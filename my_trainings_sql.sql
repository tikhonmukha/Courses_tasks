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