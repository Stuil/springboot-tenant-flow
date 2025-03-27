<template>
  <div class="app-container">
    <!-- 添加或修改主子演示对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" v-if="open" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px"  :disabled="disabled">
        <el-row>
          <el-col :span="12">
            <el-form-item label="律师所名称" prop="lawFirmName">
              <el-input v-model="form.lawFirmName" placeholder="请输入律师所名称" maxlength="30" show-word-limit/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="地址" prop="address">
              <el-input v-model="form.address" placeholder="请输入地址" maxlength="255" show-word-limit/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="logo图片id" prop="fileId">
              <image-upload v-model="form.fileId"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="状态" prop="state">
              <el-select v-model="form.state" placeholder="请选择状态">
                <el-option
                  v-for="dict in dict.type.leave_status"
                  :key="dict.value"
                  :label="dict.label"
                  :value="parseInt(dict.value)"
                ></el-option>
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="发布时间" prop="publishTime">
              <el-date-picker
                 clearable size="small"
                 v-model="form.publishTime"
                 type="datetime"
                 value-format="yyyy-MM-dd HH:mm:ss"
                 placeholder="选择发布时间">
              </el-date-picker>
            </el-form-item>
          </el-col>
        </el-row>
        <el-divider content-position="center">子信息</el-divider>
        <el-row :gutter="10" class="mb8">
          <el-col :span="1.5">
            <el-button type="primary" icon="el-icon-plus" size="mini" @click="handleAddTestSub">添加</el-button>
          </el-col>
          <el-col :span="1.5">
            <el-button type="danger" icon="el-icon-delete" size="mini" @click="handleDeleteTestSub">删除</el-button>
          </el-col>
        </el-row>
        <el-table :data="testSubList" :row-class-name="rowTestSubIndex" @selection-change="handleTestSubSelectionChange" ref="testSub">
          <el-table-column type="selection" width="50" align="center" />
          <el-table-column label="序号" align="center" prop="index" width="50"/>
          <el-table-column label="律师名称" prop="lawyerName">
            <template slot-scope="scope">
              <el-input v-model="scope.row.lawyerName" placeholder="请输入律师名称"/>
            </template>
          </el-table-column>
          <el-table-column label="联系电话" prop="phone">
            <template slot-scope="scope">
              <el-input v-model="scope.row.phone" placeholder="请输入联系电话"/>
            </template>
          </el-table-column>
          <el-table-column label="简介" prop="briefIntroduction">
            <template slot-scope="scope">
              <el-input v-model="scope.row.briefIntroduction" placeholder="请输入简介"/>
            </template>
          </el-table-column>
        </el-table>
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
import { getMater, addMater, updateMater } from "@/api/test/mater";

export default {
  name: "Dialog",
  dicts: ['leave_status'],
  data() {
    return {
      // 子表选中数据
      checkedTestSub: [],
      // 是否禁用表单
      disabled: false,
      // 子表格数据
      testSubList: [],
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
    /** 打开主子演示弹框 */
    async show(id, disabled) {
      this.reset();
      this.disabled = disabled
      if (id) {
        await getMater(id).then(response => {
          this.form = response.data;
              this.testSubList = response.data.testSubList;
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
        lawFirmName: null,
        address: null,
        fileId: null,
        delFlag: null,
        state: null,
        publishTime: null,
        createBy: null,
        createTime: null,
        updateBy: null,
        updateTime: null
      };
      this.testSubList = [];
      this.resetForm("form");
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.form.testSubList = this.testSubList;
          if (this.form.id != null) {
            updateMater(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.$emit('refresh');
            });
          } else {
            addMater(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.$emit('refresh');
            });
          }
        }
      });
    },
	/** 子序号 */
    rowTestSubIndex({ row, rowIndex }) {
      row.index = rowIndex + 1;
    },
    /** 子添加按钮操作 */
    handleAddTestSub() {
      let obj = {};
      obj.lawyerName = "";
      obj.phone = "";
      obj.briefIntroduction = "";
      this.testSubList.push(obj);
    },
    /** 子删除按钮操作 */
    handleDeleteTestSub() {
      if (this.checkedTestSub.length == 0) {
        this.$modal.msgError("请先选择要删除的子数据");
      } else {
        const testSubList = this.testSubList;
        const checkedTestSub = this.checkedTestSub;
        this.testSubList = testSubList.filter(function(item) {
          return checkedTestSub.indexOf(item.index) == -1
        });
      }
    },
    /** 复选框选中数据 */
    handleTestSubSelectionChange(selection) {
      this.checkedTestSub = selection.map(item => item.index)
    },
  }
};
</script>
