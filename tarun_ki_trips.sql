/*
Author: Tarun Kashav
Date: January 2025
Description: Create tables, insert sample data in it and demomstrate advanced SQL concepts used
to create a ride-sharing platform "tarun_ki_rides"
*/

-- create database tarun_ki_rides
create database tarun_ki_rides;

Use tarun_ki_rides;

-- 1 create a Customers table
CREATE TABLE customers (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample customers data into the table
INSERT INTO customers (id, name, email, created_at) VALUES
(UUID(), 'John Smith', 'john.smith@example.com', '2023-01-01 00:00:00'),
(UUID(), 'Emily Johnson', 'emily.j@example.com', '2023-01-02 00:00:00'),
(UUID(), 'Michael Brown', 'michael.b@example.com', '2023-01-03 00:00:00'),
(UUID(), 'Sarah Davis', 'sarah.d@example.com', '2023-01-04 00:00:00'),
(UUID(), 'Robert Wilson', 'robert.w@example.com', '2023-01-05 00:00:00');

Select*from customers;

drop table customers;

-- 2 create a Drivers table
CREATE TABLE drivers (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    dob DATE NOT NULL,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- Insert sample drivers
INSERT INTO drivers (id, name, email, dob, latitude, longitude, created_at) VALUES
(UUID(), 'David Miller', 'david.m@example.com', '1985-03-15', 40.7484, -73.9857, '2023-01-01 00:00:00'),
(UUID(), 'Jennifer Lee', 'jennifer.l@example.com', '1990-07-22', 40.7128, -74.0060, '2023-01-02 00:00:00'),
(UUID(), 'James Taylor', 'james.t@example.com', '1982-11-30', 40.78, -73.9667, '2023-01-03 00:00:00'),
(UUID(), 'Lisa Anderson', 'lisa.a@example.com', '1988-05-10', 40.7527, -73.9772, '2023-01-04 00:00:00'),
(UUID(), 'Thomas Clark', 'thomas.c@example.com', '1979-09-18', 40.7505, -73.9939, '2023-01-05 00:00:00');




-- 3 create a Cabs table
CREATE TABLE cabs (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    driver_id VARCHAR(36),
    type ENUM('economy', 'comfort', 'premium', 'xl', 'black'),
    reg_no VARCHAR(20) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (driver_id) REFERENCES drivers(id)
);


-- Insert sample cabs
INSERT INTO cabs (id, driver_id, type, reg_no, created_at) VALUES
(UUID(), (SELECT id FROM drivers WHERE email = 'david.m@example.com'), 'comfort', 'NY12345', '2023-01-01 00:00:00'),
(UUID(), (SELECT id FROM drivers WHERE email = 'jennifer.l@example.com'), 'economy', 'NY67890', '2023-01-02 00:00:00'),
(UUID(), (SELECT id FROM drivers WHERE email = 'james.t@example.com'), 'premium', 'NY24680', '2023-01-03 00:00:00'),
(UUID(), (SELECT id FROM drivers WHERE email = 'lisa.a@example.com'), 'xl', 'NY13579', '2023-01-04 00:00:00'),
(UUID(), (SELECT id FROM drivers WHERE email = 'thomas.c@example.com'), 'black', 'NY86420', '2023-01-05 00:00:00');



-- 4 create a Trips table
CREATE TABLE trips (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    customer_id VARCHAR(36),
    driver_id VARCHAR(36),
    status ENUM('requested', 'accepted', 'in_progress', 'completed', 'cancelled'),
    source_lat DECIMAL(10, 8),
    source_lng DECIMAL(11, 8),
    dest_lat DECIMAL(10, 8),
    dest_lng DECIMAL(11, 8),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    started_at TIMESTAMP NULL,
    completed_at TIMESTAMP NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (driver_id) REFERENCES drivers(id)
);
-- update trips set status='cancelled'where id='62315a70-1ffd-11f0-8f90-7cd30a81ceef';
-- Insert sample trips
-- select * from trips
INSERT INTO trips (id, customer_id, driver_id, status, source_lat, source_lng, dest_lat, dest_lng, created_at, started_at, completed_at) VALUES
(UUID(), 
 (SELECT id FROM customers WHERE email = 'john.smith@example.com'), 
 (SELECT id FROM drivers WHERE email = 'david.m@example.com'), 
 'cancelled', 40.7484, -73.9857, 40.7527, -73.9772, 
 '2023-01-15 08:30:00', '2023-01-15 08:35:00', '2023-01-15 08:55:00'),
 
(UUID(), 
 (SELECT id FROM customers WHERE email = 'emily.j@example.com'), 
 (SELECT id FROM drivers WHERE email = 'jennifer.l@example.com'), 
 'completed', 40.7128, -74.0060, 40.78, -73.9667, 
 '2023-01-16 12:15:00', '2023-01-16 12:20:00', '2023-01-16 12:50:00'),
 
(UUID(), 
 (SELECT id FROM customers WHERE email = 'michael.b@example.com'), 
 (SELECT id FROM drivers WHERE email = 'james.t@example.com'), 
 'completed', 40.78, -73.9667, 40.7505, -73.9939, 
 '2023-01-17 18:45:00', '2023-01-17 18:50:00', '2023-01-17 19:20:00'),
 
(UUID(), 
 (SELECT id FROM customers WHERE email = 'sarah.d@example.com'), 
 (SELECT id FROM drivers WHERE email = 'lisa.a@example.com'), 
 'completed', 40.7527, -73.9772, 40.7484, -73.9857, 
 '2023-01-18 09:30:00', '2023-01-18 09:35:00', '2023-01-18 09:55:00'),
 
(UUID(), 
 (SELECT id FROM customers WHERE email = 'robert.w@example.com'), 
 (SELECT id FROM drivers WHERE email = 'thomas.c@example.com'), 
 'completed', 40.7505, -73.9939, 40.7128, -74.0060, 
 '2023-01-19 17:30:00', '2023-01-19 17:35:00', '2023-01-19 18:05:00');



-- 5 create a Payments table
CREATE TABLE payments (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    trip_id VARCHAR(36),
    method ENUM('credit_card', 'debit_card', 'paypal', 'cash', 'wallet'),
    amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (trip_id) REFERENCES trips(id)
);



-- Insert sample payments
INSERT INTO payments (id, trip_id, method, amount, created_at) VALUES
(UUID(), (SELECT id FROM trips WHERE created_at = '2023-01-15 08:30:00'), 'credit_card', 15.50, '2023-01-15 08:56:00'),
(UUID(), (SELECT id FROM trips WHERE created_at = '2023-01-16 12:15:00'), 'debit_card', 22.75, '2023-01-16 12:51:00'),
(UUID(), (SELECT id FROM trips WHERE created_at = '2023-01-17 18:45:00'), 'wallet', 28.30, '2023-01-17 19:21:00'),
(UUID(), (SELECT id FROM trips WHERE created_at = '2023-01-18 09:30:00'), 'credit_card', 12.20, '2023-01-18 09:56:00'),
(UUID(), (SELECT id FROM trips WHERE created_at = '2023-01-19 17:30:00'), 'cash', 25.60, '2023-01-19 18:06:00');




-- 6 create a Ratings table
CREATE TABLE ratings (
    id VARCHAR(36) PRIMARY KEY DEFAULT (UUID()),
    customer_id VARCHAR(36),
    driver_id VARCHAR(36),
    trip_id VARCHAR(36),
    rating TINYINT CHECK (rating BETWEEN 1 AND 5),
    feedback TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (driver_id) REFERENCES drivers(id),
    FOREIGN KEY (trip_id) REFERENCES trips(id)
);



-- Insert sample ratings
INSERT INTO ratings (id, customer_id, driver_id, trip_id, rating, feedback, created_at) VALUES
(UUID(), 
 (SELECT id FROM customers WHERE email = 'john.smith@example.com'),
 (SELECT id FROM drivers WHERE email = 'david.m@example.com'),
 (SELECT id FROM trips WHERE created_at = '2023-01-15 08:30:00'),
 5, 'Excellent service!', '2023-01-15 09:00:00'),
 
(UUID(), 
 (SELECT id FROM customers WHERE email = 'emily.j@example.com'),
 (SELECT id FROM drivers WHERE email = 'jennifer.l@example.com'),
 (SELECT id FROM trips WHERE created_at = '2023-01-16 12:15:00'),
 4, 'Good ride, but slightly late', '2023-01-16 12:55:00'),
 
(UUID(), 
 (SELECT id FROM customers WHERE email = 'michael.b@example.com'),
 (SELECT id FROM drivers WHERE email = 'james.t@example.com'),
 (SELECT id FROM trips WHERE created_at = '2023-01-17 18:45:00'),
 3, 'Average experience', '2023-01-17 19:25:00'),
 
(UUID(), 
 (SELECT id FROM customers WHERE email = 'sarah.d@example.com'),
 (SELECT id FROM drivers WHERE email = 'lisa.a@example.com'),
 (SELECT id FROM trips WHERE created_at = '2023-01-18 09:30:00'),
 5, 'Perfect ride, very professional', '2023-01-18 10:00:00'),
 
(UUID(), 
 (SELECT id FROM customers WHERE email = 'robert.w@example.com'),
 (SELECT id FROM drivers WHERE email = 'thomas.c@example.com'),
 (SELECT id FROM trips WHERE created_at = '2023-01-19 17:30:00'),
 2, 'Driver took a longer route', '2023-01-19 18:10:00');


select*from ratings;

-- SQL Queries for Analysis--


-- 1 Basic Driver Ratings Report


SELECT 
    d.id,
    d.name AS driver_name,
    COUNT(r.id) AS rating_count,
    AVG(r.rating) AS average_rating
FROM 
    drivers d
LEFT JOIN 
    ratings r 
    ON d.id = r.driver_id
GROUP BY 
    1
ORDER BY 
    average_rating DESC;

-- What it shows: Lists all drivers with their average rating and how many ratings they've received, sorted from highest to lowest rate



-- 2 Trip Count by Customer and total payments made by them

SELECT 
    c.id,
    c.name AS customer_name,
    COUNT(t.id) AS trips_taken,
    SUM(p.amount) AS total_spent
FROM 
    customers c
LEFT JOIN 
    trips t ON c.id = t.customer_id AND t.status = 'completed'
LEFT JOIN 
    payments p ON t.id = p.trip_id
GROUP BY 
    1
ORDER BY 
    trips_taken DESC;

-- What it shows: Shows how many trips each customer has taken and how much they've spent in total.




-- 3 Most Popular Cab Types

SELECT 
    type AS cab_type,
    COUNT(t.id) AS trips_completed
FROM 
    cabs c
LEFT JOIN 
    trips t ON c.driver_id = t.driver_id AND t.status = 'completed'
GROUP BY 
    type
ORDER BY 
    trips_completed DESC;

-- What it shows: Reveals which cab types (economy, comfort, etc.) are used most frequently.




-- 4 Daily Trip Volume

SELECT 
    DATE(created_at) AS trip_date,
    COUNT(*) AS trips_count
FROM 
    trips
WHERE 
    status = 'completed'
GROUP BY 
    trip_date
ORDER BY 
    trip_date;

-- What it shows: Counts how many trips were completed each day, helping identify busy vs. slow days.





-- 5 Simple Payment Method Analysis

SELECT 
    method AS payment_method,
    COUNT(*) AS usage_count,
    ROUND(AVG(amount), 2) AS average_payment
FROM 
    payments
GROUP BY 
    method
ORDER BY 
    usage_count DESC;

-- What it shows: Shows which payment methods customers use most often and the average transaction amount for each.







-- Complex SQL Queries for Analysis--




-- 1 Driver Performance Analysis

-- Top performing drivers by average rating and total earnings

SELECT 
    d.name AS driver_name,
    c.type AS cab_type,
    COUNT(t.id) AS total_trips,
    ROUND(AVG(r.rating), 1) AS avg_rating,
    SUM(p.amount) AS total_earnings,
    ROUND(SUM(p.amount) / COUNT(t.id), 2) AS avg_earnings_per_trip
FROM 
    drivers d
JOIN 
    cabs c ON d.id = c.driver_id
LEFT JOIN 
    trips t ON d.id = t.driver_id
LEFT JOIN 
    payments p ON t.id = p.trip_id
LEFT JOIN 
    ratings r ON t.id = r.trip_id
WHERE 
    t.status = 'completed'
GROUP BY 
    d.name, c.type
ORDER BY 
    avg_rating DESC, total_earnings DESC;





-- 2 Customer Spending Patterns

-- Customer spending analysis by time of day and day of week
SELECT 
    cu.name AS customer_name,
    DAYOFWEEK(t.created_at) AS day_of_week,
    CASE 
        WHEN HOUR(t.created_at) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN HOUR(t.created_at) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN HOUR(t.created_at) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    COUNT(t.id) AS trip_count,
    SUM(p.amount) AS total_spent,
    ROUND(AVG(p.amount), 2) AS avg_spent_per_trip
FROM 
    customers cu
JOIN 
    trips t ON cu.id = t.customer_id AND t.status = 'completed'
JOIN 
    payments p ON t.id = p.trip_id
GROUP BY 
    cu.name, day_of_week, time_of_day
ORDER BY 
    cu.name, day_of_week, time_of_day;
    
    
    


-- 3 Revenue Analysis by Cab Type

-- Revenue and utilization by cab type

SELECT 
    c.type AS cab_type,
    COUNT(t.id) AS total_trips,
    SUM(p.amount) AS total_revenue,
    ROUND(AVG(p.amount), 2) AS avg_revenue_per_trip,
    ROUND(COUNT(t.id) * 100.0 / (SELECT COUNT(*) FROM trips WHERE status = 'completed'), 2) AS market_share_percentage,
    ROUND(AVG(r.rating), 1) AS avg_rating
FROM 
    cabs c
JOIN 
    drivers d ON c.driver_id = d.id
JOIN 
    trips t ON d.id = t.driver_id AND t.status = 'completed'
JOIN 
    payments p ON t.id = p.trip_id
LEFT JOIN 
    ratings r ON t.id = r.trip_id
GROUP BY 
    c.type
ORDER BY 
    total_revenue DESC;





-- 4 Customer Retention Analysis

-- Customer repeat rate and lifetime value

WITH customer_trips AS (
    SELECT 
        c.id AS customer_id,
        c.name AS customer_name,
        COUNT(t.id) AS trip_count,
        SUM(p.amount) AS total_spent,
        MIN(t.created_at) AS first_trip_date,
        MAX(t.created_at) AS last_trip_date
    FROM 
        customers c
    LEFT JOIN 
        trips t ON c.id = t.customer_id AND t.status = 'completed'
    LEFT JOIN 
        payments p ON t.id = p.trip_id
    GROUP BY 
        c.id, c.name
)
SELECT 
    customer_name,
    trip_count,
    total_spent,
    ROUND(total_spent / trip_count, 2) AS avg_spent_per_trip,
    first_trip_date,
    last_trip_date,
    CASE 
        WHEN trip_count > 1 THEN 'Repeat'
        ELSE 'One-time'
    END AS customer_type,
    CASE 
        WHEN trip_count > 3 THEN 'High Value'
        WHEN trip_count > 1 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS customer_segment
FROM 
    customer_trips
ORDER BY 
    total_spent DESC;





-- 5 Peak Hour Analysis

SELECT 
    HOUR(t.created_at) AS hour_of_day,
    COUNT(*) AS total_trips,
    ROUND(AVG(amount), 2) AS avg_fare,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM trips WHERE status = 'completed'), 2) AS percentage_of_total
FROM 
    trips t
JOIN 
    payments p ON t.id = p.trip_id
WHERE 
    t.status = 'completed'
GROUP BY 
    hour_of_day
ORDER BY 
    total_trips DESC;





 -- 6 Driver Availability Analysis

SELECT 
    d.name AS driver_name,
    c.type AS cab_type,
    COUNT(t.id) AS completed_trips,
    SUM(CASE WHEN t.status = 'cancelled' THEN 1 ELSE 0 END) AS cancelled_trips,
    ROUND(COUNT(t.id) / (COUNT(t.id) + SUM(CASE WHEN t.status = 'cancelled' THEN 1 ELSE 0 END)) * 100, 2) AS completion_rate
FROM 
    drivers d
JOIN 
    cabs c ON d.id = c.driver_id
LEFT JOIN 
    trips t ON d.id = t.driver_id
GROUP BY 
    d.name, c.type
ORDER BY 
    completion_rate DESC;

-- These MySQL-compatible queries provide comprehensive analysis of my ride-sharing platform's data, enabling data-driven decision making for operations, marketing, and strategic planning.