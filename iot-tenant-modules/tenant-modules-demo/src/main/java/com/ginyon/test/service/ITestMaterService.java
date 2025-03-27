package com.ginyon.test.service;

import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.mybatis.service.IBaseService;
import com.ginyon.test.domain.TestMater;

import java.util.List;

/**
 * 主子演示Service接口
 *
 * @author zwh
 */
public interface ITestMaterService extends IBaseService<TestMater> {
    /**
     * 查询主子演示
     *
     * @param id 主子演示主键
     * @return 主子演示
     */
    public TestMater selectById(Long id);

    /**
     * 分页查询主子演示列表
     *
     * @param queryParam 分页对象
     * @param testMater 主子演示
     * @return 分页对象
     */
    TableDataInfo<TestMater> selectPage(QueryParam queryParam, TestMater testMater);

    /**
     * 查询主子演示列表
     *
     * @param testMater 主子演示
     * @return 主子演示集合
     */
    public List<TestMater> selectList(TestMater testMater);

    /**
     * 新增主子演示
     *
     * @param testMater 主子演示
     * @return 结果
     */
    public boolean insert(TestMater testMater);

    /**
     * 修改主子演示
     *
     * @param testMater 主子演示
     * @return 结果
     */
    public boolean update(TestMater testMater);

    /**
     * 批量删除主子演示
     *
     * @param ids 需要删除的主子演示主键集合
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
