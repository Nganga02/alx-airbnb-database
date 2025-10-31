--===========================================
--IDENTIFYING PROPERTIES WITH A RATING > 4.0
--===========================================

SELECT * FROM properties WHERE property_id IN (SELECT DISTINCT property_id FROM reviews WHERE reviews.rating > 4.0);

--===========================================
--IDENTIFYING USERS WITH MORE THAN 3 BOOKINGS
--===========================================


WITH more_than_3 AS (
    SELECT user_id, COUNT(*) AS booking_count
    FROM bookings
    GROUP BY user_id
    HAVING COUNT(*) >= 3
)
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    m.booking_count
FROM users AS u
JOIN more_than_3 AS m ON u.user_id = m.user_id;
