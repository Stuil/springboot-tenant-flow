package com.ginyon.system.api;

import com.ginyon.system.api.domain.SysLogininfor;
import com.ginyon.system.service.ISysLogininforServeice;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * 系统访问日志情况信息 对外api实现服务层
 *
 * @author zwh
 */
@Service
public class SysLogininforApiImpl implements ISysLogininforApi{

    @Resource
    private ISysLogininforServeice logininforServeice;

    /**
     * 新增系统登录日志
     *
     * @param logininfor 访问日志对象
     */
    @Override
    public void insertLogininfor(SysLogininfor logininfor) {
        logininforServeice.insertLogininfor(logininfor);
    }

}
