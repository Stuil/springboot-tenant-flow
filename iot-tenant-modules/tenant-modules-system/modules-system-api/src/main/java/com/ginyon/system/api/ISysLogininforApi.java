package com.ginyon.system.api;

import com.ginyon.system.api.domain.SysLogininfor;

/**
 * 系统访问日志情况信息 对外api服务层
 *
 * @author zwh
 */
public interface ISysLogininforApi {
    /**
     * 新增系统登录日志
     *
     * @param logininfor 访问日志对象
     */
    public void insertLogininfor(SysLogininfor logininfor);

}
