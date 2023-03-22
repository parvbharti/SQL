create database case_library;
use case_library;
-- values and table given by the case study
-- book table
CREATE TABLE BOOK 
   (	BOOKID int(15)   PRIMARY KEY auto_increment, 
	BPUB varchar(20), 
	BAUTH varchar(20), 
	BTITLE varchar(25), 
	BSUB varchar(25)
   ) ;
  -- member table 
  CREATE TABLE MEMBER 
   (	MID int(4)   PRIMARY KEY auto_increment, 
	MNAME varchar(20), 
	MPHONE numeric(10,0),
        JOINDATE DATE
   ) ;
   -- bcopy table
  CREATE TABLE BCOPY 
   (	C_ID int(4), 
	BOOKID int(15), 
	STATUS varchar(20) CHECK (status in('available','rented','reserved')),
        PRIMARY KEY (C_ID,BOOKID)
   ); 
   -- bres table
  CREATE TABLE BRES 
   (	MID int(4) , 
	BOOKID int(15) REFERENCES BOOK, 
	RESDATE DATE,PRIMARY KEY (MID, BOOKID, RESDATE),
        foreign key(mid) references member(mid)
   ) ;
   -- bloan table
  CREATE TABLE BLOAN 
   (	BOOKID int(4), 
	LDATE DATE, 
	FINE numeric(11,2), 
	MID int(4), 
	EXP_DATE DATE DEFAULT (curdate()+2), 
	ACT_DATE DATE, 
	C_ID int(4),
  FOREIGN KEY (C_ID, BOOKID)
	  REFERENCES BCOPY (C_ID, BOOKID),
 foreign key(mid) references member(mid)
   ) ;
-- book tuples
Insert into BOOK (BPUB,BAUTH,BTITLE,BSUB) 
values ('IDG Books','Carol','Oracle Bible','Database');
Insert into BOOK (BPUB,BAUTH,BTITLE,BSUB) 
values ('TMH','James','Information Systems','I.Science');
Insert into BOOK (BPUB,BAUTH,BTITLE,BSUB) 
values ('SPD','Shah','Java EB 5','Java');
Insert into BOOK (BPUB,BAUTH,BTITLE,BSUB) 
values ('BPB','Deshpande','P.T.Olap','Database');
-- member tuples
Insert into MEMBER (MNAME,MPHONE,JOINDATE) 
values ('rahul',9343438641,(curdate()-3));
Insert into MEMBER (MNAME,MPHONE,joindate)
 values ('raj',9880138898,(curdate()-2));
Insert into MEMBER (MNAME,MPHONE,joindate) 
values ('mahesh',9900780859,curdate());
-- bcopy tuples
Insert into BCOPY (C_ID,BOOKID,STATUS) values (1,1,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (2,1,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (1,2,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (2,2,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (1,3,'available');
Insert into BCOPY (C_ID,BOOKID,STATUS) values (1,4,'available');
-- tables, descriptions and values
show tables;
desc member;
desc bloan;
desc bcopy;
desc book;
desc bres;
select * from bloan;
select * from bres;
select * from bcopy;
select * from book;
select * from member;

-- NEW_MEMBER: A  procedure that adds a new member to the MEMBER table.For the join date, use CURDATE(). 
-- Pass all other values to be inserted into a new row as parameters.

-- procedure for insertions in member
delimiter $
create procedure new_member(name varchar(30),phno decimal(10,0))
begin
insert into member(mname,mphone,joindate) values (name,phno,curdate()); 
end $
delimiter ;

-- NEW_BOOK: A procedure that adds a new book to the book table. columns pass as parameter.

-- procedure to insert into book
delimiter $
create procedure new_book(pub varchar(30),aut varchar(30),tit varchar(30),sub varchar(30))
begin
insert into book(bpub,bauth,btitle,bsub) values (pub,aut,tit,sub); 
end $
delimiter ;

-- Create a trigger to insert into bcopy  table whenever insert happens on new_book.

-- trigger to insert into bcopy for book table
delimiter $
create trigger bcopyinsert
after insert
on book
for each row
begin
insert into bcopy values(1,new.bookid,'available');
end $
delimiter ;

-- NEW_RENTAL: Function to record a new rental. Pass the bID number for the book that is to be  rented,
-- pass ID number into the function. The function should return the due date for the book. Due dates are 
-- three days from the date the book is rented. If the status for a book requested is listed as AVAILABLE 
-- in the bCOPY table for one copy of this title, then update this b_COPY table and set the status to RENTED. 
-- If there is no copy available, the function must return NULL. Then, insert a new record into the BLOAN  
-- table identifying the booked date as today's date, the copy ID number, the member ID number, the BOOKID 
-- number and the expected return date. 

-- function for lending a book to see if it is present
delimiter $
create function new_rental(bid int,memid int)
returns varchar(50)
deterministic
begin
declare v varchar(20);
declare b int;
declare mn varchar(20);
declare a int;
declare d varchar(50);
set v=null;
select bauth into v from book where bookid=bid;
select mname into mn from member where mid=memid;
if(v is not null and mn is not null) then
	select c_id,bookid into b,a from bcopy where bookid=bid and status='available' limit 1;
	if(b is not null) then
		update bcopy set status='rented' where bookid=a and c_id=b;
        insert into bloan(bookid,ldate,mid,exp_date,c_id) values(a,curdate(),memid,date_add(curdate(),interval '2' day),b);
		return concat(date_add(curdate(),interval '2' day),' is the returning date');
	else
		call reserve_book(memid,bid,@da);
        set d=@da;
		return d;
	end if;
else
	signal sqlstate '45000' set message_text='no book is present with the given book id';
end if;
end $
delimiter ;

-- RETURN_book: A  procedure that updates the status of a book (available, rented, or reserved) and sets the 
-- return date. Pass the book ID, the copyID and the status to this procedure. Check whether there are 
-- reservations for that title, and display a message if it is reserved. Update the RENTAL table and set the 
-- actual return date to today’s date. Update the status in the BCOPY table based on the status parameter passed 
-- into the procedure. 

-- create a procedure for the book returning and update the tables accordingly
delimiter $
create procedure return_book(bid int,cid int,st varchar(20))
begin
declare v varchar(20);
declare n varchar(20);
select status into v from bcopy where bookid=bid and c_id=cid;
if(v='reserved') then
update bloan set act_date=curdate() where bookid=bid and c_id=cid;
update bcopy set status='available' where bookid=bid and c_id=cid;
select mname into n from member m natural join bloan where
m.mid=(select mid from bloan where act_date=(select min(act_date) from bloan where bookid=bid limit 1));
select concat('book is reserved for ',n) reserved;
else
update bcopy set status=st where bookid=bid and c_id=cid;
update bloan set act_date=curdate() where bookid=bid and c_id=cid;
update bcopy set status='available' where bookid=bid and c_id=cid;
end if;
end $
delimiter ;

-- RESERVE_BOOK: A  procedure that executes only if all of the book copies requested in the NEW_RENTAL 
-- procedure have a status of RENTED. Pass the member ID number and the book ID number to this procedure. 
-- Insert a new record into the BRES table and record the reservation date, member ID number, and BID 
-- number. Print out a message indicating that a BOOK is reserved and its expected date of return.

-- create a procedure for the book if all books are rented
delimiter $
create procedure reserve_book(meid int,bid int,out d varchar(50))
begin
declare c int;
select min(exp_date),c.c_id into d,c from bloan l 
inner join bcopy c on c.bookid=l.bookid where l.bookid=bid and c.status='rented';
if(d is not null)then
insert into bres values(meid,bid,d);
update bcopy set status='reserved' where bookid=bid and c_id=c;
set d=concat('expected date of return : ',d,' copyid : ',c);
else
set d=concat('all the books with bookid ',bid,' is reserved');
end if;
end $
delimiter ; 

-- f. PMEM_BOOK:   A PROCEDURE TO PASS MEMBER ID 
-- A. PRINT THE LIST OF BOOKS TAKEN BY HIM IN THE FOLLWING FORMAT.
-- BOOKS ON LOAN TO:
-- member_id:22
-- member_name:shekar***********
-- book#:4
-- title:P.T.Olap
-- loandate:29-AUG-18
-- --------------------
-- B. IF MEMBER HAS NOT TAKEN ANY BOOKS PRINT THE MESSAGE AS BELOW
-- **NO BOOKS TAKEN BY THE MEMBER 41

-- create procedure to view books taken by a person
delimiter $
create procedure pmem_book(id int)
begin
declare a date;
if(a is not null) then
 select  m.mid,mname,b.bookid,btitle,exp_date from bloan l
 inner join book b on l.bookid=b.bookid
 inner join member m on m.mid=l.mid where m.mid=id;
else
 select '** no books are taken by member';
end if;
end $
delimiter ;

-- WHEN ACTUAL RETURN DATE EXCEEDS EXPECTED RETURN DATE, FINE SHOULD BE LEVIED.(PER DAY RS.5) after expected return date.

-- create a trigger to get fine of a member
delimiter $
create trigger memfine
before update 
on bloan
for each row
begin
declare v int;
if(new.act_date is not null) then
set v= datediff(new.exp_date,new.act_date);
end if;
if(v<0) then
set v=abs(v*5);
else
set v=0;
end if;
set new.fine=v;
end $
delimiter ;

-- List all the members took a particular book.

-- show the details of members who have taken a purticular book
delimiter $
create procedure book_taken_by(id int)
begin
declare v varchar(50);
set v=concat(id,' book is taken by'); 
select mname from member m inner join bloan l on m.mid=l.mid where l.bookid=id and act_date is null;
end $
delimiter ;
drop procedure book_taken_by;
call book_taken_by(1);
