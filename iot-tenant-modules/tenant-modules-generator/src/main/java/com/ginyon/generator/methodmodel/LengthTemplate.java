package com.ginyon.generator.methodmodel;

import com.ginyon.generator.constant.GenConstants;
import com.ginyon.generator.util.GenUtils;
import freemarker.template.TemplateMethodModelEx;

import java.util.List;

/**
 * @author zwh
 * @description: 获取长度
 * @date: 2023/4/5 17:22
 */
public class LengthTemplate implements TemplateMethodModelEx {
    /**
     * 获取字符串或者精度长度
     */
    @Override
    public Object exec(List args) {
        String columnType = args.get(0).toString();
        String dataType = GenUtils.getDbType(columnType);
        if (GenUtils.arraysContains(GenConstants.COLUMNTYPE_STR, dataType)) {
            Integer columnLength = GenUtils.getColumnLength(columnType);
            return String.valueOf(columnLength);
        }
        return null;
    }

}
