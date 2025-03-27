package com.ginyon.system.service;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.core.util.ObjectUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.ginyon.captcha.config.properties.CaptchaProperties;
import com.ginyon.common.constant.CacheConstants;
import com.ginyon.common.constant.Constants;
import com.ginyon.common.constant.TenantConstants;
import com.ginyon.common.constant.UserConstants;
import com.ginyon.common.exception.ServiceException;
import com.ginyon.common.exception.user.*;
import com.ginyon.common.utils.DateUtils;
import com.ginyon.common.utils.MessageUtils;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.common.utils.ip.IpUtils;
import com.ginyon.common.utils.sign.RsaUtils;
import com.ginyon.redis.cache.CacheUtil;
import com.ginyon.satoken.helper.LoginHelper;
import com.ginyon.security.enums.UserStatus;
import com.ginyon.security.web.service.SysPasswordService;
import com.ginyon.security.web.service.SysPermissionService;
import com.ginyon.security.web.service.TokenService;
import com.ginyon.system.api.domain.SysTenant;
import com.ginyon.system.api.domain.SysUser;
import com.ginyon.system.api.model.LoginBody;
import com.ginyon.system.api.model.LoginUser;
import com.ginyon.tenant.enums.TenantStatus;
import com.ginyon.tenant.exception.TenantException;
import com.ginyon.tenant.helper.TenantHelper;
import com.ginyon.thread.manager.AsyncManager;
import com.ginyon.thread.manager.factory.AsyncFactory;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.Date;

/**
 * 登录校验方法
 *
 * @author zwh
 */
@Component
public class SysLoginService {
    protected final Logger log = LoggerFactory.getLogger(this.getClass());
    @Resource
    private TokenService tokenService;

    @Resource
    private ISysUserServeice userService;

    @Resource
    private SysPasswordService passwordService;

    @Resource
    private SysPermissionService permissionService;

    @Resource
    private ISysConfigService configService;

    @Resource
    private ISysTenantService tenantService;

    @Resource
    private CaptchaProperties captchaProperties;

    /**
     * 登录验证
     *
     * @param loginBody 用户名
     * @return 结果
     */
    public String login(LoginBody loginBody) {
        // 验证码校验
        validateCaptcha(loginBody.getUsername(), loginBody.getCode(), loginBody.getUuid());
        try {
            loginBody.setPassword(RsaUtils.decryptByPrivateKey(loginBody.getPassword()));
        } catch (Exception e) {
            log.error("密码解密失败！");
            throw new UserLoginException();
        }
        // 校验租户
        checkTenant(loginBody.getTenantId());
        // 登录前置校验
        loginPreCheck(loginBody.getUsername(), loginBody.getPassword());
        // 用户验证
        try {
            LoginUser loginUser = loadUserByUsername(loginBody.getTenantId(), loginBody.getUsername(), loginBody.getPassword());

            AsyncManager.me().execute(AsyncFactory.recordLogininfor(loginBody.getUsername()
                    , Constants.LOGIN_SUCCESS, MessageUtils.message("user.login.success")));
            recordLoginInfo(loginUser.getUserId());
            loginUser.setTenantId(loginBody.getTenantId());
            StpUtil.login(loginUser.getUserId());
            // 生成token
            return tokenService.createToken(loginUser);
        } catch (Exception e) {
            log.error("登录失败!", e);
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(loginBody.getUsername(), Constants.LOGIN_FAIL, e.getMessage()));
            throw new ServiceException(e.getMessage());
        }
    }

    public void logout() {
        try {
            LoginUser loginUser = LoginHelper.get();
            if (TenantHelper.isEnable() && LoginHelper.isSuperAdmin()) {
                // 超级管理员 登出清除动态租户
                TenantHelper.clearDynamic();
            }
            if (ObjectUtil.isNotNull(loginUser)) {
                String userName = loginUser.getUsername();
                CacheUtil.deleteObject(CacheConstants.ONLINE_TOKEN_KEY + ":" + loginUser.getToken());
                // 记录用户退出日志
                AsyncManager.me().execute(AsyncFactory.recordLogininfor(userName, Constants.LOGOUT, "退出成功"));
            }
            StpUtil.logout();
        } catch (Exception e) {
            log.error("登出失败！", e);
        } finally {
            StpUtil.logout();
        }
    }

    private LoginUser loadUserByUsername(String tenantId, String username, String password) {
        SysUser user = userService.getOne(new LambdaQueryWrapper<SysUser>()
                .eq(TenantHelper.isEnable(), SysUser::getTenantId, tenantId)
                .eq(SysUser::getUserName, username));

        if (ObjectUtil.isNull(user)) {
            log.info("登录用户：{} 不存在.", username);
            throw new ServiceException(MessageUtils.message("user.not.exists"));
        } else if (UserStatus.DELETED.getCode().equals(user.getDelFlag())) {
            log.info("登录用户：{} 已被删除.", username);
            throw new ServiceException(MessageUtils.message("user.password.delete"));
        } else if (UserStatus.DISABLE.getCode().equals(user.getStatus())) {
            log.info("登录用户：{} 已被停用.", username);
            throw new ServiceException(MessageUtils.message("user.blocked"));
        }

        passwordService.validate(password, user);
        if (TenantHelper.isEnable()) {
            user = userService.selectTenantUserByUserName(username, tenantId);
        } else  {
            user = userService.selectUserByUserName(username);
        }
        return createLoginUser(user);
    }

    private LoginUser createLoginUser(SysUser user) {
        return new LoginUser(user.getUserId(), user.getDeptId(), user
                , permissionService.getMenuPermission(user), permissionService.getRolePermission(user));
    }

    /**
     * 校验验证码
     *
     * @param username 用户名
     * @param code     验证码
     * @param uuid     唯一标识
     * @return 结果
     */
    public void validateCaptcha(String username, String code, String uuid) {
        boolean captchaEnabled = captchaProperties.getEnable();
        if (captchaEnabled) {
            String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + StringUtils.nvl(uuid, "");
            String captcha = CacheUtil.getCacheObject(verifyKey);
            CacheUtil.deleteObject(verifyKey);
            if (captcha == null) {
                AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL, MessageUtils.message("user.jcaptcha.expire")));
                throw new CaptchaExpireException();
            }
            if (!code.equalsIgnoreCase(captcha)) {
                AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL, MessageUtils.message("user.jcaptcha.error")));
                throw new CaptchaException();
            }
        }
    }

    /**
     * 登录前置校验
     *
     * @param username 用户名
     * @param password 用户密码
     */
    public void loginPreCheck(String username, String password) {
        // 用户名或密码为空 错误
        if (StringUtils.isEmpty(username) || StringUtils.isEmpty(password)) {
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL, MessageUtils.message("not.null")));
            throw new UserNotExistsException();
        }
        // 密码如果不在指定范围内 错误
        if (password.length() < UserConstants.PASSWORD_MIN_LENGTH
                || password.length() > UserConstants.PASSWORD_MAX_LENGTH) {
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL, MessageUtils.message("user.password.not.match")));
            throw new UserPasswordNotMatchException();
        }
        // 用户名不在指定范围内 错误
        if (username.length() < UserConstants.USERNAME_MIN_LENGTH
                || username.length() > UserConstants.USERNAME_MAX_LENGTH) {
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL, MessageUtils.message("user.password.not.match")));
            throw new UserPasswordNotMatchException();
        }
    }

    /**
     * 记录登录信息
     *
     * @param userId 用户ID
     */
    public void recordLoginInfo(Long userId) {
        SysUser sysUser = new SysUser();
        sysUser.setUserId(userId);
        sysUser.setLoginIp(IpUtils.getIpAddr());
        sysUser.setLoginDate(DateUtils.getNowDate());
        userService.updateUserProfile(sysUser);
    }

    /**
     * 校验租户
     *
     * @param tenantId 租户ID
     */
    public void checkTenant(String tenantId) {
        if (!TenantHelper.isEnable()) {
            return;
        }
        if (TenantConstants.DEFAULT_TENANT_ID.equals(tenantId)) {
            return;
        }
        if (StringUtils.isBlank(tenantId)) {
            throw new TenantException("tenant.number.not.blank");
        }
        SysTenant tenant = tenantService.queryByTenantId(tenantId);
        if (ObjectUtil.isNull(tenant)) {
            log.info("登录租户：{} 不存在.", tenantId);
            throw new TenantException("tenant.not.exists");
        } else if (TenantStatus.DISABLE.getCode().equals(tenant.getStatus())) {
            log.info("登录租户：{} 已被停用.", tenantId);
            throw new TenantException("tenant.blocked");
        } else if (ObjectUtil.isNotNull(tenant.getExpireTime())
                && new Date().after(tenant.getExpireTime())) {
            log.info("登录租户：{} 已超过有效期.", tenantId);
            throw new TenantException("tenant.expired");
        }
    }
}
