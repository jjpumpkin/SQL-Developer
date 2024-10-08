CREATE TABLE stocks(
     itemCode VARCHAR2(10)
     ,stock_name VARCHAR2(1000)
    ,close_price NUMBER
    ,create_dt DATE DEFAULT SYSDATE
);
s
drop table stocks;

select * from stocks;


CREATE TABLE tb_user AS
SELECT mem_id AS user_id,
       mem_pass AS user_pw,
       mem_name AS user_nm,
       'Y' AS use_yn,           
       SYSDATE AS create_dt    
FROM MEMBER
INSERT INTO tb_user(user_id, user_pw, user_nm, use_yn, create_dt)
VALUES('test', 'test', 'test', 'Y', SYSDATE);


create table stock
(
    code varchar2(10) primary key,
    name varchar2(100),
    market varchar2(100),
    marcap number,
    stocks number,
    use_yn varchar2(1) default 'N'

);

insert into stock(code, name, market, marcap, stocks)
values(:1, :2, :3, :4, :5);

select *
from stock;

update stock 
set use_yn = 'Y'
where name ='유니온머티리얼';

CREATE TABLE stock_price(
     code VARCHAR2(10)
    ,seq NUMBER GENERATED ALWAYS AS IDENTITY
    ,price NUMBER
    ,create_dt DATE DEFAULT SYSDATE
    ,CONSTRAINT pk_stock_price PRIMARY KEY(code, seq)
    ,CONSTRAINT fk_stock_price FOREIGN KEY(code) REFERENCES stock(code)
);

select *
from stock
where use_yn = 'Y';


insert into stock_price(code, price)
values (:1, :2);

select * from stock_price;

create table stock_bbs
(
    code varchar2(10),
    discussion_id varchar2(20),
    title varchar2(200),
    contents CLOB,
    read_count number,
    good_count number,
    bad_count number,
    comment_count number,
    create_dt date,
    update_dt date default sysdate,
    constraint pk_stock_bbs primary key(code, discussion_id)
);

merge into stock_bbs a
using dual
on (a.code = :code and a.discussion_id = :discussionId)
when matched then update set a.read_count = :readCount, a.good_count = :goodCount, a.bad_Count = :badCount, a.comment_count = :commentCount

when not matched then
    insert (a.code, a.discussion_id, a.read_count, a.good_count, a.bad_count, a.comment_count, a.title, a.contents, a.create_dt)
    values (:code, :discussionId, :readCount, :goodCount, :badCount, :commentCount, :title, :contents, to_data(:createDt, 'YYYY-MM-DD HH24:MI:SS'));
    


select * from stock_bbs;


SELECT (SELECT name
         FROM stock
         WHERE code=a.code)                       as nm
      ,a.title                                    as title
      ,a.read_count                               as read_count
      ,TO_CHAR(a.update_dt,'YYYYMMDD HH24:MI:SS') as update_dt
FROM stock_bbs a
ORDER BY 1,4 DESC;


SELECT *
FROM tb_user;