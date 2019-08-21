# 8.5 練習問題
# 8.5 練習問題

# 8-1
select count(*)
from account;

# 8-2
select a.cust_id, count(*) acount_num
from account a inner join customer c
on a.cust_id = c.cust_id
where a.status = 'ACTIVE'
group by a.cust_id;

select cust_id, count(*)
from account
group by cust_id;

# 8-3
select a.cust_id, count(*) acount_num
from account a inner join customer c
on a.cust_id = c.cust_id
where a.status = 'ACTIVE'
group by a.cust_id
having count(*) > 1;

select cust_id, count(*)
from account
group by cust_id
having count(*) >= 2;

# 8-4(応用問題)
select product_cd, open_branch_id,
sum(avail_balance)
from account
group by product_cd, open_branch_id
having count(*) > 1
order by sum(avail_balance) desc;
