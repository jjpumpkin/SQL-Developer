SELECT department_id as �μ���ȣ
, LPAD(' ', 3* (LEVEL -1)) || department_name as �μ���
, LEVEL
, parent_id
FROM departments
START WITH parent_id IS NULL                 --��������(��Ʈ ��带 ����)
CONNECT BY PRIOR department_id = parent_id;  -- prior �θ��÷� = �ڽ� �÷�
-- parent_id �� ���̶� �ֻ��� ����  �ѹ���ȹ�ΰ� �ֻ���  
-- (2����)������, ����, �λ�� 10���μ��ξֵ�
-- (3����) �з�Ʈ ���̵� 30�ξֵ� 40�ξֵ� 100������ ���ڰ��� �����ֵ��� ������ ���� 1����

/*
   ������ ������ ����Ŭ���� �����ϰ� �ִ� ����� �ϳ���
   �������̶�� ���� ����ϰ� �������� ���迡�� ������ ���踦 ǥ���� �� �����.
   ��� , �޴�, ���..�� ����.
   LEVEL�� connect by���� �Բ� ��� ������ ����-���ν� Ʈ�� ������ � �ܰ迡 �ִ�����
   ��Ÿ���� ������
*/

SELECT a.employee_id , a.manager_id
       ,b.department_name, LPAD (' ' , 3*(LEVEL-1)) || a.emp_name as ������
       ,LEVEL
FROM employees a
  , departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id =a.manager_id
--AND a.department_id =30; 

/* ��ȸ����
  1. ������ ������ ����ó��
  2. START WITH���� ������ �ֻ��� ���� �ο츦 ����
  3. CONNECT BY�� ��õ� ������ ���� ����������(�θ�-�ڽ�) ����
  4. �ڽ� �ο� ã�Ⱑ ������ ���� ������ ������ WHERE ���ǿ� �ش��ϴ� �ο츦 �ɷ���
*/

SELECT a.employee_id , a.manager_id
       ,b.department_name, LPAD (' ' , 3*(LEVEL-1)) || a.emp_name as �����̸�
       ,LEVEL
FROM employees  a
  , departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id =a.manager_id
ORDER SIBLINGS BY a.emp_name;  
--������ �������� ���� as �ȵ�, ���̺� �ִ� �÷�����.
--�������������� ��밡���� �Լ�

SELECT department_id as �μ���ȣ
       , LPAD (' ' , 3*(LEVEL-1)) || department_name as �μ���
       , LEVEL
       , CONNECT_BY_ROOT department_name as root_name  --��Ʈ ���� �÷� ���ٰ���
       , CONNECT_BY_ISLEAF as leafs                        --������ ���1, �ڽ������� -
       , SYS_CONNECT_BY_PATH(department_name, '|') as depths --��Ʈ���� ���������
FROM departments 
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;




-- �ű� �μ��� ���Խ��ϴ�.
-- IT ��嵥��ũ�μ� �ؿ� '��ۺδ�' �μ��� ���Խ��ϴ�.
-- departments ���̺� �˸°� �����͸� �������ּ���

SELECT
LPAD (' ' , 3*(LEVEL-1)) || department_name as �μ���
,LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;
-- ������ �߰���
INSERT INTO departments (department_id , department_name, parent_id)
VALUES(280,'��ۺδ�',230);


/*
�Ʒ�ó�� ��� �Ƿ� ���̺��� ����, ������ �μ�Ʈ �� ����Ͻÿ�
�̻���  ����                1
�����     ����             2
������        ����          3
�����           ����       4
�̴븮              �븮    5
�ֻ��                 ��� 6
�����                 ��� 6
�ڰ���           ����       4
��븮              �븮    5
�ֻ��                 ��� 6
*/

CREATE TABLE ��(
     ���̵� number
   , �̸�  varchar2(100)
   , ��å  varchar2(100)
   , �������̵� number);

INSERT into �� values(1,'�̻���','����',0);
insert into �� values(2,'�����','����',1);
insert into �� values(3,'������','����',2);
insert into �� values(4,'�����','����',3);
insert into �� values(5,'�ڰ���','����',3);
insert into �� values(6,'�̴븮','�븮',4);
insert into �� values(7,'��븮','�븮',5);
insert into �� values(8,'�ֻ��','���',6);
insert into �� values(9,'�����','���',6);
insert into �� values(10,'�ֻ��','���',7);
-- ****** �����

SELECT �̸�
     , LPAD(' ' ,3* (LEVEL-1)) || ��å as �μ���
     , LEVEL
    FROM ��
    START WITH �������̵� =0
    CONNECT BY PRIOR ���̵� = �������̵�;


-- (BOttom_up) �ڽĿ��� �θ�� �ö󰡴� ����
SELECT department_id as �μ���ȣ
       , LPAD(' ', 3* (LEVEL -1)) || department_name as �μ���
       , LEVEL
FROM departments
START With department_id =280             --��������(��Ʈ ��带 ��å)
CONNECT BY PRIOR parent_id = department_id ; -- prior �ڽ� �÷� = �θ��÷�

-- connect by ���� level ���
-- ���������� ������(���� �����Ͱ� �ʿ��Ҷ� ���)
SELECT LEVEL 
FROM dual
Connect BY LEVEL <= 12;

SELECT TO_CHAR(SYSDATE, 'YYYY') || LPAD(LEVEL, 2, '0') as yy
FROM dual
CONNECT BY LEVEL <=12;

SELECT period
       , sum(loan_jan_amt)
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period;

SELECT '2013' || LPAD(LEVEL, 2, '0') as period
FROM dual
CONNECT BY LEVEL <=12;

SELECT a.period
      ,NVL(b.amt_sum,0) as amt_sum
FROM (SELECT '2013' || LPAD(LEVEL, 2, '0') as period
FROM dual
CONNECT BY LEVEL <=12) a
    ,(SELECT period
       , sum(loan_jan_amt) as amt_sum
FROM kor_loan_status
WHERE period LIKE '2013%'
GROUP BY period) b
WHERE a.period = b.period(+);
ORDER BY 1;

-- �̹��� 1�� ���� ������������ ���� ����Ͻÿ� DATE Ÿ������
-- connect by level ���

/*
SELECT '2013' || LPAD(LEVEL, 2, '0') as period
FROM dual
CONNECT BY LEVEL <=12;
*/

SELECT TO_DATE(TO_CHAR(SYSDATE,'YYYYMM') || LPAD(LEVEL,2,'0')) as dates
FROM dual
CONNECT BY LEVEL <=TO_CHAR(LAST_DAY(SYSDATE),'dd');

SELECT LEVEL
FROM dual
CONNECT BY LEVEL <=5;

-- 202401 ~202412 ���� �� 100���� �����͸� ���� 100~1000 ������ ����������
CREATE TABLE ex_temp AS
SELECT ROWNUM as seq
      ,TO_CHAR(SYSDATE, 'YYYY') || LPAD(CELL(ROWNUM/1000),2,'0') mon
      ,ROUND(DBMS_RANDOM.VALUE(100,1000)) as amt
FROM dual
CONNECT BY LEVEL <= 12000;
SELECT * FROM ex_temp;





