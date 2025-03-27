<#import "/templates/function/format.ftlh" as format>
<#--时间编辑-->
<#macro date params columnType comment javaField>
    <#if columnType == 'datetime'>
              <el-date-picker
                 clearable size="small"
                 v-model="${params}.${javaField}"
                 type="datetime"
                 value-format="${format.dateFormat(columnType)}"
                 placeholder="选择${comment}">
              </el-date-picker>
    <#else >
              <el-date-picker
                 clearable size="small"
                 v-model="${params}.${javaField}"
                 type="date"
                 value-format="${format.dateFormat(columnType)}"
                 placeholder="选择${comment}">
              </el-date-picker>
    </#if>
</#macro>
<#--时间区间编辑-->
<#macro dateRange AttrName columnType>
    <#if columnType == 'datetime'>
        <el-date-picker
           v-model="daterange${AttrName}"
           size="small"
           value-format="${format.dateFormat(columnType)}"
           type="datetimerange"
           range-separator="-"
           start-placeholder="开始日期"
           end-placeholder="结束日期"
        ></el-date-picker>
    <#else >
        <el-date-picker
           v-model="daterange${AttrName}"
           size="small"
           style="width: 240px"
           value-format="${format.dateFormat(columnType)}"
           type="daterange"
           range-separator="-"
           start-placeholder="开始日期"
           end-placeholder="结束日期"
        ></el-date-picker>
    </#if>
</#macro>

<#macro dateColumn columnType comment javaField>
    <#if columnType == 'datetime'>
        <el-table-column label="${comment}" align="center" prop="${javaField}" width="160" :show-overflow-tooltip="true">
            <template slot-scope="scope">
                <span>{{ parseTime(scope.row.${javaField}) }}</span>
            </template>
        </el-table-column>
    <#else >
        <el-table-column label="${comment}" align="center" prop="${javaField}" width="100" :show-overflow-tooltip="true">
            <template slot-scope="scope">
                <span>{{ parseTime(scope.row.${javaField}, '{y}-{m}-{d}') }}</span>
            </template>
        </el-table-column>
    </#if>
</#macro>
