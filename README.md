# SQL-Sales-Customer-Analytics-Project
Project
📌 Project Overview

This project is a collection of SQL queries and views designed to perform data analysis on a retail sales database. It covers sales performance, customer behavior, product segmentation, and reporting. The queries are written for Oracle SQL syntax but can be adapted for other SQL engines.
The main goal is to demonstrate how SQL can be used for business intelligence tasks such as:
Tracking changes over time
Performing cumulative analysis
Comparing performance across products
Finding contributions to totals (part-of-whole analysis)
Creating customer and product segments
Building reports for business decision-making

🔑 Key Analyses
1. Changes Over Time

By Year: Total sales, unique customers, and total quantity aggregated annually.
By Month: Sales, customers, and quantity summarized by calendar month.
👉 Purpose: Shows sales trends and customer activity over different periods.

2. Cumulative Analysis
Monthly Cumulative Sales: Progressive running total of sales across months.
Yearly Cumulative Sales: Running total of yearly sales.
👉 Purpose: Helps visualize growth and long-term progress.

4. Performance Analysis
Analyzes sales performance per product by year.
Compares current yearly sales with the product’s average sales across years.
Labels performance as:
Above Average
Below Average
Average
👉 Purpose: Identify which products are performing better or worse compared to their own historical average.

5. Part-of-Whole Analysis
Groups sales by product categories.
Shows each category’s contribution to the overall revenue as a percentage.
👉 Purpose: Understand which product categories generate the most sales.

5. Product Segmentation
Classifies products into cost ranges:
Below 100
100–500
500–1000
Above 1000
👉 Purpose: Useful for analyzing product distribution across price tiers.

6. Customer Segmentation
Calculates total spending and lifespan of each customer.
Groups customers into segments:
VIP: Long-term + high spending
Regular: Long-term + lower spending
New: Short-term or first-time customers
👉 Purpose: Helps in targeted marketing and loyalty programs.

7. Customer Reports (View Creation)
Created a view report_customers that provides a full profile of customers, including:
Basic details (ID, name, age)
Age group classification
Customer segment (VIP, Regular, New)
Purchase history: total orders, sales, quantity, unique products
Recency: Time since last purchas
Lifespan: Duration between first and last order
👉 Purpose: Ready-to-use report for business insights and dashboards.

📂 Project Structure
Changes Over Year Analysis – yearly sales, customers, quantities
Changes Over Month Analysis – monthly breakdown
Cumulative Analysis – running totals over time
Performance Analysis – product-level performance vs. average
Part of Whole Analysis – category-level contributions
Data Segmentation – products segmented by price
Customer Segmentation – customers segmented by spending & loyalty
Customer Reports (View) – consolidated customer report for BI

🚀 How to Use
Run the SQL scripts in your database environment (Oracle/other SQL engines).
Make sure you have the following tables:
sales (order_number, product_key, order_date, sales_amount, quantity, customer_key)
customers (customer_key, customer_number, first_name, last_name, birthdate)
products (product_key, product_name, category, cost)
Use the queries to explore different aspects of sales and customer behavior.
Query the report_customers view to get a ready-made customer analytics report.

📈 Business Value
Understand sales growth over time.
Spot high-performing and underperforming products.
See which categories drive the business.
Identify customer loyalty levels and tailor strategies.
Provide management with a ready dashboard/report view for decision-making.
