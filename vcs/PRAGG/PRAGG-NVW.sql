--------------------------------------------------------
--  DDL for View NVW_LEDGER
--------------------------------------------------------
SELECT DISTINCT   ( LEDGER_CODE ) AS "id"  ,(    SELECT DISTINCT     ( MAX(DEPTH) )    FROM TBL_LEDGER   ) AS "maxlev"  ,NAME AS "text"  ,PARENT_CODE AS "parent"  ,DEPTH AS "level"  FROM TBL_LEDGER  START WITH   PARENT_CODE IS NULL  CONNECT BY   PRIOR LEDGER_CODE = PARENT_CODE  ORDER BY LEDGER_CODE
--------------------------------------------------------
--  DDL for View NVW_LEDGER_TREE
--------------------------------------------------------
SELECT   PARENT_CODE "parent"  ,NAME "text"  ,DEPTH "level"  ,LEDGER_CODE "id"  ,BALANCE "value"  FROM TBL_LEDGER_ARCHIVE
--------------------------------------------------------
--  DDL for View NVW_LOG_BRIEF
--------------------------------------------------------
WITH TMP AS ( SELECT REF_LOG,  SUM(CASE  WHEN NAM LIKE '%TIME%'  THEN ROUND(TO_NUMBER(MEGHDAR)/1000,1)  ELSE 0  END) ZAMAN_KOL, SUM(CASE   WHEN NAM LIKE '%NEGASHT%'  THEN ROUND(TO_NUMBER(MEGHDAR)/1000,1)  ELSE 0 END) ZAMAN_NEGASHT, MAX(CASE WHEN NAM LIKE 'TOTAL_CNT' THEN MEGHDAR ELSE NULL END) TEDAD_KOL FROM TBL_LOG_DETAIL GROUP BY REF_LOG ORDER BY REF_LOG) SELECT   T.REF_LOG,                L.TARIKH_EJRA,                L.NAM_BANK,                TO_CHAR( T.TEDAD_KOL, '999,999,999,999') TEDAD_KOL,                TO_CHAR(to_date(ROUND(T.ZAMAN_KOL,0),'SSSSS'),'HH24:MI:SS') ZAMAN_KOL,                 TO_CHAR(to_date(ROUND(T.ZAMAN_NEGASHT,0),'SSSSS'),'HH24:MI:SS') ZAMAN_NEGHASHT,                TO_CHAR(to_date(ROUND(T.ZAMAN_KOL - T.ZAMAN_NEGASHT,0),'SSSSS'),'HH24:MI:SS') ZAMAN_DIGAR  FROM TMP T JOIN  TBL_LOG L ON T.REF_LOG = L.ID
