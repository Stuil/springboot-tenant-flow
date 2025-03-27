package com.ginyon.common.utils.uuid;

import cn.hutool.core.lang.Snowflake;
import cn.hutool.core.util.IdUtil;

/**
 * ID生成器工具类
 *
 * @author zwh
 */
public class IdUtils {
    /**
     * 获取随机UUID
     *
     * @return 随机UUID
     */
    public static String randomUUID() {
        return UUID.randomUUID().toString();
    }

    /**
     * 简化的UUID，去掉了横线
     *
     * @return 简化的UUID，去掉了横线
     */
    public static String simpleUUID() {
        return UUID.randomUUID().toString(true);
    }

    /**
     * 获取随机UUID，使用性能更好的ThreadLocalRandom生成UUID
     *
     * @return 随机UUID
     */
    public static String fastUUID() {
        return UUID.fastUUID().toString();
    }

    /**
     * 简化的UUID，去掉了横线，使用性能更好的ThreadLocalRandom生成UUID
     *
     * @return 简化的UUID，去掉了横线
     */
    public static String fastSimpleUUID() {
        return UUID.fastUUID().toString(true);
    }

    /**
     * 获取雪花算法id
     *
     * @return
     */
    public static Long snowflakeId() {
        return IdUtil.getSnowflake(1, 1).nextId();
    }

    /**
     * 获取雪花算法id 字符串
     *
     * @return
     */
    public static String snowflakeIdStr() {
        return IdUtil.getSnowflake(1, 1).nextIdStr();
    }

    /**
     * 获取雪花算法id
     *
     * @return
     */
    public static Snowflake getSnowflake() {
        return IdUtil.getSnowflake(1, 1);
    }
}
