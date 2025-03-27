package com.ginyon.test.service;

import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.mybatis.service.IBaseService;
import com.ginyon.test.domain.TestCommon;

import java.util.List;

/**
 * 常规演示Service接口
 *
 * @author zwh
 */
public interface ITestCommonService extends IBaseService<TestCommon> {
    /**
     * 查询常规演示
     *
     * @param id 常规演示主键
     * @return 常规演示
     */
    public TestCommon selectById(Long id);

    /**
     * 分页查询常规演示列表
     *
     * @param queryParam 分页对象
     * @param testCommon 常规演示
     * @return 分页对象
     */
    TableDataInfo<TestCommon> selectPage(QueryParam queryParam, TestCommon testCommon);

    /**
     * 查询常规演示列表
     *
     * @param testCommon 常规演示
     * @return 常规演示集合
     */
    public List<TestCommon> selectList(TestCommon testCommon);

    /**
     * 新增常规演示
     *
     * @param testCommon 常规演示
     * @return 结果
     */
    public boolean insert(TestCommon testCommon);

    /**
     * 修改常规演示
     *
     * @param testCommon 常规演示
     * @return 结果
     */
    public boolean update(TestCommon testCommon);

    /**
     * 批量删除常规演示
     *
     * @param ids 需要删除的常规演示主键集合
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
