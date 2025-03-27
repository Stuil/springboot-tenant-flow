package com.ginyon.system.controller.system;

import cn.dev33.satoken.annotation.SaIgnore;
import cn.hutool.core.collection.CollUtil;
import com.ginyon.common.constant.Constants;
import com.ginyon.common.core.domain.AjaxResult;
import com.ginyon.common.core.domain.R;
import com.ginyon.common.utils.MapstructUtils;
import com.ginyon.common.utils.StreamUtils;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.satoken.helper.LoginHelper;
import com.ginyon.security.web.service.SysPermissionService;
import com.ginyon.system.api.domain.SysMenu;
import com.ginyon.system.api.domain.SysTenant;
import com.ginyon.system.api.domain.SysUser;
import com.ginyon.system.api.model.LoginBody;
import com.ginyon.system.api.model.LoginTenantVo;
import com.ginyon.system.api.model.TenantListVo;
import com.ginyon.system.service.ISysMenuServeice;
import com.ginyon.system.service.ISysTenantService;
import com.ginyon.system.service.SysLoginService;
import com.ginyon.tenant.helper.TenantHelper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.net.URL;
import java.util.List;
import java.util.Set;

/**
 * 登录验证
 *
 * @author zwh
 */
@RestController
public class SysLoginController {
    @Resource
    private SysLoginService loginService;

    @Resource
    private ISysMenuServeice menuService;

    @Resource
    private SysPermissionService permissionService;

    @Resource
    private ISysTenantService tenantService;

    /**
     * 登录方法
     *
     * @param loginBody 登录信息
     * @return 结果
     */
    @SaIgnore
    @PostMapping("/login")
    public AjaxResult login(@RequestBody LoginBody loginBody) {
        AjaxResult ajax = AjaxResult.success();
        // 生成令牌
        String token = loginService.login(loginBody);
        ajax.put(Constants.TOKEN, token);
        return ajax;
    }

    /**
     * 登出
     *
     * @return
     */
    @SaIgnore
    @PostMapping("logout")
    public R<Void> logout() {
        loginService.logout();
        return R.ok();
    }

    /**
     * 获取用户信息
     *
     * @return 用户信息
     */
    @GetMapping("getInfo")
    public AjaxResult getInfo() {
        SysUser user = LoginHelper.getUser();
        if (TenantHelper.isEnable() && LoginHelper.isSuperAdmin()) {
            // 超级管理员 如果重新加载用户信息需清除动态租户
            TenantHelper.clearDynamic();
        }
        // 角色集合
        Set<String> roles = permissionService.getRolePermission(user);
        // 权限集合
        Set<String> permissions = permissionService.getMenuPermission(user);
        AjaxResult ajax = AjaxResult.success();
        ajax.put("user", user);
        ajax.put("roles", roles);
        ajax.put("permissions", permissions);
        return ajax;
    }

    /**
     * 获取路由信息
     *
     * @return 路由信息
     */
    @GetMapping("getRouters")
    public AjaxResult getRouters() {
        Long userId = LoginHelper.getUserId();
        List<SysMenu> menus = menuService.selectMenuTreeByUserId(userId);
        return AjaxResult.success(menuService.buildMenus(menus));
    }

    /**
     * 登录页面租户下拉框
     *
     * @return 租户列表
     */
    @SaIgnore
    @GetMapping("/tenant/list")
    public R<LoginTenantVo> tenantList(HttpServletRequest request) throws Exception {
        List<SysTenant> tenantList = tenantService.selectList(new SysTenant());
        List<TenantListVo> voList = MapstructUtils.convert(tenantList, TenantListVo.class);
        // 获取域名
        String host;
        String referer = request.getHeader("referer");
        if (StringUtils.isNotBlank(referer)) {
            // 这里从referer中取值是为了本地使用hosts添加虚拟域名，方便本地环境调试
            host = referer.split("//")[1].split("/")[0];
        } else {
            host = new URL(request.getRequestURL().toString()).getHost();
        }
        // 根据域名进行筛选
        List<TenantListVo> list = StreamUtils.filter(voList, vo ->
                StringUtils.equals(vo.getDomain(), host));
        // 返回对象
        LoginTenantVo vo = new LoginTenantVo();
        vo.setVoList(CollUtil.isNotEmpty(list) ? list : voList);
        vo.setTenantEnabled(TenantHelper.isEnable());
        return R.ok(vo);
    }
}
