DROP DATABASE IF EXISTS `play_on`;
CREATE DATABASE `play_on`; 
USE `play_on`;

SET NAMES utf8 ;
SET character_set_client = utf8mb4 ;

CREATE TABLE `clients` (
  `client_id` int(11) NOT NULL auto_increment,
  `name` varchar(50) NOT NULL,
  `login_id` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `num_subscribers` int(11) NOT NULL default '0',
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `clients` VALUES (1,'Ali','ali001','password123',0);
INSERT INTO `clients` VALUES (2,'Ahmad','ahmad002','password1234',0);
INSERT INTO `clients` VALUES (3,'Fareed','fareed002','password1234',0);
INSERT INTO `clients` VALUES (4,'Mustafa','mustafa003','password1234',0);
INSERT INTO `clients` VALUES (5,'Muzammil','muzammil004','password1234',0);

CREATE TABLE `videos` (
  `video_id` int(11) NOT NULL auto_increment,
  `title` varchar(50) NOT NULL,
  `client_id` int(11) NOT NULL,
  `num_likes` int(11) NOT NULL default '0',
  `num_comments` int(11) NOT NULL default '0',
  `upload_date` date NOT NULL,
  PRIMARY KEY (`video_id`),
  KEY `fk_clinet_id_video` (`client_id`),
  CONSTRAINT `fk_client_id_video` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `videos` VALUES (1,'first video',2,0,0,'2021-03-09');
INSERT INTO `videos` VALUES (2,'second video',1,0,0,'2021-04-10');
INSERT INTO `videos` VALUES (3,'third video',4,0,0,'2020-11-11');
INSERT INTO `videos` VALUES (4,'fourth video',5,0,0,'2020-10-08');
INSERT INTO `videos` VALUES (5,'fifth video',3,0,0,'2021-02-05');
INSERT INTO `videos` VALUES (6,'sixth video',2,0,0,'2019-03-03');

CREATE TABLE `watched` (
  `client_id` int(11) NOT NULL auto_increment,
  `video_id` varchar(50) NOT NULL,
  `watched_on` date NOT NULL,
  PRIMARY KEY (`client_id`, `video_id`),
  KEY `fk_client_id_watch` (`client_id`),
  KEY `fk_video_id_watch` (`video_id`),
  CONSTRAINT `fk_client_id_watch` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_video_id_watch` FOREIGN KEY (`video_id`) REFERENCES `videos` (`video_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


CREATE TABLE `likes` (
  `client_id` int(11) NOT NULL,
  `video_id` int(11) NOT NULL,
  PRIMARY KEY (`client_id`, `video_id`),
  KEY `fk_client_id_like` (`client_id`),
  KEY `fk_video_id_like` (`video_id`),
  CONSTRAINT `fk_client_id_like` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_video_id_like` FOREIGN KEY (`video_id`) REFERENCES `videos` (`video_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `likes` VALUES (1,1);
INSERT INTO `likes` VALUES (2,2);
INSERT INTO `likes` VALUES (3,2);
INSERT INTO `likes` VALUES (5,2);
INSERT INTO `likes` VALUES (1,3);
INSERT INTO `likes` VALUES (2,2);
INSERT INTO `likes` VALUES (6,5);


CREATE TABLE `watch_later` (
  `client_id` int(11) NOT NULL,
  `video_id` int(11) NOT NULL,
  PRIMARY KEY (`client_id`, `video_id`),
  KEY `fk_client_id_wl` (`client_id`),
  KEY `fk_video_id_wl` (`video_id`),
  CONSTRAINT `fk_client_id_wl` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_video_id_wl` FOREIGN KEY (`video_id`) REFERENCES `videos` (`video_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `watch_later` VALUES (1,1);
INSERT INTO `watch_later` VALUES (1,2);
INSERT INTO `watch_later` VALUES (1,3);
INSERT INTO `watch_later` VALUES (2,1);
INSERT INTO `watch_later` VALUES (2,5);


CREATE TABLE `comments` (
  `comment_id` int(11) NOT NULL auto_increment,
  `comment_string` varchar(50) NOT NULL,
  `client_id` int(11) NOT NULL,
  `video_id` int(11) NOT NULL,
  PRIMARY KEY (`comment_id`),
  KEY `fk_client_id_comm` (`client_id`),
  KEY `fk_video_id_comm` (`video_id`),
  CONSTRAINT `fk_client_id_comm` FOREIGN KEY (`client_id`) REFERENCES `clients` (`client_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_video_id_comm` FOREIGN KEY (`video_id`) REFERENCES `videos` (`video_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `comments` VALUES (1,"comment 1 on video 2 by user 1",1, 2);
INSERT INTO `comments` VALUES (2,"comment 2 on video 1 by user 2",2, 1);
INSERT INTO `comments` VALUES (3,"comment 3 on video 2 by user 1",1, 2);
INSERT INTO `comments` VALUES (4,"comment 4 on video 1 by user 2",2, 1);
INSERT INTO `comments` VALUES (5,"comment 5 on video 2 by user 1",1, 2);
INSERT INTO `comments` VALUES (6,"comment 6 on video 1 by user 2",2, 1);



CREATE TABLE `admin` (
  `admin_id` int(11) NOT NULL AUTO_INCREMENT,
  `full_name` varchar(50) NOT NULL,
  `login_id` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `admin` VALUES (1, "admin 1", "admin1login", "admin1pwd");

CREATE TABLE `deleted_videos` (
  `video_id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `reason` varchar(50) NOT NULL,
  PRIMARY KEY (`video_id`),
  KEY `FK_video_id_del` (`video_id`),
  KEY `FK_admin_id_del` (`admin_id`),
  CONSTRAINT `FK_video_id_del` FOREIGN KEY (`video_id`) REFERENCES `videos` (`video_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_admin_id_del` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`admin_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `deleted_videos` VALUES (2, 1, "violating community standards");

CREATE TABLE `banned_users` (
  `client_id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `reason` varchar(50) NOT NULL,
  PRIMARY KEY (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
INSERT INTO `banned_users` VALUES (3, 1, "violating community standards");
