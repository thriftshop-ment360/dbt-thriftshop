

{{ config(materialized='table') }}

with transform_product as (
SELECT
  P.product_id  
  ,P.product_name  
  ,P.product_category  
  ,P.product_sub_category    
  ,P.brand        
  ,P.sale_price
  ,P.market_price    
  ,P.product_type
  ,P.product_rating    
  ,P.product_description  
  ,('10') as tax_percentage        
  ,I.image_url AS product_image
  ,current_datetime as created_datetime
  ,current_datetime as updated_datetime
  ,'yes' as is_active
FROM `thriftshop_staging.product-staging-prep` P
INNER JOIN `thriftshop_staging.product-images-by-subcategory` I
  ON P.product_sub_category = I.product_sub_category
)

select *
from transform_product