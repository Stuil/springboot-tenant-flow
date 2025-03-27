package com.ginyon.flow.service.impl;

import com.ginyon.flow.service.GinyonDefService;
import com.warm.flow.core.service.DefService;
import com.warm.flow.core.service.NodeService;
import com.warm.flow.core.service.SkipService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author zwh
 * @description: 流程定义serviceImpl
 * @date: 2023/5/29 13:09
 */
@Service
public class GinyonDefServiceImpl implements GinyonDefService {

    @Resource
    private DefService defService;

    @Resource
    private NodeService nodeService;

    @Resource
    private SkipService skipService;

}
