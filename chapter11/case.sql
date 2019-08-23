# 12.1 条件ロジック
/* case ... when ... then ... else ... end で 条件分岐できる */
select c.cust_id, c.fed_id,
case
when c.cust_type_cd = 'I'
  then concat(i.fname, ' ', i.lname)
when c.cust_type_cd = 'B'
  then b.name
else 'Unknown'
end name
from customer c left outer join individual i
on c.cust_id = i.cust_id
left outer join business b
on c.cust_id = b.cust_id;

/* 検索 case */
/* 相関サブクエリを利用したcase */
select c.cust_id, c.fed_id,
case
when c.cust_type_cd = 'I' then
  (select concat(i.fname, ' ', i.lname)
    from individual i
    where i.cust_id = c.cust_id)
when c.cust_type_cd = 'B' then
  (select b.name
    from business b
    where b.cust_id = c.cust_id)
else 'Unknown'
end name
from customer c;

/* 単純 case 式 ( case のあとに評価する要素を書く ) */
select c.cust_id, c.fed_id,
case c.cust_type_cd
when 'I' then
  (select concat(i.fname, ' ', i.lname)
    from individual i
    where i.cust_id = c.cust_id)
when 'B' then
  (select b.name
    from business b
    where b.cust_id = c.cust_id)
else 'Unknown Customer Type'
end name
from customer c;

# 11.3 case 式の例
/* 結果セットの変換 */
select year(open_date) year, count(*) how_many
from account
where open_date > '1999-12-31'
group by year(open_date);
/* 上の結果セットの転置 */
select
sum(case
when extract(year from open_date) = 2000 then 1
else 0
end) year_2000,
sum(case
when extract(year from open_date) = 2001 then 1
else 0
end) year_2001,
sum(case
when extract(year from open_date) = 2002 then 1
else 0
end) year_2002,
sum(case
when extract(year from open_date) = 2003 then 1
else 0
end) year_2003,
sum(case
when extract(year from open_date) = 2004 then 1
else 0
end) year_2004,
sum(case
when extract(year from open_date) = 2005 then 1
else 0
end) year_2005
from account
where open_date > '1999-12-31';

/* 選択に基づく集約 */
select concat('ALERT! : Account #', a.account_id,
  ' Has Incorrect Balance!') error
from account a
where (a.avail_balance, a.pending_balance) <>
(select
  sum(case
    when t.funds_avail_date > current_timestamp()
      then 0
    when t.txn_type_cd = 'DBT'
      then t.amount * -1
    else t.amount
  end),
  sum(case
    when t.txn_type_cd = 'DBT'
      then t.amount * -1
    else t.amount
  end)
from transaction t
where t.account_id = a.account_id);

/* 存在の確認 */
select c.cust_id, c.fed_id, c.cust_type_cd,
case
when exists (select 1 from account a
  where a.cust_id = c.cust_id
  and a.product_cd = 'CHK') then 'Y'
  else 'N'
end has_checking,
case
when exists (select 1 from account a
  where a.cust_id = c.cust_id
  and a.product_cd = 'SAV') then 'Y'
  else 'N'
end has_saving
from customer c;

/* ある程度の計算 */
select c.cust_id, c.fed_id, c.cust_type_cd,
case (select count(*) from account a
where a.cust_id = c.cust_id)
when 0 then 'None'
when 1 then '1'
when 2 then '2'
else '3+'
end num_accounts
from customer c;

/* 0による除算エラー */
select 100 / 0;
/* null となる */

/* null除算をハンドリングする*/
select a.cust_id, a.product_cd, a.avail_balance /
case
when prod_tots.tot_balance = 0 then 1 -- 除数が 0 ときに 0とする
else prod_tots.tot_balance
end percent_of_total
from account a inner join
(select a.product_cd, sum(a.avail_balance) tot_balance
from account a
group by a.product_cd) prod_tots
on a.product_cd = prod_tots.product_cd;

/* update */
update account
  set last_activity_date = current_timestamp(),
  pending_balance = pending_balance +
    (select t.amount *
      case t.txn_type_cd when 'DBT' then -1 else 1 end
    from transaction t
    where t.txn_id = 999),
  avail_balance = avail_balance +
    (select
      case
        when t.funds_avail_date > current_timestamp() then 0
        else t.amount *
          case t.txn_type_cd when 'DBT' then -1 else 1 end
      end
    from transaction t
    where t.txn_id = 999)
  where account.account_id =
    (select t.account_id
      from transaction t
      where t.txn_id = 999);

/* null 値の処理 */
select emp_id, fname, lname,
case when title is null then 'Unknown' -- nullと表示されるところを Unknown に書き換えている
else title
end title
from employee;

/* 計算にnull が含まれていると結果も null になる */
select (7 * 5) / ((3 + 14) * null);
/* 処理を補う */
