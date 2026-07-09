use ecommerce_DB;
select *
from ecommerce_sales_data;
--show top 10 rows for quick overview
select top 10 *
from ecommerce_sales_data;
--columns info--
select column_name,data_type
from INFORMATION_SCHEMA.COLUMNS
where TABLE_NAME='ecommerce_sales_data';
--table info--
exec sp_help 'ecommerce_sales_data';
--adding revenue column--
alter table ecommerce_sales_data
add revenue decimal(10,2);
--calculating revenue--
update ecommerce_sales_data
set revenue = Price*Quantity;
--data cleaning--
select count(*) as total_records
from ecommerce_sales_data;

select count(distinct Order_ID) from ecommerce_sales_data;
--therefore no duplicate records--

select 
SUM(case when Order_ID is null then 1 else 0 end) as order_id,
SUM(case when Product is null then 1 else 0 end) as product,
SUM(case when Category is null then 1 else 0 end) as category,
SUM(case when Quantity is null then 1 else 0 end) as quantity,
SUM(case when Price is null then 1 else 0 end) as price,
SUM(case when City is null then 1 else 0 end) as city,
SUM(case when Date is null then 1 else 0 end) as date,
SUM(case when revenue is null then 1 else 0 end) as revenue
from ecommerce_sales_data;
--no null values--

select *
from ecommerce_sales_data
where Product=' ' or Category=' ' or Quantity = ' '
or Price=' ' or City= ' ' or Date = ' ' ;
--no blank values--

--fixing data types--
alter table ecommerce_sales_data
alter column Price decimal(10,2);

select *
from ecommerce_sales_data
where Price<0 or Quantity<=0 or revenue<0; 
--no negatives or invalid values--

--EDA(Exploratory Data Analysis)--
select top 10 *
from ecommerce_sales_data;

--total revenue--
select SUM(revenue) as total_revenue
from ecommerce_sales_data;
--total revenue = 27620651.09--
--total revenue by product--
select Product, SUM(revenue) as total_revenue
from ecommerce_sales_data
group by Product
order by total_revenue desc;
--finding: laptop generated the highest revenue.
/*insight: company should increase the budget 
on laptop and other electronic items.*/
--total revenue by quantity--
select Quantity,sum(revenue) as total_revenue
from ecommerce_sales_data
group by Quantity
order by total_revenue desc;
--total revenue by city--
select City,sum(revenue) as total_revenue
from ecommerce_sales_data
group by City
order by total_revenue desc;
--finding: pune contributed mostly to sales.
/*insight: company can launch more products
or increase stock in pune which will help in 
the growth of business. therefore more revenue
generation*/

select AVG(revenue) as average_revenue
from ecommerce_sales_data;
--average revenue=27620.65

select MAX(revenue) as maximum_revenue
from ecommerce_sales_data;
-- maximum revenue= 299643.45

select Category,SUM(revenue) as highest_prod_category
from ecommerce_sales_data
group by Category
order by highest_prod_category desc;
--finding: electronics are the priority contributors to revenue.
/*insight:business should focus on electronic items more
and make sure that these items dont run out of stock*/

--what are the most priced products--
select Product,MAX(Price) as max_price
from ecommerce_sales_data
group by Product
order by max_price desc;
--finding:laptop is the highest priced product yet people are buying it.
/*insight:due to expensiveness of laptops, business 
should gather their budget due to increased demand of 
laptops*/

--what are the products more than average price--
with average_prices_product as (
select AVG(Price) as avg_price
from ecommerce_sales_data)
select distinct Product 
from ecommerce_sales_data 
where Price > (select avg_price 
from average_prices_product);
--finding: again,laptop is priced more than the average price.


--which category has highest price and in which city--
select Category,City
from ecommerce_sales_data 
where Price= (select max(Price) as max_price 
from ecommerce_sales_data);
--in jaipur, laptops are the most expensive items compared to other cities.
/*insight: company should focus on managing the pricing of laptops
in jaipur*/

-- how much revenue increased/decreased in comparison to previous months--
with monthly_sales as (
select YEAR(Date) as year,
MONTH(Date) as month,
sum(revenue) as total_revenue
from ecommerce_sales_data
group by YEAR(Date),MONTH(Date)
)
select year,month,total_revenue,
lag(total_revenue) over(order by year,month) as previous_month_revenue,
total_revenue-lag(total_revenue) over (order by year,month) as revenue_change
from monthly_sales;

--in the 2nd month of 2026, the revenue was negative indicating decrease sales.
--similarly in 4th and 6th month also.

-- best peforming months--
select MONTH(Date) as month,
SUM(revenue) as total_revenue
from ecommerce_sales_data
group by MONTH(Date)
order by total_revenue desc;
--january was the highest revenue generating month--

--highest sales date--
select top 1 Date,sum(revenue) as total_revenue
from ecommerce_sales_data
group by Date
order by total_revenue desc;
--2026-04-27--

/*conclusion: the electronics category,
particularly laptops, generated the highest sales
and revenue. Despite having a higher price compared to 
other products,laptops continued to experience 
strong demand. This suggests that customers are willing
to pay  for high-value electronic products.*/


/*
Business Recommendation: The comapany should maintain 
sufficient laptop inventory.Also focus on marketing
campaigns of electronics category.company should consider
on expanding the laptop product range, as it consistently
performs well despite its premium pricing.
*/























