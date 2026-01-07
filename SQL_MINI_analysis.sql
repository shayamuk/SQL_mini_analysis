with cte as(
Select *,
LEAD(plan_value,1, plan_value) OVER(PARTITION BY customer_id ORDER BY subscription_date) as next_value
from subscription_details),
final_cte as(
select customer_id,
    MAX(CASE WHEN plan_value<next_value THEN 1 ELSE 0 END) as Upwards,
    MAX(CASE WHEN plan_value>next_value THEN 1 ELSE 0 END) as Downwards
from cte GROUP BY customer_id)

Select customer_id,
CASE WHEN Upwards=1 then 'Yes' ELSE 'No' END as Upwards,
CASE WHEN Downwards=1 then 'Yes' ELSE 'No' END as Downwards
from final_cte;
