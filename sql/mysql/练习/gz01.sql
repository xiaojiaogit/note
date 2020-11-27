/*
 Navicat Premium Data Transfer

 Source Server         : h2
 Source Server Type    : MySQL
 Source Server Version : 50729
 Source Host           : h2:3306
 Source Schema         : gz01

 Target Server Type    : MySQL
 Target Server Version : 50729
 File Encoding         : 65001

 Date: 27/11/2020 10:03:24
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for dept
-- ----------------------------
DROP TABLE IF EXISTS `dept`;
CREATE TABLE `dept`  (
  `deptno` decimal(2, 0) NULL DEFAULT NULL,
  `dname` varchar(14) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `loc` varchar(13) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of dept
-- ----------------------------
INSERT INTO `dept` VALUES (10, 'accounting', 'new york');
INSERT INTO `dept` VALUES (20, 'research', 'dallas');
INSERT INTO `dept` VALUES (30, 'sales', 'chicago');
INSERT INTO `dept` VALUES (40, 'operations', 'boston');

-- ----------------------------
-- Table structure for dummy
-- ----------------------------
DROP TABLE IF EXISTS `dummy`;
CREATE TABLE `dummy`  (
  `dummy` decimal(10, 0) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of dummy
-- ----------------------------
INSERT INTO `dummy` VALUES (0);

-- ----------------------------
-- Table structure for employee
-- ----------------------------
DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee`  (
  `employeeno` decimal(4, 0) NOT NULL,
  `ename` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `job` varchar(9) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `mgr` decimal(4, 0) NULL DEFAULT NULL,
  `hiredate` date NULL DEFAULT NULL,
  `sal` decimal(7, 2) NULL DEFAULT NULL,
  `comm` decimal(7, 2) NULL DEFAULT NULL,
  `deptno` decimal(2, 0) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of employee
-- ----------------------------
INSERT INTO `employee` VALUES (7369, 'smith', 'clerk', 7902, '1980-12-17', 800.00, NULL, 20);
INSERT INTO `employee` VALUES (7499, 'allen', 'salesman', 7698, '1981-02-20', 1600.00, 300.00, 30);
INSERT INTO `employee` VALUES (7521, 'ward', 'salesman', 7698, '1981-02-22', 1250.00, 500.00, 30);
INSERT INTO `employee` VALUES (7566, 'jones', 'manager', 7839, '1981-04-02', 2975.00, NULL, 20);
INSERT INTO `employee` VALUES (7654, 'martin', 'salesman', 7698, '1981-09-28', 1250.00, 1400.00, 30);
INSERT INTO `employee` VALUES (7698, 'blake', 'manager', 7839, '1981-05-01', 2850.00, NULL, 30);
INSERT INTO `employee` VALUES (7782, 'clark', 'manager', 7839, '1981-07-09', 2450.00, NULL, 10);
INSERT INTO `employee` VALUES (7788, 'scott', 'analyst', 7566, '1982-12-09', 3000.00, NULL, 20);
INSERT INTO `employee` VALUES (7839, 'king', 'president', NULL, '1981-11-17', 5000.00, NULL, 10);
INSERT INTO `employee` VALUES (7844, 'turner', 'salesman', 7698, '1981-09-08', 1500.00, 0.00, 30);
INSERT INTO `employee` VALUES (7876, 'adams', 'clerk', 7788, '1983-01-12', 1100.00, NULL, 20);
INSERT INTO `employee` VALUES (7900, 'james', 'clerk', 7698, '1981-12-03', 950.00, NULL, 30);
INSERT INTO `employee` VALUES (7902, 'ford', 'analyst', 7566, '1981-12-03', 3000.00, NULL, 20);
INSERT INTO `employee` VALUES (7934, 'miller', 'clerk', 7782, '1982-01-23', 1300.00, NULL, 10);

-- ----------------------------
-- Table structure for salgrade
-- ----------------------------
DROP TABLE IF EXISTS `salgrade`;
CREATE TABLE `salgrade`  (
  `grade` decimal(10, 0) NULL DEFAULT NULL,
  `losal` decimal(10, 0) NULL DEFAULT NULL,
  `hisal` decimal(10, 0) NULL DEFAULT NULL
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of salgrade
-- ----------------------------
INSERT INTO `salgrade` VALUES (1, 700, 1200);
INSERT INTO `salgrade` VALUES (2, 1201, 1400);
INSERT INTO `salgrade` VALUES (3, 1401, 2000);
INSERT INTO `salgrade` VALUES (4, 2001, 3000);
INSERT INTO `salgrade` VALUES (5, 3001, 9999);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `account` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'aa', '111', 'abc');
INSERT INTO `sys_user` VALUES (2, 'ba', '123', 'bbb');
INSERT INTO `sys_user` VALUES (3, 'ca', '321', 'ccc');
INSERT INTO `sys_user` VALUES (4, 'da', '333', 'ddd');
INSERT INTO `sys_user` VALUES (5, 'ea', '213', 'dcs');

SET FOREIGN_KEY_CHECKS = 1;
