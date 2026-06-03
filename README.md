# Food Delivery SQL Analysis & Dashboard

## Project Overview

This project analyzes a food delivery dataset to uncover insights related to revenue performance, customer behavior, restaurant performance, and operational efficiency.

The analysis was conducted using PostgreSQL for data extraction and transformation, followed by dashboard development in Looker Studio to visualize key business metrics and trends.

---

## Business Questions

This project answers the following business questions:

1. How many orders were placed?
2. How much revenue was generated?
3. What is the average order value (AOV)?
4. Which restaurants generate the highest revenue?
5. How do orders and revenue change over time?
6. Which cuisines contribute the most revenue?
7. Which customers spend the most?
8. What is the order cancellation rate?
9. Which menu items sell the most?
10. How long does delivery take on average?

A total of **22 SQL queries** were developed to answer these questions.

---

## Dataset

The project uses five relational datasets:

| Table            | Description            |
| ---------------- | ---------------------- |
| customers_medium | Customer information   |
| orders_medium    | Order transactions     |
| order_items      | Order item details     |
| restaurants      | Restaurant information |
| menu_items       | Menu item information  |

Raw datasets are available in the `Dataset/` folder.

---

## Tools Used

* PostgreSQL
* SQL
* Google Sheets
* Looker Studio
* GitHub

---

## SQL Analysis

The SQL analysis covers:

* Business KPI calculations
* Revenue analysis
* Customer spending analysis
* Restaurant performance analysis
* Customer ranking
* Order trend analysis
* Operational performance metrics
* Window functions and ranking

SQL script:

```text
SQL/food_delivery_analysis.sql
```

---

## Dashboard Preview

### Executive Overview

![Executive Overview](Dashboard/dashboard_overview)

### Restaurant Performance

![Restaurant Performance](Dashboard/dashboard_restaurant_performance)

### Customer & Operations Analysis

![Customer & Operations Analysis](Dashboard/dashboard_customer_operations)

---

## Key Insights

### Revenue Performance

* Total revenue exceeded 560K during the analysis period.
* Revenue trends remained relatively stable across most months.
* Lower performance in May 2024 is due to partial-month data availability (transactions available until May 15 only).

### Restaurant Performance

* Revenue is concentrated among a small group of top-performing restaurants.
* Thai cuisine generated the highest revenue contribution.
* Leeds and Liverpool were among the strongest revenue-generating cities.
* Top-selling menu items showed relatively balanced sales performance.

### Customer Insights

* A small group of customers contributed significantly to total revenue.
* Customer acquisition remained consistent throughout most months.
* Repeat customers represent an important source of business revenue.

### Operational Insights

* Average delivery time was approximately 55 minutes.
* Delivered orders significantly exceeded cancelled orders.
* Cancellation rates remained relatively low throughout the analysis period.

---

## Repository Structure

```text
food-delivery-sql-analysis/
│
├── Dataset/
│
├── Dashboard/
│
├── Dashboard_Data/
│
├── SQL/
│   ├── README.md
│   └── food_delivery_analysis.sql
│
└── README.md
```

---

## Dashboard

Interactive dashboard developed using Looker Studio.

The dashboard includes:

* Executive Overview
* Restaurant Performance Analysis
* Customer & Operations Analysis

---

## Author

Shintia Bella
