package com.ginyon.common.constant;

/**
 * 缓存的key 常量
 *
 * @author zwh
 */
public class CacheConstants {

    /**
     * 全局 redis key (业务无关的key)
     */
    public static final String GLOBAL_REDIS_KEY = "global:";


    /**
     * 登录用户 redis key
     */
    public static final String LOGIN_TOKEN_KEY = GLOBAL_REDIS_KEY + "login_tokens:";

    /**
     * 在线用户 redis key
     */
    public static final String ONLINE_TOKEN_KEY = "online_tokens:";

    /**
     * 验证码 redis key
     */
    public static final String CAPTCHA_CODE_KEY = GLOBAL_REDIS_KEY + "captcha_codes:";

    /**
     * 参数管理 cache key
     */
    public static final String SYS_CONFIG_KEY = "sys_config:";

    /**
     * 字典管理 cache key
     */
    public static final String SYS_DICT_KEY = "sys_dict:";

    /**
     * 防重提交 redis key
     */
    public static final String REPEAT_SUBMIT_KEY = GLOBAL_REDIS_KEY + "repeat_submit:";

    /**
     * 限流 redis key
     */
    public static final String RATE_LIMIT_KEY = GLOBAL_REDIS_KEY + "rate_limit:";

    /**
     * 登录账户密码错误次数 redis key
     */
    public static final String PWD_ERR_CNT_KEY = GLOBAL_REDIS_KEY + "pwd_err_cnt:";

    /**
     * 动态租户 redis key
     */
    public static final String DYNAMIC_TENANT_KEY = GLOBAL_REDIS_KEY + "dynamic_tenant:";
}
