package com.ginyon.test.service.impl;

import cn.hutool.core.collection.CollUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.mybatis.service.impl.BaseServiceImpl;
import com.ginyon.test.domain.TestTree;
import com.ginyon.test.mapper.TestTreeMapper;
import com.ginyon.test.service.ITestTreeService;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * 测试树Service业务层处理
 *
 * @author zwh
 * @date 2023-10-26
 */
@Component
public class TestTreeServiceImpl extends BaseServiceImpl<TestTreeMapper, TestTree> implements ITestTreeService {

    @Resource
    private TestTreeMapper testTreeMapper;



    @Override
    public TestTree selectById(Long id) {
        return testTreeMapper.selectById(id);

    }


    @Override
    public List<TestTree> selectList(TestTree testTree) {
        List<TestTree> testTrees = testTreeMapper.selectList(buildQuery(testTree));
        if (CollUtil.isEmpty(testTrees)) {
            return Collections.emptyList();
        }
        return testTrees;
    }

    public LambdaQueryWrapper<TestTree> buildQuery(TestTree testTree) {
        return Wrappers.lambdaQuery(TestTree.class)
                .eq(testTree.getParentId() != null, TestTree::getParentId, testTree.getParentId())
                .like(StringUtils.isNotBlank(testTree.getTreeName()), TestTree::getTreeName, testTree.getTreeName())
                .eq(testTree.getVersion() != null, TestTree::getVersion, testTree.getVersion())
                .orderByDesc(TestTree::getCreateTime);
    }

    @Override
    public boolean insert(TestTree testTree) {
        return testTreeMapper.insert(testTree) > 0;
    }

    @Override
    public boolean update(TestTree testTree) {
        return testTreeMapper.updateById(testTree) > 0;
    }

    @Override
    public boolean deleteByIds(Long[] ids) {
        return testTreeMapper.deleteBatchIds(Arrays.asList(ids)) > 0;
    }


}
