SELECT
    orders.*,
    int_order_items_summary.gross_item_sales_amount,
    int_order_items_summary.item_discounted_amount
FROM
    {{ ref('stg_tpch_orders') }} as orders
JOIN
    {{ ref('int_order_items_summary') }} as int_order_items_summary
    ON orders.order_key = int_order_items_summary.order_key
ORDER BY
    orders.order_date