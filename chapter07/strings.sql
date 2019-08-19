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
