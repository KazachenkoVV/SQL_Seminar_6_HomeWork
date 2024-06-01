-- Задание 3.
-- Создать процедуру, которая решает следующую задачу
-- Выбрать для одного пользователя 5 пользователей в случайной комбинации,
-- которые удовлетворяют хотя бы одному критерию:
-- а) из одного города
-- б) состоят в одной группе
-- в) друзья друзей

-- -------------------------------------------------------------------------
-- NB Поскольку наполнение БД таково, что все Юзеры входят в группу 1, то --
-- проверка работы процедуры целиком не очнеь информативна - всегда будут --
-- выдаваться в предолжения дружить все Юзеры, кроме себя любимого ...    --
-- -------------------------------------------------------------------------
USE seminar_4;
DROP PROCEDURE IF EXISTS let_s_be_friends;
DELIMITER &&
CREATE PROCEDURE let_s_be_friends
(
	IN for_id_user BIGINT
)
BEGIN
	SELECT MAX(id) INTO @max_id_user FROM users;
    IF for_id_user BETWEEN 1 AND @max_id_user THEN

		-- Ищем id потенциальных друзей и сохраняем их в CTE temp_users
        WITH temp_users AS
        (
			-- Потенциальные друзья - друзья друзей юзера
			-- Сначала находим друзей юзера и сохраняем их в CTE friends_1
			WITH friends_1 AS
            (
				SELECT target_user_id AS friend
				FROM friend_requests
				WHERE initiator_user_id = for_id_user AND status = 'approved'
				UNION
				SELECT initiator_user_id AS friend
				FROM friend_requests
				WHERE target_user_id = for_id_user AND status = 'approved'
				ORDER BY friend
			)

			-- Находим собственно друзей друзей
			SELECT target_user_id AS recommended_friend
			FROM friends_1
			JOIN friend_requests f ON friend = initiator_user_id
			AND status = 'approved' AND target_user_id != for_id_user
			UNION
			SELECT initiator_user_id AS recommended_friend
			FROM friends_1
			JOIN friend_requests f ON friend = target_user_id
			AND status = 'approved' AND initiator_user_id != for_id_user
		
		UNION
		
			-- Потенциальные друзья, живущие в одном городе с юзером
			SELECT p1.user_id AS recommended_friend
			FROM profiles p
			JOIN profiles p1 ON p.hometown = p1.hometown
			AND p.user_id = for_id_user AND p1.user_id !=for_id_user
		
		UNION
		
			-- Потенциальные друзья, участвующие в тех же группах, где и юзер
			SELECT DISTINCT(c1.user_id) AS recommended_friend
			FROM users_communities c
			JOIN users_communities c1 ON c.community_id = c1.community_id
			AND c.user_id = for_id_user AND c1.user_id !=for_id_user
		)
        
        -- Озвучиваем поля для рекомендованных друзей
        SELECT u.*
        FROM temp_users t
        LEFT JOIN users u ON t.recommended_friend = u.id
        ORDER BY RAND()
		LIMIT 5;

    ELSE
		SELECT CONCAT ('Ошибка. В таблице USERS отсутствует пользователь с индексом - ',
        for_id_user) AS Error;
    END IF;
// END;
END //
DELIMITER ;

CALL let_s_be_friends(FLOOR(RAND() * 15) + 1);