-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 23, 2020 at 06:20 PM
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
-- Table structure for table `passenger`
--

CREATE TABLE `passenger` (
  `name` varchar(50) NOT NULL,
  `age` int(11) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `pnr_no` varchar(12) NOT NULL,
  `berth_no` int(11) NOT NULL,
  `berth_type` varchar(10) NOT NULL,
  `coach_no` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `passenger`
--
DELIMITER $$
CREATE TRIGGER `before_berth_assign` BEFORE INSERT ON `passenger` FOR EACH ROW BEGIN
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
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `passenger`
--
ALTER TABLE `passenger`
  ADD PRIMARY KEY (`pnr_no`,`berth_no`,`coach_no`),
  ADD KEY `pnr_no` (`pnr_no`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `passenger`
--
ALTER TABLE `passenger`
  ADD CONSTRAINT `passenger_ibfk_1` FOREIGN KEY (`pnr_no`) REFERENCES `ticket` (`pnr_no`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
