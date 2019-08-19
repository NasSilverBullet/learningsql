# 7.1 文字列データの操作
/*
char : 固定長(文末が空白文字で埋められる)
varchar : 可変長
text : 可変長(長い)
**/

create table string_tbl
(char_fld char(30),
vchar_fld varchar(30),
text_fld text
);

## 文字列の生成
insert into string_tbl (char_fld, vchar_fld, text_fld)
values ('This is char  data',
'This is varchar data',
'This is text data');

## 溢れたとき
update string_tbl
set vchar_fld = 'This is a piece of extremely long varchar data';
/* バージョンアップでオーバーフローエラーになった **/

## クオートが使用されたとき
update string_tbl
set text_fld = 'This string did''t work, but it does now';
/* 普通のエスケープもできる **/
update string_tbl
set text_fld = 'This string did\'t work, but it does now';

/* そのまま取得できる **/
select text_fld
from string_tbl;
/* が、エクスポートする場合はquote()を使ってエスケープするべき **/
select quote(text_fld)
from string_tbl;

## 特殊文字
/* ascii 文字セットから文字列を生成する char() **/
select 'abcdefg', char(97, 98, 99, 100, 101, 102, 103);

select char(128, 129, 130, 131, 132, 133, 134, 135, 136, 137)

/* concat を使用することで特殊文字を文中で使用した文字列を容易く作成できる **/
select concat('danke sch', char(148), 'n');


# 7.1.2 文字列操作
/** 掃除 */
delete from string_tbl; # 掃除
insert into string_tbl (char_fld, vchar_fld, text_fld)
values ('This string is 28 characters',
'This string is 28 characters',
'This string is 28 characters');

## 数値を返す文字列関数
/** length */
select length(char_fld) char_length, /** char は固定長だが、select 時に行末の空白を削除するため、28文字となる */
length(vchar_fld) varchar_length,
length(text_fld) text_length
from string_tbl;

/** position 位置検索*/
select position('characters' in vchar_fld)
from string_tbl;
/** 検索に失敗した場合は0 */

/** locate 位置検索(開始位置を設定できる) */
select locate('is', vchar_fld, 5) /** 開始位置 */
from string_tbl;

/** strcmp 文字列比較関数 */
/** 掃除 */
delete from string_tbl;
insert into string_tbl(vchar_fld) values ('abcd');
insert into string_tbl(vchar_fld) values ('xyz');
insert into string_tbl(vchar_fld) values ('QRSTUV');
insert into string_tbl(vchar_fld) values ('qrstuv');
insert into string_tbl(vchar_fld) values ('12345');

select vchar_fld
from string_tbl
order by vchar_fld;

select strcmp('12345', '12345') 12345_12345, # 0
strcmp('abcd', 'xyz') abcd_xyz, # -1
strcmp('abcd', 'QRSTUV') abcd_qrstuv, # -1
strcmp('qrstuv', 'QRSTUV') qrstuv_QRSTUV, # 0 ケースにオーダーはない
strcmp('12345', 'xyz') 12345_xyz, # -1
strcmp('xyz', 'qrstuv') xyz_qrstuv; # 1

select name, name like '%ns' ends_in_ns # ns で終わっている場合は1が返る
from department;

select cust_id, cust_type_cd, fed_id,
fed_id regexp '.{3}-.{2}-.{4}' is_ss_no_format # 正規表現に一致した場合に1を返す
from customer;

## 文字列を返す文字列関数
/** 掃除 */
delete from string_tbl;
insert into string_tbl (text_fld)
values ('This string was 29 characters');

update string_tbl
set text_fld = concat(text_fld, ', but now it is longer');

select text_fld
from string_tbl;

/** 文字列を組み立てる */
select concat(fname, ' ', lname, ' has been a ',
title, ' since', start_date) emp_narrative
from employee
where title = 'Teller' or title = 'Head Teller';

/** 置換 */
/** 3つ目の引数に0を指定することで挿入する */
select insert('goodbye world', 9, 0, 'cruel ') string;
/** 3つ目の引数に指定した値までを置換する */
select insert('goodbye world', 1, 7, 'hello') string;

/** 抽出 */
select substring('goodbye cruel world', 9, 5); # 9番目から5番目
