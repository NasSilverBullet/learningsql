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
where open_emp_id <> (select e.emp_id -- != でもいける
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

/* updete */
update account a
set a.last_activity_date =
  (select max(t.txn_date)
  from transaction t
  where t.account_id = a.account_id);

/* null で上書くことを防止 */
update account a
set a.last_activity_date =
  (select max(t.txn_date)
  from transaction t
  where t.account_id = a.account_id)
where exists (select 1 -- ここで防止している
  from transaction t
  where t.account_id = a.account_id);

/* delete 存在しなかったら */
delete from department
where not exists (select 1
  from employee
  where employee.dept_id = department.dept_id);

/* delete相関サブクエリでもエイリアス使える... */
delete from department d
where not exists (select 1
  from employee e
  where e.dept_id = d.dept_id);

# 9.5 サブクエリを使用する状況

/* データソースとしてのサブクエリ */
select d.dept_id, d.name, e_cnt.how_many num_employees
from department d inner join
(select dept_id, count(*) how_many
from employee
group by dept_id) e_cnt
on d.dept_id = e_cnt.dept_id;

/* サブクエリが生成するテーブル */
select dept_id, count(*) how_many
from employee
group by dept_id;

/* 仮想テーブルの作成 */
select 'Small Fry' name, 0 low_limit, 4999.99 high_limit
union all
select 'Average Joes' name, 5000 low_limit, 9999.99 high_limit
union all
select 'Heavy Hitters' name, 10000 low_limit, 9999999.99 high_limit;

/* 顧客グループの生成するためのクエリのfromに仮想テーブルを追加 */
# [TODO] 動かないので動かす
select groups.name, count(*) num_customers
from
(select sum(a.avail_balance) cust_balance
from account a inner join product p
on a.product_cd = p.product_cd
where p.product_type_cd = 'ACCOUNT'
group by a.cust_id) cust_rollup inner join
(select 'Small Fry' name, 0 low_limit, 4999.99 high_limit
union all
select 'Average Joes' name, 5000 low_limit,
9999.99 high_limit
union all
select 'Heavy Hitters' name, 10000 low_limit,
9999999.99 high_limit) groups
on cust_rollup.cust_balance
between groups.low_limit and groups.high_limit
group by groups.name;

/* サブクエリを使わないのっぺり(最後に group by) */
select p.name product, b.name branch,
concat(e.fname, ' ', e.lname) name,
sum(a.avail_balance) tot_deposits
from account a inner join employee e
on a.open_emp_id = e.emp_id
inner join branch b
on a.open_branch_id = b.branch_id
inner join product p
on a.product_cd = p.product_cd
where product_type_cd = 'ACCOUNT'
group by p.name, b.name, e.fname, e.lname;

/* サブクエリを使った立体的クエリ(group byをさきにやる) */
select p.name product, b.name branch,
concat(e.fname, ' ', e.lname) name,
account_groups.tot_deposits
from
(select product_cd, open_branch_id branch_id,
open_emp_id emp_id,
sum(avail_balance) tot_deposits
from account
group by product_cd, open_branch_id, open_emp_id) account_groups
inner join employee e on e.emp_id = account_groups.emp_id
inner join branch b on b.branch_id = account_groups.branch_id
inner join product p on p.product_cd = account_groups.product_cd
where p.product_type_cd = 'ACCOUNT';

/* サブクエリだけ抜き出したもの(ここですでにgroup by している) */
select product_cd, open_branch_id branch_id, open_emp_id emp_id,
sum(avail_balance) tot_deposits
from account
group by product_cd, open_branch_id, open_emp_id;

/* フィルタ条件のサブクエリ */
select open_emp_id, count(*) how_many
from account
group by open_emp_id
having count(*) = (select max(emp_cnt.how_many) -- 最大と一致したレコードを表示
from (select count(*) how_many
from account
group by open_emp_id) emp_cnt);

/* 式ジェネレータとしてのサブクエリ */
select
(select p.name from product p
where p.product_cd = a.product_cd
and p.product_type_cd = 'ACCOUNT') product,
(select b.name from branch b
where b.branch_id = a.open_branch_id) branch,
(select concat(e.fname, ' ', e.lname) from employee e
where e.emp_id = a.open_emp_id) name,
sum(a.avail_balance) tot_deposits
from account a
group by a.product_cd, a.open_branch_id, a.open_emp_id;

/* 上の結果クエリから null を除去 */
select all_prods.product, all_prods.branch,
all_prods.name, all_prods.tot_deposits
from
(select
  (select p.name from product p
    where p.product_cd = a.product_cd
    and p.product_type_cd = 'ACCOUNT') product,
  (select b.name from branch b
    where b.branch_id = a.open_branch_id) branch,
  (select concat(e.fname, ' ', e.lname) from employee e
    where e.emp_id = a.open_emp_id) name,
  sum(a.avail_balance) tot_deposits
    from account a
    group by a.product_cd, a.open_branch_id, a.open_emp_id) all_prods
where all_prods.product is not null;

/* スカラーサブクエリは order by 節でも使用可能 */
select emp.emp_id, concat(emp.fname, ' ', emp.lname) emp_name,
(select concat(boss.fname, ' ', boss.lname)
  from employee boss
  where boss.emp_id = emp.superior_emp_id) boss_name
from employee emp
where emp.superior_emp_id is not null
order by (select boss.lname from employee boss
  where boss.emp_id = emp.superior_emp_id), emp.lname;

/* insert */
insert into account
(account_id, product_cd, cust_id, open_date, last_activity_date,
  status, open_branch_id, open_emp_id, avail_balance, pending_balance)
values (null,
  (select product_cd from product where name = 'savings account'),
  (select cust_id from customer where fed_id = '555-55-5555'),
  '2005-01-25', '2005-01-25', 'ACTIVE',
  (select branch_id from branch where name = 'Quincy Bnrach'),
  (select emp_id from employee where lname = 'Portman' and fname = 'Frank'),
  0, 0);
