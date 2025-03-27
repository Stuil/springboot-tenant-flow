package com.ginyon.banner.core;

import cn.hutool.core.thread.ThreadUtil;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.util.concurrent.TimeUnit;

/**
 * @author zwh
 * @description: 目启动成功后，提供文档相关的地址
 * @date: 2023/3/31 14:55
 */
@Component
public class BannerApplicationRunner implements ApplicationRunner {

    @Resource
    private Environment environment;


    @Override
    public void run(ApplicationArguments args) {
        ThreadUtil.execute(() -> {
            ThreadUtil.sleep(2, TimeUnit.SECONDS); // 延迟 1 秒，保证输出到结尾
            System.out.println("\n(♥◠‿◠)ﾉﾞ  启动成功   ლ(´ڡ`ლ)ﾞ");
            System.out.println("----------------------------------------------------------\n\t");
            System.out.println("    接口文档地址：http://localhost:" + environment.getProperty("server.port") + "/doc.html");

            System.out.println("\n----------------------------------------------------------\n\t");
        });
    }


}
