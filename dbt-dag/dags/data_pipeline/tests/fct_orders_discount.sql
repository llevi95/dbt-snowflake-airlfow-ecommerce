SELECT
    *
FROM
    {{ ref('fct_orders') }}
WHERE
    item_discounted_amount > 0