package com.ginyon;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;

/**
 * 启动程序
 *
 * @author zwh
 */
@SpringBootApplication(exclude = {DataSourceAutoConfiguration.class})
public class IotTenantApplication {
    public static void main(String[] args) {
        System.setProperty("spring.devtools.restart.enabled", "false");
        SpringApplication.run(IotTenantApplication.class, args);
    }
}
