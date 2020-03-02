--Number of [titles] Retiring
select e.emp_no,
e.first_name,
e.last_name,
t.title,
t.from_date,
t.to_date,
s.salary
into number_of_titles_retiring
from employees as e
inner join titles as t
on (e.emp_no = t.emp_no)
inner join salaries as s
on (e.emp_no = s.emp_no);

--Only the Most Recent Titles
SELECT
  first_name,
  last_name,
  from_date,
  count(*)
FROM number_of_titles_retiring
GROUP BY
  first_name,
  last_name,
  from_date
HAVING count(*) > 1;


SELECT * FROM
  (SELECT *, count(*)
  OVER
    (PARTITION BY
      first_name,
      last_name
    ) AS count
  FROM number_of_titles_retiring) tableWithCount
  WHERE tableWithCount.count > 1;
  
  
SELECT emp_no, first_name, last_name, from_date, to_date, title
INTO employee_most_recent_title
FROM
  (SELECT emp_no, first_name, last_name, from_date, to_date, title,
     ROW_NUMBER() OVER 
(PARTITION BY (first_name, last_name) ORDER BY from_date DESC) rn
   FROM number_of_titles_retiring
  ) tmp WHERE rn = 1;

--Who’s Ready for a Mentor?
select e.emp_no,
e.first_name,
e.last_name,
rt.title,
rt.from_date,
rt.to_date
into ready_mentor
from employees as e
inner join employee_most_recent_title as rt
on (e.emp_no = rt.emp_no)
WHERE rt.to_date = ('9999-01-01')
AND e.birth_date between '1965-01-01' and '1965-12-31'
