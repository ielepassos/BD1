--ROTEIRO 5
--ALUNA: IELE FACUNDO PASSOS
--MATRÍCULA: 119110826

--Q1

SELECT COUNT(sex) FROM employee WHERE sex = 'F';

--Q2

SELECT AVG(salary) FROM employee WHERE employee.address LIKE '%TX' AND sex = 'M';

--Q3

SELECT e.superssn AS ssn_supervisor, COUNT(e.ssn) AS qtd_supervisionados FROM employee AS e GROUP BY e.superssn ORDER BY COUNT(*) ASC;

--Q4

SELECT e.fname AS nome_supervisor, COUNT(*) AS qtd_supervisionados FROM (employee AS e JOIN employee AS s ON e.ssn = s.superssn) GROUP BY e.ssn ORDER BY COUNT(*) ASC;

--Q5

SELECT e.fname AS nome_supervisor, COUNT(*) AS qtd_supervisionados FROM (employee AS e RIGHT OUTER JOIN employee AS s ON e.ssn = s.superssn) GROUP BY e.ssn ORDER BY COUNT(*) ASC;

--Q6

SELECT MIN(COUNT) AS qtd FROM ( SELECT COUNT(*) FROM works_on GROUP BY pno) AS a;

--Q7

SELECT pno AS num_projeto, qtd AS qtd_func FROM ((SELECT pno, COUNT(*) FROM works_on GROUP BY pno) AS a JOIN (SELECT MIN(COUNT) AS qtd FROM (SELECT COUNT(*) FROM works_on GROUP BY pno) AS b) AS minimum ON a.COUNT = minimum.qtd);

--Q8

SELECT pno AS num_proj, AVG(salary) AS media_sal FROM works_on j JOIN employee e ON (j.essn = e.ssn) GROUP BY pno;

--Q9

SELECT pno AS proj_num, pname AS proj_nome, AVG(salary) AS media_sal FROM project p JOIN (works_on j JOIN employee e ON (j.essn = e.ssn)) ON (p.pnumber = j.pno) GROUP BY j.pno, p.pname ORDER BY AVG(salary) ASC;

--Q10

SELECT e.fname, e.salary FROM employee AS e WHERE e.salary > ALL (SELECT e.salary FROM works_on AS j JOIN employee AS e ON (j.essn = e.ssn AND j.pno = 92));

--Q11

SELECT e.ssn AS ssn, COUNT(w.pno) AS qtd_proj FROM employee AS e LEFT OUTER JOIN works_on AS w ON (e.ssn = w.essn) GROUP BY e.ssn ORDER BY COUNT(w.pno) ASC;

--Q12

SELECT pno AS num_proj, COUNT AS qtd_func FROM (SELECT pno, COUNT(*) FROM employee AS e LEFT OUTER JOIN works_on AS j ON (j.essn = e.ssn) GROUP BY pno) AS qtd WHERE qtd.count < 5;

--Q13

SELECT e.fname FROM employee AS e WHERE e.ssn IN (SELECT e.ssn FROM works_on AS j WHERE(e.ssn = j.essn) AND j.pno IN (SELECT j.pno FROM project AS p WHERE (p.pnumber = j.pno) AND p.pname IN (SELECT p.pname FROM project AS p WHERE (p.plocation = 'Sugarland') AND EXISTS(SELECT pname FROM dependent AS d WHERE d.essn = e.ssn))));

--Q14

SELECT d.dname FROM department AS d WHERE NOT EXISTS( SELECT * FROM project AS p WHERE p.dnum = d.dnumber);

--Q15

SELECT DISTINCT fname, lname FROM employee AS e, works_on WHERE essn = ssn AND ssn <> '123456789' AND NOT EXISTS ((SELECT pno FROM works_on WHERE essn ='123456789')EXCEPT(SELECT pno FROM works_on WHERE essn = e.ssn));


