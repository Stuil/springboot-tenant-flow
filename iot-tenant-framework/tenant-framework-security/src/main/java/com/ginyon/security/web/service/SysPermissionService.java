package com.ginyon.security.web.service;

import com.ginyon.common.constant.UserConstants;
import com.ginyon.satoken.helper.LoginHelper;
import com.ginyon.system.api.ISysMenuApi;
import com.ginyon.system.api.ISysRoleApi;
import com.ginyon.system.api.domain.SysRole;
import com.ginyon.system.api.domain.SysUser;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import javax.annotation.Resource;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

/**
 * 用户权限处理
 *
 * @author zwh
 */
@Component
public class SysPermissionService {
    @Resource
    private ISysRoleApi roleService;

    @Resource
    private ISysMenuApi menuService;

    /**
     * 获取角色数据权限
     *
     * @param user 用户信息
     * @return 角色权限信息
     */
    public Set<String> getRolePermission(SysUser user) {
        Set<String> roles = new HashSet<String>();
        // 管理员拥有所有权限
        if (LoginHelper.isSuperAdmin(user.getUserId())) {
            roles.add(UserConstants.SUPER_ADMIN);
        } else {
            roles.addAll(roleService.selectRolePermissionByUserId(user.getUserId()));
        }
        return roles;
    }

    /**
     * 获取菜单数据权限
     *
     * @param user 用户信息
     * @return 菜单权限信息
     */
    public Set<String> getMenuPermission(SysUser user) {
        Set<String> perms = new HashSet<String>();
        // 管理员拥有所有权限
        if (LoginHelper.isSuperAdmin(user.getUserId())) {
            perms.add("*");
        } else {
            List<SysRole> roles = user.getRoles();
            if (!CollectionUtils.isEmpty(roles)) {
                // 多角色设置permissions属性，以便数据权限匹配权限
                for (SysRole role : roles) {
                    Set<String> rolePerms = menuService.selectMenuPermsByRoleId(role.getRoleId());
                    role.setPermissions(rolePerms);
                    perms.addAll(rolePerms);
                }
            } else {
                perms.addAll(menuService.selectMenuPermsByUserId(user.getUserId()));
            }
        }
        return perms;
    }
}
