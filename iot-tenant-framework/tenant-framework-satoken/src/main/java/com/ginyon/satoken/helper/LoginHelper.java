package com.ginyon.satoken.helper;

import cn.dev33.satoken.secure.BCrypt;
import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.util.ObjUtil;
import com.ginyon.common.constant.HttpStatus;
import com.ginyon.common.exception.ServiceException;
import com.ginyon.system.api.domain.SysDept;
import com.ginyon.system.api.domain.SysRole;
import com.ginyon.system.api.domain.SysUser;
import com.ginyon.system.api.model.LoginUser;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Objects;

/**
 * 安全服务工具类
 *
 * @author zwh
 */
public class LoginHelper {

    private static final Logger log = LoggerFactory.getLogger(LoginHelper.class);

    public static final String LOGIN_USER = "LOGIN_USER";

    public static void set(LoginUser loginUser) {
        if (ObjUtil.isNotNull(loginUser)) {
            StpUtil.getSession().set(LOGIN_USER, loginUser);
        }
    }
    public static void delete() {
        StpUtil.getSession().delete(LOGIN_USER);
    }

    /**
     * 获取用户登录信息
     **/
    public static LoginUser get() {
        Object object = StpUtil.getSession().get(LOGIN_USER);
        if (ObjUtil.isNotNull(object)) {
            return (LoginUser) object;
        }
        return null;
    }

    /**
     * 获取用户
     **/
    public static LoginUser getN() {
        try {
            Object object = StpUtil.getSession().get(LOGIN_USER);
            if (ObjUtil.isNotNull(object)) {
                return (LoginUser) object;
            }
        } catch (Exception e) {
            log.warn("获取用户账户异常 => 用户未登录");
        }
        return null;
    }

    /**
     * 获取用户
     **/
    public static SysUser getUser() {
        try {
            return Objects.requireNonNull(get()).getUser();
        } catch (Exception e) {
            throw new ServiceException("获取用户ID异常", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * 获取用户角色集合
     **/
    public static List<SysRole> getRoles() {
        try {
            return Objects.requireNonNull(get()).getUser().getRoles();
        } catch (Exception e) {
            throw new ServiceException("获取用户ID异常", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * 获取用户部门
     **/
    public static SysDept getDept() {
        try {
            return Objects.requireNonNull(get()).getUser().getDept();
        } catch (Exception e) {
            throw new ServiceException("获取用户ID异常", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * 用户ID
     **/
    public static Long getUserId() {
        try {
            return Objects.requireNonNull(get()).getUserId();
        } catch (Exception e) {
            throw new ServiceException("获取用户ID异常", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * 租户ID
     **/
    public static String getTenantId() {
        try {
            return Objects.requireNonNull(get()).getTenantId();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * 获取部门ID
     **/
    public static Long getDeptId() {
        try {
            return Objects.requireNonNull(get()).getDeptId();
        } catch (Exception e) {
            throw new ServiceException("获取部门ID异常", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * 获取用户账户, 不抛异常
     **/
    public static String getUsernameNe() {
        try {
            return Objects.requireNonNull(get()).getUsername();
        } catch (Exception e) {
            log.warn("获取用户账户异常 => 用户未登录");
            return null;
        }
    }

    /**
     * 获取用户账户
     **/
    public static String getUsername() {
        try {
            return Objects.requireNonNull(get()).getUsername();
        } catch (Exception e) {
            throw new ServiceException("获取用户账户异常", HttpStatus.UNAUTHORIZED);
        }
    }

    /**
     * 生成BCryptPasswordEncoder密码
     *
     * @param password 密码
     * @return 加密字符串
     */
    public static String encryptPassword(String password) {
        return BCrypt.hashpw(password);

    }

    /**
     * 判断密码是否相同
     *
     * @param rawPassword     真实密码
     * @param encodedPassword 加密后字符
     * @return 结果
     */
    public static boolean matchesPassword(String rawPassword, String encodedPassword) {
        return BCrypt.checkpw(rawPassword, encodedPassword);
    }


    /**
     * 通过用户或者角色id是否为管理员
     *
     * @param id userId或者RoleId
     * @return 结果
     */
    public static boolean isSuperAdmin(Long id) {
        return id != null && 1L == id;
    }

    /**
     * 通过用户id是否为管理员
     *
     * @return 结果
     */
    public static boolean isSuperAdmin() {
        return isSuperAdmin(getUserId());
    }

}
