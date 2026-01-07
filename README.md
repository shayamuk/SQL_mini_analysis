# Subscription Upgrade & Downgrade Analysis (SQL)

This repository contains a simple yet interview-ready SQL analysis to identify **customer upgrade and downgrade behavior** using subscription history.

---

## 📌 Problem Statement

Given a subscription history table with plan values over time, determine for each customer:

* Whether they have **ever upgraded**
* Whether they have **ever downgraded**

---

## 🗂️ Dataset Structure

### Table 1: `subscription_details`

| Column Name       | Description                 |
| ----------------- | --------------------------- |
| customer_id       | Unique customer identifier  |
| subscription_date | Date of subscription change |
| plan_value        | Subscription plan price     |

### Sample Data

| customer_id | subscription_date | plan_value |
| ----------- | ----------------- | ---------- |
| 1           | 2025-03-02        | 889        |
| 1           | 2025-04-01        | 664        |
| 1           | 2025-05-01        | 299        |
| 2           | 2025-03-01        | 799        |
| 2           | 2025-04-01        | 599        |
| 3           | 2025-05-01        | 499        |
| 3           | 2025-06-01        | 599        |
| 4           | 2025-06-01        | 299        |
| 4           | 2025-07-01        | 399        |
| 4           | 2025-08-02        | 299        |

---

## 🧠 Approach

1. Use the `LEAD()` window function to compare each plan value with the **next subscription**.
2. Flag upgrade and downgrade events using conditional logic.
3. Aggregate at the customer level to identify if an upgrade or downgrade ever occurred.

---

## 🧾 SQL Solution

```sql
WITH cte AS (
    SELECT *,
           LEAD(plan_value, 1, plan_value)
           OVER (PARTITION BY customer_id ORDER BY subscription_date) AS next_value
    FROM subscription_details
),
final_cte AS (
    SELECT customer_id,
           MAX(CASE WHEN plan_value < next_value THEN 1 ELSE 0 END) AS Upgrade,
           MAX(CASE WHEN plan_value > next_value THEN 1 ELSE 0 END) AS Downgrade
    FROM cte
    GROUP BY customer_id
)
SELECT customer_id,
       CASE WHEN Upgrade = 1 THEN 'Yes' ELSE 'No' END AS Upgrade,
       CASE WHEN Downgrade = 1 THEN 'Yes' ELSE 'No' END AS Downgrade
FROM final_cte;
```

---

## ✅ Output

| customer_id | Upgrade | Downgrade |
| ----------- | ------- | --------- |
| 1           | No      | Yes       |
| 2           | No      | Yes       |
| 3           | Yes     | No        |
| 4           | Yes     | Yes       |

---

## 💡 Key Learnings

* Window functions can replace complex self-joins
* `LEAD()` is ideal for time-based comparisons
* Aggregation with flags helps summarize behavior efficiently

---

## Key Insights:

The analysis revealed distinct patterns — some customers showed consistent downgrades, indicating price sensitivity, while others upgraded as perceived value increased. A few customers fluctuated between plans, reflecting changing usage needs.

Insights like these can support better pricing strategies, customer retention, and churn prediction in subscription-based businesses.

## 🚀 Use Cases

* Customer churn analysis
* Pricing strategy evaluation
* Subscription-based business insights
