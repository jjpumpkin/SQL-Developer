/*
    집계함수와 그룹바이절
    집계함수 대상 데이터를 대해 총합 ,평균 ,최댓값, 최솟값 등을 구하는 함수
    그룹바이 절 대상 데이터를 특정그룹으로 묶는 방법
*/
--COUNT 로우 수를 반환하는 집계함수.
SELECT COUNT(*)                     -- null 포함  카운트 별은 어느하나에 널이 있더라도 
                                    -- 전체 행의 수가 나옴 
     ,COUNT(department_id)          --default ALL  디팔트먼트 건에만 널값은 제외 106나옴
     ,COUNT(ALL department_id)      --중복 포함, null x
     ,COUNT(DISTINCT department_id) -- 중복 제거
     ,COUNT(employee_id)            -- employees테이블의 pk (*) 같음
FROM employees;

SELECT SUM(salary)          as 합계
      ,MAX(salary)          as 최대
      ,MIN(salary)          as 최소
      ,ROUND(AVG(salary),2) as 평균
      ,COUNT(employee_id)   as 직원수
FROM employees                    --직원 테이블의
WHERE department_id IS NOT NULL   --검색조건이 있다면 FROM 사이에 GROUP
AND department_id IN(30,60,90)    
GROUP BY department_id            --부서 별 (그룹으로 집계)
ORDER BY 1;

-- MEMBER 회원수와 마일리지 합계, 평균을 출력하시오
SELECT  MEM_JOB                   as 직업
       ,COUNT(mem_id)             as 회원수
       ,SUM(mem_mileage)          as 마일리지합계
       ,ROUND(AVG(mem_mileage),2) as 마일리지평균  --as 쓰고 단어 붙이기
FROM member
GROUP BY MEM_JOB
ORDER BY 3 DESC;  -- 3은 세번째 마일리지 합계를 뜻함

-- 직업별 회원수와 마일리지 합계 ,평균 출력(마일리지 합계 내림차순)
SELECT mem_job                    as 직업
      ,COUNT(mem_id)              as 회원수
      ,SUM(mem_mileage)           as 마일리지합계
      ,ROUND(AVG(mem_mileage),2)  as 마일리지평균
FROM member
GROUP BY mem_job
HAVING SUM(mem_mileage) >= 10000  --집계결과에 검색조건
ORDER BY 3 DESC;

-- ROWNUM 의사컬럼 테이블에는 없지만 있는것 처럼 사용가능
SELECT ROWNUM as rnum
       ,mem_name
FROM member
WHERE ROWNUM <=10;

-- kor_loan_status (java계정) 테이블의  loan_jan_amt (대출액)
-- 2013년도 기간별 총 대출잔액을 출력하시오
SELECT SUBSTR(period,1,4) as 년도
      ,region             as 지역
      ,gubun              as 구분 
      ,SUM(loan_jan_amt)  as 대출합
FROM kor_loan_status
-- WHERE period LIKE '2013%'; 같은값
WHERE SUBSTR(period,1,4) = '2013'
GROUP BY SUBSTR(period,1,4) , region, gubun
ORDER BY 2;

-- 전체 지역별 대출의 합계가 20000 이상인 결과를 출력하시오
-- 대출잔액 내림차순
--
SELECT region             as 지역
      ,SUM(loan_jan_amt)  as 대출합
FROM  kor_loan_status
GROUP BY region
HAVING SUM(loan_jan_amt) >=20000
ORDER BY 2 DESC;

--대전, 서울, 부산의
--년도별 대출의 합계에서 
--대출의 합이 60000넘는 결과를 출력하시오
--정렬 지역 오름차순,대출합 내림차순

SELECT SUBSTR(period,1,4) as 년도
      ,region             as 지역
      ,SUM(loan_jan_amt)  as 대출합
      
FROM kor_loan_status
WHERE region IN('대전','서울','부산')
GROUP BY SUBSTR(period, 1,4), region
HAVING SUM(loan_ja
      ,SUM(loan_jan_amt) >=60000
ORDER BY 2 ASC ,
         3 DESC;
      
         
--employees 직원들의 입사년도별 직원수를 출력하시오
--hire_date 사용(정렬 년도 오름차순)
-- 연도는 TO_CHAR 사용
SELECT TO_CHAR (hire_date,'YYYY') 년도
       ,COUNT(*) as 직원수
FROM employees
GROUP BY TO_CHAR(hire_date,'YYYY')
HAVING COUNT(*) >=10
ORDER BY 1;


-- customer 회원의 전체 회원수, 남자 회원수, 여자 회원수를 출력하시오
-- 남자, 여자라는 컬럼음 없음.
-- customers 테이블의 컬럼을 활용해서 만들어야함.
-- decode로 표현을 바꿈

SELECT     COUNT (cust_gender)  as 전체    
          , COUNT(DECODE(cust_gender, 'F','여자')) as 여자
          , SUM(DECODE(cust_gender,'F',1,0))      as 여자2
          , COUNT(DECODE(cust_gender,'M','남자'))  as 남자
          , SUM(DECODE(cust_gender,'M',1,0))      as 남자2
  FROM customers ;
  
  
SELECT emp_name, email
FROM employees;

-- 1.정렬 요일 일요일 부터 ~(employees, hire_date)사용
SELECT  to_char(hire_date,'day')     as 요일 
       ,COUNT(*) as 입사직원수 --행의 수를 세는게 *
FROM employees
GROUP BY to_char(hire_date,'day') --해당조건을 기준으로 같은데이터 묶어라
ORDER BY 
    CASE 
     WHEN (to_char(hire_date,'day'))='일요일'THEN 1 
     WHEN (to_char(hire_date,'day'))='월요일'THEN 2 
     WHEN (to_char(hire_date,'day'))='화요일'THEN 3 
     WHEN (to_char(hire_date,'day'))='수요일'THEN 4 
     WHEN (to_char(hire_date,'day'))='목요일'THEN 5 
     WHEN (to_char(hire_date,'day'))='금요일'THEN 6 
     WHEN (to_char(hire_date,'day'))='토요일'THEN 7 --순서를 정렬
END; 

--2.년도별 요일의 고용인원수를 출력하시오
--(employees, hire_date)사용
--정렬 년도 오름차순



SELECT to_char (hire_date,'yyyy') as 년도,
   COUNT(to_char (hire_date,'day')="일요일"  )as 'SUN', 
       to_char (hire_date,'day')="월요일"  as 'MON',
       to_char (hire_date,'day')="화요일" as 'TUE',
       to_char (hire_date,'day')="수요일" as 'WED',
          to_char (hire_date,'day')="목요일" as 'THU',
           to_char (hire_date,'day')="금요일" as 'FRI',
            to_char (hire_date,'day')="토요일" as 'SAT'
FROM employees
GROUP BY to_char(hire_date,'yyyy');
-- 
      






