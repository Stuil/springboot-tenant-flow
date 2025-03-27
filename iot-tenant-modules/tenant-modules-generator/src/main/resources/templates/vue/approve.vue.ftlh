<#import "/templates/macro/util.ftlh" as util>
<#import "/templates/function/validated.ftlh" as validated>
<template>
  <div class="app-container">
    <!-- 添加或修改${functionName}对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="<#if table.twoColumn == 'Y'>800px<#else>500px</#if>" v-if="open" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px"  :disabled="disabled">
<#-- 定义一个便利次数的变量  -->
<#if table.twoColumn == 'Y'>
    <#assign  formNum = 0>
</#if>
<#list columns as column>
    <#assign field = column.javaField>
    <#if column.insert && ! column.pk>
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
            <#if column.htmlType == "input">
            <el-form-item label="${comment}" prop="${field}">
                <#assign lengthTemplate = "com.hh.generator.methodmodel.LengthTemplate"?new()>
                <#assign length = lengthTemplate(column.columnType)>
              <el-input v-model="form.${field}" placeholder="请输入${comment}" <#if length?? && length?trim != "">maxlength="${length}" show-word-limit</#if>/>
            </el-form-item>
            <#elseIf column.htmlType == "imageUpload">
            <el-form-item label="${comment}" prop="${field}">
              <image-upload v-model="form.${field}"/>
            </el-form-item>
            <#elseIf column.htmlType == "fileUpload">
            <el-form-item label="${comment}" prop="${field}">
              <file-upload v-model="form.${field}" :deleteShow="!disabled"/>
            </el-form-item>
            <#elseIf column.htmlType == "editor">
            <el-form-item label="${comment}">
              <editor v-model="form.${field}" :min-height="192"  :readOnly="disabled"/>
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
            <#elseIf column.htmlType == "checkbox" &&  dictType>
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
                <#assign lengthTemplate = "com.hh.generator.methodmodel.LengthTemplate"?new()>
                <#assign length = lengthTemplate(column.columnType)>
              <el-input v-model="form.${field}" type="textarea" placeholder="请输入内容" <#if length?? && length?trim != "">maxlength="${length}" show-word-limit</#if>/>
            </el-form-item>
            <#elseIf column.htmlType == "inputNumber">
            <el-form-item label="${comment}" prop="${field}">
                <#--<#assign numberTemplate = "com.hh.generator.methodmodel.NumberTemplate"?new()>
                <#assign map = numberTemplate(column.columnType)>-->
                <el-input-number
                        v-model="form.${field}"
                        placeholder="请输入${comment}"
                        controls-position="right"
                        :min="0"
                        <#--<#if map?? && (map?size>0)>
                        :max="${map["first"]}"
                            <#if map["isFloat"] == "true">
                        :precision="${map["second"]}"
                            </#if>
                        </#if>-->/>
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
<#if table.sub>
        <el-divider content-position="center">${subTable.functionName}信息</el-divider>
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAdd${subClassName}">添加</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDelete${subClassName}">删除</el-button>
          </el-col>
        </el-row>
        <el-table :data="${subclassName}List" :row-class-name="row${subClassName}Index" @selection-change="handle${subClassName}SelectionChange" ref="${subclassName}">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="序号" align="center" prop="index" width="50"/>
    <#list subTable.columns as column>
        <#assign javaField = column.javaField>
        <#assign parentheseIndex = column.columnComment?indexOf("（")>
        <#if parentheseIndex != -1>
            <#assign comment = column.columnComment?substring(0, parentheseIndex)>
        <#else>
            <#assign comment = column.columnComment>
        </#if>
        <#if column.pk || javaField == subTableFkclassName>
        <#elseIf column.list && column.htmlType == "input">
          <el-table-column label="${comment}" prop="${javaField}">
            <template slot-scope="scope">
              <el-input v-model="scope.row.${javaField}" placeholder="请输入${comment}"/>
            </template>
          </el-table-column>
        <#elseIf column.list && column.htmlType == "datetime">
          <el-table-column label="${comment}" prop="${javaField}" width="240">
            <template slot-scope="scope">
              <el-date-picker clearable v-model="scope.row.${javaField}" type="date" value-format="yyyy-MM-dd" placeholder="请选择${comment}" />
            </template>
          </el-table-column>
        <#elseIf column.list && (column.htmlType == "select" || column.htmlType == "radio") && "" != column.dictType>
          <el-table-column label="${comment}" prop="${javaField}" width="150">
            <template slot-scope="scope">
              <el-select v-model="scope.row.${javaField}" placeholder="请选择${comment}">
                <el-option
                  v-for="dict in dict.type.${column.dictType}"
                  :key="dict.value"
                  :label="dict.label"
                  :value="dict.value"
                ></el-option>
              </el-select>
            </template>
          </el-table-column>
        <#elseIf column.list && (column.htmlType == "select" || column.htmlType == "radio") && "" == column.dictType>
          <el-table-column label="${comment}" prop="${javaField}" width="150">
            <template slot-scope="scope">
              <el-select v-model="scope.row.${javaField}" placeholder="请选择${comment}">
                <el-option label="请选择字典生成" value="" />
              </el-select>
            </template>
          </el-table-column>
        </#if>
    </#list>
        </el-table>
</#if>
        <el-divider></el-divider>
        <el-form-item label="审批意见" prop="message">
            <el-input v-model="form.message" type="textarea" placeholder="请输入审批意见"
                      :autosize="{minRows: 4, maxRows: 4}"/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="handleBtn('PASS')">审批通过</el-button>
        <el-button @click="handleBtn('REJECT')">驳回</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { get${BusinessName}, handle } from "@/api/${moduleName}/${businessName}";

export default {
  name: "Approve",
<#if dicts?? && dicts?size gt 0>
  dicts: [<#list dicts as dict>'${dict}'<#if dict_index + 1 != dicts?size>,</#if></#list>],
</#if>
  props: {
      /* 业务id */
      value: {
          type: String,
          default: "",
      },

      /* 实例id */
      taskId: {
          type: String,
          default: "",
      },

      /* 是否可以标编辑 */
      disabled: {
          type: Boolean,
          default: false,
      },
  },
  data() {
    return {
<#if table.sub>
      // 子表选中数据
      checked${subClassName}: [],
</#if>
<#if table.sub>
      // ${subTable.functionName}表格数据
      ${subclassName}List: [],
</#if>
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 表单参数
      form: {},
      // 表单校验
      rules: {
<#list  columns as column>
    <#if column.required>
        <#assign parentheseIndex = column.columnComment?indexOf("（")>
        <#if parentheseIndex != -1>
            <#assign comment = column.columnComment?substring(0, parentheseIndex)>
        <#else>
            <#assign comment = column.columnComment>
        </#if>
        ${column.javaField}: [
          { required: true, message: "${comment}不能为空", trigger: <#if column.htmlType == "select" ||  column.htmlType == "radio">"change"<#else>"blur"</#if> }
        ]<#if column_index + 1 !=  columns?size>,</#if>
    </#if>
</#list>
      }
    };
  },
  created() {
      this.reset();
      get${BusinessName}(this.value).then(response => {
          if (!response.data) {
              this.$modal.alertWarning("代办任务不存在");
          }
          this.form = response.data;
      });
      this.title = "办理"
      this.open = true
  },
  methods: {
      // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        message: null,
<#list  columns as column>
    <#if column.htmlType == "checkbox">
        ${column.javaField}: []<#if column_index + 1 != columns?size>,</#if>
    <#else>
        ${column.javaField}: null<#if column_index + 1 != columns?size>,</#if>
    </#if>
</#list>
      };
<#if table.sub>
      this.${subclassName}List = [];
</#if>
      this.resetForm("form");
    },
    /** 审核通过按钮 */
    handleBtn(skipType) {
        this.$refs["form"].validate(valid => {
            if (valid) {
                handle(this.form, this.taskId, skipType, this.form.message).then(response => {
                    this.$modal.msgSuccess("办理成功");
                    this.open = false;
                    this.$emit('refresh');
                });
            }
        });
    },
<#if table.sub>
	/** ${subTable.functionName}序号 */
    row${subClassName}Index({ row, rowIndex }) {
      row.index = rowIndex + 1;
    },
    /** ${subTable.functionName}添加按钮操作 */
    handleAdd${subClassName}() {
      let obj = {};
    <#list subTable.columns as column>
        <#if column.pk || column.javaField == subTableFkclassName>
        <#elseIf column.list && "" != javaField>
      obj.${column.javaField} = "";
        </#if>
    </#list>
      this.${subclassName}List.push(obj);
    },
    /** ${subTable.functionName}删除按钮操作 */
    handleDelete${subClassName}() {
      if (this.checked${subClassName}.length == 0) {
        this.$modal.msgError("请先选择要删除的${subTable.functionName}数据");
      } else {
        const ${subclassName}List = this.${subclassName}List;
        const checked${subClassName} = this.checked${subClassName};
        this.${subclassName}List = ${subclassName}List.filter(function(item) {
          return checked${subClassName}.indexOf(item.index) == -1
        });
      }
    },
    /** 复选框选中数据 */
    handle${subClassName}SelectionChange(selection) {
      this.checked${subClassName} = selection.map(item => item.index)
    },
</#if>
  }
};
</script>
