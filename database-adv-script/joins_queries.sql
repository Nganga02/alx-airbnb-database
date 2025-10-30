--===============
--INNER JOIN 
--===============

SELECT 
bookings.booking_id, 
bookings.property_id, 
bookings.start_date, 
bookings.end_date, 
bookings.total_price, 
bookings.status, 
users.first_name, 
users.last_name, 
users.phone_number, 
users.email 
FROM bookings JOIN users ON bookings.user_id = users.user_id;


--===============
--LEFT JOIN 
--===============
SELECT * FROM properties LEFT JOIN reviews ON properties.property_id = reviews.property_id;


--===============
--FULL OUTER JOIN 
--===============

SELECT * FROM users FULL OUTER JOIN bookings ON users.user_id = bookings.user_id;