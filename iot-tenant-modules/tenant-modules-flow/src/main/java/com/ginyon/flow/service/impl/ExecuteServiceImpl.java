package com.ginyon.flow.service.impl;

import com.ginyon.common.utils.uuid.IdUtils;
import com.ginyon.flow.domain.Flow;
import com.ginyon.flow.service.ExecuteService;
import com.ginyon.satoken.helper.LoginHelper;
import com.ginyon.system.api.model.LoginUser;
import com.ginyon.tenant.helper.TenantHelper;
import com.warm.flow.core.dto.FlowParams;
import com.warm.flow.core.entity.Instance;
import com.warm.flow.core.service.InsService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author zwh
 * @description: 流程执行serviceImpl
 * @date: 2023/5/29 13:09
 */
@Service
public class ExecuteServiceImpl implements ExecuteService {

    @Resource
    private InsService insService;


    @Override
    public void startFlow(Flow flow, String tableName) {
        Long id = IdUtils.snowflakeId();
        LoginUser user = LoginHelper.get();
        FlowParams flowParams = FlowParams.build().flowCode(tableName)
                .createBy(user.getUser().getUserId().toString())
                .nickName(user.getUser().getNickName())
                .tenantId(TenantHelper.getTenantId());
        Instance instance = insService.start(String.valueOf(id), flowParams);
        flow.setId(id);
        flow.setInstanceId(instance.getId());
        flow.setNodeCode(instance.getNodeCode());
        flow.setNodeName(instance.getNodeName());
        flow.setFlowStatus(instance.getFlowStatus());
    }
}
