drop table stocks;
CREATE TABLE stocks(
    item_Code VARCHAR2(10)
    ,stock_name VARCHAR2(1000)
    ,close_price NUMBER
    ,create_dt   DATE DEFAULT SYSDATE
);
