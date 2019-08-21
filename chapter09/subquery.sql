# 9.1 サブクエリ
/*
列が1つ含まれた1行のデータ
列が1つ含まれた複数行のデータ
複数の列が含まれた複数行のデータ
*/

select account_id, product_cd, cust_id, avail_balance
from account
where account_id = (select max(account_id) from account);

/* 以下のようなサブクエリが含まれる */
select max(account_id) from account;

/* つまりこう */
select account_id, product_cd, cust_id, avail_balance
from account
where account_id = 29;

# 9.2 サブクエリの種類
/*
非相関サブクエリ : そのままサブクエリの結果を使う
相関サブクエリ : 含む側の文に依存する
*/

# 9.3 非相関サブクエリ
/* 1 : 1 のサブクエリ使用パターン */
select account_id, product_cd, cust_id, avail_balance
from account
where open_emp_id <> (select e.emp_id
from employee e inner join branch b
on e.assigned_branch_id = b.branch_id
where e.title = 'Head Teller' and b.city = 'Woburn');

/* 1 : n のサブクエリ使用パターン */
/* in 演算子 */
select emp_id, fname, lname, title
from employee
where emp_id in (select superior_emp_id
from employee);

/* サブクエリに重複があっても in のときは関係ない*/
select superior_emp_id
from employee;

/* not in 演算子 */
select emp_id, fname, lname, title
from employee
where emp_id not in (select superior_emp_id
from employee
where superior_emp_id is not null);
/* null と比較すると unknown が返り、0件になってしまうので取り除く */

/* all 演算子 > 全てと比較し、ok のレコードのみ返る*/
select account_id, cust_id, product_cd, avail_balance
from account
where avail_balance < all (select a.avail_balance
from account a inner join individual i
on a.cust_id = i.cust_id
where i.fname = 'Frank' and i.lname = 'Tucker');

/* 以下のようなサブクエリが含まれる */
select a.avail_balance
from account a inner join individual i
on a.cust_id = i.cust_id
where i.fname = 'Frank' and i.lname = 'Tucker';

/* any 演算子 > 一つでも条件に合致すれば返す */
select account_id, cust_id, product_cd, avail_balance
from account
where avail_balance > any (select a.avail_balance
from account a inner join individual i
on a.cust_id = i.cust_id
where i.fname = 'Frank' and i.lname = 'Tucker');

/* 複数列のサブクエリ */
select account_id, product_cd, cust_id
from account
where open_branch_id = (select branch_id
from branch
where name = 'Woburn Branch')
and open_emp_id in (select emp_id
from employee
where title = 'Teller' or title = 'Head Teller');

/* べつのかきかた */
select account_id, product_cd, cust_id
from account
where (open_branch_id, open_emp_id) in -- サブクエリの branch_id は 1つなので in で大丈夫
(select b.branch_id, e.emp_id
from branch b inner join employee e
on b.branch_id = e.assigned_branch_id
where b.name = 'Woburn Branch'
and (e.title = 'Teller' or e.title = 'Head Teller'));

select 'ALERT! : Account #1 Has Incorrect Balance!'
from account
where (avail_balance, pending_balance) <>
  (select sum(/* 確定残高を生成するための式*/),
    sum(/* 暫定残高を生成するための式 */)
  from transaction
  where account_id = 1)
  and account_id = 1;

# 9.4 相関サブクエリ
select c.cust_id, c.cust_type_cd, c.city
from customer c
where 2 = (select count(*)
from account a
where a.cust_id = c.cust_id); -- 含む側を参照している

select c.cust_id, c.cust_type_cd, c.city
from customer c
where (select sum(a.avail_balance)
from account a
where a.cust_id = c.cust_id)
between 5000 and 100000;


/* 下のやつが */
select 'ALERT! : Account #1 Has Incorrect Balance!'
from account
where (avail_balance, pending_balance) <>
  (select sum(/* 確定残高を生成するための式*/),
    sum(/* 暫定残高を生成するための式 */)
  from transaction
  where account_id = 1)
  and account_id = 1;

/* これなら一発でできる */
select concat('ALERT! : Account #', a.account_id,
  'Has Incorrect Balance!')
from account a
where (a.avail_balance, a.pending_balance) <>
(select sum(/* 確定残高を生成するための式 */),
  sum(/* 暫定残高を生成するための式*/)
from transaction t
where t.account_id = a.account_id);

/* exists 演算子 */
select a.account_id, a.product_cd, a.cust_id, a.avail_balance
from account a
where exists (select 1
  from transaction t
  where t.account_id = a.account_id
  and t.txn_date = '2002-11-23');

/* サブクエリから何を返してもよいが意味がない(だから上では1という適当な値を返してる) */
select a.account_id, a.product_cd, a.cust_id, a.avail_balance
from account a
where exists (select t.txn_id, 'hello', 3.14115927
  from transaction t
  where t.account_id = a.account_id
  and t.txn_date = '2002-11-23');
/* だが、select 1 または select * を指定する決まりになっている */

/* not exists 演算子 */
select a.account_id, a.product_cd, a.cust_id
from account a
where not exists (select 1
from business b
where b.cust_id = a.cust_id);
