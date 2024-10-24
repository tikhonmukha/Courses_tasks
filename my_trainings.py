## codewars 7 kyu Credit Card Mask

def maskify(cc):
    if len(cc)>=4:
        cc = cc.replace(cc[0:len(cc)-4], '#'*(len(cc)-4))
    return cc


## codewars 6 kyu Sum of Digits / Digital Root

def digital_root(n):
    x = str(n)
    y = n
    while len(x)>1:
        y=0
        for i in range(len(x)):
            y+=int(x[i])
        x=str(y)
    return y

digital_root(12343)


## codewars 7 kyu Shortest Word

my_words = min([len(i) for i in input().split()])
def find_short(s):
    l = min([len(i) for i in s.split()])
    return l # l: shortest word length


## codewars 6 kyu Stop gninnipS My sdroW!

def spin_words(sentence):
    sentence = list(map(lambda x: x[::-1] if len(x)>=5 else x, sentence.split()))
    res = ''
    for i in sentence:
        res+=i+' '
    return res[:-1]

spin_words('Hey fellow warriors')


## codewars 6 kyu Find the odd int

def find_it(seq):
    seq_str = [str(i) for i in seq]
    seq_dct = {int(i): seq_str.count(i) for i in seq_str}
    my_key = ''
    for key, value in seq_dct.items():
        if value % 2 != 0:
            my_key = key
    return my_key

find_it([1,2,2,3,3,3,4,3,3,3,2,2,1])


## codewars 7 kyu Sum of two lowest positive integers

def sum_two_smallest_numbers(numbers):
    numbers.sort()
    return sum(numbers[0:2])

sum_two_smallest_numbers([19, 5, 42, 2, 77])


## codewars 6 kyu Persistent Bugger.

def persistence(n):
    x = str(n)
    y = n
    cnt = 0
    while len(x)>1:
        y=1
        for i in range(len(x)):
            y*=int(x[i])
        x=str(y)
        cnt += 1
    return cnt

persistence(999)


## codewars 7 kyu Number of People in the Bus

def number(bus_stops):
    return sum([i[0]-i[1] for i in bus_stops])

number([[3,0],[9,1],[4,10],[12,2],[6,1],[7,10]])


## codewars 6 kyu Break camelCase

s = "camelCasing"

def solution(s):
    s = list(map(lambda x: ' '+x if x.isupper()==True else x, s))
    res = ''
    for i in s:
        res+=i
    return(res)

solution(s)


## leetcode 175. Combine Two Tables

import pandas as pd

Person = pd.DataFrame([[1, 'Wang', 'Allen'],[2,'Alice','Bob']], columns=['personId','lastName','firstName'])
Address = pd.DataFrame([[1, 2, 'New York City', 'New York'],[2,3,'Leetcode','California']], columns=['addressId','personId','city','state'])
Person.merge(Address, on='personId', how='left')[['firstName', 'lastName', 'city', 'state']]


## leetcode 2678. Number of Senior Citizens

details = ["7868190130M7522","5303914400F9211","9273338290F4010"]

def countSeniors(details):
    return len(list(filter(lambda x: x if int(x[11:13])>60 else None, details)))

countSeniors(details)


## leetcode 178. Rank Scores

import pandas as pd

data = [[1, 3.5], [2, 3.65], [3, 4.0], [4, 3.85], [5, 4.0], [6, 3.65]]
scores = pd.DataFrame(data, columns=['id', 'score']).astype({'id':'Int64', 'score':'Float64'})

def order_scores(scores: pd.DataFrame) -> pd.DataFrame:
    scores['rank'] = scores.score.rank(method='dense',ascending=False)
    return scores[['score','rank']].sort_values(by='score', ascending=False)

order_scores(scores)


## leetcode 181. Employees Earning More Than Their Managers

import pandas as pd

data = [[1, 'Joe', 70000, 3], [2, 'Henry', 80000, 4], [3, 'Sam', 60000, None], [4, 'Max', 90000, None]]
employee = pd.DataFrame(data, columns=['id', 'name', 'salary', 'managerId']).astype({'id':'Int64', 'name':'object', 'salary':'Int64', 'managerId':'Int64'})

def find_employees(employee: pd.DataFrame) -> pd.DataFrame:
    return pd.DataFrame({'Employee':employee.merge(employee, left_on='id', right_on='managerId').query('salary_y>salary_x').name_y})

find_employees(employee)


## leetcode 185. Department Top Three Salaries

import pandas as pd

data = [[1, 'Joe', 85000, 1], [2, 'Henry', 80000, 2], [3, 'Sam', 60000, 2], [4, 'Max', 90000, 1], [5, 'Janet', 69000, 1], [6, 'Randy', 85000, 1], [7, 'Will', 70000, 1]]
employee = pd.DataFrame(data, columns=['id', 'name', 'salary', 'departmentId']).astype({'id':'Int64', 'name':'object', 'salary':'Int64', 'departmentId':'Int64'})
data = [[1, 'IT'], [2, 'Sales']]
department = pd.DataFrame(data, columns=['id', 'name']).astype({'id':'Int64', 'name':'object'})

def top_three_salaries(employee: pd.DataFrame, department: pd.DataFrame) -> pd.DataFrame:
    emp_dep = employee.merge(department, left_on='departmentId', right_on='id')
    emp_dep['rank'] = emp_dep.groupby('name_y', as_index=False).salary.rank(method='dense',ascending=False)
    return emp_dep.query('rank<=3').rename(columns={'name_y':'Department','name_x':'Employee','salary':'Salary'})[['Department','Employee','Salary']]

top_three_salaries(employee, department)


## leetcode 550. Game Play Analysis IV

import pandas as pd

data = [[1, 2, '2016-03-01', 5], [1, 2, '2016-03-02', 6], [2, 3, '2017-06-25', 1], [3, 1, '2016-03-02', 0], [3, 4, '2018-07-03', 5]]
activity = pd.DataFrame(data, columns=['player_id', 'device_id', 'event_date', 'games_played']).astype({'player_id':'Int64', 'device_id':'Int64', 'event_date':'datetime64[ns]', 'games_played':'Int64'})

def gameplay_analysis(activity: pd.DataFrame) -> pd.DataFrame:
    tot_players = activity.player_id.nunique()
    returned_players = activity.query('games_played>0').groupby('player_id', as_index=False).agg({'games_played':'count'}).query('games_played>1').player_id.nunique()
    fraction = round(returned_players/tot_players, 2)
    return pd.DataFrame({'fraction':[fraction]})

gameplay_analysis(activity)


## leetcode 1148. Article Views I

import pandas as pd

data = [[1, 3, 5, '2019-08-01'], [1, 3, 6, '2019-08-02'], [2, 7, 7, '2019-08-01'], [2, 7, 6, '2019-08-02'], [4, 7, 1, '2019-07-22'], [3, 4, 4, '2019-07-21'], [3, 4, 4, '2019-07-21']]
views = pd.DataFrame(data, columns=['article_id', 'author_id', 'viewer_id', 'view_date']).astype({'article_id':'Int64', 'author_id':'Int64', 'viewer_id':'Int64', 'view_date':'datetime64[ns]'})

def article_views(views: pd.DataFrame) -> pd.DataFrame:
    return pd.DataFrame({'id':views.query('author_id==viewer_id')['author_id'].drop_duplicates().sort_values()})

article_views(views)


## leetcode 177. Nth Highest Salary

import pandas as pd

data = [[1, 100], [2, 100]]
employee = pd.DataFrame(data, columns=['id', 'salary']).astype({'id':'Int64', 'salary':'Int64'})

def nth_highest_salary(employee: pd.DataFrame, N: int) -> pd.DataFrame:
    employee['rank'] = employee.salary.rank(method='dense', ascending=False)
    salary = employee.query(f'rank=={N}').salary.drop_duplicates()
    if len(salary)!=0:
        return pd.DataFrame({f'getNthHighestSalary({N})':salary})
    else:
        return pd.DataFrame({f'getNthHighestSalary({N})':[None]})

nth_highest_salary(employee, 4)


# leetcode 184. Department Highest Salary

import pandas as pd

data = [[1, 'Joe', 70000, 1], [2, 'Jim', 90000, 1], [3, 'Henry', 80000, 2], [4, 'Sam', 60000, 2], [5, 'Max', 90000, 1]]
employee = pd.DataFrame(data, columns=['id', 'name', 'salary', 'departmentId']).astype({'id':'Int64', 'name':'object', 'salary':'Int64', 'departmentId':'Int64'})
data = [[1, 'IT'], [2, 'Sales']]
department = pd.DataFrame(data, columns=['id', 'name']).astype({'id':'Int64', 'name':'object'})

def department_highest_salary(employee: pd.DataFrame, department: pd.DataFrame) -> pd.DataFrame:
    emp_dep = employee.merge(department, left_on='departmentId', right_on='id')
    emp_dep['rank'] = emp_dep.groupby('name_y', as_index=False)['salary'].rank(method='dense', ascending=False)
    return emp_dep.query('rank==1')[['name_y','name_x','salary']].rename(columns={'name_y':'Department','name_x':'Employee','salary':'Salary'})

department_highest_salary(employee, department)


# leetcode 570. Managers with at Least 5 Direct Reports

import pandas as pd

data = [[101, 'John', 'A', None], [102, 'Dan', 'A', 101], [103, 'James', 'A', 101], [104, 'Amy', 'A', 101], [105, 'Anne', 'A', 101], [106, 'Ron', 'B', 101], [111, 'John', 'A', None], [112, 'Ron', 'A', 111], [113, 'Ron', 'A', 111], [114, 'Ron', 'A', 111], [115, 'Ron', 'A', 111], [116, 'Ron', 'B', 111]]
employee = pd.DataFrame(data, columns=['id', 'name', 'department', 'managerId']).astype({'id':'Int64', 'name':'object', 'department':'object', 'managerId':'Int64'})
def find_managers(employee: pd.DataFrame) -> pd.DataFrame:
    emp_man = employee.merge(employee, left_on='id', right_on='managerId').groupby(['id_x', 'name_x'], as_index=False)['id_y'].nunique().rename(columns={'name_x':'name','id_y':'cnt'})
    if len(emp_man['id_x'])!=0:
        return pd.DataFrame({'name':emp_man.query('cnt>=5')['name']})
    else:
        return pd.DataFrame({'name':[None]})

find_managers(employee)


## leetcode 602. Friend Requests II: Who Has the Most Friends

import pandas as pd

data = [[1, 2, '2016/06/03'], [1, 3, '2016/06/08'], [2, 3, '2016/06/08'], [3, 4, '2016/06/09']]
request_accepted = pd.DataFrame(data, columns=['requester_id', 'accepter_id', 'accept_date']).astype({'requester_id':'Int64', 'accepter_id':'Int64', 'accept_date':'datetime64[ns]'})

def most_friends(request_accepted: pd.DataFrame) -> pd.DataFrame:
    requesters = request_accepted.groupby('requester_id', as_index=False).agg({'accept_date':'count'}).rename(columns={'requester_id':'id'})
    accepters = request_accepted.groupby('accepter_id', as_index=False).agg({'accept_date':'count'}).rename(columns={'accepter_id':'id'})
    req_and_acc = pd.concat([requesters, accepters]).groupby('id', as_index=False).agg({'accept_date':'sum'}).rename(columns={'accept_date':'num'})
    req_and_acc['rank'] = req_and_acc['num'].rank(ascending=False)
    return req_and_acc.query('rank==1')[['id','num']]

most_friends(request_accepted)


## leetcode 610. Triangle Judgement

import pandas as pd
import numpy as np

data = [[13, 15, 30], [10, 20, 15]]
triangle = pd.DataFrame(data, columns=['x', 'y', 'z']).astype({'x':'Int64', 'y':'Int64', 'z':'Int64'})

def triangle_judgement(triangle: pd.DataFrame) -> pd.DataFrame:
    triangle['triangle'] = np.where((triangle.x+triangle.y>triangle.z) & (triangle.z+triangle.y>triangle.x) & (triangle.x+triangle.z>triangle.y), 'Yes','No')
    return triangle

triangle_judgement(triangle)


## leetcode 619. Biggest Single Number

import pandas as pd

data = [[8], [8], [3], [3], [1], [4], [5], [6]]
my_numbers = pd.DataFrame(data, columns=['num']).astype({'num':'Int64'})
my_numbers.groupby('num').aggregate({'num':'count'}).rename(columns={'num':'amt'}).query('amt==1').sort_index(ascending=False).head(1)


## leetcode 620. Not Boring Movies

import pandas as pd

data = [[1, 'War', 'great 3D', 8.9], [2, 'Science', 'fiction', 8.5], [3, 'irish', 'boring', 6.2], [4, 'Ice song', 'Fantacy', 8.6], [5, 'House card', 'Interesting', 9.1]]
cinema = pd.DataFrame(data, columns=['id', 'movie', 'description', 'rating']).astype({'id':'Int64', 'movie':'object', 'description':'object', 'rating':'Float64'})

def not_boring_movies(cinema: pd.DataFrame) -> pd.DataFrame:
    return cinema.query('id%2!=0 & description!="boring"').sort_values(by='rating',ascending=False)

not_boring_movies(cinema)


## leetcode 626. Exchange Seats

import pandas as pd
import numpy as np

data = [[1, 'Abbot'], [2, 'Doris'], [3, 'Emerson'], [4, 'Green'], [5, 'Jeames']]
seat = pd.DataFrame(data, columns=['id', 'student']).astype({'id':'Int64', 'student':'object'})
max_id=max(seat['id'])
conditions=[
    (seat['id']%2!=0) & (seat['id']!=max_id),
    (seat['id']%2==0),
    (seat['id']==max(seat['id']))
]
values=[seat['id']+1,seat['id']-1,seat['id']]
seat['id']=np.select(conditions,values)

seat.loc[seat['id']%2!=0 & seat['id']!=max_id, 'newid'] = seat['id']+1


## leetcode 1045. Customers Who Bought All Products

import pandas as pd

data = [[1, 5], [2, 6], [3, 5], [3, 6], [1, 6]]
customer = pd.DataFrame(data, columns=['customer_id', 'product_key']).astype({'customer_id':'Int64', 'product_key':'Int64'})
data = [[5], [6]]
product = pd.DataFrame(data, columns=['product_key']).astype({'product_key':'Int64'})

def find_customers(customer: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    unique_products = product.product_key.nunique()
    cust = customer.groupby('customer_id', as_index=False).aggregate({'product_key':'nunique'}).query('product_key==@unique_products').customer_id
    return pd.DataFrame({'customer_id':cust})

find_customers(customer, product)


## leetcode 1050. Actors and Directors Who Cooperated At Least Three Times

import pandas as pd

data = [[1, 1, 0], [1, 1, 1], [1, 1, 2], [1, 2, 3], [1, 2, 4], [2, 1, 5], [2, 1, 6]]
actor_director = pd.DataFrame(data, columns=['actor_id', 'director_id', 'timestamp']).astype({'actor_id':'int64', 'director_id':'int64', 'timestamp':'int64'})

def actors_and_directors(actor_director: pd.DataFrame) -> pd.DataFrame:
    return actor_director.groupby(['actor_id','director_id'], as_index=False)\
        .aggregate({'timestamp':'nunique'})\
            .query('timestamp>=3')[['actor_id','director_id']]

actors_and_directors(actor_director)


## leetcode 1068. Product Sales Analysis I

import pandas as pd

data = [[1, 100, 2008, 10, 5000], [2, 100, 2009, 12, 5000], [7, 200, 2011, 15, 9000]]
sales = pd.DataFrame(data, columns=['sale_id', 'product_id', 'year', 'quantity', 'price']).astype({'sale_id':'Int64', 'product_id':'Int64', 'year':'Int64', 'quantity':'Int64', 'price':'Int64'})
data = [[100, 'Nokia'], [200, 'Apple'], [300, 'Samsung']]
product = pd.DataFrame(data, columns=['product_id', 'product_name']).astype({'product_id':'Int64', 'product_name':'object'})

def sales_analysis(sales: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    return sales.merge(product, how='inner', on='product_id')[['product_name','year','price']]

sales_analysis(sales,product)


## leetcode 1070. Product Sales Analysis III

import pandas as pd

data = [[1, 100, 2008, 10, 5000], [2, 100, 2009, 12, 5000], [7, 200, 2011, 15, 9000]]
sales = pd.DataFrame(data, columns=['sale_id', 'product_id', 'year', 'quantity', 'price']).astype({'sale_id':'Int64', 'product_id':'Int64', 'year':'Int64', 'quantity':'Int64', 'price':'Int64'})
data = [[100, 'Nokia'], [200, 'Apple'], [300, 'Samsung']]
product = pd.DataFrame(data, columns=['product_id', 'product_name']).astype({'product_id':'Int64', 'product_name':'object'})

def sales_analysis(sales: pd.DataFrame, product: pd.DataFrame) -> pd.DataFrame:
    return sales.merge(product, how='inner', on='product_id')[['product_id','year','quantity','price']]\
        .groupby('product_id',as_index=False)\
            .min('year')\
                .rename(columns={'year':'first_year'})

sales_analysis(sales,product)


## leetcode 1075. Project Employees I

import pandas as pd

data = [[1, 1], [1, 2], [1, 3], [2, 1], [2, 4]]
project = pd.DataFrame(data, columns=['project_id', 'employee_id']).astype({'project_id':'Int64', 'employee_id':'Int64'})
data = [[1, 'Khaled', 3], [2, 'Ali', 2], [3, 'John', 1], [4, 'Doe', 2]]
employee = pd.DataFrame(data, columns=['employee_id', 'name', 'experience_years']).astype({'employee_id':'Int64', 'name':'object', 'experience_years':'Int64'})

def project_employees_i(project: pd.DataFrame, employee: pd.DataFrame) -> pd.DataFrame:
    return project.merge(employee, how='left', on='employee_id')\
        .groupby('project_id', as_index=False)\
            .aggregate({'experience_years':'mean'})\
                .round({'experience_years':2})\
                    .rename(columns={'experience_years':'average_years'})

project_employees_i(project, employee)


## leetcode 1084. Sales Analysis III

import pandas as pd

data = [[1, 'S8', 1000], [2, 'G4', 800], [3, 'iPhone', 1400]]
product = pd.DataFrame(data, columns=['product_id', 'product_name', 'unit_price']).astype({'product_id':'Int64', 'product_name':'object', 'unit_price':'Int64'})
data = [[1, 1, 1, '2019-01-21', 2, 2000], [1, 2, 2, '2019-02-17', 1, 800], [2, 2, 3, '2019-06-02', 1, 800], [3, 3, 4, '2019-05-13', 2, 2800]]
sales = pd.DataFrame(data, columns=['seller_id', 'product_id', 'buyer_id', 'sale_date', 'quantity', 'price']).astype({'seller_id':'Int64', 'product_id':'Int64', 'buyer_id':'Int64', 'sale_date':'datetime64[ns]', 'quantity':'Int64', 'price':'Int64'})

def sales_analysis(product: pd.DataFrame, sales: pd.DataFrame) -> pd.DataFrame:
    return sales.merge(product, how='inner', on='product_id')\
        .groupby(['product_id','product_name'], as_index=False).sale_date\
            .agg(minDate='min',maxDate='max').query('minDate>="2019-01-01" & maxDate<="2019-03-31"')[['product_id','product_name']]

sales_analysis(product, sales)


## leetcode 1141. User Activity for the Past 30 Days I

import pandas as pd

data = [[1, 1, '2019-07-20', 'open_session'], [1, 1, '2019-07-20', 'scroll_down'], [1, 1, '2019-07-20', 'end_session'], [2, 4, '2019-07-20', 'open_session'], [2, 4, '2019-07-21', 'send_message'], [2, 4, '2019-07-21', 'end_session'], [3, 2, '2019-07-21', 'open_session'], [3, 2, '2019-07-21', 'send_message'], [3, 2, '2019-07-21', 'end_session'], [4, 3, '2019-06-25', 'open_session'], [4, 3, '2019-06-25', 'end_session']]
activity = pd.DataFrame(data, columns=['user_id', 'session_id', 'activity_date', 'activity_type']).astype({'user_id':'Int64', 'session_id':'Int64', 'activity_date':'datetime64[ns]', 'activity_type':'object'})

def user_activity(activity: pd.DataFrame) -> pd.DataFrame:
    return activity.query('activity_date>="2019-06-28" & activity_date<="2019-07-27"')\
        .groupby('activity_date', as_index=False).user_id.agg(active_users='nunique').rename(columns={'activity_date':'day'})

user_activity(activity)


## leetcode 1148. Article Views I

import pandas as pd

data = [[1, 3, 5, '2019-08-01'], [1, 3, 6, '2019-08-02'], [2, 7, 7, '2019-08-01'], [2, 7, 6, '2019-08-02'], [4, 7, 1, '2019-07-22'], [3, 4, 4, '2019-07-21'], [3, 4, 4, '2019-07-21']]
views = pd.DataFrame(data, columns=['article_id', 'author_id', 'viewer_id', 'view_date']).astype({'article_id':'Int64', 'author_id':'Int64', 'viewer_id':'Int64', 'view_date':'datetime64[ns]'})

def article_views(views: pd.DataFrame) -> pd.DataFrame:
    return pd.DataFrame({'id':views.query('author_id==viewer_id').sort_values(by='author_id').author_id.unique()})

article_views(views)


## leetcode 1158. Market Analysis I

import pandas as pd

data = [[1, '2018-01-01', 'Lenovo'], [2, '2018-02-09', 'Samsung'], [3, '2018-01-19', 'LG'], [4, '2018-05-21', 'HP']]
users = pd.DataFrame(data, columns=['user_id', 'join_date', 'favorite_brand']).astype({'user_id':'Int64', 'join_date':'datetime64[ns]', 'favorite_brand':'object'})
data = [[1, '2019-08-01', 4, 1, 2], [2, '2018-08-02', 2, 1, 3], [3, '2019-08-03', 3, 2, 3], [4, '2018-08-04', 1, 4, 2], [5, '2018-08-04', 1, 3, 4], [6, '2019-08-05', 2, 2, 4]]
orders = pd.DataFrame(data, columns=['order_id', 'order_date', 'item_id', 'buyer_id', 'seller_id']).astype({'order_id':'Int64', 'order_date':'datetime64[ns]', 'item_id':'Int64', 'buyer_id':'Int64', 'seller_id':'Int64'})
data = [[1, 'Samsung'], [2, 'Lenovo'], [3, 'LG'], [4, 'HP']]
items = pd.DataFrame(data, columns=['item_id', 'item_brand']).astype({'item_id':'Int64', 'item_brand':'object'})

def market_analysis(users: pd.DataFrame, orders: pd.DataFrame, items: pd.DataFrame) -> pd.DataFrame:
    merged_data = orders.merge(users, left_on='buyer_id', right_on='user_id', how='right')
    merged_data['year'] = pd.to_datetime(merged_data.order_date).dt.year
    merged_data['orders_in_2019'] = list(map(lambda x: x==2019, merged_data.year))
    return merged_data.groupby(['user_id', 'join_date'], as_index=False).agg({'orders_in_2019':'sum'}).rename(columns={'user_id':'buyer_id'})

market_analysis(users, orders, items)


## leetcode 1164. Product Price at a Given Date

import pandas as pd

data = [[1, 20, '2019-08-14'], [2, 50, '2019-08-14'], [1, 30, '2019-08-15'], [1, 35, '2019-08-16'], [2, 65, '2019-08-17'], [3, 20, '2019-08-18']]
products = pd.DataFrame(data, columns=['product_id', 'new_price', 'change_date']).astype({'product_id':'Int64', 'new_price':'Int64', 'change_date':'datetime64[ns]'})

def price_at_given_date(products: pd.DataFrame) -> pd.DataFrame:
    products_before_date = products.query('change_date<="2019-08-16"').groupby('product_id', as_index=False).agg({'change_date':'max'})
    products_after_date = products.groupby('product_id', as_index=False).agg({'change_date':'min'}).query('change_date>"2019-08-16"')
    products_first_sold = pd.concat([products_before_date,products_after_date])
    products_first_sold = products_first_sold.merge(products, how='inner', on=['product_id','change_date'])
    products_first_sold['true_date'] = products_first_sold.change_date<='2019-08-16'
    products_first_sold['price'] = [products_first_sold['new_price'][i] if products_first_sold['true_date'][i]==True else 10 for i in range(0, len(products_first_sold['true_date']))]
    return products_first_sold[['product_id','price']]

price_at_given_date(products)


## leetcode 1174. Immediate Food Delivery II

import pandas as pd

data = [[1, 1, '2019-08-01', '2019-08-02'], [2, 2, '2019-08-02', '2019-08-02'], [3, 1, '2019-08-11', '2019-08-12'], [4, 3, '2019-08-24', '2019-08-24'], [5, 3, '2019-08-21', '2019-08-22'], [6, 2, '2019-08-11', '2019-08-13'], [7, 4, '2019-08-09', '2019-08-09']]
delivery = pd.DataFrame(data, columns=['delivery_id', 'customer_id', 'order_date', 'customer_pref_delivery_date']).astype({'delivery_id':'Int64', 'customer_id':'Int64', 'order_date':'datetime64[ns]', 'customer_pref_delivery_date':'datetime64[ns]'})

def immediate_food_delivery(delivery: pd.DataFrame) -> pd.DataFrame:
    delivery['order_type'] = ['immediate' if delivery['order_date'][i]==delivery['customer_pref_delivery_date'][i] else 'scheduled' for i in range(0, len(delivery))]
    first_orders = delivery.groupby('customer_id', as_index=False)['order_date'].min()
    first_orders_full = delivery.merge(first_orders, how='inner', on=['customer_id','order_date'])
    return pd.DataFrame({'immediate_percentage':[round(first_orders_full.query('order_type=="immediate"').shape[0] / first_orders_full.shape[0] * 100, 2)]})

immediate_food_delivery(delivery)


## leetcode 1179. Reformat Department Table

import pandas as pd
import numpy as np

data = [[1, 8000, 'Jan'], [2, 9000, 'Jan'], [3, 10000, 'Feb'], [1, 7000, 'Feb'], [1, 6000, 'Mar']]
department = pd.DataFrame(data, columns=['id', 'revenue', 'month']).astype({'id':'Int64', 'revenue':'Int64', 'month':'object'})

data = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']
months = pd.DataFrame(data, columns=['month']).astype({'month':'object'})
dep_mon = months.merge(department['id'].drop_duplicates(), how='cross')
department_allmonths = department.merge(dep_mon, how='right', on=['id','month'])
department_allmonths['month_num'] = np.select([department_allmonths['month']=='Jan', 
                                     department_allmonths['month']=='Feb', 
                                     department_allmonths['month']=='Mar', 
                                     department_allmonths['month']=='Apr', 
                                     department_allmonths['month']=='May', 
                                     department_allmonths['month']=='Jun', 
                                     department_allmonths['month']=='Jul', 
                                     department_allmonths['month']=='Aug', 
                                     department_allmonths['month']=='Sep', 
                                     department_allmonths['month']=='Oct', 
                                     department_allmonths['month']=='Nov', 
                                     department_allmonths['month']=='Dec'], 
                                     [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12])
department_allmonths.pivot_table(index='id', columns='month_num', values='revenue', aggfunc='sum').reset_index()\
    .rename(columns={1:'Jan_Revenue', 
                     2:'Feb_Revenue', 
                     3:'Mar_Revenue', 
                     4:'Apr_Revenue', 
                     5:'May_Revenue', 
                     6:'Jun_Revenue', 
                     7:'Jul_Revenue', 
                     8:'Aug_Revenue', 
                     9:'Sep_Revenue', 
                     10:'Oct_Revenue', 
                     11:'Nov_Revenue', 
                     12:'Dec_Revenue'})
department_allmonths.groupby(['id','month_num'], as_index=False).sum()


## leetcode 1193. Monthly Transactions I

import pandas as pd

data = [[121, 'US', 'approved', 1000, '2018-12-18'], [122, 'US', 'declined', 2000, '2018-12-19'], [123, 'US', 'approved', 2000, '2019-01-01'], [124, 'DE', 'approved', 2000, '2019-01-07'], [123, None, 'approved', 2000, '2019-01-07']]
transactions = pd.DataFrame(data, columns=['id', 'country', 'state', 'amount', 'trans_date']).astype({'id':'Int64', 'country':'object', 'state':'object', 'amount':'Int64', 'trans_date':'datetime64[ns]'})
transactions['month'] = transactions['trans_date'].dt.strftime('%Y-%m')
transactions = transactions.assign(state_bin=lambda df: df.state=='approved')
transactions.groupby(['month', 'country'], as_index=False).agg({'state':'count', 'state_bin':'sum', 'amount':'sum'})

def monthly_transactions(transactions: pd.DataFrame) -> pd.DataFrame:
    transactions['month'] = transactions['trans_date'].dt.strftime('%Y-%m')
    transactions['country'] = transactions['country'].fillna('None')
    t_all = transactions.groupby(['month', 'country'], as_index=False).agg({'state':'count', 'amount':'sum'})
    t_approved = transactions.query('state=="approved"').groupby(['month', 'country'], as_index=False).agg({'state':'count', 'amount':'sum'})
    t_result = t_all.merge(t_approved, how='left', on=['month', 'country'])\
        .rename(columns={'state_x':'trans_count', 'state_y':'approved_count', 'amount_x':'trans_total_amount', 'amount_y':'approved_total_amount'})\
            .fillna(0)[['month','country','trans_count','approved_count','trans_total_amount','approved_total_amount']]
    t_result.loc[t_result['country']=='None', 'country'] = None
    return t_result

monthly_transactions(transactions)


## leetcode 1204. Last Person to Fit in the Bus

import pandas as pd

data = [[5, 'Alice', 250, 1], [4, 'Bob', 175, 5], [3, 'Alex', 350, 2], [6, 'John Cena', 400, 3], [1, 'Winston', 500, 6], [2, 'Marie', 200, 4]]
queue = pd.DataFrame(data, columns=['person_id', 'person_name', 'weight', 'turn']).astype({'person_id':'Int64', 'person_name':'object', 'weight':'Int64', 'turn':'Int64'})

def last_passenger(queue: pd.DataFrame) -> pd.DataFrame:
    queue['weight_cumsum'] = queue.sort_values(by='turn')['weight'].cumsum()
    return pd.DataFrame({'person_name':[queue.query('weight_cumsum<=1000').sort_values(by='weight_cumsum', ascending=False).iloc[0, :]['person_name']]})

last_passenger(queue)


## leetcode 1211. Queries Quality and Percentage

import pandas as pd

data = [['Dog', 'Golden Retriever', 1, 5], ['Dog', 'German Shepherd', 2, 5], ['Dog', 'Mule', 200, 1], ['Cat', 'Shirazi', 5, 2], ['Cat', 'Siamese', 3, 3], ['Cat', 'Sphynx', 7, 4]]
queries = pd.DataFrame(data, columns=['query_name', 'result', 'position', 'rating']).astype({'query_name':'object', 'result':'object', 'position':'Int64', 'rating':'Int64'})

round2 = lambda x: round(x + 1e-9, 2)

def queries_stats(queries: pd.DataFrame) -> pd.DataFrame:
    queries['quality'] = queries['rating'] / queries['position']
    queries['poor_query_percentage'] = (queries['rating'] < 3) * 100
    return queries.groupby('query_name')[['quality','poor_query_percentage']].mean().apply(round2).reset_index()

queries_stats(queries)


## leetcode 1251. Average Selling Price

import pandas as pd

data = [[1, '2019-02-17', '2019-02-28', 5], [1, '2019-03-01', '2019-03-22', 20], [2, '2019-02-01', '2019-02-20', 15], [2, '2019-02-21', '2019-03-31', 30], [3, '2019-02-21', '2019-03-31', 30]]
prices = pd.DataFrame(data, columns=['product_id', 'start_date', 'end_date', 'price']).astype({'product_id':'Int64', 'start_date':'datetime64[ns]', 'end_date':'datetime64[ns]', 'price':'Int64'})
data = [[1, '2019-02-25', 100], [1, '2019-03-01', 15], [2, '2019-02-10', 200], [2, '2019-03-22', 30]]
units_sold = pd.DataFrame(data, columns=['product_id', 'purchase_date', 'units']).astype({'product_id':'Int64', 'purchase_date':'datetime64[ns]', 'units':'Int64'})

def average_selling_price(prices: pd.DataFrame, units_sold: pd.DataFrame) -> pd.DataFrame:
    units_prices = pd.merge(units_sold, prices, on='product_id', how='right')
    units_prices = units_prices[(units_prices['purchase_date']>=units_prices['start_date']) & (units_prices['purchase_date']<=units_prices['end_date']) | (units_prices['purchase_date'].isnull())]
    units_prices['total_amt'] = units_prices['units'] * units_prices['price']
    units_prices_agg = units_prices.groupby('product_id', as_index=False).agg({'total_amt':'sum', 'units':'sum'})
    units_prices_agg['average_price'] = round(units_prices_agg['total_amt'] / units_prices_agg['units'].replace(0, 1), 2)
    return units_prices_agg[['product_id', 'average_price']]

average_selling_price(prices, units_sold)


## leetcode 1280. Students and Examinations

import pandas as pd

data = [[1, 'Alice'], [2, 'Bob'], [13, 'John'], [6, 'Alex']]
students = pd.DataFrame(data, columns=['student_id', 'student_name']).astype({'student_id':'Int64', 'student_name':'object'})
data = [['Math'], ['Physics'], ['Programming']]
subjects = pd.DataFrame(data, columns=['subject_name']).astype({'subject_name':'object'})
data = [[1, 'Math'], [1, 'Physics'], [1, 'Programming'], [2, 'Programming'], [1, 'Physics'], [1, 'Math'], [13, 'Math'], [13, 'Programming'], [13, 'Physics'], [2, 'Math'], [1, 'Math']]
examinations = pd.DataFrame(data, columns=['student_id', 'subject_name']).astype({'student_id':'Int64', 'subject_name':'object'})

def students_and_examinations(students: pd.DataFrame, subjects: pd.DataFrame, examinations: pd.DataFrame) -> pd.DataFrame:
    exams = pd.merge(students, subjects, how='cross')\
        .sort_values(by=['student_id', 'subject_name'])\
            .merge(examinations.groupby(['student_id', 'subject_name'], as_index=False)\
                .agg(attended_exams=('subject_name', 'count')), 
                    on=['student_id', 'subject_name'], how='left')[['student_id', 'student_name', 'subject_name', 'attended_exams']]
    exams['attended_exams'] = exams['attended_exams'].fillna(0)
    return exams

students_and_examinations(students, subjects, examinations)


## leetcode 1321. Restaurant Growth

import pandas as pd

data = [[1, 'Jhon', '2019-01-01', 100], [2, 'Daniel', '2019-01-02', 110], [3, 'Jade', '2019-01-03', 120], [4, 'Khaled', '2019-01-04', 130], [5, 'Winston', '2019-01-05', 110], [6, 'Elvis', '2019-01-06', 140], [7, 'Anna', '2019-01-07', 150], [8, 'Maria', '2019-01-08', 80], [9, 'Jaze', '2019-01-09', 110], [1, 'Jhon', '2019-01-10', 130], [3, 'Jade', '2019-01-10', 150]]
customer = pd.DataFrame(data, columns=['customer_id', 'name', 'visited_on', 'amount']).astype({'customer_id':'Int64', 'name':'object', 'visited_on':'datetime64[ns]', 'amount':'Int64'})

def restaurant_growth(customer: pd.DataFrame) -> pd.DataFrame:
    running_total = customer.groupby('visited_on').agg({'amount':'sum'}).rolling(window=7).sum().reset_index().query('amount > 0')
    running_avg = customer.groupby('visited_on').agg(average_amount=('amount','sum')).rolling(window=7).mean().reset_index().round(2).query('average_amount > 0')
    return pd.merge(running_total, running_avg, how='inner', on='visited_on')

restaurant_growth(customer)


## leetcode 1327. List the Products Ordered in a Period

import pandas as pd

data = [[1, 'Leetcode Solutions', 'Book'], [2, 'Jewels of Stringology', 'Book'], [3, 'HP', 'Laptop'], [4, 'Lenovo', 'Laptop'], [5, 'Leetcode Kit', 'T-shirt']]
products = pd.DataFrame(data, columns=['product_id', 'product_name', 'product_category']).astype({'product_id':'Int64', 'product_name':'object', 'product_category':'object'})
data = [[1, '2020-02-05', 60], [1, '2020-02-10', 70], [2, '2020-01-18', 30], [2, '2020-02-11', 80], [3, '2020-02-17', 2], [3, '2020-02-24', 3], [4, '2020-03-01', 20], [4, '2020-03-04', 30], [4, '2020-03-04', 60], [5, '2020-02-25', 50], [5, '2020-02-27', 50], [5, '2020-03-01', 50]]
orders = pd.DataFrame(data, columns=['product_id', 'order_date', 'unit']).astype({'product_id':'Int64', 'order_date':'datetime64[ns]', 'unit':'Int64'})

def list_products(products: pd.DataFrame, orders: pd.DataFrame) -> pd.DataFrame:
    orders['order_month'] = orders['order_date'].dt.strftime('%Y-%m')
    return orders.merge(products, how='inner', on='product_id').query('order_month=="2020-02"').groupby('product_name', as_index=False).agg({'unit':'sum'}).query('unit>=100')

list_products(products, orders)


## leetcode 1341. Movie Rating

import pandas as pd

data = [[1, 'Avengers'], [2, 'Frozen 2'], [3, 'Joker']]
movies = pd.DataFrame(data, columns=['movie_id', 'title']).astype({'movie_id':'Int64', 'title':'object'})
data = [[1, 'Daniel'], [2, 'Monica'], [3, 'Maria'], [4, 'James']]
users = pd.DataFrame(data, columns=['user_id', 'name']).astype({'user_id':'Int64', 'name':'object'})
data = [[1, 1, 3, '2020-01-12'], [1, 2, 4, '2020-02-11'], [1, 3, 2, '2020-02-12'], [1, 4, 1, '2020-01-01'], [2, 1, 5, '2020-02-17'], [2, 2, 2, '2020-02-01'], [2, 3, 2, '2020-03-01'], [3, 1, 3, '2020-02-22'], [3, 2, 4, '2020-02-25']]
movie_rating = pd.DataFrame(data, columns=['movie_id', 'user_id', 'rating', 'created_at']).astype({'movie_id':'Int64', 'user_id':'Int64', 'rating':'Int64', 'created_at':'datetime64[ns]'})

def movie_rating(movies: pd.DataFrame, users: pd.DataFrame, movie_rating: pd.DataFrame) -> pd.DataFrame:
    movie_rating['rating_month'] = movie_rating['created_at'].dt.strftime('%Y-%m')
    most_rates = movie_rating.merge(users, how='inner', on='user_id').groupby('name', as_index=False).agg({'rating':'count'}).sort_values(by='rating', ascending=False).head(1)['name']
    max_avg_rating = movie_rating.merge(movies, how='inner', on='movie_id').query('rating_month=="2020-02"').groupby('title', as_index=False).agg({'rating':'mean'}).sort_values(by='rating', ascending=False).head(1)['title']
    return pd.DataFrame({'results':pd.concat([most_rates, max_avg_rating])})

movie_rating(movies, users, movie_rating)


## leetcode 1378. Replace Employee ID With The Unique Identifier

import pandas as pd

data = [[1, 'Alice'], [7, 'Bob'], [11, 'Meir'], [90, 'Winston'], [3, 'Jonathan']]
employees = pd.DataFrame(data, columns=['id', 'name']).astype({'id':'int64', 'name':'object'})
data = [[3, 1], [11, 2], [90, 3]]
employee_uni = pd.DataFrame(data, columns=['id', 'unique_id']).astype({'id':'int64', 'unique_id':'int64'})

def replace_employee_id(employees: pd.DataFrame, employee_uni: pd.DataFrame) -> pd.DataFrame:
    return employees.merge(employee_uni, how='left', on='id')[['unique_id', 'name']]

replace_employee_id(employees, employee_uni)


## leetcode 1393. Capital Gain/Loss

import pandas as pd
import numpy as np

data = [['Leetcode', 'Buy', 1, 1000], ['Corona Masks', 'Buy', 2, 10], ['Leetcode', 'Sell', 5, 9000], ['Handbags', 'Buy', 17, 30000], ['Corona Masks', 'Sell', 3, 1010], ['Corona Masks', 'Buy', 4, 1000], ['Corona Masks', 'Sell', 5, 500], ['Corona Masks', 'Buy', 6, 1000], ['Handbags', 'Sell', 29, 7000], ['Corona Masks', 'Sell', 10, 10000]]
stocks = pd.DataFrame(data, columns=['stock_name', 'operation', 'operation_day', 'price']).astype({'stock_name':'object', 'operation':'object', 'operation_day':'Int64', 'price':'Int64'})

def capital_gainloss(stocks: pd.DataFrame) -> pd.DataFrame:
    stocks['capital_gain_loss'] = np.where(stocks['operation']=='Buy', -stocks['price'], stocks['price'])
    return stocks.groupby('stock_name', as_index=False).agg({'capital_gain_loss':'sum'})

capital_gainloss(stocks)


## leetcode 1407. Top Travellers

import pandas as pd

data = [[1, 'Alice'], [2, 'Bob'], [3, 'Alex'], [4, 'Donald'], [7, 'Lee'], [13, 'Jonathan'], [19, 'Elvis']]
users = pd.DataFrame(data, columns=['id', 'name']).astype({'id':'Int64', 'name':'object'})
data = [[1, 1, 120], [2, 2, 317], [3, 3, 222], [4, 7, 100], [5, 13, 312], [6, 19, 50], [7, 7, 120], [8, 19, 400], [9, 7, 230]]
rides = pd.DataFrame(data, columns=['id', 'user_id', 'distance']).astype({'id':'Int64', 'user_id':'Int64', 'distance':'Int64'})

def top_travellers(users: pd.DataFrame, rides: pd.DataFrame) -> pd.DataFrame:
    return users\
        .merge(rides, how='left', left_on='id', right_on='user_id')[['id_x', 'name', 'distance']]\
            .groupby(['id_x', 'name'], as_index=False)\
                .agg(travelled_distance = ('distance', 'sum'))\
                    .sort_values(['travelled_distance', 'name'], ascending=[False, True])[['name', 'travelled_distance']]

top_travellers(users, rides)


## leetcode 1484. Group Sold Products By The Date

import pandas as pd

data = [['2020-05-30', 'Headphone'], ['2020-06-01', 'Pencil'], ['2020-06-02', 'Mask'], ['2020-05-30', 'Basketball'], ['2020-06-01', 'Bible'], ['2020-06-02', 'Mask'], ['2020-05-30', 'T-Shirt']]
activities = pd.DataFrame(data, columns=['sell_date', 'product']).astype({'sell_date':'datetime64[ns]', 'product':'object'})

def categorize_products(activities: pd.DataFrame) -> pd.DataFrame:
    return activities.groupby('sell_date', as_index=False)['product'].agg([('num_sold', 'nunique'), ('products', lambda x: ','.join(sorted(x.unique())))])

categorize_products(activities)


## leetcode 1517. Find Users With Valid E-Mails

import pandas as pd

data = [[1, 'Winston', 'winston@leetcode.com'], [2, 'Jonathan', 'jonathanisgreat'], [3, 'Annabelle', 'bella-@leetcode.com'], [4, 'Sally', 'sally.come@leetcode.com'], [5, 'Marwan', 'quarz#2020@leetcode.com'], [6, 'David', 'david69@gmail.com'], [7, 'Shapiro', '.shapo@leetcode.com']]
users = pd.DataFrame(data, columns=['user_id', 'name', 'mail']).astype({'user_id':'int64', 'name':'object', 'mail':'object'})

def valid_emails(users: pd.DataFrame) -> pd.DataFrame:
    return users[users['mail'].str.match(r'^[A-Za-z][A-Za-z0-9_\.\-]*@leetcode(\?com)?\.com$')]

valid_emails(users)


## leetcode 1527. Patients With a Condition

import pandas as pd

data = [[1, 'Daniel', 'YFEV COUGH'], [2, 'Alice', ''], [3, 'Bob', 'SADIAB100 MYOP'], [4, 'George', 'ACNE DIAB100'], [5, 'Alain', 'DIAB201']]
patients = pd.DataFrame(data, columns=['patient_id', 'patient_name', 'conditions']).astype({'patient_id':'int64', 'patient_name':'object', 'conditions':'object'})

def find_patients(patients: pd.DataFrame) -> pd.DataFrame:
    return patients[patients.conditions.str.contains(r'\bDIAB1')]

find_patients(patients)


## leetcode 1581. Customer Who Visited but Did Not Make Any Transactions

import pandas as pd

data = [[1, 23], [2, 9], [4, 30], [5, 54], [6, 96], [7, 54], [8, 54]]
visits = pd.DataFrame(data, columns=['visit_id', 'customer_id']).astype({'visit_id':'Int64', 'customer_id':'Int64'})
data = [[2, 5, 310], [3, 5, 300], [9, 5, 200], [12, 1, 910], [13, 2, 970]]
transactions = pd.DataFrame(data, columns=['transaction_id', 'visit_id', 'amount']).astype({'transaction_id':'Int64', 'visit_id':'Int64', 'amount':'Int64'})

def find_customers(visits: pd.DataFrame, transactions: pd.DataFrame) -> pd.DataFrame:
    return visits.merge(transactions, how='left', on='visit_id')\
        .query('transaction_id.isna()').groupby('customer_id', as_index=False)\
            .agg(count_no_trans=('visit_id', 'count'))

find_customers(visits)


## leetcode 1587. Bank Account Summary II

import pandas as pd

data = [[900001, 'Alice'], [900002, 'Bob'], [900003, 'Charlie']]
users = pd.DataFrame(data, columns=['account', 'name']).astype({'account':'Int64', 'name':'object'})
data = [[1, 900001, 7000, '2020-08-01'], [2, 900001, 7000, '2020-09-01'], [3, 900001, -3000, '2020-09-02'], [4, 900002, 1000, '2020-09-12'], [5, 900003, 6000, '2020-08-07'], [6, 900003, 6000, '2020-09-07'], [7, 900003, -4000, '2020-09-11']]
transactions = pd.DataFrame(data, columns=['trans_id', 'account', 'amount', 'transacted_on']).astype({'trans_id':'Int64', 'account':'Int64', 'amount':'Int64', 'transacted_on':'datetime64[ns]'})

def account_summary(users: pd.DataFrame, transactions: pd.DataFrame) -> pd.DataFrame:
    return users.merge(transactions, how='left', on='account')\
        .groupby('name', as_index=False).agg(balance=('amount','sum')).query('balance>10000')

account_summary(users, transactions)


## leetcode 1633. Percentage of Users Attended a Contest

import pandas as pd

data = [[6, None], [2, 'Bob'], [7, 'Alex']]
users = pd.DataFrame(data, columns=['user_id', 'user_name']).astype({'user_id':'Int64', 'user_name':'object'})
data = [[215, 6], [209, 2], [208, 2], [210, 6], [208, 6], [209, 7], [209, 6], [215, 7], [208, 7], [210, 2], [207, 2], [210, 7]]
register = pd.DataFrame(data, columns=['contest_id', 'user_id']).astype({'contest_id':'Int64', 'user_id':'Int64'})

def users_percentage(users: pd.DataFrame, register: pd.DataFrame) -> pd.DataFrame:
    max_amt = users.merge(register, how='cross')[['user_id_x', 'contest_id']].drop_duplicates().groupby('contest_id', as_index=False).agg(tot_amt=('user_id_x', 'count'))
    cur_amt = users.merge(register, how='left', on='user_id')[['user_id', 'contest_id']].groupby('contest_id', as_index=False).agg(cur_amt=('user_id', 'count'))
    percentage_ds = cur_amt.merge(max_amt, how='right', on='contest_id')
    percentage_ds['percentage'] = round(percentage_ds['cur_amt'] / percentage_ds['tot_amt'] * 100, 2)
    return percentage_ds[['contest_id', 'percentage']].sort_values(by=['percentage', 'contest_id'], ascending=[False, True])

users_percentage(users, register)


## leetcode 1661. Average Time of Process per Machine

import pandas as pd

data = [[0, 0, 'start', 0.712], [0, 0, 'end', 1.52], [0, 1, 'start', 3.14], [0, 1, 'end', 4.12], [1, 0, 'start', 0.55], [1, 0, 'end', 1.55], [1, 1, 'start', 0.43], [1, 1, 'end', 1.42], [2, 0, 'start', 4.1], [2, 0, 'end', 4.512], [2, 1, 'start', 2.5], [2, 1, 'end', 5]]
activity = pd.DataFrame(data, columns=['machine_id', 'process_id', 'activity_type', 'timestamp']).astype({'machine_id':'Int64', 'process_id':'Int64', 'activity_type':'object', 'timestamp':'Float64'})

def get_average_time(activity: pd.DataFrame) -> pd.DataFrame:
    activity_df_pvt = activity.pivot(index=['machine_id', 'process_id'], columns='activity_type', values='timestamp').reset_index()
    activity_df_pvt['processing_time'] = activity_df_pvt['end']-activity_df_pvt['start']
    return activity_df_pvt.groupby('machine_id', as_index=False).agg({'processing_time':'mean'}).round(3)

get_average_time(activity)


## leetcode 1667. Fix Names in a Table

import pandas as pd

data = [[1, 'aLice'], [2, 'bOB']]
users = pd.DataFrame(data, columns=['user_id', 'name']).astype({'user_id':'Int64', 'name':'object'})

def fix_names(users: pd.DataFrame) -> pd.DataFrame:
    users['name'] = users['name'].str.capitalize()
    return users.sort_values(by='user_id')

fix_names(users)


## leetcode 1683. Invalid Tweets

import pandas as pd

data = [[1, 'Let us Code'], [2, 'More than fifteen chars are here!']]
tweets = pd.DataFrame(data, columns=['tweet_id', 'content']).astype({'tweet_id':'Int64', 'content':'object'})

def invalid_tweets(tweets: pd.DataFrame) -> pd.DataFrame:
    return pd.DataFrame({'tweet_id':tweets.query('content.str.len()>15')['tweet_id']})

invalid_tweets(tweets)


## leetcode 1693. Daily Leads and Partners

import pandas as pd

data = [['2020-12-8', 'toyota', 0, 1], ['2020-12-8', 'toyota', 1, 0], ['2020-12-8', 'toyota', 1, 2], ['2020-12-7', 'toyota', 0, 2], ['2020-12-7', 'toyota', 0, 1], ['2020-12-8', 'honda', 1, 2], ['2020-12-8', 'honda', 2, 1], ['2020-12-7', 'honda', 0, 1], ['2020-12-7', 'honda', 1, 2], ['2020-12-7', 'honda', 2, 1]]
daily_sales = pd.DataFrame(data, columns=['date_id', 'make_name', 'lead_id', 'partner_id']).astype({'date_id':'datetime64[ns]', 'make_name':'object', 'lead_id':'Int64', 'partner_id':'Int64'})

def daily_leads_and_partners(daily_sales: pd.DataFrame) -> pd.DataFrame:
    return daily_sales.groupby(['date_id', 'make_name'], as_index=False)\
        .agg(unique_leads=('lead_id', 'nunique'), unique_partners=('partner_id', 'nunique'))

daily_leads_and_partners(daily_sales)


## leetcode 1729. Find Followers Count

import pandas as pd

data = [['0', '1'], ['1', '0'], ['2', '0'], ['2', '1']]
followers = pd.DataFrame(data, columns=['user_id', 'follower_id']).astype({'user_id':'Int64', 'follower_id':'Int64'})

def count_followers(followers: pd.DataFrame) -> pd.DataFrame:
    return followers.groupby('user_id', as_index=False)\
        .agg(followers_count=('follower_id', 'nunique')).sort_values(by='user_id')

count_followers(followers)


## leetcode 1731. The Number of Employees Which Report to Each Employee

import pandas as pd
import numpy as np

data = [[9, 'Hercy', None, 43], [6, 'Alice', 9, 41], [4, 'Bob', 9, 36], [2, 'Winston', None, 37]]
employees = pd.DataFrame(data, columns=['employee_id', 'name', 'reports_to', 'age']).astype({'employee_id':'Int64', 'name':'object', 'reports_to':'Int64', 'age':'Int64'})

def custom_round(x):
    return int(np.floor(x + 0.5))

def count_employees(employees: pd.DataFrame) -> pd.DataFrame:
    df = employees.merge(employees, how='inner', left_on='employee_id', right_on='reports_to')\
    .groupby(['employee_id_x', 'name_x'], as_index=False)\
        .agg(reports_count=('reports_to_y','count'), average_age=('age_y','mean'))\
            .rename(columns={'employee_id_x':'employee_id', 'name_x':'name'}).sort_values(by='employee_id')
    df['average_age'] = df['average_age'].apply(custom_round)
    return df

count_employees(employees)


## leetcode 1741. Find Total Time Spent by Each Employee

import pandas as pd

data = [['1', '2020-11-28', '4', '32'], ['1', '2020-11-28', '55', '200'], ['1', '2020-12-3', '1', '42'], ['2', '2020-11-28', '3', '33'], ['2', '2020-12-9', '47', '74']]
employees = pd.DataFrame(data, columns=['emp_id', 'event_day', 'in_time', 'out_time']).astype({'emp_id':'Int64', 'event_day':'datetime64[ns]', 'in_time':'Int64', 'out_time':'Int64'})

def total_time(employees: pd.DataFrame) -> pd.DataFrame:
    employees['time_diff'] = employees['out_time'] - employees['in_time']
    return employees.groupby(['event_day', 'emp_id'], as_index=False).\
        agg(total_time=('time_diff','sum')).rename(columns={'event_day':'day'})

total_time(employees)


## leetcode 1757. Recyclable and Low Fat Products

import pandas as pd

data = [['0', 'Y', 'N'], ['1', 'Y', 'Y'], ['2', 'N', 'Y'], ['3', 'Y', 'Y'], ['4', 'N', 'N']]
products = pd.DataFrame(data, columns=['product_id', 'low_fats', 'recyclable']).astype({'product_id':'int64', 'low_fats':'category', 'recyclable':'category'})

def find_products(products: pd.DataFrame) -> pd.DataFrame:
    return pd.DataFrame({'product_id':products.query('low_fats=="Y" & recyclable=="Y"')['product_id']})

find_products(products)


## leetcode 1789. Primary Department for Each Employee

import pandas as pd

data = [['1', '1', 'N'], ['2', '1', 'Y'], ['2', '2', 'N'], ['3', '3', 'N'], ['4', '2', 'N'], ['4', '3', 'Y'], ['4', '4', 'N']]
employee = pd.DataFrame(data, columns=['employee_id', 'department_id', 'primary_flag']).astype({'employee_id':'Int64', 'department_id':'Int64', 'primary_flag':'object'})

def find_primary_department(employee: pd.DataFrame) -> pd.DataFrame:
    employee_cnt = employee.groupby('employee_id', as_index=False).agg(emp_cnt = ('employee_id', 'count'))
    return employee.merge(employee_cnt, how='left', on='employee_id')\
        .query('emp_cnt==1 | primary_flag=="Y"')[['employee_id', 'department_id']]

find_primary_department(employee)


## leetcode 1795. Rearrange Products Table

import pandas as pd

data = [[0, 95, 100, 105], [1, 70, None, 80]]
products = pd.DataFrame(data, columns=['product_id', 'store1', 'store2', 'store3']).astype({'product_id':'Int64', 'store1':'Int64', 'store2':'Int64', 'store3':'Int64'})

def rearrange_products_table(products: pd.DataFrame) -> pd.DataFrame:
    return products.melt(id_vars='product_id').rename(columns={'variable':'store', 'value':'price'}).dropna()

rearrange_products_table(products)


## leetcode 1873. Calculate Special Bonus

import pandas as pd
import numpy as np

data = [[2, 'Meir', 3000], [3, 'Michael', 3800], [7, 'Addilyn', 7400], [8, 'Juan', 6100], [9, 'Kannon', 7700]]
employees = pd.DataFrame(data, columns=['employee_id', 'name', 'salary']).astype({'employee_id':'int64', 'name':'object', 'salary':'int64'})

def calculate_special_bonus(employees: pd.DataFrame) -> pd.DataFrame:
    conditions = [(employees['employee_id'] % 2 != 0) & (employees['name'].str[0] != 'M')]
    employees['bonus'] = np.select(conditions, [employees['salary']])
    return employees[['employee_id', 'bonus']].sort_values(by='employee_id')

calculate_special_bonus(employees)


## leetcode 1890. The Latest Login in 2020

import pandas as pd

data = [[6, '2020-06-30 15:06:07'], [6, '2021-04-21 14:06:06'], [6, '2019-03-07 00:18:15'], [8, '2020-02-01 05:10:53'], [8, '2020-12-30 00:46:50'], [2, '2020-01-16 02:49:50'], [2, '2019-08-25 07:59:08'], [14, '2019-07-14 09:00:00'], [14, '2021-01-06 11:59:59']]
logins = pd.DataFrame(data, columns=['user_id', 'time_stamp']).astype({'user_id':'Int64', 'time_stamp':'datetime64[ns]'})

def latest_login(logins: pd.DataFrame) -> pd.DataFrame:
    return logins.loc[logins.time_stamp.dt.year == 2020].groupby('user_id', as_index=False).agg(last_stamp = ('time_stamp', 'max'))


## leetcode 1907. Count Salary Categories

import pandas as pd
import numpy as np

data = [[3, 108939], [2, 12747], [8, 87709], [6, 91796]]
accounts = pd.DataFrame(data, columns=['account_id', 'income']).astype({'account_id':'Int64', 'income':'Int64'})

def count_salary_categories(accounts: pd.DataFrame) -> pd.DataFrame:
    accounts.astype({'income': int})
    salary_cat_ds = pd.DataFrame(['Low Salary', 'Average Salary', 'High Salary'], columns=['category']).astype({'category':'object'})
    conditions = [
        (accounts['income'] < 20000),
        (accounts['income'] >= 20000) & (accounts['income'] <= 50000),
        (accounts['income'] > 50000)
    ]
    values = ['Low Salary', 'Average Salary', 'High Salary']
    accounts['category'] = np.select(conditions, values, default='large')
    return salary_cat_ds.merge(accounts, how='left', on='category').groupby('category', as_index=False).agg(accounts_count=('account_id','count'))

count_salary_categories(accounts)


## leetcode 1934. Confirmation Rate

import pandas as pd
import numpy as np

data = [[3, '2020-03-21 10:16:13'], [7, '2020-01-04 13:57:59'], [2, '2020-07-29 23:09:44'], [6, '2020-12-09 10:39:37']]
signups = pd.DataFrame(data, columns=['user_id', 'time_stamp']).astype({'user_id':'Int64', 'time_stamp':'datetime64[ns]'})
data = [[3, '2021-01-06 03:30:46', 'timeout'], [3, '2021-07-14 14:00:00', 'timeout'], [7, '2021-06-12 11:57:29', 'confirmed'], [7, '2021-06-13 12:58:28', 'confirmed'], [7, '2021-06-14 13:59:27', 'confirmed'], [2, '2021-01-22 00:00:00', 'confirmed'], [2, '2021-02-28 23:59:59', 'timeout']]
confirmations = pd.DataFrame(data, columns=['user_id', 'time_stamp', 'action']).astype({'user_id':'Int64', 'time_stamp':'datetime64[ns]', 'action':'object'})

def confirmation_rate(signups: pd.DataFrame, confirmations: pd.DataFrame) -> pd.DataFrame:
    confirmations['confirm'] = np.where(confirmations.action == 'confirmed', 1, 0)
    conf_rate_ds = signups.merge(confirmations, how='left', on='user_id').groupby('user_id', as_index=False).agg(confirmed=('confirm','sum'), total=('confirm','count'))
    conf_rate_ds['confirmation_rate'] = conf_rate_ds['confirmed'] / conf_rate_ds['total']
    conf_rate_ds['confirmation_rate'] = conf_rate_ds['confirmation_rate'].fillna(0).round(2)
    return conf_rate_ds[['user_id', 'confirmation_rate']]

confirmation_rate(signups, confirmations)


## leetcode 1965. Employees With Missing Information

import pandas as pd

data = [[2, 'Crew'], [4, 'Haven'], [5, 'Kristian']]
employees = pd.DataFrame(data, columns=['employee_id', 'name']).astype({'employee_id':'Int64', 'name':'object'})
data = [[5, 76071], [1, 22517], [4, 63539]]
salaries = pd.DataFrame(data, columns=['employee_id', 'salary']).astype({'employee_id':'Int64', 'salary':'Int64'})

def find_employees(employees: pd.DataFrame, salaries: pd.DataFrame) -> pd.DataFrame:
    return pd.DataFrame({'employee_id':list(employees\
                                            .merge(salaries, how='outer', on='employee_id')\
                                                .query('name.isna()==True | salary.isna()==True')\
                                                    .sort_values(by='employee_id')['employee_id'])})

find_employees(employees, salaries)


## leetcode 1978. Employees Whose Manager Left the Company

import pandas as pd

data = [[3, 'Mila', 9, 60301], [12, 'Antonella', None, 31000], [13, 'Emery', None, 67084], [1, 'Kalel', 11, 21241], [9, 'Mikaela', None, 50937], [11, 'Joziah', 6, 28485]]
employees = pd.DataFrame(data, columns=['employee_id', 'name', 'manager_id', 'salary']).astype({'employee_id':'Int64', 'name':'object', 'manager_id':'Int64', 'salary':'Int64'})

def find_employees(employees: pd.DataFrame) -> pd.DataFrame:
    return pd.DataFrame({'employee_id':list(employees\
                                            .merge(employees, how='left', left_on='manager_id', right_on='employee_id')\
                                                .query('manager_id_x.isna()==False & name_y.isna()==True & salary_x<30000')\
                                                    .sort_values(by='employee_id_x')['employee_id_x'])})

find_employees(employees)


## leetcode 2356. Number of Unique Subjects Taught by Each Teacher

import pandas as pd

data = [[1, 2, 3], [1, 2, 4], [1, 3, 3], [2, 1, 1], [2, 2, 1], [2, 3, 1], [2, 4, 1]]
teacher = pd.DataFrame(data, columns=['teacher_id', 'subject_id', 'dept_id']).astype({'teacher_id':'Int64', 'subject_id':'Int64', 'dept_id':'Int64'})

def count_unique_subjects(teacher: pd.DataFrame) -> pd.DataFrame:
    return teacher.groupby(by='teacher_id', as_index=False).agg(cnt=('subject_id', 'nunique'))

count_unique_subjects(teacher)


## leetcode 2877. Create a DataFrame from List

import pandas as pd

student_data = [
  [1, 15],
  [2, 11],
  [3, 11],
  [4, 20]
]

def createDataframe(student_data: List[List[int]]) -> pd.DataFrame:
    return pd.DataFrame(student_data, columns=['student_id', 'age']).astype({'student_id':int, 'age':int})

createDataframe(student_data)


## leetcode 2878. Get the Size of a DataFrame

import pandas as pd

def getDataframeSize(players: pd.DataFrame) -> List[int]:
    return list(players.shape)


## leetcode 2879. Display the First Three Rows

import pandas as pd

def selectFirstRows(employees: pd.DataFrame) -> pd.DataFrame:
    return employees.head(3)


## leetcode 2880. Select Data

import pandas as pd

def selectData(students: pd.DataFrame) -> pd.DataFrame:
    return students.query('student_id==101')[['name', 'age']]


## leetcode 2881. Create a New Column

import pandas as pd

def createBonusColumn(employees: pd.DataFrame) -> pd.DataFrame:
    employees['bonus'] = employees['salary'] * 2
    return employees


## leetcode 2882. Drop Duplicate Rows

import pandas as pd

def dropDuplicateEmails(customers: pd.DataFrame) -> pd.DataFrame:
    return customers.drop_duplicates(subset=['email'], keep='first')


## leetcode 2883. Drop Missing Data

import pandas as pd

def dropMissingData(students: pd.DataFrame) -> pd.DataFrame:
    return students.query('name.isna()==False')


## leetcode 2884. Modify Columns

import pandas as pd

def modifySalaryColumn(employees: pd.DataFrame) -> pd.DataFrame:
    employees['salary'] = employees['salary'] * 2
    return employees


## leetcode 2885. Rename Columns

import pandas as pd

def renameColumns(students: pd.DataFrame) -> pd.DataFrame:
    return students.rename(columns={'id':'student_id', 'first':'first_name', 'last':'last_name', 'age':'age_in_years'})


## leetcode 2886. Change Data Type

import pandas as pd

def changeDatatype(students: pd.DataFrame) -> pd.DataFrame:
    students['grade'] = students['grade'].astype(int)
    return students


## leetcode 2887. Fill Missing Data

import pandas as pd

def fillMissingValues(products: pd.DataFrame) -> pd.DataFrame:
    products['quantity'] = products['quantity'].fillna(0)
    return products


## leetcode 2888. Reshape Data: Concatenate

import pandas as pd

def concatenateTables(df1: pd.DataFrame, df2: pd.DataFrame) -> pd.DataFrame:
    return pd.concat([df1, df2])


## leetcode 2889. Reshape Data: Pivot

import pandas as pd

def pivotTable(weather: pd.DataFrame) -> pd.DataFrame:
    return weather.pivot(index='month', columns='city', values='temperature')


## leetcode 2890. Reshape Data: Melt

import pandas as pd

def meltTable(report: pd.DataFrame) -> pd.DataFrame:
    return report.melt(id_vars='product', value_vars=['quarter_1', 'quarter_2', 'quarter_3', 'quarter_4'], var_name='quarter', value_name='sales')


## leetcode 2891. Method Chaining

import pandas as pd

def findHeavyAnimals(animals: pd.DataFrame) -> pd.DataFrame:
    return pd.DataFrame({'name':list(animals.query('weight>100').sort_values(by='weight', ascending=False)['name'])})


## leetcode 3220. Odd and Even Transactions

import pandas as pd
import numpy as np

data = [[1, 150, '2024-07-01'], [2, 200, '2024-07-01'], [3, 75, '2024-07-01'], [4, 300, '2024-07-02'], [5, 50, '2024-07-02'], [6, 120, '2024-07-03']]
transactions = pd.DataFrame(data, columns=['transaction_id', 'amount', 'transaction_date']).astype({'transaction_id':int, 'amount':int, 'transaction_date':'datetime64[ns]'})

def sum_daily_odd_even(transactions: pd.DataFrame) -> pd.DataFrame:
    transactions['transaction_type'] = np.where(transactions['amount'] % 2 == 0, 'even_sum', 'odd_sum')
    return transactions\
        .pivot_table(index='transaction_date', columns='transaction_type', values='amount', aggfunc='sum')\
            .reset_index()\
                .fillna(0)[['transaction_date', 'odd_sum', 'even_sum']]

sum_daily_odd_even(transactions)