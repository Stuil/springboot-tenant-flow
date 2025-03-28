<template>
  <div class="app-container">
    <el-form :model="queryParams" ref="queryForm" size="small" :inline="true" v-show="showSearch" label-width="68px">
      <el-form-item label="父id" prop="parentId">
        <el-input
          v-model="queryParams.parentId"
          placeholder="请输入父id"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="值" prop="treeName">
        <el-input
          v-model="queryParams.treeName"
          placeholder="请输入值"
          clearable
          @keyup.enter.native="handleQuery"
        />
      </el-form-item>
      <el-form-item label="版本" prop="version">
        <el-input
          v-model="queryParams.version"
          placeholder="请输入版本"
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
          v-hasPermi="['test:tree:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="info"
          plain
          icon="el-icon-sort"
          size="mini"
          @click="toggleExpandAll"
        >展开/折叠</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <el-table
      v-if="refreshTable"
      v-loading="loading"
      :data="treeList"
      row-key="id"
      :default-expand-all="isExpandAll"
      :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
    >
      <el-table-column label="父id" prop="parentId"  :show-overflow-tooltip="true"/>
      <el-table-column label="值" align="center" prop="treeName"  :show-overflow-tooltip="true"/>
      <el-table-column label="版本" align="center" prop="version"  :show-overflow-tooltip="true"/>
      <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
              size="mini"
              type="text"
              @click="handleDetail(scope.row)"
              v-hasPermi="['test:tree:detail']"
          >详情</el-button>
          <el-button
            size="mini"
            type="text"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['test:tree:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            @click="handleAdd(scope.row)"
            v-hasPermi="['test:tree:add']"
          >新增</el-button>
          <el-button
            size="mini"
            type="text"
            @click="handleDelete(scope.row)"
            v-hasPermi="['test:tree:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 添加或修改测试树对话框 -->
    <el-dialog :title="title" :visible.sync="open" width="800px" v-if="open" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="100px"  :disabled="disabled">
        <el-row>
          <el-col :span="12">
        <el-form-item label="父id" prop="parentId">
          <treeselect v-model="form.parentId" :options="treeOptions" :normalizer="normalizer" placeholder="请选择父id"
                      :disabled="disabled"/>
        </el-form-item>
          </el-col>
          <el-col :span="12">
        <el-form-item label="值" prop="treeName">
          <el-input v-model="form.treeName" placeholder="请输入值" />
        </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :span="12">
        <el-form-item label="版本" prop="version">
          <el-input v-model="form.version" placeholder="请输入版本" />
        </el-form-item>
          </el-col>
        </el-row>
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
import { listTree, getTree, delTree, addTree, updateTree } from "@/api/test/tree";
import Treeselect from "@riophae/vue-treeselect";
import "@riophae/vue-treeselect/dist/vue-treeselect.css";

export default {
  name: "Tree",
  components: {
    Treeselect
  },
  data() {
    return {
      // 遮罩层
      loading: true,
      // 显示搜索条件
      showSearch: true,
      // 测试树表格数据
      treeList: [],
      // 测试树树选项
      treeOptions: [],
      // 弹出层标题
      title: "",
      // 是否显示弹出层
      open: false,
      // 是否禁用表单
      disabled: false,
      // 是否展开，默认全部展开
      isExpandAll: true,
      // 重新渲染表格状态
      refreshTable: true,
      // 查询参数
      queryParams: {
        parentId: null,
        treeName: null,
        version: null,
      },
      // 表单参数
      form: {},
      // 表单校验
      rules: {
      }
    };
  },
  created() {
    this.getList();
  },
  methods: {
    /** 查询测试树列表 */
    getList() {
      this.loading = true;
      listTree(this.queryParams).then(response => {
        this.treeList = this.handleTree(response.data, "id", "parentId");
        this.loading = false;
      });
    },
    /** 转换测试树数据结构 */
    normalizer(node) {
      if (node.children && !node.children.length) {
        delete node.children;
      }
      return {
        id: node.id,
        label: node.treeName,
        children: node.children
      };
    },
	/** 查询测试树下拉树结构 */
    getTreeselect() {
      listTree().then(response => {
        this.treeOptions = [];
        const data = { id: 0, treeName: '顶级节点', children: [] };
        data.children = this.handleTree(response.data, "id", "parentId");
        this.treeOptions.push(data);
      });
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
        parentId: null,
        treeName: null,
        version: null,
        createTime: null,
        createBy: null,
        updateTime: null,
        updateBy: null,
        delFlag: null
      };
      this.resetForm("form");
    },
    /** 搜索按钮操作 */
    handleQuery() {
      this.getList();
    },
    /** 重置按钮操作 */
    resetQuery() {
      this.resetForm("queryForm");
      this.handleQuery();
    },
    /** 新增按钮操作 */
    handleAdd(row) {
      this.reset();
      this.getTreeselect();
      if (row != null && row.id) {
        this.form.parentId = row.id;
      } else {
        this.form.parentId = 0;
      }
      this.open = true;
      this.disabled = false;
      this.title = "添加测试树";
    },
    /** 展开/折叠操作 */
    toggleExpandAll() {
      this.refreshTable = false;
      this.isExpandAll = !this.isExpandAll;
      this.$nextTick(() => {
        this.refreshTable = true;
      });
    },
    /** 详情按钮操作 */
    handleDetail(row) {
      this.reset();
      this.getTreeselect();
      if (row != null) {
        this.form.parentId = row.id;
      }
      getTree(row.id).then(response => {
        this.form = response.data;
        this.open = true;
        this.disabled = true;
        this.title = "详情测试树";
      });
    },
    /** 修改按钮操作 */
    handleUpdate(row) {
      this.reset();
      this.getTreeselect();
      if (row != null) {
        this.form.parentId = row.id;
      }
      getTree(row.id).then(response => {
        this.form = response.data;
        this.open = true;
        this.disabled = false;
        this.title = "修改测试树";
      });
    },
    /** 提交按钮 */
    submitForm() {
      this.$refs["form"].validate(valid => {
        if (valid) {
          if (this.form.id != null) {
            updateTree(this.form).then(response => {
              this.$modal.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          } else {
            addTree(this.form).then(response => {
              this.$modal.msgSuccess("新增成功");
              this.open = false;
              this.getList();
            });
          }
        }
      });
    },
    /** 删除按钮操作 */
    handleDelete(row) {
      this.$modal.confirm('是否确认删除测试树编号为"' + row.id + '"的数据项？').then(function() {
        return delTree(row.id);
      }).then(() => {
        this.getList();
        this.$modal.msgSuccess("删除成功");
      }).catch(() => {});
    },
  }
};
</script>
