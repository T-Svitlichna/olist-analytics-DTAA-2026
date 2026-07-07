-- Main Dataset with contecst delivereds orders
select o.order_id,
 	   o.order_purchase_t,
       strftime('%Y-%m', o.order_purchase_t) as ym,
       cu.customer_state,
       t.product_category_1 as category_EN,
       oi.price,
       oi.freight_value,
       op.payment_type as payment_method,
       r.review_score
from olist_order_items_dataset as oi
JOIN olist_orders_dataset as o using(order_id)
join olist_customers_dataset as cu using(customer_id)
join olist_products_dataset as p USING (product_id)
left join product_category_name_translation as t USING(product_category)
left join olist_order_payments_dataset as op using(order_id)
left join olist_order_reviews_dataset as r USING (order_id)
WHERE o.order_status = 'delivered';
