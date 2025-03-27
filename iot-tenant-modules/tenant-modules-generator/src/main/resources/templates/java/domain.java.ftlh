package ${packageName}.domain;

<#list  importList as import>
import ${import};
</#list>
<#if table.exportEnable == 'Y'>
import com.hh.excel.poi.annotation.Excel;
</#if>
<#if table.swaggerEnable == 'Y'>
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
</#if>
<#if table.sub>
import com.baomidou.mybatisplus.annotation.TableField;
</#if>
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import lombok.EqualsAndHashCode;
import javax.validation.constraints.*;
<#if table.crud || table.sub>
import com.hh.common.core.domain.BaseEntity;
<#elseif table.tree>
import com.hh.common.core.domain.TreeEntity;
</#if>

/**
 * ${functionName}对象 ${tableName}
 *
 * @author ${author}
 * @date ${datetime}
 */
<#if table.crud || table.sub>
    <#assign Entity="BaseEntity">
<#elseif table.tree>
    <#assign Entity="TreeEntity">
</#if>
@Data
@EqualsAndHashCode(callSuper = true)
<#if table.swaggerEnable == 'Y'>
@ApiModel("${functionName}对象")
</#if>
@TableName(value = "${tableName}")
public class ${ClassName} extends ${Entity}
{
    private static final long serialVersionUID = 1L;

<#list columns as column>
        <#if !table.isSuperColumn(column.javaField)>
    /** ${column.columnComment} */
            <#if column.columnName != pkColumn.columnName>
                <#assign parentheseIndex = column.columnComment?index_of("（")>
                <#if parentheseIndex != -1>
                    <#assign comment = column.columnComment?substring(0, parentheseIndex)>
                <#else>
                    <#assign comment = column.columnComment>
                </#if>
                <#if column.isRequired() && table.swaggerEnable == 'Y'>
    @ApiModelProperty(value = "${column.columnComment}", required = true)
                <#elseif table.swaggerEnable == 'Y'>
    @ApiModelProperty(value = "${column.columnComment}")
                </#if>
                <#if column.isRequired()>
                    <#if column.javaType == 'String'>
    @NotBlank(message = "${column.columnComment}不能为空")
                    <#else>
    @NotNull(message = "${column.columnComment}不能为空")
                    </#if>
                </#if>
                <#if  table.exportEnable == 'Y'>
                    <#if parentheseIndex != -1>
    @Excel(name = "${comment}", readConverterExp = "${column.readConverterExp()}")
                    <#elseif column.columnType == 'date'>
    @Excel(name = "${comment}", width = 30, dateFormat = "yyyy-MM-dd")
                    <#elseif column.columnType == 'datetime'>
    @Excel(name = "${comment}", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
                    <#else>
    @Excel(name = "${comment}")
                    </#if>
                </#if>
                <#if column.columnType == 'date'>
    @JsonFormat(pattern = "yyyy-MM-dd")
                <#elseif column.columnType == 'datetime'>
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
                </#if>
                <#assign lengthTemplate = "com.hh.generator.methodmodel.LengthTemplate"?new()>
                <#assign length = lengthTemplate(column.columnType)>
                <#if column.javaType == 'String'>
                    <#if length?? && length?trim != "">
    @Size(max = ${length}, message = "${column.columnComment}长度不能超过${length}")
                    </#if>
                <#--<#assign numberTemplate = "com.hh.generator.methodmodel.NumberTemplate"?new()>
                <#elseif column.javaType == 'BigDecimal'>
                    <#assign map = numberTemplate(column.columnType)>
                    <#if map?? && (map?size>0)>
    @DecimalMin(value="0", message = "${column.columnComment}最小值不能大于${map["first"]}")
    @DecimalMax(value="${map["first"]}", message = "${column.columnComment}最大值不能超过${map["first"]}")
                    </#if>
                <#elseif column.javaType == 'Integer' || column.javaType == 'Long'>
                    <#assign map = numberTemplate(column.columnType)>
                    <#if map?? && (map?size>0)>
    @Range(Max="${map["first"]}", message = "${column.columnComment}的范围是0-${map["first"]}")
                    </#if>-->
                </#if>
                <#if column.javaField=='delFlag'>
    @TableLogic
                </#if>
                <#if column.javaField=='version'>
    @Version
                </#if>
            <#else>
    @TableId
            </#if>
    private ${column.javaType} ${column.javaField};

        </#if>
</#list>
<#if table.sub>
    /** ${table.subTable.functionName}信息 */
    @TableField(exist = false)
    private List<${subClassName}> ${subclassName}List;

</#if>
}
