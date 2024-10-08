--bbs member 테이블 활용
CREATE TABLE tb_user AS
SELECT mem_id      AS user_id
     , mem_pass    AS user_pw
     , mem_name    AS user_nm
     , 'Y'         AS use_yn
     , SYSDATE     AS create_dt
FROM member;

SELECT user_id
      ,user_pw
      ,user_nm
FROM tb_user
WHERE user_id ='a001'
AND   use_yn ='Y' ;

INSERT INTO tb_user(user_id, user_pw,user_nm, use_yn, create_dt)
VALUES('test','test','test', 'Y', SYSDATE);