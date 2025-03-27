package com.ginyon.system.controller.monitor;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ginyon.common.core.controller.BaseController;
import com.ginyon.common.core.domain.AjaxResult;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.excel.poi.utils.ExcelUtil;
import com.ginyon.log.annotaion.Log;
import com.ginyon.log.enums.BusinessType;
import com.ginyon.mybatis.utils.PageUtils;
import com.ginyon.system.api.domain.SysOperLog;
import com.ginyon.system.service.ISysOperLogServeice;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * 操作日志记录
 *
 * @author zwh
 */
@RestController
@RequestMapping("/monitor/operlog")
public class SysOperlogController extends BaseController {
    @Resource
    private ISysOperLogServeice operLogService;

    @SaCheckPermission("monitor:operlog:list")
    @GetMapping("/list")
    public TableDataInfo list(SysOperLog operLog) {
        PageUtils.startPage();
        List<SysOperLog> list = operLogService.selectOperLogList(operLog);
        return PageUtils.getDataTable(list);
    }

    @Log(title = "操作日志", businessType = BusinessType.EXPORT)
    @SaCheckPermission("monitor:operlog:export")
    @PostMapping("/export")
    public void export(HttpServletResponse response, SysOperLog operLog) {
        List<SysOperLog> list = operLogService.selectOperLogList(operLog);
        ExcelUtil<SysOperLog> util = new ExcelUtil<SysOperLog>(SysOperLog.class);
        util.exportExcel(response, list, "操作日志");
    }

    @Log(title = "操作日志", businessType = BusinessType.DELETE)
    @SaCheckPermission("monitor:operlog:remove")
    @DeleteMapping("/{operIds}")
    public AjaxResult remove(@PathVariable Long[] operIds) {
        return toAjax(operLogService.deleteOperLogByIds(operIds));
    }

    @Log(title = "操作日志", businessType = BusinessType.CLEAN)
    @SaCheckPermission("monitor:operlog:remove")
    @DeleteMapping("/clean")
    public AjaxResult clean() {
        operLogService.cleanOperLog();
        return success();
    }
}
