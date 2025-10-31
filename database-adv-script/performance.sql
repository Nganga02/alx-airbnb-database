-- ===========================
-- TASK 04 OPTIMIZING COMPLES QUERIES
-- ===========================



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