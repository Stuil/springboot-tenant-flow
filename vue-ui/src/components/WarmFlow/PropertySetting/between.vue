<template>
  <div>
    <el-form ref="form" :model="form" label-width="120px" size="small" :disabled="disabled">
      <slot name="form-item-task-nodeCode" :model="form" field="nodeCode">
        <el-form-item label="节点编码">
          <el-input v-model="form.nodeCode" :disabled="disabled"></el-input>
        </el-form-item>
      </slot>
      <slot name="form-item-task-nodeName" :model="form" field="nodeName">
        <el-form-item label="节点名称">
          <el-input v-model="form.nodeName" :disabled="disabled"></el-input>
        </el-form-item>
      </slot>
      <slot name="form-item-task-permissionFlag" :model="form" field="permissionFlag">
        <el-form-item label="权限标识">
          <el-select v-model="form.permissionFlag" multiple collapse-tags
                     :disabled="disabled" :clearable="!disabled" filterable>
            <el-option-group
              v-for="groupOption in groupOptions"
              :key="groupOption.label"
              :label="groupOption.label"
              :disabled="disabled">
              <el-option
                v-for="item in groupOption.options"
                :key="item.value"
                :label="item.label"
                :value="item.value">
              </el-option>
            </el-option-group>
          </el-select>
        </el-form-item>
      </slot>
      <slot name="form-item-task-skipAnyNode" :model="form" field="skipAnyNode">
        <el-form-item label="是否可以退回任意节点">
          <el-radio-group v-model="form.skipAnyNode">
            <el-radio label="N" >否</el-radio>
            <el-radio label="Y">是</el-radio>
          </el-radio-group>
        </el-form-item>
      </slot>
    </el-form>
  </div>
</template>

<script>
import {listRole} from "@/api/system/role";
import {listUser} from "@/api/system/user";
import {listDept} from "@/api/system/dept";

export default {
  name: "Between",
  props: {
    value: {
      type: Object,
      default () {
        return {}
      }
    },
    disabled: { // 是否禁止
      type: Boolean,
      default: false
    },
  },
  data () {
    return {
      form: this.value,
      attrKey: '',
      field: this.value.field || {},
      groupOptions: [],
    }
  },
  watch: {
    form: {
      handler (n) {
        this.$emit('change', n)
      },
      deep: true
    }
  },
  created() {
    if (this.form.permissionFlag) {
      this.form.permissionFlag = this.form.permissionFlag.split(",")
    }
    this.getPermissionFlag();
  },
  methods: {
    /** 选择角色权限范围触发 */
    getPermissionFlag() {
      listRole().then(response => {
        let groupOption = {
          label: '角色',
          options: response.rows.map(item =>{
              return {
                value: 'role:' + item.roleId,
                label: item.roleName
              }
            }
          )
        }
        this.groupOptions.push(groupOption);
        listUser().then(response => {
          let groupOption = {
            label: '用户',
            options: response.rows.map(item =>{
                return {
                  value: 'user:'+ item.userId,
                  label: item.nickName
                }
              }
            )
          }
          this.groupOptions.push(groupOption);
          listDept().then(response => {
            let groupOption = {
              label: '部门',
              options: response.data.map(item =>{
                  return {
                    value: 'dept:' + item.deptId,
                    label: item.deptName
                  }
                }
              )
            }
            this.groupOptions.push(groupOption);
          });
        });
      });
    },
  }
}
</script>

<style scoped>

</style>
