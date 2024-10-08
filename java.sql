SELECT info_no
       ,nm
       ,email
       ,hobby
FROM tb_info;

INSERT INTO 학생(학번, 이름)
VALUES ((SELECT nvl(max(학번),0) +1
            FROM 학생), '팽순');
            
SELECT *
FROM 학생;

SELECT 이름 ,전공, 평점
FROM 학생
WHERE 학번 =?
