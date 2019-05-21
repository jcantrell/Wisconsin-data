/* create temp table mytemp as */
select * from tenktup1, tenktup2
where (tenktup1.unique2 = tenktup2.unique2)
and (tenktup2.unique2 < 1000); 
