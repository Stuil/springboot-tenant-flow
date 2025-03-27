package com.ginyon.test.domain;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ginyon.common.core.domain.BaseEntity;
import com.ginyon.excel.poi.annotation.Excel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.Size;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 常规演示对象 test_common
 *
 * @author zwh
 * @date 2023-10-26
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName(value = "test_common")
public class TestCommon extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @TableId
    private Long id;

    /** 删除标志（0代表存在 2代表删除） */
    @Excel(name = "删除标志", readConverterExp = "0=代表存在,2=代表删除")
    @Size(max = 1, message = "删除标志（0代表存在 2代表删除）长度不能超过1")
    @TableLogic
    private String delFlag;

    /** 标题 */
    @Excel(name = "标题")
    @Size(max = 64, message = "标题长度不能超过64")
    private String title;

    /** 级别（取数据字典） */
    @Excel(name = "级别", readConverterExp = "取=数据字典")
    private Long level;

    /** 发文字号 */
    @Excel(name = "发文字号")
    @Size(max = 64, message = "发文字号长度不能超过64")
    private String sendDocNo;

    /** 发文单位 */
    @Excel(name = "发文单位")
    @Size(max = 64, message = "发文单位长度不能超过64")
    private String sendDocUnit;

    /** 发布时间 */
    @Excel(name = "发布时间", width = 30, dateFormat = "yyyy-MM-dd")
    @JsonFormat(pattern = "yyyy-MM-dd")
    private Date publishTime;

    /** 截至日期 */
    @Excel(name = "截至日期", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date deadline;

    /** 标签 */
    @Excel(name = "标签")
    private String label;

    /** 文章内容 */
    @Excel(name = "文章内容")
    private String content;

    /** 金额 */
    @Excel(name = "金额")
    private BigDecimal money;

    /** 阅读次数 */
    @Excel(name = "阅读次数")
    private Long views;

    /** 附件 */
    @Excel(name = "附件")
    @Size(max = 200, message = "附件长度不能超过200")
    private String newFileId;

    /** 图片 */
    @Excel(name = "图片")
    @Size(max = 200, message = "图片长度不能超过200")
    private String imageId;

}
