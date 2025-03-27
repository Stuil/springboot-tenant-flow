package com.ginyon.system.api;

import java.util.Set;

/**
 * 菜单 对外api业务层
 *
 * @author zwh
 */
public interface ISysMenuApi {

    /**
     * 根据用户ID查询权限
     *
     * @param userId 用户ID
     * @return 权限列表
     */
    public Set<String> selectMenuPermsByUserId(Long userId);

    /**
     * 根据角色ID查询权限
     *
     * @param roleId 角色ID
     * @return 权限列表
     */
    public Set<String> selectMenuPermsByRoleId(Long roleId);

}
