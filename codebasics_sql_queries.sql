
-- Query 1
SELECT p.product_name,p.product_code,fe.base_price,fe.promo_type
FROM dim_products p  join
fact_events fe on p.product_code=fe.product_code
where promo_type ='BOGOF' and base_price>500;

-- query 2
select count(distinct store_id) as no_of_stores,city
from dim_stores
group by 2
order by 1 desc;

-- query 3
select campaign_id,sum(base_price* quantity_sold_before) as revenue_before_discount,
sum(base_price* quantity_sold_after) as revenue_after_discount
from fact_events
group by 1;


-- query4
WITH tbl as(SELECT p.product_name,p.product_code,sum(fe.quantity_sold_before) as quantity_sold_before,sum(fe.quantity_sold_after) as quantity_sold_after
,p.category,round(((sum(fe.quantity_sold_after)-sum(fe.quantity_sold_before))/sum(fe.quantity_sold_before)*100),2) as ISU
FROM dim_products p  join
fact_events fe on p.product_code=fe.product_code
where campaign_id='camp_diw_01'
group by category)
select *,
rank()over(order by ISU desc) as rnk
from tbl;
-- query 5
with purchase as (SELECT p.product_name,p.product_code,(fe.base_price*fe.quantity_sold_before) tot_price_bef,p.category,
(fe.base_price*fe.quantity_sold_after) tot_price_aft
FROM dim_products p  join
fact_events fe on p.product_code=fe.product_code
group by p.product_name
order by tot_price_bef,tot_price_aft desc)
select product_name,category,round(((tot_price_aft-tot_price_bef)*100/tot_price_bef),2) as percentage,
rank() over(order by((tot_price_aft-tot_price_bef)*100/tot_price_bef)desc) as rnk
from purchase;


