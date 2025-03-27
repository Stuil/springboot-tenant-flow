package com.ginyon.test.domain;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ginyon.common.core.domain.BaseEntity;
import com.ginyon.excel.poi.annotation.Excel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * 子对象 test_sub
 *
 * @author zwh
 * @date 2023-10-26
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName(value = "test_sub")
public class TestSub extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @TableId
    private Long id;

    /** 事务所id */
    @Excel(name = "事务所id")
    private Long legalId;

    /** 律师名称 */
    @Excel(name = "律师名称")
    private String lawyerName;

    /** 联系电话 */
    @Excel(name = "联系电话")
    private Long phone;

    /** 简介 */
    @Excel(name = "简介")
    private String briefIntroduction;

    /** 删除标志（0代表存在 2代表删除） */
    @Excel(name = "删除标志", readConverterExp = "0=代表存在,2=代表删除")
    @TableLogic
    private String delFlag;

}
