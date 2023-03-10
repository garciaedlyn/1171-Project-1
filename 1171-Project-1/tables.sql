
--Edlyn Garcia Project 1 

DROP TABLE IF EXISTS courses_programs CASCADE;
DROP TABLE IF EXISTS programs CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS faculties CASCADE;
DROP TABLE IF EXISTS pre_requisites CASCADE;
DROP TABLE IF EXISTS instructors CASCADE;

CREATE TABLE faculties(               --Parent Table
  faculty_id VARCHAR(4) PRIMARY KEY,
  faculty_name VARCHAR(100) NOT NULL,
  faculty_description TEXT NOT NULL
);


CREATE TABLE programs ( 
  program_id CHAR(4) PRIMARY KEY,
  faculty_id VARCHAR(4),
  program_name VARCHAR(50)NOT NULL,
  program_location VARCHAR(50) NOT NULL,
  program_description TEXT NOT NULL,
  FOREIGN KEY (faculty_id)
  REFERENCES faculties(faculty_id)
);

CREATE TABLE instructors ( --parent table
  instructor_id INT PRIMARY KEY,
  email VARCHAR (50),
  instructor_name VARCHAR (50),
  office_location VARCHAR (50),
  telephone CHAR (20),
  degree VARCHAR(5)
);

CREATE TABLE courses (
  course_id INT PRIMARY KEY,
  code CHAR ( 8 ) NOT NULL,
  year INT NOT NULL,
  semester INT NOT NULL,
  section VARCHAR (10) NOT NULL,
  title VARCHAR ( 100 ) NOT NULL,
  credits INT NOT NULL,
  modality VARCHAR ( 50 ) NOT NULL,
  modality_type VARCHAR(20) NOT NULL,
  instructor_id INT NOT NULL,
  class_venue	VARCHAR(100),
  communicatioin_tool	VARCHAR(25),
  course_platform	VARCHAR(25),
  field_trips	VARCHAR(3) check(field_trips in ('Yes','No')),
  resources_required TEXT NOT NULL,
  resources_recommended TEXT NOT NULL,
  resources_other TEXT NOT NULL,
  description TEXT NOT NULL,
  outline_url TEXT NOT NULL,
  UNIQUE (code, year, semester, section),
  FOREIGN KEY (instructor_id)
    REFERENCES instructors (instructor_id)
);

CREATE TABLE courses_programs ( --linking table
  course_id INT NOT NULL,
  program_id CHAR(4) NOT NULL,
  FOREIGN KEY (program_id)
    REFERENCES programs (program_id),
  FOREIGN KEY (course_id)
    REFERENCES courses (course_id)
);
CREATE TABLE pre_requisites( --child table
  course_id INT NOT NULL,
  prereq_id VARCHAR(8) NOT NULL,
  PRIMARY KEY (course_id,prereq_id),
  FOREIGN KEY (course_id)
  REFERENCES courses(course_id)
);





\COPY faculties                       
FROM '/home/edlyn/Downloads/Project1/faculties.csv'           
DELIMITER ','
CSV HEADER;

\COPY programs
FROM '/home/edlyn/Downloads/Project1/programs.csv' 
DELIMITER ','
CSV HEADER;

\COPY courses
FROM '/home/edlyn/Downloads/Project1/courses.csv'    
DELIMITER ','
CSV HEADER;


\COPY courses_programs                                         
FROM '/home/edlyn/Downloads/Project1/courses_programs.csv'  
DELIMITER ','
CSV HEADER;


\COPY instructors
FROM '/home/edlyn/Downloads/Project1/instructors.csv'          
DELIMITER ','
CSV HEADER;


\COPY pre_requisites            
FROM '/home/edlyn/Downloads/Project1/pre_reqs.csv' 
DELIMITER ','
CSV HEADER;
 
--Just to check if the tables copied 
--EACH DISPLAY TABLES
SELECT *
FROM faculties;

SELECT *
FROM programs;

SELECT *
FROM courses;

SELECT *
FROM courses_programs;

SELECT *
FROM instructors;

SELECT *
FROM pre_requisites;

--QUERIES

--QUERY 3 What faculties id’s at UB end in S?
SELECT faculty_id,faculty_name
FROM faculties
WHERE faculty_id
LIKE '%S'; --wildcard ends in S

--QUERY 4  What programs are offered in Belize City?
SELECT program_id, faculty_id,program_name,program_location
FROM programs
WHERE program_location='Belize City';

--QUERY 5  What courses does Mrs. Vernelle Sylvester teach?
SELECT  c.course_id,c.code,c.title,i.instructor_id,i.instructor_name
FROM courses AS c
INNER JOIN instructors AS i
ON i.instructor_id=c.instructor_id
WHERE i.instructor_name= 'Vernelle Sylvester'
GROUP BY c.course_id, i.instructor_id; 


--Query 6  Which instructors have a Masters Degree?
SELECT instructor_id,instructor_name,degree
FROM instructors
WHERE degree='M.Sc.';


--Query 7 What are the prerequisites for Programming 2? *extra credit nested sql query to return name of the pre-req

SELECT c.course_id,c.code,c.title,p.prereq_id
FROM courses AS c
INNER JOIN pre_requisites AS p 
ON c.course_id=p.course_id
WHERE c.title='Priciples of Programming 2';

--Query 8 List the code, year, semester section and title for all courses.
SELECT code, year, semester, section, title
FROM courses;


--Query 9 List the program_name and code, year, semester section and title for all courses in the
--AINT program. *hint join 3 tables
SELECT C.code, C.year, C.semester,C.section, C.title,P.program_name
FROM programs AS P 
INNER JOIN courses_programs AS CP 
ON  P.program_id=CP.program_id
INNER JOIN courses AS C 
ON C.course_id=CP.course_id 
WHERE P.program_id='AINT'; 

--Query 10 List the faculty_name and code, year, semester section and title for all courses
--offered by FST. *hint join 4 tables
SELECT C.code,C.year,C.semester,C.section,C.title,P.program_name,F.faculty_id
FROM faculties AS F  --table 1=faculties
INNER JOIN programs AS P   --table 2=programs
ON F.faculty_id=P.faculty_id
INNER JOIN courses_programs AS CP  --table 3= course_programs
ON P.program_id=CP.program_id 
INNER JOIN courses AS C     --table 4=courses
ON CP.course_id=C.course_id  
WHERE F.faculty_id='FST';
