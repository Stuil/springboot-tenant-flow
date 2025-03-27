package ${packageName}.service.impl;

import cn.hutool.core.collection.CollUtil;
<#list columns as column>
    <#if column.query>
        <#if  column.queryType == "BETWEEN">
import cn.hutool.core.util.ObjectUtil;
<#break>
        </#if>
    </#if>
</#list>
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import ${packageName}.domain.${ClassName};
<#if table.sub>
import ${packageName}.domain.${subClassName};
</#if>
import ${packageName}.mapper.${ClassName}Mapper;
import ${packageName}.service.I${ClassName}Service;
<#if table.sub>
import ${packageName}.service.I${subClassName}Service;
</#if>
<#if table.crud || table.sub>
import com.hh.common.core.page.TableDataInfo;
import com.hh.mybatis.domain.QueryParam;
</#if>
import com.hh.common.utils.StringUtils;
<#if table.flowEnable == 'Y'>
import com.hh.common.utils.uuid.IdUtils;
import com.hh.satoken.helper.LoginHelper;
import com.hh.system.api.LoginUser;
import com.hh.tenant.helper.TenantHelper;
import com.warm.flow.core.dto.FlowParams;
import com.warm.flow.core.entity.Instance;
import com.warm.flow.core.service.InsService;
import com.warm.flow.core.enums.SkipType;
import java.util.stream.Collectors;
import com.hh.system.api.domain.SysRole;
</#if>
import com.hh.mybatis.service.impl.BaseServiceImpl;
<#if table.crud ||  table.sub>
import com.hh.mybatis.utils.PageUtils;
</#if>
import org.springframework.stereotype.Component;
import javax.annotation.Resource;
<#if table.sub || table.flowEnable == 'Y'>
import org.springframework.transaction.annotation.Transactional;
</#if>

import java.util.*;
<#list columns as column>
    <#if  column.queryType == "BETWEEN">
import java.util.Map;
    </#if>
</#list>

/**
 * ${functionName}Service业务层处理
 *
 * @author ${author}
 * @date ${datetime}
 */
@Component
public class ${ClassName}ServiceImpl extends BaseServiceImpl<${ClassName}Mapper, ${ClassName}> implements I${ClassName}Service {

    @Resource
    private ${ClassName}Mapper ${className}Mapper;

<#if table.flowEnable == 'Y'>
    @Resource
    private InsService insService;
</#if>

<#if table.sub>
    @Resource
    private I${subClassName}Service ${subclassName}Service;

</#if>

    @Override
    public ${ClassName} selectById(${pkColumn.javaType} ${pkColumn.javaField}) {
        <#if table.sub>
        ${ClassName} ${className} = ${className}Mapper.selectById(${pkColumn.javaField});
        List<${subClassName}> subDoList = ${subclassName}Service.list(Wrappers.lambdaQuery(${subClassName}.class)
            .eq(${subClassName}::get${subTableFkClassName}, ${className}.get${pkColumn.capJavaField}()));
        ${className}.set${subClassName}List(subDoList);
        return ${className};
        <#else>
        return ${className}Mapper.selectById(${pkColumn.javaField});
        </#if>

    }

<#if table.crud || table.sub>
    @Override
    public TableDataInfo<${ClassName}> selectPage(QueryParam queryParam, ${ClassName} ${className}) {
        LambdaQueryWrapper<${ClassName}> qw = buildQuery(${className});
        Page<${ClassName}> page = ${className}Mapper.selectPage(queryParam.getPage(), qw);
        if (CollUtil.isEmpty(page.getRecords())) {
            page.setRecords(Collections.emptyList());
        }
        return PageUtils.build(page);
    }
</#if>

    @Override
    public List<${ClassName}> selectList(${ClassName} ${className}) {
        List<${ClassName}> ${className}s = ${className}Mapper.selectList(buildQuery(${className}));
        if (CollUtil.isEmpty(${className}s)) {
            return Collections.emptyList();
        }
        return ${className}s;
    }

    public LambdaQueryWrapper<${ClassName}> buildQuery(${ClassName} ${className}) {
<#list columns as column>
    <#if  column.queryType == "BETWEEN">
        Map<String, Object> params = ${className}.getParams();
        <#break/>
    </#if>
</#list>
        return Wrappers.lambdaQuery(${ClassName}.class)
<#assign  endNum = 0>
<#list columns as column>
    <#if column.query>
        <#assign  endNum = endNum + 1>
    </#if>
</#list>
<#assign  queryNum = 0>
<#list columns as column>
    <#if column.query>
        <#assign  queryNum = queryNum + 1>
        <#assign  queryType = column.queryType>
        <#assign  AttrName = column.javaField?substring(0,1)?upperCase + column.javaField?substring(1)>
        <#if column.javaType == 'String'>
            <#assign condition='StringUtils.isNotBlank(' + className+ '.get' + AttrName + '())'>
        <#else>
            <#assign condition=className + '.get'+AttrName+'() != null'>
        </#if>
        <#import "/templates/function/util.ftlh" as util>
        <#if  queryType == "BETWEEN">
                .between(!ObjectUtil.hasNull(params.get("begin${AttrName}"), params.get("end${AttrName}")),
                    ${ClassName}::get${AttrName}, params.get("begin${AttrName}"), params.get("end${AttrName}"))<#if queryNum == endNum>
                .orderByDesc(${ClassName}::getCreateTime);</#if>
        <#else>
                .${util.queryWay(queryType)}(${condition}, ${ClassName}::get${AttrName}, ${className}.get${AttrName}())<#if queryNum == endNum>
                .orderByDesc(${ClassName}::getCreateTime);</#if>
        </#if>
    </#if>
</#list>
    }

    @Override
<#if table.sub || table.flowEnable == 'Y'>
    @Transactional(rollbackFor = Exception.class)
</#if>
    public boolean insert(${ClassName} ${className}) {
<#if table.sub>
        int rows = ${className}Mapper.insert(${className});
        insert${subClassName}(${className});
        return rows > 0;
<#else>
    <#if table.flowEnable == 'Y'>
        Long id = IdUtils.snowflakeId();
        LoginUser user = LoginHelper.get();
        FlowParams flowParams = FlowParams.build().flowCode("${tableName}")
                .createBy(user.getUser().getUserId().toString())
                .nickName(user.getUser().getNickName())
                .tenantId(TenantHelper.getTenantId());
        Instance instance = insService.start(String.valueOf(id), flowParams);
        ${className}.setId(id);
        ${className}.setInstanceId(instance.getId());
        ${className}.setNodeCode(instance.getNodeCode());
        ${className}.setNodeName(instance.getNodeName());
        ${className}.setFlowStatus(instance.getFlowStatus());
        return save(${className});
    <#else>
        return ${className}Mapper.insert(${className}) > 0;
    </#if>
</#if>
    }

    @Override
<#if table.sub>
    @Transactional(rollbackFor = Exception.class)
</#if>
    public boolean update(${ClassName} ${className}) {
<#list columns as column>
</#list>
<#if table.sub>
        ${subclassName}Service.remove(Wrappers.lambdaQuery(${subClassName}.class).eq(${subClassName}::get${subTableFkClassName}, ${className}.get${pkColumn.capJavaField}()));
        insert${subClassName}(${className});
</#if>
        return ${className}Mapper.updateById(${className}) > 0;
    }

    @Override
<#if table.sub || table.flowEnable == 'Y'>
    @Transactional(rollbackFor = Exception.class)
</#if>
    public boolean deleteByIds(${pkColumn.javaType}[] ${pkColumn.javaField}s) {
<#if table.sub>
        List<${pkColumn.javaType}> ${pkColumn.javaField}List = Arrays.asList(${pkColumn.javaField}s);
        ${subclassName}Service.remove(Wrappers.lambdaQuery(${subClassName}.class).in(${subClassName}::get${subTableFkClassName}, ${pkColumn.javaField}List));
        return ${className}Mapper.deleteBatchIds(${pkColumn.javaField}List) > 0;
<#else>
    <#if table.flowEnable == 'Y'>
        List<${ClassName}> ${className}List = listByIds(Arrays.asList(ids));
        if (removeByIds(Arrays.asList(ids))) {
            List<Long> instanceIds = ${className}List.stream().map(${ClassName}::getInstanceId).collect(Collectors.toList());
            return insService.remove(instanceIds);
        }
        return false;
     <#else>
        return ${className}Mapper.deleteBatchIds(Arrays.asList(${pkColumn.javaField}s)) > 0;
    </#if>
</#if>
    }

<#if table.flowEnable == 'Y'>
    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean submit(${pkColumn.javaType} ${pkColumn.javaField}) {
        ${ClassName} testLeave = getById(${pkColumn.javaField});
        LoginUser user = LoginHelper.get();
        FlowParams flowParams = FlowParams.build().createBy(user.getUser().getUserId().toString())
                .nickName(user.getUser().getNickName())
                .skipType(SkipType.PASS.getKey());
        List<SysRole> roles = user.getUser().getRoles();
        if (Objects.nonNull(roles)) {
            List<String> roleList = roles.stream().map(role -> "role:" + role.getRoleId()).collect(Collectors.toList());
            flowParams.permissionFlag(roleList);
        }
        Instance instance = insService.skipByInsId(testLeave.getInstanceId(), flowParams);
        ${className}.setNodeCode(instance.getNodeCode());
        ${className}.setNodeName(instance.getNodeName());
        ${className}.setFlowStatus(instance.getFlowStatus());
        return updateById(${className});
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Boolean handle(${ClassName} ${className}, Long taskId, String skipType, String message) {
        // 设置流转参数
        LoginUser user = LoginHelper.get();
        FlowParams flowParams = FlowParams.build().createBy(user.getUser().getUserId().toString())
                .nickName(user.getUser().getNickName())
                .skipType(skipType)
                .message(message);
        List<SysRole> roles = user.getUser().getRoles();
        if (Objects.nonNull(roles)) {
            List<String> roleList = roles.stream().map(role -> "role:" + role.getRoleId()).collect(Collectors.toList());
            flowParams.permissionFlag(roleList);
        }

        Instance instance = insService.skip(taskId, flowParams);
        ${className}.setNodeCode(instance.getNodeCode());
        ${className}.setNodeName(instance.getNodeName());
        ${className}.setFlowStatus(instance.getFlowStatus());
        updateById(${className});
        return true;
    }
</#if>

<#if table.sub>
    private void insert${subClassName}(${ClassName} ${className}) {
        List<${subClassName}> subList = ${className}.get${subClassName}List();
        ${pkColumn.javaType} ${pkColumn.javaField} = ${className}.get${pkColumn.capJavaField}();
        if (CollUtil.isNotEmpty(subList)) {
            subList.forEach(sub -> {
                sub.set${subTableFkClassName}(${pkColumn.javaField});
                sub.set${pkColumn.capJavaField}(null);
            });
            ${subclassName}Service.saveBatch(subList);
        }
    }
</#if>
}
