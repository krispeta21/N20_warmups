-- For each country calculate the total spending for each customer, and 
-- include a column (called 'difference') showing how much more each customer 
-- spent compared to the next highest spender in that country. 
-- For the 'difference' column, fill any nulls with zero.
-- ROUND your all of your results to the next penny.

-- hints: 
-- keywords to google - lead, lag, coalesce
-- If rounding isn't working: 
-- https://stackoverflow.com/questions/13113096/how-to-round-an-average-to-2-decimal-places-in-postgresql/20934099



WITH order_total AS (
SELECT order_id, SUM(product_id*unit_price-discount * quantity) AS total
FROM
order_details
GROUP BY
order_id)

SELECT 
customers.customer_id, 
customers.country, 
order_total.order_id, 
order_total.total, 
LAG (order_total.total, 1) OVER (
    PARTITION BY 
    customers.customer_id
    ORDER BY
    order_total.total DESC)
    AS prev_total,
    order_total.total-LAG(order_total.total, 1) OVER(
        PARTITION BY customers.customer_id
        ORDER BY
        order_total.total DESC) AS difference
FROM 
order_total 
JOIN 
orders 
ON
order_total.order_id=orders.order_id
JOIN
customers
ON
customers.customer_id = orders.customer_id
LIMIT 50;






 customer_id | country | order_id |      total       |    prev_total    |    difference     
-------------+---------+----------+------------------+------------------+-------------------
 ALFKI       | Germany |    10835 | 4245.59999999404 |                  |                  
 ALFKI       | Germany |    10692 | 2765.70009613037 | 4245.59999999404 | -1479.89990386367
 ALFKI       | Germany |    10643 | 2521.29995727539 | 2765.70009613037 |  -244.40013885498
 ALFKI       | Germany |    11011 |  2292.9999999702 | 2521.29995727539 | -228.299957305193
 ALFKI       | Germany |    10952 | 1425.99995726347 |  2292.9999999702 | -867.000042706728
 ALFKI       | Germany |    10702 |             1398 | 1425.99995726347 | -27.9999572634697
 ANATR       | Mexico  |    10926 |  2989.3999414444 |                  |                  
 ANATR       | Mexico  |    10625 |           2953.5 |  2989.3999414444 |  -35.899941444397
 ANATR       | Mexico  |    10308 | 2827.19994735718 |           2953.5 | -126.300052642822
 ANATR       | Mexico  |    10759 |             1024 | 2827.19994735718 | -1803.19994735718
 ANTON       | Mexico  |    10535 |   5315.499984622 |                  |                  
 ANTON       | Mexico  |    10573 | 2877.39995956421 |   5315.499984622 | -2438.10002505779
 ANTON       | Mexico  |    10507 | 2585.49999982119 | 2877.39995956421 | -291.899959743023
 ANTON       | Mexico  |    10682 |          1785.75 | 2585.49999982119 | -799.749999821186
 ANTON       | Mexico  |    10677 | 888.779987871647 |          1785.75 | -896.970012128353
 ANTON       | Mexico  |    10856 |              626 | 888.779987871647 | -262.779987871647
 ANTON       | Mexico  |    10365 | 184.799991607666 |              626 | -441.200008392334
 AROUT       | UK      |    10558 | 6346.89995956421 |                  |                  
 AROUT       | UK      |    10768 |             4416 | 6346.89995956421 | -1930.89995956421
 AROUT       | UK      |    10707 | 3477.29999983311 |             4416 | -938.700000166893
 AROUT       | UK      |    10383 | 2414.79998111725 | 3477.29999983311 | -1062.50001871586
 AROUT       | UK      |    10953 | 2002.49999992549 | 2414.79998111725 | -412.299981191754
 AROUT       | UK      |    10864 |             1568 | 2002.49999992549 | -434.499999925494
 AROUT       | UK      |    10453 | 1325.59999078512 |             1568 | -242.400009214878
 AROUT       | UK      |    11016 |           1071.5 | 1325.59999078512 | -254.099990785122
 AROUT       | UK      |    10355 | 975.600019454956 |           1071.5 | -95.8999805450439
 AROUT       | UK      |    10920 |            812.5 | 975.600019454956 | -163.100019454956
 AROUT       | UK      |    10793 | 759.649984359741 |            812.5 | -52.8500156402588
 AROUT       | UK      |    10743 | 550.599999979138 | 759.649984359741 | -209.049984380603
 AROUT       | UK      |    10741 | 34.9999999552965 | 550.599999979138 | -515.600000023842