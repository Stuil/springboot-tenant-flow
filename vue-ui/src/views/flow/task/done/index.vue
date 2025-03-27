<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="任务名称" prop="nodeName">
        <el-input
          v-model="queryParams.nodeName"
          placeholder="请输入任务名称"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="流程状态" prop="flowStatus">
        <el-select v-model="queryParams.flowStatus" placeholder="请选择流程状态" clearable>
          <el-option
            v-for="dict in dict.type.flow_status"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="审批人" prop="createBy">
        <el-input
          v-model="queryParams.createBy"
          placeholder="请输入审批人"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="审批时间" prop="createTime">
        <el-date-picker
          clearable size="small"
          v-model="queryParams.createTime"
          type="datetime"
          value-format="yyyy-MM-dd HH:mm:ss"
          placeholder="选择创建时间">
        </el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>
    <el-table :data="instanceList">
      <el-table-column type="selection" width="55" align="center" fixed />
      <el-table-column label="序号" width="55" align="center" key="id" prop="id">
        <template slot-scope="scope">
          {{ scope.$index + 1 }}
        </template>
      </el-table-column>
      <el-table-column label="流程实例id" align="center" prop="instanceId" :show-overflow-tooltip="true"/>
      <el-table-column label="流程名称" align="center" prop="flowName" :show-overflow-tooltip="true"/>
      <el-table-column label="任务名称" align="center" prop="nodeName" :show-overflow-tooltip="true"/>
      <el-table-column label="审批人" align="center" prop="approver" :show-overflow-tooltip="true"/>
      <el-table-column label="流程状态" align="center" prop="flowStatus" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.flow_status" :value="scope.row.flowStatus"/>
        </template>
      </el-table-column>
      <el-table-column label="审批时间" align="center" prop="createTime" width="160" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="110" fixed="right" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            @click="showDoneList(scope.row.instanceId)"
            v-hasPermi="['flow:execute:doneList']"
          >审批记录</el-button>
          <el-button
            size="mini"
            type="text"
            @click="toFlowImage(scope.row.instanceId)"
          >流程图</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageNum"
      :limit.sync="queryParams.pageSize"
      @pagination="getList"
    />
    <el-dialog
      title="流程图"
      :visible.sync="flowChart"
      width="80%">
      <img
        :src="imgUrl"
        width="100%"
        style="margin:0 auto"/>
    </el-dialog>
<!--    <DoneList ref="dialog"></DoneList>-->
  </div>
</template>

<script>
import { donePage } from "@/api/flow/execute";
import {flowImage} from "@/api/flow/definition";


export default {
  name: "Done",
  dicts: ['flow_status'],
  data() {
    return {
      // 选中数组
      ids: [],
      // 显示搜索条件
      showSearch: true,
      flowChart: false,
      imgUrl: "",
      // 总条数
      total: 0,
      // 流程实例表格数据
      instanceList: [],
      todoDetail: null,
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        nodeName: null,
        flowStatus: null,
        createBy: null,
        createTime: null,
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询流程实例列表 */
    getList() {
      donePage(this.queryParams).then(response => {
        this.instanceList = response.rows;
        this.total = response.total;
      });
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 办理按钮操作 */
    showDoneList(instanceId) {
      const params = { disabled: false, pageNum: this.queryParams.pageNum };
      this.$tab.openPage("流程历史记录", '/done/doneList/index/' + instanceId, params);
    },
    toFlowImage(instanceId) {
      flowImage(instanceId).then(response => {
        this.flowChart = true
        this.imgUrl = "data:image/gif;base64," + response.data;
      });
    },
  }
};
</script>
