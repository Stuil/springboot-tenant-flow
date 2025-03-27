package ${packageName}.service.impl;

import com.hh.mybatis.service.impl.BaseServiceImpl;
import org.springframework.stereotype.Service;
import ${packageName}.mapper.${subClassName}Mapper;
import ${packageName}.domain.${subClassName};
import ${packageName}.service.I${subClassName}Service;

/**
 * ${subTable.functionName}Service业务层处理
 *
 * @author ${author}
 * @date ${datetime}
 */
@Service
public class ${subClassName}ServiceImpl extends BaseServiceImpl<${subClassName}Mapper, ${subClassName}> implements I${subClassName}Service
{

}
