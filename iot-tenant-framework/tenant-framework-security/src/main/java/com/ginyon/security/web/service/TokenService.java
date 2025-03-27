package com.ginyon.security.web.service;

import cn.dev33.satoken.stp.StpUtil;
import com.ginyon.common.constant.CacheConstants;
import com.ginyon.common.utils.ServletUtils;
import com.ginyon.common.utils.ip.AddressUtils;
import com.ginyon.common.utils.ip.IpUtils;
import com.ginyon.redis.cache.CacheUtil;
import com.ginyon.satoken.helper.LoginHelper;
import com.ginyon.system.api.model.LoginUser;
import eu.bitwalker.useragentutils.UserAgent;
import org.springframework.stereotype.Component;

/**
 * token验证处理
 *
 * @author zwh
 */
@Component
public class TokenService {

    /**
     * 创建令牌
     *
     * @param loginUser 用户信息
     * @return 令牌
     */
    public String createToken(LoginUser loginUser) {
        String token = StpUtil.getTokenValue();
        loginUser.setToken(token);
        setUserAgent(loginUser);
        loginUser.setLoginTime(System.currentTimeMillis());
        LoginHelper.set(loginUser);
        CacheUtil.setCacheObject(CacheConstants.ONLINE_TOKEN_KEY + ":" + token, loginUser);
        return token;
    }

    /**
     * 设置用户代理信息
     *
     * @param loginUser 登录信息
     */
    public void setUserAgent(LoginUser loginUser) {
        UserAgent userAgent = UserAgent.parseUserAgentString(ServletUtils.getRequest().getHeader("User-Agent"));
        String ip = IpUtils.getIpAddr();
        loginUser.setIpaddr(ip);
        loginUser.setLoginLocation(AddressUtils.getRealAddressByIP(ip));
        loginUser.setBrowser(userAgent.getBrowser().getName());
        loginUser.setOs(userAgent.getOperatingSystem().getName());
    }

}
