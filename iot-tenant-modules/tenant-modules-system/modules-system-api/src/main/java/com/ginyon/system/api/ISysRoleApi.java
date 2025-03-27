package com.ginyon.system.api;

import java.util.Set;

/**
 * 角色业务层对外api
 *
 * @author zwh
 */
public interface ISysRoleApi {

    /**
     * 根据用户ID查询角色权限
     *
     * @param userId 用户ID
     * @return 权限列表
     */
    public Set<String> selectRolePermissionByUserId(Long userId);

}
