package com.ginyon.test.service;

import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.mybatis.service.IBaseService;
import com.ginyon.test.domain.TestLeave;

import java.util.List;

/**
 * OA 请假申请Service接口
 *
 * @author zwh
 */
public interface ITestLeaveService extends IBaseService<TestLeave> {
    /**
     * 查询OA 请假申请
     *
     * @param id OA 请假申请主键
     * @return OA 请假申请
     */
    public TestLeave selectById(Long id);

    /**
     * 分页查询OA 请假申请列表
     *
     * @param queryParam 分页对象
     * @param testLeave OA 请假申请
     * @return 分页对象
     */
    TableDataInfo<TestLeave> selectPage(QueryParam queryParam, TestLeave testLeave);

    /**
     * 查询OA 请假申请列表
     *
     * @param testLeave OA 请假申请
     * @return OA 请假申请集合
     */
    public List<TestLeave> selectList(TestLeave testLeave);

    /**
     * 新增OA 请假申请
     *
     * @param testLeave OA 请假申请
     * @return 结果
     */
    public boolean insert(TestLeave testLeave);

    /**
     * 修改OA 请假申请
     *
     * @param testLeave OA 请假申请
     * @return 结果
     */
    public boolean update(TestLeave testLeave);

    /**
     * 批量删除OA 请假申请
     *
     * @param ids 需要删除的OA 请假申请主键集合
     * @return 结果
     */
    public boolean deleteByIds(Long[] ids);

	/**
     * 提交审批
     *
     * @param id
     * @return
     */
    public boolean submit(Long id);

	/**
     * 办理
     *
     * @param testLeave
     * @param taskId
     * @param skipType
     * @param message
     * @return
     */
    Boolean handle(TestLeave testLeave, Long taskId, String skipType, String message);

}
