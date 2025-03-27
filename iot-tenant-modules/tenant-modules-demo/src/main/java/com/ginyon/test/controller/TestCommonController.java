package com.ginyon.test.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ginyon.common.core.controller.BaseController;
import com.ginyon.common.core.domain.R;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.excel.poi.utils.ExcelUtil;
import com.ginyon.log.annotaion.Log;
import com.ginyon.log.enums.BusinessType;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.test.domain.TestCommon;
import com.ginyon.test.service.ITestCommonService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 常规演示Controller
 *
 * @author zwh
 * @date 2023-10-30
 */
@Validated
@RestController
@RequestMapping("/test/common")
public class TestCommonController extends BaseController {
    @Resource
    private ITestCommonService testCommonService;

    /**
     * 分页查询常规演示列表
     */
    @SaCheckPermission("test:common:list")
    @GetMapping("/list")
    public TableDataInfo<TestCommon> list(QueryParam queryParam, TestCommon testCommon) {
        return testCommonService.selectPage(queryParam, testCommon);
    }

    /**
     * 导出常规演示列表
     */
    @SaCheckPermission("test:common:export")
    @Log(title = "常规演示", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TestCommon testCommon) {
        List<TestCommon> list = testCommonService.selectList(testCommon);
        ExcelUtil<TestCommon> util = new ExcelUtil<>(TestCommon.class);
        util.exportExcel(response, list, "常规演示数据");
    }

    /**
     * 获取常规演示详细信息
     */
    @SaCheckPermission("test:common:query")
    @GetMapping(value = "/{id}")
    public R<TestCommon> getInfo(@PathVariable("id") Long id) {
        return R.ok(testCommonService.selectById(id));
    }

    /**
     * 新增常规演示
     */
    @SaCheckPermission("test:common:add")
    @Log(title = "常规演示", businessType = BusinessType.INSERT)
    @PostMapping
    public R<Void> add(@Validated @RequestBody TestCommon testCommon) {
        return toR(testCommonService.insert(testCommon));
    }

    /**
     * 修改常规演示
     */
    @SaCheckPermission("test:common:edit")
    @Log(title = "常规演示", businessType = BusinessType.UPDATE)
    @PutMapping
    public R<Void> edit(@Validated @RequestBody TestCommon testCommon) {
        return toR(testCommonService.update(testCommon));
    }

    /**
     * 删除常规演示
     */
    @SaCheckPermission("test:common:remove")
    @Log(title = "常规演示", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    public R<Void> remove(@PathVariable Long[] ids) {
        return toR(testCommonService.deleteByIds(ids));
    }


}
