-- Changes Over YEAR Analysis
SELECT 
    EXTRACT(YEAR FROM order_date) AS years,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY EXTRACT(YEAR FROM order_date) ASC;

-- Changes Over MONTH Analysis
SELECT 
    EXTRACT(MONTH FROM order_date) AS months,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM sales
WHERE order_date IS NOT NULL
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY EXTRACT(MONTH FROM order_date) ASC;

-- CUMULATIVE ANALYSIS (AGGREGATING DATA PROGRESSIVELY OVER TIME)
WITH monthly_sales AS (
    SELECT 
        TO_CHAR(order_date, 'YYYY-MM') AS dates,
        SUM(sales_amount) AS sum_sales
    FROM sales
    WHERE order_date IS NOT NULL
    GROUP BY TO_CHAR(order_date, 'YYYY-MM')
)
SELECT 
    dates,
    sum_sales,
    SUM(sum_sales) OVER (ORDER BY dates ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS cumulative_sales
FROM monthly_sales
ORDER BY dates;

-- FOR EACH YEAR
WITH yearly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM order_date) AS dates,
        SUM(sales_amount) AS sum_sales
    FROM sales
    WHERE order_date IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM order_date)
)
SELECT 
    dates,
    sum_sales,
    SUM(sum_sales) OVER (ORDER BY dates ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW ) AS cumulative_sales
FROM yearly_sales
ORDER BY dates;

-- PERFORMANCE ANALYSIS
WITH yearly_product_sales AS (
    select 
        EXTRACT(YEAR FROM s.order_date) AS years,
        p.product_name product_name,
        SUM(s.sales_amount) current_sales
    from sales s
    join products p
    on p.product_key = s.product_key
    WHERE s.order_date is not null
    GROUP BY EXTRACT(YEAR FROM s.order_date),product_name 
)
Select
    years,
    product_name,
    current_sales,
    ROUND(AVG(current_sales) OVER(PARTITION BY product_name),0) avg_sales,
    ROUND(current_sales - AVG(current_sales) OVER(PARTITION BY product_name,0)) diff_avg,
    CASE 
        WHEN current_sales- AVG(current_sales) OVER(PARTITION BY product_name)>0 THEN 'Above Average' 
        WHEN current_sales- AVG(current_sales) OVER(PARTITION BY product_name)<0 THEN 'Below Average' 
        ELSE 'Average'
    END AVG_CHANGE
from yearly_product_sales
ORDER BY product_name,years;
    
-- PART OF WHOLE ANALYSIS
WITH sales_for_categories AS(
    SELECT  
        p.category,
        SUM(s.sales_amount) total_sales
    FROM sales s
    LEFT JOIN products p
    ON p.product_key = s.product_key
    GROUP BY p.category
)
SELECT 
    category, 
    total_sales, 
    CONCAT(ROUND(total_sales * 100 / SUM(total_sales) OVER(),0),'%') percent_total
FROM sales_for_categories;

-- DATA SEGMENTATION
WITH product_segments AS(
SELECT 
    product_key,
    product_name,
    cost,
    CASE 
        WHEN cost < 100 THEN 'Below 100'
        WHEN cost BETWEEN 100 and 500 THEN '100-500'
        WHEN cost BETWEEN 501 and 1000 THEN '500-1000'
        ELSE 'Above 1000'
    END cost_range
FROM products)
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range;

-- GROUPING CUSTOMERS INTO SEGMENTS
WITH customer_spendings AS(
SELECT 
    c.customer_key,
    SUM(s.sales_amount) total_spending,
    ROUND(MONTHS_BETWEEN(MAX(s.order_date), MIN(s.order_date)),0) AS lifespan
FROM customers c
LEFT JOIN sales s
ON s.customer_key = c.customer_key
GROUP BY c.customer_key
) -- cte

SELECT -- main query
customer_segment,
COUNT(customer_key)
FROM ( -- subquery
SELECT
    customer_key,
    total_spending,
    lifespan,
    CASE
        WHEN lifespan>10 and total_spending>5000 THEN 'VIP'
        WHEN lifespan>10 and total_spending<5000 THEN 'Regular'
        ELSE 'New'
    END customer_segment
FROM customer_spendings)
GROUP BY customer_segment;

-- BUILDING CUSTOMER REPORTS  
CREATE VIEW report_customers AS
WITH base_query AS (
    SELECT 
        s.order_number,
        s.product_key,
        s.order_date,
        s.sales_amount,
        s.quantity,
        c.customer_key,
        c.customer_number,
        (c.first_name || ' ' || c.last_name) AS customer_name,
        ROUND((SYSDATE - c.birthdate)/365,0) AS age
    FROM sales s
    LEFT JOIN customers c
        ON c.customer_key = s.customer_key
    WHERE order_date IS NOT NULL
),
customer_aggregation AS (
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        ROUND(MONTHS_BETWEEN(MAX(order_date), MIN(order_date)),0) AS lifespan
    FROM base_query
    GROUP BY customer_key,
             customer_number,
             customer_name,
             age
)
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20–29'
        WHEN age BETWEEN 30 AND 39 THEN '30–39'
        WHEN age BETWEEN 40 AND 49 THEN '40–49'
        ELSE '50 and above'
    END AS age_group,
    CASE
        WHEN lifespan > 10 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan > 10 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    last_order_date,
    lifespan,
    ROUND(MONTHS_BETWEEN(SYSDATE, last_order_date), 0) AS recency
FROM customer_aggregation;

SELECT * FROM report_customers;

