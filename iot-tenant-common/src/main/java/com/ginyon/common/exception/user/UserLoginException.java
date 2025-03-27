package com.ginyon.common.exception.user;

/**
 * 用户登录异常
 *
 * @author zwh
 */
public class UserLoginException extends UserException {
    private static final long serialVersionUID = 1L;

    public UserLoginException() {
        super("user.login.fail", null);
    }
}
