SELECT 
IF(A>=B+C OR B>=A+C OR C>=A+B, "Not A Triangle",
   IF(A=B AND B=C, "Equilateral",
      IF(A !=B AND B !=C AND A !=C, "Scalene","Isosceles")
      )
   ) AS Tipo
FROM TRIANGLES;
