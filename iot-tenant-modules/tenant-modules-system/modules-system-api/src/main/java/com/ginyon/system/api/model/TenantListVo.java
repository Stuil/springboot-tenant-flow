package com.ginyon.system.api.model;

import com.ginyon.system.api.domain.SysTenant;
import io.github.linpeilie.annotations.AutoMapper;
import lombok.Data;

/**
 * 租户列表
 *
 * @author zwh
 */
@Data
@AutoMapper(target = SysTenant.class)
public class TenantListVo {

    private String tenantId;

    private String companyName;

    private String domain;

}
