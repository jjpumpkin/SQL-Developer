-- 마일리지 하는법
SELECT MEM_NAME
     , MEM_JOB
     , MEM_LIKE
     , MEM_MILEAGE
     , CASE WHEN MEM_MILEAGE <5000 THEN 'sliver'
         WHEN MEM_MILEAGE >=5000 AND MEM_MILEAGE <8000 THEN 'gold'
         ELSE 'VIP'
         END as grade
         FROM member
          WHERE MEM_JOB='주부' OR
         MEM_JOB='회사원' OR
         MEM_JOB='자영업'
         
         
         ORDER BY MEM_MILEAGE DESC;
     