# 6.5 練習問題

# 6-1
/* A union B
= {L, M, N, O, P, Q, R, S, T}
**/

/* A union all B
= {L, M, N, O, P, P, Q, R, S, T}
**/

/* A intersect B
= {P}
**/

/* A except B
= {L, M, N, O}
**/

# 6-2
select fname, lname
from individual
union all
select fname, lname
from employee;

# 6-3
select fname, lname
from individual
union all
select fname, lname
from employee
order by lname;
