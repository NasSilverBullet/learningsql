# B.1 select 文の拡張機能

/* limit */
select open_emp_id, count(*) how_many
from account
group by open_emp_id;

/* 取得できるレコードを制限する */
select open_emp_id, count(*) how_many
from account
group by open_emp_id
limit 3;

/* limit と oder by の組み合わせをする(ランク付けクエリ) */
/* 最も多くの口座を開いた上位三名を取得できる */
select open_emp_id, count(*) how_many
from account
group by open_emp_id
order by how_many desc
limit 3;

/* 第三位の出納係の検索 */
select open_emp_id, count(*) how_many
from account
group by open_emp_id
order by how_many desc
limit 2, 1; -- １つ目の引数 -> 先頭行(0オリジン) 2つめの引数 -> 表示する行

/* 第三位以降の出納係の検索 */
select open_emp_id, count(*) how_many
from account
group by open_emp_id
order by how_many desc
limit 2, 9999999;


# B.2 into outfile 節
/* ファイルに書き出す */
select emp_id, fname, lname, start_date
into outfile '~/go/src/github.com/NasSilverBullet/learningsql/appendixB/emp_list.txt'
from employee;

/* 区切り文字を変更できる */
select emp_id, fname, lname, start_date
into outfile '$GOPATH/src/github.com/NasSilverBullet/learningsql/appendixB/emp_list.txt'
fields terminated by '|'
from employee;

/* 改行文字も変更できる */
select emp_id, fname, lname, start_date
into outfile '$GOPATH/src/github.com/NasSilverBullet/learningsql/appendixB/emp_list_atsign.txt'
fields terminated by '|'
lines terminated by '@'
from employee;
