-- ���� ����
ALTER SESSION SET "_ORACLE_SCRIPT"=true;

CREATE USER jdbc IDENTIFIED BY jdbc;

GRANT CONNECT, RESOURCE TO jdbc;

GRANT UNLIMITED TABLESPACE TO  jdbc;

-- ȸ�� ���̺� ���� (jdbc)
CREATE TABLE members (
   mem_id VARCHAR2(50) PRIMARY KEY
   ,mem_pw VARCHAR2(1000) NOT NULL
   ,mem_nm VARCHAR2(100)
   ,mem_addr VARCHAR2(1000)
   ,profile_img VARCHAR2(1000)
   ,use_yn VARCHAR2(1) DEFAULT 'Y'
   ,update_dt DATE DEFAULT SYSDATE
   ,create_dt DATE DEFAULT SYSDATE
   );
INSERT INTO members(mem_id,mem_pw,mem_nm)
VALUES('admin','admin','������');
COMMIT;
SELECT mem_id
      ,mem_nm
FROM members
WHERE use_yn ='Y'
AND mem_id ='admin'
AND mem_pw ='admin';
    
SELECT *
FROM members;

-- ����� �Խ��� 
CREATE TABLE boards(
 board_no NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY
 ,board_title VARCHAR2(1000)
 ,mem_id VARCHAR2(100)
 , board_content VARCHAR2(2000)
 , create_dt DATE DEFAULT SYSDATE
 , update_dt DATE DEFAULT SYSDATE
 , use_yn VARCHAR2(1) DEFAULT 'Y'
 , CONSTRAINT fk_members FOREIGN KEY(mem_id) REFERENCES members(mem_id)
   ON DELETE CASCADE
   );
DROP TABLE BOARDS;
-- �Խ��� ��� 
INSERT INTO boards(board_title, board_content,mem_id)
VALUES('�������� �Դϴ�.','������ �ӽð�����!','admin');
INSERT INTO boards(board_title, board_content, mem_id)
VALUES('ù��° �Խñ�','ù��°��!!','AAAA');
COMMIT;
SELECT *FROM boards;



-- �Խ��� ��� ��ȸ

SELECT a.board_no  
     , a.board_title
     , a.board_content
     , b.mem_id
     , b.mem_nm
     , TO_CHAR(a.update_dt ,'YYYY/MM/DD HH24:MI:SS') as update_dt
     , TO_CHAR(a.create_dt ,'YYYY/MM/DD HH24:MI:SS') as create_dt 
FROM  boards a
     ,members b
WHERE a.mem_id = b.mem_id
AND   a.use_yn ='Y'
AND   a.board_no= '1'
ORDER BY a.update_dt DESC;

-- ��� ���̺�
CREATE TABLE replys(
    board_no NUMBER,
    reply_no NUMBER,
    mem_id VARCHAR2(100),
    reply_content VARCHAR2(1000),
    use_yn VARCHAR2(1) DEFAULT 'Y',
    reply_date DATE DEFAULT SYSDATE,
    PRIMARY KEY(board_no , reply_no),
    CONSTRAINT fk_mem_id FOREIGN KEY (mem_id) REFERENCES members(mem_id)
    ON DELETE CASCADE,
    CONSTRAINT fk_board_no FOREIGN KEY(board_no) REFERENCES boards(board_no)
    ON DELETE CASCADE
);


INSERT INTO replys(board_no, reply_no ,mem_id, reply_content)
VALUES(1 ,2 'ASDF' ,'���³��̴�! ��~~');
INSERT INTO replys(board_no, reply_no ,mem_id, reply_content)
VALUES(1 ,2 'AAAA' ,'�����ϼ���!!');
COMMIT;
SELECT a.reply_no
       ,a.board_no
       ,b.mem_id
       ,b.mem_nm
       ,a.reply_content
       ,a.TO_CHAR(a.reply_date , 'MM/DD HH24:MI') as reply_date
FROM replys a, members b
WHERE a.mem_id =b.mem_id
AND  a.use_yn ='Y'
AND  a.board_no =1;