-- Find the total amount of poster_qty paper ordered in the orders table.

SELECT SUM(poster_qty)
FROM orders

-- Find the total amount of standard_qty paper ordered in the orders table.

SELECT SUM(standard_qty)
FROM orders

-- Find the total dollar amount of sales using the total_amt_usd in the orders table.

SELECT SUM(total_amt_usd)
FROM orders

-- Find the total amount spent on standard_amt_usd and gloss_amt_usd paper for each order in the orders table. This should give a dollar amount for each order in the table.

SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders

-- Find the standard_amt_usd per unit of standard_qty paper. Your solution should use both an aggregation and a mathematical operator.

SELECT SUM(standard_amt_usd) / SUM(standard_qty)
FROM orders

-- When was the earliest order ever placed? You only need to return the date.

SELECT MIN(occurred_at)
FROM orders

-- Try performing the same query as in question 1 without using an aggregation function.

SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1

-- When did the most recent (latest) web_event occur?

SELECT MAX(occurred_at)
FROM web_events


-- Try to perform the result of the previous query without using an aggregation function.

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1

-- Find the mean (AVERAGE) amount spent per order on each paper type, as well as the mean amount of each paper type purchased per order. Your final answer should have 6 values - one for each paper type for the average number of sales, as well as the average amount.

SELECT AVG(standard_qty) standard_qty_avg,
	   AVG(gloss_qty) gloss_qty_avg,
       AVG(poster_qty) poster_qty_avg,
       AVG(standard_amt_usd / (standard_qty + 0.01)) standard_price_avg,
       AVG(gloss_amt_usd / (gloss_qty + 0.01)) gloss_price_avg,
       AVG(poster_amt_usd / (poster_qty + 0.01)) poster_price_avg
FROM orders

-- Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders?

SELECT total_amt_usd FROM (SELECT * 
FROM orders
ORDER BY total_amt_usd
LIMIT (SELECT COUNT(*) FROM orders) / 2) AS a
ORDER BY a.total_amt_usd DESC
LIMIT 2

-- Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.

SELECT acc.name, o.occurred_at
FROM orders o
JOIN accounts acc
ON o.account_id = acc.id
ORDER BY o.occurred_at
LIMIT 1

-- Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.

SELECT acc.name, SUM(o.total_amt_usd)
FROM orders o
JOIN accounts acc
ON o.account_id = acc.id
GROUP BY acc.name

-- Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.

SELECT we.occurred_at, we.channl, acc.name
FROM web_events we
JOIN accounts acc
ON we.account_id = acc.id
ORDER BY we.occurred_at DESC
LIMIT 1

-- Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.

SELECT we.channl, COUNT(*)
FROM web_events we
GROUP BY we.channl

-- Who was the primary contact associated with the earliest web_event?

SELECT acc.primary_poc
FROM accounts acc
JOIN web_events we
ON we.account_id = acc.id
ORDER BY we.occurred_at
LIMIT 1

-- What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.

SELECT acc.name, MIN(o.total_amt_usd) AS total_amt
FROM orders o
JOIN accounts acc
ON o.account_id = acc.id
GROUP BY acc.name
ORDER BY total_amt

-- Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.

SELECT r.name, COUNT(*) count_reps
FROM sales_reps s
JOIN region r
ON s.region_id = r.id
GROUP BY r.name
ORDER BY count_reps