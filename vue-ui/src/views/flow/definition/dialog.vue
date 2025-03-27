<template>
  <div class="app-container">
    <!-- 添加或修改流程定义对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" v-if="open" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px"  :disabled="disabled">
        <el-form-item label="流程编码" prop="flowCode">
          <el-input v-model="form.flowCode" placeholder="请输入流程编码" maxlength="40" show-word-limit/>
        </el-form-item>
        <el-form-item label="流程名称" prop="flowName">
          <el-input v-model="form.flowName" placeholder="请输入流程名称" maxlength="100" show-word-limit/>
        </el-form-item>
        <el-form-item label="流程版本" prop="version">
          <el-input v-model="form.version" placeholder="请输入流程版本" maxlength="20" show-word-limit/>
        </el-form-item>
        <el-form-item label="是否发布" prop="isPublish" v-if="disabled">
          <el-select v-model="form.isPublish" placeholder="请选择是否开启流程">
            <el-option
              v-for="dict in dict.type.is_publish"
              :key="dict.value"
              :label="dict.label"
              :value="parseInt(dict.value)"
            ></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="审批表单是否自定义" prop="fromCustom">
          <el-radio-group v-model="form.fromCustom">
<!--            <el-radio label="Y">是</el-radio>-->
            <el-radio label="N" >否</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="审批表单路径" prop="fromPath">
          <el-input v-model="form.fromPath" placeholder="请输入审批表单路径" maxlength="100" show-word-limit/>
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" v-if="!disabled" @click="submitForm">确 定</el-button>
        <el-button @click="cancel" v-if="!disabled">取 消</el-button>
        <el-button @click="cancel" v-if="disabled">关 闭</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getDefinition, addDefinition, updateDefinition } from "@/api/flow/definition";

export default {
  name: "Dialog",
  dicts: ['sys_yes_no', 'is_publish'],
  data() {
    return {
      // 是否禁用表单
      disabled: false,
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        flowCode: [
          { required: true, message: "流程编码不能为空", trigger: "blur" }
        ],
        flowName: [
          { required: true, message: "流程名称不能为空", trigger: "blur" }
        ],
        version: [
          { required: true, message: "流程版本不能为空", trigger: "blur" }
        ],
        isPublish: [
          { required: true, message: "是否开启流程不能为空", trigger: "change" }
        ],
        fromCustom: [
          { required: true, message: "请选择审批表单是否自定义", trigger: "change" }
        ],
      }
    };
  },
  methods: {
    /** 打开流程定义弹框 */
    async show(id, disabled) {
      this.reset();
      this.disabled = disabled
      if (id) {
        await getDefinition(id).then(response => {
          this.form = response.data;
        });
      }
      this.open = true
      if (this.disabled) {
        this.title = "详情"
      } else if (id) {
        this.title = "修改"
      } else {
        this.title = "新增"
      }
    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.form = {
        id: null,
        flowCode: null,
        flowName: null,
        version: null,
        isPublish: null,
        fromCustom: null,
        fromPath: null,
        createTime: null,
        updateTime: null,
        delFlag: null
      };
      this.resetForm("form");
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateDefinition(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.$emit('refresh');
            });
          } else {
            addDefinition(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.$emit('refresh');
            });
          }
        }
      });
    },
  }
};
</script>
