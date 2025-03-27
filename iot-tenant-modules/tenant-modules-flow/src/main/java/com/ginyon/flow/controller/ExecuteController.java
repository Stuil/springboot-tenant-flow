package com.ginyon.flow.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import cn.hutool.core.util.ObjUtil;
import cn.hutool.core.util.StrUtil;
import com.ginyon.common.constant.HttpStatus;
import com.ginyon.common.core.controller.BaseController;
import com.ginyon.common.core.domain.R;
import com.ginyon.common.core.page.PageDomain;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.common.core.page.TableSupport;
import com.ginyon.satoken.helper.LoginHelper;
import com.ginyon.system.api.ISysUserApi;
import com.ginyon.system.api.domain.SysRole;
import com.ginyon.system.api.domain.SysUser;
import com.ginyon.tenant.helper.TenantHelper;
import com.warm.flow.core.entity.HisTask;
import com.warm.flow.core.entity.Task;
import com.warm.flow.core.service.HisTaskService;
import com.warm.flow.core.service.TaskService;
import com.warm.flow.orm.entity.FlowHisTask;
import com.warm.flow.orm.entity.FlowTask;
import com.warm.tools.utils.page.Page;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.annotation.Resource;
import java.util.List;
import java.util.stream.Collectors;

/**
 * 流程实例Controller
 *
 * @author zwh
 * @date 2023-04-18
 */
@Validated
@RestController
@RequestMapping("/flow/execute")
public class ExecuteController extends BaseController {
    @Resource
    private ISysUserApi userService;

    @Resource
    private HisTaskService hisTaskService;

    @Resource
    private TaskService taskService;

    /**
     * 分页待办任务列表
     */
    @SaCheckPermission("flow:execute:toDoPage")
    @GetMapping("/toDoPage")
    public TableDataInfo<Task> toDoPage(FlowTask flowTask) {
        PageDomain pageDomain = TableSupport.buildPageRequest();
        Page<Task> page = Page.pageOf(pageDomain.getPageNum(), pageDomain.getPageSize());
        List<SysRole> roles = LoginHelper.getRoles();
        List<String> roleKeyList = roles.stream().map(role ->
                "role:" + role.getRoleId().toString()).collect(Collectors.toList());
        flowTask.setPermissionList(roleKeyList);
        flowTask.setTenantId(TenantHelper.getTenantId());
        page = taskService.toDoPage(flowTask, page);
        page.getList().forEach(instance -> {
            if (StrUtil.isNotBlank(instance.getApprover())) {
                SysUser sysUser = userService.selectUserById(Long.valueOf(instance.getApprover()));
                if (ObjUtil.isNotNull(sysUser)) {
                    instance.setApprover(sysUser.getNickName());
                }
            }
        });
        TableDataInfo rspData = new TableDataInfo();
        rspData.setCode(HttpStatus.SUCCESS);
        rspData.setMsg("查询成功");
        rspData.setRows(page.getList());
        rspData.setTotal(page.getTotal());
        return rspData;
    }

    /**
     * 分页已办任务列表
     */
    @SaCheckPermission("flow:execute:donePage")
    @GetMapping("/donePage")
    public TableDataInfo<HisTask> donePage(FlowHisTask flowHisTask) {
        PageDomain pageDomain = TableSupport.buildPageRequest();
        Page<HisTask> page = Page.pageOf(pageDomain.getPageNum(), pageDomain.getPageSize());
        List<SysRole> roles = LoginHelper.getRoles();
        List<String> roleKeyList = roles.stream().map(role ->
                "role:" + role.getRoleId().toString()).collect(Collectors.toList());
        flowHisTask.setPermissionList(roleKeyList);
        flowHisTask.setTenantId(TenantHelper.getTenantId());
        page = hisTaskService.donePage(flowHisTask, page);
        page.getList().forEach(hisTask -> {
            if (StrUtil.isNotBlank(hisTask.getApprover())) {
                SysUser sysUser = userService.selectUserById(Long.valueOf(hisTask.getApprover()));
                if (ObjUtil.isNotNull(sysUser)) {
                    hisTask.setApprover(sysUser.getNickName());
                }
            }
        });
        TableDataInfo rspData = new TableDataInfo();
        rspData.setCode(HttpStatus.SUCCESS);
        rspData.setMsg("查询成功");
        rspData.setRows(page.getList());
        rspData.setTotal(page.getTotal());
        return rspData;
    }

    /**
     * 查询已办任务历史记录
     */
    @SaCheckPermission("flow:execute:doneList")
    @GetMapping("/doneList/{instanceId}")
    public R<List<HisTask>> doneList(@PathVariable("instanceId") Long instanceId) {
        List<HisTask> flowHisTasks = hisTaskService.getByInsIds(instanceId);
        flowHisTasks.forEach(hisTask -> {
            if (StrUtil.isNotBlank(hisTask.getApprover())) {
                SysUser sysUser = userService.selectUserById(Long.valueOf(hisTask.getApprover()));
                hisTask.setApprover(sysUser.getNickName());
                if (ObjUtil.isNotNull(sysUser)) {
                    hisTask.setApprover(sysUser.getNickName());
                }
            }
        });
        return R.ok(flowHisTasks);
    }

}
