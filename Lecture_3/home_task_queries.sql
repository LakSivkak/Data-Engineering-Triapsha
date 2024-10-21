/*
 Завдання на SQL до лекції 03.
 */


/*
1.
Вивести кількість фільмів в кожній категорії.
Результат відсортувати за спаданням.
*/
-- SQL code goes here...
select count (film.film_id) as film_amnt, c.name
from public.film
    inner join public.film_category fc on film.film_id = fc.film_id
    inner join public.category c on c.category_id = fc.category_id
group by c.name
order by count (film.film_id) desc

/*
2.
Вивести 10 акторів, чиї фільми брали на прокат найбільше.
Результат відсортувати за спаданням.
*/
-- SQL code goes here...
select concat(a.first_name,' ',a.last_name) as actor
from public.actor a
inner join public.film_actor fa on a.actor_id = fa.actor_id
inner join (select i.film_id, count (*) as rental_amnt
            from public.inventory i
                inner join public.rental r on i.inventory_id = r.inventory_id
            group by i.film_id
            ) i  on fa.film_id = i.film_id
order by rental_amnt desc
limit 10

/*
3.
Вивести категорія фільмів, на яку було витрачено найбільше грошей
в прокаті
*/
-- SQL code goes here...
select name as film_category_name
from public.category c
    inner join public.film_category fc on c.category_id = fc.category_id
    inner join (select f.film_id, sum (rental_duration*rental_rate) as rental_sum
                from public.film f
                    inner join public.inventory i on f.film_id = i.film_id
                    inner join public.rental r on i.inventory_id = r.inventory_id
                group by f.film_id
                ) i  on fc.film_id = i.film_id
order by rental_sum desc
limit 1


/*
4.
Вивести назви фільмів, яких не має в inventory.
Запит має бути без оператора IN
*/
-- SQL code goes here...
select f.title
from public.film f
where not exists (select 1 from public.inventory i where f.film_id = i.film_id)


/*
5.
Вивести топ 3 актори, які найбільше зʼявлялись в категорії фільмів “Children”.
*/
-- SQL code goes here...
select concat(a.first_name,' ',a.last_name) as actor
from public.actor a
    inner join (select count (fa.film_id) as film_count, fa.actor_id
                from public.film_actor fa
                inner join public.film_category fc on fa.film_id = fc.film_id
                inner join public.category c on c.category_id = fc.category_id
                where c.name = 'Children'
                group by fa.actor_id) fa on a.actor_id = fa.actor_id
order by film_count desc
limit 3