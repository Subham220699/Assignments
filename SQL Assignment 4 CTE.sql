-- 5. CTE Basics:
--  a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they 
-- have acted in from the actor and film_actor tables.

WITH ActorFilmCount AS (
    SELECT 
        a.actor_id, 
        CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
        COUNT(fa.film_id) AS film_count
    FROM 
        actor a
    JOIN 
        film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY 
        a.actor_id, actor_name
)
SELECT 
    actor_name, 
    film_count
FROM 
    ActorFilmCount
ORDER BY 
    film_count DESC;

-- 6. CTE with Joins:
--  a. Create a CTE that combines information from the film and language tables to display the film title, 
--  language name, and rental rate.
WITH FilmLanguageRental AS (
    SELECT 
        f.title AS film_title, 
        l.name AS language_name, 
        f.rental_rate
    FROM 
        film f
    JOIN 
        language l ON f.language_id = l.language_id
)
SELECT 
    film_title, 
    language_name, 
    rental_rate
FROM 
    FilmLanguageRental
ORDER BY 
    film_title;
    
-- 7. CTE for Aggregation:
--  a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) 
--  from the customer and payment tables.
WITH CustomerRevenue AS (
    SELECT 
        c.customer_id, 
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name, 
        SUM(p.amount) AS total_revenue
    FROM 
        customer c
    JOIN 
        payment p ON c.customer_id = p.customer_id
    GROUP BY 
        c.customer_id, customer_name
)
SELECT 
    customer_name, 
    total_revenue
FROM 
    CustomerRevenue
ORDER BY 
    total_revenue DESC;

-- 8. CTE with Window Functions:
-- a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.
WITH FilmRentalRank AS (
    SELECT 
        title AS film_title,
        rental_duration,
        RANK() OVER (ORDER BY rental_duration DESC) AS rental_rank
    FROM 
        film
)
SELECT 
    film_title,
    rental_duration,
    rental_rank
FROM 
    FilmRentalRank
ORDER BY 
    rental_rank;

-- 9. CTE and Filtering:
 -- a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the 
-- customer table to retrieve additional customer details.
WITH CustomerRentalCount AS (
    SELECT 
        customer_id,
        COUNT(rental_id) AS rental_count
    FROM 
        rental
    GROUP BY 
        customer_id
    HAVING 
        COUNT(rental_id) > 2
)
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    crc.rental_count
FROM 
    customer c
JOIN 
    CustomerRentalCount crc ON c.customer_id = crc.customer_id
ORDER BY 
    crc.rental_count DESC;

-- 10. CTE for Date Calculations:
--  a. Write a query using a CTE to find the total number of rentals made each month, considering the 
--  rental_date from the rental table
WITH MonthlyRentalCount AS (
    SELECT 
        EXTRACT(YEAR FROM rental_date) AS rental_year,
        EXTRACT(MONTH FROM rental_date) AS rental_month,
        COUNT(rental_id) AS total_rentals
    FROM 
        rental
    GROUP BY 
        rental_year, rental_month
)
SELECT 
    rental_year,
    rental_month,
    total_rentals
FROM 
    MonthlyRentalCount
ORDER BY 
    rental_year DESC, rental_month DESC;
    
-- 11. CTE and Self-Join:
--  a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film 
-- together, using the film_actor table.
WITH ActorPairs AS (
    SELECT 
        fa1.actor_id AS actor_1_id,
        fa2.actor_id AS actor_2_id,
        fa1.film_id
    FROM 
        film_actor fa1
    JOIN 
        film_actor fa2 ON fa1.film_id = fa2.film_id
    WHERE 
        fa1.actor_id < fa2.actor_id
)
SELECT 
    a1.first_name || ' ' || a1.last_name AS actor_1_name,
    a2.first_name || ' ' || a2.last_name AS actor_2_name,
    COUNT(ap.film_id) AS films_together
FROM 
    ActorPairs ap
JOIN 
    actor a1 ON ap.actor_1_id = a1.actor_id
JOIN 
    actor a2 ON ap.actor_2_id = a2.actor_id
GROUP BY 
    actor_1_name, actor_2_name
ORDER BY 
    films_together DESC;

-- 12. CTE for Recursive Search:
--  a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, 
-- considering the reports_to column
WITH RECURSIVE EmployeeHierarchy AS (
    -- Anchor member: Select the manager from whom we start the search
    SELECT 
        staff_id,
        first_name,
        last_name,
        reports_to
    FROM 
        staff
    WHERE 
        staff_id = 1  -- Replace with the specific manager's staff_id

    UNION ALL

    -- Recursive member: Find employees who report to the current employee
    SELECT 
        s.staff_id,
        s.first_name,
        s.last_name,
        s.reports_to
    FROM 
        staff s
    JOIN 
        EmployeeHierarchy eh ON s.reports_to = eh.staff_id
)
SELECT 
    staff_id,
    first_name,
    last_name
FROM 
    EmployeeHierarchy
ORDER BY 
    staff_id;