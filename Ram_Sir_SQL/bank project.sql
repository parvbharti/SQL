use demo;
create table bankaccount(accno numeric(16),name varchar(20));
create table savings(accno numeric(16),minbal int check (minbal >= 200),foreign key(accno) references bankaccount(accno));
create table current(accno numeric(16),overdraft int,foreign key(accno) references bankaccount(accno));