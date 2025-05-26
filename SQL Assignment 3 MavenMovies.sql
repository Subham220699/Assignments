use mavenmovies;
-- 1-Identify the primary keys and foreign keys in maven movies db. Discuss the differences
DESCRIBE table_name;
#or
SHOW COLUMNS FROM table_name;

-- 2- List all details of actors
select *from actor;

-- 3 -List all customer information from DB.
select *from customer;

-- 4 -List different countries.
select country from country;

-- 5 -Display all active customers.
select 
    customer_id,
    first_name,
    last_name,
    email,
    active
from
    customer
where 
    active = 1
order by 
    last_name, first_name;
    
-- 6 -List of all rental IDs for customer with staff_ID 1.
select *from rental;

select rental_id , staff_id from rental
where 
	staff_id = 1
order by 
	rental_id;

-- 7 - Display all the films whose rental duration is greater than 5 
select 
    title,
    rental_duration 
from 
    film
where 
    rental_duration > 5;

-- 8 - List the total number of films whose replacement cost is greater than $15 and less than $20.
select 
	count(title) as total_films
from 
	film
where
	replacement_cost > 15 AND replacement_cost < 20 ;

-- 9 - Display the count of unique first names of actors.
select count(distinct first_name) as unique_first_names
from actor;

-- 10- Display the first 10 records from the customer table .
select *from customer
limit 10;

-- 11 - Display the first 3 records from the customer table whose first name starts with ‘b’.
select *from customer
where first_name like 'b%'
limit 3;

-- 12 -Display the names of the first 5 movies which are rated as ‘G’
select *from film
where rating like 'G'
limit 5;

-- 13-Find all customers whose first name starts with "a".
select first_name from customer
where first_name like 'a%';

-- 14- Find all customers whose first name ends with "a".
select first_name from customer
where first_name like 'a%';

-- 15- Display the list of first 4 cities which start and end with ‘a'
select city from city
where city like 'a%a'
limit 4;

-- 16- Find all customers whose first name have "NI" in any position.
select customer_id, first_name, last_name
from customer
where first_name like '%NI%';

-- 17- Find all customers whose first name have "r" in the second position .
select customer_id, first_name, last_name
from customer
where first_name like '_r%';

-- 18 - Find all customers whose first name starts with "a" and are at least 5 characters in length.
select customer_id, first_name, last_name
from customer
where first_name like 'a%' and length(first_name) >=5;

-- 19- Find all customers whose first name starts with "a" and ends with "o".
select customer_id, first_name, last_name
from customer
where first_name like 'a%o';

-- 20 - Get the films with pg and pg-13 rating using IN operator.
select title, rating
from film
where rating in ('pg', 'pg-13');

-- 21 - Get the films with length between 50 to 100 using between operator.
select title, length 
from film
where length between 50 and 100;

-- 22 - Get the top 50 actors using limit operator.
select actor_id, first_name, last_name 
from actor
limit 50;

-- 23 - Get the distinct film ids from inventory table.
select distinct film_id 
from inventory;
 