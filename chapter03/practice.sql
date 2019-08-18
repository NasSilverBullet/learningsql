# 3.8 練習問題

## 3-1
select emp_id, lname, fname
from employee
order by lname, fname;

## 3-2
select account_id, cust_id, avail_balance
from account
where status = 'ACTIVE'
and avail_balance > '2500';

## 3-3
select distinct open_emp_id
from account

## 3-4
select p.product_cd, a.cust_id, a.avail_balance
from product p inner join account a
on p.product_cd = a.product_cd
where p.product_type_cd = 'ACCOUNT';
