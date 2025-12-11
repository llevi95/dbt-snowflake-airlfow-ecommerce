SELECT
    line_items.order_item_key,
    line_items.part_key,
    line_items.line_number,
    orders.order_key,
    orders.customer_key,
    orders.order_date,
    line_items.extended_price,
    {{ discounted_amount('line_items.extended_price', 'line_items.discount', 2) }} as item_discounted_amount
FROM 
    {{ ref('stg_tpch_orders') }} as orders
JOIN 
    {{ ref('stg_tpch_line_items') }} as line_items
    ON orders.order_key = line_items.order_key
ORDER BY
    orders.order_date