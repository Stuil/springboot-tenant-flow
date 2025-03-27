<template>
  <div>
    <el-form ref="form" :model="form" label-width="120px" size="small" :disabled="disabled">
      <slot name="form-item-task-skipName" v-if="skipConditionShow" :model="form" field="skipName">
        <el-form-item label="跳转名称">
          <el-input v-model="form.skipName" placeholder="跳转名称"/>
        </el-form-item>
      </slot>
      <slot name="form-item-task-skipType" :model="form" field="skipType">
        <el-form-item label="跳转类型">
          <el-select v-model="form.skipType">
            <el-option sel label="审批通过" value="PASS"/>
            <el-option label="驳回" value="REJECT"/>
          </el-select>
        </el-form-item>
      </slot>
      <slot name="form-item-task-skipCondition" v-if="skipConditionShow" :model="form" field="skipCondition">
        <el-form-item label="跳转条件">
          <el-input v-model="form.condition" placeholder="条件名" style="width: 25%"/>
          <el-select v-model="form.conditionType" placeholder="请选择条件方式" style="width: 40%;margin-left: 5px">
            <el-option label="大于" value="gt"/>
            <el-option label="大于等于" value="ge"/>
            <el-option label="等于" value="eq"/>
            <el-option label="不等于" value="ne"/>
            <el-option label="小于" value="lt"/>
            <el-option label="小于等于" value="le"/>
            <el-option label="包含" value="like"/>
            <el-option label="不包含" value="notNike"/>
          </el-select>
          <el-input v-model="form.conditionValue" placeholder="条件值" style="width: 25%;margin-left: 5px"/>
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
      },
    },
    disabled: { // 是否禁止
      type: Boolean,
      default: false
    },
    skipConditionShow: { // 是否显示跳转条件
      type: Boolean,
      default: true
    },
  },
  data () {
    return {
      form: this.value,
      attrKey: '',
      field: this.value.field || {},
    }
  },
  watch: {
    form: {
      handler (n) {
        n.skipCondition = "@@" + (n.conditionType ? n.conditionType : '') + "@@|"
          + (n.condition ? n.condition : '') + "@@"
          + (n.conditionType ? n.conditionType : '') + "@@"
          + (n.conditionValue ? n.conditionValue : '')
        this.$emit('change', n)
      },
      deep: true
    }
  },
  created() {
  },
  methods: {
  }
}
</script>

<style scoped>

</style>
