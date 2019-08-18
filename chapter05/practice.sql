# 5.6 練習問題

# 5-1
select e.emp_id, e.fname, e.lname, b.name
from employee e inner join branch b
on e.assigned_branch_id = b.branch_id;

# 5-2
select a.account_id, c.fed_id, p.name product_name
from account a inner join customer c
on a.cust_id = c.cust_id
inner join product p
on a.product_cd = p.product_cd
where c.cust_type_cd = 'I'

/* or **/
select a.account_id, c.fed_id, p.name product_name
from account a inner join (
    select cust_id, fed_id
        from customer
            where cust_type_cd = 'I') c
    on a.cust_id = c.cust_id
inner join product p
    on a.product_cd = p.product_cd


# 5-3
select e.emp_id, e.fname, e.lname
from employee e inner join employee mgr
on e.superior_emp_id = mgr.emp_id
where e.dept_id != mgr.dept_id;
