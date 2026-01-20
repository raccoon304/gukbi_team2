
-------- ���̺� ���� --------

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

-- status �÷� ����Ʈ�� ����
ALTER TABLE TBL_MEMBER
  MODIFY (STATUS DEFAULT 0);
  
-- idle �÷� ����Ʈ�� ����
ALTER TABLE TBL_MEMBER
  MODIFY (IDLE DEFAULT 0);
  

create table tbl_member_backup
as
select * from tbl_member;

-- ������ ����
CREATE SEQUENCE SEQ_TBL_MEMBER_USERSEQ
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- userseq �÷� �߰�
alter table tbl_member
add userseq number;

update tbl_member set userseq = SEQ_TBL_MEMBER_USERSEQ.nextval
where MEMBER_ID = 'eomjh';

update tbl_member set userseq = SEQ_TBL_MEMBER_USERSEQ.nextval
where MEMBER_ID = 'smon0376';

-- userseq �÷� ����ũ���� ����
alter table tbl_member
add constraint UQ_TBL_MEMBER_USERSEQ unique(userseq);

-- userseq �÷� not null ����
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

-- IMAGE_PATH �÷� �߰�
ALTER TABLE TBL_PRODUCT
ADD (IMAGE_PATH VARCHAR2(200));

-- IMAGE_PATH �÷� NOT NULL ����
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

-------- ������ ���� --------

CREATE SEQUENCE SEQ_TBL_COUPON_COUPON_CATEGORY_NO
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- �÷� �Ӽ� ����
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

-- IMAGE_PATH �÷� ����
ALTER TABLE TBL_PRODUCT_OPTION
DROP COLUMN IMAGE_PATH;

-------- ������ ���� --------

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

-------- ������ ���� --------

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

-------- ������ ���� --------

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

-------- ������ ���� --------

CREATE SEQUENCE SEQ_TBL_ORDERS_ORDER_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE SEQ_TBL_ORDERS_DELIVERY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- �÷� �߰�
ALTER TABLE TBL_ORDERS
ADD (
  DELIVERY_NUMBER     VARCHAR2(20),
  DELIVERY_STARTDATE  DATE,
  DELIVERY_ENDDATE    DATE
);


-- üũ���� �߰�
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

-------- ������ ���� --------

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

-------- ������ ���� --------

CREATE SEQUENCE SEQ_TBL_REVIEW_REVIEW_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- RATING, DELETED_YN, DELETED_AT, DELETED_BT �÷� �߰�
ALTER TABLE TBL_REVIEW ADD (
  RATING      NUMBER(2,1)             NOT NULL,
  DELETED_YN  NUMBER(1)     DEFAULT 0 NOT NULL,
  DELETED_AT  DATE          NULL,
  DELETED_BY  VARCHAR2(40)  NULL
);

-- RATING, DELETED_YN �÷��� üũ���� �߰�
ALTER TABLE TBL_REVIEW
ADD CONSTRAINT CK_TBL_REVIEW_RATING
CHECK (
  RATING BETWEEN 0.5 AND 5.0
  AND (RATING*2 = TRUNC(RATING*2))
);

ALTER TABLE TBL_REVIEW
ADD CONSTRAINT CK_TBL_REVIEW_DELETED_YN
CHECK (DELETED_YN IN (0,1));


-- review_title �÷� �߰�
ALTER TABLE TBL_REVIEW
ADD (review_title VARCHAR2(100));

-- review_title �÷� NOT NULL ����
ALTER TABLE TBL_REVIEW
MODIFY (review_title VARCHAR2(100) NOT NULL);

-- ����ũ ���� �߰���

CREATE UNIQUE INDEX UQ_TBL_REVIEW_FK_ORDER_DETAIL_ID
ON TBL_REVIEW ( CASE WHEN deleted_yn = 0 THEN fk_order_detail_id END );

-- �÷� Ÿ�� ����
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

-------- ������ ���� --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- üũ���� ����
ALTER TABLE TBL_INQUIRY
DROP CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS;

-- üũ���� ����
ALTER TABLE TBL_INQUIRY
ADD CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS
CHECK (REPLY_STATUS IN (0,1,2));

-- REPLY_STATUS ����Ʈ�� 1�� ����
ALTER TABLE TBL_INQUIRY
MODIFY (REPLY_STATUS DEFAULT 1);


-- deleted_yn, deleted_at, deleted_by, is_secret �÷� �߰�
ALTER TABLE tbl_inquiry ADD (
  deleted_yn NUMBER(1) DEFAULT 0 NOT NULL,
  deleted_at DATE,
  deleted_by VARCHAR2(40),
  is_secret  NUMBER(1) DEFAULT 0 NOT NULL
);

-- deleted_yn, is_secret �÷� üũ���� �߰�
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


------ ��ǰ���̺� ���� ����ϱ�
select *
from tbl_product
order by product_name;

------ ��ǰ�����̺� ���� ����ϱ�
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ������17 �����Ͱ�
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '������17�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '������17 Pro�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '������17 Pro Max�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');

-- ������16 �����Ͱ�
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '������16�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '������16 Pro�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '������16 Pro Max�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

-- ������15 �����Ͱ�
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '������15�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '������15 Pro�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '������15 Pro Max�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- �������� �����Ͱ�
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', '������ Z����7�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', '������ Z�ø�7�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', '������ s25 ��Ʈ�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

---------------- ������6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', '������ Z����6�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', '������ Z�ø�6�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', '������ s24 ��Ʈ�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

---------------- ������5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', '������ Z����5�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', '������ Z�ø�5�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', '������ s23 ��Ʈ�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------������ �󼼿ɼ� ������ ����----------------------------------------------------
--������17 ������
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

--������17 Pro �󼼿ɼ�
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

--������17 Pro Max �󼼿ɼ�
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



--������16 �󼼿ɼ�
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

--������16 Pro ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ������16 Pro Max ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--������15 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--������15 Pro ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--������ 15 Pro Max ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- ��ǰ�� ������ ��ǰ�� �����Ͽ� ���� ����ϱ�
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- ��ǰ���̺� ���� ����ϱ�
select * from tbl_product;
commit;

---------------------------------------������ �󼼿ɼ� ������ ����----------------------------------------------------
-- Galaxy Z Fold7 �󼼿ɼ�
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


-- Galaxy Z Flip7 �󼼿ɼ�
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


-- Galaxy S25 Ultra �󼼿ɼ�
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

-- ������ z����6 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- ������ z�ø�6 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- ������ s24 ��Ʈ�� ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- ������ ����5 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- ������ �ø�5 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- ������ s23 ��Ʈ�� ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- ��ǰ�� ������ ��ǰ�� �����Ͽ� ���� ����ϱ�
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ��ǰ���̺� ���� ����ϱ�
select * from tbl_product;
commit;


--��ǰ�� ���� ������ ������ ���� ���� �ɼ��� ������ �����Ͽ� ���
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '�Ǹ���'
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


------ ��ǰ���̺� ���� ����ϱ�
select *
from tbl_product
order by product_name;

------ ��ǰ�����̺� ���� ����ϱ�
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ������17 �����Ͱ�
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '������17�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '������17 Pro�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '������17 Pro Max�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');

-- ������16 �����Ͱ�
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '������16�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '������16 Pro�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '������16 Pro Max�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

-- ������15 �����Ͱ�
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '������15�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '������15 Pro�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '������15 Pro Max�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- �������� �����Ͱ�
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', '������ Z����7�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', '������ Z�ø�7�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', '������ s25 ��Ʈ�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

---------------- ������6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', '������ Z����6�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', '������ Z�ø�6�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', '������ s24 ��Ʈ�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

---------------- ������5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', '������ Z����5�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', '������ Z�ø�5�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', '������ s23 ��Ʈ�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------������ �󼼿ɼ� ������ ����----------------------------------------------------
--������17 ������
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

--������17 Pro �󼼿ɼ�
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

--������17 Pro Max �󼼿ɼ�
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



--������16 �󼼿ɼ�
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

--������16 Pro ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ������16 Pro Max ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--������15 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--������15 Pro ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--������ 15 Pro Max ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- ��ǰ�� ������ ��ǰ�� �����Ͽ� ���� ����ϱ�
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- ��ǰ���̺� ���� ����ϱ�
select * from tbl_product;
commit;

---------------------------------------������ �󼼿ɼ� ������ ����----------------------------------------------------
-- Galaxy Z Fold7 �󼼿ɼ�
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


-- Galaxy Z Flip7 �󼼿ɼ�
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


-- Galaxy S25 Ultra �󼼿ɼ�
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

-- ������ z����6 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- ������ z�ø�6 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- ������ s24 ��Ʈ�� ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- ������ ����5 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- ������ �ø�5 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- ������ s23 ��Ʈ�� ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- ��ǰ�� ������ ��ǰ�� �����Ͽ� ���� ����ϱ�
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ��ǰ���̺� ���� ����ϱ�
select * from tbl_product;
commit;


--��ǰ�� ���� ������ ������ ���� ���� �ɼ��� ������ �����Ͽ� ���
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '�Ǹ���'
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



-- ��ǰ�ɼ����̺��� �������ǵ� Ȯ���ϱ�
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT_OPTION';

-- ��ǰ�ɼ����̺��� ���� üũ���� ����
ALTER TABLE tbl_product_option DROP CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE;

-- ��ǰ�ɼ����̺��� pric �÷� ����
ALTER TABLE tbl_product_option
DROP COLUMN price;

-- ��ǰ�ɼ����̺� plus_price �÷� �߰�(�������� 0�� ���ų� ŭ)
ALTER TABLE tbl_product_option
ADD plus_price NUMBER DEFAULT 0
    CONSTRAINT ck_tbl_product_option_plus_price CHECK (plus_price >= 0);
    
select * from tbl_product_option;


-- ��ǰ���̺��� �������ǵ� Ȯ���ϱ�
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT';

-- ��ǰ���̺� price �÷� �߰�(�������� 0���� Ŀ�� ��)
ALTER TABLE tbl_product
ADD price NUMBER
    CONSTRAINT ck_tbl_product_price CHECK (price > 0);

select product_code, product_name, price
from tbl_product
where brand_name = 'Samsung'
order by product_code;

-- ��ǰ���̺��� �����÷��� �� ������Ʈ�ϱ�
update tbl_product set price = 2200000
where product_code = '3000GX';

commit;



-- ��ǰ�� ������ ��ǰ�� �����Ͽ� ���� ����ϱ�
SELECT P.product_code, option_id, P.product_name,storage_size, price, plus_price
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Samsung' and storage_size = '512GB'
ORDER BY product_code, storage_size desc;

-- ��ǰ�ɼ����̺��� �߰��ݾ� �÷��� �� ������Ʈ�ϱ�
update tbl_product_option set plus_price = 150000
where fk_product_code = '2100GX' and storage_size = '512GB';

commit;


--(��ǰ�ڵ�,��ǰ��,�귣���,�̹������,����)
select product_code, product_name, brand_name, image_path, price, sale_status
from tbl_product
where sale_status='�Ǹ���';


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


-- �����߽��ϴ�...
-- �����߽��ϴ�...

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

-------- ������ ���� --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- üũ���� ����
ALTER TABLE TBL_INQUIRY
DROP CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS;

-- üũ���� ����
ALTER TABLE TBL_INQUIRY
ADD CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS
CHECK (REPLY_STATUS IN (0,1,2));

-- REPLY_STATUS ����Ʈ�� 1�� ����
ALTER TABLE TBL_INQUIRY
MODIFY (REPLY_STATUS DEFAULT 1);


-- deleted_yn, deleted_at, deleted_by, is_secret �÷� �߰�
ALTER TABLE tbl_inquiry ADD (
  deleted_yn NUMBER(1) DEFAULT 0 NOT NULL,
  deleted_at DATE,
  deleted_by VARCHAR2(40),
  is_secret  NUMBER(1) DEFAULT 0 NOT NULL
);

-- deleted_yn, is_secret �÷� üũ���� �߰�
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_deleted_yn CHECK (deleted_yn IN (0,1));
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_is_secret  CHECK (is_secret  IN (0,1));


-- �÷� Ÿ�� ����
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


-------- ������ ���� --------

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


------ ��ǰ���̺� ���� ����ϱ�
select *
from tbl_product
order by product_name;

------ ��ǰ�����̺� ���� ����ϱ�
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ������17 �����Ͱ�
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '������17�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '������17 Pro�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '������17 Pro Max�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');

-- ������16 �����Ͱ�
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '������16�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '������16 Pro�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '������16 Pro Max�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

-- ������15 �����Ͱ�
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '������15�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '������15 Pro�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '������15 Pro Max�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- �������� �����Ͱ�
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', '������ Z����7�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', '������ Z�ø�7�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', '������ s25 ��Ʈ�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

---------------- ������6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', '������ Z����6�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', '������ Z�ø�6�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', '������ s24 ��Ʈ�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

---------------- ������5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', '������ Z����5�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', '������ Z�ø�5�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', '������ s23 ��Ʈ�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------������ �󼼿ɼ� ������ ����----------------------------------------------------
--������17 ������
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

--������17 Pro �󼼿ɼ�
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

--������17 Pro Max �󼼿ɼ�
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



--������16 �󼼿ɼ�
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

--������16 Pro ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ������16 Pro Max ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--������15 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--������15 Pro ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--������ 15 Pro Max ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- ��ǰ�� ������ ��ǰ�� �����Ͽ� ���� ����ϱ�
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- ��ǰ���̺� ���� ����ϱ�
select * from tbl_product;
commit;

---------------------------------------������ �󼼿ɼ� ������ ����----------------------------------------------------
-- Galaxy Z Fold7 �󼼿ɼ�
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


-- Galaxy Z Flip7 �󼼿ɼ�
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


-- Galaxy S25 Ultra �󼼿ɼ�
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

-- ������ z����6 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- ������ z�ø�6 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- ������ s24 ��Ʈ�� ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- ������ ����5 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- ������ �ø�5 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- ������ s23 ��Ʈ�� ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- ��ǰ�� ������ ��ǰ�� �����Ͽ� ���� ����ϱ�
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ��ǰ���̺� ���� ����ϱ�
select * from tbl_product;
commit;


--��ǰ�� ���� ������ ������ ���� ���� �ɼ��� ������ �����Ͽ� ���
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '�Ǹ���'
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


------ ��ǰ���̺� ���� ����ϱ�
select *
from tbl_product
order by product_name;

------ ��ǰ�����̺� ���� ����ϱ�
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ������17 �����Ͱ�
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '������17�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '������17 Pro�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '������17 Pro Max�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');

-- ������16 �����Ͱ�
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '������16�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '������16 Pro�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '������16 Pro Max�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

-- ������15 �����Ͱ�
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '������15�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '������15 Pro�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '������15 Pro Max�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- �������� �����Ͱ�
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', '������ Z����7�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', '������ Z�ø�7�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', '������ s25 ��Ʈ�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

---------------- ������6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', '������ Z����6�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', '������ Z�ø�6�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', '������ s24 ��Ʈ�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;

---------------- ������5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', '������ Z����5�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', '������ Z�ø�5�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', '������ s23 ��Ʈ�� ���� �����Դϴ�. �ӽ� �����Դϴ�. ���߿� update�� �ٲټ���.', '�Ǹ���', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------������ �󼼿ɼ� ������ ����----------------------------------------------------
--������17 ������
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

--������17 Pro �󼼿ɼ�
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

--������17 Pro Max �󼼿ɼ�
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



--������16 �󼼿ɼ�
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

--������16 Pro ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ������16 Pro Max ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--������15 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--������15 Pro ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--������ 15 Pro Max ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- ��ǰ�� ������ ��ǰ�� �����Ͽ� ���� ����ϱ�
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- ��ǰ���̺� ���� ����ϱ�
select * from tbl_product;
commit;

---------------------------------------������ �󼼿ɼ� ������ ����----------------------------------------------------
-- Galaxy Z Fold7 �󼼿ɼ�
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


-- Galaxy Z Flip7 �󼼿ɼ�
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


-- Galaxy S25 Ultra �󼼿ɼ�
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

-- ������ z����6 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- ������ z�ø�6 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- ������ s24 ��Ʈ�� ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- ������ ����5 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- ������ �ø�5 ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- ������ s23 ��Ʈ�� ������
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- ��ǰ�� ������ ��ǰ�� �����Ͽ� ���� ����ϱ�
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ��ǰ���̺� ���� ����ϱ�
select * from tbl_product;
commit;


--��ǰ�� ���� ������ ������ ���� ���� �ɼ��� ������ �����Ͽ� ���
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '�Ǹ���'
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



-- ��ǰ�ɼ����̺��� �������ǵ� Ȯ���ϱ�
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT_OPTION';

-- ��ǰ�ɼ����̺��� ���� üũ���� ����
ALTER TABLE tbl_product_option DROP CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE;

-- ��ǰ�ɼ����̺��� pric �÷� ����
ALTER TABLE tbl_product_option
DROP COLUMN price;

-- ��ǰ�ɼ����̺� plus_price �÷� �߰�(�������� 0�� ���ų� ŭ)
ALTER TABLE tbl_product_option
ADD plus_price NUMBER DEFAULT 0
    CONSTRAINT ck_tbl_product_option_plus_price CHECK (plus_price >= 0);
    
select * from tbl_product_option;


-- ��ǰ���̺��� �������ǵ� Ȯ���ϱ�
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT';

-- ��ǰ���̺� price �÷� �߰�(�������� 0���� Ŀ�� ��)
ALTER TABLE tbl_product
ADD price NUMBER
    CONSTRAINT ck_tbl_product_price CHECK (price > 0);

select product_code, product_name, price
from tbl_product
where brand_name = 'Samsung'
order by product_code;

-- ��ǰ���̺��� �����÷��� �� ������Ʈ�ϱ�
update tbl_product set price = 2200000
where product_code = '3000GX';

commit;



-- ��ǰ�� ������ ��ǰ�� �����Ͽ� ���� ����ϱ�
SELECT P.product_code, option_id, P.product_name,storage_size, price, plus_price
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Samsung' and storage_size = '512GB'
ORDER BY product_code, storage_size desc;

-- ��ǰ�ɼ����̺��� �߰��ݾ� �÷��� �� ������Ʈ�ϱ�
update tbl_product_option set plus_price = 150000
where fk_product_code = '2100GX' and storage_size = '512GB';

commit;


--(��ǰ�ڵ�,��ǰ��,�귣���,�̹������,����)
select product_code, product_name, brand_name, image_path, price, sale_status
from tbl_product
where sale_status='�Ǹ���';


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


-- �����߽��ϴ�...
-- �����߽��ϴ�...

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

insert into tbl_orders(1002, dog, sysdate, 4950000, 50000, 'PAID', '���� ���ı� ������ 128 101ȣ', �ӽü�����, 010-0000-0000, 0);
insert into tbl_order_detail(1003, 149, 1002, 1, 2400000, 0, 'Galaxy Z Fold7', 'Samsung');
insert into tbl_order_detail(1004, 196, 1002, 1, 1700000, 0, 'iPhone15 Pro', 'Apple');

insert into tbl_review(1,196,1000,'��â�ϼ���',sysdate,5,0,null,null,'�߾��� �־��');

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
-- Table TBL_PRODUCT_IMAGE��(��) �����Ǿ����ϴ�.

ALTER TABLE tbl_product_image
RENAME COLUMN product_code TO fk_product_code_image;
ALTER TABLE tbl_product_image
RENAME COLUMN image_path TO plus_image_path;
commit;

-- PRIMARY KEY �߰�
ALTER TABLE tbl_product_image ADD CONSTRAINT pk_product_image PRIMARY KEY (image_id);

-- FOREIGN KEY �߰� (��ǰ ���̺�� ����)
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
-- Sequence SEQ_PRODUCT_IMAGE��(��) �����Ǿ����ϴ�.

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
SET product_desc = q'[�׽�Ʈ�� �̹��� ��� ��ǰ�Դϴ�.<br>��ǰ �� ���������� �̹���/���� ����� ���� �����ϴ��� Ȯ���� �� �־��.<br>����� ���� �������̸�, ���� � �� �������� ��ü�ϸ� �˴ϴ�.<br>�̹��� ��� �� �⺻ ���� ���� �׽�Ʈ�� ������ ��ǰ�Դϴ�.]'
WHERE product_code = '0481SS';




UPDATE tbl_product
SET product_desc = q'[iPhone 17�� �ϻ���� �������� ������ �������� ����� ��ǥ�� �� �����̾� ����Ʈ���Դϴ�.<br>������ ���÷��̿� ���� ���� �������� �� ��ȯ�� ��Ƽ�½�ŷ�� �Ų������ϴ�.<br>�Կ����� �������� �� ���� ó���� �� �ֵ��� ī�޶� Ȱ�뼺�� ��ȭ�Ǿ����ϴ�.<br>������ ��� �ٴϱ� ���� ����� �̵��� ���� ����ڿ��Ե� �� �½��ϴ�.]'
WHERE product_code = '1000AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Fold7�� ������ ���� �޴뼺�� ������ ���� ��ȭ�� ������ ��� �����ϴ� ������ ���Դϴ�.<br>���� �۾�, ��Ƽ�½�ŷ, ���� ������� �� ȭ�鿡�� ȿ�������� Ȱ���� �� �־��.<br>�� ����/�÷��� �� �پ��� ȭ�� �������� ���꼺�� ���� �� �ֽ��ϴ�.<br>�����̾� ����� �ϼ����� ������ �Թ��ں��� ��� �������� �������� �����ϴ�.]'
WHERE product_code = '1000GX';

UPDATE tbl_product
SET product_desc = q'[iPhone 17 Pro�� ���� �۾��� �Կ��� ���� �ϴ� ����ڿ��� ����ȭ�� ���� ���ξ��Դϴ�.<br>���� ó�� �ӵ��� �������� �߿�/���� ������ ��ð� ��뿡�� �����մϴ�.<br>������ ���� �Կ� �� ������ ǥ���� ������ �ڿ������� �����ǵ��� ����Ǿ����ϴ�.<br>�����̾� ������ �߰��� ���������� ���ϸ� �����ε� �ϼ����� �����ϴ�.]'
WHERE product_code = '1100AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Flip7�� ����Ʈ�ϰ� ������ �����ͷ� �޴뼺�� ��Ÿ���� ���ÿ� ���� �ø� ���Դϴ�.<br>Ŀ�� ȭ���� Ȱ���� �˸� Ȯ��, ������ ������ ������ ó���� �� �־��.<br>���� �Կ��̳� ���̺� �� �Կ� �� ������ Ư���� Ȱ�뵵�� �پ�ϴ�.<br>������ ��밨�� ���� �ִ� �������� ���ϴ� ����ڿ��� ��õ�մϴ�.]'
WHERE product_code = '1100GX';

UPDATE tbl_product
SET product_desc = q'[iPhone 17 Pro Max�� ��ȭ��� �� ��� �ð��� ���ϴ� ����ڿ��� ���� �ֻ��� ���Դϴ�.<br>���� ȭ������ ����/����/������ ���� ���԰� �ְ� ��� �� �ֽ��ϴ�.<br>��� �Կ� ��ɰ� �������� �������� ������ ���ۿ��� �����մϴ�.<br>���͸� ȿ���� �߽��ϴ� ����ڿ��� Ư�� �������� �����ϴ�.]'
WHERE product_code = '1200AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy S25 Ultra�� ������ ��ȭ��� ������ ������ ������� �� ��Ʈ�� �÷��׽� ���Դϴ�.<br>ī�޶� Ȱ�뼺�� �پ ǳ��, �ι�, �߰� �Կ����� ���а� Ŀ���մϴ�.<br>���� �����̳� ��Ƽ�½�ŷ������ �ε巯�� ������ ����� �� �ֽ��ϴ�.<br>����/�н�/�������θ�Ʈ�� �� ���� �ذ��ϰ� ���� ����ڿ��� �����մϴ�.]'
WHERE product_code = '1200GX';

UPDATE tbl_product
SET product_desc = q'[�� ��ǰ�� �׽�Ʈ/���� ������ �ӽ� �������Դϴ�.<br>��ǰ��� ����, �˻� Ű���� ���� ���� � ���ذ� �ٸ� �� �ֽ��ϴ�.<br>����Ʈ ȭ�� ��� �� DB ����/��ȸ �帧 ���˿� ����� �� �־��.<br>� ���� �� �ݵ�� �������� ��ǰ ������ ������Ʈ�ϼ���.]'
WHERE product_code = '1234IN';

UPDATE tbl_product
SET product_desc = q'[TESTproduct2222�� ��� ������ ���� �׽�Ʈ ��ǰ�Դϴ�.<br>��ǰ ���/��/��ٱ���/���� �帧���� �����Ͱ� ���� ����Ǵ��� Ȯ���غ�����.<br>�ɼ� ����, ��� ó��, ���� ����� �ùٸ��� �����ϴ��� �����ϱ� �����ϴ�.<br>�Ǽ��� �ݿ� �ÿ��� ���� ��ǰ �������� ��ü�� �ʿ��մϴ�.]'
WHERE product_code = '1234SD';

UPDATE tbl_product
SET product_desc = q'[testAppleProduct24�� ���� �迭 ��ǰ ��� ��� �׽�Ʈ�� �����Դϴ�.<br>�̹��� ���ε�, �� ������ ������, �ٹٲ� ó�� Ȯ�ο� �����մϴ�.<br>������ ���������� ����/����/��ȸ ����� ������ �� Ȱ���� �� �־��.<br>� ������ ��ǰ ����� �Ǹ� ��å�� �°� ������ ������Ʈ�ϼ���.]'
WHERE product_code = '1300AP';

UPDATE tbl_product
SET product_desc = q'[iPhone 16�� ���� ���� ���ɰ� ��뼺�� �����ϴ� ���Ĵٵ� ���Դϴ�.<br>�ϻ����� �� ������ ����/���� �Կ����� ���������� ó���� �� �ֽ��ϴ�.<br>������ ȭ��� �ε巯�� ���������� ��ð� ��뿡�� �Ƿΰ��� �����ϴ�.<br>������� �ϼ����� �Բ� ����ϴ� ����ڿ��� ��õ�մϴ�.]'
WHERE product_code = '2000AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Fold6�� ��ȭ�� ����� ��Ƽ�½�ŷ�� ������ ���� ������ ����Ʈ���Դϴ�.<br>�� ȭ�鿡�� ���� ���� ���ÿ� ��� ����/�н� ȿ���� ���� �� �ֽ��ϴ�.<br>���� �����̳� ����å �� ������ �Һ񿡵� �������� �����ϴ�.<br>�޴뼺�� ���꼺�� ��� ���ϴ� ����ڿ��� �� �½��ϴ�.]'
WHERE product_code = '2000GX';

UPDATE tbl_product
SET product_desc = q'[Galaxy A17�� �Ǽ� �ִ� ���ɰ� �ո����� ���ݴ븦 ��ǥ�� �� ���Դϴ�.<br>�ϻ����� SNS, ������, ���� ���� �� �⺻ ��뿡 ����� �뷱���� �����մϴ�.<br>����� �����ΰ� ������ ��밨���� �δ� ���� �����ϱ� ���ƿ�.<br>���������̳� �θ�� ���������ε� ������ �������Դϴ�.]'
WHERE product_code = '2045GX';

UPDATE tbl_product
SET product_desc = q'[testimageproduct10000�� �̹��� ���ε�/��� Ȯ���� ���� �׽�Ʈ ��ǰ�Դϴ�.<br>��ǰ �� ȭ�鿡�� �ٹٲ�(<br>) �������� �������� Ȯ���� �� �ֽ��ϴ�.<br>����� ��� �� ���� �̹��� ��ȯ ��� ���˿��� Ȱ���ϼ���.<br>� �ݿ� �� ���� ��ǰ �������� ��ü�� �ʿ��մϴ�.]'
WHERE product_code = '2048AD';

UPDATE tbl_product
SET product_desc = q'[iPhone 16 Pro�� ���ɰ� �Կ� ǰ���� �߽��ϴ� ����ڿ��� ����ȭ�� ���Դϴ�.<br>���� ó�� �ӵ��� ��ȭ�� ���� �Կ�/�������� �δ��� �����ϴ�.<br>������ ǥ���� �پ ī�޶�� �ϻ� ��Ϻ��� ���� �Կ����� Ȱ�뵵�� �����ϴ�.<br>�����̾� �����ΰ� �ϼ����� ���ϴ� ����ڿ��� ��õ�մϴ�.]'
WHERE product_code = '2100AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Flip6�� ����Ʈ�� �޴뼺�� ������ Ư���� Ȱ�뼺�� �����ϴ� ���Դϴ�.<br>Ŀ�� ȭ�鿡�� �˸� Ȯ�ΰ� ������ ������ ������ ���Ǽ��� �پ�ϴ�.<br>��ġ ���̵� �پ��� ������ �Կ��� �� �־� ����/���̷α׿� �����մϴ�.<br>��Ÿ�ϰ� �ǿ뼺�� ���ÿ� ���ϴ� ����ڿ��� �� �½��ϴ�.]'
WHERE product_code = '2100GX';

UPDATE tbl_product
SET product_desc = q'[iPhone 16 Pro Max�� ��ȭ��� ������ ������ ���ÿ� ���ϴ� ����ڿ��� �����մϴ�.<br>���� ����� ���ӿ��� ���԰��� ����, ���͸� ��� �ð��� �˳��� ���Դϴ�.<br>���α� �Կ� ������� ����/���� ������ ���ۿ��� Ȱ���ϱ� �����ϴ�.<br>�Ϸ� ���� ����Ʈ���� ���� ����ϴ� ����ڿ��� ��õ�մϴ�.]'
WHERE product_code = '2200AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy S24 Ultra�� ��Ʈ�� ���ξ��ٿ� ������ ���ɰ� ī�޶� Ȱ�뼺�� �����մϴ�.<br>������ ��ȭ������ ������ ����� �۾� ȿ���� ���ÿ� ������ų �� �־��.<br>���� �� �����̳� ��Ƽ�½�ŷ������ �������� �����ս��� ����� �� �ֽ��ϴ�.<br>�����̾� �÷��׽� ������ ���ϴ� ����ڿ��� �����մϴ�.]'
WHERE product_code = '2200GX';

UPDATE tbl_product
SET product_desc = q'[TestImageProduct44�� �̹��� ��°� �� ������ UI ������ ���� �׽�Ʈ ��ǰ�Դϴ�.<br>��ǰ ���� �ٹٲ� ó��, ���̾ƿ� ���� ���� ���� Ȯ���ϱ� �����ϴ�.<br>�ɼ�/����/��� �������� �Բ� �׽�Ʈ�ϸ� ��ü �帧 ������ ������ �˴ϴ�.<br>�ǻ�� ������ ���� �������� ������Ʈ�ϼ���.]'
WHERE product_code = '2314AS';

UPDATE tbl_product
SET product_desc = q'[appleTestphone11�� ���� �迭 ��ǰ ���/���� ��� �׽�Ʈ�� �����Դϴ�.<br>������ ���������� CRUD ���� �� ������ ���ε��� ������ �� ����� �� �ֽ��ϴ�.<br>Ư�� �� ������ �ٹٲ�(<br>) ó���� ȭ�� ��� Ȯ�ο� �����մϴ�.<br>� ���� ������ ���� ��ǰ ������ ��ü�ϼ���.]'
WHERE product_code = '2345AE';

UPDATE tbl_product
SET product_desc = q'[testimageproduct1623�� �� ���� �ٹٲ� �� �̹��� ǥ�ø� �׽�Ʈ�ϱ� ���� ��ǰ�Դϴ�.<br>��ǰ �� ȭ�鿡�� <br> �±װ� ���� �ٹٲ����� �ݿ��Ǵ��� Ȯ���غ�����.<br>����� Ŭ�� �� ���� �̹��� ����, Ȯ��/������ ó���� �Բ� �����ϸ� �����ϴ�.<br>�׽�Ʈ �Ϸ� �Ŀ��� ��� �������� ������Ʈ�ϼ���.]'
WHERE product_code = '2352SQ';

UPDATE tbl_product
SET product_desc = q'[iPhone 15�� �������� ���ɰ� ��뼺�� �������� ������ ����޴� ���Դϴ�.<br>�ϻ� ������ �Կ�, ��Ʈ���ֱ��� ���������� ���� ���� ������ �����մϴ�.<br>������ ���۰��� ����ȭ�� �ý������� ��ð� ��뿡�� �������� �����ϴ�.<br>�ո����� ������ ���ϴ� ����ڿ��� ��õ�մϴ�.]'
WHERE product_code = '3000AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Fold5�� ������ ��ȭ���� Ȱ���� ���꼺�� ��Ƽ�½�ŷ�� ��ȭ�� ���Դϴ�.<br>����, �޽���, �������� ���ÿ� ��� ȿ�������� �۾��� �� �־��.<br>��ȭ�� ������ ���� �����ϸ� �̵� �߿��� �º�ó�� Ȱ�� �����մϴ�.<br>������ �������θ�Ʈ�� �Բ� ���� ����ڿ��� ��õ�մϴ�.]'
WHERE product_code = '3000GX';

UPDATE tbl_product
SET product_desc = q'[TestSamsungPhone4432�� �Ｚ �޴��� ��ǰ �帧 ������ ���� �׽�Ʈ ��ǰ�Դϴ�.<br>��ǰ �� ���������� �� ����/���� �� ������ �ڿ������� ��µǴ��� Ȯ���ϼ���.<br>���� ǥ��(õ ���� �޸�)�� �ɼ�/��� ó������ ���� �����ϸ� �ϼ����� �ö󰩴ϴ�.<br>� �ݿ� ������ �ǻ�ǰ ����� ��å�� �´� �������� ��ü�ϼ���.]'
WHERE product_code = '3091AP';

UPDATE tbl_product
SET product_desc = q'[iPhone 15 Pro�� ������ ������ ������ ���ϴ� ����ڿ��� ������ ���� ���Դϴ�.<br>���� ó�� �ӵ��� ����/���� ����, ���� �� ��뿡�� �δ��� �����ϴ�.<br>ī�޶� Ȱ�뼺�� �پ �ϻ� ��Ϻ��� ���� �Կ����� �������� �����ϴ�.<br>�����̾� ���� �ܬ�ެ�Ѭܬ��ϰ� ���� ���� ����ڿ��� ��õ�մϴ�.]'
WHERE product_code = '3100AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy Z Flip5�� ���� ��̿� �޴뼺�� ��� ���� �ø��� ������ ���Դϴ�.<br>Ŀ�� ȭ���� ���� ������ �˸��� Ȯ���ϰ� ���� ���� ����� ������ �� �ֽ��ϴ�.<br>�پ��� ������ ���� �Կ��� �� �־� ����/���� �Կ� Ȱ�뵵�� �����ϴ�.<br>���� �ִ� �����ΰ� �ǿ뼺�� �Բ� ���ϴ� ����ڿ��� �� �½��ϴ�.]'
WHERE product_code = '3100GX';

UPDATE tbl_product
SET product_desc = q'[iPhone 15 Pro Max�� ��ȭ��� ������ ������ ���ϴ� ����ڿ��� ������ ���Դϴ�.<br>���� ����, ����, �۾� �� �پ��� Ȱ�뿡�� ���԰��� �پ�ϴ�.<br>��� �Կ� ������� ����/���� ������ ���ۿ��� �����մϴ�.<br>���͸� ��� �ð��� �߿��ϰ�, ū ȭ�� ��ȣ���� ���� ����ڿ��� ��õ�մϴ�.]'
WHERE product_code = '3200AP';

UPDATE tbl_product
SET product_desc = q'[Galaxy S23 Ultra�� �����̾� ���ɰ� ī�޶� ������� ���� ��Ʈ�� ���ξ� ���Դϴ�.<br>������ ���÷��̷� ������ ����� �۾� ȿ���� ���ÿ� ����ø� �� �ֽ��ϴ�.<br>���� �۾������� �������� �����ս��� ������ ��� �������Ե� �����մϴ�.<br>�÷��׽� ������ ���ϴ� ����ڿ��� ������ ��õ�Ǵ� �������Դϴ�.]'
WHERE product_code = '3200GX';

UPDATE tbl_product
SET product_desc = q'[TestImageProduct55�� �̹���/���� ��� �׽�Ʈ�� ���� ���� ��ǰ�Դϴ�.<br>�� ���������� <br> �ٹٲ��� ���� �ݿ��Ǵ����� UI ���� ���¸� Ȯ���ϼ���.<br>�̹��� ������, ����� ����, Ȯ�� ��� �� ����Ʈ ���� ���˿��� Ȱ�� �����մϴ�.<br>�׽�Ʈ �Ϸ� �Ŀ��� ��� ��ǰ �������� ��ü�ϴ� ���� �����մϴ�.]'
WHERE product_code = '4039AD';
commit;


select * from tbl_product;
=======
-------- ?��?���? ?��?�� --------

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

-- status 컬럼 ?��?��?���? ?��?��
ALTER TABLE TBL_MEMBER
  MODIFY (STATUS DEFAULT 0);
  
-- idle 컬럼 ?��?��?���? ?��?��
ALTER TABLE TBL_MEMBER
  MODIFY (IDLE DEFAULT 0);
  

create table tbl_member_backup
as
select * from tbl_member;

-- ?��???�� ?��?��
CREATE SEQUENCE SEQ_TBL_MEMBER_USERSEQ
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- userseq 컬럼 추�?
alter table tbl_member
add userseq number;

update tbl_member set userseq = SEQ_TBL_MEMBER_USERSEQ.nextval
where MEMBER_ID = 'eomjh';

update tbl_member set userseq = SEQ_TBL_MEMBER_USERSEQ.nextval
where MEMBER_ID = 'smon0376';

-- userseq 컬럼 ?��?��?��?��?�� ?��?��
alter table tbl_member
add constraint UQ_TBL_MEMBER_USERSEQ unique(userseq);

-- userseq 컬럼 not null ?��?��
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

-- IMAGE_PATH 컬럼 추�?
ALTER TABLE TBL_PRODUCT
ADD (IMAGE_PATH VARCHAR2(200));

-- IMAGE_PATH 컬럼 NOT NULL ?��?��
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

-------- ?��???�� ?��?�� --------

CREATE SEQUENCE SEQ_TBL_COUPON_COUPON_CATEGORY_NO
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- 컬럼 ?��?�� �?�?
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

-- IMAGE_PATH 컬럼 ?��?��
ALTER TABLE TBL_PRODUCT_OPTION
DROP COLUMN IMAGE_PATH;

-------- ?��???�� ?��?�� --------

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

-------- ?��???�� ?��?�� --------

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

-------- ?��???�� ?��?�� --------

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

-------- ?��???�� ?��?�� --------

CREATE SEQUENCE SEQ_TBL_ORDERS_ORDER_ID
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE SEQ_TBL_ORDERS_DELIVERY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- 컬럼 추�?
ALTER TABLE TBL_ORDERS
ADD (
  DELIVERY_NUMBER     VARCHAR2(20),
  DELIVERY_STARTDATE  DATE,
  DELIVERY_ENDDATE    DATE
);


-- 체크?��?�� 추�?
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

-------- ?��???�� ?��?�� --------

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

-------- ?��???�� ?��?�� --------

CREATE SEQUENCE SEQ_TBL_REVIEW_REVIEW_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;

-- RATING, DELETED_YN, DELETED_AT, DELETED_BT 컬럼 추�?
ALTER TABLE TBL_REVIEW ADD (
  RATING      NUMBER(2,1)             NOT NULL,
  DELETED_YN  NUMBER(1)     DEFAULT 0 NOT NULL,
  DELETED_AT  DATE          NULL,
  DELETED_BY  VARCHAR2(40)  NULL
);

-- RATING, DELETED_YN 컬럼?�� 체크?��?�� 추�?
ALTER TABLE TBL_REVIEW
ADD CONSTRAINT CK_TBL_REVIEW_RATING
CHECK (
  RATING BETWEEN 0.5 AND 5.0
  AND (RATING*2 = TRUNC(RATING*2))
);

ALTER TABLE TBL_REVIEW
ADD CONSTRAINT CK_TBL_REVIEW_DELETED_YN
CHECK (DELETED_YN IN (0,1));


-- review_title 컬럼 추�?
ALTER TABLE TBL_REVIEW
ADD (review_title VARCHAR2(100));

-- review_title 컬럼 NOT NULL ?��?��
ALTER TABLE TBL_REVIEW
MODIFY (review_title VARCHAR2(100) NOT NULL);

-- ?��?��?�� ?��?�� 추�??��

CREATE UNIQUE INDEX UQ_TBL_REVIEW_FK_ORDER_DETAIL_ID
ON TBL_REVIEW ( CASE WHEN deleted_yn = 0 THEN fk_order_detail_id END );

-- 컬럼 ???�� �?�?
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

-------- ?��???�� ?��?�� --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- 체크?��?�� ?��?��
ALTER TABLE TBL_INQUIRY
DROP CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS;

-- 체크?��?�� ?��?��
ALTER TABLE TBL_INQUIRY
ADD CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS
CHECK (REPLY_STATUS IN (0,1,2));

-- REPLY_STATUS ?��?��?���? 1�? �?�?
ALTER TABLE TBL_INQUIRY
MODIFY (REPLY_STATUS DEFAULT 1);


-- deleted_yn, deleted_at, deleted_by, is_secret 컬럼 추�?
ALTER TABLE tbl_inquiry ADD (
  deleted_yn NUMBER(1) DEFAULT 0 NOT NULL,
  deleted_at DATE,
  deleted_by VARCHAR2(40),
  is_secret  NUMBER(1) DEFAULT 0 NOT NULL
);

-- deleted_yn, is_secret 컬럼 체크?��?�� 추�?
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


------ ?��?��?��?���? ?���? 출력?���?
select *
from tbl_product
order by product_name;

------ ?��?��?��?��?��?���? ?���? 출력?���?
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ?��?��?��17 ?��?��?���?
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '?��?��?��17?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '?��?��?��17 Pro?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '?��?��?��17 Pro Max?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');

-- ?��?��?��16 ?��?��?���?
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '?��?��?��16?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '?��?��?��16 Pro?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '?��?��?��16 Pro Max?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
commit;

-- ?��?��?��15 ?��?��?���?
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '?��?��?��15?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '?��?��?��15 Pro?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '?��?��?��15 Pro Max?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 갤럭?��?�� ?��?��?���?
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', '갤럭?�� Z?��?��7?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', '갤럭?�� Z?���?7?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', '갤럭?�� s25 ?��?��?��?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
commit;

---------------- 갤럭?��6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', '갤럭?�� Z?��?��6?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', '갤럭?�� Z?���?6?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', '갤럭?�� s24 ?��?��?��?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
commit;

---------------- 갤럭?��5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', '갤럭?�� Z?��?��5?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', '갤럭?�� Z?���?5?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', '갤럭?�� s23 ?��?��?��?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------?��?��?�� ?��?��?��?�� ?��?��?�� ?��?��----------------------------------------------------
--?��?��?��17 ?��?��?���?
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

--?��?��?��17 Pro ?��?��?��?��
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

--?��?��?��17 Pro Max ?��?��?��?��
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



--?��?��?��16 ?��?��?��?��
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

--?��?��?��16 Pro ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ?��?��?��16 Pro Max ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--?��?��?��15 ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--?��?��?��15 Pro ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--?��?��?�� 15 Pro Max ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- ?��?��?��?�� ?��보�? ?��?���? 조인?��?�� 같이 출력?���?
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- ?��?��?��?���? ?���? 출력?���?
select * from tbl_product;
commit;

---------------------------------------갤럭?�� ?��?��?��?�� ?��?��?�� ?��?��----------------------------------------------------
-- Galaxy Z Fold7 ?��?��?��?��
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


-- Galaxy Z Flip7 ?��?��?��?��
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


-- Galaxy S25 Ultra ?��?��?��?��
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

-- 갤럭?�� z?��?��6 ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- 갤럭?�� z?���?6 ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- 갤럭?�� s24 ?��?��?�� ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- 갤럭?�� ?��?��5 ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- 갤럭?�� ?���?5 ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- 갤럭?�� s23 ?��?��?�� ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- ?��?��?��?�� ?��보�? ?��?���? 조인?��?�� 같이 출력?���?
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ?��?��?��?���? ?���? 출력?���?
select * from tbl_product;
commit;


--?��?��?�� ???�� ?��보�? �?격이 ?��?�� ?��?? ?��?��?�� ?��보�?? 조인?��?�� 출력
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '?��매중'
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


------ ?��?��?��?���? ?���? 출력?���?
select *
from tbl_product
order by product_name;

------ ?��?��?��?��?��?���? ?���? 출력?���?
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';


--delete from tbl_product where product_code = '1000AP';
--commit;

-- ?��?��?��17 ?��?��?���?
insert into tbl_product
values('1000AP', 'iPhone17', 'Apple', '?��?��?��17?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('1100AP', 'iPhone17 Pro', 'Apple', '?��?��?��17 Pro?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('1200AP', 'iPhone17 Pro Max', 'Apple', '?��?��?��17 Pro Max?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');

-- ?��?��?��16 ?��?��?���?
insert into tbl_product
values('2000AP', 'iPhone16', 'Apple', '?��?��?��16?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('2100AP', 'iPhone16 Pro', 'Apple', '?��?��?��16 Pro?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('2200AP', 'iPhone16 Pro Max', 'Apple', '?��?��?��16 Pro Max?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
commit;

-- ?��?��?��15 ?��?��?���?
insert into tbl_product
values('3000AP', 'iPhone15', 'Apple', '?��?��?��15?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('3100AP', 'iPhone15 Pro', 'Apple', '?��?��?��15 Pro?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('3200AP', 'iPhone15 Pro Max', 'Apple', '?��?��?��15 Pro Max?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
commit;

-------------------------------------------------------------------------------------------------------------------------------------------------
-- 갤럭?��?�� ?��?��?���?
insert into tbl_product
values('1000GX', 'Galaxy Z Fold7', 'Galaxy', '갤럭?�� Z?��?��7?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('1100GX', 'Galaxy Z Flip7', 'Galaxy', '갤럭?�� Z?���?7?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('1200GX', 'Galaxy S25 Ultra', 'Galaxy', '갤럭?�� s25 ?��?��?��?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
commit;

---------------- 갤럭?��6, 24
insert into tbl_product
values('2000GX', 'Galaxy Z Fold6', 'Galaxy', '갤럭?�� Z?��?��6?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('2100GX', 'Galaxy Z Flip6', 'Galaxy', '갤럭?�� Z?���?6?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('2200GX', 'Galaxy S24 Ultra', 'Galaxy', '갤럭?�� s24 ?��?��?��?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
commit;

---------------- 갤럭?��5, 23
insert into tbl_product
values('3000GX', 'Galaxy Z Fold5', 'Galaxy', '갤럭?�� Z?��?��5?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('3100GX', 'Galaxy Z Flip5', 'Galaxy', '갤럭?�� Z?���?5?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
insert into tbl_product
values('3200GX', 'Galaxy S23 Ultra', 'Galaxy', '갤럭?�� s23 ?��?��?��?�� ???�� ?��명입?��?��. ?��?�� ?��명입?��?��. ?��중에 update�? 바꾸?��?��.', '?��매중', 'test.jpg');
commit;


select *
from tbl_product
order by product_name;

select * from tbl_product_option;
-- delete from tbl_product_option where fk_product_code = '1200AP';
-- update tbl_product_option set color = 'black' where option_id = 1;



---------------------------------------?��?��?�� ?��?��?��?�� ?��?��?�� ?��?��----------------------------------------------------
--?��?��?��17 ?��?��?���?
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

--?��?��?��17 Pro ?��?��?��?��
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

--?��?��?��17 Pro Max ?��?��?��?��
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



--?��?��?��16 ?��?��?��?��
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

--?��?��?��16 Pro ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2100AP', 'Red',   '512GB', '2000000', 35);
commit;

-- ?��?��?��16 Pro Max ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '256GB', '1980000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '256GB', '1980000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Black', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'White', '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Blue',  '512GB', '2288000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '2200AP', 'Red',   '512GB', '2288000', 35);
commit;

--?��?��?��15 ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '256GB', '1400000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '256GB', '1400000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Black', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'White', '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Blue',  '512GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3000AP', 'Red',   '512GB', '1700000', 35);
commit;

--?��?��?��15 Pro ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '256GB', '1700000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '256GB', '1700000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Black', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'White', '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Blue',  '512GB', '2000000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3100AP', 'Red',   '512GB', '2000000', 35);
commit;

--?��?��?�� 15 Pro Max ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '256GB', '1900000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '256GB', '1900000', 35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Black', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'White', '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Blue',  '512GB', '2200000', 35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval, '3200AP', 'Red',   '512GB', '2200000', 35);
commit;

-- ?��?��?��?�� ?��보�? ?��?���? 조인?��?�� 같이 출력?���?
SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;

-- ?��?��?��?���? ?���? 출력?���?
select * from tbl_product;
commit;

---------------------------------------갤럭?�� ?��?��?��?�� ?��?��?�� ?��?��----------------------------------------------------
-- Galaxy Z Fold7 ?��?��?��?��
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


-- Galaxy Z Flip7 ?��?��?��?��
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


-- Galaxy S25 Ultra ?��?��?��?��
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

-- 갤럭?�� z?��?��6 ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','256GB','2229000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','256GB','2229000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Black','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','White','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Blue','512GB','2469000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2000GX','Red','512GB','2469000',35);

-- 갤럭?�� z?���?6 ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','256GB','1485000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','256GB','1485000',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Black','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','White','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Blue','512GB','1643000',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2100GX','Red','512GB','1643000',35);

-- 갤럭?�� s24 ?��?��?�� ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','256GB','1698400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','256GB','1698400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Black','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','White','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Blue','512GB','1841400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'2200GX','Red','512GB','1841400',35);

-- 갤럭?�� ?��?��5 ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','256GB','2097700',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','256GB','2097700',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Black','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','White','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Blue','512GB','2336400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3000GX','Red','512GB','2336400',35);

-- 갤럭?�� ?���?5 ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','256GB','1399200',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','256GB','1399200',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Black','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','White','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Blue','512GB','1522400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3100GX','Red','512GB','1522400',35);

-- 갤럭?�� s23 ?��?��?�� ?��?��?���?
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','256GB','1599400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','256GB','1599400',35);

insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Black','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','White','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Blue','512GB','1720400',35);
insert into tbl_product_option values (SEQ_TBL_PRODUCT_OPTION_OPTION_ID.nextval,'3200GX','Red','512GB','1720400',35);

-- ?��?��?��?�� ?��보�? ?��?���? 조인?��?�� 같이 출력?���?
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ?��?��?��?���? ?���? 출력?���?
select * from tbl_product;
commit;


--?��?��?�� ???�� ?��보�? �?격이 ?��?�� ?��?? ?��?��?�� ?��보�?? 조인?��?�� 출력
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '?��매중'
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



-- ?��?��?��?��?��?��블의 ?��?��조건?�� ?��?��?���?
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT_OPTION';

-- ?��?��?��?��?��?��블의 �?�? 체크조건 ?��?��
ALTER TABLE tbl_product_option DROP CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE;

-- ?��?��?��?��?��?��블의 pric 컬럼 ?��?��
ALTER TABLE tbl_product_option
DROP COLUMN price;

-- ?��?��?��?��?��?��블에 plus_price 컬럼 추�?(?��?��조건 0�? 같거?�� ?��)
ALTER TABLE tbl_product_option
ADD plus_price NUMBER DEFAULT 0
    CONSTRAINT ck_tbl_product_option_plus_price CHECK (plus_price >= 0);
    
select * from tbl_product_option;


-- ?��?��?��?��블의 ?��?��조건?�� ?��?��?���?
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT';

-- ?��?��?��?��블에 price 컬럼 추�?(?��?��조건 0보다 커야 ?��)
ALTER TABLE tbl_product
ADD price NUMBER
    CONSTRAINT ck_tbl_product_price CHECK (price > 0);

select product_code, product_name, price
from tbl_product
where brand_name = 'Samsung'
order by product_code;

-- ?��?��?��?��블의 �?격컬?��?�� �? ?��?��?��?��?���?
update tbl_product set price = 2200000
where product_code = '3000GX';

commit;



-- ?��?��?��?�� ?��보�? ?��?���? 조인?��?�� 같이 출력?���?
SELECT P.product_code, option_id, P.product_name,storage_size, price, plus_price
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Samsung' and storage_size = '512GB'
ORDER BY product_code, storage_size desc;

-- ?��?��?��?��?��?��블의 추�?금액 컬럼?�� �? ?��?��?��?��?���?
update tbl_product_option set plus_price = 150000
where fk_product_code = '2100GX' and storage_size = '512GB';

commit;


--(?��?��코드,?��?���?,브랜?���?,?��미�?경로,�?�?)
select product_code, product_name, brand_name, image_path, price, sale_status
from tbl_product
where sale_status='?��매중';


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


-- ?��?��?��?��?��?��...
-- ?��?��?��?��?��?��...

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

-------- ?��???�� ?��?�� --------

CREATE SEQUENCE SEQ_TBL_INQUIRY_INQUIRY_NUMBER
START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;



-- 체크?��?�� ?��?��
ALTER TABLE TBL_INQUIRY
DROP CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS;

-- 체크?��?�� ?��?��
ALTER TABLE TBL_INQUIRY
ADD CONSTRAINT CK_TBL_INQUIRY_REPLY_STATUS
CHECK (REPLY_STATUS IN (0,1,2));

-- REPLY_STATUS ?��?��?���? 1�? �?�?
ALTER TABLE TBL_INQUIRY
MODIFY (REPLY_STATUS DEFAULT 1);


-- deleted_yn, deleted_at, deleted_by, is_secret 컬럼 추�?
ALTER TABLE tbl_inquiry ADD (
  deleted_yn NUMBER(1) DEFAULT 0 NOT NULL,
  deleted_at DATE,
  deleted_by VARCHAR2(40),
  is_secret  NUMBER(1) DEFAULT 0 NOT NULL
);

-- deleted_yn, is_secret 컬럼 체크?��?�� 추�?
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_deleted_yn CHECK (deleted_yn IN (0,1));
ALTER TABLE tbl_inquiry ADD CONSTRAINT ck_tbl_inquiry_is_secret  CHECK (is_secret  IN (0,1));


-- 컬럼 ???�� �?�?
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


-------- ?��???�� ?��?�� --------

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


------ ?��?��?��?���? ?���? 출력?���?
select *
from tbl_product
order by product_name;

------ ?��?��?��?��?��?���? ?���? 출력?���?
select * from tbl_product_option;

SELECT P.product_code, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
ORDER BY product_code;
--WHERE P.product_code = '1200GX' AND storage_size= '512GB';



-- ?��?��?��?�� ?��보�? ?��?���? 조인?��?�� 같이 출력?���?
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ?��?��?��?���? ?���? 출력?���?
select * from tbl_product;
commit;


--?��?��?�� ???�� ?��보�? �?격이 ?��?�� ?��?? ?��?��?�� ?��보�?? 조인?��?�� 출력
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '?��매중'
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


------ ?��?��?��?���? ?���? 출력?���?
select *
from tbl_product
order by product_name;

------ ?��?��?��?��?��?���? ?���? 출력?���?
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



-- ?��?��?��?�� ?��보�? ?��?���? 조인?��?�� 같이 출력?���?
SELECT P.product_code, P.brand_name, option_id, P.product_name, color, storage_size, price, stock_qty
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Apple'
ORDER BY product_code;

commit;


-- ?��?��?��?���? ?���? 출력?���?
select * from tbl_product;
commit;


--?��?��?�� ???�� ?��보�? �?격이 ?��?�� ?��?? ?��?��?�� ?��보�?? 조인?��?�� 출력
SELECT
    p.product_code,
    p.product_name,
    p.brand_name,
    p.image_path,
    MIN(o.price) AS min_price
FROM tbl_product p
JOIN tbl_product_option o
  ON p.product_code = o.fk_product_code
WHERE p.sale_status = '?��매중'
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



-- ?��?��?��?��?��?��블의 ?��?��조건?�� ?��?��?���?
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT_OPTION';

-- ?��?��?��?��?��?��블의 �?�? 체크조건 ?��?��
ALTER TABLE tbl_product_option DROP CONSTRAINT CK_TBL_PRODUCT_OPTION_PRICE;

-- ?��?��?��?��?��?��블의 pric 컬럼 ?��?��
ALTER TABLE tbl_product_option
DROP COLUMN price;

-- ?��?��?��?��?��?��블에 plus_price 컬럼 추�?(?��?��조건 0�? 같거?�� ?��)
ALTER TABLE tbl_product_option
ADD plus_price NUMBER DEFAULT 0
    CONSTRAINT ck_tbl_product_option_plus_price CHECK (plus_price >= 0);
    
select * from tbl_product_option;


-- ?��?��?��?��블의 ?��?��조건?�� ?��?��?���?
SELECT constraint_name,
       constraint_type,
       table_name,
       search_condition
FROM user_constraints
WHERE table_name = 'TBL_PRODUCT';

-- ?��?��?��?��블에 price 컬럼 추�?(?��?��조건 0보다 커야 ?��)
ALTER TABLE tbl_product
ADD price NUMBER
    CONSTRAINT ck_tbl_product_price CHECK (price > 0);

select product_code, product_name, price
from tbl_product
where brand_name = 'Samsung'
order by product_code;

-- ?��?��?��?��블의 �?격컬?��?�� �? ?��?��?��?��?���?
update tbl_product set price = 2200000
where product_code = '3000GX';

commit;



-- ?��?��?��?�� ?��보�? ?��?���? 조인?��?�� 같이 출력?���?
SELECT P.product_code, option_id, P.product_name,storage_size, price, plus_price
FROM tbl_product_option O
JOIN tbl_product P
ON P.product_code = O.fk_product_code
WHERE brand_name = 'Samsung' and storage_size = '512GB'
ORDER BY product_code, storage_size desc;

-- ?��?��?��?��?��?��블의 추�?금액 컬럼?�� �? ?��?��?��?��?���?
update tbl_product_option set plus_price = 150000
where fk_product_code = '2100GX' and storage_size = '512GB';

commit;


--(?��?��코드,?��?���?,브랜?���?,?��미�?경로,�?�?)
select product_code, product_name, brand_name, image_path, price, sale_status
from tbl_product
where sale_status='?��매중';


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


-- ?��?��?��?��?��?��...
-- ?��?��?��?��?��?��...

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

insert into tbl_orders(1002, dog, sysdate, 4950000, 50000, 'PAID', '?��?�� ?��?���? 법원�? 128 101?��', ?��?��?��?��?��, 010-0000-0000, 0);
insert into tbl_order_detail(1003, 149, 1002, 1, 2400000, 0, 'Galaxy Z Fold7', 'Samsung');
insert into tbl_order_detail(1004, 196, 1002, 1, 1700000, 0, 'iPhone15 Pro', 'Apple');

insert into tbl_review(1,196,1000,'번창?��?��?��',sysdate,5,0,null,null,'?��?���? ?��?��?��');

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

select * from tbl_review;

update tbl_orders set order_date = sysdate - 365, delivery_number = 'D20250120-1', delivery_startdate = sysdate-365, delivery_enddate = sysdate-364
where order_id = 495;

update tbl_orders set order_date = sysdate, delivery_number = null, delivery_startdate = null, delivery_enddate = null


update tbl_review set writeday = sysdate -364
where review_number = 59;
commit;

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
   tbl_product 데이터 INSERT
   ========================= */
select * from tbl_product;
select * from tbl_product_option;

INSERT INTO tbl_product
(product_code, product_name, brand_name, product_desc, sale_status, image_path, price)
VALUES
('1000AP', 'iPhone17', 'Apple',
 q'[iPhone 17은 일상부터 업무까지 안정적으로 사용할 수 있는 스마트폰입니다.<br>
선명한 디스플레이와 빠른 반응성으로 앱 실행이 부드럽습니다.<br>
사진과 영상 촬영에서도 자연스러운 색감을 제공합니다.<br>
데일리 스마트폰으로 활용하기에 충분한 완성도를 갖췄습니다.]',
 '판매중', 'Main_iphone17.jpg', 1000000);

--update tbl_product set sale_status = '판매중'
--where product_code = '1000AP';

INSERT INTO tbl_product
VALUES
('1100AP', 'iPhone17 Pro', 'Apple',
 q'[iPhone 17 Pro는 고성능 작업과 촬영에 특화된 프리미엄 모델입니다.<br>
강력한 성능으로 멀티태스킹과 고사양 앱 실행이 원활합니다.<br>
카메라 성능이 강화되어 영상 촬영에도 적합합니다.<br>
완성도 높은 디자인과 성능을 원하는 사용자에게 추천합니다.]',
 '판매중', 'Main_iphone17Pro.jpg', 1100000);
 
 
INSERT INTO tbl_product
VALUES
('1200AP', 'iPhone17 Pro Max', 'Apple',
 q'[iPhone 17 Pro Max는 대화면과 긴 배터리 사용 시간을 제공하는 모델입니다.<br>
영상 감상과 게임에서 몰입감 있는 화면을 경험할 수 있습니다.<br>
고성능 칩셋으로 장시간 사용에도 안정적인 성능을 유지합니다.<br>
큰 화면을 선호하는 사용자에게 적합한 스마트폰입니다.]',
 '판매중', 'Main_iphone17ProMax.jpg', 1200000);

INSERT INTO tbl_product
VALUES
('2000AP', 'iPhone16', 'Apple',
 q'[iPhone 16은 균형 잡힌 성능과 사용성을 제공하는 모델입니다.<br>
일상적인 앱 사용과 멀티미디어 감상에 적합합니다.<br>
부드러운 인터페이스로 장시간 사용에도 피로도가 낮습니다.<br>
가성비를 고려한 선택지로 추천됩니다.]',
 '판매중', 'Main_iphone16.jpg', 2000000);

INSERT INTO tbl_product
VALUES
('2100AP', 'iPhone16 Pro', 'Apple',
 q'[iPhone 16 Pro는 성능과 카메라 활용도를 중시한 모델입니다.<br>
사진과 영상 촬영에서 디테일한 표현이 가능합니다.<br>
고사양 앱과 작업에서도 안정적인 퍼포먼스를 제공합니다.<br>
프리미엄 스마트폰을 원하는 사용자에게 적합합니다.]',
 '판매중', 'Main_iphone16Pro.jpg', 2100000);

INSERT INTO tbl_product
VALUES
('2200AP', 'iPhone16 Pro Max', 'Apple',
 q'[iPhone 16 Pro Max는 넓은 화면과 고성능을 동시에 제공합니다.<br>
콘텐츠 감상과 작업에서 높은 몰입감을 제공합니다.<br>
배터리 효율이 좋아 하루 종일 사용이 가능합니다.<br>
최상위 모델을 찾는 사용자에게 추천합니다.]',
 '판매중', 'Main_iphone16ProMax.jpg', 2200000);

INSERT INTO tbl_product
VALUES
('3000AP', 'iPhone15', 'Apple',
 q'[iPhone 15는 안정적인 성능으로 꾸준히 사랑받는 모델입니다.<br>
일상 사용에 충분한 퍼포먼스를 제공합니다.<br>
사진, 영상, SNS 활용에 무난한 선택지입니다.<br>
실속 있는 스마트폰을 찾는 분께 추천합니다.]',
 '판매중', 'Main_iphone15.jpg', 3000000);

INSERT INTO tbl_product
VALUES
('3100AP', 'iPhone15 Pro', 'Apple',
 q'[iPhone 15 Pro는 가볍고 강력한 성능을 갖춘 모델입니다.<br>
고급 카메라 기능으로 촬영 활용도가 높습니다.<br>
빠른 처리 속도로 다양한 작업을 수행할 수 있습니다.<br>
프리미엄 사용 경험을 원하는 사용자에게 적합합니다.]',
 '판매중', 'Main_iphone15Pro.jpg', 3100000);

INSERT INTO tbl_product
VALUES
('3200AP', 'iPhone15 Pro Max', 'Apple',
 q'[iPhone 15 Pro Max는 대형 디스플레이와 고성능이 특징입니다.<br>
영상 감상과 게임 플레이에서 뛰어난 몰입감을 제공합니다.<br>
장시간 사용에도 안정적인 퍼포먼스를 유지합니다.<br>
대화면 스마트폰을 선호하는 사용자에게 추천합니다.]',
 '판매중', 'Main_iphone15ProMax.jpg', 3200000);

INSERT INTO tbl_product
VALUES
('1000GX', 'Galaxy Z Fold7', 'Samsung',
 q'[Galaxy Z Fold7은 접이식 대화면을 제공하는 프리미엄 폴더블 스마트폰입니다.<br>
멀티태스킹과 문서 작업에 최적화된 화면 구성을 지원합니다.<br>
영상 감상과 업무 활용도가 매우 높습니다.<br>
생산성을 중시하는 사용자에게 적합합니다.]',
 '판매중', 'Main_galaxy_z_fold7.jpg', 1000000);

INSERT INTO tbl_product
VALUES
('1100GX', 'Galaxy Z Flip7', 'Samsung',
 q'[Galaxy Z Flip7은 컴팩트한 폴더블 디자인이 특징입니다.<br>
휴대성이 뛰어나고 스타일리시한 사용이 가능합니다.<br>
셀피 촬영과 각도 조절 촬영에 유리합니다.<br>
개성 있는 스마트폰을 원하는 사용자에게 추천합니다.]',
 '판매중', 'Main_galaxy_z_flip7.jpg', 1100000);

INSERT INTO tbl_product
VALUES
('1200GX', 'Galaxy S25 Ultra', 'Samsung',
 q'[Galaxy S25 Ultra는 최상위 성능을 제공하는 울트라 모델입니다.<br>
대형 디스플레이와 강력한 카메라 성능을 갖추고 있습니다.<br>
고사양 작업과 게임에서도 안정적인 성능을 유지합니다.<br>
프리미엄 안드로이드 스마트폰을 원하는 분께 추천합니다.]',
 '판매중', 'Main_galaxy_s25_ultra.jpg', 1200000);

INSERT INTO tbl_product
VALUES
('2000GX', 'Galaxy Z Fold6', 'Samsung',
 q'[Galaxy Z Fold6는 대화면 기반의 멀티태스킹에 강점이 있습니다.<br>
여러 앱을 동시에 실행해 작업 효율을 높일 수 있습니다.<br>
콘텐츠 소비와 업무 활용 모두에 적합합니다.<br>
폴더블 경험을 원하는 사용자에게 추천됩니다.]',
 '판매중', 'Main_galaxy_z_fold6.jpg', 2000000);

INSERT INTO tbl_product
VALUES
('2100GX', 'Galaxy Z Flip6', 'Samsung',
 q'[Galaxy Z Flip6는 휴대성과 활용성을 겸비한 폴더블 모델입니다.<br>
작은 크기로 접어 휴대하기 편리합니다.<br>
다양한 촬영 각도를 지원해 사진 활용도가 높습니다.<br>
실용성과 디자인을 중시하는 사용자에게 적합합니다.]',
 '판매중', 'Main_galaxy_z_flip6.jpg', 2100000);

INSERT INTO tbl_product
VALUES
('2200GX', 'Galaxy S24 Ultra', 'Samsung',
 q'[Galaxy S24 Ultra는 고급스러운 디자인과 성능을 제공합니다.<br>
카메라와 디스플레이 품질이 뛰어납니다.<br>
고사양 앱과 멀티태스킹에서도 안정적인 사용이 가능합니다.<br>
프리미엄 갤럭시 모델을 찾는 사용자에게 추천합니다.]',
 '판매중', 'Main_galaxy_s24_ultra.jpg', 2200000);

INSERT INTO tbl_product
VALUES
('3000GX', 'Galaxy Z Fold5', 'Samsung',
 q'[Galaxy Z Fold5는 폴더블 대화면의 활용성이 돋보이는 모델입니다.<br>
업무와 엔터테인먼트를 동시에 즐길 수 있습니다.<br>
멀티태스킹에 최적화된 사용자 경험을 제공합니다.<br>
대화면 스마트폰을 선호하는 사용자에게 적합합니다.]',
 '판매중', 'Main_galaxy_z_fold5.jpg', 3000000);

INSERT INTO tbl_product
VALUES
('3100GX', 'Galaxy Z Flip5', 'Samsung',
 q'[Galaxy Z Flip5는 세련된 디자인과 휴대성이 특징입니다.<br>
접이식 구조로 사용성과 개성을 모두 만족시킵니다.<br>
촬영과 일상 사용에서 편의성이 뛰어납니다.<br>
트렌디한 스마트폰을 원하는 사용자에게 추천합니다.]',
 '판매중', 'Main_galaxy_z_flip5.jpg', 3100000);

INSERT INTO tbl_product
VALUES
('3200GX', 'Galaxy S23 Ultra', 'Samsung',
 q'[Galaxy S23 Ultra는 강력한 성능과 카메라를 갖춘 모델입니다.<br>
대형 디스플레이로 콘텐츠 감상에 최적화되어 있습니다.<br>
업무와 엔터테인먼트 모두에 적합한 스마트폰입니다.<br>
울트라 라인업을 선호하는 사용자에게 추천합니다.]',
 '판매중', 'Main_galaxy_s23_ultra.jpg', 3200000);

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
 q'[iPhone 13은 안정적인 성능과 완성도를 갖춘 스탠다드 모델입니다.<br>
일상적인 앱 사용과 멀티미디어 감상에 충분한 성능을 제공합니다.<br>
카메라 성능이 개선되어 사진과 영상 촬영이 더욱 자연스럽습니다.<br>
실사용 중심의 스마트폰을 원하는 사용자에게 적합합니다.]',
 '판매중', 'Main_iPhone13.jpg', 1300000);

INSERT INTO tbl_product
VALUES
('1310AP', 'iPhone13 Pro', 'Apple',
 q'[iPhone 13 Pro는 성능과 촬영 품질을 강화한 프로 라인업 모델입니다.<br>
고성능 칩셋으로 고사양 앱과 멀티태스킹에서도 안정적인 사용이 가능합니다.<br>
카메라 활용도가 높아 영상 및 사진 촬영에 유리합니다.<br>
프리미엄 사용 경험을 원하는 사용자에게 추천됩니다.]',
 '판매중', 'Main_iPhone13Pro.jpg', 1400000);
 
 COMMIT;
 
/*
INSERT INTO tbl_product
VALUES
('1320AP', 'iPhone13 Pro Max', 'Apple',
 q'[iPhone 13 Pro Max는 대화면과 긴 배터리 사용 시간을 제공하는 모델입니다.<br>
영상 감상과 게임에서 뛰어난 몰입감을 제공합니다.<br>
프로급 카메라 성능으로 콘텐츠 제작에도 적합합니다.<br>
대형 스마트폰을 선호하는 사용자에게 추천합니다.]',
 '판매중', '', 1500000);

INSERT INTO tbl_product
VALUES
('1400AP', 'iPhone14', 'Apple',
 q'[iPhone 14는 균형 잡힌 성능과 향상된 안정성을 제공하는 모델입니다.<br>
일상 사용에 최적화된 인터페이스로 누구나 쉽게 사용할 수 있습니다.<br>
카메라와 디스플레이 품질이 개선되어 만족도가 높습니다.<br>
실속 있는 최신 아이폰을 찾는 사용자에게 적합합니다.]',
 '판매중', '', 1600000);

INSERT INTO tbl_product
VALUES
('1410AP', 'iPhone14 Pro', 'Apple',
 q'[iPhone 14 Pro는 고급 기능과 성능을 강화한 프리미엄 모델입니다.<br>
부드러운 화면 전환과 빠른 반응 속도를 제공합니다.<br>
촬영 기능이 강화되어 사진과 영상의 완성도가 높습니다.<br>
성능과 디자인을 모두 중시하는 사용자에게 추천합니다.]',
 '판매중', '', 1700000);

INSERT INTO tbl_product
VALUES
('1420AP', 'iPhone14 Pro Max', 'Apple',
 q'[iPhone 14 Pro Max는 대화면과 강력한 성능을 동시에 제공하는 최상위 모델입니다.<br>
콘텐츠 감상과 게임 플레이에서 뛰어난 몰입감을 제공합니다.<br>
고성능 카메라로 다양한 촬영 환경에서도 안정적인 결과를 얻을 수 있습니다.<br>
최고 사양의 아이폰을 원하는 사용자에게 적합합니다.]',
 '판매중', '', 1800000);
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
----------------------------상품 옵션에 대한 값 넣기--------------------------------------
--------------------------------------------------------------------------------------
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
   - 각 상품당 추가 이미지 2개
   - image_path는 임시로 빈 문자열 ''
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
    