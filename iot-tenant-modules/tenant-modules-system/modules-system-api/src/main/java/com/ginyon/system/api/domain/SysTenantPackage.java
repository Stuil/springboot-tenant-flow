package com.ginyon.system.api.domain;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ginyon.common.core.domain.BaseEntity;
import com.ginyon.excel.poi.annotation.Excel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.Size;

/**
 * 租户套餐对象 sys_tenant_package
 *
 * @author zwh
 * @date 2023-10-26
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName(value = "sys_tenant_package")
public class SysTenantPackage extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** 租户套餐id */
    @TableId
    private Long packageId;

    /** 套餐名称 */
    @Excel(name = "套餐名称")
    @Size(max = 20, message = "套餐名称长度不能超过20")
    private String packageName;

    /** 关联菜单id */
    @Excel(name = "关联菜单id")
    @Size(max = 3000, message = "关联菜单id长度不能超过3000")
    private String menuIds;

    /** 菜单树选择项是否关联显示 */
    @Excel(name = "菜单树选择项是否关联显示", readConverterExp = "0=父子不互相关联显示,1=父子互相关联显示")
    private Boolean menuCheckStrictly;

    /** 状态（0正常 1停用） */
    @Excel(name = "状态", readConverterExp = "0=正常,1=停用")
    @Size(max = 1, message = "状态（0正常 1停用）长度不能超过1")
    private String status;

    /** 备注 */
    @Excel(name = "备注")
    @Size(max = 200, message = "备注长度不能超过200")
    private String remark;

    /** 删除标志（0代表存在 2代表删除） */
    @Excel(name = "删除标志", readConverterExp = "0=代表存在,2=代表删除")
    @Size(max = 1, message = "删除标志（0代表存在 2代表删除）长度不能超过1")
    @TableLogic
    private String delFlag;

}
