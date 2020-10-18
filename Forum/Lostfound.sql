/*
SQLyog Ultimate v8.32 
MySQL - 8.0.19 : Database - forum
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`forum` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `forum`;

/*Table structure for table `teacherassess` */

DROP TABLE IF EXISTS `teacherassess`;

CREATE TABLE `teacherassess` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `z01` int DEFAULT NULL,
  `z02` int DEFAULT NULL,
  `z03` int DEFAULT NULL,
  `z04` int DEFAULT NULL,
  `z05` int DEFAULT NULL,
  `z06` int DEFAULT NULL,
  `z07` int DEFAULT NULL,
  `z08` int DEFAULT NULL,
  `z09` int DEFAULT NULL,
  `z10` int DEFAULT NULL,
  `z11` int DEFAULT NULL,
  `z12` int DEFAULT NULL,
  `z13` int DEFAULT NULL,
  `z14` int DEFAULT NULL,
  `z15` int DEFAULT NULL,
  `z16` int DEFAULT NULL,
  `z17` int DEFAULT NULL,
  `z18` int DEFAULT NULL,
  `z19` int DEFAULT NULL,
  `z20` int DEFAULT NULL,
  `z21` int DEFAULT NULL,
  `z22` int DEFAULT NULL,
  `z23` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=41 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*Table structure for table `teachername` */

DROP TABLE IF EXISTS `teachername`;

CREATE TABLE `teachername` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tName` varchar(100) DEFAULT NULL,
  `college` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
