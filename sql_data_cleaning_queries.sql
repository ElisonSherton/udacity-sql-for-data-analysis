-- In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.

SELECT RIGHT(acc.website, 3) AS webExtensions,
	   COUNT(RIGHT(acc.website, 3))
FROM accounts acc
GROUP BY 1

-- There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number).

    SELECT LEFT(acc.name, 1) as first_char,
        COUNT(*) fc_count
    FROM accounts acc
    GROUP BY first_char
    ORDER BY fc_count DESC

-- Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?

SELECT CASE WHEN LEFT(acc.name, 1) IN ('0', '1', '2', '3', '4', '5', '6' , '7', '8', '9') THEN 'Number'
	        ELSE 'Letter' END AS type_fc,
	   COUNT(*) fc_count
FROM accounts acc
GROUP BY type_fc
ORDER BY fc_count DESC

-- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?

SELECT CASE WHEN LEFT(acc.name, 1) IN ('A', 'E', 'I', 'O', 'U') THEN 'Vowel'
	        ELSE 'Non-Vovel' END AS type_fc,
	   COUNT(*) fc_count
FROM accounts acc
GROUP BY type_fc
ORDER BY fc_count DESC

-- Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc.

SELECT acc.primary_poc,
       LEFT(acc.primary_poc, POSITION(' ' IN acc.primary_poc) - 1) AS firstName,
	   RIGHT(acc.primary_poc, LENGTH(acc.primary_poc) - POSITION(' ' IN acc.primary_poc)) AS lastName
FROM accounts acc

-- Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.

SELECT sr.name,
       LEFT(sr.name, POSITION(' ' IN sr.name) - 1) AS firstName,
	   RIGHT(sr.name, LENGTH(sr.name) - POSITION(' ' IN sr.name)) AS lastName
FROM sales_reps sr

-- Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.ABORT

WITH table1 AS (
				SELECT acc.name,
					   LEFT(acc.primary_poc, POSITION(' ' IN acc.primary_poc) - 1) AS firstName,
					   RIGHT(acc.primary_poc, LENGTH(acc.primary_poc) - POSITION(' ' IN acc.primary_poc)) AS lastName
				FROM accounts acc
			   )
SELECT table1.name,
       CONCAT(table1.firstName, '.', table1.lastName, '@', table1.name, '.com')
FROM table1

-- You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 1. Some helpful documentation is here.

WITH table1 AS (
				SELECT acc.name,
					   LEFT(acc.primary_poc, POSITION(' ' IN acc.primary_poc) - 1) AS firstName,
					   RIGHT(acc.primary_poc, LENGTH(acc.primary_poc) - POSITION(' ' IN acc.primary_poc)) AS lastName
				FROM accounts acc
			   )
SELECT table1.name,
       CONCAT(table1.firstName, '.', table1.lastName, '@', REPLACE(REPLACE(table1.name, ' ', ''), '.', ''), '.com')
FROM table1

-- We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.

WITH table1 AS (
				SELECT acc.name,
					   LEFT(acc.primary_poc, POSITION(' ' IN acc.primary_poc) - 1) AS firstName,
					   RIGHT(acc.primary_poc, LENGTH(acc.primary_poc) - POSITION(' ' IN acc.primary_poc)) AS lastName
				FROM accounts acc
			   )
SELECT table1.name,
       CONCAT(LOWER(LEFT(table1.firstName, 1)),
			  LOWER(RIGHT(table1.firstName, 1)),
			  LOWER(LEFT(table1.lastName, 1)),
			  LOWER(RIGHT(table1.lastName, 1)),
			  LENGTH(table1.firstName),
			  LENGTH(table1.lastName),
			  REPLACE(UPPER(table1.name), ' ', '')),
FROM table1

-- 

SELECT *,
       COALESCE(a.id, o.account_id) AS id,
       COALESCE(o.account_id, a.id) AS account_id,
       COALESCE(o.standard_qty, 0) AS standard_qty,
       COALESCE(o.gloss_qty, 0) AS gloss_qty,
       COALESCE(o.poster_qty, 0) AS poster_qty,
       COALESCE(o.standard_amt_usd, 0) AS standard_amt_usd,
       COALESCE(o.gloss_amt_usd, 0) AS gloss_amt_usd,
       COALESCE(o.poster_amt_usd, 0) AS poster_amt_usd,
       COALESCE(o.total, 0) AS total,
       COALESCE(o.total_amt_usd, 0) AS total_amt_usd
       
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;