package com.ginyon.satoken.service;

import cn.dev33.satoken.stp.StpInterface;
import com.ginyon.common.constant.UserConstants;
import com.ginyon.satoken.helper.LoginHelper;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Set;

/**
 * 自定义权限验证接口扩展
 *
 * @author zwh
 */
@Component
public class StpInterfaceImpl implements StpInterface {

    /**
     * 返回一个账号所拥有的权限码集合
     */
    @Override
    public List<String> getPermissionList(Object loginId, String loginType) {
        if (LoginHelper.get() != null) {
            return new ArrayList<>(Objects.requireNonNull(LoginHelper.get()).getPermissions());
        }
        return new ArrayList<>();

    }

    /**
     * 返回一个账号所拥有的角色标识集合
     */
    @Override
    public List<String> getRoleList(Object loginId, String loginType) {
        if (LoginHelper.get() != null) {
            Set<String> rolePermissions = Objects.requireNonNull(LoginHelper.get()).getRolePermissions();
            for (String rolePermission : rolePermissions) {
                // 管理员有所有权限
                if (UserConstants.SUPER_ADMIN.equals(rolePermission)) {
                    rolePermissions.add("*");
                }
            }
            return new ArrayList<>(rolePermissions);
        }
        return new ArrayList<>();
    }

}
