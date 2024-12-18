-- codewars 8 kyu Quarter of the year

select month, CASE
  WHEN month>=1 and month<=3 THEN 1
  WHEN month>=4 and month<=6 THEN 2
  WHEN month>=7 and month<=9 THEN 3
  ELSE 4
  END as res
 from quarterof


-- codewars 7 kyu Leap Years

select
  year,
  case
    when (year%4 = 0 and year%100 <> 0) or year%400 = 0 then true
    else false
  end as is_leap  -- your code here
from years
order by year;      -- result has to be sorted by year, ascending


-- codewars 7 kyu Best-Selling Books (SQL for Beginners #5)

select *
from books
order by copies_sold desc limit 5


-- codewars 7 kyu SQL Basics - Trimming the Field

select id, name, split_part(characteristics, ',', 1) as characteristic
from monsters
order by id


-- codewars 6 kyu SQL Basics: Simple HAVING

select age, COUNT(id) as total_people
from people
group by age
having COUNT(id)>=10


-- codewars 6 kyu SQL Bug Fixing: Fix the QUERY - Totaling

SELECT 
  CAST(s.transaction_date as DATE) as day,
  d.name as department,
  COUNT(s.id) as sale_count
  FROM department d
    JOIN sale s on d.id = s.department_id
  group by department, day
  order by day, department asc


-- codewars 7 kyu Easy SQL: Cube Root and Natural Log

select cbrt(number1) as cuberoot, ln(number2) as logarithm
from decimals


-- codewars 7 kyu BASICS: Length based SELECT with LIKE

select n.first_name, n.last_name
from names n
where n.first_name like '______%'


-- codewars 7 kyu GROCERY STORE: Support Local Products

select count(*) as products, country
from products
where country in ('United States of America','Canada')
group by country
order by products desc


-- codewars 6 kyu SQL Basics: Simple NULL handling

select id, 
  COALESCE(NULLIF(name,''), '[product name not found]') as name, 
  price, 
  COALESCE(NULLIF(card_name,''), '[card name not found]') as card_name, 
  card_number, 
  transaction_date
from eusales
where COALESCE(price, 0)>50


-- codewars 6 kyu Conditional Count

select DATE_PART('month', payment_date::date) as month,
  count(*) as total_count,
  sum(amount) as total_amount,
  count(*) filter(where staff_id = 1) as mike_count,
  sum(amount) filter(where staff_id = 1) as mike_amount,
  count(*) filter(where staff_id = 2) as jon_count,
  sum(amount) filter(where staff_id = 2) as jon_amount
from payment
group by month
order by month


-- codewars 6 kyu SQL Bug Fixing: Fix the JOIN

SELECT 
  j.job_title,
  CAST(ROUND(AVG(j.salary),2) as FLOAT) as average_salary,
  COUNT(p.id) as total_people,
  CAST(ROUND(SUM(j.salary),2) as FLOAT) as total_salary
  FROM people p
    JOIN job j on p.id=j.people_id
  GROUP BY j.job_title
  ORDER BY average_salary desc


-- codewars 6 kyu SQL Basics: Simple UNION ALL

select
  'US' as location,
  u.id,
  u.name,
  u.price,
  u.card_name,
  u.card_number,
  u.transaction_date
from ussales u
where price>50
union all
select
  'EU' as location,
  e.id,
  e.name,
  e.price,
  e.card_name,
  e.card_number,
  e.transaction_date
from eusales e
where price>50
order by location desc, id


-- codewars 5 kyu Using Window Functions To Get Top N per Group

with post_ranks as (
  select c.id as category_id, c.category, p.title, p.views, p.id as post_id, RANK() OVER(PARTITION BY p.category_id ORDER BY p.views DESC, p.id ASC) as view_rank
  from categories c left join posts p on c.id=p.category_id
)

select category_id, category, title, views, post_id
from post_ranks
where view_rank in (1,2)
order by category, views desc, post_id


-- codewars 5 kyu Calculating Running Total

with posts_num as (
  select
    created_at::DATE as date,
    COUNT(created_at) as count
  from posts
  group by created_at::DATE
)

select date, count, (sum(count) over(order by date rows unbounded preceding))::INT as total
from posts_num
order by date


-- codewars 6 kyu The Peculiar Taste of Store Owner

with j_actors_max_id as (  
  select a.actor_id, a.first_name || ' ' || a.last_name as full_name, MAX(f.film_id) as max_id
  from film f join film_actor fa on f.film_id=fa.film_id join actor a on fa.actor_id=a.actor_id
  where a.first_name like 'J%'
  group by a.actor_id, full_name
)

select j.actor_id, j.full_name, f.title as film_title
from j_actors_max_id j join film f on j.max_id=f.film_id
order by j.actor_id


-- codewars 7 kyu Disemvowel Trolls

select str, regexp_replace(str, '[AEIOUaeiou]', '', 'g') as res
from disemvowel


-- leetcode 175. Combine Two Tables

select firstName, lastName, city, state
from Person left join Address on Person.personID=Address.personID


-- leetcode 176. Second Highest Salary

select max(salary) SecondHighestSalary
from Employee
where salary < (select max(salary) from Employee)


-- leetcode 177. Nth Highest Salary

CREATE FUNCTION getNthHighestSalary(@N INT) RETURNS INT AS
BEGIN
    RETURN (
        select max(salary)
        from (
            select salary, dense_rank() over(order by salary desc) rank_desc
            from Employee
        ) ranks
        where rank_desc=@N
    );
END


-- leetcode 178. Rank Scores

select Score, dense_rank() over(order by Score desc) as Rank
from Scores


-- leetcode 181. Employees Earning More Than Their Managers

select e1.name Employee
from Employee e1, Employee e2
where e1.managerId=e2.id and e1.salary>e2.salary


-- leetcode 182. Duplicate Emails

select email Email
from (select email, count(*) as email_num from Person group by email having count(*) > 1) t1


-- leetcode 183. Customers Who Never Order

select name Customers
from Customers left join Orders on Customers.id=Orders.CustomerId
where CustomerId is NULL


-- leetcode 184. Department Highest Salary

with salaries as (
    select 
        d.name as Department, 
        e.name as Employee, 
        e.salary as Salary, 
        dense_rank() over(partition by d.name order by e.salary desc) as salary_rank
    from Employee e left join Department d on e.departmentId=d.id
)

select Department, Employee, Salary
from salaries
where salary_rank=1


-- leetcode 196. Delete Duplicate Emails

delete from Person
where id not in (select MIN(id) from Person group by email)


-- leetcode 197. Rising Temperature

select t2.id
from Weather t1, Weather t2
where datediff(dayofyear,t1.recordDate,t2.recordDate) = 1 and t2.temperature>t1.temperature


-- leetcode 511. Game Play Analysis I

select player_id, min(event_date) as first_login
from Activity
group by player_id


-- leetcode 570. Managers with at Least 5 Direct Reports

select a.name
from Employee a join Employee b on a.id=b.managerId
group by a.id, a.name
having count(b.managerId)>=5


-- leetcode 577. Employee Bonus

select name, bonus
from Employee left join Bonus on Employee.empId=Bonus.empId
where ISNULL(bonus,0)<1000


-- leetcode 584. Find Customer Referee

select name
from Customer
where referee_id<>2 or referee_id is null


-- leetcode 585. Investments in 2016

with unique_lat_lon as (    
    select lat, lon
    from Insurance
    group by lat, lon
    having count(*)=1
),
group_tiv_2015 as (
    select tiv_2015
    from Insurance
    group by tiv_2015
    having count(tiv_2015)>=2
)

select round(sum(tiv_2016),2) as tiv_2016
from Insurance
where 
    tiv_2015 in (select tiv_2015 from group_tiv_2015) 
    and lat in (select lat from unique_lat_lon) 
    and lon in (select lon from unique_lat_lon)


-- leetcode 586. Customer Placing the Largest Number of Orders

select customer_number
from (
    select top(1) customer_number, count(order_number) as order_amount 
    from Orders 
    group by customer_number
    order by count(order_number) desc
) o1


-- leetcode 595. Big Countries

select name, population, area
from World
where area>=3000000 or population>=25000000


-- leetcode 596. Classes More Than 5 Students

select class
from (
    select class, count(*) as students_num
    from Courses
    group by class
    having count(*)>=5
) c1


-- leetcode 602. Friend Requests II: Who Has the Most Friends

with id_and_num as (    
    select requester_id as id, count(*) as num
    from RequestAccepted
    group by requester_id
    union all
    select accepter_id as id, count(*) as num
    from RequestAccepted
    group by accepter_id
),
top_ids as (
    select id, sum(num) as num, dense_rank() over(order by sum(num) desc) as rank
    from id_and_num
    group by id
)

select id, num
from top_ids
where rank=1


-- leetcode 607. Sales Person

select distinct s.name
from SalesPerson s
where s.sales_id not in (
    select distinct sales_id
    from Orders o join Company c on o.com_id=c.com_id
    where c.name = 'RED'
)


-- leetcode 619. Biggest Single Number

select MAX(num) num
from (
    select num, count(*) as num_amount
    from MyNumbers
    group by num
    having count(*) = 1
) t1


-- leetcode 620. Not Boring Movies

select *
from Cinema
where description <> 'boring' and id % 2 <> 0
order by rating desc


-- leetcode 626. Exchange Seats

select
    case
        when id%2!=0 and id!=(select max(id) from Seat) then id+1
        when id%2=0 then id-1
        when id=(select max(id) from Seat) then id
    end as id,
    student
from Seat
order by id


-- leetcode 627. Swap Salary

update Salary 
set sex = (
    case
        when sex='m' then 'f'
        when sex='F' then 'm'
        end
)


-- leetcode 1045. Customers Who Bought All Products

select customer_id
from Customer
group by customer_id
having count(distinct product_key) = (select count(*) from Product)


-- leetcode 1050. Actors and Directors Who Cooperated At Least Three Times

select actor_id, director_id
from (
    select actor_id, director_id, count(*) as cooperations
    from ActorDirector
    group by actor_id, director_id
    having count(*)>=3
) t1


-- leetcode 1068. Product Sales Analysis I

select product_name, year, price
from Sales s join Product p on s.product_id=p.product_id


-- leetcode 1070. Product Sales Analysis III

with product_year_rank as (
    select product_id, year as first_year, dense_rank() over(partition by product_id order by year) as year_rank
    from Sales
),
first_years as (
    select product_id, first_year
    from product_year_rank
    where year_rank=1
)

select distinct Sales.product_id, year as first_year, quantity, price
from Sales join first_years on Sales.product_id=first_years.product_id and Sales.year=first_years.first_year


-- leetcode 1075. Project Employees I

select p.project_id, round(avg(1.00*experience_years),2) as average_years
from Project p join Employee e on p.employee_id=e.employee_id
group by p.project_id


-- leetcode 1148. Article Views I

select distinct author_id as id
from Views
where author_id=viewer_id
order by id


-- leetcode 1158. Market Analysis I

select user_id as buyer_id, join_date, count(distinct order_id) as orders_in_2019
from Users u left join Orders o on u.user_id=o.buyer_id
and year(order_date)=2019
group by user_id, join_date


-- leetcode 1084. Sales Analysis III

select distinct s.product_id, p.product_name
from Sales s join Product p on s.product_id=p.product_id
group by s.product_id, p.product_name
having min(s.sale_date)>='2019-01-01' and max(sale_date)<='2019-03-31'


-- leetcode 1141. User Activity for the Past 30 Days I

select activity_date as day, count(distinct user_id) as active_users
from Activity
where activity_date between DATEADD(day,-29,'2019-07-27') and '2019-07-27'
group by activity_date


-- leetcode 1164. Product Price at a Given Date

with product_max_date as (
    select product_id, max(change_date) as max_change_date
    from Products
    where change_date<='2019-08-16'
    group by product_id
    union
    select product_id, max(change_date) as max_change_date
    from Products
    group by product_id
    having min(change_date)>'2019-08-16'
)

select p.product_id, 
    case
        when pmd.max_change_date<='2019-08-16' then p.new_price
        when pmd.max_change_date>'2019-08-16' then 10
    end as price
from Products p join product_max_date pmd on p.product_id=pmd.product_id
    and p.change_date=pmd.max_change_date


-- leetcode 1174. Immediate Food Delivery II

with order_ranks as (   
    select
        customer_id,
        delivery_id,
        case
            when order_date=customer_pref_delivery_date then 'immediate'
            when order_date!=customer_pref_delivery_date then 'scheduled'
        end as order_type,
        rank() over(partition by customer_id order by order_date) as order_date_rank
    from Delivery
),
immediate_first_orders as (
    select count(order_type) as immediate_orders_num
    from order_ranks
    where order_type='immediate' and order_date_rank=1
),
total_first_orders as (
    select count(order_type) as total_orders_num
    from order_ranks
    where order_date_rank=1
)

select round(immediate_orders_num/cast(total_orders_num as float)*100,2) as immediate_percentage
from immediate_first_orders, total_first_orders


--leetcode 1179. Reformat Department Table

select 
	id, 
	[Jan] as [Jan_Revenue], 
	[Feb] as [Feb_Revenue], 
	[Mar] as [Mar_Revenue], 
	[Apr] as [Apr_Revenue], 
	[May] as [May_Revenue], 
	[Jun] as [Jun_Revenue], 
	[Jul] as [Jul_Revenue], 
	[Aug] as [Aug_Revenue], 
	[Sep] as [Sep_Revenue], 
	[Oct] as [Oct_Revenue], 
	[Nov] as [Nov_Revenue], 
	[Dec] as [Dec_Revenue]
from (
    select dep.id, dep.month, dep.revenue
    from dbo.Department dep
) as src
pivot (
    sum(src.revenue) for src.month in ([Jan], [Feb], [Mar], [Apr], [May], [Jun], [Jul], [Aug], [Sep], [Oct], [Nov], [Dec])
) as pvt


--leetcode 1193. Monthly Transactions I

create test_db
go
use test_db
go
Create table dbo.Transactions (id int, country varchar(4), state nvarchar(20), amount int, trans_date date)
go
insert into dbo.Transactions (id, country, state, amount, trans_date) values ('121', 'US', 'approved', '1000', '2018-12-18')
insert into dbo.Transactions (id, country, state, amount, trans_date) values ('122', 'US', 'declined', '2000', '2018-12-19')
insert into dbo.Transactions (id, country, state, amount, trans_date) values ('123', 'US', 'approved', '2000', '2019-01-01')
insert into dbo.Transactions (id, country, state, amount, trans_date) values ('124', 'DE', 'approved', '2000', '2019-01-07')
insert into dbo.Transactions (id, country, state, amount, trans_date) values ('125', NULL, 'approved', '2000', '2019-01-07')
go

use test_db
go
with all_trans as (
	select concat(format(trans_date, 'yyyy-MM'),'-',country) as tbl_id, format(trans_date, 'yyyy-MM') as [month], country, count(id) as trans_count, sum(amount) as trans_total_amount
	from dbo.Transactions
	group by format(trans_date, 'yyyy-MM'), country
),
approved_trans as (
	select concat(format(trans_date, 'yyyy-MM'),'-',country) as tbl_id, format(trans_date, 'yyyy-MM') as [month], country, count(id) as trans_count, sum(amount) as trans_total_amount
	from dbo.Transactions
	where [state]='approved'
	group by format(trans_date, 'yyyy-MM'), country
)
select [all].[month], [all].country, [all].trans_count, coalesce(app.trans_count,0) as approved_count, [all].trans_total_amount, coalesce(app.trans_total_amount,0) as approved_total_amount
from all_trans as [all] left join approved_trans as app on [all].tbl_id=app.tbl_id

use test_db
go
drop table dbo.Transactions


--leetcode 1204. Last Person to Fit in the Bus

create test_db
go
use test_db
go
Create table dbo.Queue (person_id int, person_name varchar(30), weight int, turn int)
go
insert into Queue (person_id, person_name, weight, turn) values ('5', 'Alice', '250', '1')
insert into Queue (person_id, person_name, weight, turn) values ('4', 'Bob', '175', '5')
insert into Queue (person_id, person_name, weight, turn) values ('3', 'Alex', '350', '2')
insert into Queue (person_id, person_name, weight, turn) values ('6', 'John Cena', '400', '3')
insert into Queue (person_id, person_name, weight, turn) values ('1', 'Winston', '500', '6')
insert into Queue (person_id, person_name, weight, turn) values ('2', 'Marie', '200', '4')
go

use test_db
go
with person_running_weight as (
	select *, sum(weight) over(order by turn rows unbounded preceding) as running_weight
	from dbo.Queue
)
select top 1 person_name
from person_running_weight
where running_weight<=1000
order by turn desc

use test_db
go
drop table dbo.Queue


--leetcode 1211. Queries Quality and Percentage

use test_db
go
Create table Queries (query_name varchar(30), result varchar(50), position int, rating int)
go
insert into Queries (query_name, result, position, rating) values ('Dog', 'Golden Retriever', '1', '5')
insert into Queries (query_name, result, position, rating) values ('Dog', 'German Shepherd', '2', '5')
insert into Queries (query_name, result, position, rating) values ('Dog', 'Mule', '200', '1')
insert into Queries (query_name, result, position, rating) values ('Cat', 'Shirazi', '5', '2')
insert into Queries (query_name, result, position, rating) values ('Cat', 'Siamese', '3', '3')
insert into Queries (query_name, result, position, rating) values (null, 'Sphynx', '7', '4')
go

use test_db
go
select 
	query_name, 
	round(sum(cast(rating as float)/position)/count(*),2) as quality,
	round(cast(sum(case when rating<3 then 1 else 0 end) as float)/count(*)*100,2) as poor_query_percentage
from dbo.Queries
where query_name is not null
group by query_name

use test_db
go
drop table dbo.Queries


--leetcode 1251. Average Selling Price

use test_db
go
Create table Prices (product_id int, start_date date, end_date date, price int)
Create table UnitsSold (product_id int, purchase_date date, units int)
go
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-02-17', '2019-02-28', '5')
insert into Prices (product_id, start_date, end_date, price) values ('1', '2019-03-01', '2019-03-22', '20')
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-01', '2019-02-20', '15')
insert into Prices (product_id, start_date, end_date, price) values ('2', '2019-02-21', '2019-03-31', '30')
insert into Prices (product_id, start_date, end_date, price) values ('3', '2019-02-21', '2019-03-31', '30')
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-02-25', '100')
insert into UnitsSold (product_id, purchase_date, units) values ('1', '2019-03-01', '15')
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-02-10', '200')
insert into UnitsSold (product_id, purchase_date, units) values ('2', '2019-03-22', '30')
go

use test_db
go
select 
	p.product_id, 
	round(coalesce(sum(p.price*u.units)/sum(cast(u.units as float)),0),2) as average_price
from dbo.Prices p 
	left join UnitsSold u on p.product_id=u.product_id and u.purchase_date>=p.start_date and u.purchase_date<=p.end_date
group by p.product_id

use test_db
go
drop table dbo.Prices, dbo.UnitsSold


--leetcode 1280. Students and Examinations

use test_db
go
Create table Students (student_id int, student_name varchar(20))
Create table Subjects (subject_name varchar(20))
Create table Examinations (student_id int, subject_name varchar(20))
go
insert into Students (student_id, student_name) values ('1', 'Alice')
insert into Students (student_id, student_name) values ('2', 'Bob')
insert into Students (student_id, student_name) values ('13', 'John')
insert into Students (student_id, student_name) values ('6', 'Alex')
insert into Subjects (subject_name) values ('Math')
insert into Subjects (subject_name) values ('Physics')
insert into Subjects (subject_name) values ('Programming')
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Programming')
insert into Examinations (student_id, subject_name) values ('2', 'Programming')
insert into Examinations (student_id, subject_name) values ('1', 'Physics')
insert into Examinations (student_id, subject_name) values ('1', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Math')
insert into Examinations (student_id, subject_name) values ('13', 'Programming')
insert into Examinations (student_id, subject_name) values ('13', 'Physics')
insert into Examinations (student_id, subject_name) values ('2', 'Math')
insert into Examinations (student_id, subject_name) values ('1', 'Math')

use test_db
go
select 
	st.student_id, 
	st.student_name, 
	sub.subject_name, 
	count(ex.subject_name) as attended_exams
from dbo.Students st 
	cross join dbo.Subjects sub 
	left join dbo.Examinations ex on st.student_id=ex.student_id and sub.subject_name=ex.subject_name
group by st.student_id, st.student_name, sub.subject_name
order by st.student_id, sub.subject_name

use test_db
go
drop table dbo.Students, dbo.Subjects, dbo.Examinations


--leetcode 1321. Restaurant Growth

use test_db
go
Create table Customer (customer_id int, name varchar(20), visited_on date, amount int)
go
insert into Customer (customer_id, name, visited_on, amount) values ('1', 'Jhon', '2019-01-01', '100')
insert into Customer (customer_id, name, visited_on, amount) values ('2', 'Daniel', '2019-01-02', '110')
insert into Customer (customer_id, name, visited_on, amount) values ('3', 'Jade', '2019-01-03', '120')
insert into Customer (customer_id, name, visited_on, amount) values ('4', 'Khaled', '2019-01-04', '130')
insert into Customer (customer_id, name, visited_on, amount) values ('5', 'Winston', '2019-01-05', '110')
insert into Customer (customer_id, name, visited_on, amount) values ('6', 'Elvis', '2019-01-06', '140')
insert into Customer (customer_id, name, visited_on, amount) values ('7', 'Anna', '2019-01-07', '150')
insert into Customer (customer_id, name, visited_on, amount) values ('8', 'Maria', '2019-01-08', '80')
insert into Customer (customer_id, name, visited_on, amount) values ('9', 'Jaze', '2019-01-09', '110')
insert into Customer (customer_id, name, visited_on, amount) values ('1', 'Jhon', '2019-01-10', '130')
insert into Customer (customer_id, name, visited_on, amount) values ('3', 'Jade', '2019-01-10', '150')
go

use test_db
go
with daily_amount as (
	select visited_on, sum(amount) as amount
	from dbo.Customer
	group by visited_on
),
rolling_values as (
	select 
		visited_on, 
		sum(amount) over(order by visited_on rows between 6 preceding and current row) as amount, 
		case
			when datediff(day,(select min(visited_on) from daily_amount),visited_on)>=6
			then round(avg(cast(amount as float)) over(order by visited_on rows between 6 preceding and current row),2)
			else null
		end as average_amount
	from daily_amount
)
select *
from rolling_values
where average_amount is not null
order by visited_on


--leetcode 1327. List the Products Ordered in a Period

use test_db
go
Create table Products (product_id int, product_name varchar(40), product_category varchar(40))
Create table Orders (product_id int, order_date date, unit int)
go
insert into Products (product_id, product_name, product_category) values ('1', 'Leetcode Solutions', 'Book')
insert into Products (product_id, product_name, product_category) values ('2', 'Jewels of Stringology', 'Book')
insert into Products (product_id, product_name, product_category) values ('3', 'HP', 'Laptop')
insert into Products (product_id, product_name, product_category) values ('4', 'Lenovo', 'Laptop')
insert into Products (product_id, product_name, product_category) values ('5', 'Leetcode Kit', 'T-shirt')
insert into Orders (product_id, order_date, unit) values ('1', '2020-02-05', '60')
insert into Orders (product_id, order_date, unit) values ('1', '2020-02-10', '70')
insert into Orders (product_id, order_date, unit) values ('2', '2020-01-18', '30')
insert into Orders (product_id, order_date, unit) values ('2', '2020-02-11', '80')
insert into Orders (product_id, order_date, unit) values ('3', '2020-02-17', '2')
insert into Orders (product_id, order_date, unit) values ('3', '2020-02-24', '3')
insert into Orders (product_id, order_date, unit) values ('4', '2020-03-01', '20')
insert into Orders (product_id, order_date, unit) values ('4', '2020-03-04', '30')
insert into Orders (product_id, order_date, unit) values ('4', '2020-03-04', '60')
insert into Orders (product_id, order_date, unit) values ('5', '2020-02-25', '50')
insert into Orders (product_id, order_date, unit) values ('5', '2020-02-27', '50')
insert into Orders (product_id, order_date, unit) values ('5', '2020-03-01', '50')
go

use test_db
go
select p.product_name, sum(unit) as unit
from dbo.Products p left join dbo.Orders o on p.product_id=o.product_id
where format(o.order_date, 'yyyyMM')='202002'
group by p.product_name
having sum(unit)>=100


--leetcode 1341. Movie Rating

use test_db
go
Create table Movies (movie_id int, title varchar(30))
Create table Users (user_id int, name varchar(30))
Create table MovieRating (movie_id int, user_id int, rating int, created_at date)
go
insert into Movies (movie_id, title) values ('1', 'Avengers')
insert into Movies (movie_id, title) values ('2', 'Frozen 2')
insert into Movies (movie_id, title) values ('3', 'Joker')
insert into Users (user_id, name) values ('1', 'Daniel')
insert into Users (user_id, name) values ('2', 'Monica')
insert into Users (user_id, name) values ('3', 'Maria')
insert into Users (user_id, name) values ('4', 'James')
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '1', '3', '2020-01-12')
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '2', '4', '2020-02-11')
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '3', '2', '2020-02-12')
insert into MovieRating (movie_id, user_id, rating, created_at) values ('1', '4', '1', '2020-01-01')
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '1', '5', '2020-02-17')
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '2', '2', '2020-02-01')
insert into MovieRating (movie_id, user_id, rating, created_at) values ('2', '3', '2', '2020-03-01')
insert into MovieRating (movie_id, user_id, rating, created_at) values ('3', '1', '3', '2020-02-22')
insert into MovieRating (movie_id, user_id, rating, created_at) values ('3', '2', '4', '2020-02-25')

use test_db
go
with ratings as (
select m.title, u.name, mv.rating, mv.created_at
from dbo.MovieRating mv 
	join dbo.Movies m on mv.movie_id=m.movie_id 
	join dbo.Users u on mv.user_id=u.user_id
),
top_user as (
	select top 1 name as results
	from ratings
	group by name
	order by count(*) desc, name asc
),
top_movie as (
	select top 1 title as results
	from ratings
	where format(created_at, 'yyyyMM')='202002'
	group by title
	order by avg(cast(rating as float)) desc, title asc
)
select *
from top_user
union all
select *
from top_movie


--leetcode 1378. Replace Employee ID With The Unique Identifier

use test_db
go
Create table Employees (id int, name varchar(20))
Create table EmployeeUNI (id int, unique_id int)
go
insert into Employees (id, name) values ('1', 'Alice')
insert into Employees (id, name) values ('7', 'Bob')
insert into Employees (id, name) values ('11', 'Meir')
insert into Employees (id, name) values ('90', 'Winston')
insert into Employees (id, name) values ('3', 'Jonathan')
insert into EmployeeUNI (id, unique_id) values ('3', '1')
insert into EmployeeUNI (id, unique_id) values ('11', '2')
insert into EmployeeUNI (id, unique_id) values ('90', '3')
go

use test_db
go
select eu.unique_id, e.name
from Employees e left join EmployeeUNI eu on e.id=eu.id


--leetcode 1393. Capital Gain/Loss

use test_db
go
Create Table Stocks (stock_name varchar(15), operation nchar(4), operation_day int, price int)
go
insert into Stocks (stock_name, operation, operation_day, price) values ('Leetcode', 'Buy', '1', '1000')
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Buy', '2', '10')
insert into Stocks (stock_name, operation, operation_day, price) values ('Leetcode', 'Sell', '5', '9000')
insert into Stocks (stock_name, operation, operation_day, price) values ('Handbags', 'Buy', '17', '30000')
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Sell', '3', '1010')
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Buy', '4', '1000')
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Sell', '5', '500')
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Buy', '6', '1000')
insert into Stocks (stock_name, operation, operation_day, price) values ('Handbags', 'Sell', '29', '7000')
insert into Stocks (stock_name, operation, operation_day, price) values ('Corona Masks', 'Sell', '10', '10000')
go

use test_db
go
with stock as (
	select stock_name, operation, operation_day,
		case
			when operation='Buy' then price*(-1)
			else price
		end as price
	from Stocks
)
select stock_name, sum(price) as capital_gain_loss
from stock
group by stock_name


--leetcode 1407. Top Travellers

use test_db
go
Create Table Users (id int, name varchar(30))
Create Table Rides (id int, user_id int, distance int)
go
insert into Users (id, name) values ('1', 'Alice')
insert into Users (id, name) values ('2', 'Bob')
insert into Users (id, name) values ('3', 'Alex')
insert into Users (id, name) values ('4', 'Donald')
insert into Users (id, name) values ('7', 'Lee')
insert into Users (id, name) values ('13', 'Jonathan')
insert into Users (id, name) values ('19', 'Elvis')
insert into Rides (id, user_id, distance) values ('1', '1', '120')
insert into Rides (id, user_id, distance) values ('2', '2', '317')
insert into Rides (id, user_id, distance) values ('3', '3', '222')
insert into Rides (id, user_id, distance) values ('4', '7', '100')
insert into Rides (id, user_id, distance) values ('5', '13', '312')
insert into Rides (id, user_id, distance) values ('6', '19', '50')
insert into Rides (id, user_id, distance) values ('7', '7', '120')
insert into Rides (id, user_id, distance) values ('8', '19', '400')
insert into Rides (id, user_id, distance) values ('9', '7', '230')
go

use test_db
go
select u.[name], coalesce(sum(r.distance),0) as travelled_distance
from Users u left join Rides r on u.id=r.[user_id]
group by u.id, u.[name]
order by travelled_distance desc, u.[name]


--leetcode 1484. Group Sold Products By The Date

use test_db
go
Create table Activities (sell_date date, product varchar(20))
go
insert into Activities (sell_date, product) values ('2020-05-30', 'Headphone')
insert into Activities (sell_date, product) values ('2020-06-01', 'Pencil')
insert into Activities (sell_date, product) values ('2020-06-02', 'Mask')
insert into Activities (sell_date, product) values ('2020-05-30', 'Basketball')
insert into Activities (sell_date, product) values ('2020-06-01', 'Bible')
insert into Activities (sell_date, product) values ('2020-06-02', 'Mask')
insert into Activities (sell_date, product) values ('2020-05-30', 'T-Shirt')
go

use test_db
go
select sell_date, count(*) as num_sold, 
	string_agg(product, ',') within group (order by product) as products
from (
	select distinct sell_date, product 
	from Activities
	) as distinct_Activities
group by sell_date
order by sell_date


--leetcode 1517. Find Users With Valid E-Mails (not solved)

use test_db
go
Create table Users (user_id int, name varchar(30), mail varchar(50))
go
insert into Users (user_id, name, mail) values ('1', 'Winston', 'winston@leetcode.com')
insert into Users (user_id, name, mail) values ('2', 'Jonathan', 'jonathanisgreat')
insert into Users (user_id, name, mail) values ('3', 'Annabelle', 'bella-@leetcode.com')
insert into Users (user_id, name, mail) values ('4', 'Sally', 'sally.come@leetcode.com')
insert into Users (user_id, name, mail) values ('5', 'Marwan', 'quarz#2020@leetcode.com')
insert into Users (user_id, name, mail) values ('6', 'David', 'david69@gmail.com')
insert into Users (user_id, name, mail) values ('7', 'Shapiro', '.shapo@leetcode.com')
go

use test_db
go
select *
from Users
where right(mail, 13)='@leetcode.com' 
	and mail like '[A-Z]%' 
	and left(mail, len(mail)-13) like '%[aA-zZ]%' 
	and left(mail, len(mail)-13) not like '%#%'


-- leetcode 1527. Patients With a Condition

use test_db
go
Create table Patients (patient_id int, patient_name varchar(30), conditions varchar(100))
go
insert into Patients (patient_id, patient_name, conditions) values ('1', 'Daniel', 'YFEV COUGH')
insert into Patients (patient_id, patient_name, conditions) values ('2', 'Alice', '')
insert into Patients (patient_id, patient_name, conditions) values ('3', 'Bob', 'DIAB100 MYOP')
insert into Patients (patient_id, patient_name, conditions) values ('4', 'George', 'ACNE DIAB100')
insert into Patients (patient_id, patient_name, conditions) values ('5', 'Alain', 'DIAB201')
go

use test_db
go
select *
from Patients
where conditions like 'DIAB1%' 
    or conditions like '% DIAB1%'


-- leetcode 1581. Customer Who Visited but Did Not Make Any Transactions

use test_db
go
Create table Visits(visit_id int, customer_id int)
Create table Transactions(transaction_id int, visit_id int, amount int)
go
insert into Visits (visit_id, customer_id) values ('1', '23')
insert into Visits (visit_id, customer_id) values ('2', '9')
insert into Visits (visit_id, customer_id) values ('4', '30')
insert into Visits (visit_id, customer_id) values ('5', '54')
insert into Visits (visit_id, customer_id) values ('6', '96')
insert into Visits (visit_id, customer_id) values ('7', '54')
insert into Visits (visit_id, customer_id) values ('8', '54')
insert into Transactions (transaction_id, visit_id, amount) values ('2', '5', '310')
insert into Transactions (transaction_id, visit_id, amount) values ('3', '5', '300')
insert into Transactions (transaction_id, visit_id, amount) values ('9', '5', '200')
insert into Transactions (transaction_id, visit_id, amount) values ('12', '1', '910')
insert into Transactions (transaction_id, visit_id, amount) values ('13', '2', '970')
go

use test_db
go
select v.customer_id, count(v.visit_id) as count_no_trans
from visits v 
	left join transactions t on v.visit_id=t.visit_id
where t.transaction_id is null
group by v.customer_id


-- leetcode 1587. Bank Account Summary II

use test_db
go
Create table Users (account int, name varchar(20))
Create table Transactions (trans_id int, account int, amount int, transacted_on date)
go
insert into Users (account, name) values ('900001', 'Alice')
insert into Users (account, name) values ('900002', 'Bob')
insert into Users (account, name) values ('900003', 'Charlie')
insert into Transactions (trans_id, account, amount, transacted_on) values ('1', '900001', '7000', '2020-08-01')
insert into Transactions (trans_id, account, amount, transacted_on) values ('2', '900001', '7000', '2020-09-01')
insert into Transactions (trans_id, account, amount, transacted_on) values ('3', '900001', '-3000', '2020-09-02')
insert into Transactions (trans_id, account, amount, transacted_on) values ('4', '900002', '1000', '2020-09-12')
insert into Transactions (trans_id, account, amount, transacted_on) values ('5', '900003', '6000', '2020-08-07')
insert into Transactions (trans_id, account, amount, transacted_on) values ('6', '900003', '6000', '2020-09-07')
insert into Transactions (trans_id, account, amount, transacted_on) values ('7', '900003', '-4000', '2020-09-11')
go

use test_db
go
select u.name, sum(t.amount) as balance
from Users u
	left join Transactions t on u.account=t.account
group by u.name
having sum(t.amount)>10000


-- leetcode 1633. Percentage of Users Attended a Contest

use test_db
go
Create table Users (user_id int, user_name varchar(20))
Create table Register (contest_id int, user_id int)
go
insert into Users (user_id, user_name) values ('6', 'Alice')
insert into Users (user_id, user_name) values ('2', 'Bob')
insert into Users (user_id, user_name) values ('7', 'Alex')
insert into Register (contest_id, user_id) values ('215', '6')
insert into Register (contest_id, user_id) values ('209', '2')
insert into Register (contest_id, user_id) values ('208', '2')
insert into Register (contest_id, user_id) values ('210', '6')
insert into Register (contest_id, user_id) values ('208', '6')
insert into Register (contest_id, user_id) values ('209', '7')
insert into Register (contest_id, user_id) values ('209', '6')
insert into Register (contest_id, user_id) values ('215', '7')
insert into Register (contest_id, user_id) values ('208', '7')
insert into Register (contest_id, user_id) values ('210', '2')
insert into Register (contest_id, user_id) values ('207', '2')
insert into Register (contest_id, user_id) values ('210', '7')
go

use test_db
go
with total_users as (
	select count(distinct [user_id]) as amt
	from Users
),
contest_users as (
	select contest_id, count([user_id]) as tot_users
	from Register
	group by contest_id
)
select contest_id, round(tot_users/cast(amt as float)*100,2) as [percentage]
from contest_users, total_users
order by [percentage] desc, contest_id


-- leetcode 1661. Average Time of Process per Machine

use test_db
go
Create table Activity (machine_id int, process_id int, activity_type nchar(5), timestamp float)
go
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('0', '0', 'start', '0.712')
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('0', '0', 'end', '1.52')
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('0', '1', 'start', '3.14')
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('0', '1', 'end', '4.12')
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('1', '0', 'start', '0.55')
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('1', '0', 'end', '1.55')
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('1', '1', 'start', '0.43')
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('1', '1', 'end', '1.42')
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('2', '0', 'start', '4.1')
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('2', '0', 'end', '4.512')
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('2', '1', 'start', '2.5')
insert into Activity (machine_id, process_id, activity_type, timestamp) values ('2', '1', 'end', '5')
go

use test_db
go
with timestamp_pvt as (
	select machine_id, process_id, [start], [end]
	from (
		select machine_id, process_id, activity_type, [timestamp]
		from Activity
	) as source_tbl
	pivot (
		sum([timestamp]) for activity_type in ([start], [end])
	) as pvt_tbl
)
select machine_id, round(sum([end]-[start])/count(distinct process_id),3) as processing_time
from timestamp_pvt
group by machine_id 


-- leetcode 1667. Fix Names in a Table

use test_db
go
Create table Users (user_id int, name varchar(40))
go
insert into Users (user_id, name) values ('1', 'aLice')
insert into Users (user_id, name) values ('2', 'bOB')
go

use test_db
go
select [user_id], UPPER(LEFT([name], 1)) + LOWER(SUBSTRING([name], 2, LEN([name]))) as [name]
from Users
order by [user_id]


-- leetcode 1683. Invalid Tweets

use test_db
go
Create table Tweets(tweet_id int, content varchar(50))
go
insert into Tweets (tweet_id, content) values ('1', 'Let us Code')
insert into Tweets (tweet_id, content) values ('2', 'More than fifteen chars are here!')
go

use test_db
go
select tweet_id
from Tweets
where LEN(content) > 15


-- leetcode 1693. Daily Leads and Partners

use test_db
go
Create table DailySales(date_id date, make_name varchar(20), lead_id int, partner_id int)
go
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'toyota', '0', '1')
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'toyota', '1', '0')
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'toyota', '1', '2')
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'toyota', '0', '2')
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'toyota', '0', '1')
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'honda', '1', '2')
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-8', 'honda', '2', '1')
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'honda', '0', '1')
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'honda', '1', '2')
insert into DailySales (date_id, make_name, lead_id, partner_id) values ('2020-12-7', 'honda', '2', '1')
go

use test_db
go
select date_id, make_name, COUNT(DISTINCT lead_id) as unique_leads, COUNT(DISTINCT partner_id) as unique_partners
from DailySales
group by date_id, make_name


-- leetcode 1729. Find Followers Count

use test_db
go
Create table Followers(user_id int, follower_id int)
go
insert into Followers (user_id, follower_id) values ('0', '1')
insert into Followers (user_id, follower_id) values ('1', '0')
insert into Followers (user_id, follower_id) values ('2', '0')
insert into Followers (user_id, follower_id) values ('2', '1')
go

use test_db
go
select user_id, COUNT(follower_id) as followers_count
from Followers
group by user_id
order by user_id


-- leetcode 1731. The Number of Employees Which Report to Each Employee

use test_db
go
Create table Employees(employee_id int, name varchar(20), reports_to int, age int)
go
insert into Employees (employee_id, name, reports_to, age) values ('9', 'Hercy', NULL, '43')
insert into Employees (employee_id, name, reports_to, age) values ('6', 'Alice', '9', '41')
insert into Employees (employee_id, name, reports_to, age) values ('4', 'Bob', '9', '36')
insert into Employees (employee_id, name, reports_to, age) values ('2', 'Winston', NULL, '37')
go

use test_db
go
select m.employee_id, m.name, COUNT(e.employee_id) as reports_count, ROUND(AVG(CAST(e.age AS FLOAT)),0) as average_age
from Employees m
	join Employees e on m.employee_id=e.reports_to
group by m.employee_id, m.name
order by m.employee_id


-- leetcode 1741. Find Total Time Spent by Each Employee

use test_db
go
Create table Employees(emp_id int, event_day date, in_time int, out_time int)
go
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-11-28', '4', '32')
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-11-28', '55', '200')
insert into Employees (emp_id, event_day, in_time, out_time) values ('1', '2020-12-3', '1', '42')
insert into Employees (emp_id, event_day, in_time, out_time) values ('2', '2020-11-28', '3', '33')
insert into Employees (emp_id, event_day, in_time, out_time) values ('2', '2020-12-9', '47', '74')
go

use test_db
go
select event_day as day, emp_id, SUM(out_time - in_time) as total_time
from Employees
group by event_day, emp_id


-- leetcode 1757. Recyclable and Low Fat Products

use test_db
go
Create table Products (product_id int, low_fats nchar(1), recyclable nchar(1))
go
insert into Products (product_id, low_fats, recyclable) values ('0', 'Y', 'N')
insert into Products (product_id, low_fats, recyclable) values ('1', 'Y', 'Y')
insert into Products (product_id, low_fats, recyclable) values ('2', 'N', 'Y')
insert into Products (product_id, low_fats, recyclable) values ('3', 'Y', 'Y')
insert into Products (product_id, low_fats, recyclable) values ('4', 'N', 'N')
go

use test_db
go
select product_id
from Products
where low_fats = 'Y'
	and recyclable = 'Y'


-- leetcode 1789. Primary Department for Each Employee

use test_db
go
Create table Employee (employee_id int, department_id int, primary_flag nchar(1))
go
insert into Employee (employee_id, department_id, primary_flag) values ('1', '1', 'N')
insert into Employee (employee_id, department_id, primary_flag) values ('2', '1', 'Y')
insert into Employee (employee_id, department_id, primary_flag) values ('2', '2', 'N')
insert into Employee (employee_id, department_id, primary_flag) values ('3', '3', 'N')
insert into Employee (employee_id, department_id, primary_flag) values ('4', '2', 'N')
insert into Employee (employee_id, department_id, primary_flag) values ('4', '3', 'Y')
insert into Employee (employee_id, department_id, primary_flag) values ('4', '4', 'N')
go

use test_db
go
with employee_row_amt as (
	select employee_id, count(employee_id) as row_amt
	from Employee
	group by employee_id
)
select e.employee_id, department_id
from Employee e 
	join employee_row_amt r on e.employee_id = r.employee_id
where primary_flag = 'Y'
	or row_amt = 1


-- leetcode 1795. Rearrange Products Table

use test_db
go
Create table Products (product_id int, store1 int, store2 int, store3 int)
go
insert into Products (product_id, store1, store2, store3) values ('0', '95', '100', '105')
insert into Products (product_id, store1, store2, store3) values ('1', '70', NULL, '80')
go

use test_db
go
select product_id, store, price
from (
	select product_id, store1, store2, store3
	from Products
) p
unpivot
(
	price for store in (store1, store2, store3)
) as unpvt


-- leetcode 1873. Calculate Special Bonus

use test_db
go
Create table Employees (employee_id int, name varchar(30), salary int)
go
insert into Employees (employee_id, name, salary) values ('2', 'Meir', '3000')
insert into Employees (employee_id, name, salary) values ('3', 'Michael', '3800')
insert into Employees (employee_id, name, salary) values ('7', 'Addilyn', '7400')
insert into Employees (employee_id, name, salary) values ('8', 'Juan', '6100')
insert into Employees (employee_id, name, salary) values ('9', 'Kannon', '7700')
go

select employee_id,
	case
		when employee_id % 2 != 0 and name not like 'M%' then salary
		else 0
	end as bonus
from Employees
order by employee_id


-- leetcode 1890. The Latest Login in 2020

use test_db
go
Create table Logins (user_id int, time_stamp datetime)
go
insert into Logins (user_id, time_stamp) values ('6', '2020-06-30 15:06:07')
insert into Logins (user_id, time_stamp) values ('6', '2021-04-21 14:06:06')
insert into Logins (user_id, time_stamp) values ('6', '2019-03-07 00:18:15')
insert into Logins (user_id, time_stamp) values ('8', '2020-02-01 05:10:53')
insert into Logins (user_id, time_stamp) values ('8', '2020-12-30 00:46:50')
insert into Logins (user_id, time_stamp) values ('2', '2020-01-16 02:49:50')
insert into Logins (user_id, time_stamp) values ('2', '2019-08-25 07:59:08')
insert into Logins (user_id, time_stamp) values ('14', '2019-07-14 09:00:00')
insert into Logins (user_id, time_stamp) values ('14', '2021-01-06 11:59:59')
go

use test_db
go
select user_id, max(time_stamp) as last_stamp
from Logins
where year(time_stamp) = 2020
group by user_id