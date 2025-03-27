package com.ginyon.generator.util;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONObject;
import com.ginyon.common.utils.DateUtils;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.generator.config.GenConfig;
import com.ginyon.generator.constant.GenConstants;
import com.ginyon.generator.domain.GenTable;
import com.ginyon.generator.domain.GenTableColumn;
import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import org.springframework.ui.freemarker.FreeMarkerTemplateUtils;

import java.io.IOException;
import java.util.*;

/**
 * 模板处理工具类
 *
 * @author zwh
 */
public class FreemarkerUtils {
    /**
     * 项目空间路径
     */
    private static final String PROJECT_PATH = "main/java";

    /**
     * mybatis空间路径
     */
    private static final String MYBATIS_PATH = "main/resources/mapper";

    /**
     * 默认上级菜单，系统工具
     */
    private static final String DEFAULT_PARENT_MENU_ID = "3";

    /**
     * 设置模板变量信息
     *
     * @return 模板列表
     */
    public static Map<String, Object> prepareContext(GenTable genTable) {
        String moduleName = genTable.getModuleName();
        String businessName = genTable.getBusinessName();
        String packageName = genTable.getPackageName();
        String tplCategory = genTable.getTplCategory();
        String functionName = genTable.getFunctionName();

        Map<String, Object> contextMap = new HashMap<>();
        contextMap.put("tplCategory", genTable.getTplCategory());
        contextMap.put("tableName", genTable.getTableName());
        contextMap.put("functionName", StringUtils.isNotEmpty(functionName) ? functionName : "【请填写功能名称】");
        contextMap.put("ClassName", genTable.getClassName());
        contextMap.put("className", StringUtils.uncapitalize(genTable.getClassName()));
        contextMap.put("moduleName", genTable.getModuleName());
        contextMap.put("BusinessName", StringUtils.capitalize(genTable.getBusinessName()));
        contextMap.put("businessName", genTable.getBusinessName());
        contextMap.put("basePackage", getPackagePrefix(packageName));
        contextMap.put("packageName", packageName);
        contextMap.put("author", genTable.getFunctionAuthor());
        contextMap.put("datetime", DateUtils.getDate());
        contextMap.put("pkColumn", genTable.getPkColumn());
        contextMap.put("importList", getImportList(genTable));
        contextMap.put("permissionPrefix", getPermissionPrefix(moduleName, businessName));
        contextMap.put("columns", genTable.getColumns());
        contextMap.put("table", genTable);
        contextMap.put("dicts", getDicts(genTable));
        setMenuVelocityContext(contextMap, genTable);
        if (GenConstants.TPL_TREE.equals(tplCategory)) {
            setTreeVelocityContext(contextMap, genTable);
        }
        if (GenConstants.TPL_SUB.equals(tplCategory)) {
            setSubVelocityContext(contextMap, genTable);
        }
        return contextMap;
    }

    public static void setMenuVelocityContext(Map<String, Object> contextMap, GenTable genTable) {
        String options = genTable.getOptions();
        JSONObject paramsObj = JSON.parseObject(options);
        String parentMenuId = getParentMenuId(paramsObj);
        contextMap.put("parentMenuId", parentMenuId);
    }

    public static void setTreeVelocityContext(Map<String, Object> contextMap, GenTable genTable) {
        String options = genTable.getOptions();
        JSONObject paramsObj = JSON.parseObject(options);
        String treeCode = getTreecode(paramsObj);
        String treeParentCode = getTreeParentCode(paramsObj);
        String treeName = getTreeName(paramsObj);

        contextMap.put("treeCode", treeCode);
        contextMap.put("treeParentCode", treeParentCode);
        contextMap.put("treeName", treeName);
        contextMap.put("expandColumn", getExpandColumn(genTable));
        if (paramsObj.containsKey(GenConstants.TREE_PARENT_CODE)) {
            contextMap.put("tree_parent_code", paramsObj.getString(GenConstants.TREE_PARENT_CODE));
        }
        if (paramsObj.containsKey(GenConstants.TREE_NAME)) {
            contextMap.put("tree_name", paramsObj.getString(GenConstants.TREE_NAME));
        }
    }

    public static void setSubVelocityContext(Map<String, Object> contextMap, GenTable genTable) {
        GenTable subTable = genTable.getSubTable();
        String subTableName = genTable.getSubTableName();
        String subTableFkName = genTable.getSubTableFkName();
        String subClassName = genTable.getSubTable().getClassName();
        String subTableFkClassName = StringUtils.convertToCamelCase(subTableFkName);

        contextMap.put("subTable", subTable);
        contextMap.put("subTableName", subTableName);
        contextMap.put("subTableFkName", subTableFkName);
        contextMap.put("subTableFkClassName", subTableFkClassName);
        contextMap.put("subTableFkclassName", StringUtils.uncapitalize(subTableFkClassName));
        contextMap.put("subClassName", subClassName);
        contextMap.put("subclassName", StringUtils.uncapitalize(subClassName));
        contextMap.put("subImportList", getImportList(genTable.getSubTable()));
    }

    /**
     * 获取模板信息
     *
     * @return 模板列表
     */
    public static List<String> getTemplateList(String tplCategory) {
        List<String> templates = new ArrayList<String>();
        templates.add("templates/java/domain.java.ftlh");
        templates.add("templates/java/mapper.java.ftlh");
        templates.add("templates/java/service.java.ftlh");
        templates.add("templates/java/serviceImpl.java.ftlh");
        templates.add("templates/java/controller.java.ftlh");
        templates.add("templates/xml/mapper.xml.ftlh");
        templates.add("templates/sql/sql.ftlh");
        templates.add("templates/js/api.js.ftlh");
        if (GenConstants.TPL_CRUD.equals(tplCategory)) {
            templates.add("templates/vue/index.vue.ftlh");
            templates.add("templates/vue/dialog.vue.ftlh");
            if (GenConstants.FLOW_ENABLE_Y.equals(GenConfig.getFlowEnable())) {
                templates.add("templates/vue/approve.vue.ftlh");
            }
        } else if (GenConstants.TPL_TREE.equals(tplCategory)) {
            templates.add("templates/vue/index-tree.vue.ftlh");
        } else if (GenConstants.TPL_SUB.equals(tplCategory)) {
            templates.add("templates/vue/index.vue.ftlh");
            templates.add("templates/vue/dialog.vue.ftlh");
            if (GenConstants.FLOW_ENABLE_Y.equals(GenConfig.getFlowEnable())) {
                templates.add("templates/vue/approve.vue.ftlh");
            }
            templates.add("templates/java/sub-domain.java.ftlh");
            templates.add("templates/java/sub-mapper.java.ftlh");
            templates.add("templates/java/sub-service.java.ftlh");
            templates.add("templates/java/sub-serviceImpl.java.ftlh");
            templates.add("templates/xml/sub-mapper.xml.ftlh");
        }
        return templates;
    }

    /**
     * 获取文件名
     */
    public static String getFileName(String template, GenTable genTable) {
        // 文件名称
        String fileName = "";
        // 包路径
        String packageName = genTable.getPackageName();
        // 模块名
        String moduleName = genTable.getModuleName();
        // 大写类名
        String className = genTable.getClassName();
        // 业务名称
        String businessName = genTable.getBusinessName();

        String javaPath = PROJECT_PATH + "/" + StringUtils.replace(packageName, ".", "/");
        String mybatisPath = MYBATIS_PATH + "/" + moduleName;
        String vuePath = "vue";

        String[] split = template.split("/");
        template = split[split.length - 1];
        if (template.equals("domain.java.ftlh")) {
            fileName = StringUtils.format("{}/domain/{}.java", javaPath, className);
        }
        if (template.equals("sub-domain.java.ftlh") && StringUtils.equals(GenConstants.TPL_SUB, genTable.getTplCategory())) {
            fileName = StringUtils.format("{}/domain/{}.java", javaPath, genTable.getSubTable().getClassName());
        } else if (template.equals("mapper.java.ftlh")) {
            fileName = StringUtils.format("{}/mapper/{}Mapper.java", javaPath, className);
        } else if (template.equals("sub-mapper.java.ftlh") && StringUtils.equals(GenConstants.TPL_SUB, genTable.getTplCategory())) {
            fileName = StringUtils.format("{}/mapper/{}Mapper.java", javaPath, genTable.getSubTable().getClassName());
        } else if (template.equals("service.java.ftlh")) {
            fileName = StringUtils.format("{}/service/I{}Service.java", javaPath, className);
        } else if (template.equals("sub-service.java.ftlh") && StringUtils.equals(GenConstants.TPL_SUB, genTable.getTplCategory())) {
            fileName = StringUtils.format("{}/service/I{}Service.java", javaPath, genTable.getSubTable().getClassName());
        } else if (template.equals("serviceImpl.java.ftlh")) {
            fileName = StringUtils.format("{}/service/impl/{}ServiceImpl.java", javaPath, className);
        } else if (template.equals("sub-serviceImpl.java.ftlh") && StringUtils.equals(GenConstants.TPL_SUB, genTable.getTplCategory())) {
            fileName = StringUtils.format("{}/service/impl/{}ServiceImpl.java", javaPath, genTable.getSubTable().getClassName());
        } else if (template.equals("controller.java.ftlh")) {
            fileName = StringUtils.format("{}/controller/{}Controller.java", javaPath, className);
        } else if (template.equals("mapper.xml.ftlh")) {
            fileName = StringUtils.format("{}/{}Mapper.xml", mybatisPath, className);
        } else if (template.equals("sub-mapper.xml.ftlh") && StringUtils.equals(GenConstants.TPL_SUB, genTable.getTplCategory())) {
            fileName = StringUtils.format("{}/{}Mapper.xml", mybatisPath, genTable.getSubTable().getClassName());
        } else if (template.equals("sql.ftlh")) {
            fileName = businessName + "Menu.sql";
        } else if (template.equals("api.js.ftlh")) {
            fileName = StringUtils.format("{}/api/{}/{}.js", vuePath, moduleName, businessName);
        } else if (template.equals("index.vue.ftlh")) {
            fileName = StringUtils.format("{}/views/{}/{}/index.vue", vuePath, moduleName, businessName);
        } else if (template.equals("approve.vue.ftlh")) {
            fileName = StringUtils.format("{}/views/{}/{}/approve.vue", vuePath, moduleName, businessName);
        } else if (template.equals("dialog.vue.ftlh")) {
            fileName = StringUtils.format("{}/views/{}/{}/dialog.vue", vuePath, moduleName, businessName);
        } else if (template.equals("index-tree.vue.ftlh")) {
            fileName = StringUtils.format("{}/views/{}/{}/index.vue", vuePath, moduleName, businessName);
        }
        return fileName;
    }

    /**
     * 获取包前缀
     *
     * @param packageName 包名称
     * @return 包前缀名称
     */
    public static String getPackagePrefix(String packageName) {
        int lastIndex = packageName.lastIndexOf(".");
        return StringUtils.substring(packageName, 0, lastIndex);
    }

    /**
     * 根据列类型获取导入包
     *
     * @param genTable 业务表对象
     * @return 返回需要导入的包列表
     */
    public static HashSet<String> getImportList(GenTable genTable) {
        List<GenTableColumn> columns = genTable.getColumns();
        GenTable subGenTable = genTable.getSubTable();
        HashSet<String> importList = new HashSet<String>();
        if (StringUtils.isNotNull(subGenTable)) {
            importList.add("java.util.List");
        }
        for (GenTableColumn column : columns) {
            if (!column.isSuperColumn() && GenConstants.TYPE_DATE.equals(column.getJavaType())) {
                importList.add("java.util.Date");
                importList.add("com.fasterxml.jackson.annotation.JsonFormat");
            } else if (!column.isSuperColumn() && GenConstants.TYPE_BIGDECIMAL.equals(column.getJavaType())) {
                importList.add("java.math.BigDecimal");
            }
        }
        return importList;
    }

    /**
     * 根据列类型获取字典组
     *
     * @param genTable 业务表对象
     * @return 返回字典组
     */
    public static Set<String> getDicts(GenTable genTable) {
        List<GenTableColumn> columns = genTable.getColumns();
        Set<String> dicts = new HashSet<String>();
        addDicts(dicts, columns);
        if (StringUtils.isNotNull(genTable.getSubTable())) {
            List<GenTableColumn> subColumns = genTable.getSubTable().getColumns();
            addDicts(dicts, subColumns);
        }
        return dicts;
    }

    /**
     * 添加字典列表
     *
     * @param dicts   字典列表
     * @param columns 列集合
     */
    public static void addDicts(Set<String> dicts, List<GenTableColumn> columns) {
        for (GenTableColumn column : columns) {
            if (!column.isSuperColumn() && StringUtils.isNotEmpty(column.getDictType()) && StringUtils.equalsAny(
                    column.getHtmlType(),
                    new String[]{GenConstants.HTML_SELECT, GenConstants.HTML_RADIO, GenConstants.HTML_CHECKBOX})) {
                dicts.add(column.getDictType());
            }
        }
    }

    /**
     * 获取权限前缀
     *
     * @param moduleName   模块名称
     * @param businessName 业务名称
     * @return 返回权限前缀
     */
    public static String getPermissionPrefix(String moduleName, String businessName) {
        return StringUtils.format("{}:{}", moduleName, businessName);
    }

    /**
     * 获取上级菜单ID字段
     *
     * @param paramsObj 生成其他选项
     * @return 上级菜单ID字段
     */
    public static String getParentMenuId(JSONObject paramsObj) {
        if (StringUtils.isNotEmpty(paramsObj) && paramsObj.containsKey(GenConstants.PARENT_MENU_ID)
                && StringUtils.isNotEmpty(paramsObj.getString(GenConstants.PARENT_MENU_ID))) {
            return paramsObj.getString(GenConstants.PARENT_MENU_ID);
        }
        return DEFAULT_PARENT_MENU_ID;
    }

    /**
     * 获取树编码
     *
     * @param paramsObj 生成其他选项
     * @return 树编码
     */
    public static String getTreecode(JSONObject paramsObj) {
        if (paramsObj.containsKey(GenConstants.TREE_CODE)) {
            return StringUtils.toCamelCase(paramsObj.getString(GenConstants.TREE_CODE));
        }
        return StringUtils.EMPTY;
    }

    /**
     * 获取树父编码
     *
     * @param paramsObj 生成其他选项
     * @return 树父编码
     */
    public static String getTreeParentCode(JSONObject paramsObj) {
        if (paramsObj.containsKey(GenConstants.TREE_PARENT_CODE)) {
            return StringUtils.toCamelCase(paramsObj.getString(GenConstants.TREE_PARENT_CODE));
        }
        return StringUtils.EMPTY;
    }

    /**
     * 获取树名称
     *
     * @param paramsObj 生成其他选项
     * @return 树名称
     */
    public static String getTreeName(JSONObject paramsObj) {
        if (paramsObj.containsKey(GenConstants.TREE_NAME)) {
            return StringUtils.toCamelCase(paramsObj.getString(GenConstants.TREE_NAME));
        }
        return StringUtils.EMPTY;
    }

    /**
     * 获取需要在哪一列上面显示展开按钮
     *
     * @param genTable 业务表对象
     * @return 展开按钮列序号
     */
    public static int getExpandColumn(GenTable genTable) {
        String options = genTable.getOptions();
        JSONObject paramsObj = JSON.parseObject(options);
        String treeName = paramsObj.getString(GenConstants.TREE_NAME);
        int num = 0;
        for (GenTableColumn column : genTable.getColumns()) {
            if (column.isList()) {
                num++;
                String columnName = column.getColumnName();
                if (columnName.equals(treeName)) {
                    break;
                }
            }
        }
        return num;
    }

    /**
     * 模板文件的Template和表数据进行渲染，返回新生成文件的字符串
     *
     * @param contextMap
     * @param template
     * @param freemaker
     * @return
     * @throws IOException
     * @throws TemplateException
     */
    public static String getContentString(Configuration freemaker, Map<String, Object> contextMap, String template) throws IOException, TemplateException {
        // 获取根据模板文件路径获取Template
        Template templete = freemaker.getTemplate(template);
        // 渲染模板
        return FreeMarkerTemplateUtils.processTemplateIntoString(templete, contextMap);
    }
}
