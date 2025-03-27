package com.ginyon.system.service;

import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.mybatis.service.IBaseService;
import com.ginyon.system.api.domain.SysTenant;

import java.util.List;

/**
 * 租户Service接口
 *
 * @author zwh
 */
public interface ISysTenantService extends IBaseService<SysTenant> {
    /**
     * 查询租户
     *
     * @param id 租户主键
     * @return 租户
     */
    public SysTenant selectById(Long id);

    /**
     * 基于租户ID查询租户
     */
    SysTenant queryByTenantId(String tenantId);

    /**
     * 分页查询租户列表
     *
     * @param queryParam 分页对象
     * @param sysTenant 租户
     * @return 分页对象
     */
    TableDataInfo<SysTenant> selectPage(QueryParam queryParam, SysTenant sysTenant);

    /**
     * 查询租户列表
     *
     * @param sysTenant 租户
     * @return 租户集合
     */
    public List<SysTenant> selectList(SysTenant sysTenant);

    /**
     * 新增租户
     *
     * @param sysTenant 租户
     * @return 结果
     */
    public boolean insert(SysTenant sysTenant);

    /**
     * 修改租户
     *
     * @param sysTenant 租户
     * @return 结果
     */
    public boolean update(SysTenant sysTenant);

    /**
     * 批量删除租户
     *
     * @param ids 需要删除的租户主键集合
     * @return 结果
     */
    public boolean deleteByIds(Long[] ids);

    /**
     * 校验租户是否允许操作
     *
     * @param tenantId 租户ID
     */
    void checkTenantAllowed(String tenantId);

    /**
     * 校验企业名称是否唯一
     */
    boolean checkCompanyNameUnique(SysTenant sysTenant);

    /**
     * 校验账号余额
     */
    boolean checkAccountBalance(String tenantId);

    /**
     * 校验有效期
     */
    boolean checkExpireTime(String tenantId);

    /**
     * 同步租户套餐
     */
    Boolean syncTenantPackage(String tenantId, Long packageId);
}
