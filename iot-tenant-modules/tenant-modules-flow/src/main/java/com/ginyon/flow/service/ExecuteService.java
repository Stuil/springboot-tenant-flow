package com.ginyon.flow.service;

import com.ginyon.flow.domain.Flow;

/**
 * @author zwh
 * @description: 流程执行service
 * @date: 2023/5/29 13:09
 */
public interface ExecuteService {


    /**
     * 提交审批
     * @param flow
     * @param tableName
     */
    void startFlow(Flow flow, String tableName);
}
