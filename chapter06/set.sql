# 6.1 集合理論 : 入門

/*
和集合 : A union B
積集合 : A intersect B
差集合 : A except B
**/

# 6.2 集合理論 : 実践

select 1 num, 'abc' str
union
select 9 num, 'xyz' str;
/* 複数の独立したクエリで構成されるため、複合クエリと呼ぶ */

# 6.3 集合演算子

## union 演算子
/* union all は重複を削除しない **/
select cust_id, lname name
from individual
union all
select cust_id, name
from business;

/* 重複が除外されない例(union all) **/
select emp_id
from employee
where assigned_branch_id = 2
and (title = 'Teller' or title = 'Head Teller')
union all
select distinct open_emp_id
from account
where open_branch_id = 2;

/* 重複が除外される例(union) **/
select emp_id
from employee
where assigned_branch_id = 2
and (title = 'Teller' or title = 'Head Teller')
union
select distinct open_emp_id
from account
where open_branch_id = 2;

## intersect 演算子
/* intersect 演算子は未実装のために inner join で代用 **/
select emp_id
from (select emp_id
    from employee
    where assigned_branch_id = 2
    and (title = 'Teller' or title = 'Head Teller')) e
inner join (select distinct open_emp_id
    from account
    where open_branch_id = 2) a
on e.emp_id = a.open_emp_id;

## except 演算子
/* except 演算子は未実装のために not in で代用 **/
select emp_id
from (select emp_id
    from employee
    where assigned_branch_id = 2
    and (title = 'Teller' or title = 'Head Teller')) e
where emp_id not in (select distinct open_emp_id
    from account
    where open_branch_id = 2);
