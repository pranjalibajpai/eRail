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
CREATE DEFINER=`root`@`localhost` PROCEDURE `check_valid_train`(IN `num` INT(11), IN `date` DATE)
    NO SQL
BEGIN
	DECLARE n INT;
	DECLARE d DATE;
    DECLARE m1 VARCHAR(128) DEFAULT '';
    DECLARE m2 VARCHAR(128) DEFAULT '';
    DECLARE finished INT DEFAULT 0;
	DEClARE train_info CURSOR
    	FOR SELECT t_number, t_date FROM train;
	DECLARE CONTINUE HANDLER 
    	FOR NOT FOUND SET finished = 1;
    
    IF date < CURRENT_DATE() THEN
    	SET m1 = 'Please enter valid date';
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
        END IF;
    ELSEIF type like 'sleeper' THEN
    	IF avail_s = 0 THEN
        	SET m1 = CONCAT('No Sleeper Coach is available in Train- ', tnum, ' Dated- ', tdate);
        ELSEIF avail_s*24 = book_s THEN
        	SET m1 = CONCAT('Sleeper Coaches of Train- ', tnum, ' Dated- ', tdate, ' are already booked!');
        END IF;
    END IF;
    
    IF m1 not like '' THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = m1;
    END IF;
END$$
DELIMITER ;
