CREATE OR REPLACE PROCEDURE HRIS_UPDATE_EMPLOYEE_SERVICE(
    P_JOB_HISTORY_ID HRIS_JOB_HISTORY.JOB_HISTORY_ID%TYPE)
AS
BEGIN
  DECLARE
    JOB_HISTORY HRIS_JOB_HISTORY%ROWTYPE;
    IS_LATEST NUMBER:=0;
  BEGIN
    SELECT *
    INTO JOB_HISTORY
    FROM HRIS_JOB_HISTORY
    WHERE JOB_HISTORY_ID=P_JOB_HISTORY_ID AND STATUS = 'E';
    SELECT COUNT(*)
    INTO IS_LATEST
    FROM
      (SELECT MAX(START_DATE) AS MAX_START_DATE
      FROM HRIS_JOB_HISTORY
      WHERE EMPLOYEE_ID=JOB_HISTORY.EMPLOYEE_ID AND STATUS = 'E'
      GROUP BY EMPLOYEE_ID
      ) H
    WHERE H.MAX_START_DATE=JOB_HISTORY.START_DATE;
    IF (IS_LATEST         >0 AND JOB_HISTORY.START_DATE<=TRUNC(SYSDATE) ) THEN
      UPDATE HRIS_EMPLOYEES
      SET BRANCH_ID           =JOB_HISTORY.TO_BRANCH_ID,
        DEPARTMENT_ID         =JOB_HISTORY.TO_DEPARTMENT_ID,
        DESIGNATION_ID        =JOB_HISTORY.TO_DESIGNATION_ID,
        POSITION_ID           =JOB_HISTORY.TO_POSITION_ID,
        SERVICE_TYPE_ID       =JOB_HISTORY.TO_SERVICE_TYPE_ID,
        SERVICE_EVENT_TYPE_ID =JOB_HISTORY.SERVICE_EVENT_TYPE_ID,
        COMPANY_ID            =JOB_HISTORY.TO_COMPANY_ID,
        SALARY                = JOB_HISTORY.TO_SALARY,
        RETIRED_FLAG          = JOB_HISTORY.RETIRED_FLAG,
        STATUS                = (
        CASE
          WHEN JOB_HISTORY.DISABLED_FLAG = 'Y'
          THEN 'D'
          ELSE 'E'
        END)
      WHERE EMPLOYEE_ID =JOB_HISTORY.EMPLOYEE_ID;
    END IF;
  END;
END HRIS_UPDATE_EMPLOYEE_SERVICE; 