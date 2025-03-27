<template>
  <div class="app-container">
    <!-- 添加或修改流程实例对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="1000px" v-if="open" append-to-body>
      <component v-bind:is="approve" v-model="businessId" :disabled="false"></component>
      <el-divider></el-divider>
      <el-form ref="todoForm" :model="todoForm" :rules="rules" label-width="150px">
        <el-form-item label="审批意见" prop="message">
          <el-input v-model="todoForm.message" type="textarea" placeholder="请输入审批意见"
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
import { handle } from "@/api/flow/execute";

export default {
  name: "Dialog",
  data() {
    return {
      instanceId: "",
      businessId: "",
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 表单参数
      todoForm: {},
      // 业务审批页面
      approve: null,
      // 表单校验
      rules: {
        message: [
          { required: true, message: "审批意见不能为空", trigger: "blur" }
        ],
      }
    };
  },
  methods: {
    /** 打开办理弹框 */
    show(row) {
      this.reset();
      this.instanceId = row.instanceId
      this.businessId = row.businessId
      this.title = "办理"
      if (row.fromCustom == 'N' && row.fromPath) {
        // 实际情况是，不同条件对应不同的页面，所以用动态组件
        this.approve = (resolve) => require([`@/views/${row.fromPath}`], resolve)
      }
      this.open = true

    },
    // 取消按钮
    cancel() {
      this.open = false;
      this.reset();
    },
    // 表单重置
    reset() {
      this.todoForm = {
        message: null,
      };
      this.resetForm("todoForm");
    },
    /** 审核通过按钮 */
    handleBtn(skipType) {
      this.$refs["todoForm"].validate(valid => {
        if (valid) {
          handle(this.instanceId, skipType, this.todoForm.message).then(response => {
            this.$modal.msgSuccess("办理成功");
            this.open = false;
            this.$emit('refresh');
          });
        }
      });
    },
  }
};
</script>
