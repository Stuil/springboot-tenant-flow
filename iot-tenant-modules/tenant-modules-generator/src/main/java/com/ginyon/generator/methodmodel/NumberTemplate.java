package com.ginyon.generator.methodmodel;

import com.ginyon.common.utils.StringUtils;
import com.ginyon.generator.constant.GenConstants;
import com.ginyon.generator.util.GenUtils;
import freemarker.template.TemplateMethodModelEx;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;

/**
 * @author zwh
 * @description: 获取数字类型精度长度
 * @date: 2023/4/5 17:22
 */
public class NumberTemplate implements TemplateMethodModelEx {
    /**
     * 获取数字类型精度长度
     */
    @Override
    public Object exec(List args) {
        String columnType = args.get(0).toString();
        String dataType = GenUtils.getDbType(columnType);
        if (GenUtils.arraysContains(GenConstants.COLUMNTYPE_NUMBER, dataType)) {
            String[] str = StringUtils.split(StringUtils.substringBetween(columnType, "(", ")"), ",");
            HashMap<String, String> map = new HashMap<>(2);
            String str1 = String.format("%-" + str[0] + "s", 10).replace(" ", "0");
            map.put("first", String.valueOf(new BigDecimal(str1).subtract(new BigDecimal(1))));
            // 如果是否点型
            if (str != null && str.length == 2) {
                map.put("isFloat", "true");
                map.put("second", String.valueOf(str[1]));
                return map;
            }
            // 如果是整形或者长整型
            else if (str != null && str.length == 1) {
                map.put("isFloat", "false");
                return map;
            }
        }
        return null;
    }

}
