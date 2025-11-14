with orders AS (
	select * from {{ ref('stg_orders')}}
),

order_items AS (
	select * from {{ ref('stg_items')}}
),

order_payments_agg AS (
	select 
		order_id,
		sum(payment_value) as total_payment_value
		from {{ ref('stg_payments') }}
		group by 1 ),
		
final AS (
   select 	
	oi.order_id,
	oi.order_item_id,
	o.customer_id,
	oi.seller_id,
	o.purchased_at,
	o.approved_at,
	o.shipped_at,
	o.delivered_at,
	o.estimated_delivery_at,
	oi.shipping_limit_date,
	o.order_status,
	oi.price,
	oi.freight_value,
	p.total_payment_value,
	timestamp_diff(o.delivered_at,o.estimated_delivery_at, day) as delivery_delay_days

	from order_items as oi 
	left join orders as o on oi.order_id=o.order_id
	left join order_payments_agg as p on oi.order_id=p.order_id
)	
select * from final	