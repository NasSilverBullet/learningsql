# 7.3 タイムゾーン
set global time_zone = timezone;

select @@global.time_zone, @@session.time_zone;

set time_zone = 'Japan';

select @@global.time_zone, @@session.time_zone;

## 時間データの生成
/* 時間データの文字列表現 **/
update transaction
set txn_date = '2005-03-27 15:30:00'
where txn_id = 9999;

/** 文字列から日付への変換 */
select cast('2005-03-27 15:30:00' as datetime);
/** サーバーが datetime 型の値が渡されることを想定していない場合は、文字列を datetime 型 に変換する必陽に変換がある */

/** date, time */
select cast('2005-03-27' as date) date_field,
cast('108:17:57' as time) time_field;

/** セパレータはかなり柔軟に扱える */
select cast('2005/03/27' as datetime),
cast('2005,03,27,15,30,00' as datetime),
cast('20050327153000' as datetime);

## 日付を生成するための関数
/** str_to_date */
update individual
set birth_date = str_to_date('march 27, 2005', '%M %d, %Y')
where cust_id = 9999;

/** current 系 */
select current_date(), current_time(), current_timestamp();

## 時間データの操作
/** 日付を返す時間関数 */
/** date_add */
select date_add(current_date(), interval 5 day);

update transaction
set txn_date = date_add(txn_date, interval '3:27:11' hour_second)
where txn_id = 9999;

update employee
set birth_date = date_add(birth_date, interval '9-11' year_month)
where emp_id = 4789;

/** last_day */
select last_day('2005-03-25');

/** convert_tz */
select current_timestamp() current_est,
convert_tz(current_timestamp(), 'US/Eastern', 'UTC') current_utc;

/** dayname 曜日 */
select dayname('2005-03-22');

/** extract 抽出 */
select extract(year from '2005-03-22 22:19:05');

/** datediff 期間 */
select datediff('2005-09-05', '2005-06-22');
/** 時刻は無視される */
select datediff('2005-09-05 23:59:59', '2005-06-22 00:00:01')
/** 古い日付を先にした場合、負数になる */ */
select datediff('2005-06-22', '2005-09-05');
