package com.ginyon.test.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ginyon.common.core.controller.BaseController;
import com.ginyon.common.core.domain.R;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.log.annotaion.Log;
import com.ginyon.log.enums.BusinessType;
import com.ginyon.mybatis.domain.QueryParam;
import com.ginyon.test.domain.TestLeave;
import com.ginyon.test.service.ITestLeaveService;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;

/**
 * OA 请假申请Controller
 *
 * @author zwh
 * @date 2023-10-26
 */
@Validated
@RestController
@RequestMapping("/test/leave")
public class TestLeaveController extends BaseController {
    @Resource
    private ITestLeaveService testLeaveService;

    /**
     * 分页查询OA 请假申请列表
     */
    @SaCheckPermission("test:leave:list")
    @GetMapping("/list")
    public TableDataInfo<TestLeave> list(QueryParam queryParam, TestLeave testLeave) {
        return testLeaveService.selectPage(queryParam, testLeave);
    }


    /**
     * 获取OA 请假申请详细信息
     */
    @SaCheckPermission("test:leave:query")
    @GetMapping(value = "/{id}")
    public R<TestLeave> getInfo(@PathVariable("id") Long id) {
        return R.ok(testLeaveService.selectById(id));
    }

    /**
     * 新增OA 请假申请
     */
    @SaCheckPermission("test:leave:add")
    @Log(title = "OA 请假申请", businessType = BusinessType.INSERT)
    @PostMapping
    public R<Void> add(@Validated @RequestBody TestLeave testLeave) {
        return toR(testLeaveService.insert(testLeave));
    }

    /**
     * 修改OA 请假申请
     */
    @SaCheckPermission("test:leave:edit")
    @Log(title = "OA 请假申请", businessType = BusinessType.UPDATE)
    @PutMapping
    public R<Void> edit(@Validated @RequestBody TestLeave testLeave) {
        return toR(testLeaveService.update(testLeave));
    }

    /**
     * 删除OA 请假申请
     */
    @SaCheckPermission("test:leave:remove")
    @Log(title = "OA 请假申请", businessType = BusinessType.DELETE)
	@DeleteMapping("/{ids}")
    public R<Void> remove(@PathVariable Long[] ids) {
        return toR(testLeaveService.deleteByIds(ids));
    }

    /**
     * 提交审批
     */
    @SaCheckPermission("test:leave:submit")
    @Log(title = "OA 请假申请", businessType = BusinessType.OTHER)
    @GetMapping(value = "/submit/{id}")
    public R<Void> submit(@PathVariable("id") Long id) {
        return toR(testLeaveService.submit(id));
    }

    /**
     * 办理
     */
    @SaCheckPermission("flow:execute:handle")
    @Log(title = "流程实例", businessType = BusinessType.OTHER)
    @PostMapping("/handle")
    public R<Void> handle(@RequestBody TestLeave testLeave, Long taskId, String skipType, String message) {
        return toR(testLeaveService.handle(testLeave, taskId, skipType, message));
    }

}
