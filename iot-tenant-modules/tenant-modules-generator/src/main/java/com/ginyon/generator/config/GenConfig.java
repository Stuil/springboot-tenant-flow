package com.ginyon.generator.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Component;

/**
 * 读取代码生成相关配置
 *
 * @author zwh
 */
@Component
@ConfigurationProperties(prefix = "gen")
@PropertySource(value = {"classpath:generator.yml"})
public class GenConfig {
    /**
     * 作者
     */
    public static String author;

    /**
     * 生成包路径
     */
    public static String packageName;

    /**
     * 自动去除表前缀，默认是false
     */
    public static boolean autoRemovePre;

    /**
     * 表前缀(类名不会包含表前缀)
     */
    public static String tablePrefix;

    /**
     * 是否显示两列
     */
    public static String twoColumn;

    /**
     * 是否是否生成swagger
     */
    public static String swaggerEnable;

    /**
     * 是否导出
     */
    public static String exportEnable;

    /**
     * 是否需要审批流
     */
    public static String flowEnable;

    public static String getAuthor() {
        return author;
    }

    @Value("${author}")
    public void setAuthor(String author) {
        GenConfig.author = author;
    }

    public static String getPackageName() {
        return packageName;
    }

    @Value("${packageName}")
    public void setPackageName(String packageName) {
        GenConfig.packageName = packageName;
    }

    public static boolean getAutoRemovePre() {
        return autoRemovePre;
    }

    @Value("${autoRemovePre}")
    public void setAutoRemovePre(boolean autoRemovePre) {
        GenConfig.autoRemovePre = autoRemovePre;
    }

    public static String getTablePrefix() {
        return tablePrefix;
    }

    @Value("${tablePrefix}")
    public void setTablePrefix(String tablePrefix) {
        GenConfig.tablePrefix = tablePrefix;
    }

    public static String getTwoColumn() {
        return twoColumn;
    }

    @Value("${twoColumn}")
    public void setTwoColumn(String twoColumn) {
        GenConfig.twoColumn = twoColumn;
    }

    public static String getSwaggerEnable() {
        return swaggerEnable;
    }

    @Value("${swaggerEnable}")
    public void setSwaggerEnable(String swaggerEnable) {
        GenConfig.swaggerEnable = swaggerEnable;
    }

    public static String getExportEnable() {
        return exportEnable;
    }

    @Value("${exportEnable}")
    public void setExportEnable(String exportEnable) {
        GenConfig.exportEnable = exportEnable;
    }

    public static String getFlowEnable() {
        return flowEnable;
    }

    @Value("${flowEnable}")
    public void setFlowEnable(String flowEnable) {
        GenConfig.flowEnable = flowEnable;
    }
}
