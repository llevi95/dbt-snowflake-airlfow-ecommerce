{% macro discounted_amount(extended_price, discount_percentafe, scale = 2) %}
    (-1 * {{ extended_price }} * ({{ discount_percentafe }}))::decimal(16, {{ scale }})
{% endmacro %}