<#--判断长度是否大于0并且不等于0-->
<#function stringLength length>
    <#assign columnTypeB = length?default("")?trim>
    <#if columnTypeB?length gt 0 && columnTypeB != "0">
        <#return true>
    <#else>
        <#return false>
    </#if>
</#function>
<#-- 判断是否一下几个类型-->
<#function wrap htmlType>
    <#if htmlType == "imageUpload" || htmlType == "fileUpload"
    || htmlType == "editor" || htmlType == "textarea">
        <#return true>
    <#else>
        <#return false>
    </#if>
</#function>
