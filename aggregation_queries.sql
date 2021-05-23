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

-- For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.

SELECT acc.name as accountName, AVG(o.standard_qty) standard,
       AVG(o.gloss_qty) gloss, AVG(o.poster_qty) poster
FROM orders o
JOIN accounts acc
ON o.account_id = acc.id
GROUP BY acc.name

-- For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.

SELECT acc.name as accountName, AVG(o.standard_amt_usd) standard,
       AVG(o.gloss_amt_usd) gloss, AVG(o.poster_amt_usd) poster
FROM orders o
JOIN accounts acc
ON o.account_id = acc.id
GROUP BY acc.name

-- Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.

SELECT sr.name, we.channl, COUNT(*) occurred
FROM web_events we
JOIN accounts acc
ON we.account_id = acc.id
JOIN sales_reps sr
ON acc.sales_rep_id = sr.id
GROUP BY we.channl, sr.name
ORDER BY occurred DESC

-- Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.

SELECT r.name, we.channl, COUNT(*) occurred
FROM web_events we
JOIN accounts acc
ON we.account_id = acc.id
JOIN sales_reps sr
ON acc.sales_rep_id = sr.id
JOIN region r
ON sr.region_id = r.id
GROUP BY r.name, we.channl
ORDER BY occurred DESC

-- Use DISTINCT to test if there are any accounts associated with more than one regio

SELECT acc.name, COUNT(r.name)
FROM accounts acc
JOIN sales_reps sr
ON acc.sales_rep_id = sr.id
JOIN region r
ON sr.region_id = r.id
GROUP BY acc.name

-- Have any sales reps worked on more than one account?

SELECT sr.name SRName, acc.name AccName
FROM sales_reps sr
JOIN accounts acc
ON acc.sales_rep_id = sr.id

-- How many of the sales reps have more than 5 accounts that they manage?

SELECT sr.name, COUNT(acc.name) no_of_accounts
FROM sales_reps sr
JOIN accounts acc
ON acc.sales_rep_id = sr.id
GROUP BY sr.name
HAVING COUNT(acc.name) > 5

-- How many accounts have more than 20 orders?

SELECT acc.name, COUNT(o.id) AS order_count
FROM orders o
JOIN accounts acc
ON o.account_id = acc.id
GROUP BY acc.name
HAVING COUNT(o.id) > 20

-- Which account has the most orders?

SELECT acc.name, COUNT(o.id) AS order_count
FROM orders o
JOIN accounts acc
ON o.account_id = acc.id
GROUP BY acc.name
ORDER BY COUNT(o.id) DESC
LIMIT 1

-- Which accounts spent more than 30,000 usd total across all orders?

SELECT acc.name, SUM(o.total_amt_usd) AS AccountRevenue
FROM orders o
JOIN accounts acc
ON o.account_id = acc.id
GROUP BY acc.name
HAVING SUM(o.total_amt_usd) > 30000

-- Which accounts spent less than 1,000 usd total across all orders?

SELECT acc.name, SUM(o.total_amt_usd) AS AccountRevenue
FROM orders o
JOIN accounts acc
ON o.account_id = acc.id
GROUP BY acc.name
HAVING SUM(o.total_amt_usd) < 1000

-- Which account has spent the most with us?

SELECT acc.name, SUM(o.total_amt_usd) AS AccountRevenue
FROM orders o
JOIN accounts acc
ON o.account_id = acc.id
GROUP BY acc.name
ORDER BY SUM(o.total_amt_usd) DESC
LIMIT 1

-- Which account has spent the least with us?

SELECT acc.name, SUM(o.total_amt_usd) AS AccountRevenue
FROM orders o
JOIN accounts acc
ON o.account_id = acc.id
GROUP BY acc.name
ORDER BY SUM(o.total_amt_usd) 
LIMIT 1

-- Which accounts used facebook as a channel to contact customers more than 6 times?

SELECT acc.name, we.channl, COUNT(we.channl) AS channel_sum
FROM web_events we
JOIN accounts acc
ON we.account_id = acc.id
WHERE we.channl = 'facebook'
GROUP BY acc.name, we.channl
HAVING COUNT(we.channl) > 6

-- Which account used facebook most as a channel?

SELECT acc.name, we.channl, COUNT(we.channl) AS channel_sum
FROM web_events we
JOIN accounts acc
ON we.account_id = acc.id
WHERE we.channl = 'facebook'
GROUP BY acc.name, we.channl
ORDER BY COUNT(we.channl) DESC
LIMIT 1

-- Which channel was most frequently used by most accounts

-- a. By most accounts
SELECT channl, COUNT(name) AS frequency, SUM(max) AS timesUsed
FROM
(SELECT name, channl, MAX(channel_sum)
FROM
(SELECT acc.name, we.channl, COUNT(we.channl) AS channel_sum
FROM web_events we
JOIN accounts acc
ON we.account_id = acc.id
GROUP BY we.channl, acc.name
ORDER BY acc.name) AS table1
GROUP BY name, channl) AS table2
GROUP BY channl
ORDER BY frequency DESC
LIMIT 1

-- b. By all accounts
SELECT a.id, a.name, w.channl, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channl
ORDER BY use_of_channel DESC
LIMIT 10;

SELECT name, channl, MAX(channel_sum) most_used
FROM
(SELECT acc.name, we.channl, COUNT(we.channl) AS channel_sum
FROM web_events we
JOIN accounts acc
ON we.account_id = acc.id
GROUP BY we.channl, acc.name
ORDER BY acc.name) AS table1
GROUP BY name, channl
ORDER BY most_used DESC

-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?

SELECT DATE_PART('year', o.occurred_at) as year,
       SUM(total) as yearly_revenue
FROM orders o
GROUP BY DATE_PART('year', o.occurred_at)
ORDER BY yearly_revenue DESC

-- Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?

SELECT DATE_PART('month', o.occurred_at) as month,
       SUM(total) as monthly_revenue
FROM orders o
WHERE o.occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY DATE_PART('month', o.occurred_at)
ORDER BY monthly_revenue DESC

-- Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?

SELECT DATE_PART('year', o.occurred_at) as year,
       COUNT(o.id) as order_counts
FROM orders o

GROUP BY DATE_PART('year', o.occurred_at)
ORDER BY order_counts DESC


-- Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?

SELECT DATE_PART('month', o.occurred_at) as month,
       COUNT(o.id) as order_counts
FROM orders o
WHERE o.occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY DATE_PART('month', o.occurred_at)
ORDER BY order_counts DESC

-- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?

SELECT DATE_PART('year', o.occurred_at) yr,
       DATE_PART('month', o.occurred_at) mth,
       COUNT(o.id) as order_counts,
	   SUM(o.gloss_amt_usd) as gloss_amount_usd
FROM orders o
JOIN accounts acc
ON o.account_id = acc.id
WHERE acc.name = 'Walmart'
GROUP BY DATE_PART('year', o.occurred_at), DATE_PART('month', o.occurred_at)
ORDER BY gloss_amount_usd DESC
LIMIT 1

-- Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.

SELECT o.account_id, o.total_amt_usd,
       CASE WHEN o.total_amt_usd > 3000 THEN 'LARGE'
	        WHEN o.total_amt_usd > 0 AND o.total_amt_usd <= 3000 THEN 'SMALL' END AS CustomerLevel
FROM orders o

-- Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT CASE WHEN o.total >= 2000 THEN 'At Least 2000'
	        WHEN o.total >=1000 AND o.total < 2000 THEN 'Between 1000 and 2000'
			WHEN o.total >=0. AND o.total < 1000 THEN 'Less than 1000' END AS orderType,
	   COUNT(*) AS orderCount
FROM orders o
GROUP BY 1

-- We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.

SELECT acc.name AS AccountName,
	   SUM(o.total_amt_usd) AS AccountRevenue,
	   CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'greater than 200,000'
	   		WHEN SUM(o.total_amt_usd) > 100000 AND SUM(o.total_amt_usd) <= 200000 THEN '100,000 to 200,000'
			WHEN SUM(o.total_amt_usd) > 0 AND SUM(o.total_amt_usd) <= 100000 THEN 'under 100000' END AS CustomerType
FROM accounts acc
JOIN orders o
ON o.account_id = acc.id
GROUP BY acc.name
ORDER BY SUM(o.total_amt_usd) DESC

-- We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.

SELECT acc.name AS AccountName,
	   SUM(o.total_amt_usd) AS AccountRevenue,
	   CASE WHEN SUM(o.total_amt_usd) > 200000 THEN 'greater than 200,000'
	   		WHEN SUM(o.total_amt_usd) > 100000 AND SUM(o.total_amt_usd) <= 200000 THEN '100,000 to 200,000'
			WHEN SUM(o.total_amt_usd) > 0 AND SUM(o.total_amt_usd) <= 100000 THEN 'under 100000' END AS CustomerType
FROM accounts acc
JOIN orders o
ON o.account_id = acc.id
WHERE DATE_PART('year', o.occurred_at) BETWEEN '2016' AND '2017'
GROUP BY acc.name
ORDER BY SUM(o.total_amt_usd) DESC

-- We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.

SELECT sr.name AS SalesRep,
	   COUNT(o.id) AS OrdersBagged,
	   CASE WHEN COUNT(o.id) > 200 THEN 'top'
	   		WHEN COUNT(o.id) > 0 AND COUNT(o.id) <= 200 THEN 'not' END AS salesRepType
FROM accounts acc
JOIN orders o
ON o.account_id = acc.id
JOIN sales_reps sr
ON acc.sales_rep_id = sr.id
GROUP BY sr.name
ORDER BY COUNT(o.id) DESC

-- The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!

SELECT sr.name AS SalesRep,
	   COUNT(o.id) AS OrdersBagged,
	   SUM(o.total_amt_usd) AS OrderTotal,
	   CASE WHEN COUNT(o.id) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
	   		WHEN COUNT(o.id) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
	   		ELSE 'low' END AS salesRepType
FROM accounts acc
JOIN orders o
ON o.account_id = acc.id
JOIN sales_reps sr
ON acc.sales_rep_id = sr.id
GROUP BY sr.name
ORDER BY SUM(o.total_amt_usd) DESC