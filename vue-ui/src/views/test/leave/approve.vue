<template>
  <div class="app-container">
    <!-- 添加或修改OA 请假申请对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" v-if="open" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px"  :disabled="disabled">
            <el-form-item label="请假类型" prop="type">
              <el-select v-model="form.type" placeholder="请选择请假类型">
                <el-option
                  v-for="dict in dict.type.leave_type"
                  :key="dict.value"
                  :label="dict.label"
                  :value="parseInt(dict.value)"
                ></el-option>
              </el-select>
            </el-form-item>
            <el-form-item label="请假原因" prop="reason">
              <el-input v-model="form.reason" type="textarea" placeholder="请输入内容" maxlength="200" show-word-limit/>
            </el-form-item>
            <el-form-item label="开始时间" prop="startTime">
              <el-date-picker
                 clearable size="small"
                 v-model="form.startTime"
                 type="datetime"
                 value-format="yyyy-MM-dd HH:mm:ss"
                 placeholder="选择开始时间">
              </el-date-picker>
            </el-form-item>
            <el-form-item label="结束时间" prop="endTime">
              <el-date-picker
                 clearable size="small"
                 v-model="form.endTime"
                 type="datetime"
                 value-format="yyyy-MM-dd HH:mm:ss"
                 placeholder="选择结束时间">
              </el-date-picker>
            </el-form-item>
            <el-form-item label="请假天数" prop="day">
              <el-input v-model="form.day" placeholder="请输入请假天数" />
            </el-form-item>
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
import { getLeave, handle } from "@/api/test/leave";

export default {
  name: "Approve",
  dicts: ['flow_status','leave_type'],
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
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 表单参数
      form: {},
      // 表单校验
      rules: {
        type: [
          { required: true, message: "请假类型不能为空", trigger: "change" }
        ],
        reason: [
          { required: true, message: "请假原因不能为空", trigger: "blur" }
        ],
        startTime: [
          { required: true, message: "开始时间不能为空", trigger: "blur" }
        ],
        endTime: [
          { required: true, message: "结束时间不能为空", trigger: "blur" }
        ],
        day: [
          { required: true, message: "请假天数不能为空", trigger: "blur" }
        ],
      }
    };
  },
  created() {
      this.reset();
      getLeave(this.value).then(response => {
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
        id: null,
        type: null,
        reason: null,
        startTime: null,
        endTime: null,
        day: null,
        instanceId: null,
        nodeCode: null,
        nodeName: null,
        flowStatus: null,
        createBy: null,
        createTime: null,
        updateBy: null,
        updateTime: null,
        delFlag: null
      };
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
  }
};
</script>
