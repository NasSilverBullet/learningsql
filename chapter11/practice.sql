# 11.4 練習問題
# 11-1
select emp_id,
case
when title like '%President' or title = 'Treasurer' or title = 'Loan Manager' then 'Management'
when title like '%Teller' or 'Operations Manager' then 'Operations'
else 'Unknown'
end title
from employee;

# 11-2
select
sum(case when open_branch_id = 1 then 1 else 0 end) branch_1,
sum(case when open_branch_id = 2 then 1 else 0 end) branch_2,
sum(case when open_branch_id = 3 then 1 else 0 end) branch_3,
sum(case when open_branch_id = 4 then 1 else 0 end) branch_4
from account;
