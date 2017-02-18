CREATE DATABASE IF NOT EXISTS BucketList;

CREATE TABLE IF NOT EXISTS `BucketList`.`tbl_user` (
	`user_id` BIGINT NULL AUTO_INCREMENT,
	`user_name` VARCHAR(45) NULL,
	`user_username` VARCHAR(45) NULL,
	`user_password` VARCHAR(160) NULL,
	PRIMARY KEY (`user_id`));

use BucketList;
DROP procedure IF EXISTS `BucketList`.`sp_createUser`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_createUser` (
	IN p_name VARCHAR(20),
	IN p_username VARCHAR(20),
	IN p_password VARCHAR(160)
)
BEGIN
	if (select exists (select 1 from tbl_user where user_username = p_username)) THEN
		select 'Username Exists!!';
	else
		insert into tbl_user
		(
			user_name,
			user_username,
			user_password
		)
		values
		(
			p_name,
			p_username,
			p_password
		);
	end if;
END$$
DELIMITER ;

use BucketList;
DROP procedure IF EXISTS `BucketList`.`sp_validateLogin`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_validateLogin` (
IN p_username VARCHAR(20)
)
BEGIN
	select * from tbl_user where user_username = p_username;
END$$
DELIMITER ;

use BucketList;
CREATE TABLE IF NOT EXISTS `tbl_wish` (
	`wish_id` int(11) NOT NULL AUTO_INCREMENT,
	`wish_title` VARCHAR(45) DEFAULT NULL,
	`wish_description` VARCHAR(5000) DEFAULT NULL,
	`wish_user_id` int(11) DEFAULT NULL,
	`wish_date` datetime DEFAULT NULL,
	`wish_file_path` VARCHAR(200) NULL,
	`wish_accomplished` INT NULL DEFAULT 0,
	`wish_private` INT NULL DEFAULT 0,
	PRIMARY KEY (`wish_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

use BucketList;
DROP procedure IF EXISTS `BucketList`.`sp_addWish`;

DELIMITER $$
USE `BucketList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addWish` (
	IN p_title VARCHAR(45),
	IN p_description VARCHAR(1000),
	In p_user_id BIGINT,
	IN p_file_path varchar(200),
	IN p_is_private int,
	IN p_is_done int
)
BEGIN
	insert into tbl_wish(
		wish_title,
		wish_description,
		wish_user_id,
		wish_date,
		wish_file_path,
		wish_private,
		wish_accomplished
	)
	values
	(
		p_title,
		p_description,
		p_user_id,
		NOW(),
		p_file_path,
		p_is_private,
		p_is_done
	);
END$$

DELIMITER ;

use BucketList;
DROP procedure IF EXISTS `sp_GetWishByUser`;

DELIMITER $$
use `BucketList`$$
CREATE PROCEDURE `sp_GetWishByUser` (
IN p_user_id bigint,
IN p_limit int,
IN p_offset int,
OUT p_total bigint
)
BEGIN
	select count(*) into p_total from tbl_wish where wish_user_id = p_user_id;

	set @t1 = CONCAT( 'select * from tbl_wish where wish_user_id = ', p_user_id, ' order by wish_date desc limit ', p_limit, ' offset ', p_offset);
	prepare stmt from @t1;
	execute stmt;
	deallocate prepare stmt;
END $$

DELIMITER ;

use BucketList;
DROP procedure IF EXISTS `BucketList`.`sp_GetWishById`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetWishById` (
IN p_wish_id bigint,
IN p_user_id bigint
)
BEGIN
	select wish_id,wish_title,wish_description,wish_file_path,wish_private,wish_accomplished from tbl_wish where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$

DELIMITER ;

use BucketList;
DROP procedure IF EXISTS `BucketList`.`sp_updateWish`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_updateWish` (
IN p_title varchar(45),
IN p_description varchar(1000),
IN p_wish_id bigint,
IN p_user_id bigint,
IN p_file_path varchar(200),
IN p_is_private int,
IN p_is_done int
)
BEGIN
	update tbl_wish set wish_title = p_title, wish_description = p_description, wish_file_path = p_file_path, wish_private = p_is_private, wish_accomplished = p_is_done where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$
DELIMITER ;

DELIMITER $$
DROP procedure IF EXISTS `BucketList`.`sp_deleteWish`;
use `BucketList`$$
CREATE PROCEDURE `sp_deleteWish` (
IN p_wish_id bigint,
IN p_user_id bigint
)
BEGIN
	delete from tbl_wish where wish_id = p_wish_id and wish_user_id = p_user_id;
END$$
DELIMITER ;

use BucketList;
drop procedure if exists `sp_GetAllWishes`;
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_GetAllWishes` (
	IN p_limit int,
	IN p_offset int,
	OUT p_total bigint
)
BEGIN
	select count(*) into p_total from tbl_wish where wish_private = 0;

	set @t1 = CONCAT( 'select wish_id,wish_title,wish_description,wish_file_path from tbl_wish where wish_private = ', 0, ' order by wish_date desc limit ', p_limit, ' offset ', p_offset);
	prepare stmt from @t1;
	execute stmt;
	deallocate prepare stmt;
END$$

DELIMITER ;
