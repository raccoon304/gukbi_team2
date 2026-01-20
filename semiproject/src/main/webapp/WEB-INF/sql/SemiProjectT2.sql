
-------- 테이블 생성 --------

-------- MEMBER TABLE --------
CREATE TABLE TBL_MEMBER (
  MEMBER_ID       VARCHAR2(40)            NOT NULL,
  NAME            VARCHAR2(30)            NOT NULL,
  MOBILE_PHONE    VARCHAR2(100)           NOT NULL,
  PASSWORD        VARCHAR2(200)           NOT NULL,
  EMAIL           VARCHAR2(200)           NOT NULL,
  BIRTH_DATE      VARCHAR2(10)            NOT NULL,
  GENDER          NUMBER(1)               NOT NULL, 
  CREATED_AT      DATE DEFAULT SYSDATE    NOT NULL,
  STATUS          NUMBER(1)               NOT NULL,
  IDLE            NUMBER(1)               NOT NULL,

  CONSTRAINT PK_TBL_MEMBER_MEMBER_ID PRIMARY KEY (MEMBER_ID),
  CONSTRAINT CK_TBL_MEMBER_GENDER CHECK (GENDER IN (0,1)),
  CONSTRAINT CK_TBL_MEMBER_STATUS CHECK (STATUS IN (0,1)),
  CONSTRAINT CK_TBL_MEMBER_IDLE CHECK (IDLE IN (0,1)),
  CONSTRAINT UQ_TBL_MEMBER_EMAIL UNIQUE (EMAIL),
  CONSTRAINT UQ_TBL_MEMBER_MOBILE_PHONE UNIQUE (MOBILE_PHONE)
);

-- status 컬럼 디폴트값 설정
ALTER TABLE TBL_MEMBER
  MODIFY (STATUS DEFAULT 0);
  
-- idle 컬럼 디폴트값 설정
ALTER TABLE TBL_MEMBER
  MODIFY (IDLE DEFAULT 0);
  

create table tbl_member_backup
as
select * from tbl_member;

-- 시퀀스 생성
CREATE SEQUENCE SEQ_TBL_MEMBER_USERSEQ
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- userseq 컬럼 추가
alter table tbl_member
add userseq number;

update tbl_member set userseq = SEQ_TBL_MEMBER_USERSEQ.nextval
where MEMBER_ID = 'eomjh';

update tbl_member set userseq = SEQ_TBL_MEMBER_USERSEQ.nextval
where MEMBER_ID = 'smon0376';

-- userseq 컬럼 유니크제약 설정
alter table tbl_member
add constraint UQ_TBL_MEMBER_USERSEQ unique(userseq);

-- userseq 컬럼 not null 설정
alter table tbl_member
modify userseq constraint NN_TBL_MEMBER_USERSEQ not null;

commit;


-------- PRODUCT TABLE --------
CREATE TABLE TBL_PRODUCT (
  PRODUCT_CODE  VARCHAR2(20)    NOT NULL,
  PRODUCT_NAME  VARCHAR2(100)   NOT NULL,
  BRAND_NAME    VARCHAR2(50)    NOT NULL,
  PRODUCT_DESC  VARCHAR2(1000)  NOT NULL,
  SALE_STATUS   VARCHAR2(20)    NOT NULL,
  IMAGE_PATH    VARCHAR2(200)   NOT NULL,

  CONSTRAINT PK_TBL_PRODUCT_PRODUCT_CODE PRIMARY KEY (PRODUCT_CODE)
);

-- IMAGE_PATH 컬럼 추가
ALTER TABLE TBL_PRODUCT
ADD (IMAGE_PATH VARCHAR2(200));

-- IMAGE_PATH 컬럼 NOT NULL 제약
ALTER TABLE TBL_PRODUCT
MODIFY (IMAGE_PATH VARCHAR2(200) NOT NULL);


-------- COUPON TABLE --------
CREATE TABLE TBL_COUPON (
  COUPON_CATEGORY_NO NUMBER                  NOT NULL,
  COUPON_NAME        VARCHAR2(20)            NOT NULL,
  DISCOUNT_VALUE     NUMBER                  NOT NULL,
  DISCOUNT_TYPE      NUMBER(1)               NOT NULL,  
  USABLE             NUMBER(1) DEFAULT 1     NOT NULL, 

  CONSTRAINT PK_TBL_COUPON_COUPON_CATEGORY_NO PRIMARY KEY (COUPON_CATEGORY_NO),
  CONSTRAINT CK_TBL_COUPON_DISCOUNT_TYPE CHECK (DISCOUNT_TYPE IN (0,1)),
  CONSTRAINT CK_TBL_COUPON_USABLE CHECK (USABLE IN (0,1)),
  CONSTRAINT CK_TBL_COUPON_DISCOUNT_VALUE CHECK (DISCOUNT_VALUE > 0)
);

-------- 시퀀스 생성 --------

CREATE SEQUENCE SEQ_TBL_COUPON_COUPON_CATEGORY_NO
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- 컬럼 속성 변경
ALTER TABLE TBL_COUPON MODIFY COUPON_NAME   VARCHAR2(40 CHAR);




-------- PRODUCT_OPTION TABLE --------
CREATE TABLE TBL_PRODUCT_OPTION (
  OPTION_ID             NUMBER         NOT NULL,
  FK_PRODUCT_CODE       VARCHAR2(20)   NOT NULL,
  COLOR                 VARCHAR2(20)   NOT NULL,
  STORAGE_SIZE          VARCHAR2(20)   NOT NULL,
  PRICE                 NUMBER         NOT NULL,
  STOCK_QTY             NUMBER         NOT NULL,
  IMAGE_PATH            VARCHAR2(200)  NOT NULL,

  CONSTRAINT PK_TBL_PRODUCT_OPTION_OPTION_ID PRIMARY KEY (OPTION_ID),
  CONSTRAINT FK_TBL_PRODUCT_OPTION_FK_PRODUCT_CODE FOREIGN KEY (FK_PRODUCT_CODE)
  REFERENCES TBL_PRODUCT (PRODUCT_CODE),
  CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE CHECK (PRICE > 0),
  CONSTRAINT CK_TBL_PRODUCT_OPTION_STOCK_QTY CHECK (STOCK_QTY >= 0),
  CONSTRAINT UQ_TBL_PRODUCT_OPTION_FK_PRODUCT_CODE_COLOR_STORAGE_SIZE UNIQUE (FK_PRODUCT_CODE, COLOR, STORAGE_SIZE)
);

-- IMAGE_PATH 컬럼 삭제
ALTER TABLE TBL_PRODUCT_OPTION
DROP COLUMN IMAGE_PATH;

-------- 시퀀스 생성 --------

CREATE SEQUENCE SEQ_TBL_PRODUCT_OPTION_OPTION_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE; 


-------- COUPON_ISSUE TABLE --------
CREATE TABLE TBL_COUPON_ISSUE (
  FK_COUPON_CATEGORY_NO         NUMBER                  NOT NULL,
  COUPON_ID                     NUMBER                  NOT NULL,  
  FK_MEMBER_ID                  VARCHAR2(40)            NOT NULL,
  ISSUE_DATE                    DATE DEFAULT SYSDATE    NOT NULL,
  EXPIRE_DATE                   DATE                    NOT NULL,
  USED_YN                       NUMBER(1) DEFAULT 0     NOT NULL, 

  CONSTRAINT PK_TBL_COUPON_ISSUE_FK_COUPON_CATEGORY_NO_COUPON_ID PRIMARY KEY (FK_COUPON_CATEGORY_NO, COUPON_ID),
  CONSTRAINT FK_TBL_COUPON_ISSUE_FK_COUPON_CATEGORY_NO FOREIGN KEY (FK_COUPON_CATEGORY_NO)
  REFERENCES TBL_COUPON (COUPON_CATEGORY_NO),
  CONSTRAINT FK_TBL_COUPON_ISSUE_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT CK_TBL_COUPON_ISSUE_USED_YN CHECK (USED_YN IN (0,1)),
  CONSTRAINT CK_TBL_COUPON_ISSUE_EXPIRE_DATE CHECK (EXPIRE_DATE > ISSUE_DATE)
);


-------- DELIVERY TABLE --------
CREATE TABLE TBL_DELIVERY (
  DELIVERY_ADDRESS_ID   NUMBER                NOT NULL,
  FK_MEMBER_ID          VARCHAR2(40)          NOT NULL,
  RECIPIENT_NAME        VARCHAR2(50)          NOT NULL,
  RECIPIENT_PHONE       VARCHAR2(100)         NOT NULL,
  ADDRESS               VARCHAR2(200)         NOT NULL,
  ADDRESS_DETAIL        VARCHAR2(200)         NOT NULL,
  ADDRESS_EXTRA         VARCHAR2(200)                 , 
  IS_DEFAULT            NUMBER(1) DEFAULT 0   NOT NULL,
  POSTAL_CODE           VARCHAR2(50)          NOT NULL, 

  CONSTRAINT PK_TBL_DELIVERY_DELIVERY_ADDRESS_ID PRIMARY KEY (DELIVERY_ADDRESS_ID),
  CONSTRAINT FK_TBL_DELIVERY_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT CK_TBL_DELIVERY_IS_DEFAULT CHECK (IS_DEFAULT IN (0,1))
);

-------- 시퀀스 생성 --------

CREATE SEQUENCE SEQ_TBL_DELIVERY_DELIVERY_ADDRESS_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-------- CART TABLE --------
CREATE TABLE TBL_CART (
  CART_ID         NUMBER                      NOT NULL,
  FK_MEMBER_ID    VARCHAR2(40)                NOT NULL,
  FK_OPTION_ID    NUMBER                      NOT NULL,
  ADDED_DATE      DATE    DEFAULT SYSDATE     NOT NULL,
  QUANTITY        NUMBER                      NOT NULL,

  CONSTRAINT PK_TBL_CART_CART_ID PRIMARY KEY (CART_ID),
  CONSTRAINT FK_TBL_CART_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT FK_TBL_CART_FK_OPTION_ID FOREIGN KEY (FK_OPTION_ID)
  REFERENCES TBL_PRODUCT_OPTION (OPTION_ID),
  CONSTRAINT CK_TBL_CART_QUANTITY CHECK (QUANTITY > 0),
  CONSTRAINT UQ_TBL_CART_FK_MEMBER_ID_FK_OPTION_ID UNIQUE (FK_MEMBER_ID, FK_OPTION_ID)
);

-------- 시퀀스 생성 --------

CREATE SEQUENCE SEQ_TBL_CART_CART_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-------- ORDERS TABLE --------
CREATE TABLE TBL_ORDERS (
  ORDER_ID               NUMBER                     NOT NULL,
  FK_MEMBER_ID           VARCHAR2(40)               NOT NULL,
  ORDER_DATE             DATE DEFAULT SYSDATE       NOT NULL,
  TOTAL_AMOUNT           NUMBER                     NOT NULL,
  DISCOUNT_AMOUNT        NUMBER                     NOT NULL,
  ORDER_STATUS           VARCHAR2(20)               NOT NULL,
  DELIVERY_ADDRESS       VARCHAR2(300)              NOT NULL,

  CONSTRAINT PK_TBL_ORDERS_ORDER_ID PRIMARY KEY (ORDER_ID),
  CONSTRAINT FK_TBL_ORDERS_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT CK_TBL_ORDERS_TOTAL_AMOUNT CHECK (TOTAL_AMOUNT > 0),
  CONSTRAINT CK_TBL_ORDERS_DISCOUNT_AMOUNT CHECK (
    DISCOUNT_AMOUNT >= 0 AND DISCOUNT_AMOUNT < TOTAL_AMOUNT
  )
);

-------- 시퀀스 생성 --------

CREATE SEQUENCE SEQ_TBL_ORDERS_ORDER_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE SEQ_TBL_ORDERS_DELIVERY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- 컬럼 추가
ALTER TABLE TBL_ORDERS
ADD (
  DELIVERY_NUMBER     VARCHAR2(20),
  DELIVERY_STARTDATE  DATE,
  DELIVERY_ENDDATE    DATE
);


-- 체크제약 추가
ALTER TABLE TBL_ORDERS
ADD CONSTRAINT CK_TBL_ORDERS_DELIVERY_DATES
CHECK (
  DELIVERY_ENDDATE IS NULL
  OR (DELIVERY_STARTDATE IS NOT NULL AND DELIVERY_ENDDATE > DELIVERY_STARTDATE)
);



-------- ORDER_DETAIL TABLE --------
CREATE TABLE TBL_ORDER_DETAIL (
  ORDER_DETAIL_ID       NUMBER                   NOT NULL,
  FK_OPTION_ID          NUMBER                   NOT NULL,
  FK_ORDER_ID           NUMBER                   NOT NULL,
  QUANTITY              NUMBER                   NOT NULL,
  UNIT_PRICE            NUMBER                   NOT NULL,
  IS_REVIEW_WRITTEN     NUMBER(1) DEFAULT 0      NOT NULL, 
  PRODUCT_NAME          VARCHAR2(100)            NOT NULL,
  BRAND_NAME            VARCHAR2(50)             NOT NULL,

  CONSTRAINT PK_TBL_ORDER_DETAIL_ORDER_DETAIL_ID PRIMARY KEY (ORDER_DETAIL_ID),
  CONSTRAINT FK_TBL_ORDER_DETAIL_FK_OPTION_ID FOREIGN KEY (FK_OPTION_ID)
  REFERENCES TBL_PRODUCT_OPTION (OPTION_ID),
  CONSTRAINT FK_TBL_ORDER_DETAIL_FK_ORDER_ID FOREIGN KEY (FK_ORDER_ID)
  REFERENCES TBL_ORDERS (ORDER_ID),
  CONSTRAINT CK_TBL_ORDER_DETAIL_QUANTITY CHECK (QUANTITY > 0),
  CONSTRAINT CK_TBL_ORDER_DETAIL_UNIT_PRICE CHECK (UNIT_PRICE > 0),
  CONSTRAINT CK_TBL_ORDER_DETAIL_IS_REVIEW_WRITTEN CHECK (IS_REVIEW_WRITTEN IN (0,1))
);

-------- 시퀀스 생성 --------

CREATE SEQUENCE SEQ_TBL_ORDER_DETAIL_ORDER_DETAIL_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-------- REVIEW TABLE --------
CREATE TABLE TBL_REVIEW (
  REVIEW_NUMBER         NUMBER                  NOT NULL,
  FK_OPTION_ID          NUMBER                  NOT NULL,
  FK_ORDER_DETAIL_ID    NUMBER                  NOT NULL,
  REVIEW_CONTENT        VARCHAR2(1000)          NOT NULL,
  WRITEDAY              DATE DEFAULT SYSDATE    NOT NULL,
  RATING                NUMBER(2,1)             NOT NULL,
  DELETED_YN            NUMBER(1)     DEFAULT 0 NOT NULL,
  DELETED_AT            DATE          NULL,
  DELETED_BY            VARCHAR2(40)  NULL

  CONSTRAINT PK_TBL_REVIEW_REVIEW_NUMBER PRIMARY KEY (REVIEW_NUMBER),
  CONSTRAINT FK_TBL_REVIEW_FK_OPTION_ID FOREIGN KEY (FK_OPTION_ID)
  REFERENCES TBL_PRODUCT_OPTION (OPTION_ID),
  CONSTRAINT FK_TBL_REVIEW_FK_ORDER_DETAIL_ID FOREIGN KEY (FK_ORDER_DETAIL_ID)
  REFERENCES TBL_ORDER_DETAIL (ORDER_DETAIL_ID),
  CONSTRAINT CK_TBL_REVIEW_RATING CHECK (RATING BETWEEN 0.5 AND 5.0 AND (RATING*2 = TRUNC(RATING*2))),
  CONSTRAINT CK_TBL_REVIEW_DELETED_YN CHECK (DELETED_YN IN (0,1));
);

-------- 시퀀스 생성 --------

CREATE SEQUENCE SEQ_TBL_REVIEW_REVIEW_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- RATING, DELETED_YN, DELETED_AT, DELETED_BT 컬럼 추가
ALTER TABLE TBL_REVIEW ADD (
  RATING      NUMBER(2,1)             NOT NULL,
  DELETED_YN  NUMBER(1)     DEFAULT 0 NOT NULL,
  DELETED_AT  DATE          NULL,
  DELETED_BY  VARCHAR2(40)  NULL
);

-- RATING, DELETED_YN 컬럼에 체크제약 추가
ALTER TABLE TBL_REVIEW
ADD CONSTRAINT CK_TBL_REVIEW_RATING
CHECK (
  RATING BETWEEN 0.5 AND 5.0
  AND (RATING*2 = TRUNC(RATING*2))
);

ALTER TABLE TBL_REVIEW
ADD CONSTRAINT CK_TBL_REVIEW_DELETED_YN
CHECK (DELETED_YN IN (0,1));


-- review_title 컬럼 추가
ALTER TABLE TBL_REVIEW
ADD (review_title VARCHAR2(100));

-- review_title 컬럼 NOT NULL 제약
ALTER TABLE TBL_REVIEW
MODIFY (review_title VARCHAR2(100) NOT NULL);

-- 유니크 제약 추가함

CREATE UNIQUE INDEX UQ_TBL_REVIEW_FK_ORDER_DETAIL_ID
ON TBL_REVIEW ( CASE WHEN deleted_yn = 0 THEN fk_order_detail_id END );

-- 컬럼 타입 변경
ALTER TABLE TBL_REVIEW MODIFY review_title   VARCHAR2(100 CHAR);
ALTER TABLE TBL_REVIEW MODIFY review_content VARCHAR2(1000 CHAR);



-------- INQUIRY TABLE --------
CREATE TABLE TBL_INQUIRY (
  INQUIRY_NUMBER        NUMBER                     NOT NULL,
  FK_MEMBER_ID          VARCHAR2(40)               NOT NULL,
  INQUIRY_TYPE          VARCHAR2(30)               NOT NULL,
  TITLE                 VARCHAR2(100)              NOT NULL,
  REGISTERDAY           DATE DEFAULT SYSDATE       NOT NULL,
  INQUIRY_CONTENT       VARCHAR2(1000)             NOT NULL,
  REPLY_CONTENT         VARCHAR2(1000),
  REPLY_REGISTERDAY     DATE,                                         
  REPLY_STATUS          NUMBER(1) DEFAULT 1   NOT NULL, 

  CONSTRAINT PK_TBL_INQUIRY_INQUIRY_NUMBER PRIMARY KEY (INQUIRY_NUMBER),
  CONSTRAINT FK_TBL_INQUIRY_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS CHECK (REPLY_STATUS IN (0,1,2))
);

-------- 시퀀스 생성 --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- 체크제약 삭제
ALTER TABLE TBL_INQUIRY
DROP CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS;

-- 체크제약 생성
ALTER TABLE TBL_INQUIRY
ADD CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS
CHECK (REPLY_STATUS IN (0,1,2));

-- REPLY_STATUS 디폴트값 1로 변경
ALTER TABLE TBL_INQUIRY
MODIFY (REPLY_STATUS DEFAULT 1);


-- deleted_yn, deleted_at, deleted_by, is_secret 컬럼 추가
ALTER TABLE tbl_inquiry ADD (
  deleted_yn NUMBER(1) DEFAULT 0 NOT NULL,
  deleted_at DATE,
  deleted_by VARCHAR2(40),
  is_secret  NUMBER(1) DEFAULT 0 NOT NULL
);

-- deleted_yn, is_secret 컬럼 체크제약 추가
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_deleted_yn CHECK (deleted_yn IN (0,1));
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_is_secret  CHECK (is_secret  IN (0,1));



-------- REVIEW_IMAGE --------
CREATE TABLE TBL_REVIEW_IMAGE (
  REVIEW_IMAGE_ID  NUMBER NOT NULL,
  FK_REVIEW_NUMBER NUMBER NOT NULL,
  IMAGE_PATH       VARCHAR2(400) NOT NULL,
  SORT_NO          NUMBER DEFAULT 1 NOT NULL,
  CONSTRAINT PK_TBL_REVIEW_IMAGE PRIMARY KEY (REVIEW_IMAGE_ID),
  CONSTRAINT FK_TBL_REVIEW_IMAGE_REVIEW FOREIGN KEY (FK_REVIEW_NUMBER)
    REFERENCES TBL_REVIEW (REVIEW_NUMBER),
  CONSTRAINT CK_TBL_REVIEW_IMAGE_SORTNO CHECK (SORT_NO >= 1),
  CONSTRAINT UQ_TBL_REVIEW_IMAGE_SORT UNIQUE (FK_REVIEW_NUMBER, SORT_NO)
);




commit;

select *
from tbl_inquiry;




select * from tab;
select * from tbl_member;
select * from tbl_delivery;
select * from tbl_orders;
select * from tbl_inquiry;
select * from tbl_product_option;


update tbl_member set created_at = sysdate
where userseq = 16;

rollback;

commit;










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









select * from tab;
select * from tbl_member;


SELECT userseq, member_id, name, email, mobile_phone
FROM tbl_member
WHERE member_id = 'anth';

DELETE FROM tbl_member
WHERE member_id = 'anth';


-- 수정했습니다...
-- 수정했습니다...

SELECT * FROM TBL_PRODUCT
SELECT * FROM TBL_PRODUCT_OPTION
SELECT * FROM TBL_ORDERS
SELECT * FROM TBL_ORDER_DETAIL

update tbl_orders set total_amount = 5000000
where order_id = 1001;

commit;

UPDATE TBL_ORDER_DETAIL SET FK_OPTION_ID = 149
WHERE ORDER_DETAIL_ID = 1001

UPDATE TBL_ORDER_DETAIL SET unit_price = 1650000
WHERE ORDER_DETAIL_ID = 1001;

UPDATE TBL_ORDER_DETAIL SET PRODUCT_NAME = 'iPhone15 Pro', BRAND_NAME = 'Apple'
WHERE ORDER_DETAIL_ID = 1000;

INSERT INTO TBL_ORDER_DETAIL
(ORDER_DETAIL_ID, FK_OPTION_ID, FK_ORDER_ID, QUANTITY, UNIT_PRICE, IS_REVIEW_WRITTEN, PRODUCT_NAME, BRAND_NAME)
VALUES
(1002, 196, 1001, 1, 1700000, 0, 'iPhone15 Pro', 'Apple');

COMMIT;

select *
from TBL_DELIVERY


SELECT
  o.order_id,
  o.total_amount AS net_amount,
  o.discount_amount,
  (o.total_amount + o.discount_amount) AS gross_by_orders,
  (SELECT NVL(SUM(d.quantity * d.unit_price),0)
     FROM tbl_order_detail d
    WHERE d.fk_order_id = o.order_id) AS gross_by_detail
FROM tbl_orders o
WHERE o.order_id = 9;


SELECT * FROM TBL_PRODUCT
SELECT * FROM TBL_PRODUCT_OPTION
SELECT * FROM TBL_ORDERS
SELECT * FROM TBL_ORDER_DETAIL

update tbl_orders set total_amount = 4950000
where order_id = 1001;

commit;






-------- INQUIRY TABLE --------
CREATE TABLE TBL_INQUIRY (
  INQUIRY_NUMBER        NUMBER                     NOT NULL,
  FK_MEMBER_ID          VARCHAR2(40)               NOT NULL,
  INQUIRY_TYPE          VARCHAR2(30)               NOT NULL,
  TITLE                 VARCHAR2(100)              NOT NULL,
  REGISTERDAY           DATE DEFAULT SYSDATE       NOT NULL,
  INQUIRY_CONTENT       VARCHAR2(1000)             NOT NULL,
  REPLY_CONTENT         VARCHAR2(1000),
  REPLY_REGISTERDAY     DATE,                                         
  REPLY_STATUS          NUMBER(1) DEFAULT 1   NOT NULL, 

  CONSTRAINT PK_TBL_INQUIRY_INQUIRY_NUMBER PRIMARY KEY (INQUIRY_NUMBER),
  CONSTRAINT FK_TBL_INQUIRY_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS CHECK (REPLY_STATUS IN (0,1,2))
);

-------- 시퀀스 생성 --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- 체크제약 삭제
ALTER TABLE TBL_INQUIRY
DROP CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS;

-- 체크제약 생성
ALTER TABLE TBL_INQUIRY
ADD CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS
CHECK (REPLY_STATUS IN (0,1,2));

-- REPLY_STATUS 디폴트값 1로 변경
ALTER TABLE TBL_INQUIRY
MODIFY (REPLY_STATUS DEFAULT 1);


-- deleted_yn, deleted_at, deleted_by, is_secret 컬럼 추가
ALTER TABLE tbl_inquiry ADD (
  deleted_yn NUMBER(1) DEFAULT 0 NOT NULL,
  deleted_at DATE,
  deleted_by VARCHAR2(40),
  is_secret  NUMBER(1) DEFAULT 0 NOT NULL
);

-- deleted_yn, is_secret 컬럼 체크제약 추가
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_deleted_yn CHECK (deleted_yn IN (0,1));
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_is_secret  CHECK (is_secret  IN (0,1));


-- 컬럼 타입 변경
ALTER TABLE tbl_inquiry MODIFY title   VARCHAR2(100 CHAR);
ALTER TABLE tbl_inquiry MODIFY inquiry_content VARCHAR2(1000 CHAR);
ALTER TABLE tbl_inquiry MODIFY reply_content VARCHAR2(1000 CHAR);
desc tbl_inquiry

-------- REVIEW_IMAGE TABLE --------
CREATE TABLE TBL_REVIEW_IMAGE (
  REVIEW_IMAGE_ID  NUMBER NOT NULL,
  FK_REVIEW_NUMBER NUMBER NOT NULL,
  IMAGE_PATH       VARCHAR2(400) NOT NULL,
  SORT_NO          NUMBER DEFAULT 1 NOT NULL,
  CONSTRAINT PK_TBL_REVIEW_IMAGE PRIMARY KEY (REVIEW_IMAGE_ID),
  CONSTRAINT FK_TBL_REVIEW_IMAGE_REVIEW FOREIGN KEY (FK_REVIEW_NUMBER)
    REFERENCES TBL_REVIEW (REVIEW_NUMBER),
  CONSTRAINT CK_TBL_REVIEW_IMAGE_SORTNO CHECK (SORT_NO >= 1),
  CONSTRAINT UQ_TBL_REVIEW_IMAGE_SORT UNIQUE (FK_REVIEW_NUMBER, SORT_NO)
);


-------- 시퀀스 생성 --------

CREATE SEQUENCE SEQ_TBL_REVIEW_IMAGE_NUMBER_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;





select * from tab;
select * from tbl_member;
select * from tbl_delivery;
select * from tbl_orders;
select * from tbl_inquiry;
select * from tbl_product_option;


update tbl_member set created_at = sysdate
where userseq = 16;

rollback;

commit;










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









select * from tab;
select * from tbl_member;


SELECT userseq, member_id, name, email, mobile_phone
FROM tbl_member
WHERE member_id = 'anth';

DELETE FROM tbl_member
WHERE member_id = 'anth';


-- 수정했습니다...
-- 수정했습니다...

SELECT * FROM TBL_PRODUCT
SELECT * FROM TBL_PRODUCT_OPTION
SELECT * FROM TBL_ORDERS
SELECT * FROM TBL_ORDER_DETAIL

update tbl_orders set total_amount = 5000000
where order_id = 1001;

commit;

UPDATE TBL_ORDER_DETAIL SET FK_OPTION_ID = 149
WHERE ORDER_DETAIL_ID = 1001

UPDATE TBL_ORDER_DETAIL SET unit_price = 1650000
WHERE ORDER_DETAIL_ID = 1001;

UPDATE TBL_ORDER_DETAIL SET PRODUCT_NAME = 'iPhone15 Pro', BRAND_NAME = 'Apple'
WHERE ORDER_DETAIL_ID = 1000;

INSERT INTO TBL_ORDER_DETAIL
(ORDER_DETAIL_ID, FK_OPTION_ID, FK_ORDER_ID, QUANTITY, UNIT_PRICE, IS_REVIEW_WRITTEN, PRODUCT_NAME, BRAND_NAME)
VALUES
(1002, 196, 1001, 1, 1700000, 0, 'iPhone15 Pro', 'Apple');

COMMIT;

select *
from TBL_DELIVERY


SELECT
  o.order_id,
  o.total_amount AS net_amount,
  o.discount_amount,
  (o.total_amount + o.discount_amount) AS gross_by_orders,
  (SELECT NVL(SUM(d.quantity * d.unit_price),0)
     FROM tbl_order_detail d
    WHERE d.fk_order_id = o.order_id) AS gross_by_detail
FROM tbl_orders o
WHERE o.order_id = 9;


SELECT * FROM TBL_PRODUCT
SELECT * FROM TBL_PRODUCT_OPTION
SELECT * FROM TBL_ORDERS
SELECT * FROM TBL_ORDER_DETAIL

update tbl_orders set total_amount = 4950000
where order_id = 1001;




commit;

select * from tbl_review;
select * from tbl_review_image;

delete from tbl_review
where review_number = 2;

delete from tbl_review_image
where fk_review_number = 2;

update tbl_order_detail set is_review_written = 0
where order_detail_id = 1000;

commit;


select * from tbl_orders;
select * from tbl_order_detail;
select * from tbl_product;
select * from tbl_product_option;
select * from tbl_review;
select * from tbl_member;

insert into tbl_orders(1002, dog, sysdate, 4950000, 50000, 'PAID', '서울 송파구 법원로 128 101호', 임시수령인, 010-0000-0000, 0);
insert into tbl_order_detail(1003, 149, 1002, 1, 2400000, 0, 'Galaxy Z Fold7', 'Samsung');
insert into tbl_order_detail(1004, 196, 1002, 1, 1700000, 0, 'iPhone15 Pro', 'Apple');

insert into tbl_review(1,196,1000,'번창하세요',sysdate,5,0,null,null,'잘쓰고 있어요');

desc tbl_orders;

select review_number, fk_order_detail_id, deleted_yn
from tbl_review
where fk_order_detail_id = 1000
order by review_number desc;


SELECT constraint_name
     , constraint_type
FROM user_constraints
WHERE table_name = 'TBL_REVIEW'
  AND constraint_type IN ('U','P');
  
  SELECT index_name, column_name, column_position
FROM user_ind_columns
WHERE table_name = 'TBL_REVIEW'
ORDER BY index_name, column_position;



CREATE UNIQUE INDEX UQ_TBL_REVIEW_FK_ORDER_DETAIL_ID
ON TBL_REVIEW ( CASE WHEN deleted_yn = 0 THEN fk_order_detail_id END );

DESC TBL_REVIEW;


select * from tbl_orders where order_status = 'PAID';
select * from tbl_orders;

update tbl_orders set delivery_status = 0
where delivery_status = 2;





commit;




select  product_name
from tbl_product
order by product_name;

select  product_code, image_path
from tbl_product;



CREATE TABLE tbl_product_image (
    image_id     NUMBER        NOT NULL,
    product_code VARCHAR2(50)  NOT NULL,
    image_path   VARCHAR2(300) NOT NULL
);
-- Table TBL_PRODUCT_IMAGE이(가) 생성되었습니다.

ALTER TABLE tbl_product_image
RENAME COLUMN product_code TO fk_product_code_image;
ALTER TABLE tbl_product_image
RENAME COLUMN image_path TO plus_image_path;
commit;

-- PRIMARY KEY 추가
ALTER TABLE tbl_product_image ADD CONSTRAINT pk_product_image PRIMARY KEY (image_id);

-- FOREIGN KEY 추가 (상품 테이블과 연결)
ALTER TABLE tbl_product_image ADD CONSTRAINT fk_product_image_product FOREIGN KEY (fk_product_code_image)
REFERENCES tbl_product(product_code) ON DELETE CASCADE;
commit;

select * from tbl_product
where product_code = '2352SQ';
select * from tbl_product_image;


CREATE SEQUENCE seq_product_image
START WITH 1
INCREMENT BY 1
NOCACHE
NOCYCLE;
-- Sequence SEQ_PRODUCT_IMAGE이(가) 생성되었습니다.

commit;

select product_code, product_name
from tbl_product
where product_code = '1200AP';

INSERT INTO tbl_product_image(image_id, product_code, image_path)
VALUES (1, '1200AP', 'iphone171.png');

INSERT INTO tbl_product_image(image_id, product_code, image_path)
VALUES(2, '1200AP', 'iphone172.png');

update tbl_product_image set image_id = 60
where image_id = 2;
commit;

select * from tbl_product_image;


select product_code, product_name, plus_image_path
from tbl_product P
join tbl_product_image I
on P.product_code = I.fk_product_code_image;

select * from tbl_product
where brand_name = 'Samsung'
order by product_name;


update tbl_product set product_desc = 'asdkmlaslkdmaiop ;laksdm sadklm asnedj sakldjna eunsakn r ls waslkd miasd dfeioda mlksad  slkadm e maslk dmase malskdm '
where product_code = '1234IN';
commit;

select product_code, product_name, image_path
from tbl_product
where product_code like '%GX'
order by product_name;

update tbl_product set image_path = 'Main_galaxy_z_fold5.jpg'
where product_code = '3000GX';
update tbl_product set image_path = 'Main_galaxy_s23_ultra.jpg'
where product_code = '3200GX';
update tbl_product set image_path = 'Main_galaxy_s24_ultra.jpg'
where product_code = '2200GX';
update tbl_product set image_path = 'Main_galaxy_s25_ultra.jpg'
where product_code = '1200GX';
update tbl_product set image_path = 'Main_galaxy_z_flip5.jpg'
where product_code = '3100GX';
update tbl_product set image_path = 'Main_galaxy_z_flip6.jpg'
where product_code = '2100GX';
update tbl_product set image_path = 'Main_galaxy_z_flip7.jpg'
where product_code = '1100GX';

select * from tbl_product;

delete tbl_product
where product_code = '1234SD';

commit;


SELECT constraint_name
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT_OPTION' AND constraint_type = 'R';

ALTER TABLE TBL_PRODUCT_OPTION
DROP CONSTRAINT FK_TBL_PRODUCT_OPTION_FK_PRODUCT_CODE;

ALTER TABLE TBL_PRODUCT_OPTION
ADD CONSTRAINT FK_TBL_PRODOPT_PROD_CODE
FOREIGN KEY (fk_PRODUCT_CODE)
REFERENCES TBL_PRODUCT (PRODUCT_CODE)
ON DELETE CASCADE;

commit;

select product_name, price
from tbl_product
order by price desc;



select * from tbl_product_image;

select product_code, product_name
from tbl_product
where brand_name = 'Apple'
order by product_name;

insert into tbl_product_image(image_id, fk_product_code_image, plus_image_path)
values(SEQ_PRODUCT_IMAGE.nextval, '1000AP', 'iphone17_1.jpg');
insert into tbl_product_image (image_id, fk_product_code_image, plus_image_path)
values(SEQ_PRODUCT_IMAGE.nextval, '1000AP', 'iphone17_2.jpg');

insert into tbl_product_image (image_id, fk_product_code_image, plus_image_path)
values(SEQ_PRODUCT_IMAGE.nextval, '1100AP', 'iphone17Pro_1.jpg');
insert into tbl_product_image (image_id, fk_product_code_image, plus_image_path)
values(SEQ_PRODUCT_IMAGE.nextval, '1100AP', 'iphone17Pro_2.jpg');

insert into tbl_product_image (image_id, fk_product_code_image, plus_image_path)
values(SEQ_PRODUCT_IMAGE.nextval, '1200AP', 'iphone17ProMax_1.jpg');
insert into tbl_product_image (image_id, fk_product_code_image, plus_image_path)
values(SEQ_PRODUCT_IMAGE.nextval, '1200AP', 'iphone17ProMax_2.jpg');
commit;

select product_code,product_name,image_path, image_id, plus_image_path
from tbl_product P
join tbl_product_image I
on P.product_code = I.fk_product_code_image;

select product_code, product_name, product_desc
from tbl_product
order by product_code;

UPDATE tbl_product
SET product_desc = q'[테스트용 이미지 등록 상품입니다.<br>상품 상세 페이지에서 이미지/설명 출력이 정상 동작하는지 확인할 수 있어요.<br>현재는 샘플 데이터이며, 실제 운영 전 콘텐츠로 교체하면 됩니다.<br>이미지 경로 및 기본 정보 연결 테스트에 적합한 상품입니다.]'
WHERE product_code = '0481SS';




UPDATE tbl_product
SET product_desc = q'[iPhone 17은 일상부터 업무까지 빠르고 안정적인 사용을 목표로 한 프리미엄 스마트폰입니다.<br>선명한 디스플레이와 균형 잡힌 성능으로 앱 전환과 멀티태스킹이 매끄럽습니다.<br>촬영부터 편집까지 한 번에 처리할 수 있도록 카메라 활용성이 강화되었습니다.<br>가볍게 들고 다니기 좋은 설계로 이동이 잦은 사용자에게도 잘 맞습니다.]'
WHERE product_code = '1000AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Fold7은 접었을 때의 휴대성과 펼쳤을 때의 대화면 경험을 모두 제공하는 폴더블 모델입니다.<br>문서 작업, 멀티태스킹, 영상 감상까지 한 화면에서 효율적으로 활용할 수 있어요.<br>앱 분할/플로팅 등 다양한 화면 구성으로 생산성을 높일 수 있습니다.<br>프리미엄 소재와 완성도로 폴더블 입문자부터 헤비 유저까지 만족도가 높습니다.]'
WHERE product_code = '1000GX';

UPDATE tbl_product
SET product_desc = q'[iPhone 17 Pro는 고성능 작업과 촬영을 자주 하는 사용자에게 최적화된 프로 라인업입니다.<br>빠른 처리 속도와 안정적인 발열/전력 관리로 장시간 사용에도 쾌적합니다.<br>사진과 영상 촬영 시 디테일 표현과 색감이 자연스럽게 유지되도록 설계되었습니다.<br>프리미엄 마감과 견고한 내구성으로 데일리 폰으로도 완성도가 높습니다.]'
WHERE product_code = '1100AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Flip7은 컴팩트하게 접히는 폼팩터로 휴대성과 스타일을 동시에 잡은 플립 모델입니다.<br>커버 화면을 활용해 알림 확인, 간단한 조작을 빠르게 처리할 수 있어요.<br>셀피 촬영이나 테이블 위 촬영 등 폴더블 특유의 활용도가 뛰어납니다.<br>가벼운 사용감과 개성 있는 디자인을 원하는 사용자에게 추천합니다.]'
WHERE product_code = '1100GX';

UPDATE tbl_product
SET product_desc = q'[iPhone 17 Pro Max는 대화면과 긴 사용 시간을 원하는 사용자에게 맞춘 최상위 모델입니다.<br>넓은 화면으로 영상/게임/업무를 더욱 몰입감 있게 즐길 수 있습니다.<br>고급 촬영 기능과 안정적인 성능으로 콘텐츠 제작에도 유리합니다.<br>배터리 효율을 중시하는 사용자에게 특히 만족도가 높습니다.]'
WHERE product_code = '1200AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy S25 Ultra는 선명한 대화면과 강력한 성능을 기반으로 한 울트라 플래그십 모델입니다.<br>카메라 활용성이 뛰어나 풍경, 인물, 야간 촬영까지 폭넓게 커버합니다.<br>고사양 게임이나 멀티태스킹에서도 부드러운 동작을 기대할 수 있습니다.<br>업무/학습/엔터테인먼트를 한 기기로 해결하고 싶은 사용자에게 적합합니다.]'
WHERE product_code = '1200GX';

UPDATE tbl_product
SET product_desc = q'[본 상품은 테스트/샘플 목적의 임시 데이터입니다.<br>상품명과 설명, 검색 키워드 등이 실제 운영 기준과 다를 수 있습니다.<br>프론트 화면 출력 및 DB 저장/조회 흐름 점검에 사용할 수 있어요.<br>운영 적용 전 반드시 정상적인 상품 정보로 업데이트하세요.]'
WHERE product_code = '1234IN';

UPDATE tbl_product
SET product_desc = q'[TESTproduct2222는 기능 검증을 위한 테스트 상품입니다.<br>상품 목록/상세/장바구니/결제 흐름에서 데이터가 정상 노출되는지 확인해보세요.<br>옵션 조합, 재고 처리, 가격 계산이 올바르게 동작하는지 점검하기 좋습니다.<br>실서비스 반영 시에는 실제 상품 설명으로 교체가 필요합니다.]'
WHERE product_code = '1234SD';

UPDATE tbl_product
SET product_desc = q'[testAppleProduct24는 애플 계열 상품 등록 기능 테스트용 샘플입니다.<br>이미지 업로드, 상세 페이지 렌더링, 줄바꿈 처리 확인에 적합합니다.<br>관리자 페이지에서 수정/삭제/조회 기능을 점검할 때 활용할 수 있어요.<br>운영 전에는 상품 스펙과 판매 정책에 맞게 설명을 업데이트하세요.]'
WHERE product_code = '1300AP';

UPDATE tbl_product
SET product_desc = q'[iPhone 16은 균형 잡힌 성능과 사용성을 제공하는 스탠다드 모델입니다.<br>일상적인 앱 사용부터 사진/영상 촬영까지 안정적으로 처리할 수 있습니다.<br>선명한 화면과 부드러운 반응성으로 장시간 사용에도 피로감이 적습니다.<br>가성비와 완성도를 함께 고려하는 사용자에게 추천합니다.]'
WHERE product_code = '2000AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Fold6는 대화면 기반의 멀티태스킹에 강점을 가진 폴더블 스마트폰입니다.<br>한 화면에서 여러 앱을 동시에 띄워 업무/학습 효율을 높일 수 있습니다.<br>영상 감상이나 전자책 등 콘텐츠 소비에도 만족도가 높습니다.<br>휴대성과 생산성을 모두 원하는 사용자에게 잘 맞습니다.]'
WHERE product_code = '2000GX';

UPDATE tbl_product
SET product_desc = q'[Galaxy A17은 실속 있는 성능과 합리적인 가격대를 목표로 한 모델입니다.<br>일상적인 SNS, 웹서핑, 영상 감상 등 기본 사용에 충분한 밸런스를 제공합니다.<br>깔끔한 디자인과 가벼운 사용감으로 부담 없이 선택하기 좋아요.<br>세컨드폰이나 부모님 선물용으로도 무난한 선택지입니다.]'
WHERE product_code = '2045GX';

UPDATE tbl_product
SET product_desc = q'[testimageproduct10000은 이미지 업로드/출력 확인을 위한 테스트 상품입니다.<br>상품 상세 화면에서 줄바꿈(<br>) 렌더링이 정상인지 확인할 수 있습니다.<br>썸네일 목록 및 메인 이미지 전환 기능 점검에도 활용하세요.<br>운영 반영 전 실제 상품 설명으로 교체가 필요합니다.]'
WHERE product_code = '2048AD';

UPDATE tbl_product
SET product_desc = q'[iPhone 16 Pro는 고성능과 촬영 품질을 중시하는 사용자에게 최적화된 모델입니다.<br>빠른 처리 속도로 고화질 영상 촬영/편집에도 부담이 적습니다.<br>디테일 표현이 뛰어난 카메라로 일상 기록부터 여행 촬영까지 활용도가 높습니다.<br>프리미엄 디자인과 완성도를 원하는 사용자에게 추천합니다.]'
WHERE product_code = '2100AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Flip6는 컴팩트한 휴대성과 폴더블 특유의 활용성을 제공하는 모델입니다.<br>커버 화면에서 알림 확인과 간단한 조작이 가능해 편의성이 뛰어납니다.<br>거치 없이도 다양한 각도로 촬영할 수 있어 셀피/브이로그에 유리합니다.<br>스타일과 실용성을 동시에 원하는 사용자에게 잘 맞습니다.]'
WHERE product_code = '2100GX';

UPDATE tbl_product
SET product_desc = q'[iPhone 16 Pro Max는 대화면과 강력한 성능을 동시에 원하는 사용자에게 적합합니다.<br>영상 감상과 게임에서 몰입감이 높고, 배터리 사용 시간도 넉넉한 편입니다.<br>프로급 촬영 기능으로 사진/영상 콘텐츠 제작에도 활용하기 좋습니다.<br>하루 종일 스마트폰을 많이 사용하는 사용자에게 추천합니다.]'
WHERE product_code = '2200AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy S24 Ultra는 울트라 라인업다운 강력한 성능과 카메라 활용성을 제공합니다.<br>선명한 대화면으로 콘텐츠 감상과 작업 효율을 동시에 만족시킬 수 있어요.<br>고사양 앱 실행이나 멀티태스킹에서도 안정적인 퍼포먼스를 기대할 수 있습니다.<br>프리미엄 플래그십 경험을 원하는 사용자에게 적합합니다.]'
WHERE product_code = '2200GX';

UPDATE tbl_product
SET product_desc = q'[TestImageProduct44는 이미지 출력과 상세 페이지 UI 점검을 위한 테스트 상품입니다.<br>상품 설명 줄바꿈 처리, 레이아웃 깨짐 여부 등을 확인하기 좋습니다.<br>옵션/가격/재고 연동까지 함께 테스트하면 전체 흐름 검증에 도움이 됩니다.<br>실사용 전에는 실제 콘텐츠로 업데이트하세요.]'
WHERE product_code = '2314AS';

UPDATE tbl_product
SET product_desc = q'[appleTestphone11은 애플 계열 상품 등록/수정 기능 테스트용 샘플입니다.<br>관리자 페이지에서 CRUD 동작 및 데이터 바인딩을 검증할 때 사용할 수 있습니다.<br>특히 상세 설명의 줄바꿈(<br>) 처리와 화면 출력 확인에 적합합니다.<br>운영 적용 전에는 정식 상품 정보로 교체하세요.]'
WHERE product_code = '2345AE';

UPDATE tbl_product
SET product_desc = q'[testimageproduct1623은 상세 설명 줄바꿈 및 이미지 표시를 테스트하기 위한 상품입니다.<br>상품 상세 화면에서 <br> 태그가 실제 줄바꿈으로 반영되는지 확인해보세요.<br>썸네일 클릭 시 메인 이미지 변경, 확대/프레임 처리도 함께 점검하면 좋습니다.<br>테스트 완료 후에는 운영용 설명으로 업데이트하세요.]'
WHERE product_code = '2352SQ';

UPDATE tbl_product
SET product_desc = q'[iPhone 15는 안정적인 성능과 사용성을 바탕으로 꾸준히 사랑받는 모델입니다.<br>일상 사용부터 촬영, 스트리밍까지 전반적으로 균형 잡힌 경험을 제공합니다.<br>가벼운 조작감과 최적화된 시스템으로 장시간 사용에도 만족도가 높습니다.<br>합리적인 선택을 원하는 사용자에게 추천합니다.]'
WHERE product_code = '3000AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Fold5는 폴더블 대화면을 활용해 생산성과 멀티태스킹을 강화한 모델입니다.<br>문서, 메신저, 브라우저를 동시에 띄워 효율적으로 작업할 수 있어요.<br>대화면 콘텐츠 감상에 유리하며 이동 중에도 태블릿처럼 활용 가능합니다.<br>업무와 엔터테인먼트를 함께 즐기는 사용자에게 추천합니다.]'
WHERE product_code = '3000GX';

UPDATE tbl_product
SET product_desc = q'[TestSamsungPhone4432는 삼성 휴대폰 상품 흐름 점검을 위한 테스트 상품입니다.<br>상품 상세 페이지에서 긴 문장/여러 줄 설명이 자연스럽게 출력되는지 확인하세요.<br>가격 표시(천 단위 콤마)와 옵션/재고 처리까지 연동 점검하면 완성도가 올라갑니다.<br>운영 반영 전에는 실상품 스펙과 정책에 맞는 설명으로 교체하세요.]'
WHERE product_code = '3091AP';

UPDATE tbl_product
SET product_desc = q'[iPhone 15 Pro는 가볍고 강력한 성능을 원하는 사용자에게 적합한 프로 모델입니다.<br>빠른 처리 속도로 사진/영상 편집, 고사양 앱 사용에도 부담이 적습니다.<br>카메라 활용성이 뛰어나 일상 기록부터 여행 촬영까지 만족도가 높습니다.<br>프리미엄 폰을 компакт하게 쓰고 싶은 사용자에게 추천합니다.]'
WHERE product_code = '3100AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Flip5는 접는 재미와 휴대성을 모두 갖춘 플립형 폴더블 모델입니다.<br>커버 화면을 통해 빠르게 알림을 확인하고 자주 쓰는 기능을 실행할 수 있습니다.<br>다양한 각도로 세워 촬영할 수 있어 사진/영상 촬영 활용도가 높습니다.<br>개성 있는 디자인과 실용성을 함께 원하는 사용자에게 잘 맞습니다.]'
WHERE product_code = '3100GX';

UPDATE tbl_product
SET product_desc = q'[iPhone 15 Pro Max는 대화면과 강력한 성능을 원하는 사용자에게 최적의 모델입니다.<br>영상 감상, 게임, 작업 등 다양한 활용에서 몰입감이 뛰어납니다.<br>고급 촬영 기능으로 사진/영상 콘텐츠 제작에도 유리합니다.<br>배터리 사용 시간이 중요하고, 큰 화면 선호도가 높은 사용자에게 추천합니다.]'
WHERE product_code = '3200AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy S23 Ultra는 프리미엄 성능과 카메라 경쟁력을 갖춘 울트라 라인업 모델입니다.<br>선명한 디스플레이로 콘텐츠 감상과 작업 효율을 동시에 끌어올릴 수 있습니다.<br>고사양 작업에서도 안정적인 퍼포먼스를 제공해 헤비 유저에게도 적합합니다.<br>플래그십 경험을 원하는 사용자에게 꾸준히 추천되는 선택지입니다.]'
WHERE product_code = '3200GX';

UPDATE tbl_product
SET product_desc = q'[TestImageProduct55는 이미지/설명 출력 테스트를 위한 샘플 상품입니다.<br>상세 페이지에서 <br> 줄바꿈이 정상 반영되는지와 UI 정렬 상태를 확인하세요.<br>이미지 프레임, 썸네일 영역, 확대 기능 등 프론트 동작 점검에도 활용 가능합니다.<br>테스트 완료 후에는 운영용 상품 설명으로 교체하는 것을 권장합니다.]'
WHERE product_code = '4039AD';
commit;


select * from tbl_product;
=======
-------- ?뀒?씠釉? ?깮?꽦 --------

-------- MEMBER TABLE --------
CREATE TABLE TBL_MEMBER (
  MEMBER_ID       VARCHAR2(40)            NOT NULL,
  NAME            VARCHAR2(30)            NOT NULL,
  MOBILE_PHONE    VARCHAR2(100)           NOT NULL,
  PASSWORD        VARCHAR2(200)           NOT NULL,
  EMAIL           VARCHAR2(200)           NOT NULL,
  BIRTH_DATE      VARCHAR2(10)            NOT NULL,
  GENDER          NUMBER(1)               NOT NULL, 
  CREATED_AT      DATE DEFAULT SYSDATE    NOT NULL,
  STATUS          NUMBER(1)               NOT NULL,
  IDLE            NUMBER(1)               NOT NULL,

  CONSTRAINT PK_TBL_MEMBER_MEMBER_ID PRIMARY KEY (MEMBER_ID),
  CONSTRAINT CK_TBL_MEMBER_GENDER CHECK (GENDER IN (0,1)),
  CONSTRAINT CK_TBL_MEMBER_STATUS CHECK (STATUS IN (0,1)),
  CONSTRAINT CK_TBL_MEMBER_IDLE CHECK (IDLE IN (0,1)),
  CONSTRAINT UQ_TBL_MEMBER_EMAIL UNIQUE (EMAIL),
  CONSTRAINT UQ_TBL_MEMBER_MOBILE_PHONE UNIQUE (MOBILE_PHONE)
);

-- status 而щ읆 ?뵒?뤃?듃媛? ?꽕?젙
ALTER TABLE TBL_MEMBER
  MODIFY (STATUS DEFAULT 0);
  
-- idle 而щ읆 ?뵒?뤃?듃媛? ?꽕?젙
ALTER TABLE TBL_MEMBER
  MODIFY (IDLE DEFAULT 0);
  

create table tbl_member_backup
as
select * from tbl_member;

-- ?떆???뒪 ?깮?꽦
CREATE SEQUENCE SEQ_TBL_MEMBER_USERSEQ
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- userseq 而щ읆 異붽?
alter table tbl_member
add userseq number;

update tbl_member set userseq = SEQ_TBL_MEMBER_USERSEQ.nextval
where MEMBER_ID = 'eomjh';

update tbl_member set userseq = SEQ_TBL_MEMBER_USERSEQ.nextval
where MEMBER_ID = 'smon0376';

-- userseq 而щ읆 ?쑀?땲?겕?젣?빟 ?꽕?젙
alter table tbl_member
add constraint UQ_TBL_MEMBER_USERSEQ unique(userseq);

-- userseq 而щ읆 not null ?꽕?젙
alter table tbl_member
modify userseq constraint NN_TBL_MEMBER_USERSEQ not null;

commit;


-------- PRODUCT TABLE --------
CREATE TABLE TBL_PRODUCT (
  PRODUCT_CODE  VARCHAR2(20)    NOT NULL,
  PRODUCT_NAME  VARCHAR2(100)   NOT NULL,
  BRAND_NAME    VARCHAR2(50)    NOT NULL,
  PRODUCT_DESC  VARCHAR2(1000)  NOT NULL,
  SALE_STATUS   VARCHAR2(20)    NOT NULL,
  IMAGE_PATH    VARCHAR2(200)   NOT NULL,

  CONSTRAINT PK_TBL_PRODUCT_PRODUCT_CODE PRIMARY KEY (PRODUCT_CODE)
);

-- IMAGE_PATH 而щ읆 異붽?
ALTER TABLE TBL_PRODUCT
ADD (IMAGE_PATH VARCHAR2(200));

-- IMAGE_PATH 而щ읆 NOT NULL ?젣?빟
ALTER TABLE TBL_PRODUCT
MODIFY (IMAGE_PATH VARCHAR2(200) NOT NULL);


-------- COUPON TABLE --------
CREATE TABLE TBL_COUPON (
  COUPON_CATEGORY_NO NUMBER                  NOT NULL,
  COUPON_NAME        VARCHAR2(20)            NOT NULL,
  DISCOUNT_VALUE     NUMBER                  NOT NULL,
  DISCOUNT_TYPE      NUMBER(1)               NOT NULL,  
  USABLE             NUMBER(1) DEFAULT 1     NOT NULL, 

  CONSTRAINT PK_TBL_COUPON_COUPON_CATEGORY_NO PRIMARY KEY (COUPON_CATEGORY_NO),
  CONSTRAINT CK_TBL_COUPON_DISCOUNT_TYPE CHECK (DISCOUNT_TYPE IN (0,1)),
  CONSTRAINT CK_TBL_COUPON_USABLE CHECK (USABLE IN (0,1)),
  CONSTRAINT CK_TBL_COUPON_DISCOUNT_VALUE CHECK (DISCOUNT_VALUE > 0)
);

-------- ?떆???뒪 ?깮?꽦 --------

CREATE SEQUENCE SEQ_TBL_COUPON_COUPON_CATEGORY_NO
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- 而щ읆 ?냽?꽦 蹂?寃?
ALTER TABLE TBL_COUPON MODIFY COUPON_NAME   VARCHAR2(40 CHAR);




-------- PRODUCT_OPTION TABLE --------
CREATE TABLE TBL_PRODUCT_OPTION (
  OPTION_ID             NUMBER         NOT NULL,
  FK_PRODUCT_CODE       VARCHAR2(20)   NOT NULL,
  COLOR                 VARCHAR2(20)   NOT NULL,
  STORAGE_SIZE          VARCHAR2(20)   NOT NULL,
  PRICE                 NUMBER         NOT NULL,
  STOCK_QTY             NUMBER         NOT NULL,
  IMAGE_PATH            VARCHAR2(200)  NOT NULL,

  CONSTRAINT PK_TBL_PRODUCT_OPTION_OPTION_ID PRIMARY KEY (OPTION_ID),
  CONSTRAINT FK_TBL_PRODUCT_OPTION_FK_PRODUCT_CODE FOREIGN KEY (FK_PRODUCT_CODE)
  REFERENCES TBL_PRODUCT (PRODUCT_CODE),
  CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE CHECK (PRICE > 0),
  CONSTRAINT CK_TBL_PRODUCT_OPTION_STOCK_QTY CHECK (STOCK_QTY >= 0),
  CONSTRAINT UQ_TBL_PRODUCT_OPTION_FK_PRODUCT_CODE_COLOR_STORAGE_SIZE UNIQUE (FK_PRODUCT_CODE, COLOR, STORAGE_SIZE)
);

-- IMAGE_PATH 而щ읆 ?궘?젣
ALTER TABLE TBL_PRODUCT_OPTION
DROP COLUMN IMAGE_PATH;

-------- ?떆???뒪 ?깮?꽦 --------

CREATE SEQUENCE SEQ_TBL_PRODUCT_OPTION_OPTION_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE; 


-------- COUPON_ISSUE TABLE --------
CREATE TABLE TBL_COUPON_ISSUE (
  FK_COUPON_CATEGORY_NO         NUMBER                  NOT NULL,
  COUPON_ID                     NUMBER                  NOT NULL,  
  FK_MEMBER_ID                  VARCHAR2(40)            NOT NULL,
  ISSUE_DATE                    DATE DEFAULT SYSDATE    NOT NULL,
  EXPIRE_DATE                   DATE                    NOT NULL,
  USED_YN                       NUMBER(1) DEFAULT 0     NOT NULL, 

  CONSTRAINT PK_TBL_COUPON_ISSUE_FK_COUPON_CATEGORY_NO_COUPON_ID PRIMARY KEY (FK_COUPON_CATEGORY_NO, COUPON_ID),
  CONSTRAINT FK_TBL_COUPON_ISSUE_FK_COUPON_CATEGORY_NO FOREIGN KEY (FK_COUPON_CATEGORY_NO)
  REFERENCES TBL_COUPON (COUPON_CATEGORY_NO),
  CONSTRAINT FK_TBL_COUPON_ISSUE_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT CK_TBL_COUPON_ISSUE_USED_YN CHECK (USED_YN IN (0,1)),
  CONSTRAINT CK_TBL_COUPON_ISSUE_EXPIRE_DATE CHECK (EXPIRE_DATE > ISSUE_DATE)
);


-------- DELIVERY TABLE --------
CREATE TABLE TBL_DELIVERY (
  DELIVERY_ADDRESS_ID   NUMBER                NOT NULL,
  FK_MEMBER_ID          VARCHAR2(40)          NOT NULL,
  RECIPIENT_NAME        VARCHAR2(50)          NOT NULL,
  RECIPIENT_PHONE       VARCHAR2(100)         NOT NULL,
  ADDRESS               VARCHAR2(200)         NOT NULL,
  ADDRESS_DETAIL        VARCHAR2(200)         NOT NULL,
  ADDRESS_EXTRA         VARCHAR2(200)                 , 
  IS_DEFAULT            NUMBER(1) DEFAULT 0   NOT NULL,
  POSTAL_CODE           VARCHAR2(50)          NOT NULL, 

  CONSTRAINT PK_TBL_DELIVERY_DELIVERY_ADDRESS_ID PRIMARY KEY (DELIVERY_ADDRESS_ID),
  CONSTRAINT FK_TBL_DELIVERY_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT CK_TBL_DELIVERY_IS_DEFAULT CHECK (IS_DEFAULT IN (0,1))
);

-------- ?떆???뒪 ?깮?꽦 --------

CREATE SEQUENCE SEQ_TBL_DELIVERY_DELIVERY_ADDRESS_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-------- CART TABLE --------
CREATE TABLE TBL_CART (
  CART_ID         NUMBER                      NOT NULL,
  FK_MEMBER_ID    VARCHAR2(40)                NOT NULL,
  FK_OPTION_ID    NUMBER                      NOT NULL,
  ADDED_DATE      DATE    DEFAULT SYSDATE     NOT NULL,
  QUANTITY        NUMBER                      NOT NULL,

  CONSTRAINT PK_TBL_CART_CART_ID PRIMARY KEY (CART_ID),
  CONSTRAINT FK_TBL_CART_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT FK_TBL_CART_FK_OPTION_ID FOREIGN KEY (FK_OPTION_ID)
  REFERENCES TBL_PRODUCT_OPTION (OPTION_ID),
  CONSTRAINT CK_TBL_CART_QUANTITY CHECK (QUANTITY > 0),
  CONSTRAINT UQ_TBL_CART_FK_MEMBER_ID_FK_OPTION_ID UNIQUE (FK_MEMBER_ID, FK_OPTION_ID)
);

-------- ?떆???뒪 ?깮?꽦 --------

CREATE SEQUENCE SEQ_TBL_CART_CART_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-------- ORDERS TABLE --------
CREATE TABLE TBL_ORDERS (
  ORDER_ID               NUMBER                     NOT NULL,
  FK_MEMBER_ID           VARCHAR2(40)               NOT NULL,
  ORDER_DATE             DATE DEFAULT SYSDATE       NOT NULL,
  TOTAL_AMOUNT           NUMBER                     NOT NULL,
  DISCOUNT_AMOUNT        NUMBER                     NOT NULL,
  ORDER_STATUS           VARCHAR2(20)               NOT NULL,
  DELIVERY_ADDRESS       VARCHAR2(300)              NOT NULL,

  CONSTRAINT PK_TBL_ORDERS_ORDER_ID PRIMARY KEY (ORDER_ID),
  CONSTRAINT FK_TBL_ORDERS_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT CK_TBL_ORDERS_TOTAL_AMOUNT CHECK (TOTAL_AMOUNT > 0),
  CONSTRAINT CK_TBL_ORDERS_DISCOUNT_AMOUNT CHECK (
    DISCOUNT_AMOUNT >= 0 AND DISCOUNT_AMOUNT < TOTAL_AMOUNT
  )
);

-------- ?떆???뒪 ?깮?꽦 --------

CREATE SEQUENCE SEQ_TBL_ORDERS_ORDER_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE SEQ_TBL_ORDERS_DELIVERY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- 而щ읆 異붽?
ALTER TABLE TBL_ORDERS
ADD (
  DELIVERY_NUMBER     VARCHAR2(20),
  DELIVERY_STARTDATE  DATE,
  DELIVERY_ENDDATE    DATE
);


-- 泥댄겕?젣?빟 異붽?
ALTER TABLE TBL_ORDERS
ADD CONSTRAINT CK_TBL_ORDERS_DELIVERY_DATES
CHECK (
  DELIVERY_ENDDATE IS NULL
  OR (DELIVERY_STARTDATE IS NOT NULL AND DELIVERY_ENDDATE > DELIVERY_STARTDATE)
);



-------- ORDER_DETAIL TABLE --------
CREATE TABLE TBL_ORDER_DETAIL (
  ORDER_DETAIL_ID       NUMBER                   NOT NULL,
  FK_OPTION_ID          NUMBER                   NOT NULL,
  FK_ORDER_ID           NUMBER                   NOT NULL,
  QUANTITY              NUMBER                   NOT NULL,
  UNIT_PRICE            NUMBER                   NOT NULL,
  IS_REVIEW_WRITTEN     NUMBER(1) DEFAULT 0      NOT NULL, 
  PRODUCT_NAME          VARCHAR2(100)            NOT NULL,
  BRAND_NAME            VARCHAR2(50)             NOT NULL,

  CONSTRAINT PK_TBL_ORDER_DETAIL_ORDER_DETAIL_ID PRIMARY KEY (ORDER_DETAIL_ID),
  CONSTRAINT FK_TBL_ORDER_DETAIL_FK_OPTION_ID FOREIGN KEY (FK_OPTION_ID)
  REFERENCES TBL_PRODUCT_OPTION (OPTION_ID),
  CONSTRAINT FK_TBL_ORDER_DETAIL_FK_ORDER_ID FOREIGN KEY (FK_ORDER_ID)
  REFERENCES TBL_ORDERS (ORDER_ID),
  CONSTRAINT CK_TBL_ORDER_DETAIL_QUANTITY CHECK (QUANTITY > 0),
  CONSTRAINT CK_TBL_ORDER_DETAIL_UNIT_PRICE CHECK (UNIT_PRICE > 0),
  CONSTRAINT CK_TBL_ORDER_DETAIL_IS_REVIEW_WRITTEN CHECK (IS_REVIEW_WRITTEN IN (0,1))
);

-------- ?떆???뒪 ?깮?꽦 --------

CREATE SEQUENCE SEQ_TBL_ORDER_DETAIL_ORDER_DETAIL_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-------- REVIEW TABLE --------
CREATE TABLE TBL_REVIEW (
  REVIEW_NUMBER         NUMBER                  NOT NULL,
  FK_OPTION_ID          NUMBER                  NOT NULL,
  FK_ORDER_DETAIL_ID    NUMBER                  NOT NULL,
  REVIEW_CONTENT        VARCHAR2(1000)          NOT NULL,
  WRITEDAY              DATE DEFAULT SYSDATE    NOT NULL,
  RATING                NUMBER(2,1)             NOT NULL,
  DELETED_YN            NUMBER(1)     DEFAULT 0 NOT NULL,
  DELETED_AT            DATE          NULL,
  DELETED_BY            VARCHAR2(40)  NULL

  CONSTRAINT PK_TBL_REVIEW_REVIEW_NUMBER PRIMARY KEY (REVIEW_NUMBER),
  CONSTRAINT FK_TBL_REVIEW_FK_OPTION_ID FOREIGN KEY (FK_OPTION_ID)
  REFERENCES TBL_PRODUCT_OPTION (OPTION_ID),
  CONSTRAINT FK_TBL_REVIEW_FK_ORDER_DETAIL_ID FOREIGN KEY (FK_ORDER_DETAIL_ID)
  REFERENCES TBL_ORDER_DETAIL (ORDER_DETAIL_ID),
  CONSTRAINT CK_TBL_REVIEW_RATING CHECK (RATING BETWEEN 0.5 AND 5.0 AND (RATING*2 = TRUNC(RATING*2))),
  CONSTRAINT CK_TBL_REVIEW_DELETED_YN CHECK (DELETED_YN IN (0,1));
);

-------- ?떆???뒪 ?깮?꽦 --------

CREATE SEQUENCE SEQ_TBL_REVIEW_REVIEW_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- RATING, DELETED_YN, DELETED_AT, DELETED_BT 而щ읆 異붽?
ALTER TABLE TBL_REVIEW ADD (
  RATING      NUMBER(2,1)             NOT NULL,
  DELETED_YN  NUMBER(1)     DEFAULT 0 NOT NULL,
  DELETED_AT  DATE          NULL,
  DELETED_BY  VARCHAR2(40)  NULL
);

-- RATING, DELETED_YN 而щ읆?뿉 泥댄겕?젣?빟 異붽?
ALTER TABLE TBL_REVIEW
ADD CONSTRAINT CK_TBL_REVIEW_RATING
CHECK (
  RATING BETWEEN 0.5 AND 5.0
  AND (RATING*2 = TRUNC(RATING*2))
);

ALTER TABLE TBL_REVIEW
ADD CONSTRAINT CK_TBL_REVIEW_DELETED_YN
CHECK (DELETED_YN IN (0,1));


-- review_title 而щ읆 異붽?
ALTER TABLE TBL_REVIEW
ADD (review_title VARCHAR2(100));

-- review_title 而щ읆 NOT NULL ?젣?빟
ALTER TABLE TBL_REVIEW
MODIFY (review_title VARCHAR2(100) NOT NULL);

-- ?쑀?땲?겕 ?젣?빟 異붽??븿

CREATE UNIQUE INDEX UQ_TBL_REVIEW_FK_ORDER_DETAIL_ID
ON TBL_REVIEW ( CASE WHEN deleted_yn = 0 THEN fk_order_detail_id END );

-- 而щ읆 ???엯 蹂?寃?
ALTER TABLE TBL_REVIEW MODIFY review_title   VARCHAR2(100 CHAR);
ALTER TABLE TBL_REVIEW MODIFY review_content VARCHAR2(1000 CHAR);



-------- INQUIRY TABLE --------
CREATE TABLE TBL_INQUIRY (
  INQUIRY_NUMBER        NUMBER                     NOT NULL,
  FK_MEMBER_ID          VARCHAR2(40)               NOT NULL,
  INQUIRY_TYPE          VARCHAR2(30)               NOT NULL,
  TITLE                 VARCHAR2(100)              NOT NULL,
  REGISTERDAY           DATE DEFAULT SYSDATE       NOT NULL,
  INQUIRY_CONTENT       VARCHAR2(1000)             NOT NULL,
  REPLY_CONTENT         VARCHAR2(1000),
  REPLY_REGISTERDAY     DATE,                                         
  REPLY_STATUS          NUMBER(1) DEFAULT 1   NOT NULL, 

  CONSTRAINT PK_TBL_INQUIRY_INQUIRY_NUMBER PRIMARY KEY (INQUIRY_NUMBER),
  CONSTRAINT FK_TBL_INQUIRY_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS CHECK (REPLY_STATUS IN (0,1,2))
);

-------- ?떆???뒪 ?깮?꽦 --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- 泥댄겕?젣?빟 ?궘?젣
ALTER TABLE TBL_INQUIRY
DROP CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS;

-- 泥댄겕?젣?빟 ?깮?꽦
ALTER TABLE TBL_INQUIRY
ADD CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS
CHECK (REPLY_STATUS IN (0,1,2));

-- REPLY_STATUS ?뵒?뤃?듃媛? 1濡? 蹂?寃?
ALTER TABLE TBL_INQUIRY
MODIFY (REPLY_STATUS DEFAULT 1);


-- deleted_yn, deleted_at, deleted_by, is_secret 而щ읆 異붽?
ALTER TABLE tbl_inquiry ADD (
  deleted_yn NUMBER(1) DEFAULT 0 NOT NULL,
  deleted_at DATE,
  deleted_by VARCHAR2(40),
  is_secret  NUMBER(1) DEFAULT 0 NOT NULL
);

-- deleted_yn, is_secret 而щ읆 泥댄겕?젣?빟 異붽?
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_deleted_yn CHECK (deleted_yn IN (0,1));
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_is_secret  CHECK (is_secret  IN (0,1));



-------- REVIEW_IMAGE --------
CREATE TABLE TBL_REVIEW_IMAGE (
  REVIEW_IMAGE_ID  NUMBER NOT NULL,
  FK_REVIEW_NUMBER NUMBER NOT NULL,
  IMAGE_PATH       VARCHAR2(400) NOT NULL,
  SORT_NO          NUMBER DEFAULT 1 NOT NULL,
  CONSTRAINT PK_TBL_REVIEW_IMAGE PRIMARY KEY (REVIEW_IMAGE_ID),
  CONSTRAINT FK_TBL_REVIEW_IMAGE_REVIEW FOREIGN KEY (FK_REVIEW_NUMBER)
    REFERENCES TBL_REVIEW (REVIEW_NUMBER),
  CONSTRAINT CK_TBL_REVIEW_IMAGE_SORTNO CHECK (SORT_NO >= 1),
  CONSTRAINT UQ_TBL_REVIEW_IMAGE_SORT UNIQUE (FK_REVIEW_NUMBER, SORT_NO)
);




commit;

select *
from tbl_inquiry;




select * from tab;
select * from tbl_member;
select * from tbl_delivery;
select * from tbl_orders;
select * from tbl_inquiry;
select * from tbl_product_option;


update tbl_member set created_at = sysdate
where userseq = 16;

rollback;

commit;










show user;

delete from tbl_product_option;
delete from tbl_product;
commit;


------ ?긽?뭹?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select *
from tbl_product
order by product_name;

------ ?긽?뭹?긽?꽭?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ?븘?씠?룿17 ?뜲?씠?꽣媛?
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '?븘?씠?룿17?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '?븘?씠?룿17 Pro?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '?븘?씠?룿17 Pro Max?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');

-- ?븘?씠?룿16 ?뜲?씠?꽣媛?
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '?븘?씠?룿16?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '?븘?씠?룿16 Pro?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '?븘?씠?룿16 Pro Max?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

-- ?븘?씠?룿15 ?뜲?씠?꽣媛?
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '?븘?씠?룿15?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '?븘?씠?룿15 Pro?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '?븘?씠?룿15 Pro Max?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 媛ㅻ윮?떆?룿 ?뜲?씠?꽣媛?
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', '媛ㅻ윮?떆 Z?뤃?뱶7?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', '媛ㅻ윮?떆 Z?뵆由?7?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', '媛ㅻ윮?떆 s25 ?슱?듃?씪?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

---------------- 媛ㅻ윮?떆6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', '媛ㅻ윮?떆 Z?뤃?뱶6?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', '媛ㅻ윮?떆 Z?뵆由?6?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', '媛ㅻ윮?떆 s24 ?슱?듃?씪?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

---------------- 媛ㅻ윮?떆5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', '媛ㅻ윮?떆 Z?뤃?뱶5?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', '媛ㅻ윮?떆 Z?뵆由?5?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', '媛ㅻ윮?떆 s23 ?슱?듃?씪?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------?븘?씠?룿 ?긽?꽭?샃?뀡 ?뜲?씠?꽣 ?궫?엯----------------------------------------------------
--?븘?씠?룿17 ?긽?꽭?젙蹂?
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

--?븘?씠?룿17 Pro ?긽?꽭?샃?뀡
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

--?븘?씠?룿17 Pro Max ?긽?꽭?샃?뀡
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



--?븘?씠?룿16 ?긽?꽭?샃?뀡
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

--?븘?씠?룿16 Pro ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ?븘?씠?룿16 Pro Max ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--?븘?씠?룿15 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--?븘?씠?룿15 Pro ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--?븘?씠?룿 15 Pro Max ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- ?긽?뭹?긽?꽭 ?젙蹂댁? ?긽?뭹紐? 議곗씤?븯?뿬 媛숈씠 異쒕젰?븯湲?
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- ?긽?뭹?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select * from tbl_product;
commit;

---------------------------------------媛ㅻ윮?떆 ?긽?꽭?샃?뀡 ?뜲?씠?꽣 ?궫?엯----------------------------------------------------
-- Galaxy Z Fold7 ?긽?꽭?샃?뀡
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


-- Galaxy Z Flip7 ?긽?꽭?샃?뀡
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


-- Galaxy S25 Ultra ?긽?꽭?샃?뀡
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

-- 媛ㅻ윮?떆 z?뤃?뱶6 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- 媛ㅻ윮?떆 z?뵆由?6 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- 媛ㅻ윮?떆 s24 ?슱?듃?씪 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- 媛ㅻ윮?떆 ?뤃?뱶5 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- 媛ㅻ윮?떆 ?뵆由?5 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- 媛ㅻ윮?떆 s23 ?슱?듃?씪 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- ?긽?뭹?긽?꽭 ?젙蹂댁? ?긽?뭹紐? 議곗씤?븯?뿬 媛숈씠 異쒕젰?븯湲?
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ?긽?뭹?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select * from tbl_product;
commit;


--?긽?뭹?뿉 ???븳 ?젙蹂댁? 媛?寃⑹씠 ?젣?씪 ?궙?? ?샃?뀡?쓽 ?젙蹂대?? 議곗씤?븯?뿬 異쒕젰
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '?뙋留ㅼ쨷'
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


show user;

delete from tbl_product_option;
delete from tbl_product;
commit;


------ ?긽?뭹?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select *
from tbl_product
order by product_name;

------ ?긽?뭹?긽?꽭?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ?븘?씠?룿17 ?뜲?씠?꽣媛?
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '?븘?씠?룿17?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '?븘?씠?룿17 Pro?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '?븘?씠?룿17 Pro Max?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');

-- ?븘?씠?룿16 ?뜲?씠?꽣媛?
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '?븘?씠?룿16?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '?븘?씠?룿16 Pro?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '?븘?씠?룿16 Pro Max?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

-- ?븘?씠?룿15 ?뜲?씠?꽣媛?
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '?븘?씠?룿15?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '?븘?씠?룿15 Pro?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '?븘?씠?룿15 Pro Max?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 媛ㅻ윮?떆?룿 ?뜲?씠?꽣媛?
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', '媛ㅻ윮?떆 Z?뤃?뱶7?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', '媛ㅻ윮?떆 Z?뵆由?7?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', '媛ㅻ윮?떆 s25 ?슱?듃?씪?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

---------------- 媛ㅻ윮?떆6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', '媛ㅻ윮?떆 Z?뤃?뱶6?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', '媛ㅻ윮?떆 Z?뵆由?6?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', '媛ㅻ윮?떆 s24 ?슱?듃?씪?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

---------------- 媛ㅻ윮?떆5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', '媛ㅻ윮?떆 Z?뤃?뱶5?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', '媛ㅻ윮?떆 Z?뵆由?5?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', '媛ㅻ윮?떆 s23 ?슱?듃?씪?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------?븘?씠?룿 ?긽?꽭?샃?뀡 ?뜲?씠?꽣 ?궫?엯----------------------------------------------------
--?븘?씠?룿17 ?긽?꽭?젙蹂?
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

--?븘?씠?룿17 Pro ?긽?꽭?샃?뀡
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

--?븘?씠?룿17 Pro Max ?긽?꽭?샃?뀡
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



--?븘?씠?룿16 ?긽?꽭?샃?뀡
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

--?븘?씠?룿16 Pro ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ?븘?씠?룿16 Pro Max ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--?븘?씠?룿15 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--?븘?씠?룿15 Pro ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--?븘?씠?룿 15 Pro Max ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- ?긽?뭹?긽?꽭 ?젙蹂댁? ?긽?뭹紐? 議곗씤?븯?뿬 媛숈씠 異쒕젰?븯湲?
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- ?긽?뭹?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select * from tbl_product;
commit;

---------------------------------------媛ㅻ윮?떆 ?긽?꽭?샃?뀡 ?뜲?씠?꽣 ?궫?엯----------------------------------------------------
-- Galaxy Z Fold7 ?긽?꽭?샃?뀡
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


-- Galaxy Z Flip7 ?긽?꽭?샃?뀡
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


-- Galaxy S25 Ultra ?긽?꽭?샃?뀡
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

-- 媛ㅻ윮?떆 z?뤃?뱶6 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- 媛ㅻ윮?떆 z?뵆由?6 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- 媛ㅻ윮?떆 s24 ?슱?듃?씪 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- 媛ㅻ윮?떆 ?뤃?뱶5 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- 媛ㅻ윮?떆 ?뵆由?5 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- 媛ㅻ윮?떆 s23 ?슱?듃?씪 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- ?긽?뭹?긽?꽭 ?젙蹂댁? ?긽?뭹紐? 議곗씤?븯?뿬 媛숈씠 異쒕젰?븯湲?
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ?긽?뭹?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select * from tbl_product;
commit;


--?긽?뭹?뿉 ???븳 ?젙蹂댁? 媛?寃⑹씠 ?젣?씪 ?궙?? ?샃?뀡?쓽 ?젙蹂대?? 議곗씤?븯?뿬 異쒕젰
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '?뙋留ㅼ쨷'
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



-- ?긽?뭹?샃?뀡?뀒?씠釉붿쓽 ?젣?빟議곌굔?뱾 ?솗?씤?븯湲?
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT_OPTION';

-- ?긽?뭹?샃?뀡?뀒?씠釉붿쓽 媛?寃? 泥댄겕議곌굔 ?궘?젣
ALTER TABLE tbl_product_option DROP CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE;

-- ?긽?뭹?샃?뀡?뀒?씠釉붿쓽 pric 而щ읆 ?궘?젣
ALTER TABLE tbl_product_option
DROP COLUMN price;

-- ?긽?뭹?샃?뀡?뀒?씠釉붿뿉 plus_price 而щ읆 異붽?(?젣?빟議곌굔 0怨? 媛숆굅?굹 ?겮)
ALTER TABLE tbl_product_option
ADD plus_price NUMBER DEFAULT 0
    CONSTRAINT ck_tbl_product_option_plus_price CHECK (plus_price >= 0);
    
select * from tbl_product_option;


-- ?긽?뭹?뀒?씠釉붿쓽 ?젣?빟議곌굔?뱾 ?솗?씤?븯湲?
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT';

-- ?긽?뭹?뀒?씠釉붿뿉 price 而щ읆 異붽?(?젣?빟議곌굔 0蹂대떎 而ㅼ빞 ?븿)
ALTER TABLE tbl_product
ADD price NUMBER
    CONSTRAINT ck_tbl_product_price CHECK (price > 0);

select product_code, product_name, price
from tbl_product
where brand_name = 'Samsung'
order by product_code;

-- ?긽?뭹?뀒?씠釉붿쓽 媛?寃⑹뺄?읇?뿉 媛? ?뾽?뜲?씠?듃?븯湲?
update tbl_product set price = 2200000
where product_code = '3000GX';

commit;



-- ?긽?뭹?긽?꽭 ?젙蹂댁? ?긽?뭹紐? 議곗씤?븯?뿬 媛숈씠 異쒕젰?븯湲?
SELECT P.product_code, option_id, P.product_name,storage_size, price, plus_price
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Samsung' and storage_size = '512GB'
ORDER BY product_code, storage_size desc;

-- ?긽?뭹?샃?뀡?뀒?씠釉붿쓽 異붽?湲덉븸 而щ읆?뿉 媛? ?뾽?뜲?씠?듃?븯湲?
update tbl_product_option set plus_price = 150000
where fk_product_code = '2100GX' and storage_size = '512GB';

commit;


--(?긽?뭹肄붾뱶,?긽?뭹紐?,釉뚮옖?뱶紐?,?씠誘몄?寃쎈줈,媛?寃?)
select product_code, product_name, brand_name, image_path, price, sale_status
from tbl_product
where sale_status='?뙋留ㅼ쨷';


select * from tbl_product_option;



SELECT P.product_code, option_id, fk_product_code, P.product_name, color, storage_size, stock_qty,
       (price + plus_price) as total_price
FROM tbl_product_option O
JOIN tbl_product P
ON O.fk_product_code = P.product_code
WHERE product_code = '1100GX';


commit;









select * from tab;
select * from tbl_member;


SELECT userseq, member_id, name, email, mobile_phone
FROM tbl_member
WHERE member_id = 'anth';

DELETE FROM tbl_member
WHERE member_id = 'anth';


-- ?닔?젙?뻽?뒿?땲?떎...
-- ?닔?젙?뻽?뒿?땲?떎...

SELECT * FROM TBL_PRODUCT
SELECT * FROM TBL_PRODUCT_OPTION
SELECT * FROM TBL_ORDERS
SELECT * FROM TBL_ORDER_DETAIL

update tbl_orders set total_amount = 5000000
where order_id = 1001;

commit;

UPDATE TBL_ORDER_DETAIL SET FK_OPTION_ID = 149
WHERE ORDER_DETAIL_ID = 1001

UPDATE TBL_ORDER_DETAIL SET unit_price = 1650000
WHERE ORDER_DETAIL_ID = 1001;

UPDATE TBL_ORDER_DETAIL SET PRODUCT_NAME = 'iPhone15 Pro', BRAND_NAME = 'Apple'
WHERE ORDER_DETAIL_ID = 1000;

INSERT INTO TBL_ORDER_DETAIL
(ORDER_DETAIL_ID, FK_OPTION_ID, FK_ORDER_ID, QUANTITY, UNIT_PRICE, IS_REVIEW_WRITTEN, PRODUCT_NAME, BRAND_NAME)
VALUES
(1002, 196, 1001, 1, 1700000, 0, 'iPhone15 Pro', 'Apple');

COMMIT;

select *
from TBL_DELIVERY


SELECT
  o.order_id,
  o.total_amount AS net_amount,
  o.discount_amount,
  (o.total_amount + o.discount_amount) AS gross_by_orders,
  (SELECT NVL(SUM(d.quantity * d.unit_price),0)
     FROM tbl_order_detail d
    WHERE d.fk_order_id = o.order_id) AS gross_by_detail
FROM tbl_orders o
WHERE o.order_id = 9;


SELECT * FROM TBL_PRODUCT
SELECT * FROM TBL_PRODUCT_OPTION
SELECT * FROM TBL_ORDERS
SELECT * FROM TBL_ORDER_DETAIL

update tbl_orders set total_amount = 4950000
where order_id = 1001;

commit;






-------- INQUIRY TABLE --------
CREATE TABLE TBL_INQUIRY (
  INQUIRY_NUMBER        NUMBER                     NOT NULL,
  FK_MEMBER_ID          VARCHAR2(40)               NOT NULL,
  INQUIRY_TYPE          VARCHAR2(30)               NOT NULL,
  TITLE                 VARCHAR2(100)              NOT NULL,
  REGISTERDAY           DATE DEFAULT SYSDATE       NOT NULL,
  INQUIRY_CONTENT       VARCHAR2(1000)             NOT NULL,
  REPLY_CONTENT         VARCHAR2(1000),
  REPLY_REGISTERDAY     DATE,                                         
  REPLY_STATUS          NUMBER(1) DEFAULT 1   NOT NULL, 

  CONSTRAINT PK_TBL_INQUIRY_INQUIRY_NUMBER PRIMARY KEY (INQUIRY_NUMBER),
  CONSTRAINT FK_TBL_INQUIRY_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS CHECK (REPLY_STATUS IN (0,1,2))
);

-------- ?떆???뒪 ?깮?꽦 --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- 泥댄겕?젣?빟 ?궘?젣
ALTER TABLE TBL_INQUIRY
DROP CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS;

-- 泥댄겕?젣?빟 ?깮?꽦
ALTER TABLE TBL_INQUIRY
ADD CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS
CHECK (REPLY_STATUS IN (0,1,2));

-- REPLY_STATUS ?뵒?뤃?듃媛? 1濡? 蹂?寃?
ALTER TABLE TBL_INQUIRY
MODIFY (REPLY_STATUS DEFAULT 1);


-- deleted_yn, deleted_at, deleted_by, is_secret 而щ읆 異붽?
ALTER TABLE tbl_inquiry ADD (
  deleted_yn NUMBER(1) DEFAULT 0 NOT NULL,
  deleted_at DATE,
  deleted_by VARCHAR2(40),
  is_secret  NUMBER(1) DEFAULT 0 NOT NULL
);

-- deleted_yn, is_secret 而щ읆 泥댄겕?젣?빟 異붽?
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_deleted_yn CHECK (deleted_yn IN (0,1));
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_is_secret  CHECK (is_secret  IN (0,1));


-- 而щ읆 ???엯 蹂?寃?
ALTER TABLE tbl_inquiry MODIFY title   VARCHAR2(100 CHAR);
ALTER TABLE tbl_inquiry MODIFY inquiry_content VARCHAR2(1000 CHAR);
ALTER TABLE tbl_inquiry MODIFY reply_content VARCHAR2(1000 CHAR);
desc tbl_inquiry

-------- REVIEW_IMAGE TABLE --------
CREATE TABLE TBL_REVIEW_IMAGE (
  REVIEW_IMAGE_ID  NUMBER NOT NULL,
  FK_REVIEW_NUMBER NUMBER NOT NULL,
  IMAGE_PATH       VARCHAR2(400) NOT NULL,
  SORT_NO          NUMBER DEFAULT 1 NOT NULL,
  CONSTRAINT PK_TBL_REVIEW_IMAGE PRIMARY KEY (REVIEW_IMAGE_ID),
  CONSTRAINT FK_TBL_REVIEW_IMAGE_REVIEW FOREIGN KEY (FK_REVIEW_NUMBER)
    REFERENCES TBL_REVIEW (REVIEW_NUMBER),
  CONSTRAINT CK_TBL_REVIEW_IMAGE_SORTNO CHECK (SORT_NO >= 1),
  CONSTRAINT UQ_TBL_REVIEW_IMAGE_SORT UNIQUE (FK_REVIEW_NUMBER, SORT_NO)
);


-------- ?떆???뒪 ?깮?꽦 --------

CREATE SEQUENCE SEQ_TBL_REVIEW_IMAGE_NUMBER_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;





select * from tab;
select * from tbl_member;
select * from tbl_delivery;
select * from tbl_orders;
select * from tbl_inquiry;
select * from tbl_product_option;


update tbl_member set created_at = sysdate
where userseq = 16;

rollback;

commit;










show user;

delete from tbl_product_option;
delete from tbl_product;
commit;


------ ?긽?뭹?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select *
from tbl_product
order by product_name;

------ ?긽?뭹?긽?꽭?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ?븘?씠?룿17 ?뜲?씠?꽣媛?
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '?븘?씠?룿17?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '?븘?씠?룿17 Pro?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '?븘?씠?룿17 Pro Max?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');

-- ?븘?씠?룿16 ?뜲?씠?꽣媛?
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '?븘?씠?룿16?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '?븘?씠?룿16 Pro?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '?븘?씠?룿16 Pro Max?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

-- ?븘?씠?룿15 ?뜲?씠?꽣媛?
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '?븘?씠?룿15?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '?븘?씠?룿15 Pro?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '?븘?씠?룿15 Pro Max?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 媛ㅻ윮?떆?룿 ?뜲?씠?꽣媛?
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', '媛ㅻ윮?떆 Z?뤃?뱶7?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', '媛ㅻ윮?떆 Z?뵆由?7?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', '媛ㅻ윮?떆 s25 ?슱?듃?씪?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

---------------- 媛ㅻ윮?떆6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', '媛ㅻ윮?떆 Z?뤃?뱶6?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', '媛ㅻ윮?떆 Z?뵆由?6?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', '媛ㅻ윮?떆 s24 ?슱?듃?씪?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

---------------- 媛ㅻ윮?떆5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', '媛ㅻ윮?떆 Z?뤃?뱶5?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', '媛ㅻ윮?떆 Z?뵆由?5?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', '媛ㅻ윮?떆 s23 ?슱?듃?씪?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------?븘?씠?룿 ?긽?꽭?샃?뀡 ?뜲?씠?꽣 ?궫?엯----------------------------------------------------
--?븘?씠?룿17 ?긽?꽭?젙蹂?
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

--?븘?씠?룿17 Pro ?긽?꽭?샃?뀡
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

--?븘?씠?룿17 Pro Max ?긽?꽭?샃?뀡
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



--?븘?씠?룿16 ?긽?꽭?샃?뀡
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

--?븘?씠?룿16 Pro ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ?븘?씠?룿16 Pro Max ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--?븘?씠?룿15 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--?븘?씠?룿15 Pro ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--?븘?씠?룿 15 Pro Max ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- ?긽?뭹?긽?꽭 ?젙蹂댁? ?긽?뭹紐? 議곗씤?븯?뿬 媛숈씠 異쒕젰?븯湲?
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- ?긽?뭹?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select * from tbl_product;
commit;

---------------------------------------媛ㅻ윮?떆 ?긽?꽭?샃?뀡 ?뜲?씠?꽣 ?궫?엯----------------------------------------------------
-- Galaxy Z Fold7 ?긽?꽭?샃?뀡
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


-- Galaxy Z Flip7 ?긽?꽭?샃?뀡
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


-- Galaxy S25 Ultra ?긽?꽭?샃?뀡
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

-- 媛ㅻ윮?떆 z?뤃?뱶6 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- 媛ㅻ윮?떆 z?뵆由?6 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- 媛ㅻ윮?떆 s24 ?슱?듃?씪 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- 媛ㅻ윮?떆 ?뤃?뱶5 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- 媛ㅻ윮?떆 ?뵆由?5 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- 媛ㅻ윮?떆 s23 ?슱?듃?씪 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- ?긽?뭹?긽?꽭 ?젙蹂댁? ?긽?뭹紐? 議곗씤?븯?뿬 媛숈씠 異쒕젰?븯湲?
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ?긽?뭹?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select * from tbl_product;
commit;


--?긽?뭹?뿉 ???븳 ?젙蹂댁? 媛?寃⑹씠 ?젣?씪 ?궙?? ?샃?뀡?쓽 ?젙蹂대?? 議곗씤?븯?뿬 異쒕젰
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '?뙋留ㅼ쨷'
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


show user;

delete from tbl_product_option;
delete from tbl_product;
commit;


------ ?긽?뭹?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select *
from tbl_product
order by product_name;

------ ?긽?뭹?긽?꽭?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ?븘?씠?룿17 ?뜲?씠?꽣媛?
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '?븘?씠?룿17?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '?븘?씠?룿17 Pro?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '?븘?씠?룿17 Pro Max?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');

-- ?븘?씠?룿16 ?뜲?씠?꽣媛?
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '?븘?씠?룿16?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '?븘?씠?룿16 Pro?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '?븘?씠?룿16 Pro Max?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

-- ?븘?씠?룿15 ?뜲?씠?꽣媛?
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '?븘?씠?룿15?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '?븘?씠?룿15 Pro?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '?븘?씠?룿15 Pro Max?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 媛ㅻ윮?떆?룿 ?뜲?씠?꽣媛?
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', '媛ㅻ윮?떆 Z?뤃?뱶7?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', '媛ㅻ윮?떆 Z?뵆由?7?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', '媛ㅻ윮?떆 s25 ?슱?듃?씪?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

---------------- 媛ㅻ윮?떆6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', '媛ㅻ윮?떆 Z?뤃?뱶6?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', '媛ㅻ윮?떆 Z?뵆由?6?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', '媛ㅻ윮?떆 s24 ?슱?듃?씪?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;

---------------- 媛ㅻ윮?떆5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', '媛ㅻ윮?떆 Z?뤃?뱶5?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', '媛ㅻ윮?떆 Z?뵆由?5?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', '媛ㅻ윮?떆 s23 ?슱?듃?씪?뿉 ???븳 ?꽕紐낆엯?땲?떎. ?엫?떆 ?꽕紐낆엯?땲?떎. ?굹以묒뿉 update濡? 諛붽씀?꽭?슂.', '?뙋留ㅼ쨷', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------?븘?씠?룿 ?긽?꽭?샃?뀡 ?뜲?씠?꽣 ?궫?엯----------------------------------------------------
--?븘?씠?룿17 ?긽?꽭?젙蹂?
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

--?븘?씠?룿17 Pro ?긽?꽭?샃?뀡
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

--?븘?씠?룿17 Pro Max ?긽?꽭?샃?뀡
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



--?븘?씠?룿16 ?긽?꽭?샃?뀡
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

--?븘?씠?룿16 Pro ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ?븘?씠?룿16 Pro Max ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--?븘?씠?룿15 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--?븘?씠?룿15 Pro ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--?븘?씠?룿 15 Pro Max ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- ?긽?뭹?긽?꽭 ?젙蹂댁? ?긽?뭹紐? 議곗씤?븯?뿬 媛숈씠 異쒕젰?븯湲?
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- ?긽?뭹?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select * from tbl_product;
commit;

---------------------------------------媛ㅻ윮?떆 ?긽?꽭?샃?뀡 ?뜲?씠?꽣 ?궫?엯----------------------------------------------------
-- Galaxy Z Fold7 ?긽?꽭?샃?뀡
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


-- Galaxy Z Flip7 ?긽?꽭?샃?뀡
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


-- Galaxy S25 Ultra ?긽?꽭?샃?뀡
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

-- 媛ㅻ윮?떆 z?뤃?뱶6 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- 媛ㅻ윮?떆 z?뵆由?6 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- 媛ㅻ윮?떆 s24 ?슱?듃?씪 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- 媛ㅻ윮?떆 ?뤃?뱶5 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- 媛ㅻ윮?떆 ?뵆由?5 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- 媛ㅻ윮?떆 s23 ?슱?듃?씪 ?긽?꽭?젙蹂?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- ?긽?뭹?긽?꽭 ?젙蹂댁? ?긽?뭹紐? 議곗씤?븯?뿬 媛숈씠 異쒕젰?븯湲?
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ?긽?뭹?뀒?씠釉? ?젙蹂? 異쒕젰?븯湲?
select * from tbl_product;
commit;


--?긽?뭹?뿉 ???븳 ?젙蹂댁? 媛?寃⑹씠 ?젣?씪 ?궙?? ?샃?뀡?쓽 ?젙蹂대?? 議곗씤?븯?뿬 異쒕젰
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '?뙋留ㅼ쨷'
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



-- ?긽?뭹?샃?뀡?뀒?씠釉붿쓽 ?젣?빟議곌굔?뱾 ?솗?씤?븯湲?
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT_OPTION';

-- ?긽?뭹?샃?뀡?뀒?씠釉붿쓽 媛?寃? 泥댄겕議곌굔 ?궘?젣
ALTER TABLE tbl_product_option DROP CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE;

-- ?긽?뭹?샃?뀡?뀒?씠釉붿쓽 pric 而щ읆 ?궘?젣
ALTER TABLE tbl_product_option
DROP COLUMN price;

-- ?긽?뭹?샃?뀡?뀒?씠釉붿뿉 plus_price 而щ읆 異붽?(?젣?빟議곌굔 0怨? 媛숆굅?굹 ?겮)
ALTER TABLE tbl_product_option
ADD plus_price NUMBER DEFAULT 0
    CONSTRAINT ck_tbl_product_option_plus_price CHECK (plus_price >= 0);
    
select * from tbl_product_option;


-- ?긽?뭹?뀒?씠釉붿쓽 ?젣?빟議곌굔?뱾 ?솗?씤?븯湲?
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT';

-- ?긽?뭹?뀒?씠釉붿뿉 price 而щ읆 異붽?(?젣?빟議곌굔 0蹂대떎 而ㅼ빞 ?븿)
ALTER TABLE tbl_product
ADD price NUMBER
    CONSTRAINT ck_tbl_product_price CHECK (price > 0);

select product_code, product_name, price
from tbl_product
where brand_name = 'Samsung'
order by product_code;

-- ?긽?뭹?뀒?씠釉붿쓽 媛?寃⑹뺄?읇?뿉 媛? ?뾽?뜲?씠?듃?븯湲?
update tbl_product set price = 2200000
where product_code = '3000GX';

commit;



-- ?긽?뭹?긽?꽭 ?젙蹂댁? ?긽?뭹紐? 議곗씤?븯?뿬 媛숈씠 異쒕젰?븯湲?
SELECT P.product_code, option_id, P.product_name,storage_size, price, plus_price
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Samsung' and storage_size = '512GB'
ORDER BY product_code, storage_size desc;

-- ?긽?뭹?샃?뀡?뀒?씠釉붿쓽 異붽?湲덉븸 而щ읆?뿉 媛? ?뾽?뜲?씠?듃?븯湲?
update tbl_product_option set plus_price = 150000
where fk_product_code = '2100GX' and storage_size = '512GB';

commit;


--(?긽?뭹肄붾뱶,?긽?뭹紐?,釉뚮옖?뱶紐?,?씠誘몄?寃쎈줈,媛?寃?)
select product_code, product_name, brand_name, image_path, price, sale_status
from tbl_product
where sale_status='?뙋留ㅼ쨷';


select * from tbl_product_option;



SELECT P.product_code, option_id, fk_product_code, P.product_name, color, storage_size, stock_qty,
       (price + plus_price) as total_price
FROM tbl_product_option O
JOIN tbl_product P
ON O.fk_product_code = P.product_code
WHERE product_code = '1100GX';


commit;









select * from tab;
select * from tbl_member;


SELECT userseq, member_id, name, email, mobile_phone
FROM tbl_member
WHERE member_id = 'anth';

DELETE FROM tbl_member
WHERE member_id = 'anth';


-- ?닔?젙?뻽?뒿?땲?떎...
-- ?닔?젙?뻽?뒿?땲?떎...

SELECT * FROM TBL_PRODUCT
SELECT * FROM TBL_PRODUCT_OPTION
SELECT * FROM TBL_ORDERS
SELECT * FROM TBL_ORDER_DETAIL

update tbl_orders set total_amount = 5000000
where order_id = 1001;

commit;

UPDATE TBL_ORDER_DETAIL SET FK_OPTION_ID = 149
WHERE ORDER_DETAIL_ID = 1001

UPDATE TBL_ORDER_DETAIL SET unit_price = 1650000
WHERE ORDER_DETAIL_ID = 1001;

UPDATE TBL_ORDER_DETAIL SET PRODUCT_NAME = 'iPhone15 Pro', BRAND_NAME = 'Apple'
WHERE ORDER_DETAIL_ID = 1000;

INSERT INTO TBL_ORDER_DETAIL
(ORDER_DETAIL_ID, FK_OPTION_ID, FK_ORDER_ID, QUANTITY, UNIT_PRICE, IS_REVIEW_WRITTEN, PRODUCT_NAME, BRAND_NAME)
VALUES
(1002, 196, 1001, 1, 1700000, 0, 'iPhone15 Pro', 'Apple');

COMMIT;

select *
from TBL_DELIVERY


SELECT
  o.order_id,
  o.total_amount AS net_amount,
  o.discount_amount,
  (o.total_amount + o.discount_amount) AS gross_by_orders,
  (SELECT NVL(SUM(d.quantity * d.unit_price),0)
     FROM tbl_order_detail d
    WHERE d.fk_order_id = o.order_id) AS gross_by_detail
FROM tbl_orders o
WHERE o.order_id = 9;


SELECT * FROM TBL_PRODUCT
SELECT * FROM TBL_PRODUCT_OPTION
SELECT * FROM TBL_ORDERS
SELECT * FROM TBL_ORDER_DETAIL

update tbl_orders set total_amount = 4950000
where order_id = 1001;




commit;

select * from tbl_review;
select * from tbl_review_image;

delete from tbl_review
where review_number = 2;

delete from tbl_review_image
where fk_review_number = 2;

update tbl_order_detail set is_review_written = 0
where order_detail_id = 1000;

commit;


select * from tbl_orders;
select * from tbl_order_detail;
select * from tbl_product;
select * from tbl_product_option;
select * from tbl_review;
select * from tbl_member;

insert into tbl_orders(1002, dog, sysdate, 4950000, 50000, 'PAID', '?꽌?슱 ?넚?뙆援? 踰뺤썝濡? 128 101?샇', ?엫?떆?닔?졊?씤, 010-0000-0000, 0);
insert into tbl_order_detail(1003, 149, 1002, 1, 2400000, 0, 'Galaxy Z Fold7', 'Samsung');
insert into tbl_order_detail(1004, 196, 1002, 1, 1700000, 0, 'iPhone15 Pro', 'Apple');

insert into tbl_review(1,196,1000,'踰덉갹?븯?꽭?슂',sysdate,5,0,null,null,'?옒?벐怨? ?엳?뼱?슂');

desc tbl_orders;

select review_number, fk_order_detail_id, deleted_yn
from tbl_review
where fk_order_detail_id = 1000
order by review_number desc;


SELECT constraint_name
     , constraint_type
FROM user_constraints
WHERE table_name = 'TBL_REVIEW'
  AND constraint_type IN ('U','P');
  
  SELECT index_name, column_name, column_position
FROM user_ind_columns
WHERE table_name = 'TBL_REVIEW'
ORDER BY index_name, column_position;



CREATE UNIQUE INDEX UQ_TBL_REVIEW_FK_ORDER_DETAIL_ID
ON TBL_REVIEW ( CASE WHEN deleted_yn = 0 THEN fk_order_detail_id END );

DESC TBL_REVIEW;


select * from tbl_orders where order_status = 'PAID';

select * from tbl_orders
order by order_id;

select * from tbl_order_detail
order by fk_order_id;

select * from tbl_product_option;

select * from tbl_product;

update tbl_orders set delivery_status = 0
where delivery_status = 2;


select * from tbl_member;

select * from tbl_coupon_issue
where fk_member_id = 'dog';


commit;

select color, storage_size, fk_product_code, stock_qty
from tbl_product_option
where UPPER(fk_product_code) = UPPER('1000ap') AND storage_size = '256GB' AND color = 'Black';





----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
--------------------- 상품테이블 데이터 삽입 --------------------------
select * from tbl_product;
/* =========================
   tbl_product 데이터 INSERT
   ========================= */

INSERT INTO tbl_product
(product_code, product_name, brand_name, product_desc, sale_status, image_path, price)
VALUES
('1000AP', 'iPhone17', 'Apple',
 q'[iPhone 17은 일상부터 업무까지 안정적으로 사용할 수 있는 스마트폰입니다.<br>
선명한 디스플레이와 빠른 반응성으로 앱 실행이 부드럽습니다.<br>
사진과 영상 촬영에서도 자연스러운 색감을 제공합니다.<br>
데일리 스마트폰으로 활용하기에 충분한 완성도를 갖췄습니다.]',
 'Y', '', 1000000);

INSERT INTO tbl_product
VALUES
('1100AP', 'iPhone17 Pro', 'Apple',
 q'[iPhone 17 Pro는 고성능 작업과 촬영에 특화된 프리미엄 모델입니다.<br>
강력한 성능으로 멀티태스킹과 고사양 앱 실행이 원활합니다.<br>
카메라 성능이 강화되어 영상 촬영에도 적합합니다.<br>
완성도 높은 디자인과 성능을 원하는 사용자에게 추천합니다.]',
 'Y', '', 1100000);

INSERT INTO tbl_product
VALUES
('1200AP', 'iPhone17 Pro Max', 'Apple',
 q'[iPhone 17 Pro Max는 대화면과 긴 배터리 사용 시간을 제공하는 모델입니다.<br>
영상 감상과 게임에서 몰입감 있는 화면을 경험할 수 있습니다.<br>
고성능 칩셋으로 장시간 사용에도 안정적인 성능을 유지합니다.<br>
큰 화면을 선호하는 사용자에게 적합한 스마트폰입니다.]',
 'Y', '', 1200000);

INSERT INTO tbl_product
VALUES
('2000AP', 'iPhone16', 'Apple',
 q'[iPhone 16은 균형 잡힌 성능과 사용성을 제공하는 모델입니다.<br>
일상적인 앱 사용과 멀티미디어 감상에 적합합니다.<br>
부드러운 인터페이스로 장시간 사용에도 피로도가 낮습니다.<br>
가성비를 고려한 선택지로 추천됩니다.]',
 'Y', '', 2000000);

INSERT INTO tbl_product
VALUES
('2100AP', 'iPhone16 Pro', 'Apple',
 q'[iPhone 16 Pro는 성능과 카메라 활용도를 중시한 모델입니다.<br>
사진과 영상 촬영에서 디테일한 표현이 가능합니다.<br>
고사양 앱과 작업에서도 안정적인 퍼포먼스를 제공합니다.<br>
프리미엄 스마트폰을 원하는 사용자에게 적합합니다.]',
 'Y', '', 2100000);

INSERT INTO tbl_product
VALUES
('2200AP', 'iPhone16 Pro Max', 'Apple',
 q'[iPhone 16 Pro Max는 넓은 화면과 고성능을 동시에 제공합니다.<br>
콘텐츠 감상과 작업에서 높은 몰입감을 제공합니다.<br>
배터리 효율이 좋아 하루 종일 사용이 가능합니다.<br>
최상위 모델을 찾는 사용자에게 추천합니다.]',
 'Y', '', 2200000);

INSERT INTO tbl_product
VALUES
('3000AP', 'iPhone15', 'Apple',
 q'[iPhone 15는 안정적인 성능으로 꾸준히 사랑받는 모델입니다.<br>
일상 사용에 충분한 퍼포먼스를 제공합니다.<br>
사진, 영상, SNS 활용에 무난한 선택지입니다.<br>
실속 있는 스마트폰을 찾는 분께 추천합니다.]',
 'Y', '', 3000000);

INSERT INTO tbl_product
VALUES
('3100AP', 'iPhone15 Pro', 'Apple',
 q'[iPhone 15 Pro는 가볍고 강력한 성능을 갖춘 모델입니다.<br>
고급 카메라 기능으로 촬영 활용도가 높습니다.<br>
빠른 처리 속도로 다양한 작업을 수행할 수 있습니다.<br>
프리미엄 사용 경험을 원하는 사용자에게 적합합니다.]',
 'Y', '', 3100000);

INSERT INTO tbl_product
VALUES
('3200AP', 'iPhone15 Pro Max', 'Apple',
 q'[iPhone 15 Pro Max는 대형 디스플레이와 고성능이 특징입니다.<br>
영상 감상과 게임 플레이에서 뛰어난 몰입감을 제공합니다.<br>
장시간 사용에도 안정적인 퍼포먼스를 유지합니다.<br>
대화면 스마트폰을 선호하는 사용자에게 추천합니다.]',
 'Y', '', 3200000);

INSERT INTO tbl_product
VALUES
('1000GX', 'Galaxy Z Fold7', 'Samsung',
 q'[Galaxy Z Fold7은 접이식 대화면을 제공하는 프리미엄 폴더블 스마트폰입니다.<br>
멀티태스킹과 문서 작업에 최적화된 화면 구성을 지원합니다.<br>
영상 감상과 업무 활용도가 매우 높습니다.<br>
생산성을 중시하는 사용자에게 적합합니다.]',
 'Y', '', 1000000);

INSERT INTO tbl_product
VALUES
('1100GX', 'Galaxy Z Flip7', 'Samsung',
 q'[Galaxy Z Flip7은 컴팩트한 폴더블 디자인이 특징입니다.<br>
휴대성이 뛰어나고 스타일리시한 사용이 가능합니다.<br>
셀피 촬영과 각도 조절 촬영에 유리합니다.<br>
개성 있는 스마트폰을 원하는 사용자에게 추천합니다.]',
 'Y', '', 1100000);

INSERT INTO tbl_product
VALUES
('1200GX', 'Galaxy S25 Ultra', 'Samsung',
 q'[Galaxy S25 Ultra는 최상위 성능을 제공하는 울트라 모델입니다.<br>
대형 디스플레이와 강력한 카메라 성능을 갖추고 있습니다.<br>
고사양 작업과 게임에서도 안정적인 성능을 유지합니다.<br>
프리미엄 안드로이드 스마트폰을 원하는 분께 추천합니다.]',
 'Y', '', 1200000);

INSERT INTO tbl_product
VALUES
('2000GX', 'Galaxy Z Fold6', 'Samsung',
 q'[Galaxy Z Fold6는 대화면 기반의 멀티태스킹에 강점이 있습니다.<br>
여러 앱을 동시에 실행해 작업 효율을 높일 수 있습니다.<br>
콘텐츠 소비와 업무 활용 모두에 적합합니다.<br>
폴더블 경험을 원하는 사용자에게 추천됩니다.]',
 'Y', '', 2000000);

INSERT INTO tbl_product
VALUES
('2100GX', 'Galaxy Z Flip6', 'Samsung',
 q'[Galaxy Z Flip6는 휴대성과 활용성을 겸비한 폴더블 모델입니다.<br>
작은 크기로 접어 휴대하기 편리합니다.<br>
다양한 촬영 각도를 지원해 사진 활용도가 높습니다.<br>
실용성과 디자인을 중시하는 사용자에게 적합합니다.]',
 'Y', '', 2100000);

INSERT INTO tbl_product
VALUES
('2200GX', 'Galaxy S24 Ultra', 'Samsung',
 q'[Galaxy S24 Ultra는 고급스러운 디자인과 성능을 제공합니다.<br>
카메라와 디스플레이 품질이 뛰어납니다.<br>
고사양 앱과 멀티태스킹에서도 안정적인 사용이 가능합니다.<br>
프리미엄 갤럭시 모델을 찾는 사용자에게 추천합니다.]',
 'Y', '', 2200000);

INSERT INTO tbl_product
VALUES
('3000GX', 'Galaxy Z Fold5', 'Samsung',
 q'[Galaxy Z Fold5는 폴더블 대화면의 활용성이 돋보이는 모델입니다.<br>
업무와 엔터테인먼트를 동시에 즐길 수 있습니다.<br>
멀티태스킹에 최적화된 사용자 경험을 제공합니다.<br>
대화면 스마트폰을 선호하는 사용자에게 적합합니다.]',
 'Y', '', 3000000);

INSERT INTO tbl_product
VALUES
('3100GX', 'Galaxy Z Flip5', 'Samsung',
 q'[Galaxy Z Flip5는 세련된 디자인과 휴대성이 특징입니다.<br>
접이식 구조로 사용성과 개성을 모두 만족시킵니다.<br>
촬영과 일상 사용에서 편의성이 뛰어납니다.<br>
트렌디한 스마트폰을 원하는 사용자에게 추천합니다.]',
 'Y', '', 3100000);

INSERT INTO tbl_product
VALUES
('3200GX', 'Galaxy S23 Ultra', 'Samsung',
 q'[Galaxy S23 Ultra는 강력한 성능과 카메라를 갖춘 모델입니다.<br>
대형 디스플레이로 콘텐츠 감상에 최적화되어 있습니다.<br>
업무와 엔터테인먼트 모두에 적합한 스마트폰입니다.<br>
울트라 라인업을 선호하는 사용자에게 추천합니다.]',
 'Y', '', 3200000);

COMMIT;

/* =========================
   iPhone 13 / 14 Series
   ========================= */

INSERT INTO tbl_product
(product_code, product_name, brand_name, product_desc, sale_status, image_path, price)
VALUES
('1300AP', 'iPhone13', 'Apple',
 q'[iPhone 13은 안정적인 성능과 완성도를 갖춘 스탠다드 모델입니다.<br>
일상적인 앱 사용과 멀티미디어 감상에 충분한 성능을 제공합니다.<br>
카메라 성능이 개선되어 사진과 영상 촬영이 더욱 자연스럽습니다.<br>
실사용 중심의 스마트폰을 원하는 사용자에게 적합합니다.]',
 'Y', '', 1300000);

INSERT INTO tbl_product
VALUES
('1310AP', 'iPhone13 Pro', 'Apple',
 q'[iPhone 13 Pro는 성능과 촬영 품질을 강화한 프로 라인업 모델입니다.<br>
고성능 칩셋으로 고사양 앱과 멀티태스킹에서도 안정적인 사용이 가능합니다.<br>
카메라 활용도가 높아 영상 및 사진 촬영에 유리합니다.<br>
프리미엄 사용 경험을 원하는 사용자에게 추천됩니다.]',
 'Y', '', 1400000);

INSERT INTO tbl_product
VALUES
('1320AP', 'iPhone13 Pro Max', 'Apple',
 q'[iPhone 13 Pro Max는 대화면과 긴 배터리 사용 시간을 제공하는 모델입니다.<br>
영상 감상과 게임에서 뛰어난 몰입감을 제공합니다.<br>
프로급 카메라 성능으로 콘텐츠 제작에도 적합합니다.<br>
대형 스마트폰을 선호하는 사용자에게 추천합니다.]',
 'Y', '', 1500000);

INSERT INTO tbl_product
VALUES
('1400AP', 'iPhone14', 'Apple',
 q'[iPhone 14는 균형 잡힌 성능과 향상된 안정성을 제공하는 모델입니다.<br>
일상 사용에 최적화된 인터페이스로 누구나 쉽게 사용할 수 있습니다.<br>
카메라와 디스플레이 품질이 개선되어 만족도가 높습니다.<br>
실속 있는 최신 아이폰을 찾는 사용자에게 적합합니다.]',
 'Y', '', 1600000);

INSERT INTO tbl_product
VALUES
('1410AP', 'iPhone14 Pro', 'Apple',
 q'[iPhone 14 Pro는 고급 기능과 성능을 강화한 프리미엄 모델입니다.<br>
부드러운 화면 전환과 빠른 반응 속도를 제공합니다.<br>
촬영 기능이 강화되어 사진과 영상의 완성도가 높습니다.<br>
성능과 디자인을 모두 중시하는 사용자에게 추천합니다.]',
 'Y', '', 1700000);

INSERT INTO tbl_product
VALUES
('1420AP', 'iPhone14 Pro Max', 'Apple',
 q'[iPhone 14 Pro Max는 대화면과 강력한 성능을 동시에 제공하는 최상위 모델입니다.<br>
콘텐츠 감상과 게임 플레이에서 뛰어난 몰입감을 제공합니다.<br>
고성능 카메라로 다양한 촬영 환경에서도 안정적인 결과를 얻을 수 있습니다.<br>
최고 사양의 아이폰을 원하는 사용자에게 적합합니다.]',
 'Y', '', 1800000);

COMMIT;

----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
----------------------------------------------------------------------------
--------------------- 상품상세 테이블 데이터 삽입 ---------------------
select * from tbl_product_option;
/* =========================================================
   tbl_product_option : 8 options per product
   base option: Black + 256GB (plus_price=0) 반드시 포함
   plus_price: 256GB=0, 512GB=200000, 1T=400000
   ========================================================= */

/* -------------------------
   Apple
-------------------------- */

/* 1000AP iPhone17 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','Black','256GB',24,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','White','256GB',11,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','Blue','256GB',8,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','Red','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','Black','512GB',9,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','White','512GB',5,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','Black','1T',3,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','Blue','1T',1,400000);

/* 1100AP iPhone17 Pro (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','Black','256GB',18,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','White','256GB',9,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','Blue','256GB',7,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','Red','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','Black','512GB',6,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','White','512GB',3,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','Blue','512GB',0,200000);

/* 1200AP iPhone17 Pro Max (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','Black','256GB',14,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','White','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','Blue','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','Red','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','Black','1T',3,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','Blue','1T',1,400000);

/* 1300AP iPhone13 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','Black','256GB',22,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','White','256GB',10,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','Blue','256GB',8,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','Red','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','Black','512GB',5,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','White','512GB',3,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','Blue','512GB',1,200000);

/* 1310AP iPhone13 Pro (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','Black','256GB',16,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','White','256GB',7,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','Blue','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','Red','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','Black','512GB',5,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','Black','1T',1,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','Blue','512GB',3,200000);

/* 1320AP iPhone13 Pro Max (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1320AP','Black','256GB',12,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1320AP','White','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1320AP','Blue','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1320AP','Red','256GB',3,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1320AP','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1320AP','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1320AP','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1320AP','Blue','1T',1,400000);

/* 1400AP iPhone14 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1400AP','Black','256GB',20,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1400AP','White','256GB',9,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1400AP','Blue','256GB',7,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1400AP','Red','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1400AP','Black','512GB',5,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1400AP','White','512GB',3,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1400AP','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1400AP','Blue','512GB',1,200000);

/* 1410AP iPhone14 Pro (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1410AP','Black','256GB',15,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1410AP','White','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1410AP','Blue','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1410AP','Red','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1410AP','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1410AP','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1410AP','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1410AP','Blue','512GB',0,200000);

/* 1420AP iPhone14 Pro Max (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1420AP','Black','256GB',11,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1420AP','White','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1420AP','Blue','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1420AP','Red','256GB',3,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1420AP','Black','512GB',3,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1420AP','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1420AP','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1420AP','Blue','1T',1,400000);

/* 2000AP iPhone16 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','Black','256GB',17,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','White','256GB',8,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','Blue','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','Red','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','Black','512GB',5,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','Blue','512GB',1,200000);

/* 2100AP iPhone16 Pro (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','Black','256GB',13,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','White','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','Blue','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','Red','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','Black','1T',1,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','Blue','1T',2,400000);

/* 2200AP iPhone16 Pro Max (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','Black','256GB',10,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','White','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','Blue','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','Red','256GB',3,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','Black','512GB',3,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','Blue','512GB',1,200000);

/* 3000AP iPhone15 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','Black','256GB',19,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','White','256GB',7,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','Blue','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','Red','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','Black','512GB',5,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','Blue','512GB',1,200000);

/* 3100AP iPhone15 Pro (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','Black','256GB',12,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','White','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','Blue','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','Red','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','Black','1T',1,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','Blue','512GB',3,200000);

/* 3200AP iPhone15 Pro Max (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','Black','256GB',9,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','White','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','Blue','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','Red','256GB',3,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','Black','512GB',3,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','Blue','1T',1,400000);


/* -------------------------
   Samsung
-------------------------- */

/* 1000GX Galaxy Z Fold7 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','Black','256GB',14,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','White','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','Blue','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','Red','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','Black','512GB',5,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','Blue','1T',1,400000);

/* 1100GX Galaxy Z Flip7 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','Black','256GB',16,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','White','256GB',7,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','Blue','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','Red','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','Black','1T',1,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','Blue','512GB',3,200000);

/* 1200GX Galaxy S25 Ultra (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','Black','256GB',13,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','White','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','Blue','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','Red','256GB',3,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','Blue','1T',1,400000);

/* 2000GX Galaxy Z Fold6 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','Black','256GB',12,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','White','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','Blue','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','Red','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','Black','512GB',5,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','Blue','512GB',1,200000);

/* 2100GX Galaxy Z Flip6 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','Black','256GB',15,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','White','256GB',7,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','Blue','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','Red','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','Black','1T',1,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','Blue','1T',2,400000);

/* 2200GX Galaxy S24 Ultra (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','Black','256GB',11,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','White','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','Blue','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','Red','256GB',3,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','Blue','512GB',1,200000);

/* 3000GX Galaxy Z Fold5 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','Black','256GB',10,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','White','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','Blue','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','Red','256GB',3,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','Black','512GB',3,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','Black','1T',1,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','Blue','512GB',1,200000);

/* 3100GX Galaxy Z Flip5 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100GX','Black','256GB',14,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100GX','White','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100GX','Blue','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100GX','Red','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100GX','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100GX','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100GX','Black','1T',1,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100GX','Blue','512GB',3,200000);

/* 3200GX Galaxy S23 Ultra (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200GX','Black','256GB',12,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200GX','White','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200GX','Blue','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200GX','Red','256GB',3,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200GX','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200GX','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200GX','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200GX','Blue','1T',1,400000);

COMMIT;





select * from tbl_product_image;

