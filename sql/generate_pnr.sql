DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_pnr` (IN `u_name` VARCHAR(50), OUT `pnr_no` VARCHAR(12), IN `coach` VARCHAR(50), IN `t_number` INT, IN `t_date` DATE)  NO SQL
BEGIN
	DECLARE p1 INT;
    DECLARE p2 INT;
    DECLARE p3 INT;
    -- find 3 digit number for username
    SET p1 = LPAD(cast(conv(substring(md5(u_name), 1, 16), 16, 10)%1000 as unsigned integer), 3, '0');
    -- randomly generated 3 digit number
    SET p2 = LPAD(FLOOR(RAND() * 999999.99), 3, '0');
    -- find 4 digit number for Current Timestamp
    SET p3 = LPAD(cast(conv(substring(md5(CURRENT_TIMESTAMP()), 1, 16), 16, 10)%10000 as unsigned integer), 4, '0');
    -- concatenate all three to get PNR
    SET pnr_no = RPAD(CONCAT(p1, '-', p2, '-', p3), 12, '0');
 	INSERT INTO ticket
    VALUES(pnr_no, coach, u_name, CURRENT_TIMESTAMP(), t_number, t_date);
END$$