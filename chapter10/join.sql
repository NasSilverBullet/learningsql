# 10.1 外部結合
/* 結合できたらするかんじ、できなくても結果クエリ出力する */
select a.account_id, a.cust_id, b.name
from account a left outer join business b /* left にあるものはすべて出力する */
on a.cust_id = b.cust_id;

select a.account_id, a.cust_id, i.fname, i.lname
from account a left outer join individual i
on a.cust_id = i.cust_id;

/* 左外部結合 */
select c.cust_id, b.name
from customer c left outer join business b
on c.cust_id = b.cust_id;

/* 右外部結合 */
select c.cust_id, b.name
from customer c right outer join business b
on c.cust_id = b.cust_id;

/* 3段の外部結合 */
select a.account_id, a.product_cd,
concat(i.fname, ' ', i.lname) person_name,
b.name business_name
from account a left outer join individual i
on a.cust_id = i.cust_id
left outer join business b
on a.cust_id = b.cust_id;

/* 外部結合で作成したサブクエリに外部結合 */
select account_ind.account_id, account_ind.product_cd,
account_ind.person_name,
b.name business_name
from
(select a.account_id, a.product_cd, a.cust_id,
concat(i.fname, ' ', i.lname) person_name
from account a left outer join individual i
on a.cust_id = i.cust_id) account_ind
left outer join business b
on account_ind.cust_id = b.cust_id;

/* 自己外部結合 */
/* 下だと上司のいない頭取が出てこない */
select e.fname, e.lname,
e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
from employee e inner join employee e_mgr
on e.superior_emp_id = e_mgr.emp_id;

/* lef outer join で頭取も含まれる */
select e.fname, e.lname,
e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
from employee e left outer join employee e_mgr
on e.superior_emp_id = e_mgr.emp_id;

/* left を rigth にかえるだけでまったくことなった結果になる */
select e.fname, e.lname,
e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
from employee e right outer join employee e_mgr
on e.superior_emp_id = e_mgr.emp_id;

# 10.2 直積
/* デカルト積(結合条件を一切指定せずに複数のテーブルを結合する) */
select pt.name, p.product_cd, p.name
from product p cross join product_type pt;

/* ほぼ使わないが下記のときのように桁ごとに足すとかのときに抽象化に役立つ */
select ones.num + tens.num + hundreds.num
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
select 90 num) tens
cross join
(select 0 num union all
select 100 num union all
select 200 num union all
select 300 num) hundreds;

/* こんなことができる */
select days.dt, count(a.account_id)
from account a right outer join
(select date_add('2004-01-01',
interval (ones.num + tens.num + hundreds.num) day) dt
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
select 90 num) tens
cross join
(select 0 num union all
select 100 num union all
select 200 num union all
select 300 num) hundreds
where date_add('2004-01-01',
interval(ones.num + tens.num + hundreds.num) day) < '2005-01-01') days
on days.dt = a.open_date
group by days.dt
order by days.dt;

# 10.3 自然結合
/* account と customer の cust_id を探して結合する */
select a.account_id, a.cust_id, c.cust_type_cd, c.fed_id
from account a natural join customer c;

/* 完全に名前が同じじゃないとうまくいかないので普通の内部結合を使う */
select a.account_id, a.cust_id, a.open_branch_id, b.name
from account a natural join branch b;
