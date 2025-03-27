package com.ginyon.system.api;

import com.ginyon.system.service.ISysRoleServeice;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Set;

/**
 * 角色业务层对外api实现
 *
 * @author zwh
 */
@Service
public class SysRoleApiImpl implements ISysRoleApi {

    @Resource
    private ISysRoleServeice roleServeice;

    /**
     * 根据用户ID查询角色权限
     *
     * @param userId 用户ID
     * @return 权限列表
     */
    @Override
    public Set<String> selectRolePermissionByUserId(Long userId) {
        return roleServeice.selectRolePermissionByUserId(userId);
    }

}
