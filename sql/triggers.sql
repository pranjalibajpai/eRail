-- Trigger Before inserting in trains 
-- CHECKS FOR - Train is released within the specified dates
--            - Number Of COaches are positive & total number of coaches are not zero
--            - Checks If the same is train has been already released on the same date or not
CREATE TRIGGER `before_train_release` BEFORE INSERT ON `train`
 FOR EACH ROW BEGIN
    DECLARE message VARCHAR(128) DEFAULT '';
    DECLARE train_number INT;
    DECLARE train_date DATE;
    DECLARE lower_bound DATE DEFAULT DATE_ADD(CURRENT_DATE(), INTERVAL 1 MONTH);
    DECLARE upper_bound DATE DEFAULT DATE_ADD(CURRENT_DATE(), INTERVAL 4 MONTH);
    DECLARE finished INT DEFAULT 0;
    DEClARE train_info CURSOR
    	FOR SELECT t_number, t_date FROM train;
	DECLARE CONTINUE HANDLER 
    	FOR NOT FOUND SET finished = 1;

    IF NEW.t_date < CURRENT_DATE() THEN
    	SET message = CONCAT('Please select a date between ', lower_bound, ' and ', upper_bound);
    ELSEIF NEW.t_date < lower_bound THEN
    	SET message = CONCAT('It is too late for a train to be released! You are ', DATEDIFF(lower_bound, NEW.t_date), ' days late.' );
    ELSEIF NEW.t_date > upper_bound THEN
    	SET message = CONCAT('It is too early for the train to be released! Try Again after ', DATEDIFF(NEW.t_date, upper_bound), ' Days');
    END IF;
    
    IF message != '' THEN
        SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = message;
    END IF;

    IF NEW.num_ac < 0 OR NEW.num_sleeper < 0 THEN
    SET message = (message, CHAR(13), 'Enter valid number of coaches');
    ELSEIF NEW.num_ac + NEW.num_sleeper = 0 THEN
    SET message = CONCAT(message, CHAR(13), 'There is no coach in the train');
    END IF;

    IF message != '' THEN
        SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = message;
    END IF;
    
	OPEN train_info;

	get_info: LOOP
		FETCH train_info INTO train_number, train_date;
		IF finished = 1 THEN 
			LEAVE get_info;
		END IF;
        IF train_number = NEW.t_number AND
           train_date = NEW.t_date THEN
        	SET message = CONCAT(message, '\nTrain number ', NEW.t_number, ' has been already released for ', NEW.t_date);
        END IF;
 
	END LOOP get_info;
   
	CLOSE train_info;

    IF message != '' THEN
    	SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = message;
    END IF;
END

-- Trigger Before Updating seats booked in train_status

CREATE TRIGGER `check_booked_seats` BEFORE UPDATE ON `train_status`
 FOR EACH ROW BEGIN
	DECLARE msg varchar(255) DEFAULT '';
    DECLARE avail_a INT;
    DECLARE avail_s INT;
    
    SELECT num_ac, num_sleeper
    FROM train
    WHERE t_number = OLD.t_number AND t_date = OLD.t_date
    INTO avail_a, avail_s;
    
	IF NEW.seats_b_ac > avail_a*18 THEN
    	SET msg = CONCAT(msg, ' Sufficient Seats are not available in AC Coach of Train no ', NEW.t_number, ' Dated ', NEW.t_date);
    END IF;
    IF NEW.seats_b_sleeper > avail_s*24 THEN
    	SET msg = CONCAT(msg, ' Sufficient Seats are not available in Sleeper Coach of Train no ', NEW.t_number, ' Dated ', NEW.t_date);
    END IF;

    IF msg != '' THEN
    	SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = msg;
    END IF;
END

-- Trigger TO Prevent Update Of Ticket Details
CREATE TRIGGER `check_ticket_update` BEFORE UPDATE ON `ticket`
 FOR EACH ROW BEGIN
	IF NEW.pnr_no != OLD.pnr_no OR NEW.coach != OLD.coach THEN
    	SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = 'Ticket details cannot be updated';
    END IF;
END

-- Trigger To Prevent Booking Of Same berth for same train coach same date 
CREATE TRIGGER `before_berth_assign` BEFORE INSERT ON `passenger`
 FOR EACH ROW BEGIN
    DECLARE msg VARCHAR(255) DEFAULT '';
    DECLARE finished INT DEFAULT 0;
    DECLARE tnum INT;
    DECLARE tdate DATE;
    DECLARE c1 VARCHAR(50);
    DECLARE bno INT;
    DECLARE cno INT;
    DECLARE t_no INT;
    DECLARE t_d INT;
    DECLARE c2 VARCHAR(50);
	DECLARE p_info CURSOR FOR
        SELECT t_number, t_date, berth_no, coach_no, coach
        FROM passenger, ticket
        WHERE passenger.pnr_no = ticket.pnr_no;
	DECLARE CONTINUE HANDLER 
    	FOR NOT FOUND SET finished = 1;
        
    SELECT t_number, t_date, coach 
    FROM ticket
    WHERE pnr_no = NEW.pnr_no
    INTO t_no, t_d, c1;
    
    OPEN p_info;
	get_info: LOOP
		FETCH p_info INTO tnum, tdate, bno, cno, c2;
		IF finished = 1 THEN 
			LEAVE get_info;
		END IF;
        IF tnum = t_no AND tdate = t_d AND bno = NEW.berth_no AND cno = NEW.coach_no AND c1 = c2 THEN
        	SET msg = 'Found';
        END IF;
	END LOOP get_info;
	CLOSE p_info;
    
    IF msg not like '' THEN
		SIGNAL SQLSTATE '45000'
    	SET MESSAGE_TEXT = 'This seat has been booked already';
    END IF;
END