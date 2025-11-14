select 
	date_trunc(purchased_at, month) as sales_month,
	sum(price) as total_monthly_revenue,
	count(distinct order_id) as total_monthly_orders
	from {{ref('fct_orders')}}
	where 
		order_Status='delivered'
	group by 1
	order by 1
