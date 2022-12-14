CREATE OR REPLACE FUNCTION HRIS_GET_FULL_FORM(
    P_SHORT_FORM VARCHAR2,
    P_OF         VARCHAR2)
  RETURN VARCHAR2
IS
  V_FULL_FORM VARCHAR2(255 BYTE);
BEGIN
  IF (P_OF      = 'TRANSPORT_TYPE') THEN
    V_FULL_FORM:=
    (
      CASE P_SHORT_FORM
      WHEN 'AP' THEN
        'AEROPLANE'
      WHEN 'OV'THEN
        'OFFICE VEHICLE'
      WHEN 'TI' THEN
        'TAXI'
      WHEN 'BS' THEN
        'BUS'
      WHEN 'OF' THEN
        'ON FOOT'
      END);
  END IF;
RETURN V_FULL_FORM;
END;