-- Задание 4.
-- Создать функцию, вычисляющую коэффициент популярности пользователя (по количеству друзей)
-- Select friends.id, fritnds.firstname, fritnds.lastname, COUNT(fritnds.friend)

DROP FUNCTION IF EXISTS rank_frand;
DELIMITER //
CREATE FUNCTION rank_frand
	(id_user INT)
    RETURNS INT
    DETERMINISTIC
BEGIN
	DECLARE result INT;
    
	WITH rang_of_users AS
    (
		Select
		DENSE_RANK() OVER(ORDER BY COUNT(friend) DESC) AS rank_pop,
		fr.id, fr.firstname, fr.lastname, COUNT(friend) AS friends
		FROM
		(
			SELECT u.id, u.firstname, u.lastname, f.target_user_id AS friend
			FROM users u
			LEFT JOIN friend_requests f ON u.id = f.initiator_user_id AND f.status = 'approved'
			UNION ALL
			SELECT u.id, u.firstname, u.lastname, f.initiator_user_id AS friend
			FROM users u
			LEFT JOIN friend_requests f ON u.id = f.target_user_id AND f.status = 'approved'
		) AS fr
		GROUP BY fr.id, fr.firstname, fr.lastname
		ORDER BY rank_pop
    )
    SELECT rank_pop INTO result
    FROM rang_of_users
    WHERE id = id_user;
    
    RETURN result;
    
END //
DELIMITER ;

-- Демонстрация работы функции
SELECT firstname, lastname, rank_frand(id) AS 'Коэффициент популярности'
FROM users
ORDER BY rank_frand(id);

-- Скрипт для проверки
/*
Select
	DENSE_RANK() OVER(ORDER BY COUNT(friend) DESC) AS rank_pop,
	fr.id,
    fr.firstname,
    fr.lastname,
    COUNT(friend) AS friends
FROM
(
	SELECT u.id, u.firstname, u.lastname, f.target_user_id AS friend
	FROM users u
	LEFT JOIN friend_requests f ON u.id = f.initiator_user_id AND f.status = 'approved'
	UNION ALL
	SELECT u.id, u.firstname, u.lastname, f.initiator_user_id AS friend
	FROM users u
	LEFT JOIN friend_requests f ON u.id = f.target_user_id AND f.status = 'approved'
) AS fr
GROUP BY fr.id, fr.firstname, fr.lastname
ORDER BY rank_pop;
*/