<template>
  <div class="app-container">
    <!-- 添加或修改租户对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" v-if="open" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px"  :disabled="disabled">
        <el-row>
          <el-col :span="12">
            <el-form-item label="联系人" prop="contactUserName">
              <el-input v-model="form.contactUserName" placeholder="请输入联系人" maxlength="20" show-word-limit/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="联系电话" prop="contactPhone">
              <el-input v-model="form.contactPhone" placeholder="请输入联系电话" maxlength="20" show-word-limit/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="企业名称" prop="companyName">
              <el-input v-model="form.companyName" placeholder="请输入企业名称" maxlength="50" show-word-limit/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="企业代码" prop="licenseNumber">
              <el-input v-model="form.licenseNumber" placeholder="请输入统一社会信用代码" maxlength="30" show-word-limit/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="租户套餐" prop="packageId">
              <el-select v-model="form.packageId" :disabled="!!form.tenantId" placeholder="请选择租户套餐" clearable style="width: 100%">
                <el-option v-for="item in packageList" :key="item.packageId" :label="item.packageName" :value="item.packageId" />
              </el-select>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row v-if="!form.id">
          <el-col :span="12">
            <el-form-item label="用户账号" prop="userName">
              <el-input v-model="form.userName" placeholder="请输入用户账号" maxlength="30" show-word-limit/>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="用户密码" prop="password">
              <el-input v-model="form.password" placeholder="请输入用户密码" maxlength="20" show-word-limit/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="地址" prop="address">
              <el-input v-model="form.address" placeholder="请输入地址" maxlength="200" show-word-limit/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="企业简介" prop="intro">
              <el-input v-model="form.intro" type="textarea" placeholder="请输入企业简介" maxlength="200" show-word-limit/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="域名" prop="domain">
              <el-input v-model="form.domain" placeholder="请输入域名" maxlength="200" show-word-limit/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
            <el-form-item label="过期时间" prop="expireTime">
              <el-date-picker
                 clearable size="small"
                 v-model="form.expireTime"
                 type="datetime"
                 value-format="yyyy-MM-dd HH:mm:ss"
                 placeholder="选择过期时间">
              </el-date-picker>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="用户数量" prop="accountCount">
              <el-input-number
                v-model="form.accountCount"
                placeholder="请输入用户数量"
                controls-position="right"
                :min="0"/>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="24">
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" maxlength="200" show-word-limit/>
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
import {getTenant, addTenant, updateTenant} from "@/api/system/tenant";
import {selectTenantPackage} from "@/api/system/package";

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
      // 租户套餐
      packageList: [],
      // 表单校验
      rules: {
        tenantId: [
          { required: true, message: "租户编号不能为空", trigger: "blur" }
        ],
        contactUserName: [
          { required: true, message: "联系人不能为空", trigger: "blur" }
        ],
        contactPhone: [
          { required: true, message: "联系电话不能为空", trigger: "blur" }
        ],
        companyName: [
          { required: true, message: "企业名称不能为空", trigger: "blur" }
        ],
        packageId: [
          { required: true, message: "请选择租户套餐", trigger: "blur" }
        ],
        userName: [
          { required: true, message: "用户账号不能为空", trigger: "blur" }
        ],
        password: [
          { required: true, message: "用户密码不能为空", trigger: "blur" }
        ],
      }
    };
  },
  methods: {
    /** 打开租户弹框 */
    async show(id, disabled) {
      this.reset();
      this.disabled = disabled
      this.getTenantPackage()
      if (this.disabled) {
        this.title = "详情"
      } else if (id) {
        await getTenant(id).then(response => {
            this.form = response.data;
        });
        this.title = "修改"
      } else {
        this.title = "新增"
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
      this.form = {
        id: null,
        tenantId: null,
        contactUserName: null,
        contactPhone: null,
        companyName: null,
        licenseNumber: null,
        address: null,
        intro: null,
        domain: null,
        remark: null,
        packageId: null,
        expireTime: null,
        accountCount: null,
        status: null,
        delFlag: null,
        createBy: null,
        createTime: null,
        updateBy: null,
        updateTime: null
      };
      this.resetForm("form");
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateTenant(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.$emit('refresh');
            });
          } else {
            addTenant(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.$emit('refresh');
            });
          }
        }
      });
    },
    /** 查询所有租户套餐 */
    getTenantPackage() {
      selectTenantPackage().then(res => {
        this.packageList = res.data;
      })
    }
  }
};
</script>
