CREATE TABLE TB_INFO(
INFO_NO NUMBER(2) PRIMARY KEY NOT NULL
,PC_NO VARCHAR2(10) UNIQUE NOT NULL
-- ������ �ʵ��, Ÿ��, ��������, �����
,NM VARCHAR(20) NOT NULL
,EMAIL VARCHAR(50) NOT NULL
,HOBBY VARCHAR(1000) 
,TEAM NUMBER(2) 
,CREATE_DT DATE DEFAULT SYSDATE 
,UPDATE_DT DATE DEFAULT SYSDATE 
);
-- null ���� �⺻���̹Ƿ� �������
drop TABLE tb_info;
-- ���̺��� ������ ��� ����ؾ��� �ϳ��� �ϸ�
-- ����� �ȳ��� drop ���� ������ �ٽ� 
SELECT * FROM tb_info;



