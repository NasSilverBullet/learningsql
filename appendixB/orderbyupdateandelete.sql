# B.3 順序付けされた update と delete
create table login_history
(cust_id integer unsigned not null,
login_date datetime,
constraint pk_login_history primary key (cust_id, login_date)
);

insert into login_history (cust_id, login_date)
select c.cust_id,
adddate(a.open_date, interval a.account_id * c.cust_id hour)
from customer c cross join account a;

select count(*) histories_num
from login_history; -- 325

/* 最新の50行以外を削除する */
delete from login_history
order by login_date asc
limit 325 - 50;

/* update もorder by & limit できる */
update account
set avail_balance = avail_balance + 100
where product_cd i ('CHK', 'SAV', 'MM')
order by open_date asc
limit 10;
