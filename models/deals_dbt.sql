{{ config(materialized='table') }}

with transform_deals as (
 WITH deal_dbt AS
 (SELECT 
  ROW_NUMBER() OVER() AS deal_id,
  CAST(product_id AS INT) as product_id,
  product_name,
  'Half Price' as deal_type,
  DATETIME(2022, 09, 12, 00, 00, 00) as deal_start_datetime,
  DATETIME_ADD(DATETIME "2022-09-13 00:00:00", INTERVAL 1 WEEK) as deal_end_datetime,
  '50 %' deal_percentage,
  (market_price * 0.5) as discounted_price,
  current_datetime as created_datetime
  from `thriftshop_staging.product-staging-prep`
  order by rand() limit 150
 )
 SELECT
 deal_id,
 product_id,
 product_name,
 deal_type,
(case when mod(deal_id, 3) = 0 then 'BigBasket'
      when mod(deal_id, 3) = 1 then 'Grofers'
      else 'Amazon Pantry'
end) as shop_name,
deal_start_datetime,
deal_end_datetime,
deal_percentage,
discounted_price,
created_datetime
from deal_dbt
)

select *
from transform_deals