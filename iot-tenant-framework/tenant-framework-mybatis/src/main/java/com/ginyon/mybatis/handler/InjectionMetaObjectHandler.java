package com.ginyon.mybatis.handler;

import cn.hutool.core.util.ObjectUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.http.HttpStatus;
import com.baomidou.mybatisplus.core.handlers.MetaObjectHandler;
import com.ginyon.common.core.domain.BaseEntity;
import com.ginyon.common.exception.ServiceException;
import com.ginyon.satoken.helper.LoginHelper;
import lombok.extern.slf4j.Slf4j;
import org.apache.ibatis.reflection.MetaObject;

import java.util.Date;

/**
 * MP注入处理器
 *
 * @author zwh
 * @date 2021/4/25
 */
@Slf4j
public class InjectionMetaObjectHandler implements MetaObjectHandler {

    @Override
    public void insertFill(MetaObject object) {
        try {
            if (ObjectUtil.isNotNull(object) && object.getOriginalObject() instanceof BaseEntity) {
                BaseEntity entity = (BaseEntity) object.getOriginalObject();
                Date date = ObjectUtil.isNotNull(entity.getCreateTime()) ? entity.getCreateTime() : new Date();
                String username = StrUtil.isNotBlank(entity.getCreateBy())
                        ? entity.getCreateBy() : LoginHelper.getUsernameNe();
                entity.setCreateBy(username);
                entity.setUpdateBy(username);
                entity.setCreateTime(date);
                entity.setUpdateTime(date);
            }
        } catch (Exception e) {
            throw new ServiceException("新增自动注入异常 => " + e.getMessage(), HttpStatus.HTTP_UNAUTHORIZED);
        }
    }

    @Override
    public void updateFill(MetaObject object) {
        try {
            if (ObjectUtil.isNotNull(object) && object.getOriginalObject() instanceof BaseEntity) {
                BaseEntity entity = (BaseEntity) object.getOriginalObject();
                entity.setUpdateBy(LoginHelper.getUsernameNe());
                entity.setUpdateTime(new Date());
            }
        } catch (Exception e) {
            throw new ServiceException("修改自动注入异常 => " + e.getMessage(), HttpStatus.HTTP_UNAUTHORIZED);
        }
    }

}
