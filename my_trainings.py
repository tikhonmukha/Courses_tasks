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