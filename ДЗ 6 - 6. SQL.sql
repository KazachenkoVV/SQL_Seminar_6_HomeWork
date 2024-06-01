USE seminar_4;
-- Задание 6
-- Создайте таблицу logs типа Archive.
-- Пусть при каждом создании записи в таблицах users, communities и messages
-- в таблицу logs помещается время и дата создания записи, название таблицы,
-- идентификатор первичного ключа. (Триггеры)

CREATE TABLE log_insert_social_network
(
    id_log BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    table_names VARCHAR(11),
    id_table BIGINT UNSIGNED
) ENGINE=ARCHIVE;

DELIMITER //
CREATE TRIGGER after_insert_in_users
AFTER INSERT ON users
FOR EACH ROW
BEGIN
	INSERT INTO log_insert_social_network
    (table_names, id_table)
    VALUES ('users', NEW.id);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_insert_in_communities
AFTER INSERT ON communities
FOR EACH ROW
BEGIN
	INSERT INTO log_insert_social_network
    (table_names, id_table)
    VALUES ('communities', NEW.id);
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_insert_in_messages
AFTER INSERT ON messages
FOR EACH ROW
BEGIN
	INSERT INTO log_insert_social_network
    (table_names, id_table)
    VALUES ('messages', NEW.id);
END //
DELIMITER ;

-- Ввод сторк для проверки работы триггеров
INSERT INTO users
(firstname, lastname, email)
VALUES ('Иван', 'Петров', 'upetrova@pisem.net');

INSERT INTO communities
(name)
VALUES ('beatniks');

INSERT INTO messages
(from_user_id, to_user_id, body)
VALUES (7, 4, 'прЮвет, Волку!');

-- Появились записи в логе?
SELECT * FROM log_insert_social_network;

