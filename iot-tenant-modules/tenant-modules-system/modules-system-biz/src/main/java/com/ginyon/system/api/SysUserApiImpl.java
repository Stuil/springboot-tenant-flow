package com.ginyon.system.api;

import com.ginyon.system.api.domain.SysUser;
import com.ginyon.system.service.ISysUserServeice;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * 用户 对外api实现业务层
 *
 * @author zwh
 */
@Service
public class SysUserApiImpl implements ISysUserApi {

    @Resource
    private ISysUserServeice userServeice;

    /**
     * 通过用户ID查询用户
     *
     * @param userId 用户ID
     * @return 用户对象信息
     */
    @Override
    public SysUser selectUserById(Long userId) {
        return userServeice.selectUserById(userId);
    }

}
