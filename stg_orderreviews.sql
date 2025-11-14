SELECT
    review_id,
    order_id,
    review_score,
    review_comment_title,
    review_comment_message,
    CAST(review_creation_date AS TIMESTAMP) AS created_at,
    CAST(review_answer_timestamp AS TIMESTAMP) AS answered_at
FROM
    {{ source('olist_raw', 'orderreviews') }} -- Assuming you named this 'orderreviews'