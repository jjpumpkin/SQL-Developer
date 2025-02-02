/*
    with 절 별 칭으로 사용한 select 문을 참조가 가능함.
    반복되는 서브쿼리를 변수처럼 사용가능
    통계쿼리나 튜닝 할때 많이 사용
    
    temp라는 임시 테이블을 사용해서 장시간 걸리는 쿼리의 결과를 저장해 놓고 
    저장해 놓은 데이터를 액세스 하기 때문에 성능이 좋을 수 있음.
    oracle 9 버젼이상 지원.
    (장점) 가독성이 좋음.
    
*/
-- 부서별 월급 합계 -- GROUP BY 부서
-- 직무별 월급 합계 -- GROUP BY 직무
-- 결과 출력 
WITH A as( SELECT employee_id, emp_name , department_id , job_id ,salary
            FROM employees )
, B as ( SELECT department_id ,SUM(salary) as dep_sum, COUNT(department_id) as dep_cnt
        FROM a
        GROUP BY department_id
), C as ( 
SELECT job_id, SUM(salary) as job_sum, COUNT(job_id) as job_cnt
        FROM a
        GROUP BY job_id)
        
SELECT a.employee_id , a.emp_name, a.salary 
        , b. dep_sum ,b.dep_cnt
        , a.job_id ,c.job_sum , c.job_cnt
FROM a,b,c
WHERE a.department_id = b.department_id
AND a.job_id = c.job_id;

/* 문제
kor_loan_status 테이블에서 '연도별', '최종월(마지막월)' 기준 
가장 대출이 많은 도시와 잔액을 구하시오

------------------------------------------------------------
- 2011년은 12월 2013년은 11월으로 연도별 최종 월이 다름.
- 연도별 최종월을 대상으로 대출 잔액이 가장 큰 금액 추출
- 월별 , 지역별  대출잔액과 '연도별가장큰 잔액' 과 비교해서 같은 건을 추출
*/
-- 최종월 
SELECT MAX(PERIOD) AS max_month
FROM KOR_LOAN_STATUS
GROUP BY SUBSTR(PERIOD,1,4);

-- JOIN --

-- 월별 지역별 MAX값
SELECT PERIOD , REGION , SUM(LOAN_JAN_AMT) as jan_sum
FROM KOR_LOAN_STATUS
GROUP BY PERIOD , REGION;

-- 최종월의 대출이 가장 큰 금액
SELECT b.period
,max(b.jan_sum) as max_jan_amt
FROM 
        ( SELECT PERIOD , REGION , SUM(LOAN_JAN_AMT) as jan_sum
        FROM KOR_LOAN_STATUS
        GROUP BY PERIOD , REGION ) b
       ,( SELECT MAX(PERIOD) AS max_month
        FROM KOR_LOAN_STATUS
        GROUP BY SUBSTR(PERIOD,1,4) ) a

WHERE b.period = a.max_month
GROUP BY b.period;

SELECT b2.*
FROM    ( SELECT PERIOD , REGION , SUM(LOAN_JAN_AMT) as jan_sum
        FROM KOR_LOAN_STATUS
        GROUP BY PERIOD , REGION) b2
        
        ,( SELECT b.period
        ,max(b.jan_sum) as max_jan_amt
        FROM 
                ( SELECT PERIOD , REGION , SUM(LOAN_JAN_AMT) as jan_sum
                FROM KOR_LOAN_STATUS
                GROUP BY PERIOD , REGION ) b
            
               ,( SELECT MAX(PERIOD) AS max_month
                FROM KOR_LOAN_STATUS
                GROUP BY SUBSTR(PERIOD,1,4) ) a

        WHERE b.period = a.max_month
        GROUP BY b.period ) c
        
    WHERE b2.period = c.period
    AND b2.jan_sum = c.max_jan_amt
    ORDER BY 1;




WITH B AS (SELECT PERIOD , REGION , SUM(LOAN_JAN_AMT) as jan_sum
        FROM KOR_LOAN_STATUS
        GROUP BY PERIOD , REGION )  
    ,C AS (SELECT B.PERIOD, MAX(B.jan_sum) AS MAX_JAN_AMT
            FROM B,
            (SELECT MAX(PERIOD) AS max_month
            FROM KOR_LOAN_STATUS
            GROUP BY SUBSTR(PERIOD,1,4)) A
        WHERE B.PERIOD = A.MAX_MONTH
        GROUP BY B.PERIOD
        )
SELECT B.*
FROM B,C
WHERE B.PERIOD = C.PERIOD
AND B.JAN_SUM = C.MAX_JAN_AMT
ORDER BY 1;

WITH test_data AS (SELECT 'abcd' as pw FROM dual UNION ALL
SELECT 'abcd안녕' as pw FROM dual UNION ALL
SELECT 'abcd안녕123' as pw FROM dual )



SELECT *
FROM test_data
WHERE REGEXP_LIKE(PW, '[가-힝]');

--고객증 카트 이력이 가장 많은 고객과 가장 적은 고객의 정보를 출력하시오.(MEMBER . CART)
SELECT MEM_ID , MEM_NAME 
FROM MEMBER;

WITH T1 AS
        (SELECT A.MEM_ID , A.MEM_NAME ,COUNT(DISTINCT B.CART_NO) CNT
        FROM MEMBER A , CART B
        WHERE A.MEM_ID = B.CART_MEMBER
        GROUP BY A.MEM_ID, A.MEM_NAME)
        
,T2 AS( SELECT MAX(T1.CNT) AS MAX_CNT ,MIN(T1.CNT) MIN_CNT
        FROM T1)
        
SELECT T1.MEM_ID , T1.MEM_NAME ,T1.CNT
FROM T1,T2
WHERE T1.CNT = T2.MAX_CNT
OR T1.CNT = T2.MIN_CNT
ORDER BY 1;


-- 내가 풀다 만것
--WITH A AS (SELECT MEM_ID , MEM_NAME 
--FROM MEMBER)
--,B AS(SELECT CART_MEMBER ,COUNT(DISTINCT(CART_NO)) AS CNT
--FROM CART
--GROUP BY CART_MEMBER)
--SELECT A.MEM_ID, A.MEM_NAME , CNT
--FROM A,B
--WHERE A.MEM_ID = B.CART_MEMBER;


/*
2000 년도 이탈리아의 '연평균 매출액' 보다 큰 '월의 평균 매출액'이었던
'년월','매출액' 을 출력하시오 (소수점 반올림)
SALES , CUSTOMERS , COUNTRIES (테이블)
평균 매출액은 AMOUNT_SOLD <-- AVG 로 (합산평군 말고 그냥 평균)
        tip.분할정복!
        (1) 최종적으로 조회되는 결과 항목을 정의
        (2) 필요한 테이블과 컬럼 파악
        (3) 작은 단위로 분할해서 쿼리 작성
        (4) 분할한 단위의 쿼리를 하나로 합쳐 최종 결과를 산출
        (5) 결과를 검증
108.2444
*/
SELECT cust_id,    --고객아이디
       sales_month, --매출월
       amount_sold  --매출금액
FROM sales;
SELECT  cust_id
      , country_id
FROM customers;
SELECT cuntry_id
      , cuntry_name
FROM countries;


SELECT A.cust_id,    --고객아이디
       A.sales_month, --매출월
       A.amount_sold  --매출금액
       B.country_id
FROM  sales a
    , customers b
    , countries c
WHERE a.cust_id = b.cust_id
AND  b.country_id =c.country_id
AND  a.sales_month BETWEEN '200001' AND '200012'
AND  c.country_name ='Italy';


SELECT  A.cust_id   --고객아이디
       ,A.sales_month --매출월
       ,A.amount_sold  --매출금액
       ,B.country_id
FROM  sales a
    , customers b
    , countries c
WHERE a.cust_id = b.cust_id
AND  b.country_id =c.country_id
AND  a.sales_month BETWEEN '200001' AND '200012'
AND  c.country_name ='Italy';



 WITH A as(
        SELECT  A.cust_id   --고객아이디
               ,A.sales_month --매출월
               ,A.amount_sold  --매출금액
               ,B.country_id
        FROM  sales a
            , customers b
            , countries c
        WHERE a.cust_id = b.cust_id
        AND  b.country_id =c.country_id
        AND  a.sales_month BETWEEN '200001' AND '200012'
        AND  c.country_name ='Italy'
)
, b as(
         SELECT ROUND(AVG(amount_sold)) as y_avg --연평균
         FROM A;
         )
, c as(
                SELECT sales_month
                 ,ROUND(AVG(amount_sold)) as m_avg  --월평균
                FROM a
                GROUP BY sales_month
                )
SELECT c.sales_month, c.m_avg
FROM b,c
WHERE c.m_avg >b.y_avg
ORDER BY 1;




--MEMBER,CART,PROD 활용 (cart_qty(수량), prod_sale(상품금액)
--고객별,상품별 (고객구매수량),(전체판매수량) (해당상품전체 판매에서의 고객 구매비율)
--            ,(고객이구매한 해당제품 구매합산), (전체에서 해당 제품 구매합산)

SELECT *
FROM MEMBER;

SELECT *
FROM CART;

SELECT *
FROM PROD;

SELECT mem_id 
      ,prod_name 
      ,cart_qty as 고객구매수량
      ,prod_sale
      ,prod_properstock
FROM cart,prod, member;


      






