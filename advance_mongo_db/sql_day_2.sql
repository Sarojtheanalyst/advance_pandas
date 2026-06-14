use zomato7;

select * from student;

DROP TABLE student;

insert into student values(1,"hari","hari123@gmail.com",
45,"2025-01-06 10:12:00");


-- different constraints 

-- primary key :
   -- not null 
   -- unique 
   
-- not null : 
-- check : -10 , 1000
-- unique : 
-- default : defualt  CURRENT_TIME;

-- CREATING A TABLE BY USING DIFFERENT CONSTRAINTS

CREATE TABLE student(id int primary key,
  age int not null ,
  email varchar(50) unique,
  enrolled_date datetime default now(),
  status varchar(100) default "active",
  check (age>10 and age<100));
  
  -- insert the data into the table
  insert into student values(2,40,"shyam1234@gmail.com","2022-02-05",
  "offline");
  

  -- default values
  insert into student(age,id) values(32,3);
  
  select * from student;
  
  
  


 


select now()

