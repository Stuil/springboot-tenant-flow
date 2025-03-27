## 平台简介

**这是基于ruoyi-vue改造的快速开发平台，对mybatis-plus封装可以参考此项目，多租户+satoken 欢迎pr**

**希望一键三连，你的⭐️ Star ⭐️是我持续开发的动力**



本项目分为三个版本：  
一、 **基于ruoyi-vue改造升级版本** ，也就是本项目，已经集成mybatis-plus。已作为自己公司开发脚手架

> [hh-vue](https://gitee.com/min290/hh-vue.git)


二、 **基于ruoyi-vue原版完整集成mybatis-flex** ，做到最小改动，会同步更新ruoyi，可放心食用

    **代码生成已经提供flex版本** ，需要导入test.sql

> [springboot集成方式](https://gitee.com/min290/RuoYi-Vue.git)
>
> [spring集成方式](https://gitee.com/min290/RuoYi-Vue/tree/ruoyi-spring-flex/)



三、 **重磅推出solon版本（去spring版本）** ，也已经集成mybatis-flex/mybatis-plus
参照ruoyi改造，jdk17+satoken+redisx/redisson+mybaits-flex+hutool+jackson+mapstruct+poi

> [warm](https://gitee.com/min290/warm)

**四、vue3版本已经上线**

https://gitee.com/min290/warm-vue3.git



**联系方式：qq群：778470567， 微信：warm-houhou**




## 平台特色

1、页面table固定表头列、斑马纹，调整行高，内容过长隐藏

2、支持两列布局

3、根据表结构，自动生成前后端唯一校验和字段基本校验，减少不必要工作

4、选择是否生成swagger注解

5、 配置是否生成导出代码


## 企业化模块开发，拆分结构

把ruoyi拆分到足够细，可以继续对每个模块增强改造，新增新组件
后期兼容ruoyi微服务，形成组件化
![输入图片说明](https://foruda.gitee.com/images/1683124257941253134/555a7541_2218307.png "屏幕截图")

## 工作流

### warm-flow

此项目是极其简单的工作流，没有太多设计，代码量少，并且只有6张表，个把小时就可以看完整个设计。使用起来方便

1. 支持简单的流程流转，比如跳转、回退、审批
2. 支持角色、部门和用户等权限配置
3. 官方提供简单流程封装demo项目，很实用
4. 支持多租户
5. 支持代办任务和已办任务，通过权限标识过滤数据
6. 支持互斥网关，并行网关（会签、或签）
7. 可退回任意节点
8. 支持条件表达式，可扩展
9. 同时支持spring和solon
10. 兼容java8和java17,理论11也可以


### 演示地址

- admin/admin123

演示地址：http://www.hhzai.top:81

### 演示图

<table>
    <tr>
        <td><img src="https://foruda.gitee.com/images/1697704379975758657/558474f6_2218307.png"/></td>
        <td><img src="https://foruda.gitee.com/images/1703576997421577844/a1dc2737_2218307.png"/></td>
    </tr>
    <tr>
        <td><img src="https://foruda.gitee.com/images/1703577051212751284/203a05b0_2218307.png"/></td>
        <td><img src="https://foruda.gitee.com/images/1703577120823449150/ba952a84_2218307.png"/></td>
    </tr>
    <tr>
        <td><img src="https://foruda.gitee.com/images/1703577416508497463/863d8da1_2218307.png"/></td>
        <td><img src="https://foruda.gitee.com/images/1703641952765512992/dc187080_2218307.png"/></td>
    </tr>
    <tr>
        <td><img src="https://foruda.gitee.com/images/1703639870569018221/453a0e0e_2218307.png"/></td>
        <td><img src="https://foruda.gitee.com/images/1703639949778635820/34a6c14e_2218307.png"/></td>
    </tr>
    <tr>
        <td><img src="https://foruda.gitee.com/images/1703640045465410604/c14affda_2218307.png"/></td>
        <td><img src="https://foruda.gitee.com/images/1703641581976369452/e4629da5_2218307.png"/></td>
    </tr>
    <tr>
        <td><img src="https://foruda.gitee.com/images/1703640080823852176/bdf9a360_2218307.png"/></td>
        <td><img src="https://foruda.gitee.com/images/1703640099939146504/b19b2b85_2218307.png"/></td>
    </tr>
    <tr>
        <td><img src="https://foruda.gitee.com/images/1703641659022331552/cc4e0af2_2218307.png"/></td>
        <td><img src="https://foruda.gitee.com/images/1703641675840058630/3430da37_2218307.png"/></td>
    </tr>
    <tr>
        <td><img src="https://foruda.gitee.com/images/1703641687716655707/62a8b20c_2218307.png"/></td>
        <td><img src="https://foruda.gitee.com/images/1703641702939748288/6da6c4f6_2218307.png"/></td>
    </tr>
</table>



## Velocity改为freemarker

![输入图片说明](https://foruda.gitee.com/images/1681102636817845267/3d0997ad_2218307.png "屏幕截图")

## 支持两列布局, 自动生成前后端唯一校验和字段基本限制,选择是否生成swagger注解，是否需要导出，支持工作流代码生成

![输入图片说明](https://foruda.gitee.com/images/1681225261917276567/d6fd942b_2218307.png "屏幕截图")
![输入图片说明](https://foruda.gitee.com/images/1681102859360937109/0465d830_2218307.png "屏幕截图")
![输入图片说明](https://foruda.gitee.com/images/1681102932043274496/34292667_2218307.png "屏幕截图")


# git提交规范

```
    [init] 初始化  
    [feat] 增加新功能  
    [fix] 修复问题/BUG  
    [style] 代码风格相关无影响运行结果的  
    [perf] 优化/性能提升  
    [refactor] 重构  
    [revert] 撤销修改  
    [test] 测试相关  
    [docs] 文档/注释  
    [chore] 依赖更新/脚手架配置修改等  
    [workflow] 工作流改进  
    [ci] 持续集成  
    [types] 类型定义文件更改  
    [wip] 开发中

```