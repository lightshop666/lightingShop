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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.answer:~2 rows (대략적) 내보내기
/*!40000 ALTER TABLE `answer` DISABLE KEYS */;
INSERT INTO `answer` (`a_no`, `q_no`, `id`, `a_content`, `createdate`, `updatedate`) VALUES
	(1, 2, 'admin', '답변 내용 입니다', '2023-06-02 11:16:27', '2023-06-02 11:16:27'),
	(2, 3, 'admin', '답변 내용 입니다', '2023-06-02 11:16:27', '2023-06-02 11:16:27');
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

-- 테이블 데이터 shop.category:~7 rows (대략적) 내보내기
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` (`category_name`, `createdate`, `updatedate`) VALUES
	('관리자', '1990-01-01 00:00:00', '2020-01-01 00:00:00'),
	('무드등', '2020-01-01 00:00:00', '2020-01-01 00:00:00'),
	('스탠드', '2020-01-01 00:00:00', '2020-01-01 00:00:00'),
	('실내조명', '2020-01-01 00:00:00', '2020-01-01 00:00:00'),
	('실외조명', '2020-01-01 00:00:00', '2020-01-01 00:00:00'),
	('파격세일', '2020-01-01 00:00:00', '2020-01-01 00:00:00'),
	('포인트조명', '2020-01-01 00:00:00', '2020-01-01 00:00:00');
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

-- 테이블 데이터 shop.customer:~1 rows (대략적) 내보내기
/*!40000 ALTER TABLE `customer` DISABLE KEYS */;
INSERT INTO `customer` (`id`, `cstm_name`, `cstm_address`, `cstm_email`, `cstm_birth`, `cstm_phone`, `cstm_gender`, `cstm_rank`, `cstm_point`, `cstm_last_login`, `cstm_agree`, `createdate`, `updatedate`) VALUES
	('test2', '홍길동', '서울시 금천구 가산디지털단지로', 'test@email', '2000-01-01', '010-1234-5678', '남자', '은', 5000, '2022-06-01 00:00:00', 'Y', '2023-06-02 14:10:43', '2023-06-02 14:10:43');
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
  `emp_phone` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`),
  CONSTRAINT `FK_employees_id` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='level :숫자가 높을 수록 권한이 높게';

-- 테이블 데이터 shop.employees:~1 rows (대략적) 내보내기
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` (`id`, `emp_name`, `emp_level`, `emp_phone`, `createdate`, `updatedate`) VALUES
	('admin', '관리자', '5', '010-0000-0000', '2023-06-02 11:16:27', '2023-06-02 11:16:27');
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;

-- 테이블 shop.id_list 구조 내보내기
CREATE TABLE IF NOT EXISTS `id_list` (
  `id` varchar(50) NOT NULL,
  `last_pw` varchar(50) NOT NULL,
  `active` enum('Y','N') NOT NULL,
  `createdate` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.id_list:~4 rows (대략적) 내보내기
/*!40000 ALTER TABLE `id_list` DISABLE KEYS */;
INSERT INTO `id_list` (`id`, `last_pw`, `active`, `createdate`) VALUES
	('admin', '1234', 'Y', '2023-06-02 11:16:27'),
	('guest', '1234', 'Y', '2023-06-02 11:16:27'),
	('test', '1234', 'Y', '2023-06-02 11:16:27'),
	('test2', '1234', 'Y', '2023-06-02 11:16:27');
/*!40000 ALTER TABLE `id_list` ENABLE KEYS */;

-- 테이블 shop.orders 구조 내보내기
CREATE TABLE IF NOT EXISTS `orders` (
  `order_no` int(11) NOT NULL AUTO_INCREMENT,
  `id` varchar(50) NOT NULL,
  `order_address` text NOT NULL,
  `order_price` double NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`order_no`),
  KEY `FK_orders_id_list` (`id`),
  CONSTRAINT `FK_orders_id_list` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.orders:~10 rows (대략적) 내보내기
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` (`order_no`, `id`, `order_address`, `order_price`, `createdate`, `updatedate`) VALUES
	(1, 'test2', '서울시 강남구', 50000, '2023-06-02 14:33:07', '2023-06-02 14:33:07'),
	(2, 'test2', '서울시 마포구', 35000, '2023-06-02 14:33:07', '2023-06-02 14:33:07'),
	(3, 'test2', '서울시 송파구', 25000, '2023-06-02 14:33:07', '2023-06-02 14:33:07'),
	(4, 'test2', '서울시 강서구', 60000, '2023-06-02 14:33:07', '2023-06-02 14:33:07'),
	(5, 'test2', '서울시 종로구', 40000, '2023-06-02 14:33:07', '2023-06-02 14:33:07'),
	(6, 'test2', '서울시 강남구', 50000, '2023-06-02 14:35:33', '2023-06-02 14:35:33'),
	(7, 'test2', '서울시 강남구', 50000, '2023-06-02 14:35:34', '2023-06-02 14:35:34'),
	(8, 'test2', '서울시 강남구', 50000, '2023-06-02 14:35:35', '2023-06-02 14:35:35'),
	(9, 'test2', '서울시 강남구', 50000, '2023-06-02 14:35:35', '2023-06-02 14:35:35'),
	(10, 'test2', '서울시 강남구', 50000, '2023-06-02 14:35:35', '2023-06-02 14:35:35');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;

-- 테이블 shop.order_product 구조 내보내기
CREATE TABLE IF NOT EXISTS `order_product` (
  `order_product_no` int(11) NOT NULL AUTO_INCREMENT,
  `order_no` int(11) NOT NULL,
  `product_no` int(11) NOT NULL,
  `product_cnt` int(11) NOT NULL,
  `delivery_status` enum('주문확인중','배송중','배송시작','배송완료','취소중','취소완료','교환중','구매확정') NOT NULL,
  PRIMARY KEY (`order_product_no`),
  KEY `order_no` (`order_no`),
  KEY `product_no` (`product_no`),
  CONSTRAINT `FK_order_product_orders` FOREIGN KEY (`order_no`) REFERENCES `orders` (`order_no`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_order_product_product` FOREIGN KEY (`product_no`) REFERENCES `product` (`product_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.order_product:~16 rows (대략적) 내보내기
/*!40000 ALTER TABLE `order_product` DISABLE KEYS */;
INSERT INTO `order_product` (`order_product_no`, `order_no`, `product_no`, `product_cnt`, `delivery_status`) VALUES
	(10, 1, 1, 2, '구매확정'),
	(11, 1, 2, 2, '구매확정'),
	(12, 2, 23, 2, '구매확정'),
	(13, 3, 25, 1, '구매확정'),
	(14, 3, 26, 1, '구매확정'),
	(15, 4, 33, 1, '배송중'),
	(16, 4, 36, 1, '배송중'),
	(17, 4, 33, 1, '배송완료'),
	(18, 4, 36, 1, '배송완료'),
	(19, 4, 36, 1, '배송완료'),
	(20, 5, 33, 1, '구매확정'),
	(21, 6, 36, 1, '구매확정'),
	(22, 7, 36, 1, '구매확정'),
	(23, 8, 35, 1, '구매확정'),
	(24, 9, 76, 1, '구매확정'),
	(25, 10, 75, 1, '구매확정');
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
  `product_discount` double NOT NULL,
  `product_status` enum('예약판매','판매중','품절') NOT NULL,
  `product_stock` int(11) NOT NULL,
  `product_info` text NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`product_no`),
  KEY `FK_item_category` (`category_name`)
) ENGINE=InnoDB AUTO_INCREMENT=102 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.product:~101 rows (대략적) 내보내기
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` (`product_no`, `category_name`, `product_name`, `product_price`, `product_discount`, `product_status`, `product_stock`, `product_info`, `createdate`, `updatedate`) VALUES
	(1, '관리자', 'admin', 0, 0, '품절', 0, '관리자전용', '2023-06-01 16:40:15', '2023-06-01 16:40:15'),
	(2, '포인트조명', 'Bread - 10 Grain', 26338, 0, '판매중', 48, 'cursus urna ut tellus nulla ut erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi', '2022-10-20 00:00:00', '2023-06-01 00:00:00'),
	(3, '실내조명', 'Oil - Peanut', 48347, 0, '예약판매', 96, 'ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu', '2022-12-14 00:00:00', '2023-06-01 00:00:00'),
	(4, '스탠드', 'Hold Up Tool Storage Rack', 48076, 0, '예약판매', 11, 'ac tellus semper interdum mauris ullamcorper purus sit amet nulla quisque arcu libero', '2022-06-26 00:00:00', '2023-06-01 00:00:00'),
	(5, '무드등', 'Wine - Acient Coast Caberne', 9835, 0, '예약판매', 62, 'diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis turpis eget elit sodales scelerisque mauris', '2022-11-24 00:00:00', '2023-06-01 00:00:00'),
	(6, '실내조명', 'Soup - Campbells, Cream Of', 11059, 0, '품절', 39, 'posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi', '2022-11-26 00:00:00', '2023-06-01 00:00:00'),
	(7, '스탠드', 'Chicken - Wieners', 2794, 0, '판매중', 45, 'quam pede lobortis ligula sit amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque', '2023-01-25 00:00:00', '2023-06-01 00:00:00'),
	(8, '포인트조명', 'Veal Inside - Provimi', 40287, 0, '판매중', 30, 'quis augue luctus tincidunt nulla mollis molestie lorem quisque ut erat curabitur gravida', '2022-11-18 00:00:00', '2023-06-01 00:00:00'),
	(9, '파격세일', 'Loaf Pan - 2 Lb, Foil', 39095, 0, '예약판매', 50, 'accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula vehicula consequat', '2022-07-11 00:00:00', '2023-06-01 00:00:00'),
	(10, '무드등', 'Muffin - Carrot Individual Wrap', 46007, 0, '판매중', 97, 'aliquet massa id lobortis convallis tortor risus dapibus augue vel accumsan tellus', '2023-04-09 00:00:00', '2023-06-01 00:00:00'),
	(11, '파격세일', 'Wine - Tio Pepe Sherry Fino', 4160, 0, '품절', 91, 'volutpat convallis morbi odio odio elementum eu interdum eu tincidunt in leo maecenas', '2022-10-28 00:00:00', '2023-06-01 00:00:00'),
	(12, '실내조명', 'Island Oasis - Banana Daiquiri', 15331, 0, '품절', 5, 'dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at', '2023-01-25 00:00:00', '2023-06-01 00:00:00'),
	(13, '실외조명', 'Octopus - Baby, Cleaned', 24786, 0, '판매중', 60, 'dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien', '2023-05-18 00:00:00', '2023-06-01 00:00:00'),
	(14, '포인트조명', 'Mustard - Pommery', 36502, 0, '판매중', 87, 'congue diam id ornare imperdiet sapien urna pretium nisl ut volutpat sapien arcu sed augue aliquam erat volutpat in', '2023-02-26 00:00:00', '2023-06-01 00:00:00'),
	(15, '실외조명', 'Cheese Cloth', 26953, 0, '품절', 60, 'quis odio consequat varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero', '2023-02-26 00:00:00', '2023-06-01 00:00:00'),
	(16, '스탠드', 'Bread - Focaccia Quarter', 30876, 0, '품절', 90, 'rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio', '2023-03-17 00:00:00', '2023-06-01 00:00:00'),
	(17, '포인트조명', 'Garlic - Primerba, Paste', 43473, 0, '판매중', 65, 'turpis elementum ligula vehicula consequat morbi a ipsum integer a nibh in quis justo', '2022-09-22 00:00:00', '2023-06-01 00:00:00'),
	(18, '실내조명', 'Crackers - Melba Toast', 18335, 0, '판매중', 53, 'nam congue risus semper porta volutpat quam pede lobortis ligula sit amet', '2023-01-30 00:00:00', '2023-06-01 00:00:00'),
	(19, '실외조명', 'Chocolate - Feathers', 8414, 0, '예약판매', 35, 'vel lectus in quam fringilla rhoncus mauris enim leo rhoncus sed', '2023-01-19 00:00:00', '2023-06-01 00:00:00'),
	(20, '파격세일', 'Soup - Knorr, Classic Can. Chili', 35056, 0, '품절', 40, 'mi in porttitor pede justo eu massa donec dapibus duis at velit eu est congue', '2022-07-08 00:00:00', '2023-06-01 00:00:00'),
	(21, '실내조명', 'Oregano - Dry, Rubbed', 34335, 0, '예약판매', 38, 'adipiscing lorem vitae mattis nibh ligula nec sem duis aliquam convallis nunc proin at', '2023-01-29 00:00:00', '2023-06-01 00:00:00'),
	(22, '실내조명', 'Sprouts - Baby Pea Tendrils', 49648, 0, '품절', 81, 'nisi at nibh in hac habitasse platea dictumst aliquam augue quam sollicitudin vitae consectetuer eget rutrum at', '2023-02-02 00:00:00', '2023-06-01 00:00:00'),
	(23, '실내조명', 'Carbonated Water - Blackcherry', 9492, 0, '품절', 92, 'libero nam dui proin leo odio porttitor id consequat in consequat ut nulla sed accumsan felis ut at dolor', '2022-12-14 00:00:00', '2023-06-01 00:00:00'),
	(24, '스탠드', 'Ketchup - Tomato', 17033, 0, '판매중', 5, 'maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac diam cras pellentesque volutpat', '2022-09-26 00:00:00', '2023-06-01 00:00:00'),
	(25, '파격세일', 'Beans - Kidney, Canned', 29344, 0, '품절', 87, 'montes nascetur ridiculus mus vivamus vestibulum sagittis sapien cum sociis natoque', '2022-06-01 00:00:00', '2023-06-01 00:00:00'),
	(26, '포인트조명', 'Nut - Macadamia', 35725, 0, '판매중', 62, 'curae duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat eleifend donec', '2022-09-16 00:00:00', '2023-06-01 00:00:00'),
	(27, '무드등', 'Chevere Logs', 2787, 0, '품절', 30, 'posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl', '2023-03-07 00:00:00', '2023-06-01 00:00:00'),
	(28, '무드등', 'Pop - Club Soda Can', 48299, 0, '판매중', 41, 'eros suspendisse accumsan tortor quis turpis sed ante vivamus tortor duis mattis egestas', '2022-09-03 00:00:00', '2023-06-01 00:00:00'),
	(29, '무드등', 'Bandage - Fexible 1x3', 2596, 0, '예약판매', 100, 'neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in sagittis dui vel nisl duis', '2023-01-24 00:00:00', '2023-06-01 00:00:00'),
	(30, '포인트조명', 'Chocolate Liqueur - Godet White', 21952, 0, '예약판매', 39, 'in leo maecenas pulvinar lobortis est phasellus sit amet erat nulla tempus vivamus in felis eu sapien', '2022-08-15 00:00:00', '2023-06-01 00:00:00'),
	(31, '포인트조명', 'Cheese - Comtomme', 3502, 0, '판매중', 45, 'vel accumsan tellus nisi eu orci mauris lacinia sapien quis libero nullam sit amet turpis elementum ligula', '2022-08-14 00:00:00', '2023-06-01 00:00:00'),
	(32, '실외조명', 'Yogurt - Strawberry, 175 Gr', 39921, 0, '품절', 84, 'at feugiat non pretium quis lectus suspendisse potenti in eleifend quam a odio in hac habitasse platea dictumst maecenas ut', '2022-07-14 00:00:00', '2023-06-01 00:00:00'),
	(33, '스탠드', 'Chocolate Bar - Oh Henry', 33633, 0, '판매중', 72, 'pulvinar nulla pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra', '2023-03-26 00:00:00', '2023-06-01 00:00:00'),
	(34, '무드등', 'Dasheen', 43024, 0, '품절', 94, 'phasellus in felis donec semper sapien a libero nam dui proin leo odio porttitor id', '2022-06-28 00:00:00', '2023-06-01 00:00:00'),
	(35, '실내조명', 'Juice - Tomato, 10 Oz', 18492, 0, '예약판매', 53, 'ligula vehicula consequat morbi a ipsum integer a nibh in quis justo maecenas rhoncus aliquam', '2023-01-26 00:00:00', '2023-06-01 00:00:00'),
	(36, '실외조명', 'Wine - Vouvray Cuvee Domaine', 26965, 0, '예약판매', 81, 'velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis in', '2022-09-02 00:00:00', '2023-06-01 00:00:00'),
	(37, '파격세일', 'Red Currants', 19071, 0, '품절', 89, 'ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum morbi', '2022-06-22 00:00:00', '2023-06-01 00:00:00'),
	(38, '실내조명', 'Dill Weed - Fresh', 27085, 0, '품절', 11, 'et commodo vulputate justo in blandit ultrices enim lorem ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris', '2022-09-04 00:00:00', '2023-06-01 00:00:00'),
	(39, '실내조명', 'Cheese - Victor Et Berthold', 43539, 0, '판매중', 73, 'justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum', '2022-07-25 00:00:00', '2023-06-01 00:00:00'),
	(40, '스탠드', 'Oregano - Fresh', 45236, 0, '품절', 87, 'ipsum dolor sit amet consectetuer adipiscing elit proin interdum mauris non ligula pellentesque ultrices phasellus id sapien in', '2023-01-07 00:00:00', '2023-06-01 00:00:00'),
	(41, '실외조명', 'Jam - Strawberry, 20 Ml Jar', 15096, 0, '품절', 39, 'ligula in lacus curabitur at ipsum ac tellus semper interdum mauris ullamcorper', '2022-09-26 00:00:00', '2023-06-01 00:00:00'),
	(42, '무드등', 'Flour - Teff', 27892, 0, '예약판매', 56, 'nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor gravida sem praesent id massa id nisl venenatis', '2022-10-10 00:00:00', '2023-06-01 00:00:00'),
	(43, '스탠드', 'Pear - Prickly', 7235, 0, '품절', 29, 'tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis bibendum', '2022-07-28 00:00:00', '2023-06-01 00:00:00'),
	(44, '실외조명', 'Club Soda - Schweppes, 355 Ml', 34572, 0, '판매중', 67, 'habitasse platea dictumst morbi vestibulum velit id pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat', '2022-07-03 00:00:00', '2023-06-01 00:00:00'),
	(45, '실외조명', 'Bacardi Limon', 8202, 0, '품절', 99, 'nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere', '2022-10-03 00:00:00', '2023-06-01 00:00:00'),
	(46, '포인트조명', 'Beets - Golden', 18899, 0, '품절', 5, 'tristique in tempus sit amet sem fusce consequat nulla nisl nunc nisl duis bibendum felis sed interdum venenatis', '2022-08-07 00:00:00', '2023-06-01 00:00:00'),
	(47, '무드등', 'Plasticspoonblack', 22929, 0, '예약판매', 29, 'ligula pellentesque ultrices phasellus id sapien in sapien iaculis congue vivamus metus arcu adipiscing molestie hendrerit at vulputate', '2023-04-25 00:00:00', '2023-06-01 00:00:00'),
	(48, '포인트조명', 'Lamb - Racks, Frenched', 2934, 0, '판매중', 49, 'interdum in ante vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere', '2022-08-11 00:00:00', '2023-06-01 00:00:00'),
	(49, '스탠드', 'Banana - Leaves', 5581, 0, '예약판매', 95, 'in consequat ut nulla sed accumsan felis ut at dolor quis odio consequat varius', '2023-03-01 00:00:00', '2023-06-01 00:00:00'),
	(50, '파격세일', 'Sobe - Lizard Fuel', 29781, 0, '판매중', 10, 'pretium iaculis diam erat fermentum justo nec condimentum neque sapien placerat ante nulla justo aliquam quis', '2023-03-19 00:00:00', '2023-06-01 00:00:00'),
	(51, '무드등', 'Bread - Pumpernickle, Rounds', 4141, 0, '판매중', 17, 'pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer', '2022-10-04 00:00:00', '2023-06-01 00:00:00'),
	(52, '실외조명', 'Vaccum Bag - 14x20', 46935, 0, '예약판매', 86, 'dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum', '2023-03-27 00:00:00', '2023-06-01 00:00:00'),
	(53, '파격세일', 'Dried Cranberries', 10655, 0, '예약판매', 2, 'metus vitae ipsum aliquam non mauris morbi non lectus aliquam sit amet', '2023-01-24 00:00:00', '2023-06-01 00:00:00'),
	(54, '실내조명', 'Sour Cream', 7461, 0, '예약판매', 12, 'nisi volutpat eleifend donec ut dolor morbi vel lectus in quam fringilla rhoncus mauris enim', '2022-07-08 00:00:00', '2023-06-01 00:00:00'),
	(55, '무드등', 'Absolut Citron', 21381, 0, '예약판매', 82, 'sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis', '2022-07-16 00:00:00', '2023-06-01 00:00:00'),
	(56, '스탠드', 'Beer - Camerons Cream Ale', 2364, 0, '예약판매', 100, 'nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a', '2022-12-27 00:00:00', '2023-06-01 00:00:00'),
	(57, '파격세일', 'Beer - Sleeman Fine Porter', 6437, 0, '판매중', 36, 'posuere nonummy integer non velit donec diam neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum primis', '2022-10-23 00:00:00', '2023-06-01 00:00:00'),
	(58, '실내조명', 'Ice Cream - Vanilla', 25856, 0, '품절', 69, 'eget tincidunt eget tempus vel pede morbi porttitor lorem id ligula suspendisse ornare consequat lectus in', '2023-04-02 00:00:00', '2023-06-01 00:00:00'),
	(59, '무드등', 'Melon - Cantaloupe', 6280, 0, '판매중', 68, 'bibendum imperdiet nullam orci pede venenatis non sodales sed tincidunt eu felis fusce posuere felis sed lacus', '2022-06-30 00:00:00', '2023-06-01 00:00:00'),
	(60, '스탠드', 'Ocean Spray - Kiwi Strawberry', 9999, 0, '품절', 98, 'ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien', '2023-03-06 00:00:00', '2023-06-01 00:00:00'),
	(61, '파격세일', 'Peach - Halves', 40190, 0, '판매중', 20, 'sit amet turpis elementum ligula vehicula consequat morbi a ipsum integer', '2022-08-03 00:00:00', '2023-06-01 00:00:00'),
	(62, '무드등', 'Wine - Lamancha Do Crianza', 5178, 0, '판매중', 32, 'metus arcu adipiscing molestie hendrerit at vulputate vitae nisl aenean lectus pellentesque eget nunc donec quis orci eget', '2022-10-21 00:00:00', '2023-06-01 00:00:00'),
	(63, '포인트조명', 'Juice - Pineapple, 341 Ml', 1510, 0, '품절', 86, 'eu sapien cursus vestibulum proin eu mi nulla ac enim in tempor turpis nec euismod scelerisque', '2023-03-29 00:00:00', '2023-06-01 00:00:00'),
	(64, '실내조명', 'Maple Syrup', 40250, 0, '품절', 33, 'quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec molestie sed justo pellentesque viverra pede ac', '2022-10-26 00:00:00', '2023-06-01 00:00:00'),
	(65, '실외조명', 'Cheese - Cambozola', 25791, 0, '판매중', 67, 'eu tincidunt in leo maecenas pulvinar lobortis est phasellus sit', '2023-04-11 00:00:00', '2023-06-01 00:00:00'),
	(66, '스탠드', 'Mushroom - Lg - Cello', 28204, 0, '예약판매', 34, 'interdum venenatis turpis enim blandit mi in porttitor pede justo eu massa donec dapibus duis at velit', '2022-07-16 00:00:00', '2023-06-01 00:00:00'),
	(67, '스탠드', 'Sea Bass - Whole', 17005, 0, '품절', 34, 'posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc', '2022-10-10 00:00:00', '2023-06-01 00:00:00'),
	(68, '포인트조명', 'Gingerale - Schweppes, 355 Ml', 29435, 0, '품절', 23, 'lectus pellentesque at nulla suspendisse potenti cras in purus eu magna vulputate luctus cum sociis natoque penatibus', '2023-04-12 00:00:00', '2023-06-01 00:00:00'),
	(69, '스탠드', 'Wine - Casablanca Valley', 29731, 0, '판매중', 65, 'lectus aliquam sit amet diam in magna bibendum imperdiet nullam orci pede venenatis non', '2023-04-13 00:00:00', '2023-06-01 00:00:00'),
	(70, '실내조명', 'Lamb - Pieces, Diced', 6910, 0, '판매중', 78, 'luctus et ultrices posuere cubilia curae donec pharetra magna vestibulum aliquet ultrices erat tortor sollicitudin mi sit amet lobortis sapien', '2023-01-09 00:00:00', '2023-06-01 00:00:00'),
	(71, '스탠드', 'Tortillas - Flour, 10', 44276, 0, '예약판매', 11, 'quisque porta volutpat erat quisque erat eros viverra eget congue eget semper rutrum nulla nunc purus phasellus', '2022-10-30 00:00:00', '2023-06-01 00:00:00'),
	(72, '스탠드', 'Pineapple - Regular', 48470, 0, '품절', 41, 'in eleifend quam a odio in hac habitasse platea dictumst maecenas ut', '2023-01-28 00:00:00', '2023-06-01 00:00:00'),
	(73, '실내조명', 'Corn Syrup', 37417, 0, '판매중', 8, 'erat id mauris vulputate elementum nullam varius nulla facilisi cras non velit nec nisi', '2022-06-16 00:00:00', '2023-06-01 00:00:00'),
	(74, '실내조명', 'Gelatine Leaves - Envelopes', 31743, 0, '품절', 33, 'odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede ullamcorper augue a', '2023-02-02 00:00:00', '2023-06-01 00:00:00'),
	(75, '무드등', 'Venison - Striploin', 6398, 0, '예약판매', 8, 'et magnis dis parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum', '2022-08-21 00:00:00', '2023-06-01 00:00:00'),
	(76, '스탠드', 'Pepper - Roasted Red', 5931, 0, '품절', 80, 'sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl nunc rhoncus dui vel sem sed sagittis nam', '2022-07-08 00:00:00', '2023-06-01 00:00:00'),
	(77, '파격세일', 'Bread - White Mini Epi', 9879, 0, '예약판매', 68, 'duis faucibus accumsan odio curabitur convallis duis consequat dui nec nisi volutpat', '2023-04-22 00:00:00', '2023-06-01 00:00:00'),
	(78, '파격세일', 'Beans - Long, Chinese', 7129, 0, '품절', 16, 'neque libero convallis eget eleifend luctus ultricies eu nibh quisque id justo sit amet sapien dignissim vestibulum vestibulum', '2022-12-27 00:00:00', '2023-06-01 00:00:00'),
	(79, '실외조명', 'Oil - Hazelnut', 6860, 0, '예약판매', 29, 'quis justo maecenas rhoncus aliquam lacus morbi quis tortor id nulla ultrices aliquet maecenas leo odio condimentum id luctus nec', '2023-03-20 00:00:00', '2023-06-01 00:00:00'),
	(80, '실내조명', 'Gelatine Powder', 3813, 0, '판매중', 32, 'tempor convallis nulla neque libero convallis eget eleifend luctus ultricies eu nibh', '2022-11-20 00:00:00', '2023-06-01 00:00:00'),
	(81, '실내조명', 'Coke - Diet, 355 Ml', 26885, 0, '판매중', 26, 'pede ullamcorper augue a suscipit nulla elit ac nulla sed vel enim sit amet nunc viverra dapibus nulla suscipit', '2023-03-27 00:00:00', '2023-06-01 00:00:00'),
	(82, '무드등', 'Cup Translucent 9 Oz', 17516, 0, '판매중', 42, 'velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros', '2022-10-29 00:00:00', '2023-06-01 00:00:00'),
	(83, '무드등', 'Skewers - Bamboo', 36855, 0, '예약판매', 86, 'donec posuere metus vitae ipsum aliquam non mauris morbi non lectus aliquam', '2023-05-14 00:00:00', '2023-06-01 00:00:00'),
	(84, '실내조명', 'Island Oasis - Lemonade', 35324, 0, '예약판매', 8, 'lorem ipsum dolor sit amet consectetuer adipiscing elit proin risus praesent lectus vestibulum quam sapien varius ut blandit', '2022-08-02 00:00:00', '2023-06-01 00:00:00'),
	(85, '스탠드', 'Lettuce - California Mix', 19091, 0, '예약판매', 63, 'parturient montes nascetur ridiculus mus etiam vel augue vestibulum rutrum rutrum neque aenean auctor', '2022-07-28 00:00:00', '2023-06-01 00:00:00'),
	(86, '실내조명', 'Mushroom - Shitake, Dry', 47021, 0, '품절', 43, 'sodales sed tincidunt eu felis fusce posuere felis sed lacus morbi sem mauris laoreet ut rhoncus aliquet pulvinar sed nisl', '2022-11-14 00:00:00', '2023-06-01 00:00:00'),
	(87, '실내조명', 'Foam Cup 6 Oz', 8016, 0, '판매중', 61, 'nec dui luctus rutrum nulla tellus in sagittis dui vel', '2023-04-23 00:00:00', '2023-06-01 00:00:00'),
	(88, '파격세일', 'Eel - Smoked', 21731, 0, '예약판매', 37, 'nunc nisl duis bibendum felis sed interdum venenatis turpis enim blandit mi in', '2023-03-30 00:00:00', '2023-06-01 00:00:00'),
	(89, '파격세일', 'Brandy - Orange, Mc Guiness', 9884, 0, '판매중', 22, 'neque vestibulum eget vulputate ut ultrices vel augue vestibulum ante ipsum', '2022-09-25 00:00:00', '2023-06-01 00:00:00'),
	(90, '파격세일', 'Cookie Dough - Oatmeal Rasin', 28376, 0, '예약판매', 23, 'amet eleifend pede libero quis orci nullam molestie nibh in lectus pellentesque at nulla', '2022-11-28 00:00:00', '2023-06-01 00:00:00'),
	(91, '스탠드', 'Eggroll', 15155, 0, '판매중', 50, 'fusce consequat nulla nisl nunc nisl duis bibendum felis sed', '2022-11-05 00:00:00', '2023-06-01 00:00:00'),
	(92, '포인트조명', 'Cake Circle, Paprus', 18490, 0, '판매중', 33, 'ultrices posuere cubilia curae mauris viverra diam vitae quam suspendisse potenti', '2023-02-22 00:00:00', '2023-06-01 00:00:00'),
	(93, '포인트조명', 'Oil - Sesame', 11304, 0, '품절', 41, 'aenean sit amet justo morbi ut odio cras mi pede', '2022-09-05 00:00:00', '2023-06-01 00:00:00'),
	(94, '실내조명', 'Wine - Coteaux Du Tricastin Ac', 11075, 0, '품절', 51, 'lacus at velit vivamus vel nulla eget eros elementum pellentesque quisque porta volutpat erat quisque erat eros', '2023-01-09 00:00:00', '2023-06-01 00:00:00'),
	(95, '실외조명', 'Mushroom - Chanterelle, Dry', 26307, 0, '판매중', 21, 'ultrices erat tortor sollicitudin mi sit amet lobortis sapien sapien non mi integer ac neque duis', '2023-01-14 00:00:00', '2023-06-01 00:00:00'),
	(96, '무드등', 'Rabbit - Frozen', 22351, 0, '판매중', 47, 'in faucibus orci luctus et ultrices posuere cubilia curae donec pharetra', '2023-04-25 00:00:00', '2023-06-01 00:00:00'),
	(97, '스탠드', 'Vinegar - Champagne', 23504, 0, '예약판매', 80, 'mi integer ac neque duis bibendum morbi non quam nec dui luctus rutrum nulla tellus in', '2022-07-24 00:00:00', '2023-06-01 00:00:00'),
	(98, '스탠드', 'Wine - Magnotta - Cab Franc', 33287, 0, '판매중', 65, 'ac est lacinia nisi venenatis tristique fusce congue diam id ornare imperdiet', '2023-02-11 00:00:00', '2023-06-01 00:00:00'),
	(99, '무드등', 'Pasta - Spaghetti, Dry', 29288, 0, '예약판매', 70, 'varius integer ac leo pellentesque ultrices mattis odio donec vitae nisi nam ultrices libero non mattis pulvinar nulla pede', '2022-09-05 00:00:00', '2023-06-01 00:00:00'),
	(100, '파격세일', 'Wine - Gewurztraminer Pierre', 6045, 0, '예약판매', 42, 'mi integer ac neque duis bibendum morbi non quam nec dui luctus', '2023-05-10 00:00:00', '2023-06-01 00:00:00'),
	(101, '실내조명', 'Soup - Canadian Pea, Dry Mix', 16641, 0, '예약판매', 70, 'vulputate luctus cum sociis natoque penatibus et magnis dis parturient montes nascetur ridiculus mus vivamus', '2022-08-05 00:00:00', '2023-06-01 00:00:00');
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

-- 테이블 데이터 shop.product_img:~12 rows (대략적) 내보내기
/*!40000 ALTER TABLE `product_img` DISABLE KEYS */;
INSERT INTO `product_img` (`product_no`, `product_ori_filename`, `product_save_filename`, `product_filetype`, `createdate`, `updatedate`) VALUES
	(1, '0630070004597.jpg', 'img/product/0630070004597.jpg', 'jpg', '2023-06-02 14:22:05', '2023-06-02 14:22:05'),
	(2, '0630070005247.jpg', 'img/product/0630070005247.jpg', 'jpg', '2023-06-02 14:22:05', '2023-06-02 14:22:05'),
	(3, '0630070009927.jpg', 'img/product/0630070009927.jpg', 'jpg', '2023-06-02 14:22:05', '2023-06-02 14:22:05'),
	(4, '0630070004597.jpg', 'img/product/0630070004597.jpg', 'jpg', '2023-06-02 14:24:32', '2023-06-02 14:24:32'),
	(5, '0630070005247.jpg', 'img/product/0630070005247.jpg', 'jpg', '2023-06-02 14:24:32', '2023-06-02 14:24:32'),
	(6, '0630070009927.jpg', 'img/product/0630070009927.jpg', 'jpg', '2023-06-02 14:24:32', '2023-06-02 14:24:32'),
	(7, '0630070004597.jpg', 'img/product/0630070004597.jpg', 'jpg', '2023-06-02 14:24:47', '2023-06-02 14:24:47'),
	(8, '0630070005247.jpg', 'img/product/0630070005247.jpg', 'jpg', '2023-06-02 14:24:47', '2023-06-02 14:24:47'),
	(9, '0630070009927.jpg', 'img/product/0630070009927.jpg', 'jpg', '2023-06-02 14:24:47', '2023-06-02 14:24:47'),
	(10, '0630070004597.jpg', 'img/product/0630070004597.jpg', 'jpg', '2023-06-02 14:25:06', '2023-06-02 14:25:06'),
	(11, '0630070005247.jpg', 'img/product/0630070005247.jpg', 'jpg', '2023-06-02 14:25:06', '2023-06-02 14:25:06'),
	(12, '0630070009927.jpg', 'img/product/0630070009927.jpg', 'jpg', '2023-06-02 14:25:06', '2023-06-02 14:25:06');
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
  `a_chk` enum('Y','N') NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`q_no`),
  KEY `FK_q_board_id` (`id`),
  KEY `product_no` (`product_no`),
  CONSTRAINT `FK_q_board_id` FOREIGN KEY (`id`) REFERENCES `id_list` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_question_product` FOREIGN KEY (`product_no`) REFERENCES `product` (`product_no`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci COMMENT='상품페이지 밑에 있는 문의';

-- 테이블 데이터 shop.question:~5 rows (대략적) 내보내기
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` (`q_no`, `product_no`, `id`, `q_category`, `q_title`, `q_content`, `q_pw`, `a_chk`, `createdate`, `updatedate`) VALUES
	(1, 1, 'guest', '배송', '문의 테스트', '문의 테스트 입니다', '0000', 'N', '2023-06-02 11:16:27', '2023-06-02 11:16:27'),
	(2, 1, 'guest', '배송', '문의 테스트', '문의 테스트 입니다', '0000', 'Y', '2023-06-02 11:16:27', '2023-06-02 11:16:27'),
	(3, 23, 'test', '배송', '문의 테스트', '문의 테스트 입니다', '1234', 'Y', '2023-06-02 11:16:27', '2023-06-02 11:16:27'),
	(4, 30, 'test2', '배송', '문의 테스트', '문의 테스트 입니다', '1234', 'N', '2023-06-02 11:16:27', '2023-06-02 11:16:27'),
	(5, 68, 'test', '배송', '문의 테스트', '문의 테스트 입니다', '1234', 'N', '2023-06-02 11:16:27', '2023-06-02 11:16:27');
/*!40000 ALTER TABLE `question` ENABLE KEYS */;

-- 테이블 shop.review 구조 내보내기
CREATE TABLE IF NOT EXISTS `review` (
  `order_product_no` int(11) NOT NULL,
  `review_title` varchar(50) NOT NULL,
  `review_content` text NOT NULL,
  `review_written` enum('Y','N') NOT NULL DEFAULT 'N',
  `review_ori_filename` text NOT NULL,
  `review_save_filename` text NOT NULL,
  `review_filetype` varchar(50) NOT NULL,
  `createdate` datetime NOT NULL,
  `updatedate` datetime NOT NULL,
  PRIMARY KEY (`order_product_no`),
  CONSTRAINT `FK_review_order_product` FOREIGN KEY (`order_product_no`) REFERENCES `order_product` (`order_product_no`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

-- 테이블 데이터 shop.review:~0 rows (대략적) 내보내기
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` (`order_product_no`, `review_title`, `review_content`, `review_written`, `review_ori_filename`, `review_save_filename`, `review_filetype`, `createdate`, `updatedate`) VALUES
	(10, '제품에 대한 만족도 높음', '구매한 제품에 대해 매우 만족합니다.', 'Y', 'review1.jpg', 'webapp/img/review/review1.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(11, '품질이 좋은 제품', '구매한 제품의 품질이 매우 좋습니다.', 'Y', 'review2.jpg', 'webapp/img/review/review2.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(12, '추천합니다!', '이 제품을 다른 분들에게도 추천하고 싶습니다.', 'Y', 'review3.jpg', 'webapp/img/review/review3.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(13, '만족도 100%', '구매한 제품에 대한 만족도가 100%입니다.', 'Y', 'review4.jpg', 'webapp/img/review/review4.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(14, '너무 좋아요!', '이 제품을 구매한 것을 후회하지 않습니다.', 'Y', 'review5.jpg', 'webapp/img/review/review5.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(15, '배송이 빨라요!', '빠른 배송 서비스에 감사드립니다.', 'Y', 'review6.jpg', 'webapp/img/review/review6.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(16, '훌륭한 제품입니다', '이 제품은 정말 훌륭합니다.', 'Y', 'review7.jpg', 'webapp/img/review/review7.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(17, '만족도 최고', '구매한 제품에 대한 만족도가 최고입니다.', 'Y', 'review8.jpg', 'webapp/img/review/review8.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(18, '다시 구매 의사 있음', '이 제품을 다시 구매할 의사가 있습니다.', 'Y', 'review9.jpg', 'webapp/img/review/review9.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(19, '매우 실용적인 제품', '구매한 제품은 매우 실용적이고 편리합니다.', 'Y', 'review10.jpg', 'webapp/img/review/review10.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(20, '제품 만족도 200%', '이 제품은 만족도가 200%입니다.', 'Y', 'review11.jpg', 'webapp/img/review/review11.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(21, '굿!', '이 제품은 정말 굿입니다.', 'Y', 'review12.jpg', 'webapp/img/review/review12.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(22, '다른 제품과 차별화된 디자인', '이 제품은 다른 제품들과 차별화된 디자인을 가지고 있습니다.', 'Y', 'review13.jpg', 'webapp/img/review/review13.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(23, '편리한 사용법', '이 제품은 편리한 사용법을 가지고 있습니다.', 'Y', 'review14.jpg', 'webapp/img/review/review14.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(24, '제품 성능 최고', '구매한 제품의 성능이 최고 수준입니다.', 'Y', 'review15.jpg', 'webapp/img/review/review15.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46'),
	(25, '탁월한 가격 대비 성능', '이 제품은 탁월한 가격 대비 성능을 가지고 있습니다.', 'Y', 'review16.jpg', 'webapp/img/review/review16.jpg', 'jpg', '2023-06-02 15:18:46', '2023-06-02 15:18:46');
/*!40000 ALTER TABLE `review` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
