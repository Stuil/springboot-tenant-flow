<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${packageName}.mapper.${ClassName}Mapper">

    <resultMap type="${ClassName}" id="${ClassName}Result">
<#list columns as column>
        <result property="${column.javaField}"    column="${column.columnName}"    />
</#list>
    </resultMap>
<#if table.sub>

    <resultMap id="${ClassName}${subClassName}Result" type="${ClassName}" extends="${ClassName}Result">
        <collection property="${subclassName}List" notNullColumn="sub_${subTable.pkColumn.columnName}" javaType="java.util.List" resultMap="${subClassName}Result" />
    </resultMap>

    <resultMap type="${subClassName}" id="${subClassName}Result">
<#list subTable.columns as column>
        <result property="${column.javaField}"    column="sub_${column.columnName}"    />
</#list>
    </resultMap>
</#if>

    <sql id="selectVo">
        select<#list columns as column> t.${column.columnName}<#if column_index + 1 != columns?size>,</#if></#list> from ${tableName} t
    </sql>
</mapper>
