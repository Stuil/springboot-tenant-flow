package com.ginyon.system.controller.system;

import cn.dev33.satoken.annotation.SaCheckPermission;
import cn.dev33.satoken.annotation.SaCheckRole;
import com.ginyon.common.constant.TenantConstants;
import com.ginyon.common.core.controller.BaseController;
import com.ginyon.common.core.domain.R;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.excel.poi.utils.ExcelUtil;
import com.ginyon.log.annotaion.Log;
import com.ginyon.log.enums.BusinessType;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.system.api.domain.SysTenantPackage;
import com.ginyon.system.service.ISysTenantPackageService;
import com.ginyon.web.anaotation.RepeatSubmit;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 租户套餐Controller
 *
 * @author zwh
 * @date 2023-10-26
 */
@SaCheckRole(TenantConstants.SUPER_ADMIN_ROLE_KEY)
@Validated
@RestController
@RequestMapping("/system/tenant/package")
public class SysTenantPackageController extends BaseController {
    @Resource
    private ISysTenantPackageService sysTenantPackageService;

    /**
     * 分页查询租户套餐列表
     */
    @SaCheckPermission("system:tenantPackage:list")
    @GetMapping("/list")
    public TableDataInfo<SysTenantPackage> list(QueryParam queryParam, SysTenantPackage sysTenantPackage) {
        return sysTenantPackageService.selectPage(queryParam, sysTenantPackage);
    }

    /**
     * 查询租户套餐下拉选列表
     */
    @SaCheckPermission("system:tenantPackage:list")
    @GetMapping("/selectList")
    public R<List<SysTenantPackage>> selectList() {
        return R.ok(sysTenantPackageService.selectList());
    }


    /**
     * 导出租户套餐列表
     */
    @SaCheckPermission("system:tenantPackage:export")
    @Log(title = "租户套餐", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysTenantPackage sysTenantPackage) {
        List<SysTenantPackage> list = sysTenantPackageService.selectList(sysTenantPackage);
        ExcelUtil<SysTenantPackage> util = new ExcelUtil<>(SysTenantPackage.class);
        util.exportExcel(response, list, "租户套餐数据");
    }

    /**
     * 获取租户套餐详细信息
     */
    @SaCheckPermission("system:tenantPackage:query")
    @GetMapping(value = "/{packageId}")
    public R<SysTenantPackage> getInfo(@PathVariable("packageId") Long packageId) {
        return R.ok(sysTenantPackageService.selectById(packageId));
    }

    /**
     * 新增租户套餐
     */
    @SaCheckPermission("system:tenantPackage:add")
    @Log(title = "租户套餐", businessType = BusinessType.INSERT)
    @RepeatSubmit
    @PostMapping
    public R<Void> add(@Validated @RequestBody SysTenantPackage sysTenantPackage) {
        return toR(sysTenantPackageService.insert(sysTenantPackage));
    }

    /**
     * 修改租户套餐
     */
    @SaCheckPermission("system:tenantPackage:edit")
    @Log(title = "租户套餐", businessType = BusinessType.UPDATE)
    @RepeatSubmit
    @PutMapping
    public R<Void> edit(@Validated @RequestBody SysTenantPackage sysTenantPackage) {
        return toR(sysTenantPackageService.update(sysTenantPackage));
    }

    /**
     * 删除租户套餐
     */
    @SaCheckPermission("system:tenantPackage:remove")
    @Log(title = "租户套餐", businessType = BusinessType.DELETE)
	@DeleteMapping("/{packageIds}")
    public R<Void> remove(@PathVariable Long[] packageIds) {
        return toR(sysTenantPackageService.deleteByIds(packageIds));
    }

    /**
     * 修改租户套餐状态
     */
    @SaCheckPermission("system:tenantPackage:remove")
    @Log(title = "租户套餐", businessType = BusinessType.DELETE)
    @PutMapping("changeStatus")
    public R<Void> changeStatus(@RequestBody SysTenantPackage sysTenantPackage) {
        return toR(sysTenantPackageService.updateById(sysTenantPackage));
    }
}
