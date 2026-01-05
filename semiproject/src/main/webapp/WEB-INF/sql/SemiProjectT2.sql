
<<<<<<< HEAD
-------- í…Œì´ë¸” ìƒì„± --------

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


-------- PRODUCT TABLE --------
CREATE TABLE TBL_PRODUCT (
  PRODUCT_CODE  VARCHAR2(20)    NOT NULL,
  PRODUCT_NAME  VARCHAR2(100)   NOT NULL,
  BRAND_NAME    VARCHAR2(50)    NOT NULL,
  PRODUCT_DESC  VARCHAR2(1000)  NOT NULL,
  SALE_STATUS   VARCHAR2(20)    NOT NULL,

  CONSTRAINT PK_TBL_PRODUCT_PRODUCT_CODE PRIMARY KEY (PRODUCT_CODE)
);


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

-------- ì‹œí€€ìŠ¤ ìƒì„± --------

CREATE SEQUENCE SEQ_TBL_COUPON_COUPON_CATEGORY_NO
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


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


-------- ì‹œí€€ìŠ¤ ìƒì„± --------

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

-------- ì‹œí€€ìŠ¤ ìƒì„± --------

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

-------- ì‹œí€€ìŠ¤ ìƒì„± --------

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

-------- ì‹œí€€ìŠ¤ ìƒì„± --------

CREATE SEQUENCE SEQ_TBL_ORDERS_ORDER_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


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

-------- ì‹œí€€ìŠ¤ ìƒì„± --------

CREATE SEQUENCE SEQ_TBL_ORDER_DETAIL_ORDER_DETAIL_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


-------- REVIEW TABLE --------
CREATE TABLE TBL_REVIEW (
  REVIEW_NUMBER         NUMBER                  NOT NULL,
  FK_OPTION_ID          NUMBER                  NOT NULL,
  FK_ORDER_DETAIL_ID    NUMBER                  NOT NULL,
  REVIEW_CONTENT        VARCHAR2(1000)          NOT NULL,
  WRITEDAY              DATE DEFAULT SYSDATE    NOT NULL,

  CONSTRAINT PK_TBL_REVIEW_REVIEW_NUMBER PRIMARY KEY (REVIEW_NUMBER),
  CONSTRAINT FK_TBL_REVIEW_FK_OPTION_ID FOREIGN KEY (FK_OPTION_ID)
  REFERENCES TBL_PRODUCT_OPTION (OPTION_ID),
  CONSTRAINT FK_TBL_REVIEW_FK_ORDER_DETAIL_ID FOREIGN KEY (FK_ORDER_DETAIL_ID)
  REFERENCES TBL_ORDER_DETAIL (ORDER_DETAIL_ID),
  CONSTRAINT UQ_TBL_REVIEW_FK_ORDER_DETAIL_ID UNIQUE (FK_ORDER_DETAIL_ID)
);

-------- ì‹œí€€ìŠ¤ ìƒì„± --------

CREATE SEQUENCE SEQ_TBL_REVIEW_REVIEW_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


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
  REPLY_STATUS          NUMBER(1) DEFAULT 0   NOT NULL, 

  CONSTRAINT PK_TBL_INQUIRY_INQUIRY_NUMBER PRIMARY KEY (INQUIRY_NUMBER),
  CONSTRAINT FK_TBL_INQUIRY_FK_MEMBER_ID FOREIGN KEY (FK_MEMBER_ID)
  REFERENCES TBL_MEMBER (MEMBER_ID),
  CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS CHECK (REPLY_STATUS IN (0,1))
);

-------- ì‹œí€€ìŠ¤ ìƒì„± --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;


select * from tab;
select * from tbl_member;
select * from tbl_delivery;

select * from TBL_COUPON_ISSUE















=======
delete from tbl_product_option;
delete from tbl_product;
commit;


------ »óÇ°Å×ÀÌºí Á¤º¸ Ãâ·ÂÇÏ±â
select *
from tbl_product
order by product_name;

------ »óÇ°»ó¼¼Å×ÀÌºí Á¤º¸ Ãâ·ÂÇÏ±â
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ¾ÆÀÌÆù17 µ¥ÀÌÅÍ°ª
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '¾ÆÀÌÆù17¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '¾ÆÀÌÆù17 Pro¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '¾ÆÀÌÆù17 Pro Max¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');

-- ¾ÆÀÌÆù16 µ¥ÀÌÅÍ°ª
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '¾ÆÀÌÆù16¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '¾ÆÀÌÆù16 Pro¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '¾ÆÀÌÆù16 Pro Max¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
commit;

-- ¾ÆÀÌÆù15 µ¥ÀÌÅÍ°ª
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '¾ÆÀÌÆù15¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '¾ÆÀÌÆù15 Pro¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '¾ÆÀÌÆù15 Pro Max¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- °¶·°½ÃÆù µ¥ÀÌÅÍ°ª
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', '°¶·°½Ã ZÆúµå7¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', '°¶·°½Ã ZÇÃ¸³7¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', '°¶·°½Ã s25 ¿ïÆ®¶ó¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
commit;

---------------- °¶·°½Ã6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', '°¶·°½Ã ZÆúµå6¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', '°¶·°½Ã ZÇÃ¸³6¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', '°¶·°½Ã s24 ¿ïÆ®¶ó¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
commit;

---------------- °¶·°½Ã5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', '°¶·°½Ã ZÆúµå5¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', '°¶·°½Ã ZÇÃ¸³5¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', '°¶·°½Ã s23 ¿ïÆ®¶ó¿¡ ´ëÇÑ ¼³¸íÀÔ´Ï´Ù. ÀÓ½Ã ¼³¸íÀÔ´Ï´Ù. ³ªÁß¿¡ update·Î ¹Ù²Ù¼¼¿ä.', 'ÆÇ¸ÅÁß', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------¾ÆÀÌÆù »ó¼¼¿É¼Ç µ¥ÀÌÅÍ »ðÀÔ----------------------------------------------------
--¾ÆÀÌÆù17 »ó¼¼Á¤º¸
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

--¾ÆÀÌÆù17 Pro »ó¼¼¿É¼Ç
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

--¾ÆÀÌÆù17 Pro Max »ó¼¼¿É¼Ç
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



--¾ÆÀÌÆù16 »ó¼¼¿É¼Ç
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

--¾ÆÀÌÆù16 Pro »ó¼¼Á¤º¸
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ¾ÆÀÌÆù16 Pro Max »ó¼¼Á¤º¸
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--¾ÆÀÌÆù15 »ó¼¼Á¤º¸
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--¾ÆÀÌÆù15 Pro »ó¼¼Á¤º¸
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--¾ÆÀÌÆù 15 Pro Max »ó¼¼Á¤º¸
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- »óÇ°»ó¼¼ Á¤º¸¿Í »óÇ°¸í Á¶ÀÎÇÏ¿© °°ÀÌ Ãâ·ÂÇÏ±â
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- »óÇ°Å×ÀÌºí Á¤º¸ Ãâ·ÂÇÏ±â
select * from tbl_product;
commit;

---------------------------------------°¶·°½Ã »ó¼¼¿É¼Ç µ¥ÀÌÅÍ »ðÀÔ----------------------------------------------------
-- Galaxy Z Fold7 »ó¼¼¿É¼Ç
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


-- Galaxy Z Flip7 »ó¼¼¿É¼Ç
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


-- Galaxy S25 Ultra »ó¼¼¿É¼Ç
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

-- °¶·°½Ã zÆúµå6 »ó¼¼Á¤º¸
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- °¶·°½Ã zÇÃ¸³6 »ó¼¼Á¤º¸
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- °¶·°½Ã s24 ¿ïÆ®¶ó »ó¼¼Á¤º¸
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- °¶·°½Ã Æúµå5 »ó¼¼Á¤º¸
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- °¶·°½Ã ÇÃ¸³5 »ó¼¼Á¤º¸
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- °¶·°½Ã s23 ¿ïÆ®¶ó »ó¼¼Á¤º¸
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- »óÇ°»ó¼¼ Á¤º¸¿Í »óÇ°¸í Á¶ÀÎÇÏ¿© °°ÀÌ Ãâ·ÂÇÏ±â
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- »óÇ°Å×ÀÌºí Á¤º¸ Ãâ·ÂÇÏ±â
select * from tbl_product;
commit;


--»óÇ°¿¡ ´ëÇÑ Á¤º¸¿Í °¡°ÝÀÌ Á¦ÀÏ ³·Àº ¿É¼ÇÀÇ Á¤º¸¸¦ Á¶ÀÎÇÏ¿© Ãâ·Â
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = 'ÆÇ¸ÅÁß'
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
>>>>>>> origin/anth
