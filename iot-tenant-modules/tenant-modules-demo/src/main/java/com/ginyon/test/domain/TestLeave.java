package com.ginyon.test.domain;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.ginyon.common.core.domain.BaseEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import java.util.Date;

/**
 * OA 请假申请对象 test_leave
 *
 * @author zwh
 * @date 2023-10-26
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName(value = "test_leave")
public class TestLeave extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @TableId
    private Long id;

    /** 请假类型 */
    @NotNull(message = "请假类型不能为空")
    private Integer type;

    /** 请假原因 */
    @NotBlank(message = "请假原因不能为空")
    @Size(max = 200, message = "请假原因长度不能超过200")
    private String reason;

    /** 开始时间 */
    @NotNull(message = "开始时间不能为空")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date startTime;

    /** 结束时间 */
    @NotNull(message = "结束时间不能为空")
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date endTime;

    /** 请假天数 */
    @NotNull(message = "请假天数不能为空")
    private Integer day;

    /** 流程实例的id */
    private Long instanceId;

    /** 节点编码 */
    @Size(max = 100, message = "节点编码长度不能超过100")
    private String nodeCode;

    /** 流程节点名称 */
    @Size(max = 100, message = "流程节点名称长度不能超过100")
    private String nodeName;

    /** 流程状态（0待提交 1审批中 2 审批通过 8已完成 9已驳回 10失效） */
    private Integer flowStatus;

    /** 删除标志（0代表存在 2代表删除） */
    @Size(max = 1, message = "删除标志（0代表存在 2代表删除）长度不能超过1")
    @TableLogic
    private String delFlag;

}
