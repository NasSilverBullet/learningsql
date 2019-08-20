# 7.2 数値データの操作

select (37 * 59) / (78 - (8 * 6));

## 剰余 (mod)
select mod(10, 4);
select mod(22.75, 5);

## 累乗 (pow)
select pow(2, 8);
select pow(2, 10) kilobyte, pow(2, 20) megabyte,
pow(2, 30) gigabyte, pow(2, 40) terabyte;

## 数値の精度の制御

/** 切り上げ(ceil) */
/** 切捨て(floor) */
select ceil(72.445), floor(72.445);
select ceil(72.000000001), floor(72.999999999);

/** 四捨五入(round) */
select round(72.49999), round(72.5), round(72.50001);
/** 桁数を指定できる */
select round(72.0909, 1), round(72.0909, 2), round(72.0909, 3);

/** 桁数を指定して切捨て(truncate) */
select truncate(72.0909, 1), truncate(72.0909, 2), truncate(72.0909, 3);
/** 桁数に負数を指定することで整数部で丸めることが可能 */
select round(17, -1), truncate(17, -1);

## 符号付きデータの処理
/** 正負を判定(sign) */
/** 絶対値を取得(abs) */
select account_id, sign(avail_balance), abs(avail_balance)
from account;
