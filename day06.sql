-- ROLLUP
-- ±×·ìº° ¼Ò°è¿Í ÃÑ°è¸¦ Áý°èÇÔ
-- Ç¥Çö½ÄÀÇ °³¼ö°¡ nÀÌ¸é n+1 ·¹º§±îÁö, ÇÏÀ§ ·¹º§¿¡¼­
-- »óÀ§ ·¹º§ ¼øÀ¸·Î µ¥ÀÌÅÍ°¡ ¼øÀ¸·Î µ¥ÀÌÅÍ°¡ Áý°èµÊ

--Á÷¾÷º° ¸¶ÀÏ¸®ÁöÀÇ ÇÕ°è¿Í ÀüÃ¼ ÇÕ°è Ãâ·Â
SELECT mem_job
      ,sum(mem_mileage) as ¸¶ÀÏ¸®ÁöÇÕ
FROM member
GROUP BY ROLLUP(mem_hob);
-- ¿¬½À¿ë °èÁ¤¿¡ ÀÕÀ½
-- Ä«Å×°í¸®, ¼­ºêÄ«Å×°í¸® º° »óÇ°¼ö
SELECT prod_category
      ,prod_subcategory
      ,COUNT(prod_id) as »óÇ°¼ö
FROM products
GROUP BY ROLLUP (prod_category
                 , prod_subcategory);
                 
-- ¿©±ä ¸â¹ö·Î



CREATE TABLE exp_goods_asia (
       country VARCHAR2(10),
       seq     NUMBER,
       goods   VARCHAR2(80));

INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 1, '¿øÀ¯Á¦¿Ü ¼®À¯·ù');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 2, 'ÀÚµ¿Â÷');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 3, 'ÀüÀÚÁýÀûÈ¸·Î');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 4, '¼±¹Ú');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 5,  'LCD');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 6,  'ÀÚµ¿Â÷ºÎÇ°');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 7,  'ÈÞ´ëÀüÈ­');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 8,  'È¯½ÄÅºÈ­¼ö¼Ò');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 9,  '¹«¼±¼Û½Å±â µð½ºÇÃ·¹ÀÌ ºÎ¼ÓÇ°');
INSERT INTO exp_goods_asia VALUES ('ÇÑ±¹', 10,  'Ã¶ ¶Ç´Â ºñÇÕ±Ý°­');

INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 1, 'ÀÚµ¿Â÷');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 2, 'ÀÚµ¿Â÷ºÎÇ°');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 3, 'ÀüÀÚÁýÀûÈ¸·Î');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 4, '¼±¹Ú');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 5, '¹ÝµµÃ¼¿þÀÌÆÛ');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 6, 'È­¹°Â÷');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 7, '¿øÀ¯Á¦¿Ü ¼®À¯·ù');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 8, '°Ç¼³±â°è');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 9, '´ÙÀÌ¿Àµå, Æ®·£Áö½ºÅÍ');
INSERT INTO exp_goods_asia VALUES ('ÀÏº»', 10, '±â°è·ù');

-- Çà´ÜÀ§ ÁýÇÕ UNION,UNION ALL, MINUS, INTERSECT
SELECT goods
FROM exp_goods_asia
WHERE country = 'ÇÑ±¹'
MINUS -- Â÷ÁýÇÕ
SELECT goods
FROM exp_goods_asia
WHERE country = 'ÀÏº»';

SELECT goods
FROM exp_goods_asia
WHERE country = 'ÇÑ±¹'
INTERSECT --±³ÁýÇÕ
SELECT goods
FROM exp_goods_asia
WHERE country = 'ÀÏº»';
UNION
SELECT '³»¿ë'
FROM dual;
-- ÁýÇÕ ´ë»óÀÇ ÄÃ·³ÀÇ ¼ö¿Í Å¸ÀÔÀÌ ÀÏÄ¡ÇÏ¸é »ç¿ë°¡´É

SELECT gubun
     ,sum(loan_jan_amt) as´ëÃâÇÕ
FROM kor_loan_status
GROUP BY gubun
UNION
SELECT 'ÇÕ°è', SUM(loan_jan_amt)
FROM kor_loan_status;

--´ë°ýÈ£ ¹®ÀÚ 1°³·Î Ãë±Þ  ¼ýÀÚ¾È¿¡ ÀÖÀ¸¸é [0-9][0-9] ¼ýÀÚ 2¹ø 
-- [0-9][2] ¼ýÀÚ0~9¹ø±îÁö 2¹ø¹Ýº¹
-- ^ ½ÃÀÛ ^1 1·Î ½ÃÀÛ 
-- [^abc] abc°¡ ¾Æ´Ñ°Í
-- [°¡-ÆR] ÇÑ±Û



/*

   Á¤±ÔÇ¥Çö½Ä oracle 10gºÎÅÍ »ç¿ë°¡´É REGEXP _< ·Î ½ÃÀÛÇÏ´Â ÇÔ¼ö
   .(DOT) or [] <-- ¸ðµç ¹®ÀÚ 1±ÛÀÚ¸¦ ÀÇ¹ÌÇÔ.
   ^½ÃÀÛ, $³¡ [^] <- ´ë°ýÈ£ ¾ÈÀÇ ^ notÀ» ÀÇ¹ÌÇÔ.
   {n} :n¹ø¹Ýº¹, {n,}: nÀÌ»ó ¹Ýº¹, {n,m} nÀÌ»ó m ÀÌÇÏ¹Ýº¹
*/
-- REGEXP_LIKE :Á¤±Ô½Ä ÆÐÅÏ °Ë»ö
SELECT mem_name , mem_comtel
FROM member
WHERE REGEXP_LIKE (mem_comtel, '..-');

-- mem_mail µ¥ÀÌÅÍ Áß ¿µ¹®ÀÚ 3~5 ÀÚ¸® ÀÌ¸ÞÀÏ ÁÖ¼ÒÆÐÅÏ ÃßÃâ
SELECT mem_name, mem_mail
FROM member
WHERE REGEXP_LIKE (mem_mail , '^[a~zA-Z]{3,5}@');
-- mem_add2 ÁÖ¼Ò¿¡¼­ ÇÑ±Û·Î ³¡³ª´Â ÆÐÅÏÀÇ ÁÖ¼Ò¸¦ ÃßÃâÇÏ½Ã¿À
SELECT mem_name, mem_add2
FROM member
WHERE REGEXP_LIKE(mem_add2, '[°¡-Èþ]$');
-- ´ÙÀ½ ÆÐÅÏÀÇ ÁÖ¼Ò¸¦ Á¶È¸ÇÏ½Ã¿À
-- ÇÑ±Û +¶Ù¾î¾²±â + ¼ýÀÚ ex ¾ÆÆÄÆ® 5µ¿
SELECT mem_add2
FROM member
WHERE REGEXP_LIKE (mem_add2, '[°¡-Èþ] [0-9]');

--ÇÑ±Û¸¸ ÀÖ´Â ÁÖ¼Ò°Ë»ö
-- *:0È¸ or ±×ÀÌ»ó È½¼ö·Î, ?:0È¸ or 1È¸, +:1È¸ orÀÌ»óÀ¸·Î
SELECT mem_¤±¤·¤·2
FROM member
WHERE REGEXP_LIKE(mem_add2, '^[°¡-Èþ] {1,}$');
-- WHERE REGEXP_LIKE(mem_add2, '^[°¡-Èþ]*$');
-- WHERE REGEXP_LIKE(mem_add2, '^[°¡-Èþ] +$);



--´ë°ýÈ£ ¹®ÀÚ 1°³·Î Ãë±Þ  ¼ýÀÚ¾È¿¡ ÀÖÀ¸¸é [0-9][0-9] ¼ýÀÚ 2¹ø 
-- [0-9][2] ¼ýÀÚ0~9¹ø±îÁö 2¹ø¹Ýº¹
-- ^ ½ÃÀÛ ^1 1·Î ½ÃÀÛ 
-- [^abc] abc°¡ ¾Æ´Ñ°Í
-- [°¡-ÆR] ÇÑ±Û

/*

   Á¤±ÔÇ¥Çö½Ä oracle 10gºÎÅÍ »ç¿ë°¡´É REGEXP _< ·Î ½ÃÀÛÇÏ´Â ÇÔ¼ö
   .(DOT) or [] <-- ¸ðµç ¹®ÀÚ 1±ÛÀÚ¸¦ ÀÇ¹ÌÇÔ.
   ^½ÃÀÛ, $³¡ [^] <- ´ë°ýÈ£ ¾ÈÀÇ ^ notÀ» ÀÇ¹ÌÇÔ.
   {n} :n¹ø¹Ýº¹, {n,}: nÀÌ»ó ¹Ýº¹, {n,m} nÀÌ»ó m ÀÌÇÏ¹Ýº¹
*/

-- ÇÑ±ÛÀÌ ¾ø´Â ÁÖ¼Ò¸¦ °Ë»öÇÏ½Ã¿À~

SELECT mem_add2
FROM member
WHERE REGEXP_LIKE (mem_add2, '^[^°¡-Èþ]+$');

SELECT mem_add2
FROM member
WHERE REGEXP_LIKE (mem_add2, '^[^°¡-Èþ]');

-- | : ¶Ç´Â, (): ±×·ì
-- j·Î ½ÃÀÛÇÏ¸ç, ¼¼¹øÂ° ¹®ÀÚ°¡ m or n ÀÎ Á÷¿ø ÀÌ¸§Á¶È¸
SELECT emp_name
FROM employees
WHERE REGEXP_LIKE(emp_name , 'J.(m|n)');

-- REGEXP_SUBSTR Á¤±ÔÇ¥Çö½Ä ÆÐÅÏ°ú ÀÏÄ¡ÇÏ´Â ¹®ÀÚ¿­À» ¹ÝÈ¯
-- ÀÌ¸ÞÀÏ ±âÁØÀ¸·Î ¾Õ µÚ Ãâ·Â
SELECT mem_mail
      ,REGEXP_SUBSTR(mem_mail, '[^@] +',1,1) as ¾Æ¾Æµð
      ,REGEXP_SUBSTR(mem_mail, '[^@] +',1,2) as µµ¸ÞÀÎ
FROM member;


SELECT  REGEXP_SUBSTR(A-B-C, '[^-] +',1,1) as ex1
       ,REGEXP_SUBSTR(A-B-C, '[^-] +',1,2) as ex2
       ,REGEXP_SUBSTR(A-B-C, '[^-] +',1,3) as ex3   
       ,REGEXP_SUBSTR(A-B-C, '[^-] +',1,4) as ex4
FROM dual;

-- mem_add1 ¿¡¼­ °ø¹éÀ» ±âÁØÀ¸·Î Ã¹¹øÂ° ´Ü¾î¸¦ Ãâ·ÂÇÏ½Ã¿À
SELECT mem_add1
FROM member;

SELECT  REGEXP_SUBSTR(mem_add1, '[^]+',1,1) as ½Ãµµ
       ,REGEXP_SUBSTR(mem_add1, '[^]+',1,2) as ±º±¸
FROM member;
--REGEXP_REPLACE ´ë»ó ¹®ÀÚ¿­¿¡¼­ 
--Á¤±Ô Ç¥Çö½Ä ÆÐÅÏÀ» Àû¿ëÇÏ¿© ´Ù¸¥ ÆÐÅÏÀ¸·Î ´ëÃ¼
SELECT REGEXP_REPLACE('Ellen Hidi Smith'
                      , '(.*) (.*) (.*)' 
                    ,'\3, \1 \2')as re
FROM dual;

--´ëÀüÀÇ ÁÖ¼ÒµéÀ» ¸ðµÎ '´ëÀü' À¸·Î ¹Ù²ã¼­ Ãâ·ÂÇÏ½Ã¿À id:p001Á¦¿Ü
--´ëÀü±¤¿ª½Ã ->´ëÀü
--´ëÀü½Ã ->´ëÀü
SELECT mem_add1
       ,REGEXP_REPLACE(mem_add1, '(.[1,5]) (.*)', '´ëÀü\2') as ÁÖ¼Ò
FROM member
WHERE mem_add1 LIKE '%´ëÀü%'
AND mem_id !='p001';

-- ÆÞ Ç¥±â¹ý \w = [a-zA-Z], \d = [0-9]
-- ÀüÈ­¹øÈ£ µÞÀÚ¸®¿¡¼­ µ¿ÀÏÇÑ ¹øÈ£°¡ ¹Ýº¹µÇ´Â »ç¿øÁ¶È¸
SELECT emp_name ,phone_number
FROM employees
WHERE REGEXP_LIKE(phone_number, '(\d\d)\1$');

--(\d\d)\$ (¼ýÀÚ¼ýÀÚ) \1 Ã¹¹øÂ° ±×·ì Ä¸Ã³ ±×·ìÀ» ´Ù½ÃÂüÁ¶
-- ^\d*\ .?\d{0,2}
-- ¾î¶² ÆÐÅÏÀÏ±î¿ä?

CREATE TABLE (

