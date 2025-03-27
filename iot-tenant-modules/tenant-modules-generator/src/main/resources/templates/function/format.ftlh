<#function dateFormat columnType>
    <#if columnType == 'datetime'>
        <#return 'yyyy-MM-dd HH:mm:ss'>
    <#else>
        <#return 'yyyy-MM-dd'>
    </#if>
</#function>
