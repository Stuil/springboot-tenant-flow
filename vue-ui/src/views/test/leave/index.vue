<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="请假类型" prop="type">
        <el-select v-model="queryParams.type" placeholder="请选择请假类型" clearable>
          <el-option
            v-for="dict in dict.type.leave_type"
            :key="dict.value"
            :label="dict.label"
            :value="dict.value"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="请假天数" prop="day">
        <el-input
          v-model="queryParams.day"
          placeholder="请输入请假天数"
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
      <el-form-item label="创建者" prop="createBy">
        <el-input
          v-model="queryParams.createBy"
          placeholder="请输入创建者"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="创建时间">
        <el-date-picker
          v-model="daterangeCreateTime"
          size="small"
          value-format="yyyy-MM-dd HH:mm:ss"
          type="datetimerange"
          range-separator="-"
          start-placeholder="开始日期"
          end-placeholder="结束日期"
        ></el-date-picker>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['test:leave:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['test:leave:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="danger"
          plain
          icon="el-icon-delete"
          size="mini"
          :disabled="multiple"
          @click="handleDelete"
          v-hasPermi="['test:leave:remove']"
        >删除</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="leaveList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" fixed />
      <el-table-column label="序号" width="50" align="center" key="id" prop="id">
        <template slot-scope="scope">
          <span>{{(queryParams.pageNum - 1) * queryParams.pageSize + scope.$index + 1}}</span>
        </template>
      </el-table-column>
      <el-table-column label="请假类型" align="center" prop="type" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.leave_type" :value="scope.row.type"/>
        </template>
      </el-table-column>
      <el-table-column label="开始时间" align="center" prop="startTime" width="160" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.startTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="结束时间" align="center" prop="endTime" width="160" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.endTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="请假天数" align="center" prop="day" :show-overflow-tooltip="true"/>
      <el-table-column label="流程节点名称" align="center" prop="nodeName" :show-overflow-tooltip="true"/>
      <el-table-column label="流程状态" align="center" prop="flowStatus" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <dict-tag :options="dict.type.flow_status" :value="scope.row.flowStatus"/>
        </template>
      </el-table-column>
      <el-table-column label="创建者" align="center" prop="createBy" :show-overflow-tooltip="true"/>
      <el-table-column label="创建时间" align="center" prop="createTime" width="160" :show-overflow-tooltip="true">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.createTime) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="200" fixed="right" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            @click="handleDetail(scope.row.id)"
            v-hasPermi="['test:leave:detail']"
          >详情</el-button>
          <el-button
            size="mini"
            type="text"
            v-if="scope.row.nodeCode === '2'"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['test:leave:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            v-if="scope.row.nodeCode === '2'"
            @click="handleSubmit(scope.row.id)"
            v-hasPermi="['test:leave:submit']"
          >提交审批</el-button>
          <el-button
            size="mini"
            type="text"
            @click="toFlowImage(scope.row.instanceId)"
          >流程图</el-button>
          <el-button
            size="mini"
            type="text"
            v-if="scope.row.nodeCode === '2'"
            @click="handleDelete(scope.row)"
            v-hasPermi="['test:leave:remove']"
          >删除</el-button>
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
    <Dialog ref="dialog" @refresh="getList"></Dialog>

    <el-dialog title="流程图" :visible.sync="flowChart" width="80%">
      <img :src="imgUrl" width="100%" style="margin:0 auto"/>
    </el-dialog>
  </div>
</template>

<script>
import { listLeave, delLeave, submit } from "@/api/test/leave";
import Dialog from "@/views/test/leave/dialog";
import {flowImage} from "@/api/flow/definition";

export default {
  name: "Leave",
  dicts: ['flow_status','leave_type'],
  components: {
    Dialog
  },
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      flowChart: false,
      imgUrl: "",
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // OA 请假申请表格数据
      leaveList: [],
      // 删除标志时间范围
      daterangeCreateTime: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
        type: null,
        day: null,
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
    /** 查询OA 请假申请列表 */
    getList() {
      this.loading = true;
      this.queryParams.paramsStr = "";
      if (null != this.daterangeCreateTime && '' != this.daterangeCreateTime) {
        this.queryParams.paramsStr =
          JSON.stringify({
            "beginCreateTime": this.daterangeCreateTime[0],
            "endCreateTime": this.daterangeCreateTime[1]
          });
      }
      listLeave(this.queryParams).then(response => {
        this.leaveList = response.rows;
        this.total = response.total;
        this.loading = false;
      });
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.queryParams.pageNum = 1;
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.daterangeCreateTime = [];
      this.resetForm("queryForm");
      this.handleQuery();
    },
    // 多选框选中数据
    handleSelectionChange(selection) {
      this.ids = selection.map(item => item.id)
      this.single = selection.length!==1
      this.multiple = !selection.length
    },
    /** 新增按钮操作 */
    handleAdd() {
      this.$refs.dialog.show();
    },
    /** 详情按钮操作 */
    handleDetail(id) {
      this.$refs.dialog.show(id, true);
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      const id = row.id || this.ids
      this.$refs.dialog.show(id);
    },

    /** 提交审批按钮操作 */
    handleSubmit(id){
      this.$modal.confirm('你确定提交审批吗').then(function() {
        return submit(id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("提交审批成功");
      }).catch(() => {});
    },
    toFlowImage(instanceId) {
      flowImage(instanceId).then(response => {
        this.flowChart = true
        this.imgUrl = "data:image/gif;base64," + response.data;
      });
    },

    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除OA 请假申请编号为"' + ids + '"的数据项？').then(function() {
        return delLeave(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
  }
};
</script>
