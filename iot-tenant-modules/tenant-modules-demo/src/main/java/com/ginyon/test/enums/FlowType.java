package com.ginyon.test.enums;

/**
 * @author zwh
 * @description: 流程类型枚举
 * @date: 2023/3/31 12:16
 */
public enum FlowType {
    /**
     * 请假流程
     */
    TEST_LEAVE_SERIAL1("leaveFlow-serial1", "串行-简单"),
    TEST_LEAVE_SERIAL2("leaveFlow-serial2", "串行-通过互斥"),
    TEST_LEAVE_SERIAL3("leaveFlow-serial3", "串行-驳回互斥"),
    TEST_LEAVE_PARALLEL1("leaveFlow-parallel1", "并行-汇聚"),
    TEST_LEAVE_PARALLEL2("leaveFlow-parallel2", "串行-驳回互斥");

    private String key;
    private String value;

    FlowType(String key, String value) {
        this.key = key;
        this.value = value;
    }

    public String getKey() {
        return key;
    }

    public String getValue() {
        return value;
    }

    public static String getKeyByValue(String value) {
        for (FlowType item : FlowType.values()) {
            if (item.getValue().equals(value)) {
                return item.getKey();
            }
        }
        return null;
    }

    public static String getValueByKey(String key) {
        for (FlowType item : FlowType.values()) {
            if (item.getKey().equals(key)) {
                return item.getValue();
            }
        }
        return null;
    }
}
