# 4.1 条件の評価

## カッコの使用
select *
from employee
where end_date is null
and (title = 'Teller' or start_date < '2003-01-01');

## not 演算子の使用
select *
from employee
where end_date is null
and not (title = 'Teller' or start_date < '2003-01-01');

## not 演算子の使用は避け、下記のように書く
select *
from employee
where end_date is null
and (title != 'Teller' and start_date >= '2003-01-01');

# 4.2 条件の構築

## 等価条件
/*
title = 'Teller'
dept_id = (select dept_id from department where name = 'Loans'
**/

# 4.3 条件の種類

## 等価条件
select pt.name product_type, p.name product
from product p inner join product_type pt
on p.product_type_cd = pt.product_type_cd
where pt.name = 'Customer Accounts';

## 不等価条件
select pt.name product_type, p.name product
from product p inner join product_type pt
on p.product_type_cd = pt.product_type_cd
where pt.name != 'Customer Accounts';
## 等価条件を利用したデータの変更
delete from account
where status = 'CLOSED' and year(close_date) = 1999;

## 範囲条件
select emp_id, fname, lname, start_date
from employee
where start_date < '2003-01-01';

/* 下限指定 **/
select emp_id, fname, lname, start_date
from employee
where start_date < '2003-01-01'
and start_date >= '2001-01-01';

/* between 条件 **/
select emp_id, fname, lname, start_date
from employee
where start_date between '2001-01-01' and '2003-01-01';
/* 下限も上限も含む野で注意 下と同義 **/
select emp_id, fname, lname, start_date
from employee
where start_date >= '2001-01-01';
and start_date <= '2003-01-01'

/* 3000 と 5000 が入ってる **/
select account_id, product_cd, cust_id, avail_balance
from account
where avail_balance between 3000 and 5000;

## 文字列の範囲
select cust_id, fed_id
from customer
where cust_type_cd = 'I'
and fed_id between '500-00-0000' and '999-99-9999'
/*
文字列の範囲を扱うためには文字列の順番を調べる必要がある
文字セットの文字の順序 > 照合順序
 **/

## メンバーシップ条件(in)
select account_id, product_cd, cust_id, avail_balance
from account
where product_cd = 'CHK' or product_cd = 'SAV'
or product_cd = 'CD' or product_cd = 'MM';
/* 上はだるいので下のように in を使う **/
select account_id, product_cd, cust_id, avail_balance
from account
where product_cd in ('CHK', 'SAV', 'CD', 'MM');

## サブクエリの使用
/*
上の条件は product_type_cd = 'ACCOUNT' という条件でも絞れる
サブクエリを使用し、別テーブルから条件取得
**/
select account_id, product_cd, cust_id, avail_balance
from account
where product_cd in (select product_cd from product
where product_type_cd = 'ACCOUNT');

## not in 演算子
select account_id, product_cd, cust_id, avail_balance
from account
where product_cd not in ('CHK', 'SAV', 'CD', 'MM');

## 部分一致
select emp_id, fname, lname
from employee
where left(lname, 1) = 'T';
# 左から1文字目 が T

## ワイルドカード
select lname
from employee
where lname like '_a%e%';
/*
_ : 1文字
% : 任意数(0を含む)の文字
**/

select cust_id, fed_id
from customer
where fed_id like '___-__-____';

select emp_id, fname, lname
from employee
where lname like 'F%' or lname like 'G%';

## 正規表現の使用
select emp_id, fname, lname
from employee
where lname regexp '^[FG]';

## null について
/* null を判定するときは is null 演算子を使う **/
select emp_id, fname, lname, superior_emp_id
from employee
where superior_emp_id is null;
/* 下はできない **/
select emp_id, fname, lname, superior_emp_id
from employee
where superior_emp_id = null;

/* !null を判定するときは is not null 演算子を使う **/
select emp_id, fname, lname, superior_emp_id
from employee
where superior_emp_id is not null;

select emp_id, fname, lname, superior_emp_id
from employee
where superior_emp_id != 6;
/* 上では superior_emp_id が null の レコードが含まれない **/

select emp_id, fname, lname, superior_emp_id
from employee
where superior_emp_id != 6 or superior_emp_id is null;
/* データ漏れがないようにデータの構造をよく理解する **/
