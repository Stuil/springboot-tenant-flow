package ${packageName}.domain;

<#list subImportList as import>
import ${import};
</#list>
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import com.hh.common.core.domain.BaseEntity;
import com.hh.excel.poi.annotation.Excel;
import lombok.Data;
import lombok.EqualsAndHashCode;

/**
 * ${subTable.functionName}对象 ${subTableName}
 *
 * @author ${author}
 * @date ${datetime}
 */
@Data
@EqualsAndHashCode(callSuper = true)
@TableName(value = "${subTableName}")
public class ${subClassName} extends BaseEntity
{
    private static final long serialVersionUID = 1L;

<#list subTable.columns as column>
        <#if !table.isSuperColumn(column.javaField)>
    /** ${column.columnComment} */
            <#if column.columnName != pkColumn.columnName>
                <#assign parentheseIndex = column.columnComment?indexOf("（")>
                <#if parentheseIndex != -1>
                    <#assign comment = column.columnComment?substring(0, parentheseIndex)>
                <#else>
                    <#assign comment = column.columnComment>
                </#if>
                <#if parentheseIndex != -1>
    @Excel(name = "${comment}", readConverterExp = "${column.readConverterExp()}")
                <#elseIf column.javaType == 'Date'>
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "${comment}", width = 30, dateFormat = "yyyy-MM-dd")
                <#else>
    @Excel(name = "${comment}")
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
}
