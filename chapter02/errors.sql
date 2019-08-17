# 2.6 文も使い方次第

# 一意でない主キー
insert into person
(person_id, fname, lname, gender, birth_date)
value (1, 'Charles', 'Fulton', 'M', '1968-01-15');
## ERROR 1062 (23000) at line 2: Duplicate entry '1' for key 'PRIMARY'

# 存在しない外部キー
insert into favorite_food (person_id, food)
values (999, 'lasagna');
## ERROR 1216 (23000) at line 2: Cannot add or update a child row: a foreign key constraint fails

# 列値の違反
update person
set gender = 'Z'
where person_id = 1;
## ERROR 1265 (01000) at line 2: Data truncated for column 'gender' at row 1
## おそらくversion up で waring ではなくなった

show warings;

## 無効なひづけの変換
update person
set birth_date = 'DEC-21-1980'
where person_id = 1;
## ERROR 1292 (22007) at line 2: Incorrect date value: 'DEC-21-1980' for column 'birth_date' at row 1
## おそらくversion up で waring ではなくなった
