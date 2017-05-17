with facts as (

    select * from {{ref('order_facts')}}

),

products as (

    select
        product_name,
        sum(order_item_subtotal) as revenue,
        sum(order_item_quantity) as quantity
    from facts
    where order_timestamp >= to_date('{%raw%}{{start_date}}{%endraw%}', 'mm/dd/yyyy')
        and order_timestamp < to_date('{%raw%}{{end_date}}{%endraw%}', 'mm/dd/yyyy')
    group by 1

)

select
    *,
    revenue::float / nullif(quantity, 0) as avg_revenue_per_item
from products
where product_name is not null
order by revenue desc, quantity desc
