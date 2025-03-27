package com.ginyon.test.service.impl;

import cn.hutool.core.collection.CollUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.mybatis.service.impl.BaseServiceImpl;
import com.ginyon.mybatis.utils.PageUtils;
import com.ginyon.test.domain.TestCommon;
import com.ginyon.test.mapper.TestCommonMapper;
import com.ginyon.test.service.ITestCommonService;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * 常规演示Service业务层处理
 *
 * @author zwh
 * @date 2023-10-26
 */
@Component
public class TestCommonServiceImpl extends BaseServiceImpl<TestCommonMapper, TestCommon> implements ITestCommonService {

    @Resource
    private TestCommonMapper testCommonMapper;



    @Override
    public TestCommon selectById(Long id) {
        return testCommonMapper.selectById(id);

    }

    @Override
    public TableDataInfo<TestCommon> selectPage(QueryParam queryParam, TestCommon testCommon) {
        LambdaQueryWrapper<TestCommon> qw = buildQuery(testCommon);
        Page<TestCommon> page = testCommonMapper.selectPage(queryParam.getPage(), qw);
        if (CollUtil.isEmpty(page.getRecords())) {
            page.setRecords(Collections.emptyList());
        }
        return PageUtils.build(page);
    }

    @Override
    public List<TestCommon> selectList(TestCommon testCommon) {
        List<TestCommon> testCommons = testCommonMapper.selectList(buildQuery(testCommon));
        if (CollUtil.isEmpty(testCommons)) {
            return Collections.emptyList();
        }
        return testCommons;
    }

    public LambdaQueryWrapper<TestCommon> buildQuery(TestCommon testCommon) {
        return Wrappers.lambdaQuery(TestCommon.class)
                .eq(StringUtils.isNotBlank(testCommon.getTitle()), TestCommon::getTitle, testCommon.getTitle())
                .eq(testCommon.getLevel() != null, TestCommon::getLevel, testCommon.getLevel())
                .eq(StringUtils.isNotBlank(testCommon.getSendDocNo()), TestCommon::getSendDocNo, testCommon.getSendDocNo())
                .eq(StringUtils.isNotBlank(testCommon.getSendDocUnit()), TestCommon::getSendDocUnit, testCommon.getSendDocUnit())
                .eq(testCommon.getPublishTime() != null, TestCommon::getPublishTime, testCommon.getPublishTime())
                .eq(testCommon.getDeadline() != null, TestCommon::getDeadline, testCommon.getDeadline())
                .eq(StringUtils.isNotBlank(testCommon.getLabel()), TestCommon::getLabel, testCommon.getLabel())
                .eq(StringUtils.isNotBlank(testCommon.getContent()), TestCommon::getContent, testCommon.getContent())
                .eq(testCommon.getMoney() != null, TestCommon::getMoney, testCommon.getMoney())
                .eq(testCommon.getViews() != null, TestCommon::getViews, testCommon.getViews())
                .eq(StringUtils.isNotBlank(testCommon.getNewFileId()), TestCommon::getNewFileId, testCommon.getNewFileId())
                .eq(StringUtils.isNotBlank(testCommon.getImageId()), TestCommon::getImageId, testCommon.getImageId())
                .orderByDesc(TestCommon::getCreateTime);
    }

    @Override
    public boolean insert(TestCommon testCommon) {
        return testCommonMapper.insert(testCommon) > 0;
    }

    @Override
    public boolean update(TestCommon testCommon) {
        return testCommonMapper.updateById(testCommon) > 0;
    }

    @Override
    public boolean deleteByIds(Long[] ids) {
        return testCommonMapper.deleteBatchIds(Arrays.asList(ids)) > 0;
    }


}
