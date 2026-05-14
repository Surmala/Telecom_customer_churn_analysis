CREATE DATABASE telecom_customer_churn_analysis;

-- check for duplicates
ALTER TABLE telecom_customer_churn
RENAME COLUMN `Customer ID` TO Customer_ID;

SELECT Customer_ID,COUNT(Customer_ID) AS Count
FROM telecom_customer_churn
GROUP BY Customer_ID
HAVING COUNT(Customer_ID)>1;

-- How many customers joined the company during the last quarter? How many customers joined?
-- Customers with tenure <=3 months can be considered customers who joined in the last quarted

ALTER TABLE telecom_customer_churn
RENAME COLUMN `Tenure in Months` TO Tenure_in_Months;

SELECT COUNT(*) AS customers_joined_last_quarter
FROM telecom_customer_churn
WHERE Tenure_in_Months <=3;
---  1051

-- total no_of_customers
SELECT
COUNT(DISTINCT Customer_ID) AS counts_of_customer
FROM telecom_customer_churn;
---- 7043


ALTER TABLE telecom_customer_churn
RENAME COLUMN `Total Revenue` TO Total_Revenue;

ALTER TABLE telecom_customer_churn
RENAME COLUMN `Customer Status` TO Customer_Status;


-- How much revenue was lost to churned customers?
SELECT Customer_Status ,
COUNT(Customer_ID) AS customer_count,
ROUND(SUM(Total_Revenue)*100/ SUM(SUM(Total_Revenue)) OVER(),1) AS revenue_percentage
FROM telecom_customer_churn
GROUP BY Customer_Status;

-- It lost 1869 customers and they accounted for 17.2% of total revenue . 
-- 2. Typical tenure for churners:

SELECT 
Tenure_in_Months 
FROM  telecom_customer_churn;
SELECT
	CASE 
		WHEN Tenure_in_Months <= 6 THEN '6 months'
		WHEN Tenure_in_Months <= 12 THEN '1 year'
        WHEN Tenure_in_Months <= 24 THEN '2 Years'
        ELSE '>2 Years'
        END AS Tenure,
        ROUND(COUNT(Customer_ID) *100.0/ SUM(COUNT(Customer_ID)) OVER(),1) AS Churn_Percentage
FROM telecom_customer_churn
WHERE 
Customer_Status ='Churned'
GROUP BY
	CASE 
		WHEN Tenure_in_Months <= 6 THEN '6 months'
		WHEN Tenure_in_Months <= 12 THEN '1 year'
        WHEN Tenure_in_Months <= 24 THEN '2 Years'
        ELSE '>2 Years'
END
ORDER BY 
Churn_Percentage DESC;     

-- Found that ~41.9% of churned customers spent 6 months or less before leaving

-- which city has the highest churn rates?
SELECT  City,
COUNT(CASE WHEN Customer_Status ='Churned' THEN 1 END)AS Churned_Customers,
COUNT(*) AS total_customers,
ROUND(COUNT(CASE WHEN Customer_Status='Churned' THEN 1 END)*100.0 /COUNT(*),2)AS Churn_rate_pct
FROM telecom_customer_churn
GROUP BY City 
HAVING COUNT(*) >30
ORDER BY Churn_rate_pct DESC
LIMIT 1;

-- San Diego has the highest churn rate at 64.91% which means that over half of the customers have left their company 

ALTER TABLE telecom_customer_churn
RENAME COLUMN `Churn Category` TO Churn_Category;

SELECT Churn_Category
FROM telecom_customer_churn;

SELECT Churn_Category,
ROUND(SUM(Total_Revenue),0)AS Total_rev,
ROUND(COUNT(*) * 100.0/ SUM(COUNT(*)) OVER()) AS Churned_pct
FROM telecom_customer_churn
WHERE Customer_Status='Churned'
GROUP BY Churn_Category
ORDER BY Churned_pct DESC;

-- 44% of churned customers stated Competitor as their reason of leaving and 17% left due to attitude of support staff.

ALTER TABLE telecom_customer_churn
RENAME COLUMN `Churn Reason` TO Churn_Reason;

-- why exactly did customers leave
SELECT 
Churn_Reason,
Churn_Category,
ROUND(COUNT(*)*100 / SUM(COUNT(*)) OVER(),1) AS churn_pct
FROM telecom_customer_churn
WHERE Customer_Status= 'Churned'
GROUP BY Churn_Reason,
Churn_Category
ORDER BY churn_pct DESC
LIMIT 5;

-- the specific churn reason was 'Competitor had better devices' ,'Competitor made better offer' and 'Attitude of support person'

-- did churners have premium tech support

ALTER TABLE telecom_customer_churn
RENAME COLUMN `Premium Tech Support` TO Premium_Tech_Support;

SELECT 
Premium_Tech_Support,
COUNT(*) AS Churned,
ROUND(COUNT(*)*100 /SUM(COUNT(*)) OVER(),1) AS churned_pct
FROM  telecom_customer_churn
WHERE Customer_Status='Churned'
GROUP BY Premium_Tech_Support
ORDER BY churned_pct DESC;

-- 77.4% of churned customers didnot have premium tech support.


-- any offers were provide to the churned customers


SELECT 
    COALESCE(Offer, 'No Offer') AS Offer,
    ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER(), 1) AS churned_pct
FROM telecom_customer_churn
WHERE Customer_Status = 'Churned'
GROUP BY COALESCE(Offer, 'No Offer')
ORDER BY churned_pct DESC;

-- almost 56.2 % didnot have any offer while 22.8% has offer execute

ALTER TABLE telecom_customer_churn
RENAME COLUMN `Internet Type` TO Internet_Type;

SELECT Internet_Type,
COUNT(*) AS churned,
ROUND(COUNT(*)*100/ SUM(COUNT(*)) OVER(),1) AS churned_pct
FROM telecom_customer_churn
WHERE Customer_Status='Churned'
GROUP BY Internet_Type
ORDER BY churned_pct DESC;

-- 66.1 % of all churned customers used Fiber Optic 

-- What Internet Type did 'Competitor' churners have?
SELECT
    Internet_Type,
    Churn_Category,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Pct
FROM
  telecom_customer_churn
WHERE 
    Customer_Status = 'Churned'
    AND Churn_Category = 'Competitor'
GROUP BY
Internet_Type,
Churn_Category
ORDER BY Churn_Pct DESC;

-- -- 69.8 % of all churned customers who left for competitor also used Fiber Optic 

-- what contract were churners on ?
-- What contract were churners on?
SELECT 
    Contract,
    COUNT(Customer_ID) AS Churned,
    ROUND(COUNT(Customer_ID) * 100.0 / SUM(COUNT(Customer_ID)) OVER(), 1) AS Churn_Percentage
FROM 
     telecom_customer_churn
WHERE
    Customer_Status = 'Churned'
GROUP BY
    Contract
ORDER BY 
    Churned DESC;
    -- 88.6% of churned customers were on Month-On-Month contract
    