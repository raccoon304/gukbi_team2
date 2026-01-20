
-------- О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ --------

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

-- status О©╫ц╥О©╫ О©╫О©╫О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE TBL_MEMBER
  MODIFY (STATUS DEFAULT 0);
  
-- idle О©╫ц╥О©╫ О©╫О©╫О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE TBL_MEMBER
  MODIFY (IDLE DEFAULT 0);
  

create table tbl_member_backup
as
select * from tbl_member;

-- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫
CREATE SEQUENCE SEQ_TBL_MEMBER_USERSEQ
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- userseq О©╫ц╥О©╫ О©╫ъ╟О©╫
alter table tbl_member
add userseq number;

update tbl_member set userseq = SEQ_TBL_MEMBER_USERSEQ.nextval
where MEMBER_ID = 'eomjh';

update tbl_member set userseq = SEQ_TBL_MEMBER_USERSEQ.nextval
where MEMBER_ID = 'smon0376';

-- userseq О©╫ц╥О©╫ О©╫О©╫О©╫О©╫е╘О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫
alter table tbl_member
add constraint UQ_TBL_MEMBER_USERSEQ unique(userseq);

-- userseq О©╫ц╥О©╫ not null О©╫О©╫О©╫О©╫
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

-- IMAGE_PATH О©╫ц╥О©╫ О©╫ъ╟О©╫
ALTER TABLE TBL_PRODUCT
ADD (IMAGE_PATH VARCHAR2(200));

-- IMAGE_PATH О©╫ц╥О©╫ NOT NULL О©╫О©╫О©╫О©╫
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

-------- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ --------

CREATE SEQUENCE SEQ_TBL_COUPON_COUPON_CATEGORY_NO
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- О©╫ц╥О©╫ О©╫с╪О©╫ О©╫О©╫О©╫О©╫
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

-- IMAGE_PATH О©╫ц╥О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE TBL_PRODUCT_OPTION
DROP COLUMN IMAGE_PATH;

-------- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ --------

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

-------- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ --------

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

-------- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ --------

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

-------- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ --------

CREATE SEQUENCE SEQ_TBL_ORDERS_ORDER_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE SEQ_TBL_ORDERS_DELIVERY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- О©╫ц╥О©╫ О©╫ъ╟О©╫
ALTER TABLE TBL_ORDERS
ADD (
  DELIVERY_NUMBER     VARCHAR2(20),
  DELIVERY_STARTDATE  DATE,
  DELIVERY_ENDDATE    DATE
);


-- ц╪е╘О©╫О©╫О©╫О©╫ О©╫ъ╟О©╫
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

-------- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ --------

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

-------- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ --------

CREATE SEQUENCE SEQ_TBL_REVIEW_REVIEW_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- RATING, DELETED_YN, DELETED_AT, DELETED_BT О©╫ц╥О©╫ О©╫ъ╟О©╫
ALTER TABLE TBL_REVIEW ADD (
  RATING      NUMBER(2,1)             NOT NULL,
  DELETED_YN  NUMBER(1)     DEFAULT 0 NOT NULL,
  DELETED_AT  DATE          NULL,
  DELETED_BY  VARCHAR2(40)  NULL
);

-- RATING, DELETED_YN О©╫ц╥О©╫О©╫О©╫ ц╪е╘О©╫О©╫О©╫О©╫ О©╫ъ╟О©╫
ALTER TABLE TBL_REVIEW
ADD CONSTRAINT CK_TBL_REVIEW_RATING
CHECK (
  RATING BETWEEN 0.5 AND 5.0
  AND (RATING*2 = TRUNC(RATING*2))
);

ALTER TABLE TBL_REVIEW
ADD CONSTRAINT CK_TBL_REVIEW_DELETED_YN
CHECK (DELETED_YN IN (0,1));


-- review_title О©╫ц╥О©╫ О©╫ъ╟О©╫
ALTER TABLE TBL_REVIEW
ADD (review_title VARCHAR2(100));

-- review_title О©╫ц╥О©╫ NOT NULL О©╫О©╫О©╫О©╫
ALTER TABLE TBL_REVIEW
MODIFY (review_title VARCHAR2(100) NOT NULL);

-- О©╫О©╫О©╫О©╫е╘ О©╫О©╫О©╫О©╫ О©╫ъ╟О©╫О©╫О©╫

CREATE UNIQUE INDEX UQ_TBL_REVIEW_FK_ORDER_DETAIL_ID
ON TBL_REVIEW ( CASE WHEN deleted_yn = 0 THEN fk_order_detail_id END );

-- О©╫ц╥О©╫ е╦О©╫О©╫ О©╫О©╫О©╫О©╫
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

-------- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- ц╪е╘О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE TBL_INQUIRY
DROP CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS;

-- ц╪е╘О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE TBL_INQUIRY
ADD CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS
CHECK (REPLY_STATUS IN (0,1,2));

-- REPLY_STATUS О©╫О©╫О©╫О©╫ф╝О©╫О©╫ 1О©╫О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE TBL_INQUIRY
MODIFY (REPLY_STATUS DEFAULT 1);


-- deleted_yn, deleted_at, deleted_by, is_secret О©╫ц╥О©╫ О©╫ъ╟О©╫
ALTER TABLE tbl_inquiry ADD (
  deleted_yn NUMBER(1) DEFAULT 0 NOT NULL,
  deleted_at DATE,
  deleted_by VARCHAR2(40),
  is_secret  NUMBER(1) DEFAULT 0 NOT NULL
);

-- deleted_yn, is_secret О©╫ц╥О©╫ ц╪е╘О©╫О©╫О©╫О©╫ О©╫ъ╟О©╫
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


------ О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select *
from tbl_product
order by product_name;

------ О©╫О©╫г╟О©╫О©╫О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- О©╫О©╫О©╫О©╫О©╫О©╫17 О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫17О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫17 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫17 Pro MaxО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');

-- О©╫О©╫О©╫О©╫О©╫О©╫16 О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫16О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫16 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫16 Pro MaxО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

-- О©╫О©╫О©╫О©╫О©╫О©╫15 О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫15О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫15 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫15 Pro MaxО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫О©╫О©╫О©╫7О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫ц╦О©╫7О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ s25 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

---------------- О©╫О©╫О©╫О©╫О©╫О©╫6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫О©╫О©╫О©╫6О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫ц╦О©╫6О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ s24 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

---------------- О©╫О©╫О©╫О©╫О©╫О©╫5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫О©╫О©╫О©╫5О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫ц╦О©╫5О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ s23 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------О©╫О©╫О©╫О©╫О©╫О©╫ О©╫С╪╪©и╪О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫----------------------------------------------------
--О©╫О©╫О©╫О©╫О©╫О©╫17 О©╫О©╫О©╫О©╫О©╫О©╫
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

--О©╫О©╫О©╫О©╫О©╫О©╫17 Pro О©╫С╪╪©и╪О©╫
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

--О©╫О©╫О©╫О©╫О©╫О©╫17 Pro Max О©╫С╪╪©и╪О©╫
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



--О©╫О©╫О©╫О©╫О©╫О©╫16 О©╫С╪╪©и╪О©╫
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

--О©╫О©╫О©╫О©╫О©╫О©╫16 Pro О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- О©╫О©╫О©╫О©╫О©╫О©╫16 Pro Max О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--О©╫О©╫О©╫О©╫О©╫О©╫15 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--О©╫О©╫О©╫О©╫О©╫О©╫15 Pro О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--О©╫О©╫О©╫О©╫О©╫О©╫ 15 Pro Max О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select * from tbl_product;
commit;

---------------------------------------О©╫О©╫О©╫О©╫О©╫О©╫ О©╫С╪╪©и╪О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫----------------------------------------------------
-- Galaxy Z Fold7 О©╫С╪╪©и╪О©╫
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


-- Galaxy Z Flip7 О©╫С╪╪©и╪О©╫
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


-- Galaxy S25 Ultra О©╫С╪╪©и╪О©╫
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

-- О©╫О©╫О©╫О©╫О©╫О©╫ zО©╫О©╫О©╫О©╫6 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ zО©╫ц╦О©╫6 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ s24 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫5 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫ц╦О©╫5 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ s23 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select * from tbl_product;
commit;


--О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫и╪О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©?
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = 'О©╫г╦О©╫О©╫О©╫'
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


------ О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select *
from tbl_product
order by product_name;

------ О©╫О©╫г╟О©╫О©╫О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- О©╫О©╫О©╫О©╫О©╫О©╫17 О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫17О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫17 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫17 Pro MaxО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');

-- О©╫О©╫О©╫О©╫О©╫О©╫16 О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫16О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫16 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫16 Pro MaxО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

-- О©╫О©╫О©╫О©╫О©╫О©╫15 О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫15О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫15 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫15 Pro MaxО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫О©╫О©╫О©╫7О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫ц╦О©╫7О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ s25 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

---------------- О©╫О©╫О©╫О©╫О©╫О©╫6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫О©╫О©╫О©╫6О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫ц╦О©╫6О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ s24 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

---------------- О©╫О©╫О©╫О©╫О©╫О©╫5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫О©╫О©╫О©╫5О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫ц╦О©╫5О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ s23 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------О©╫О©╫О©╫О©╫О©╫О©╫ О©╫С╪╪©и╪О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫----------------------------------------------------
--О©╫О©╫О©╫О©╫О©╫О©╫17 О©╫О©╫О©╫О©╫О©╫О©╫
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

--О©╫О©╫О©╫О©╫О©╫О©╫17 Pro О©╫С╪╪©и╪О©╫
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

--О©╫О©╫О©╫О©╫О©╫О©╫17 Pro Max О©╫С╪╪©и╪О©╫
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



--О©╫О©╫О©╫О©╫О©╫О©╫16 О©╫С╪╪©и╪О©╫
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

--О©╫О©╫О©╫О©╫О©╫О©╫16 Pro О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- О©╫О©╫О©╫О©╫О©╫О©╫16 Pro Max О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--О©╫О©╫О©╫О©╫О©╫О©╫15 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--О©╫О©╫О©╫О©╫О©╫О©╫15 Pro О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--О©╫О©╫О©╫О©╫О©╫О©╫ 15 Pro Max О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select * from tbl_product;
commit;

---------------------------------------О©╫О©╫О©╫О©╫О©╫О©╫ О©╫С╪╪©и╪О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫----------------------------------------------------
-- Galaxy Z Fold7 О©╫С╪╪©и╪О©╫
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


-- Galaxy Z Flip7 О©╫С╪╪©и╪О©╫
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


-- Galaxy S25 Ultra О©╫С╪╪©и╪О©╫
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

-- О©╫О©╫О©╫О©╫О©╫О©╫ zО©╫О©╫О©╫О©╫6 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ zО©╫ц╦О©╫6 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ s24 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫5 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫ц╦О©╫5 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ s23 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select * from tbl_product;
commit;


--О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫и╪О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©?
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = 'О©╫г╦О©╫О©╫О©╫'
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



-- О©╫О©╫г╟О©╫и╪О©╫О©╫О©╫О©╫л╨О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫г╣О©╫ х╝О©╫О©╫О©╫о╠О©╫
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT_OPTION';

-- О©╫О©╫г╟О©╫и╪О©╫О©╫О©╫О©╫л╨О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ ц╪е╘О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE tbl_product_option DROP CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE;

-- О©╫О©╫г╟О©╫и╪О©╫О©╫О©╫О©╫л╨О©╫О©╫О©╫ pric О©╫ц╥О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE tbl_product_option
DROP COLUMN price;

-- О©╫О©╫г╟О©╫и╪О©╫О©╫О©╫О©╫л╨О©╫ plus_price О©╫ц╥О©╫ О©╫ъ╟О©╫(О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ 0О©╫О©╫ О©╫О©╫О©╫еЁО©╫ е╜)
ALTER TABLE tbl_product_option
ADD plus_price NUMBER DEFAULT 0
    CONSTRAINT ck_tbl_product_option_plus_price CHECK (plus_price >= 0);
    
select * from tbl_product_option;


-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫г╣О©╫ х╝О©╫О©╫О©╫о╠О©╫
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT';

-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ price О©╫ц╥О©╫ О©╫ъ╟О©╫(О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ 0О©╫О©╫О©╫О©╫ д©О©╫О©╫ О©╫О©╫)
ALTER TABLE tbl_product
ADD price NUMBER
    CONSTRAINT ck_tbl_product_price CHECK (price > 0);

select product_code, product_name, price
from tbl_product
where brand_name = 'Samsung'
order by product_code;

-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫ц╥О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ф╝О©╫о╠О©╫
update tbl_product set price = 2200000
where product_code = '3000GX';

commit;



-- О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
SELECT P.product_code, option_id, P.product_name,storage_size, price, plus_price
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Samsung' and storage_size = '512GB'
ORDER BY product_code, storage_size desc;

-- О©╫О©╫г╟О©╫и╪О©╫О©╫О©╫О©╫л╨О©╫О©╫О©╫ О©╫ъ╟О©╫О©╫щ╬О©╫ О©╫ц╥О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ф╝О©╫о╠О©╫
update tbl_product_option set plus_price = 150000
where fk_product_code = '2100GX' and storage_size = '512GB';

commit;


--(О©╫О©╫г╟О©╫з╣О©╫,О©╫О©╫г╟О©╫О©╫,О©╫Й╥ёО©╫О©╫О©?,О©╫л╧О©╫О©╫О©╫О©╫О©╫О©?,О©╫О©╫О©╫О©╫)
select product_code, product_name, brand_name, image_path, price, sale_status
from tbl_product
where sale_status='О©╫г╦О©╫О©╫О©╫';


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


-- О©╫О©╫О©╫О©╫О©╫ъ╫О©╫О©╫о╢О©╫...
-- О©╫О©╫О©╫О©╫О©╫ъ╫О©╫О©╫о╢О©╫...

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

-------- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- ц╪е╘О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE TBL_INQUIRY
DROP CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS;

-- ц╪е╘О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE TBL_INQUIRY
ADD CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS
CHECK (REPLY_STATUS IN (0,1,2));

-- REPLY_STATUS О©╫О©╫О©╫О©╫ф╝О©╫О©╫ 1О©╫О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE TBL_INQUIRY
MODIFY (REPLY_STATUS DEFAULT 1);


-- deleted_yn, deleted_at, deleted_by, is_secret О©╫ц╥О©╫ О©╫ъ╟О©╫
ALTER TABLE tbl_inquiry ADD (
  deleted_yn NUMBER(1) DEFAULT 0 NOT NULL,
  deleted_at DATE,
  deleted_by VARCHAR2(40),
  is_secret  NUMBER(1) DEFAULT 0 NOT NULL
);

-- deleted_yn, is_secret О©╫ц╥О©╫ ц╪е╘О©╫О©╫О©╫О©╫ О©╫ъ╟О©╫
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_deleted_yn CHECK (deleted_yn IN (0,1));
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_is_secret  CHECK (is_secret  IN (0,1));


-- О©╫ц╥О©╫ е╦О©╫О©╫ О©╫О©╫О©╫О©╫
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


-------- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ --------

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


------ О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select *
from tbl_product
order by product_name;

------ О©╫О©╫г╟О©╫О©╫О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- О©╫О©╫О©╫О©╫О©╫О©╫17 О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫17О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫17 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫17 Pro MaxО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');

-- О©╫О©╫О©╫О©╫О©╫О©╫16 О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫16О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫16 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫16 Pro MaxО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

-- О©╫О©╫О©╫О©╫О©╫О©╫15 О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫15О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫15 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫15 Pro MaxО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫О©╫О©╫О©╫7О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫ц╦О©╫7О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ s25 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

---------------- О©╫О©╫О©╫О©╫О©╫О©╫6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫О©╫О©╫О©╫6О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫ц╦О©╫6О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ s24 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

---------------- О©╫О©╫О©╫О©╫О©╫О©╫5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫О©╫О©╫О©╫5О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫ц╦О©╫5О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ s23 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------О©╫О©╫О©╫О©╫О©╫О©╫ О©╫С╪╪©и╪О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫----------------------------------------------------
--О©╫О©╫О©╫О©╫О©╫О©╫17 О©╫О©╫О©╫О©╫О©╫О©╫
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

--О©╫О©╫О©╫О©╫О©╫О©╫17 Pro О©╫С╪╪©и╪О©╫
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

--О©╫О©╫О©╫О©╫О©╫О©╫17 Pro Max О©╫С╪╪©и╪О©╫
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



--О©╫О©╫О©╫О©╫О©╫О©╫16 О©╫С╪╪©и╪О©╫
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

--О©╫О©╫О©╫О©╫О©╫О©╫16 Pro О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- О©╫О©╫О©╫О©╫О©╫О©╫16 Pro Max О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--О©╫О©╫О©╫О©╫О©╫О©╫15 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--О©╫О©╫О©╫О©╫О©╫О©╫15 Pro О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--О©╫О©╫О©╫О©╫О©╫О©╫ 15 Pro Max О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select * from tbl_product;
commit;

---------------------------------------О©╫О©╫О©╫О©╫О©╫О©╫ О©╫С╪╪©и╪О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫----------------------------------------------------
-- Galaxy Z Fold7 О©╫С╪╪©и╪О©╫
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


-- Galaxy Z Flip7 О©╫С╪╪©и╪О©╫
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


-- Galaxy S25 Ultra О©╫С╪╪©и╪О©╫
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

-- О©╫О©╫О©╫О©╫О©╫О©╫ zО©╫О©╫О©╫О©╫6 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ zО©╫ц╦О©╫6 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ s24 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫5 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫ц╦О©╫5 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ s23 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select * from tbl_product;
commit;


--О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫и╪О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©?
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = 'О©╫г╦О©╫О©╫О©╫'
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


------ О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select *
from tbl_product
order by product_name;

------ О©╫О©╫г╟О©╫О©╫О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- О©╫О©╫О©╫О©╫О©╫О©╫17 О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫17О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫17 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫17 Pro MaxО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');

-- О©╫О©╫О©╫О©╫О©╫О©╫16 О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫16О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫16 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫16 Pro MaxО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

-- О©╫О©╫О©╫О©╫О©╫О©╫15 О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫15О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫15 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', 'О©╫О©╫О©╫О©╫О©╫О©╫15 Pro MaxО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫м╟О©╫
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫О©╫О©╫О©╫7О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫ц╦О©╫7О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ s25 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

---------------- О©╫О©╫О©╫О©╫О©╫О©╫6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫О©╫О©╫О©╫6О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫ц╦О©╫6О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ s24 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;

---------------- О©╫О©╫О©╫О©╫О©╫О©╫5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫О©╫О©╫О©╫5О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ ZО©╫ц╦О©╫5О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', 'О©╫О©╫О©╫О©╫О©╫О©╫ s23 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫. О©╫О©╫О©╫ъ©О©╫ updateО©╫О©╫ О©╫ы╡ы╪О©╫О©╫О©╫.', 'О©╫г╦О©╫О©╫О©╫', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------О©╫О©╫О©╫О©╫О©╫О©╫ О©╫С╪╪©и╪О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫----------------------------------------------------
--О©╫О©╫О©╫О©╫О©╫О©╫17 О©╫О©╫О©╫О©╫О©╫О©╫
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

--О©╫О©╫О©╫О©╫О©╫О©╫17 Pro О©╫С╪╪©и╪О©╫
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

--О©╫О©╫О©╫О©╫О©╫О©╫17 Pro Max О©╫С╪╪©и╪О©╫
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



--О©╫О©╫О©╫О©╫О©╫О©╫16 О©╫С╪╪©и╪О©╫
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

--О©╫О©╫О©╫О©╫О©╫О©╫16 Pro О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- О©╫О©╫О©╫О©╫О©╫О©╫16 Pro Max О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--О©╫О©╫О©╫О©╫О©╫О©╫15 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--О©╫О©╫О©╫О©╫О©╫О©╫15 Pro О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--О©╫О©╫О©╫О©╫О©╫О©╫ 15 Pro Max О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select * from tbl_product;
commit;

---------------------------------------О©╫О©╫О©╫О©╫О©╫О©╫ О©╫С╪╪©и╪О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫----------------------------------------------------
-- Galaxy Z Fold7 О©╫С╪╪©и╪О©╫
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


-- Galaxy Z Flip7 О©╫С╪╪©и╪О©╫
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


-- Galaxy S25 Ultra О©╫С╪╪©и╪О©╫
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

-- О©╫О©╫О©╫О©╫О©╫О©╫ zО©╫О©╫О©╫О©╫6 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ zО©╫ц╦О©╫6 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ s24 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫5 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ О©╫ц╦О©╫5 О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- О©╫О©╫О©╫О©╫О©╫О©╫ s23 О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
select * from tbl_product;
commit;


--О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫и╪О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©?
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = 'О©╫г╦О©╫О©╫О©╫'
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



-- О©╫О©╫г╟О©╫и╪О©╫О©╫О©╫О©╫л╨О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫г╣О©╫ х╝О©╫О©╫О©╫о╠О©╫
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT_OPTION';

-- О©╫О©╫г╟О©╫и╪О©╫О©╫О©╫О©╫л╨О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ ц╪е╘О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE tbl_product_option DROP CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE;

-- О©╫О©╫г╟О©╫и╪О©╫О©╫О©╫О©╫л╨О©╫О©╫О©╫ pric О©╫ц╥О©╫ О©╫О©╫О©╫О©╫
ALTER TABLE tbl_product_option
DROP COLUMN price;

-- О©╫О©╫г╟О©╫и╪О©╫О©╫О©╫О©╫л╨О©╫ plus_price О©╫ц╥О©╫ О©╫ъ╟О©╫(О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ 0О©╫О©╫ О©╫О©╫О©╫еЁО©╫ е╜)
ALTER TABLE tbl_product_option
ADD plus_price NUMBER DEFAULT 0
    CONSTRAINT ck_tbl_product_option_plus_price CHECK (plus_price >= 0);
    
select * from tbl_product_option;


-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫г╣О©╫ х╝О©╫О©╫О©╫о╠О©╫
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT';

-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫ price О©╫ц╥О©╫ О©╫ъ╟О©╫(О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ 0О©╫О©╫О©╫О©╫ д©О©╫О©╫ О©╫О©╫)
ALTER TABLE tbl_product
ADD price NUMBER
    CONSTRAINT ck_tbl_product_price CHECK (price > 0);

select product_code, product_name, price
from tbl_product
where brand_name = 'Samsung'
order by product_code;

-- О©╫О©╫г╟О©╫О©╫О©╫л╨О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫ц╥О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ф╝О©╫о╠О©╫
update tbl_product set price = 2200000
where product_code = '3000GX';

commit;



-- О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о©О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╠О©?
SELECT P.product_code, option_id, P.product_name,storage_size, price, plus_price
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Samsung' and storage_size = '512GB'
ORDER BY product_code, storage_size desc;

-- О©╫О©╫г╟О©╫и╪О©╫О©╫О©╫О©╫л╨О©╫О©╫О©╫ О©╫ъ╟О©╫О©╫щ╬О©╫ О©╫ц╥О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ф╝О©╫о╠О©╫
update tbl_product_option set plus_price = 150000
where fk_product_code = '2100GX' and storage_size = '512GB';

commit;


--(О©╫О©╫г╟О©╫з╣О©╫,О©╫О©╫г╟О©╫О©╫,О©╫Й╥ёО©╫О©╫О©?,О©╫л╧О©╫О©╫О©╫О©╫О©╫О©?,О©╫О©╫О©╫О©╫)
select product_code, product_name, brand_name, image_path, price, sale_status
from tbl_product
where sale_status='О©╫г╦О©╫О©╫О©╫';


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


-- О©╫О©╫О©╫О©╫О©╫ъ╫О©╫О©╫о╢О©╫...
-- О©╫О©╫О©╫О©╫О©╫ъ╫О©╫О©╫о╢О©╫...

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

insert into tbl_orders(1002, dog, sysdate, 4950000, 50000, 'PAID', 'О©╫О©╫О©╫О©╫ О©╫О©╫О©╫д╠О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ 128 101хё', О©╫с╫ц╪О©╫О©╫О©╫О©╫О©╫, 010-0000-0000, 0);
insert into tbl_order_detail(1003, 149, 1002, 1, 2400000, 0, 'Galaxy Z Fold7', 'Samsung');
insert into tbl_order_detail(1004, 196, 1002, 1, 1700000, 0, 'iPhone15 Pro', 'Apple');

insert into tbl_review(1,196,1000,'О©╫О©╫ц╒О©╫о╪О©╫О©╫О©╫',sysdate,5,0,null,null,'О©╫ъ╬О©╫О©╫О©╫ О©╫ж╬О©╫О©?');

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
-- Table TBL_PRODUCT_IMAGEО©╫О©╫(О©╫О©╫) О©╫О©╫О©╫О©╫О©╫г╬О©╫О©╫О©╫О©╫о╢О©╫.

ALTER TABLE tbl_product_image
RENAME COLUMN product_code TO fk_product_code_image;
ALTER TABLE tbl_product_image
RENAME COLUMN image_path TO plus_image_path;
commit;

-- PRIMARY KEY О©╫ъ╟О©╫
ALTER TABLE tbl_product_image ADD CONSTRAINT pk_product_image PRIMARY KEY (image_id);

-- FOREIGN KEY О©╫ъ╟О©╫ (О©╫О©╫г╟ О©╫О©╫О©╫л╨О©╫О©? О©╫О©╫О©╫О©╫)
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
-- Sequence SEQ_PRODUCT_IMAGEО©╫О©╫(О©╫О©╫) О©╫О©╫О©╫О©╫О©╫г╬О©╫О©╫О©╫О©╫о╢О©╫.

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
SET product_desc = q'[О©╫в╫О©╫ф╝О©╫О©╫ О©╫л╧О©╫О©╫О©╫ О©╫О©╫О©? О©╫О©╫г╟О©╫т╢о╢О©╫.<br>О©╫О©╫г╟ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫л╧О©╫О©╫О©╫/О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©? О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫О©╫О©╫ х╝О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫ж╬О©╫О©?.<br>О©╫О©╫О©╫О©╫О©? О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫л╦О©╫, О©╫О©╫О©╫О©╫ О©╫Н©╣ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ц╪О©╫о╦О©╫ О©╫к╢о╢О©╫.<br>О©╫л╧О©╫О©╫О©╫ О©╫О©╫О©? О©╫О©╫ О©╫Б╨╩ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫в╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫т╢о╢О©╫.]'
WHERE product_code = '0481SS';




UPDATE tbl_product
SET product_desc = q'[iPhone 17О©╫О©╫ О©╫о╩О©╫О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©? О©╫О©╫г╔О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫л╬О©╫ О©╫О©╫О©╫О©╫ф╝О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫ц╥О©╫О©╫л©О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫х╞О©╫О©╫ О©╫О©╫ф╪О©╫б╫О©╫е╥О©╫О©╫ О©╫е╡О©╫О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫т©О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫ цЁО©╫О©╫О©╫О©╫ О©╫О©╫ О©╫ж╣О©╫О©╫О©╫ д╚О©╫ч╤О©╫ х╟О©╫К╪╨О©╫О©╫ О©╫О©╫х╜О©╫г╬О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©? О©╫ы╢о╠О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©? О©╫л╣О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫т╣О©? О©╫О©╫ О©╫б╫О©╫О©╫о╢О©╫.]'
WHERE product_code = '1000AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Fold7О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫ч╢К╪╨О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫х╜О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫О©╫О©╫ О©╫ш╬О©╫, О©╫О©╫ф╪О©╫б╫О©╫е╥, О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©? О©╫О©╫ х╜О©╫И©║О©╫О©╫ х©О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ х╟О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫ж╬О©╫О©?.<br>О©╫О©╫ О©╫О©╫О©╫О©╫/О©╫ц╥О©╫О©╫О©╫ О©╫О©╫ О©╫ы╬О©╫О©╫О©╫ х╜О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫Й╪╨О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫ж╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫л╬О©╫ О©╫О©╫О©╫О©╫О©? О©╫о╪О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫т╧О©╫О©╫з╨О©╫О©╫О©╫ О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.]'
WHERE product_code = '1000GX';

UPDATE tbl_product
SET product_desc = q'[iPhone 17 ProО©╫О©╫ О©╫О©╫О©╫О©╫ О©╫ш╬О©╫О©╫О©╫ О©╫т©О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫О©╫О©╫х╜О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫н╬О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫О©╫О©╫ цЁО©╫О©╫ О©╫с╣О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫ъ©О©╫/О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ц╟О©? О©╫О©╫К©║О©╫О©? О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫т©О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ г╔О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫з©О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫г╣О©╫О©╫О©╫ О©╫О©╫О©╫О©╫г╬О©╫О©╫О©╫О©╫о╢О©?.<br>О©╫О©╫О©╫О©╫О©╫л╬О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫ъ╟О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫о╦О©╫ О©╫О©╫О©╫О©╫О©╫н╣О©╫ О©╫о╪О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.]'
WHERE product_code = '1100AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Flip7О©╫О©╫ О©╫О©╫О©╫О©╫ф╝О©╫о╟О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫м╥О©╫ О©╫ч╢К╪╨О©╫О©╫ О©╫О©╫е╦О©╫О©╫О©╫О©╫ О©╫О©╫О©╫ц©О©╫ О©╫О©╫О©╫О©╫ О©╫ц╦О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>д©О©╫О©╫ х╜О©╫О©╫О©╫О©╫ х╟О©╫О©╫О©╫О©╫ О©╫к╦О©╫ х╝О©╫О©╫, О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ цЁО©╫О©╫О©╫О©╫ О©╫О©╫ О©╫ж╬О©╫О©?.<br>О©╫О©╫О©╫О©╫ О©╫т©О©╫О©╫лЁО©╫ О©╫О©╫О©╫л╨О©╫ О©╫О©╫ О©╫т©О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ ф╞О©╫О©╫О©╫О©╫ х╟О©╫К╣╣О©╫О©╫ О©╫ы╬НЁЁО©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫К╟╗О©╫О©? О©╫О©╫О©╫О©╫ О©╫ж╢О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫ц╣О©╫у╢о╢О©╫.]'
WHERE product_code = '1100GX';

UPDATE tbl_product
SET product_desc = q'[iPhone 17 Pro MaxО©╫О©╫ О©╫О©╫х╜О©╫О©╫О©? О©╫О©╫ О©╫О©╫О©? О©╫ц╟О©╫О©╫О©╫ О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫О©╫О©╫ О©╫ж╩О©╫О©╫О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫О©╫О©╫ х╜О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫/О©╫О©╫О©╫О©╫/О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫т╟О©╫ О©╫ж╟О©╫ О©╫О©╫О©? О©╫О©╫ О©╫ж╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©? О©╫т©О©╫ О©╫О©╫и╟О©? О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫ш©О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫О©╫О©╫м╦О©╫ х©О©╫О©╫О©╫О©╫ О©╫ъ╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? ф╞О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.]'
WHERE product_code = '1200AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy S25 UltraО©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫х╜О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©? О©╫О©╫ О©╫О©╫ф╝О©╫О©╫ О©╫ц╥О©╫О©╫в╫О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>д╚О©╫ч╤О©╫ х╟О©╫К╪╨О©╫О©╫ О©╫ы╬НЁ╙ гЁО©╫О©╫, О©╫н╧О©╫, О©╫ъ╟О©╫ О©╫т©О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫п╟О©╫ д©О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫лЁО©╫ О©╫О©╫ф╪О©╫б╫О©╫е╥О©╫О©╫О©╫О©╫О©╫О©╫ О©╫н╣Е╥╞О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©? О©╫О©╫ О©╫ж╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫/О©╫п╫О©╫/О©╫О©╫О©╫О©╫О©╫О©╫О©╫н╦О©╫ф╝О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫ь╟О©╫О©╫о╟О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.]'
WHERE product_code = '1200GX';

UPDATE tbl_product
SET product_desc = q'[О©╫О©╫ О©╫О©╫г╟О©╫О©╫ О©╫в╫О©╫ф╝/О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫с╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫г╟О©╫О©╫О©? О©╫О©╫О©╫О©╫, О©╫к╩О©╫ е╟О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫Н©╣ О©╫О©╫О©╫ь╟О©╫ О©╫ы╦О©╫ О©╫О©╫ О©╫ж╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫ф╝ х╜О©╫О©╫ О©╫О©╫О©? О©╫О©╫ DB О©╫О©╫О©╫О©╫/О©╫О©╫х╦ О©╫Е╦╖ О©╫О©╫О©╫к©О©╫ О©╫О©╫О©╫О©╫О©? О©╫О©╫ О©╫ж╬О©╫О©?.<br>О©╫Н©╣ О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫щ╣О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ф╝О©╫о╪О©╫О©╫О©╫.]'
WHERE product_code = '1234IN';

UPDATE tbl_product
SET product_desc = q'[TESTproduct2222О©╫О©╫ О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫в╫О©╫ф╝ О©╫О©╫г╟О©╫т╢о╢О©╫.<br>О©╫О©╫г╟ О©╫О©╫О©?/О©╫О©╫/О©╫О©╫ы╠О©╫О©╫О©?/О©╫О©╫О©╫О©╫ О©╫Е╦╖О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫м╟О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫г╢О©╫О©╫О©? х╝О©╫О©╫О©╫ь╨О©╫О©╫О©╫О©╫О©╫.<br>О©╫и╪О©╫ О©╫О©╫О©╫О©╫, О©╫О©╫О©? цЁО©╫О©╫, О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©? О©╫ц╧ы╦О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╠О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫г╪О©╫О©╫О©╫ О©╫щ©О©╫ О©╫ц©О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫г╟ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ц╪О©╫О©╫ О©╫й©О©╫О©╫у╢о╢О©╫.]'
WHERE product_code = '1234SD';

UPDATE tbl_product
SET product_desc = q'[testAppleProduct24О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫Х©╜ О©╫О©╫г╟ О©╫О©╫О©? О©╫О©╫О©? О©╫в╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫л╧О©╫О©╫О©╫ О©╫О©╫О©╫н╣О©╫, О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫, О©╫ы╧ы╡О©╫ цЁО©╫О©╫ х╝О©╫н©О©╫ О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫/О©╫О©╫О©╫О©╫/О©╫О©╫х╦ О©╫О©╫О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ х╟О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫ж╬О©╫О©?.<br>О©╫Н©╣ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫г╟ О©╫О©╫О©╫О©╫О©? О©╫г╦О©╫ О©╫О©╫ц╔О©╫О©╫ О©╫б╟О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ф╝О©╫о╪О©╫О©╫О©╫.]'
WHERE product_code = '1300AP';

UPDATE tbl_product
SET product_desc = q'[iPhone 16О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫и╟О©╫ О©╫О©╫К╪╨О©╫О©? О©╫О©╫О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫д╢ы╣О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫о╩О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫/О©╫О©╫О©╫О©╫ О©╫т©О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ цЁО©╫О©╫О©╫О©╫ О©╫О©╫ О©╫ж╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫ х╜О©╫О©╫О©? О©╫н╣Е╥╞О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ц╟О©? О©╫О©╫К©║О©╫О©? О©╫г╥н╟О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫О©? О©╫о╪О©╫О©╫О©╫О©╫О©╫ О©╫т╡О©╫ О©╫О©╫О©╫О©╫о╢О©? О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫ц╣О©╫у╢о╢О©╫.]'
WHERE product_code = '2000AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Fold6О©╫О©╫ О©╫О©╫х╜О©╫О©╫ О©╫О©╫О©╫О©╫О©? О©╫О©╫ф╪О©╫б╫О©╫е╥О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ф╝О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫ х╜О©╫И©║О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫ц©О©╫ О©╫О©╫О©? О©╫О©╫О©╫О©╫/О©╫п╫О©╫ х©О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫ж╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫лЁО©╫ О©╫О©╫О©╫О©╫ц╔ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫р╨Я©║╣О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫ч╢К╪╨О©╫О©╫ О©╫О©╫О©╫Й╪╨О©╫О©╫ О©╫О©╫О©? О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫ О©╫б╫О©╫О©╫о╢О©╫.]'
WHERE product_code = '2000GX';

UPDATE tbl_product
SET product_desc = q'[Galaxy A17О©╫О©╫ О©╫г╪О©╫ О©╫ж╢О©╫ О©╫О©╫О©╫и╟О©╫ О©╫у╦О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫щ╢К╦╕ О©╫О©╫г╔О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫о╩О©╫О©╫О©╫О©╫О©╫ SNS, О©╫О©╫О©╫О©╫О©╫О©╫, О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫Б╨╩ О©╫О©╫К©? О©╫О©╫О©╫О©╫О©? О©╫К╥╠О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫О©╫О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫н╟О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫К╟╗О©╫О©╫О©╫О©? О©╫н╢О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╠О©╫ О©╫О©╫О©╫ф©О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫лЁО©╫ О©╫н╦О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫н╣О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫.]'
WHERE product_code = '2045GX';

UPDATE tbl_product
SET product_desc = q'[testimageproduct10000О©╫О©╫ О©╫л╧О©╫О©╫О©╫ О©╫О©╫О©╫н╣О©╫/О©╫О©╫О©? х╝О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫в╫О©╫ф╝ О©╫О©╫г╟О©╫т╢о╢О©╫.<br>О©╫О©╫г╟ О©╫О©╫ х╜О©╫И©║О©╫О©╫ О©╫ы╧ы╡О©╫(<br>) О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ х╝О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫ж╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫О©? О©╫О©╫О©? О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫л╧О©╫О©╫О©╫ О©╫О©╫х╞ О©╫О©╫О©? О©╫О©╫О©╫к©О©╫О©╫О©╫ х╟О©╫О©╫О©╫о╪О©╫О©╫О©╫.<br>О©╫Н©╣ О©╫щ©О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫г╟ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ц╪О©╫О©╫ О©╫й©О©╫О©╫у╢о╢О©╫.]'
WHERE product_code = '2048AD';

UPDATE tbl_product
SET product_desc = q'[iPhone 16 ProО©╫О©╫ О©╫О©╫О©╫и╟О©╫ О©╫т©О©╫ г╟О©╫О©╫О©╫О©╫ О©╫ъ╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫О©╫О©╫х╜О©╫О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫О©╫О©╫ цЁО©╫О©╫ О©╫с╣О©╫О©╫О©╫ О©╫О©╫х╜О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫т©О©╫/О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫н╢О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫ г╔О©╫О©╫О©╫О©╫ О©╫ы╬НЁ╜ д╚О©╫ч╤О©╫О©? О©╫о╩О©╫ О©╫О©╫о╨О©╫О©╫О©? О©╫О©╫О©╫О©╫ О©╫т©О©╫О©╫О©╫О©╫О©╫ х╟О©╫К╣╣О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫л╬О©╫ О©╫О©╫О©╫О©╫О©╫н╟О©╫ О©╫о╪О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫ц╣О©╫у╢о╢О©╫.]'
WHERE product_code = '2100AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Flip6О©╫О©╫ О©╫О©╫О©╫О©╫ф╝О©╫О©╫ О©╫ч╢К╪╨О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ ф╞О©╫О©╫О©╫О©╫ х╟О©╫К╪╨О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>д©О©╫О©╫ х╜О©╫И©║О©╫О©╫ О©╫к╦О©╫ х╝О©╫н╟О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫г╪О©╫О©╫О©╫ О©╫ы╬НЁЁО©╫о╢О©╫.<br>О©╫О©╫д║ О©╫О©╫О©╫л╣О©╫ О©╫ы╬О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫т©О©╫О©╫О©╫ О©╫О©╫ О©╫ж╬О©╫ О©╫О©╫О©╫О©╫/О©╫О©╫О©╫л╥н╠в©О©╫ О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫О©╫е╦О©╫о╟О©╫ О©╫г©К╪╨О©╫О©╫ О©╫О©╫О©╫ц©О©╫ О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫ О©╫б╫О©╫О©╫о╢О©╫.]'
WHERE product_code = '2100GX';

UPDATE tbl_product
SET product_desc = q'[iPhone 16 Pro MaxО©╫О©╫ О©╫О©╫х╜О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫ц©О©╫ О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©? О©╫О©╫О©╫с©О©╫О©╫О©╫ О©╫О©╫О©╫т╟О©╫О©╫О©╫ О©╫О©╫О©╫О©╫, О©╫О©╫О©╫м╦О©╫ О©╫О©╫О©? О©╫ц╟О©╫О©╫О©╫ О©╫кЁО©╫О©╫О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫О©╫н╠О©╫ О©╫т©О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©? О©╫О©╫О©╫О©╫/О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫ш©О©╫О©╫О©╫ х╟О©╫О©╫О©╫о╠О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫о╥О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ф╝О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫о╢О©? О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫ц╣О©╫у╢о╢О©╫.]'
WHERE product_code = '2200AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy S24 UltraО©╫О©╫ О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫н╬О©╫О©╫ы©О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫и╟О©╫ д╚О©╫ч╤О©╫ х╟О©╫К╪╨О©╫О©╫ О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫х╜О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©? О©╫ш╬О©╫ х©О©╫О©╫О©╫О©╫ О©╫О©╫О©╫ц©О©╫ О©╫О©╫О©╫О©╫О©╫О©╫еЁ О©╫О©╫ О©╫ж╬О©╫О©?.<br>О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫лЁО©╫ О©╫О©╫ф╪О©╫б╫О©╫е╥О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫у╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©? О©╫О©╫ О©╫ж╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫л╬О©╫ О©╫ц╥О©╫О©╫в╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.]'
WHERE product_code = '2200GX';

UPDATE tbl_product
SET product_desc = q'[TestImageProduct44О©╫О©╫ О©╫л╧О©╫О©╫О©╫ О©╫О©╫б╟О©? О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ UI О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫в╫О©╫ф╝ О©╫О©╫г╟О©╫т╢о╢О©╫.<br>О©╫О©╫г╟ О©╫О©╫О©╫О©╫ О©╫ы╧ы╡О©╫ цЁО©╫О©╫, О©╫О©╫О©╫л╬ф©О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ х╝О©╫О©╫О©╫о╠О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫и╪О©╫/О©╫О©╫О©╫О©╫/О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫т╡О©╫ О©╫в╫О©╫ф╝О©╫о╦О©╫ О©╫О©╫ц╪ О©╫Е╦╖ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫к╢о╢О©╫.<br>О©╫г╩О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ф╝О©╫о╪О©╫О©╫О©╫.]'
WHERE product_code = '2314AS';

UPDATE tbl_product
SET product_desc = q'[appleTestphone11О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫Х©╜ О©╫О©╫г╟ О©╫О©╫О©?/О©╫О©╫О©╫О©╫ О©╫О©╫О©? О©╫в╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ CRUD О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫н╣О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©? О©╫О©╫ О©╫ж╫О©╫О©╫о╢О©╫.<br>ф╞О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫ы╧ы╡О©╫(<br>) цЁО©╫О©╫О©╫О©╫ х╜О©╫О©╫ О©╫О©╫О©? х╝О©╫н©О©╫ О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫Н©╣ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫г╟ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ц╪О©╫о╪О©╫О©╫О©╫.]'
WHERE product_code = '2345AE';

UPDATE tbl_product
SET product_desc = q'[testimageproduct1623О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫ы╧ы╡О©╫ О©╫О©╫ О©╫л╧О©╫О©╫О©╫ г╔О©╫ц╦О©╫ О©╫в╫О©╫ф╝О©╫о╠О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫т╢о╢О©╫.<br>О©╫О©╫г╟ О©╫О©╫ х╜О©╫И©║О©╫О©╫ <br> О©╫б╠в╟О©╫ О©╫О©╫О©╫О©╫ О©╫ы╧ы╡О©╫О©╫О©╫О©╫О©╫ О©╫щ©О©╫О©╫г╢О©╫О©╫О©╫ х╝О©╫О©╫О©╫ь╨О©╫О©╫О©╫О©╫О©╫.<br>О©╫О©╫О©╫О©╫О©? е╛О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫л╧О©╫О©╫О©╫ О©╫О©╫О©╫О©╫, х╝О©╫О©╫/О©╫О©╫О©╫О©╫О©╫О©╫ цЁО©╫О©╫О©╫О©╫ О©╫т╡О©╫ О©╫О©╫О©╫О©╫О©╫о╦О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫в╫О©╫ф╝ О©╫о╥О©╫ О©╫д©О©╫О©╫О©╫ О©╫Н©╣О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ф╝О©╫о╪О©╫О©╫О©╫.]'
WHERE product_code = '2352SQ';

UPDATE tbl_product
SET product_desc = q'[iPhone 15О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫и╟О©╫ О©╫О©╫К╪╨О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ч╢О©? О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫о╩О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫т©О©╫, О©╫О©╫ф╝О©╫О©╫О©╫ж╠О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫ш╟О©╫О©╫О©╫ О©╫О©╫О©╫О©╫х╜О©╫О©╫ О©╫ц╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ц╟О©? О©╫О©╫К©║О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫у╦О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫ц╣О©╫у╢о╢О©╫.]'
WHERE product_code = '3000AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Fold5О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫х╜О©╫О©╫О©╫О©╫ х╟О©╫О©╫О©╫О©╫ О©╫О©╫О©╫Й╪╨О©╫О©╫ О©╫О©╫ф╪О©╫б╫О©╫е╥О©╫О©╫ О©╫О©╫х╜О©╫О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫О©╫О©╫, О©╫ч╫О©╫О©╫О©╫, О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫ц©О©╫ О©╫О©╫О©? х©О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫ш╬О©╫О©╫О©╫ О©╫О©╫ О©╫ж╬О©╫О©?.<br>О©╫О©╫х╜О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╦О©╫ О©╫л╣О©╫ О©╫ъ©О©╫О©╫О©╫ О©╫б╨О©╫цЁО©╫О©╫ х╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫н╦О©╫ф╝О©╫О©╫ О©╫т╡О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫ц╣О©╫у╢о╢О©╫.]'
WHERE product_code = '3000GX';

UPDATE tbl_product
SET product_desc = q'[TestSamsungPhone4432О©╫О©╫ О©╫О╪╨ О©╫ч╢О©╫О©╫О©╫ О©╫О©╫г╟ О©╫Е╦╖ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫в╫О©╫ф╝ О©╫О©╫г╟О©╫т╢о╢О©╫.<br>О©╫О©╫г╟ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫/О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫з©О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫б╣г╢О©╫О©╫О©? х╝О©╫О©╫О©╫о╪О©╫О©╫О©╫.<br>О©╫О©╫О©╫О©╫ г╔О©╫О©╫(ц╣ О©╫О©╫О©╫О©╫ О©╫ч╦О©╫)О©╫О©╫ О©╫и╪О©╫/О©╫О©╫О©? цЁО©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╦О©╫ О©╫о╪О©╫О©╫О©╫О©╫О©╫ О©╫ц╤С╟╘╢о╢О©╫.<br>О©╫Н©╣ О©╫щ©О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫г╩О©╫г╟ О©╫О©╫О©╫О©╫О©? О©╫О©╫ц╔О©╫О©╫ О©╫б╢О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ц╪О©╫о╪О©╫О©╫О©╫.]'
WHERE product_code = '3091AP';

UPDATE tbl_product
SET product_desc = q'[iPhone 15 ProО©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫О©╫О©╫ цЁО©╫О©╫ О©╫с╣О©╫О©╫О©╫ О©╫О©╫О©╫О©╫/О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫, О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫О©╫К©║О©╫О©? О©╫н╢О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>д╚О©╫ч╤О©╫ х╟О©╫К╪╨О©╫О©╫ О©╫ы╬НЁ╙ О©╫о╩О©╫ О©╫О©╫о╨О©╫О©╫О©? О©╫О©╫О©╫О©╫ О©╫т©О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫л╬О©╫ О©╫О©╫О©╫О©╫ О©╫э╛О©╫ч╛О©╫я╛э╛О©╫О©╫о╟О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫ц╣О©╫у╢о╢О©╫.]'
WHERE product_code = '3100AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Flip5О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫л©О©? О©╫ч╢К╪╨О©╫О©╫ О©╫О©╫О©? О©╫О©╫О©╫О©╫ О©╫ц╦О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>д©О©╫О©╫ х╜О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫к╦О©╫О©╫О©╫ х╝О©╫О©╫О©╫о╟О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ О©╫ж╫О©╫О©╫о╢О©╫.<br>О©╫ы╬О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫т©О©╫О©╫О©╫ О©╫О©╫ О©╫ж╬О©╫ О©╫О©╫О©╫О©╫/О©╫О©╫О©╫О©╫ О©╫т©О©╫ х╟О©╫К╣╣О©╫О©╫ О©╫О©╫О©╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫ О©╫ж╢О©╫ О©╫О©╫О©╫О©╫О©╫н╟О©╫ О©╫г©К╪╨О©╫О©╫ О©╫т╡О©╫ О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫ О©╫б╫О©╫О©╫о╢О©╫.]'
WHERE product_code = '3100GX';

UPDATE tbl_product
SET product_desc = q'[iPhone 15 Pro MaxО©╫О©╫ О©╫О©╫х╜О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫, О©╫О©╫О©╫О©╫, О©╫ш╬О©╫ О©╫О©╫ О©╫ы╬О©╫О©╫О©╫ х╟О©╫К©║О©╫О©╫ О©╫О©╫О©╫т╟О©╫О©╫О©╫ О©╫ы╬НЁЁО©╫о╢О©╫.<br>О©╫О©╫О©? О©╫т©О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©? О©╫О©╫О©╫О©╫/О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫ш©О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫О©╫О©╫м╦О©╫ О©╫О©╫О©? О©╫ц╟О©╫О©╫О©╫ О©╫ъ©О©╫О©╫о╟О©╫, е╚ х╜О©╫О©╫ О©╫О©╫хёО©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫ц╣О©╫у╢о╢О©╫.]'
WHERE product_code = '3200AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy S23 UltraО©╫О©╫ О©╫О©╫О©╫О©╫О©╫л╬О©╫ О©╫О©╫О©╫и╟О©╫ д╚О©╫ч╤О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©? О©╫О©╫О©╫О©╫ О©╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫н╬О©╫ О©╫О©╫О©╫т╢о╢О©╫.<br>О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫ц╥О©╫О©╫л╥О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©? О©╫ш╬О©╫ х©О©╫О©╫О©╫О©╫ О©╫О©╫О©╫ц©О©╫ О©╫О©╫О©╫О©╫ц╦О©? О©╫О©╫ О©╫ж╫О©╫О©╫о╢О©╫.<br>О©╫О©╫О©╫О©╫ О©╫ш╬О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫у╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫О©╫т╣О©╫ О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫ц╥О©╫О©╫в╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫О©╫о╢О©╫ О©╫О©╫О©╫О©╫з©О©╫О©╫О©? О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ц╣О©╫г╢О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫т╢о╢О©╫.]'
WHERE product_code = '3200GX';

UPDATE tbl_product
SET product_desc = q'[TestImageProduct55О©╫О©╫ О©╫л╧О©╫О©╫О©╫/О©╫О©╫О©╫О©╫ О©╫О©╫О©? О©╫в╫О©╫ф╝О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫г╟О©╫т╢о╢О©╫.<br>О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ <br> О©╫ы╧ы╡О©╫О©╫О©╫ О©╫О©╫О©╫О©╫ О©╫щ©О©╫О©╫г╢О©╫О©╫О©╫О©╫О©╫ UI О©╫О©╫О©╫О©╫ О©╫О©╫О©╫б╦О©╫ х╝О©╫О©╫О©╫о╪О©╫О©╫О©╫.<br>О©╫л╧О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫О©╫, О©╫О©╫О©╫О©╫О©? О©╫О©╫О©╫О©╫, х╝О©╫О©╫ О©╫О©╫О©? О©╫О©╫ О©╫О©╫О©╫О©╫ф╝ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫к©О©╫О©╫О©╫ х╟О©╫О©╫ О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.<br>О©╫в╫О©╫ф╝ О©╫о╥О©╫ О©╫д©О©╫О©╫О©╫ О©╫Н©╣О©╫О©╫ О©╫О©╫г╟ О©╫О©╫О©╫О©╫О©╫О©╫О©╫О©╫ О©╫О©╫ц╪О©╫о╢О©╫ О©╫О©╫О©╫О©╫ О©╫О©╫О©╫О©╫О©╫у╢о╢О©╫.]'
WHERE product_code = '4039AD';
commit;


select * from tbl_product;
=======
-------- ?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫?О©╫О©╫ --------

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

-- status Л╩╛К÷╪ ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫?О©╫О©╫
ALTER TABLE TBL_MEMBER
  MODIFY (STATUS DEFAULT 0);
  
-- idle Л╩╛К÷╪ ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫?О©╫О©╫
ALTER TABLE TBL_MEMBER
  MODIFY (IDLE DEFAULT 0);
  

create table tbl_member_backup
as
select * from tbl_member;

-- ?О©╫О©╫???О©╫О©╫ ?О©╫О©╫?О©╫О©╫
CREATE SEQUENCE SEQ_TBL_MEMBER_USERSEQ
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- userseq Л╩╛К÷╪ Л╤■О©╫?
alter table tbl_member
add userseq number;

update tbl_member set userseq = SEQ_TBL_MEMBER_USERSEQ.nextval
where MEMBER_ID = 'eomjh';

update tbl_member set userseq = SEQ_TBL_MEMBER_USERSEQ.nextval
where MEMBER_ID = 'smon0376';

-- userseq Л╩╛К÷╪ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫
alter table tbl_member
add constraint UQ_TBL_MEMBER_USERSEQ unique(userseq);

-- userseq Л╩╛К÷╪ not null ?О©╫О©╫?О©╫О©╫
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

-- IMAGE_PATH Л╩╛К÷╪ Л╤■О©╫?
ALTER TABLE TBL_PRODUCT
ADD (IMAGE_PATH VARCHAR2(200));

-- IMAGE_PATH Л╩╛К÷╪ NOT NULL ?О©╫О©╫?О©╫О©╫
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

-------- ?О©╫О©╫???О©╫О©╫ ?О©╫О©╫?О©╫О©╫ --------

CREATE SEQUENCE SEQ_TBL_COUPON_COUPON_CATEGORY_NO
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Л╩╛К÷╪ ?О©╫О©╫?О©╫О©╫ О©??О©??
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

-- IMAGE_PATH Л╩╛К÷╪ ?О©╫О©╫?О©╫О©╫
ALTER TABLE TBL_PRODUCT_OPTION
DROP COLUMN IMAGE_PATH;

-------- ?О©╫О©╫???О©╫О©╫ ?О©╫О©╫?О©╫О©╫ --------

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

-------- ?О©╫О©╫???О©╫О©╫ ?О©╫О©╫?О©╫О©╫ --------

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

-------- ?О©╫О©╫???О©╫О©╫ ?О©╫О©╫?О©╫О©╫ --------

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

-------- ?О©╫О©╫???О©╫О©╫ ?О©╫О©╫?О©╫О©╫ --------

CREATE SEQUENCE SEQ_TBL_ORDERS_ORDER_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE SEQ_TBL_ORDERS_DELIVERY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- Л╩╛К÷╪ Л╤■О©╫?
ALTER TABLE TBL_ORDERS
ADD (
  DELIVERY_NUMBER     VARCHAR2(20),
  DELIVERY_STARTDATE  DATE,
  DELIVERY_ENDDATE    DATE
);


-- Л╡╢М│╛?О©╫О©╫?О©╫О©╫ Л╤■О©╫?
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

-------- ?О©╫О©╫???О©╫О©╫ ?О©╫О©╫?О©╫О©╫ --------

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

-------- ?О©╫О©╫???О©╫О©╫ ?О©╫О©╫?О©╫О©╫ --------

CREATE SEQUENCE SEQ_TBL_REVIEW_REVIEW_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- RATING, DELETED_YN, DELETED_AT, DELETED_BT Л╩╛К÷╪ Л╤■О©╫?
ALTER TABLE TBL_REVIEW ADD (
  RATING      NUMBER(2,1)             NOT NULL,
  DELETED_YN  NUMBER(1)     DEFAULT 0 NOT NULL,
  DELETED_AT  DATE          NULL,
  DELETED_BY  VARCHAR2(40)  NULL
);

-- RATING, DELETED_YN Л╩╛К÷╪?О©╫О©╫ Л╡╢М│╛?О©╫О©╫?О©╫О©╫ Л╤■О©╫?
ALTER TABLE TBL_REVIEW
ADD CONSTRAINT CK_TBL_REVIEW_RATING
CHECK (
  RATING BETWEEN 0.5 AND 5.0
  AND (RATING*2 = TRUNC(RATING*2))
);

ALTER TABLE TBL_REVIEW
ADD CONSTRAINT CK_TBL_REVIEW_DELETED_YN
CHECK (DELETED_YN IN (0,1));


-- review_title Л╩╛К÷╪ Л╤■О©╫?
ALTER TABLE TBL_REVIEW
ADD (review_title VARCHAR2(100));

-- review_title Л╩╛К÷╪ NOT NULL ?О©╫О©╫?О©╫О©╫
ALTER TABLE TBL_REVIEW
MODIFY (review_title VARCHAR2(100) NOT NULL);

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫ Л╤■О©╫??О©╫О©╫

CREATE UNIQUE INDEX UQ_TBL_REVIEW_FK_ORDER_DETAIL_ID
ON TBL_REVIEW ( CASE WHEN deleted_yn = 0 THEN fk_order_detail_id END );

-- Л╩╛К÷╪ ???О©╫О©╫ О©??О©??
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

-------- ?О©╫О©╫???О©╫О©╫ ?О©╫О©╫?О©╫О©╫ --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- Л╡╢М│╛?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫
ALTER TABLE TBL_INQUIRY
DROP CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS;

-- Л╡╢М│╛?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫
ALTER TABLE TBL_INQUIRY
ADD CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS
CHECK (REPLY_STATUS IN (0,1,2));

-- REPLY_STATUS ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? 1О©?? О©??О©??
ALTER TABLE TBL_INQUIRY
MODIFY (REPLY_STATUS DEFAULT 1);


-- deleted_yn, deleted_at, deleted_by, is_secret Л╩╛К÷╪ Л╤■О©╫?
ALTER TABLE tbl_inquiry ADD (
  deleted_yn NUMBER(1) DEFAULT 0 NOT NULL,
  deleted_at DATE,
  deleted_by VARCHAR2(40),
  is_secret  NUMBER(1) DEFAULT 0 NOT NULL
);

-- deleted_yn, is_secret Л╩╛К÷╪ Л╡╢М│╛?О©╫О©╫?О©╫О©╫ Л╤■О©╫?
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


------ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select *
from tbl_product
order by product_name;

------ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫17 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫17?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫17 Pro?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫17 Pro Max?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫16 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫16?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫16 Pro?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫16 Pro Max?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
commit;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫15 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫15?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫15 Pro?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫15 Pro Max?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Й╟╓К÷╜?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ Z?О©╫О©╫?О©╫О©╫7?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ Z?О©╫О©╫О©??7?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ s25 ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
commit;

---------------- Й╟╓К÷╜?О©╫О©╫6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ Z?О©╫О©╫?О©╫О©╫6?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ Z?О©╫О©╫О©??6?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ s24 ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
commit;

---------------- Й╟╓К÷╜?О©╫О©╫5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ Z?О©╫О©╫?О©╫О©╫5?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ Z?О©╫О©╫О©??5?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ s23 ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫----------------------------------------------------
--?О©╫О©╫?О©╫О©╫?О©╫О©╫17 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
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

--?О©╫О©╫?О©╫О©╫?О©╫О©╫17 Pro ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫
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

--?О©╫О©╫?О©╫О©╫?О©╫О©╫17 Pro Max ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫
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



--?О©╫О©╫?О©╫О©╫?О©╫О©╫16 ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫
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

--?О©╫О©╫?О©╫О©╫?О©╫О©╫16 Pro ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫16 Pro Max ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--?О©╫О©╫?О©╫О©╫?О©╫О©╫15 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--?О©╫О©╫?О©╫О©╫?О©╫О©╫15 Pro ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--?О©╫О©╫?О©╫О©╫?О©╫О©╫ 15 Pro Max ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫КЁ╢О©╫? ?О©╫О©╫?О©╫О©╫О©?? Л║╟Л²╦?О©╫О©╫?О©╫О©╫ Й╟≥Л²╢ Л╤°К═╔?О©╫О©╫О©??
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select * from tbl_product;
commit;

---------------------------------------Й╟╓К÷╜?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫----------------------------------------------------
-- Galaxy Z Fold7 ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫
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


-- Galaxy Z Flip7 ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫
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


-- Galaxy S25 Ultra ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫
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

-- Й╟╓К÷╜?О©╫О©╫ z?О©╫О©╫?О©╫О©╫6 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- Й╟╓К÷╜?О©╫О©╫ z?О©╫О©╫О©??6 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- Й╟╓К÷╜?О©╫О©╫ s24 ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- Й╟╓К÷╜?О©╫О©╫ ?О©╫О©╫?О©╫О©╫5 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- Й╟╓К÷╜?О©╫О©╫ ?О©╫О©╫О©??5 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- Й╟╓К÷╜?О©╫О©╫ s23 ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫КЁ╢О©╫? ?О©╫О©╫?О©╫О©╫О©?? Л║╟Л²╦?О©╫О©╫?О©╫О©╫ Й╟≥Л²╢ Л╤°К═╔?О©╫О©╫О©??
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select * from tbl_product;
commit;


--?О©╫О©╫?О©╫О©╫?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫КЁ╢О©╫? О©??Й╡╘Л²╢ ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?? ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫КЁ╢О©╫?? Л║╟Л²╦?О©╫О©╫?О©╫О©╫ Л╤°К═╔
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '?О©╫О©╫К╖╓Л╓▒'
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


------ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select *
from tbl_product
order by product_name;

------ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫17 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫17?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫17 Pro?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫17 Pro Max?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫16 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫16?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫16 Pro?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫16 Pro Max?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
commit;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫15 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫15?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫15 Pro?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '?О©╫О©╫?О©╫О©╫?О©╫О©╫15 Pro Max?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- Й╟╓К÷╜?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ Z?О©╫О©╫?О©╫О©╫7?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ Z?О©╫О©╫О©??7?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ s25 ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
commit;

---------------- Й╟╓К÷╜?О©╫О©╫6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ Z?О©╫О©╫?О©╫О©╫6?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ Z?О©╫О©╫О©??6?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ s24 ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
commit;

---------------- Й╟╓К÷╜?О©╫О©╫5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ Z?О©╫О©╫?О©╫О©╫5?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ Z?О©╫О©╫О©??5?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', 'Й╟╓К÷╜?О©╫О©╫ s23 ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫К╙┘Л·┘?О©╫О©╫?О©╫О©╫. ?О©╫О©╫Л╓▒Л≈░ updateО©?? К╟■Й╬╦?О©╫О©╫?О©╫О©╫.', '?О©╫О©╫К╖╓Л╓▒', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫----------------------------------------------------
--?О©╫О©╫?О©╫О©╫?О©╫О©╫17 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
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

--?О©╫О©╫?О©╫О©╫?О©╫О©╫17 Pro ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫
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

--?О©╫О©╫?О©╫О©╫?О©╫О©╫17 Pro Max ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫
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



--?О©╫О©╫?О©╫О©╫?О©╫О©╫16 ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫
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

--?О©╫О©╫?О©╫О©╫?О©╫О©╫16 Pro ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫16 Pro Max ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--?О©╫О©╫?О©╫О©╫?О©╫О©╫15 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--?О©╫О©╫?О©╫О©╫?О©╫О©╫15 Pro ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--?О©╫О©╫?О©╫О©╫?О©╫О©╫ 15 Pro Max ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫КЁ╢О©╫? ?О©╫О©╫?О©╫О©╫О©?? Л║╟Л²╦?О©╫О©╫?О©╫О©╫ Й╟≥Л²╢ Л╤°К═╔?О©╫О©╫О©??
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select * from tbl_product;
commit;

---------------------------------------Й╟╓К÷╜?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫----------------------------------------------------
-- Galaxy Z Fold7 ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫
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


-- Galaxy Z Flip7 ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫
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


-- Galaxy S25 Ultra ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫
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

-- Й╟╓К÷╜?О©╫О©╫ z?О©╫О©╫?О©╫О©╫6 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- Й╟╓К÷╜?О©╫О©╫ z?О©╫О©╫О©??6 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- Й╟╓К÷╜?О©╫О©╫ s24 ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- Й╟╓К÷╜?О©╫О©╫ ?О©╫О©╫?О©╫О©╫5 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- Й╟╓К÷╜?О©╫О©╫ ?О©╫О©╫О©??5 ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- Й╟╓К÷╜?О©╫О©╫ s23 ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫КЁ╢О©╫? ?О©╫О©╫?О©╫О©╫О©?? Л║╟Л²╦?О©╫О©╫?О©╫О©╫ Й╟≥Л²╢ Л╤°К═╔?О©╫О©╫О©??
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select * from tbl_product;
commit;


--?О©╫О©╫?О©╫О©╫?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫КЁ╢О©╫? О©??Й╡╘Л²╢ ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?? ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫КЁ╢О©╫?? Л║╟Л²╦?О©╫О©╫?О©╫О©╫ Л╤°К═╔
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '?О©╫О©╫К╖╓Л╓▒'
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



-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л²≤ ?О©╫О©╫?О©╫О©╫Л║╟Й╠╢?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT_OPTION';

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л²≤ О©??О©?? Л╡╢М│╛Л║╟Й╠╢ ?О©╫О©╫?О©╫О©╫
ALTER TABLE tbl_product_option DROP CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л²≤ pric Л╩╛К÷╪ ?О©╫О©╫?О©╫О©╫
ALTER TABLE tbl_product_option
DROP COLUMN price;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л≈░ plus_price Л╩╛К÷╪ Л╤■О©╫?(?О©╫О©╫?О©╫О©╫Л║╟Й╠╢ 0О©?? Й╟≥Й╠╟?О©╫О©╫ ?О©╫О©╫)
ALTER TABLE tbl_product_option
ADD plus_price NUMBER DEFAULT 0
    CONSTRAINT ck_tbl_product_option_plus_price CHECK (plus_price >= 0);
    
select * from tbl_product_option;


-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л²≤ ?О©╫О©╫?О©╫О©╫Л║╟Й╠╢?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT';

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л≈░ price Л╩╛К÷╪ Л╤■О©╫?(?О©╫О©╫?О©╫О©╫Л║╟Й╠╢ 0КЁ╢К▀╓ Л╩╓Л∙╪ ?О©╫О©╫)
ALTER TABLE tbl_product
ADD price NUMBER
    CONSTRAINT ck_tbl_product_price CHECK (price > 0);

select product_code, product_name, price
from tbl_product
where brand_name = 'Samsung'
order by product_code;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л²≤ О©??Й╡╘Л╩╛?О©╫О©╫?О©╫О©╫ О©?? ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
update tbl_product set price = 2200000
where product_code = '3000GX';

commit;



-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫КЁ╢О©╫? ?О©╫О©╫?О©╫О©╫О©?? Л║╟Л²╦?О©╫О©╫?О©╫О©╫ Й╟≥Л²╢ Л╤°К═╔?О©╫О©╫О©??
SELECT P.product_code, option_id, P.product_name,storage_size, price, plus_price
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Samsung' and storage_size = '512GB'
ORDER BY product_code, storage_size desc;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л²≤ Л╤■О©╫?Й╦┬Л∙║ Л╩╛К÷╪?О©╫О©╫ О©?? ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
update tbl_product_option set plus_price = 150000
where fk_product_code = '2100GX' and storage_size = '512GB';

commit;


--(?О©╫О©╫?О©╫О©╫Л╫■К⌠°,?О©╫О©╫?О©╫О©╫О©??,К╦▄К·°?О©╫О©╫О©??,?О©╫О©╫К╞╦О©╫?Й╡╫К║°,О©??О©??)
select product_code, product_name, brand_name, image_path, price, sale_status
from tbl_product
where sale_status='?О©╫О©╫К╖╓Л╓▒';


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


-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫...
-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫...

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

-------- ?О©╫О©╫???О©╫О©╫ ?О©╫О©╫?О©╫О©╫ --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- Л╡╢М│╛?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫
ALTER TABLE TBL_INQUIRY
DROP CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS;

-- Л╡╢М│╛?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫
ALTER TABLE TBL_INQUIRY
ADD CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS
CHECK (REPLY_STATUS IN (0,1,2));

-- REPLY_STATUS ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? 1О©?? О©??О©??
ALTER TABLE TBL_INQUIRY
MODIFY (REPLY_STATUS DEFAULT 1);


-- deleted_yn, deleted_at, deleted_by, is_secret Л╩╛К÷╪ Л╤■О©╫?
ALTER TABLE tbl_inquiry ADD (
  deleted_yn NUMBER(1) DEFAULT 0 NOT NULL,
  deleted_at DATE,
  deleted_by VARCHAR2(40),
  is_secret  NUMBER(1) DEFAULT 0 NOT NULL
);

-- deleted_yn, is_secret Л╩╛К÷╪ Л╡╢М│╛?О©╫О©╫?О©╫О©╫ Л╤■О©╫?
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_deleted_yn CHECK (deleted_yn IN (0,1));
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_is_secret  CHECK (is_secret  IN (0,1));


-- Л╩╛К÷╪ ???О©╫О©╫ О©??О©??
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


-------- ?О©╫О©╫???О©╫О©╫ ?О©╫О©╫?О©╫О©╫ --------

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


------ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select *
from tbl_product
order by product_name;

------ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';



-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫КЁ╢О©╫? ?О©╫О©╫?О©╫О©╫О©?? Л║╟Л²╦?О©╫О©╫?О©╫О©╫ Й╟≥Л²╢ Л╤°К═╔?О©╫О©╫О©??
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select * from tbl_product;
commit;


--?О©╫О©╫?О©╫О©╫?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫КЁ╢О©╫? О©??Й╡╘Л²╢ ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?? ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫КЁ╢О©╫?? Л║╟Л²╦?О©╫О©╫?О©╫О©╫ Л╤°К═╔
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '?О©╫О©╫К╖╓Л╓▒'
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


------ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select *
from tbl_product
order by product_name;

------ ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';




select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫КЁ╢О©╫? ?О©╫О©╫?О©╫О©╫О©?? Л║╟Л²╦?О©╫О©╫?О©╫О©╫ Й╟≥Л²╢ Л╤°К═╔?О©╫О©╫О©??
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫О©?? Л╤°К═╔?О©╫О©╫О©??
select * from tbl_product;
commit;


--?О©╫О©╫?О©╫О©╫?О©╫О©╫ ???О©╫О©╫ ?О©╫О©╫КЁ╢О©╫? О©??Й╡╘Л²╢ ?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?? ?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫КЁ╢О©╫?? Л║╟Л²╦?О©╫О©╫?О©╫О©╫ Л╤°К═╔
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '?О©╫О©╫К╖╓Л╓▒'
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



-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л²≤ ?О©╫О©╫?О©╫О©╫Л║╟Й╠╢?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT_OPTION';

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л²≤ О©??О©?? Л╡╢М│╛Л║╟Й╠╢ ?О©╫О©╫?О©╫О©╫
ALTER TABLE tbl_product_option DROP CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л²≤ pric Л╩╛К÷╪ ?О©╫О©╫?О©╫О©╫
ALTER TABLE tbl_product_option
DROP COLUMN price;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л≈░ plus_price Л╩╛К÷╪ Л╤■О©╫?(?О©╫О©╫?О©╫О©╫Л║╟Й╠╢ 0О©?? Й╟≥Й╠╟?О©╫О©╫ ?О©╫О©╫)
ALTER TABLE tbl_product_option
ADD plus_price NUMBER DEFAULT 0
    CONSTRAINT ck_tbl_product_option_plus_price CHECK (plus_price >= 0);
    
select * from tbl_product_option;


-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л²≤ ?О©╫О©╫?О©╫О©╫Л║╟Й╠╢?О©╫О©╫ ?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT';

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л≈░ price Л╩╛К÷╪ Л╤■О©╫?(?О©╫О©╫?О©╫О©╫Л║╟Й╠╢ 0КЁ╢К▀╓ Л╩╓Л∙╪ ?О©╫О©╫)
ALTER TABLE tbl_product
ADD price NUMBER
    CONSTRAINT ck_tbl_product_price CHECK (price > 0);

select product_code, product_name, price
from tbl_product
where brand_name = 'Samsung'
order by product_code;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л²≤ О©??Й╡╘Л╩╛?О©╫О©╫?О©╫О©╫ О©?? ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
update tbl_product set price = 2200000
where product_code = '3000GX';

commit;



-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫ ?О©╫О©╫КЁ╢О©╫? ?О©╫О©╫?О©╫О©╫О©?? Л║╟Л²╦?О©╫О©╫?О©╫О©╫ Й╟≥Л²╢ Л╤°К═╔?О©╫О©╫О©??
SELECT P.product_code, option_id, P.product_name,storage_size, price, plus_price
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Samsung' and storage_size = '512GB'
ORDER BY product_code, storage_size desc;

-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫К╦■Л²≤ Л╤■О©╫?Й╦┬Л∙║ Л╩╛К÷╪?О©╫О©╫ О©?? ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫О©??
update tbl_product_option set plus_price = 150000
where fk_product_code = '2100GX' and storage_size = '512GB';

commit;


--(?О©╫О©╫?О©╫О©╫Л╫■К⌠°,?О©╫О©╫?О©╫О©╫О©??,К╦▄К·°?О©╫О©╫О©??,?О©╫О©╫К╞╦О©╫?Й╡╫К║°,О©??О©??)
select product_code, product_name, brand_name, image_path, price, sale_status
from tbl_product
where sale_status='?О©╫О©╫К╖╓Л╓▒';


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


-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫...
-- ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫...

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

insert into tbl_orders(1002, dog, sysdate, 4950000, 50000, 'PAID', '?О©╫О©╫?О©╫О©╫ ?О©╫О©╫?О©╫О©╫О©?? К╡∙Л⌡░О©?? 128 101?О©╫О©╫', ?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫?О©╫О©╫, 010-0000-0000, 0);
insert into tbl_order_detail(1003, 149, 1002, 1, 2400000, 0, 'Galaxy Z Fold7', 'Samsung');
insert into tbl_order_detail(1004, 196, 1002, 1, 1700000, 0, 'iPhone15 Pro', 'Apple');

insert into tbl_review(1,196,1000,'К╡┬Л╟╫?О©╫О©╫?О©╫О©╫?О©╫О©╫',sysdate,5,0,null,null,'?О©╫О©╫?О©╫О©╫О©?? ?О©╫О©╫?О©╫О©╫?О©╫О©╫');

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







------------------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@-----------------------------------------------------------------------
------------------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@-----------------------------------------------------------------------
------------------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@-----------------------------------------------------------------------
------------------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@-----------------------------------------------------------------------
/* =========================
   tbl_product ?█╟?²╢?└╟ INSERT
   ========================= */
select * from tbl_product;
select * from tbl_product_option;

INSERT INTO tbl_product
(product_code, product_name, brand_name, product_desc, sale_status, image_path, price)
VALUES
('1000AP', 'iPhone17', 'Apple',
 q'[iPhone 17?? ?²╪?┐│К╤??└╟ ?≈┘К╛╢Й╧▄Л╖? ?∙┬?═∙?═│?°╪К║? ?┌╛? ╘?∙═ ?┬≤ ?·┬?┼■ ?┼╓К╖┬М┼╦?▐╟?·┘?▀┬?▀╓.<br>
?└═К╙┘М∙° ?■■?┼╓?■▄?═┬?²╢?? К╧═К╔╦ К╟≤Л²▒?└╠?°╪К║? ?∙╠ ?▀╓?√┴?²╢ К╤??⌠°?÷╫?┼╣?▀┬?▀╓.<br>
?┌╛Л╖└ЙЁ╪ ?≤│?┐│ Л╢╛Л≤│?≈░?└°?▐└ ?·░?≈╟?┼╓?÷╛? ╢ ?┐┴Й╟░Л²└ ?═°ЙЁ╣М∙╘?▀┬?▀╓.<br>
?█╟?²╪К╕? ?┼╓К╖┬М┼╦?▐╟?°╪К║? ?≥°? ╘?∙≤Й╦╟Л≈░ Л╤╘К╤└?∙° ?≥└?└╠?▐└К╔? Й╟√Л╥└?┼╣?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_iphone17.jpg', 1000000);

--update tbl_product set sale_status = '?▄░К╖╓Л╓▒'
--where product_code = '1000AP';

INSERT INTO tbl_product
VALUES
('1100AP', 'iPhone17 Pro', 'Apple',
 q'[iPhone 17 Pro?┼■ ЙЁ═Л└╠?┼╔ ?·▒?≈┘ЙЁ? Л╢╛Л≤│?≈░ ?┼╧?≥■?░° ?■└К╕╛К?╦Л≈└ К╙╗К█╦?·┘?▀┬?▀╓.<br>
Й╟∙К═╔?∙° ?└╠?┼╔?°╪К║? К╘??▀╟?┐°?┼╓?┌╧ЙЁ? ЙЁ═Л┌╛?√▒ ?∙╠ ?▀╓?√┴?²╢ ?⌡░?≥°?∙╘?▀┬?▀╓.<br>
Л╧╢К╘■?²╪ ?└╠?┼╔?²╢ Й╟∙М≥■?░≤?√╢ ?≤│?┐│ Л╢╛Л≤│?≈░?▐└ ?═│?∙╘?∙╘?▀┬?▀╓.<br>
?≥└?└╠?▐└ ?├▓?? ?■■?·░?²╦ЙЁ? ?└╠?┼╔?²└ ?⌡░?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? Л╤■Л╡°?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_iphone17Pro.jpg', 1100000);
 
 
INSERT INTO tbl_product
VALUES
('1200AP', 'iPhone17 Pro Max', 'Apple',
 q'[iPhone 17 Pro Max?┼■ ???≥■К╘╢ЙЁ╪ Й╦? К╟╟М└╟К╕? ?┌╛? ╘ ?▀°Й╟└Л²└ ?═°ЙЁ╣М∙≤?┼■ К╙╗К█╦?·┘?▀┬?▀╓.<br>
?≤│?┐│ Й╟░Л┐│ЙЁ? Й╡▄Л·└?≈░?└° К╙╟Л·┘Й╟? ?·┬?┼■ ?≥■К╘╢Л²└ Й╡╫М≈≤?∙═ ?┬≤ ?·┬?┼╣?▀┬?▀╓.<br>
ЙЁ═Л└╠?┼╔ Л╧╘Л┘▀?°╪К║? ?·╔?▀°Й╟? ?┌╛? ╘?≈░?▐└ ?∙┬?═∙?═│?²╦ ?└╠?┼╔?²└ ?°═Л╖??∙╘?▀┬?▀╓.<br>
?│╟ ?≥■К╘╢Л²└ ?└═?≤╦?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? ?═│?∙╘?∙° ?┼╓К╖┬М┼╦?▐╟?·┘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_iphone17ProMax.jpg', 1200000);

INSERT INTO tbl_product
VALUES
('2000AP', 'iPhone16', 'Apple',
 q'[iPhone 16?? Й╥═М≤∙ ?·║?·▄ ?└╠?┼╔ЙЁ? ?┌╛? ╘?└╠?²└ ?═°ЙЁ╣М∙≤?┼■ К╙╗К█╦?·┘?▀┬?▀╓.<br>
?²╪?┐│?═│?²╦ ?∙╠ ?┌╛? ╘ЙЁ? К╘??▀╟К╞╦К■■?√╢ Й╟░Л┐│?≈░ ?═│?∙╘?∙╘?▀┬?▀╓.<br>
К╤??⌠°?÷╛? ╢ ?²╦?└╟?▌≤?²╢?┼╓К║? ?·╔?▀°Й╟? ?┌╛? ╘?≈░?▐└ ?■╪К║°К▐└Й╟? ?┌╝?┼╣?▀┬?▀╓.<br>
Й╟??└╠К╧└К?? ЙЁ═К═╓?∙° ?└═?┐²Л╖?К║? Л╤■Л╡°?░╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_iphone16.jpg', 2000000);

INSERT INTO tbl_product
VALUES
('2100AP', 'iPhone16 Pro', 'Apple',
 q'[iPhone 16 Pro?┼■ ?└╠?┼╔ЙЁ? Л╧╢К╘■?²╪ ?≥°? ╘?▐└К╔? Л╓▒Л▀°?∙° К╙╗К█╦?·┘?▀┬?▀╓.<br>
?┌╛Л╖└ЙЁ╪ ?≤│?┐│ Л╢╛Л≤│?≈░?└° ?■■?┘▄?²╪?∙° ?▒°?≤└?²╢ Й╟??┼╔?∙╘?▀┬?▀╓.<br>
ЙЁ═Л┌╛?√▒ ?∙╠ЙЁ? ?·▒?≈┘?≈░?└°?▐└ ?∙┬?═∙?═│?²╦ ?█╪?▐╛К╗╪Л┼╓К╔? ?═°ЙЁ╣М∙╘?▀┬?▀╓.<br>
?■└К╕╛К?╦Л≈└ ?┼╓К╖┬М┼╦?▐╟?²└ ?⌡░?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? ?═│?∙╘?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_iphone16Pro.jpg', 2100000);

INSERT INTO tbl_product
VALUES
('2200AP', 'iPhone16 Pro Max', 'Apple',
 q'[iPhone 16 Pro Max?┼■ ?└⌠?? ?≥■К╘╢ЙЁ╪ ЙЁ═Л└╠?┼╔?²└ ?▐≥?▀°?≈░ ?═°ЙЁ╣М∙╘?▀┬?▀╓.<br>
Л╫≤М┘░Л╦? Й╟░Л┐│ЙЁ? ?·▒?≈┘?≈░?└° ?├▓?? К╙╟Л·┘Й╟░Л²└ ?═°ЙЁ╣М∙╘?▀┬?▀╓.<br>
К╟╟М└╟К╕? ? ╗?°╗?²╢ Л╒▀Л∙└ ?∙≤Кё? Л╒┘Л²╪ ?┌╛? ╘?²╢ Й╟??┼╔?∙╘?▀┬?▀╓.<br>
Л╣°Л┐│?°└ К╙╗К█╦?²└ Л╟╬К┼■ ?┌╛? ╘?·░?≈░Й╡? Л╤■Л╡°?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_iphone16ProMax.jpg', 2200000);

INSERT INTO tbl_product
VALUES
('3000AP', 'iPhone15', 'Apple',
 q'[iPhone 15?┼■ ?∙┬?═∙?═│?²╦ ?└╠?┼╔?°╪К║? Й╬╦Л??·┬ ?┌╛?·▒К╟⌡К┼■ К╙╗К█╦?·┘?▀┬?▀╓.<br>
?²╪?┐│ ?┌╛? ╘?≈░ Л╤╘К╤└?∙° ?█╪?▐╛К╗╪Л┼╓К╔? ?═°ЙЁ╣М∙╘?▀┬?▀╓.<br>
?┌╛Л╖?, ?≤│?┐│, SNS ?≥°? ╘?≈░ К╛╢К┌°?∙° ?└═?┐²Л╖??·┘?▀┬?▀╓.<br>
?▀╓?├█ ?·┬?┼■ ?┼╓К╖┬М┼╦?▐╟?²└ Л╟╬К┼■ К╤└Й╩≤ Л╤■Л╡°?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_iphone15.jpg', 3000000);

INSERT INTO tbl_product
VALUES
('3100AP', 'iPhone15 Pro', 'Apple',
 q'[iPhone 15 Pro?┼■ Й╟?КЁ█ЙЁ═ Й╟∙К═╔?∙° ?└╠?┼╔?²└ Й╟√Л╤≤ К╙╗К█╦?·┘?▀┬?▀╓.<br>
ЙЁ═Й╦┴ Л╧╢К╘■?²╪ Й╦╟К┼╔?°╪К║? Л╢╛Л≤│ ?≥°? ╘?▐└Й╟? ?├▓?┼╣?▀┬?▀╓.<br>
К╧═К╔╦ Л╡≤К╕╛ ?├█?▐└К║? ?▀╓?√▒?∙° ?·▒?≈┘?²└ ?┬≤?√┴?∙═ ?┬≤ ?·┬?┼╣?▀┬?▀╓.<br>
?■└К╕╛К?╦Л≈└ ?┌╛? ╘ Й╡╫М≈≤?²└ ?⌡░?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? ?═│?∙╘?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_iphone15Pro.jpg', 3100000);

INSERT INTO tbl_product
VALUES
('3200AP', 'iPhone15 Pro Max', 'Apple',
 q'[iPhone 15 Pro Max?┼■ ???≤∙ ?■■?┼╓?■▄?═┬?²╢?? ЙЁ═Л└╠?┼╔?²╢ ?┼╧Л╖∙Л·┘?▀┬?▀╓.<br>
?≤│?┐│ Й╟░Л┐│ЙЁ? Й╡▄Л·└ ?■▄?═┬?²╢?≈░?└° ?⌡╟?√╢?┌° К╙╟Л·┘Й╟░Л²└ ?═°ЙЁ╣М∙╘?▀┬?▀╓.<br>
?·╔?▀°Й╟? ?┌╛? ╘?≈░?▐└ ?∙┬?═∙?═│?²╦ ?█╪?▐╛К╗╪Л┼╓К╔? ?°═Л╖??∙╘?▀┬?▀╓.<br>
???≥■К╘? ?┼╓К╖┬М┼╦?▐╟?²└ ?└═?≤╦?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? Л╤■Л╡°?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_iphone15ProMax.jpg', 3200000);

INSERT INTO tbl_product
VALUES
('1000GX', 'Galaxy Z Fold7', 'Samsung',
 q'[Galaxy Z Fold7?? ?═▒?²╢?▀² ???≥■К╘╢Л²└ ?═°ЙЁ╣М∙≤?┼■ ?■└К╕╛К?╦Л≈└ ?▐╢?█■К╦? ?┼╓К╖┬М┼╦?▐╟?·┘?▀┬?▀╓.<br>
К╘??▀╟?┐°?┼╓?┌╧ЙЁ? К╛╦Л└° ?·▒?≈┘?≈░ Л╣°Л═│?≥■?░° ?≥■К╘? Й╣╛Л└╠?²└ Л╖??⌡░?∙╘?▀┬?▀╓.<br>
?≤│?┐│ Й╟░Л┐│ЙЁ? ?≈┘К╛? ?≥°? ╘?▐└Й╟? К╖╓Л ╟ ?├▓?┼╣?▀┬?▀╓.<br>
?┐²?┌╟?└╠?²└ Л╓▒Л▀°?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? ?═│?∙╘?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_galaxy_z_fold7.jpg', 1000000);

INSERT INTO tbl_product
VALUES
('1100GX', 'Galaxy Z Flip7', 'Samsung',
 q'[Galaxy Z Flip7?? Л╩╢М▄╘?┼╦?∙° ?▐╢?█■К╦? ?■■?·░?²╦?²╢ ?┼╧Л╖∙Л·┘?▀┬?▀╓.<br>
?°╢???└╠?²╢ ?⌡╟?√╢?┌≤ЙЁ? ?┼╓???²╪К╕╛Л▀°?∙° ?┌╛? ╘?²╢ Й╟??┼╔?∙╘?▀┬?▀╓.<br>
???■╪ Л╢╛Л≤│ЙЁ? Й╟│К▐└ Л║╟Л═┬ Л╢╛Л≤│?≈░ ?°═К╕╛М∙╘?▀┬?▀╓.<br>
Й╟°Л└╠ ?·┬?┼■ ?┼╓К╖┬М┼╦?▐╟?²└ ?⌡░?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? Л╤■Л╡°?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_galaxy_z_flip7.jpg', 1100000);

INSERT INTO tbl_product
VALUES
('1200GX', 'Galaxy S25 Ultra', 'Samsung',
 q'[Galaxy S25 Ultra?┼■ Л╣°Л┐│?°└ ?└╠?┼╔?²└ ?═°ЙЁ╣М∙≤?┼■ ? ╦?┼╦?²╪ К╙╗К█╦?·┘?▀┬?▀╓.<br>
???≤∙ ?■■?┼╓?■▄?═┬?²╢?? Й╟∙К═╔?∙° Л╧╢К╘■?²╪ ?└╠?┼╔?²└ Й╟√Л╤■ЙЁ? ?·┬?┼╣?▀┬?▀╓.<br>
ЙЁ═Л┌╛?√▒ ?·▒?≈┘ЙЁ? Й╡▄Л·└?≈░?└°?▐└ ?∙┬?═∙?═│?²╦ ?└╠?┼╔?²└ ?°═Л╖??∙╘?▀┬?▀╓.<br>
?■└К╕╛К?╦Л≈└ ?∙┬?⌠°К║°Л²╢?⌠° ?┼╓К╖┬М┼╦?▐╟?²└ ?⌡░?∙≤?┼■ К╤└Й╩≤ Л╤■Л╡°?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_galaxy_s25_ultra.jpg', 1200000);

INSERT INTO tbl_product
VALUES
('2000GX', 'Galaxy Z Fold6', 'Samsung',
 q'[Galaxy Z Fold6?┼■ ???≥■К╘? Й╦╟К╟≤?²≤ К╘??▀╟?┐°?┼╓?┌╧?≈░ Й╟∙Л═░?²╢ ?·┬?┼╣?▀┬?▀╓.<br>
?≈╛?÷╛ ?∙╠?²└ ?▐≥?▀°?≈░ ?▀╓?√┴?∙╢ ?·▒?≈┘ ? ╗?°╗?²└ ?├▓?²╪ ?┬≤ ?·┬?┼╣?▀┬?▀╓.<br>
Л╫≤М┘░Л╦? ?├▄К╧└Л? ?≈┘К╛? ?≥°? ╘ К╙╗К▒░?≈░ ?═│?∙╘?∙╘?▀┬?▀╓.<br>
?▐╢?█■К╦? Й╡╫М≈≤?²└ ?⌡░?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? Л╤■Л╡°?░╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_galaxy_z_fold6.jpg', 2000000);

INSERT INTO tbl_product
VALUES
('2100GX', 'Galaxy Z Flip6', 'Samsung',
 q'[Galaxy Z Flip6?┼■ ?°╢???└╠ЙЁ? ?≥°? ╘?└╠?²└ Й╡╦К╧└?∙° ?▐╢?█■К╦? К╙╗К█╦?·┘?▀┬?▀╓.<br>
?·▒?? ?│╛Й╦╟К║° ?═▒?√╢ ?°╢???∙≤Й╦? ?▌╦К╕╛М∙╘?▀┬?▀╓.<br>
?▀╓?√▒?∙° Л╢╛Л≤│ Й╟│К▐└К╔? Л╖??⌡░?∙╢ ?┌╛Л╖? ?≥°? ╘?▐└Й╟? ?├▓?┼╣?▀┬?▀╓.<br>
?▀╓? ╘?└╠ЙЁ? ?■■?·░?²╦?²└ Л╓▒Л▀°?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? ?═│?∙╘?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_galaxy_z_flip6.jpg', 2100000);

INSERT INTO tbl_product
VALUES
('2200GX', 'Galaxy S24 Ultra', 'Samsung',
 q'[Galaxy S24 Ultra?┼■ ЙЁ═Й╦┴?┼╓?÷╛? ╢ ?■■?·░?²╦ЙЁ? ?└╠?┼╔?²└ ?═°ЙЁ╣М∙╘?▀┬?▀╓.<br>
Л╧╢К╘■?²╪?? ?■■?┼╓?■▄?═┬?²╢ ?▓┬Л╖┬Л²╢ ?⌡╟?√╢?┌╘?▀┬?▀╓.<br>
ЙЁ═Л┌╛?√▒ ?∙╠ЙЁ? К╘??▀╟?┐°?┼╓?┌╧?≈░?└°?▐└ ?∙┬?═∙?═│?²╦ ?┌╛? ╘?²╢ Й╟??┼╔?∙╘?▀┬?▀╓.<br>
?■└К╕╛К?╦Л≈└ Й╟╓К÷╜?▀° К╙╗К█╦?²└ Л╟╬К┼■ ?┌╛? ╘?·░?≈░Й╡? Л╤■Л╡°?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_galaxy_s24_ultra.jpg', 2200000);

INSERT INTO tbl_product
VALUES
('3000GX', 'Galaxy Z Fold5', 'Samsung',
 q'[Galaxy Z Fold5?┼■ ?▐╢?█■К╦? ???≥■К╘╢Л²≤ ?≥°? ╘?└╠?²╢ ?▐▀КЁ╢Л²╢?┼■ К╙╗К█╦?·┘?▀┬?▀╓.<br>
?≈┘К╛╢Л? ?≈■?└╟?┘▄?²╦К╗╪М┼╦К╔? ?▐≥?▀°?≈░ Л╕░Й╦╦ ?┬≤ ?·┬?┼╣?▀┬?▀╓.<br>
К╘??▀╟?┐°?┼╓?┌╧?≈░ Л╣°Л═│?≥■?░° ?┌╛? ╘?·░ Й╡╫М≈≤?²└ ?═°ЙЁ╣М∙╘?▀┬?▀╓.<br>
???≥■К╘? ?┼╓К╖┬М┼╦?▐╟?²└ ?└═?≤╦?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? ?═│?∙╘?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_galaxy_z_fold5.jpg', 3000000);

INSERT INTO tbl_product
VALUES
('3100GX', 'Galaxy Z Flip5', 'Samsung',
 q'[Galaxy Z Flip5?┼■ ?└╦?═╗?░° ?■■?·░?²╦ЙЁ? ?°╢???└╠?²╢ ?┼╧Л╖∙Л·┘?▀┬?▀╓.<br>
?═▒?²╢?▀² Й╣╛Л║╟К║? ?┌╛? ╘?└╠ЙЁ? Й╟°Л└╠?²└ К╙╗К▒░ К╖▄Л║╠?▀°?┌╣?▀┬?▀╓.<br>
Л╢╛Л≤│ЙЁ? ?²╪?┐│ ?┌╛? ╘?≈░?└° ?▌╦?²≤?└╠?²╢ ?⌡╟?√╢?┌╘?▀┬?▀╓.<br>
?┼╦?═▄?■■?∙° ?┼╓К╖┬М┼╦?▐╟?²└ ?⌡░?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? Л╤■Л╡°?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_galaxy_z_flip5.jpg', 3100000);

INSERT INTO tbl_product
VALUES
('3200GX', 'Galaxy S23 Ultra', 'Samsung',
 q'[Galaxy S23 Ultra?┼■ Й╟∙К═╔?∙° ?└╠?┼╔ЙЁ? Л╧╢К╘■?²╪К╔? Й╟√Л╤≤ К╙╗К█╦?·┘?▀┬?▀╓.<br>
???≤∙ ?■■?┼╓?■▄?═┬?²╢К║? Л╫≤М┘░Л╦? Й╟░Л┐│?≈░ Л╣°Л═│?≥■?░≤?√╢ ?·┬?┼╣?▀┬?▀╓.<br>
?≈┘К╛╢Л? ?≈■?└╟?┘▄?²╦К╗╪М┼╦ К╙╗К▒░?≈░ ?═│?∙╘?∙° ?┼╓К╖┬М┼╦?▐╟?·┘?▀┬?▀╓.<br>
? ╦?┼╦?²╪ ?²╪?²╦?≈┘?²└ ?└═?≤╦?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? Л╤■Л╡°?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_galaxy_s23_ultra.jpg', 3200000);

COMMIT;

select * from tbl_product
order by product_code;
/* =========================
   iPhone 13 / 14 Series
   ========================= */

INSERT INTO tbl_product
(product_code, product_name, brand_name, product_desc, sale_status, image_path, price)
VALUES
('1300AP', 'iPhone13', 'Apple',
 q'[iPhone 13?? ?∙┬?═∙?═│?²╦ ?└╠?┼╔ЙЁ? ?≥└?└╠?▐└К╔? Й╟√Л╤≤ ?┼╓?┐═?▀╓?⌠° К╙╗К█╦?·┘?▀┬?▀╓.<br>
?²╪?┐│?═│?²╦ ?∙╠ ?┌╛? ╘ЙЁ? К╘??▀╟К╞╦К■■?√╢ Й╟░Л┐│?≈░ Л╤╘К╤└?∙° ?└╠?┼╔?²└ ?═°ЙЁ╣М∙╘?▀┬?▀╓.<br>
Л╧╢К╘■?²╪ ?└╠?┼╔?²╢ Й╟°Л└═?░≤?√╢ ?┌╛Л╖└ЙЁ╪ ?≤│?┐│ Л╢╛Л≤│?²╢ ?█■? ╠ ?·░?≈╟?┼╓?÷╫?┼╣?▀┬?▀╓.<br>
?▀╓?┌╛? ╘ Л╓▒Л▀╛?²≤ ?┼╓К╖┬М┼╦?▐╟?²└ ?⌡░?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? ?═│?∙╘?∙╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_iPhone13.jpg', 1300000);

INSERT INTO tbl_product
VALUES
('1310AP', 'iPhone13 Pro', 'Apple',
 q'[iPhone 13 Pro?┼■ ?└╠?┼╔ЙЁ? Л╢╛Л≤│ ?▓┬Л╖┬Л²└ Й╟∙М≥■?∙° ?■└К║? ?²╪?²╦?≈┘ К╙╗К█╦?·┘?▀┬?▀╓.<br>
ЙЁ═Л└╠?┼╔ Л╧╘Л┘▀?°╪К║? ЙЁ═Л┌╛?√▒ ?∙╠ЙЁ? К╘??▀╟?┐°?┼╓?┌╧?≈░?└°?▐└ ?∙┬?═∙?═│?²╦ ?┌╛? ╘?²╢ Й╟??┼╔?∙╘?▀┬?▀╓.<br>
Л╧╢К╘■?²╪ ?≥°? ╘?▐└Й╟? ?├▓?∙└ ?≤│?┐│ К╟? ?┌╛Л╖? Л╢╛Л≤│?≈░ ?°═К╕╛М∙╘?▀┬?▀╓.<br>
?■└К╕╛К?╦Л≈└ ?┌╛? ╘ Й╡╫М≈≤?²└ ?⌡░?∙≤?┼■ ?┌╛? ╘?·░?≈░Й╡? Л╤■Л╡°?░╘?▀┬?▀╓.]',
 '?▄░К╖╓Л╓▒', 'Main_iPhone13Pro.jpg', 1400000);
 
 COMMIT;
 
/*
INSERT INTO tbl_product
VALUES
('1320AP', 'iPhone13 Pro Max', 'Apple',
 q'[iPhone 13 Pro Max╢б ╢Кх╜╦И╟З ╠Д ╧Хем╦╝ ╩Г©К ╫ц╟ёю╩ а╕╟Ьго╢б ╦П╣╗ют╢о╢ы.<br>
©╣╩С ╟╗╩С╟З ╟тюс©║╪╜ ╤ы╬НЁ╜ ╦Тют╟╗ю╩ а╕╟Ьгу╢о╢ы.<br>
га╥н╠ч д╚╦ч╤С ╪╨╢ию╦╥н дэеыцВ а╕юш©║╣╣ юШгугу╢о╢ы.<br>
╢КгЭ ╫╨╦╤ф╝фЫю╩ ╪╠хёго╢б ╩Г©Кюз©║╟т цъц╣гу╢о╢ы.]',
 'фг╦еаъ', '', 1500000);

INSERT INTO tbl_product
VALUES
('1400AP', 'iPhone14', 'Apple',
 q'[iPhone 14╢б ╠угЭ юБхЫ ╪╨╢и╟З гБ╩С╣х ╬ха╓╪╨ю╩ а╕╟Ьго╢б ╦П╣╗ют╢о╢ы.<br>
юо╩С ╩Г©К©║ цжюШх╜╣х юнемфДюл╫╨╥н ╢╘╠╦Ё╙ ╫╠╟т ╩Г©Кгр ╪Ж юж╫ю╢о╢ы.<br>
д╚╦ч╤С©м ╣П╫╨гц╥╧юл г╟аЗюл ╟Ё╪╠╣г╬Н ╦╦а╥╣╣╟║ ЁТ╫ю╢о╢ы.<br>
╫г╪с юж╢б цж╫е ╬фюлфЫю╩ цё╢б ╩Г©Кюз©║╟т юШгугу╢о╢ы.]',
 'фг╦еаъ', '', 1600000);

INSERT INTO tbl_product
VALUES
('1410AP', 'iPhone14 Pro', 'Apple',
 q'[iPhone 14 Pro╢б ╟М╠ч ╠Б╢и╟З ╪╨╢ию╩ ╟╜х╜гя га╦╝╧л╬Ж ╦П╣╗ют╢о╢ы.<br>
╨н╣Е╥╞©Н х╜╦И юЭх╞╟З ╨Э╦╔ ╧щюю ╪с╣╣╦╕ а╕╟Ьгу╢о╢ы.<br>
цт©╣ ╠Б╢июл ╟╜х╜╣г╬Н ╩ГаЬ╟З ©╣╩Сюг ©о╪╨╣╣╟║ ЁТ╫ю╢о╢ы.<br>
╪╨╢и╟З ╣Пюзюню╩ ╦П╣н аъ╫цго╢б ╩Г©Кюз©║╟т цъц╣гу╢о╢ы.]',
 'фг╦еаъ', '', 1700000);

INSERT INTO tbl_product
VALUES
('1420AP', 'iPhone14 Pro Max', 'Apple',
 q'[iPhone 14 Pro Max╢б ╢Кх╜╦И╟З ╟╜╥бгя ╪╨╢ию╩ ╣©╫ц©║ а╕╟Ьго╢б цж╩Сю╖ ╦П╣╗ют╢о╢ы.<br>
дэеыцВ ╟╗╩С╟З ╟тюс гц╥╧юл©║╪╜ ╤ы╬НЁ╜ ╦Тют╟╗ю╩ а╕╟Ьгу╢о╢ы.<br>
╟М╪╨╢и д╚╦ч╤С╥н ╢ы╬Ггя цт©╣ х╞╟Ф©║╪╜╣╣ ╬ха╓юШюн ╟А╟З╦╕ ╬Рю╩ ╪Ж юж╫ю╢о╢ы.<br>
цж╟М ╩Г╬Гюг ╬фюлфЫю╩ ©Ьго╢б ╩Г©Кюз©║╟т юШгугу╢о╢ы.]',
 'фг╦еаъ', '', 1800000);
*/




--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
/* ===== iPhone 17 Series ===== */
UPDATE tbl_product SET price = 1490000 WHERE product_name = 'iPhone17';
UPDATE tbl_product SET price = 1790000 WHERE product_name = 'iPhone17 Pro';
UPDATE tbl_product SET price = 1990000 WHERE product_name = 'iPhone17 Pro Max';
commit;

/* ===== iPhone 16 Series ===== */
UPDATE tbl_product SET price = 1450000 WHERE product_name = 'iPhone16';
UPDATE tbl_product SET price = 1750000 WHERE product_name = 'iPhone16 Pro';
UPDATE tbl_product SET price = 1950000 WHERE product_name = 'iPhone16 Pro Max';
commit;

/* ===== iPhone 15 Series ===== */
UPDATE tbl_product SET price = 1390000 WHERE product_name = 'iPhone15';
UPDATE tbl_product SET price = 1550000 WHERE product_name = 'iPhone15 Pro';
UPDATE tbl_product SET price = 1900000 WHERE product_name = 'iPhone15 Pro Max';
commit;

/* ===== iPhone 14 Series ===== */
UPDATE tbl_product SET price = 1250000 WHERE product_name = 'iPhone14';
UPDATE tbl_product SET price = 1550000 WHERE product_name = 'iPhone14 Pro';
UPDATE tbl_product SET price = 1750000 WHERE product_name = 'iPhone14 Pro Max';

/* ===== iPhone 13 Series ===== */
UPDATE tbl_product SET price = 1290000 WHERE product_name = 'iPhone13';
UPDATE tbl_product SET price = 1450000 WHERE product_name = 'iPhone13 Pro';
commit;


/* ===== Galaxy Z Fold / Flip / S Ultra ===== */
UPDATE tbl_product SET price = 2379300 WHERE product_name = 'Galaxy Z Fold7';
UPDATE tbl_product SET price = 1495000 WHERE product_name = 'Galaxy Z Flip7';
UPDATE tbl_product SET price = 1696000 WHERE product_name = 'Galaxy S25 Ultra';
commit;

UPDATE tbl_product SET price = 2229700 WHERE product_name = 'Galaxy Z Fold6';
UPDATE tbl_product SET price = 1485000 WHERE product_name = 'Galaxy Z Flip6';
UPDATE tbl_product SET price = 1628400 WHERE product_name = 'Galaxy S24 Ultra';
commit;


UPDATE tbl_product SET price = 2097700 WHERE product_name = 'Galaxy Z Fold5';
UPDATE tbl_product SET price = 1420200 WHERE product_name = 'Galaxy Z Flip5';
UPDATE tbl_product SET price = 1599400 WHERE product_name = 'Galaxy S23 Ultra';
commit;

select product_name, price
from tbl_product
where brand_name = 'Apple';
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
----------------------------╩Сг╟ ©и╪г©║ ╢Кгя ╟╙ Ёж╠Б--------------------------------------
--------------------------------------------------------------------------------------
/* =========================================================
   tbl_product_option : 8 options per product
   base option: Black + 256GB (plus_price=0) ╧щ╣Е╫ц фВгт
   plus_price: 256GB=0, 512GB=200000, 1T=400000
   ========================================================= */

/* -------------------------
   Apple
-------------------------- */

/* 1000AP iPhone17 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','Black','256GB',24,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','White','256GB',11,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','Blue','256GB',18,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','Red','256GB',16,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','Black','512GB',19,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','White','512GB',15,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','Black','1T',13,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000AP','Blue','1T',11,400000);
commit; 

/* 1100AP iPhone17 Pro (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','Black','256GB',18,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','White','256GB',19,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','Blue','256GB',17,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','Red','256GB',15,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','Black','512GB',16,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','White','512GB',13,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','Black','1T',12,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100AP','Blue','512GB',0,200000);

/* 1200AP iPhone17 Pro Max (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','Black','256GB',14,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','White','256GB',16,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','Blue','256GB',15,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','Red','256GB',14,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','Black','512GB',14,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','White','512GB',12,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','Black','1T',13,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200AP','Blue','1T',11,400000);

/* 1300AP iPhone13 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','Black','256GB',22,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','White','256GB',10,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','Blue','256GB',18,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','Red','256GB',16,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','Black','512GB',15,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','White','512GB',13,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','Black','1T',12,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1300AP','Blue','512GB',11,200000);

/* 1310AP iPhone13 Pro (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','Black','256GB',16,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','White','256GB',17,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','Blue','256GB',16,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','Red','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','Black','512GB',15,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','Black','1T',11,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1310AP','Blue','512GB',13,200000);



/* 2000AP iPhone16 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','Black','256GB',17,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','White','256GB',8,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','Blue','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','Red','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','Black','512GB',25,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','White','512GB',22,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','Black','1T',12,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000AP','Blue','512GB',1,200000);

/* 2100AP iPhone16 Pro (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','Black','256GB',13,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','White','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','Blue','256GB',0,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','Red','256GB',14,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','Black','512GB',14,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','White','512GB',22,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','Black','1T',1,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100AP','Blue','1T',22,400000);

/* 2200AP iPhone16 Pro Max (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','Black','256GB',10,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','White','256GB',25,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','Blue','256GB',14,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','Red','256GB',13,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','Black','512GB',23,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','White','512GB',22,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','Black','1T',12,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200AP','Blue','512GB',11,200000);

/* 3000AP iPhone15 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','Black','256GB',19,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','White','256GB',7,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','Blue','256GB',6,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','Red','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','Black','512GB',15,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','White','512GB',22,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','Black','1T',12,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000AP','Blue','512GB',1,200000);

/* 3100AP iPhone15 Pro (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','Black','256GB',12,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','White','256GB',26,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','Blue','256GB',25,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','Red','256GB',14,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','White','512GB',22,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','Black','1T',1,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3100AP','Blue','512GB',3,200000);

/* 3200AP iPhone15 Pro Max (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','Black','256GB',19,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','White','256GB',4,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','Blue','256GB',24,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','Red','256GB',13,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','Black','512GB',23,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','White','512GB',22,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3200AP','Blue','1T',11,400000);


/* -------------------------
   Samsung
-------------------------- */

/* 1000GX Galaxy Z Fold7 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','Black','256GB',14,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','White','256GB',26,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','Blue','256GB',25,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','Red','256GB',14,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','Black','512GB',15,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','White','512GB',22,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','Black','1T',22,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1000GX','Blue','1T',21,400000);

/* 1100GX Galaxy Z Flip7 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','Black','256GB',16,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','White','256GB',17,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','Blue','256GB',15,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','Red','256GB',14,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','Black','512GB',4,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','White','512GB',2,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','Black','1T',21,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1100GX','Blue','512GB',13,200000);

/* 1200GX Galaxy S25 Ultra (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','Black','256GB',13,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','White','256GB',5,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','Blue','256GB',24,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','Red','256GB',23,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','Black','512GB',14,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','White','512GB',22,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','Black','1T',22,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'1200GX','Blue','1T',1,400000);

/* 2000GX Galaxy Z Fold6 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','Black','256GB',12,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','White','256GB',26,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','Blue','256GB',25,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','Red','256GB',14,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','Black','512GB',25,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','White','512GB',22,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','Black','1T',32,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2000GX','Blue','512GB',31,200000);

/* 2100GX Galaxy Z Flip6 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','Black','256GB',15,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','White','256GB',37,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','Blue','256GB',25,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','Red','256GB',34,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','Black','512GB',34,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','White','512GB',22,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','Black','1T',31,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2100GX','Blue','1T',32,400000);

/* 2200GX Galaxy S24 Ultra (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','Black','256GB',11,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','White','256GB',25,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','Blue','256GB',34,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','Red','256GB',33,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','Black','512GB',34,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','White','512GB',22,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','Black','1T',2,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'2200GX','Blue','512GB',21,200000);

/* 3000GX Galaxy Z Fold5 (8) */
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','Black','256GB',10,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','White','256GB',0,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','Blue','256GB',24,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','Red','256GB',13,0);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','Black','512GB',23,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','White','512GB',32,200000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','Black','1T',31,400000);
INSERT INTO tbl_product_option VALUES(SEQ_PRODUCT_OPTION_ID.nextval,'3000GX','Blue','512GB',31,200000);

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


-----------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-----------@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
select * from tbl_product_image;


/* =====================================
   tbl_product_image INSERT
   - ╟╒ ╩Сг╟╢Г цъ╟║ юл╧лаЖ 2╟Ё
   - image_path╢б юс╫ц╥н ╨С ╧╝юз©╜ ''
   ===================================== */

/* ===== Apple ===== */

/* iPhone 17 */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1000AP', 'iphone17_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1000AP', 'iphone17_2.jpg');

/* iPhone 17 Pro */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1100AP', 'iphone17Pro_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1100AP', 'iphone17Pro_2.jpg');

/* iPhone 17 Pro Max */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1200AP', 'iphone17ProMax_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1200AP', 'iphone17ProMax_2.jpg');

/* iPhone 13 */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1300AP', 'iPhone13_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1300AP', 'iPhone13_2.jpg');

/* iPhone 13 Pro */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1310AP', 'iPhone13Pro_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1310AP', 'iPhone13Pro_2.jpg');


/* iPhone 16 */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '2000AP', 'iphone16_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '2000AP', 'iphone16_2.jpg');

/* iPhone 16 Pro */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '2100AP', 'iphone16Pro_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '2100AP', 'iphone16Pro_2.jpg');

/* iPhone 16 Pro Max */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '2200AP', 'iphone16ProMax_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '2200AP', 'iphone16ProMax_2.jpg');

/* iPhone 15 */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '3000AP', 'iphone15_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '3000AP', 'iphone15_2.jpg');

/* iPhone 15 Pro */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '3100AP', 'iphone15Pro_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '3100AP', 'iphone15Pro_2.jpg');

/* iPhone 15 Pro Max */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '3200AP', 'iphone15ProMax_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '3200AP', 'iphone15ProMax_2.jpg');
commit;

/* ===== Samsung ===== */

/* Galaxy Z Fold7 */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1000GX', 'galaxy_z_fold7_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1000GX', 'galaxy_z_fold7_2.jpg');

/* Galaxy Z Flip7 */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1100GX', 'galaxy_z_flip7_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1100GX', 'galaxy_z_flip7_2.jpg');

/* Galaxy S25 Ultra */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1200GX', 'galaxy_s25_ultra_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '1200GX', 'galaxy_s25_ultra_2.jpg');

/* Galaxy Z Fold6 */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '2000GX', 'galaxy_z_fold6_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '2000GX', 'galaxy_z_fold6_2.jpg');

/* Galaxy Z Flip6 */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '2100GX', 'galaxy_z_flip6_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '2100GX', 'galaxy_z_flip6_2.jpg');

/* Galaxy S24 Ultra */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '2200GX', 'galaxy_s24_ultra_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '2200GX', 'galaxy_s24_ultra_2.jpg');

/* Galaxy Z Fold5 */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '3000GX', 'galaxy_z_fold5_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '3000GX', 'galaxy_z_fold5_2.jpg');

/* Galaxy Z Flip5 */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '3100GX', 'galaxy_z_flip5_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '3100GX', 'galaxy_z_flip5_2.jpg');

/* Galaxy S23 Ultra */
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '3200GX', 'galaxy_s23_ultra_1.jpg');
INSERT INTO tbl_product_image VALUES (SEQ_PRODUCT_IMAGE.nextval, '3200GX', 'galaxy_s23_ultra_2.jpg');

COMMIT;


SELECT fk_product_code option_id, color, storage_size, plus_price, stock_qty
FROM tbl_product_option
WHERE fk_product_code = '1000AP'
ORDER BY 
CASE storage_size
    WHEN '256GB' THEN 1
    WHEN '512GB' THEN 2
    WHEN '1T' THEN 3
END,
color;
    