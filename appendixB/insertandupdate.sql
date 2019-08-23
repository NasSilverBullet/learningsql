# B.2 insert と update の組み合わせ
/* レコードがあれば更新、なければ作成するパターン */
create table branch_usage
(branch_id smallint unsigned not null,
cust_id smallint unsigned not null,
last_visited_on datetime,
constraint pk_branch_usage primary key (branch_id, cust_id))

/* 1回目は良いが次回以降は失敗する */
insert into branch_usage (branch_id, cust_id, last_visited_on)
values (1, 5, current_timestamp());
/* ERROR 1062 (23000) at line 2: Duplicate entry '1-5' for key 'PRIMARY' */

/* このパターンを回避できる(存在したら更新する) */
insert into branch_usage (branch_id, cust_id, last_visited_on)
values (1, 5, current_timestamp())
on duplicate key update last_visited_on = current_timestamp();
