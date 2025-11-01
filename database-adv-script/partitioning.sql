-- =====================================================
-- Creating monthly bookings
-- =====================================================
CREATE TABLE monthly_bookings ( 
    booking_id UUID NOT NULL,
    property_id UUID NOT NULL REFERENCES properties(property_id) ON DELETE SET NULL,
    user_id UUID NOT NULL REFERENCES users(user_id) ON DELETE SET NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status booking_status NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, start_date)
)                                                     
PARTITION BY RANGE (start_date);

-- ======================================================
-- Dynamically create monthly partitions
--    Example: 2023–2026 (you can adjust as needed)
-- ======================================================
DO $$
DECLARE
    yr INT := 2025;
    mon INT;
    start_date DATE;
    end_date DATE;
    partition_name TEXT;
BEGIN
    FOR mon IN 1..12 LOOP
        start_date := make_date(yr, mon, 1);
        end_date := (start_date + INTERVAL '1 month');
        partition_name := format('%s_bookings', lower(to_char(start_date, 'Mon')));

        EXECUTE format($sql$
            CREATE TABLE IF NOT EXISTS %I
            PARTITION OF monthly_bookings
            FOR VALUES FROM (%L) TO (%L);
        $sql$, partition_name, start_date, end_date);
    END LOOP;
END $$;

-- ======================================================
-- Copy data from the old table (if exists)
-- ======================================================
INSERT INTO monthly_bookings (booking_id, user_id, property_id, start_date, end_date, total_price, status, created_at)
SELECT booking_id, user_id, property_id, start_date, end_date, total_price, status, created_at
FROM bookings
ON CONFLICT DO NOTHING