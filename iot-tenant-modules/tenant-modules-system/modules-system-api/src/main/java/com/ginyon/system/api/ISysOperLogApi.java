package com.ginyon.system.api;

import com.ginyon.system.api.domain.SysOperLog;

/**
 * 操作日志 对外api服务层
 *
 * @author zwh
 */
public interface ISysOperLogApi {
    /**
     * 新增操作日志
     *
     * @param operLog 操作日志对象
     */
    public void insertOperlog(SysOperLog operLog);

}
