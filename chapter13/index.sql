# 13.1 インデックス
/* テーブルのすべての行を調べなくても、テーブルの行や列の部分集合を取得できるようにする */

/* インデックスの作成(オプションコンポーネントとして扱われるため、table作成時に設定できない) */
alter table department
add index dept_name_idx (name);

/* インデックスを調べる */
show index from department;

/* インデックスの削除 */
alter table department
drop index dept_name_idx;

/* 一意のインデックス */
/* 通常のインデックスの利点 + ユニークであることを保証する */
alter table department
add unique dept_name_idx (name);

/* 一意じゃないからエラーになる */
/* ERROR 1062 (23000) at line 2: Duplicate entry 'Operations' for key 'dept_name_idx' */
insert into department (dept_id, name)
values (999, 'Operations');

/* 複数列のインデックスも可能 */
alter table employee
add index emp_name_idx (lname, fname);

/* インデックスが使用される仕組み */
alter table account
add index acc_bal_idx (cust_id, avail_balance);

/*
上の変更を加えることにより、possible_keys、keyが fk_a_cust_id から acc_bal_idx になる
rows も 24 => 9 に変更される
 */
explain select cust_id, sum(avail_balance) tot_bal
from account
where cust_id in (1, 5, 9, 11)
group by cust_id;
