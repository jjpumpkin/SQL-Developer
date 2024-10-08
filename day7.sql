SELECT *
FROM �л�;
SELECT *
FROM ��������;
/* 1.�������� INNER JOIN or �������� equi-join �̶���.
            WHERE ������ = ��ȣ ������ ���
            A�� B ���̺� ����� ���� ���� �÷��� ������ ���������� ��(TRUE)�� ���
            �� �� �÷��� ���� ���� ���� ����
*/
SELECT *
FROM  �л�
     ,��������
WHERE �л�.�й� = ��������. �й�
--AND �̸� ='�ּ���' ���� ���� ����
AND �л�.�й� = '1997131542';


SELECT  a.�̸�
       ,a.�ּ�
       ,b.�����ȣ
       ,a.�й�             -- from�� ���̺� ��Ī�� ����ϸ� �÷��� ��Ī�� ����ؾ���
FROM �л� a, �������� b   --���̺� ��Ī
WHERE a.�й�= b.�й�;
-- �ּ��澾�� �������� ��ȸ(��������)

SELECT  a.�̸�, a.�й� ,a.����
       ,c.�����̸�
       ,c.����
FROM �л� a, �������� b ,���� c
WHERE a.�й�= b.�й�
AND b.�����ȣ = c.�����ȣ
AND a.�̸� = '�ּ���';

-- �ּ��澾�� �� ���������� ����ϼ���
SELECT  a.�̸�
       ,a.�й�
       ,SUM(c.����) as �������� 
FROM �л� a, �������� b, ���� c
WHERE a.�й� = b.�й�
AND   b.�����ȣ=c.�����ȣ
GROUP BY a.�̸�, a.�й�;

/* 2.�ܺ����� OUTER JOIN
     NULL���� �����͵� ���� �ؾ��Ҷ�
     null���� ���� ���̺� ���ι��� (+) <-- ��ȣ ���
*/
SELECT �л�.�̸�
      ,�л�.�й�
      ,��������.����������ȣ
      ,��������.�����ȣ
FROM �л�, ��������
WHERE �л�.�й�(+) =��������.�й�;  --NULL���̾ JOIN�ϰڴ�
--�л�.�й� =��������.�й�(+); ����
--�л��� �������� �Ǽ��� ��ȸ�Ͻÿ� !
SELECT �л�.�̸�
      ,�л�.�й�
      ,COUNT(��������.����������ȣ) as �����Ǽ�
      ,COUNT(*)
FROM �л�, ��������
WHERE �л�.�й� =��������.�й�(+)
GROUP BY �л�.�̸�, �л�.�й�;


--���� ���� ���
SELECT �л�.�̸�
      ,�л�.�й�
      ,��������.����������ȣ
      ,����.����
FROM �л�, �������� ,����
WHERE �л�.�й� =��������.�й�(+)
AND   ��������.�����ȣ = ����.�����ȣ(+); --outer ������ ��� ���ο� �ɾ������


--��� ������ ���� ������� ����Ͻÿ�
SELECT ����.�����̸�
      ,����.������ȣ
      ,COUNT(���ǳ���.���ǳ�����ȣ) as ���ǰǼ�
FROM  ����,���ǳ���
WHERE ����.������ȣ =���ǳ���.������ȣ(+)
GROUP BY ����.�����̸�, ����.������ȣ;

/* sub  query (�����ȿ� ����)
   1.��Į�� ��������(select��)
   2.�ζ��� ��(from��)
   3.��ø����(where��)
*/
-- ��Į�� ���������� ������ ��ȯ
-- ������ ���� ���� �������̺��� �� �Ǽ� ��ŭ ��ȸ�ϱ� ����
-- �Ǽ��� ���� ���̺��̶�� ������ �ϴ°� �� ����.
SELECT a.emp_name
      ,a.department_id
      ,(SELECT department_name --1���� �÷��� ���� 1=1 �μ���ȣ = �μ���
        FROM departments       --�μ����̺��� �μ� ���̵�� pk ����ũ��.
        WHERE department_id = a.department_id) as dep_name
        ,a.job_id
        -- job title�� ��ȸ�Ͻÿ�!
FROM employees a;

--job title
SELECT *
FROM jobs;

SELECT a.emp_name
       ,(SELECT department_name --1���� �÷��� ���� 1=1 �μ���ȣ=�μ��� 
FROM departments                 --�μ����̺��� �μ� ���̵�� pk ����ũ��.
WHERE department_id = a. department_id) as dep_name
      ,a.job_id
      ,(SELECT job_title
      FROM jobs
      WHERE job_id = a.job_id) as job_title  --select���� ���� where���� �ݴ´�
FROM employees a;

-- ��ø�������� (where��) 
-- Ư�� ���� �ʿ��Ҷ�

-- ������ salary�� ��ü��� ���� ���� ������ ����Ͻÿ�
SELECT AVG(salary)
FROM employees;
SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
                 FROM employees);
                 
-- salary�� ���� ���� ������ ��ȸ�Ͻÿ�
SELECT emp_name ,salary
FROM employees
WHERE salary = (SELECT MAX(salary)
                    FROM employees);

-- �����̷��� �ִ� �л��� �̸��� ��ȸ�Ͻÿ�
SELECT �̸�
FROM �л�
WHERE �й� IN(SELECT �й� 
             FROM ��������);
             
SELECT �̸�
FROM �л�
WHERE �й� IN (1997131542,1998131205,1999232102,2001110131,2001211121,
                  2002110110,1999232102);
             

--������ ���� ���� �л��� ���������� ����Ͻÿ� 

SELECT �л�.�̸�
      ,�л�.�й�
      ,����.�����̸�
FROM �л�, �������� ,����
WHERE �л�.�й� =��������.�й�(+)
AND   ��������.�����ȣ = ����.�����ȣ(+)
AND  �л�.���� = (SELECT MAX(����)
                FROM �л�);
                
-- ���� �����̷��� ����Ͻÿ� (member, cart) ���̺� ���
-- 1���� īƮ���� ������ ��ǰ�� ��� �� �� ����.
-- �����̵�, ����, īƮ���Ƚ��(�̷¼�), ���Ż�ǰǰ���, ��ǰ���ż���
-- ������ (��ǰ�ѱ��ż��� ��������)
-- �۵��ϴ°� �̼��� from where group by having select order by
SELECT mem_id
      ,mem_name
      ,count(DISTINCT cart_no) as īƮ���Ƚ�� -- DISTINCT �ߺ����� CART_NO ��� Ƚ��
      ,count(DISTINCT cart_prod) as ���Ż�ǰǰ���      --���Ż�ǰǰ��� AS�� �̸��ٲ�
      ,NVL(SUM(cart_qty),0) as �ѱ��ż��� --NVL�� �ΰ��� �ٸ������� ǥ�� ��ȣ�ȿ� �ִ°� �ĸ��ڿ� ������ ��������
FROM cart,member      
--WHERE  cart.cart_member = member.mem_id  --��� ���̵��߿� īƮ����� ��ġ�� ���� ������
WHERE  cart.cart_member(+) = member.mem_id -- null ���� �ִ����� �����ش� �����ʿ� +ǥ��
group by mem_id ,mem_name
order by  5 desc;



























































      
