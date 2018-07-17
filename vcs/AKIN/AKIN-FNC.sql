--------------------------------------------------------
--  DDL for Function FNC_CHECK_VALID_DATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "AKIN"."FNC_CHECK_VALID_DATE" (
    SRCD_GHST_DATE NUMBER)
 RETURN date
AS
  V_OLDDATE_LEN NUMBER ;
  v_Newdate     VARCHAR2(20) ;
BEGIN
  V_OLDDATE_LEN := LENGTH(SRCD_GHST_DATE);
  CASE
  WHEN V_OLDDATE_LEN=3 THEN
    V_NEWDATE      := '14000' || TO_CHAR(SRCD_GHST_DATE) ;
  WHEN V_OLDDATE_LEN=4 THEN
    V_NEWDATE      := '1400' || TO_CHAR(SRCD_GHST_DATE) ;
  WHEN V_OLDDATE_LEN=5 THEN
    V_NEWDATE      := '140' || TO_CHAR(SRCD_GHST_DATE) ;
  WHEN V_OLDDATE_LEN=6 THEN
   
  CASE
  WHEN (SUBSTR(SRCD_GHST_DATE, 1,2) < 60 ) THEN
      V_NEWDATE      := '14' || TO_CHAR(SRCD_GHST_DATE) ;
  ELSE
     V_NEWDATE      := '13' || TO_CHAR(SRCD_GHST_DATE) ;
  END CASE ;
   
  ELSE
    RETURN null ;
  END CASE ;
  CASE
  WHEN (SUBSTR((V_NEWDATE), 7,2) BETWEEN 1 AND 32) AND (SUBSTR((V_NEWDATE), 5,2) BETWEEN 1 AND 12) THEN
    RETURN to_date( v_NEWDATE,'yy/mm/dd','nls_calendar=persian') ;
    -- RETURN V_NEWDATE ;
  ELSE
    RETURN null ;
  END CASE ;
END ;
