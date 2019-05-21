create table temp as
select * from tenktup1
where unique1 between 0 and 99;
drop table temp;
