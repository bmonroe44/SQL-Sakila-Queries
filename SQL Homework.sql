# Use the sakila database
USE sakila;

#Disable safe updates
SET SQL_SAFE_UPDATES = 0;

# 1a. Display the first and last names of all actors from the table 'actor'
SELECT first_name, last_name FROM actor;

#1b. Display the first and last name of each actor in a single column in uppercase letters called 'Actor Name'
ALTER TABLE actor ADD COLUMN Actor_Name VARCHAR(50);
UPDATE actor SET Actor_Name = CONCAT(first_name, ' ', last_name);
SELECT UPPER(Actor_Name) FROM actor;

#2a. Find the ID number, first name, and last name of an actor with the first name "Joe."
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'Joe';

#2b. Find all actors whose last name contain 'GEN'
SELECT * FROM actor WHERE last_name LIKE '%GEN%';

#2c. Find all actors whose last name contains 'LI'grouped by last name then first name
SELECT * FROM actor WHERE last_name LIKE '%LI%' GROUP BY first_name ORDER BY last_name;

#2d. Display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

#3a. Create 'description' column
ALTER TABLE actor ADD COLUMN Description BLOB;
# Verify description column was added
SELECT * FROM actor limit 5;

#3b. Delete 'description' column
ALTER TABLE actor DROP COLUMN Description;
# Verify description column was removed
SELECT * FROM actor limit 5;

#4a. List actors last name and how many actors have that last name
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name ORDER BY 2 DESC;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors 
SELECT last_name, COUNT(*) FROM actor GROUP BY last_name HAVING COUNT(last_name) >= 2;

#4c. Replace 'Groucho' with 'Harpo' in the first_name column
SELECT first_name, last_name, actor_id FROM actor WHERE first_name = 'Groucho';
UPDATE actor SET first_name = 'HARPO' WHERE actor_id = 172;
  # Verify name change was made
SELECT first_name, last_name, actor_id FROM actor WHERE actor_id =172;

#4d. Change 'Harpo' to 'Groucho' for all acors with first name 'Harpo'
UPDATE actor SET first_name = 'GROUCHO' WHERE first_name = 'HARPO';
  # Verify change was made
SELECT first_name, last_name, actor_id FROM actor WHERE first_name = 'GROUCHO';

#5a. Re-create schema for 'address' table
SHOW CREATE TABLE address;
 
#6a. Join first and last names from 'staff' table with address from 'address' table
SELECT staff.first_name, staff.last_name, staff.address_id, address.address
FROM staff
INNER JOIN address ON
staff.address_id = address.address_id;

#6b. Display total amount rung up by each staff member in August 2005
SELECT s.first_name, s.last_name, SUM(p.amount)
FROM staff s
INNER JOIN payment p ON
s.staff_id = p.staff_id
WHERE p.payment_date BETWEEN '2005-08-01' AND '2005-08-31' GROUP BY s.staff_id;

#6c. List each film and the number of actors who are listed for that film
SELECT f.film_id, f.title, COUNT(fa.actor_id) AS 'actors'
FROM film f
INNER JOIN film_actor fa ON
f.film_id = fa.film_id GROUP BY f.title;

#6d. Number of copies of 'Hunchback Impossible' in inventory
SELECT f.title, f.film_id, COUNT(i.inventory_id) AS 'copies'
FROM film f 
JOIN inventory i ON
f.film_id = i.film_id WHERE f.title = 'Hunchback Impossible';

#6e. Total paid by each customer, listed alphabetically by last name
SELECT c.first_name, c.last_name, SUM(p.amount)
FROM customer c 
JOIN payment p ON
c.customer_id = p.customer_id
GROUP BY p.customer_id ORDER BY last_name;

#7a. Films that begin with 'K' and 'Q' whose language is English
SELECT title FROM film WHERE title LIKE 'K%' OR title LIKE 'Q%' AND language_id IN 
	(SELECT language_id FROM language WHERE name = 'English'); 
        
#7b. Display all actors who appear in the film 'Alone Trip'
SELECT Actor_Name FROM actor WHERE actor_id IN 
	(SELECT actor_id FROM film_actor WHERE film_id IN 
		(SELECT film_id FROM film WHERE title = 'Alone Trip'));
        
#7c. Retrieve names and email addresses of all Canadian customers
SELECT c.first_name, c.last_name, c.email, country.country
FROM customer c 
JOIN address ON
c.address_id = address.address_id
JOIN city ON
address.city_id = city.city_id
JOIN country ON
city.country_id =country.country_id
WHERE country = 'Canada';

#7d. Identify all movies categorized as family films
SELECT title FROM film WHERE film_id IN 
	(SELECT film_id FROM film_category WHERE category_id IN 
		(SELECT category_id FROM category WHERE name = 'Family'));
        
#7e. Display most frequently rented movies in descending order
SELECT f.title, COUNT(r.inventory_id) 
FROM film f
JOIN inventory i ON
f.film_id = i.film_id
JOIN rental r ON 
i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY 2 DESC;

#7f. Display how much business in dollars brought in by each store STore, Inventory, Rental, Payment
SELECT s.store_id, SUM(p.amount) AS Total_Dollars
FROM store s 
JOIN inventory i ON
s.store_id = i.store_id
JOIN rental r ON 
i.inventory_id = r.inventory_id
JOIN payment p ON 
r.rental_id = p.rental_id
GROUP BY s.store_id;

#7g. Display store id, city and country for each store
SELECT store.store_id, city.city, country.country
FROM store
JOIN address ON 
store.address_id = address.address_id
JOIN city ON 
address.city_id = city.city_id
JOIN country ON 
city.country_id = country.country_id;

#7h. List top 5 genres in gross revene in descending order
SELECT SUM(p.amount), category.name
FROM payment p 
JOIN rental r ON
p.rental_id = r.rental_id
JOIN inventory i ON
r.inventory_id = i.inventory_id
JOIN film_category ON
i.film_id = film_category.film_id
JOIN category ON
film_category.category_id = category.category_id
GROUP BY category.name 
ORDER BY 1 DESC limit 5;

#8a. Create view 'Top 5 Genres'
CREATE VIEW Top_5_Genres AS
SELECT SUM(p.amount), category.name
FROM payment p 
JOIN rental r ON
p.rental_id = r.rental_id
JOIN inventory i ON
r.inventory_id = i.inventory_id
JOIN film_category ON
i.film_id = film_category.film_id
JOIN category ON
film_category.category_id = category.category_id
GROUP BY category.name 
ORDER BY 1 DESC limit 5;

#8b. Display view created in 8a
SELECT * FROM Top_5_Genres;

#8c. Delete the 'Top_5_Genres' view
DROP VIEW Top_5_Genres;
 
