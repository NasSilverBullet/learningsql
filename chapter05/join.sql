# 5.1 結合

## デカルト積
select e.fname, e.lname, d.name
from employee e join department d;
/*
デカルト積
すべての組み合わせを表示する
ほぼいらない
**/

## 内部結合
select e.fname, e.lname, d.name
from employee e inner join department d
on e.dept_id = d.dept_id;
/*
一致するものが存在するかどうかにかかわらず
一方のテーブルに存在する行がすべて含まれるようにしたい場合
outer join
**/

## using (結合に使用するカラム名が同じ場合)
select e.fname, e.lname, d.name
from employee e inner join department d
using (dept_id);

# 5.2 3つ以上のテーブルの結合
select a.account_id, c.fed_id, e.fname, lname
from account a inner join customer c
on a.cust_id = c.cust_id
inner join employee e
on a.open_emp_id = e.emp_id
where c.cust_type_cd = 'B';
/*
inner join はすでに存在する結合されたクエリである中間結果セットに結合していくイメージ
そのため、順番は関係ない
**/

## テーブルとしてのサブクエリ
select a.account_id, a.cust_id, a.open_date, a.product_cd
from account a inner join
    (select emp_id, assigned_branch_id
        from employee
        where start_date <= '2003-01-01'
            and (title = 'Teller' or title = 'Head Teller')) e  # 中間結果セットにエイリアスを設定し、テーブルとして利用
    on a.open_emp_id = e.emp_id
inner join
    (select branch_id
        from branch
        where name = 'Woburn Branch') b                         # 中間結果セットにエイリアスを設定し、テーブルとして利用
    on e.assigned_branch_id = b.branch_id;

/* サブクエリを利用しないとこう **/
select a.account_id, a.cust_id, a.open_date, a.product_cd
from account a inner join employee e
on a.open_emp_id = e.emp_id
inner join branch b
on e.assigned_branch_id = b.branch_id
where e.start_date <= '2003-01-01'
and (e.title = 'Teller' or e.title = 'Head Teller')
and b.name = 'Woburn Branch';

## 同じテーブルの複数使用
select a.account_id, e.emp_id,
b_a.name open_branch, b_e.name emp_branch
from account a inner join branch b_a
on a.open_branch_id = b_a.branch_id
inner join employee e
on a.open_emp_id = e.emp_id
inner join branch b_e
on e.assigned_branch_id = b_e.branch_id
where a.product_cd = 'CHK';

# 5.3 自己結合
/*
自己参照外部キー
再帰的に自己参照しているときもエイリアスを設定する
**/
select e.fname, e.lname,
e_mgr.fname mgr_fname, e_mgr.lname mgr_lname
from employee e inner join employee e_mgr
on e.superior_emp_id = e_mgr.emp_id;
/*
頭取には上司がいないため、表示したいときは 外部結合
**/

# 5.4 等結合と非結合

/* 非結合 (=以外で join する)**/
select e.emp_id, e.fname, e.lname, e.start_date
from employee e inner join product p
    on e.start_date >= p.date_offered
        and e.start_date <= p.date_retired
where p.name = 'no-fee checking';

/* 自己非等結合 (=以外で自分のテーブルとjoin する)**/
/* 総当たり戦 **/
select e1.fname, e1.lname, 'VS' vs, e2.fname, e2.lname
from employee e1 inner join employee e2
on e1.emp_id < e2.emp_id
where e1.title = 'Teller' and e2.title = 'Teller';
