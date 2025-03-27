<#import "/templates/macro/util.ftlh" as util>
<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="100px">
<#list columns as column>
    <#if column.query>
        <#assign dictType = column.dictType>
        <#assign AttrName = column.javaField?substring(0,1)?upperCase + column.javaField?substring(1)>
        <#assign parentheseIndex = column.columnComment?indexOf("（")>
        <#if parentheseIndex != -1>
            <#assign comment = column.columnComment?substring(0, parentheseIndex)>
        <#else>
            <#assign comment = column.columnComment>
        </#if>
        <#if column.htmlType == "input">
      <el-form-item label="${comment}" prop="${column.javaField}">
        <el-input
          v-model="queryParams.${column.javaField}"
          placeholder="请输入${comment}"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
        <#elseIf (column.htmlType == "select" || column.htmlType == "radio") && "" != dictType>
      <el-form-item label="${comment}" prop="${column.javaField}">
        <el-select v-model="queryParams.${column.javaField}" placeholder="请选择${comment}" clearable>
          <el-option
            v-for="dict in dict.type.${dictType}"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
        <#elseIf (column.htmlType == "select" || column.htmlType == "radio") && dictType>
      <el-form-item label="${comment}" prop="${column.javaField}">
        <el-select v-model="queryParams.${column.javaField}" placeholder="请选择${comment}" clearable>
          <el-option label="请选择字典生成" value="" />
        </el-select>
      </el-form-item>
        <#elseIf column.htmlType == "datetime" && column.queryType != "BETWEEN">
      <el-form-item label="${comment}" prop="${column.javaField}">
        <@util.date "queryParams" column.columnType comment column.javaField/>
      </el-form-item>
        <#elseIf column.htmlType == "datetime" && column.queryType == "BETWEEN">
      <el-form-item label="${comment}">
        <@util.dateRange AttrName column.columnType/>
      </el-form-item>
        </#if>
    </#if>
</#list>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['${moduleName}:${businessName}:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['${moduleName}:${businessName}:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['${moduleName}:${businessName}:remove']"
        >删除</el-button>
      </el-col>
        <#if table.exportEnable == 'Y'>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['${moduleName}:${businessName}:export']"
        >导出</el-button>
      </el-col>
        </#if>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="${businessName}List" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" fixed />
      <el-table-column label="序号" width="50" align="center" key="${pkColumn.javaField}" prop="${pkColumn.javaField}">
          <template slot-scope="scope">
              <span>{{(queryParams.pageNum - 1) * queryParams.pageSize + scope.$index + 1}}</span>
          </template>
      </el-table-column>
<#list columns as column>
    <#assign javaField = column.javaField>
    <#assign parentheseIndex = column.columnComment?indexOf("（")>
    <#if parentheseIndex != -1>
        <#assign comment = column.columnComment?substring(0, parentheseIndex)>
    <#else>
        <#assign comment = column.columnComment>
    </#if>
    <#if column.list && column.pk>
    <#elseIf column.list && column.htmlType == "datetime">
      <@util.dateColumn column.columnType comment javaField/>
    <#elseIf column.list && column.htmlType == "imageUpload">
      <el-table-column label="${comment}" align="center" prop="${javaField}" width="100">
        <template slot-scope="scope">
          <image-preview :src="scope.row.${javaField}" :width="50" :height="50"/>
        </template>
      </el-table-column>
    <#elseIf column.list && "" != column.dictType>
      <el-table-column label="${comment}" align="center" prop="${javaField}" :show-overflow-tooltip="true">
        <template slot-scope="scope">
        <#if column.htmlType == "checkbox">
          <dict-tag :options="dict.type.${column.dictType}" :value="scope.row.${javaField} ? scope.row.${javaField}.split(',') : []"/>
        <#else>
          <dict-tag :options="dict.type.${column.dictType}" :value="scope.row.${javaField}"/>
        </#if>
        </template>
      </el-table-column>
    <#elseIf column.list && "" != javaField>
      <el-table-column label="${comment}" align="center" prop="${javaField}" :show-overflow-tooltip="true"/>
    </#if>
</#list>
      <el-table-column label="操作" align="center" width="<#if table.flowEnable == 'Y'>200<#else>110</#if>" fixed="right" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
              size="mini"
              type="text"
              @click="handleDetail(scope.row.${pkColumn.javaField})"
              v-hasPermi="['${moduleName}:${businessName}:detail']"
          >详情</el-button>
          <el-button
            size="mini"
            type="text"
			<#if table.flowEnable == 'Y'>
            v-if="scope.row.nodeCode === '2'"
            </#if>
            @click="handleUpdate(scope.row)"
            v-hasPermi="['${moduleName}:${businessName}:edit']"
          >修改</el-button>
          <#if table.flowEnable == 'Y'>
		  <el-button
            size="mini"
            type="text"
            v-if="scope.row.nodeCode === '2'"
            @click="handleSubmit(scope.row.id)"
            v-hasPermi="['test:leave:submit']"
          >提交审批</el-button>
          <el-button
            size="mini"
            type="text"
            @click="toFlowImage(scope.row.instanceId)"
          >流程图</el-button>
          </#if>
          <el-button
            size="mini"
            type="text"
			<#if table.flowEnable == 'Y'>
            v-if="scope.row.nodeCode === '2'"
            </#if>
            @click="handleDelete(scope.row)"
            v-hasPermi="['${moduleName}:${businessName}:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
    <Dialog ref="dialog" @refresh="getList"></Dialog>

	<#if table.flowEnable == 'Y'>
	<el-dialog title="流程图" :visible.sync="flowChart" width="80%">
      <img :src="imgUrl" width="100%" style="margin:0 auto"/>
    </el-dialog>
	</#if>
  </div>
</template>

<script>
import { list${BusinessName}, del${BusinessName}<#if table.flowEnable == 'Y'>, submit</#if> } from "@/api/${moduleName}/${businessName}";
import Dialog from "@/views/${moduleName}/${businessName}/dialog";
<#if table.flowEnable == 'Y'>
import {flowImage} from "@/api/flow/definition";
</#if>

export default {
  name: "${BusinessName}",
<#if dicts?? && dicts?size gt 0>
  dicts: [<#list dicts as dict>'${dict}'<#if dict_index + 1 != dicts?size>,</#if></#list>],
</#if>
  components: {
    Dialog
  },
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
	  <#if table.flowEnable == 'Y'>
      flowChart: false,
      imgUrl: "",
	  </#if>
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // ${functionName}表格数据
      ${businessName}List: [],
<#list columns as column>
    <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
    <#assign AttrName = column.javaField?substring(0,1)?upperCase + column.javaField?substring(1)>
      // ${comment}时间范围
      daterange${AttrName}: [],
    </#if>
</#list>
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
<#list  columns as column>
    <#if column.query>
        ${column.javaField}: null<#if column_index + 1 !=  columns?size>,</#if>
    </#if>
</#list>
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询${functionName}列表 */
    getList() {
      this.loading = true;
<#list  columns as column>
    <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
      this.queryParams.paramsStr = "";
        <#break>
    </#if>
</#list>
<#list  columns as column>
    <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
        <#assign AttrName = column.javaField?substring(0,1)?upperCase + column.javaField?substring(1)>
      if (null != this.daterange${AttrName} && '' != this.daterange${AttrName}) {
        this.queryParams.paramsStr =
            JSON.stringify({
                "beginCreateTime": this.daterangeCreateTime[0],
                "endCreateTime": this.daterangeCreateTime[1]
            });
      }
    </#if>
</#list>
      list${BusinessName}(this.queryParams).then(response => {
        this.${businessName}List = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
<#list  columns as column>
    <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
        <#assign AttrName = column.javaField?substring(0,1)?upperCase + column.javaField?substring(1)>
      this.daterange${AttrName} = [];
    </#if>
</#list>
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.${pkColumn.javaField})
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.$refs.dialog.show();
    },
    /** 详情按钮操作 */
    handleDetail(${pkColumn.javaField}) {
      this.$refs.dialog.show(${pkColumn.javaField}, true);
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      const ${pkColumn.javaField} = row.${pkColumn.javaField} || this.ids
      this.$refs.dialog.show(${pkColumn.javaField});
    },

	<#if table.flowEnable == 'Y'>
	/** 提交审批按钮操作 */
    handleSubmit(id){
      this.$modal.confirm('你确定提交审批吗').then(() => {
        this.loading = true;
        return submit(id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("提交审批成功");
      }).catch(() => {
        this.loading = true;
      });
    },
	toFlowImage(instanceId) {
      flowImage(instanceId).then(response => {
        this.flowChart = true
        this.imgUrl = "data:image/gif;base64," + response.data;
      });
    },
	</#if>

    /** 删除按钮操作 */
    handleDelete(row) {
      const ${pkColumn.javaField}s = row.${pkColumn.javaField} || this.ids;
      this.$modal.confirm('是否确认删除${functionName}编号为"' + ${pkColumn.javaField}s + '"的数据项？').then(() => {
        this.loading = true;
        return del${BusinessName}(${pkColumn.javaField}s);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
        this.loading = true;
      });
    },
<#if table.exportEnable == 'Y'>
    /** 导出按钮操作 */
    handleExport() {
      this.download('${moduleName}/${businessName}/export', {
        ...this.queryParams
      }, `${functionName}_${r"${new Date().getTime()}"}.xlsx`)
    },
</#if>
  }
};
</script>
