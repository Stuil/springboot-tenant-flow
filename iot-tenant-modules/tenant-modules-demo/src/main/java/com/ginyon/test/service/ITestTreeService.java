package com.ginyon.test.service;

import com.ginyon.mybatis.service.IBaseService;
import com.ginyon.test.domain.TestTree;

import java.util.List;

/**
 * 测试树Service接口
 *
 * @author zwh
 */
public interface ITestTreeService extends IBaseService<TestTree> {
    /**
     * 查询测试树
     *
     * @param id 测试树主键
     * @return 测试树
     */
    public TestTree selectById(Long id);


    /**
     * 查询测试树列表
     *
     * @param testTree 测试树
     * @return 测试树集合
     */
    public List<TestTree> selectList(TestTree testTree);

    /**
     * 新增测试树
     *
     * @param testTree 测试树
     * @return 结果
     */
    public boolean insert(TestTree testTree);

    /**
     * 修改测试树
     *
     * @param testTree 测试树
     * @return 结果
     */
    public boolean update(TestTree testTree);

    /**
     * 批量删除测试树
     *
     * @param ids 需要删除的测试树主键集合
     * @return 结果
     */
    public boolean deleteByIds(Long[] ids);

	/**
     * 提交审批
     *
     * @param id
     * @return
     */

}
