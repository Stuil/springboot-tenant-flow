<template>
  <div>
    <el-drawer
      ref="drawer"
      :title="title"
      destroy-on-close
      :visible.sync="drawer"
      direction="rtl"
      :append-to-body="true"
      :before-close="handleClose">
      <component :is="node?node.type:''" v-model="form" :disabled="disabled" :skipConditionShow="skipConditionShow">
        <template v-slot:[key]="data" v-for="(item, key) in $scopedSlots">
          <slot :name="key" v-bind="data || {}"></slot>
        </template>
      </component>
    </el-drawer>
  </div>
</template>

<script>
import Start from './start.vue'
import Between from './between.vue'
import Serial from './serial.vue'
import Parallel from './parallel.vue'
import End from './end.vue'
import Skip from './skip.vue'
import {skipText} from "@/components/WarmFlow/js/tool";

export default {
  components: {
    Start,
    Between,
    Serial,
    Parallel,
    End,
    Skip,
  },
  props: {
    value: {
      type: Object,
      default () {
        return {}
      }
    },
    node: {
      type: Object,
      default () {
        return {}
      }
    },
    lf: {
      type: Object,
      default () {
        return null
      }
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
      drawer: false,
      form: {},
      objId: undefined,
    }
  },
  watch: {
    node (n) {
      if (n) {
        this.objId = n.id
        let skipCondition = n.properties.skipCondition
        let conditionSpl = skipCondition ? skipCondition.split('@@|') : []
        let conditionSplTwo = conditionSpl && conditionSpl.length > 0 ? conditionSpl[1]: []
        if (n.type === 'skip') {
          this.form = {
            nodeType: n.type,
            skipType: n.properties.skipType,
            skipName: n.properties.skipName,
            skipCondition: skipCondition,
            condition: conditionSplTwo && conditionSplTwo.length > 0 ? conditionSplTwo.split("@@")[0] : '',
            conditionType: conditionSplTwo && conditionSplTwo.length > 0 ? conditionSplTwo.split("@@")[1] : '',
            conditionValue: conditionSplTwo && conditionSplTwo.length > 0 ? conditionSplTwo.split("@@")[2] : '',
          }
        } else {
          this.form = {
            nodeType: n.type,
            nodeCode: n.id,
            nodeName: n.text instanceof Object ? n.text.value : n.text,
            ...n.properties,
          }
        }
      }
    },
    'form.nodeCode' (n, o) {
      // 监听节点编码变量并更新
      if (n && o) {
        if (['skip'].includes(this.node.type)) {
          if (!this.lf.getEdgeModelById(n)) {
            this.lf.changeEdgeId(o, n)
          }
        } else {
          if (!this.lf.getNodeModelById(n)) {
            this.lf.changeNodeId(o, n)
          }
        }
        this.objId = n
      }
    },
    'form.skipType' (n) {
      // 监听跳转属性变化并更新
      this.lf.setProperties(this.objId, {
        skipType: n
      })
    },
    'form.nodeName' (n) {
      // 监听节点名称变化并更新
      this.lf.updateText(this.objId, n)
      // 监听节点名称变化并更新
      this.lf.setProperties(this.objId, {
        nodeName: n
      })
    },
    'form.permissionFlag' (n) {
      // 监听节点属性变化并更新
      if (n instanceof  Array) {
        this.lf.setProperties(this.objId, {
          permissionFlag: n.join()
        })
      } else {
        this.lf.setProperties(this.objId, {
          permissionFlag: n
        })
      }
    },
    'form.skipAnyNode' (n) {
      // 监听跳转属性变化并更新
      this.lf.setProperties(this.objId, {
        skipAnyNode: n
      })
    },
    'form.skipCondition' (n) {
      // 监听跳转属性变化并更新
      this.lf.setProperties(this.objId, {
        skipCondition: n
      })
    },
    'form.skipName' (n) {
      if (['skip'].includes(this.node.type)) {
        debugger
        // 监听跳转名称变化并更新
        this.lf.updateText(this.objId, n)
        // 监听跳转属性变化并更新
        this.lf.setProperties(this.objId, {
          skipName: n
        })
      }
    },
  },
  created() {

  },
  computed: {
    title () {
      if (this.node && this.node.type === 'skip') {
        return '设置边属性'
      } else if (this.node && this.node.type === 'serial') {
        return '设置串行网关属性'
      } else if (this.node && this.node.type === 'parallel') {
        return '设置并行网关属性'
      } else if (this.node && this.node.type === 'start') {
        return '设置开始属性'
      } else if (this.node && this.node.type === 'end') {
        return '设置结束属性'
      }
      return '设置中间属性'
    }
  },
  methods: {
    show () {
      this.drawer = true
    },
    handleClose () {
      this.drawer = false
    }
  }
}
</script>

<style scoped>
.el-drawer__container ::-webkit-scrollbar {
  display: none;
}
</style>
