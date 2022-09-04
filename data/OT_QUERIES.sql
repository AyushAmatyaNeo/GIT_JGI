DECLARE
  V_COT_ID NUMBER:=44;
BEGIN
  FOR attendance IN
  (SELECT AD.*
  FROM HRIS_ATTENDANCE_DETAIL AD ,
    (SELECT COT.EARLY_OVERTIME_HR,
      COT.LATE_OVERTIME_HR,
      COT.START_DATE,
      COT.END_DATE,
      ECOT.EMPLOYEE_ID
    FROM HRIS_COMPULSORY_OVERTIME COT
    JOIN HRIS_EMPLOYEE_COMPULSORY_OT ECOT
    ON (COT.COMPULSORY_OVERTIME_ID  = ECOT.COMPULSORY_OVERTIME_ID)
    WHERE COT.COMPULSORY_OVERTIME_ID=V_COT_ID
    ) OT
  WHERE AD.EMPLOYEE_ID=OT.EMPLOYEE_ID
  AND (AD.ATTENDANCE_DT BETWEEN OT.START_DATE AND OT.END_DATE )
  )
  LOOP
    NULL;
  END LOOP;
END;
/
--
SELECT EMPLOYEE_ID,
  ATTENDANCE_DT,
  IN_TIME,
  OUT_TIME,
  START_TIME,
  END_TIME,
  EXTRACT(HOUR FROM EARLY_OT_HR)*60+EXTRACT(MINUTE FROM EARLY_OT_HR) AS ACT_EARLY_OT_HR,
  EXTRACT(HOUR FROM LATE_OT_HR) *60+EXTRACT(MINUTE FROM LATE_OT_HR)  AS ACT_LATE_OT_HR,
  EARLY_OVERTIME_HR,
  LATE_OVERTIME_HR
FROM
  (SELECT AD.EMPLOYEE_ID,
    AD.ATTENDANCE_DT,
    AD.IN_TIME,
    AD.OUT_TIME,
    S.START_TIME,
    S.END_TIME,
    ((S.START_TIME-TRUNC(S.START_TIME))-(AD.IN_TIME -TRUNC(AD.IN_TIME))) AS EARLY_OT_HR,
    ((AD.OUT_TIME -TRUNC(AD.OUT_TIME))-(S.END_TIME-TRUNC(S.END_TIME)))   AS LATE_OT_HR,
    OT.EARLY_OVERTIME_HR,
    OT.LATE_OVERTIME_HR
  FROM HRIS_ATTENDANCE_DETAIL AD ,
    (SELECT COT.EARLY_OVERTIME_HR,
      COT.LATE_OVERTIME_HR,
      COT.START_DATE,
      COT.END_DATE,
      ECOT.EMPLOYEE_ID
    FROM HRIS_COMPULSORY_OVERTIME COT
    JOIN HRIS_EMPLOYEE_COMPULSORY_OT ECOT
    ON (COT.COMPULSORY_OVERTIME_ID  = ECOT.COMPULSORY_OVERTIME_ID)
    WHERE COT.COMPULSORY_OVERTIME_ID=45
    ) OT,
    HRIS_SHIFTS S
  WHERE AD.EMPLOYEE_ID=OT.EMPLOYEE_ID
  AND (AD.ATTENDANCE_DT BETWEEN OT.START_DATE AND OT.END_DATE )
  AND AD.OVERALL_STATUS  IN ('PR','LA','BA')
  AND AD.LATE_STATUS NOT IN ('X','Y')
  AND AD.SHIFT_ID         =S.SHIFT_ID
  );
--
SELECT EMPLOYEE_ID,
  SUM(ACT_EARLY_OT_HR),
  SUM(ACT_LATE_OT_HR),
  SUM(EARLY_OVERTIME_HR),
  SUM(LATE_OVERTIME_HR)
FROM
  (SELECT EMPLOYEE_ID,
    ATTENDANCE_DT,
    IN_TIME,
    OUT_TIME,
    START_TIME,
    END_TIME,
    EXTRACT(HOUR FROM EARLY_OT_HR)*60+EXTRACT(MINUTE FROM EARLY_OT_HR) AS ACT_EARLY_OT_HR,
    EXTRACT(HOUR FROM LATE_OT_HR) *60+EXTRACT(MINUTE FROM LATE_OT_HR)  AS ACT_LATE_OT_HR,
    EARLY_OVERTIME_HR,
    LATE_OVERTIME_HR
  FROM
    (SELECT AD.EMPLOYEE_ID,
      AD.ATTENDANCE_DT,
      AD.IN_TIME,
      AD.OUT_TIME,
      S.START_TIME,
      S.END_TIME,
      ((S.START_TIME-TRUNC(S.START_TIME))-(AD.IN_TIME -TRUNC(AD.IN_TIME))) AS EARLY_OT_HR,
      ((AD.OUT_TIME -TRUNC(AD.OUT_TIME))-(S.END_TIME-TRUNC(S.END_TIME)))   AS LATE_OT_HR,
      OT.EARLY_OVERTIME_HR,
      OT.LATE_OVERTIME_HR
    FROM HRIS_ATTENDANCE_DETAIL AD ,
      (SELECT COT.EARLY_OVERTIME_HR,
        COT.LATE_OVERTIME_HR,
        COT.START_DATE,
        COT.END_DATE,
        ECOT.EMPLOYEE_ID
      FROM HRIS_COMPULSORY_OVERTIME COT
      JOIN HRIS_EMPLOYEE_COMPULSORY_OT ECOT
      ON (COT.COMPULSORY_OVERTIME_ID  = ECOT.COMPULSORY_OVERTIME_ID)
      WHERE COT.COMPULSORY_OVERTIME_ID=44
      ) OT,
      HRIS_SHIFTS S
    WHERE AD.EMPLOYEE_ID=OT.EMPLOYEE_ID
    AND (AD.ATTENDANCE_DT BETWEEN OT.START_DATE AND OT.END_DATE )
    AND AD.OVERALL_STATUS  IN ('PR','LA','BA')
    AND AD.LATE_STATUS NOT IN ('X','Y')
    AND AD.SHIFT_ID         =S.SHIFT_ID
    )
  )
GROUP BY EMPLOYEE_ID;

SELECT * FROM HRIS_COMPULSORY_OVERTIME;
SELECT *
FROM HRIS_OVERTIME
WHERE OVERTIME_DATE BETWEEN TO_DATE('17-NOV-17','DD-MON-RR') AND TO_DATE('15-DEC-17','DD-MON-RR') AND EMPLOYEE_ID IN (SELECT EMPLOYEE_ID FROM HRIS_EMPLOYEE_COMPULSORY_OT WHERE COMPULSORY_OVERTIME_ID = 44);


-- 

-- 
-- 

DECLARE
  V_COMPULSORY_OVERTIME_ID NUMBER:=47;
TYPE OVERTIME_DETAIL_TYPE
IS
  TABLE OF HRIS_OVERTIME_DETAIL%ROWTYPE INDEX BY BINARY_INTEGER;
  V_OT_DETAIL OVERTIME_DETAIL_TYPE;
  V_DESCRIPTION    VARCHAR2(255 BYTE):='THIS IS AUTOGENERATED OT REQUEST FROM COMPULSORY OT.';
  V_TOTAL_HOUR     NUMBER;
  V_OVERTIME_ID    NUMBER;
  V_DETAIL_ID      NUMBER;
  V_MESSAGE_ID     NUMBER;
  V_TO_EMPLOYEE_ID NUMBER;
  V_ROLE_ID        NUMBER;
  V_ROUTE          VARCHAR2(4000 BYTE);
  V_EMPLOYEE_NAME  VARCHAR2(255 BYTE);
BEGIN
  FOR ot IN
  (SELECT EMPLOYEE_ID,
    ATTENDANCE_DT,
    IN_TIME,
    OUT_TIME,
    START_TIME,
    END_TIME,
    EXTRACT(HOUR FROM EARLY_OT_HR)*60+EXTRACT(MINUTE FROM EARLY_OT_HR) AS ACT_EARLY_OT_HR,
    EXTRACT(HOUR FROM LATE_OT_HR) *60+EXTRACT(MINUTE FROM LATE_OT_HR)  AS ACT_LATE_OT_HR,
    EARLY_OVERTIME_HR,
    LATE_OVERTIME_HR
  FROM
    (SELECT AD.EMPLOYEE_ID,
      AD.ATTENDANCE_DT,
      AD.IN_TIME,
      AD.OUT_TIME,
      S.START_TIME,
      S.END_TIME,
      ((S.START_TIME-TRUNC(S.START_TIME))-(AD.IN_TIME -TRUNC(AD.IN_TIME))) AS EARLY_OT_HR,
      ((AD.OUT_TIME -TRUNC(AD.OUT_TIME))-(S.END_TIME-TRUNC(S.END_TIME)))   AS LATE_OT_HR,
      OT.EARLY_OVERTIME_HR,
      OT.LATE_OVERTIME_HR
    FROM HRIS_ATTENDANCE_DETAIL AD ,
      (SELECT COT.EARLY_OVERTIME_HR,
        COT.LATE_OVERTIME_HR,
        COT.START_DATE,
        COT.END_DATE,
        ECOT.EMPLOYEE_ID
      FROM HRIS_COMPULSORY_OVERTIME COT
      JOIN HRIS_EMPLOYEE_COMPULSORY_OT ECOT
      ON (COT.COMPULSORY_OVERTIME_ID  = ECOT.COMPULSORY_OVERTIME_ID)
      WHERE COT.COMPULSORY_OVERTIME_ID=V_COMPULSORY_OVERTIME_ID
      ) OT,
      HRIS_SHIFTS S
    WHERE AD.EMPLOYEE_ID=OT.EMPLOYEE_ID
    AND (AD.ATTENDANCE_DT BETWEEN OT.START_DATE AND OT.END_DATE )
    AND AD.OVERALL_STATUS  IN ('PR','LA','BA')
    AND AD.LATE_STATUS NOT IN ('X','Y')
    AND AD.SHIFT_ID         =S.SHIFT_ID
    )
  )
  LOOP
    V_OT_DETAIL.DELETE;
    V_TOTAL_HOUR:=0;
    --
    IF(ot.EARLY_OVERTIME_HR    >=30) AND (ot.ACT_EARLY_OT_HR >=30) THEN
      V_OT_DETAIL(0).START_TIME:=ot.IN_TIME ;
      V_OT_DETAIL(0).END_TIME  :=ot.START_TIME;
      V_OT_DETAIL(0).STATUS    :='E';
      V_OT_DETAIL(0).TOTAL_HOUR:=ot.ACT_EARLY_OT_HR;
      V_TOTAL_HOUR             :=V_TOTAL_HOUR+ot.ACT_EARLY_OT_HR;
    END IF;
    IF(ot.LATE_OVERTIME_HR     >=30) AND (ot.ACT_LATE_OT_HR >=30) THEN
      V_OT_DETAIL(1).START_TIME:=ot.END_TIME;
      V_OT_DETAIL(1).END_TIME  :=ot.OUT_TIME;
      V_OT_DETAIL(1).STATUS    :='E';
      V_OT_DETAIL(1).TOTAL_HOUR:=ot.ACT_LATE_OT_HR;
      V_TOTAL_HOUR             :=V_TOTAL_HOUR+ot.ACT_LATE_OT_HR;
    END IF;
    IF(V_OT_DETAIL.COUNT >0) THEN
      SELECT NVL(MAX(OVERTIME_ID),1)+1 INTO V_OVERTIME_ID FROM HRIS_OVERTIME;
      INSERT
      INTO HRIS_OVERTIME
        (
          OVERTIME_ID,
          EMPLOYEE_ID,
          OVERTIME_DATE,
          REQUESTED_DATE,
          DESCRIPTION,
          STATUS,
          TOTAL_HOUR
        )
        VALUES
        (
          V_OVERTIME_ID,
          ot.EMPLOYEE_ID,
          ot.ATTENDANCE_DT,
          ot.ATTENDANCE_DT,
          V_DESCRIPTION,
          'RQ',
          V_TOTAL_HOUR
        );
      FOR i IN V_OT_DETAIL.FIRST .. V_OT_DETAIL.LAST
      LOOP
        SELECT NVL(MAX(DETAIL_ID),1)+1 INTO V_DETAIL_ID FROM HRIS_OVERTIME_DETAIL;
        INSERT
        INTO HRIS_OVERTIME_DETAIL
          (
            DETAIL_ID,
            OVERTIME_ID,
            START_TIME,
            END_TIME,
            STATUS,
            TOTAL_HOUR
          )
          VALUES
          (
            V_DETAIL_ID,
            V_OVERTIME_ID,
            V_OT_DETAIL(i).START_TIME,
            V_OT_DETAIL(i).END_TIME,
            'E',
            V_OT_DETAIL(i).TOTAL_HOUR
          );
      END LOOP;
      SELECT NVL(MAX(MESSAGE_ID),0)+1 INTO V_MESSAGE_ID FROM HRIS_NOTIFICATION;
      SELECT RECOMMEND_BY,
        (
        CASE
          WHEN RECOMMEND_BY=APPROVED_BY
          THEN 4
          ELSE 2
        END)
      INTO V_TO_EMPLOYEE_ID,
        V_ROLE_ID
      FROM HRIS_RECOMMENDER_APPROVER
      WHERE EMPLOYEE_ID = ot.EMPLOYEE_ID;
      V_ROUTE          :='{"route":"overtimeApprove","action":"view","id":"'||V_OVERTIME_ID||'","role":'||V_ROLE_ID||'}';
      SELECT FULL_NAME
      INTO V_EMPLOYEE_NAME
      FROM HRIS_EMPLOYEES
      WHERE EMPLOYEE_ID=ot.EMPLOYEE_ID;
      INSERT
      INTO HRIS_NOTIFICATION
        (
          MESSAGE_ID,
          MESSAGE_DATETIME,
          MESSAGE_TITLE,
          MESSAGE_DESC,
          MESSAGE_FROM,
          MESSAGE_TO,
          STATUS,
          EXPIRY_TIME,
          ROUTE
        )
        VALUES
        (
          V_MESSAGE_ID,
          SYSDATE,
          'Compulsory OT',
          'OT REQUEST OF '
          ||V_EMPLOYEE_NAME
          ||' FROM THE DATE '
          ||TO_CHAR(ot.ATTENDANCE_DT,'DD-MON-YYYY'),
          ot.EMPLOYEE_ID,
          V_TO_EMPLOYEE_ID,
          'U',
          SYSDATE+14,
          V_ROUTE
        );
    END IF;
  END LOOP;
END;
/

-- remedy
--
SELECT * FROM HRIS_NOTIFICATION WHERE MESSAGE_TITLE='Compulsory OT';
SELECT *
FROM HRIS_OVERTIME
WHERE DESCRIPTION='THIS IS AUTOGENERATED OT REQUEST FROM COMPULSORY OT.';
--
DELETE FROM HRIS_NOTIFICATION WHERE MESSAGE_TITLE='Compulsory OT';
DELETE
FROM HRIS_OVERTIME_DETAIL
WHERE OVERTIME_ID IN
  (SELECT OVERTIME_ID
  FROM HRIS_OVERTIME
  WHERE DESCRIPTION='THIS IS AUTOGENERATED OT REQUEST FROM COMPULSORY OT.'
  );
DELETE
FROM HRIS_OVERTIME
WHERE DESCRIPTION='THIS IS AUTOGENERATED OT REQUEST FROM COMPULSORY OT.';