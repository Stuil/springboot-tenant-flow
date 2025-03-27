package com.ginyon.system.api;

import com.ginyon.system.api.domain.SysUser;

/**
 * 用户 对外api业务层
 *
 * @author zwh
 */
public interface ISysUserApi {

    /**
     * 通过用户ID查询用户
     *
     * @param userId 用户ID
     * @return 用户对象信息
     */
    public SysUser selectUserById(Long userId);

}
