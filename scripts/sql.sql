	---Total Revenue
	SELECT sum (total_price) as Total_Revenue
	  FROM  pizza_sales

	  ---Average Order Value
	SELECT sum (total_price) / Count(Distinct order_id) as Average_Order_Value
	  FROM  pizza_sales

	   --- Total Pizza sold
	SELECT sum(quantity) as Pizza_sold
	  FROM  pizza_sales

	   --Total orders
	SELECT count(Distinct order_id) as Total_orders
	  FROM  pizza_sales

	   ---Average Pizza per order
	SELECT cast(cast(sum(quantity) as decimal(10,2)) /
	cast(count(Distinct order_id) as decimal(10,2)) as decimal(10,2)) as Average_pizza_per_order
	  FROM  pizza_sales

	    ---Daily Trend for Total Orders 
	SELECT DATENAME(DW,order_date) as order_day, COUNT(DISTINCT order_id) as Total_orders
	  FROM  pizza_sales
	  GROUP BY DATENAME(DW,order_date)



	  --Hourly Trend
	  SELECT DATEPART(HOUR,order_time) as order_hour, COUNT(DISTINCT order_id) as Total_orders
	  FROM  pizza_sales
	  GROUP BY DATEPART(HOUR,order_time)
	  ORDER BY DATEPART(HOUR,order_time) 



	  --- Percentage of Sales by Pizza Category
	  SELECT pizza_category,cast(sum(total_price) as decimal(10,2)) as total_sales ,cast(sum(total_price) * 100 /
	  (select sum(total_price)  from pizza_sales) as decimal(10,2)) PCT
	  from pizza_sales
	  GROUP BY pizza_category


	    --- Percentage of Sales by Pizza size
	  SELECT pizza_size, cast(sum(total_price) as decimal(10,2)) as total_sales ,cast(sum(total_price) * 100 /
	  (select sum(total_price)  from pizza_sales where DATEPART(quarter,order_date) = 1) as decimal(10,2)) PCT
	  from pizza_sales
	  where DATEPART(quarter,order_date) = 1
	  GROUP BY pizza_size


	    --- Total pizza sold by category
	  SELECT pizza_category,sum(quantity) as total_pizza_sold
	  from pizza_sales
	  group by pizza_category
	  

	  ---Top 5 Best Sellers by total pizzas sold

	  SELECT top 5  pizza_name,sum(quantity) as total_pizza_sold
	  from pizza_sales
	  group by pizza_name
	  order by sum(quantity) desc


	  ---Top 5 worst Sellers by total pizzas sold

	  SELECT top 5  pizza_name,sum(quantity) as total_pizza_sold
	  from pizza_sales
	  group by pizza_name
	  order by sum(quantity) asc








