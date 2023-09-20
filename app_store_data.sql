create table applestre_compined AS
select * from appleStore_description1
union all 
select * from appleStore_description2
union ALL
select * from appleStore_description3
union ALL
select * from appleStore_description4

** EDA **

--  check the number of unique apps in both tables aAppleStore 

select count(distinct id) as UniqueAppIDs 
from AppleStore

select count(distinct id) as UniqueAppIDs 
from applestre_compined

-- from both the table the count is 7197, so both the table records are equal.AppleStore

** Missing Values**

-- check for any missing values in the key fields

select count(*) as MissingValues
from AppleStore
where track_name is null or user_rating is null or prime_genre is NULL


select count(*) as MissingValues
from applestre_compined
where app_desc is null 

-- According the result there are no missing vaules in both the tables.AppleStore

-- find out the number of apps per genre 

select prime_genre, count(*) as NumApps
from AppleStore
group by prime_genre
order by NumApps DESC

-- "Games"	"3862"
"Entertainment"	"535"
"Education"	"453"
"Photo & Video"	"349"
"Utilities"	"248"
"Health & Fitness"	"180"
"Productivity"	"178"
"Social Networking"	"167"
"Lifestyle"	"144"
"Music"	"138"
"Shopping"	"122"
"Sports"	"114"
"Book"	"112"
"Finance"	"104"
"Travel"	"81"
"News"	"75"
"Weather"	"72"
"Reference"	"64"
"Food & Drink"	"63"
"Business"	"57"
"Navigation"	"46"
"Medical"	"23"
"Catalogs"	"10" -- this will be the result of the Number of apps in GenreAppleStore

-- Get an overview of the apps rathing

select min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore

-- the output of the query is "0"	"5"	"3.526955675976101"


--get the distribution of app pricesAppleStore

select 
(price / 2) *2 as PriceBinStart,
((price / 2)*2) +2 as PriceBinEnd,
count(*) as NumApps
from AppleStore
group by PriceBinStart
order by PriceBinStart

** Data Analysis**

--Determine whether paid apps have higher ratings than free apps


select case 
			when price >0 then 'paid'
            else 'free'
       end as App_Type,
       avg(user_rating) as Avg_Rating
from AppleStore
group by App_Type

-- check if apps with more supported languages have higher ratings


select CASE
			when lang_num <10 then '<10 languages'
            when lang_num between 10 and 30 then '10 -30 languages'
            else '>30 languages'
       end as language_bucket,
       avg(user_rating) as Avg_Rating
from AppleStore
group by language_bucket
order by Avg_Rating DESC


--check genres with low ratings 


select prime_genre, avg(user_rating) as Avg_Rating
from AppleStore
group by prime_genre
order by Avg_Rating ASC 
limit 10


-- check if there is correlation between the length of the app description and the user rating 

SELECT CASE
			when length(b.app_desc) <500 then 'Short'
            when length(b.app_desc) between 500 and 1000 then 'Medium'
            else 'Long'
       end as desc_length_bucket,
       avg(a.user_rating) as avg_rating

from 	
	AppleStore as A
    
JOIN
	applestre_compined as b 
on 
	a.id = b.id
group by desc_length_bucket
order by avg_rating desc


--check the top - rated app for each genre

select 
	prime_genre,
    track_name,
    user_rating
from (
  			SELECT
  			prime_genre,
  			track_name,
  			user_rating,
  			RANK() over(PARTITION BY prime_genre order by user_rating desc, rating_count_tot desc) as rank
            from 
            AppleStore
       ) as a 
 WHERE
  a.rank = 1
  
  
-- final conclusion for the above task 

-- 1. paid apps have better ratings 
-- 2. apps supprting between 10 and 30 languages have better ratings. 
-- 3. finance and book apps have low ratings. 
-- 4. apps with a longer description have better ratings. 
-- 5. a new app should aim for an average ratings above 3.5. 
-- 6. games and enterteinment have high competition. 
                        
            

