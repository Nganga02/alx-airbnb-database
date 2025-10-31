--===========================================
--USERS BOOKING COUNT
--===========================================

SELECT bookings.user_id, COUNT(*) FROM bookings GROUP BY bookings.user_id; 

--======================================================
--RANKING ALL PROPERTIES BOOKING USING A WINDOW FUNCTION
--======================================================

SELECT 
property_id, 
total_bookings, 
ROW_NUMBER() OVER (ORDER BY total_bookings DESC) AS row_number,
RANK() OVER (ORDER BY total_bookings DESC) AS rank,
FROM(
SELECT property_id, COUNT(*) AS total_bookings
    FROM bookings
    GROUP BY property_id
) AS booking_counts;



