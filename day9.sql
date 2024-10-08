SELECT department_id as 부서번호
, LPAD(' ', 3* (LEVEL -1)) || department_name as 부서명
, LEVEL
, parent_id
FROM departments
START WITH parent_id IS NULL                 --시작조건(루트 노드를 선택)
CONNECT BY PRIOR department_id = parent_id;  -- prior 부모컬럼 = 자식 컬럼
-- parent_id 가 널이라 최상위 조건  총무기획부가 최상위  
-- (2레벨)마케팅, 구매, 인사부 10번부서인애들
-- (3레벨) 패런트 아이디가 30인애들 40인애들 100전까지 숫자값이 적은애들이 레벨이 낮음 1순위

/*
   계층형 쿼리는 오라클에서 제공하고 있는 기능중 하나로
   관계형이라는 서로 평등하고 수평적인 관계에서 수직적 관계를 표현할 때 사용함.
   등급 , 메뉴, 등등..에 사용됨.
   LEVEL은 connect by절과 함께 사용 가능한 가상-열로써 트리 내에서 어떤 단계에 있는지를
   나타내는 정수값
*/

SELECT a.employee_id , a.manager_id
       ,b.department_name, LPAD (' ' , 3*(LEVEL-1)) || a.emp_name as 관리자
       ,LEVEL
FROM employees a
  , departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id =a.manager_id
--AND a.department_id =30; 

/* 조회절차
  1. 조인이 있으면 조인처리
  2. START WITH절을 참조해 최상위 계층 로우를 선택
  3. CONNECT BY절 명시된 구문에 따라 계층형관계(부모-자식) 선택
  4. 자식 로우 찾기가 끝나면 조인 조건을 제외한 WHERE 조건에 해당하는 로우를 걸러냄
*/

SELECT a.employee_id , a.manager_id
       ,b.department_name, LPAD (' ' , 3*(LEVEL-1)) || a.emp_name as 직원이름
       ,LEVEL
FROM employees  a
  , departments b
WHERE a.department_id = b.department_id
START WITH a.manager_id IS NULL
CONNECT BY PRIOR a.employee_id =a.manager_id
ORDER SIBLINGS BY a.emp_name;  
--계층형 쿼리에서 정렬 as 안됨, 테이블에 있는 컬럼만됨.
--계층형쿼리에서 사용가능한 함수

SELECT department_id as 부서번호
       , LPAD (' ' , 3*(LEVEL-1)) || department_name as 부서명
       , LEVEL
       , CONNECT_BY_ROOT department_name as root_name  --루트 행의 컬럼 접근가능
       , CONNECT_BY_ISLEAF as leafs                        --마지막 노드1, 자식있으면 -
       , SYS_CONNECT_BY_PATH(department_name, '|') as depths --루트에서 현재행까지
FROM departments 
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;




-- 신규 부서가 들어왔습니다.
-- IT 헬드데스크부서 밑에 '댓글부대' 부서가 들어왔습니다.
-- departments 테이블에 알맞게 데이터를 삽입해주세요

SELECT
LPAD (' ' , 3*(LEVEL-1)) || department_name as 부서명
,LEVEL
FROM departments
START WITH parent_id IS NULL
CONNECT BY PRIOR department_id = parent_id;
-- 데이터 추가함
INSERT INTO departments (department_id , department_name, parent_id)
VALUES(280,'댓글부대',230);


/*
아래처럼 출력 되록 테이블을 생성, 데이터 인서트 후 출력하시오
이사장  사장                1
김부장     부장             2
서차장        차장          3
장과장           과장       4
이대리              대리    5
최사원                 사원 6
강사원                 사원 6
박과장           과장       4
김대리              대리    5
주사원                 사원 6
*/

CREATE TABLE 팀(
     아이디 number
   , 이름  varchar2(100)
   , 직책  varchar2(100)
   , 상위아이디 number);

INSERT into 팀 values(1,'이사장','사장',0);
insert into 팀 values(2,'김부장','부장',1);
insert into 팀 values(3,'서차장','차장',2);
insert into 팀 values(4,'장과장','과장',3);
insert into 팀 values(5,'박과장','과장',3);
insert into 팀 values(6,'이대리','대리',4);
insert into 팀 values(7,'김대리','대리',5);
insert into 팀 values(8,'최사원','사원',6);
insert into 팀 values(9,'강사원','사원',6);
insert into 팀 values(10,'주사원','사원',7);
-- ****** 물어볼것

SELECT 이름
     , LPAD(' ' ,3* (LEVEL-1)) || 직책 as 부서명
     , LEVEL
    FROM 팀
    START WITH 상위아이디 =0
    CONNECT BY PRIOR 아이디 = 상위아이디;


-- (BOttom_up) 자식에서 부모로 올라가는 구조
SELECT department_id as 부서번호
       , LPAD(' ', 3* (LEVEL -1)) || department_name as 부서명
       , LEVEL
FROM departments
START With department_id =280             --시작조건(루트 노드를 선책)
CONNECT BY PRIOR parent_id = department_id ; -- prior 자식 컬럼 = 부모컬럼

-- connect by 절과 level 사용
-- 계층형쿼리 응용방법(샘플 데이터가 필요할때 사용)
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

-- 이번달 1일 부터 마지막날까지 행을 출력하시오 DATE 타입으로
-- connect by level 사용

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

-- 202401 ~202412 까지 월 100건의 데이터를 생성 100~1000 사이의 정수값으로
CREATE TABLE ex_temp AS
SELECT ROWNUM as seq
      ,TO_CHAR(SYSDATE, 'YYYY') || LPAD(CELL(ROWNUM/1000),2,'0') mon
      ,ROUND(DBMS_RANDOM.VALUE(100,1000)) as amt
FROM dual
CONNECT BY LEVEL <= 12000;
SELECT * FROM ex_temp;





