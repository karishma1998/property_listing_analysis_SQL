use project;
select*from [dbo].[host_dallas_df$];
select*from [dbo].[listing_dallas_df$];
select* from [dbo].[review_dallas_df];
select* from df_dallas_availability$;

------------
SELECT distinct room_type,
   Avg(review_scores_rating) AS average_of_review_score_rating
FROM  [dbo].[listing_dallas_df$]
GROUP  BY room_type;

----------------
select distinct room_type,
sum(bedrooms)as sum_of_bedroom,
sum(beds) as sum_of_beds
from [dbo].[listing_dallas_df$]
group by room_type
order by room_type;
-----------

SELECT  room_type,
   Avg(maximum_nights) AS average_of_maximum_nights,
    Avg(minimum_nights)AS average_of_minimum_nights
FROM  [dbo].[listing_dallas_df$] 
GROUP  BY room_type
order by room_type
----------------

select year(a.date) as year,count(1) as sales_count,sum(a.price) as price_sum
from df_dallas_availability$  as a
left join df_dallas_availability$ as b on a.id =b.listing_id
group by YEAR(a.date)
order by sales_count
----------------

SELECT a.property_type,
sum (available) as avail
from   [dbo].[listing_dallas_df$] as a
left join df_dallas_availability$ as b on a.id= b.listing_id
where year(b.date) = 2022
GROUP by a.property_type
--------------
SELECT a.property_type,
sum (available) as avail
from  [dbo].[listing_dallas_df$]  as a
left join df_dallas_availability$ as b on a.id= b.listing_id
where year(b.date) = 2023
GROUP by a.property_type
----------------
select a.property_type,sum(a.price) total_price,sum(b.available) as total_avail,
case when sum(available)<=1000 then 'catag_1' 
	when sum(available)>1000 and sum(available)<=10000 then 'catag_2'
	when sum(available)>10000 and sum(available)<=20000 then 'catag_3' else 'catag_4' end as catagorys
from [dbo].[listing_dallas_df$] as a 
left join df_dallas_availability$ as b on a.id =b.listing_id
group by a.property_type
having  sum(b.available) is not null
order by total_avail;



--------------

select case when  host_is_superhost='true' then 'superhost'
else 'host' end as host_is_superhost, review_count from(
select c.host_is_superhost , COUNT(a.reviewer_id) as review_count from [dbo].[review_dallas_df]  as a left join [dbo].[listing_dallas_df$]  as b on a.reviewer_id=b.id
left join [dbo].[host_dallas_df$] as c on b.host_id=c.host_id
where (a.comments) like '%beautiful%'or (a.comments) like '%tastefull%' or (a.comments) like  '%perfect%' or
(a.comments) like '%amazing%'or (a.comments) like '%very clean%' or (a.comments) like  '%gracious%' or
(a.comments) like '%best host%'or (a.comments) like '%awesome%' or (a.comments) like  '%great place%' and c.host_is_superhost is not null
group by c.host_is_superhost) as mm