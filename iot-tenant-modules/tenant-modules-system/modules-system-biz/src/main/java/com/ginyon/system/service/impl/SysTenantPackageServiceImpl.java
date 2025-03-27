package com.ginyon.system.service.impl;

import cn.hutool.core.collection.CollUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ginyon.common.constant.TenantConstants;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.common.exception.ServiceException;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.mybatis.service.impl.BaseServiceImpl;
import com.ginyon.mybatis.utils.PageUtils;
import com.ginyon.system.api.domain.SysTenant;
import com.ginyon.system.api.domain.SysTenantPackage;
import com.ginyon.system.mapper.SysTenantMapper;
import com.ginyon.system.mapper.SysTenantPackageMapper;
import com.ginyon.system.service.ISysTenantPackageService;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * 租户套餐Service业务层处理
 *
 * @author zwh
 * @date 2023-10-26
 */
@Component
public class SysTenantPackageServiceImpl extends BaseServiceImpl<SysTenantPackageMapper, SysTenantPackage> implements ISysTenantPackageService {

    @Resource
    private SysTenantPackageMapper sysTenantPackageMapper;

    @Resource
    private SysTenantMapper tenantMapper;



    @Override
    public SysTenantPackage selectById(Long packageId) {
        return sysTenantPackageMapper.selectById(packageId);

    }

    @Override
    public TableDataInfo<SysTenantPackage> selectPage(QueryParam queryParam, SysTenantPackage sysTenantPackage) {
        LambdaQueryWrapper<SysTenantPackage> qw = buildQuery(sysTenantPackage);
        Page<SysTenantPackage> page = sysTenantPackageMapper.selectPage(queryParam.getPage(), qw);;
        if (CollUtil.isEmpty(page.getRecords())) {
            page.setRecords(Collections.emptyList());
        }
        return PageUtils.build(page);
    }

    @Override
    public List<SysTenantPackage> selectList() {
        return sysTenantPackageMapper.selectList(new LambdaQueryWrapper<SysTenantPackage>()
                .eq(SysTenantPackage::getStatus, TenantConstants.NORMAL));
    }

    @Override
    public List<SysTenantPackage> selectList(SysTenantPackage sysTenantPackage) {
        List<SysTenantPackage> sysTenantPackages = sysTenantPackageMapper.selectList(buildQuery(sysTenantPackage));
        if (CollUtil.isEmpty(sysTenantPackages)) {
            return Collections.emptyList();
        }
        return sysTenantPackages;
    }

    public LambdaQueryWrapper<SysTenantPackage> buildQuery(SysTenantPackage sysTenantPackage) {
        return Wrappers.lambdaQuery(SysTenantPackage.class)
                .like(StringUtils.isNotBlank(sysTenantPackage.getPackageName()), SysTenantPackage::getPackageName, sysTenantPackage.getPackageName())
                .orderByDesc(SysTenantPackage::getCreateTime);
    }

    @Override
    public boolean insert(SysTenantPackage sysTenantPackage) {
        return sysTenantPackageMapper.insert(sysTenantPackage) > 0;
    }

    @Override
    public boolean update(SysTenantPackage sysTenantPackage) {
        return sysTenantPackageMapper.updateById(sysTenantPackage) > 0;
    }

    @Override
    public boolean deleteByIds(Long[] packageIds) {
        boolean exists = tenantMapper.exists(new LambdaQueryWrapper<SysTenant>()
                .in(SysTenant::getPackageId, Arrays.asList(packageIds)));
        if (exists) {
            throw new ServiceException("租户套餐已被使用");
        }
        return sysTenantPackageMapper.deleteBatchIds(Arrays.asList(packageIds)) > 0;
    }


}
