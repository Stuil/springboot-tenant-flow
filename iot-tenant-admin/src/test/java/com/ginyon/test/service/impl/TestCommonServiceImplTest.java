//package com.hh.test.service.impl;
//
//
//import com.hh.common.utils.http.HttpUtils;
//import com.hh.test.domain.TestCommon;
//import com.hh.test.service.ITestCommonService;
//import org.junit.jupiter.api.Test;
//import org.slf4j.Logger;
//import org.slf4j.LoggerFactory;
//import org.springframework.boot.test.context.SpringBootTest;
//
//import javax.annotation.Resource;
//import java.util.ArrayList;
//import java.util.Date;
//import java.util.List;
//import java.util.stream.Collectors;
//
//@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
//public class TestCommonServiceImplTest {
//
//    private static final Logger log = LoggerFactory.getLogger(HttpUtils.class);
//
//    @Resource
//    private ITestCommonService testCommonService;
//
//    @Test
//    public void insert() {
//        long start = System.currentTimeMillis();
//        for (int i = 0; i < 1; i++) {
//            TestCommon testCommon = new TestCommon();
//            testCommon.setTitle(String.valueOf(i));
//            testCommonService.save(testCommon);
//        }
//
//        long end = System.currentTimeMillis();
//        log.info("耗时：{}", end - start);
//    }
//
//    @Test
//    public void saveBatch() {
//        long start = System.currentTimeMillis();
//        List<TestCommon> list = new ArrayList<>();
//        for (int i = 0; i < 100000; i++) {
//            TestCommon testCommon = new TestCommon();
//            testCommon.setTitle(String.valueOf(i));
//            testCommon.setDeadline(new Date());
//            testCommon.setLabel("323");
//            testCommon.setLevel(1L);
//            testCommon.setImageId("132131");
//            testCommon.setPublishTime(new Date());
//            list.add(testCommon);
//        }
//        testCommonService.saveBatch(list);
//        long end = System.currentTimeMillis();
//        log.info("耗时：{}", end - start);
//    }
//
//    @Test
//    public void batchUpdate() {
//        long start = System.currentTimeMillis();
//        List<TestCommon> list = testCommonService.selectList(new TestCommon());
//        log.info("更新前条数：{}", list.size());
//        for (TestCommon testCommon : list) {
//            testCommon.setTitle("测试");
//            testCommon.setDeadline(new Date());
//            testCommon.setLabel("323");
//            testCommon.setLevel(1L);
//            testCommon.setImageId("132131");
//            testCommon.setPublishTime(new Date());
//        }
//        long end = System.currentTimeMillis();
//        log.info("耗时：{}", end - start);
//    }
//
//    @Test
//    public void updateBatch() {
//        long start = System.currentTimeMillis();
//        List<TestCommon> list = testCommonService.selectList(new TestCommon());
//        for (TestCommon testCommon : list) {
//            testCommon.setTitle("312");
//            testCommon.setDeadline(new Date());
//            testCommon.setLabel("323");
//            testCommon.setLevel(1L);
//            testCommon.setImageId("132131");
//            testCommon.setPublishTime(new Date());
//            testCommonService.updateById(testCommon);
//        }
//        long end = System.currentTimeMillis();
//        log.info("耗时：{}", end - start);
//    }
//
//    @Test
//    public void deleteByIds() {
//        long start = System.currentTimeMillis();
//        List<TestCommon> list = testCommonService.selectList(new TestCommon());
//        List<Long> ids = list.stream().map(TestCommon::getId).collect(Collectors.toList());
//        testCommonService.removeByIds(ids);
//        long end = System.currentTimeMillis();
//        log.info("耗时：{}", end - start);
//    }
//
//}
