package com.ginyon.system.controller.monitor;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ginyon.common.config.GinyonConfig;
import com.ginyon.common.core.domain.AjaxResult;
import com.ginyon.system.domain.Server;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 服务器监控
 *
 * @author zwh
 */
@RestController
@RequestMapping("/monitor/server")
public class ServerController {
    @Resource
    private GinyonConfig ginyonConfig;

    @SaCheckPermission("monitor:server:list")
    @GetMapping()
    public AjaxResult getInfo() throws Exception {
        if (ginyonConfig.isDemoEnabled()) {
            return AjaxResult.success(null);
        }
        Server server = new Server();
        server.copyTo();
        return AjaxResult.success(server);
    }
}
