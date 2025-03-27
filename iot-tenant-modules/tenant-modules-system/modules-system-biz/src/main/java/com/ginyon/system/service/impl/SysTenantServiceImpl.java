package com.ginyon.system.service.impl;

import cn.hutool.core.collection.CollUtil;
import cn.hutool.core.convert.Convert;
import cn.hutool.core.util.ArrayUtil;
import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.RandomUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.ginyon.common.constant.Constants;
import com.ginyon.common.constant.TenantConstants;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.common.exception.ServiceException;
import com.ginyon.common.utils.StringUtils;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.mybatis.service.impl.BaseServiceImpl;
import com.ginyon.mybatis.utils.PageUtils;
import com.ginyon.satoken.helper.LoginHelper;
import com.ginyon.system.api.domain.*;
import com.ginyon.system.mapper.*;
import com.ginyon.system.service.ISysTenantService;
import com.ginyon.tenant.helper.TenantHelper;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;

/**
 * 租户Service业务层处理
 *
 * @author zwh
 * @date 2023-10-27
 */
@Component
public class SysTenantServiceImpl extends BaseServiceImpl<SysTenantMapper, SysTenant> implements ISysTenantService {

    @Resource
    private SysTenantMapper tenantMapper;
    @Resource
    private SysTenantPackageMapper tenantPackageMapper;
    @Resource
    private SysUserMapper userMapper;
    @Resource
    private SysDeptMapper deptMapper;
    @Resource
    private SysRoleMapper roleMapper;
    @Resource
    private SysRoleMenuMapper roleMenuMapper;
    @Resource
    private SysRoleDeptMapper roleDeptMapper;
    @Resource
    private SysUserRoleMapper userRoleMapper;
    @Resource
    private SysDictTypeMapper dictTypeMapper;
    @Resource
    private SysDictDataMapper dictDataMapper;
    @Resource
    private SysConfigMapper configMapper;

    @Override
    public SysTenant selectById(Long id) {
        return tenantMapper.selectById(id);

    }
    @Override
    public SysTenant queryByTenantId(String tenantId) {
        return baseMapper.selectOne(new LambdaQueryWrapper<SysTenant>().eq(SysTenant::getTenantId, tenantId));
    }

    @Override
    public TableDataInfo<SysTenant> selectPage(QueryParam queryParam, SysTenant sysTenant) {
        LambdaQueryWrapper<SysTenant> qw = buildQuery(sysTenant);
        Page<SysTenant> page = tenantMapper.selectPage(queryParam.getPage(), qw);
        if (CollUtil.isEmpty(page.getRecords())) {
            page.setRecords(Collections.emptyList());
        }
        return PageUtils.build(page);
    }

    @Override
    public List<SysTenant> selectList(SysTenant sysTenant) {
        List<SysTenant> sysTenants = tenantMapper.selectList(buildQuery(sysTenant));
        if (CollUtil.isEmpty(sysTenants)) {
            return Collections.emptyList();
        }
        return sysTenants;
    }

    public LambdaQueryWrapper<SysTenant> buildQuery(SysTenant sysTenant) {
        return Wrappers.lambdaQuery(SysTenant.class)
                .like(StringUtils.isNotBlank(sysTenant.getTenantId()), SysTenant::getTenantId, sysTenant.getTenantId())
                .like(StringUtils.isNotBlank(sysTenant.getContactUserName()), SysTenant::getContactUserName, sysTenant.getContactUserName())
                .like(StringUtils.isNotBlank(sysTenant.getContactPhone()), SysTenant::getContactPhone, sysTenant.getContactPhone())
                .like(StringUtils.isNotBlank(sysTenant.getCompanyName()), SysTenant::getCompanyName, sysTenant.getCompanyName())
                .orderByAsc(SysTenant::getCreateTime);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean insert(SysTenant sysTenant) {
        TenantHelper.ignore(() -> {
            // 获取所有租户编号
            List<String> tenantIds = tenantMapper.selectObjs(
                    new LambdaQueryWrapper<SysTenant>().select(SysTenant::getTenantId), x -> {return Convert.toStr(x);});
            String tenantId = generateTenantId(tenantIds);
            sysTenant.setTenantId(tenantId);
            boolean flag = tenantMapper.insert(sysTenant) > 0;
            if (!flag) {
                throw new ServiceException("创建租户失败");
            }
            // 根据套餐创建角色
            Long roleId = createTenantRole(tenantId, sysTenant.getPackageId());

            // 创建部门: 公司名是部门名称
            SysDept dept = new SysDept();
            dept.setTenantId(tenantId);
            dept.setDeptName(sysTenant.getCompanyName());
            dept.setParentId(Constants.TOP_PARENT_ID);
            dept.setAncestors(Constants.TOP_PARENT_ID.toString());
            deptMapper.insert(dept);
            Long deptId = dept.getDeptId();

            // 角色和部门关联表
            SysRoleDept roleDept = new SysRoleDept();
            roleDept.setRoleId(roleId);
            roleDept.setDeptId(deptId);
            roleDeptMapper.insert(roleDept);

            // 创建系统用户
            SysUser user = new SysUser();
            user.setTenantId(tenantId);
            user.setUserName(sysTenant.getUserName());
            user.setNickName(sysTenant.getUserName());
            user.setPassword(LoginHelper.encryptPassword(sysTenant.getPassword()));
            user.setDeptId(deptId);
            userMapper.insert(user);
            //新增系统用户后，默认当前用户为部门的负责人
            SysDept sd = new SysDept();
            sd.setLeader(user.getUserId());
            sd.setDeptId(deptId);
            deptMapper.updateById(sd);

            // 用户和角色关联表
            SysUserRole userRole = new SysUserRole();
            userRole.setUserId(user.getUserId());
            userRole.setRoleId(roleId);
            userRoleMapper.insert(userRole);

            String defaultTenantId = TenantConstants.DEFAULT_TENANT_ID;
            List<SysDictType> dictTypeList = dictTypeMapper.selectList(
                    new LambdaQueryWrapper<SysDictType>().eq(SysDictType::getTenantId, defaultTenantId));
            List<SysDictData> dictDataList = dictDataMapper.selectList(
                    new LambdaQueryWrapper<SysDictData>().eq(SysDictData::getTenantId, defaultTenantId));
            for (SysDictType dictType : dictTypeList) {
                dictType.setDictId(null);
                dictType.setCreateBy(null);
                dictType.setCreateTime(null);
                dictType.setUpdateBy(null);
                dictType.setUpdateTime(null);
                dictType.setTenantId(tenantId);
            }
            for (SysDictData dictData : dictDataList) {
                dictData.setDictCode(null);
                dictData.setCreateBy(null);
                dictData.setCreateTime(null);
                dictData.setUpdateBy(null);
                dictData.setUpdateTime(null);
                dictData.setTenantId(tenantId);
            }
            dictTypeMapper.insertBatch(dictTypeList);
            dictDataMapper.insertBatch(dictDataList);

            List<SysConfig> sysConfigList = configMapper.selectList(
                    new LambdaQueryWrapper<SysConfig>().eq(SysConfig::getTenantId, defaultTenantId));
            for (SysConfig config : sysConfigList) {
                config.setConfigId(null);
                config.setTenantId(tenantId);
            }
            configMapper.insertBatch(sysConfigList);
        });
        return true;
    }

    @Override
    public boolean update(SysTenant sysTenant) {
        sysTenant.setTenantId(null);
        sysTenant.setPackageId(null);
        return tenantMapper.updateById(sysTenant) > 0;
    }

    @Override
    public boolean deleteByIds(Long[] ids) {
        // 做一些业务上的校验,判断是否需要校验
        if (ArrayUtil.contains(ids, TenantConstants.SUPER_ADMIN_ID)) {
            throw new ServiceException("超管租户不能删除");
        }
        return tenantMapper.deleteBatchIds(Arrays.asList(ids)) > 0;
    }

    /**
     * 校验租户是否允许操作
     *
     * @param tenantId 租户ID
     */
    @Override
    public void checkTenantAllowed(String tenantId) {
        if (ObjectUtil.isNotNull(tenantId) && TenantConstants.DEFAULT_TENANT_ID.equals(tenantId)) {
            throw new ServiceException("不允许操作管理租户");
        }
    }

    /**
     * 校验企业名称是否唯一
     */
    @Override
    public boolean checkCompanyNameUnique(SysTenant sysTenant) {
        boolean exist = tenantMapper.exists(new LambdaQueryWrapper<SysTenant>()
                .eq(SysTenant::getCompanyName, sysTenant.getCompanyName())
                .ne(ObjectUtil.isNotNull(sysTenant.getTenantId()), SysTenant::getTenantId, sysTenant.getTenantId()));
        return !exist;
    }

    /**
     * 校验账号余额
     */
    @Override
    public boolean checkAccountBalance(String tenantId) {
        SysTenant tenant = queryByTenantId(tenantId);
        // 如果余额为-1代表不限制
        if (tenant.getAccountCount() == -1) {
            return true;
        }
        Long userNumber = userMapper.selectCount(new LambdaQueryWrapper<>());
        // 如果余额大于0代表还有可用名额
        return tenant.getAccountCount() - userNumber > 0;
    }

    /**
     * 校验有效期
     */
    @Override
    public boolean checkExpireTime(String tenantId) {
        SysTenant tenant = queryByTenantId(tenantId);
        // 如果未设置过期时间代表不限制
        if (ObjectUtil.isNull(tenant.getExpireTime())) {
            return true;
        }
        // 如果当前时间在过期时间之前则通过
        return new Date().before(tenant.getExpireTime());
    }

    /**
     * 同步租户套餐
     */
    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean syncTenantPackage(String tenantId, Long packageId) {
        TenantHelper.ignore(() -> {
            SysTenantPackage tenantPackage = tenantPackageMapper.selectById(packageId);
            List<SysRole> roles = roleMapper.selectList(
                    new LambdaQueryWrapper<SysRole>().eq(SysRole::getTenantId, tenantId));
            List<Long> roleIds = new ArrayList<>(roles.size() - 1);
            List<Long> menuIds = StringUtils.splitTo(tenantPackage.getMenuIds(), Convert::toLong);
            roles.forEach(item -> {
                if (TenantConstants.TENANT_ADMIN_ROLE_KEY.equals(item.getRoleKey())) {
                    List<SysRoleMenu> roleMenus = new ArrayList<>(menuIds.size());
                    menuIds.forEach(menuId -> {
                        SysRoleMenu roleMenu = new SysRoleMenu();
                        roleMenu.setRoleId(item.getRoleId());
                        roleMenu.setMenuId(menuId);
                        roleMenus.add(roleMenu);
                    });
                    roleMenuMapper.delete(new LambdaQueryWrapper<SysRoleMenu>().eq(SysRoleMenu::getRoleId, item.getRoleId()));
                    roleMenuMapper.insertBatch(roleMenus);
                } else {
                    roleIds.add(item.getRoleId());
                }
            });
            if (!roleIds.isEmpty()) {
                roleMenuMapper.delete(
                        new LambdaQueryWrapper<SysRoleMenu>().in(SysRoleMenu::getRoleId, roleIds).notIn(!menuIds.isEmpty(), SysRoleMenu::getMenuId, menuIds));
            }
        });
        return true;
    }
    /**
     * 生成租户id
     *
     * @param tenantIds 已有租户id列表
     * @return 租户id
     */
    private String generateTenantId(List<String> tenantIds) {
        // 随机生成6位
        String numbers = RandomUtil.randomNumbers(6);
        // 判断是否存在，如果存在则重新生成
        if (tenantIds.contains(numbers)) {
            generateTenantId(tenantIds);
        }
        return numbers;
    }

    /**
     * 根据租户菜单创建租户角色
     *
     * @param tenantId  租户编号
     * @param packageId 租户套餐id
     * @return 角色id
     */
    private Long createTenantRole(String tenantId, Long packageId) {
        // 获取租户套餐
        SysTenantPackage tenantPackage = tenantPackageMapper.selectById(packageId);
        if (ObjectUtil.isNull(tenantPackage)) {
            throw new ServiceException("套餐不存在");
        }
        // 获取套餐菜单id
        List<Long> menuIds = StringUtils.splitTo(tenantPackage.getMenuIds(), Convert::toLong);

        // 创建角色
        SysRole role = new SysRole();
        role.setTenantId(tenantId);
        role.setRoleName(TenantConstants.TENANT_ADMIN_ROLE_NAME);
        role.setRoleKey(TenantConstants.TENANT_ADMIN_ROLE_KEY);
        role.setRoleSort(1);
        role.setStatus(TenantConstants.NORMAL);
        roleMapper.insert(role);
        Long roleId = role.getRoleId();

        // 创建角色菜单
        List<SysRoleMenu> roleMenus = new ArrayList<>(menuIds.size());
        menuIds.forEach(menuId -> {
            SysRoleMenu roleMenu = new SysRoleMenu();
            roleMenu.setRoleId(roleId);
            roleMenu.setMenuId(menuId);
            roleMenus.add(roleMenu);
        });
        roleMenuMapper.insertBatch(roleMenus);

        return roleId;
    }
}
