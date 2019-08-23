# 制約の作成

create table product
 (product_cd varchar(10) not null,
  name varchar(50) not null,
  product_type_cd varchar(10) not null,
  date_offered date,
  date_retired date,
  constraint fk_product_type_cd foreign key (product_type_cd)
    references product_type (product_type_cd),
  constraint pk_product primary key (product_cd)
 );

/* 制約の連鎖 */
/* ERROR 1452 (23000) at line 2: Cannot add or update a child row: a foreign key constraint fails */
/* 外部キーは、親行に存在しなければ、子行を変更できないようにする */
update product
set product_type_cd = 'XYZ'
where product_type_cd = 'LOAN';

/* 外部キーで参照されているため更新できない */
/*ERROR 1451 (23000) at line 2: Cannot delete or update a parent row: a foreign key constraint fails */
update product_type
set product_type_cd = 'XYZ'
where product_type_cd = 'LOAN';

/* 連鎖更新可能な on update cascade を含む外部キーを作成する */
alter table product
drop foreign key fk_product_type_cd;

alter table product
add constraint fk_product_type_cd foreign key (product_type_cd)
references product_type (product_type_cd)
on update cascade;

/* 更新が成功する */
update product_type
set product_type_cd = 'XYZ'
where product_type_cd = 'LOAN';

/* LOAN が XYZ に変更されている */
select product_type_cd, name
from product_type;

/* 参照している側でも変更されているため */
select product_type_cd, product_cd, name
from product
order by product_type_cd;

/* 連鎖削除 */
alter table product
add constraint fk_product_type_cd foreign key (product_type_cd)
  references product_type (product_type_cd)
  on update cascade
  on delete cascade; -- この一行で 連鎖削除も可能になる
