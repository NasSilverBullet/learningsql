# 9.7 練習問題
# 9-1
select account_id, product_cd, cust_id, avail_balance
from account
where product_cd in (select product_cd
from product
where product_type_cd = 'LOAN');

# 9-2
select account_id, product_cd, cust_id, avail_balance
from account a
where exists (select 1
from product p
where p.product_type_cd = 'LOAN'
and p.product_cd = a.product_cd);

# 9-3
select e.emp_id, e.fname, e.lname, levels.name
from employee e inner join
(select 'trainee' name, '2004-01-01' start_dt, '2005-12-31' end_dt
union all
select 'worker' name, '2002-01-01' start_dt, '2003-12-31' end_dt
union all
select 'mentor' name, '2000-01-01' start_dt, '2001-12-31' end_dt) levels
on e.start_date
between levels.start_dt and levels.end_dt;

# 9-4
select e.emp_id, e.fname, e.lname,
(select d.name from department d where d.dept_id = e.dept_id ) dept_name,
(select b.name from branch b where b.branch_id = e.assigned_branch_id ) branch_name
from employee e;
