# UrbanNest Retail Sales & Customer Analysis — MySQL

## Project Overview
A fictional retail business dataset created for a Data Analyst portfolio.

The project demonstrates SQL from basic querying through intermediate and selected advanced analytical concepts. The focus is on practical business questions rather than a large number of repetitive queries.

## Business Areas Covered
- Sales and revenue KPIs
- High-value orders
- Monthly order and revenue trends
- Product/category performance
- Repeat and high-value customers
- Customer segmentation
- City-wise business performance
- Payment method analysis
- Order status and cancellation rate
- Orders above average value
- Top customers
- Product ranking
- Month-over-month revenue growth
- Data-quality validation
- Payment/order reconciliation

## Dataset
All customer names, emails, products, and transactions are fictional.

### Tables
1. `customers` — customer profile and location data
2. `products` — product catalog, pricing, and stock
3. `orders` — order-level transaction data
4. `order_items` — product-level order details
5. `payments` — payment information

## SQL Skills Demonstrated

### Basic
- SELECT
- WHERE
- DISTINCT
- ORDER BY
- LIMIT
- COUNT
- COUNT DISTINCT
- SUM
- AVG
- ROUND
- Date functions

### Intermediate
- INNER JOIN
- LEFT JOIN
- GROUP BY
- HAVING
- CASE WHEN
- Conditional aggregation
- Subqueries
- Data filtering and sorting

### Advanced Analytical SQL
- CTEs (`WITH`)
- Window functions
- `RANK()`
- `LAG()`
- `PARTITION BY`
- Month-over-month growth
- Data-quality checks
- Multi-table validation
- Payment/order reconciliation

## Folder Structure
```text
UrbanNest_Retail_SQL_Project/
│
├── data/
│ ├── customers.csv
│ ├── products.csv
│ ├── orders.csv
│ ├── order_items.csv
│ └── payments.csv
│
├── sql/
│ ├── 01_setup.sql
│ ├── 02_insert_data.sql
│ └── 03_analysis_queries.sql
│
└── README.md
```

## How to Run in MySQL Workbench

### Step 1
Run:
`sql/01_setup.sql`

This creates the `urbannest_retail` database and five tables.

### Step 2
Run:
`sql/02_insert_data.sql`

This inserts the fictional data.

### Step 3
Run:
`sql/03_analysis_queries.sql`

Run the 15 analysis sections individually so you can review and understand each result.

## Query Progression

1. Basic KPIs
2. Filtering and sorting
3. Monthly trends
4. Joins and category analysis
5. GROUP BY + HAVING
6. CASE-based segmentation
7. City-wise analysis
8. Payment analysis
9. Conditional aggregation
10. Subquery
11. CTE
12. RANK window function
13. LAG window function + MoM growth
14. Data-quality validation
15. Payment/order reconciliation

## Resume Project Name
UrbanNest Retail Sales & Customer Analysis

## Resume Skills
MySQL, SQL, Joins, Aggregations, Subqueries, CTEs, Window Functions, CASE Expressions, Data Validation, Data Analysis
