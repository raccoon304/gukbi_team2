show user;

delete from tbl_product_option;
delete from tbl_product;
commit;


------ 상품테이블 정보 출력하기
select *
from tbl_product
order by product_name;

------ 상품상세테이블 정보 출력하기
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- 아이폰17 데이터값
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '아이폰17에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '아이폰17 Pro에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '아이폰17 Pro Max에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');

-- 아이폰16 데이터값
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '아이폰16에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '아이폰16 Pro에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '아이폰16 Pro Max에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
commit;

-- 아이폰15 데이터값
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '아이폰15에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '아이폰15 Pro에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '아이폰15 Pro Max에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 갤럭시폰 데이터값
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', '갤럭시 Z폴드7에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', '갤럭시 Z플립7에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', '갤럭시 s25 울트라에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
commit;

---------------- 갤럭시6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', '갤럭시 Z폴드6에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', '갤럭시 Z플립6에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', '갤럭시 s24 울트라에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
commit;

---------------- 갤럭시5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', '갤럭시 Z폴드5에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', '갤럭시 Z플립5에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', '갤럭시 s23 울트라에 대한 설명입니다. 임시 설명입니다. 나중에 update로 바꾸세요.', '판매중', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------아이폰 상세옵션 데이터 삽입----------------------------------------------------
--아이폰17 상세정보
insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1000AP', 'Black', '256GB', '1290000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1000AP', 'White', '256GB', '1290000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1000AP', 'Blue', '256GB', '1290000', 30);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1000AP', 'Red', '256GB', '1290000', 30);
commit;

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1000AP', 'Black', '512GB', '1584000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1000AP', 'White', '512GB', '1584000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1000AP', 'Blue', '512GB', '1584000', 35);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1000AP', 'Red', '512GB', '1584000', 35);
commit;
-------------------------------------------------------------------------------------------------------------------

--아이폰17 Pro 상세옵션
insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1100AP', 'Black', '256GB', '1790000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1100AP', 'White', '256GB', '1790000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1100AP', 'Blue', '256GB', '1790000', 35);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1100AP', 'Red', '256GB', '1790000', 35);
commit;
--------
insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1100AP', 'Black', '512GB', '2090000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1100AP', 'White', '512GB', '2090000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1100AP', 'Blue', '512GB', '2090000', 35);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1100AP', 'Red', '512GB', '2090000', 35);
commit;
-------------------------------------------------------------------------------------------------------------------

--아이폰17 Pro Max 상세옵션
insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1200AP', 'Black', '256GB', '1980000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1200AP', 'White', '256GB', '1980000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1200AP', 'Blue', '256GB', '1980000', 35);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1200AP', 'Red', '256GB', '1980000', 35);

------------------
insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1200AP', 'Black', '512GB', '2288000', '50');

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1200AP', 'White', '512GB', '2288000', '50');

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1200AP', 'Blue', '512GB', '2288000', '35');

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '1200AP', 'Red', '512GB', '2288000', '35');



--아이폰16 상세옵션
insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2000AP', 'Black', '256GB', '1440000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2000AP', 'White', '256GB', '1440000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2000AP', 'Blue', '256GB', '1440000', 30);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2000AP', 'Red', '256GB', '1440000', 30);
commit;

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2000AP', 'Black', '512GB', '1700000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2000AP', 'White', '512GB', '1700000', 50);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2000AP', 'Blue', '512GB', '1700000', 35);

insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2000AP', 'Red', '512GB', '1700000', 35);
commit;

--아이폰16 Pro 상세정보
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- 아이폰16 Pro Max 상세정보
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--아이폰15 상세정보
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--아이폰15 Pro 상세정보
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--아이폰 15 Pro Max 상세정보
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- 상품상세 정보와 상품명 조인하여 같이 출력하기
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- 상품테이블 정보 출력하기
select * from tbl_product;
commit;

---------------------------------------갤럭시 상세옵션 데이터 삽입----------------------------------------------------
-- Galaxy Z Fold7 상세옵션
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1000GX','Black','256GB', '2379000', 50);
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1000GX','Black','512GB', '2537000', 50);

insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1000GX','White','256GB', '2379000', 50);
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1000GX','White','512GB', '2537000', 50);

insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1000GX','Blue','256GB', '2379000', 50);
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1000GX','Blue','512GB', '2537000', 50);

insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1000GX','Red','256GB', '2379000', 50);
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1000GX','Red','512GB', '2537000', 50);


-- Galaxy Z Flip7 상세옵션
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1100GX','Black','256GB','1485000','35');
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1100GX','Black','512GB','1643400','35');

insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1100GX','White','256GB','1485000','35');
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1100GX','White','512GB','1643400','35');

insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1100GX','Blue','256GB','1485000','35');
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1100GX','Blue','512GB','1643400','35');

insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1100GX','Red','256GB','1485000','35');
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1100GX','Red','512GB','1643400','35');


-- Galaxy S25 Ultra 상세옵션
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1200GX','Black','256GB','1698400','35');
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1200GX','Black','512GB','1856800','35');

insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1200GX','White','256GB','1698400','35');
insert into tbl_product_option
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1200GX','White','512GB','1856800','35');

insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1200GX','Blue','256GB','1698400','35');
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1200GX','Blue','512GB','1856800','35');

insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1200GX','Red','256GB','1698400','35');
insert into tbl_product_option 
values(SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'1200GX','Red','512GB','1856800','35');

-- 갤럭시 z폴드6 상세정보
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- 갤럭시 z플립6 상세정보
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- 갤럭시 s24 울트라 상세정보
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- 갤럭시 폴드5 상세정보
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- 갤럭시 플립5 상세정보
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- 갤럭시 s23 울트라 상세정보
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- 상품상세 정보와 상품명 조인하여 같이 출력하기
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- 상품테이블 정보 출력하기
select * from tbl_product;
commit;


--상품에 대한 정보와 가격이 제일 낮은 옵션의 정보를 조인하여 출력
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '판매중'
GROUP BY
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path
ORDER BY product_name;

select * from tbl_product;

--update tbl_product set image_path = 'iphone.jpg'
--where brand_name = 'Apple';
commit;


select * from tbl_product;
select * from tbl_product_option;

select * from tbl_cart;



-- 상품옵션테이블의 제약조건들 확인하기
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT_OPTION';

-- 상품옵션테이블의 가격 체크조건 삭제
ALTER TABLE tbl_product_option DROP CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE;

-- 상품옵션테이블의 pric 컬럼 삭제
ALTER TABLE tbl_product_option
DROP COLUMN price;

-- 상품옵션테이블에 plus_price 컬럼 추가(제약조건 0과 같거나 큼)
ALTER TABLE tbl_product_option
ADD plus_price NUMBER DEFAULT 0
    CONSTRAINT ck_tbl_product_option_plus_price CHECK (plus_price >= 0);
    
select * from tbl_product_option;


-- 상품테이블의 제약조건들 확인하기
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT';

-- 상품테이블에 price 컬럼 추가(제약조건 0보다 커야 함)
ALTER TABLE tbl_product
ADD price NUMBER
    CONSTRAINT ck_tbl_product_price CHECK (price > 0);

select product_code, product_name, price
from tbl_product
where brand_name = 'Samsung'
order by product_code;

-- 상품테이블의 가격컬럽에 값 업데이트하기
update tbl_product set price = 2200000
where product_code = '3000GX';

commit;



-- 상품상세 정보와 상품명 조인하여 같이 출력하기
SELECT P.product_code, option_id, P.product_name,storage_size, price, plus_price
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Samsung' and storage_size = '512GB'
ORDER BY product_code, storage_size desc;

-- 상품옵션테이블의 추가금액 컬럼에 값 업데이트하기
update tbl_product_option set plus_price = 150000
where fk_product_code = '2100GX' and storage_size = '512GB';

commit;


--(상품코드,상품명,브랜드명,이미지경로,가격)
select product_code, product_name, brand_name, image_path, price, sale_status
from tbl_product
where sale_status='판매중';


select * from tbl_product_option;



SELECT P.product_code, option_id, fk_product_code, P.product_name, color, storage_size, stock_qty,
       (price + plus_price) as total_price
FROM tbl_product_option O
JOIN tbl_product P
ON O.fk_product_code = P.product_code
WHERE product_code = '1100GX';


commit;