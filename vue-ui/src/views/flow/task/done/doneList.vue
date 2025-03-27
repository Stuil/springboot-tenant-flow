<template>
  <div class="app-container">
    <el-table :data="taskList">
      <el-table-column label="序号" width="50" align="center" key="id" prop="id">
        <template slot-scope="scope">
          {{ scope.$index + 1 }}
        </template>
      </el-table-column>
      <el-table-column label="开始节点名称" align="center" prop="nodeName" :show-overflow-tooltip="true"/>
      <el-table-column label="结束节点名称" align="center" prop="targetNodeName" :show-overflow-tooltip="true"/>
      <el-table-column label="审批人" align="center" prop="approver" :show-overflow-tooltip="true"/>
      <el-table-column label="流程状态" align="center" prop="flowStatus" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.flow_status" :value="scope.row.flowStatus"/>
        </template>
      </el-table-column>
      <el-table-column label="审批意见" align="center" prop="message" :show-overflow-tooltip="true"/>
      <el-table-column label="创建时间" align="center" prop="createTime" width="160" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>

import { doneList } from '@/api/flow/execute'

export default {
  name: "DoneList",
  dicts: ['flow_status'],
  data() {
    return {
      instanceId: "",
      // 历史任务记录表格数据
      taskList: [],
    };
  },
  created() {
    this.instanceId = this.$route.params && this.$route.params.instanceId;
    doneList(this.instanceId).then(response => {
      this.taskList = response.data;
    });
  },
};
</script>
