package com.ginyon.common.core.page;

import com.ginyon.common.constant.HttpStatus;

import java.io.Serializable;
import java.util.List;

/**
 * 表格分页数据对象
 *
 * @author zwh
 */
public class TableDataInfo<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    /**
     * 总记录数
     */
    private long total;

    /**
     * 列表数据
     */
    private List<T> rows;

    /**
     * 消息状态码
     */
    private int code;

    /**
     * 消息内容
     */
    private String msg;

    /**
     * 失败
     */
    public static final int FAIL = HttpStatus.ERROR;

    /**
     * 表格数据对象
     */
    public TableDataInfo() {
    }

    /**
     * 分页
     *
     * @param list  列表数据
     * @param total 总记录数
     */
    public TableDataInfo(List<T> list, int total) {
        this.rows = list;
        this.total = total;
    }

    public long getTotal() {
        return total;
    }

    public void setTotal(long total) {
        this.total = total;
    }

    public List<T> getRows() {
        return rows;
    }

    public void setRows(List<T> rows) {
        this.rows = rows;
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }

    public static <T> TableDataInfo<T> fail(String msg) {
        return restResult(null, FAIL, msg);
    }

    public static <T> TableDataInfo<T> fail(List<T> rows) {
        return restResult(rows, FAIL, "操作失败");
    }

    public static <T> TableDataInfo<T> fail(List<T> rows, String msg) {
        return restResult(rows, FAIL, msg);
    }

    public static <T> TableDataInfo<T> fail(int code, String msg) {
        return restResult(null, code, msg);
    }

    private static <T> TableDataInfo<T> restResult(List<T> rows, int code, String msg) {
        TableDataInfo<T> tableDataInfo = new TableDataInfo<>();
        tableDataInfo.setCode(code);
        tableDataInfo.setRows(rows);
        tableDataInfo.setTotal(0);
        tableDataInfo.setMsg(msg);
        return tableDataInfo;
    }
}
