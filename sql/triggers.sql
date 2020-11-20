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
