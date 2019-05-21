create table temp as
select * from tenktup1
where unique2 between 792 and 1791;
drop table temp;
