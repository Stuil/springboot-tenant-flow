package com.ginyon.common.utils;

import com.ginyon.common.exception.ServiceException;

import java.util.Collection;

/**
 * @author zwh
 * @description: Assert类
 * @date: 2023/3/30 14:05
 */
public class AssertUtil {
    private AssertUtil() {

    }

    public static void isNull(Object obj, String errorMsg) {
        if (obj == null) {
            throw new ServiceException(errorMsg);
        }
    }

    public static void isBlank(String obj, String errorMsg) {
        if (StringUtils.isBlank(obj)) {
            throw new ServiceException(errorMsg);
        }
    }

    public static void isTrue(boolean obj, String errorMsg) {
        if (!obj) {
            throw new ServiceException(errorMsg);
        }
    }

    public static void isFalse(boolean obj, String errorMsg) {
        if (obj) {
            throw new ServiceException(errorMsg);
        }
    }

    public static void notEmpty(Collection<?> obj, String errorMsg) {
        if ((obj == null) || (obj.isEmpty())) {
            throw new ServiceException(errorMsg);
        }
    }
}
