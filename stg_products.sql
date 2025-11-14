SELECT
    product_id,
    product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty AS product_photos_quantity,
    product_weight_g AS product_weight_grams,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM
    {{ source('olist_raw', 'products') }}