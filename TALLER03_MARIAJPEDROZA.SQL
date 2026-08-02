# Taller 3-SQL práctica
use Sakila;

# PARTE 1. Select and Where
## 1 Nombre y apellido de todos los clientes
select first_name, last_name
from customer;

## 2 Peliculas con duración mayor a 120 min
select * from film;
SELECT title, length
from film
where length > 120;


# PARTE 2. Order By
## 3 Ordenar clientes por apellido A-Z
select * from customer
order by last_name asc;

## 4 Top 5 peliculas más largas
select * from film
order by length desc
limit 5;


# PARTE 3. Inner Join
## 5 Cantidad pagada y fecha del pago con nombre y apellido del cliente (JOIN entre Payment - Customer)
### en la parte de select queda más facil definir por medio del punto en que tabla se encuentra la columna que necesitamos. (ej: payment.payment_date)
SELECT payment.amount, payment.payment_date, customer.first_name, customer.last_name FROM payment
JOIN customer ON customer.customer_id = payment.customer_id;

## 6 Películas alquiladas (JOIN entre Rental - Inventory - Film)
### pasamos por inventory ya que ahí están las llaves necesarias para conectar las demás tablas (rental y film)
select film.title, rental.rental_date, inventory.inventory_id from film
inner join inventory on film.film_id = inventory.film_id 
inner join rental on inventory.inventory_id = rental.inventory_id;


# PARTE 4. Left Join 
## 7 Nombre y apellido de clientes sin pagos (LEFT JOIN entre Payment - Customer pero usando WHERE)
### colocamos el count para que nos de con más exactitud la cantidad de transacciones por cliente
### y tambien colocamos el as para que en el resultado no aparezca count(payment.payment_id) sino el nombre que le demos.
SELECT customer.first_name, customer.last_name, count(payment.payment_id) as payment_amount from customer
left join payment on customer.customer_id = payment.customer_id
where payment.payment_id is null
group by customer.customer_id, customer.first_name, customer.last_name;
### no nos arroja valores, por lo cual no hay cliente que no haya realizado pagos.

## 8 Listar los nombres de las peliculas y su duracion de aquellos titulos que no tienen actores
SELECT film.title, film.length FROM film
LEFT JOIN film_actor ON film.film_id = film_actor.film_id
WHERE film_actor.actor_id IS NULL;


# PARTE 5. INSERT, UPDATE, DELETE (Data Definition Language)
## 9 Insertar actor temporal
insert into actor (first_name, last_name)
VALUES ("Dwayne", "johnson");
select * from actor;

## 10 Actualizar actor
update actor 
set last_name = "Douglas"
where actor_id = 204;
select * from actor;

## 11 Eliminar actor
delete from actor
where actor_id = 204;
select * from actor;


# PARTE 6. Consultas Avanzadas
## 12 Top 5 clientes con mayor cantidad de dinero pagado al servicio de rentas
SELECT customer.first_name, customer.last_name, SUM(payment.amount) AS Total_paid FROM customer
INNER JOIN payment ON customer.customer_id = payment.customer_id
GROUP BY customer.customer_id, customer.first_name, customer.last_name
ORDER BY Total_paid DESC
LIMIT 5;

## 13 Top 5 Películas más alquiladas (JOIN entre Rental - Inventory - Film) --> Agrupar los datos con conteo y tomar las mejores 5
SELECT film.title, COUNT(rental.rental_id) AS total_rental FROM rental
INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN film ON inventory.film_id = film.film_id
GROUP BY film.film_id, film.title
ORDER BY total_rental DESC
LIMIT 5;

