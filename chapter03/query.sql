# 3.1 クエリの仕組み

## クエリの結果は結果セットという新しいテーブル
select emp_id, fname lname
from employee
where lname = 'Bkadfl';
## Empty set

select fname, lname
from employee
