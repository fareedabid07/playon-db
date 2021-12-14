-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema play_on
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema play_on
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `play_on` DEFAULT CHARACTER SET utf8 ;
USE `play_on` ;

-- -----------------------------------------------------
-- Table `play_on`.`clients`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `play_on`.`clients` ;

CREATE TABLE IF NOT EXISTS `play_on`.`clients` (
  `client_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `num_subs` INT NOT NULL DEFAULT 0,
  `login_id` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`client_id`),
  UNIQUE INDEX `client_id_UNIQUE` (`client_id` ASC) VISIBLE,
  UNIQUE INDEX `loginid_UNIQUE` (`login_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `play_on`.`videos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `play_on`.`videos` ;

CREATE TABLE IF NOT EXISTS `play_on`.`videos` (
  `video_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(200) NOT NULL,
  `uploader_id` INT NOT NULL,
  `login_id` VARCHAR(45) NOT NULL,
  `num_likes` INT NOT NULL DEFAULT 0,
  `num_comments` INT NOT NULL DEFAULT 0,
  `upload_date` DATE NOT NULL,
  `filename` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`video_id`),
  UNIQUE INDEX `video_id_UNIQUE` (`video_id` ASC) VISIBLE,
  INDEX `client_id_idx` (`uploader_id` ASC) VISIBLE,
  CONSTRAINT `uploader_id`
    FOREIGN KEY (`uploader_id`)
    REFERENCES `play_on`.`clients` (`client_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `play_on`.`likes`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `play_on`.`likes` ;

CREATE TABLE IF NOT EXISTS `play_on`.`likes` (
  `video_id` INT NOT NULL,
  `client_id` INT NOT NULL,
  PRIMARY KEY (`video_id`, `client_id`),
  INDEX `client_id_idx` (`client_id` ASC) VISIBLE,
  CONSTRAINT `video_id_like`
    FOREIGN KEY (`video_id`)
    REFERENCES `play_on`.`videos` (`video_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `client_id_like`
    FOREIGN KEY (`client_id`)
    REFERENCES `play_on`.`clients` (`client_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `play_on`.`subscribers`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `play_on`.`subscribers` ;

CREATE TABLE IF NOT EXISTS `play_on`.`subscribers` (
  `client_id` INT NOT NULL,
  `subscriber_id` INT NOT NULL,
  PRIMARY KEY (`client_id`, `subscriber_id`),
  INDEX `subscriber_id_idx` (`subscriber_id` ASC) VISIBLE,
  CONSTRAINT `subscriber_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `play_on`.`clients` (`client_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `client_id_sub`
    FOREIGN KEY (`client_id`)
    REFERENCES `play_on`.`clients` (`client_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `play_on`.`admin`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `play_on`.`admin` ;

CREATE TABLE IF NOT EXISTS `play_on`.`admin` (
  `admin_id` INT NOT NULL AUTO_INCREMENT,
  `full_name` VARCHAR(45) NOT NULL,
  `login_id` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`admin_id`))
ENGINE = InnoDB;
INSERT INTO `admin` VALUES (1, "admin 1", "admin1login", "admin1pwd");

-- -----------------------------------------------------
-- Table `play_on`.`banned_users`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `play_on`.`banned_users` ;

CREATE TABLE IF NOT EXISTS `play_on`.`banned_users` (
  `client_id` INT NOT NULL,
  `admin_id` INT NOT NULL,
  PRIMARY KEY (`client_id`),
  INDEX `admin_id_idx` (`admin_id` ASC) VISIBLE,
  CONSTRAINT `admin_id`
    FOREIGN KEY (`admin_id`)
    REFERENCES `play_on`.`admin` (`admin_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `play_on`.`comments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `play_on`.`comments` ;

CREATE TABLE IF NOT EXISTS `play_on`.`comments` (
  `comment_id` INT NOT NULL AUTO_INCREMENT,
  `video_id` INT NOT NULL,
  `client_id` INT NOT NULL,
  `login_id` VARCHAR(45) NOT NULL,
  `content` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`comment_id`),
  INDEX `comment_id_idx` (`comment_id` ASC) VISIBLE,
  CONSTRAINT `video_id_comment`
    FOREIGN KEY (`video_id`)
    REFERENCES `play_on`.`videos` (`video_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `client_id_comment`
    FOREIGN KEY (`client_id`)
    REFERENCES `play_on`.`clients` (`client_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `play_on`.`deleted_videos`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `play_on`.`deleted_videos` ;

CREATE TABLE IF NOT EXISTS `play_on`.`deleted_videos` (
  `video_id` INT NOT NULL,
  `admin_id` INT NULL,
  `reason` VARCHAR(200) NOT NULL,
  PRIMARY KEY (`video_id`),
  INDEX `admin_id_idx` (`admin_id` ASC) VISIBLE,
  CONSTRAINT `admin_id_del`
    FOREIGN KEY (`admin_id`)
    REFERENCES `play_on`.`admin` (`admin_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;