package com.ginyon.mybatis.utils;

import org.springframework.aop.framework.AopProxyUtils;

/**
 * @author zwh
 * @description: 反射工具类
 * @date: 2023/4/28 10:38
 */
public class ReflectUtil {

    private ReflectUtil() {
    }

    /**
     * 获取mapper被代理的类型
     *
     * @param mapper
     * @param <M>
     * @return
     */
    public static <M> Class<M> getMapperTarget(M mapper) {
        Class<M> mapperClass = null;
        Class<?>[] classes = AopProxyUtils.proxiedUserInterfaces(mapper);
        if (classes.length > 0) {
            mapperClass = (Class<M>) classes[0];
        }
        return mapperClass;
    }
}
