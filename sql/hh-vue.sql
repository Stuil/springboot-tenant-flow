/*
 Navicat Premium Data Transfer

 Source Server         : 本人mysql
 Source Server Type    : MySQL
 Source Server Version : 80200 (8.2.0)
 Source Host           : localhost:3306
 Source Schema         : hh-vue

 Target Server Type    : MySQL
 Target Server Version : 80200 (8.2.0)
 File Encoding         : 65001

 Date: 28/12/2023 01:38:16
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for flow_definition
-- ----------------------------
DROP TABLE IF EXISTS `flow_definition`;
CREATE TABLE `flow_definition` (
                                   `id` bigint unsigned NOT NULL COMMENT '主键id',
                                   `flow_code` varchar(40) NOT NULL COMMENT '流程编码',
                                   `flow_name` varchar(100) NOT NULL COMMENT '流程名称',
                                   `version` varchar(20) NOT NULL COMMENT '流程版本',
                                   `is_publish` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否发布（0未发布 1已发布 9失效）',
                                   `from_custom` char(1) DEFAULT 'N' COMMENT '审批表单是否自定义（Y是 N否）',
                                   `from_path` varchar(100) DEFAULT NULL COMMENT '审批表单路径',
                                   `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                   `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                                   PRIMARY KEY (`id`) USING BTREE,
                                   UNIQUE KEY `flow_code_version` (`flow_code`,`version`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='流程定义表';

-- ----------------------------
-- Records of flow_definition
-- ----------------------------
BEGIN;
INSERT INTO `flow_definition` (`id`, `flow_code`, `flow_name`, `version`, `is_publish`, `from_custom`, `from_path`, `create_time`, `update_time`) VALUES (1164575944237780992, 'leaveFlow-serial1', '串行-简单', '1.0', 1, 'N', 'test/leave/approve', '2023-10-19 14:49:02', '2023-12-27 02:19:09');
INSERT INTO `flow_definition` (`id`, `flow_code`, `flow_name`, `version`, `is_publish`, `from_custom`, `from_path`, `create_time`, `update_time`) VALUES (1164575944237780993, 'leaveFlow-serial2', '串行-通过互斥', '1.0', 1, 'N', 'test/leave/approve', '2023-10-19 14:49:02', '2023-12-27 11:23:27');
INSERT INTO `flow_definition` (`id`, `flow_code`, `flow_name`, `version`, `is_publish`, `from_custom`, `from_path`, `create_time`, `update_time`) VALUES (1164575944237780994, 'leaveFlow-parallel1', '并行-汇聚', '1.0', 1, 'N', 'test/leave/approve', '2023-10-19 14:49:02', '2023-12-27 02:19:17');
INSERT INTO `flow_definition` (`id`, `flow_code`, `flow_name`, `version`, `is_publish`, `from_custom`, `from_path`, `create_time`, `update_time`) VALUES (1164575944237780995, 'leaveFlow-parallel2', '并行-分开', '1.0', 1, 'N', 'test/leave/approve', '2023-10-19 14:49:02', '2023-12-27 02:19:21');
INSERT INTO `flow_definition` (`id`, `flow_code`, `flow_name`, `version`, `is_publish`, `from_custom`, `from_path`, `create_time`, `update_time`) VALUES (1164867267142488064, 'leaveFlow-serial3', '串行-驳回互斥', '1.0', 1, 'N', 'test/leave/approve', '2023-10-20 10:06:39', '2023-12-27 11:23:26');
COMMIT;

-- ----------------------------
-- Table structure for flow_his_task
-- ----------------------------
DROP TABLE IF EXISTS `flow_his_task`;
CREATE TABLE `flow_his_task` (
                                 `id` bigint unsigned NOT NULL COMMENT '主键id',
                                 `definition_id` bigint NOT NULL COMMENT '对应flow_definition表的id',
                                 `instance_id` bigint NOT NULL COMMENT '对应flow_instance表的id',
                                 `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
                                 `node_code` varchar(100) DEFAULT NULL COMMENT '开始节点编码',
                                 `node_name` varchar(100) DEFAULT NULL COMMENT '开始节点名称',
                                 `node_type` tinyint(1) NOT NULL COMMENT '开始节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
                                 `target_node_code` varchar(100) DEFAULT NULL COMMENT '目标节点编码',
                                 `target_node_name` varchar(100) DEFAULT NULL COMMENT '结束节点名称',
                                 `approver` varchar(40) DEFAULT NULL COMMENT '审批者',
                                 `permission_flag` varchar(200) DEFAULT NULL COMMENT '权限标识（权限类型:权限标识，可以多个，如role:1,role:2)',
                                 `flow_status` tinyint(1) NOT NULL COMMENT '流程状态（0待提交 1审批中 2 审批通过 8已完成 9已驳回 10失效）',
                                 `gateway_node` varchar(40) DEFAULT NULL COMMENT '所属并行网关节点编码',
                                 `message` varchar(500) DEFAULT NULL COMMENT '审批意见',
                                 `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                 `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                                 PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='历史任务记录表';

-- ----------------------------
-- Records of flow_his_task
-- ----------------------------
BEGIN;
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227307726934017, 1164575944237780992, 1189227307726934016, '000000', '2', '待提交', 1, '3', '组长审批', '1', 'role:1,role:2', 2, NULL, NULL, '2023-12-26 15:24:50', '2023-12-26 15:24:50');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227327272390656, 1164575944237780992, 1189227307726934016, '000000', '3', '组长审批', 1, '4', '部门经理审批', '1', 'role:1,role:3', 2, NULL, '1', '2023-12-26 15:34:28', '2023-12-26 15:34:28');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227403407396865, 1164867267142488064, 1189227403407396864, '000000', '2', '中间节点1', 1, '0fbb9fbe-e4bd-4280-94f4-a8f939b760e2', '中间节点2', '1', NULL, 2, NULL, NULL, '2023-12-26 15:25:13', '2023-12-26 15:25:13');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227425637208064, 1164867267142488064, 1189227403407396864, '000000', '0fbb9fbe-e4bd-4280-94f4-a8f939b760e2', '中间节点2', 1, '80e10f4c-452c-4a79-b608-84e75831a437', '中间节点3', '1', NULL, 2, NULL, 'undefined', '2023-12-26 15:34:49', '2023-12-26 15:34:49');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227464279330816, 1164575944237780993, 1189227464275136512, '000000', '2', '待提交', 1, '3', '组长审批', '1', 'role:1,role:3', 2, NULL, NULL, '2023-12-26 15:25:25', '2023-12-26 15:25:25');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227474274357248, 1164575944237780993, 1189227464275136512, '000000', '3', '组长审批', 1, '4', '大组长审批', '1', 'role:1,role:3', 2, NULL, 'undefined', '2023-12-26 15:34:00', '2023-12-26 15:34:00');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227536773681153, 1164575944237780994, 1189227536773681152, '000000', '2', '待提交', 1, '3', '小组长审批', '1', 'role:1,role:3', 2, NULL, NULL, '2023-12-26 15:25:42', '2023-12-26 15:25:42');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227545560748032, 1164575944237780994, 1189227536773681152, '000000', '3', '小组长审批', 1, '5,7', '大组长审批,hr审批', '1', 'role:1,role:3', 2, NULL, 'undefined', '2023-12-26 15:33:01', '2023-12-26 15:33:01');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227579673022465, 1164575944237780995, 1189227579673022464, '000000', '2', '待提交', 1, '3', '小组长审批', '1', 'role:1,role:3', 2, NULL, NULL, '2023-12-26 15:25:52', '2023-12-26 15:25:52');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227589701603328, 1164575944237780995, 1189227579673022464, '000000', '3', '小组长审批', 1, '5,7', '大组长审批,董事长审批', '1', 'role:1,role:3', 2, NULL, 'undefined', '2023-12-26 15:26:19', '2023-12-26 15:26:19');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227701257506816, 1164575944237780995, 1189227579673022464, '000000', '5', '大组长审批', 1, '6', '部门经理审批', '1', 'role:1,role:3', 2, NULL, '4', '2023-12-26 15:26:34', '2023-12-26 15:26:34');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227701257506817, 1164575944237780995, 1189227579673022464, '000000', '7', '董事长审批', 1, '9', '结束2', '1', 'role:1,role:3', 8, NULL, '4', '2023-12-26 15:26:41', '2023-12-26 15:26:41');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189227765442940928, 1164575944237780995, 1189227579673022464, '000000', '6', '部门经理审批', 1, NULL, NULL, NULL, 'role:1,role:3', 8, NULL, NULL, '2023-12-26 15:26:41', '2023-12-26 15:26:41');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189229387627761664, 1164575944237780994, 1189227536773681152, '000000', '5', '大组长审批', 1, '6', '部门经理审批', '1', 'role:1,role:3', 2, NULL, 'undefined', '2023-12-26 15:33:11', '2023-12-26 15:33:11');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189229387627761665, 1164575944237780994, 1189227536773681152, '000000', '7', 'hr审批', 1, '43563e5c-42fb-4f46-936d-70f8727943bf', '董事长审批', '1', 'role:1,role:3', 2, NULL, 'undefined', '2023-12-26 15:33:33', '2023-12-26 15:33:33');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189229431856697344, 1164575944237780994, 1189227536773681152, '000000', '6', '部门经理审批', 1, '43563e5c-42fb-4f46-936d-70f8727943bf', '董事长审批', '1', 'role:1,role:3', 2, NULL, 'undefined', '2023-12-26 15:33:18', '2023-12-26 15:33:18');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189229521111486464, 1164575944237780994, 1189227536773681152, '000000', '43563e5c-42fb-4f46-936d-70f8727943bf', '董事长审批', 1, 'd34fb004-0bf5-4ad7-8e05-82200e6f9e78', '结束', '1', 'role:1,role:3', 8, NULL, 'undefined', '2023-12-26 15:33:41', '2023-12-26 15:33:41');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189229637385981952, 1164575944237780993, 1189227464275136512, '000000', '4', '大组长审批', 1, '6', '部门经理审批', '1', 'role:1,role:3', 2, NULL, 'undefined', '2023-12-26 15:39:50', '2023-12-26 15:39:50');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189229755195592704, 1164575944237780992, 1189227307726934016, '000000', '4', '部门经理审批', 1, '9edc9b26-cab4-4fd4-9a30-c89f11626911', 'hr审批', '1', 'role:1,role:3', 2, NULL, '4', '2023-12-26 15:34:38', '2023-12-26 15:34:38');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189229793711886336, 1164575944237780992, 1189227307726934016, '000000', '9edc9b26-cab4-4fd4-9a30-c89f11626911', 'hr审批', 1, 'fa0fe17b-66d2-458d-b420-fec5cb14f73d', '结束', '1', 'role:1,role:3', 8, NULL, 'undefined', '2023-12-26 15:34:41', '2023-12-26 15:34:41');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189229841300459520, 1164867267142488064, 1189227403407396864, '000000', '80e10f4c-452c-4a79-b608-84e75831a437', '中间节点3', 1, '3893b8ab-355a-483f-ac34-e781f1f5d4ca', '结束', '1', NULL, 8, NULL, 'undefined', '2023-12-26 15:40:00', '2023-12-26 15:40:00');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189231103861460992, 1164575944237780993, 1189227464275136512, '000000', '6', '部门经理审批', 1, '8', '结束', '1', 'role:1,role:3', 8, NULL, 'undefined', '2023-12-26 15:39:56', '2023-12-26 15:39:56');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189232477701541889, 1164575944237780992, 1189232477701541888, '000000', '2', '待提交', 1, '3', '组长审批', '1', 'role:1,role:2', 2, NULL, NULL, '2023-12-26 15:46:04', '2023-12-26 15:46:04');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189232513973882881, 1164867267142488064, 1189232513973882880, '000000', '2', '中间节点1', 1, '0fbb9fbe-e4bd-4280-94f4-a8f939b760e2', '中间节点2', '1', NULL, 2, NULL, NULL, '2023-12-26 15:46:03', '2023-12-26 15:46:03');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189232547490566144, 1164575944237780993, 1189232547486371840, '000000', '2', '待提交', 1, '3', '组长审批', '1', 'role:1,role:3', 2, NULL, NULL, '2023-12-26 15:45:59', '2023-12-26 15:45:59');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189232584807288833, 1164575944237780994, 1189232584807288832, '000000', '2', '待提交', 1, '3', '小组长审批', '1', 'role:1,role:3', 2, NULL, NULL, '2023-12-26 15:45:58', '2023-12-26 15:45:58');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189232624221163521, 1164575944237780995, 1189232624221163520, '000000', '2', '待提交', 1, '3', '小组长审批', '1', 'role:1,role:3', 2, NULL, NULL, '2023-12-26 15:45:56', '2023-12-26 15:45:56');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189232638423076864, 1164575944237780995, 1189232624221163520, '000000', '3', '小组长审批', 1, '5,7', '大组长审批,董事长审批', '1', 'role:1,role:3', 2, NULL, 'undefined', '2023-12-27 02:20:15', '2023-12-27 02:20:15');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189232645964435456, 1164575944237780994, 1189232584807288832, '000000', '3', '小组长审批', 1, '5,7', '大组长审批,hr审批', '1', 'role:1,role:3', 2, NULL, 'undefined', '2023-12-26 23:40:30', '2023-12-26 23:40:30');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189232653518376960, 1164575944237780993, 1189232547486371840, '000000', '3', '组长审批', 1, '4', '大组长审批', '1', 'role:1,role:3', 2, NULL, 'undefined', '2023-12-26 15:52:44', '2023-12-26 15:52:44');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189527982549635073, 1164575944237780993, 1189527982549635072, '000000', '2', '待提交', 1, '3', '组长审批', '1', 'role:1,role:3', 2, NULL, NULL, '2023-12-27 11:19:34', '2023-12-27 11:19:34');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189527994868305920, 1164575944237780993, 1189527982549635072, '000000', '3', '组长审批', 1, '4', '大组长审批', '1', 'role:1,role:3', 2, NULL, 'undefined', '2023-12-27 11:26:00', '2023-12-27 11:26:00');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189529705775239169, 1164575944237780993, 1189529705775239168, '000000', '2', '待提交', 1, '3', '组长审批', '1', 'role:1,role:3', 2, NULL, NULL, '2023-12-27 11:26:25', '2023-12-27 11:26:25');
INSERT INTO `flow_his_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `target_node_code`, `target_node_name`, `approver`, `permission_flag`, `flow_status`, `gateway_node`, `message`, `create_time`, `update_time`) VALUES (1189529715384389632, 1164575944237780993, 1189529705775239168, '000000', '3', '组长审批', 1, '7', '董事长审批', '1', 'role:1,role:3', 2, NULL, '4', '2023-12-27 11:26:36', '2023-12-27 11:26:36');
COMMIT;

-- ----------------------------
-- Table structure for flow_instance
-- ----------------------------
DROP TABLE IF EXISTS `flow_instance`;
CREATE TABLE `flow_instance` (
                                 `id` bigint NOT NULL COMMENT '主键id',
                                 `definition_id` bigint NOT NULL COMMENT '对应flow_definition表的id',
                                 `business_id` varchar(40) NOT NULL COMMENT '业务id',
                                 `node_type` tinyint(1) NOT NULL COMMENT '结点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
                                 `node_code` varchar(40) NOT NULL COMMENT '流程节点编码',
                                 `node_name` varchar(100) DEFAULT NULL COMMENT '流程节点名称',
                                 `flow_status` tinyint(1) NOT NULL COMMENT '流程状态（0待提交 1审批中 2 审批通过 8已完成 9已驳回 10失效）',
                                 `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                                 `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                 `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                                 `ext` varchar(500) DEFAULT NULL COMMENT '扩展字段',
                                 PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='流程实例表';

-- ----------------------------
-- Records of flow_instance
-- ----------------------------
BEGIN;
INSERT INTO `flow_instance` (`id`, `definition_id`, `business_id`, `node_type`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_time`, `ext`) VALUES (1189227307726934016, 1164575944237780992, '1739547781112139776', 1, '9edc9b26-cab4-4fd4-9a30-c89f11626911', 'hr审批', 8, '1', '2023-12-26 15:24:45', '2023-12-26 15:34:41', NULL);
INSERT INTO `flow_instance` (`id`, `definition_id`, `business_id`, `node_type`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_time`, `ext`) VALUES (1189227403407396864, 1164867267142488064, '1739547876775825408', 1, '80e10f4c-452c-4a79-b608-84e75831a437', '中间节点3', 8, '1', '2023-12-26 15:25:08', '2023-12-26 15:40:00', NULL);
INSERT INTO `flow_instance` (`id`, `definition_id`, `business_id`, `node_type`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_time`, `ext`) VALUES (1189227464275136512, 1164575944237780993, '1739547937656147968', 1, '6', '部门经理审批', 8, '1', '2023-12-26 15:25:22', '2023-12-26 15:39:56', NULL);
INSERT INTO `flow_instance` (`id`, `definition_id`, `business_id`, `node_type`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_time`, `ext`) VALUES (1189227536773681152, 1164575944237780994, '1739548010154692608', 1, '43563e5c-42fb-4f46-936d-70f8727943bf', '董事长审批', 8, '1', '2023-12-26 15:25:40', '2023-12-26 15:33:41', NULL);
INSERT INTO `flow_instance` (`id`, `definition_id`, `business_id`, `node_type`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_time`, `ext`) VALUES (1189227579673022464, 1164575944237780995, '1739548053058228224', 1, '6', '部门经理审批', 8, '1', '2023-12-26 15:25:50', '2023-12-26 15:26:41', NULL);
INSERT INTO `flow_instance` (`id`, `definition_id`, `business_id`, `node_type`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_time`, `ext`) VALUES (1189232477701541888, 1164575944237780992, '1739552951107719168', 1, '3', '组长审批', 1, '1', '2023-12-26 15:45:18', '2023-12-26 15:46:04', NULL);
INSERT INTO `flow_instance` (`id`, `definition_id`, `business_id`, `node_type`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_time`, `ext`) VALUES (1189232513973882880, 1164867267142488064, '1739552987325534208', 1, '0fbb9fbe-e4bd-4280-94f4-a8f939b760e2', '中间节点2', 1, '1', '2023-12-26 15:45:26', '2023-12-26 15:46:03', NULL);
INSERT INTO `flow_instance` (`id`, `definition_id`, `business_id`, `node_type`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_time`, `ext`) VALUES (1189232547486371840, 1164575944237780993, '1739553020846411776', 1, '4', '大组长审批', 1, '1', '2023-12-26 15:45:34', '2023-12-26 15:52:44', NULL);
INSERT INTO `flow_instance` (`id`, `definition_id`, `business_id`, `node_type`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_time`, `ext`) VALUES (1189232584807288832, 1164575944237780994, '1739553058163134464', 1, '5', '大组长审批', 1, '1', '2023-12-26 15:45:43', '2023-12-26 23:40:30', NULL);
INSERT INTO `flow_instance` (`id`, `definition_id`, `business_id`, `node_type`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_time`, `ext`) VALUES (1189232624221163520, 1164575944237780995, '1739553097564426240', 1, '5', '大组长审批', 1, '1', '2023-12-26 15:45:52', '2023-12-27 02:20:15', NULL);
INSERT INTO `flow_instance` (`id`, `definition_id`, `business_id`, `node_type`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_time`, `ext`) VALUES (1189527982549635072, 1164575944237780993, '1739848455930646528', 1, '4', '大组长审批', 1, '1', '2023-12-27 11:19:31', '2023-12-27 11:26:00', NULL);
INSERT INTO `flow_instance` (`id`, `definition_id`, `business_id`, `node_type`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_time`, `ext`) VALUES (1189529705775239168, 1164575944237780993, '1739850179168833536', 1, '7', '董事长审批', 1, '1', '2023-12-27 11:26:22', '2023-12-27 11:26:36', NULL);
COMMIT;

-- ----------------------------
-- Table structure for flow_node
-- ----------------------------
DROP TABLE IF EXISTS `flow_node`;
CREATE TABLE `flow_node` (
                             `id` bigint unsigned NOT NULL COMMENT '主键id',
                             `node_type` tinyint(1) NOT NULL COMMENT '节点类型（0开始节点 1中间节点 2结束结点 3互斥网关 4并行网关）',
                             `definition_id` bigint NOT NULL COMMENT '流程定义id',
                             `node_code` varchar(100) NOT NULL COMMENT '流程节点编码',
                             `node_name` varchar(100) DEFAULT NULL COMMENT '流程节点名称',
                             `permission_flag` varchar(200) DEFAULT NULL COMMENT '权限标识（权限类型:权限标识，可以多个，如role:1,role:2)',
                             `coordinate` varchar(100) DEFAULT NULL COMMENT '坐标',
                             `skip_any_node` varchar(100) DEFAULT 'N' COMMENT '是否可以退回任意节点（Y是 N否）',
                             `version` varchar(20) NOT NULL COMMENT '版本',
                             `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                             `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                             PRIMARY KEY (`id`) USING BTREE,
                             UNIQUE KEY `info_id_code` (`definition_id`,`node_code`) USING BTREE COMMENT '保证一个流程中node_code是唯一的'
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='流程结点表';

-- ----------------------------
-- Records of flow_node
-- ----------------------------
BEGIN;
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391839938088961, 0, 1164575944237780992, '1', '开始', NULL, '120,280|120,280', 'N', '1.0', '2023-12-27 02:18:32', '2023-12-27 02:18:32');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391839938088963, 1, 1164575944237780992, '2', '待提交', 'role:1,role:2', '280,280|280,280', 'N', '1.0', '2023-12-27 02:18:32', '2023-12-27 02:18:32');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391839938088965, 1, 1164575944237780992, '3', '组长审批', 'role:1,role:3', '480,280|480,280', 'N', '1.0', '2023-12-27 02:18:32', '2023-12-27 02:18:32');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391839938088967, 1, 1164575944237780992, '4', '部门经理审批', 'role:1,role:3', '700,280|700,280', 'N', '1.0', '2023-12-27 02:18:32', '2023-12-27 02:18:32');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391839938088970, 1, 1164575944237780992, '9edc9b26-cab4-4fd4-9a30-c89f11626911', 'hr审批', 'role:1,role:3', '920,280|920,280', 'Y', '1.0', '2023-12-27 02:18:33', '2023-12-27 02:18:33');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391839938088972, 2, 1164575944237780992, 'fa0fe17b-66d2-458d-b420-fec5cb14f73d', '结束', NULL, '1120,280|1120,280', 'N', '1.0', '2023-12-27 02:18:33', '2023-12-27 02:18:33');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391860049776641, 0, 1164575944237780994, '1', '开始', NULL, '140,180|140,180', 'N', '1.0', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391860049776643, 1, 1164575944237780994, '2', '待提交', 'role:1,role:3', '280,180|280,180', 'N', '1.0', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391860049776645, 1, 1164575944237780994, '3', '小组长审批', 'role:1,role:3', '480,180|480,180', 'N', '1.0', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391860049776647, 4, 1164575944237780994, 'f06c0d62-3983-4503-ad1f-f581a89727e6', NULL, NULL, '640,180', 'N', '1.0', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391860049776650, 1, 1164575944237780994, '5', '大组长审批', 'role:1,role:3', '880,140|880,140', 'N', '1.0', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391860049776652, 1, 1164575944237780994, '6', '部门经理审批', 'role:1,role:3', '1100,140|1100,140', 'N', '1.0', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391860049776654, 4, 1164575944237780994, 'd7de884d-e86f-4483-be14-b4350d93a079', NULL, NULL, '1100,300', 'N', '1.0', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391860049776656, 1, 1164575944237780994, '43563e5c-42fb-4f46-936d-70f8727943bf', '董事长审批', 'role:1,role:3', '1100,440|1100,440', 'N', '1.0', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391860049776658, 2, 1164575944237780994, 'd34fb004-0bf5-4ad7-8e05-82200e6f9e78', '结束', NULL, '1100,600|1100,600', 'N', '1.0', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391860049776659, 1, 1164575944237780994, '7', 'hr审批', 'role:1,role:3', '880,300|880,300', 'N', '1.0', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391879658147841, 0, 1164575944237780995, '1', '开始', NULL, '140,220|140,220', 'N', '1.0', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391879658147843, 1, 1164575944237780995, '2', '待提交', 'role:1,role:3', '300,220|300,220', 'N', '1.0', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391879658147845, 1, 1164575944237780995, '3', '小组长审批', 'role:1,role:3', '500,220|500,220', 'N', '1.0', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391879658147847, 4, 1164575944237780995, 'e8d342f3-1353-415f-af62-c02f33a083bd', NULL, NULL, '660,220', 'N', '1.0', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391879658147850, 1, 1164575944237780995, '5', '大组长审批', 'role:1,role:3', '820,120|820,120', 'N', '1.0', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391879658147852, 1, 1164575944237780995, '6', '部门经理审批', 'role:1,role:3', '1040,120|1040,120', 'N', '1.0', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391879662342145, 2, 1164575944237780995, '8', '结束1', NULL, '1240,120|1240,120', 'N', '1.0', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391879662342146, 1, 1164575944237780995, '7', '董事长审批', 'role:1,role:3', '820,280|820,280', 'N', '1.0', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189391879662342149, 2, 1164575944237780995, '9', '结束2', NULL, '1240,280|1240,280', 'N', '1.0', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528826661703681, 0, 1164867267142488064, 'f6c8ca02-6440-4f49-a35f-dfe689e38263', '开始', NULL, '160,200|160,200', 'N', '1.0', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528826661703683, 1, 1164867267142488064, '2', '中间节点1', NULL, '380,200|380,200', 'N', '1.0', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528826661703685, 1, 1164867267142488064, '0fbb9fbe-e4bd-4280-94f4-a8f939b760e2', '中间节点2', NULL, '600,200|600,200', 'N', '1.0', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528826661703687, 1, 1164867267142488064, '80e10f4c-452c-4a79-b608-84e75831a437', '中间节点3', NULL, '840,200|840,200', 'N', '1.0', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528826661703690, 2, 1164867267142488064, '3893b8ab-355a-483f-ac34-e781f1f5d4ca', '结束', NULL, '1060,200|1060,200', 'N', '1.0', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528826661703691, 3, 1164867267142488064, 'f038c246-b219-4316-89b9-991ba067c740', NULL, NULL, '700,80', 'N', '1.0', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528918848311297, 0, 1164575944237780993, '1', '开始', NULL, '140,300|140,300', 'N', '1.0', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528918848311299, 1, 1164575944237780993, '2', '待提交', 'role:1,role:3', '300,300|300,300', 'N', '1.0', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528918848311301, 1, 1164575944237780993, '3', '组长审批', 'role:1,role:3', '500,300|500,300', 'N', '1.0', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528918848311303, 3, 1164575944237780993, '50a177f6-d9a7-44e8-96d6-afc6d1362192', NULL, NULL, '660,300', 'N', '1.0', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528918848311306, 1, 1164575944237780993, '4', '大组长审批', 'role:1,role:3', '840,180|840,180', 'N', '1.0', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528918848311308, 1, 1164575944237780993, '6', '部门经理审批', 'role:1,role:3', '1040,180|1040,180', 'N', '1.0', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528918848311311, 2, 1164575944237780993, '8', '结束', NULL, '1200,300|1200,300', 'N', '1.0', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_node` (`id`, `node_type`, `definition_id`, `node_code`, `node_name`, `permission_flag`, `coordinate`, `skip_any_node`, `version`, `create_time`, `update_time`) VALUES (1189528918848311312, 1, 1164575944237780993, '7', '董事长审批', 'role:1,role:3', '840,420|840,420', 'N', '1.0', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
COMMIT;

-- ----------------------------
-- Table structure for flow_skip
-- ----------------------------
DROP TABLE IF EXISTS `flow_skip`;
CREATE TABLE `flow_skip` (
                             `id` bigint unsigned NOT NULL COMMENT '主键id',
                             `definition_id` bigint NOT NULL COMMENT '流程定义id',
                             `node_id` bigint NOT NULL COMMENT '当前节点id',
                             `now_node_code` varchar(100) NOT NULL COMMENT '当前流程节点的编码',
                             `now_node_type` tinyint(1) DEFAULT NULL COMMENT '当前节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
                             `next_node_code` varchar(100) NOT NULL COMMENT '下一个流程节点的编码',
                             `next_node_type` tinyint(1) DEFAULT NULL COMMENT '下一个节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
                             `skip_name` varchar(100) DEFAULT NULL COMMENT '跳转名称',
                             `skip_type` varchar(40) DEFAULT NULL COMMENT '跳转类型（PASS审批通过 REJECT驳回）',
                             `skip_condition` varchar(200) DEFAULT NULL COMMENT '跳转条件',
                             `coordinate` varchar(100) DEFAULT NULL COMMENT '坐标',
                             `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                             `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                             PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='结点跳转关联表';

-- ----------------------------
-- Records of flow_skip
-- ----------------------------
BEGIN;
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391839938088962, 1164575944237780992, 1189391839938088961, '1', 0, '2', 1, NULL, 'PASS', NULL, '140,280;230,280', '2023-12-27 02:18:33', '2023-12-27 02:18:33');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391839938088964, 1164575944237780992, 1189391839938088963, '2', 1, '3', 1, NULL, 'PASS', NULL, '330,280;430,280', '2023-12-27 02:18:33', '2023-12-27 02:18:33');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391839938088966, 1164575944237780992, 1189391839938088965, '3', 1, '4', 1, NULL, 'PASS', NULL, '530,280;650,280', '2023-12-27 02:18:33', '2023-12-27 02:18:33');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391839938088968, 1164575944237780992, 1189391839938088967, '4', 1, '9edc9b26-cab4-4fd4-9a30-c89f11626911', 1, NULL, 'PASS', NULL, '750,280;870,280', '2023-12-27 02:18:33', '2023-12-27 02:18:33');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391839938088969, 1164575944237780992, 1189391839938088967, '4', 1, '2', 1, NULL, 'REJECT', NULL, '700,240;700,210;280,210;280,240', '2023-12-27 02:18:33', '2023-12-27 02:18:33');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391839938088971, 1164575944237780992, 1189391839938088970, '9edc9b26-cab4-4fd4-9a30-c89f11626911', 1, 'fa0fe17b-66d2-458d-b420-fec5cb14f73d', 2, NULL, 'PASS', NULL, '970,280;1100,280', '2023-12-27 02:18:33', '2023-12-27 02:18:33');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391860049776642, 1164575944237780994, 1189391860049776641, '1', 0, '2', 1, NULL, 'PASS', NULL, '160,180;230,180', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391860049776644, 1164575944237780994, 1189391860049776643, '2', 1, '3', 1, NULL, 'PASS', NULL, '330,180;430,180', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391860049776646, 1164575944237780994, 1189391860049776645, '3', 1, 'f06c0d62-3983-4503-ad1f-f581a89727e6', 4, NULL, 'PASS', NULL, '530,180;615,180', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391860049776648, 1164575944237780994, 1189391860049776647, 'f06c0d62-3983-4503-ad1f-f581a89727e6', 4, '5', 1, NULL, 'PASS', NULL, '665,180;683,180;683,140;830,140', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391860049776649, 1164575944237780994, 1189391860049776647, 'f06c0d62-3983-4503-ad1f-f581a89727e6', 4, '7', 1, NULL, 'PASS', NULL, '665,180;685,180;685,300;830,300', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391860049776651, 1164575944237780994, 1189391860049776650, '5', 1, '6', 1, NULL, 'PASS', NULL, '930,140;1050,140', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391860049776653, 1164575944237780994, 1189391860049776652, '6', 1, 'd7de884d-e86f-4483-be14-b4350d93a079', 4, NULL, 'PASS', NULL, '1101,180;1101,276', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391860049776655, 1164575944237780994, 1189391860049776654, 'd7de884d-e86f-4483-be14-b4350d93a079', 4, '43563e5c-42fb-4f46-936d-70f8727943bf', 1, NULL, 'PASS', NULL, '1102,323;1102,400', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391860049776657, 1164575944237780994, 1189391860049776656, '43563e5c-42fb-4f46-936d-70f8727943bf', 1, 'd34fb004-0bf5-4ad7-8e05-82200e6f9e78', 2, NULL, 'PASS', NULL, '1100,480;1100,580', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391860049776660, 1164575944237780994, 1189391860049776659, '7', 1, 'd7de884d-e86f-4483-be14-b4350d93a079', 4, NULL, 'PASS', NULL, '930,300;1075,300', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391860049776661, 1164575944237780994, 1189391860049776659, '7', 1, '3', 1, NULL, 'REJECT', NULL, '880,340;880,360;480,360;480,220', '2023-12-27 02:18:37', '2023-12-27 02:18:37');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391879658147842, 1164575944237780995, 1189391879658147841, '1', 0, '2', 1, NULL, 'PASS', NULL, '160,220;250,220', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391879658147844, 1164575944237780995, 1189391879658147843, '2', 1, '3', 1, NULL, 'PASS', NULL, '350,220;450,220', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391879658147846, 1164575944237780995, 1189391879658147845, '3', 1, 'e8d342f3-1353-415f-af62-c02f33a083bd', 4, NULL, 'PASS', NULL, '550,220;635,220', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391879658147848, 1164575944237780995, 1189391879658147847, 'e8d342f3-1353-415f-af62-c02f33a083bd', 4, '5', 1, NULL, 'PASS', NULL, '685,220;716,220;716,120;770,120', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391879658147849, 1164575944237780995, 1189391879658147847, 'e8d342f3-1353-415f-af62-c02f33a083bd', 4, '7', 1, NULL, 'PASS', NULL, '685,220;715,220;715,280;770,280', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391879658147851, 1164575944237780995, 1189391879658147850, '5', 1, '6', 1, NULL, 'PASS', NULL, '870,120;990,120', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391879662342144, 1164575944237780995, 1189391879658147852, '6', 1, '8', 2, NULL, 'PASS', NULL, '1090,120;1220,120', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391879662342147, 1164575944237780995, 1189391879662342146, '7', 1, '9', 2, NULL, 'PASS', NULL, '870,280;1220,280', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189391879662342148, 1164575944237780995, 1189391879662342146, '7', 1, '3', 1, NULL, 'REJECT', NULL, '820,320;820,350;500,350;500,260', '2023-12-27 02:18:42', '2023-12-27 02:18:42');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528826661703682, 1164867267142488064, 1189528826661703681, 'f6c8ca02-6440-4f49-a35f-dfe689e38263', 0, '2', 1, NULL, 'PASS', NULL, '180,200;330,200', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528826661703684, 1164867267142488064, 1189528826661703683, '2', 1, '0fbb9fbe-e4bd-4280-94f4-a8f939b760e2', 1, NULL, 'PASS', NULL, '430,200;550,200', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528826661703686, 1164867267142488064, 1189528826661703685, '0fbb9fbe-e4bd-4280-94f4-a8f939b760e2', 1, '80e10f4c-452c-4a79-b608-84e75831a437', 1, NULL, 'PASS', NULL, '650,200;790,200', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528826661703688, 1164867267142488064, 1189528826661703687, '80e10f4c-452c-4a79-b608-84e75831a437', 1, '3893b8ab-355a-483f-ac34-e781f1f5d4ca', 2, NULL, 'PASS', NULL, '890,200;1040,200', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528826661703689, 1164867267142488064, 1189528826661703687, '80e10f4c-452c-4a79-b608-84e75831a437', 1, 'f038c246-b219-4316-89b9-991ba067c740', 3, NULL, 'REJECT', NULL, '840,160;840,79;724,79', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528826661703692, 1164867267142488064, 1189528826661703691, 'f038c246-b219-4316-89b9-991ba067c740', 3, '0fbb9fbe-e4bd-4280-94f4-a8f939b760e2', 1, '请假时间大于4天', 'REJECT', '@@gt@@|flag@@gt@@4', '675,80;600,80;600,160|600,80', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528826661703693, 1164867267142488064, 1189528826661703691, 'f038c246-b219-4316-89b9-991ba067c740', 3, '2', 1, '请假时间小于等于4天', 'REJECT', '@@ge@@|flag@@ge@@4', '700,55;700,35;380,35;380,160|540,35', '2023-12-27 11:22:53', '2023-12-27 11:22:53');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528918848311298, 1164575944237780993, 1189528918848311297, '1', 0, '2', 1, NULL, 'PASS', NULL, '160,300;250,300', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528918848311300, 1164575944237780993, 1189528918848311299, '2', 1, '3', 1, NULL, 'PASS', NULL, '350,300;450,300', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528918848311302, 1164575944237780993, 1189528918848311301, '3', 1, '50a177f6-d9a7-44e8-96d6-afc6d1362192', 3, NULL, 'PASS', NULL, '550,300;635,300', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528918848311304, 1164575944237780993, 1189528918848311303, '50a177f6-d9a7-44e8-96d6-afc6d1362192', 3, '4', 1, '请假时间小于等于4天', 'PASS', '@@le@@|flag@@le@@4', '660,275;660,180;790,180|660,225', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528918848311305, 1164575944237780993, 1189528918848311303, '50a177f6-d9a7-44e8-96d6-afc6d1362192', 3, '7', 1, '请假时间大于4天', 'PASS', '@@gt@@|flag@@gt@@4', '660,325;660,420;790,420|660,375', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528918848311307, 1164575944237780993, 1189528918848311306, '4', 1, '6', 1, NULL, 'PASS', NULL, '890,180;990,180', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528918848311309, 1164575944237780993, 1189528918848311308, '6', 1, '8', 2, NULL, 'PASS', NULL, '1090,180;1141,180;1141,300;1180,300', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528918848311310, 1164575944237780993, 1189528918848311308, '6', 1, '4', 1, NULL, 'REJECT', NULL, '1040,140;1040,120;840,120;840,140', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
INSERT INTO `flow_skip` (`id`, `definition_id`, `node_id`, `now_node_code`, `now_node_type`, `next_node_code`, `next_node_type`, `skip_name`, `skip_type`, `skip_condition`, `coordinate`, `create_time`, `update_time`) VALUES (1189528918848311313, 1164575944237780993, 1189528918848311312, '7', 1, '8', 2, NULL, 'PASS', NULL, '890,420;910,420;910,300;1180,300', '2023-12-27 11:23:15', '2023-12-27 11:23:15');
COMMIT;

-- ----------------------------
-- Table structure for flow_task
-- ----------------------------
DROP TABLE IF EXISTS `flow_task`;
CREATE TABLE `flow_task` (
                             `id` bigint NOT NULL COMMENT '主键id',
                             `definition_id` bigint NOT NULL COMMENT '对应flow_definition表的id',
                             `instance_id` bigint NOT NULL COMMENT '对应flow_instance表的id',
                             `tenant_id` varchar(40) DEFAULT NULL COMMENT '租户id',
                             `node_code` varchar(100) NOT NULL COMMENT '节点编码',
                             `node_name` varchar(100) DEFAULT NULL COMMENT '节点名称',
                             `node_type` tinyint(1) NOT NULL COMMENT '节点类型（0开始节点 1中间节点 2结束节点 3互斥网关 4并行网关）',
                             `permission_flag` varchar(200) DEFAULT NULL COMMENT '权限标识（权限类型:权限标识，可以多个，如role:1,role:2)',
                             `flow_status` tinyint(1) NOT NULL COMMENT '流程状态（0待提交 1审批中 2 审批通过 8已完成 9已驳回 10失效）',
                             `approver` varchar(40) DEFAULT NULL COMMENT '审批者',
                             `assignee` varchar(40) DEFAULT NULL COMMENT '转办人',
                             `gateway_node` varchar(40) DEFAULT NULL COMMENT '所属并行网关节点编码',
                             `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                             `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                             PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='待办任务表';

-- ----------------------------
-- Records of flow_task
-- ----------------------------
BEGIN;
INSERT INTO `flow_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `permission_flag`, `flow_status`, `approver`, `assignee`, `gateway_node`, `create_time`, `update_time`) VALUES (1189232666277449728, 1164867267142488064, 1189232513973882880, '000000', '0fbb9fbe-e4bd-4280-94f4-a8f939b760e2', '中间节点2', 1, NULL, 1, '1', NULL, NULL, '2023-12-26 15:46:03', '2023-12-26 15:46:03');
INSERT INTO `flow_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `permission_flag`, `flow_status`, `approver`, `assignee`, `gateway_node`, `create_time`, `update_time`) VALUES (1189232674275987456, 1164575944237780992, 1189232477701541888, '000000', '3', '组长审批', 1, 'role:1,role:3', 1, '1', NULL, NULL, '2023-12-26 15:46:04', '2023-12-26 15:46:04');
INSERT INTO `flow_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `permission_flag`, `flow_status`, `approver`, `assignee`, `gateway_node`, `create_time`, `update_time`) VALUES (1189234351720763392, 1164575944237780993, 1189232547486371840, '000000', '4', '大组长审批', 1, 'role:1,role:3', 1, '1', NULL, NULL, '2023-12-26 15:52:44', '2023-12-26 15:52:44');
INSERT INTO `flow_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `permission_flag`, `flow_status`, `approver`, `assignee`, `gateway_node`, `create_time`, `update_time`) VALUES (1189352067601403904, 1164575944237780994, 1189232584807288832, '000000', '5', '大组长审批', 1, 'role:1,role:3', 1, '1', NULL, NULL, '2023-12-26 23:40:30', '2023-12-26 23:40:30');
INSERT INTO `flow_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `permission_flag`, `flow_status`, `approver`, `assignee`, `gateway_node`, `create_time`, `update_time`) VALUES (1189352067601403905, 1164575944237780994, 1189232584807288832, '000000', '7', 'hr审批', 1, 'role:1,role:3', 1, '1', NULL, NULL, '2023-12-26 23:40:30', '2023-12-26 23:40:30');
INSERT INTO `flow_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `permission_flag`, `flow_status`, `approver`, `assignee`, `gateway_node`, `create_time`, `update_time`) VALUES (1189392271607468032, 1164575944237780995, 1189232624221163520, '000000', '5', '大组长审批', 1, 'role:1,role:3', 1, '1', NULL, NULL, '2023-12-27 02:20:15', '2023-12-27 02:20:15');
INSERT INTO `flow_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `permission_flag`, `flow_status`, `approver`, `assignee`, `gateway_node`, `create_time`, `update_time`) VALUES (1189392271607468033, 1164575944237780995, 1189232624221163520, '000000', '7', '董事长审批', 1, 'role:1,role:3', 1, '1', NULL, NULL, '2023-12-27 02:20:15', '2023-12-27 02:20:15');
INSERT INTO `flow_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `permission_flag`, `flow_status`, `approver`, `assignee`, `gateway_node`, `create_time`, `update_time`) VALUES (1189529612871405568, 1164575944237780993, 1189527982549635072, '000000', '4', '大组长审批', 1, 'role:1,role:3', 1, '1', NULL, NULL, '2023-12-27 11:26:00', '2023-12-27 11:26:00');
INSERT INTO `flow_task` (`id`, `definition_id`, `instance_id`, `tenant_id`, `node_code`, `node_name`, `node_type`, `permission_flag`, `flow_status`, `approver`, `assignee`, `gateway_node`, `create_time`, `update_time`) VALUES (1189529761874055168, 1164575944237780993, 1189529705775239168, '000000', '7', '董事长审批', 1, 'role:1,role:3', 1, '1', NULL, NULL, '2023-12-27 11:26:36', '2023-12-27 11:26:36');
COMMIT;

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table` (
                             `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
                             `table_name` varchar(200) DEFAULT '' COMMENT '表名称',
                             `table_comment` varchar(500) DEFAULT '' COMMENT '表描述',
                             `sub_table_name` varchar(64) DEFAULT NULL COMMENT '关联子表的表名',
                             `sub_table_fk_name` varchar(64) DEFAULT NULL COMMENT '子表关联的外键名',
                             `class_name` varchar(100) DEFAULT '' COMMENT '实体类名称',
                             `tpl_category` varchar(200) DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
                             `package_name` varchar(100) DEFAULT NULL COMMENT '生成包路径',
                             `module_name` varchar(30) DEFAULT NULL COMMENT '生成模块名',
                             `business_name` varchar(30) DEFAULT NULL COMMENT '生成业务名',
                             `function_name` varchar(50) DEFAULT NULL COMMENT '生成功能名',
                             `function_author` varchar(50) DEFAULT NULL COMMENT '生成功能作者',
                             `gen_type` char(1) DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
                             `two_column` varchar(10) DEFAULT NULL COMMENT '是否显示两列',
                             `swagger_enable` varchar(10) DEFAULT NULL COMMENT '是否生成swagger',
                             `export_enable` varchar(10) DEFAULT NULL COMMENT '是否导出',
                             `flow_enable` varchar(10) DEFAULT NULL COMMENT '是否需要审批流',
                             `gen_path` varchar(200) DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
                             `options` varchar(1000) DEFAULT NULL COMMENT '其它生成选项',
                             `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                             `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                             `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                             `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                             `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                             PRIMARY KEY (`table_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=31 ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表';

-- ----------------------------
-- Records of gen_table
-- ----------------------------
BEGIN;
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `two_column`, `swagger_enable`, `export_enable`, `flow_enable`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, 'test_tree', '测试树表', '', '', 'TestTree', 'tree', 'com.hh.test', 'test', 'tree', '测试树', 'hh', '0', 'Y', NULL, NULL, NULL, '/', '{\"treeCode\":\"id\",\"treeName\":\"tree_name\",\"treeParentCode\":\"parent_id\",\"parentMenuId\":\"1061\"}', 'admin', '2023-03-23 23:26:34', '', '2023-04-07 21:24:39', NULL);
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `two_column`, `swagger_enable`, `export_enable`, `flow_enable`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8, 'test_leave', 'OA 请假申请表', NULL, NULL, 'TestLeave', 'crud', 'com.hh.test', 'test', 'leave', 'OA 请假申请', 'hh', '0', 'N', 'N', 'N', 'Y', '/', '{\"parentMenuId\":\"1061\"}', 'admin', '2023-04-01 23:13:51', '', '2023-10-24 02:39:27', NULL);
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `two_column`, `swagger_enable`, `export_enable`, `flow_enable`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9, 'test_mater', '主子表演示', 'test_sub', 'legal_id', 'TestMater', 'sub', 'com.hh.test', 'test', 'mater', '主子演示', 'hh', '0', 'Y', 'N', 'Y', NULL, '/', '{\"parentMenuId\":\"1061\"}', 'admin', '2023-04-07 12:29:53', '', '2023-05-03 22:15:31', NULL);
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `two_column`, `swagger_enable`, `export_enable`, `flow_enable`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (17, 'test_sub', '子表', NULL, NULL, 'TestSub', 'crud', 'com.hh.test', 'test', 'sub', '子', 'hh', '0', 'Y', 'N', NULL, NULL, '/', NULL, 'admin', '2023-04-08 06:40:21', '', NULL, NULL);
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `two_column`, `swagger_enable`, `export_enable`, `flow_enable`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (20, 'flow_definition', '流程定义表', '', '', 'FlowDefinition', 'crud', 'com.hh.flow', 'flow', 'definition', '流程定义', 'hh', '0', 'N', 'N', 'N', NULL, '/', '{\"parentMenuId\":\"1106\"}', 'admin', '2023-04-11 11:00:03', '', '2023-04-18 11:13:01', NULL);
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `two_column`, `swagger_enable`, `export_enable`, `flow_enable`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (21, 'flow_node', '流程结点表', 'flow_skip', 'node_id', 'FlowNode', 'sub', 'com.hh.flow', 'flow', 'node', '流程结点', 'hh', '0', 'Y', 'N', 'N', NULL, '/', '{\"parentMenuId\":\"1106\"}', 'admin', '2023-04-12 12:33:57', '', '2023-04-14 12:43:57', NULL);
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `two_column`, `swagger_enable`, `export_enable`, `flow_enable`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (22, 'flow_skip', '结点跳转关联表', NULL, NULL, 'FlowSkip', 'crud', 'com.hh.flow', 'test', 'flow', '结点跳转关联', 'hh', '0', 'Y', 'N', 'N', NULL, '/', '{}', 'admin', '2023-04-14 12:43:06', '', '2023-04-14 12:43:29', NULL);
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `two_column`, `swagger_enable`, `export_enable`, `flow_enable`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (23, 'flow_instance', '流程实例表', NULL, NULL, 'FlowInstance', 'crud', 'com.hh.flow', 'flow', 'instance', '流程实例', 'hh', '0', 'N', 'N', 'N', NULL, '/', '{\"parentMenuId\":\"1106\"}', 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04', NULL);
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `two_column`, `swagger_enable`, `export_enable`, `flow_enable`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (26, 'test_common', '常规表演示', NULL, NULL, 'TestCommon', 'crud', 'com.hh.test', 'test', 'common', '常规演示', 'hh', '0', 'Y', 'N', 'Y', 'N', '/', '{}', 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00', NULL);
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `two_column`, `swagger_enable`, `export_enable`, `flow_enable`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (27, 'flow_his_task', '历史任务记录表', NULL, NULL, 'FlowHisTask', 'crud', 'com.hh.test', 'test', 'task', '历史任务记录', 'hh', '0', 'Y', 'N', 'Y', NULL, '/', '{}', 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30', NULL);
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `two_column`, `swagger_enable`, `export_enable`, `flow_enable`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (29, 'sys_tenant_package', '租户套餐表', NULL, NULL, 'SysTenantPackage', 'crud', 'com.hh.system', 'system', 'tenant/package', '租户套餐', 'hh', '0', 'N', 'N', 'Y', 'N', '/', '{\"parentMenuId\":\"1125\"}', 'admin', '2023-10-26 14:32:16', '', '2023-10-27 01:33:58', NULL);
INSERT INTO `gen_table` (`table_id`, `table_name`, `table_comment`, `sub_table_name`, `sub_table_fk_name`, `class_name`, `tpl_category`, `package_name`, `module_name`, `business_name`, `function_name`, `function_author`, `gen_type`, `two_column`, `swagger_enable`, `export_enable`, `flow_enable`, `gen_path`, `options`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (30, 'sys_tenant', '租户表', NULL, NULL, 'SysTenant', 'crud', 'com.hh.system', 'system', 'tenant', '租户', 'hh', '0', 'Y', 'N', 'Y', 'N', '/', '{\"parentMenuId\":\"1125\"}', 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11', NULL);
COMMIT;

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column` (
                                    `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
                                    `table_id` bigint DEFAULT NULL COMMENT '归属表编号',
                                    `column_name` varchar(200) DEFAULT NULL COMMENT '列名称',
                                    `column_comment` varchar(500) DEFAULT NULL COMMENT '列描述',
                                    `column_type` varchar(100) DEFAULT NULL COMMENT '列类型',
                                    `java_type` varchar(500) DEFAULT NULL COMMENT 'JAVA类型',
                                    `java_field` varchar(200) DEFAULT NULL COMMENT 'JAVA字段名',
                                    `is_pk` char(1) DEFAULT NULL COMMENT '是否主键（1是）',
                                    `is_increment` char(1) DEFAULT NULL COMMENT '是否自增（1是）',
                                    `is_required` char(1) DEFAULT NULL COMMENT '是否必填（1是）',
                                    `is_insert` char(1) DEFAULT NULL COMMENT '是否为插入字段（1是）',
                                    `is_edit` char(1) DEFAULT NULL COMMENT '是否编辑字段（1是）',
                                    `is_list` char(1) DEFAULT NULL COMMENT '是否列表字段（1是）',
                                    `is_query` char(1) DEFAULT NULL COMMENT '是否查询字段（1是）',
                                    `query_type` varchar(200) DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
                                    `html_type` varchar(200) DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
                                    `dict_type` varchar(200) DEFAULT '' COMMENT '字典类型',
                                    `sort` int DEFAULT NULL COMMENT '排序',
                                    `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                                    `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                    `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                                    `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                                    PRIMARY KEY (`column_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=386 ROW_FORMAT=DYNAMIC COMMENT='代码生成业务表字段';

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
BEGIN;
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (19, 2, 'id', '主键', 'bigint(20)', 'Long', 'id', '1', '0', NULL, '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2023-03-23 23:26:34', '', '2023-04-07 21:24:39');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (20, 2, 'parent_id', '父id', 'int(11)', 'Long', 'parentId', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2023-03-23 23:26:34', '', '2023-04-07 21:24:39');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (21, 2, 'tree_name', '值', 'varchar(255)', 'String', 'treeName', '0', '0', NULL, '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2023-03-23 23:26:34', '', '2023-04-07 21:24:39');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (22, 2, 'version', '版本', 'int(11)', 'Long', 'version', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2023-03-23 23:26:34', '', '2023-04-07 21:24:39');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (23, 2, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, '0', NULL, NULL, NULL, 'EQ', 'datetime', '', 5, 'admin', '2023-03-23 23:26:34', '', '2023-04-07 21:24:39');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (24, 2, 'create_by', '创建人', 'varchar(64)', 'String', 'createBy', '0', '0', NULL, '0', NULL, NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2023-03-23 23:26:34', '', '2023-04-07 21:24:39');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (25, 2, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, '0', '0', NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2023-03-23 23:26:34', '', '2023-04-07 21:24:39');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (26, 2, 'update_by', '更新人', 'varchar(64)', 'String', 'updateBy', '0', '0', NULL, '0', '0', NULL, NULL, 'EQ', 'input', '', 8, 'admin', '2023-03-23 23:26:34', '', '2023-04-07 21:24:39');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (27, 2, 'del_flag', '删除标志', 'int(11)', 'Long', 'delFlag', '0', '0', NULL, '0', NULL, NULL, NULL, 'EQ', 'input', '', 9, 'admin', '2023-03-23 23:26:34', '', '2023-04-07 21:24:39');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (92, 8, 'id', '主键', 'bigint(20) unsigned', 'Long', 'id', '1', '0', NULL, '0', NULL, NULL, NULL, 'EQ', 'inputNumber', '', 1, 'admin', '2023-04-01 23:13:51', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (94, 8, 'type', '请假类型', 'tinyint(4)', 'Integer', 'type', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'leave_type', 2, 'admin', '2023-04-01 23:13:51', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (95, 8, 'reason', '请假原因', 'varchar(200)', 'String', 'reason', '0', '0', '1', '1', '1', '0', '0', 'EQ', 'textarea', '', 3, 'admin', '2023-04-01 23:13:51', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (96, 8, 'start_time', '开始时间', 'datetime', 'Date', 'startTime', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'datetime', '', 4, 'admin', '2023-04-01 23:13:51', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (97, 8, 'end_time', '结束时间', 'datetime', 'Date', 'endTime', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'datetime', '', 5, 'admin', '2023-04-01 23:13:51', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (98, 8, 'day', '请假天数', 'tinyint(4)', 'Integer', 'day', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2023-04-01 23:13:51', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (101, 8, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', NULL, '0', '0', '1', '1', 'EQ', 'input', '', 11, 'admin', '2023-04-01 23:13:51', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (102, 8, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, '1', '1', 'BETWEEN', 'datetime', '', 12, 'admin', '2023-04-01 23:13:51', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (103, 8, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', NULL, '0', '0', '0', '0', 'EQ', 'input', '', 13, 'admin', '2023-04-01 23:13:51', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (104, 8, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'datetime', '', 14, 'admin', '2023-04-01 23:13:51', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (107, 8, 'instance_id', '流程实例的id', 'varchar(64)', 'Long', 'instanceId', '0', '0', NULL, '0', '0', '0', '0', 'EQ', 'inputNumber', '', 7, '', '2023-04-01 23:19:57', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (108, 8, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', NULL, '0', NULL, NULL, NULL, 'EQ', 'input', '', 15, '', '2023-04-01 23:21:27', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (109, 8, 'flow_status', '流程状态（0待提交 1审批中 2 审批通过 8已完成 9已驳回 10失效）', 'tinyint(1)', 'Integer', 'flowStatus', '0', '0', NULL, '0', '0', '1', '1', 'EQ', 'select', 'flow_status', 10, '', '2023-04-01 23:27:17', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (110, 9, 'id', '事务所id', 'bigint(20)', 'Long', 'id', '1', '1', NULL, '0', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2023-04-07 12:29:53', '', '2023-05-03 22:15:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (111, 9, 'law_firm_name', '律师所名称', 'varchar(30)', 'String', 'lawFirmName', '0', '0', NULL, '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2023-04-07 12:29:53', '', '2023-05-03 22:15:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (112, 9, 'address', '地址', 'varchar(255)', 'String', 'address', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2023-04-07 12:29:53', '', '2023-05-03 22:15:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (113, 9, 'file_id', 'logo图片id', 'varchar(255)', 'String', 'fileId', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'imageUpload', '', 4, 'admin', '2023-04-07 12:29:53', '', '2023-05-03 22:15:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (114, 9, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', NULL, '0', NULL, NULL, NULL, 'EQ', 'input', '', 5, 'admin', '2023-04-07 12:29:53', '', '2023-05-03 22:15:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (115, 9, 'state', '状态', 'tinyint(2)', 'Integer', 'state', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'select', 'leave_status', 6, 'admin', '2023-04-07 12:29:53', '', '2023-05-03 22:15:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (116, 9, 'publish_time', '发布时间', 'datetime', 'Date', 'publishTime', '0', '0', NULL, '1', '1', '1', '1', 'BETWEEN', 'datetime', '', 7, 'admin', '2023-04-07 12:29:53', '', '2023-05-03 22:15:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (117, 9, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', NULL, '0', NULL, '1', NULL, 'EQ', 'input', '', 8, 'admin', '2023-04-07 12:29:53', '', '2023-05-03 22:15:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (118, 9, 'create_time', '创建时间/提交时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, '0', NULL, '1', NULL, 'EQ', 'datetime', '', 9, 'admin', '2023-04-07 12:29:53', '', '2023-05-03 22:15:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (119, 9, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', NULL, '0', '0', NULL, NULL, 'EQ', 'input', '', 10, 'admin', '2023-04-07 12:29:53', '', '2023-05-03 22:15:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (120, 9, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, '0', '0', NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2023-04-07 12:29:53', '', '2023-05-03 22:15:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (203, 17, 'id', '律师id', 'bigint(20)', 'Long', 'id', '1', '1', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2023-04-08 06:40:21', '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (204, 17, 'legal_id', '事务所id', 'bigint(20)', 'Long', 'legalId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2023-04-08 06:40:21', '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (205, 17, 'lawyer_name', '律师名称', 'varchar(30)', 'String', 'lawyerName', '0', '0', NULL, '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2023-04-08 06:40:21', '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (206, 17, 'phone', '联系电话', 'bigint(20)', 'Long', 'phone', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2023-04-08 06:40:21', '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (207, 17, 'brief_introduction', '简介', 'varchar(255)', 'String', 'briefIntroduction', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2023-04-08 06:40:21', '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (208, 17, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2023-04-08 06:40:21', '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (209, 17, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 7, 'admin', '2023-04-08 06:40:21', '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (210, 17, 'create_time', '创建时间/提交时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 8, 'admin', '2023-04-08 06:40:21', '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (211, 17, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 9, 'admin', '2023-04-08 06:40:21', '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (212, 17, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 10, 'admin', '2023-04-08 06:40:21', '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (241, 20, 'id', '主键id', 'bigint(20) unsigned', 'Long', 'id', '1', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'inputNumber', '', 1, 'admin', '2023-04-11 11:00:03', '', '2023-04-18 11:13:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (242, 20, 'flow_code', '流程编码', 'varchar(40)', 'String', 'flowCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2023-04-11 11:00:03', '', '2023-04-18 11:13:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (243, 20, 'flow_name', '流程名称', 'varchar(100)', 'String', 'flowName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2023-04-11 11:00:03', '', '2023-04-18 11:13:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (244, 20, 'version', '流程版本', 'varchar(20)', 'String', 'version', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2023-04-11 11:00:03', '', '2023-04-18 11:13:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (245, 20, 'is_publish', '是否发布（0未发布 1已发布 9失效）', 'tinyint(1)', 'Integer', 'isPublish', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'is_publish', 5, 'admin', '2023-04-11 11:00:03', '', '2023-04-18 11:13:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (246, 20, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', NULL, NULL, NULL, '1', '0', 'EQ', 'input', '', 8, 'admin', '2023-04-11 11:00:03', '', '2023-04-18 11:13:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (247, 20, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, NULL, NULL, '1', '0', 'EQ', 'datetime', '', 9, 'admin', '2023-04-11 11:00:03', '', '2023-04-18 11:13:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (248, 20, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 10, 'admin', '2023-04-11 11:00:03', '', '2023-04-18 11:13:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (249, 20, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2023-04-11 11:00:03', '', '2023-04-18 11:13:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (250, 20, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 12, 'admin', '2023-04-11 11:00:03', '', '2023-04-18 11:13:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (251, 21, 'id', '主键id', 'bigint(20) unsigned', 'Long', 'id', '1', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'inputNumber', '', 1, 'admin', '2023-04-12 12:33:57', '', '2023-05-03 23:03:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (252, 21, 'node_type', '结点类型（0开始结点 1中间结点 2结束结点）', 'tinyint(1)', 'Integer', 'nodeType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'node_type', 2, 'admin', '2023-04-12 12:33:57', '', '2023-05-03 23:03:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (253, 21, 'definition_id', '流程定义id', 'bigint(20)', 'Long', 'definitionId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'inputNumber', '', 3, 'admin', '2023-04-12 12:33:57', '', '2023-05-03 23:03:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (254, 21, 'node_name', '流程结点名称', 'varchar(100)', 'String', 'nodeName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2023-04-12 12:33:57', '', '2023-05-03 23:03:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (255, 21, 'node_code', '流程结点编码', 'varchar(40)', 'String', 'nodeCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2023-04-12 12:33:57', '', '2023-05-03 23:03:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (256, 21, 'version', '版本', 'varchar(20)', 'String', 'version', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 8, 'admin', '2023-04-12 12:33:57', '', '2023-05-03 23:03:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (257, 21, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 9, 'admin', '2023-04-12 12:33:57', '', '2023-05-03 23:03:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (258, 21, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 10, 'admin', '2023-04-12 12:33:57', '', '2023-05-03 23:03:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (259, 21, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 11, 'admin', '2023-04-12 12:33:57', '', '2023-05-03 23:03:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (260, 21, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2023-04-12 12:33:57', '', '2023-05-03 23:03:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (261, 21, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 13, 'admin', '2023-04-12 12:33:57', '', '2023-05-03 23:03:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (262, 22, 'id', '主键id', 'bigint(20) unsigned', 'Long', 'id', '1', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'inputNumber', '', 1, 'admin', '2023-04-14 12:43:06', '', '2023-04-14 13:02:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (263, 22, 'definition_id', '流程定义id', 'bigint(20)', 'Long', 'definitionId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'inputNumber', '', 2, 'admin', '2023-04-14 12:43:06', '', '2023-04-14 13:02:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (264, 22, 'node_id', '当前结点id', 'bigint(20)', 'Long', 'nodeId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'inputNumber', '', 3, 'admin', '2023-04-14 12:43:06', '', '2023-04-14 13:02:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (265, 22, 'now_node_code', '当前流程结点的编码', 'varchar(40)', 'String', 'nowNodeCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2023-04-14 12:43:06', '', '2023-04-14 13:02:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (266, 22, 'next_node_code', '下一个流程结点的编码', 'varchar(40)', 'String', 'nextNodeCode', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2023-04-14 12:43:06', '', '2023-04-14 13:02:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (267, 22, 'condition_value', '跳转条件', 'varchar(40)', 'String', 'conditionValue', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2023-04-14 12:43:06', '', '2023-04-14 13:02:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (268, 22, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 7, 'admin', '2023-04-14 12:43:06', '', '2023-04-14 13:02:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (269, 22, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 8, 'admin', '2023-04-14 12:43:06', '', '2023-04-14 13:02:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (270, 22, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 9, 'admin', '2023-04-14 12:43:06', '', '2023-04-14 13:02:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (271, 22, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 10, 'admin', '2023-04-14 12:43:06', '', '2023-04-14 13:02:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (272, 22, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 11, 'admin', '2023-04-14 12:43:06', '', '2023-04-14 13:02:31');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (273, 20, 'from_custom', '审批表单是否自定义（Y是 2否）', 'char(1)', 'String', 'fromCustom', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'radio', 'sys_yes_no', 6, '', '2023-04-18 10:52:57', '', '2023-04-18 11:13:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (274, 20, 'from_path', '审批表单是否自定义（Y是 2否）', 'varchar(100)', 'String', 'fromPath', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 7, '', '2023-04-18 10:52:57', '', '2023-04-18 11:13:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (275, 23, 'id', '主键id', 'bigint(20)', 'Long', 'id', '1', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'inputNumber', '', 1, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (276, 23, 'business_id', '业务id', 'varchar(40)', 'String', 'businessId', '0', '0', '1', '0', '0', '0', '0', 'EQ', 'input', '', 2, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (277, 23, 'node_code', '结点编码', 'varchar(40)', 'String', 'nodeCode', '0', '0', '1', '1', '1', '0', '0', 'EQ', 'input', '', 3, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (278, 23, 'node_name', '结点名称', 'varchar(100)', 'String', 'nodeName', '0', '0', NULL, '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (279, 23, 'flow_status', '流程状态（0开始 1执行中 2结束）', 'tinyint(1)', 'Integer', 'flowStatus', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'node_type', 5, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (280, 23, 'flow_version', '流程版本', 'varchar(20)', 'String', 'flowVersion', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (281, 23, 'user_code', '流程创建者编码', 'varchar(40)', 'String', 'userCode', '0', '0', '1', '1', '1', '0', '0', 'EQ', 'input', '', 7, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (282, 23, 'user_name', '流程创建者', 'varchar(100)', 'String', 'userName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (283, 23, 'definition_id', '对应flow_definition表的id', 'bigint(20)', 'Long', 'definitionId', '0', '0', '1', '1', '1', '0', '0', 'EQ', 'inputNumber', '', 9, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (284, 23, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', NULL, NULL, NULL, '1', '1', 'EQ', 'input', '', 10, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (285, 23, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, NULL, NULL, '1', '1', 'EQ', 'datetime', '', 11, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (286, 23, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 12, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (287, 23, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 13, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (288, 23, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 14, 'admin', '2023-04-18 13:38:28', '', '2023-04-22 11:27:04');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (304, 21, 'role_code', '角色编码(该结点能被哪些角色审核)', 'varchar(40)', 'String', 'roleCode', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', '', 6, '', '2023-05-03 23:03:30', '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (305, 21, 'role_name', '角色名称', 'varchar(100)', 'String', 'roleName', '0', '0', NULL, '1', '1', '1', '1', 'LIKE', 'input', '', 7, '', '2023-05-03 23:03:30', '', NULL);
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (310, 26, 'id', '主键id', 'bigint(20)', 'Long', 'id', '1', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'inputNumber', '', 1, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (311, 26, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 2, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (312, 26, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 3, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (313, 26, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 4, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (314, 26, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 5, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (315, 26, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (316, 26, 'title', '标题', 'varchar(64)', 'String', 'title', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (317, 26, 'level', '级别（取数据字典）', 'bigint(20)', 'Long', 'level', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'inputNumber', '', 8, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (318, 26, 'send_doc_no', '发文字号', 'varchar(64)', 'String', 'sendDocNo', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', '', 9, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (319, 26, 'send_doc_unit', '发文单位', 'varchar(64)', 'String', 'sendDocUnit', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', '', 10, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (320, 26, 'publish_time', '发布时间', 'date', 'Date', 'publishTime', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'datetime', '', 11, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (321, 26, 'deadline', '截至日期', 'datetime', 'Date', 'deadline', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'datetime', '', 12, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (322, 26, 'label', '标签', 'longtext', 'String', 'label', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'textarea', '', 13, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (323, 26, 'content', '文章内容', 'longtext', 'String', 'content', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'editor', '', 14, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (324, 26, 'money', '金额', 'decimal(18,2)', 'BigDecimal', 'money', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'inputNumber', '', 15, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (325, 26, 'views', '阅读次数', 'bigint(20)', 'Long', 'views', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'inputNumber', '', 16, 'admin', '2023-05-05 16:16:39', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (328, 27, 'id', '主键id', 'bigint(40) unsigned', 'Long', 'id', '1', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'inputNumber', '', 1, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (329, 27, 'definition_id', '对应flow_definition表的id', 'bigint(20)', 'Long', 'definitionId', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'inputNumber', '', 2, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (330, 27, 'instance_id', '流程实例表id', 'bigint(20)', 'Long', 'instanceId', '0', '0', NULL, '0', '0', '0', '0', 'EQ', 'inputNumber', '', 3, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (331, 27, 'node_from', '开始结点编码', 'varchar(40)', 'String', 'nodeFrom', '0', '0', NULL, '0', '0', '0', '0', 'EQ', 'input', '', 4, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (332, 27, 'node_from_name', '开始结点名称', 'varchar(100)', 'String', 'nodeFromName', '0', '0', NULL, '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (333, 27, 'node_type', '开始结点类型（0开始结点 1中间结点 2结束结点）', 'tinyint(1)', 'Integer', 'nodeType', '0', '0', '0', '0', '0', '0', '0', 'EQ', 'select', '', 6, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (334, 27, 'node_to', '目标结点编码', 'varchar(40)', 'String', 'nodeTo', '0', '0', NULL, '0', '0', '0', '0', 'EQ', 'input', '', 7, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (335, 27, 'node_to_name', '结束结点名称', 'varchar(100)', 'String', 'nodeToName', '0', '0', NULL, '1', '1', '1', '1', 'LIKE', 'input', '', 8, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (336, 27, 'user_code', '账号编码(只记录该流程审核时用的账户)', 'varchar(40)', 'String', 'userCode', '0', '0', NULL, '0', '0', '0', '0', 'EQ', 'input', '', 9, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (337, 27, 'user_name', '账号名称', 'varchar(100)', 'String', 'userName', '0', '0', NULL, '1', '1', '1', '1', 'LIKE', 'input', '', 10, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (338, 27, 'flow_status', '流程状态', 'tinyint(1)', 'Integer', 'flowStatus', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'select', 'flow_status', 11, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (339, 27, 'message', '审批意见', 'varchar(500)', 'String', 'message', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'textarea', '', 12, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (340, 27, 'condition_value', '跳转条件', 'varchar(40)', 'String', 'conditionValue', '0', '0', NULL, '0', '0', '0', '0', 'EQ', 'input', '', 13, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (341, 27, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, '1', '1', NULL, NULL, 'EQ', 'datetime', '', 14, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (342, 27, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 15, 'admin', '2023-06-01 13:16:27', '', '2023-06-01 13:21:30');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (351, 26, 'new_file_id', '附件', 'varchar(200)', 'String', 'newFileId', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', '', 17, '', '2023-10-24 00:09:46', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (352, 26, 'image_id', '图片', 'varchar(200)', 'String', 'imageId', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'input', '', 18, '', '2023-10-24 00:09:46', '', '2023-10-24 01:13:00');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (353, 8, 'node_code', '节点编码', 'varchar(100)', 'String', 'nodeCode', '0', '0', NULL, '0', '0', '0', '0', 'EQ', 'input', '', 8, '', '2023-10-24 02:21:48', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (354, 8, 'node_name', '流程节点名称', 'varchar(100)', 'String', 'nodeName', '0', '0', NULL, '0', '0', '1', '0', 'LIKE', 'input', '', 9, '', '2023-10-24 02:21:48', '', '2023-10-24 02:39:27');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (355, 29, 'package_id', '租户套餐id', 'bigint(20)', 'Long', 'packageId', '1', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'inputNumber', '', 1, 'admin', '2023-10-26 14:32:16', '', '2023-10-27 01:50:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (356, 29, 'package_name', '套餐名称', 'varchar(20)', 'String', 'packageName', '0', '0', NULL, '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2023-10-26 14:32:16', '', '2023-10-27 01:50:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (357, 29, 'menu_ids', '关联菜单id', 'varchar(3000)', 'String', 'menuIds', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'textarea', '', 3, 'admin', '2023-10-26 14:32:16', '', '2023-10-27 01:50:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (358, 29, 'remark', '备注', 'varchar(200)', 'String', 'remark', '0', '0', NULL, '1', '1', '1', NULL, 'EQ', 'input', '', 4, 'admin', '2023-10-26 14:32:16', '', '2023-10-27 01:50:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (359, 29, 'menu_check_strictly', '菜单树选择项是否关联显示（0父子不互相关联显示 1父子互相关联显示）', 'tinyint(1)', 'Integer', 'menuCheckStrictly', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'inputNumber', '', 5, 'admin', '2023-10-26 14:32:16', '', '2023-10-27 01:50:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (360, 29, 'status', '状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'radio', '', 6, 'admin', '2023-10-26 14:32:16', '', '2023-10-27 01:50:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (361, 29, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 7, 'admin', '2023-10-26 14:32:16', '', '2023-10-27 01:50:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (363, 29, 'create_by', '创建者', 'bigint(20)', 'String', 'createBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 8, 'admin', '2023-10-26 14:32:16', '', '2023-10-27 01:50:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (364, 29, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2023-10-26 14:32:16', '', '2023-10-27 01:50:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (365, 29, 'update_by', '更新者', 'bigint(20)', 'String', 'updateBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 10, 'admin', '2023-10-26 14:32:16', '', '2023-10-27 01:50:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (366, 29, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2023-10-26 14:32:16', '', '2023-10-27 01:50:01');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (367, 30, 'id', 'id', 'bigint(20)', 'Long', 'id', '1', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'inputNumber', '', 1, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (368, 30, 'tenant_id', '租户编号', 'varchar(20)', 'String', 'tenantId', '0', '0', '1', '0', '0', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (369, 30, 'contact_user_name', '联系人', 'varchar(20)', 'String', 'contactUserName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (370, 30, 'contact_phone', '联系电话', 'varchar(20)', 'String', 'contactPhone', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 4, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (371, 30, 'company_name', '企业名称', 'varchar(50)', 'String', 'companyName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 5, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (372, 30, 'license_number', '统一社会信用代码', 'varchar(30)', 'String', 'licenseNumber', '0', '0', NULL, '1', '1', '1', '0', 'EQ', 'input', '', 6, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (373, 30, 'address', '地址', 'varchar(200)', 'String', 'address', '0', '0', NULL, '1', '1', '0', '0', 'EQ', 'input', '', 7, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (374, 30, 'intro', '企业简介', 'varchar(200)', 'String', 'intro', '0', '0', NULL, '1', '1', '0', '0', 'EQ', 'input', '', 8, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (375, 30, 'domain', '域名', 'varchar(200)', 'String', 'domain', '0', '0', NULL, '1', '1', '0', '0', 'EQ', 'input', '', 9, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (376, 30, 'remark', '备注', 'varchar(200)', 'String', 'remark', '0', '0', NULL, '1', '1', '1', '1', 'EQ', 'textarea', '', 10, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (377, 30, 'package_id', '租户套餐编号', 'bigint(20)', 'Long', 'packageId', '0', '0', NULL, '1', '1', '0', '0', 'EQ', 'select', '', 11, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (378, 30, 'expire_time', '过期时间', 'datetime', 'Date', 'expireTime', '0', '0', NULL, '1', '1', '1', '0', 'EQ', 'datetime', '', 12, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (379, 30, 'account_count', '用户数量（-1不限制）', 'int(11)', 'Long', 'accountCount', '0', '0', NULL, '1', '1', '0', '0', 'EQ', 'inputNumber', '', 13, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (380, 30, 'status', '租户状态（0正常 1停用）', 'char(1)', 'String', 'status', '0', '0', NULL, '1', '1', '1', '0', 'EQ', 'select', '', 14, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (381, 30, 'del_flag', '删除标志（0代表存在 2代表删除）', 'char(1)', 'String', 'delFlag', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 15, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (382, 30, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 16, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (383, 30, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 17, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (384, 30, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'input', '', 18, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
INSERT INTO `gen_table_column` (`column_id`, `table_id`, `column_name`, `column_comment`, `column_type`, `java_type`, `java_field`, `is_pk`, `is_increment`, `is_required`, `is_insert`, `is_edit`, `is_list`, `is_query`, `query_type`, `html_type`, `dict_type`, `sort`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (385, 30, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', NULL, NULL, NULL, NULL, NULL, 'EQ', 'datetime', '', 19, 'admin', '2023-10-27 11:18:34', '', '2023-10-27 12:20:11');
COMMIT;

-- ----------------------------
-- Table structure for qrtz_blob_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_blob_triggers`;
CREATE TABLE `qrtz_blob_triggers` (
                                      `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                      `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
                                      `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
                                      `blob_data` blob COMMENT '存放持久化Trigger对象',
                                      PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
                                      CONSTRAINT `qrtz_blob_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='Blob类型的触发器表';

-- ----------------------------
-- Records of qrtz_blob_triggers
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for qrtz_calendars
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_calendars`;
CREATE TABLE `qrtz_calendars` (
                                  `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                  `calendar_name` varchar(200) NOT NULL COMMENT '日历名称',
                                  `calendar` blob NOT NULL COMMENT '存放持久化calendar对象',
                                  PRIMARY KEY (`sched_name`,`calendar_name`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='日历信息表';

-- ----------------------------
-- Records of qrtz_calendars
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for qrtz_cron_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_cron_triggers`;
CREATE TABLE `qrtz_cron_triggers` (
                                      `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                      `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
                                      `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
                                      `cron_expression` varchar(200) NOT NULL COMMENT 'cron表达式',
                                      `time_zone_id` varchar(80) DEFAULT NULL COMMENT '时区',
                                      PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
                                      CONSTRAINT `qrtz_cron_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='Cron类型的触发器表';

-- ----------------------------
-- Records of qrtz_cron_triggers
-- ----------------------------
BEGIN;
INSERT INTO `qrtz_cron_triggers` (`sched_name`, `trigger_name`, `trigger_group`, `cron_expression`, `time_zone_id`) VALUES ('HhScheduler', 'TASK_CLASS_NAME1', 'DEFAULT', '0/1 * * * * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` (`sched_name`, `trigger_name`, `trigger_group`, `cron_expression`, `time_zone_id`) VALUES ('HhScheduler', 'TASK_CLASS_NAME2', 'DEFAULT', '0/15 * * * * ?', 'Asia/Shanghai');
INSERT INTO `qrtz_cron_triggers` (`sched_name`, `trigger_name`, `trigger_group`, `cron_expression`, `time_zone_id`) VALUES ('HhScheduler', 'TASK_CLASS_NAME3', 'DEFAULT', '0/20 * * * * ?', 'Asia/Shanghai');
COMMIT;

-- ----------------------------
-- Table structure for qrtz_fired_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_fired_triggers`;
CREATE TABLE `qrtz_fired_triggers` (
                                       `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                       `entry_id` varchar(95) NOT NULL COMMENT '调度器实例id',
                                       `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
                                       `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
                                       `instance_name` varchar(200) NOT NULL COMMENT '调度器实例名',
                                       `fired_time` bigint NOT NULL COMMENT '触发的时间',
                                       `sched_time` bigint NOT NULL COMMENT '定时器制定的时间',
                                       `priority` int NOT NULL COMMENT '优先级',
                                       `state` varchar(16) NOT NULL COMMENT '状态',
                                       `job_name` varchar(200) DEFAULT NULL COMMENT '任务名称',
                                       `job_group` varchar(200) DEFAULT NULL COMMENT '任务组名',
                                       `is_nonconcurrent` varchar(1) DEFAULT NULL COMMENT '是否并发',
                                       `requests_recovery` varchar(1) DEFAULT NULL COMMENT '是否接受恢复执行',
                                       PRIMARY KEY (`sched_name`,`entry_id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='已触发的触发器表';

-- ----------------------------
-- Records of qrtz_fired_triggers
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for qrtz_job_details
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_job_details`;
CREATE TABLE `qrtz_job_details` (
                                    `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                    `job_name` varchar(200) NOT NULL COMMENT '任务名称',
                                    `job_group` varchar(200) NOT NULL COMMENT '任务组名',
                                    `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
                                    `job_class_name` varchar(250) NOT NULL COMMENT '执行任务类名称',
                                    `is_durable` varchar(1) NOT NULL COMMENT '是否持久化',
                                    `is_nonconcurrent` varchar(1) NOT NULL COMMENT '是否并发',
                                    `is_update_data` varchar(1) NOT NULL COMMENT '是否更新数据',
                                    `requests_recovery` varchar(1) NOT NULL COMMENT '是否接受恢复执行',
                                    `job_data` blob COMMENT '存放持久化job对象',
                                    PRIMARY KEY (`sched_name`,`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='任务详细信息表';

-- ----------------------------
-- Records of qrtz_job_details
-- ----------------------------
BEGIN;
INSERT INTO `qrtz_job_details` (`sched_name`, `job_name`, `job_group`, `description`, `job_class_name`, `is_durable`, `is_nonconcurrent`, `is_update_data`, `requests_recovery`, `job_data`) VALUES ('HhScheduler', 'TASK_CLASS_NAME1', 'DEFAULT', NULL, 'com.hh.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001B636F6D2E68682E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200094C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000672656D61726B71007E00094C000673746174757371007E000978720024636F6D2E68682E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0002696471007E000A4C0006706172616D7371007E00034C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7372000E6A6176612E7574696C2E44617465686A81014B5974190300007870770800000186E8DB5A187870707070707400013174000D302F31202A202A202A202A203F74001168685461736B2E72794E6F506172616D7374000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000001740018E7B3BBE7BB9FE9BB98E8AEA4EFBC88E697A0E58F82EFBC8974000131740000740001317800);
INSERT INTO `qrtz_job_details` (`sched_name`, `job_name`, `job_group`, `description`, `job_class_name`, `is_durable`, `is_nonconcurrent`, `is_update_data`, `requests_recovery`, `job_data`) VALUES ('HhScheduler', 'TASK_CLASS_NAME2', 'DEFAULT', NULL, 'com.hh.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001B636F6D2E68682E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200094C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000672656D61726B71007E00094C000673746174757371007E000978720024636F6D2E68682E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0002696471007E000A4C0006706172616D7371007E00034C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7372000E6A6176612E7574696C2E44617465686A81014B5974190300007870770800000186E8DB5A187870707070707400013174000E302F3135202A202A202A202A203F74001568685461736B2E7279506172616D7328276868272974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000002740018E7B3BBE7BB9FE9BB98E8AEA4EFBC88E69C89E58F82EFBC8974000133740000740001317800);
INSERT INTO `qrtz_job_details` (`sched_name`, `job_name`, `job_group`, `description`, `job_class_name`, `is_durable`, `is_nonconcurrent`, `is_update_data`, `requests_recovery`, `job_data`) VALUES ('HhScheduler', 'TASK_CLASS_NAME3', 'DEFAULT', NULL, 'com.hh.quartz.util.QuartzDisallowConcurrentExecution', '0', '1', '0', '0', 0xACED0005737200156F72672E71756172747A2E4A6F62446174614D61709FB083E8BFA9B0CB020000787200266F72672E71756172747A2E7574696C732E537472696E674B65794469727479466C61674D61708208E8C3FBC55D280200015A0013616C6C6F77735472616E7369656E74446174617872001D6F72672E71756172747A2E7574696C732E4469727479466C61674D617013E62EAD28760ACE0200025A000564697274794C00036D617074000F4C6A6176612F7574696C2F4D61703B787001737200116A6176612E7574696C2E486173684D61700507DAC1C31660D103000246000A6C6F6164466163746F724900097468726573686F6C6478703F4000000000000C7708000000100000000174000F5441534B5F50524F504552544945537372001B636F6D2E68682E71756172747A2E646F6D61696E2E5379734A6F6200000000000000010200094C000A636F6E63757272656E747400124C6A6176612F6C616E672F537472696E673B4C000E63726F6E45787072657373696F6E71007E00094C000C696E766F6B6554617267657471007E00094C00086A6F6247726F757071007E00094C00056A6F6249647400104C6A6176612F6C616E672F4C6F6E673B4C00076A6F624E616D6571007E00094C000D6D697366697265506F6C69637971007E00094C000672656D61726B71007E00094C000673746174757371007E000978720024636F6D2E68682E636F6D6D6F6E2E636F72652E646F6D61696E2E42617365456E7469747900000000000000010200074C0008637265617465427971007E00094C000A63726561746554696D657400104C6A6176612F7574696C2F446174653B4C0002696471007E000A4C0006706172616D7371007E00034C000B73656172636856616C756571007E00094C0008757064617465427971007E00094C000A75706461746554696D6571007E000C787074000561646D696E7372000E6A6176612E7574696C2E44617465686A81014B5974190300007870770800000186E8DB5A187870707070707400013174000E302F3230202A202A202A202A203F74003868685461736B2E72794D756C7469706C65506172616D7328276868272C20747275652C20323030304C2C203331362E3530442C203130302974000744454641554C547372000E6A6176612E6C616E672E4C6F6E673B8BE490CC8F23DF0200014A000576616C7565787200106A6176612E6C616E672E4E756D62657286AC951D0B94E08B02000078700000000000000003740018E7B3BBE7BB9FE9BB98E8AEA4EFBC88E5A49AE58F82EFBC8974000133740000740001317800);
COMMIT;

-- ----------------------------
-- Table structure for qrtz_locks
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_locks`;
CREATE TABLE `qrtz_locks` (
                              `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                              `lock_name` varchar(40) NOT NULL COMMENT '悲观锁名称',
                              PRIMARY KEY (`sched_name`,`lock_name`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='存储的悲观锁信息表';

-- ----------------------------
-- Records of qrtz_locks
-- ----------------------------
BEGIN;
INSERT INTO `qrtz_locks` (`sched_name`, `lock_name`) VALUES ('HhScheduler', 'STATE_ACCESS');
INSERT INTO `qrtz_locks` (`sched_name`, `lock_name`) VALUES ('HhScheduler', 'TRIGGER_ACCESS');
COMMIT;

-- ----------------------------
-- Table structure for qrtz_paused_trigger_grps
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_paused_trigger_grps`;
CREATE TABLE `qrtz_paused_trigger_grps` (
                                            `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                            `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
                                            PRIMARY KEY (`sched_name`,`trigger_group`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='暂停的触发器表';

-- ----------------------------
-- Records of qrtz_paused_trigger_grps
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for qrtz_scheduler_state
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_scheduler_state`;
CREATE TABLE `qrtz_scheduler_state` (
                                        `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                        `instance_name` varchar(200) NOT NULL COMMENT '实例名称',
                                        `last_checkin_time` bigint NOT NULL COMMENT '上次检查时间',
                                        `checkin_interval` bigint NOT NULL COMMENT '检查间隔时间',
                                        PRIMARY KEY (`sched_name`,`instance_name`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='调度器状态表';

-- ----------------------------
-- Records of qrtz_scheduler_state
-- ----------------------------
BEGIN;
INSERT INTO `qrtz_scheduler_state` (`sched_name`, `instance_name`, `last_checkin_time`, `checkin_interval`) VALUES ('HhScheduler', 'minliuhua1693537803303', 1693537926785, 15000);
COMMIT;

-- ----------------------------
-- Table structure for qrtz_simple_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simple_triggers`;
CREATE TABLE `qrtz_simple_triggers` (
                                        `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                        `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
                                        `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
                                        `repeat_count` bigint NOT NULL COMMENT '重复的次数统计',
                                        `repeat_interval` bigint NOT NULL COMMENT '重复的间隔时间',
                                        `times_triggered` bigint NOT NULL COMMENT '已经触发的次数',
                                        PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
                                        CONSTRAINT `qrtz_simple_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='简单触发器的信息表';

-- ----------------------------
-- Records of qrtz_simple_triggers
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for qrtz_simprop_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_simprop_triggers`;
CREATE TABLE `qrtz_simprop_triggers` (
                                         `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                         `trigger_name` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_name的外键',
                                         `trigger_group` varchar(200) NOT NULL COMMENT 'qrtz_triggers表trigger_group的外键',
                                         `str_prop_1` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第一个参数',
                                         `str_prop_2` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第二个参数',
                                         `str_prop_3` varchar(512) DEFAULT NULL COMMENT 'String类型的trigger的第三个参数',
                                         `int_prop_1` int DEFAULT NULL COMMENT 'int类型的trigger的第一个参数',
                                         `int_prop_2` int DEFAULT NULL COMMENT 'int类型的trigger的第二个参数',
                                         `long_prop_1` bigint DEFAULT NULL COMMENT 'long类型的trigger的第一个参数',
                                         `long_prop_2` bigint DEFAULT NULL COMMENT 'long类型的trigger的第二个参数',
                                         `dec_prop_1` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第一个参数',
                                         `dec_prop_2` decimal(13,4) DEFAULT NULL COMMENT 'decimal类型的trigger的第二个参数',
                                         `bool_prop_1` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第一个参数',
                                         `bool_prop_2` varchar(1) DEFAULT NULL COMMENT 'Boolean类型的trigger的第二个参数',
                                         PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
                                         CONSTRAINT `qrtz_simprop_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `trigger_name`, `trigger_group`) REFERENCES `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='同步机制的行锁表';

-- ----------------------------
-- Records of qrtz_simprop_triggers
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for qrtz_triggers
-- ----------------------------
DROP TABLE IF EXISTS `qrtz_triggers`;
CREATE TABLE `qrtz_triggers` (
                                 `sched_name` varchar(120) NOT NULL COMMENT '调度名称',
                                 `trigger_name` varchar(200) NOT NULL COMMENT '触发器的名字',
                                 `trigger_group` varchar(200) NOT NULL COMMENT '触发器所属组的名字',
                                 `job_name` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_name的外键',
                                 `job_group` varchar(200) NOT NULL COMMENT 'qrtz_job_details表job_group的外键',
                                 `description` varchar(250) DEFAULT NULL COMMENT '相关介绍',
                                 `next_fire_time` bigint DEFAULT NULL COMMENT '上一次触发时间（毫秒）',
                                 `prev_fire_time` bigint DEFAULT NULL COMMENT '下一次触发时间（默认为-1表示不触发）',
                                 `priority` int DEFAULT NULL COMMENT '优先级',
                                 `trigger_state` varchar(16) NOT NULL COMMENT '触发器状态',
                                 `trigger_type` varchar(8) NOT NULL COMMENT '触发器的类型',
                                 `start_time` bigint NOT NULL COMMENT '开始时间',
                                 `end_time` bigint DEFAULT NULL COMMENT '结束时间',
                                 `calendar_name` varchar(200) DEFAULT NULL COMMENT '日程表名称',
                                 `misfire_instr` smallint DEFAULT NULL COMMENT '补偿执行的策略',
                                 `job_data` blob COMMENT '存放持久化job对象',
                                 PRIMARY KEY (`sched_name`,`trigger_name`,`trigger_group`) USING BTREE,
                                 KEY `sched_name` (`sched_name`,`job_name`,`job_group`) USING BTREE,
                                 CONSTRAINT `qrtz_triggers_ibfk_1` FOREIGN KEY (`sched_name`, `job_name`, `job_group`) REFERENCES `qrtz_job_details` (`sched_name`, `job_name`, `job_group`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='触发器详细信息表';

-- ----------------------------
-- Records of qrtz_triggers
-- ----------------------------
BEGIN;
INSERT INTO `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`, `job_name`, `job_group`, `description`, `next_fire_time`, `prev_fire_time`, `priority`, `trigger_state`, `trigger_type`, `start_time`, `end_time`, `calendar_name`, `misfire_instr`, `job_data`) VALUES ('HhScheduler', 'TASK_CLASS_NAME1', 'DEFAULT', 'TASK_CLASS_NAME1', 'DEFAULT', NULL, 1693537803000, -1, 5, 'PAUSED', 'CRON', 1693537803000, 0, NULL, -1, '');
INSERT INTO `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`, `job_name`, `job_group`, `description`, `next_fire_time`, `prev_fire_time`, `priority`, `trigger_state`, `trigger_type`, `start_time`, `end_time`, `calendar_name`, `misfire_instr`, `job_data`) VALUES ('HhScheduler', 'TASK_CLASS_NAME2', 'DEFAULT', 'TASK_CLASS_NAME2', 'DEFAULT', NULL, 1693537815000, -1, 5, 'PAUSED', 'CRON', 1693537803000, 0, NULL, 2, '');
INSERT INTO `qrtz_triggers` (`sched_name`, `trigger_name`, `trigger_group`, `job_name`, `job_group`, `description`, `next_fire_time`, `prev_fire_time`, `priority`, `trigger_state`, `trigger_type`, `start_time`, `end_time`, `calendar_name`, `misfire_instr`, `job_data`) VALUES ('HhScheduler', 'TASK_CLASS_NAME3', 'DEFAULT', 'TASK_CLASS_NAME3', 'DEFAULT', NULL, 1693537820000, -1, 5, 'PAUSED', 'CRON', 1693537803000, 0, NULL, 2, '');
COMMIT;

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
                              `config_id` bigint NOT NULL AUTO_INCREMENT COMMENT '参数主键',
                              `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                              `config_name` varchar(100) DEFAULT '' COMMENT '参数名称',
                              `config_key` varchar(100) DEFAULT '' COMMENT '参数键名',
                              `config_value` varchar(500) DEFAULT '' COMMENT '参数键值',
                              `config_type` char(1) DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
                              `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                              `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                              `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                              `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                              `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                              PRIMARY KEY (`config_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1719040395834834950 ROW_FORMAT=DYNAMIC COMMENT='参数配置表';

-- ----------------------------
-- Records of sys_config
-- ----------------------------
BEGIN;
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '000000', '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2023-03-16 13:18:55', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, '000000', '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2023-03-16 13:18:55', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3, '000000', '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2023-03-16 13:18:55', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4, '000000', '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2023-03-16 13:18:55', 'admin', '2023-11-03 15:34:22', '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621904502785, '662218', '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2023-03-16 13:18:55', '', '2023-03-16 13:18:55', '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621904502786, '662218', '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2023-03-16 13:18:55', '', '2023-03-16 13:18:55', '初始化密码 123456');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621904502787, '662218', '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2023-03-16 13:18:55', '', '2023-03-16 13:18:55', '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621904502788, '662218', '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', '2023-03-16 13:18:55', 'admin', '2023-03-16 13:18:55', '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395834834946, '460253', '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2023-03-16 13:18:55', '', '2023-03-16 13:18:55', '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395834834947, '460253', '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2023-03-16 13:18:55', '', '2023-03-16 13:18:55', '初始化密码 123456');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395834834948, '460253', '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2023-03-16 13:18:55', '', '2023-03-16 13:18:55', '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` (`config_id`, `tenant_id`, `config_name`, `config_key`, `config_value`, `config_type`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395834834949, '460253', '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'true', 'Y', 'admin', '2023-03-16 13:18:55', 'admin', '2023-03-16 13:18:55', '是否开启注册用户功能（true开启，false关闭）');
COMMIT;

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept` (
                            `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
                            `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                            `parent_id` bigint DEFAULT '0' COMMENT '父部门id',
                            `ancestors` varchar(50) DEFAULT '' COMMENT '祖级列表',
                            `dept_name` varchar(30) DEFAULT '' COMMENT '部门名称',
                            `order_num` int DEFAULT '0' COMMENT '显示顺序',
                            `leader` bigint DEFAULT NULL COMMENT '负责人',
                            `phone` varchar(11) DEFAULT NULL COMMENT '联系电话',
                            `email` varchar(50) DEFAULT NULL COMMENT '邮箱',
                            `status` char(1) DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
                            `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                            `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                            `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1719040394589126658 ROW_FORMAT=DYNAMIC COMMENT='部门表';

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
BEGIN;
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (100, '000000', 0, '0', 'A科技', 0, NULL, '15888888888', 'ry@qq.com', '0', '0', 'admin', '2023-03-16 13:18:52', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (101, '000000', 100, '0,100', '深圳总公司', 1, NULL, '15888888888', 'ry@qq.com', '0', '0', 'admin', '2023-03-16 13:18:52', 'admin', '2023-06-12 08:54:22');
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (102, '000000', 100, '0,100', '长沙分公司', 2, NULL, '15888888888', 'ry@qq.com', '0', '0', 'admin', '2023-03-16 13:18:52', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (103, '000000', 101, '0,100,101', '研发部门', 1, 5, '15888888888', 'ry@qq.com', '0', '0', 'admin', '2023-03-16 13:18:52', 'admin', '2023-10-27 23:57:44');
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (104, '000000', 101, '0,100,101', '市场部门', 2, NULL, '15888888888', 'ry@qq.com', '0', '0', 'admin', '2023-03-16 13:18:52', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (105, '000000', 101, '0,100,101', '测试部门', 3, NULL, '15888888888', 'ry@qq.com', '0', '0', 'admin', '2023-03-16 13:18:52', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (106, '000000', 101, '0,100,101', '财务部门', 4, NULL, '15888888888', 'ry@qq.com', '0', '0', 'admin', '2023-03-16 13:18:52', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (107, '000000', 101, '0,100,101', '运维部门', 5, NULL, '15888888888', 'ry@qq.com', '0', '0', 'admin', '2023-03-16 13:18:52', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (108, '000000', 102, '0,100,102', '市场部门', 1, NULL, '15888888888', 'ry@qq.com', '0', '0', 'admin', '2023-03-16 13:18:52', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (109, '000000', 102, '0,100,102', '财务部门', 2, NULL, '15888888888', 'ry@qq.com', '0', '0', 'admin', '2023-03-16 13:18:52', '', NULL);
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1719031620470050818, '662218', 0, '0', '测试企业', 0, 1719031621183082497, NULL, NULL, '0', '0', NULL, '2023-10-31 00:40:51', 'admin', '2023-10-31 00:40:51');
INSERT INTO `sys_dept` (`dept_id`, `tenant_id`, `parent_id`, `ancestors`, `dept_name`, `order_num`, `leader`, `phone`, `email`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1719040394589126657, '460253', 0, '0', '工具企业负', 0, 1719040395184717826, NULL, NULL, '0', '0', NULL, '2023-10-31 01:15:43', 'admin', '2023-10-31 01:15:43');
COMMIT;

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data` (
                                 `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
                                 `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                                 `dict_sort` int DEFAULT '0' COMMENT '字典排序',
                                 `dict_label` varchar(100) DEFAULT '' COMMENT '字典标签',
                                 `dict_value` varchar(100) DEFAULT '' COMMENT '字典键值',
                                 `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
                                 `css_class` varchar(100) DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
                                 `list_class` varchar(100) DEFAULT NULL COMMENT '表格回显样式',
                                 `is_default` char(1) DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
                                 `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
                                 `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                                 `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                 `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                                 `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                                 `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                                 PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1719040395704811535 ROW_FORMAT=DYNAMIC COMMENT='字典数据表';

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
BEGIN;
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '000000', 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '性别男');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, '000000', 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '性别女');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3, '000000', 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4, '000000', 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5, '000000', 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6, '000000', 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (7, '000000', 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8, '000000', 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9, '000000', 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (10, '000000', 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (11, '000000', 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (12, '000000', 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (13, '000000', 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (14, '000000', 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '通知');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (15, '000000', 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '公告');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (16, '000000', 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (17, '000000', 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (18, '000000', 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (19, '000000', 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (20, '000000', 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (21, '000000', 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (22, '000000', 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (23, '000000', 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (24, '000000', 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (25, '000000', 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (26, '000000', 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (27, '000000', 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (28, '000000', 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (29, '000000', 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2023-03-16 13:18:55', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (30, '000000', 0, '串行-简单', '0', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2023-04-01 23:32:40', 'admin', '2023-10-20 10:04:55', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (31, '000000', 1, '串行-通过互斥', '1', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2023-04-01 23:33:14', 'admin', '2023-10-20 10:04:59', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (32, '000000', 0, '待审批', '0', 'leave_status', NULL, 'default', 'N', '0', 'admin', '2023-04-01 23:38:43', '', NULL, NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (33, '000000', 1, '审批中', '1', 'leave_status', NULL, 'default', 'N', '0', 'admin', '2023-04-01 23:38:56', '', NULL, NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (34, '000000', 2, '审批结束', '2', 'leave_status', NULL, 'default', 'N', '0', 'admin', '2023-04-01 23:39:09', '', NULL, NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (35, '000000', 0, '未发布', '0', 'is_publish', NULL, 'default', 'N', '0', 'admin', '2023-04-11 11:09:04', 'admin', '2023-04-11 13:26:51', '未发布');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (36, '000000', 1, '已发布', '1', 'is_publish', NULL, 'default', 'N', '0', 'admin', '2023-04-11 11:09:13', 'admin', '2023-04-11 13:27:02', '已发布');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (37, '000000', 9, '已失效', '9', 'is_publish', '9', 'default', 'N', '0', 'admin', '2023-04-11 13:26:32', 'admin', '2023-04-14 18:23:05', '失效');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (38, '000000', 0, '开始节点', '0', 'node_type', NULL, 'default', 'N', '0', 'admin', '2023-04-12 12:46:56', 'admin', '2023-10-09 11:44:44', '开始节点');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (39, '000000', 1, '中间节点', '1', 'node_type', NULL, 'default', 'N', '0', 'admin', '2023-04-12 12:47:05', 'admin', '2023-10-09 11:44:49', '中间节点');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (40, '000000', 2, '结束节点', '2', 'node_type', NULL, 'default', 'N', '0', 'admin', '2023-04-12 12:47:18', 'admin', '2023-10-09 11:44:54', '结束节点');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (41, '000000', 0, '待提交', '0', 'flow_status', NULL, 'info', 'N', '0', 'admin', '2023-05-07 00:48:15', 'admin', '2023-05-07 00:50:24', '待提交');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (42, '000000', 1, '审批中', '1', 'flow_status', NULL, 'primary', 'N', '0', 'admin', '2023-05-07 00:49:27', 'admin', '2023-05-07 00:50:33', '审批中');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (43, '000000', 8, '已完成', '8', 'flow_status', NULL, 'success', 'N', '0', 'admin', '2023-05-07 00:49:59', 'admin', '2023-09-04 00:28:38', '已完成');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (44, '000000', 9, '驳回', '9', 'flow_status', NULL, 'warning', 'N', '0', 'admin', '2023-05-07 00:50:56', '', NULL, '驳回');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (45, '000000', 2, '审批通过', '2', 'flow_status', NULL, 'primary', 'N', '0', 'admin', '2023-09-04 00:29:04', 'admin', '2023-09-18 14:53:17', '审批通过');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (46, '000000', 2, '并行-汇聚', '2', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2023-09-13 00:17:44', 'admin', '2023-10-20 10:05:03', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (47, '000000', 3, '互斥网关', '3', 'node_type', NULL, 'default', 'N', '0', 'admin', '2023-09-13 15:25:40', '', NULL, NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (48, '000000', 4, '并行网关', '4', 'node_type', NULL, 'default', 'N', '0', 'admin', '2023-09-13 15:25:59', '', NULL, NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (49, '000000', 3, '并行-分开', '3', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2023-09-13 15:34:39', 'admin', '2023-10-20 10:05:07', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (50, '000000', 10, '失效', '10', 'flow_status', NULL, 'info', 'N', '0', 'admin', '2023-09-20 11:24:32', 'admin', '2023-09-20 11:25:51', '失效');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (51, '000000', 0, '串行-驳回互斥', '4', 'leave_type', NULL, 'default', 'N', '0', 'admin', '2023-10-20 10:11:57', '', NULL, '串行-驳回互斥');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621514432521, '662218', 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '性别男');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621514432522, '662218', 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '性别女');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621606707201, '662218', 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '性别未知');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621606707202, '662218', 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '显示菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621606707203, '662218', 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '隐藏菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621669621761, '662218', 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621669621762, '662218', 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621669621763, '662218', 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621669621764, '662218', 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621669621765, '662218', 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '默认分组');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621669621766, '662218', 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '系统分组');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621669621767, '662218', 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '系统默认是');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621669621768, '662218', 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '系统默认否');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621669621769, '662218', 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '通知');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621669621770, '662218', 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '公告');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621669621771, '662218', 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564801, '662218', 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '关闭状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564802, '662218', 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '其他操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564803, '662218', 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '新增操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564804, '662218', 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '修改操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564805, '662218', 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '删除操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564806, '662218', 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '授权操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564807, '662218', 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '导出操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564808, '662218', 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '导入操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564809, '662218', 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '强退操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564810, '662218', 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '生成操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564811, '662218', 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '清空操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564812, '662218', 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564813, '662218', 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564814, '662218', 0, '串行-简单', '0', 'leave_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564815, '662218', 1, '串行-通过互斥', '1', 'leave_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564816, '662218', 0, '待审批', '0', 'leave_status', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564817, '662218', 1, '审批中', '1', 'leave_status', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564818, '662218', 2, '审批结束', '2', 'leave_status', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621711564819, '662218', 0, '未发布', '0', 'is_publish', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '未发布');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479361, '662218', 1, '已发布', '1', 'is_publish', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '已发布');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479362, '662218', 9, '已失效', '9', 'is_publish', '9', 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '失效');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479363, '662218', 0, '开始节点', '0', 'node_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '开始节点');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479364, '662218', 1, '中间节点', '1', 'node_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '中间节点');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479365, '662218', 2, '结束节点', '2', 'node_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '结束节点');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479366, '662218', 0, '待提交', '0', 'flow_status', NULL, 'info', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '待提交');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479367, '662218', 1, '审批中', '1', 'flow_status', NULL, 'primary', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '审批中');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479368, '662218', 8, '已完成', '8', 'flow_status', NULL, 'success', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '已完成');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479369, '662218', 9, '驳回', '9', 'flow_status', NULL, 'warning', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '驳回');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479370, '662218', 2, '审批通过', '2', 'flow_status', NULL, 'primary', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '审批通过');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479371, '662218', 2, '并行-汇聚', '2', 'leave_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479372, '662218', 3, '互斥网关', '3', 'node_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479373, '662218', 4, '并行网关', '4', 'node_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479374, '662218', 3, '并行-分开', '3', 'leave_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621774479375, '662218', 10, '失效', '10', 'flow_status', NULL, 'info', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '失效');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621837393921, '662218', 0, '串行-驳回互斥', '4', 'leave_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '串行-驳回互斥');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788097, '460253', 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '性别男');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788098, '460253', 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '性别女');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788099, '460253', 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '性别未知');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788100, '460253', 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '显示菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788101, '460253', 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '隐藏菜单');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788102, '460253', 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788103, '460253', 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788104, '460253', 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788105, '460253', 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788106, '460253', 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '默认分组');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788107, '460253', 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '系统分组');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788108, '460253', 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '系统默认是');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788109, '460253', 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '系统默认否');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788110, '460253', 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '通知');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788111, '460253', 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '公告');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788112, '460253', 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395574788113, '460253', 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '关闭状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702657, '460253', 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '其他操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702658, '460253', 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '新增操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702659, '460253', 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '修改操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702660, '460253', 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '删除操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702661, '460253', 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '授权操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702662, '460253', 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '导出操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702663, '460253', 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '导入操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702664, '460253', 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '强退操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702665, '460253', 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '生成操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702666, '460253', 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '清空操作');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702667, '460253', 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '正常状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702668, '460253', 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '停用状态');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702669, '460253', 0, '串行-简单', '0', 'leave_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702670, '460253', 1, '串行-通过互斥', '1', 'leave_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702671, '460253', 0, '待审批', '0', 'leave_status', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702672, '460253', 1, '审批中', '1', 'leave_status', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702673, '460253', 2, '审批结束', '2', 'leave_status', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702674, '460253', 0, '未发布', '0', 'is_publish', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '未发布');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702675, '460253', 1, '已发布', '1', 'is_publish', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '已发布');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702676, '460253', 9, '已失效', '9', 'is_publish', '9', 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '失效');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395637702677, '460253', 0, '开始节点', '0', 'node_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '开始节点');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811522, '460253', 1, '中间节点', '1', 'node_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '中间节点');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811523, '460253', 2, '结束节点', '2', 'node_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '结束节点');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811524, '460253', 0, '待提交', '0', 'flow_status', NULL, 'info', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '待提交');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811525, '460253', 1, '审批中', '1', 'flow_status', NULL, 'primary', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '审批中');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811526, '460253', 8, '已完成', '8', 'flow_status', NULL, 'success', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '已完成');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811527, '460253', 9, '驳回', '9', 'flow_status', NULL, 'warning', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '驳回');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811528, '460253', 2, '审批通过', '2', 'flow_status', NULL, 'primary', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '审批通过');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811529, '460253', 2, '并行-汇聚', '2', 'leave_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811530, '460253', 3, '互斥网关', '3', 'node_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811531, '460253', 4, '并行网关', '4', 'node_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811532, '460253', 3, '并行-分开', '3', 'leave_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', NULL);
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811533, '460253', 10, '失效', '10', 'flow_status', NULL, 'info', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '失效');
INSERT INTO `sys_dict_data` (`dict_code`, `tenant_id`, `dict_sort`, `dict_label`, `dict_value`, `dict_type`, `css_class`, `list_class`, `is_default`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395704811534, '460253', 0, '串行-驳回互斥', '4', 'leave_type', NULL, 'default', 'N', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '串行-驳回互斥');
COMMIT;

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type` (
                                 `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
                                 `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                                 `dict_name` varchar(100) DEFAULT '' COMMENT '字典名称',
                                 `dict_type` varchar(100) DEFAULT '' COMMENT '字典类型',
                                 `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
                                 `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                                 `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                 `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                                 `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                                 `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                                 PRIMARY KEY (`dict_id`) USING BTREE,
                                 UNIQUE KEY ```tenant_id``, ``dict_type``` (`tenant_id`,`dict_type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1719040395511873548 ROW_FORMAT=DYNAMIC COMMENT='字典类型表';

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
BEGIN;
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '000000', '用户性别', 'sys_user_sex', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, '000000', '菜单状态', 'sys_show_hide', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3, '000000', '系统开关', 'sys_normal_disable', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4, '000000', '任务状态', 'sys_job_status', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5, '000000', '任务分组', 'sys_job_group', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (6, '000000', '系统是否', 'sys_yes_no', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (7, '000000', '通知类型', 'sys_notice_type', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (8, '000000', '通知状态', 'sys_notice_status', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (9, '000000', '操作类型', 'sys_oper_type', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (10, '000000', '系统状态', 'sys_common_status', '0', 'admin', '2023-03-16 13:18:54', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (11, '000000', '请假类型', 'leave_type', '0', 'admin', '2023-04-01 23:32:00', 'admin', '2023-04-11 11:07:24', '请假类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (12, '000000', '请假状态', 'leave_status', '0', 'admin', '2023-04-01 23:35:00', 'admin', '2023-04-11 11:07:18', '请假状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (13, '000000', '是否发布', 'is_publish', '0', 'admin', '2023-04-11 11:08:03', 'admin', '2023-04-14 18:23:14', '是否开启流程列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (14, '000000', '节点类型', 'node_type', '0', 'admin', '2023-04-12 12:46:44', 'admin', '2023-10-27 16:50:27', '结点类型');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (15, '000000', '流程状态', 'flow_status', '0', 'admin', '2023-05-07 00:47:03', 'admin', '2023-10-27 16:50:23', '流程状态');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621459906562, '662218', '用户性别', 'sys_user_sex', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '用户性别列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621459906563, '662218', '菜单状态', 'sys_show_hide', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '菜单状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621459906564, '662218', '系统开关', 'sys_normal_disable', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '系统开关列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621459906565, '662218', '任务状态', 'sys_job_status', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '任务状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621459906566, '662218', '任务分组', 'sys_job_group', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '任务分组列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621459906567, '662218', '系统是否', 'sys_yes_no', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '系统是否列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621459906568, '662218', '通知类型', 'sys_notice_type', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '通知类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621459906569, '662218', '通知状态', 'sys_notice_status', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '通知状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621514432514, '662218', '操作类型', 'sys_oper_type', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '操作类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621514432515, '662218', '系统状态', 'sys_common_status', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '登录状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621514432516, '662218', '请假类型', 'leave_type', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '请假类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621514432517, '662218', '请假状态', 'leave_status', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '请假状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621514432518, '662218', '是否发布', 'is_publish', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '是否开启流程列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621514432519, '662218', '节点类型', 'node_type', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '结点类型');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621514432520, '662218', '流程状态', 'flow_status', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', '流程状态');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395444764673, '460253', '流程状态', 'flow_status', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '流程状态');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395444764674, '460253', '是否发布', 'is_publish', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '是否开启流程列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395444764675, '460253', '请假状态', 'leave_status', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '请假状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395444764676, '460253', '请假类型', 'leave_type', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '请假类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395444764677, '460253', '节点类型', 'node_type', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '结点类型');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395511873538, '460253', '系统状态', 'sys_common_status', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '登录状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395511873539, '460253', '任务分组', 'sys_job_group', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '任务分组列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395511873540, '460253', '任务状态', 'sys_job_status', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '任务状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395511873541, '460253', '系统开关', 'sys_normal_disable', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '系统开关列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395511873542, '460253', '通知状态', 'sys_notice_status', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '通知状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395511873543, '460253', '通知类型', 'sys_notice_type', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '通知类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395511873544, '460253', '操作类型', 'sys_oper_type', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '操作类型列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395511873545, '460253', '菜单状态', 'sys_show_hide', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '菜单状态列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395511873546, '460253', '用户性别', 'sys_user_sex', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '用户性别列表');
INSERT INTO `sys_dict_type` (`dict_id`, `tenant_id`, `dict_name`, `dict_type`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395511873547, '460253', '系统是否', 'sys_yes_no', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', '系统是否列表');
COMMIT;

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job` (
                           `job_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务ID',
                           `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                           `job_name` varchar(64) NOT NULL DEFAULT '' COMMENT '任务名称',
                           `job_group` varchar(64) NOT NULL DEFAULT 'DEFAULT' COMMENT '任务组名',
                           `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
                           `cron_expression` varchar(255) DEFAULT '' COMMENT 'cron执行表达式',
                           `misfire_policy` varchar(20) DEFAULT '3' COMMENT '计划执行错误策略（1立即执行 2执行一次 3放弃执行）',
                           `concurrent` char(1) DEFAULT '1' COMMENT '是否并发执行（0允许 1禁止）',
                           `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1暂停）',
                           `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                           `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                           `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                           `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                           `remark` varchar(500) DEFAULT '' COMMENT '备注信息',
                           PRIMARY KEY (`job_id`,`job_name`,`job_group`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=4 ROW_FORMAT=DYNAMIC COMMENT='定时任务调度表';

-- ----------------------------
-- Records of sys_job
-- ----------------------------
BEGIN;
INSERT INTO `sys_job` (`job_id`, `tenant_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '000000', '系统默认（无参）', 'DEFAULT', 'ginyonTask.ryNoParams', '0/1 * * * * ?', '1', '1', '1', 'admin', '2023-03-16 13:18:55', 'admin', '2023-10-30 17:15:39', '');
INSERT INTO `sys_job` (`job_id`, `tenant_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, '000000', '系统默认（有参）', 'DEFAULT', 'ginyonTask.ryParams(\'hh\')', '0/15 * * * * ?', '3', '1', '1', 'admin', '2023-03-16 13:18:55', '', NULL, '');
INSERT INTO `sys_job` (`job_id`, `tenant_id`, `job_name`, `job_group`, `invoke_target`, `cron_expression`, `misfire_policy`, `concurrent`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3, '000000', '系统默认（多参）', 'DEFAULT', 'ginyonTask.ryMultipleParams(\'hh\', true, 2000L, 316.50D, 100)', '0/20 * * * * ?', '3', '1', '1', 'admin', '2023-03-16 13:18:55', '', NULL, '');
COMMIT;

-- ----------------------------
-- Table structure for sys_job_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_job_log`;
CREATE TABLE `sys_job_log` (
                               `job_log_id` bigint NOT NULL AUTO_INCREMENT COMMENT '任务日志ID',
                               `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                               `job_name` varchar(64) NOT NULL COMMENT '任务名称',
                               `job_group` varchar(64) NOT NULL COMMENT '任务组名',
                               `invoke_target` varchar(500) NOT NULL COMMENT '调用目标字符串',
                               `job_message` varchar(500) DEFAULT NULL COMMENT '日志信息',
                               `status` char(1) DEFAULT '0' COMMENT '执行状态（0正常 1失败）',
                               `exception_info` varchar(2000) DEFAULT '' COMMENT '异常信息',
                               `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                               `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                               `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                               `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                               PRIMARY KEY (`job_log_id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='定时任务调度日志表';

-- ----------------------------
-- Records of sys_job_log
-- ----------------------------
BEGIN;
COMMIT;

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor` (
                                  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
                                  `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                                  `user_name` varchar(50) DEFAULT '' COMMENT '用户账号',
                                  `ipaddr` varchar(128) DEFAULT '' COMMENT '登录IP地址',
                                  `login_location` varchar(255) DEFAULT '' COMMENT '登录地点',
                                  `browser` varchar(50) DEFAULT '' COMMENT '浏览器类型',
                                  `os` varchar(50) DEFAULT '' COMMENT '操作系统',
                                  `status` char(1) DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
                                  `msg` varchar(255) DEFAULT '' COMMENT '提示消息',
                                  `login_time` datetime DEFAULT NULL COMMENT '访问时间',
                                  PRIMARY KEY (`info_id`) USING BTREE,
                                  KEY `idx_sys_logininfor_s` (`status`) USING BTREE,
                                  KEY `idx_sys_logininfor_lt` (`login_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=439 ROW_FORMAT=DYNAMIC COMMENT='系统访问记录';

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu` (
                            `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
                            `menu_name` varchar(50) NOT NULL COMMENT '菜单名称',
                            `parent_id` bigint DEFAULT '0' COMMENT '父菜单ID',
                            `order_num` int DEFAULT '0' COMMENT '显示顺序',
                            `path` varchar(200) DEFAULT '' COMMENT '路由地址',
                            `component` varchar(255) DEFAULT NULL COMMENT '组件路径',
                            `query` varchar(255) DEFAULT NULL COMMENT '路由参数',
                            `is_frame` int DEFAULT '1' COMMENT '是否为外链（0是 1否）',
                            `is_cache` int DEFAULT '0' COMMENT '是否缓存（0缓存 1不缓存）',
                            `menu_type` char(1) DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
                            `visible` char(1) DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
                            `status` char(1) DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
                            `perms` varchar(100) DEFAULT NULL COMMENT '权限标识',
                            `icon` varchar(100) DEFAULT '#' COMMENT '菜单图标',
                            `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                            `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            `remark` varchar(500) DEFAULT '' COMMENT '备注',
                            PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1141 ROW_FORMAT=DYNAMIC COMMENT='菜单权限表';

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '系统管理', 0, 10, 'system', NULL, '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2023-03-16 13:18:52', 'admin', '2023-10-26 17:21:07', '系统管理目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, '系统监控', 0, 30, 'monitor', NULL, '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2023-03-16 13:18:52', 'admin', '2023-10-26 17:21:20', '系统监控目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3, '系统工具', 0, 40, 'tool', NULL, '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2023-03-16 13:18:52', 'admin', '2023-10-26 17:21:26', '系统工具目录');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2023-03-16 13:18:52', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2023-03-16 13:18:52', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2023-03-16 13:18:52', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2023-03-16 13:18:52', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2023-03-16 13:18:52', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2023-03-16 13:18:52', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2023-03-16 13:18:53', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2023-03-16 13:18:53', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (108, '日志管理', 1, 9, 'log', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2023-03-16 13:18:53', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2023-03-16 13:18:53', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (110, '定时任务', 2, 2, 'job', 'monitor/job/index', '', 1, 0, 'C', '0', '0', 'monitor:job:list', 'job', 'admin', '2023-03-16 13:18:53', '', NULL, '定时任务菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2023-03-16 13:18:53', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2023-03-16 13:18:53', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2023-03-16 13:18:53', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2023-03-16 13:18:53', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2023-03-16 13:18:53', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2023-03-16 13:18:53', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2023-03-16 13:18:53', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2023-03-16 13:18:53', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2023-03-16 13:18:53', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1000, '用户查询', 100, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1001, '用户新增', 100, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1002, '用户修改', 100, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1003, '用户删除', 100, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1004, '用户导出', 100, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1005, '用户导入', 100, 6, '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1006, '重置密码', 100, 7, '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1007, '角色查询', 101, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1008, '角色新增', 101, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1009, '角色修改', 101, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1010, '角色删除', 101, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1011, '角色导出', 101, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1012, '菜单查询', 102, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1013, '菜单新增', 102, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1014, '菜单修改', 102, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1015, '菜单删除', 102, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1016, '部门查询', 103, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1017, '部门新增', 103, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1018, '部门修改', 103, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1019, '部门删除', 103, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1020, '岗位查询', 104, 1, '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1021, '岗位新增', 104, 2, '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1022, '岗位修改', 104, 3, '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1023, '岗位删除', 104, 4, '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1024, '岗位导出', 104, 5, '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1025, '字典查询', 105, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1026, '字典新增', 105, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1027, '字典修改', 105, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1028, '字典删除', 105, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1029, '字典导出', 105, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1030, '参数查询', 106, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1031, '参数新增', 106, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1032, '参数修改', 106, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1033, '参数删除', 106, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1034, '参数导出', 106, 5, '#', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1035, '公告查询', 107, 1, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1036, '公告新增', 107, 2, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1037, '公告修改', 107, 3, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1038, '公告删除', 107, 4, '#', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1039, '操作查询', 500, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1040, '操作删除', 500, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1041, '日志导出', 500, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1042, '登录查询', 501, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1043, '登录删除', 501, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1044, '日志导出', 501, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1045, '账户解锁', 501, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1046, '在线查询', 109, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1047, '批量强退', 109, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1048, '单条强退', 109, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1049, '任务查询', 110, 1, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1050, '任务新增', 110, 2, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1051, '任务修改', 110, 3, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1052, '任务删除', 110, 4, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1053, '状态修改', 110, 5, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:changeStatus', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1054, '任务导出', 110, 6, '#', '', '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1055, '生成查询', 116, 1, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1056, '生成修改', 116, 2, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1057, '生成删除', 116, 3, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1058, '导入代码', 116, 4, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1059, '预览代码', 116, 5, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1060, '生成代码', 116, 6, '#', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2023-03-16 13:18:53', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1061, '测试菜单', 0, 60, 'test', NULL, NULL, 1, 0, 'M', '0', '0', '', 'example', 'admin', '2023-03-17 18:15:12', 'admin', '2023-10-26 17:21:45', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1074, '测试树', 1061, 1, 'tree', 'test/tree/index', NULL, 1, 0, 'C', '0', '0', 'test:tree:list', '#', 'admin', '2023-03-25 00:21:02', '', NULL, '测试树菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1075, '测试树查询', 1074, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:tree:query', '#', 'admin', '2023-03-25 00:21:02', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1076, '测试树新增', 1074, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:tree:add', '#', 'admin', '2023-03-25 00:21:02', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1077, '测试树修改', 1074, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:tree:edit', '#', 'admin', '2023-03-25 00:21:02', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1078, '测试树删除', 1074, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:tree:remove', '#', 'admin', '2023-03-25 00:21:02', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1079, '测试树导出', 1074, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:tree:export', '#', 'admin', '2023-03-25 00:21:02', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1080, '常规演示', 1061, 1, 'common', 'test/common/index', NULL, 1, 0, 'C', '0', '0', 'test:common:list', '#', 'admin', '2023-03-25 00:21:02', '', NULL, '常规演示菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1081, '常规演示查询', 1080, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:common:query', '#', 'admin', '2023-03-25 00:21:02', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1082, '常规演示新增', 1080, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:common:add', '#', 'admin', '2023-03-25 00:21:02', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1083, '常规演示修改', 1080, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:common:edit', '#', 'admin', '2023-03-25 00:21:02', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1084, '常规演示删除', 1080, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:common:remove', '#', 'admin', '2023-03-25 00:21:02', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1085, '常规演示导出', 1080, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:common:export', '#', 'admin', '2023-03-25 00:21:02', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1092, 'OA 请假申请', 1061, 1, 'leave', 'test/leave/index', NULL, 1, 0, 'C', '0', '0', 'test:leave:list', '#', 'admin', '2023-04-02 18:14:21', '', NULL, 'OA 请假申请菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1093, 'OA 请假申请查询', 1092, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:leave:query', '#', 'admin', '2023-04-02 18:14:21', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1094, 'OA 请假申请新增', 1092, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:leave:add', '#', 'admin', '2023-04-02 18:14:21', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1095, 'OA 请假申请详情', 1092, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:leave:detail', '#', 'admin', '2023-04-02 18:14:21', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1096, 'OA 请假申请修改', 1092, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:leave:edit', '#', 'admin', '2023-04-02 18:14:21', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1097, 'OA 请假申请删除', 1092, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:leave:remove', '#', 'admin', '2023-04-02 18:14:21', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1098, 'OA 请假申请导出', 1092, 6, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:leave:export', '#', 'admin', '2023-04-02 18:14:21', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1099, '主子演示', 1061, 1, 'mater', 'test/mater/index', NULL, 1, 0, 'C', '0', '0', 'test:mater:list', '#', 'admin', '2023-04-07 12:59:45', '', NULL, '主子演示菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1100, '主子演示查询', 1099, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:mater:query', '#', 'admin', '2023-04-07 12:59:45', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1101, '主子演示新增', 1099, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:mater:add', '#', 'admin', '2023-04-07 12:59:45', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1102, '主子演示详情', 1099, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:mater:detail', '#', 'admin', '2023-04-07 12:59:45', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1103, '主子演示修改', 1099, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:mater:edit', '#', 'admin', '2023-04-07 12:59:45', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1104, '主子演示删除', 1099, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:mater:remove', '#', 'admin', '2023-04-07 12:59:45', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1105, '主子演示导出', 1099, 6, '#', '', NULL, 1, 0, 'F', '0', '0', 'test:mater:export', '#', 'admin', '2023-04-07 12:59:45', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1106, '流程管理', 0, 50, 'flow', NULL, NULL, 1, 0, 'M', '0', '0', '', 'cascader', 'admin', '2023-04-11 11:02:28', 'admin', '2023-10-26 17:21:32', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1107, '流程定义', 1106, 1, 'definition', 'flow/definition/index', NULL, 1, 0, 'C', '0', '0', 'flow:definition:list', 'online', 'admin', '2023-04-11 13:06:38', 'admin', '2023-04-13 13:00:05', '流程定义菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1108, '流程定义查询', 1107, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'flow:definition:query', '#', 'admin', '2023-04-11 13:06:38', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1109, '流程定义新增', 1107, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'flow:definition:add', '#', 'admin', '2023-04-11 13:06:38', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1110, '流程设计', 1107, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'flow:definition:design', '#', 'admin', '2023-04-11 13:06:38', 'admin', '2023-04-14 12:01:20', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1111, '流程定义修改', 1107, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'flow:definition:edit', '#', 'admin', '2023-04-11 13:06:38', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1112, '流程定义删除', 1107, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'flow:definition:remove', '#', 'admin', '2023-04-11 13:06:38', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1113, '保存流程结点', 1107, 6, '', NULL, NULL, 1, 0, 'F', '0', '0', 'flow:definition:saveNode', '#', 'admin', '2023-04-13 01:09:22', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1114, '跳转规则配置', 1107, 7, '', NULL, NULL, 1, 0, 'F', '0', '0', 'flow:definition:skip', '#', 'admin', '2023-04-13 01:11:24', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1115, '查看流程设计', 1107, 8, '', NULL, NULL, 1, 0, 'F', '0', '0', 'flow:definition:queryDesign', '#', 'admin', '2023-04-14 12:02:37', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1116, '发布', 1107, 9, '', NULL, NULL, 1, 0, 'F', '0', '0', 'flow:definition:publish', '#', 'admin', '2023-04-14 17:03:57', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1117, '取消发布', 1107, 10, '', NULL, NULL, 1, 0, 'F', '0', '0', 'flow:definition:unPublish', '#', 'admin', '2023-04-14 23:05:27', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1118, '待办任务', 1106, 2, 'todo', 'flow/task/todo/index', NULL, 1, 0, 'C', '0', '0', 'flow:execute:toDoPage', 'guide', 'admin', '2023-04-17 17:21:21', 'admin', '2023-06-11 00:33:39', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1119, '办理', 1118, 2, '', NULL, NULL, 1, 0, 'F', '0', '0', 'flow:execute:handle', '#', 'admin', '2023-04-22 16:03:38', 'admin', '2023-06-02 08:59:46', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1120, '提交审批', 1092, 7, '', NULL, NULL, 1, 0, 'F', '0', '0', 'test:leave:submit', '#', 'admin', '2023-04-24 12:34:40', 'admin', '2023-05-07 02:39:33', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1122, '已办任务', 1106, 3, '1', 'flow/task/done/index', NULL, 1, 0, 'C', '0', '0', 'flow:execute:donePage', 'druid', 'admin', '2023-05-06 13:01:37', 'admin', '2023-06-02 08:59:50', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1123, '已办任务历史记录', 1122, 1, '', NULL, NULL, 1, 0, 'F', '0', '0', 'flow:execute:doneList', '#', 'admin', '2023-06-02 13:12:11', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1124, '导入流程定义', 1107, 11, '', NULL, NULL, 1, 0, 'F', '0', '0', 'flow:definition:importDefinition', '#', 'admin', '2023-06-04 23:52:33', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1125, '租户管理', 0, 20, 'tenant', NULL, NULL, 1, 0, 'M', '0', '0', '', 'company', 'admin', '2023-10-26 15:49:05', 'admin', '2023-10-29 00:49:55', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1126, '租户套餐管理', 1125, 2, 'tenant/package', 'system/tenant/package/index', NULL, 1, 0, 'C', '0', '0', 'system:tenantPackage:list', 'money', 'admin', '2023-10-26 15:53:02', 'admin', '2023-10-29 00:52:05', '租户套餐菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1127, '租户套餐查询', 1126, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenantPackage:query', '#', 'admin', '2023-10-26 15:53:02', 'admin', '2023-10-26 17:00:32', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1128, '租户套餐新增', 1126, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenantPackage:add', '#', 'admin', '2023-10-26 15:53:02', 'admin', '2023-10-26 17:00:41', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1129, '租户套餐详情', 1126, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenantPackage:detail', '#', 'admin', '2023-10-26 15:53:02', 'admin', '2023-10-26 17:00:48', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1130, '租户套餐修改', 1126, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenantPackage:edit', '#', 'admin', '2023-10-26 15:53:02', 'admin', '2023-10-26 17:00:54', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1131, '租户套餐删除', 1126, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenantPackage:remove', '#', 'admin', '2023-10-26 15:53:02', 'admin', '2023-10-26 17:01:00', '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1132, '租户套餐导出', 1126, 6, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenantPackage:export', '#', 'admin', '2023-10-27 01:35:04', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1133, '租户管理', 1125, 1, 'tenant', 'system/tenant/index', NULL, 1, 0, 'C', '0', '0', 'system:tenant:list', 'list', 'admin', '2023-10-27 11:27:20', 'admin', '2023-10-29 00:50:48', '租户菜单');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1134, '租户查询', 1133, 1, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenant:query', '#', 'admin', '2023-10-27 11:27:20', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1135, '租户新增', 1133, 2, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenant:add', '#', 'admin', '2023-10-27 11:27:20', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1136, '租户详情', 1133, 3, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenant:detail', '#', 'admin', '2023-10-27 11:27:20', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1137, '租户修改', 1133, 4, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenant:edit', '#', 'admin', '2023-10-27 11:27:20', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1138, '租户删除', 1133, 5, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenant:remove', '#', 'admin', '2023-10-27 11:27:20', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1139, '租户导出', 1133, 6, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenant:export', '#', 'admin', '2023-10-27 11:27:20', '', NULL, '');
INSERT INTO `sys_menu` (`menu_id`, `menu_name`, `parent_id`, `order_num`, `path`, `component`, `query`, `is_frame`, `is_cache`, `menu_type`, `visible`, `status`, `perms`, `icon`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1140, '租户提交', 1133, 7, '#', '', NULL, 1, 0, 'F', '0', '0', 'system:tenant:submit', '#', 'admin', '2023-10-27 11:27:20', '', NULL, '');
COMMIT;

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice` (
                              `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
                              `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                              `notice_title` varchar(50) NOT NULL COMMENT '公告标题',
                              `notice_type` char(1) NOT NULL COMMENT '公告类型（1通知 2公告）',
                              `notice_content` longblob COMMENT '公告内容',
                              `status` char(1) DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
                              `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                              `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                              `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                              `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                              `remark` varchar(255) DEFAULT NULL COMMENT '备注',
                              PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 ROW_FORMAT=DYNAMIC COMMENT='通知公告表';

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
BEGIN;
INSERT INTO `sys_notice` (`notice_id`, `tenant_id`, `notice_title`, `notice_type`, `notice_content`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '000000', '温馨提醒：2018-07-01 新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2023-03-16 13:18:55', '', NULL, '管理员');
INSERT INTO `sys_notice` (`notice_id`, `tenant_id`, `notice_title`, `notice_type`, `notice_content`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, '000000', '维护通知：2018-07-01 系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2023-03-16 13:18:55', '', NULL, '管理员');
INSERT INTO `sys_notice` (`notice_id`, `tenant_id`, `notice_title`, `notice_type`, `notice_content`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3, '000000', '啊实打实', '1', 0x3C703EE998BFE696AFE9A1BF20203C2F703E, '0', 'admin', '2023-05-05 08:51:43', '', NULL, NULL);
INSERT INTO `sys_notice` (`notice_id`, `tenant_id`, `notice_title`, `notice_type`, `notice_content`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4, '000000', '<ewr', '1', NULL, '0', 'admin', '2023-08-28 16:25:53', 'admin', '2023-08-28 16:26:31', NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log` (
                                `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
                                `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                                `title` varchar(50) DEFAULT '' COMMENT '模块标题',
                                `business_type` int DEFAULT '0' COMMENT '业务类型（0其它 1新增 2修改 3删除）',
                                `method` varchar(100) DEFAULT '' COMMENT '方法名称',
                                `request_method` varchar(10) DEFAULT '' COMMENT '请求方式',
                                `operator_type` int DEFAULT '0' COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
                                `oper_name` varchar(50) DEFAULT '' COMMENT '操作人员',
                                `dept_name` varchar(50) DEFAULT '' COMMENT '部门名称',
                                `oper_url` varchar(255) DEFAULT '' COMMENT '请求URL',
                                `oper_ip` varchar(128) DEFAULT '' COMMENT '主机地址',
                                `oper_location` varchar(255) DEFAULT '' COMMENT '操作地点',
                                `oper_param` varchar(2000) DEFAULT '' COMMENT '请求参数',
                                `json_result` varchar(2000) DEFAULT '' COMMENT '返回参数',
                                `status` int DEFAULT '0' COMMENT '操作状态（0正常 1异常）',
                                `error_msg` varchar(2000) DEFAULT '' COMMENT '错误消息',
                                `oper_time` datetime DEFAULT NULL COMMENT '操作时间',
                                `cost_time` bigint DEFAULT '0' COMMENT '消耗时间',
                                PRIMARY KEY (`oper_id`) USING BTREE,
                                KEY `idx_sys_oper_log_bt` (`business_type`) USING BTREE,
                                KEY `idx_sys_oper_log_s` (`status`) USING BTREE,
                                KEY `idx_sys_oper_log_ot` (`oper_time`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1675 ROW_FORMAT=DYNAMIC COMMENT='操作日志记录';


-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post` (
                            `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
                            `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                            `post_code` varchar(64) NOT NULL COMMENT '岗位编码',
                            `post_name` varchar(50) NOT NULL COMMENT '岗位名称',
                            `post_sort` int NOT NULL COMMENT '显示顺序',
                            `status` char(1) NOT NULL COMMENT '状态（0正常 1停用）',
                            `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                            `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                            PRIMARY KEY (`post_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 ROW_FORMAT=DYNAMIC COMMENT='岗位信息表';

-- ----------------------------
-- Records of sys_post
-- ----------------------------
BEGIN;
INSERT INTO `sys_post` (`post_id`, `tenant_id`, `post_code`, `post_name`, `post_sort`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '000000', 'ceo', '董事长', 1, '0', 'admin', '2023-03-16 13:18:52', '', NULL, '');
INSERT INTO `sys_post` (`post_id`, `tenant_id`, `post_code`, `post_name`, `post_sort`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, '000000', 'se', '项目经理', 2, '0', 'admin', '2023-03-16 13:18:52', '', NULL, '');
INSERT INTO `sys_post` (`post_id`, `tenant_id`, `post_code`, `post_name`, `post_sort`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3, '000000', 'hr', '人力资源', 3, '0', 'admin', '2023-03-16 13:18:52', '', NULL, '');
INSERT INTO `sys_post` (`post_id`, `tenant_id`, `post_code`, `post_name`, `post_sort`, `status`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4, '000000', 'user', '普通员工', 4, '0', 'admin', '2023-03-16 13:18:52', '', NULL, '');
COMMIT;

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role` (
                            `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
                            `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                            `role_name` varchar(30) NOT NULL COMMENT '角色名称',
                            `role_key` varchar(100) NOT NULL COMMENT '角色权限字符串',
                            `role_sort` int NOT NULL COMMENT '显示顺序',
                            `data_scope` char(1) DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
                            `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示',
                            `dept_check_strictly` tinyint(1) DEFAULT '1' COMMENT '部门树选择项是否关联显示',
                            `status` char(1) NOT NULL COMMENT '角色状态（0正常 1停用）',
                            `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                            `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                            `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                            PRIMARY KEY (`role_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1719040394459103234 ROW_FORMAT=DYNAMIC COMMENT='角色信息表';

-- ----------------------------
-- Records of sys_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_role` (`role_id`, `tenant_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '000000', '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2023-03-16 13:18:52', '', NULL, '超级管理员');
INSERT INTO `sys_role` (`role_id`, `tenant_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, '000000', '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2023-03-16 13:18:52', 'admin', '2023-04-02 18:14:45', '普通角色');
INSERT INTO `sys_role` (`role_id`, `tenant_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (3, '000000', '领导', 'leader', 3, '1', 1, 1, '0', '0', 'admin', '2023-05-27 16:43:20', 'admin', '2023-10-26 23:47:32', NULL);
INSERT INTO `sys_role` (`role_id`, `tenant_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4, '000000', '员工', 'staff', 0, '1', 1, 1, '0', '0', 'admin', '2023-05-27 16:44:05', 'admin', '2023-11-24 16:06:07', NULL);
INSERT INTO `sys_role` (`role_id`, `tenant_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031620210003970, '662218', '租户管理员', 'tenantAdmin', 1, '1', 0, 0, '0', '0', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 00:40:51', NULL);
INSERT INTO `sys_role` (`role_id`, `tenant_id`, `role_name`, `role_key`, `role_sort`, `data_scope`, `menu_check_strictly`, `dept_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040394459103233, '460253', '租户管理员', 'tenantAdmin', 1, '1', 0, 0, '0', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43', NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept` (
                                 `role_id` bigint NOT NULL COMMENT '角色ID',
                                 `dept_id` bigint NOT NULL COMMENT '部门ID',
                                 PRIMARY KEY (`role_id`,`dept_id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='角色和部门关联表';

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_dept` (`role_id`, `dept_id`) VALUES (2, 100);
INSERT INTO `sys_role_dept` (`role_id`, `dept_id`) VALUES (2, 101);
INSERT INTO `sys_role_dept` (`role_id`, `dept_id`) VALUES (2, 105);
INSERT INTO `sys_role_dept` (`role_id`, `dept_id`) VALUES (1719031620210003970, 1719031620470050818);
INSERT INTO `sys_role_dept` (`role_id`, `dept_id`) VALUES (1719040394459103233, 1719040394589126657);
COMMIT;

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu` (
                                 `role_id` bigint NOT NULL COMMENT '角色ID',
                                 `menu_id` bigint NOT NULL COMMENT '菜单ID',
                                 PRIMARY KEY (`role_id`,`menu_id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='角色和菜单关联表';

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
BEGIN;
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1061);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1074);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1075);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1076);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1077);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1078);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1079);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1080);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1081);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1082);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1083);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1084);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1085);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1092);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1093);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1094);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1095);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1096);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1097);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (2, 1098);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1061);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1092);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1093);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1094);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1095);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1096);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1097);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1098);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1106);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1107);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1108);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1109);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1110);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1111);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1112);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1113);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1114);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1115);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1116);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1117);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1118);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1119);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1120);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1122);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (3, 1123);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 100);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 101);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 102);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 103);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 104);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 105);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 106);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 107);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 108);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 500);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 501);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1000);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1001);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1002);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1003);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1004);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1005);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1006);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1007);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1008);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1009);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1010);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1011);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1012);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1013);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1014);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1015);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1016);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1017);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1018);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1019);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1020);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1021);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1022);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1023);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1024);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1025);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1026);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1027);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1028);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1029);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1030);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1031);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1032);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1033);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1034);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1035);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1036);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1037);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1038);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1039);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1040);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1041);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1042);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1043);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1044);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1045);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1061);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1092);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1093);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1094);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1095);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1096);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1097);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1098);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1106);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1107);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1108);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1109);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1110);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1111);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1112);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1113);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1114);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1115);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1116);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1117);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1118);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1119);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1120);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1122);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1123);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (4, 1124);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1061);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1074);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1075);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1076);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1077);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1078);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1079);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1080);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1081);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1082);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1083);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1084);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1085);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1092);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1093);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1094);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1095);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1096);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1097);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1098);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1099);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1100);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1101);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1102);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1103);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1104);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1105);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1106);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1107);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1108);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1109);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1110);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1111);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1112);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1113);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1114);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1115);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1116);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1117);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1118);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1119);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1120);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1122);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1123);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719031620210003970, 1124);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719040394459103233, 3);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719040394459103233, 115);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719040394459103233, 116);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719040394459103233, 117);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719040394459103233, 1055);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719040394459103233, 1056);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719040394459103233, 1057);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719040394459103233, 1058);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719040394459103233, 1059);
INSERT INTO `sys_role_menu` (`role_id`, `menu_id`) VALUES (1719040394459103233, 1060);
COMMIT;

-- ----------------------------
-- Table structure for sys_tenant
-- ----------------------------
DROP TABLE IF EXISTS `sys_tenant`;
CREATE TABLE `sys_tenant` (
                              `id` bigint NOT NULL COMMENT 'id',
                              `tenant_id` varchar(20) NOT NULL COMMENT '租户编号',
                              `contact_user_name` varchar(20) DEFAULT NULL COMMENT '联系人',
                              `contact_phone` varchar(20) DEFAULT NULL COMMENT '联系电话',
                              `company_name` varchar(50) DEFAULT NULL COMMENT '企业名称',
                              `license_number` varchar(30) DEFAULT NULL COMMENT '统一社会信用代码',
                              `address` varchar(200) DEFAULT NULL COMMENT '地址',
                              `intro` varchar(200) DEFAULT NULL COMMENT '企业简介',
                              `domain` varchar(200) DEFAULT NULL COMMENT '域名',
                              `remark` varchar(200) DEFAULT NULL COMMENT '备注',
                              `package_id` bigint DEFAULT NULL COMMENT '租户套餐编号',
                              `expire_time` datetime DEFAULT NULL COMMENT '过期时间',
                              `account_count` int DEFAULT '-1' COMMENT '用户数量（-1不限制）',
                              `status` char(1) DEFAULT '0' COMMENT '租户状态（0正常 1停用）',
                              `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                              `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
                              `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                              `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
                              `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                              PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='租户表';

-- ----------------------------
-- Records of sys_tenant
-- ----------------------------
BEGIN;
INSERT INTO `sys_tenant` (`id`, `tenant_id`, `contact_user_name`, `contact_phone`, `company_name`, `license_number`, `address`, `intro`, `domain`, `remark`, `package_id`, `expire_time`, `account_count`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1, '000000', '管理组', '15888888888', 'XXX有限公司', '1213', NULL, '多租户通用后台管理管理系统', NULL, NULL, NULL, NULL, 2, '0', '0', '1', '2023-10-28 10:43:44', 'admin', '2023-10-28 00:50:23');
INSERT INTO `sys_tenant` (`id`, `tenant_id`, `contact_user_name`, `contact_phone`, `company_name`, `license_number`, `address`, `intro`, `domain`, `remark`, `package_id`, `expire_time`, `account_count`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1719031620079980545, '662218', '测试企业负责人', '17688968436', '测试企业', NULL, NULL, NULL, '', NULL, 1717594985660497922, NULL, 0, '0', '0', NULL, '2023-10-31 00:40:51', 'admin', '2023-10-31 01:48:05');
INSERT INTO `sys_tenant` (`id`, `tenant_id`, `contact_user_name`, `contact_phone`, `company_name`, `license_number`, `address`, `intro`, `domain`, `remark`, `package_id`, `expire_time`, `account_count`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1719040394312302594, '460253', '工具企业负责人', '13617064737', '工具企业负', NULL, NULL, NULL, NULL, NULL, 1717467764031721474, NULL, 0, '0', '0', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 01:15:43');
COMMIT;

-- ----------------------------
-- Table structure for sys_tenant_package
-- ----------------------------
DROP TABLE IF EXISTS `sys_tenant_package`;
CREATE TABLE `sys_tenant_package` (
                                      `package_id` bigint NOT NULL COMMENT '租户套餐id',
                                      `package_name` varchar(20) DEFAULT NULL COMMENT '套餐名称',
                                      `menu_ids` varchar(3000) DEFAULT NULL COMMENT '关联菜单id',
                                      `remark` varchar(200) DEFAULT NULL COMMENT '备注',
                                      `menu_check_strictly` tinyint(1) DEFAULT '1' COMMENT '菜单树选择项是否关联显示（0父子不互相关联显示 1父子互相关联显示）',
                                      `status` char(1) DEFAULT '0' COMMENT '状态（0正常 1停用）',
                                      `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                                      `create_by` varchar(64) DEFAULT NULL COMMENT '创建者',
                                      `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                                      `update_by` varchar(64) DEFAULT NULL COMMENT '更新者',
                                      `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                                      PRIMARY KEY (`package_id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='租户套餐表';

-- ----------------------------
-- Records of sys_tenant_package
-- ----------------------------
BEGIN;
INSERT INTO `sys_tenant_package` (`package_id`, `package_name`, `menu_ids`, `remark`, `menu_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1717467764031721474, '系统工具租户', '3,115,116,1055,1056,1057,1058,1059,1060,117', NULL, 1, '0', '0', 'admin', '2023-10-26 17:06:39', 'admin', '2023-10-28 00:49:32');
INSERT INTO `sys_tenant_package` (`package_id`, `package_name`, `menu_ids`, `remark`, `menu_check_strictly`, `status`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1717594985660497922, '测试菜单租户', '1106,1107,1108,1109,1110,1111,1112,1113,1114,1115,1116,1117,1124,1118,1119,1122,1123,1061,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1092,1093,1094,1095,1096,1097,1098,1120,1099,1100,1101,1102,1103,1104,1105', NULL, 1, '0', '0', 'admin', '2023-10-27 01:32:11', 'admin', '2023-11-13 16:16:31');
COMMIT;

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
                            `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
                            `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                            `dept_id` bigint DEFAULT NULL COMMENT '部门ID',
                            `user_name` varchar(30) NOT NULL COMMENT '用户账号',
                            `nick_name` varchar(30) NOT NULL COMMENT '用户昵称',
                            `user_type` varchar(2) DEFAULT '00' COMMENT '用户类型（00系统用户）',
                            `email` varchar(50) DEFAULT '' COMMENT '用户邮箱',
                            `phonenumber` varchar(11) DEFAULT '' COMMENT '手机号码',
                            `sex` char(1) DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
                            `avatar` varchar(100) DEFAULT '' COMMENT '头像地址',
                            `password` varchar(100) DEFAULT '' COMMENT '密码',
                            `status` char(1) DEFAULT '0' COMMENT '帐号状态（0正常 1停用）',
                            `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                            `login_ip` varchar(128) DEFAULT '' COMMENT '最后登录IP',
                            `login_date` datetime DEFAULT NULL COMMENT '最后登录时间',
                            `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                            `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            `remark` varchar(500) DEFAULT NULL COMMENT '备注',
                            PRIMARY KEY (`user_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1719040395184717827 ROW_FORMAT=DYNAMIC COMMENT='用户信息表';

-- ----------------------------
-- Records of sys_user
-- ----------------------------
BEGIN;
INSERT INTO `sys_user` (`user_id`, `tenant_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1, '000000', 103, 'admin', '超级管理员', '00', 'ry@163.com', '15888888888', '1', '/profile/avatar/2023/10/19/blob_20231019174605A001.png', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2023-12-27 23:47:12', 'admin', '2023-03-16 13:18:52', '', '2023-12-27 23:47:11', '管理员');
INSERT INTO `sys_user` (`user_id`, `tenant_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (2, '000000', 105, 'staff', '普通角色', '00', 'ry@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2023-11-24 16:07:00', 'admin', '2023-03-16 13:18:52', 'admin', '2023-11-24 16:07:00', '测试员');
INSERT INTO `sys_user` (`user_id`, `tenant_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (4, '000000', 105, 'leaveStaff', '请假员工', '00', '', '', '0', '', '$2a$10$8tbCSBjTljk5vUbKvfibE.OSWufn72coFuZb74b.qQTeqDWMcO/KK', '0', '0', '127.0.0.1', '2023-09-03 23:54:05', 'admin', '2023-05-27 16:45:07', 'admin', '2023-10-27 13:16:56', NULL);
INSERT INTO `sys_user` (`user_id`, `tenant_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (5, '000000', 103, 'leader', '领导', '00', '', '', '0', '', '$2a$10$UEwQowgXD7amXAFiRklex.zqihZOaUdQpf.uO0BWPSoR1MuZI8/Zq', '0', '0', '127.0.0.1', '2023-10-26 23:47:48', 'admin', '2023-05-27 16:45:22', 'admin', '2023-10-29 00:24:44', NULL);
INSERT INTO `sys_user` (`user_id`, `tenant_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719031621183082497, '662218', 1719031620470050818, 'zhangsan', 'zhangsan', '00', '', '', '0', '', '$2a$10$fiLZnzJhz9nq.ZJzDB32V.Ck2/eBbJ8dhyEVl92vNZpAitr3rYOjG', '0', '0', '127.0.0.1', '2023-10-31 01:53:08', NULL, '2023-10-31 00:40:51', NULL, '2023-10-31 01:53:08', NULL);
INSERT INTO `sys_user` (`user_id`, `tenant_id`, `dept_id`, `user_name`, `nick_name`, `user_type`, `email`, `phonenumber`, `sex`, `avatar`, `password`, `status`, `del_flag`, `login_ip`, `login_date`, `create_by`, `create_time`, `update_by`, `update_time`, `remark`) VALUES (1719040395184717826, '460253', 1719040394589126657, 'lisi', 'lisi', '00', '', '', '0', '', '$2a$10$V9dG0mAY0kBJcEPmtlsFseMfE3miQYzRkw2p22g8aJ3WaqL3ODIAe', '0', '0', '127.0.0.1', '2023-10-31 10:59:14', NULL, '2023-10-31 01:15:43', NULL, '2023-10-31 10:59:14', NULL);
COMMIT;

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post` (
                                 `user_id` bigint NOT NULL COMMENT '用户ID',
                                 `post_id` bigint NOT NULL COMMENT '岗位ID',
                                 PRIMARY KEY (`user_id`,`post_id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='用户与岗位关联表';

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_post` (`user_id`, `post_id`) VALUES (2, 2);
COMMIT;

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role` (
                                 `user_id` bigint NOT NULL COMMENT '用户ID',
                                 `role_id` bigint NOT NULL COMMENT '角色ID',
                                 PRIMARY KEY (`user_id`,`role_id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='用户和角色关联表';

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
BEGIN;
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (1, 1);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (2, 2);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (4, 2);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (4, 4);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (1719031621183082497, 1719031620210003970);
INSERT INTO `sys_user_role` (`user_id`, `role_id`) VALUES (1719040395184717826, 1719040394459103233);
COMMIT;

-- ----------------------------
-- Table structure for test_common
-- ----------------------------
DROP TABLE IF EXISTS `test_common`;
CREATE TABLE `test_common` (
                               `id` bigint NOT NULL COMMENT '主键id',
                               `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                               `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                               `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                               `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                               `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                               `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                               `title` varchar(64) DEFAULT NULL COMMENT '标题',
                               `level` bigint DEFAULT NULL COMMENT '级别（取数据字典）',
                               `send_doc_no` varchar(64) DEFAULT NULL COMMENT '发文字号',
                               `send_doc_unit` varchar(64) DEFAULT NULL COMMENT '发文单位',
                               `publish_time` date DEFAULT NULL COMMENT '发布时间',
                               `deadline` datetime DEFAULT NULL COMMENT '截至日期',
                               `label` longtext COMMENT '标签',
                               `content` longtext COMMENT '文章内容',
                               `money` decimal(18,2) DEFAULT NULL COMMENT '金额',
                               `views` bigint DEFAULT NULL COMMENT '阅读次数',
                               `new_file_id` varchar(200) DEFAULT NULL COMMENT '附件',
                               `image_id` varchar(200) DEFAULT NULL COMMENT '图片',
                               PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='常规表演示';

-- ----------------------------
-- Records of test_common
-- ----------------------------
BEGIN;
INSERT INTO `test_common` (`id`, `tenant_id`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`, `title`, `level`, `send_doc_no`, `send_doc_unit`, `publish_time`, `deadline`, `label`, `content`, `money`, `views`, `new_file_id`, `image_id`) VALUES (1724441993633439745, '000000', 'admin', '2023-11-14 22:59:45', 'admin', '2023-11-14 23:00:17', '0', '11', 0, NULL, NULL, NULL, NULL, NULL, NULL, 0.00, 0, NULL, NULL);
COMMIT;

-- ----------------------------
-- Table structure for test_leave
-- ----------------------------
DROP TABLE IF EXISTS `test_leave`;
CREATE TABLE `test_leave` (
                              `id` bigint unsigned NOT NULL COMMENT '主键',
                              `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                              `type` tinyint NOT NULL COMMENT '请假类型',
                              `reason` varchar(500) NOT NULL COMMENT '请假原因',
                              `start_time` datetime NOT NULL COMMENT '开始时间',
                              `end_time` datetime NOT NULL COMMENT '结束时间',
                              `day` tinyint DEFAULT NULL COMMENT '请假天数',
                              `instance_id` bigint DEFAULT NULL COMMENT '流程实例的id',
                              `node_code` varchar(100) DEFAULT NULL COMMENT '节点编码',
                              `node_name` varchar(100) DEFAULT NULL COMMENT '流程节点名称',
                              `flow_status` tinyint(1) DEFAULT NULL COMMENT '流程状态（0待提交 1审批中 2 审批通过 8已完成 9已驳回 10失效）',
                              `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                              `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                              `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                              `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                              `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                              PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='OA 请假申请表';

-- ----------------------------
-- Records of test_leave
-- ----------------------------
BEGIN;
INSERT INTO `test_leave` (`id`, `tenant_id`, `type`, `reason`, `start_time`, `end_time`, `day`, `instance_id`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`) VALUES (1739547781112139776, '000000', 0, '1', '2023-12-26 15:24:40', '2023-12-26 15:24:42', 1, 1189227307726934016, '9edc9b26-cab4-4fd4-9a30-c89f11626911', 'hr审批', 8, 'admin', '2023-12-26 15:24:45', 'admin', '2023-12-26 15:34:41', '0');
INSERT INTO `test_leave` (`id`, `tenant_id`, `type`, `reason`, `start_time`, `end_time`, `day`, `instance_id`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`) VALUES (1739547876775825408, '000000', 4, '1', '2023-12-26 15:25:01', '2023-12-26 15:25:02', 4, 1189227403407396864, '80e10f4c-452c-4a79-b608-84e75831a437', '中间节点3', 8, 'admin', '2023-12-26 15:25:08', 'admin', '2023-12-26 15:40:00', '0');
INSERT INTO `test_leave` (`id`, `tenant_id`, `type`, `reason`, `start_time`, `end_time`, `day`, `instance_id`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`) VALUES (1739547937656147968, '000000', 1, '1', '2023-12-26 15:25:18', '2023-12-26 15:25:19', 4, 1189227464275136512, '6', '部门经理审批', 8, 'admin', '2023-12-26 15:25:22', 'admin', '2023-12-26 15:39:56', '0');
INSERT INTO `test_leave` (`id`, `tenant_id`, `type`, `reason`, `start_time`, `end_time`, `day`, `instance_id`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`) VALUES (1739548010154692608, '000000', 2, '1', '2023-12-26 15:25:35', '2023-12-26 15:25:37', 4, 1189227536773681152, '43563e5c-42fb-4f46-936d-70f8727943bf', '董事长审批', 8, 'admin', '2023-12-26 15:25:40', 'admin', '2023-12-26 15:33:41', '0');
INSERT INTO `test_leave` (`id`, `tenant_id`, `type`, `reason`, `start_time`, `end_time`, `day`, `instance_id`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`) VALUES (1739548053058228224, '000000', 3, '1', '2023-12-26 15:25:46', '2023-12-26 15:25:47', 4, 1189227579673022464, '6', '部门经理审批', 8, 'admin', '2023-12-26 15:25:50', 'admin', '2023-12-26 15:26:41', '0');
INSERT INTO `test_leave` (`id`, `tenant_id`, `type`, `reason`, `start_time`, `end_time`, `day`, `instance_id`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`) VALUES (1739552951107719168, '000000', 0, '4', '2023-12-26 15:45:13', '2023-12-26 15:45:14', 4, 1189232477701541888, '3', '组长审批', 1, 'admin', '2023-12-26 15:45:18', 'admin', '2023-12-26 15:46:04', '0');
INSERT INTO `test_leave` (`id`, `tenant_id`, `type`, `reason`, `start_time`, `end_time`, `day`, `instance_id`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`) VALUES (1739552987325534208, '000000', 4, '4', '2023-12-26 15:45:23', '2023-12-26 15:45:24', 4, 1189232513973882880, '0fbb9fbe-e4bd-4280-94f4-a8f939b760e2', '中间节点2', 1, 'admin', '2023-12-26 15:45:26', 'admin', '2023-12-26 15:46:03', '0');
INSERT INTO `test_leave` (`id`, `tenant_id`, `type`, `reason`, `start_time`, `end_time`, `day`, `instance_id`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`) VALUES (1739553020846411776, '000000', 1, '4', '2023-12-26 15:45:30', '2023-12-26 15:45:32', 4, 1189232547486371840, '4', '大组长审批', 1, 'admin', '2023-12-26 15:45:34', 'admin', '2023-12-26 15:52:44', '0');
INSERT INTO `test_leave` (`id`, `tenant_id`, `type`, `reason`, `start_time`, `end_time`, `day`, `instance_id`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`) VALUES (1739553058163134464, '000000', 2, '4', '2023-12-26 15:45:40', '2023-12-26 15:45:41', 4, 1189232584807288832, '5', '大组长审批', 1, 'admin', '2023-12-26 15:45:43', 'admin', '2023-12-26 23:40:30', '0');
INSERT INTO `test_leave` (`id`, `tenant_id`, `type`, `reason`, `start_time`, `end_time`, `day`, `instance_id`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`) VALUES (1739553097564426240, '000000', 3, '4', '2023-12-26 15:45:47', '2023-12-26 15:45:50', 4, 1189232624221163520, '5', '大组长审批', 1, 'admin', '2023-12-26 15:45:52', 'admin', '2023-12-27 02:20:15', '0');
INSERT INTO `test_leave` (`id`, `tenant_id`, `type`, `reason`, `start_time`, `end_time`, `day`, `instance_id`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`) VALUES (1739848455930646528, '000000', 1, '1', '2023-12-27 11:19:25', '2023-12-27 11:19:27', 4, 1189527982549635072, '4', '大组长审批', 1, 'admin', '2023-12-27 11:19:31', 'admin', '2023-12-27 11:26:00', '0');
INSERT INTO `test_leave` (`id`, `tenant_id`, `type`, `reason`, `start_time`, `end_time`, `day`, `instance_id`, `node_code`, `node_name`, `flow_status`, `create_by`, `create_time`, `update_by`, `update_time`, `del_flag`) VALUES (1739850179168833536, '000000', 1, '1', '2023-12-27 11:26:16', '2023-12-27 11:26:18', 5, 1189529705775239168, '7', '董事长审批', 1, 'admin', '2023-12-27 11:26:22', 'admin', '2023-12-27 11:26:36', '0');
COMMIT;

-- ----------------------------
-- Table structure for test_mater
-- ----------------------------
DROP TABLE IF EXISTS `test_mater`;
CREATE TABLE `test_mater` (
                              `id` bigint NOT NULL AUTO_INCREMENT COMMENT '事务所id',
                              `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                              `law_firm_name` varchar(30) DEFAULT '' COMMENT '律师所名称',
                              `address` varchar(255) DEFAULT NULL COMMENT '地址',
                              `file_id` varchar(255) DEFAULT NULL COMMENT 'logo图片id',
                              `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                              `state` tinyint DEFAULT NULL COMMENT '状态',
                              `publish_time` datetime DEFAULT NULL COMMENT '发布时间',
                              `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                              `create_time` datetime DEFAULT NULL COMMENT '创建时间/提交时间',
                              `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                              `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                              PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1716723890996891650 ROW_FORMAT=DYNAMIC COMMENT='主子表演示';

-- ----------------------------
-- Records of test_mater
-- ----------------------------
BEGIN;
INSERT INTO `test_mater` (`id`, `tenant_id`, `law_firm_name`, `address`, `file_id`, `del_flag`, `state`, `publish_time`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1716723890996891649, '000000', '3213', NULL, '/profile/upload/2023/10/30/测试_20231030143923A001.jpg', '0', NULL, NULL, 'admin', '2023-10-24 15:50:45', 'admin', '2023-10-30 14:39:25');
COMMIT;

-- ----------------------------
-- Table structure for test_sub
-- ----------------------------
DROP TABLE IF EXISTS `test_sub`;
CREATE TABLE `test_sub` (
                            `id` bigint NOT NULL AUTO_INCREMENT COMMENT '律师id',
                            `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                            `legal_id` bigint NOT NULL COMMENT '事务所id',
                            `lawyer_name` varchar(30) DEFAULT NULL COMMENT '律师名称',
                            `phone` bigint DEFAULT NULL COMMENT '联系电话',
                            `brief_introduction` varchar(255) DEFAULT NULL COMMENT '简介',
                            `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                            `create_by` varchar(64) DEFAULT '' COMMENT '创建者',
                            `create_time` datetime DEFAULT NULL COMMENT '创建时间/提交时间',
                            `update_by` varchar(64) DEFAULT '' COMMENT '更新者',
                            `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                            PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1718880262618189826 ROW_FORMAT=DYNAMIC COMMENT='子表';

-- ----------------------------
-- Records of test_sub
-- ----------------------------
BEGIN;
INSERT INTO `test_sub` (`id`, `tenant_id`, `legal_id`, `lawyer_name`, `phone`, `brief_introduction`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1716723890996891650, '000000', 1716723890996891649, '3213', 17688968436, '1', '2', 'admin', '2023-10-24 15:50:45', 'admin', '2023-10-24 15:50:45');
INSERT INTO `test_sub` (`id`, `tenant_id`, `legal_id`, `lawyer_name`, `phone`, `brief_introduction`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1716724051571625986, '000000', 1716723890996891649, '3213', 17688968436, '4', '2', 'admin', '2023-10-24 15:50:45', 'admin', '2023-10-24 15:50:45');
INSERT INTO `test_sub` (`id`, `tenant_id`, `legal_id`, `lawyer_name`, `phone`, `brief_introduction`, `del_flag`, `create_by`, `create_time`, `update_by`, `update_time`) VALUES (1718880262618189825, '000000', 1716723890996891649, '3213', 17688968436, '4', '0', 'admin', '2023-10-24 15:50:45', 'admin', '2023-10-24 15:50:45');
COMMIT;

-- ----------------------------
-- Table structure for test_tree
-- ----------------------------
DROP TABLE IF EXISTS `test_tree`;
CREATE TABLE `test_tree` (
                             `id` bigint NOT NULL COMMENT '主键',
                             `tenant_id` varchar(20) DEFAULT '000000' COMMENT '租户编号',
                             `parent_id` bigint DEFAULT '0' COMMENT '父id',
                             `tree_name` varchar(255) DEFAULT NULL COMMENT '值',
                             `version` int DEFAULT '0' COMMENT '版本',
                             `create_time` datetime DEFAULT NULL COMMENT '创建时间',
                             `create_by` varchar(64) DEFAULT NULL COMMENT '创建人',
                             `update_time` datetime DEFAULT NULL COMMENT '更新时间',
                             `update_by` varchar(64) DEFAULT NULL COMMENT '更新人',
                             `del_flag` char(1) DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
                             PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB ROW_FORMAT=DYNAMIC COMMENT='测试树表';

-- ----------------------------
-- Records of test_tree
-- ----------------------------
BEGIN;
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `tree_name`, `version`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (1716488177943973888, '000000', 0, '4444', 324, '2023-10-24 00:14:07', 'admin', '2023-10-24 15:47:19', 'admin', '0');
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `tree_name`, `version`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (1716488197430710272, '000000', 1716488177943973888, '4324', 313, '2023-10-24 00:14:12', 'admin', '2023-10-24 00:17:51', 'admin', '2');
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `tree_name`, `version`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (1716721928788238338, '000000', 0, '321', 322, NULL, NULL, NULL, NULL, '2');
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `tree_name`, `version`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (1716722625936084993, '000000', 0, '3', 3, '2023-10-24 15:45:44', 'admin', '2023-10-24 15:45:44', 'admin', '0');
INSERT INTO `test_tree` (`id`, `tenant_id`, `parent_id`, `tree_name`, `version`, `create_time`, `create_by`, `update_time`, `update_by`, `del_flag`) VALUES (1726435957572091905, '000000', 1716722625936084993, '4', 444, '2023-11-20 11:03:03', 'admin', '2023-11-20 11:03:03', 'admin', '0');
COMMIT;

SET FOREIGN_KEY_CHECKS = 1;
