package com.ginyon.flow.controller;

import cn.dev33.satoken.annotation.SaCheckPermission;
import com.ginyon.common.constant.HttpStatus;
import com.ginyon.common.core.controller.BaseController;
import com.ginyon.common.core.domain.R;
import com.ginyon.common.core.page.PageDomain;
import com.ginyon.common.core.page.TableDataInfo;
import com.ginyon.common.core.page.TableSupport;
import com.ginyon.log.annotaion.Log;
import com.ginyon.log.enums.BusinessType;
import com.warm.flow.core.entity.Definition;
import com.warm.flow.core.service.DefService;
import com.warm.flow.orm.entity.FlowDefinition;
import com.warm.tools.utils.page.Page;
import org.dom4j.Document;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * 流程定义Controller
 *
 * @author zwh
 * @date 2023-04-11
 */
@Validated
@RestController
@RequestMapping("/flow/definition")
public class DefController extends BaseController {
    @Resource
    private DefService defService;

    /**
     * 分页查询流程定义列表
     */
    @GetMapping("/list")
    public TableDataInfo<FlowDefinition> list(FlowDefinition flowDefinition) {
        // flow组件自带分页功能
        PageDomain pageDomain = TableSupport.buildPageRequest();
        Page<Definition> page = Page.pageOf(pageDomain.getPageNum(), pageDomain.getPageSize());
        page = defService.orderByCreateTime().desc().page(flowDefinition, page);
        TableDataInfo rspData = new TableDataInfo();
        rspData.setCode(HttpStatus.SUCCESS);
        rspData.setMsg("查询成功");
        rspData.setRows(page.getList());
        rspData.setTotal(page.getTotal());
        return rspData;
    }


    /**
     * 获取流程定义详细信息
     */
    @SaCheckPermission("flow:definition:query")
    @GetMapping(value = "/{id}")
    public R<Definition> getInfo(@PathVariable("id") Long id) {
        return R.ok(defService.getById(id));
    }

    /**
     * 新增流程定义
     */
    @SaCheckPermission("flow:definition:add")
    @Log(title = "流程定义", businessType = BusinessType.INSERT)
    @PostMapping
    @Transactional(rollbackFor = Exception.class)
    public R add(@RequestBody FlowDefinition flowDefinition) {
        return R.ok(defService.checkAndSave(flowDefinition));
    }

    /**
     * 发布流程定义
     */
    @SaCheckPermission("flow:definition:publish")
    @Log(title = "流程定义", businessType = BusinessType.INSERT)
    @GetMapping("/publish/{id}")
    @Transactional(rollbackFor = Exception.class)
    public R publish(@PathVariable("id") Long id) {
        return R.ok(defService.publish(id));
    }

    /**
     * 取消发布流程定义
     */
    @SaCheckPermission("flow:definition:publish")
    @Log(title = "流程定义", businessType = BusinessType.INSERT)
    @GetMapping("/unPublish/{id}")
    @Transactional(rollbackFor = Exception.class)
    public R<Void> unPublish(@PathVariable("id") Long id) {
        defService.unPublish(id);
        return R.ok();
    }

    /**
     * 修改流程定义
     */
    @SaCheckPermission("flow:definition:edit")
    @Log(title = "流程定义", businessType = BusinessType.UPDATE)
    @PutMapping
    @Transactional(rollbackFor = Exception.class)
    public R edit(@RequestBody FlowDefinition flowDefinition) {
        return R.ok(defService.updateById(flowDefinition));
    }

    /**
     * 删除流程定义
     */
    @SaCheckPermission("flow:definition:remove")
    @Log(title = "流程定义", businessType = BusinessType.DELETE)
    @DeleteMapping("/{ids}")
    @Transactional(rollbackFor = Exception.class)
    public R remove(@PathVariable List<Long> ids) {
        return R.ok(defService.removeDef(ids));
    }

    @Log(title = "流程定义", businessType = BusinessType.IMPORT)
    @SaCheckPermission("flow:definition:importDefinition")
    @PostMapping("/saveXml")
    @Transactional(rollbackFor = Exception.class)
    public R<Void> saveXml(@RequestBody FlowDefinition def) throws Exception {
        defService.saveXml(def);
        return R.ok();
    }

    @Log(title = "流程定义", businessType = BusinessType.IMPORT)
    @SaCheckPermission("flow:definition:importDefinition")
    @PostMapping("/importDefinition")
    public R<Void> importDefinition(MultipartFile file) throws Exception {
        defService.importXml(file.getInputStream());
        return R.ok();
    }

    @Log(title = "流程定义", businessType = BusinessType.EXPORT)
    @SaCheckPermission("flow:definition:exportDefinition")
    @PostMapping("/exportDefinition/{id}")
    public void exportDefinition(@PathVariable("id") Long id, HttpServletResponse response) throws Exception {
        Document document = defService.exportXml(id);
        // 设置生成xml的格式
        OutputFormat of = OutputFormat.createPrettyPrint();
        // 设置编码格式
        of.setEncoding("UTF-8");
        of.setIndent(true);
        of.setIndent("    ");
        of.setNewlines(true);

        // 创建一个xml文档编辑器
        XMLWriter writer = new XMLWriter(response.getOutputStream(), of);
        writer.setEscapeText(false);
        response.reset();
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/x-msdownload");
        response.setHeader("Content-Disposition", "attachment;");
        writer.write(document);
        writer.close();
    }

    @Log(title = "获取流程定义xml字符串", businessType = BusinessType.EXPORT)
    @SaCheckPermission("flow:definition:exportDefinition")
    @GetMapping("/xmlString/{id}")
    public R<String> xmlString(@PathVariable("id") Long id, HttpServletResponse response) throws Exception {
        return R.ok(defService.xmlString(id));
    }

    /**
     * 查询流程图
     *
     * @param instanceId
     * @return
     * @throws IOException
     */
    @GetMapping("/flowChart/{instanceId}")
    public R<String> flowChart(@PathVariable("instanceId") Long instanceId) throws IOException {
        return R.ok(defService.flowChart(instanceId));
    }
}
