<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="mini" :inline="true" v-show="showSearch" label-width="100px">
      <el-form-item label="标题" prop="title">
        <el-input
          v-model="queryParams.title"
          placeholder="请输入标题"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="发文字号" prop="sendDocNo">
        <el-input
          v-model="queryParams.sendDocNo"
          placeholder="请输入发文字号"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="发文单位" prop="sendDocUnit">
        <el-input
          v-model="queryParams.sendDocUnit"
          placeholder="请输入发文单位"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="发布时间" prop="publishTime">
              <el-date-picker
                 clearable size="small"
                 v-model="queryParams.publishTime"
                 type="date"
                 value-format="yyyy-MM-dd"
                 placeholder="选择发布时间">
              </el-date-picker>
      </el-form-item>
      <el-form-item label="截至日期" prop="deadline">
              <el-date-picker
                 clearable size="small"
                 v-model="queryParams.deadline"
                 type="datetime"
                 value-format="yyyy-MM-dd HH:mm:ss"
                 placeholder="选择截至日期">
              </el-date-picker>
      </el-form-item>
      <el-form-item label="图片" prop="imageId">
        <el-input
          v-model="queryParams.imageId"
          placeholder="请输入图片"
          clearable
          @keyup.enter.native="handleQuery"
        />
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
          v-hasPermi="['test:common:add']"
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
          v-hasPermi="['test:common:edit']"
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
          v-hasPermi="['test:common:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="warning"
          plain
          icon="el-icon-download"
          size="mini"
          @click="handleExport"
          v-hasPermi="['test:common:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table v-loading="loading" :data="commonList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" fixed />
      <el-table-column label="序号" width="50" align="center" key="id" prop="id">
          <template slot-scope="scope">
            <span>{{(queryParams.pageNum - 1) * queryParams.pageSize + scope.$index + 1}}</span>
          </template>
      </el-table-column>
      <el-table-column label="标题" align="center" prop="title" :show-overflow-tooltip="true"/>
      <el-table-column label="级别" align="center" prop="level" :show-overflow-tooltip="true"/>
      <el-table-column label="发文字号" align="center" prop="sendDocNo" :show-overflow-tooltip="true"/>
      <el-table-column label="发文单位" align="center" prop="sendDocUnit" :show-overflow-tooltip="true"/>
        <el-table-column label="发布时间" align="center" prop="publishTime" width="100" sortable="custom" :show-overflow-tooltip="true">
            <template slot-scope="scope">
                <span>{{ parseTime(scope.row.publishTime, '{y}-{m}-{d}') }}</span>
            </template>
        </el-table-column>
        <el-table-column label="截至日期" align="center" prop="deadline" width="160" sortable="custom" :show-overflow-tooltip="true">
            <template slot-scope="scope">
                <span>{{ parseTime(scope.row.deadline) }}</span>
            </template>
        </el-table-column>
      <el-table-column label="标签" align="center" prop="label" :show-overflow-tooltip="true"/>
      <el-table-column label="文章内容" align="center" prop="content" :show-overflow-tooltip="true"/>
      <el-table-column label="金额" align="center" prop="money" :show-overflow-tooltip="true"/>
      <el-table-column label="阅读次数" align="center" prop="views" :show-overflow-tooltip="true"/>
      <el-table-column label="附件" align="center" prop="newfileId" :show-overflow-tooltip="true"/>
      <el-table-column label="图片" align="center" prop="imageId" :show-overflow-tooltip="true"/>
      <el-table-column label="操作" align="center" width="110" fixed="right" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
              size="mini"
              type="text"
              @click="handleDetail(scope.row.id)"
              v-hasPermi="['test:common:detail']"
          >详情</el-button>
          <el-button
            size="mini"
            type="text"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['test:common:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            @click="handleDelete(scope.row)"
            v-hasPermi="['test:common:remove']"
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
  </div>
</template>

<script>
import { listCommon, delCommon } from "@/api/test/common";
import Dialog from "@/views/test/common/dialog";

export default {
  name: "Common",
  components: {
    Dialog
  },
  data() {
    return {
      // 遮罩层
      loading: true,
      // 选中数组
      ids: [],
      // 非单个禁用
      single: true,
      // 非多个禁用
      multiple: true,
      // 显示搜索条件
      showSearch: true,
      // 总条数
      total: 0,
      // 常规演示表格数据
      commonList: [],
      // 查询参数
      queryParams: {
        pageNum: 1,
        pageSize: 10,
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
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询常规演示列表 */
    getList() {
      this.loading = true;
      listCommon(this.queryParams).then(response => {
        this.commonList = response.rows;
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
    /** 删除按钮操作 */
    handleDelete(row) {
      const ids = row.id || this.ids;
      this.$modal.confirm('是否确认删除常规演示编号为"' + ids + '"的数据项？').then(() => {
        this.loading = true;
        return delCommon(ids);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {
        this.loading = false;
      });
    },
    /** 导出按钮操作 */
    handleExport() {
      this.download('test/common/export', {
        ...this.queryParams
      }, `常规演示_${new Date().getTime()}.xlsx`)
    },
  }
};
</script>
