package com.ginyon.test.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.mybatis.service.impl.BaseServiceImpl;
import com.ginyon.mybatis.utils.PageUtils;
import com.ginyon.test.domain.TestMater;
import com.ginyon.test.domain.TestSub;
import com.ginyon.test.mapper.TestMaterMapper;
import com.ginyon.test.service.ITestMaterService;
import com.ginyon.test.service.ITestSubService;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

/**
 * 主子演示Service业务层处理
 *
 * @author zwh
 * @date 2023-10-26
 */
@Component
public class TestMaterServiceImpl extends BaseServiceImpl<TestMaterMapper, TestMater> implements ITestMaterService {

    @Resource
    private TestMaterMapper testMaterMapper;


    @Resource
    private ITestSubService testSubService;


    @Override
    public TestMater selectById(Long id) {
        TestMater testMater = testMaterMapper.selectById(id);
        List<TestSub> subDoList = testSubService.list(Wrappers.lambdaQuery(TestSub.class)
            .eq(TestSub::getLegalId, testMater.getId()));
        testMater.setTestSubList(subDoList);
        return testMater;

    }

    @Override
    public TableDataInfo<TestMater> selectPage(QueryParam queryParam, TestMater testMater) {
        LambdaQueryWrapper<TestMater> qw = buildQuery(testMater);
        Page<TestMater> page = testMaterMapper.selectPage(queryParam.getPage(), qw);
        if (CollUtil.isEmpty(page.getRecords())) {
            page.setRecords(Collections.emptyList());
        }
        return PageUtils.build(page);
    }

    @Override
    public List<TestMater> selectList(TestMater testMater) {
        List<TestMater> testMaters = testMaterMapper.selectList(buildQuery(testMater));
        if (CollUtil.isEmpty(testMaters)) {
            return Collections.emptyList();
        }
        return testMaters;
    }

    public LambdaQueryWrapper<TestMater> buildQuery(TestMater testMater) {
        Map<String, Object> params = testMater.getParams();
        return Wrappers.lambdaQuery(TestMater.class)
                .like(StringUtils.isNotBlank(testMater.getLawFirmName()), TestMater::getLawFirmName, testMater.getLawFirmName())
                .eq(StringUtils.isNotBlank(testMater.getAddress()), TestMater::getAddress, testMater.getAddress())
                .eq(StringUtils.isNotBlank(testMater.getFileId()), TestMater::getFileId, testMater.getFileId())
                .eq(testMater.getState() != null, TestMater::getState, testMater.getState())
                .between(!ObjectUtil.hasNull(params.get("beginPublishTime"), params.get("endPublishTime")),
                    TestMater::getPublishTime, params.get("beginPublishTime"), params.get("endPublishTime"))
                .orderByDesc(TestMater::getCreateTime);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean insert(TestMater testMater) {
        int rows = testMaterMapper.insert(testMater);
        insertTestSub(testMater);
        return rows > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean update(TestMater testMater) {
        testSubService.remove(Wrappers.lambdaQuery(TestSub.class).eq(TestSub::getLegalId, testMater.getId()));
        insertTestSub(testMater);
        return testMaterMapper.updateById(testMater) > 0;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean deleteByIds(Long[] ids) {
        List<Long> idList = Arrays.asList(ids);
        testSubService.remove(Wrappers.lambdaQuery(TestSub.class).in(TestSub::getLegalId, idList));
        return testMaterMapper.deleteBatchIds(idList) > 0;
    }


    private void insertTestSub(TestMater testMater) {
        List<TestSub> subList = testMater.getTestSubList();
        Long id = testMater.getId();
        if (CollUtil.isNotEmpty(subList)) {
            subList.forEach(sub -> {
                sub.setLegalId(id);
                sub.setId(null);
            });
            testSubService.saveBatch(subList);
        }
    }
}
