create temp table tmp as
select * from tenktup1, bprime
where (tenktup1.unique2 = bprime.unique2);
