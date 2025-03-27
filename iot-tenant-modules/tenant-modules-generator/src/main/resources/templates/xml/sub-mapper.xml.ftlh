<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${packageName}.mapper.${subClassName}Mapper">

    <resultMap type="${subClassName}" id="${subClassName}Result">
<#list subTable.columns as column>
        <result property="${column.javaField}"    column="${column.columnName}"    />
</#list>
    </resultMap>

    <sql id="selectVo">
        select<#list subTable.columns as column> t.${column.columnName}<#if column_index + 1 != columns?size>,</#if></#list> from ${subTableName} t
    </sql>

</mapper>
