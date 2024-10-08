/*
    �����Լ��� �׷������
    �����Լ� ��� �����͸� ���� ���� ,��� ,�ִ�, �ּڰ� ���� ���ϴ� �Լ�
    �׷���� �� ��� �����͸� Ư���׷����� ���� ���
*/
--COUNT �ο� ���� ��ȯ�ϴ� �����Լ�.
SELECT COUNT(*)                     -- null ����  ī��Ʈ ���� ����ϳ��� ���� �ִ��� 
                                    -- ��ü ���� ���� ���� 
     ,COUNT(department_id)          --default ALL  ����Ʈ��Ʈ �ǿ��� �ΰ��� ���� 106����
     ,COUNT(ALL department_id)      --�ߺ� ����, null x
     ,COUNT(DISTINCT department_id) -- �ߺ� ����
     ,COUNT(employee_id)            -- employees���̺��� pk (*) ����
FROM employees;

SELECT SUM(salary)          as �հ�
      ,MAX(salary)          as �ִ�
      ,MIN(salary)          as �ּ�
      ,ROUND(AVG(salary),2) as ���
      ,COUNT(employee_id)   as ������
FROM employees                    --���� ���̺���
WHERE department_id IS NOT NULL   --�˻������� �ִٸ� FROM ���̿� GROUP
AND department_id IN(30,60,90)    
GROUP BY department_id            --�μ� �� (�׷����� ����)
ORDER BY 1;

-- MEMBER ȸ������ ���ϸ��� �հ�, ����� ����Ͻÿ�
SELECT  MEM_JOB                   as ����
       ,COUNT(mem_id)             as ȸ����
       ,SUM(mem_mileage)          as ���ϸ����հ�
       ,ROUND(AVG(mem_mileage),2) as ���ϸ������  --as ���� �ܾ� ���̱�
FROM member
GROUP BY MEM_JOB
ORDER BY 3 DESC;  -- 3�� ����° ���ϸ��� �հ踦 ����

-- ������ ȸ������ ���ϸ��� �հ� ,��� ���(���ϸ��� �հ� ��������)
SELECT mem_job                    as ����
      ,COUNT(mem_id)              as ȸ����
      ,SUM(mem_mileage)           as ���ϸ����հ�
      ,ROUND(AVG(mem_mileage),2)  as ���ϸ������
FROM member
GROUP BY mem_job
HAVING SUM(mem_mileage) >= 10000  --�������� �˻�����
ORDER BY 3 DESC;

-- ROWNUM �ǻ��÷� ���̺��� ������ �ִ°� ó�� ��밡��
SELECT ROWNUM as rnum
       ,mem_name
FROM member
WHERE ROWNUM <=10;

-- kor_loan_status (java����) ���̺���  loan_jan_amt (�����)
-- 2013�⵵ �Ⱓ�� �� �����ܾ��� ����Ͻÿ�
SELECT SUBSTR(period,1,4) as �⵵
      ,region             as ����
      ,gubun              as ���� 
      ,SUM(loan_jan_amt)  as ������
FROM kor_loan_status
-- WHERE period LIKE '2013%'; ������
WHERE SUBSTR(period,1,4) = '2013'
GROUP BY SUBSTR(period,1,4) , region, gubun
ORDER BY 2;

-- ��ü ������ ������ �հ谡 20000 �̻��� ����� ����Ͻÿ�
-- �����ܾ� ��������
--
SELECT region             as ����
      ,SUM(loan_jan_amt)  as ������
FROM  kor_loan_status
GROUP BY region
HAVING SUM(loan_jan_amt) >=20000
ORDER BY 2 DESC;

--����, ����, �λ���
--�⵵�� ������ �հ迡�� 
--������ ���� 60000�Ѵ� ����� ����Ͻÿ�
--���� ���� ��������,������ ��������

SELECT SUBSTR(period,1,4) as �⵵
      ,region             as ����
      ,SUM(loan_jan_amt)  as ������
      
FROM kor_loan_status
WHERE region IN('����','����','�λ�')
GROUP BY SUBSTR(period, 1,4), region
HAVING SUM(loan_ja
      ,SUM(loan_jan_amt) >=60000
ORDER BY 2 ASC ,
         3 DESC;
      
         
--employees �������� �Ի�⵵�� �������� ����Ͻÿ�
--hire_date ���(���� �⵵ ��������)
-- ������ TO_CHAR ���
SELECT TO_CHAR (hire_date,'YYYY') �⵵
       ,COUNT(*) as ������
FROM employees
GROUP BY TO_CHAR(hire_date,'YYYY')
HAVING COUNT(*) >=10
ORDER BY 1;


-- customer ȸ���� ��ü ȸ����, ���� ȸ����, ���� ȸ������ ����Ͻÿ�
-- ����, ���ڶ�� �÷��� ����.
-- customers ���̺��� �÷��� Ȱ���ؼ� ��������.
-- decode�� ǥ���� �ٲ�

SELECT     COUNT (cust_gender)  as ��ü    
          , COUNT(DECODE(cust_gender, 'F','����')) as ����
          , SUM(DECODE(cust_gender,'F',1,0))      as ����2
          , COUNT(DECODE(cust_gender,'M','����'))  as ����
          , SUM(DECODE(cust_gender,'M',1,0))      as ����2
  FROM customers ;
  
  
SELECT emp_name, email
FROM employees;

-- 1.���� ���� �Ͽ��� ���� ~(employees, hire_date)���
SELECT  to_char(hire_date,'day')     as ���� 
       ,COUNT(*) as �Ի������� --���� ���� ���°� *
FROM employees
GROUP BY to_char(hire_date,'day') --�ش������� �������� ���������� �����
ORDER BY 
    CASE 
     WHEN (to_char(hire_date,'day'))='�Ͽ���'THEN 1 
     WHEN (to_char(hire_date,'day'))='������'THEN 2 
     WHEN (to_char(hire_date,'day'))='ȭ����'THEN 3 
     WHEN (to_char(hire_date,'day'))='������'THEN 4 
     WHEN (to_char(hire_date,'day'))='�����'THEN 5 
     WHEN (to_char(hire_date,'day'))='�ݿ���'THEN 6 
     WHEN (to_char(hire_date,'day'))='�����'THEN 7 --������ ����
END; 

--2.�⵵�� ������ ����ο����� ����Ͻÿ�
--(employees, hire_date)���
--���� �⵵ ��������



SELECT to_char (hire_date,'yyyy') as �⵵,
   COUNT(to_char (hire_date,'day')="�Ͽ���"  )as 'SUN', 
       to_char (hire_date,'day')="������"  as 'MON',
       to_char (hire_date,'day')="ȭ����" as 'TUE',
       to_char (hire_date,'day')="������" as 'WED',
          to_char (hire_date,'day')="�����" as 'THU',
           to_char (hire_date,'day')="�ݿ���" as 'FRI',
            to_char (hire_date,'day')="�����" as 'SAT'
FROM employees
GROUP BY to_char(hire_date,'yyyy');
-- 
      






