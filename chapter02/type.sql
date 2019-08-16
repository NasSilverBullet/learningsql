-- 2.3 MySQL のデータ型

-- 2.3.1 文字データ

char(20) -- 固定長
varchar(20) -- 可変長

show character set; -- 文字セットの表示

-- デフォルト文字セット以外を選択する際は下記のようにする
varchar(20) character set utf8

-- データベース全体のデフォルト文字セットを設定する
create database foreign_sales character set utf8;

--- 255文字を超える場合はテキスト型を使用する

-- 2.3.2 数値データ

-- primary key  は unsigned

-- 2.3.3 時間データ

/*
生年月日 : date
注文 : datetime
いつ変更したか : timestamp(その時の日時が自動挿入)
期間 : time
**/

-- 2.3 MySQL のデータ型

-- 2.3.1 文字データ

char(20) -- 固定長
varchar(20) -- 可変長

show character set; -- 文字セットの表示

-- デフォルト文字セット以外を選択する際は下記のようにする
varchar(20) character set utf8

-- データベース全体のデフォルト文字セットを設定する
create database foreign_sales character set utf8;

--- 255文字を超える場合はテキスト型を使用する

-- 2.3.2 数値データ

-- primary key  は unsigned

-- 2.3.3 時間データ

/*
生年月日 : date
注文 : datetime
いつ変更したか : timestamp(その時の日時が自動挿入)
期間 : time
**/
