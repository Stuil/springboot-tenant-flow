package com.ginyon.quartz.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ginyon.common.core.controller.BaseController;
import com.ginyon.common.core.domain.AjaxResult;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.excel.poi.utils.ExcelUtil;
import com.ginyon.log.annotaion.Log;
import com.ginyon.log.enums.BusinessType;
import com.ginyon.mybatis.utils.PageUtils;
import com.ginyon.quartz.domain.SysJobLog;
import com.ginyon.quartz.service.ISysJobLogService;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 调度日志操作处理
 *
 * @author zwh
 */
@RestController
@RequestMapping("/monitor/jobLog")
public class SysJobLogController extends BaseController {
    @Resource
    private ISysJobLogService jobLogService;

    /**
     * 查询定时任务调度日志列表
     */
    @SaCheckPermission("monitor:job:list")
    @GetMapping("/list")
    public TableDataInfo list(SysJobLog sysJobLog) {
        PageUtils.startPage();
        List<SysJobLog> list = jobLogService.selectJobLogList(sysJobLog);
        return PageUtils.getDataTable(list);
    }

    /**
     * 导出定时任务调度日志列表
     */
    @SaCheckPermission("monitor:job:export")
    @Log(title = "任务调度日志", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysJobLog sysJobLog) {
        List<SysJobLog> list = jobLogService.selectJobLogList(sysJobLog);
        ExcelUtil<SysJobLog> util = new ExcelUtil<SysJobLog>(SysJobLog.class);
        util.exportExcel(response, list, "调度日志");
    }

    /**
     * 根据调度编号获取详细信息
     */
    @SaCheckPermission("monitor:job:query")
    @GetMapping(value = "/{jobLogId}")
    public AjaxResult getInfo(@PathVariable Long jobLogId) {
        return success(jobLogService.selectJobLogById(jobLogId));
    }


    /**
     * 删除定时任务调度日志
     */
    @SaCheckPermission("monitor:job:remove")
    @Log(title = "定时任务调度日志", businessType = BusinessType.DELETE)
    @DeleteMapping("/{jobLogIds}")
    public AjaxResult remove(@PathVariable Long[] jobLogIds) {
        return toAjax(jobLogService.deleteJobLogByIds(jobLogIds));
    }

    /**
     * 清空定时任务调度日志
     */
    @SaCheckPermission("monitor:job:remove")
    @Log(title = "调度日志", businessType = BusinessType.CLEAN)
    @DeleteMapping("/clean")
    public AjaxResult clean() {
        jobLogService.cleanJobLog();
        return success();
    }
}
