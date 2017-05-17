{{
    config(
        materialized = 'table',
        dist = 'order_id',
        sort = 'order_timestamp'
    )
}}

with customers as (

    select * from {{var('customers_table')}}

),

orders as (

    select * from {{var('orders_table')}}

),

items as (

    select * from {{var('order_items_table')}}

),

skus as (

    select * from {{var('skus_table')}}

),

products as (

    select * from {{var('products_table')}}

),

joined as (

    select

        items.order_id,
        orders.customer_id,
        items.sku_id,
        items.order_item_line_number,
        items.quantity as order_item_quantity,
        items.item_cost as order_item_cost,
        items.subtotal as order_item_subtotal,
        orders.happened_at as order_timestamp,
        orders.total as order_total,
        orders.customer_order_number,

        case
            when orders.customer_order_number = 1 then 'new'
            else 'repeat'
        end as new_vs_repeat,

        customers.first_purchase_date as customer_first_purchase_date,
        customers.lifetime_orders as customer_lifetime_orders,
        customers.lifetime_revenue as customer_lifetime_revenue,
        products.name as product_name

    from items
    left outer join orders on items.order_id = orders.id
    left outer join customers on orders.customer_id = customers.id
    left outer join skus on items.sku_id = skus.id
    left outer join products on skus.product_id = products.id

)

select * from joined
