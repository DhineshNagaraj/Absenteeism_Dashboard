SELECT * FROM absenteeism.absenteeism_at_work;
SELECT * FROM absenteeism.compensation;
SELECT * FROM absenteeism.reasons;
use absenteeism;

SELECT * FROM work;
SELECT * FROM compensation;
SELECT * FROM reasons;


-- create join--

select * from work a
left join compensation b on a.ID = b.ID
left join reasons c on 
a.`Reason for absence` = c.number;


-- main working table -- 


select a.ID,
`comp/hr`,
Reason,
`Month of absence`,
case 
when `Month of absence` = 1 then 'Jan'
when `Month of absence` = 2 then 'Feb'
when `Month of absence` = 3 then 'Mar'
when `Month of absence` = 4 then 'Apr'
when `Month of absence` = 5 then 'May'
when `Month of absence` = 6 then 'Jun'
when `Month of absence` = 7 then 'Jul'
when `Month of absence` = 8 then 'Aug'
when `Month of absence` = 9 then 'Sep'
when `Month of absence` = 10 then 'Oct'
when `Month of absence` = 11 then 'Nov'
when `Month of absence` = 12 then 'Dec'
else 'Data not found'
end as 'month name',
Seasons,
`Day of the week`,
case
when `Day of the week` = 2 then 'Mon'
when `Day of the week` = 3 then 'Tue'
when `Day of the week` = 4 then 'Wed'
when `Day of the week` = 5 then 'Thu'
when `Day of the week` = 6 then 'Fri'
end as 'weeks name',
`Transportation expense`,
`Distance from Residence to Work`,
`Service time`,
Age,
case
when age >=35 then 'Middle age'
when age <35 then 'Adult'
end as 'Age category',
Weight,
Height,
`Body mass index`,
case
when `Body mass index` <= 18.5 then 'Under weight'
when `Body mass index` between 18.6 and 25 then 'Normal'
when `Body mass index` between 25.01 and 29.9 then 'Over weight'
when `Body mass index` >= 30 then 'Obese'
end as 'BMI range',
`Absenteeism time in hours`
from work a
left join compensation b on a.ID = b.ID
left join reasons c on 
a.`Reason for absence` = c.number;


-- finding healthly individual who deseves bonus--
-- non smoker, non drinker, BMI below 25 and absenteeism less than average time --


select * from work where
`Social drinker` = 0 and
`Social smoker` = 0 and
`Body mass index` < 25 and
`Absenteeism time in hours` < (select avg(`Absenteeism time in hours`) from work );


-- main working table of healthy individuals --

select a.ID,
`comp/hr`,
Reason,
`Month of absence`,
case 
when `Month of absence` = 1 then 'Jan'
when `Month of absence` = 2 then 'Feb'
when `Month of absence` = 3 then 'Mar'
when `Month of absence` = 4 then 'Apr'
when `Month of absence` = 5 then 'May'
when `Month of absence` = 6 then 'Jun'
when `Month of absence` = 7 then 'Jul'
when `Month of absence` = 8 then 'Aug'
when `Month of absence` = 9 then 'Sep'
when `Month of absence` = 10 then 'Oct'
when `Month of absence` = 11 then 'Nov'
when `Month of absence` = 12 then 'Dec'
else 'Data not found'
end as 'month name',
Seasons,
`Day of the week`,
case
when `Day of the week` = 2 then 'Mon'
when `Day of the week` = 3 then 'Tue'
when `Day of the week` = 4 then 'Wed'
when `Day of the week` = 5 then 'Thu'
when `Day of the week` = 6 then 'Fri'
end as 'weeks name',
`Transportation expense`,
`Distance from Residence to Work`,
`Service time`,
Age,
case
when age >=35 then 'Middle age'
when age <35 then 'Adult'
end as 'Age category',
Weight,
Height,
`Body mass index`,
case
when `Body mass index` <= 18.5 then 'Under weight'
when `Body mass index` between 18.6 and 25 then 'Normal'
when `Body mass index` between 25.01 and 29.9 then 'Over weight'
when `Body mass index` >= 30 then 'Obese'
end as 'BMI range',
`Absenteeism time in hours`
from work a
left join compensation b on a.ID = b.ID
left join reasons c on 
a.`Reason for absence` = c.number
where
`Social drinker` = 0 and
`Social smoker` = 0 and
`Body mass index` < 25 and
`Absenteeism time in hours` < (select avg(`Absenteeism time in hours`) from work );

-- compensation/budget amt for non smokers -- 
-- budget is 983,221 -- 
select count(*) from work where `Social smoker` = 0;

-- total no of working hrs by non smokers in a year = 1426880 hrs --
select 5*8*52*(select count(*) from work where `Social smoker` = 0) as 'total working hrs by non smokers in a year' ;

-- compensation per hour = 0.6891 --
select 983221 / (select 5*8*52*(select count(*) from work where `Social smoker` = 0));

-- compensation per employee for 1 year = $1433.26--
select (select 983221 / (select 5*8*52*(select count(*) from work where `Social smoker` = 0)))*5*8*52;




-- calculation of absenteeism by reason --

select Reason, sum(`Absenteeism time in hours`) as 'total hours', count(*) as 'count of employees' from work a
left join compensation b on a.ID = b.ID
left join reasons c on 
a.`Reason for absence` = c.number
group by Reason
order by `total hours` desc ;

-- absenteeism in smoker vs non smoker --

select 
case 
	when `Social smoker` = 0 then 'Non smoker'
	when `Social smoker` = 1 then ' smoker'
end as 'Category',
count(*), 
sum(`Absenteeism time in hours`) as 'total absent hours',
sum(`Absenteeism time in hours`)/count(*) from work
group by `Social smoker`;


-- absenteeism in social drinker-- 

select 
case 
	when `Social drinker` = 0 then 'Non drinker'
	when `Social drinker` = 1 then ' drinker'
end as 'Category',
count(*), 
sum(`Absenteeism time in hours`) as 'total absent hours',
sum(`Absenteeism time in hours`)/count(*) from work
group by `Social drinker`;

-- abesnteeism with either one of the habit  --


SELECT 
  CASE 
    WHEN `Social smoker` = 1 AND `Social drinker` = 1 THEN 'Smoker and Drinker'
    WHEN `Social smoker` = 0 AND `Social drinker` = 0 THEN 'Non Smoker and Non Drinker'
    ELSE 'Either one'
  END AS 'Category',
  COUNT(*) AS 'Total Employees',
  SUM(`Absenteeism time in hours`) AS 'Total Absent Hours',
  SUM(`Absenteeism time in hours`) / COUNT(*) AS 'Average Absent Hours'
FROM work
GROUP BY 
  CASE 
    WHEN `Social smoker` = 1 AND `Social drinker` = 1 THEN 'Smoker and Drinker'
    WHEN `Social smoker` = 0 AND `Social drinker` = 0 THEN 'Non Smoker and Non Drinker'
    ELSE 'Either one'
  END;

-- absenteesism in drinkers and non drinkers --
select 
case 
	when `Social drinker` = 0 then 'Non drinker'
	when `Social drinker` = 1 then ' drinker'
end as 'Category',
count(*), 
sum(`Absenteeism time in hours`) as 'total absent hours',
sum(`Absenteeism time in hours`)/count(*) from work
group by `Social drinker`;



-- BMI range table --

SELECT
  CASE
    WHEN `Body mass index` <= 18.5 THEN 'Under weight'
    WHEN `Body mass index` BETWEEN 18.6 AND 25 THEN 'Normal'
    WHEN `Body mass index` BETWEEN 25.01 AND 29.9 THEN 'Over weight'
    WHEN `Body mass index` >= 30 THEN 'Obese'
  END AS 'BMI range',
  COUNT(*) AS 'Count',
  SUM(`Absenteeism time in hours`) AS 'Total Absenteeism Hours',
  SUM(`Absenteeism time in hours`) /COUNT(*) as 'avg absenteeism hrs by bmi range'
FROM
  work
GROUP BY 
 CASE
    WHEN `Body mass index` <= 18.5 THEN 'Under weight'
    WHEN `Body mass index` BETWEEN 18.6 AND 25 THEN 'Normal'
    WHEN `Body mass index` BETWEEN 25.01 AND 29.9 THEN 'Over weight'
    WHEN `Body mass index` >= 30 THEN 'Obese'
  END;





 