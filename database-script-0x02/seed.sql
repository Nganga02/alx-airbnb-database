-- ================================
-- INSERTING DATA INTO THE DATABASE
-- ================================


-- =====
-- USERS
-- =====

INSERT INTO users (first_name, last_name, password_hash, email, phone, role, created_at)
VALUES
('u1', 'Alice', 'Mwangi', 'alice@example.com', 'password_hash', '+254712345678', 'host', NOW()),
('u2', 'Brian', 'Otieno', 'brian@example.com', 'password_hash', '+254701112233', 'guest', NOW()),
('u3', 'Sarah', 'Kimani', 'sarah@example.com', 'password_hash', '+254799887766', 'guest', NOW()),
('u4', 'John', 'Kariuki', 'john@example.com', 'password_hash', '+254722333444', 'host', NOW());


-- ===========
-- PROPERTIES
-- ===========

INSERT INTO properties (host_id, title, description, location, price_per_night, max_guests, created_at)
SELECT user_id AS host_id, lastname || 'property' as title, 'A quiet, fully furnished studio perfect for students and young professionals.', 'Nairobi, Kilimani', 3200, 2, NOW() FROM users WHERE role = 'host'

VALUES
('p1', 'u1', 'Cozy Studio Apartment', 'A quiet, fully furnished studio perfect for students and young professionals.', 'Nairobi, Kilimani', 3200, 2, NOW()),
('p2', 'u1', 'Luxury 2BR Apartment', 'Modern apartment with WiFi, balcony, and parking.', 'Nairobi, Kileleshwa', 7500, 4, NOW()),
('p3', 'u4', 'Beachfront Cottage', 'Peaceful cottage overlooking the ocean. Ideal for vacations.', 'Mombasa, Nyali', 9500, 5, NOW());


-- ===========
-- BOOKINGS
-- ===========

INSERT INTO bookings (booking_id, property_id, guest_id, start_date, end_date, total_amount, status, created_at)
VALUES
('b1', 'p1', 'u2', '2025-11-10', '2025-11-12', 6400, 'confirmed', NOW()),
('b2', 'p2', 'u3', '2025-12-01', '2025-12-05', 30000, 'pending', NOW()),
('b3', 'p3', 'u2', '2025-12-20', '2025-12-23', 28500, 'confirmed', NOW());


-- ===========
-- PAYMENTS
-- ===========

INSERT INTO payments (payment_id, booking_id, amount, method, status, paid_at)
VALUES
('pay1', 'b1', 6400, 'M-Pesa', 'completed', NOW()),
('pay2', 'b2', 30000, 'Credit Card', 'pending', NULL),
('pay3', 'b3', 28500, 'M-Pesa', 'completed', NOW());


-- ==========
-- REVIEWS
-- ==========

INSERT INTO reviews (review_id, booking_id, rating, comment, review_date)
VALUES
('r1', 'b1', 4, 'Great place, clean and peaceful.', NOW()),
('r2', 'b3', 5, 'Amazing view and very friendly host!', NOW());


-- ==========
-- MESSAGES
-- ==========

BEGIN;

-- Insert two users and retrieve their IDs
INSERT INTO users (users_id) VALUES ('u1') RETURNING user_id;
-- Suppose returned user_id = 1

INSERT INTO users (users_id) VALUES ('u2') RETURNING user_id;
-- Suppose returned user_id = 2

-- Insert messages between the two users
INSERT INTO messages (sender_id, receiver_id, message_text)
VALUES (1, 2, 'Hey Brian, how are you?');

INSERT INTO messages (sender_id, receiver_id, message_text)
VALUES (2, 1, 'Hi Alice! I am doing great, thanks!');

COMMIT;
