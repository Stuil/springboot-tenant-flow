package com.ginyon.system.api;

import com.ginyon.system.api.domain.SysOperLog;
import com.ginyon.system.service.ISysOperLogServeice;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * 操作日志 对外api实现服务层
 *
 * @author zwh
 */
@Service
public class SysOperLogApiImpl implements ISysOperLogApi{

    @Resource
    private ISysOperLogServeice operLogServeice;
    /**
     * 新增操作日志
     *
     * @param operLog 操作日志对象
     */
    @Override
    public void insertOperlog(SysOperLog operLog) {
        operLogServeice.insertOperlog(operLog);
    }

}
