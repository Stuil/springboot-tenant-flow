package com.ginyon.tenant.handle;

import com.baomidou.mybatisplus.extension.plugins.handler.TenantLineHandler;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.satoken.helper.LoginHelper;
import com.ginyon.tenant.helper.TenantHelper;
import com.ginyon.tenant.properties.TenantProperties;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import net.sf.jsqlparser.expression.Expression;
import net.sf.jsqlparser.expression.NullValue;
import net.sf.jsqlparser.expression.StringValue;

import java.util.List;

/**
 * 自定义租户处理器
 *
 * @author zwh
 */
@Slf4j
@AllArgsConstructor
public class GinyonTenantLineHandler implements TenantLineHandler {

    private final TenantProperties tenantProperties;

    @Override
    public Expression getTenantId() {
        String tenantId = LoginHelper.getTenantId();
        if (StringUtils.isBlank(tenantId)) {
            log.error("无法获取有效的租户id -> Null");
            return new NullValue();
        }
        String dynamicTenantId = TenantHelper.getDynamic();
        if (StringUtils.isNotBlank(dynamicTenantId)) {
            // 返回动态租户
            return new StringValue(dynamicTenantId);
        }
        // 返回固定租户
        return new StringValue(tenantId);
    }

    @Override
    public boolean ignoreTable(String tableName) {
        String tenantId = LoginHelper.getTenantId();
        // 判断是否有租户
        if (StringUtils.isNotBlank(tenantId)) {
            // 不需要过滤租户的表
            List<String> excludes = tenantProperties.getExcludes();
            return excludes.contains(tableName);
        }
        return true;
    }

}
