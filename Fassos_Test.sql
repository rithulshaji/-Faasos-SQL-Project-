CREATE DATABASE faasos_test;
USE faasos_test;

drop table if exists driver;
CREATE TABLE driver(driver_id integer,reg_date date); 

INSERT INTO driver(driver_id,reg_date) 
 VALUES (1,str_to_date('01-01-2021' ,'%m-%d-%Y')),
(2,str_to_date('01-03-2021','%m-%d-%Y')),
(3,str_to_date('01-08-2021','%m-%d-%Y')),
(4,str_to_date('01-15-2021','%m-%d-%Y'));


drop table if exists ingredients;
CREATE TABLE ingredients(ingredients_id integer,ingredients_name varchar(60)); 

INSERT INTO ingredients(ingredients_id ,ingredients_name) 
 VALUES (1,'BBQ Chicken'),
(2,'Chilli Sauce'),
(3,'Chicken'),
(4,'Cheese'),
(5,'Kebab'),
(6,'Mushrooms'),
(7,'Onions'),
(8,'Egg'),
(9,'Peppers'),
(10,'schezwan sauce'),
(11,'Tomatoes'),
(12,'Tomato Sauce');

drop table if exists rolls;
CREATE TABLE rolls(roll_id integer,roll_name varchar(30)); 

INSERT INTO rolls(roll_id ,roll_name) 
 VALUES (1	,'Non Veg Roll'),
(2	,'Veg Roll');

drop table if exists rolls_recipes;
CREATE TABLE rolls_recipes(roll_id integer,ingredients varchar(24)); 

INSERT INTO rolls_recipes(roll_id ,ingredients) 
 VALUES (1,'1,2,3,4,5,6,8,10'),
(2,'4,6,7,9,11,12');

drop table if exists driver_order;
CREATE TABLE driver_order(order_id integer,driver_id integer,pickup_time datetime,distance VARCHAR(7),duration VARCHAR(10),cancellation VARCHAR(23));
INSERT INTO driver_order(order_id,driver_id,pickup_time,distance,duration,cancellation)
VALUES
(1,1,STR_TO_DATE('01-01-2021 18:15:34','%m-%d-%Y %H:%i:%s'),'20km','32 minutes',''),
(2,1,STR_TO_DATE('01-01-2021 19:10:54','%m-%d-%Y %H:%i:%s'),'20km','27 minutes',''),
(3,1,STR_TO_DATE('01-03-2021 00:12:37','%m-%d-%Y %H:%i:%s'),'13.4km','20 mins','NaN'),
(4,2,STR_TO_DATE('01-04-2021 13:53:03','%m-%d-%Y %H:%i:%s'),'23.4','40','NaN'),
(5,3,STR_TO_DATE('01-08-2021 21:10:57','%m-%d-%Y %H:%i:%s'),'10','15','NaN'),
(6,3,null,null,null,'Cancellation'),
(7,2,STR_TO_DATE('01-08-2021 21:30:45','%m-%d-%Y %H:%i:%s'),'25km','25mins',null),
(8,2,STR_TO_DATE('01-10-2021 00:15:02','%m-%d-%Y %H:%i:%s'),'23.4 km','15 minute',null),
(9,2,null,null,null,'Customer Cancellation'),
(10,1,STR_TO_DATE('01-11-2021 18:50:20','%m-%d-%Y %H:%i:%s'),'10km','10minutes',null);



drop table if exists customer_orders;
CREATE TABLE customer_orders(order_id integer,customer_id integer,roll_id integer,not_include_items VARCHAR(4),extra_items_included VARCHAR(4),order_date datetime);
INSERT INTO customer_orders(order_id,customer_id,roll_id,not_include_items,extra_items_included,order_date)
values (1,101,1,'','',str_to_date('01-01-2021  18:05:02','%m-%d-%Y %H:%i:%s')),
(2,101,1,'','',str_to_date('01-01-2021 19:00:52','%m-%d-%Y %H:%i:%s')),
(3,102,1,'','',str_to_date('01-02-2021 23:51:23','%m-%d-%Y %H:%i:%s')),
(3,102,2,'','NaN',str_to_date('01-02-2021 23:51:23','%m-%d-%Y %H:%i:%s')),
(4,103,1,'4','',str_to_date('01-04-2021 13:23:46','%m-%d-%Y %H:%i:%s')),
(4,103,1,'4','',str_to_date('01-04-2021 13:23:46','%m-%d-%Y %H:%i:%s')),
(4,103,2,'4','',str_to_date('01-04-2021 13:23:46','%m-%d-%Y %H:%i:%s')),
(5,104,1,null,'1',str_to_date('01-08-2021 21:00:29','%m-%d-%Y %H:%i:%s')),
(6,101,2,null,null,str_to_date('01-08-2021 21:03:13','%m-%d-%Y %H:%i:%s')),
(7,105,2,null,'1',str_to_date('01-08-2021 21:20:29','%m-%d-%Y %H:%i:%s')),
(8,102,1,null,null,str_to_date('01-09-2021 23:54:33','%m-%d-%Y %H:%i:%s')),
(9,103,1,'4','1,5',str_to_date('01-10-2021 11:22:59','%m-%d-%Y %H:%i:%s')),
(10,104,1,null,null,str_to_date('01-11-2021 18:34:49','%m-%d-%Y %H:%i:%s')),
(10,104,1,'2,6','1,4',str_to_date('01-11-2021 18:34:49','%m-%d-%Y %H:%i:%s'));

select * from customer_orders;
select * from driver_order;
select * from ingredients;
select * from driver;
select * from rolls;
select * from rolls_recipes;


-- A) Rolls matrix
-- 1)How many rolls were ordered?
SELECT COUNT(roll_id) AS no_of_rolls_ordered FROM customer_orders;

-- 2) How many unique customer orders were made?
SELECT COUNT(DISTINCT customer_id) AS unique_customer_orders 
FROM customer_orders;

-- 3)How many successful orders were delivered by each driver?
SELECT driver_id,COUNT(DISTINCT order_id) AS succesful_driver_delivery 
FROM driver_order
WHERE cancellation != 'Cancellation' AND cancellation != 'Customer Cancellation'
GROUP BY driver_id;

-- 4) How many of each type of roll was delivered?
SELECT roll_id, COUNT(roll_id) FROM customer_orders WHERE order_id IN 
(SELECT order_id FROM 
(SELECT *, (CASE WHEN cancellation IN('Cancellation','Customer Cancellation') 
THEN 'c' ELSE 'nc' END) AS odrer_cancel_details FROM driver_order) AS a 
WHERE odrer_cancel_details='nc') 
GROUP BY roll_id;

-- 5) How many veg and non veg rolls were orderd by each customers?
SELECT a.*,b.roll_name FROM 
(SELECT customer_id,COUNT(roll_id) AS cnt,roll_id FROM customer_orders
GROUP BY customer_id,roll_id) AS a
INNER JOIN rolls AS b ON a.roll_id=b.roll_id;

-- 6) What was the maximum no of orders delivered in a single order?
SELECT order_id, COUNT(roll_id) AS cnt FROM
(SELECT * FROM customer_orders WHERE order_id IN(
(SELECT order_id FROM 
(SELECT *, (CASE WHEN cancellation IN('Cancellation','Customer Cancellation') 
THEN 'c' ELSE 'nc' END) AS odrer_cancel_details FROM driver_order) AS a
WHERE odrer_cancel_details='nc'))) AS b;

SELECT * FROM 
(SELECT *, RANK() OVER(ORDER BY cnt DESC) AS rnk FROM
(SELECT order_id,COUNT(roll_id) AS cnt FROM 
(SELECT * FROM customer_orders WHERE order_id IN
(SELECT order_id FROM 
(SELECT *, (CASE WHEN cancellation IN('Cancellation','Customer Cancellation') 
THEN 'c' ELSE 'nc' END) AS odrer_cancel_details FROM driver_order) AS a
WHERE odrer_cancel_details='nc')) AS b
GROUP BY order_id) AS c) AS d
WHERE rnk=1;

-- 7) For each customer, how many delivered rolls had atleast 1 change
--  and how many had no change? 

SELECT customer_id,change_in_roll,COUNT( change_in_roll) FROM
(SELECT a.*,b.cancellation FROM 
(SELECT *, (CASE 
WHEN not_include_items IN(NULL,'') AND extra_items_included IN('NaN',NULL,'')
THEN 'No_change' 
WHEN not_include_items IS NULL AND extra_items_included IS NULL
THEN 'No_change' ELSE 'Change' END )AS change_in_roll
FROM customer_orders) AS a 
INNER JOIN driver_order AS b ON a.order_id=b.order_id 
AND b.cancellation NOT IN('Cancellation','Customer Cancellation')) AS c
GROUP BY customer_id,change_in_roll;-- -wrong

-- Instructor
with temp_customer_orders (order_id,customer_id,roll_id,not_include_items,
extra_items_included,order_date) as
 (
select order_id,customer_id,roll_id, 
case when not_include_items is null or not_include_items= '' then '0' 
else not_include_items end as new_not_include_items,
case when extra_items_included is null or  extra_items_included='' 
or extra_items_included='NaN' or extra_items_included=NULL 
then '0'else extra_items_included end as new_extra_items_included,order_date 
from customer_orders),
temp_driver_order (order_id,driver_id,pickup_time,distance,duration,
 new_cancellation) as
(select order_id,driver_id,pickup_time,distance,duration, 
case when cancellation in ("Cancellation","Customer cancellation") then 0 
else 1 end as new_cancellation from driver_order)
select customer_id,chg_no_chg,count(order_id) as at_least_1_change from 
(select *, case when not_include_items="0" and extra_items_Included ="0"
then 'no_change' else 'change' end as chg_no_chg from temp_customer_orders
where order_id in (select order_id from temp_driver_order where 
new_cancellation!="0")) as a
group by customer_id,chg_no_chg;
 
 -- 8) How many rolls that were deliverd had both exclusions and extras?
with temp_customer_orders (order_id,customer_id,roll_id,not_include_items,
extra_items_included,order_date) as
 (
select order_id,customer_id,roll_id, 
case when not_include_items is null or not_include_items= '' then '0' 
else not_include_items end as new_not_include_items,
case when extra_items_included is null or  extra_items_included='' 
or extra_items_included='NaN' or extra_items_included=NULL 
then '0'else extra_items_included end as new_extra_items_included,order_date 
from customer_orders),
temp_driver_order (order_id,driver_id,pickup_time,distance,duration,
 new_cancellation) as
(select order_id,driver_id,pickup_time,distance,duration, 
case when cancellation in ("Cancellation","Customer cancellation") then 0 
else 1 end as new_cancellation from driver_order)
SELECT chg_no_chg,COUNT(chg_no_chg) FROM
(select *, case when not_include_items!="0" and extra_items_Included !="0"
then 'both exe inc' else 'either 1 exc or inc' end as chg_no_chg from temp_customer_orders
 where order_id in (select order_id from temp_driver_order where 
 new_cancellation!="0")) AS a
 GROUP BY chg_no_chg;
 
 -- 9)What was the total no of rolls ordered for each hour of the day?
SELECT hr,COUNT(hr) FROM
(SELECT *, CONCAT(EXTRACT(HOUR FROM order_date), '-', 
EXTRACT(HOUR FROM order_date) + 1) AS hr FROM customer_orders) AS a
GROUP BY hr;

-- 10) What was the no of orders for each day of the week?
SELECT day_name,COUNT(DISTINCT order_id) AS no_of_ordersperday FROM 
(SELECT *,DAYNAME(order_date) AS day_name FROM customer_orders) AS a
GROUP BY  day_name;

-- B) Driver and customer experience

/* 1) What was the avg time in minutes it took for each driver to 
   arrive at the Faasos haed quarters to pickup the order? */

SELECT driver_id, ROUND(SUM(diff)/COUNT(order_id),0) AS avg_mins FROM
(SELECT * FROM
(SELECT *,row_number() OVER (PARTITION BY order_id ORDER BY diff) AS rnk From
(SELECT a.order_id,a.customer_id,a.roll_id,a.not_include_items,
a.extra_items_included,a.order_date,b.driver_id,b.pickup_time,
b.distance,b.duration,b.cancellation, 
TIMESTAMPDIFF(MINUTE, a.order_date, b.pickup_time) AS diff
FROM customer_orders AS a INNER JOIN driver_order AS b ON a.order_id=b.order_id
WHERE b.pickup_time IS NOT NULL) a) b WHERE rnk=1) c
GROUP BY driver_id;

/* 2) Is there any relationship between the number of rolls and how long 
the order takes to prepare? */

SELECT order_id, COUNT(roll_id) cnt,ROUND(SUM(diff)/COUNT(order_id),0) tym FROM 
(SELECT a.order_id,a.customer_id,a.roll_id,a.not_include_items,
a.extra_items_included,a.order_date,b.driver_id,b.pickup_time,
b.distance,b.duration,b.cancellation, 
TIMESTAMPDIFF(MINUTE, a.order_date, b.pickup_time) AS diff
FROM customer_orders AS a INNER JOIN driver_order AS b ON a.order_id=b.order_id
WHERE b.pickup_time IS NOT NULL) R
GROUP BY order_id;

/* 3) What was the average distance travelled for each customer? */

SELECT customer_id,ROUND(SUM(distance)/COUNT(order_id),2) AS avg_distance FROM
(SELECT * FROM
(SELECT *,row_number() OVER (PARTITION BY order_id ORDER BY diff) AS rnk From
(SELECT a.order_id,a.customer_id,a.roll_id,a.not_include_items,
a.extra_items_included,a.order_date,b.driver_id,b.pickup_time,
CAST(TRIM(REPLACE(LOWER(b.distance),'km','')) AS DECIMAL(4,2)) distance,b.duration,b.cancellation, 
TIMESTAMPDIFF(MINUTE, a.order_date, b.pickup_time) AS diff
FROM customer_orders AS a INNER JOIN driver_order AS b ON a.order_id=b.order_id
WHERE b.pickup_time IS NOT NULL) a) b WHERE rnk=1) R
GROUP BY customer_id;

/* 4) What is the difference between the longest and shortest delivery time for all orders? */

SELECT MAX(duration) - MIN(duration) FROM (
SELECT  CAST(CASE WHEN duration LIKE '%min%' THEN LEFT(duration, INSTR(duration,'m')-1) 
        ELSE duration END  AS SIGNED) AS duration FROM driver_order WHERE duration IS NOT NULL)a;

/* 5) What was the average speed for each driver for each delivery and 
do you notice any trend for these values? */

SELECT order_id,driver_id,ROUND(distance/duration,2) AS speed FROM
(SELECT order_id,driver_id,CAST(TRIM(REPLACE(LOWER(distance),'km','')) AS DECIMAL(4,2)) distance,
CAST(CASE WHEN duration LIKE '%min%' THEN LEFT(duration, INSTR(duration,'m')-1) 
        ELSE duration END  AS SIGNED) AS duration FROM driver_order WHERE duration IS NOT NULL) r
INNER JOIN 
(SELECT order_id,COUNT(roll_id) AS cnt FROM customer_orders GROUP BY order_id)i USING(order_id);

/* 6) What is the sucessful delivery percentage for each driver? */

SELECT driver_id, ROUND((SUM(can_per) /COUNT(driver_id))*100,2) AS sdp  FROM 
(SELECT driver_id, CASE WHEN LOWER(cancellation) like '%cancel%' THEN 0 ELSE 1 END AS can_per FROM driver_order) r
GROUP BY driver_id;

