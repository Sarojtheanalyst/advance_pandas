-- 
use bikerental;

--  Emily would like to know how many bikes the shop owns by category. Can you get this for her? 
-- Display the category name and the number of bikes the shop owns in each category (call this column number_of_bikes ). Show only the categories where the number of bikes is greater than 2 .
SELECT category,
       COUNT(*) AS number_of_bikes
FROM bike
GROUP BY category
HAVING COUNT(*) > 2;


-- 2 Emily needs a list of customer names with the total number of 
-- memberships purchased by each.
-- For each customer, display the customer's name and the count of
-- memberships purchased (call this column membership_count ).
-- Sort the results by membership_count , starting with the 
-- customer who has purchased the highest number of memberships.
-- Keep in mind that some customers may not have purchased any
-- memberships yet. In such a situation, display 0 for the
--  membership_count .

SELECT c.name,
       COUNT(m.id) AS membership_count
FROM customer c
LEFT JOIN membership m
       ON c.id = m.customer_id
GROUP BY c.name
ORDER BY membership_count DESC;

--  Emily is working on a special offer for the winter months. Can you help her prepare a list of new rental prices?
-- For each bike, display its ID, category, old price per hour (call this column old_price_per_hour ), discounted price per hour (call it new_price_per_hour ), old 
-- price per day (call it old_price_per_day ), and discounted price per day (call it 
-- new_price_per_day ).
-- Electric bikes should have a 10% discount for hourly rentals and a 20% discount for daily rentals. Mountain bikes should have a 20% discount for hourly rentals and a 50% discount for daily rentals. All other bikes should have a 50% discount for all types of rentals.
-- Round the new prices to 2 decimal digits.

SELECT 
    id,
    category,
    
    price_per_hour AS old_price_per_hour,

    CASE 
        WHEN category = 'electric' 
            THEN ROUND(price_per_hour - (price_per_hour * 0.1), 2)

        WHEN category = 'mountain bike' 
            THEN ROUND(price_per_hour - (price_per_hour * 0.2), 2)

        ELSE ROUND(price_per_hour - (price_per_hour * 0.5), 2)
    END AS new_price_per_hour,

    price_per_day AS old_price_per_day,

    CASE 
        WHEN category = 'electric' 
            THEN ROUND(price_per_day - (price_per_day * 0.2), 2)

        WHEN category = 'mountain bike' 
            THEN ROUND(price_per_day - (price_per_day * 0.5), 2)

        ELSE ROUND(price_per_day - (price_per_day * 0.5), 2)
    END AS new_price_per_day
FROM bike;


--  Emily is looking for counts of the rented bikes and of the available bikes in each category.
-- Display the number of available bikes (call this column 
-- available_bikes_count ) and the number of rented bikes (call this column rented_bikes_count ) by bike category.
SELECT 
    category,

    COUNT(
        CASE 
            WHEN status = 'available' THEN 1
        END
    ) AS available_bikes_count,

    COUNT(
        CASE 
            WHEN status = 'rented' THEN 1
        END
    ) AS rented_bikes_count

FROM bike
GROUP BY category;


--  Emily is preparing a sales report. She needs to know the total revenue from rentals by month, the total by year, and the all-time across all the years. 
-- Display the total revenue from rentals for each month, the total for each year, and the total across all the years. Do not take memberships into account. There should be 3 columns: year , month , and revenue .
-- Sort the results chronologically. Display the year total after all the month totals for the corresponding year. Show the all-time total as the last row.
-- The resulting table looks something like this:
SELECT 
    YEAR(start_timestamp) AS year,
    MONTH(start_timestamp) AS month,
    SUM(total_paid) AS revenue
FROM rental
GROUP BY YEAR(start_timestamp), MONTH(start_timestamp)

UNION ALL

SELECT 
    YEAR(start_timestamp) AS year,
    NULL AS month,
    SUM(total_paid) AS revenue
FROM rental
GROUP BY YEAR(start_timestamp)

UNION ALL

SELECT 
    NULL AS year,
    NULL AS month,
    SUM(total_paid) AS revenue
FROM rental

ORDER BY year, month;

-- query 2
SELECT 
    YEAR(start_timestamp) AS year,
    MONTH(start_timestamp) AS month,
    SUM(total_paid) AS revenue
FROM rental
GROUP BY 
    YEAR(start_timestamp),
    MONTH(start_timestamp)
WITH ROLLUP;

--  Emily has asked you to get the total revenue from memberships for each combination of year, month, and membership type.
-- Display the year, the month, the name of the membership type (call this column membership_type_name ), and the total revenue (call this column total_revenue ) for every combination of year, month, and membership type. Sort the results by year, month, and name of membership type.
SELECT 
    YEAR(start_date) AS year,
    MONTH(start_date) AS month,
    mt.name AS membership_type_name,
    SUM(total_paid) AS total_revenue

FROM membership m
JOIN membership_type mt
    ON m.membership_type_id = mt.id

GROUP BY 
    YEAR(start_date),
    MONTH(start_date),
    mt.name

ORDER BY 
    year,
    month,
    mt.name;
    
    
--  Next, Emily would like data about memberships purchased in 2023, with subtotals and grand totals for all the different combinations of membership types and months.
-- Display the total revenue from memberships purchased in 2023 for each combination of month and membership type. Generate subtotals and grand totals for all possible combinations.  There should be 3 columns: 
-- membership_type_name , month , and total_revenue .
-- Sort the results by membership type name alphabetically and then chronologically by month.
SELECT 
    mt.name AS membership_type_name,
    MONTH(start_date) AS month,
    SUM(total_paid) AS total_revenue
FROM membership m
JOIN membership_type mt 
    ON m.membership_type_id = mt.id
WHERE YEAR(start_date) = 2023
GROUP BY mt.name, MONTH(start_date)

UNION ALL

SELECT 
    mt.name AS membership_type_name,
    NULL AS month,
    SUM(total_paid) AS total_revenue
FROM membership m
JOIN membership_type mt 
    ON m.membership_type_id = mt.id
WHERE YEAR(start_date) = 2023
GROUP BY mt.name

UNION ALL

SELECT 
    NULL AS membership_type_name,
    MONTH(start_date) AS month,
    SUM(total_paid) AS total_revenue
FROM membership m
JOIN membership_type mt 
    ON m.membership_type_id = mt.id
WHERE YEAR(start_date) = 2023
GROUP BY MONTH(start_date)

UNION ALL

SELECT 
    NULL AS membership_type_name,
    NULL AS month,
    SUM(total_paid) AS total_revenue
FROM membership m
JOIN membership_type mt 
    ON m.membership_type_id = mt.id
WHERE YEAR(start_date) = 2023

ORDER BY membership_type_name, month;

-- last
--  Now it's time for the final task.
-- Emily wants to segment customers based on the number of rentals and see the count of customers in each segment. Use your SQL skills to get this!
-- Categorize customers based on their rental history as follows:

WITH cte AS (
    SELECT 
        customer_id,
        COUNT(1) AS rental_count,

        CASE 
            WHEN COUNT(1) > 10 THEN 'more than 10'

            WHEN COUNT(1) BETWEEN 5 AND 10 
                THEN 'between 5 and 10'

            ELSE 'fewer than 5'
        END AS category

    FROM rental
    GROUP BY customer_id
)

SELECT 
    category AS rental_count_category,
    COUNT(*) AS customer_count

FROM cte
GROUP BY category
ORDER BY customer_count;

