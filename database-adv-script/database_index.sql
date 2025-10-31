--By default postresql creates indexes for the primary key therefore no need for that


-- Additional Index for faster email lookup     
CREATE INDEX idx_users_email ON users(email);


-- Index to speed up property searches by host and location
CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_properties_location ON properties(location);

-- Indexes for speeding up queries by property and user
CREATE INDEX idx_bookings_property_id ON bookings(property_id);
CREATE INDEX idx_bookings_user_id ON bookings(user_id);

-- Index for faster booking-to-payment lookup
CREATE INDEX idx_payments_booking_id ON payments(booking_id);

-- Index for faster review retrieval by property
CREATE INDEX idx_reviews_property_id ON reviews(property_id);

-- Indexes for faster message retrieval involving users
CREATE INDEX idx_messages_sender_id ON messages(sender_id);
CREATE INDEX idx_messages_recipient_id ON messages(recipient_id);


--Checks for querying the performance of the database query
EXPLAIN ANALYZE WITH more_than_3 AS (
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




WITH matching_payments AS (
  SELECT 
    b.booking_id,
    b.user_id,
    b.property_id,
    b.start_date,
    b.end_date,
    d.payment_id,
    d.amount,
    d.payment_date,
    d.payment_method
  FROM bookings b
  LEFT JOIN payments d 
  ON b.booking_id = d.booking_id
)
SELECT 
  b.booking_id,
  b.start_date,
  b.end_date,
  b.payment_id,
  b.amount,
  b.payment_date,
  b.payment_method,
  p.property_id,
  p.name,
  p.location,
  p.pricepernight,
  p.host_id,
  u.user_id,
  u.first_name,
  u.last_name,
  u.email
FROM matching_payments b
JOIN properties p 
  ON b.property_id = p.property_id
JOIN users u 
  ON b.user_id = u.user_id;