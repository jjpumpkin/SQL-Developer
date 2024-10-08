--���̺� �ڸ��
COMMENT ON TABLE tb_info IS '�츮��';
-- �÷� �ڸ�Ʈ
COMMENT ON COLUMN tb_info.info_no IS '�⼮�� ��ȣ';
COMMENT ON COLUMN tb_info.pc_no IS '��ǻ�� ��ȣ';
COMMENT ON COLUMN tb_info.NM IS '�̸�';
COMMENT ON COLUMN tb_info.email IS '�̸���';
COMMENT ON COLUMN tb_info.hobby IS '���';
-- ���̺��� �ڸ�Ʈ ������ �˻��ؼ� ã�Ƽ�
SELECT table_name , comments
FROM all_tab_comments --���̺� ���� ��ȸ
WHERE table_name='TB_INFO';

--NULL ���ǽİ� � ���ǽ� (AND, OR, NOT)
SELECT *
FROM departments
WHERE parent_id IS NULL;  --null�� ��ȸ�Ҷ��� IS or IS NOT
SELECT *
FROM departments
WHERE parent_id IS NOT NULL;  --null�� �ƴ�
-- IN ���ǽ�(������ or�� �ʿ��Ҷ�)
-- 30 ,50, 60, 80 �μ� ��ȸ
SELECT *
FROM employees
WHERE department_id IN (30,50,60,80); --30 or 50 or 60 or 80
--LIKE �˻� (���ڿ� ���ϰ˻�)
SELECT *
FROM tb_info
WHERE nm LIKE '��%' --'��'�� �����ϴ� ���-
SELECT *
FROM tb_info
WHERE nm LIKE '%ȣ' --'ȣ'�� ������ ���-
SELECT *
FROM tb_info
WHERE nm LIKE '%��%' --'��'�� ���ԵǾ� ������-
SELECT *
FROM tb_info
WHERE nm LIKE '%' || :param_val ||'%'; --�Ű����� �Է� �׽�Ʈ

-- �л��߿� �̸��� �ּҰ� naver�� �л��� ��ȸ�Ͻÿ�
SELECT *
FROM tb_info
WHERE email LIKE '%naver%';
-- naver�� gmail �� �ƴ�
SELECT *
FROM tb_info
WHERE email NOT LIKE '%gmail%';
AND email NOT LIKE '%naver%';

-- ���ڿ� �Լ� LOWER(�ҹ��ڷ� ����), UPPER(�빮�ڷ� ����)
SELECT LOWER('i LIKE Mac') as lowers
      ,UPPER('i LIKE Mac') as uppers
FROM dual; --<-- dual �ӽ� ���̺����� (sql select ������ ���߱� ����)

SELECT emp_name, UPPER(emp_name), employee_id
FROM employees;
-- employees ���̺��� -> william�� ���Ե� ������ ��� ��ȸ�Ͻÿ�
SELECT emp_name
FROM employees
WHERE UPPER (emp_name) LIKE '%'|| UPPER ('william')||'%';
-- LIKE �˻����� ���̱��� ��Ȯ�ϰ� ã�������
INSERT INTO TB_INFO (info_no , pc_no, nm, email)
VALUES (19 ,30, '�ؼ�', '�ؼ�@email.com');
INSERT INTO TB_INFO (info_no , pc_no, nm, email)
VALUES (20 ,33, '����', '�ؼ�@email.com');
INSERT INTO TB_INFO (info_no , pc_no, nm, email)
VALUES (21 ,32, '���ؼ���', '�ؼ�@email.com');

SELECT*
FROM tb_info
-- WHERE nm LIKE '%�ؼ�_';
WHERE nm LIKE '��_';
-- ���ڿ� �ڸ��� SUBSTR (CHAR, POS,LEN) ����ڿ� char�� pos��° ���� len ���� ��ŭ �ڸ�
SELECT SUBSTR ('ABCD EFG' , 1, 4) as ex1  --POS�� 0�̿��� ����Ʈ
      ,SUBSTR ('ABCD EFG' , 4)    as ex2 --�Է°��� 2���ϰ�� �ش� �ε��� ���� ������
      ,SUBSTR ('ABCD EFG' , -3, 3) as ex3 -- ������ �����̸� �ڿ��� ���� 
FROM dual;
-- ���ڿ� ��ġ ã�� INSTR( p1, p2, p3, p4) p1:����ڿ�, p2:ã�� ���ڿ� ,p3:����, p4:��°
SELECT INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi','�ȳ�') as ex1 -- p3,p4 ����Ʈ 1
       ,INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi','�ȳ�',5) as ex2
       ,INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi','�ȳ�'1,2) as ex3 -- �ι�° �ȳ� ������ġ
       ,INSTR('�ȳ� ������ �ݰ���, �ȳ��� hi','hello') as ex4 -- ������ 0
FROM dual;

--- tb_info �л��� �̸��� �̸��� �ּҸ� ����Ͻÿ�.
--- (�� �̸��� �ּҴ� id, domain�и��Ͽ� ����Ͻÿ�)
--- ex) pangsu@gmail.com -> id:pangsu, domain:gmail.com
SELECT nm
      ,email
      ,INSTR(email,'@')
      ,SUBSTR(email, 1, 8) -- -1�� ���� 1,7 ex)(email,1,10) ����ȣ 10�̴ϱ� 9���� wjdgh7321����
      ,SUBSTR(email, 1, INSTR(email,'@') -1) as ���̵�
      ,SUBSTR(email, INSTR(email,'@') +1) as ������
FROM tb_info;
 
 
-- ���� ���� TRIM, LTRIM, RTRIM
SELECT LTRIM ('ABC') as ex1 --���� ����
      ,RTRIM ('ABC') as ex2 --������ ����
      ,TRIM ('ABC') as ex3  --���� ����
FROM dual;
-- ���ڿ� �е� LPAD, RPAD,
SELECT LPAD(123, 5, '0') as ex1 -- 00123 (���,����, ǥ����) LPAD�� ���ʺ��� ä��
      ,LPAD (1,5, '0')   as ex2  -- 00001
      ,LPAD (123456 ,5, '0') as ex3 -- 12345 �Ѿ�� ���ŵ�.(����)
      ,RPAD(2, 5, '*')   as ex4  -- 2**** R�� ������ ���� 
FROM dual;
-- ���ڿ� ���� REPLACE(����ڿ�, ã�°�, ���氪)
SELECT REPLACE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?', '����','�ʸ�') as ex1
      --replace�� �ܾ� ��Ȯ�ϰ� ��Ī, translate�� �ѱ��� �� ��Ī
    , TRANSLATE('���� �ʸ� �𸣴µ� �ʴ� ���� �˰ڴ°�?' , '����','�ʸ�') as ex2 
FROM dual;

--member ������ member ���̺��� ��ȸ�Ͻÿ�
-- �˻�����: ���� �߱��� ��� ����
--�ּҴ� mem_add
--������ mem_regno2 (Ȧ��,����,¦�� ����)

select*
from member;

select mem_id
      ,mem_name
      ,mem_regno1 ||'_'|| substr(mem_regno2,1,1)||'******' as regno
      ,mem_regno1 ||'_'|| substr(mem_regno2,1,1)||'******' as regno2
      ,mem_add1, mem_add2, mem_job
from member
where mem_add1 like '%����%'
and mem_add1 like '%�߱�%'
and substr(mem_regno2,1,1) ='2';an
--or substr(mem_regno2,1,1) ='4';
--and substr(mem_regno2,1,1) IN('2','4');

      



