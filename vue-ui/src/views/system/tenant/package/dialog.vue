<template>
  <div class="app-container">
    <!-- 添加或修改租户套餐对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" v-if="open" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="110px"  :disabled="disabled">
            <el-form-item label="套餐名称" prop="packageName">
              <el-input v-model="form.packageName" placeholder="请输入套餐名称" maxlength="20" show-word-limit/>
            </el-form-item>
            <el-form-item label="菜单权限">
              <el-checkbox v-model="menuExpand" @change="handleCheckedTreeExpand($event)">展开/折叠</el-checkbox>
              <el-checkbox v-model="menuNodeAll" @change="handleCheckedTreeNodeAll($event)">全选/全不选</el-checkbox>
              <el-checkbox v-model="form.menuCheckStrictly" @change="handleCheckedTreeConnect($event)">父子联动</el-checkbox>
              <el-tree
                class="tree-border"
                :data="menuOptions"
                show-checkbox
                ref="menu"
                node-key="id"
                :check-strictly="!form.menuCheckStrictly"
                empty-text="加载中，请稍候"
                :props="{ label: 'label', children: 'children' }"
              ></el-tree>
            </el-form-item>
            <el-form-item label="备注" prop="remark">
              <el-input v-model="form.remark" placeholder="请输入备注" maxlength="200" show-word-limit/>
            </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" v-if="!disabled" @click="submitForm">确 定</el-button>
        <el-button @click="cancel" v-if="!disabled">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<script>
import { getTenantPackage, addTenantPackage, updateTenantPackage } from "@/api/system/package";
import {treeselect as menuTreeselect, tenantPackageMenuTreeselect} from "@/api/system/menu";


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
      menuExpand: false,
      menuNodeAll: false,
      // 菜单列表
      menuOptions: [],
      // 表单参数
      form: {},
      // 表单校验
      rules: {
      }
    };
  },
  methods: {
    /** 打开租户套餐弹框 */
    async show(packageId, disabled) {
      this.reset();
      this.disabled = disabled
      if (this.disabled) {
        this.title = "详情"
      } else if (packageId) {
        const roleMenu = this.getTenantPackageMenuTreeselect(packageId);
        await getTenantPackage(packageId).then(response => {
          this.form = response.data;
          this.$nextTick(() => {
            roleMenu.then(res => {
              let checkedKeys = res.checkedKeys
              checkedKeys.forEach((v) => {
                this.$nextTick(()=>{
                  this.$refs.menu.setChecked(v, true ,false);
                })
              })
            });
          });
        });
        this.title = "修改"
      } else {
        this.getMenuTreeselect();
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
      if (this.$refs.menu != undefined) {
        this.$refs.menu.setCheckedKeys([]);
      }
      this.menuExpand = false,
      this.menuNodeAll = false,
      this.form = {
        packageId: null,
        packageName: null,
        menuIds: null,
        remark: null,
        menuCheckStrictly: null,
        status: null,
        delFlag: null,
        createBy: null,
        createTime: null,
        updateBy: null,
        updateTime: null
      };
      this.resetForm("form");
    },
    /** 查询菜单树结构 */
    getMenuTreeselect() {
      menuTreeselect().then(response => {
        this.menuOptions = response.data;
      });
    },
    /** 根据租户套餐ID查询菜单树结构 */
    getTenantPackageMenuTreeselect(roleId) {
      return tenantPackageMenuTreeselect(roleId).then(response => {
        this.menuOptions = response.menus;
        return response;
      });
    },
    // 所有菜单节点数据
    getMenuAllCheckedKeys() {
      // 目前被选中的菜单节点
      let checkedKeys = this.$refs.menu.getCheckedKeys();
      // 半选中的菜单节点
      let halfCheckedKeys = this.$refs.menu.getHalfCheckedKeys();
      checkedKeys.unshift.apply(checkedKeys, halfCheckedKeys);
      return checkedKeys ?checkedKeys.join(','): '';
    },
    // 树权限（展开/折叠）
    handleCheckedTreeExpand(value) {
      let treeList = this.menuOptions;
      for (let i = 0; i < treeList.length; i++) {
        this.$refs.menu.store.nodesMap[treeList[i].id].expanded = value;
      }
    },
    // 树权限（全选/全不选）
    handleCheckedTreeNodeAll(value) {
      this.$refs.menu.setCheckedNodes(value ? this.menuOptions: []);
    },
    // 树权限（父子联动）
    handleCheckedTreeConnect(value) {
      this.form.menuCheckStrictly = value ? true: false;
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          this.form.menuIds = this.getMenuAllCheckedKeys();
          if (this.form.packageId != null) {
            updateTenantPackage(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.$emit('refresh');
            });
          } else {
            addTenantPackage(this.form).then(response => {
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
