with orders as(

	select 
		customer_id,
		purchased_at
	from {{ ref('fct_orders')}}
	),


customer_first_order as(
	
	select 
		customer_id,
		min(purchased_at) as first_order_at
	from orders 
	group by 1
	),


cohort_data as(
	
	select 
		o.customer_id,
		date_trunc(cfo.first_order_at, month) as cohort_month, 
		
		date_diff(
			cast(o.purchased_at as date),
			cast(cfo.first_order_at as date),
			month) as cohort_index
		from orders o 
		left join customer_first_order cfo on o.customer_id=cfo.customer_id
	),

final as (
	select
		cohort_month,
		cohort_index,
		count(distinct customer_id) as active_customers
	from cohort_data
	group by 1,2
	)

	select * from final

	