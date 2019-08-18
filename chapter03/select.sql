# 3.2 クエリの節

## クエリは下記の節で構成される
/*
select
from
where
group by
having
order by
 **/


# 3.3 select 節
select *
from department;

select dept_id, name
from department;

select name
from department;

## ビルトイン関数
select emp_id,
'ACTIVE',
emp_id * 3.14159,
upper(lname)
from employee;

## from 節を削除できる場合もある
select version(),
user(),
database();

## 列エイリアス
select emp_id,
'ACTIVE' status,              ## 列エイリアス
emp_id * 3.14159 empid_x_pi,  ## 列エイリアス
upper(lname) last_name_upper  ## 列エイリアス
from employee;

## 重複の削除
select distinct cust_id
from account;
## データソートを行っているため、大きな結果セットでは時間がかかる
## 安易に distinct を使用しない
## データを理解することに時間を割く


# 3.4 from 節

## サブクエリ
select e.emp_id, e.fname, e.lname
from (select emp_id, fname, lname, start_date, title
from employee) e;

## ビュー
create view employee_vw as
select emp_id, fname, lname,
    year(start_date) start_year
from employee;

select emp_id, start_year
from employee_vw;

## テーブルリンク
select employee.emp_id, employee.fname,
employee.lname, department.name dept_name
from employee inner join department
on employee.dept_id = department.dept_id;

## テーブルエイリアスの定義
select e.emp_id, e.fname, e.lname,
    d.name dept_name
from employee e inner join department d
    on e.dept_id  = d.dept_id;


## where 節

select emp_id, fname, lname, start_date, title
from employee
where title = 'Head Teller';

## and
select emp_id, fname, lname, start_date, title
from employee
where title = 'Head Teller';
and start_date > '2002-01-01';

## or
select emp_id, fname, lname, start_date, title
from employee
where title = 'Head Teller';
or start_date > '2002-01-01';

## 演算子を組み合わせて使う場合は()を使う
select emp_id, fname, lname, start_date, title
from employee
where (title = 'Head Teller' and start_date > '2002-01-01')
or (title = 'Teller' and start_date > '2003-01-01');

# 3.6 group by 節 having 節

# 3.7 order by 節
select open_emp_id, product_cd
from account
order by open_emp_id;

select open_emp_id, product_cd
from account
order by open_emp_id, product_cd; # open_emp_id のあとに product_cd をソートする

select account_id, product_cd, open_date, avail_balance
from account
order by avail_balance desc; # 降順

## 3.7.2 式による並べ替え
select cust_id, cust_type_cd, city, state, fed_id
from customer
order by right(fed_id, 3); # fed_id の下三桁でソートする

## 3.7.3 数値のプレースホルダによる並べ替え
select emp_id, title, start_date, fname, lname
from employee
order by 2, 5;
## あんまり使わないほうが良い
