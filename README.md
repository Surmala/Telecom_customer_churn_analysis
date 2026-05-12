Project Overview:
This project analyses customer churn data for a telecom company "Maven" using SQL queries and Power BI.
The goal is to identify churn patterns ,revenue loss,customer behaviour and business insights that can help improve customer retention strategies.

This analysis include:
Customer churn trends
Revenue impact
Customer tenure analysis
Churn Reasons
Contract and internet type analysis
Support service impact on churn

The main steps for this project are:
Data Cleaning and Preparation
Exploratory Data Analysis
Building the Ideal Churn Profile
Data Insights
Customer Retention Strategies
Data Visualisation


Data cleaning and preparation:
There may be null values in the dataset beacause all customers have unique combination of subscription preferences .Therefore checked for duplicate values and found none
SELECT Customer_ID,COUNT(Customer_ID) AS Count
FROM telecom_customer_churn
GROUP BY Customer_ID
HAVING COUNT(Customer_ID)>1;
