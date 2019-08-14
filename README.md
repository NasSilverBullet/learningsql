# Learning SQL: Master SQL Fundamentals

![Learning SQL](https://covers.oreillystatic.com/images/9780596007270/lrg.jpg "Learning SQL")

## How to start

```sh
$ git clone https://github.com/NasSilverBullet/learningsql.git
$ cd learningsql
$ find `pwd` -name LearningSQLExample.sql
/path/to/learningsql/LearningSQLExample/LearningSQLExample.sql #copy absolute path
$ mysql -u root
```

in mysql...

```sql
mysql> create user lrngsql@localhost identified by 'xxxxx';
mysql> grant all on *.* to lrngsql@localhost;
mysql> quit;
```

in shell...

```sh
mysql -u lrngsql -p
```

in mysql again...

```sql
mysql> create database bank;
mysql> use bank;
mysql> source {absolute path};
```

start learning sql!!

[Learning SQL: Master SQL Fundamentals](https://www.oreilly.co.jp/books/4873112818/)
