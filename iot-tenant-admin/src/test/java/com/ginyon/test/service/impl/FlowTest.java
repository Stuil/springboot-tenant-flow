//package com.hh.test.service.impl;
//
//
//import com.warm.flow.core.dto.FlowParams;
//import com.warm.flow.core.entity.Instance;
//import com.warm.flow.core.enums.SkipType;
//import com.warm.flow.core.service.DefService;
//import com.warm.flow.core.service.InsService;
//import org.junit.jupiter.api.Test;
//import org.springframework.boot.test.context.SpringBootTest;
//
//import javax.annotation.Resource;
//import java.io.FileInputStream;
//import java.util.Arrays;
//
//
//@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
//public class FlowTest {
//
//    @Resource
//    private DefService defService;
//
//    @Resource
//    private InsService insService;
//
//
//    public FlowParams getUser() {
//        FlowParams flowParams = FlowParams.build().flowCode("leaveFlow-serial10")
//                .createBy("1")
//                .nickName("张三")
//                .skipType(SkipType.PASS.getKey())
//                .permissionFlag(Arrays.asList("role:1", "role:2"));
//        return flowParams;
//    }
//
//    @Test
//    public void deployFlow() throws Exception {
//        String path = "/Users/minliuhua/Desktop/mdata/file/IdeaProjects/min/hh-vue/hh-admin/src/main/resources/leaveFlow-serial.xml";
//        System.out.println("已部署流程的id：" + defService.importXml(new FileInputStream(path)).getId());
//    }
//
//    @Test
//    public void publish() throws Exception {
//        defService.publish(1212437969554771968L);
//    }
//
//    @Test
//    public void startFlow() {
//        System.out.println("已开启的流程实例id：" + insService.start("1", getUser()).getId());
//    }
//
//    @Test
//    public void skipFlow() throws Exception {
////        // 通过当前代办任务流转
////        insService.skip()
//
//         // 通过实例id流转
//        Instance instance = insService.skipByInsId(1212438548456804352L, getUser().skipType(SkipType.PASS.getKey())
//                .permissionFlag(Arrays.asList("role:1", "role:2")));
//        System.out.println("流转后流程实例：" + instance.toString());
//    }
//}
