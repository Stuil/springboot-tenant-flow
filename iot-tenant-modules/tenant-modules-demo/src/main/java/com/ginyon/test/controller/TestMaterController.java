package com.ginyon.test.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ginyon.common.core.controller.BaseController;
import com.ginyon.common.core.domain.R;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.excel.poi.utils.ExcelUtil;
import com.ginyon.log.annotaion.Log;
import com.ginyon.log.enums.BusinessType;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.test.domain.TestMater;
import com.ginyon.test.service.ITestMaterService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 主子演示Controller
 *
 * @author zwh
 * @date 2023-10-26
 */
@Validated
@RestController
@RequestMapping("/test/mater")
public class TestMaterController extends BaseController {
    @Resource
    private ITestMaterService testMaterService;

    /**
     * 分页查询主子演示列表
     */
    @SaCheckPermission("test:mater:list")
    @GetMapping("/list")
    public TableDataInfo<TestMater> list(QueryParam queryParam, TestMater testMater) {
        return testMaterService.selectPage(queryParam, testMater);
    }

    /**
     * 导出主子演示列表
     */
    @SaCheckPermission("test:mater:export")
    @Log(title = "主子演示", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, TestMater testMater) {
        List<TestMater> list = testMaterService.selectList(testMater);
        ExcelUtil<TestMater> util = new ExcelUtil<>(TestMater.class);
        util.exportExcel(response, list, "主子演示数据");
    }

    /**
     * 获取主子演示详细信息
     */
    @SaCheckPermission("test:mater:query")
    @GetMapping(value = "/{id}")
    public R<TestMater> getInfo(@PathVariable("id") Long id) {
        return R.ok(testMaterService.selectById(id));
    }

    /**
     * 新增主子演示
     */
    @SaCheckPermission("test:mater:add")
    @Log(title = "主子演示", businessType = BusinessType.INSERT)
    @PostMapping
    public R<Void> add(@Validated @RequestBody TestMater testMater) {
        return toR(testMaterService.insert(testMater));
    }

    /**
     * 修改主子演示
     */
    @SaCheckPermission("test:mater:edit")
    @Log(title = "主子演示", businessType = BusinessType.UPDATE)
    @PutMapping
    public R<Void> edit(@Validated @RequestBody TestMater testMater) {
        return toR(testMaterService.update(testMater));
    }

    /**
     * 删除主子演示
     */
    @SaCheckPermission("test:mater:remove")
    @Log(title = "主子演示", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public R<Void> remove(@PathVariable Long[] ids) {
        return toR(testMaterService.deleteByIds(ids));
    }


}
