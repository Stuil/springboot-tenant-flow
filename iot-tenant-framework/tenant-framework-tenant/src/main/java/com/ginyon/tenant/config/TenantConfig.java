package com.ginyon.tenant.config;

import cn.dev33.satoken.stp.StpUtil;
import com.baomidou.mybatisplus.extension.plugins.MybatisPlusInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.InnerInterceptor;
import com.baomidou.mybatisplus.extension.plugins.inner.TenantLineInnerInterceptor;
import com.ginyon.common.constant.CacheConstants;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.mybatis.config.MybatisPlusConfig;
import com.ginyon.redis.cache.CacheUtil;
import com.ginyon.tenant.handle.GinyonTenantLineHandler;
import com.ginyon.tenant.helper.TenantHelper;
import com.ginyon.tenant.properties.TenantProperties;
import org.springframework.boot.autoconfigure.AutoConfigureAfter;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;

/**
 * 租户配置类
 *
 * @author zwh
 */
@EnableConfigurationProperties(TenantProperties.class)
@Configuration
@AutoConfigureAfter(MybatisPlusConfig.class)
@ConditionalOnProperty(value = "tenant.enable", havingValue = "true")
public class TenantConfig {

    /**
     * 初始化租户配置
     */
    @Bean
    public boolean tenantInit(MybatisPlusInterceptor mybatisPlusInterceptor,
                              TenantProperties tenantProperties) {
        List<InnerInterceptor> interceptors = new ArrayList<>();
        // 多租户插件 必须放到第一位
        interceptors.add(tenantLineInnerInterceptor(tenantProperties));
        interceptors.addAll(mybatisPlusInterceptor.getInterceptors());
        mybatisPlusInterceptor.setInterceptors(interceptors);
        // 多租户情况下，需要重新赋值key
        CacheUtil.setFunction(this::getKey);
        return true;
    }

    /**
     * 多租户插件
     */
    public TenantLineInnerInterceptor tenantLineInnerInterceptor(TenantProperties tenantProperties) {
        return new TenantLineInnerInterceptor(new GinyonTenantLineHandler(tenantProperties));
    }

    public String getKey(String key) {
        if (!StpUtil.isLogin()) {
            return key;
        }
        if (StringUtils.startsWith(key, CacheConstants.GLOBAL_REDIS_KEY)) {
            return key;
        }
        String tenantId = TenantHelper.getTenantId();
        return tenantId + ":" + key;
    }
}
