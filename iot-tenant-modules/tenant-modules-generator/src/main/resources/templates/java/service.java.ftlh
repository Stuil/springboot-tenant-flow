package ${packageName}.service;

import ${packageName}.domain.${ClassName};
<#if table.crud ||  table.sub>
import com.hh.mybatis.domain.QueryParam;
import com.hh.common.core.page.TableDataInfo;
</#if>
import com.hh.mybatis.service.IBaseService;

import java.util.List;

/**
 * ${functionName}Service接口
 *
 * @author ${author}
 */
public interface I${ClassName}Service extends IBaseService<${ClassName}> {
    /**
     * 查询${functionName}
     *
     * @param ${pkColumn.javaField} ${functionName}主键
     * @return ${functionName}
     */
    public ${ClassName} selectById(${pkColumn.javaType} ${pkColumn.javaField});

    <#if table.crud ||  table.sub>
    /**
     * 分页查询${functionName}列表
     *
     * @param queryParam 分页对象
     * @param ${className} ${functionName}
     * @return 分页对象
     */
    TableDataInfo<${ClassName}> selectPage(QueryParam queryParam, ${ClassName} ${className});
    </#if>

    /**
     * 查询${functionName}列表
     *
     * @param ${className} ${functionName}
     * @return ${functionName}集合
     */
    public List<${ClassName}> selectList(${ClassName} ${className});

    /**
     * 新增${functionName}
     *
     * @param ${className} ${functionName}
     * @return 结果
     */
    public boolean insert(${ClassName} ${className});

    /**
     * 修改${functionName}
     *
     * @param ${className} ${functionName}
     * @return 结果
     */
    public boolean update(${ClassName} ${className});

    /**
     * 批量删除${functionName}
     *
     * @param ${pkColumn.javaField}s 需要删除的${functionName}主键集合
     * @return 结果
     */
    public boolean deleteByIds(${pkColumn.javaType}[] ${pkColumn.javaField}s);

<#if table.flowEnable == 'Y'>
    /**
     * 提交审批
     *
     * @param id
     * @return
     */
    public boolean submit(${pkColumn.javaType} ${pkColumn.javaField});

	/**
     * 办理
     *
     * @param ${className}
     * @param taskId
     * @param skipType
     * @param message
     * @return
     */
    Boolean handle(${ClassName} ${className}, Long taskId, String skipType, String message);
</#if>

}
