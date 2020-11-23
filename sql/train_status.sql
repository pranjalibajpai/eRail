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
-- Table structure for table `train_status`
--

CREATE TABLE `train_status` (
  `t_number` int(11) NOT NULL,
  `t_date` date NOT NULL,
  `seats_b_ac` int(11) NOT NULL,
  `seats_b_sleeper` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `train_status`
--
DELIMITER $$
CREATE TRIGGER `check_booked_seats` BEFORE UPDATE ON `train_status` FOR EACH ROW BEGIN
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
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `train_status`
--
ALTER TABLE `train_status`
  ADD PRIMARY KEY (`t_number`,`t_date`),
  ADD KEY `t_number` (`t_number`),
  ADD KEY `t_date` (`t_date`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `train_status`
--
ALTER TABLE `train_status`
  ADD CONSTRAINT `train_status_ibfk_1` FOREIGN KEY (`t_number`,`t_date`) REFERENCES `train` (`t_number`, `t_date`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
