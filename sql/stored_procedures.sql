-- CHECK EMAIL ID ALREADY REGISTERED OR NOT
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_email_registered`(IN `in_email` VARCHAR(50))
    NO SQL
BEGIN
	DECLARE email_id VARCHAR(50);
    DECLARE message VARCHAR(128) DEFAULT '';
    DECLARE finished INT DEFAULT 0;
	DEClARE user_email CURSOR
    	FOR SELECT email FROM user;
	DECLARE CONTINUE HANDLER 
    	FOR NOT FOUND SET finished = 1;
        
    OPEN user_email;

	get_email: LOOP
		FETCH user_email INTO email_id;
		IF finished = 1 THEN 
			LEAVE get_email;
		END IF;
        IF email_id = in_email THEN
        	SET message = 'Email id already registered';
        END IF;
 
	END LOOP get_email;
	CLOSE user_email;
    
    IF message != '' THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = message;
    END IF;
END$$
DELIMITER ;
-- CHECK USERNAME ALREADY TAKEN OR NOT
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_username_registered`(IN `in_username` VARCHAR(10))
    NO SQL
BEGIN
	DECLARE name VARCHAR(10);
    DECLARE message VARCHAR(128) DEFAULT '';
    DECLARE finished INT DEFAULT 0;
	DEClARE user_name CURSOR
    	FOR SELECT username FROM user;
	DECLARE CONTINUE HANDLER 
    	FOR NOT FOUND SET finished = 1;
        
    OPEN user_name;

	get_name: LOOP
		FETCH user_name INTO name;
		IF finished = 1 THEN 
			LEAVE get_name;
		END IF;
        IF name = in_username THEN
        	SET message = 'Username already taken';
        END IF;
 
	END LOOP get_name;
	CLOSE user_name;
    
    IF message != '' THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = message;
    END IF;
END$$
DELIMITER ;

-- CHECK ADMIN CREDENTIALS DURING LOGIN
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_admin_credentials`(IN `n` VARCHAR(10), IN `p` VARCHAR(50))
    NO SQL
BEGIN
	DECLARE name VARCHAR(10);
	DECLARE pass VARCHAR(50);
    DECLARE message VARCHAR(128) DEFAULT '';
    DECLARE finished INT DEFAULT 0;
	DEClARE user_info CURSOR
    	FOR SELECT * FROM admin;
	DECLARE CONTINUE HANDLER 
    	FOR NOT FOUND SET finished = 1;
        
    OPEN user_info;

	get_info: LOOP
		FETCH user_info INTO name, pass;
		IF finished = 1 THEN 
			LEAVE get_info;
		END IF;
        IF name = n AND pass = p THEN
        	SET message = 'Found';
        END IF;
 
	END LOOP get_info;
	CLOSE user_info;
    
    IF message like '' THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'Invalid Username or Password';
    END IF;
END$$
DELIMITER ;

--CHECK USER CREDENTIALS DURING LOGIN
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_user_credentials`(IN `n` VARCHAR(10), IN `p` VARCHAR(50))
    NO SQL
BEGIN
	DECLARE name VARCHAR(10);
	DECLARE pass VARCHAR(50);
    DECLARE message VARCHAR(128) DEFAULT '';
    DECLARE finished INT DEFAULT 0;
	DEClARE user_info CURSOR
    	FOR SELECT username, password FROM user;
	DECLARE CONTINUE HANDLER 
    	FOR NOT FOUND SET finished = 1;
        
    OPEN user_info;

	get_info: LOOP
		FETCH user_info INTO name, pass;
		IF finished = 1 THEN 
			LEAVE get_info;
		END IF;
        IF name = n AND pass = p THEN
        	SET message = 'Found';
        END IF;
 
	END LOOP get_info;
	CLOSE user_info;
    
    IF message like '' THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'Invalid Username or Password';
    END IF;
END$$
DELIMITER ;

-- CHECK VALIDITY OF TRAIN NUMBER & DATE
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_train_details`(IN `num` INT(11), IN `date` DATE)
    NO SQL
BEGIN
	DECLARE n INT;
	DECLARE d DATE;
    DECLARE m1 VARCHAR(128) DEFAULT '';
    DECLARE m2 VARCHAR(128) DEFAULT '';
    DECLARE finished INT DEFAULT 0;
    DECLARE upper_bound DATE DEFAULT DATE_ADD(CURRENT_DATE(), INTERVAL 2 MONTH);
	DEClARE train_info CURSOR
    	FOR SELECT t_number, t_date FROM train;
	DECLARE CONTINUE HANDLER 
    	FOR NOT FOUND SET finished = 1;
    
    IF date < CURRENT_DATE() THEN
    	SET m1 = 'Please enter valid date';
    ELSEIF date > upper_bound THEN
    	SET m1 = 'Train can be booked atmost 2 months in advance';
    END IF;
    
    OPEN train_info;

	get_info: LOOP
		FETCH train_info INTO n, d;
		IF finished = 1 THEN 
			LEAVE get_info;
		END IF;
        IF num = n AND date = d THEN
        	SET m2 = 'Found';
        END IF;
 
	END LOOP get_info;
	CLOSE train_info;
    
    IF m1 not like '' THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = m1;
    ELSEIF m2 like '' THEN
    	SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'Train not yet released!';
    END IF;
END$$
DELIMITER ;

-- CHECK SEATS ARE AVAILABLE
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_seats_availabilty`(IN `tnum` INT, IN `tdate` DATE, IN `type` VARCHAR(50), IN `num_p` INT)
    NO SQL
BEGIN
	DECLARE avail_a INT;
    DECLARE avail_s INT;
    DECLARE book_a INT;
    DECLARE book_s INT;
    DECLARE m1 VARCHAR(128) DEFAULT '';
    DECLARE m2 VARCHAR(128) DEFAULT '';
  
    SELECT num_ac, num_sleeper, seats_b_ac, seats_b_sleeper
    FROM train
    WHERE t_number = tnum AND t_date = tdate
    INTO avail_a, avail_s, book_a, book_s;
    
    IF type like 'ac' THEN
    	IF avail_a = 0 THEN
        	SET m1 = CONCAT('No AC Coach is available in Train- ', tnum, ' Dated- ', tdate);
        ELSEIF avail_a*18 = book_a THEN
        	SET m1 = CONCAT('AC Coaches of Train- ', tnum, ' Dated- ', tdate, ' are already booked!');
        ELSEIF avail_a*18 < book_a + num_p THEN
        	SET m1 = CONCAT('AC Coach of Train- ', tnum, ' Dated- ', tdate, ' has only ' , avail_a*18-book_a, ' seats available!'); 
        END IF;
    ELSEIF type like 'sleeper' THEN
    	IF avail_s = 0 THEN
        	SET m1 = CONCAT('No Sleeper Coach is available in Train- ', tnum, ' Dated- ', tdate);
        ELSEIF avail_s*24 = book_s THEN
        	SET m1 = CONCAT('Sleeper Coaches of Train- ', tnum, ' Dated- ', tdate, ' are already booked!');
        ELSEIF avail_s*24 < book_s + num_p THEN
        	SET m1 = CONCAT('Sleeper Coach of Train- ', tnum, ' Dated- ', tdate, ' has only ' , avail_s*18-book_s, ' seats available!'); 
        END IF;
    END IF;
    
    IF m1 not like '' THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = m1;
    END IF;
END$$
DELIMITER ;

-- GENERATE PNR & INSERT INTO ticket TABLE
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generate_pnr`(IN `u_name` VARCHAR(50), OUT `pnr_no` VARCHAR(12), IN `coach` VARCHAR(50), IN `t_number` INT, IN `t_date` DATE)
    NO SQL
BEGIN
	DECLARE p1 INT;
    DECLARE p2 INT;
    DECLARE p3 INT;
    SET p1 = LPAD(cast(conv(substring(md5(u_name), 1, 16), 16, 10)%1000 as unsigned integer), 3, '0');
    SET p2 = LPAD(FLOOR(RAND() * 999999.99), 3, '0');
    SET p3 = LPAD(cast(conv(substring(md5(CURRENT_TIMESTAMP()), 1, 16), 16, 10)%10000 as unsigned integer), 4, '0');
    SET pnr_no = RPAD(CONCAT(p1, '-', p2, '-', p3), 12, '0');
 	INSERT INTO ticket
    VALUES(pnr_no, coach, u_name, t_number, t_date);
END$$
DELIMITER ;

-- ASSIGN BERTH NO, COACH NO & BERTH TYPE + INSERT IN passenger + UPDATE IN train 
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `assign_berth`(IN `tnum` INT, IN `tdate` DATE, IN `tcoach` VARCHAR(50), IN `name` VARCHAR(50), IN `age` INT, IN `gender` VARCHAR(50), IN `pnr_no` VARCHAR(12))
    NO SQL
BEGIN
	DECLARE bseats INT;
    DECLARE tseats INT;
    DECLARE berth_no INT;
    DECLARE coach_no INT;
    DECLARE berth_type VARCHAR(10);
    DECLARE msg varchar(250) DEFAULT '';
    
	-- update
    IF tcoach like 'ac' THEN
        UPDATE train
        SET seats_b_ac = seats_b_ac + 1
        WHERE t_number = tnum AND t_date = tdate;
    ELSE
        UPDATE train
        SET seats_b_sleeper = seats_b_sleeper + 1
        WHERE t_number = tnum AND t_date = tdate;
    END IF;
    
    IF tcoach like 'ac' THEN
        SET tseats = 18;
        SELECT seats_b_ac
        FROM train 
        WHERE t_number = tnum AND t_date = tdate
        INTO bseats;
    ELSE 
        SET tseats = 24;
        SELECT seats_b_sleeper
        FROM train 
        WHERE t_number = tnum AND t_date = tdate
        INTO bseats;
    END IF;
    
    -- berth_no & coach_no
    IF bseats % tseats = 0 THEN
        SET coach_no = bseats/tseats;
        SET berth_no = tseats;
    ELSE
        SET coach_no = floor(bseats/tseats) + 1;
        SET berth_no = bseats%tseats;
    END IF;
	
    -- berth_type
    IF tcoach like 'ac' THEN
    	CASE berth_no % 6
            WHEN 1 THEN
               SET berth_type = 'LB';
            WHEN 2 THEN
               SET berth_type = 'LB';
            WHEN 3 THEN
               SET berth_type = 'UB';
            WHEN 4 THEN
               SET berth_type = 'UB';
            WHEN 5 THEN
               SET berth_type = 'SL';
            WHEN 0 THEN
               SET berth_type = 'SU';
		END CASE;
    ELSE
    	CASE berth_no % 8
            WHEN 1 THEN
               SET berth_type = 'LB';
            WHEN 2 THEN
               SET berth_type = 'MB';
            WHEN 3 THEN
               SET berth_type = 'UB';
            WHEN 4 THEN
               SET berth_type = 'LB';
            WHEN 5 THEN
               SET berth_type = 'MB';
            WHEN 6 THEN
               SET berth_type = 'UB';
            WHEN 7 THEN
               SET berth_type = 'SL';
            WHEN 0 THEN
               SET berth_type = 'SU';
		END CASE;
    END IF;
   
    -- insert
    INSERT INTO passenger 
    VALUES(name, age, gender, pnr_no, berth_no, berth_type, coach_no);
   
END$$
DELIMITER ;


-- CHECK VALID PNR
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_valid_pnr`(IN `pnr` VARCHAR(12))
    NO SQL
BEGIN
	DECLARE msg VARCHAR(255) DEFAULT '';
    DECLARE p VARCHAR(12);
	DECLARE finished INT DEFAULT 0;
	DEClARE ticket_info CURSOR
    	FOR SELECT pnr_no FROM ticket;
	DECLARE CONTINUE HANDLER 
    	FOR NOT FOUND SET finished = 1;
        
    OPEN ticket_info;
	get_info: LOOP
		FETCH ticket_info INTO p;
		IF finished = 1 THEN 
			LEAVE get_info;
		END IF;
        IF p like pnr THEN
        	SET msg = 'Found';
        END IF;
	END LOOP get_info;
	CLOSE ticket_info;
    
    IF msg like '' THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'Please enter vaild PNR Number';
    END IF;
END$$
DELIMITER ;