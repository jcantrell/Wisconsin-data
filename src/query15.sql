create temp table tmp as
select * from tenktup1, tenktup2
where (tenktup1.unique1 = tenktup2.unique1)
and (tenktup1.unique2 < 1000);
