package com.ginyon.system.service;

import com.ginyon.captcha.config.properties.CaptchaProperties;
import com.ginyon.common.constant.CacheConstants;
import com.ginyon.common.constant.Constants;
import com.ginyon.common.constant.UserConstants;
import com.ginyon.common.exception.user.CaptchaException;
import com.ginyon.common.exception.user.CaptchaExpireException;
import com.ginyon.common.utils.MessageUtils;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.redis.cache.CacheUtil;
import com.ginyon.satoken.helper.LoginHelper;
import com.ginyon.system.api.domain.SysUser;
import com.ginyon.system.api.model.RegisterBody;
import com.ginyon.thread.manager.AsyncManager;
import com.ginyon.thread.manager.factory.AsyncFactory;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;

/**
 * 注册校验方法
 *
 * @author zwh
 */
@Component
public class SysRegisterService {
    @Resource
    private ISysUserServeice userService;

    @Resource
    private CaptchaProperties captchaProperties;

    /**
     * 注册
     */
    public String register(RegisterBody registerBody) {
        String msg = "", username = registerBody.getUsername(), password = registerBody.getPassword();
        SysUser sysUser = new SysUser();
        sysUser.setUserName(username);
        sysUser.setTenantId(registerBody.getTenantId());

        // 验证码开关
        boolean captchaEnabled = captchaProperties.getEnable();
        if (captchaEnabled) {
            validateCaptcha(username, registerBody.getCode(), registerBody.getUuid());
        }

        if (StringUtils.isEmpty(registerBody.getTenantId())) {
            msg = "必须选择租户";
        } else if (StringUtils.isEmpty(username)) {
            msg = "用户名不能为空";
        } else if (StringUtils.isEmpty(password)) {
            msg = "用户密码不能为空";
        } else if (username.length() < UserConstants.USERNAME_MIN_LENGTH
                || username.length() > UserConstants.USERNAME_MAX_LENGTH) {
            msg = "账户长度必须在2到20个字符之间";
        } else if (password.length() < UserConstants.PASSWORD_MIN_LENGTH
                || password.length() > UserConstants.PASSWORD_MAX_LENGTH) {
            msg = "密码长度必须在5到20个字符之间";
        } else if (userService.checkUserUnique(sysUser)) {
            msg = "保存用户'" + username + "'失败，注册账号已存在";
        } else {
            sysUser.setNickName(username);
            sysUser.setPassword(LoginHelper.encryptPassword(password));
            boolean regFlag = userService.registerUser(sysUser);
            if (!regFlag) {
                msg = "注册失败,请联系系统管理人员";
            } else {
                AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.REGISTER, MessageUtils.message("user.register.success")));
            }
        }
        return msg;
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
        String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + StringUtils.nvl(uuid, "");
        String captcha = CacheUtil.getCacheObject(verifyKey);
        CacheUtil.deleteObject(verifyKey);
        if (captcha == null) {
            throw new CaptchaExpireException();
        }
        if (!code.equalsIgnoreCase(captcha)) {
            throw new CaptchaException();
        }
    }
}
