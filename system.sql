--한줄 주석 ctrl /
/*
주석공간
*/
-- 계정만들기 !
-- 11g버젼 이후 계정명은 특정 스타일을 지켜야 만들어지는데
-- 예전 스타일로 만들려면 아래 명령어를 실행해야함.
ALTER SESSION SET "_ORACLE_SCRIPT"=true;
-- 게정 생성
-- 여기에서 java는 계정명 , oracle은 비번
CREATE USER member IDENTIFIED BY member;
-- 접속 및 기본 권한 부여 
GRANT CONNECT, RESOURCE TO member;
-- 테이블 스페이스 접근 권환부여 
GRANT UNLIMITED TABLESPACE TO member; --<--; 로 명렁어 구분