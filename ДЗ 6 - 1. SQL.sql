-- создаём базу данных
DROP DATABASE IF EXISTS seminar_6;
CREATE DATABASE seminar_6;
USE seminar_6;

-- Задание 1.
-- Создайте функцию, которая принимает кол-во сек и форматирует их в кол-во дней часов.
-- Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '

DROP FUNCTION IF EXISTS times;
DELIMITER //
CREATE FUNCTION times
	(all_time_in_seconds INT)
    RETURNS VARCHAR(45)
    DETERMINISTIC

	BEGIN
		DECLARE seconds TINYINT;
        DECLARE minutes TINYINT;
		DECLARE hours TINYINT;
		DECLARE days INT;
	
		SET seconds = all_time_in_seconds % 60;
        SET minutes = all_time_in_seconds DIV 60 % 60;
        SET hours = all_time_in_seconds DIV (60 * 60) % 24;
        SET days = all_time_in_seconds DIV (60 * 60 * 24);
        
        RETURN CONCAT(days, ' days ', hours, ' hours ', minutes, ' minuts ', seconds, ' seconds');

    END //
 DELIMITER ;
   
SELECT seminar_6.times(123456);