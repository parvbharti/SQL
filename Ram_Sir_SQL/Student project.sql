-- Steps Involved
-- 1) collect data
-- 2) prepare er diagrams using obtained data
-- 3) convert er diagrams to tables
-- 4) normalize the tables

-- three types of intigrities
-- 1)entity : primary/foreign , unique , not null
-- 2)referential : primary/foreign
-- 3)domain : check

-- terminologies in er diagram
-- entity - rectangle
-- > object about which data is collected
-- > they become tables names
-- relationship - rhombus
-- > association amoung entities
-- attribute - ellipse
-- > describes an entity
-- > they become columns
-- identifier - underlined
-- > uniquely identifies a row/tuple
create table student (id int primary key,name varchar(20));
insert into student values(1,'sai'),(2,'rishi'),(3,'teja'),(4,'karishma');
alter table student add column mobile numeric(10);
desc student;
select * from student;
update student set mobile=72681171 where name='sai';

-- types of attributes
-- >simple oval
-- >multivalued double oval
-- >derived  
-- >composite
create table phone(id int, mobile varchar(10), foreign key(id) references student(id));
alter table student drop column mobile;
insert into phone values(1,627158162),(2,7518127112),(3,7168162751),(4,7168251851),(1,27156271),(2,818152711);
select * from phone;

-- combine two tables phone and student and print values of sai
select id,name,mobile from student natural join phone where name='sai';

alter table student add dob date;
update student set dob='2000-05-15';

-- derived attribute
select name,ceil((curdate()-dob)/(365*30)) as age from student;

-- view
-- it is a temporary table which can only be retrived but cannot be edited
-- it is created for data protection and also for derived valued attributes.
-- after its creation when a new row is updated,deleted or inserted into the table it is been built on it updates itself
create view stud_age as select id,name,ceil((curdate()-dob)/(365*30)) "age" from student;
select * from stud_age;

alter table student add (city varchar(20),street varchar(20),pincode numeric(6));
select * from student;
-- composite attribute
-- concat function ==> A function that is used to combine the attributes or feilds in a table as one and represent it as a single column
 select id,name,concat(city,",",street,",",pincode) as address from student;