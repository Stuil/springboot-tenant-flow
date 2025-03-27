package com.ginyon.system.api.model;

import lombok.Data;

import java.util.List;

/**
 * 登录租户对象
 *
 * @author zwh
 */
@Data
public class LoginTenantVo {

    /**
     * 租户开关
     */
    private Boolean tenantEnabled;

    /**
     * 租户对象列表
     */
    private List<TenantListVo> voList;

}
