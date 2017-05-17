with facts as (

    select * from {{ref('order_facts')}}

),

orders as (

    select
        order_timestamp,
        order_total,
        sum(order_item_quantity) as order_quantity
    from facts
    where order_timestamp >= to_date('{%raw%}{{start_date}}{%endraw%}', 'mm/dd/yyyy')
        and order_timestamp < to_date('{%raw%}{{end_date}}{%endraw%}', 'mm/dd/yyyy')
    group by 1, 2

),

agg as (

    select
        date_trunc('{%raw%}{{date_resolution}}{%endraw%}', order_timestamp) as period,
        sum(order_total) as revenue,
        sum(order_quantity) as quantity,
        count(*) as orders
    from orders
    group by 1
    order by 1

)

select
    *,
    revenue::float / nullif(quantity, 0) as avg_revenue_per_item,
    quantity::float / nullif(orders, 0) as avg_items_per_order,
    revenue::float / nullif(orders, 0) as avg_order_value
from agg
