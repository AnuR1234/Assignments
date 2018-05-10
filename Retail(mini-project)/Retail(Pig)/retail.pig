
--‐ Analyze the entire data set and arrive at products that have experienced a consolidated yearly avg growth of 10% or more in sales since 2000.

--Load monthly data from local into three bags
sales2000 = LOAD '/home/hduser/Downloads/retail/2000.txt' using PigStorage(',') as (prod_id:long, product:chararray, jan:double, feb:double, mar:double, apr:double, may:double, jun:double, jul:double, aug:double, sep:double, oct:double, nov:double, dec:double);

sales2001 = LOAD '/home/hduser/Downloads/retail/2001.txt' using PigStorage(',') as (prod_id:long, product:chararray, jan:double, feb:double, mar:double, apr:double, may:double, jun:double, jul:double, aug:double, sep:double, oct:double, nov:double, dec:double);

sales2002 = LOAD '/home/hduser/Downloads/retail/2002.txt' using PigStorage(',') as (prod_id:long, product:chararray, jan:double, feb:double, mar:double, apr:double, may:double, jun:double, jul:double, aug:double, sep:double, oct:double, nov:double, dec:double);

--Calculate annual sales by adding monthly sales of each year
totsales2000 = foreach sales2000 generate prod_id, product, $2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13 as total2000;

totsales2001 = foreach sales2001 generate prod_id, product, $2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13 as total2001;

totsales2002 = foreach sales2002 generate prod_id, product, $2+$3+$4+$5+$6+$7+$8+$9+$10+$11+$12+$13 as total2002;

--dump totsales2000;

--join all 3 bags

totalsalesall = join totsales2000 by $0,totsales2001 by $0,totsales2002 by $0;

--describe totalsalesall;
--removing repetitive columns


result = foreach totalsalesall generate $0,$1,$2,$5,$8;

--describe result;

growth = foreach result generate $0,$1,(($3-$2)*100) as g1,(($4-$3)/$3*100) as g2;

--describe growth;
--dump growth;
avg1 = foreach growth generate $0,$1,($2+$3)/2 as avg;
---describe avg1;
--dump avg1;

final = filter avg1 by avg > 10.0;

--dump final;

 
--‐Qns2: Analyze the entire data set and arrive at products that have experienced a consolidated yearly avg drop of 5% or more since 2000.

--all are same till avg1:

final2 = filter avg1 by avg < -5.0;

--dump final2;

--Qns3:- Find top 5 products and bottom 5 products of overall sales for 3 years.

--till result;

total = foreach result generate $0,$1,($2+$3+$4) as totalall;

top5 = order total by totalall desc;

top5 = limit top5 5;

--dump top5;

bottom5 = order total by totalall;

bottom5 = limit bottom5 5;

--dump bottom5;


