package com.ginyon.system.controller.system;

import cn.dev33.satoken.annotation.SaCheckPermission;
import cn.dev33.satoken.annotation.SaCheckRole;
import com.ginyon.common.constant.TenantConstants;
import com.ginyon.common.core.controller.BaseController;
import com.ginyon.common.core.domain.R;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.common.validate.AddGroup;
import com.ginyon.common.validate.EditGroup;
import com.ginyon.excel.poi.utils.ExcelUtil;
import com.ginyon.log.annotaion.Log;
import com.ginyon.log.enums.BusinessType;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.system.api.domain.SysTenant;
import com.ginyon.system.service.ISysTenantService;
import com.ginyon.tenant.helper.TenantHelper;
import com.ginyon.web.anaotation.RepeatSubmit;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.util.List;

/**
 * 租户Controller
 *
 * @author zwh
 * @date 2023-10-27
 */
@SaCheckRole(TenantConstants.SUPER_ADMIN_ROLE_KEY)
@Validated
@RestController
@RequestMapping("/system/tenant")
public class SysTenantController extends BaseController {
    @Resource
    private ISysTenantService tenantService;

    /**
     * 分页查询租户列表
     */
    @SaCheckPermission("system:tenant:list")
    @GetMapping("/list")
    public TableDataInfo<SysTenant> list(QueryParam queryParam, SysTenant sysTenant) {
        return tenantService.selectPage(queryParam, sysTenant);
    }

    /**
     * 导出租户列表
     */
    @SaCheckPermission("system:tenant:export")
    @Log(title = "租户", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysTenant sysTenant) {
        List<SysTenant> list = tenantService.selectList(sysTenant);
        ExcelUtil<SysTenant> util = new ExcelUtil<>(SysTenant.class);
        util.exportExcel(response, list, "租户数据");
    }

    /**
     * 获取租户详细信息
     */
    @SaCheckPermission("system:tenant:query")
    @GetMapping(value = "/{id}")
    public R<SysTenant> getInfo(@PathVariable("id") Long id) {
        return R.ok(tenantService.selectById(id));
    }

    /**
     * 新增租户
     */
    @SaCheckPermission("system:tenant:add")
    @Log(title = "租户", businessType = BusinessType.INSERT)
    @RepeatSubmit
    @PostMapping
    public R<Void> add(@Validated(AddGroup.class) @RequestBody SysTenant sysTenant) {
        if (!tenantService.checkCompanyNameUnique(sysTenant)) {
            return R.fail("新增租户'" + sysTenant.getCompanyName() + "'失败，企业名称已存在");
        }
        return toR(tenantService.insert(sysTenant));
    }

    /**
     * 修改租户
     */
    @SaCheckPermission("system:tenant:edit")
    @Log(title = "租户", businessType = BusinessType.UPDATE)
    @RepeatSubmit
    @PutMapping
    public R<Void> edit(@Validated(EditGroup.class) @RequestBody SysTenant sysTenant) {
        tenantService.checkTenantAllowed(sysTenant.getTenantId());
        if (!tenantService.checkCompanyNameUnique(sysTenant)) {
            return R.fail("修改租户'" + sysTenant.getCompanyName() + "'失败，公司名称已存在");
        }
        return toR(tenantService.update(sysTenant));
    }

    /**
     * 删除租户
     */
    @SaCheckPermission("system:tenant:remove")
    @Log(title = "租户", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public R<Void> remove(@PathVariable Long[] ids) {
        return toR(tenantService.deleteByIds(ids));
    }

    /**
     * 修改租户状态
     */
    @SaCheckPermission("system:tenantPackage:remove")
    @Log(title = "租户套餐", businessType = BusinessType.DELETE)
    @PutMapping("changeStatus")
    public R<Void> changeStatus(@RequestBody SysTenant sysTenant) {
        tenantService.checkTenantAllowed(sysTenant.getTenantId());
        return toR(tenantService.updateById(sysTenant));
    }

    /**
     * 动态切换租户
     *
     * @param tenantId 租户ID
     */
    @GetMapping("/dynamic/{tenantId}")
    public R<Void> dynamicTenant(@NotBlank(message = "租户ID不能为空") @PathVariable String tenantId) {
        TenantHelper.setDynamic(tenantId);
        return R.ok();
    }

    /**
     * 清除动态租户
     */
    @GetMapping("/dynamic/clear")
    public R<Void> dynamicClear() {
        TenantHelper.clearDynamic();
        return R.ok();
    }

    /**
     * 同步租户套餐
     *
     * @param tenantId  租户id
     * @param packageId 套餐id
     */
    @SaCheckPermission("system:tenant:edit")
    @Log(title = "租户", businessType = BusinessType.UPDATE)
    @GetMapping("/syncTenantPackage")
    public R<Void> syncTenantPackage(@NotBlank(message = "租户ID不能为空") String tenantId,
                                     @NotNull(message = "套餐ID不能为空") Long packageId) {
        return toR(tenantService.syncTenantPackage(tenantId, packageId));
    }

}
