package com.ginyon.system.controller.system;

import cn.dev33.satoken.annotation.SaIgnore;
import com.ginyon.common.core.controller.BaseController;
import com.ginyon.common.core.domain.AjaxResult;
import com.ginyon.common.core.text.Convert;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.system.api.model.RegisterBody;
import com.ginyon.system.service.ISysConfigService;
import com.ginyon.system.service.SysRegisterService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;

/**
 * 注册验证
 *
 * @author zwh
 */
@RestController
public class SysRegisterController extends BaseController {
    @Resource
    private SysRegisterService registerService;

    @Resource
    private ISysConfigService configService;

    @SaIgnore
    @PostMapping("/register")
    public AjaxResult register(@RequestBody RegisterBody user) {
        if (!Convert.toBool(configService.selectConfigNoLogin(user.getTenantId(), "sys.account.registerUser"))) {
            return error("当前系统没有开启注册功能！");
        }
        String msg = registerService.register(user);
        return StringUtils.isEmpty(msg) ? success() : error(msg);
    }
}
