-- partial dependency
-- an attribute depends on only part of the primary key and primary key must be composite
-- functional dependency
-- attribute depends on the primary key completely
-- transitive dependency
-- attribute depends on another attribute that is not primary
use demo;
delete from dept;
-- this is not possible as it is a parent table for another table

-- distinct 
-- this key word is used in the select statement to get the distinct values of the retrived table
-- one query can have one distinct and that should be given in the first of rows
select distinct(deptno),job from emp;

-- find distinct salaries in emp table
select distinct(sal) from emp;
-- find distinct deptno from emp table
select distinct(deptno) from emp;

select dname from dept where deptno=10;
-- row name = dname
select Dname from dept where deptno=10;
-- row name = Dname
select DNAME from dept where deptno=10;
-- row name = DNAME
-- the names are case sensitive in the my sql and sql server so the name you write in the query is retrived as the same in the output table

-- column aliasing
-- it is as giving the user name to any column while retriving data using select statement
-- three ways of doing it
-- sal "salary"
select sal "salary" from emp;
-- sal as salary
select sal as salary from emp;
-- sal salary
select sal salary from emp;

-- if space needs to be provided during aliasing double quotes is required

-- arithmetic operations
-- addition
-- increase the salary by 300 in emp table
select ename,sal,sal+300 "incr sal" from emp;
-- generate the salary slip of all the employees in emp table as 
-- hra = 40% 
-- da = 30%
-- pf = 12%
-- tax = 10%
-- tot=hra+da-pf-tax+sal
select ename, sal*0.4 hra,sal*0.3 da,sal*0.12 pf,sal*0.1 tax,sal+(sal*0.4)+(sal*0.3)-(sal*0.12)-(sal*0.1) total_sal from emp;

-- set command
-- this command is used to set a value to a variable in mysql which can be further used
set @hra=0.4;
set @da=0.3;
set @tax=0.1;
set @pf=0.12;
set @tot=0.4+0.3+1-0.1-0.12;

select ename,sal*@hra hra,sal*@da da,sal*@tax tax,sal*@pf pf,sal*@tot total_bal from emp;
 
 -- sort
 -- order by keyword is used to sort the data in mysql
 -- types
 -- order by <colname>;
 select ename,deptno,job from emp order by ename;
 -- order by <colname> desc; default is ascending but it can also be made descending by giving desc in command line
select ename,deptno,job from emp order by ename desc;
 -- order by <col1,col2>; sort using two columns
select ename,deptno,job from emp order by job,ename;
 -- order by <colnumber>; sorting using the column number of that purticular table
select * from emp order by 3;
 
-- limit 
-- this function is used to get only specific number of rows in a table
select * from emp limit 3;
-- display top sal from emp table
select * from emp order by sal desc limit 1;
-- display top 5 salaries from emp table
select * from emp order by sal desc limit 5;
-- display top 5 distinct salaries
select distinct(sal) from emp order by sal desc limit 5;

-- display 3rd,4th,5th salaries from emp table
select distinct(sal) from emp order by sal desc limit 2,3;

-- functions
-- 1)single row functions => operate on single rows and return one result per row 
-- 2)multiple row functions => can manipulate groups of rows to give one result per group of rows

-- single row functions
-- these are further divided into:-
-- > character functions
-- > number functions
-- > control functions
-- > date functions

-- character functions
-- >> concat
-- 		this is used to combine two or more columns or values
--  	syntax : concat(col1,col2,col3)
-- >> substr
-- 		we can extract character or sprcified length of characters
-- 		syntax : substr(string,n) print all characters from nth position
-- 				 substr(string,n,m) print m characters from nth position 
-- >> length
-- 		displays the length of specified columns
-- 		syntax : length(string)
-- >> upper
-- 		displays the string in uppercase format
-- 		syntax : upper(string)
-- >> lower
-- 		displays the string in lowercase format
-- 		syntax : lower(string)
-- >> instring
-- 		gives the first position of specified character
-- 		syntax : instr(string,string)
-- >> left/right
-- 		it gives left or right specified length
-- 		syntax : left(string,length)
-- 				 right(string,length)  length denotes the no of letters to be printed from the left or right of string
-- >> replace
-- 		replaces source string with target string
-- 		syntax = replace(str1,str2,str3) in str1 replace str2 with str3
-- >> left padding/right padding
-- 		add padding to left or right of string with the string given
-- 		syntax : lpad(str1,n,str2) or rpad(str1,n,str2)
-- 					the str2 is filled from left or right till n spaces after the completion of str1 letters
-- >> repeat 
-- 		repates the given string by the given amount of times
-- 		syntax : repeat(str,n)
-- 				str is repeated n times
-- >> trim
-- 		trims the spaces before and after string
-- 		syntax : trim(str)
-- 				 trim(str1 from str2)
-- 					str1 is been removed from str2
-- >> rtrim,ltrim
-- 		trims only to left or right of the string
-- 		syntax : rtrim(str),ltrim(str)

-- Number Functions
-- >> mod
-- 		it gives the reminder when of two numbers
-- 		syntax : mod(num1,num2)
-- >> sign
-- 		it compares two numbers
-- 		syntax : sign(a-b)
-- 		0 if both are equal
-- 		1 if a is greater
-- 		-1 if b is greater
-- >> abs
-- 		it converts the given number to its positive value
-- 		syntax : abs(-100)=>100		
-- >> ascii
-- 		gives the ascii value of the given number
-- 		syntax : ascii('a')=>97
-- >> char 
-- 		gives character against value 
-- 		syntax : char(65 using ascii)=>A
-- >> round/truncate/ceil/floor
-- 		Round
-- 		round the number to the closet values
-- 		syntax : round(n1,n2)
-- 			n1 is round by n2
-- 			positive after dot
-- 			negetive before dot
			 
-- character functions
-- >> concat
-- 		this is used to combine two or more columns or values
--  	syntax : concat(col1,col2,col3)
--      select concat(firstname,lastname) from <table name>
select concat(ename,job) d from emp;
select concat(ename ,' is working as ',job) "employee and his job" from emp;

-- display the ename and ob in the following format
-- smith's job is clerk
select concat(ename,"'s job is ",job) "job done" from emp;

-- >> substr
-- 		we can extract character or sprcified length of characters
-- 		syntax : substr(string,n) print all characters from nth position
-- 				 substr(string,n,m) print m characters from nth position 
select substr("hello world",7) "from 7th position";
select substr("hello world",7,2) "from 7th position 2 characters";
-- display the names where 3rd and 4th characters are same
select ename from emp where substr(ename,3,1)=substr(ename,4,1);
-- display ename where name starting with a,j,m,k
select ename from emp where substr(ename,1,1) in ('a','j','m','k');
-- display last character in all names
select substr(ename,-1,1) from emp;

-- >> length
-- 		displays the length of specified columns
-- 		syntax : length(string)
select substr(ename,length(ename)) from emp;

-- >> upper
-- 		displays the string in uppercase format
-- 		syntax : upper(string)
select job,upper(job),lower(job) from emp;

-- display the ename last letter as upper and all other letters as lower
select concat(lower(substr(ename,1,(length(ename)-1))),upper(substr(ename,-1))) "last letter capital" from emp;

-- >> instring
-- 		gives the position of specified character
select instr("hello world","ld");

-- display ename where last character is getting repeated
select ename from emp where instr(substr(ename,1,(length(ename)-1)),substr(ename,-1));
select ename from emp where instr(substr(ename,1,(length(ename)-1)),substr(ename,-1))=instr(ename,substr(ename,-1));

-- >> left/right
-- 		it gives left or right specified length
-- 		syntax : left(string,length)
-- 				 right(string,length)  length denotes the no of letters to be printed from the left or right of string

select left("hello",3),right("hello",3);

-- >> replace
-- 		replaces source string with target string
-- 		syntax = replace(str1,str2,str3) in str1 replace str2 with str3
select replace("marry had a little lamb","lamb","bomb");

-- find the occurences of a in 'mary had a little lamb'
set @str='mary had a little lamb';
select length(@str)-length(replace(@str,'a','')) 'count of a';

-- >> left padding/right padding
-- 		add padding to left or right of string with the string given
-- 		syntax : lpad(str1,n,str2) or rpad(str1,n,str2)
-- 					the str2 is filled from left or right till n spaces after the completion of str1 letters
select lpad(dname,15,'-') , rpad(dname,15,'+') from dept;

-- >> repeat 
-- 		repates the given string by the given amount of times
-- 		syntax : repeat(str,n)
-- 				str is repeated n times
select repeat("test",3);

-- >> trim
-- 		trims the spaces before and after string
-- 		syntax : trim(str)
-- 				 trim(str1 from str2)
-- 					str1 is been removed from str2
-- 		it is case sensitive
set @str2='helloh';
select trim('h' from @str2);
set @str1='  sai  ';
select @str1,trim(@str1);

-- >> rtrim,ltrim
-- 		trims only to left or right of the string
-- 		syntax : rtrim(str),ltrim(str)
select ltrim(@str1),rtrim(@str1);

-- Number Functions
-- >> mod
-- 		it gives the reminder when of two numbers
-- 		syntax : mod(num1,num2)

-- find the employees with empno in odd
SELECT 
    *
FROM
    emp
WHERE
    MOD(empno, 2) = 1; 

-- >> sign
-- 		syntax : sign(a-b)
-- 		it compares two numbers
-- 		0 if both are equal
-- 		1 if a is greater
-- 		-1 if b is greater
set @a=10;
set @b=20;
set @c=10;
select sign(@a-@b); -- output = -1
select sign(@b-@c); -- output = 1
select sign(@a-@c); -- output = 0

-- find employees who are taking comision more than salary
select ename,comm,sal from emp where sign(comm-sal)=1;

-- >> abs
-- 		it converts the given number to its positive value
-- 		syntax : abs(-100)=>100		
select abs(-100);
-- >> ascii
-- 		gives the ascii value of the given number
-- 		syntax : ascii('a')=>97
select ascii('a');
-- >> char 
-- 		gives character against value 
-- 		syntax : char(65 using ascii)=>A
select char(11 using ascii);
-- >> round/truncate/ceil/floor
-- 		Round
-- 		round the number to the closet values
-- 		syntax : round(n1,n2)
-- 			n1 is round by n2
-- 			positive after dot
-- 			negetive before dot

select round(18.876,1); -- 18.9
select round(18.862,2); -- 18.86
select round(18.972,-1); -- 20
select round(18.297,-2); -- 0
-- 		truncate 
-- 		it round to the lower value of the given number
-- 		syntax : truncate(n1,n2)
select truncate(18.876,1); -- 18.8
select truncate(18.862,2); -- 18.86
select truncate(18.972,-1); -- 10
select truncate(18.297,-2); -- 0
