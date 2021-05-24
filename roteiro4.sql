-- Roteiro 4 - Banco de Dados 
-- Aluna: Iele Passos

-- Q1

SELECT * FROM department;

-- Q2

SELECT * FROM dependent;

--Q3

SELECT * FROM dept_locations;

-- Q4

SELECT * FROM employee;

--Q5

SELECT * FROM project;

--Q6

SELECT * FROM works_on;

--Q7

SELECT fname, lname FROM employee WHERE sex='M';

--Q8 

SELECT fname FROM employee WHERE sex='M' AND superssn IS NULL;

--Q9

SELECT e.fname, s.fname FROM employee e, employee s WHERE s.ssn = e.superssn;

--Q10

SELECT e.fname FROM employee e, employee s WHERE s.ssn = e.superssn AND s.fname='Franklin';

--Q11

SELECT d.dname, l.dlocation FROM department d, dept_locations l WHERE d.dnumber = l.dnumber;

-- Q12

SELECT d.dname, l.dlocation FROM department d, dept_locations l WHERE d.dnumber = l.dnumber AND l.dlocation LIKE 'S%';

-- Q13 

SELECT e.fname, e.lname, d.dependent_name FROM employee e, dependent d WHERE d.essn = e.ssn;

-- Q14

SELECT (e.fname || ' ' || e.minit || ' ' || e.lname) AS full_name, salary FROM employee e WHERE e.salary > 50000;

-- Q15

SELECT p.pname, d.dname FROM project p, department d WHERE d.dnumber = p.dnum;

-- Q16

SELECT p.pname, g.fname FROM project p, department d, employee g WHERE p.dnum = d.dnumber AND d.mgrssn = g.ssn AND p.pnumber > 30;

-- Q17

SELECT p.pname, e.fname FROM project p, employee e, works_on j WHERE p.pnumber = j.pno AND j.essn = e.ssn;

-- Q18

SELECT e.fname, d.dependent_name, d.relationship FROM employee e, dependent d, works_on j WHERE d.essn = e.ssn AND e.ssn = j.essn AND j.pno = 91;



