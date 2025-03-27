package ${packageName}.controller;

import java.util.List;
<#if table.exportEnable == 'Y'>
import javax.servlet.http.HttpServletResponse;
</#if>
import javax.annotation.Resource;

import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import cn.dev33.satoken.annotation.SaCheckPermission;
<#if table.exportEnable == 'Y'>
import com.hh.excel.poi.utils.ExcelUtil;
</#if>
import com.hh.log.annotaion.Log;
import com.hh.common.core.controller.BaseController;
import com.hh.common.core.domain.R;
import com.hh.log.enums.BusinessType;
import com.hh.mybatis.domain.QueryParam;
import ${packageName}.domain.${ClassName};
import ${packageName}.service.I${ClassName}Service;
<#if table.crud || table.sub>
import com.hh.common.core.page.TableDataInfo;
<#elseif table.tree>
</#if>
<#if table.swaggerEnable == 'Y'>
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
</#if>

/**
 * ${functionName}Controller
 *
 * @author ${author}
 * @date ${datetime}
 */
<#if table.swaggerEnable == 'Y'>
@Api("${functionName}控制器")
</#if>
@Validated
@RestController
@RequestMapping("/${moduleName}/${businessName}")
public class ${ClassName}Controller extends BaseController {
    @Resource
    private I${ClassName}Service ${className}Service;

    /**
     * 分页查询${functionName}列表
     */
<#if table.swaggerEnable == 'Y'>
    @ApiOperation("分页查询${functionName}列表")
</#if>
    @SaCheckPermission("${permissionPrefix}:list")
    @GetMapping("/list")
<#if table.crud || table.sub>
    public TableDataInfo<${ClassName}> list(QueryParam queryParam, ${ClassName} ${className}) {
        return ${className}Service.selectPage(queryParam, ${className});
    }
<#elseif table.tree>
    public R<List<${ClassName}>> list(${ClassName} ${className}) {
        return R.ok(${className}Service.selectList(${className}));
    }
</#if>

<#if table.exportEnable == 'Y'>
    /**
     * 导出${functionName}列表
     */
    <#if table.swaggerEnable == 'Y'>
    @ApiOperation("导出${functionName}列表")
    </#if>
    @SaCheckPermission("${permissionPrefix}:export")
    @Log(title = "${functionName}", businessType = BusinessType.EXPORT)
    @PostMapping("/export")
    public void export(HttpServletResponse response, ${ClassName} ${className}) {
        List<${ClassName}> list = ${className}Service.selectList(${className});
        ExcelUtil<${ClassName}> util = new ExcelUtil<>(${ClassName}.class);
        util.exportExcel(response, list, "${functionName}数据");
    }
</#if>

    /**
     * 获取${functionName}详细信息
     */
<#if table.swaggerEnable == 'Y'>
    @ApiOperation("获取${functionName}详细信息")
</#if>
    @SaCheckPermission("${permissionPrefix}:query")
    @GetMapping(value = "/{${pkColumn.javaField}}")
    public R<${ClassName}> getInfo(@PathVariable("${pkColumn.javaField}") ${pkColumn.javaType} ${pkColumn.javaField}) {
        return R.ok(${className}Service.selectById(${pkColumn.javaField}));
    }

    /**
     * 新增${functionName}
     */
<#if table.swaggerEnable == 'Y'>
    @ApiOperation("新增${functionName}")
</#if>
    @SaCheckPermission("${permissionPrefix}:add")
    @Log(title = "${functionName}", businessType = BusinessType.INSERT)
    @PostMapping
    public R<Void> add(@Validated @RequestBody ${ClassName} ${className}) {
        return toR(${className}Service.insert(${className}));
    }

    /**
     * 修改${functionName}
     */
<#if table.swaggerEnable == 'Y'>
    @ApiOperation("修改${functionName}")
</#if>
    @SaCheckPermission("${permissionPrefix}:edit")
    @Log(title = "${functionName}", businessType = BusinessType.UPDATE)
    @PutMapping
    public R<Void> edit(@Validated @RequestBody ${ClassName} ${className}) {
        return toR(${className}Service.update(${className}));
    }

    /**
     * 删除${functionName}
     */
<#if table.swaggerEnable == 'Y'>
    @ApiOperation("删除${functionName}")
</#if>
    @SaCheckPermission("${permissionPrefix}:remove")
    @Log(title = "${functionName}", businessType = BusinessType.DELETE)
	@DeleteMapping("/{${pkColumn.javaField}s}")
    public R<Void> remove(@PathVariable ${pkColumn.javaType}[] ${pkColumn.javaField}s) {
        return toR(${className}Service.deleteByIds(${pkColumn.javaField}s));
    }

<#if table.flowEnable == 'Y'>
    /**
     * 提交审批
     */
    @SaCheckPermission("${permissionPrefix}:submit")
    @Log(title = "${functionName}", businessType = BusinessType.OTHER)
    @GetMapping(value = "/submit/{id}")
    public R<Void> submit(@PathVariable("id") ${pkColumn.javaType} ${pkColumn.javaField}) {
        return toR(${className}Service.submit(id));
    }

    /**
     * 办理
     */
    @SaCheckPermission("flow:execute:handle")
    @Log(title = "流程实例", businessType = BusinessType.OTHER)
    @PostMapping("/handle")
    public R<Void> handle(@RequestBody ${ClassName} ${className}, Long taskId, String skipType, String message) {
        return toR(${className}Service.handle(testLeave, taskId, skipType, message));
    }
</#if>

}
