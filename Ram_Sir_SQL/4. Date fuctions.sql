-- Date Functions
-- Returning date and time

-- >> Currentdate,curdate 
-- 		returns date
select current_date,curdate();
-- >> current_timestamp,now,sysdate 
-- 		returns date and time
select current_timestamp,now(),sysdate();
-- >> date
-- 		to print only date or time using these three functions
select date(now());
select time(now());
-- >> Dayname
-- 		get the day name
select dayname(curdate());
select dayname(sysdate());
-- display employees who have joined on tuesday
select ename from emp where dayname(hiredate)='Tuesday';
-- >> monthname
-- 		get the month name
select monthname(sysdate());
select monthname(curdate());
-- find employees who joined in february
select ename from emp where monthname(hiredate)='February';
-- >> Year
-- 		get the year
select year(sysdate());
select year(curdate());
-- find employees who joined in 1987
select ename from emp where year(hiredate)=1987;
-- >> Quarter
-- 		get the quarter
select quarter(sysdate());
select quarter(curdate());
-- display employees who joined on tuesday and quarter 4
select ename from emp where dayname(hiredate)='Tuesday' and quarter(hiredate)=4;
-- >> Hour,Minute,second
-- 		to print the hour, minute, second of the purticular time
select hour(sysdate()),minute(now()),second(current_timestamp());
select second(current_time());
-- >> Date format
-- 		%a => 3 letter day
select date_format(curdate(),'%a');
-- 		%W => Full Day
select date_format(curdate(),'%W');
-- 		%b => 3 letter month
select date_format(curdate(),'%b');
-- 		%M => Full month
select date_format(curdate(),'%M');
-- 		%d => Day number within a month
select date_format(curdate(),'%d');
-- 		%j => Day number within a year
select date_format(curdate(),'%j');
-- 		%w => Day number within a week
select date_format(curdate(),'%w');
-- 		%y => Two digit year
select date_format(curdate(),'%y');
-- 		%Y => Four digit year
select date_format(curdate(),'%Y');
set @ind_date='1947-08-15';
select date_format(@ind_date,'%W');
-- find employees who joined in leap year
select ename from emp where mod(date_format(hiredate,'%y'),4)=0;
-- 		%m => numerical month
select date_format(curdate(),'%m');


select date_format(now(),'%Y-%M-%d');
select concat(year(hiredate),'-12-31') from emp;
-- >> Date difference
-- 		datediff = takes two arguments
-- 		syntax : datediff(date1,date2)
-- 		This gives the difference between the two dates given in it
select ename,hiredate,datediff(curdate(),hiredate)/365 'exp' from emp;
-- 		timestampdiff
-- 		syntax : timestampdiff(month or day or year,date1,date2)
-- 		this differences the dates and given the output in the specified format
select timestampdiff(year,dob,curdate()) year from student;
select timestampdiff(day,dob,curdate()) day from student;
select timestampdiff(month,dob,curdate()) month from student;

-- find the experience in years of all the employees
select ename,hiredate,timestampdiff(year,hiredate,curdate()) years from emp;
-- find your age in months and year
select timestampdiff(year,'2001-05-18',curdate()) year,mod(timestampdiff(month,'2001-05-18',curdate()),12) month;
select timestampdiff(year,'2001-05-18',curdate()) year,timestampdiff(month,'2001-05-18',curdate())-(timestampdiff(year,'2001-05-18',curdate())*12) month;

-- >> Modifying dates
-- 		date_add => add months,years,days
-- 		date_sub => sub months,years,days
select curdate(),date_add(curdate(),interval '4' year) 'adding 4 years';
select curdate(),date_add(curdate(),interval '4' day) 'adding 4 days';
select curdate(),date_add(curdate(),interval '4' month) 'adding 4 months';
select curdate(),date_sub(curdate(),interval '4' year) 'subtracting 4 years';
select curdate(),date_sub(curdate(),interval '4' day) 'subtracting 4 days';
select curdate(),date_sub(curdate(),interval '4' month) 'subtracting 4 months';

-- display ename,hiredate,salary review data
-- salary review date = six months from hire date name it as review
select ename,hiredate,
concat(dayname(date_add(hiredate,interval '6' month)),
' ',date_format(hiredate,'%m'),'th ',
monthname(date_add(hiredate,interval '6' month)),
',',year(date_add(hiredate,interval '6' month))) review from emp;

-- diaplay ename,hiredate,day of joining order results based on day of joining
select ename,hiredate,dayname(hiredate) joining_day from emp order by date_format(hiredate,'%w');

-- >> last_day
-- 		it displays the last day of the purticular month
-- 		syntax : lastday(date)
select last_day(curdate());

-- >> makedate
-- 		it adds the no of days to the year provided
-- 		makedate(year,no of days to be added)
select makedate(2017,1000);
select ename,hiredate,makedate(year(hiredate),1) "first date of joining year" from emp;

-- >> format conversion
-- 		str_to_date converts string to date
-- 		syntax(str,format in which date is given)
select str_to_date('22-dec-2022','%d-%b-%Y');
select str_to_date('dec-2001-18','%b-%Y-%d');

-- >> Extract
-- 		this function is used to extract year or month or day from the date given
-- 		syntax : extract(year from date)
select extract(year from curdate());
select extract(month from curdate());
select extract(day from curdate());

-- Control Functions
-- True,False,Expression
-- >>IF,NULL IF,CASE EXPRESSION,IFNULL

-- if
-- syntax : if(exp1,ex2,exp3)
-- if first expression is true returns exp2 else exp3
select ename,sal,if(sal>2500,'high','low') comment from emp;

