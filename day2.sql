CREATE TABLE ex2_1(
  col1 VARCHAR2(100)
  ,COl2 NUMBER
  ,col3 DATE
); 
-- INSERT 데이터 삽입
-- 방법1. 기본형태 컬럼명 작성
INSERT INTO ex2_1 (col1,col2,col3)
VALUES('nick' , 10 , sysdate);
-- 문자열 타입은'' 숫자는 그냥 숫자 하지만 문자열인데 숫자라면 가능
INSERT INTO ex2_1 (col1,col2,col3)
VALUES('jack' , 10 , sysdate);
SELECT * FROM ex2_1;
-- 특정 칼럼에만 삽입할때는 무조건 컬럼명 써야함.
INSERT INTO ex2_1 (col1)
VALUES('judy');
-- 방법2. 테이블에 있는 전체 컬럼에 삽입할때는 안써도됨.
INSERT INTO ex2_1 VALUES('팽수' , 10, sysdate);
-- 방법3. SELECT ~ INSERT 조회 결과를 삽입
INSERT INTO ex2_1 (col1)
SELECT emp_name 
FROM employees;

-- UPDATE 데이터 수정
UPDATE ex2_1
SET col3 = sysdate; --set에는 수정하고자하는 데이터
-- where 절이 없으면 테이블 전체 업데이트 됨.
UPDATE ex2_1
SET col2 =20
   ,col3 = sysdate  --수정 컬럼이 많으면, <-- 여러개면 컴마컴마 해서 추가
   WHERE col1 = 'nick';
   COMMIT; --변경이력 반영
   ROLLBACK; --변경이력 취소
   
--DELETE 데이터 삭제
DELETE ex2_1; --테이블 내용 전체 삭제
-- delete도 update와 같이 검색 조건 중요함
DELETE ex2_1
WHERE col1 = 'nick'; --해당 조건이 만족하는 행을 삭제
-- 제약조건도 삭제 후 테이블 삭제.
 DROP TABLE dep CASCADE CONSTRAINTS;
 
 --산술 연산자*+-/-
 --문자 연산자
 SELECT employee_id || '-'|| emp_name as emp_info // ||플러스 기호라고 생각
 FROM employees;
 -- 논리 연산자: >,<,>=,=,<>,!=,^=
SELECT *FROM employees WHERE salary=2600; --같다
SELECT *FROM employees WHERE salary<>2600; --같지 않다
SELECT *FROM employees WHERE salary!=2600; --같지 않다
SELECT *FROM employees WHERE salary^=2600; --같지 않다
SELECT *FROM employees WHERE salary>2600; --초과
SELECT *FROM employees WHERE salary<2600; --미만
SELECT *FROM employees WHERE salary<=2600; --이하
SELECT *FROM employees WHERE salary>=2600; --이상

--표현식 CASE WHEN 조건1 THEN 조건 1이 true일때
--                조건2 THEN 조건 1이 true일때
--                ELSE 그밖에
--               END 종료
--   5000이하 C등급, 5000 초과 15000 이하 B등급, 그밖에 A등급
SELECT employee_id, salary
      ,CASE WHEN salary <= 5000 THEN 'c등급'
      WHEN salary >5000 AND salary <= 15000 THEN'B등급'
      ELSE 'a등급'
      END as grade
    FROM employees;
-- customers 테이블에서
-- 고객의 이름과 출생년도 성별을 출력하시오 (성별의 표현은 F:여자, M:남자)
desc customers;
SELECT cust_name 
      ,cust_gender
      ,CASE WHEN cust_gender ='F' THEN '여자'--조건은 빠질수 있고 원본 데이터를 보고 함
           WHEN cust_gender ='M' THEN '남자'-- 테이블 칼럼을 추가하고 찾고자하는 출력값이 나온다
       END as gender --case는 end로 끝내야한다.  
      ,cust_year_of_birth
FROM customers
WHERE cust_year_of_birth=1990 AND cust_gender ='M'
ORDER BY cust_year_of_birth DESC,cust_name ASC;
-- 1990 년 출생이면 남자만 조회하시오
-- 오름차순 a~z까지 순서대로
-- 내림차순 년생 99~90 내려감
--계정 생성 'id:member' 'pw:member'
--권한 부여
--해당 계정에 접속하여 =>>member_ table(utf-8).sql 파일 실행(table &data)




     


     
 