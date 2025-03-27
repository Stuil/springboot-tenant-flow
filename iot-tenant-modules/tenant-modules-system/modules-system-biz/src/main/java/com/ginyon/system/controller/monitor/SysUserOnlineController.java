package com.ginyon.system.controller.monitor;

import cn.dev33.satoken.annotation.SaCheckPermission;
import cn.dev33.satoken.stp.StpUtil;
import com.ginyon.common.constant.CacheConstants;
import com.ginyon.common.core.controller.BaseController;
import com.ginyon.common.core.domain.AjaxResult;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.log.annotaion.Log;
import com.ginyon.log.enums.BusinessType;
import com.ginyon.mybatis.utils.PageUtils;
import com.ginyon.redis.cache.CacheUtil;
import com.ginyon.system.api.domain.SysUserOnline;
import com.ginyon.system.api.model.LoginUser;
import com.ginyon.system.service.ISysUserOnlineService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * 在线用户监控
 *
 * @author zwh
 */
@RestController
@RequestMapping("/monitor/online")
public class SysUserOnlineController extends BaseController {
    @Resource
    private ISysUserOnlineService userOnlineService;

    @SaCheckPermission("monitor:online:list")
    @GetMapping("/list")
    public TableDataInfo list(String ipaddr, String userName) {
        List<String> keys = StpUtil.searchTokenValue("", 0, -1, false);
        List<SysUserOnline> userOnlineList = new ArrayList<>();
        for (String key : keys) {
            String token = StringUtils.substringAfterLast(key, ":");
            // 如果已经过期则跳过
            if (StpUtil.stpLogic.getTokenActiveTimeoutByToken(token) < -1) {
                continue;
            }
            LoginUser user = CacheUtil.getCacheObject(CacheConstants.ONLINE_TOKEN_KEY + ":" + token);
            if (StringUtils.isNotEmpty(ipaddr) && StringUtils.isNotEmpty(userName)) {
                userOnlineList.add(userOnlineService.selectOnlineByInfo(ipaddr, userName, user));
            } else if (StringUtils.isNotEmpty(ipaddr)) {
                userOnlineList.add(userOnlineService.selectOnlineByIpaddr(ipaddr, user));
            } else if (StringUtils.isNotEmpty(userName) && StringUtils.isNotNull(user.getUser())) {
                userOnlineList.add(userOnlineService.selectOnlineByUserName(userName, user));
            } else {
                userOnlineList.add(userOnlineService.loginUserToUserOnline(user));
            }
        }
        Collections.reverse(userOnlineList);
        userOnlineList.removeAll(Collections.singleton(null));
        return PageUtils.getDataTable(userOnlineList);
    }

    /**
     * 强退用户
     */
    @SaCheckPermission("monitor:online:forceLogout")
    @Log(title = "在线用户", businessType = BusinessType.FORCE)
    @DeleteMapping("/{tokenId}")
    public AjaxResult forceLogout(@PathVariable String tokenId) {
        CacheUtil.deleteObject(CacheConstants.ONLINE_TOKEN_KEY + ":" + tokenId);
        StpUtil.kickoutByTokenValue(tokenId);
        return success();
    }
}
