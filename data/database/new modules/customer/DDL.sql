CREATE TABLE HRIS_CUSTOMER
  (
    CUSTOMER_ID         NUMBER(7,0) PRIMARY KEY,
    CUSTOMER_CODE       VARCHAR2(15 BYTE),
    CUSTOMER_ENAME      VARCHAR2(150 BYTE) NOT NULL,
    CUSTOMER_LNAME      VARCHAR2(150 BYTE),
    ADDRESS             VARCHAR2(150 BYTE),
    PHONE_NO            VARCHAR2(30 BYTE),
    CONTACT_PERSON_NAME VARCHAR2(150 BYTE),
    PAN_NO 		VARCHAR2(150 BYTE),
    VAT_NO              VARCHAR2(100 BYTE),
    FAX                 VARCHAR2(100 BYTE),
    EMAIL               VARCHAR2(100 BYTE),
    CREATED_BY          NUMBER(7,0) ,
    CREATED_DT          DATE DEFAULT TRUNC(SYSDATE),
    MODIFIED_BY         NUMBER(7,0),
    MODIFIED_DT         DATE,
    REMARKS             VARCHAR2(512 BYTE),
    STATUS              CHAR(1 BYTE) DEFAULT 'E' NOT NULL CHECK(STATUS IN ('E','D'))
  );
  
  CREATE TABLE HRIS_CUSTOMER_LOCATION(
LOCATION_ID         NUMBER(7,0),
CUSTOMER_ID         NUMBER(7,0),
LOCATION_NAME       VARCHAR2(255 BYTE),
ADDRESS             VARCHAR2(255 BYTE),
CREATED_BY          NUMBER(7,0),
CREATED_DT          DATE DEFAULT TRUNC(SYSDATE),
MODIFIED_BY         NUMBER(7,0),
MODIFIED_DT         DATE,
REMARKS             VARCHAR2(512 BYTE),
STATUS              CHAR(1 BYTE) DEFAULT 'E' NOT NULL CHECK(STATUS IN ('E','D'))
);


CREATE TABLE HRIS_CUSTOMER_CONTRACT(
CONTRACT_ID NUMBER(7,0) NOT NULL,
CUSTOMER_ID NUMBER(7,0) NOT NULL,
CONTRACT_NAME VARCHAR2(255 BYTE) NOT NULL,
START_DATE DATE,
END_DATE DATE,
BILLING_MONTH CHAR(1 BYTE) DEFAULT 'N' NOT NULL CHECK (BILLING_MONTH IN ('N','E')),
FREEZED CHAR(1 BYTE) DEFAULT 'N' NOT NULL CHECK (FREEZED IN ('N','Y')),
BILLING_TYPE CHAR(1 BYTE),
CREATED_BY    NUMBER(7,0) ,
CREATED_DT    DATE DEFAULT TRUNC(SYSDATE),
MODIFIED_BY   NUMBER(7,0),
MODIFIED_DT   DATE,
REMARKS       VARCHAR2(512 BYTE),
STATUS        CHAR(1 BYTE) DEFAULT 'E' NOT NULL CHECK(STATUS IN ('E','D'))
);

CREATE TABLE HRIS_CUSTOMER_CONTRACT_DETAILS
(
CONTRACT_ID NUMBER(7,0),
CUSTOMER_ID NUMBER(7,0),
LOCATION_ID NUMBER(7,0),
DESIGNATION_ID NUMBER(7,0),
QUANTITY NUMBER(7,0),
RATE FLOAT(126),
SHIFT_ID NUMBER(7,0),
DAYS_IN_MONTH NUMBER(2,0), -- in month
WEEK_DETAILS VARCHAR2(200 BYTE),
CREATED_BY    NUMBER(7,0),
CREATED_DT    DATE DEFAULT TRUNC(SYSDATE),
MODIFIED_BY   NUMBER(7,0),
MODIFIED_DT   DATE,
REMARKS       VARCHAR2(512 BYTE),
STATUS        CHAR(1 BYTE) DEFAULT 'E' NOT NULL CHECK(STATUS IN ('E','D'))
);


CREATE TABLE HRIS_CONTRACT_EMP_ASSIGN(
EMP_ASSIGN_ID NUMBER(7,0) PRIMARY KEY,
CONTRACT_ID NUMBER(7,0), 
CUSTOMER_ID NUMBER(7,0),
LOCATION_ID NUMBER(7,0),
EMPLOYEE_ID NUMBER(7,0),
DESIGNATION_ID NUMBER(7,0),
DUTY_TYPE_ID NUMBER(7,0),
START_TIME TIMESTAMP,
END_TIME TIMESTAMP,
START_DATE DATE,
END_DATE DATE,
LAST_ASSIGNED_DATE DATE,
CREATED_BY          NUMBER(7,0),
CREATED_DT          DATE DEFAULT TRUNC(SYSDATE),
MODIFIED_BY         NUMBER(7,0),
MODIFIED_DT         DATE,
REMARKS             VARCHAR2(512 BYTE),
STATUS              CHAR(1 BYTE) DEFAULT 'E' NOT NULL CHECK(STATUS IN ('E','D'))
);



CREATE TABLE HRIS_CONTRACT_EMP_ATTENDANCE(
ATTENDANCE_DATE DATE,
EMPLOYEE_ID NUMBER(7,0),
CUSTOMER_ID NUMBER(7,0),
CONTRACT_ID NUMBER(7,0),
LOCATION_ID NUMBER(7,0),
IN_TIME TIMESTAMP,
OUT_TIME TIMESTAMP,
SHIFT_ID NUMBER(7,0),
MONTH_CODE NUMBER(7,0), 
NORMAL_HOUR FLOAT(126),
OT_HOUR FLOAT(126),
PT_HOUR FLOAT(126),
STATUS CHAR(2 BYTE) NOT NULL CHECK (STATUS IN ('PR','AB','HO','PT'))
);


CREATE TABLE HRIS_CONTRACT_EMP_ABSENT_SUB(
ID NUMBER(7,0),
ATTENDANCE_DATE DATE,
CUSTOMER_ID NUMBER(7,0),
CONTRACT_ID NUMBER(7,0), 
EMPLOYEE_ID NUMBER(7,0),
EMPLOYEE_LOCATION_ID NUMBER(7,0),
EMPLOYEE_DESIGNATION_ID NUMBER(7,0),
EMPLOYEE_SHIFT_ID NUMBER(7,0),
ABSENT_REASON VARCHAR2(255 BYTE),
SUB_EMPLOYEE_ID NUMBER(7,0),
SUB_SHIFT_TYPE_ID NUMBER(7,0),
SUB_LOCATION_ID NUMBER(7,0),
SUB_DESIGNATION_ID NUMBER(7,0),
POSTING_TYPE VARCHAR2(50 BYTE),
NORMAL_HOUR FLOAT(126),
OT_HOUR FLOAT(126),
PT_HOUR FLOAT(126),
CREATED_BY          NUMBER(7,0) ,
CREATED_DT          DATE DEFAULT TRUNC(SYSDATE),
MODIFIED_BY         NUMBER(7,0),
MODIFIED_DT         DATE,
REMARKS             VARCHAR2(512 BYTE),
STATUS              CHAR(1 BYTE) DEFAULT 'E' NOT NULL CHECK(STATUS IN ('E','D'))
);


CREATE TABLE HRIS_DUTY_TYPE
(
DUTY_TYPE_ID NUMBER(7,0) NOT NULL,
DUTY_TYPE_NAME VARCHAR2(255 BYTE)  NOT NULL,
NORMAL_HOUR FLOAT(126)  NOT NULL,
OT_HOUR FLOAT(126),
CREATED_BY          NUMBER(7,0) ,
CREATED_DT          DATE DEFAULT TRUNC(SYSDATE),
MODIFIED_BY         NUMBER(7,0),
MODIFIED_DT         DATE,
REMARKS             VARCHAR2(512 BYTE),
STATUS              CHAR(1 BYTE) DEFAULT 'E' NOT NULL CHECK(STATUS IN ('E','D'))
);



ALTER TABLE HRIS_CUSTOMER_CONTRACT_DETAILS 
ADD DUTY_TYPE_ID NUMBER(7,0);

ALTER TABLE HRIS_CUSTOMER_CONTRACT_DETAILS
DROP COLUMN SHIFT_ID;



ALTER TABLE HRIS_CONTRACT_EMP_ATTENDANCE
ADD DUTY_TYPE_ID NUMBER(7,0);

ALTER TABLE HRIS_CONTRACT_EMP_ATTENDANCE
ADD START_TIME TIMESTAMP;

ALTER TABLE HRIS_CONTRACT_EMP_ATTENDANCE
ADD END_TIME TIMESTAMP;

ALTER TABLE HRIS_CONTRACT_EMP_ATTENDANCE
ADD SUB_EMPLOYEE_ID NUMBER(7,0);

ALTER TABLE HRIS_CONTRACT_EMP_ATTENDANCE
ADD DESIGNATION_ID NUMBER(7,0);

ALTER TABLE HRIS_CONTRACT_EMP_ATTENDANCE
ADD EMP_ASSIGN_ID NUMBER(7,0);



ALTER TABLE HRIS_CONTRACT_EMP_ATTENDANCE  
ADD POSTING_TYPE CHAR(2 BYTE);



ALTER TABLE HRIS_CONTRACT_EMP_ASSIGN
ADD  MONTHLY_RATE FLOAT(126);



alter table HRIS_CUSTOMER_CONTRACT 
add OT_RATE FLOAT(126);

ALTER TABLE HRIS_CUSTOMER_CONTRACT 
ADD OT_TYPE CHAR(1 BYTE);

ALTER TABLE HRIS_CONTRACT_EMP_ATTENDANCE
ADD SUB_RATE FLOAT(126);

ALTER TABLE HRIS_CONTRACT_EMP_ATTENDANCE
ADD SUB_OT_RATE FLOAT(126);

ALTER TABLE HRIS_CONTRACT_EMP_ATTENDANCE
ADD SUB_OT_TYPE CHAR(1 BYTE);


ALTER TABLE HRIS_EMPLOYEES
ADD HOURLY_AMOUNT FLOAT (126);

  