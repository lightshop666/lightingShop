-- --------------------------------------------------------
-- 호스트:                          127.0.0.1
-- 서버 버전:                        10.5.19-MariaDB - mariadb.org binary distribution
-- 서버 OS:                        Win64
-- HeidiSQL 버전:                  11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- shop 데이터베이스 구조 내보내기
CREATE DATABASE IF NOT EXISTS `shop` /*!40100 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci */;
USE `shop`;

-- 테이블 shop.address 구조 내보내기
CREATE TABLE IF NOT EXISTS `address` (
  `address_no` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(50) NOT NULL,
  `address_name` varchar(50) NOT NULL,
  `address` text NOT NULL,
  `address_last_date` datetime NOT NULL,
  `default_address` enum('Y','N') NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`address_no`),
  KEY `id` (`id`),
  CONSTRAINT `FK_address_id_list` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.address:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
/*!40000 ALTER TABLE `address` ENABLE KEYS */;

-- 테이블 shop.answer 구조 내보내기
CREATE TABLE IF NOT EXISTS `answer` (
  `a_no` int(11) NOT NULL AUTO_INCREMENT,
  `q_no` int(11) NOT NULL,
  `id` varchar(50) NOT NULL,
  `a_content` text NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`a_no`),
  KEY `FK_a_board_q_board` (`q_no`),
  KEY `FK_answer_employees` (`id`),
  CONSTRAINT `FK_a_board_q_board` FOREIGN KEY (`q_no`) REFERENCES `question` (`q_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_answer_employees` FOREIGN KEY (`id`) REFERENCES `employees` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.answer:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `answer` DISABLE KEYS */;
/*!40000 ALTER TABLE `answer` ENABLE KEYS */;

-- 테이블 shop.cart 구조 내보내기
CREATE TABLE IF NOT EXISTS `cart` (
  `cart_no` int(11) NOT NULL AUTO_INCREMENT,
  `product_no` int(11) NOT NULL,
  `id` varchar(50) NOT NULL,
  `cart_cnt` int(11) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`cart_no`),
  KEY `FK_cart_id` (`id`),
  KEY `product_no` (`product_no`),
  CONSTRAINT `FK_cart_id` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_cart_product` FOREIGN KEY (`product_no`) REFERENCES `product` (`product_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.cart:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;

-- 테이블 shop.category 구조 내보내기
CREATE TABLE IF NOT EXISTS `category` (
  `category_name` varchar(100) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.category:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
/*!40000 ALTER TABLE `category` ENABLE KEYS */;

-- 테이블 shop.customer 구조 내보내기
CREATE TABLE IF NOT EXISTS `customer` (
  `id` varchar(50) NOT NULL,
  `cstm_name` varchar(50) NOT NULL,
  `cstm_address` text NOT NULL,
  `cstm_email` varchar(50) NOT NULL,
  `cstm_birth` date NOT NULL,
  `cstm_phone` varchar(50) NOT NULL,
  `cstm_gender` varchar(50) NOT NULL,
  `cstm_rank` enum('금','은','동') NOT NULL,
  `cstm_point` int(11) NOT NULL,
  `cstm_last_login` datetime NOT NULL,
  `cstm_agree` enum('Y','N') NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `FK_customer_id` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.customer:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
/*!40000 ALTER TABLE `customer` ENABLE KEYS */;

-- 테이블 shop.discount 구조 내보내기
CREATE TABLE IF NOT EXISTS `discount` (
  `discount_no` int(11) NOT NULL AUTO_INCREMENT,
  `product_no` int(11) NOT NULL,
  `discount_start` datetime NOT NULL,
  `discount_end` datetime NOT NULL,
  `discount_rate` double NOT NULL,
  `createdate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  `updatedate` datetime NOT NULL DEFAULT '0000-00-00 00:00:00',
  PRIMARY KEY (`discount_no`),
  KEY `product_no` (`product_no`),
  CONSTRAINT `FK_discount_product` FOREIGN KEY (`product_no`) REFERENCES `product` (`product_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.discount:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `discount` DISABLE KEYS */;
/*!40000 ALTER TABLE `discount` ENABLE KEYS */;

-- 테이블 shop.employees 구조 내보내기
CREATE TABLE IF NOT EXISTS `employees` (
  `id` varchar(50) NOT NULL,
  `emp_name` varchar(50) NOT NULL,
  `emp_level` enum('1','3','5') NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  CONSTRAINT `FK_employees_id` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='level :숫자가 높을 수록 권한이 높게';

-- 테이블 데이터 shop.employees:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;

-- 테이블 shop.id_list 구조 내보내기
CREATE TABLE IF NOT EXISTS `id_list` (
  `id` varchar(50) NOT NULL,
  `last_pw` varchar(50) NOT NULL,
  `active` enum('Y','N') NOT NULL,
  `createdate` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.id_list:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `id_list` DISABLE KEYS */;
/*!40000 ALTER TABLE `id_list` ENABLE KEYS */;

-- 테이블 shop.orders 구조 내보내기
CREATE TABLE IF NOT EXISTS `orders` (
  `order_no` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(50) NOT NULL,
  `delivery_status` enum('주문확인중','배송중','배송시작','배송완료','구매확정') NOT NULL,
  `order_cnt` int(11) NOT NULL,
  `order_address` text NOT NULL,
  `order_price` double NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`order_no`),
  KEY `FK_orders_id_list` (`id`),
  CONSTRAINT `FK_orders_id_list` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.orders:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;

-- 테이블 shop.order_product 구조 내보내기
CREATE TABLE IF NOT EXISTS `order_product` (
  `order_product_no` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL,
  `product_no` int(11) NOT NULL,
  `product_cnt` int(11) NOT NULL,
  `product_price` double NOT NULL,
  `product_discount` double NOT NULL,
  PRIMARY KEY (`order_product_no`),
  KEY `order_no` (`order_no`),
  KEY `product_no` (`product_no`),
  CONSTRAINT `FK_order_product_orders` FOREIGN KEY (`order_no`) REFERENCES `orders` (`order_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_order_product_product` FOREIGN KEY (`product_no`) REFERENCES `product` (`product_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.order_product:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `order_product` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_product` ENABLE KEYS */;

-- 테이블 shop.point_history 구조 내보내기
CREATE TABLE IF NOT EXISTS `point_history` (
  `point_no` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL,
  `point_pm` enum('P','M') NOT NULL,
  `point` int(10) NOT NULL,
  `createdate` datetime NOT NULL,
  PRIMARY KEY (`point_no`),
  KEY `FK_point_order` (`order_no`),
  CONSTRAINT `FK_point_order` FOREIGN KEY (`order_no`) REFERENCES `orders` (`order_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.point_history:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `point_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `point_history` ENABLE KEYS */;

-- 테이블 shop.product 구조 내보내기
CREATE TABLE IF NOT EXISTS `product` (
  `product_no` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(50) NOT NULL,
  `product_name` text NOT NULL,
  `product_price` double NOT NULL,
  `product_status` enum('예약판매','판매중','품절') NOT NULL,
  `product_stock` int(11) NOT NULL,
  `product_info` int(11) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`product_no`),
  KEY `FK_item_category` (`category_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.product:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
/*!40000 ALTER TABLE `product` ENABLE KEYS */;

-- 테이블 shop.product_img 구조 내보내기
CREATE TABLE IF NOT EXISTS `product_img` (
  `product_no` int(11) NOT NULL,
  `product_ori_filename` text NOT NULL,
  `product_save_filename` text NOT NULL,
  `product_filetype` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`product_no`),
  KEY `product_no` (`product_no`),
  CONSTRAINT `FK_product_img_product` FOREIGN KEY (`product_no`) REFERENCES `product` (`product_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.product_img:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `product_img` DISABLE KEYS */;
/*!40000 ALTER TABLE `product_img` ENABLE KEYS */;

-- 테이블 shop.pw_history 구조 내보내기
CREATE TABLE IF NOT EXISTS `pw_history` (
  `pw_no` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(50) NOT NULL,
  `pw` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  PRIMARY KEY (`pw_no`),
  KEY `FK_pw_id` (`id`),
  CONSTRAINT `FK_pw_id` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.pw_history:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `pw_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `pw_history` ENABLE KEYS */;

-- 테이블 shop.question 구조 내보내기
CREATE TABLE IF NOT EXISTS `question` (
  `q_no` int(11) NOT NULL AUTO_INCREMENT,
  `product_no` int(11) NOT NULL,
  `id` varchar(50) NOT NULL,
  `q_category` varchar(50) NOT NULL,
  `q_title` varchar(50) NOT NULL,
  `q_content` text NOT NULL,
  `q_pw` varchar(50) NOT NULL,
  `a_chk` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`q_no`),
  KEY `FK_q_board_id` (`id`),
  KEY `product_no` (`product_no`),
  CONSTRAINT `FK_q_board_id` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_question_product` FOREIGN KEY (`product_no`) REFERENCES `product` (`product_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='상품페이지 밑에 있는 문의';

-- 테이블 데이터 shop.question:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
/*!40000 ALTER TABLE `question` ENABLE KEYS */;

-- 테이블 shop.review 구조 내보내기
CREATE TABLE IF NOT EXISTS `review` (
  `order_no` int(11) NOT NULL,
  `review_title` varchar(50) NOT NULL,
  `review_content` text NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`order_no`),
  KEY `order_no` (`order_no`),
  CONSTRAINT `FK_review_order` FOREIGN KEY (`order_no`) REFERENCES `orders` (`order_no`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.review:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
/*!40000 ALTER TABLE `review` ENABLE KEYS */;

-- 테이블 shop.review_img 구조 내보내기
CREATE TABLE IF NOT EXISTS `review_img` (
  `order_no` int(11) NOT NULL,
  `review_ori_filename` text NOT NULL,
  `review_save_filename` text NOT NULL,
  `review_filetype` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`order_no`),
  KEY `order_no` (`order_no`),
  CONSTRAINT `FK_review_img_orders` FOREIGN KEY (`order_no`) REFERENCES `orders` (`order_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.review_img:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `review_img` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_img` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
