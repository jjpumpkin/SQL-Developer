CREATE TABLE stock(
     code VARCHAR2(10) PRIMARY KEY
    ,name VARCHAR2(100)
    ,market VARCHAR2(100)
    ,marcap NUMBER
    ,stocks NUMBER
    ,use_yn VARCHAR2(1) DEFAULT 'N'
);



CREATE TABLE stock_price (
      code VARCHAR2(10)
     ,seq NUMBER GENERATED ALWAYS AS IDENTITY
     ,price NUMBER
     ,create_dt DATE DEFAULT SYSDATE
     ,CONSTRAINT pk_stock_price PRIMARY KEY(code, seq)
     ,CONSTRAINT fk_stock_price FOREIGN KEY(code) REFERENCES stock(code)
);

CREATE TABLE stock_bbs(
     code VARCHAR2(10)
    ,discussion_id VARCHAR2(20)
    ,title VARCHAR2(200)
    ,contents CLOB
    ,read_count NUMBER
    ,good_count NUMBER
    ,bad_count NUMBER
    ,comment_count NUMBER
    ,create_dt DATE 
    ,update_dt DATE DEFAULT SYSDATE
    ,CONSTRAINT pk_stock_bbs PRIMARY KEY(code, discussion_id)
);