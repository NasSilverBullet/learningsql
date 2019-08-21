# 8.1 グループ化

select open_emp_id
from account
group by open_emp_id;

/** 集約関数 */
select open_emp_id, count(*) how_many
from account
group by open_emp_id;

/** where 節は グループ化前に実行される */
select open_emp_id, count(*) how_many
from account
where count(*) > 4
group by open_emp_id, product_cd;
/** ERROR 1111 (HY000) at line 2: Invalid use of group function */

/** グループ化にフィルタを追加したいときは having を足す */
select open_emp_id, count(*) how_many
from account
group by open_emp_id
having count(*) > 4;

# 8.2 集約関数
select max(avail_balance) max_balance,
min(avail_balance) min_balance,
avg(avail_balance) avg_balance,
sum(avail_balance) tot_balance,
count(*) num_accounts
from account
where product_cd = 'CHK';
/** グループ化 がレコード全体に行われている */
/** 暗黙的なグループ */

/** 明示的なグループ */
select product_cd, -- ここと
  max(avail_balance) max_balance,
  min(avail_balance) min_balance,
  avg(avail_balance) avg_balance,
  sum(avail_balance) tot_balance,
  count(*) num
from account
group by product_cd; -- ここが同じ

select count(open_emp_id) /** count(*) と同じ */
from account;

select count(distinct open_emp_id)
from account;

/** 式の利用 */
select max(pending_balance - avail_balance) max_uncleared
from account;

/** null を処理する方法 */
/** 準備 */
create table number_tbl
(val smallint);
insert into number_tbl values (1);
insert into number_tbl values (3);
insert into number_tbl values (5);

select count(*) num_rows, -- 3
count(val) num_vals, -- 3
sum(val) total, -- 9
max(val) max_val, -- 5
avg(val) avg_val -- 3.0000
from number_tbl;

insert into number_tbl values (null);

select count(*) num_rows, -- 4
count(val) num_vals, -- 3 それぞれの値を対象にした場合はnullを無視する
sum(val) total, -- 9
max(val) max_val, -- 5
avg(val) avg_val -- 3.0000
from number_tbl;

# 8.3 グループの生成
/** 単一列でのグループ化 */
select product_cd, sum(avail_balance) product_balance
from account
group by product_cd;

/** 複数列でのグループ化 */
select product_cd, open_branch_id,
sum(avail_balance) tot_balance
from account
group by product_cd, open_branch_id;

/** 式によるグループ化 */
select extract(year from start_date) year,
count(*) how_many
from employee
group by extract(year from start_date);

/** 小計値の生成 */
select product_cd, open_branch_id,
sum(avail_balance) tot_balance
from account
group by product_cd, open_branch_id with rollup; /* 小計値が追加される */
/* rollup をつけてあげたカラムが null として小計値を示す */

# 8.4 グループのフィルタ条件
select product_cd, sum(avail_balance) product_balance
from account
where status = 'ACTIVE'
group by product_cd
having sum(avail_balance) >= 10000;

select product_cd, sum(avail_balance) product_balance
from account
where status = 'ACTIVE'
group by product_cd
having sum(avail_balance) >= 10000
and max(avail_balance) <= 10000;
