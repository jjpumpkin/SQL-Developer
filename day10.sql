/*
    with �� �� Ī���� ����� select ���� ������ ������.
    �ݺ��Ǵ� ���������� ����ó�� ��밡��
    ��������� Ʃ�� �Ҷ� ���� ���
    
    temp��� �ӽ� ���̺��� ����ؼ� ��ð� �ɸ��� ������ ����� ������ ���� 
    ������ ���� �����͸� �׼��� �ϱ� ������ ������ ���� �� ����.
    oracle 9 �����̻� ����.
    (����) �������� ����.
    
*/
-- �μ��� ���� �հ� -- GROUP BY �μ�
-- ������ ���� �հ� -- GROUP BY ����
-- ��� ��� 
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

/* ����
kor_loan_status ���̺��� '������', '������(��������)' ���� 
���� ������ ���� ���ÿ� �ܾ��� ���Ͻÿ�

------------------------------------------------------------
- 2011���� 12�� 2013���� 11������ ������ ���� ���� �ٸ�.
- ������ �������� ������� ���� �ܾ��� ���� ū �ݾ� ����
- ���� , ������  �����ܾװ� '����������ū �ܾ�' �� ���ؼ� ���� ���� ����
*/
-- ������ 
SELECT MAX(PERIOD) AS max_month
FROM KOR_LOAN_STATUS
GROUP BY SUBSTR(PERIOD,1,4);

-- JOIN --

-- ���� ������ MAX��
SELECT PERIOD , REGION , SUM(LOAN_JAN_AMT) as jan_sum
FROM KOR_LOAN_STATUS
GROUP BY PERIOD , REGION;

-- �������� ������ ���� ū �ݾ�
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
SELECT 'abcd�ȳ�' as pw FROM dual UNION ALL
SELECT 'abcd�ȳ�123' as pw FROM dual )



SELECT *
FROM test_data
WHERE REGEXP_LIKE(PW, '[��-��]');

--���� īƮ �̷��� ���� ���� ���� ���� ���� ���� ������ ����Ͻÿ�.(MEMBER . CART)
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


-- ���� Ǯ�� ����
--WITH A AS (SELECT MEM_ID , MEM_NAME 
--FROM MEMBER)
--,B AS(SELECT CART_MEMBER ,COUNT(DISTINCT(CART_NO)) AS CNT
--FROM CART
--GROUP BY CART_MEMBER)
--SELECT A.MEM_ID, A.MEM_NAME , CNT
--FROM A,B
--WHERE A.MEM_ID = B.CART_MEMBER;


/*
2000 �⵵ ��Ż������ '����� �����' ���� ū '���� ��� �����'�̾���
'���','�����' �� ����Ͻÿ� (�Ҽ��� �ݿø�)
SALES , CUSTOMERS , COUNTRIES (���̺�)
��� ������� AMOUNT_SOLD <-- AVG �� (�ջ��� ���� �׳� ���)
        tip.��������!
        (1) ���������� ��ȸ�Ǵ� ��� �׸��� ����
        (2) �ʿ��� ���̺�� �÷� �ľ�
        (3) ���� ������ �����ؼ� ���� �ۼ�
        (4) ������ ������ ������ �ϳ��� ���� ���� ����� ����
        (5) ����� ����
108.2444
*/
SELECT cust_id,    --�����̵�
       sales_month, --�����
       amount_sold  --����ݾ�
FROM sales;
SELECT  cust_id
      , country_id
FROM customers;
SELECT cuntry_id
      , cuntry_name
FROM countries;


SELECT A.cust_id,    --�����̵�
       A.sales_month, --�����
       A.amount_sold  --����ݾ�
       B.country_id
FROM  sales a
    , customers b
    , countries c
WHERE a.cust_id = b.cust_id
AND  b.country_id =c.country_id
AND  a.sales_month BETWEEN '200001' AND '200012'
AND  c.country_name ='Italy';


SELECT  A.cust_id   --�����̵�
       ,A.sales_month --�����
       ,A.amount_sold  --����ݾ�
       ,B.country_id
FROM  sales a
    , customers b
    , countries c
WHERE a.cust_id = b.cust_id
AND  b.country_id =c.country_id
AND  a.sales_month BETWEEN '200001' AND '200012'
AND  c.country_name ='Italy';



 WITH A as(
        SELECT  A.cust_id   --�����̵�
               ,A.sales_month --�����
               ,A.amount_sold  --����ݾ�
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
         SELECT ROUND(AVG(amount_sold)) as y_avg --�����
         FROM A;
         )
, c as(
                SELECT sales_month
                 ,ROUND(AVG(amount_sold)) as m_avg  --�����
                FROM a
                GROUP BY sales_month
                )
SELECT c.sales_month, c.m_avg
FROM b,c
WHERE c.m_avg >b.y_avg
ORDER BY 1;




--MEMBER,CART,PROD Ȱ�� (cart_qty(����), prod_sale(��ǰ�ݾ�)
--����,��ǰ�� (�����ż���),(��ü�Ǹż���) (�ش��ǰ��ü �Ǹſ����� �� ���ź���)
--            ,(���̱����� �ش���ǰ �����ջ�), (��ü���� �ش� ��ǰ �����ջ�)

SELECT *
FROM MEMBER;

SELECT *
FROM CART;

SELECT *
FROM PROD;

SELECT mem_id 
      ,prod_name 
      ,cart_qty as �����ż���
      ,prod_sale
      ,prod_properstock
FROM cart,prod, member;


      






