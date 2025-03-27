<template>
  <div class="app-container">
    <!-- 添加或修改常规演示对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" v-if="open" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px"  :disabled="disabled">
        <el-row>
          <el-col :span="12">
            <el-form-item label="标题" prop="title">
              <el-input v-model="form.title" placeholder="请输入标题" maxlength="64" show-word-limit/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="级别" prop="level">
              <el-input-number
                v-model="form.level"
                placeholder="请输入级别"
                controls-position="right"
                :min="0"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="发文字号" prop="sendDocNo">
              <el-input v-model="form.sendDocNo" placeholder="请输入发文字号" maxlength="64" show-word-limit/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="发文单位" prop="sendDocUnit">
              <el-input v-model="form.sendDocUnit" placeholder="请输入发文单位" maxlength="64" show-word-limit/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="发布时间" prop="publishTime">
              <el-date-picker
                clearable size="small"
                v-model="form.publishTime"
                type="date"
                value-format="yyyy-MM-dd"
                placeholder="选择发布时间">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="截至日期" prop="deadline">
              <el-date-picker
                clearable size="small"
                v-model="form.deadline"
                type="datetime"
                value-format="yyyy-MM-dd HH:mm:ss"
                placeholder="选择截至日期">
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="标签" prop="label">
              <el-input v-model="form.label" type="textarea" placeholder="请输入内容" />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="文章内容">
              <editor v-model="form.content" :min-height="192"  :readOnly="disabled"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="金额" prop="money">
              <el-input-number
                v-model="form.money"
                placeholder="请输入金额"
                controls-position="right"
                :min="0"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="阅读次数" prop="views">
              <el-input-number
                v-model="form.views"
                placeholder="请输入阅读次数"
                controls-position="right"
                :min="0"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="附件" prop="newfileId">
              <el-input v-model="form.newfileId" placeholder="请输入附件" maxlength="100" show-word-limit/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="图片" prop="imageId">
              <el-input v-model="form.imageId" placeholder="请输入图片" maxlength="100" show-word-limit/>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" v-if="!disabled" @click="submitForm">确 定</el-button>
        <el-button @click="cancel" v-if="!disabled">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getCommon, addCommon, updateCommon } from "@/api/test/common";

export default {
  name: "Dialog",
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
      }
    };
  },
  methods: {
    /** 打开常规演示弹框 */
    async show(id, disabled) {
      this.reset();
      this.disabled = disabled
      if (id) {
        await getCommon(id).then(response => {
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
        createBy: null,
        createTime: null,
        updateBy: null,
        updateTime: null,
        delFlag: null,
        title: null,
        level: null,
        sendDocNo: null,
        sendDocUnit: null,
        publishTime: null,
        deadline: null,
        label: null,
        content: null,
        money: null,
        views: null,
        newfileId: null,
        imageId: null
      };
      this.resetForm("form");
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateCommon(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.$emit('refresh');
            });
          } else {
            addCommon(this.form).then(response => {
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
