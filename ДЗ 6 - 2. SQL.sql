USE seminar_6;

-- 2. Выведите только чётные числа от 1 до 10.
-- Пример: 2,4,6,8,10
DROP PROCEDURE IF EXISTS even_numbers;
DELIMITER &&
CREATE PROCEDURE even_numbers
(
	IN input_number INT
)
BEGIN
	DECLARE n INT;
    DECLARE result VARCHAR(100) DEFAULT '';
    SET n = input_number;
    IF n > 71 THEN
		SET result = 'Превышено максимальное значение!';
    ELSE
		IF n % 2 != 0 THEN
			SET n = n - 1;
		END IF;
		WHILE n > 0 DO
			SET result = CONCAT_WS (' ', n, result);
			SET n = n - 2;
		END WHILE;
	END IF;
    SELECT RTRIM(result) AS 'Even numbers';
-- END ;
END $$
DELIMITER ;

CALL even_numbers(25);