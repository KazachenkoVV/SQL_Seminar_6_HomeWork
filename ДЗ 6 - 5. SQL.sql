USE seminar_4;

-- Задание 5.
-- Создайте хранимую функцию hello(), которая будет возвращать приветствие,
-- в зависимости от текущего времени суток.
-- С 6:00  до 12:00 функция должна возвращать фразу "Доброе утро",
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
-- с 18:00 до 00:00               —                 "Добрый вечер",
-- с 00:00 до 6:00                —                 "Доброй ночи".

DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello ()
    RETURNS VARCHAR(12)
    DETERMINISTIC

BEGIN
	DECLARE greeting VARCHAR(12);
    SET greeting = CASE
			WHEN CURTIME() >= '00:00:00' AND CURTIME() < '06:00:00' THEN 'Доброй ночи' -- Начинать с нуля! Дабы избежать неприятностей...
            WHEN CURTIME() >= '06:00:00' AND CURTIME() < '12:00:00' THEN 'Доброе утро'
            WHEN CURTIME() >= '12:00:00' AND CURTIME() < '18:00:00' THEN 'Добрый день'
            ELSE 'Добрый вечер'
		END;
	RETURN greeting;
END //
DELIMITER ;

select hello();    