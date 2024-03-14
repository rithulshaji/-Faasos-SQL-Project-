# Fassos SQL Project

This project contains SQL scripts and queries related to a hypothetical database for a food delivery service called Fassos.

## Introduction <a name="introduction"></a>
This project involves a SQL database for managing orders, drivers, ingredients, and rolls for a food delivery service. The database schema includes tables for drivers, ingredients, rolls, customer orders, and driver orders.

## Database Schema <a name="database-schema"></a>
- **driver**: Stores information about drivers, including their unique ID and registration date.
- **ingredients**: Contains a list of ingredients along with their unique IDs.
- **rolls**: Stores types of rolls offered by Fassos.
- **rolls_recipes**: Provides a mapping of roll IDs to the ingredients used in each roll.
- **driver_order**: Records details of orders delivered by drivers, including pickup time, distance, duration, and cancellation status.
- **customer_orders**: Stores information about customer orders, including customer ID, roll ID, additional items, and order date.

### `driver` Table

| Column       | Description                             | Data Type |
|--------------|-----------------------------------------|-----------|
| driver_id    | Unique identifier for drivers           | INTEGER   |
| reg_date     | Date when the driver registered         | DATE      |

### `ingredients` Table

| Column            | Description                      | Data Type |
|-------------------|----------------------------------|-----------|
| ingredients_id    | Unique identifier for ingredients| INTEGER   |
| ingredients_name  | Name of the ingredient           | VARCHAR   |

### `rolls` Table

| Column    | Description                  | Data Type |
|-----------|------------------------------|-----------|
| roll_id   | Unique identifier for rolls  | INTEGER   |
| roll_name | Name of the roll             | VARCHAR   |

### `rolls_recipes` Table

| Column       | Description                               | Data Type |
|--------------|-------------------------------------------|-----------|
| roll_id      | Unique identifier for rolls               | INTEGER   |
| ingredients  | List of ingredient IDs used in each roll | VARCHAR   |

### `driver_order` Table

| Column         | Description                                | Data Type |
|----------------|--------------------------------------------|-----------|
| order_id       | Unique identifier for orders               | INTEGER   |
| driver_id      | Unique identifier for drivers              | INTEGER   |
| pickup_time    | Date and time of pickup                    | DATETIME  |
| distance       | Distance of delivery                       | VARCHAR   |
| duration       | Duration of delivery                       | VARCHAR   |
| cancellation   | Status of order (e.g., 'Cancellation')    | VARCHAR   |

### `customer_orders` Table

| Column            | Description                              | Data Type |
|-------------------|------------------------------------------|-----------|
| order_id          | Unique identifier for orders             | INTEGER   |
| customer_id       | Unique identifier for customers          | INTEGER   |
| roll_id           | Unique identifier for rolls              | INTEGER   |
| not_include_items | Items not included in the order          | VARCHAR   |
| extra_items_included | Additional items included in the order | VARCHAR   |
| order_date        | Date and time of the order               | DATETIME  |


## Queries <a name="queries"></a>

### Rolls Matrix <a name="rolls-matrix"></a>
1. How many rolls were ordered?
2. How many unique customer orders were made?
3. How many successful orders were delivered by each driver?
4. How many of each type of roll was delivered?
5. How many veg and non-veg rolls were ordered by each customer?
6. What was the maximum number of orders delivered in a single order?
7. For each customer, how many delivered rolls had at least one change, and how many had no change?
8. How many rolls that were delivered had both exclusions and extras?
9. What was the total number of rolls ordered for each hour of the day?
10. What was the number of orders for each day of the week?

### Driver and Customer Experience <a name="driver-and-customer-experience"></a>
1. What was the average time in minutes it took for each driver to arrive at the Fassos headquarters to pick up the order?
2. Is there any relationship between the number of rolls and how long the order takes to prepare?
3. What was the average distance traveled for each customer?
4. What is the difference between the longest and shortest delivery time for all orders?
5. What was the average speed for each driver for each delivery, and do you notice any trend for these values?
6. What is the successful delivery percentage for each driver?

## Code

``` SQL
-- Create database
CREATE DATABASE IF NOT EXISTS faasos_test;

-- Use the created database
USE faasos_test;

-- Create table for drivers
CREATE TABLE IF NOT EXISTS driver (
    driver_id INTEGER,
    reg_date DATE
);

-- Insert sample data into the driver table
INSERT INTO driver (driver_id, reg_date) VALUES
(1, '2021-01-01'),
(2, '2021-01-03'),
(3, '2021-01-08'),
(4, '2021-01-15');

-- Create table for ingredients
CREATE TABLE IF NOT EXISTS ingredients (
    ingredients_id INTEGER,
    ingredients_name VARCHAR(60)
);

-- Insert sample data into the ingredients table
INSERT INTO ingredients (ingredients_id, ingredients_name) VALUES
(1, 'BBQ Chicken'),
(2, 'Chilli Sauce'),
(3, 'Chicken'),
(4, 'Cheese'),
(5, 'Kebab'),
(6, 'Mushrooms'),
(7, 'Onions'),
(8, 'Egg'),
(9, 'Peppers'),
(10, 'Schezwan Sauce'),
(11, 'Tomatoes'),
(12, 'Tomato Sauce');

-- Create table for rolls
CREATE TABLE IF NOT EXISTS rolls (
    roll_id INTEGER,
    roll_name VARCHAR(30)
);

-- Insert sample data into the rolls table
INSERT INTO rolls (roll_id, roll_name) VALUES
(1, 'Non Veg Roll'),
(2, 'Veg Roll');

-- Create table for rolls recipes
CREATE TABLE IF NOT EXISTS rolls_recipes (
    roll_id INTEGER,
    ingredients VARCHAR(24)
);

-- Insert sample data into the rolls_recipes table
INSERT INTO rolls_recipes (roll_id, ingredients) VALUES
(1, '1,2,3,4,5,6,8,10'),
(2, '4,6,7,9,11,12');

-- Create table for driver orders
CREATE TABLE IF NOT EXISTS driver_order (
    order_id INTEGER,
    driver_id INTEGER,
    pickup_time DATETIME,
    distance VARCHAR(7),
    duration VARCHAR(10),
    cancellation VARCHAR(23)
);

-- Insert sample data into the driver_order table
INSERT INTO driver_order (order_id, driver_id, pickup_time, distance, duration, cancellation) VALUES
(1, 1, '2021-01-01 18:15:34', '20km', '32 minutes', ''),
(2, 1, '2021-01-01 19:10:54', '20km', '27 minutes', ''),
(3, 1, '2021-01-03 00:12:37', '13.4km', '20 mins', 'NaN'),
(4, 2, '2021-01-04 13:53:03', '23.4', '40', 'NaN'),
(5, 3, '2021-01-08 21:10:57', '10', '15', 'NaN'),
(6, 3, NULL, NULL, NULL, 'Cancellation'),
(7, 2, '2021-01-08 21:30:45', '25km', '25mins', NULL),
(8, 2, '2021-01-10 00:15:02', '23.4 km', '15 minute', NULL),
(9, 2, NULL, NULL, NULL, 'Customer Cancellation'),
(10, 1, '2021-01-11 18:50:20', '10km', '10minutes', NULL);

-- Create table for customer orders
CREATE TABLE IF NOT EXISTS customer_orders (
    order_id INTEGER,
    customer_id INTEGER,
    roll_id INTEGER,
    not_include_items VARCHAR(4),
    extra_items_included VARCHAR(4),
    order_date DATETIME
);

-- Insert sample data into the customer_orders table
INSERT INTO customer_orders (order_id, customer_id, roll_id, not_include_items, extra_items_included, order_date) VALUES
(1, 101, 1, '', '', '2021-01-01 18:05:02'),
(2, 101, 1, '', '', '2021-01-01 19:00:52'),
(3, 102, 1, '', '', '2021-01-02 23:51:23'),
(3, 102, 2, '', 'NaN', '2021-01-02 23:51:23'),
(4, 103, 1, '4', '', '2021-01-04 13:23:46'),
(4, 103, 1, '4', '', '2021-01-04 13:23:46'),
(4, 103, 2, '4', '', '2021-01-04 13:23:46'),
(5, 104, 1, NULL, '1', '2021-01-08 21:00:29'),
(6, 101, 2, NULL, NULL, '2021-01-08 21:03:13'),
(7, 105, 2, NULL, '1', '2021-01-08 21:20:29'),
(8, 102, 1, NULL, NULL, '2021-01-09 23:54:33'),
(9, 103, 1, '4', '1,5', '2021-01-10 11:22:59'),
(10, 104, 1, NULL, NULL, '2021-01-11 18:34:49'),
(10, 104, 1, '2,6', '1,4', '2021-01-11 18:34:49');
```


