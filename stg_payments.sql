SELECT
    order_id,
    payment_sequential,
    payment_type,
    payment_installments AS credit_card_installments,
    payment_value AS payment_value
FROM
    {{ source('olist_raw', 'payments') }}