package com.ginyon.test.domain;

import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.annotation.Version;
import com.ginyon.common.core.domain.TreeEntity;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.Size;

/**
 * 测试树对象 test_tree
 *
 * @author zwh
 * @date 2023-10-26
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName(value = "test_tree")
public class TestTree extends TreeEntity
{
    private static final long serialVersionUID = 1L;

    @TableId
    private Long id;

    /** 值 */
    @Size(max = 255, message = "值长度不能超过255")
    private String treeName;

    /** 版本 */
    @Version
    private Long version;

    /** 删除标志 */
    @TableLogic
    private Long delFlag;

}
