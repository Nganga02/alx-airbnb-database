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
