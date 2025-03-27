package com.ginyon.mybatis.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ginyon.common.core.domain.BaseEntity;
import com.ginyon.mybatis.service.IBaseService;

/**
 * BaseService层处理
 *
 * @author zwh
 * @date 2023-03-17
 */
public abstract class BaseServiceImpl<M extends com.baomidou.mybatisplus.core.mapper.BaseMapper<T>, T extends BaseEntity> extends ServiceImpl<M, T> implements IBaseService<T> {

}
