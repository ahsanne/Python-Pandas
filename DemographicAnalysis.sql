-- How many people of each race are represented in this dataset?
select race, count(*) total 
from adult 
group by race

-- What is the average age of men and women ?
select sex, round(avg(age), 1) avg_age
from adult
group by sex

-- What is the percentage of people who have a Bachelor's degree?
select education, round((count(1) / (select count(*) from adult)) * 100) perc
from adult 
group by education
order by perc desc

-- What percentage of people with advanced education (Bachelors, Masters, or Doctorate) make more than 50K?

select (count(education) / (select count(*) 
									from adult 
									where education in ('Bachelors', 'Masters','Doctorate'))* 100) Perc_adv_edu
from adult 
where education in ('Bachelors', 'Masters','Doctorate') and
	  salary = '>50K'

-- What percentage of people without advanced education make more than 50K?

select (count(education) / (select count(*) 
									from adult 
									where education not in ('Bachelors', 'Masters','Doctorate'))* 100) Perc_lower_edu
from adult 
where education not in ('Bachelors', 'Masters','Doctorate') and
	  salary = '>50K'
      
-- What is the minimum number of hours a person works per week?
      
select min(hours_per_week) from adult

-- What percentage of the people who work the minimum number of hours per week have a salary of more than 50K?

select hours_per_week, (count(*) / (select count(hours_per_week) 
								   from adult
                                   where hours_per_week = 1)*100) per
from adult
where salary = '>50K' and 
	  hours_per_week = 1
      
-- What country has the highest percentage of people that earn >50K and what is that percentage?


with 
	cte1 as(select native_country, count(*) sal_above50K from adult where salary = '>50K' group by native_country),
	cte2 as(select native_country, count(*) total from adult group by native_country)
select cte1.native_country, ((sal_above50K / total ) * 100) as per_sal_above50K
from cte1 join cte2
where cte1.native_country = cte2.native_country
order by per_sal_above50K desc


select native_country, count(native_country) /
						(select count(native_country)
                        from adult
                        group by native_country 
						) as sal
from adult 
where salary = '>50K'
group by native_country

-- Identify the most popular occupation for those who earn >50K in India.

select occupation, count(*) total
from adult 
where native_country = 'India' and 
		salary = '>50K'
group by occupation
order by total desc