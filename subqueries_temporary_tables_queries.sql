-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.


--For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?

SELECT *
FROM(
	SELECT r.name regionName, 
		   SUM(o.total_amt_usd) salesAmount,
	       COUNT(o.total) totalOrders
	FROM orders o
	JOIN accounts acc
	ON o.account_id = acc.id
	JOIN sales_reps sr
	ON acc.sales_rep_id = sr.id
	JOIN region r
	ON sr.region_id = r.id
	GROUP BY r.name
	) sub
ORDER BY salesamount DESC
LIMIT 1


-- How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?

SELECT o.account_id, SUM(o.total) total_purchases
FROM orders o
GROUP BY o.account_id
HAVING SUM(o.total) > (SELECT total_orders FROM(
												SELECT acc.id accId, SUM(o.standard_qty) max_standard_qty, SUM(o.total) total_orders
												FROM orders o
												JOIN accounts acc
												on o.account_id = acc.id
												GROUP BY acc.id
												ORDER BY max_standard_qty DESC
												LIMIT 1 
												) AS sub1
						)

-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

SELECT we.channl, COUNT(we.channl)
FROM web_events we
WHERE we.account_id =(
						(
						SELECT o.account_id
						FROM orders o
						GROUP BY o.account_id
						ORDER BY SUM(o.total_amt_usd) DESC
						LIMIT 1
						)
					 )
 GROUP BY we.channl

-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

SELECT o.account_id, AVG(o.total_amt_usd)
FROM orders o
WHERE o.account_id IN (
						(
						SELECT o.account_id
						FROM orders o
						GROUP BY o.account_id
						ORDER BY SUM(o.total_amt_usd) DESC
						LIMIT 10
						)
					  )
 GROUP BY o.account_id


-- What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.

SELECT o.account_id, AVG(o.total_amt_usd)
FROM orders o
GROUP BY o.account_id
HAVING AVG(o.total_amt_usd) > (SELECT AVG(o.total_amt_usd)
								FROM orders o)

-- Perform all the queries above using a WITH clause

-- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

WITH table1 AS (
	SELECT sr.name salesrepname, r.name regionname, SUM(total_amt_usd) sales
	FROM orders o
	JOIN accounts acc
	ON o.account_id = acc.id
	JOIN sales_reps sr
	ON acc.sales_rep_id = sr.id
	JOIN region r
	ON sr.region_id = r.id
	GROUP BY sr.name, r.name
),
table2 AS(
	SELECT regionname, MAX(sales) sales 
	FROM table1
	GROUP BY regionname
)

SELECT table1.salesrepname, table1.regionname, table1.sales
FROM table1
JOIN table2
ON table1.regionname = table2.regionname AND table2.sales = table1.sales

-- For the region with the largest sales total_amt_usd, how many total orders were placed?

WITH table1 AS  (
				SELECT r.name region, SUM(o.total_amt_usd) sales, COUNT(o.total) qty
				FROM orders o
				JOIN accounts acc
				ON o.account_id = acc.id
				JOIN sales_reps sr
				ON acc.sales_rep_id = sr.id
				JOIN region r
				ON sr.region_id = r.id
				GROUP BY r.name
				ORDER BY sales DESC
				LIMIT 1
				)
SELECT qty
FROM table1

-- How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer?

WITH table1 AS (
				SELECT acc.id accountId
				FROM orders o
				JOIN accounts acc
				ON o.account_id = acc.id
				GROUP BY acc.id
				ORDER BY SUM(standard_qty) DESC
				LIMIT 1
				),
	table2 AS (
				SELECT SUM(o.total)
				FROM orders o
				WHERE o.account_id = (SELECT * FROM table1)
				),
	table3 AS (
				SELECT o.account_id, SUM(o.total)
				FROM orders o
				GROUP BY o.account_id
				HAVING SUM(o.total) > (SELECT * FROM table2)
				)
SELECT COUNT(*) nAccounts
FROM table3

-- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

WITH table1 AS (
				SELECT o.account_id accountId
				FROM orders o
				GROUP BY o.account_id
				ORDER BY SUM(o.total_amt_usd) DESC
				LIMIT 1
				)
				
SELECT we.channl, COUNT(*)
FROM web_events we
WHERE we.account_id = (SELECT accountId FROM table1)
GROUP BY we.channl

-- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

WITH table1 AS (
				SELECT o.account_id, SUM(o.total_amt_usd) totalAmtUSD
				FROM orders o
				GROUP BY o.account_id
				ORDER BY SUM(o.total_amt_usd) DESC
				LIMIT 10
				)
SELECT AVG(totalAmtUSD)
FROM table1

-- What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.

WITH table1 AS (
				SELECT AVG(o.total_amt_usd)
				FROM orders o
				),

table2 AS (
		   SELECT o.account_id, AVG(o.total_amt_usd) averageTotalAmount
		   FROM orders o
		   GROUP BY o.account_id
		   HAVING AVG(o.total_amt_usd) > (SELECT * FROM table1)
		 )
		 
 SELECT AVG(averagetotalamount)
 FROM table2
