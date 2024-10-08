SELECT *
FROM 학생;
SELECT *
FROM 수강내역;
/* 1.내부조인 INNER JOIN or 동등조인 equi-join 이라함.
            WHERE 절에서 = 등호 연산자 사용
            A와 B 테이블에 공통된 값을 가진 컬럼을 연결해 조인조건이 참(TRUE)일 경우
            즉 두 컬럼의 값이 같은 행을 추출
*/
SELECT *
FROM  학생
     ,수강내역
WHERE 학생.학번 = 수강내역. 학번
--AND 이름 ='최숙경' 둘이 값이 같음
AND 학생.학번 = '1997131542';


SELECT  a.이름
       ,a.주소
       ,b.과목번호
       ,a.학번             -- from에 테이블 볊칭을 사용하면 컬럼에 별칭을 사용해야함
FROM 학생 a, 수강내역 b   --테이블 별칭
WHERE a.학번= b.학번;
-- 최숙경씨의 수강내역 조회(과목명까지)

SELECT  a.이름, a.학번 ,a.평점
       ,c.과목이름
       ,c.학점
FROM 학생 a, 수강내역 b ,과목 c
WHERE a.학번= b.학번
AND b.과목번호 = c.과목번호
AND a.이름 = '최숙경';

-- 최숙경씨의 총 수강학점을 출력하세요
SELECT  a.이름
       ,a.학번
       ,SUM(c.학점) as 수강학점 
FROM 학생 a, 수강내역 b, 과목 c
WHERE a.학번 = b.학번
AND   b.과목번호=c.과목번호
GROUP BY a.이름, a.학번;

/* 2.외부조인 OUTER JOIN
     NULL값의 데이터도 포함 해야할때
     null값을 포함 테이블 조인문에 (+) <-- 기호 사용
*/
SELECT 학생.이름
      ,학생.학번
      ,수강내역.수강내역번호
      ,수강내역.과목번호
FROM 학생, 수강내역
WHERE 학생.학번(+) =수강내역.학번;  --NULL값이어도 JOIN하겠다
--학생.학번 =수강내역.학번(+); 같음
--학생별 수강내역 건수를 조회하시오 !
SELECT 학생.이름
      ,학생.학번
      ,COUNT(수강내역.수강내역번호) as 수강건수
      ,COUNT(*)
FROM 학생, 수강내역
WHERE 학생.학번 =수강내역.학번(+)
GROUP BY 학생.이름, 학생.학번;


--수강 학점 출력
SELECT 학생.이름
      ,학생.학번
      ,수강내역.수강내역번호
      ,과목.학점
FROM 학생, 수강내역 ,과목
WHERE 학생.학번 =수강내역.학번(+)
AND   수강내역.과목번호 = 과목.과목번호(+); --outer 조인은 모든 조인에 걸어줘야함


--모든 교수의 강의 과목수를 출력하시오
SELECT 교수.교수이름
      ,교수.교수번호
      ,COUNT(강의내역.강의내역번호) as 강의건수
FROM  교수,강의내역
WHERE 교수.교수번호 =강의내역.교수번호(+)
GROUP BY 교수.교수이름, 교수.교수번호;

/* sub  query (쿼리안에 쿼리)
   1.스칼라 서브쿼리(select절)
   2.인라인 뷰(from절)
   3.중첩쿼리(where절)
*/
-- 스칼라 서브쿼리는 단일행 반환
-- 주의할 점은 메인 쿼리테이블의 행 건수 만큼 조회하기 때문
-- 건수가 많은 테이블이라면 조인을 하는게 더 좋음.
SELECT a.emp_name
      ,a.department_id
      ,(SELECT department_name --1개의 컬럼만 가능 1=1 부서번호 = 부서명
        FROM departments       --부서테이블의 부서 아이디는 pk 유니크함.
        WHERE department_id = a.department_id) as dep_name
        ,a.job_id
        -- job title을 조회하시오!
FROM employees a;

--job title
SELECT *
FROM jobs;

SELECT a.emp_name
       ,(SELECT department_name --1개의 컬럼만 가능 1=1 부서번호=부서명 
FROM departments                 --부서테이블의 부서 아이디는 pk 유니크함.
WHERE department_id = a. department_id) as dep_name
      ,a.job_id
      ,(SELECT job_title
      FROM jobs
      WHERE job_id = a.job_id) as job_title  --select에서 열면 where에서 닫는다
FROM employees a;

-- 중첩서브쿼리 (where절) 
-- 특정 값이 필요할때

-- 직원중 salary가 전체평균 보다 높은 직원을 출력하시오
SELECT AVG(salary)
FROM employees;
SELECT emp_name, salary
FROM employees
WHERE salary >= (SELECT AVG(salary)
                 FROM employees);
                 
-- salary가 가장 높은 직원을 조회하시오
SELECT emp_name ,salary
FROM employees
WHERE salary = (SELECT MAX(salary)
                    FROM employees);

-- 수강이력이 있는 학생의 이름을 조회하시오
SELECT 이름
FROM 학생
WHERE 학번 IN(SELECT 학번 
             FROM 수강내역);
             
SELECT 이름
FROM 학생
WHERE 학번 IN (1997131542,1998131205,1999232102,2001110131,2001211121,
                  2002110110,1999232102);
             

--평점이 가장 높은 학생의 수강내역을 출력하시오 

SELECT 학생.이름
      ,학생.학번
      ,과목.과목이름
FROM 학생, 수강내역 ,과목
WHERE 학생.학번 =수강내역.학번(+)
AND   수강내역.과목번호 = 과목.과목번호(+)
AND  학생.평점 = (SELECT MAX(평점)
                FROM 학생);
                
-- 고객의 구매이력을 출력하시오 (member, cart) 테이블 사용
-- 1개의 카트에는 여러개 상품이 기록 될 수 있음.
-- 고객아이디, 고객명, 카트사용횟수(이력수), 구매상품품목수, 상품구매수량
-- 정렬은 (상품총구매수량 내림차순)
-- 작동하는건 이순서 from where group by having select order by
SELECT mem_id
      ,mem_name
      ,count(DISTINCT cart_no) as 카트사용횟수 -- DISTINCT 중복제거 CART_NO 사용 횟수
      ,count(DISTINCT cart_prod) as 구매상품품목수      --구매상품품목수 AS로 이름바꿈
      ,NVL(SUM(cart_qty),0) as 총구매수량 --NVL은 널값은 다른값으로 표현 괄호안에 있는걸 컴마뒤에 값으로 나오게함
FROM cart,member      
--WHERE  cart.cart_member = member.mem_id  --멤버 아이디중에 카트멤버랑 겹치는 값만 보여줌
WHERE  cart.cart_member(+) = member.mem_id -- null 값이 있는쪽을 보여준다 없는쪽에 +표시
group by mem_id ,mem_name
order by  5 desc;



























































      
