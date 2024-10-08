--테이블 코멘드
COMMENT ON TABLE tb_info IS '우리반';
-- 컬럼 코멘트
COMMENT ON COLUMN tb_info.info_no IS '출석부 번호';
COMMENT ON COLUMN tb_info.pc_no IS '컴퓨터 번호';
COMMENT ON COLUMN tb_info.NM IS '이름';
COMMENT ON COLUMN tb_info.email IS '이메일';
COMMENT ON COLUMN tb_info.hobby IS '취미';
-- 테이블의 코멘트 정보를 검색해서 찾아서
SELECT table_name , comments
FROM all_tab_comments --테이블 정보 조회
WHERE table_name='TB_INFO';

--NULL 조건식과 놀리 조건식 (AND, OR, NOT)
SELECT *
FROM departments
WHERE parent_id IS NULL;  --null을 조회할때는 IS or IS NOT
SELECT *
FROM departments
WHERE parent_id IS NOT NULL;  --null이 아닌
-- IN 조건식(여러개 or가 필요할때)
-- 30 ,50, 60, 80 부서 조회
SELECT *
FROM employees
WHERE department_id IN (30,50,60,80); --30 or 50 or 60 or 80
--LIKE 검색 (문자열 패턴검색)
SELECT *
FROM tb_info
WHERE nm LIKE '이%' --'이'로 시작하는 모든-
SELECT *
FROM tb_info
WHERE nm LIKE '%호' --'호'로 끝나는 모든-
SELECT *
FROM tb_info
WHERE nm LIKE '%민%' --'민'이 포함되어 있으면-
SELECT *
FROM tb_info
WHERE nm LIKE '%' || :param_val ||'%'; --매개변수 입력 테스트

-- 학생중에 이메일 주소가 naver인 학생을 조회하시오
SELECT *
FROM tb_info
WHERE email LIKE '%naver%';
-- naver와 gmail 이 아닌
SELECT *
FROM tb_info
WHERE email NOT LIKE '%gmail%';
AND email NOT LIKE '%naver%';

-- 문자열 함수 LOWER(소문자로 변경), UPPER(대문자로 변경)
SELECT LOWER('i LIKE Mac') as lowers
      ,UPPER('i LIKE Mac') as uppers
FROM dual; --<-- dual 임시 테이블형태 (sql select 문법을 맞추기 위함)

SELECT emp_name, UPPER(emp_name), employee_id
FROM employees;
-- employees 테이블에서 -> william이 포함된 직원을 모두 조회하시오
SELECT emp_name
FROM employees
WHERE UPPER (emp_name) LIKE '%'|| UPPER ('william')||'%';
-- LIKE 검색에서 길이까지 정확하게 찾고싶을때
INSERT INTO TB_INFO (info_no , pc_no, nm, email)
VALUES (19 ,30, '팽수', '팽수@email.com');
INSERT INTO TB_INFO (info_no , pc_no, nm, email)
VALUES (20 ,33, '김팽', '팽수@email.com');
INSERT INTO TB_INFO (info_no , pc_no, nm, email)
VALUES (21 ,32, '김팽수다', '팽수@email.com');

SELECT*
FROM tb_info
-- WHERE nm LIKE '%팽수_';
WHERE nm LIKE '팽_';
-- 문자열 자르기 SUBSTR (CHAR, POS,LEN) 대상문자열 char의 pos번째 부터 len 길이 만큼 자름
SELECT SUBSTR ('ABCD EFG' , 1, 4) as ex1  --POS에 0이오면 디폴트
      ,SUBSTR ('ABCD EFG' , 4)    as ex2 --입력값이 2개일경우 해당 인덱스 부터 끝까지
      ,SUBSTR ('ABCD EFG' , -3, 3) as ex3 -- 시작이 음수이면 뒤에서 부터 
FROM dual;
-- 문자열 위치 찾기 INSTR( p1, p2, p3, p4) p1:대상문자열, p2:찾을 문자열 ,p3:시작, p4:번째
SELECT INSTR('안녕 만나서 반가워, 안녕은 hi','안녕') as ex1 -- p3,p4 디폴트 1
       ,INSTR('안녕 만나서 반가워, 안녕은 hi','안녕',5) as ex2
       ,INSTR('안녕 만나서 반가워, 안녕은 hi','안녕'1,2) as ex3 -- 두번째 안녕 시작위치
       ,INSTR('안녕 만나서 반가워, 안녕은 hi','hello') as ex4 -- 없으면 0
FROM dual;

--- tb_info 학생의 이름과 이메일 주소를 출력하시오.
--- (단 이메일 주소는 id, domain분리하여 출력하시오)
--- ex) pangsu@gmail.com -> id:pangsu, domain:gmail.com
SELECT nm
      ,email
      ,INSTR(email,'@')
      ,SUBSTR(email, 1, 8) -- -1을 해줌 1,7 ex)(email,1,10) 박정호 10이니까 9까지 wjdgh7321적용
      ,SUBSTR(email, 1, INSTR(email,'@') -1) as 아이디
      ,SUBSTR(email, INSTR(email,'@') +1) as 도메인
FROM tb_info;
 
 
-- 공백 제거 TRIM, LTRIM, RTRIM
SELECT LTRIM ('ABC') as ex1 --왼쪽 공백
      ,RTRIM ('ABC') as ex2 --오른쪽 공백
      ,TRIM ('ABC') as ex3  --양쪽 공백
FROM dual;
-- 문자열 패딩 LPAD, RPAD,
SELECT LPAD(123, 5, '0') as ex1 -- 00123 (대상,길이, 표현값) LPAD는 왼쪽부터 채움
      ,LPAD (1,5, '0')   as ex2  -- 00001
      ,LPAD (123456 ,5, '0') as ex3 -- 12345 넘어서면 제거됨.(주의)
      ,RPAD(2, 5, '*')   as ex4  -- 2**** R은 오른쪽 부터 
FROM dual;
-- 문자열 변경 REPLACE(대상문자열, 찾는값, 변경값)
SELECT REPLACE('나는 너를 모르는데 너는 나를 알겠는가?', '나는','너를') as ex1
      --replace는 단어 정확하게 매칭, translate는 한글자 씩 매칭
    , TRANSLATE('나는 너를 모르는데 너는 나를 알겠는가?' , '나는','너를') as ex2 
FROM dual;

--member 계정의 member 테이블을 조회하시오
-- 검색조건: 대전 중구에 사는 여자
--주소는 mem_add
--성별은 mem_regno2 (홀수,남자,짝수 여자)

select*
from member;

select mem_id
      ,mem_name
      ,mem_regno1 ||'_'|| substr(mem_regno2,1,1)||'******' as regno
      ,mem_regno1 ||'_'|| substr(mem_regno2,1,1)||'******' as regno2
      ,mem_add1, mem_add2, mem_job
from member
where mem_add1 like '%대전%'
and mem_add1 like '%중구%'
and substr(mem_regno2,1,1) ='2';an
--or substr(mem_regno2,1,1) ='4';
--and substr(mem_regno2,1,1) IN('2','4');

      



