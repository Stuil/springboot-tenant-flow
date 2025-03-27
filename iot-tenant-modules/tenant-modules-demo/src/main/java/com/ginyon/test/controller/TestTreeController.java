package com.ginyon.test.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ginyon.common.core.controller.BaseController;
import com.ginyon.common.core.domain.R;
import com.ginyon.log.annotaion.Log;
import com.ginyon.log.enums.BusinessType;
import com.ginyon.test.domain.TestTree;
import com.ginyon.test.service.ITestTreeService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import java.util.List;

/**
 * 测试树Controller
 *
 * @author zwh
 * @date 2023-10-26
 */
@Validated
@RestController
@RequestMapping("/test/tree")
public class TestTreeController extends BaseController {
    @Resource
    private ITestTreeService testTreeService;

    /**
     * 分页查询测试树列表
     */
    @SaCheckPermission("test:tree:list")
    @GetMapping("/list")
    public R<List<TestTree>> list(TestTree testTree) {
        return R.ok(testTreeService.selectList(testTree));
    }


    /**
     * 获取测试树详细信息
     */
    @SaCheckPermission("test:tree:query")
    @GetMapping(value = "/{id}")
    public R<TestTree> getInfo(@PathVariable("id") Long id) {
        return R.ok(testTreeService.selectById(id));
    }

    /**
     * 新增测试树
     */
    @SaCheckPermission("test:tree:add")
    @Log(title = "测试树", businessType = BusinessType.INSERT)
    @PostMapping
    public R<Void> add(@Validated @RequestBody TestTree testTree) {
        return toR(testTreeService.insert(testTree));
    }

    /**
     * 修改测试树
     */
    @SaCheckPermission("test:tree:edit")
    @Log(title = "测试树", businessType = BusinessType.UPDATE)
    @PutMapping
    public R<Void> edit(@Validated @RequestBody TestTree testTree) {
        return toR(testTreeService.update(testTree));
    }

    /**
     * 删除测试树
     */
    @SaCheckPermission("test:tree:remove")
    @Log(title = "测试树", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public R<Void> remove(@PathVariable Long[] ids) {
        return toR(testTreeService.deleteByIds(ids));
    }


}
