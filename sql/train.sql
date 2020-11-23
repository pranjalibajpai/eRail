-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 23, 2020 at 06:21 PM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.4.11

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `rdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `train`
--

CREATE TABLE `train` (
  `t_number` int(11) NOT NULL,
  `t_date` date NOT NULL,
  `num_ac` int(11) NOT NULL,
  `num_sleeper` int(11) NOT NULL,
  `released_by` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `train`
--
DELIMITER $$
CREATE TRIGGER `before_train_release` BEFORE INSERT ON `train` FOR EACH ROW BEGIN
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
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `train`
--
ALTER TABLE `train`
  ADD PRIMARY KEY (`t_number`,`t_date`),
  ADD KEY `released_by` (`released_by`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `train`
--
ALTER TABLE `train`
  ADD CONSTRAINT `train_ibfk_1` FOREIGN KEY (`released_by`) REFERENCES `admin` (`username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
