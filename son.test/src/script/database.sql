/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

CREATE TABLE IF NOT EXISTS `board` (
  `board_id` int(11) NOT NULL,
  `idx` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(50) DEFAULT NULL,
  `title` varchar(200) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `img_id` int(11) DEFAULT NULL,
  `view_cnt` int(11) unsigned DEFAULT 0,
  `create_dt` timestamp NULL DEFAULT NULL,
  `update_dt` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`idx`,`board_id`),
  KEY `idx` (`idx`,`board_id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `board_comment` (
  `comment_id` int(11) NOT NULL AUTO_INCREMENT,
  `board_id` int(11) NOT NULL,
  `idx` int(11) NOT NULL,
  `user_id` varchar(50) DEFAULT NULL,
  `comment_content` varchar(4000) DEFAULT NULL,
  `create_dt` timestamp NULL DEFAULT NULL,
  `update_dt` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`comment_id`,`board_id`,`idx`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `board_image` (
  `img_id` int(11) NOT NULL AUTO_INCREMENT,
  `create_dt` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`img_id`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `board_image_detail` (
  `img_id` int(11) NOT NULL,
  `img_srno` int(11) NOT NULL,
  `origin_file_name` varchar(500) DEFAULT NULL,
  `stored_file_name` varchar(500) DEFAULT NULL,
  `file_size` varchar(50) DEFAULT NULL,
  `file_path` varchar(100) DEFAULT NULL,
  `file_extsn` varchar(20) DEFAULT NULL,
  `file_type` varchar(20) DEFAULT NULL,
  `file_url` varchar(1000) DEFAULT NULL,
  `thumb_url` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`img_id`,`img_srno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `board_master` (
  `board_id` int(11) NOT NULL AUTO_INCREMENT,
  `board_name` varchar(200) DEFAULT NULL,
  `comment_yn` varchar(1) DEFAULT NULL,
  `use_yn` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`board_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
 

INSERT INTO `board_master` (`board_name`, `comment_yn`, `use_yn`) VALUES
	( '자유게시판', 'Y', 'Y'),
	( '게시판테스트', 'N', 'Y');



CREATE TABLE IF NOT EXISTS `temp_file` (
  `temp_file_id` int(11) NOT NULL AUTO_INCREMENT,
  `origin_file_name` varchar(500) DEFAULT NULL,
  `stored_file_name` varchar(500) DEFAULT NULL,
  `file_size` varchar(50) DEFAULT NULL,
  `file_path` varchar(100) DEFAULT NULL,
  `file_extsn` varchar(20) DEFAULT NULL,
  `file_type` varchar(100) DEFAULT NULL,
  `file_url` varchar(1000) DEFAULT NULL,
  `thumb_url` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`temp_file_id`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=utf8;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
