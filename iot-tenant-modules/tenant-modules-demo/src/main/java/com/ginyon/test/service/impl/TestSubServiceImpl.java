package com.ginyon.test.service.impl;

import com.ginyon.mybatis.service.impl.BaseServiceImpl;
import com.ginyon.test.domain.TestSub;
import com.ginyon.test.mapper.TestSubMapper;
import com.ginyon.test.service.ITestSubService;
import org.springframework.stereotype.Service;

/**
 * 子Service业务层处理
 *
 * @author zwh
 * @date 2023-10-26
 */
@Service
public class TestSubServiceImpl extends BaseServiceImpl<TestSubMapper, TestSub> implements ITestSubService
{

}
