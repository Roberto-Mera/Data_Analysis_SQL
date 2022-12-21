SELECT IF(Grades.Grade<8,NULL,Students.Name), 
Grades.Grade, 
Students.Marks 
FROM  Students, Grades
WHERE (Students.Marks <= Grades.Max_Mark 
AND Students.Marks >= Grades.Min_Mark)
ORDER BY Grades.Grade DESC,  Students.Name ASC, Students.Marks ASC;