create temp table tmp as
select * from onektup, tenktup1
where (onektup.unique2 = tenktup1.unique2)
and (tenktup1.unique2 = tenktup2.unique2)
and (tenktup1.unique2 < 1000);
