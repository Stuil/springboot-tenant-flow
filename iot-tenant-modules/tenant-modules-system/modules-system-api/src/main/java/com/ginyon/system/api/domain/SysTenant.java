package com.ginyon.system.api.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ginyon.common.core.domain.BaseEntity;
import com.ginyon.common.validate.AddGroup;
import com.ginyon.common.validate.EditGroup;
import com.ginyon.excel.poi.annotation.Excel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.Date;

/**
 * 租户对象 sys_tenant
 *
 * @author zwh
 * @date 2023-10-27
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName(value = "sys_tenant")
public class SysTenant extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** id */
    @TableId
    @NotNull(message = "id不能为空", groups = { EditGroup.class })
    private Long id;

    /** 租户编号 */
    @Excel(name = "租户编号")
    private String tenantId;

    /** 联系人 */
    @NotBlank(message = "联系人不能为空", groups = { AddGroup.class, EditGroup.class })
    @Excel(name = "联系人")
    @Size(max = 20, message = "联系人长度不能超过20", groups = { AddGroup.class, EditGroup.class })
    private String contactUserName;

    /** 联系电话 */
    @NotBlank(message = "联系电话不能为空", groups = { AddGroup.class, EditGroup.class })
    @Excel(name = "联系电话")
    @Size(max = 20, message = "联系电话长度不能超过20", groups = { AddGroup.class, EditGroup.class })
    private String contactPhone;

    /** 企业名称 */
    @NotBlank(message = "企业名称不能为空", groups = { AddGroup.class, EditGroup.class })
    @Excel(name = "企业名称")
    @Size(max = 50, message = "企业名称长度不能超过50", groups = { AddGroup.class, EditGroup.class })
    private String companyName;

    /**
     * 用户名（创建系统用户）
     */
    @TableField(exist = false)
    @NotBlank(message = "用户名不能为空", groups = { AddGroup.class })
    private String userName;

    /**
     * 密码（创建系统用户）
     */
    @TableField(exist = false)
    @NotBlank(message = "密码不能为空", groups = { AddGroup.class })
    private String password;

    /** 统一社会信用代码 */
    @Excel(name = "统一社会信用代码")
    @Size(max = 30, message = "统一社会信用代码长度不能超过30")
    private String licenseNumber;

    /** 地址 */
    @Excel(name = "地址")
    @Size(max = 200, message = "地址长度不能超过200")
    private String address;

    /** 企业简介 */
    @Excel(name = "企业简介")
    @Size(max = 200, message = "企业简介长度不能超过200")
    private String intro;

    /** 域名 */
    @Excel(name = "域名")
    @Size(max = 200, message = "域名长度不能超过200")
    private String domain;

    /** 租户套餐编号 */
    @Excel(name = "租户套餐编号")
    @NotNull(message = "租户套餐不能为空", groups = { AddGroup.class })
    private Long packageId;

    /** 过期时间 */
    @Excel(name = "过期时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date expireTime;

    /** 用户数量（-1不限制） */
    @Excel(name = "用户数量", readConverterExp = "-=1不限制")
    private Long accountCount;

    /** 租户状态（0正常 1停用） */
    @Excel(name = "租户状态", readConverterExp = "0=正常,1=停用")
    @Size(max = 1, message = "租户状态（0正常 1停用）长度不能超过1")
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
