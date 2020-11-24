DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `assign_berth` (IN `tnum` INT, IN `tdate` DATE, IN `tcoach` VARCHAR(50), IN `name` VARCHAR(50), IN `age` INT, IN `gender` VARCHAR(50), IN `pnr_no` VARCHAR(12))  NO SQL
BEGIN
	DECLARE bseats INT;
    DECLARE tseats INT;
    DECLARE berth_no INT;
    DECLARE coach_no INT;
    DECLARE berth_type VARCHAR(10);
    DECLARE msg varchar(250) DEFAULT '';
    
     -- update train_status
    IF tcoach like 'ac' THEN
        UPDATE train_status
        SET seats_b_ac = seats_b_ac + 1
        WHERE t_number = tnum AND t_date = tdate;
    ELSE
        UPDATE train_status
        SET seats_b_sleeper = seats_b_sleeper + 1
        WHERE t_number = tnum AND t_date = tdate;
    END IF;
    IF tcoach like 'ac' THEN
        SET tseats = 18;
        SELECT seats_b_ac
        FROM train_status 
        WHERE t_number = tnum AND t_date = tdate
        INTO bseats;
    ELSE 
        SET tseats = 24;
        SELECT seats_b_sleeper
        FROM train_status
        WHERE t_number = tnum AND t_date = tdate
        INTO bseats;
    END IF;
    
    -- find berth_no & coach_no
    IF bseats % tseats = 0 THEN
        SET coach_no = bseats/tseats;
        SET berth_no = tseats;
    ELSE
        SET coach_no = floor(bseats/tseats) + 1;
        SET berth_no = bseats%tseats;
    END IF;
	
    -- find berth_type
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
   
    -- insert into passenger
    INSERT INTO passenger 
    VALUES(name, age, gender, pnr_no, berth_no, berth_type, coach_no);
    
END$$
DELIMITER;