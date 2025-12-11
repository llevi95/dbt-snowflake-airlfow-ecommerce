SELECT
    order_key,
    sum(extended_price) as gross_item_sales_amount,
    sum(item_discounted_amount) as item_discounted_amount
FROM
    {{ ref('int_order_items') }}
GROUP BY
    order_key