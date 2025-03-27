package com.ginyon.security.web.service;

import com.ginyon.common.constant.CacheConstants;
import com.ginyon.common.constant.Constants;
import com.ginyon.common.exception.user.UserPasswordNotMatchException;
import com.ginyon.common.exception.user.UserPasswordRetryLimitExceedException;
import com.ginyon.common.utils.MessageUtils;
import com.ginyon.redis.cache.CacheUtil;
import com.ginyon.satoken.helper.LoginHelper;
import com.ginyon.system.api.domain.SysUser;
import com.ginyon.thread.manager.AsyncManager;
import com.ginyon.thread.manager.factory.AsyncFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.util.concurrent.TimeUnit;

/**
 * 登录密码方法
 *
 * @author zwh
 */
@Component
public class SysPasswordService {

    @Value(value = "${user.password.maxRetryCount}")
    private int maxRetryCount;

    @Value(value = "${user.password.lockTime}")
    private int lockTime;

    /**
     * 登录账户密码错误次数缓存键名
     *
     * @param username 用户名
     * @return 缓存键key
     */
    private String getCacheKey(String username) {
        return CacheConstants.PWD_ERR_CNT_KEY + username;
    }

    public void validate(String password, SysUser user) {
        String username = user.getUserName();
        Integer retryCount = CacheUtil.getCacheObject(getCacheKey(username));

        if (retryCount == null) {
            retryCount = 0;
        }

        if (retryCount >= maxRetryCount) {
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL,
                    MessageUtils.message("user.password.retry.limit.exceed", maxRetryCount, lockTime)));
            throw new UserPasswordRetryLimitExceedException(maxRetryCount, lockTime);
        }

        if (!LoginHelper.matchesPassword(password, user.getPassword())) {
            retryCount = retryCount + 1;
            AsyncManager.me().execute(AsyncFactory.recordLogininfor(username, Constants.LOGIN_FAIL,
                    MessageUtils.message("user.password.retry.limit.count", retryCount)));
            CacheUtil.setCacheObject(getCacheKey(username), retryCount, lockTime, TimeUnit.MINUTES);
            throw new UserPasswordNotMatchException();
        } else {
            clearLoginRecordCache(username);
        }
    }
    public boolean matches(SysUser user, String rawPassword) {
        return LoginHelper.matchesPassword(rawPassword, user.getPassword());
    }

    public void clearLoginRecordCache(String loginName) {
        if (CacheUtil.hasKey(getCacheKey(loginName))) {
            CacheUtil.deleteObject(getCacheKey(loginName));
        }
    }
}
