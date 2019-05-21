create table tmp as
select * from tenktup1, bprime
where (tenktup1.unique1 = bprime.unique1)
