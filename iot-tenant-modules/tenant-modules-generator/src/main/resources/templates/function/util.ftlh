<#function queryWay queryType>
    <#if queryType == "EQ">
        <#return  'eq'>
    <#elseIf queryType == "NE">
        <#return  'ne'>
    <#elseIf queryType == "GT">
        <#return  'gt'>
    <#elseIf queryType == "GTE">
        <#return  'ge'>
    <#elseIf queryType == "LT">
        <#return  'lt'>
    <#elseIf queryType == "LTE">
        <#return  'le'>
    <#elseIf queryType == "LIKE">
        <#return  'like'>
    </#if>
</#function>
