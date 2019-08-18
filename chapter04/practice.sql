# 4.5 練習問題

# 4-1
1, 2, 3, 5, 6, 7

# 4-2
4, 9

# 4-3
select account_id, open_date
from account
where year(open_date) = 2002;
/* 模範解答 **/
select account_id, open_date
from account
where open_date between '2002-01-01' and '2002-12-31';

# 4-4
select cust_id, lname, fname
from individual
where lname like '_a%e%';
