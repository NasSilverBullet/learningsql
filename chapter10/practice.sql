# 10.4 練習問題

# 10-1
select p.product_cd, a.account_id, a.cust_id, a.avail_balance
from product p left outer join account a
on p.product_cd = a.product_cd;

# 10-2
select p.product_cd, a.account_id, a.cust_id, a.avail_balance
from account a right outer join product p
on p.product_cd = a.product_cd;

# 10-3
select a.account_id, a.product_cd,
i.fname, i.lname, b.name
from account a left outer join business b
on a.cust_id = b.cust_id
left outer join individual i
on a.cust_id = i.cust_id;

# 10-4
select 1 + ones.num + tens.num
from
(select 0 num union all
select 1 num union all
select 2 num union all
select 3 num union all
select 4 num union all
select 5 num union all
select 6 num union all
select 7 num union all
select 8 num union all
select 9 num) ones
cross join
(select 0 num union all
select 10 num union all
select 20 num union all
select 30 num union all
select 40 num union all
select 50 num union all
select 60 num union all
select 70 num union all
select 80 num union all
select 90 num) tens;
