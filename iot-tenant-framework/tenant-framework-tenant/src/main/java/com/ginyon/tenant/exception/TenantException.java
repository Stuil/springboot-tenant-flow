package com.ginyon.tenant.exception;

import com.ginyon.common.exception.base.BaseException;

/**
 * 租户异常类
 *
 * @author zwh
 */
public class TenantException extends BaseException {

    private static final long serialVersionUID = 1L;

    public TenantException(String code, Object... args) {
        super("tenant", code, args, null);
    }
}
