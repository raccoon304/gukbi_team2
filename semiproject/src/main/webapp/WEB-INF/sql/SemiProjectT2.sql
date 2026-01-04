show user;

delete from tbl_product_option;
delete from tbl_product;
commit;

select product_code, product_name, brand_name, product_desc, sale_status, image_path
from tbl_product
order by product_name;

select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE P.product_code = '1200GX' AND storage_size= '512GB';


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



--아이폰17 상세옵션
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

select * from tbl_product
order by product_name;
select * from tbl_product_option
--where fk_product_code = '1200AP'
order by fk_product_code;

commit;

-------------------------------------------------------------------------------------------
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



select * from tbl_product_option
where fk_product_code = '1200GX'
order by option_id;

commit;
