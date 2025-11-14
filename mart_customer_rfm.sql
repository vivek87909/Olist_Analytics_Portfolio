- This model calculates Recency, Frequency, and Monetary (RFM) values for each customer.

WITH customer_orders AS (
    -- First, aggregate order data to the customer level to get our F and M metrics.
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS total_orders,        -- This is Frequency
        SUM(total_payment_value) AS total_spend,        -- This is Monetary
        MAX(purchased_at) AS last_order_date            -- We need this to calculate Recency
    FROM 
        {{ ref('fct_orders') }}
    WHERE 
        purchased_at IS NOT NULL
    GROUP BY 
        1 -- Group by customer_id
),

rfm_calculations AS (
    -- Second, calculate the Recency value for each customer.
    SELECT
        customer_id,
        total_orders,
        total_spend,
        
        -- THE FIX: We hardcode the 'current date' for stability.
        -- This date (2018-09-04) is one day after the last transaction in the dataset.
        -- This provides a consistent point in time for the Recency calculation.
        TIMESTAMP_DIFF(
            TIMESTAMP('2018-09-04 00:00:00 UTC'), -- Hardcoded reference date
            last_order_date,
            DAY
        ) AS days_since_last_order -- This is our Recency metric
        
    FROM 
        customer_orders
),

final AS (
    -- Finally, use the NTILE window function to create scores from 1 to 5 for each metric.
    SELECT
        customer_id,
        
        -- Recency Score: Lower is better, so we sort ascending.
        NTILE(5) OVER (ORDER BY days_since_last_order ASC) AS recency_score,
        
        -- Frequency Score: Higher is better, so we sort descending.
        NTILE(5) OVER (ORDER BY total_orders DESC) AS frequency_score,
        
        -- Monetary Score: Higher is better, so we sort descending.
        NTILE(5) OVER (ORDER BY total_spend DESC) AS monetary_score
        
    FROM 
        rfm_calculations
)

SELECT * FROM final