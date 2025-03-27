package com.ginyon.test.domain;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ginyon.common.core.domain.BaseEntity;
import com.ginyon.excel.poi.annotation.Excel;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.Size;
import java.util.Date;
import java.util.List;

/**
 * 主子演示对象 test_mater
 *
 * @author zwh
 * @date 2023-10-26
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName(value = "test_mater")
public class TestMater extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @TableId
    private Long id;

    /** 律师所名称 */
    @Excel(name = "律师所名称")
    @Size(max = 30, message = "律师所名称长度不能超过30")
    private String lawFirmName;

    /** 地址 */
    @Excel(name = "地址")
    @Size(max = 255, message = "地址长度不能超过255")
    private String address;

    /** logo图片id */
    @Excel(name = "logo图片id")
    @Size(max = 255, message = "logo图片id长度不能超过255")
    private String fileId;

    /** 删除标志（0代表存在 2代表删除） */
    @Excel(name = "删除标志", readConverterExp = "0=代表存在,2=代表删除")
    @Size(max = 1, message = "删除标志（0代表存在 2代表删除）长度不能超过1")
    @TableLogic
    private String delFlag;

    /** 状态 */
    @Excel(name = "状态")
    private Integer state;

    /** 发布时间 */
    @Excel(name = "发布时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date publishTime;

    /** 子信息 */
    @TableField(exist = false)
    private List<TestSub> testSubList;

}
