/*
    �м��Լ�
    ���̺� �ִ� �ο쿡 ���� Ư�� �׷캰�� ���� ���� ������ �� �����.
    �׷�������� ����ϴ� �����Լ��� �ٸ����� �ο� �ս� ���� ���谪�� ���� �� �� �ִ�.
    
    �м��Լ��� ������ ���� �Һ��ϴ� ������ �־ ���� �м��Լ��� ���ÿ� ����� ���
    �ִ��� ���� �������� ����ϴ� ���� ����. (�ζ��� �信�� ����ϱ� ����..)
    �м��Լ�(�Ű�����) over(PARTITION BY expr1, expr2..
                         ORDER BY expr3...
                         WINDOW ��)
    AVG, SUM, MAX, COUNT, CUM_DIST, DENSE_RANK, RANK, PERCENT_RANK, FIRST, LAST,LAG.
    PATITION BY : ��� ��� �׷��� ����.
    ORDER BY    : ��� �׷쿡 ���� ���� ����
    WINDOW      : ��Ƽ������ ���ҵ� �׷쿡 ���ؼ� �� ���� �׷����� ���� row or range
*/
-- �μ��� �̸������� ���� ��� 
SELECT ROWNUM as rnum
        ,department_id 
        ,emp_name
        , ROW_NUMBER() OVER(PARTITION BY department_id
                    ORDER BY emp_name) dep_rownum
FROM employees;
-- RANK ���� ���� �ǳʶ�
-- DENSE_RANK() �ǳʶ��� ����.
SELECT department_id, emp_name, salary
     , RANK() OVER (PARTITION BY department_id
         ORDER BY salary DESC) as rnk
     ,DENSE_RANK() OVER (PARTITION BY department_id
         ORDER BY salary DESC) as dense_rnk
         -- ������ ��ŷ�� ������ �ǳʶٰ� �ȶٰ� ���� DENSE��
         -- ������ �������� ������ DENSE �� �ǳʶ��� �ʰ� RANK�� �ǳʶ�
FROM employees;

-- �μ��� 1�� ���϶�
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
--������ �μ��� ���� �հ�� ��ü �հ����
SELECT emp_name, salary, department_id
       ,SUM(salary) OVER(PARTITION BY department_id) as �μ����հ�
       ,MAX(salary) OVER(PARTITION BY department_id) as �μ��ִ�
       ,MIN(salary) OVER(PARTITION BY department_id) as �μ��ּ�
       ,COUNT(*) OVER(PARTITION BY department_id)    as �μ�������
       ,SUM(salary) OVER() as ��ü�հ�
FROM employees;

--��� �л����� ������ ������ ��������(��������) ������ ����Ͻÿ�
-- (��ü������)
-- ��Ƽ�� ������/ ����

SELECT �̸�,����,����
       ,RANK() OVER(PARTITION BY ����
                   ORDER BY ���� desc) as ����������
        ,RANK() OVER(ORDER BY ���� desc) as ��ü����
FROM �л�
ORDER BY 2,4;  --���� �����̶� 2��° 4��°��
-- ������ �л����� �������� ������ ���Ͻÿ� (�л����� ������ 1,...

SELECT ����,�л��� 
       ,RANK()OVER(ORDER BY �л��� DESC) as ����
FROM ( SELECT ����, COUNT(*) as �л���
       FROM �л�
       GROUP BY ����
       );
       
SELECT ����
      ,COUNT(*) as �л���
      ,RANK() OVER(ORDER BY COUNT(*) DESC) as ����
FROM �л�
GROUP BY ����;

/* LAG ���� �ο��� ���� ��ȯ
   LEAD ���� �ο��� ���� �����ͼ� ��ȯ
*/
SELECT emp_name, department_id, salary
      ,LAG(emp_name,1,'�������') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) lags
      ,LEAD(emp_name,1,'���峷��') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) leads
FROM employees
WHERE department_id IN(30,60);

    

-- �������� �� �л��� �������� �Ѵܰ� ���� �л��� �������̸� ����Ͻÿ�

select �̸�,����,����
FROM �л�;

/*
SELECT emp_name, department_id, salary
      ,LAG(emp_name,1,'�������') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) lags
      ,LEAD(emp_name,1,'���峷��') OVER(PARTITION BY department_id
                                    ORDER BY salary DESC) leads
FROM employees
WHERE department_id IN(30,60);
*/
SELECT �̸�,����,���� ,LAG(�̸�,1,'1��')OVER(PARTITION BY ����
                                    ORDER BY ���� DESC) as ���������л�
                    ,NVL(LAG(����,1) OVER (PARTITION BY ����
                                    ORDER BY ���� DESC)-����,0) as ��������
                   -- ,LAG(����,1,����) OVER(PARTITION BY ����
                                   -- ORDER BY ���� DESC)-���� as ��������
FROM �л�;
/* WINDOW ��
   ROW: �ο� ������ WINDOW ���� ����
   RANGE: ������ ������ WINDOW��
   BETWEEN ~AND : WINDOW ���� ���۰� �� ������ ����Ѵ�.
                  BETWEEN �� ������� �ʰ� �ι�° �ɼǸ� �����ϸ� �������� �����̵ǰ�
                          �� ������ ���� �ο찡 ��
         UNBOUNDED PERCEDING: ��Ƽ������ ���е� ù��° �ο찡 ������.
         UNBOUNDED FOLLOWING: ��Ƽ������ ���е� ������ �ο찡 �� ������ ��.
         CURRENT ROW :���� �� �� ������ ����ο�
         expr PRECEDING :�� ������ ���, ���� ���� expr
         expr FOLLOWING: ���� ���� ��� �������� expr
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
                -- salary �ΰ��� ���� jun1�� ����
                --ex) 2 �� 3�� 13000 6000 ���ļ� 3�� jun1�� 19000����
                -- ROWS ���� �������� ����
                -- RANGE ���� ����(���ڿ� ��¥�� ���·� ������ �� �� ����)
             ,SUM(salary) OVER(PARTITION BY department_id ORDER BY 
                hire_date RANGE 365 PRECEDING) as years 
                -- �θ��� ���� ������ 1���� 1��̸��ξֵ� ���
FROM employees;

-- study
-- ���� ��ü ���������� ����Ͻÿ�
SELECT T1.*
,SUM(T1.������) OVER(ORDER BY ���
                         ROWS BETWEEN UNBOUNDED PRECEDING 
                         AND CURRENT ROW) AS ��������
    ,ROUND(RATIO_TO_REPORT(T1.������) OVER() * 100,2) ||'%' AS ����
    
FROM (SELECT SUBSTR(a.reserv_Date,1,6) as ���
    ,SUM(b.sales) as ������
    FROM RESERVATION A , ORDER_INFO B
    WHERE a.reserv_no = b.reserv_no
    GROUP BY substr(a.reserv_Date,1,6)
    ORDER BY 1
    ) T1;
    
    
    
    
    
-- ������, ���� ������, ����, �����ܾװ� ������ ��Ƽ�Ǵ��� ������ �����ܾ��� % �� ���Ͻÿ�.
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
-- ������, ����������, ����, �����ܾװ� ������ ��Ƽ�� ���������� �����ܾ��� %�� ���Ͻÿ�
-- 1.����, ����,�� ����� �ش�Ǵ� �÷� ��� select ���ۼ�
-- 2.������, ���к� �հ�
-- 3.2���� ���� �հ�� ���к� (����)�� ���

SELECT region
      ,gubun
FROM 













       
