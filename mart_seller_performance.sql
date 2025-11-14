with seller_orders as (
  select 
    seller_id,
    order_id,
    price,
    delivery_delay_days
  from {{ ref('fct_orders') }}
),

seller_reviews as (
  select 
    s.seller_id,
    cast(r.review_score as float64) as review_score
  from {{ ref('stg_sellers') }} s 
  left join {{ ref('stg_items') }} oi 
    on s.seller_id = oi.seller_id
  left join {{ ref('stg_orderreviews') }} r 
    on oi.order_id = r.order_id
),

final as (
  select 
    s.seller_id,
    s.city as seller_city,
    s.state as seller_state,
    sum(so.price) as total_revenue,
    count(distinct so.order_id) as total_orders,
    avg(case when so.delivery_delay_days is not null then so.delivery_delay_days end) as avg_delivery_delay,
    avg(case when so.delivery_delay_days > 0 then 1 else 0 end) as seller_delay_rate,
    avg(sr.review_score) as avg_review_score
  from {{ ref('stg_sellers') }} s 
  left join seller_orders so on s.seller_id = so.seller_id
  left join seller_reviews sr on s.seller_id = sr.seller_id
  group by 1,2,3
)

select * from final

