--ROTEIRO 9 - BANCO DE DADOS
--ALUNA: IELE PASSOS
--MATRÍCULA: 119110826

--Q1

--a

CREATE VIEW vw_dptmgr
AS SELECT d.dnumber, e.fname
FROM department d, employee e
WHERE d.mgrssn = e.ssn;

--b

CREATE VIEW vw_empl_houston
AS SELECT ssn, fname
FROM employee
WHERE address like '%Houston%';

--c 

CREATE VIEW vw_deptstats
AS SELECT dnumber, dname, COUNT (*) AS number_employees 
FROM employee e, department d  
WHERE d.dnumber = e.dno 
GROUP BY d.dnumber;

--d

CREATE VIEW vw_projstats 
AS SELECT pno, COUNT (*) AS number_project_employees 
FROM project p, works_on w  
WHERE w.pno = p.pnumber 
GROUP BY w.pno;


--Q2

--wv_dptmgr

SELECT * FROM wv_dptmgr;
SELECT e.fname, d.dname from employee e, department d where e.ssn = d.mgrssn;
SELECT dnumber, dname from  department ;

--vw_houston

SELECT * FROM vw_empl_houston;
SELECT * FROM employee;

--vw_deptstats

SELECT * FROM vw_deptstats;
SELECT dname, dnumber FROM  department d;
SELECT COUNT(dno) FROM employee WHERE dno = 8;
SELECT COUNT(dno) FROM employee WHERE dno = 4;
SELECT COUNT(dno) FROM employee WHERE dno = 1;
SELECT COUNT(dno) FROM employee WHERE dno = 5;
SELECT COUNT(dno) FROM employee WHERE dno = 6;
SELECT COUNT(dno) FROM employee WHERE dno = 7;

--vw_projstats

SELECT * FROM vw_projstats;


--Q3

DROP VIEW vw_dptmgr;
DROP VIEW vw_empl_houston;
DROP VIEW vw_deptstats;
DROP VIEW vw_projstats;


--Q4

CREATE OR REPLACE FUNCTION check_age(e_ssn char(9)) 
returns VARCHAR AS 
$check_age$

DECLARE 
	employee_age INTEGER;
	retorna VARCHAR;

BEGIN 
	SELECT date_part('year',age(bdate)) into employee_age
	FROM employee
	WHERE e_ssn = ssn;

	IF employee_age >= 50 then retorna := 'SENIOR';
	ELSIF employee_age < 50 and employee_age >= 0 then retorna := 'YOUNG';
    	ELSIF employee_age is null then retorna := 'UNKNOWN';
    	ELSE retorna := 'INVALID';
    	END if;

  	RETURN retorna;
END;
$check_age$ LANGUAGE plpgsql;


--Q5

CREATE OR REPLACE FUNCTION check_mgr() 
RETURNS trigger AS 
$check_mgr$

DECLARE
employee_dno INTEGER;
supervisees_qtd INTEGER;

BEGIN
	SELECT dno 
	FROM employee 
	INTO employee_dno 
	WHERE NEW.mgrssn = employee.ssn;

	SELECT COUNT(*) 
	FROM employee 
	AS emp 
	INTO supervisees_qtd 
	INNER JOIN employee 
	AS sup 
	ON sup.ssn = emp.superssn 
	GROUP BY sup.ssn 
	HAVING sup.ssn = NEW.mgrssn;

        IF employee_dno != NEW.dnumber OR NEW.mgrssn IS NULL THEN
            RAISE EXCEPTION 'manager must be a department''s employee';
	END IF;
        IF(supervisees_qtd = 0 OR supervisees_qtd IS NULL) THEN
            RAISE EXCEPTION 'manager must have supervisees';
	END IF;
        IF check_age(NEW.mgrssn) != 'SENIOR' THEN
            RAISE EXCEPTION 'manager must be a SENIOR employee';
        END IF;

	RETURN NEW;
END;
$check_mgr$ LANGUAGE plpgsql;

CREATE TRIGGER check_mgr BEFORE INSERT OR UPDATE ON department FOR EACH ROW EXECUTE PROCEDURE check_mgr(); 
