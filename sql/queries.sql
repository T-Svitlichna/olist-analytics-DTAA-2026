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
------------------------------------------------------------------------------------------------
--2 Month orders count/sum price
select 
strftime('%Y-%m', o.order_purchase_t) as ym, count(DISTINCT o.order_id), 
round(sum(oi.price),2) as orders
from olist_orders_dataset as o 
JOIN olist_order_items_dataset as oi USING (order_id)
WHERE o.order_status = 'delivered'
group by ym
order by ym;
-------------------------------------------------------------------------------------------------
-- 3 тоp-10 category
SELECT t.product_category_1 as category_EN, p.product_category, round(sum(oi.price) ,2) as total
FROM olist_products_dataset AS p
JOIN olist_order_items_dataset AS oi USING(product_id)
JOIN olist_orders_dataset AS o USING(order_id)
LEFT JOIN product_category_name_translation as t USING(product_category)
WHERE o.order_status = 'delivered'
group by category_EN
ORDER BY total DESC
LIMIT 10;
-- TOP 10 Category
--1 health_beauty
--2 watches_gifts
--3 bed_bath_table
--4 sports_leisure
--5 computers_accessories
--6 furniture_decor
--7 housewares
--8 cool_stuff
--9 auto
--10 toys

---------------------------------------------------------------------------------------------------
-- 4 state-total

SELECT
	cu.customer_state,
    ROUND(SUM(oi.price), 2) AS revenue,
    COUNT(DISTINCT o.order_id) AS orders
FROM olist_order_items_dataset oi
JOIN olist_orders_dataset o USING (order_id)
JOIN olist_customers_dataset cu USING (customer_id)
WHERE o.order_status = 'delivered'
GROUP BY cu.customer_state
ORDER BY revenue DESC;
-- TOP 3 customer_state are SP, RJ, MG
--------------------------------------------------------------------------------------------------
-- 5 AVG Rating

SELECT t.product_category_1 as category_EN, 
round(avg(r.review_score),2) as AVG_score, 
round(sum(oi.price) ,2) as total,
COUNT(*) AS reviews
FROM olist_order_items_dataset AS oi
JOIN olist_orders_dataset AS o USING(order_id)
JOIN olist_products_dataset AS p USING(product_id)
LEFT JOIN product_category_name_translation AS t USING(product_category)
LEFT JOIN olist_order_reviews_dataset AS r USING(order_id)
WHERE o.order_status = 'delivered'
group by category_EN
HAVING reviews > 50
ORDER BY AVG_score DESC
--- AVG Rating between 3,52 and 4,51 
-------------------------------------------------------------------------------------------------------------------------
-- 6 AVG delivered
SELECT round(avg(julianday(order_delivered_6) - julianday(order_purchase_t)),1) as avg_date
FROM olist_orders_dataset
WHERE order_status = 'delivered'
-- Avereg delivery 12,6 days
---------------------------------------------------------------------------------------------------------------------------
-- 7 payment_type
SELECT payment_type, COUNT(order_id)as count_orders, round(sum(payment_value),2) total_value  from olist_order_payments_dataset
GROUP by payment_type
order by count_orders DESC
--- the Best payment_type is credit_card (76795)


