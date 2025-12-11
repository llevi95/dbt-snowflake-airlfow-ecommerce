SELECT
    *
FROM
    {{ ref('fct_orders') }}
WHERE
    date(order_date) > CURRENT_DATE()
    or date(order_date) < '1990-01-01'