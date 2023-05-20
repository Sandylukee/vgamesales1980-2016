/*
dataset source: https://www.kaggle.com/datasets/ibriiee/video-games-sales-dataset-2022-updated-extra-feat

I use this dataset to learn finding some interesting fact about video game sales from 1980 to 2016 using SQL
and visualize it using tableau, here is the link: https://public.tableau.com/app/profile/sandy.nugroho/viz/VideGameSalesReleasein1980-2016_16845544035670/Dashboard1?publish=yes

I didn't visualize all the query results, just some of those that I find interesting to be shown.

I didn't use all the data (1980-2020), just 1980-2016 because I think the record from 2017-2020 isn't completed yet.
*/

use vgamesales;

select * from vgsclean;

-- 1. Total Games Released

select count(distinct name) as total_games
from vgsclean
where year < 2017;

-- 2. Best Selling Game

-- select name, (sum(global_sales)/(select sum(global_sales) from vgsclean))*100 as percentage
with ts as (select name, sum(global_sales) total_sales
from vgsclean
where year < 2017
group by 1
order by 2 desc
-- limit 5
)

select ts.name, concat(ts.total_sales/1000000, 'M')
from ts;

select name, sum(global_sales) total_sales
from vgsclean
where year < 2017
group by 1
order by 2 desc
-- limit 5
;

-- 3. Publisher with The Most Games

select publisher, count(distinct name) total_games
from vgsclean
where year < 2017
group by 1
order by 2 desc
limit 5
;
 
 
-- 4. Number of Games by Year

select year, count(distinct name) as total_games
from vgsclean
where year < 2017
group by 1
order by 1;

select distinct publisher from vgsclean;


-- 5. Sales per Continent

select 
sum(NA_sales) as total_NA_sales, 
sum(EU_sales) as total_EU_sales, 
sum(JP_sales) as total_JP_sales, 
sum(other_sales) as total_other_sales
from vgsclean
where year < 2017;


-- 6. Comparison of the Number of Games by Genre

select genre, count(distinct name) as total_games
from vgsclean
where year < 2017
group by 1
order by 2 desc;

-- 7. Comparison of total sales by Genre

select genre, sum(global_sales) as total_sales
from vgsclean
where year < 2017
group by 1
order by 2 desc;

-- 8. Best Selling Game per Publisher

with r as
(select publisher, name, global_sales, rank() over(partition by publisher order by global_sales desc) as r1
from vgsclean
where year < 2017
order by 1, 3 desc)

select r.publisher, r.name, r.global_sales
from r
where r.r1 = 1
order by 1
;


-- 9. Best Selling Game per Genre

with r2 as(
select 
genre, 
name, 
sum(global_sales) as total_sales, 
rank() over(partition by genre order by sum(global_sales) desc) as rg
from vgsclean
where year < 2017
group by 1, 2
order by 1, 3 desc)
select r2.genre, r2.name, r2.total_sales
from r2
where r2.rg = 1
;

select 
genre, 
name, 
sum(global_sales) as total_sales, 
rank() over(partition by genre order by sum(global_sales) desc) as rg
from vgsclean
group by 1, 2
order by 1, 3 desc;
