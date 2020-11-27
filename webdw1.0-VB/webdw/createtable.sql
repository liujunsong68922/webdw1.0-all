--创建webdw0.2版本正常运行所需要的数据表
--并填充原始数据
--目前仅支持Oracle数据库

--product表
CREATE TABLE PRODUCT
(
  ID               NUMBER(10)                   NOT NULL,
  NAME             VARCHAR2(15 BYTE)            NOT NULL,
  DESCRIPTION      VARCHAR2(30 BYTE)            NOT NULL,
  PROD_SIZE        VARCHAR2(18 BYTE)            NOT NULL,
  COLOR            VARCHAR2(6 BYTE)             NOT NULL,
  QUANTITY         NUMBER(10,2)                 NOT NULL,
  UNIT_PRICE       NUMBER(15,2)                 NOT NULL,
  PICTURE_NAME     VARCHAR2(255 BYTE),
  CATALOG_PICTURE  CHAR(10 BYTE)
);

--employee表
CREATE TABLE EMPLOYEE
(
  EMP_ID            NUMBER(3),
  MANAGER_ID        NUMBER(3),
  EMP_FNAME         VARCHAR2(20 BYTE),
  EMP_LNAME         VARCHAR2(20 BYTE),
  DEPT_ID           NUMBER(3),
  STREET            VARCHAR2(40 BYTE),
  CITY              VARCHAR2(20 BYTE),
  STATE             VARCHAR2(4 BYTE),
  ZIP_CODE          VARCHAR2(9 BYTE),
  PHONE             VARCHAR2(10 BYTE),
  STATUS            VARCHAR2(1 BYTE),
  SS_NUMBER         VARCHAR2(11 BYTE),
  SALARY            NUMBER(16,3),
  START_DATE        DATE,
  TERMINATION_DATE  DATE,
  BIRTH_DATE        DATE,
  BENE_HEALTH_INS   VARCHAR2(1 BYTE),
  BENE_LIFE_INS     VARCHAR2(1 BYTE),
  BENE_DAY_CARE     VARCHAR2(1 BYTE),
  SEX               VARCHAR2(1 BYTE)
);

--Department表
CREATE TABLE DEPARTMENT
(
  DEPT_ID       NUMBER(3),
  DEPT_NAME     VARCHAR2(40 BYTE),
  DEPT_HEAD_ID  NUMBER(6)
);

--insert into department
SET DEFINE OFF;
Insert into DEPARTMENT
   (DEPT_ID, DEPT_NAME, DEPT_HEAD_ID)
 Values
   (100, 'RAndD', 501);
Insert into DEPARTMENT
   (DEPT_ID, DEPT_NAME, DEPT_HEAD_ID)
 Values
   (200, 'Sales', 902);
Insert into DEPARTMENT
   (DEPT_ID, DEPT_NAME, DEPT_HEAD_ID)
 Values
   (300, 'Finance', 1293);
Insert into DEPARTMENT
   (DEPT_ID, DEPT_NAME, DEPT_HEAD_ID)
 Values
   (400, 'Marketing', 1576);
Insert into DEPARTMENT
   (DEPT_ID, DEPT_NAME, DEPT_HEAD_ID)
 Values
   (500, 'Shipping', 703);
COMMIT;

--insert into employee
SET DEFINE OFF;
Insert into EMPLOYEE
   (EMP_ID, DEPT_ID, STATE, ZIP_CODE, PHONE, STATUS, BENE_HEALTH_INS, SEX)
 Values
   (1, 200, '2', '100001', '1391057777', 'A', 'Y', 'F');
Insert into EMPLOYEE
   (EMP_ID, DEPT_ID, STATE, ZIP_CODE, PHONE, STATUS, BENE_HEALTH_INS, SEX)
 Values
   (3, 500, '4', '100004', '1391234567', 'T', 'Y', 'F');
Insert into EMPLOYEE
   (EMP_ID, DEPT_ID, ZIP_CODE, PHONE, STATUS, BENE_HEALTH_INS, SEX)
 Values
   (2, 100, '100001', '1359901011', 'A', 'Y', 'M');
COMMIT;

--insert into product
SET DEFINE OFF;
Insert into PRODUCT
   (ID, NAME, DESCRIPTION, PROD_SIZE, COLOR, QUANTITY, UNIT_PRICE, PICTURE_NAME)
 Values
   (222, 'bbb', ' bbb', 'Small', 'Purple', 2, 22, '222');
Insert into PRODUCT
   (ID, NAME, DESCRIPTION, PROD_SIZE, COLOR, QUANTITY, UNIT_PRICE, PICTURE_NAME)
 Values
   (111, 'aaa', ' aaa', 'Medium', 'Blue', 11, 12, '11');
COMMIT;
