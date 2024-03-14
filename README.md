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




