<#import "/templates/macro/util.ftlh" as util>
<#import "/templates/function/validated.ftlh" as validated>
<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="100px">
<#list columns as column>
    <#if column.query>
        <#assign dictType = column.dictType>
        <#assign AttrName= column.javaField?substring(0,1)?upperCase + column.javaField?substring(1)>
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
          type="info"
          plain
          icon="el-icon-sort"
          size="mini"
          @click="toggleExpandAll"
        >展开/折叠</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table
      v-if="refreshTable"
      v-loading="loading"
      :data="${businessName}List"
      row-key="${treeCode}"
      :default-expand-all="isExpandAll"
      :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
    >
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
        <#if column_index == 1>
      <el-table-column label="${comment}" prop="${javaField}"  :show-overflow-tooltip="true"/>
        <#else>
      <el-table-column label="${comment}" align="center" prop="${javaField}"  :show-overflow-tooltip="true"/>
        </#if>
    </#if>
</#list>
      <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
              size="mini"
              type="text"
              @click="handleDetail(scope.row)"
              v-hasPermi="['${moduleName}:${businessName}:detail']"
          >详情</el-button>
          <el-button
            size="mini"
            type="text"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['${moduleName}:${businessName}:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            @click="handleAdd(scope.row)"
            v-hasPermi="['${moduleName}:${businessName}:add']"
          >新增</el-button>
          <el-button
            size="mini"
            type="text"
            @click="handleDelete(scope.row)"
            v-hasPermi="['${moduleName}:${businessName}:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 添加或修改${functionName}对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="<#if table.twoColumn == 'Y'>800px<#else>500px</#if>" v-if="open" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px"  :disabled="disabled">
<#-- 定义一个便利次数的变量  -->
<#if table.twoColumn == 'Y'>
    <#assign  formNum = 0>
</#if>
<#list columns as column>
    <#assign field = column.javaField>
    <#if column.insert && !column.pk>
        <#if column.usableColumn || !column.superColumn>
            <#assign parentheseIndex = column.columnComment?indexOf("（")>
            <#if parentheseIndex != -1>
                <#assign comment = column.columnComment?substring(0, parentheseIndex)>
            <#else>
                <#assign comment = column.columnComment>
            </#if>
            <#assign dictType = column.dictType>
            <#if table.twoColumn == 'Y'>
              <#if formNum % 2 == 0>
                <#if validated.wrap(column.htmlType)>
        <el-row>
          <el-col :span="24">
                  <#assign  formNum = formNum + 1>
                <#else>
        <el-row>
          <el-col :span="12">
                </#if>
              <#else>
                <#if validated.wrap(column.htmlType)>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
                <#else>
          </el-col>
          <el-col :span="12">
                </#if>
              </#if>
              <#assign  formNum = formNum + 1>
            </#if>
            <#if "" != treeParentCode && column.javaField == treeParentCode>
        <el-form-item label="${comment}" prop="${treeParentCode}">
          <treeselect v-model="form.${treeParentCode}" :options="${businessName}Options" :normalizer="normalizer" placeholder="请选择${comment}"
                      :disabled="disabled"/>
        </el-form-item>
            <#elseIf column.htmlType == "input">
        <el-form-item label="${comment}" prop="${field}">
          <el-input v-model="form.${field}" placeholder="请输入${comment}" />
        </el-form-item>
            <#elseIf column.htmlType == "imageUpload">
        <el-form-item label="${comment}" prop="${field}">
          <image-upload v-model="form.${field}"/>
        </el-form-item>
            <#elseIf column.htmlType == "fileUpload">
        <el-form-item label="${comment}" prop="${field}">
          <file-upload v-model="form.${field}"/>
        </el-form-item>
            <#elseIf column.htmlType == "editor">
        <el-form-item label="${comment}">
          <editor v-model="form.${field}" :min-height="192"/>
        </el-form-item>
            <#elseIf column.htmlType == "select" && "" != dictType>
        <el-form-item label="${comment}" prop="${field}">
          <el-select v-model="form.${field}" placeholder="请选择${comment}">
            <el-option
              v-for="dict in dict.type.${dictType}"
              :key="dict.value"
              :label="dict.label"
                <#if column.javaType == "Integer" || column.javaType == "Long">
              :value="parseInt(dict.value)"
                <#else>
              :value="dict.value"
                </#if>
            ></el-option>
          </el-select>
        </el-form-item>
            <#elseIf column.htmlType == "select" && dictType>
        <el-form-item label="${comment}" prop="${field}">
          <el-select v-model="form.${field}" placeholder="请选择${comment}">
            <el-option label="请选择字典生成" value="" />
          </el-select>
        </el-form-item>
            <#elseIf column.htmlType == "checkbox" && "" != dictType>
        <el-form-item label="${comment}" prop="${field}">
          <el-checkbox-group v-model="form.${field}">
            <el-checkbox
              v-for="dict in dict.type.${dictType}"
              :key="dict.value"
              :label="dict.value">
              {{dict.label}}
            </el-checkbox>
          </el-checkbox-group>
        </el-form-item>
            <#elseIf column.htmlType == "checkbox" && dictType>
        <el-form-item label="${comment}" prop="${field}">
          <el-checkbox-group v-model="form.${field}">
            <el-checkbox>请选择字典生成</el-checkbox>
          </el-checkbox-group>
        </el-form-item>
            <#elseIf column.htmlType == "radio" && "" != dictType>
        <el-form-item label="${comment}" prop="${field}">
          <el-radio-group v-model="form.${field}">
            <el-radio
              v-for="dict in dict.type.${dictType}"
              :key="dict.value"
                <#if column.javaType == "Integer" || column.javaType == "Long">
              :label="parseInt(dict.value)"
                <#else>
              :label="dict.value"
                </#if>
            >{{dict.label}}</el-radio>
          </el-radio-group>
        </el-form-item>
            <#elseIf column.htmlType == "radio" && dictType>
        <el-form-item label="${comment}" prop="${field}">
          <el-radio-group v-model="form.${field}">
            <el-radio label="1">请选择字典生成</el-radio>
          </el-radio-group>
        </el-form-item>
            <#elseIf column.htmlType == "datetime">
        <el-form-item label="${comment}" prop="${field}">
          <@util.date "form" column.columnType comment field/>
        </el-form-item>
            <#elseIf column.htmlType == "textarea">
        <el-form-item label="${comment}" prop="${field}">
          <el-input v-model="form.${field}" type="textarea" placeholder="请输入内容" />
        </el-form-item>
            </#if>
        <#if table.twoColumn == 'Y' && formNum % 2 == 0>
          </el-col>
        </el-row>
        </#if>
        </#if>
    </#if>
</#list>
<#if table.twoColumn == 'Y' && formNum % 2 == 1 >
          </el-col>
        </el-row>
</#if>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" v-if="!disabled" @click="submitForm">确 定</el-button>
        <el-button @click="cancel" v-if="!disabled">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { list${BusinessName}, get${BusinessName}, del${BusinessName}, add${BusinessName}, update${BusinessName} } from "@/api/${moduleName}/${businessName}";
import Treeselect from "@riophae/vue-treeselect";
import "@riophae/vue-treeselect/dist/vue-treeselect.css";

export default {
  name: "${BusinessName}",
<#if dicts?? && dicts?size gt 0>
  dicts: [<#list dicts as dict>'${dict}'<#if dict_index + 1 != dicts?size>,</#if></#list>],
</#if>
  components: {
    Treeselect
  },
  data() {
    return {
      // 遮罩层
      loading: true,
      // 显示搜索条件
      showSearch: true,
      // ${functionName}表格数据
      ${businessName}List: [],
      // ${functionName}树选项
      ${businessName}Options: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 是否禁用表单
      disabled: false,
      // 是否展开，默认全部展开
      isExpandAll: true,
      // 重新渲染表格状态
      refreshTable: true,
<#list columns as column>
    <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
        <#assign AttrName = column.javaField?substring(0,1)?upperCase + column.javaField?substring(1)>
      // ${comment}时间范围
      daterange${AttrName}: [],
    </#if>
</#list>
      // 查询参数
      queryParams: {
<#list columns as column>
    <#if column.query>
        ${column.javaField}: null<#if foreach.count != columns?size>,</#if>
    </#if>
</#list>
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
<#list columns as column>
    <#if column.required>
        <#assign parentheseIndex = column.columnComment?indexOf("（")>
        <#if parentheseIndex != -1>
            <#assign comment = column.columnComment?substring(0, parentheseIndex)>
        <#else>
            <#assign comment = column.columnComment>
        </#if>
        ${column.javaField}: [
          { required: true, message: "${comment}不能为空", trigger: <#if column.htmlType == "select" || column.htmlType == "radio">"change"<#else>"blur"</#if> }
        ]<#if foreach.count != columns?size>,</#if>
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
<#list columns as column>
    <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
        <#assign  AttrName = column.javaField?substring(0,1)?upperCase + column.javaField?substring(1)>
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
        this.${businessName}List = this.handleTree(response.data, "${treeCode}", "${treeParentCode}");
        this.loading = false;
      });
    },
    /** 转换${functionName}数据结构 */
    normalizer(node) {
      if (node.children && !node.children.length) {
        delete node.children;
      }
      return {
        id: node.${treeCode},
        label: node.${treeName},
        children: node.children
      };
    },
	/** 查询${functionName}下拉树结构 */
    getTreeselect() {
      list${BusinessName}().then(response => {
        this.${businessName}Options = [];
        const data = { ${treeCode}: 0, ${treeName}: '顶级节点', children: [] };
        data.children = this.handleTree(response.data, "${treeCode}", "${treeParentCode}");
        this.${businessName}Options.push(data);
      });
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
<#list columns as column>
    <#if column.htmlType == "checkbox">
        ${column.javaField}: []<#if column_index + 1 != columns?size>,</#if>
    <#else>
        ${column.javaField}: null<#if column_index + 1 != columns?size>,</#if>
    </#if>
</#list>
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
<#list columns as column>
    <#if column.htmlType == "datetime" && column.queryType == "BETWEEN">
        <#assign AttrName = column.javaField?substring(0,1)?upperCase + column.javaField?substring(1)>
      this.daterange${AttrName} = [];
    </#if>
</#list>
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 新增按钮操作 */
    handleAdd(row) {
      this.reset();
      this.getTreeselect();
      if (row != null && row.${treeCode}) {
        this.form.${treeParentCode} = row.${treeCode};
      } else {
        this.form.${treeParentCode} = 0;
      }
      this.open = true;
      this.disabled = false;
      this.title = "添加${functionName}";
    },
    /** 展开/折叠操作 */
    toggleExpandAll() {
      this.refreshTable = false;
      this.isExpandAll = !this.isExpandAll;
      this.$nextTick(() => {
        this.refreshTable = true;
      });
    },
    /** 详情按钮操作 */
    handleDetail(row) {
      this.reset();
      this.getTreeselect();
      if (row != null) {
        this.form.${treeParentCode} = row.${treeCode};
      }
      get${BusinessName}(row.${pkColumn.javaField}).then(response => {
        this.form = response.data;
          <#list columns as column>
              <#if column.htmlType == "checkbox">
                this.form.${column.javaField} = this.form.${column.javaField}.split(",");
              </#if>
          </#list>
        this.open = true;
        this.disabled = true;
        this.title = "详情${functionName}";
      });
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      this.getTreeselect();
      if (row != null) {
        this.form.${treeParentCode} = row.${treeCode};
      }
      get${BusinessName}(row.${pkColumn.javaField}).then(response => {
        this.form = response.data;
<#list columns as column>
    <#if column.htmlType == "checkbox">
        this.form.${column.javaField} = this.form.${column.javaField}.split(",");
    </#if>
</#list>
        this.open = true;
        this.disabled = false;
        this.title = "修改${functionName}";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
<#list columns as column>
    <#if column.htmlType == "checkbox">
          this.form.${column.javaField} = this.form.${column.javaField}.join(",");
    </#if>
</#list>
          if (this.form.${pkColumn.javaField} != null) {
            update${BusinessName}(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            add${BusinessName}(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      this.$modal.confirm('是否确认删除${functionName}编号为"' + row.${pkColumn.javaField} + '"的数据项？').then(function() {
        return del${BusinessName}(row.${pkColumn.javaField});
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
  }
};
</script>
