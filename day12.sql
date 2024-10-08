/*
    분석함수
    테이블에 있는 로우에 대해 특정 그룹별로 집계 값을 산출할 때 사용함.
    그룹바이절을 사용하는 집계함수와 다른점은 로우 손실 없이 집계값을 산출 할 수 있다.
    
    분석함수는 지원을 많이 소비하는 경향이 있어서 여러 분석함수를 동시에 사용할 경우
    최대한 메인 쿼리에서 사용하는 것이 좋음. (인라인 뷰에서 사용하기 보단..)
    분석함수(매개변수) over(PARTITION BY expr1, expr2..
                         ORDER BY expr3...
                         WINDOW 절)
    AVG, SUM, MAX, COUNT, CUM_DIST, DENSE_RANK, RANK, PERCENT_RANK, FIRST, LAST,LAG.
    PATITION BY : 계산 대상 그룹을 정함.
    ORDER BY    : 대상 그룹에 대한 정렬 수행
    WINDOW      : 파티션으로 분할된 그룹에 대해서 더 상세한 그룹으로 분할 row or range
*/
-- 부서별 이름순으로 순번 출력 
SELECT ROWNUM as rnum
        ,department_id 
        ,emp_name
        , ROW_NUMBER() OVER(PARTITION BY department_id
                    ORDER BY emp_name) dep_rownum
FROM employees;
-- RANK 동일 순위 건너뜀
-- DENSE_RANK() 건너뛰지 않음.
SELECT department_id, emp_name, salary
     , RANK() OVER (PARTITION BY department_id
         ORDER BY salary DESC) as rnk
     ,DENSE_RANK() OVER (PARTITION BY department_id
         ORDER BY salary DESC) as dense_rnk
         -- 동일한 랭킹이 있으면 건너뛰고 안뛰고 차이 DENSE랑
         -- 동일한 샐러리가 있으면 DENSE 는 건너뛰지 않고 RANK는 건너뜀
FROM employees;

-- 부서별 1등 구하라
SELECT *
FROM(
SELECT department_id, emp_name, salary
      , RANK() OVER (PARTITION BY department_id
            ORDER BY salary DESC) as rnk
            ,DENSE_RANK() OVER (PARTITION BY department_id
         ORDER BY salary DESC) as dense_rnk
    FROM employees
    )
    WHERE RNK =1;
--직원의 부서별 월급 합계와 전체 합계출력
SELECT emp_name, salary, department_id
       ,SUM(salary) OVER(PARTITION BY department_id) as 부서별합계
       ,MAX(salary) OVER(PARTITION BY department_id) as 부서최대
       ,MIN(salary) OVER(PARTITION BY department_id) as 부서최소
       ,COUNT(*) OVER(PARTITION BY department_id)    as 부서직원수
       ,SUM(salary) OVER() as 전체합계
FROM employees;

--모든 학생들의 전공별 평점을 기준으로(내림차순) 순위를 출력하시오
-- (전체순위도)
-- 파티션 전공별/ 학점

SELECT 이름,전공,평점
       ,RANK() OVER(PARTITION BY 전공
                   ORDER BY 평점 desc) as 전공별순위
        ,RANK() OVER(ORDER BY 평점 desc) as 전체순위
FROM 학생
ORDER BY 2,4;  --전공 평점이라서 2번째 4번째라
-- 전공별 학생수를 기준으로 순위를 구하시오 (학생수가 많으면 1,...

SELECT 전공,학생수 
       ,RANK()OVER(ORDER BY 학생수 DESC) as 순위
FROM ( SELECT 전공, COUNT(*) as 학생수
       FROM 학생
       GROUP BY 전공
       );
       
SELECT 전공
      ,COUNT(*) as 학생수
      ,RANK() OVER(ORDER BY COUNT(*) DESC) as 순위
FROM 학생
GROUP BY 전공;

/* LAG 선행 로우의 값을 반환
   LEAD 후행 로우의 값을 가져와서 반환
*/
SELECT emp_name, department_id, salary
      ,LAG(emp_name,1,'가장높음') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) lags
      ,LEAD(emp_name,1,'가장낮음') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) leads
FROM employees
WHERE department_id IN(30,60);

    

-- 전공별로 각 학생의 평점보다 한단계 높은 학생과 평점차이를 출력하시오

select 이름,전공,평점
FROM 학생;

/*
SELECT emp_name, department_id, salary
      ,LAG(emp_name,1,'가장높음') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) lags
      ,LEAD(emp_name,1,'가장낮음') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) leads
FROM employees
WHERE department_id IN(30,60);
*/
SELECT 이름,전공,평점 ,LAG(이름,1,'1등')OVER(PARTITION BY 전공
                                    ORDER BY 평점 DESC) as 나보다위학생
                    ,NVL(LAG(평점,1) OVER (PARTITION BY 전공
                                    ORDER BY 평점 DESC)-평점,0) as 평점차이
                   -- ,LAG(평점,1,평점) OVER(PARTITION BY 전공
                                   -- ORDER BY 평점 DESC)-평점 as 평점차이
FROM 학생;
/* WINDOW 절
   ROW: 로우 단위로 WINDOW 절을 지정
   RANGE: 논리적인 범위로 WINDOW절
   BETWEEN ~AND : WINDOW 절의 시작과 끝 지점을 명시한다.
                  BETWEEN 을 명시하지 않고 두번째 옵션만 지정하면 이지점이 시작이되고
                          끝 지점은 현재 로우가 됨
         UNBOUNDED PERCEDING: 파티션으로 구분된 첫번째 로우가 시작점.
         UNBOUNDED FOLLOWING: 파티션으로 구분된 마지막 로우가 끝 지점이 됨.
         CURRENT ROW :시작 및 끝 지점이 현재로우
         expr PRECEDING :끝 지점일 경우, 시작 점은 expr
         expr FOLLOWING: 시작 점일 경우 끝지점은 expr
*/
SELECT  department_id, emp_name, hire_date, salary
        ,SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN UNBOUNDED PRECEDING 
                AND CURRENT ROW) as following_curr
        ,SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN CURRENT ROW
                AND UNBOUNDED FOLLOWING) as curr_following
        ,SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
                ROWS BETWEEN 1 PRECEDING
                AND CURRENT ROW) as jun1_current
        ,SUM(salary) OVER(PARTITION BY department_id ORDER BY hire_date
             ROWS BETWEEN 1 PRECEDING
             AND 1 FOLLOWING) as jun1_daum1
                -- salary 두개를 합쳐 jun1이 나옴
                --ex) 2 번 3번 13000 6000 합쳐서 3번 jun1에 19000나옴
                -- ROWS 행을 기준으로 집계
                -- RANGE 논리적 범위(숫자와 날짜의 형태로 범위를 줄 수 있음)
             ,SUM(salary) OVER(PARTITION BY department_id ORDER BY 
                hire_date RANGE 365 PRECEDING) as years 
                -- 두명을 묶어 각행의 1년전 1년미만인애들 출력
FROM employees;

-- study
-- 월별 전체 누적매출을 출력하시오
SELECT T1.*
,SUM(T1.월매출) OVER(ORDER BY 년월
                         ROWS BETWEEN UNBOUNDED PRECEDING 
                         AND CURRENT ROW) AS 누적집계
    ,ROUND(RATIO_TO_REPORT(T1.월매출) OVER() * 100,2) ||'%' AS 비율
    
FROM (SELECT SUBSTR(a.reserv_Date,1,6) as 년월
    ,SUM(b.sales) as 월매출
    FROM RESERVATION A , ORDER_INFO B
    WHERE a.reserv_no = b.reserv_no
    GROUP BY substr(a.reserv_Date,1,6)
    ORDER BY 1
    ) T1;
    
    
    
    
    
-- 지역별, 대출 종류별, 월별, 대출잔액과 지역별 파티션대출 종류별 대출잔액의 % 를 구하시오.
--201210~201212

SELECT REGION , GUBUN

,(PR1||'(  '|| ROUND(RATIO_TO_REPORT(PR1) OVER(PARTITION BY REGION) *100 ) ||'% )') "201210"
,(PR2||'(  '|| ROUND(RATIO_TO_REPORT(PR2) OVER(PARTITION BY REGION) *100 ) ||'% )') "201211"
,(PR3||'(  '|| ROUND(RATIO_TO_REPORT(PR3) OVER(PARTITION BY REGION) *100 ) ||'% )') "201212"

FROM (
        SELECT REGION , GUBUN 
        ,SUM(DECODE(PERIOD,'201210',LOAN_JAN_AMT )) PR1
        ,SUM(DECODE(PERIOD,'201211',LOAN_JAN_AMT )) PR2
        ,SUM(DECODE(PERIOD,'201212',LOAN_JAN_AMT )) PR3
        FROM KOR_LOAN_STATUS
        GROUP BY REGION , GUBUN 
        ORDER BY 1,2);




-- 201210 ~201212
-- 지역별, 대출종류별, 월별, 대출잔액과 지역별 파티션 대출종류별 대출잔액의 %를 구하시오
-- 1.지역, 구분,각 년월에 해당되는 컬럼 출력 select 문작성
-- 2.지역별, 구분별 합계
-- 3.2에서 구한 합계와 구분별 (비율)을 출력

SELECT region
      ,gubun
FROM 













       
