# B.4 複数テーブルの update と delete

create table individual2 as
select * from individual;

create table customer2 as
select * from customer;

create table account2 as
select * from account;

/* 3つのテーブルにおける delete */
delete from account2
where cust_id = 1;

delete from customer2
where cust_id = 1;

delete from individual2
where cust_id = 1;

/* 上をひとつの delete 文で行う */
delete account2, customer2, individual2
from account2 inner join customer2
on account2.cust_id = customer2.cust_id
inner join individual2
on customer2.cust_id = individual2.cust_id
where individual2.cust_id = 1;

/* select とほぼ同じ文法で delete できる */
select account2.account_id
from account2 inner join customer2
on account2.cust_id = customer2.cust_id
inner join individual2
on individual2.cust_id = customer2.cust_id
where individual2.fname = 'John'
and individual2.lname = 'Hayward';

/* 上と同じ構造の delete */
delete account2
from account2 inner join customer2
on account2.cust_id = customer2.cust_id
inner join individual2
on individual2.cust_id = customer2.cust_id
where individual2.fname = 'John'
and individual2.lname = 'Hayward';

/* 複数のテーブルを update */
update individual2 inner join customer2
on individual2.cust_id = customer2.cust_id
inner join account2
on customer2.cust_id = account2.cust_id
set individual2.cust_id = individual2.cust_id + 10000,
account2.cust_id = customer2.cust_id + 10000
where individual2.cust_id = 3;
