package com.ginyon.system.service;

import com.ginyon.system.api.domain.SysTenantPackage;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.mybatis.service.IBaseService;

import java.util.List;

/**
 * 租户套餐Service接口
 *
 * @author zwh
 */
public interface ISysTenantPackageService extends IBaseService<SysTenantPackage> {
    /**
     * 查询租户套餐
     *
     * @param packageId 租户套餐主键
     * @return 租户套餐
     */
    public SysTenantPackage selectById(Long packageId);

    /**
     * 分页查询租户套餐列表
     *
     * @param queryParam 分页对象
     * @param sysTenantPackage 租户套餐
     * @return 分页对象
     */
    TableDataInfo<SysTenantPackage> selectPage(QueryParam queryParam, SysTenantPackage sysTenantPackage);

    /**
     * 查询租户套餐已启用列表
     */
    List<SysTenantPackage> selectList();

    /**
     * 查询租户套餐列表
     *
     * @param sysTenantPackage 租户套餐
     * @return 租户套餐集合
     */
    public List<SysTenantPackage> selectList(SysTenantPackage sysTenantPackage);

    /**
     * 新增租户套餐
     *
     * @param sysTenantPackage 租户套餐
     * @return 结果
     */
    public boolean insert(SysTenantPackage sysTenantPackage);

    /**
     * 修改租户套餐
     *
     * @param sysTenantPackage 租户套餐
     * @return 结果
     */
    public boolean update(SysTenantPackage sysTenantPackage);

    /**
     * 批量删除租户套餐
     *
     * @param packageIds 需要删除的租户套餐主键集合
     * @return 结果
     */
    public boolean deleteByIds(Long[] packageIds);

	/**
     * 提交审批
     *
     * @param id
     * @return
     */

}
