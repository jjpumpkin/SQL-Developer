SELECT info_no
       ,nm
       ,email
       ,hobby
FROM tb_info;

INSERT INTO �л�(�й�, �̸�)
VALUES ((SELECT nvl(max(�й�),0) +1
            FROM �л�), '�ؼ�');
            
SELECT *
FROM �л�;

SELECT �̸� ,����, ����
FROM �л�
WHERE �й� =?
