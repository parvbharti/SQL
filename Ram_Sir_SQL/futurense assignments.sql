#Assignment 3
create database assignment;
use assignment;

-- create table patient
create table patient(pid int(7) primary key,
pname varchar(30) not null);
-- create table treatment
create table treatment(tid int(7) primary key,
tname varchar(30) not null);
-- create table patient_treatment
create table patient_treatment(pid_pt integer(7) not null,
tid_pt integer(7) not null,
foreign key(pid_pt)references patient(pid),
foreign key(tid_pt)references treatment(tid));


-- 1. In the Patient table, change the maximum length for Patient’s names to be 35 characters long.
alter table patient modify column pname varchar(35) not null;
-- 2. In the Patient_Treatment table, add a column called “Dosage” where the amount of the 
-- treatment given will be stored. This column is a fixed numerical value with a maximum 
-- of 99. This column cannot be null and the default value should be “0”.
alter table patient_treatment add column dosage int not null default 0;
alter table patient_treatment add check (dosage<99);
-- 3. In the Treatment table, change the column name “T_Name” to be “Treatment_Name”.
alter table treatment rename column tname to treatment_name;
-- 4. Remove the Treatment table from the database.
drop table treatment;
-- 5. Remove the foreign key constraints from PID_PT and TID_PT columns in the Patient_Treatment table.
alter table patient_treatment drop constraint patient_treatment_ibfk_1;
alter table patient_treatment drop constraint patient_treatment_ibfk_2;

# Assignment 4
-- creating tables
-- Student
create table student
(sid integer(5) primary key,
S_FName varchar(20) not null,
S_LName varchar(20) not null);
-- Course
create table course
(cid integer(6) primary key,
C_Name varchar(30) not null);
-- Course_Grades
create table course_grades
(cgid integer(7) primary key,
semester char(4) not null,
cid integer(6) not null,
sid integer(5) not null,
grades char(2) not null,
foreign key(cid) references course(cid),
foreign key(sid) references student(sid));

-- insert values to tables
-- Student
INSERT INTO `assignment`.`student` (`sid`, `S_FName`, `S_LName`) VALUES ('12345', 'Chris', 'Rock');
INSERT INTO `assignment`.`student` (`sid`, `S_FName`, `S_LName`) VALUES ('23456', 'Chris', 'Farley');
INSERT INTO `assignment`.`student` (`sid`, `S_FName`, `S_LName`) VALUES ('34567', 'David', 'Spade');
INSERT INTO `assignment`.`student` (`sid`, `S_FName`, `S_LName`) VALUES ('45678', 'Liz', 'Lemon');
INSERT INTO `assignment`.`student` (`sid`, `S_FName`, `S_LName`) VALUES ('56789', 'Jack', 'Donaghy');

-- Course
INSERT INTO `assignment`.`course` (`cid`, `C_Name`) VALUES ('101001', 'Intro to Computers');
INSERT INTO `assignment`.`course` (`cid`, `C_Name`) VALUES ('101002', 'Programming');
INSERT INTO `assignment`.`course` (`cid`, `C_Name`) VALUES ('101003', 'Databases');
INSERT INTO `assignment`.`course` (`cid`, `C_Name`) VALUES ('101004', 'Websites');
INSERT INTO `assignment`.`course` (`cid`, `C_Name`) VALUES ('101005', 'IS Management');

-- Course_Grades
INSERT INTO `assignment`.`course_grades` (`cgid`, `semester`, `cid`, `sid`, `grades`) VALUES ('2010101', 'SP10', '101005', '34567', 'D+');
INSERT INTO `assignment`.`course_grades` (`cgid`, `semester`, `cid`, `sid`, `grades`) VALUES ('2010308', 'FA10', '101005', '34567', 'A-');
INSERT INTO `assignment`.`course_grades` (`cgid`, `semester`, `cid`, `sid`, `grades`) VALUES ('2010309', 'FA10', '101001', '45678', 'B+');
INSERT INTO `assignment`.`course_grades` (`cgid`, `semester`, `cid`, `sid`, `grades`) VALUES ('2011308', 'FA11', '101003', '23456', 'B-');
INSERT INTO `assignment`.`course_grades` (`cgid`, `semester`, `cid`, `sid`, `grades`) VALUES ('2012206', 'SU12', '101002', '56789', 'A+');

-- 3. In the Student table, change the maximum length for Student first names to be 30 characters long.
alter table student modify column s_fname varchar(30) not null;
-- 4. In the Course table, add a column called “Faculty_LName” where the Faculty last name 
-- can vary up to 30 characters long. This column cannot be null and the default value 
-- should be “TBD”.
alter table course add column Faculty_LName varchar(30) not null default 'TBD';
-- 5. In the Course table, update CID 101001 where will be Faculty_LName is “Potter” and 
-- C_Name is “Intro to Wizardry”
update course set Faculty_LName='Potter' where cid=101001;
-- 6. In the Course table, change the column name “C_Name” to be “Course_Name”
alter table course rename column C_Name to Course_Name;
-- 7. Delete the “Websites” class from the Course table.
delete from course where Course_Name='Websites';
-- 10. Remove the foreign key constraints from CID and SID columns in the Course_Grades table.
show create table course_grades;
alter table course_grades drop constraint course_grades_ibfk_1;
alter table course_grades drop constraint course_grades_ibfk_2;
-- 8. Remove the Student table from the database.
drop table student;
-- 9. Remove all the data from the Course table, but retain the table structure.
truncate course;

#Assignment 5
-- 1. **Select employees first name, last name, job_id and salary whose first name starts with alphabet S.**
select first_name,last_name,job_id,salary from employees where first_name like 'S%';
-- 2. **Write a query to select employee with the highest salary.**
select first_name,salary from employees having salary=max(salary);
-- 3. **Select employee with the second highest salary**.
select first_name,salary from employees where salary=(select distinct(salary) from employees order by salary desc limit 1,1);
-- 4. **Fetch employees with 2nd or 3rd highest salary**.
select first_name,salary from employees order by salary desc limit 1,2;
-- 5. **Write a query to select employees and their corresponding managers and their salaries**.
select * from employees;
select e.first_name employee,m.first_name manager,m.salary 'manager salary' from employees e,employees m 
where e.manager_id=m.employee_id;
-- 6. **Write a query to show count of employees under each manager in descending order**.
select manager_id,count(manager_id) count from employees where manager_id is not null group by manager_id order by 2 desc;
-- 7. **Find the count of employees in each department**.
select department_id,count(department_id) from employees group by department_id;
-- 8. **Get the count of employees hired year wise**.
select count(year(hire_date)),year(hire_date) from employees group by year(hire_date) order by 2;
-- 9. **Find the salary range of employees**.
select max(salary) maximum_sal,min(salary) minimum_sal from employees;
-- 10. **Write a query to divide people into three groups based on their salaries**.
select ntile(3) over(order by salary) part, first_name,salary from employees;
-- 11. **Select the employees whose first_name contains “an”.**
select first_name from employees where first_name like '%an%';
-- 12. **Select employee first name and the corresponding phone number in the format (_ _ _)-(_ _ _)-(_ _ _ _)**.
select first_name,phone_number from employees where phone_number like '___.___.____';
-- 13. **Find the employees who joined in August, 1994.**
select first_name,hire_date from employees where year(hire_date)=1994 and date_format(hire_date,'%M')='august';
-- 14. **Write an SQL query to display employees who earn more than the average salary in that company**
select first_name,salary from employees having salary>(select avg(salary) from employees);
-- 15. **Find the maximum salary from each department.**
select max(salary),department_id from employees group by department_id;
-- 16. **Write a SQL query to display the 5 least earning employees**.
select first_name,salary from employees order by 2 limit 5;
-- 17. **Find the employees hired in the 80s**.
select first_name,hire_date from employees where year(hire_date) between 1980 and 1989;
-- 18. **Display the employees first name and the name in reverse order**.
select reverse(first_name) from employees;
-- 19. **Find the employees who joined the company after 15th of the month.**
select first_name,hire_date from employees where date_format(hire_date,'%d')>15;
-- 20. **Display the managers and the reporting employees who work in different departments**.
select e.first_name employee,e.department_id emp_dept,m.first_name manager,m.department_id
from employees e,employees m where e.manager_id=m.employee_id and e.department_id!=m.department_id;