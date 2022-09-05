
-- INSERT HR_SAL_SHEET_SETUP  INTO HRIS_LOCATIONS
INSERT INTO HRIS_LOCATIONS (
  LOCATION_ID,
  LOCATION_CODE,
  LOCATION_EDESC,
  CREATED_DT,
  STATUS
)  (
  SELECT
   SAL_SHEET_CODE,
    SAL_SHEET_CODE,
    SAL_SHEET_EDESC,
    TRUNC(SYSDATE),
    'E'
  FROM
    HR_SAL_SHEET_SETUP
);

/

EXEC HRIS_MIG_COMPANY;
/
EXEC HRIS_MIG_BRANCH;
/
EXEC HRIS_MIG_DEPARTMENT;
/
EXEC HRIS_MIG_DESIGNATION;
/
EXEC HRIS_MIG_POSITION;
/
EXEC HRIS_MIG_SERVICE_TYPE;
/
EXEC HRIS_MIG_EMPLOYEE;
/