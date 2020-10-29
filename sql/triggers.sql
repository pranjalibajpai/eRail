-- Trigger Before inserting in trains 
-- CHECKS FOR - Train is released within the specified dates
--            - Number Of COaches are positive & total number of coaches are not zero
--            - Checks If the same is train has been already released on the same date or not

CREATE TRIGGER `before_train_release` BEFORE INSERT ON `trains`
 FOR EACH ROW BEGIN
    DECLARE message VARCHAR(128) DEFAULT '';
    DECLARE t_number INT;
    DECLARE t_date DATE;
    DECLARE lower_bound DATE DEFAULT DATE_ADD(CURRENT_DATE(), INTERVAL 1 MONTH);
    DECLARE upper_bound DATE DEFAULT DATE_ADD(CURRENT_DATE(), INTERVAL 4 MONTH);
    DECLARE finished INT DEFAULT 0;
    DEClARE train_info CURSOR
    	FOR SELECT train_number, train_date FROM trains;
	DECLARE CONTINUE HANDLER 
    	FOR NOT FOUND SET finished = 1;

    IF NEW.train_date < CURRENT_DATE() THEN
    	SET message = CONCAT('Please select a date between ', lower_bound, ' and ', upper_bound);
    ELSEIF NEW.train_date < lower_bound THEN
    	SET message = CONCAT('It is too late for a train to be released! You are ', DATEDIFF(lower_bound, NEW.train_date), ' days late.' );
    ELSEIF NEW.train_date > upper_bound THEN
    	SET message = CONCAT('It is too early for the train to be released! Try Again after ', 		DATEDIFF(NEW.train_date, upper_bound), ' Days');
     END IF;
    
    
    IF NEW.num_ac_coach < 0 OR NEW.num_sleeper_coach < 0 THEN
    SET message = (message, CHAR(13), 'Enter valid number of coaches');
    ELSEIF NEW.num_ac_coach + NEW.num_sleeper_coach = 0 THEN
    SET message = CONCAT(message, CHAR(13), 'There is no coach in the train');
    
    END IF;
    
	OPEN train_info;

	get_info: LOOP
		FETCH train_info INTO t_number, t_date;
		IF finished = 1 THEN 
			LEAVE get_info;
		END IF;
        IF t_number = NEW.train_number AND
           t_date = NEW.train_date THEN
        	SET message = CONCAT(message, '\nTrain number ', NEW.train_number, ' has been already released for ', NEW.train_date);
        END IF;
 
	END LOOP get_info;
   
	CLOSE train_info;

    IF message != '' THEN
    	SIGNAL SQLSTATE '45000' 
    	SET MESSAGE_TEXT = message;
    END IF;
END