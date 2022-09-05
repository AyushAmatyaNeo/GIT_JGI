CREATE OR REPLACE PROCEDURE HRIS_MIG_ATTD_EXCEL(
P_EMPLOYEE_ID NUMBER,
P_FROM_DATE DATE:=TRUNC(SYSDATE),
P_TO_DATE DATE:=TRUNC(SYSDATE)
)
AS
V_THUMB_ID NUMBER;
V_FROM_YEAR NUMBER(4,0);
V_FROM_MONTH NUMBER(2,0);
V_FROM_DAY NUMBER(2,0);
V_TO_YEAR NUMBER(4,0);
V_TO_MONTH NUMBER(2,0);
V_TO_DAY NUMBER(2,0);
V_ALREADY_INSERTED NUMBER;
BEGIN


SELECT ID_THUMB_ID INTO V_THUMB_ID FROM HRIS_EMPLOYEES WHERE EMPLOYEE_ID=P_EMPLOYEE_ID;



IF(V_THUMB_ID IS NOT NULL AND V_THUMB_ID>0)
THEN

SELECT 
EXTRACT(YEAR FROM TO_DATE(P_FROM_DATE)),
EXTRACT(MONTH FROM TO_DATE(P_FROM_DATE)),
EXTRACT(DAY FROM TO_DATE(P_FROM_DATE)),
EXTRACT(YEAR FROM TO_DATE(P_TO_DATE)),
EXTRACT(MONTH FROM TO_DATE(P_TO_DATE)),
EXTRACT(DAY FROM TO_DATE(P_TO_DATE))
INTO
V_FROM_YEAR,
V_FROM_MONTH,
V_FROM_DAY,
V_TO_YEAR,
V_TO_MONTH,
V_TO_DAY
FROM DUAL;




FOR ATTD_LIST IN (SELECT * FROM HRIS_ATTD_EXCEL WHERE 
THUMB_ID=V_THUMB_ID 
AND (ATTD_YEAR BETWEEN V_FROM_YEAR AND V_TO_YEAR)
AND (ATTD_MONTH BETWEEN V_FROM_MONTH AND V_TO_MONTH)
AND (ATTD_DAY BETWEEN V_FROM_DAY AND V_TO_DAY)
)
LOOP
V_ALREADY_INSERTED:=0;

SELECT COUNT(*) INTO V_ALREADY_INSERTED FROM HRIS_ATTENDANCE
WHERE 
EMPLOYEE_ID=P_EMPLOYEE_ID
AND ATTENDANCE_DT=TO_DATE(ATTD_LIST.ATTD_YEAR||'-'||ATTD_LIST.ATTD_MONTH||'-'||ATTD_LIST.ATTD_DAY,'YYYY-MM-DD')
AND ATTENDANCE_TIME=TO_TIMESTAMP(ATTD_LIST.ATTD_YEAR||'-'||ATTD_LIST.ATTD_MONTH||'-'||ATTD_LIST.ATTD_DAY||'-'||ATTD_LIST.ATTD_HOUR||'-'||ATTD_LIST.ATTD_MINUTE||'-'||ATTD_LIST.ATTD_SECOND,'YYYY-MM-DD-HH24-MI-SS') 
;

IF(V_ALREADY_INSERTED=0)
THEN
INSERT INTO HRIS_ATTENDANCE VALUES
(P_EMPLOYEE_ID,
TO_DATE(ATTD_LIST.ATTD_YEAR||'-'||ATTD_LIST.ATTD_MONTH||'-'||ATTD_LIST.ATTD_DAY,'YYYY-MM-DD'),
'Manually Inserted',
'Imported By ITN('||TRUNC(SYSDATE)||')',
TO_TIMESTAMP(ATTD_LIST.ATTD_YEAR||'-'||ATTD_LIST.ATTD_MONTH||'-'||ATTD_LIST.ATTD_DAY||'-'||ATTD_LIST.ATTD_HOUR||'-'||ATTD_LIST.ATTD_MINUTE||'-'||ATTD_LIST.ATTD_SECOND,'YYYY-MM-DD-HH24-MI-SS'),
'Imported By ITN('||TRUNC(SYSDATE)||')',
ATTD_LIST.THUMB_ID,
'Y'
);
END IF;



dbms_output.put('TEST');

END LOOP;

END IF;



END;

