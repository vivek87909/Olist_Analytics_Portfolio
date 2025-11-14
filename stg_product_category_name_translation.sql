SELECT
    string_field_0 AS product_category_name, 
string_field_1 AS product_category_name_english 
FROM
    {{ source('olist_raw', 'product_category_name_translation') }}