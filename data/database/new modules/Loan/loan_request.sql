
DECLARE
V_LOAN_REQUEST_ID NUMBER;
V_LOAN_ID NUMBER;
V_LOAN_STATUS VARCHAR2(6 BYTE);
V_EMP_COUNT NUMBER;
V_PAYMENT_ID NUMBER;
BEGIN

FOR LOAN_REQUEST_LIST IN (
SELECT * FROM SCP_EMP.Hr_Advance_Request
)
LOOP

SELECT LOAN_ID INTO V_LOAN_ID FROM Hris_Loan_Master_Setup WHERE LOAN_CODE=LOAN_REQUEST_LIST.ADVANCE_TYPE;

--SELECT NVL(MAX(LOAN_REQUEST_ID),0)+1 INTO V_LOAN_REQUEST_ID FROM HRIS_EMPLOYEE_LOAN_REQUEST;

BEGIN
IF (LOAN_REQUEST_LIST.STATUS='C')
THEN 
V_LOAN_STATUS:='CLOSED';
ELSE
V_LOAN_STATUS:='OPEN';
END IF;
END;


SELECT COUNT(*) INTO V_EMP_COUNT FROM HRIS_EMPLOYEES WHERE EMPLOYEE_ID=LOAN_REQUEST_LIST.EMPLOYEE_CODE;

IF(V_EMP_COUNT>0)
THEN

INSERT INTO 
HRIS_EMPLOYEE_LOAN_REQUEST(
LOAN_REQUEST_ID,
EMPLOYEE_ID,
LOAN_ID,
REQUESTED_AMOUNT,
REQUESTED_DATE,
LOAN_DATE,
REASON,
STATUS,
RECOMMENDED_BY,
RECOMMENDED_DATE,
RECOMMENDED_REMARKS,
APPROVED_BY,
APPROVED_DATE,
APPROVED_REMARKS,
DEDUCT_ON_SALARY,
REPAYMENT_MONTHS,
LOAN_STATUS,
INTEREST_RATE,
MODIFIED_DATE
)
VALUES
(
LOAN_REQUEST_LIST.REQUEST_NO,
LOAN_REQUEST_LIST.EMPLOYEE_CODE,
V_LOAN_ID,
LOAN_REQUEST_LIST.REQUEST_AMOUNT,
LOAN_REQUEST_LIST.REQUEST_DATE,
LOAN_REQUEST_LIST.REQUEST_DATE,
'MIGRATION FROM EMPOWER',
'AP',
NULL,
NULL,
NULL,
NULL,
NULL,
NULL,
'Y',
LOAN_REQUEST_LIST.REPAYMENT_COUNT,
V_LOAN_STATUS,
LOAN_REQUEST_LIST.INT_RATE,
LOAN_REQUEST_LIST.MODIFY_DATE
);

-- TO INSERT IN TO DETAILS START





FOR PD_LIST IN (
select * from SCP0218.Hr_Advance_Request_Detail WHERE Request_No=LOAN_REQUEST_LIST.REQUEST_NO ORDER BY SERIAL_NO
)
LOOP

SELECT  NVL(MAX(PAYMENT_ID),0)+1 INTO V_PAYMENT_ID FROM HRIS_LOAN_PAYMENT_DETAIL;





INSERT INTO HRIS_LOAN_PAYMENT_DETAIL
(
PAYMENT_ID,
LOAN_REQUEST_ID,
SNO,
FROM_DATE,
TO_DATE,
AMOUNT,
PAID_FLAG,
INTEREST_AMOUNT,
PRINCIPLE_AMOUNT,
DAYS,
--VOUCHER_NO,
STATUS,
REMARKS,
CREATED_DT
)
VALUES
(
V_PAYMENT_ID,
PD_LIST.REQUEST_NO,
PD_LIST.SERIAL_NO,
PD_LIST.FROM_DATE,
PD_LIST.TO_DATE,
PD_LIST.AMOUNT,
CASE WHEN PD_LIST.PAID_FLAG IS NULL THEN 'N'
ELSE PD_LIST.PAID_FLAG END,
PD_LIST.INT_AMOUNT,
PD_LIST.PRINCIPAL,
PD_LIST.DAYS,
--PD_LIST.VOUCHER_NO,
'E',
'MIGRATED FROM EMPOWER',
TRUNC(SYSDATE)
);

END LOOP;


-- TO INSERT INTO DETAILS END





END IF;




END LOOP;

END;