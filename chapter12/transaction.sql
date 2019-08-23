/* transaction */
start transaction;
/* 1つ目の口座の残高が十分であることを確認した上で、預金を引出す */
update account set avail_balance = avail_balance - 500
where account_id = 9988
  and avail_balance > 500;

if /* 先の文によってデータが1だけ更新された */ then
  /* 預金を2つ目の口座に振り込む */
  update account set avail_balance = avail_balance + 500
  where account_id = 9989;

  if /* 先の文によってデータが1だけ更新された */ then
    /* すべてが正常に処理された場合は、変更を確定する */
    commit;
  else
    /* なにか問題が起きた場合は、このトランザクションの変更をすべてもとに戻す */
    rollback;
  end if;
else
  /* 残高が不足している、または更新中にエラーが発生した */
  rollback;
end if;

/* セーブポイント */
start transaction;

update product
set dete_retired = current_timestamp()
where product_cd = 'XYZ';

savepoint before_close_accounts;

update account -- rollback されるため、ここからは結果に反映されない
set status = 'closed', close_date = current_timestamp(),
  last_activity_date = current_timestamp()
where product_cd = 'XYZ';

rollback to savepoint before_close_accounts;

commit;
