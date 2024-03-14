/* Challenge 1
You need to use SQL built-in functions to gain insights relating to the duration of movies:

1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.*/

USE sakila;

SELECT min(length) as min_duration, max(length) as max_duration 
FROM sakila.film;

/* 1.2. Express the average movie duration in hours and minutes. Don't use decimals.
Hint: Look for floor and round functions.*/

SELECT 
    CONCAT(
        FLOOR(avg(f.length)) DIV 60, 
        ' hours ', 
        FLOOR(avg(f.length)) MOD 60, 
        ' minutes'
    ) AS average_length
FROM 
    sakila.film f;

/* You need to gain insights related to rental dates:

2.1 Calculate the number of days that the company has been operating.
Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.*/

SELECT FLOOR((DATEDIFF(CURRENT_DATE(), MIN(r.rental_date)))/365) as number_of_years_in_operation
FROM rental r;

-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.

SELECT *, 
       DATE_FORMAT(r.rental_date, '%M') AS month,
       DATE_FORMAT(r.rental_date, '%W') AS day_of_week
FROM rental r;

-- 2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
-- Hint: use a conditional expression.
SELECT *, 
       DATE_FORMAT(r.rental_date, '%M') AS month,
       DATE_FORMAT(r.rental_date, '%W') AS day_of_week,
       CASE
         WHEN DAYOFWEEK(r.rental_date) IN (2, 3, 4, 5, 6) THEN 'Weekday'
         ELSE 'Weekend'
       END AS day_category
FROM rental r;

-- You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the film titles and their rental duration. 
-- If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results of the film title in ascending order.

SELECT f.title, 
       CASE
            WHEN f.rental_duration IS NULL THEN 'Not available'
            ELSE CAST(f.rental_duration AS CHAR)
       END AS rental_duration
FROM sakila.film f
ORDER BY f.rental_duration ASC;

-- Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
-- Hint: Look for the IFNULL() function.
-- Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. To achieve this, you need to retrieve the concatenated first and last names of customers, along with the first 3 characters of their email address, so that you can address them by their first name and use their email address to send personalized recommendations. The results should be ordered by last name in ascending order to make it easier to use the data.

-- Challenge 2
-- Next, you need to analyze the films in the collection to gain some more insights. Using the film table, determine:
-- 1.1 The total number of films that have been released.

SELECT count(DISTINCT film_id) FROM sakila.film;

-- 1.2 The number of films for each rating.

SELECT rating, count(DISTINCT film_id) FROM sakila.film
group by rating;

-- 1.3 The number of films for each rating, sorting the results in descending order of the number of films. 
-- This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.
SELECT rating, count(DISTINCT film_id) as count_films FROM sakila.film
group by rating
order by count_films desc;

-- Using the film table, determine:
-- 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. 
-- This will help identify popular movie lengths for each category.

SELECT rating, count(DISTINCT film_id) as count_films, round(avg(length),2) as avg_length FROM sakila.film
group by rating
order by avg_length desc; 

-- 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.

SELECT rating,
       COUNT(DISTINCT film_id) AS count_films,
       ROUND(AVG(length), 2) AS avg_length
FROM sakila.film
GROUP BY rating
HAVING avg_length > 120
ORDER BY avg_length DESC;

-- Bonus: determine which last names are not repeated in the table actor.