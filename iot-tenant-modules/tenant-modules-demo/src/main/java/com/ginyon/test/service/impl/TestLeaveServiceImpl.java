package com.ginyon.test.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.common.utils.uuid.IdUtils;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.mybatis.service.impl.BaseServiceImpl;
import com.ginyon.mybatis.utils.PageUtils;
import com.ginyon.satoken.helper.LoginHelper;
import com.ginyon.system.api.domain.SysRole;
import com.ginyon.system.api.model.LoginUser;
import com.ginyon.tenant.helper.TenantHelper;
import com.ginyon.test.domain.TestLeave;
import com.ginyon.test.enums.FlowType;
import com.ginyon.test.mapper.TestLeaveMapper;
import com.ginyon.test.service.ITestLeaveService;
import com.warm.flow.core.dto.FlowParams;
import com.warm.flow.core.entity.Instance;
import com.warm.flow.core.enums.SkipType;
import com.warm.flow.core.service.InsService;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;
import java.util.stream.Collectors;

/**
 * OA 请假申请Service业务层处理
 *
 * @author zwh
 * @date 2023-10-26
 */
@Component
public class TestLeaveServiceImpl extends BaseServiceImpl<TestLeaveMapper, TestLeave> implements ITestLeaveService {

    @Resource
    private TestLeaveMapper testLeaveMapper;

    @Resource
    private InsService insService;


    @Override
    public TestLeave selectById(Long id) {
        return testLeaveMapper.selectById(id);

    }

    @Override
    public TableDataInfo<TestLeave> selectPage(QueryParam queryParam, TestLeave testLeave) {
        LambdaQueryWrapper<TestLeave> qw = buildQuery(testLeave);
        Page<TestLeave> page = testLeaveMapper.selectPage(queryParam.getPage(), qw);
        if (CollUtil.isEmpty(page.getRecords())) {
            page.setRecords(Collections.emptyList());
        }
        return PageUtils.build(page);
    }

    @Override
    public List<TestLeave> selectList(TestLeave testLeave) {
        List<TestLeave> testLeaves = testLeaveMapper.selectList(buildQuery(testLeave));
        if (CollUtil.isEmpty(testLeaves)) {
            return Collections.emptyList();
        }
        return testLeaves;
    }

    public LambdaQueryWrapper<TestLeave> buildQuery(TestLeave testLeave) {
        Map<String, Object> params = testLeave.getParams();
        return Wrappers.lambdaQuery(TestLeave.class)
                .eq(testLeave.getType() != null, TestLeave::getType, testLeave.getType())
                .eq(testLeave.getDay() != null, TestLeave::getDay, testLeave.getDay())
                .eq(testLeave.getFlowStatus() != null, TestLeave::getFlowStatus, testLeave.getFlowStatus())
                .eq(StringUtils.isNotBlank(testLeave.getCreateBy()), TestLeave::getCreateBy, testLeave.getCreateBy())
                .between(!ObjectUtil.hasNull(params.get("beginCreateTime"), params.get("endCreateTime")),
                    TestLeave::getCreateTime, params.get("beginCreateTime"), params.get("endCreateTime"))
                .orderByDesc(TestLeave::getCreateTime);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean insert(TestLeave testLeave) {
        FlowType testLeaveSerial = getFlowType(testLeave);
        Long id = IdUtils.snowflakeId();
        LoginUser user = LoginHelper.get();
        FlowParams flowParams = FlowParams.build().flowCode(testLeaveSerial.getKey())
                .createBy(user.getUser().getUserId().toString())
                .nickName(user.getUser().getNickName())
                .tenantId(TenantHelper.getTenantId());
        Instance instance = insService.start(String.valueOf(id), flowParams);
        testLeave.setId(id);
        testLeave.setInstanceId(instance.getId());
        testLeave.setNodeCode(instance.getNodeCode());
        testLeave.setNodeName(instance.getNodeName());
        testLeave.setFlowStatus(instance.getFlowStatus());
        return save(testLeave);
    }

    @Override
    public boolean update(TestLeave testLeave) {
        return testLeaveMapper.updateById(testLeave) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteByIds(Long[] ids) {
        List<TestLeave> testLeaveList = listByIds(Arrays.asList(ids));
        if (removeByIds(Arrays.asList(ids))) {
            List<Long> instanceIds = testLeaveList.stream().map(TestLeave::getInstanceId).collect(Collectors.toList());
            return insService.remove(instanceIds);
        }
        return false;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean submit(Long id) {
        TestLeave testLeave = getById(id);
        LoginUser user = LoginHelper.get();
        FlowParams flowParams = FlowParams.build().createBy(user.getUser().getUserId().toString())
                .nickName(user.getUser().getNickName())
                .skipType(SkipType.PASS.getKey());
        List<SysRole> roles = user.getUser().getRoles();
        if (Objects.nonNull(roles)) {
            List<String> roleList = roles.stream().map(role -> "role:" + role.getRoleId()).collect(Collectors.toList());
            flowParams.permissionFlag(roleList);
        }
        Instance instance = insService.skipByInsId(testLeave.getInstanceId(), flowParams);
        testLeave.setNodeCode(instance.getNodeCode());
        testLeave.setNodeName(instance.getNodeName());
        testLeave.setFlowStatus(instance.getFlowStatus());
        return updateById(testLeave);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean handle(TestLeave testLeave, Long taskId, String skipType, String message) {
        // 设置流转参数
        LoginUser user = LoginHelper.get();
        FlowParams flowParams = FlowParams.build().createBy(user.getUser().getUserId().toString())
                .nickName(user.getUser().getNickName())
                .skipType(skipType)
                .message(message);
        List<SysRole> roles = user.getUser().getRoles();
        if (Objects.nonNull(roles)) {
            List<String> roleList = roles.stream().map(role -> "role:" + role.getRoleId()).collect(Collectors.toList());
            flowParams.permissionFlag(roleList);
        }

        // 互斥流程
        if (testLeave.getType() == 1 || testLeave.getType() == 4) {
            Map<String, String> variable = new HashMap<>();
            // 如果是组长审批节点 需要判断请假时间确定跳转策略
            variable.put("flag", String.valueOf(testLeave.getDay()));
            flowParams.skipCondition(variable);
        }

        Instance instance = insService.skip(taskId, flowParams);
        testLeave.setNodeCode(instance.getNodeCode());
        testLeave.setNodeName(instance.getNodeName());
        testLeave.setFlowStatus(instance.getFlowStatus());
        updateById(testLeave);
        return true;
    }

    private static FlowType getFlowType(TestLeave testLeave) {
        FlowType testLeaveSerial = FlowType.TEST_LEAVE_SERIAL1;
        if (testLeave.getType() == 1) {
            testLeaveSerial = FlowType.TEST_LEAVE_SERIAL2;
        } else if (testLeave.getType() == 2) {
            testLeaveSerial = FlowType.TEST_LEAVE_PARALLEL1;
        } else if (testLeave.getType() == 3) {
            testLeaveSerial = FlowType.TEST_LEAVE_PARALLEL2;
        } else if (testLeave.getType() == 4) {
            testLeaveSerial = FlowType.TEST_LEAVE_SERIAL3;
        }
        return testLeaveSerial;
    }
}
