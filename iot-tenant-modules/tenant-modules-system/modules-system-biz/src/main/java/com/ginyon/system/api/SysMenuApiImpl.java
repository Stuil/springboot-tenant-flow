package com.ginyon.system.api;

import com.ginyon.system.service.ISysMenuServeice;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Set;

/**
 * 菜单 对外api实现业务层
 *
 * @author zwh
 */
@Service
public class SysMenuApiImpl implements ISysMenuApi{

    @Resource
    private ISysMenuServeice menuServeice;

    /**
     * 根据用户ID查询权限
     *
     * @param userId 用户ID
     * @return 权限列表
     */
    @Override
    public Set<String> selectMenuPermsByUserId(Long userId) {
        return menuServeice.selectMenuPermsByUserId(userId);
    }

    /**
     * 根据角色ID查询权限
     *
     * @param roleId 角色ID
     * @return 权限列表
     */
    @Override
    public Set<String> selectMenuPermsByRoleId(Long roleId) {
        return menuServeice.selectMenuPermsByRoleId(roleId);
    }

}
