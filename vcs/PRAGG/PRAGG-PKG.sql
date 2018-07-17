--------------------------------------------------------
--  DDL for Table PKG_CURRENCY_SENSIVITY
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CURRENCY_SENSIVITY" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*=============================================================*/
 FUNCTION FNC_GET_QUERY_CUR_SENS ( VAR VARCHAR2 ) RETURN VARCHAR2;
/*=============================================================*/

 FUNCTION FNC_GET_QUERY_DATE_CUR_SENS ( VAR VARCHAR2 ) RETURN VARCHAR2;
/*=============================================================*/

 FUNCTION FNC_GET_QUERY_INFO_CUR_SENS ( INAPR_REPORT_ID IN NUMBER ) RETURN VARCHAR2;
/*=============================================================*/

 FUNCTION FNC_GET_RATE_CUR_SECS ( INAPR_REPORT_ID IN NUMBER ) RETURN VARCHAR2;
/*=============================================================*/

 PROCEDURE PRC_CHANGING_CURRENCY (
  INPAR_REPORT_ID     IN VARCHAR2
 ,INPAR_CHANGE_RATE   IN NUMBER
 ,INPAR_CURRENCY      IN VARCHAR2
 ,OUTPUT              OUT VARCHAR2
 );
/*=============================================================*/

 FUNCTION FNC_GET_TITLE_CUR_SECS ( VAR IN NUMBER ) RETURN VARCHAR2;
/*=============================================================*/

 PROCEDURE PRC_CUR_SENSIVITY_REPORT (
  VAR_REF_ID_REPORT   IN NUMBER
 ,VAR_QUERY_CUR       OUT VARCHAR2
 );
/*=============================================================*/

 PROCEDURE PRC_REP_DETAI_PROFIL_CUR_SENS (
  INPAR_REF_REPORT_ID   IN NUMBER
 ,INPAR_NAME            IN VARCHAR2
 ,INPAR_PROFILE_ID      IN NUMBER
 ,OUTPUT                OUT VARCHAR2
 );
/*=============================================================*/

 PROCEDURE PRC_DELETE_REPORT (
  INPAR_ID   IN NUMBER
 ,OUTPAR     OUT VARCHAR2
 );
/*=============================================================*/

 FUNCTION FNC_GET_CUR_RATE ( VAR IN NUMBER ) RETURN VARCHAR2;
 /*=============================================================*/

 PROCEDURE PRC_REPORT_CUR_SENS (
  INPAR_INSERT_OR_UPDATE   IN NUMBER
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_DEC                IN VARCHAR2
 ,INPAR_BRANCH_ID          IN NUMBER
 ,INPAR_CATEGORY           IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_DATE               IN VARCHAR2
 ,OUTPAR_ID                OUT NUMBER
 );
 /*=============================================================*/

END PKG_CURRENCY_SENSIVITY;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_CURRENCY_SENSIVITY" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_GET_QUERY_DATE_CUR_SENS ( VAR VARCHAR2 ) RETURN VARCHAR2 AS
  VAR_QUERY   VARCHAR2(3000);
 BEGIN
  VAR_QUERY   := VAR;
  VAR_QUERY   := 'SELECT  WMSYS.Wm_Concat(to_char( "date",''yyyy/mm/dd'',''nls_calendar=persian'')) as "date"
FROM  (SELECT distinct
 EFF_DATE "date"
FROM TBL_LEDGER_BRANCH)'
;
  RETURN VAR_QUERY;
 END FNC_GET_QUERY_DATE_CUR_SENS;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 FUNCTION FNC_GET_QUERY_CUR_SENS ( VAR VARCHAR2 ) RETURN VARCHAR2 AS
  VAR_QUERY    VARCHAR2(3000);
  VAR_QUERY2   VARCHAR2(3000);
  VAR_CUR      VARCHAR2(3000);
 BEGIN
  VAR_CUR   := VAR;
  SELECT
   WM_CONCAT(ID)
  INTO
   VAR_CUR
  FROM (
    SELECT DISTINCT
     TLA.REF_CUR_ID AS ID
    FROM TBL_LEDGER_ARCHIVE TLA
    ,    TBL_CURRENCY TC
    WHERE TLA.REF_CUR_ID   = TC.CUR_ID
     AND
      TLA.REF_CUR_ID <> 4
   );

  SELECT
   WM_CONCAT('nvl("' ||
   ID ||
   '",0) as "' ||
   ID ||
   '"')
  INTO
   VAR_QUERY2
  FROM (
    SELECT DISTINCT
     TLA.REF_CUR_ID AS ID
    FROM TBL_LEDGER_ARCHIVE TLA
    ,    TBL_CURRENCY TC
    WHERE TLA.REF_CUR_ID   = TC.CUR_ID
     AND
      TLA.REF_CUR_ID <> 4
   );

  SELECT
   'SELECT name as "name",PROFILE_ID as  "id",
 ' ||
   VAR_QUERY2 ||
   '
FROM (
  SELECT
   name,MANDE,REF_CURRENCY,PROFILE_ID
  FROM TBL_CUR_SENSIVITY_REPORT where REF_REPORT =' ||
   VAR ||
   '
 )
  PIVOT ( MAX ( MANDE )
   FOR REF_CURRENCY
   IN ( ' ||
   VAR_CUR ||
   ')
  )
 '
  INTO
   VAR_QUERY
  FROM DUAL;

  RETURN VAR_QUERY;
 END FNC_GET_QUERY_CUR_SENS;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 FUNCTION FNC_GET_QUERY_INFO_CUR_SENS ( INAPR_REPORT_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR_QUERY   VARCHAR2(3000);
 BEGIN
  VAR_QUERY   := 'SELECT
 NAME as "name"
 ,DES as "des"
 ,REF_BRN_PROFILE "branch",
  BALANCE_SENSIVITY as "balance",
   to_char(CREATE_DATE,''yyyy/mm/dd'',''nls_calendar=persian'') AS "sensitiveDate"
FROM TBL_REPORT
WHERE ID   = '
|| INAPR_REPORT_ID || '';
  RETURN VAR_QUERY;
 END FNC_GET_QUERY_INFO_CUR_SENS;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 FUNCTION FNC_GET_RATE_CUR_SECS ( INAPR_REPORT_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR_QUERY   VARCHAR2(3000);
 BEGIN
  VAR_QUERY   := 'SELECT
 tcc.CHANGE_RATE "rate"
 ,tcc.CURRENCY "id"
 ,TC.CUR_NAME "name"
FROM TBL_CHANGE_CURRENCY tcc,TBL_CURRENCY tc
where tcc.CURRENCY <> 4 and TC.CUR_ID = TCC.CURRENCY
and TCC.REPORT_ID='
|| INAPR_REPORT_ID || '';
  RETURN VAR_QUERY;
 END FNC_GET_RATE_CUR_SECS;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 FUNCTION FNC_GET_TITLE_CUR_SECS ( VAR IN NUMBER ) RETURN VARCHAR2 AS
  VAR_QUERY   VARCHAR2(3000);
 BEGIN
  VAR_QUERY   := VAR;
  VAR_QUERY   := 'SELECT DISTINCT tla.REF_CUR_ID "id" ,TC.CUR_NAME "name" FROM TBL_LEDGER_ARCHIVE tla,TBL_CURRENCY tc where 
TLA.REF_CUR_ID = TC.CUR_ID
and tla.REF_CUR_ID <> 4'
;
  RETURN VAR_QUERY;
 END FNC_GET_TITLE_CUR_SECS;

 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 PROCEDURE PRC_CUR_SENSIVITY_REPORT (
  VAR_REF_ID_REPORT   IN NUMBER
 ,VAR_QUERY_CUR       OUT VARCHAR2
 ) AS

  ID_BRANCH    NUMBER;
  VAR_DATE     DATE;
  ID_LEDGER    NUMBER;
  VAR_QUERY    VARCHAR2(30000);
  SUM_REPORT   VARCHAR2(30000);
 BEGIN
 
 delete from TBL_CUR_SENSIVITY_REPORT where REF_REPORT = VAR_REF_ID_REPORT;
 commit;
 
  SELECT
   REF_BRN_PROFILE
  INTO
   ID_BRANCH
  FROM TBL_REPORT
  WHERE ID   = VAR_REF_ID_REPORT;

  SELECT
   CREATE_DATE
  INTO
   VAR_DATE
  FROM TBL_REPORT
  WHERE ID   = VAR_REF_ID_REPORT;

  FOR I IN (
   SELECT
    TRD.REF_ID
   ,TRD.NAME
   ,TRD.PROFILE_ID
   ,ARZ."id"
   FROM TBL_REP_DETAIL_PROFIL_CUR_SECS TRD
   ,    (
     SELECT DISTINCT
      TLA.REF_CUR_ID "id"
     FROM TBL_LEDGER_ARCHIVE TLA
     ,    TBL_CURRENCY TC
     WHERE TLA.REF_CUR_ID   = TC.CUR_ID
      AND
       TLA.REF_CUR_ID <> 4
    ) ARZ
   WHERE TRD.REF_ID   = VAR_REF_ID_REPORT
  ) LOOP
   SELECT
    NVL(
     PKG_LEDGER_REPORT_MAP.FNC_GI_CALC(
      I.PROFILE_ID
     ,VAR_REF_ID_REPORT
     ,I."id"
     ,VAR_DATE
     )
    ,0
    )
   INTO
    SUM_REPORT
   FROM DUAL;

   INSERT INTO TBL_CUR_SENSIVITY_REPORT (
    NAME
   ,REF_CURRENCY
   ,MANDE
   ,PROFILE_ID
   ,REF_REPORT
   ) VALUES (
    I.NAME
   ,I."id"
   ,SUM_REPORT
   ,I.PROFILE_ID
   ,I.REF_ID
   );

  END LOOP;

  COMMIT;
  INSERT INTO TBL_CUR_SENSIVITY_REPORT ( NAME,REF_CURRENCY,MANDE ) SELECT
   B.NAME
  ,A.ID
  ,0
  FROM (
    SELECT DISTINCT
     TLA.REF_CUR_ID AS ID
    FROM TBL_LEDGER_ARCHIVE TLA
    ,    TBL_CURRENCY TC
    WHERE TLA.REF_CUR_ID   = TC.CUR_ID
     AND
      TLA.REF_CUR_ID NOT IN (
       SELECT
        TBL_CUR_SENSIVITY_REPORT.REF_CURRENCY
       FROM TBL_CUR_SENSIVITY_REPORT
      )
     AND
      TLA.REF_CUR_ID <> 4
   ) A
  ,    (
    SELECT DISTINCT
     NAME
    FROM TBL_CUR_SENSIVITY_REPORT
   ) B;

  COMMIT;
  INSERT INTO TBL_CUR_SENSIVITY_REPORT (
   NAME
  ,REF_CURRENCY
  ,MANDE
  ,PROFILE_ID
  ) ( SELECT
   NAME
  ,1
  ,0
  ,PROFILE_ID
  FROM TBL_REP_DETAIL_PROFIL_CUR_SECS
  WHERE REF_ID   = 460
   AND
    NAME NOT IN (
     SELECT DISTINCT
      NAME
     FROM TBL_CUR_SENSIVITY_REPORT
    )
  );

  COMMIT;
  UPDATE TBL_REPORT
   SET
    BALANCE_SENSIVITY = (
     SELECT
      SUM(SUM_RIAL)
     FROM (
       SELECT
        B."id"
       ,A.ARZ * B."rate" AS SUM_RIAL
       FROM (
         SELECT
          A.REF_CURRENCY
         ,A.A - B.B ARZ
         FROM (
           SELECT
            REF_CURRENCY
           ,
            SUM(MANDE) A
           FROM TBL_CUR_SENSIVITY_REPORT
           WHERE NAME IN (
             'b1','a1'
            )
           GROUP BY
            REF_CURRENCY
          ) A
         ,    (
           SELECT
            REF_CURRENCY
           ,
            SUM(MANDE) B
           FROM TBL_CUR_SENSIVITY_REPORT
           WHERE NAME IN (
             'b2','a2'
            )
           GROUP BY
            REF_CURRENCY
          ) B
         WHERE A.REF_CURRENCY   = B.REF_CURRENCY
        ) A
       ,    (
         SELECT
          "id"
         ,NVL(CHANGE_RATE,0) "rate"
         FROM (
           SELECT DISTINCT
            TLA.REF_CUR_ID "id"
           ,
            TC.CUR_NAME "name"
           FROM TBL_LEDGER_ARCHIVE TLA
           ,
                TBL_CURRENCY TC
           WHERE TLA.REF_CUR_ID   = TC.CUR_ID
          ) A
          LEFT JOIN (
           SELECT
            *
           FROM TBL_CURRENCY_REL TCR
           WHERE TCR.REL_DATE                = (
             SELECT
              MAX(REL_DATE)
             FROM TBL_CURRENCY_REL
             WHERE TBL_CURRENCY_REL.REL_DATE   = (
               SELECT
                MAX(REL_DATE)
               FROM TBL_CURRENCY_REL
              )
            )
          ) B ON A."id"   = B.SRC_CUR_ID
         WHERE "id" <> 4
        ) B
       WHERE A.REF_CURRENCY   = B."id"
      )
    )
  WHERE ID   = VAR_REF_ID_REPORT;

  COMMIT;
  UPDATE TBL_CUR_SENSIVITY_REPORT T
   SET
    T.PROFILE_ID = (
     SELECT DISTINCT
      C.PROFILE_ID
     FROM TBL_REP_DETAIL_PROFIL_CUR_SECS C
     WHERE C.REF_ID   = VAR_REF_ID_REPORT
      AND
       C.NAME     = T.NAME
    );

  COMMIT;
  SELECT
   PKG_CURRENCY_SENSIVITY.FNC_GET_QUERY_CUR_SENS(VAR_REF_ID_REPORT)
  INTO
   VAR_QUERY_CUR
  FROM DUAL;

 END PRC_CUR_SENSIVITY_REPORT;

 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 PROCEDURE PRC_REP_DETAI_PROFIL_CUR_SENS (
  INPAR_REF_REPORT_ID   IN NUMBER /*output of PRC_REPORT_CUR_SENS ==>*/
 ,INPAR_NAME            IN VARCHAR2
 ,INPAR_PROFILE_ID      IN NUMBER
 ,OUTPUT                OUT VARCHAR2
 )
  AS
 BEGIN
  INSERT INTO TBL_REP_DETAIL_PROFIL_CUR_SECS ( REF_ID,NAME,PROFILE_ID ) VALUES ( INPAR_REF_REPORT_ID,INPAR_NAME,INPAR_PROFILE_ID );

  OUTPUT   := NULL;
 END PRC_REP_DETAI_PROFIL_CUR_SENS;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/

 PROCEDURE PRC_DELETE_REPORT (
  INPAR_ID   IN NUMBER
 ,OUTPAR     OUT VARCHAR2
 ) AS
  VAR_CATEGORY   VARCHAR2(200);
 BEGIN
  SELECT
   CATEGORY
  INTO
   VAR_CATEGORY
  FROM TBL_REPORT
  WHERE H_ID   = INPAR_ID;

  IF
   ( UPPER(VAR_CATEGORY) != 'SENSITIVE' )
  THEN   /* hameye gozareshha be joz gozareshat "SENSITIVE"*/
   UPDATE TBL_REPORT
    SET
     STATUS = 0
   WHERE H_ID   = INPAR_ID;

   OUTPAR   := NULL;
  END IF;

 EXCEPTION
  WHEN NO_DATA_FOUND THEN
   SELECT
    CATEGORY
   INTO
    VAR_CATEGORY
   FROM TBL_REPORT
   WHERE ID   = INPAR_ID;

   IF
    ( UPPER(VAR_CATEGORY) = 'SENSITIVE' )
   THEN
    DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

    DELETE FROM TBL_REP_DETAIL_PROFIL_CUR_SECS WHERE REF_ID   = INPAR_ID;

   END IF;

 END PRC_DELETE_REPORT;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 FUNCTION FNC_GET_CUR_RATE ( VAR IN NUMBER ) RETURN VARCHAR2 AS
  VAR_QUERY   VARCHAR2(3000);
 BEGIN
  VAR_QUERY   := VAR;
  VAR_QUERY   := 'select "id","name",nvl(change_rate,0) "rate" from (SELECT DISTINCT tla.REF_CUR_ID "id" ,TC.CUR_NAME "name" FROM TBL_LEDGER_ARCHIVE tla,TBL_CURRENCY tc where 
TLA.REF_CUR_ID = TC.CUR_ID)a left join (select * from TBL_CURRENCY_REL tcr where tcr.rel_date = (select max(rel_date)from TBL_CURRENCY_REL ))b
on a."id" = b.SRC_CUR_ID where "id" <> 4'
;
  RETURN VAR_QUERY;
 END FNC_GET_CUR_RATE;

 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 PROCEDURE PRC_CHANGING_CURRENCY (
  INPAR_REPORT_ID     IN VARCHAR2
 ,INPAR_CHANGE_RATE   IN NUMBER
 ,INPAR_CURRENCY      IN VARCHAR2
 ,OUTPUT              OUT VARCHAR2
 )
  AS
 BEGIN
  INSERT INTO TBL_CHANGE_CURRENCY ( REPORT_ID,CHANGE_RATE,CURRENCY ) VALUES ( INPAR_REPORT_ID,INPAR_CHANGE_RATE,INPAR_CURRENCY );

 END PRC_CHANGING_CURRENCY;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 PROCEDURE PRC_REPORT_CUR_SENS (
  INPAR_INSERT_OR_UPDATE   IN NUMBER
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_DEC                IN VARCHAR2
 ,INPAR_BRANCH_ID          IN NUMBER
 ,INPAR_CATEGORY           IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_DATE               IN VARCHAR2
 ,OUTPAR_ID                OUT NUMBER
 )
  AS
 BEGIN
/*if  :  inpar_insert_or_update=-1  ==>insert  else update */
  IF
   ( INPAR_INSERT_OR_UPDATE =-1 )
  THEN  /*insert*/
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,REF_BRN_PROFILE
   ,CATEGORY
   ,TYPE
   ,CREATE_DATE
   ,STATUS /*alaki*/
   ) VALUES (
    INPAR_NAME
   ,INPAR_DEC
   ,INPAR_BRANCH_ID
   ,INPAR_CATEGORY
   ,INPAR_TYPE
   ,TO_DATE(INPAR_DATE,'yyyy/mm/dd','nls_calendar=persian')
   ,1 /*alaki*/
   );

   SELECT
    MAX(ID)
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CATEGORY   = INPAR_CATEGORY;
 /**/

   DELETE FROM TBL_CHANGE_CURRENCY WHERE REPORT_ID   = OUTPAR_ID;

  ELSE /*  !=-1  ==> update (id report)*/
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DEC
    ,REF_BRN_PROFILE = INPAR_BRANCH_ID
   WHERE ID   = INPAR_INSERT_OR_UPDATE;

   OUTPAR_ID   := INPAR_INSERT_OR_UPDATE;
   DELETE FROM TBL_REP_DETAIL_PROFIL_CUR_SECS WHERE REF_ID   = INPAR_INSERT_OR_UPDATE;

   DELETE FROM TBL_CHANGE_CURRENCY WHERE REPORT_ID   = INPAR_INSERT_OR_UPDATE;

  END IF;
 END PRC_REPORT_CUR_SENS;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
END PKG_CURRENCY_SENSIVITY;
--------------------------------------------------------
--  DDL for Table PKG_CURRENCY_SENSIVITY
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CURRENCY_SENSIVITY" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*=============================================================*/
 FUNCTION FNC_GET_QUERY_CUR_SENS ( VAR VARCHAR2 ) RETURN VARCHAR2;
/*=============================================================*/

 FUNCTION FNC_GET_QUERY_DATE_CUR_SENS ( VAR VARCHAR2 ) RETURN VARCHAR2;
/*=============================================================*/

 FUNCTION FNC_GET_QUERY_INFO_CUR_SENS ( INAPR_REPORT_ID IN NUMBER ) RETURN VARCHAR2;
/*=============================================================*/

 FUNCTION FNC_GET_RATE_CUR_SECS ( INAPR_REPORT_ID IN NUMBER ) RETURN VARCHAR2;
/*=============================================================*/

 PROCEDURE PRC_CHANGING_CURRENCY (
  INPAR_REPORT_ID     IN VARCHAR2
 ,INPAR_CHANGE_RATE   IN NUMBER
 ,INPAR_CURRENCY      IN VARCHAR2
 ,OUTPUT              OUT VARCHAR2
 );
/*=============================================================*/

 FUNCTION FNC_GET_TITLE_CUR_SECS ( VAR IN NUMBER ) RETURN VARCHAR2;
/*=============================================================*/

 PROCEDURE PRC_CUR_SENSIVITY_REPORT (
  VAR_REF_ID_REPORT   IN NUMBER
 ,VAR_QUERY_CUR       OUT VARCHAR2
 );
/*=============================================================*/

 PROCEDURE PRC_REP_DETAI_PROFIL_CUR_SENS (
  INPAR_REF_REPORT_ID   IN NUMBER
 ,INPAR_NAME            IN VARCHAR2
 ,INPAR_PROFILE_ID      IN NUMBER
 ,OUTPUT                OUT VARCHAR2
 );
/*=============================================================*/

 PROCEDURE PRC_DELETE_REPORT (
  INPAR_ID   IN NUMBER
 ,OUTPAR     OUT VARCHAR2
 );
/*=============================================================*/

 FUNCTION FNC_GET_CUR_RATE ( VAR IN NUMBER ) RETURN VARCHAR2;
 /*=============================================================*/

 PROCEDURE PRC_REPORT_CUR_SENS (
  INPAR_INSERT_OR_UPDATE   IN NUMBER
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_DEC                IN VARCHAR2
 ,INPAR_BRANCH_ID          IN NUMBER
 ,INPAR_CATEGORY           IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_DATE               IN VARCHAR2
 ,OUTPAR_ID                OUT NUMBER
 );
 /*=============================================================*/

END PKG_CURRENCY_SENSIVITY;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_CURRENCY_SENSIVITY" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_GET_QUERY_DATE_CUR_SENS ( VAR VARCHAR2 ) RETURN VARCHAR2 AS
  VAR_QUERY   VARCHAR2(3000);
 BEGIN
  VAR_QUERY   := VAR;
  VAR_QUERY   := 'SELECT  WMSYS.Wm_Concat(to_char( "date",''yyyy/mm/dd'',''nls_calendar=persian'')) as "date"
FROM  (SELECT distinct
 EFF_DATE "date"
FROM TBL_LEDGER_BRANCH)'
;
  RETURN VAR_QUERY;
 END FNC_GET_QUERY_DATE_CUR_SENS;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 FUNCTION FNC_GET_QUERY_CUR_SENS ( VAR VARCHAR2 ) RETURN VARCHAR2 AS
  VAR_QUERY    VARCHAR2(3000);
  VAR_QUERY2   VARCHAR2(3000);
  VAR_CUR      VARCHAR2(3000);
 BEGIN
  VAR_CUR   := VAR;
  SELECT
   WM_CONCAT(ID)
  INTO
   VAR_CUR
  FROM (
    SELECT DISTINCT
     TLA.REF_CUR_ID AS ID
    FROM TBL_LEDGER_ARCHIVE TLA
    ,    TBL_CURRENCY TC
    WHERE TLA.REF_CUR_ID   = TC.CUR_ID
     AND
      TLA.REF_CUR_ID <> 4
   );

  SELECT
   WM_CONCAT('nvl("' ||
   ID ||
   '",0) as "' ||
   ID ||
   '"')
  INTO
   VAR_QUERY2
  FROM (
    SELECT DISTINCT
     TLA.REF_CUR_ID AS ID
    FROM TBL_LEDGER_ARCHIVE TLA
    ,    TBL_CURRENCY TC
    WHERE TLA.REF_CUR_ID   = TC.CUR_ID
     AND
      TLA.REF_CUR_ID <> 4
   );

  SELECT
   'SELECT name as "name",PROFILE_ID as  "id",
 ' ||
   VAR_QUERY2 ||
   '
FROM (
  SELECT
   name,MANDE,REF_CURRENCY,PROFILE_ID
  FROM TBL_CUR_SENSIVITY_REPORT where REF_REPORT =' ||
   VAR ||
   '
 )
  PIVOT ( MAX ( MANDE )
   FOR REF_CURRENCY
   IN ( ' ||
   VAR_CUR ||
   ')
  )
 '
  INTO
   VAR_QUERY
  FROM DUAL;

  RETURN VAR_QUERY;
 END FNC_GET_QUERY_CUR_SENS;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 FUNCTION FNC_GET_QUERY_INFO_CUR_SENS ( INAPR_REPORT_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR_QUERY   VARCHAR2(3000);
 BEGIN
  VAR_QUERY   := 'SELECT
 NAME as "name"
 ,DES as "des"
 ,REF_BRN_PROFILE "branch",
  BALANCE_SENSIVITY as "balance",
   to_char(CREATE_DATE,''yyyy/mm/dd'',''nls_calendar=persian'') AS "sensitiveDate"
FROM TBL_REPORT
WHERE ID   = '
|| INAPR_REPORT_ID || '';
  RETURN VAR_QUERY;
 END FNC_GET_QUERY_INFO_CUR_SENS;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 FUNCTION FNC_GET_RATE_CUR_SECS ( INAPR_REPORT_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR_QUERY   VARCHAR2(3000);
 BEGIN
  VAR_QUERY   := 'SELECT
 tcc.CHANGE_RATE "rate"
 ,tcc.CURRENCY "id"
 ,TC.CUR_NAME "name"
FROM TBL_CHANGE_CURRENCY tcc,TBL_CURRENCY tc
where tcc.CURRENCY <> 4 and TC.CUR_ID = TCC.CURRENCY
and TCC.REPORT_ID='
|| INAPR_REPORT_ID || '';
  RETURN VAR_QUERY;
 END FNC_GET_RATE_CUR_SECS;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 FUNCTION FNC_GET_TITLE_CUR_SECS ( VAR IN NUMBER ) RETURN VARCHAR2 AS
  VAR_QUERY   VARCHAR2(3000);
 BEGIN
  VAR_QUERY   := VAR;
  VAR_QUERY   := 'SELECT DISTINCT tla.REF_CUR_ID "id" ,TC.CUR_NAME "name" FROM TBL_LEDGER_ARCHIVE tla,TBL_CURRENCY tc where 
TLA.REF_CUR_ID = TC.CUR_ID
and tla.REF_CUR_ID <> 4'
;
  RETURN VAR_QUERY;
 END FNC_GET_TITLE_CUR_SECS;

 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 PROCEDURE PRC_CUR_SENSIVITY_REPORT (
  VAR_REF_ID_REPORT   IN NUMBER
 ,VAR_QUERY_CUR       OUT VARCHAR2
 ) AS

  ID_BRANCH    NUMBER;
  VAR_DATE     DATE;
  ID_LEDGER    NUMBER;
  VAR_QUERY    VARCHAR2(30000);
  SUM_REPORT   VARCHAR2(30000);
 BEGIN
 
 delete from TBL_CUR_SENSIVITY_REPORT where REF_REPORT = VAR_REF_ID_REPORT;
 commit;
 
  SELECT
   REF_BRN_PROFILE
  INTO
   ID_BRANCH
  FROM TBL_REPORT
  WHERE ID   = VAR_REF_ID_REPORT;

  SELECT
   CREATE_DATE
  INTO
   VAR_DATE
  FROM TBL_REPORT
  WHERE ID   = VAR_REF_ID_REPORT;

  FOR I IN (
   SELECT
    TRD.REF_ID
   ,TRD.NAME
   ,TRD.PROFILE_ID
   ,ARZ."id"
   FROM TBL_REP_DETAIL_PROFIL_CUR_SECS TRD
   ,    (
     SELECT DISTINCT
      TLA.REF_CUR_ID "id"
     FROM TBL_LEDGER_ARCHIVE TLA
     ,    TBL_CURRENCY TC
     WHERE TLA.REF_CUR_ID   = TC.CUR_ID
      AND
       TLA.REF_CUR_ID <> 4
    ) ARZ
   WHERE TRD.REF_ID   = VAR_REF_ID_REPORT
  ) LOOP
   SELECT
    NVL(
     PKG_LEDGER_REPORT_MAP.FNC_GI_CALC(
      I.PROFILE_ID
     ,VAR_REF_ID_REPORT
     ,I."id"
     ,VAR_DATE
     )
    ,0
    )
   INTO
    SUM_REPORT
   FROM DUAL;

   INSERT INTO TBL_CUR_SENSIVITY_REPORT (
    NAME
   ,REF_CURRENCY
   ,MANDE
   ,PROFILE_ID
   ,REF_REPORT
   ) VALUES (
    I.NAME
   ,I."id"
   ,SUM_REPORT
   ,I.PROFILE_ID
   ,I.REF_ID
   );

  END LOOP;

  COMMIT;
  INSERT INTO TBL_CUR_SENSIVITY_REPORT ( NAME,REF_CURRENCY,MANDE ) SELECT
   B.NAME
  ,A.ID
  ,0
  FROM (
    SELECT DISTINCT
     TLA.REF_CUR_ID AS ID
    FROM TBL_LEDGER_ARCHIVE TLA
    ,    TBL_CURRENCY TC
    WHERE TLA.REF_CUR_ID   = TC.CUR_ID
     AND
      TLA.REF_CUR_ID NOT IN (
       SELECT
        TBL_CUR_SENSIVITY_REPORT.REF_CURRENCY
       FROM TBL_CUR_SENSIVITY_REPORT
      )
     AND
      TLA.REF_CUR_ID <> 4
   ) A
  ,    (
    SELECT DISTINCT
     NAME
    FROM TBL_CUR_SENSIVITY_REPORT
   ) B;

  COMMIT;
  INSERT INTO TBL_CUR_SENSIVITY_REPORT (
   NAME
  ,REF_CURRENCY
  ,MANDE
  ,PROFILE_ID
  ) ( SELECT
   NAME
  ,1
  ,0
  ,PROFILE_ID
  FROM TBL_REP_DETAIL_PROFIL_CUR_SECS
  WHERE REF_ID   = 460
   AND
    NAME NOT IN (
     SELECT DISTINCT
      NAME
     FROM TBL_CUR_SENSIVITY_REPORT
    )
  );

  COMMIT;
  UPDATE TBL_REPORT
   SET
    BALANCE_SENSIVITY = (
     SELECT
      SUM(SUM_RIAL)
     FROM (
       SELECT
        B."id"
       ,A.ARZ * B."rate" AS SUM_RIAL
       FROM (
         SELECT
          A.REF_CURRENCY
         ,A.A - B.B ARZ
         FROM (
           SELECT
            REF_CURRENCY
           ,
            SUM(MANDE) A
           FROM TBL_CUR_SENSIVITY_REPORT
           WHERE NAME IN (
             'b1','a1'
            )
           GROUP BY
            REF_CURRENCY
          ) A
         ,    (
           SELECT
            REF_CURRENCY
           ,
            SUM(MANDE) B
           FROM TBL_CUR_SENSIVITY_REPORT
           WHERE NAME IN (
             'b2','a2'
            )
           GROUP BY
            REF_CURRENCY
          ) B
         WHERE A.REF_CURRENCY   = B.REF_CURRENCY
        ) A
       ,    (
         SELECT
          "id"
         ,NVL(CHANGE_RATE,0) "rate"
         FROM (
           SELECT DISTINCT
            TLA.REF_CUR_ID "id"
           ,
            TC.CUR_NAME "name"
           FROM TBL_LEDGER_ARCHIVE TLA
           ,
                TBL_CURRENCY TC
           WHERE TLA.REF_CUR_ID   = TC.CUR_ID
          ) A
          LEFT JOIN (
           SELECT
            *
           FROM TBL_CURRENCY_REL TCR
           WHERE TCR.REL_DATE                = (
             SELECT
              MAX(REL_DATE)
             FROM TBL_CURRENCY_REL
             WHERE TBL_CURRENCY_REL.REL_DATE   = (
               SELECT
                MAX(REL_DATE)
               FROM TBL_CURRENCY_REL
              )
            )
          ) B ON A."id"   = B.SRC_CUR_ID
         WHERE "id" <> 4
        ) B
       WHERE A.REF_CURRENCY   = B."id"
      )
    )
  WHERE ID   = VAR_REF_ID_REPORT;

  COMMIT;
  UPDATE TBL_CUR_SENSIVITY_REPORT T
   SET
    T.PROFILE_ID = (
     SELECT DISTINCT
      C.PROFILE_ID
     FROM TBL_REP_DETAIL_PROFIL_CUR_SECS C
     WHERE C.REF_ID   = VAR_REF_ID_REPORT
      AND
       C.NAME     = T.NAME
    );

  COMMIT;
  SELECT
   PKG_CURRENCY_SENSIVITY.FNC_GET_QUERY_CUR_SENS(VAR_REF_ID_REPORT)
  INTO
   VAR_QUERY_CUR
  FROM DUAL;

 END PRC_CUR_SENSIVITY_REPORT;

 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 PROCEDURE PRC_REP_DETAI_PROFIL_CUR_SENS (
  INPAR_REF_REPORT_ID   IN NUMBER /*output of PRC_REPORT_CUR_SENS ==>*/
 ,INPAR_NAME            IN VARCHAR2
 ,INPAR_PROFILE_ID      IN NUMBER
 ,OUTPUT                OUT VARCHAR2
 )
  AS
 BEGIN
  INSERT INTO TBL_REP_DETAIL_PROFIL_CUR_SECS ( REF_ID,NAME,PROFILE_ID ) VALUES ( INPAR_REF_REPORT_ID,INPAR_NAME,INPAR_PROFILE_ID );

  OUTPUT   := NULL;
 END PRC_REP_DETAI_PROFIL_CUR_SENS;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/

 PROCEDURE PRC_DELETE_REPORT (
  INPAR_ID   IN NUMBER
 ,OUTPAR     OUT VARCHAR2
 ) AS
  VAR_CATEGORY   VARCHAR2(200);
 BEGIN
  SELECT
   CATEGORY
  INTO
   VAR_CATEGORY
  FROM TBL_REPORT
  WHERE H_ID   = INPAR_ID;

  IF
   ( UPPER(VAR_CATEGORY) != 'SENSITIVE' )
  THEN   /* hameye gozareshha be joz gozareshat "SENSITIVE"*/
   UPDATE TBL_REPORT
    SET
     STATUS = 0
   WHERE H_ID   = INPAR_ID;

   OUTPAR   := NULL;
  END IF;

 EXCEPTION
  WHEN NO_DATA_FOUND THEN
   SELECT
    CATEGORY
   INTO
    VAR_CATEGORY
   FROM TBL_REPORT
   WHERE ID   = INPAR_ID;

   IF
    ( UPPER(VAR_CATEGORY) = 'SENSITIVE' )
   THEN
    DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

    DELETE FROM TBL_REP_DETAIL_PROFIL_CUR_SECS WHERE REF_ID   = INPAR_ID;

   END IF;

 END PRC_DELETE_REPORT;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 FUNCTION FNC_GET_CUR_RATE ( VAR IN NUMBER ) RETURN VARCHAR2 AS
  VAR_QUERY   VARCHAR2(3000);
 BEGIN
  VAR_QUERY   := VAR;
  VAR_QUERY   := 'select "id","name",nvl(change_rate,0) "rate" from (SELECT DISTINCT tla.REF_CUR_ID "id" ,TC.CUR_NAME "name" FROM TBL_LEDGER_ARCHIVE tla,TBL_CURRENCY tc where 
TLA.REF_CUR_ID = TC.CUR_ID)a left join (select * from TBL_CURRENCY_REL tcr where tcr.rel_date = (select max(rel_date)from TBL_CURRENCY_REL ))b
on a."id" = b.SRC_CUR_ID where "id" <> 4'
;
  RETURN VAR_QUERY;
 END FNC_GET_CUR_RATE;

 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 PROCEDURE PRC_CHANGING_CURRENCY (
  INPAR_REPORT_ID     IN VARCHAR2
 ,INPAR_CHANGE_RATE   IN NUMBER
 ,INPAR_CURRENCY      IN VARCHAR2
 ,OUTPUT              OUT VARCHAR2
 )
  AS
 BEGIN
  INSERT INTO TBL_CHANGE_CURRENCY ( REPORT_ID,CHANGE_RATE,CURRENCY ) VALUES ( INPAR_REPORT_ID,INPAR_CHANGE_RATE,INPAR_CURRENCY );

 END PRC_CHANGING_CURRENCY;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
 PROCEDURE PRC_REPORT_CUR_SENS (
  INPAR_INSERT_OR_UPDATE   IN NUMBER
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_DEC                IN VARCHAR2
 ,INPAR_BRANCH_ID          IN NUMBER
 ,INPAR_CATEGORY           IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_DATE               IN VARCHAR2
 ,OUTPAR_ID                OUT NUMBER
 )
  AS
 BEGIN
/*if  :  inpar_insert_or_update=-1  ==>insert  else update */
  IF
   ( INPAR_INSERT_OR_UPDATE =-1 )
  THEN  /*insert*/
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,REF_BRN_PROFILE
   ,CATEGORY
   ,TYPE
   ,CREATE_DATE
   ,STATUS /*alaki*/
   ) VALUES (
    INPAR_NAME
   ,INPAR_DEC
   ,INPAR_BRANCH_ID
   ,INPAR_CATEGORY
   ,INPAR_TYPE
   ,TO_DATE(INPAR_DATE,'yyyy/mm/dd','nls_calendar=persian')
   ,1 /*alaki*/
   );

   SELECT
    MAX(ID)
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CATEGORY   = INPAR_CATEGORY;
 /**/

   DELETE FROM TBL_CHANGE_CURRENCY WHERE REPORT_ID   = OUTPAR_ID;

  ELSE /*  !=-1  ==> update (id report)*/
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DEC
    ,REF_BRN_PROFILE = INPAR_BRANCH_ID
   WHERE ID   = INPAR_INSERT_OR_UPDATE;

   OUTPAR_ID   := INPAR_INSERT_OR_UPDATE;
   DELETE FROM TBL_REP_DETAIL_PROFIL_CUR_SECS WHERE REF_ID   = INPAR_INSERT_OR_UPDATE;

   DELETE FROM TBL_CHANGE_CURRENCY WHERE REPORT_ID   = INPAR_INSERT_OR_UPDATE;

  END IF;
 END PRC_REPORT_CUR_SENS;
 /*=============================================================*/
 /*=============================================================*/
 /*=============================================================*/
END PKG_CURRENCY_SENSIVITY;
--------------------------------------------------------
--  DDL for Table PKG_LEDGER_REPORT_MAP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_LEDGER_REPORT_MAP" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*=============================================================*/
 FUNCTION FNC_GI_CALC (
  INPAR_ID           IN NUMBER
 ,INPAR_REF_REPORT   IN NUMBER
 ,INPAR_CUR_ID       IN NUMBER
 ,INPAR_DATE         IN DATE
 ) RETURN VARCHAR2;
/*=============================================================*/

 FUNCTION FNC_AD_FARSIVALIDATE ( STR NVARCHAR2 ) RETURN NVARCHAR2;
/*=============================================================*/

 PROCEDURE PRC_GI_MAP (
  INPAR_NAME            VARCHAR2
 ,INPAR_DESCRIPTION     VARCHAR2
 ,INPAR_FORMUL          VARCHAR2
 ,INPAR_STANDARD_TYPE   VARCHAR2
 ,OUTPAR_ID             OUT VARCHAR2
 );
/*=============================================================*/

 PROCEDURE PRC_DELETE_PROFILE (
  INPAR_ID    IN VARCHAR2
 ,OUTPAR_ID   OUT VARCHAR2
 );
    /*=============================================================*/

 FUNCTION FNC_GET_QUERY_FORMULA ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*=============================================================*/

 FUNCTION FNC_GET_QUERY_FORMULA_PROFILE ( INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2;
/*=============================================================*/

END PKG_LEDGER_REPORT_MAP;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_LEDGER_REPORT_MAP" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_GI_CALC (
  INPAR_ID           IN NUMBER
 ,INPAR_REF_REPORT   IN NUMBER
 ,INPAR_CUR_ID       IN NUMBER
 ,INPAR_DATE         IN DATE
 ) RETURN VARCHAR2 AS
  VAR         CLOB;
  VAR2        CLOB;
  VAR3        CLOB;
  ID_BRANCH   NUMBER;
 BEGIN
  SELECT
   REF_BRN_PROFILE
  INTO
   ID_BRANCH
  FROM TBL_REPORT
  WHERE ID   = INPAR_REF_REPORT;

  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = ' ||
   INPAR_ID ||
   '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_BRANCH DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
      SPLIT_VALUES IS NOT NULL
     AND
      DG.REF_CUR_ID    = ' ||
   INPAR_CUR_ID ||
   '
     AND
      trunc(DG.EFF_DATE)                                          = trunc(TO_DATE(''' ||
   INPAR_DATE ||
   '''))
       and DG.REF_BRANCH in (' ||
   FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH) ||
   ')
    ORDER BY A.LEV
   )'
  INTO
   VAR
  FROM DUAL;
 -- RETURN VAR ;
  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  RETURN VAR2;
 END FNC_GI_CALC;
/*=============================================================*/
/*=============================================================*/
/*=============================================================*/

 PROCEDURE PRC_GI_MAP (
  INPAR_NAME            VARCHAR2
 ,INPAR_DESCRIPTION     VARCHAR2
 ,INPAR_FORMUL          VARCHAR2
 ,INPAR_STANDARD_TYPE   VARCHAR2
 ,OUTPAR_ID             OUT VARCHAR2
 ) AS
  VAR_COUNT   NUMBER;
 BEGIN
  SELECT
   COUNT(DISTINCT NAME)
  INTO
   VAR_COUNT
  FROM TBL_LEDGER_REPORT_MAP
  WHERE NAME   = ( UPPER(INPAR_NAME) );

  IF
   ( VAR_COUNT = 0 AND INPAR_NAME <> 'پروفايل استاندارد' )
  THEN
   INSERT INTO TBL_LEDGER_REPORT_MAP (
    NAME
   ,DESCRIPTION
   ,CREATED_DATE
   ,STANDARD_TYPE
   ,FORMULA
   ) VALUES (
    PKG_LEDGER_REPORT_MAP.FNC_AD_FARSIVALIDATE(UPPER(INPAR_NAME) )
   ,INPAR_DESCRIPTION
   ,SYSDATE
   ,INPAR_STANDARD_TYPE
   ,INPAR_FORMUL
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_LEDGER_REPORT_MAP
   WHERE NAME LIKE UPPER(INPAR_NAME);

  ELSIF ( VAR_COUNT = 1 AND INPAR_NAME <> 'پروفايل استاندارد' ) THEN
   UPDATE TBL_LEDGER_REPORT_MAP
    SET
     DESCRIPTION = INPAR_DESCRIPTION
    ,EDITED_DATE = SYSDATE
    ,FORMULA = INPAR_FORMUL
   WHERE NAME   = ( UPPER(INPAR_NAME) );

   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_LEDGER_REPORT_MAP
   WHERE NAME LIKE UPPER(INPAR_NAME);

   COMMIT;
  END IF;

 END PRC_GI_MAP;
/*=============================================================*/
/*=============================================================*/
/*=============================================================*/

 FUNCTION FNC_AD_FARSIVALIDATE ( STR NVARCHAR2 ) RETURN NVARCHAR2 AS
  TEMPSTR   NVARCHAR2(1000);
 BEGIN
  TEMPSTR   := STR;
  TEMPSTR   := REPLACE(
   TEMPSTR
  ,UNISTR('\064a')
  ,UNISTR('\06cc')
  );
  TEMPSTR   := REPLACE(
   TEMPSTR
  ,UNISTR('\0643')
  ,UNISTR('\06a9')
  );
  RETURN TEMPSTR;
 END FNC_AD_FARSIVALIDATE;
/*=============================================================*/
/*=============================================================*/
/*=============================================================*/

 PROCEDURE PRC_DELETE_PROFILE (
  INPAR_ID    IN VARCHAR2
 ,OUTPAR_ID   OUT VARCHAR2
 )
  AS
 BEGIN
  OUTPAR_ID   := 0;
  DELETE FROM TBL_LEDGER_REPORT_MAP WHERE ID   = INPAR_ID;

  COMMIT;
 END PRC_DELETE_PROFILE;
/*=============================================================*/
/*=============================================================*/
/*=============================================================*/

 FUNCTION FNC_GET_QUERY_FORMULA ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR   VARCHAR2(30000);
 BEGIN
  VAR   := 'SELECT id "id",name "name",description "description",CREATED_DATE "createdDate",EDITED_DATE "editDate",STANDARD_TYPE "constant",FORMULA "formula" FROM TBL_LEDGER_REPORT_MAP where id = '
|| INPAR_ID || ' order by id';
  RETURN VAR;
 END FNC_GET_QUERY_FORMULA;

/*=============================================================*/
/*=============================================================*/
/*=============================================================*/

 FUNCTION FNC_GET_QUERY_FORMULA_PROFILE ( INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2
  AS
 BEGIN
  RETURN 'SELECT ID as "id",
 
  NAME as "name",
  description as "des"
FROM TBL_LEDGER_report_map
where   upper(standard_type) =upper('''
|| INPAR_TYPE || ''')';
 END FNC_GET_QUERY_FORMULA_PROFILE;
/*=============================================================*/
/*=============================================================*/
/*=============================================================*/

END PKG_LEDGER_REPORT_MAP;
--------------------------------------------------------
--  DDL for Table PKG_LEDGER_REPORT_MAP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_LEDGER_REPORT_MAP" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*=============================================================*/
 FUNCTION FNC_GI_CALC (
  INPAR_ID           IN NUMBER
 ,INPAR_REF_REPORT   IN NUMBER
 ,INPAR_CUR_ID       IN NUMBER
 ,INPAR_DATE         IN DATE
 ) RETURN VARCHAR2;
/*=============================================================*/

 FUNCTION FNC_AD_FARSIVALIDATE ( STR NVARCHAR2 ) RETURN NVARCHAR2;
/*=============================================================*/

 PROCEDURE PRC_GI_MAP (
  INPAR_NAME            VARCHAR2
 ,INPAR_DESCRIPTION     VARCHAR2
 ,INPAR_FORMUL          VARCHAR2
 ,INPAR_STANDARD_TYPE   VARCHAR2
 ,OUTPAR_ID             OUT VARCHAR2
 );
/*=============================================================*/

 PROCEDURE PRC_DELETE_PROFILE (
  INPAR_ID    IN VARCHAR2
 ,OUTPAR_ID   OUT VARCHAR2
 );
    /*=============================================================*/

 FUNCTION FNC_GET_QUERY_FORMULA ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*=============================================================*/

 FUNCTION FNC_GET_QUERY_FORMULA_PROFILE ( INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2;
/*=============================================================*/

END PKG_LEDGER_REPORT_MAP;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_LEDGER_REPORT_MAP" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_GI_CALC (
  INPAR_ID           IN NUMBER
 ,INPAR_REF_REPORT   IN NUMBER
 ,INPAR_CUR_ID       IN NUMBER
 ,INPAR_DATE         IN DATE
 ) RETURN VARCHAR2 AS
  VAR         CLOB;
  VAR2        CLOB;
  VAR3        CLOB;
  ID_BRANCH   NUMBER;
 BEGIN
  SELECT
   REF_BRN_PROFILE
  INTO
   ID_BRANCH
  FROM TBL_REPORT
  WHERE ID   = INPAR_REF_REPORT;

  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = ' ||
   INPAR_ID ||
   '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_BRANCH DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
      SPLIT_VALUES IS NOT NULL
     AND
      DG.REF_CUR_ID    = ' ||
   INPAR_CUR_ID ||
   '
     AND
      trunc(DG.EFF_DATE)                                          = trunc(TO_DATE(''' ||
   INPAR_DATE ||
   '''))
       and DG.REF_BRANCH in (' ||
   FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH) ||
   ')
    ORDER BY A.LEV
   )'
  INTO
   VAR
  FROM DUAL;
 -- RETURN VAR ;
  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  RETURN VAR2;
 END FNC_GI_CALC;
/*=============================================================*/
/*=============================================================*/
/*=============================================================*/

 PROCEDURE PRC_GI_MAP (
  INPAR_NAME            VARCHAR2
 ,INPAR_DESCRIPTION     VARCHAR2
 ,INPAR_FORMUL          VARCHAR2
 ,INPAR_STANDARD_TYPE   VARCHAR2
 ,OUTPAR_ID             OUT VARCHAR2
 ) AS
  VAR_COUNT   NUMBER;
 BEGIN
  SELECT
   COUNT(DISTINCT NAME)
  INTO
   VAR_COUNT
  FROM TBL_LEDGER_REPORT_MAP
  WHERE NAME   = ( UPPER(INPAR_NAME) );

  IF
   ( VAR_COUNT = 0 AND INPAR_NAME <> 'پروفايل استاندارد' )
  THEN
   INSERT INTO TBL_LEDGER_REPORT_MAP (
    NAME
   ,DESCRIPTION
   ,CREATED_DATE
   ,STANDARD_TYPE
   ,FORMULA
   ) VALUES (
    PKG_LEDGER_REPORT_MAP.FNC_AD_FARSIVALIDATE(UPPER(INPAR_NAME) )
   ,INPAR_DESCRIPTION
   ,SYSDATE
   ,INPAR_STANDARD_TYPE
   ,INPAR_FORMUL
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_LEDGER_REPORT_MAP
   WHERE NAME LIKE UPPER(INPAR_NAME);

  ELSIF ( VAR_COUNT = 1 AND INPAR_NAME <> 'پروفايل استاندارد' ) THEN
   UPDATE TBL_LEDGER_REPORT_MAP
    SET
     DESCRIPTION = INPAR_DESCRIPTION
    ,EDITED_DATE = SYSDATE
    ,FORMULA = INPAR_FORMUL
   WHERE NAME   = ( UPPER(INPAR_NAME) );

   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_LEDGER_REPORT_MAP
   WHERE NAME LIKE UPPER(INPAR_NAME);

   COMMIT;
  END IF;

 END PRC_GI_MAP;
/*=============================================================*/
/*=============================================================*/
/*=============================================================*/

 FUNCTION FNC_AD_FARSIVALIDATE ( STR NVARCHAR2 ) RETURN NVARCHAR2 AS
  TEMPSTR   NVARCHAR2(1000);
 BEGIN
  TEMPSTR   := STR;
  TEMPSTR   := REPLACE(
   TEMPSTR
  ,UNISTR('\064a')
  ,UNISTR('\06cc')
  );
  TEMPSTR   := REPLACE(
   TEMPSTR
  ,UNISTR('\0643')
  ,UNISTR('\06a9')
  );
  RETURN TEMPSTR;
 END FNC_AD_FARSIVALIDATE;
/*=============================================================*/
/*=============================================================*/
/*=============================================================*/

 PROCEDURE PRC_DELETE_PROFILE (
  INPAR_ID    IN VARCHAR2
 ,OUTPAR_ID   OUT VARCHAR2
 )
  AS
 BEGIN
  OUTPAR_ID   := 0;
  DELETE FROM TBL_LEDGER_REPORT_MAP WHERE ID   = INPAR_ID;

  COMMIT;
 END PRC_DELETE_PROFILE;
/*=============================================================*/
/*=============================================================*/
/*=============================================================*/

 FUNCTION FNC_GET_QUERY_FORMULA ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR   VARCHAR2(30000);
 BEGIN
  VAR   := 'SELECT id "id",name "name",description "description",CREATED_DATE "createdDate",EDITED_DATE "editDate",STANDARD_TYPE "constant",FORMULA "formula" FROM TBL_LEDGER_REPORT_MAP where id = '
|| INPAR_ID || ' order by id';
  RETURN VAR;
 END FNC_GET_QUERY_FORMULA;

/*=============================================================*/
/*=============================================================*/
/*=============================================================*/

 FUNCTION FNC_GET_QUERY_FORMULA_PROFILE ( INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2
  AS
 BEGIN
  RETURN 'SELECT ID as "id",
 
  NAME as "name",
  description as "des"
FROM TBL_LEDGER_report_map
where   upper(standard_type) =upper('''
|| INPAR_TYPE || ''')';
 END FNC_GET_QUERY_FORMULA_PROFILE;
/*=============================================================*/
/*=============================================================*/
/*=============================================================*/

END PKG_LEDGER_REPORT_MAP;
--------------------------------------------------------
--  DDL for Table PKG_CAR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CAR" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_CAR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_REP_PROFILE_DETAIL (
  INPAR_REF_REP_ID         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_FINAL_REPORT (
  INPAR_REF_REPORT   IN NUMBER
 ,OUTPAR             OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DATE (
  INPAR_INSERT_OR_UPDATE   IN NUMBER
 ,/*if inpar_insert_or_update-1==> insert   else  ==>update*/
  INPAR_REF_REP_ID         IN NUMBER
 ,INPAR_CAR_DATE           IN VARCHAR2
 ,OUTPUT                   OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 
 FUNCTION FNC_CAR_GI_CALC (
  INPAR_ID     IN NUMBER
 ,INPAR_DATE   IN DATE
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_FINAL_REPORT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT ( INPAR_TYPE IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE ( INPAR_VAR IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_EDIT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE_EDIT ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_DATE_ID ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_CAR;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_CAR" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_CAR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,TYPE
   ,CATEGORY
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,INPAR_TYPE
   ,'car'
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
 END PRC_CAR_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_REP_PROFILE_DETAIL (
  INPAR_REF_REP_ID         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_CAR_REP_PROFILE_DETAIL (
    REF_REP_ID
   ,NAME
   ,PROFILE_ID
   ,PERCENT
   ,IS_STANDARD
   ,TYPE
   ) VALUES (
    INPAR_REF_REP_ID
   ,INPAR_NAME
   ,INPAR_PROFILE_ID
   ,INPAR_PERCENT
   ,INPAR_IS_STANDARD
   ,INPAR_TYPE
   );

   COMMIT; 
/*   SELECT*/
/*    ID*/
/*   INTO*/
/*    OUTPAR_ID*/
/*   FROM TBL_CAR_REP_PROFILE_DETAIL*/
/*   WHERE REF_REP_ID   = INPAR_REF_REP_ID;*/
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_CAR_REP_PROFILE_DETAIL
   WHERE ID   = (
     SELECT
      MAX(ID)
     FROM TBL_CAR_REP_PROFILE_DETAIL
    );

  ELSE
   UPDATE TBL_CAR_REP_PROFILE_DETAIL
    SET
     REF_REP_ID = INPAR_REF_REP_ID
    ,NAME = INPAR_NAME
    ,PROFILE_ID = INPAR_PROFILE_ID
    ,PERCENT = INPAR_PERCENT
    ,IS_STANDARD = INPAR_IS_STANDARD
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
 END PRC_CAR_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_FINAL_REPORT (
  INPAR_REF_REPORT   IN NUMBER
 ,OUTPAR             OUT VARCHAR2
 )
  AS
 BEGIN
 
 DELETE FROM TBL_CAR_FINAL_REPORT
  WHERE ref_report = INPAR_REF_REPORT; 
  commit; 
  
  FOR I IN (
   SELECT
    TCP.ID
   ,TC.ID AS ID_DATE
   ,TCP.REF_REP_ID
   ,TC.CAR_DATE
   ,TCP.NAME
   ,TCP.PROFILE_ID
   ,TCP.PERCENT
   ,TCP.TYPE
   FROM TBL_CAR_DATE TC
   ,    TBL_CAR_REP_PROFILE_DETAIL TCP
   WHERE TC.REF_REP_ID    = TCP.REF_REP_ID
    AND
     TCP.REF_REP_ID   = INPAR_REF_REPORT
  ) LOOP
   IF
    ( I.TYPE IN (
      1,2
     )
    )
   THEN
    INSERT INTO TBL_CAR_FINAL_REPORT (
     REF_CAR_REP_DETAIL
    ,REF_CAR_DATE
    ,BALANCE
    ,REF_REPORT
    ,REPORT_DATE
    ,NAME
    ,TYPE
    ,PERCENT
    ) VALUES (
     I.ID
    ,I.ID_DATE
    ,PKG_CAR.FNC_CAR_GI_CALC(
      I.PROFILE_ID
     ,I.CAR_DATE
     )
    ,INPAR_REF_REPORT
    ,I.CAR_DATE
    ,I.NAME
    ,I.TYPE
    ,I.PERCENT
    );

    COMMIT;
   ELSE
    INSERT INTO TBL_CAR_FINAL_REPORT (
     REF_CAR_REP_DETAIL
    ,REF_CAR_DATE
    ,BALANCE
    ,REF_REPORT
    ,REPORT_DATE
    ,NAME
    ,TYPE
    ,PERCENT
    ) VALUES (
     I.ID
    ,I.ID_DATE
    ,PKG_CAR.FNC_CAR_GI_CALC(
      I.PROFILE_ID
     ,I.CAR_DATE
     ) * I.PERCENT / 100
    ,INPAR_REF_REPORT
    ,I.CAR_DATE
    ,I.NAME
    ,I.TYPE
    ,I.PERCENT
    );

    COMMIT;
   END IF;

   COMMIT;
   UPDATE TBL_CAR_FINAL_REPORT
    SET
     BALANCE = (
      SELECT
       SUM(CURRENT_AMOUNT)
      FROM AKIN.TBL_LOAN
      WHERE LON_ID IN (
        SELECT
         REF_LON_ID
        FROM AKIN.TBL_LOAN_PAYMENT
        WHERE DUE_DATE >= I.CAR_DATE + 1800
        GROUP BY
         REF_LON_ID
       )
     )
   WHERE REPORT_DATE   = I.CAR_DATE
    AND
     TYPE          = 4;

   COMMIT;
  END LOOP;

  OUTPAR   := 1;
 END PRC_CAR_FINAL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_CAR_REP_PROFILE_DETAIL WHERE REF_REP_ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_CAR_FINAL_REPORT WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_CAR_DATE WHERE REF_REP_ID   = INPAR_ID;

  COMMIT;
  OUTPAR   := 1;
 END PRC_CAR_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DATE (
  INPAR_INSERT_OR_UPDATE   IN NUMBER  /*if inpar_insert_or_update-1==> insert   else  ==>update*/
 ,INPAR_REF_REP_ID         IN NUMBER
 ,INPAR_CAR_DATE           IN VARCHAR2
 ,OUTPUT                   OUT VARCHAR2
 )
  AS
 BEGIN
 /*
  Programmer Name: sobhan
  Release Date/Time:1396/07/15
  Version: 1.0
  Category:
  Description:
  */
  IF
   ( INPAR_INSERT_OR_UPDATE =-1 )
  THEN
   INSERT INTO TBL_CAR_DATE ( REF_REP_ID,CAR_DATE ) ( SELECT
    INPAR_REF_REP_ID
   ,TO_DATE(D,'yyyy/mm/dd','nls_calendar=persian')
   FROM (
     SELECT
      INPAR_REF_REP_ID
     ,REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) AS D
     FROM DUAL
     CONNECT BY
      REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) IS NOT NULL
    )
   );

  ELSE
   DELETE FROM TBL_CAR_DATE WHERE REF_REP_ID   = INPAR_REF_REP_ID;

   INSERT INTO TBL_CAR_DATE ( REF_REP_ID,CAR_DATE ) ( SELECT
    INPAR_REF_REP_ID
   ,TO_DATE(D,'yyyy/mm/dd','nls_calendar=persian')
   FROM (
     SELECT
      INPAR_REF_REP_ID
     ,REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) AS D
     FROM DUAL
     CONNECT BY
      REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) IS NOT NULL
    )
   );

  END IF;

  OUTPUT   := NULL;
 END PRC_CAR_DATE;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GI_CALC (
  INPAR_ID     IN NUMBER
 ,INPAR_DATE   IN DATE
 ) RETURN VARCHAR2 AS
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
 BEGIN
  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = ' ||
   INPAR_ID ||
   '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = trunc(TO_DATE(''' ||
   INPAR_DATE ||
   ''')))
 '
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  RETURN abs(to_number(VAR2));
  --RETURN VAR;
 END FNC_CAR_GI_CALC;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''CAR''';
  RETURN VAR2;
 END FNC_CAR_ALL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_FINAL_REPORT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2 AS
  VAR           VARCHAR2(10000);
  VAR_TIMING    VARCHAR2(1000);
  VAR_TIMING1   VARCHAR2(1000);
 BEGIN
  SELECT
   WMSYS.WM_CONCAT( (
    SELECT
     ID ||
     ' AS "x' ||
     REPLACE(ID,' ','_') ||
     '"'
    FROM DUAL
   ) )
  INTO
   VAR_TIMING
  FROM TBL_CAR_DATE
  WHERE REF_REP_ID   = INPAR_REPORT;

  SELECT
   WMSYS.WM_CONCAT( (
    SELECT
     '  "x' ||
     REPLACE(ID,' ','_') ||
     '"'
    FROM DUAL
   ) )
  INTO
   VAR_TIMING1
  FROM TBL_CAR_DATE
  WHERE REF_REP_ID   = INPAR_REPORT;

  IF
   INPAR_TYPE = 4
  THEN
   VAR   := '
 SELECT name  as "des",' ||
   VAR_TIMING1 ||
   ',type as "type" FROM
(
SELECT
    REF_CAR_DATE,
    BALANCE,
    NAME,type
FROM
    TBL_CAR_FINAL_REPORT
    where  REF_REPORT =' ||
   INPAR_REPORT ||
   '
    and TBL_CAR_FINAL_REPORT.type in (1,2,4)
)
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
)
union    
    SELECT  name  as "des",' ||
   VAR_TIMING1 ||
   ',type as "type"  FROM
(
SELECT
    max(REF_CAR_DATE) as REF_CAR_DATE,
    sum(BALANCE) as BALANCE,
    ''جمع دارايي هاي موزون شده به ريسک'' as NAME,
      max(type) as type
FROM
    TBL_CAR_FINAL_REPORT
    where  REF_REPORT =' ||
   INPAR_REPORT ||
   '
    and TBL_CAR_FINAL_REPORT.type   in (3)
group by REPORT_DATE)
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)
order by "type"';
  END IF;

  IF INPAR_TYPE IN (
    3
   )
  THEN
   VAR   := '    SELECT name  as "des",percent,' ||
   VAR_TIMING1 ||
   ' FROM
(

SELECT
REF_CAR_DATE,
    BALANCE,
    NAME,
    percent
FROM
    TBL_CAR_FINAL_REPORT
    where type = 3 and REF_REPORT = ' ||
   INPAR_REPORT ||
   ')
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)';
  END IF;

  IF INPAR_TYPE IN (
    1
   )
  THEN
   VAR   := '    SELECT name  as "des",' ||
   VAR_TIMING1 ||
   ' FROM
(

SELECT
REF_CAR_DATE,
    BALANCE,
    NAME
FROM
    TBL_CAR_FINAL_REPORT
    where type = ' ||
   INPAR_TYPE ||
   ' and REF_REPORT = ' ||
   INPAR_REPORT ||
   ')
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)';
  END IF;

  IF INPAR_TYPE IN (
    2
   )
  THEN
   VAR   := '    SELECT name  as "des",' ||
   VAR_TIMING1 ||
   ' FROM
(

SELECT
REF_CAR_DATE,
    BALANCE,
    NAME
FROM
    TBL_CAR_FINAL_REPORT
    where type in (2,4) and REF_REPORT = ' ||
   INPAR_REPORT ||
   ')
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)';
  END IF;

  RETURN VAR;
 END FNC_CAR_FINAL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT ( INPAR_TYPE IN NUMBER ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
 BEGIN
  IF
   ( INPAR_TYPE = 1 )
  THEN
   OUTPUT   := 'select name as "des" from TBL_CAR_REP_PROFILE_DETAIL where type=1 and IS_STANDARD=1 and REF_REP_ID is null';
  ELSIF ( INPAR_TYPE = 2 ) THEN
   OUTPUT   := 'select name as "des" from TBL_CAR_REP_PROFILE_DETAIL where  type in (2,4) and IS_STANDARD=1 and REF_REP_ID is null';
  ELSIF ( INPAR_TYPE = 3 ) THEN
   OUTPUT   := 'select name as "des",PERCENT as "zarib" from TBL_CAR_REP_PROFILE_DETAIL where type=3
 and IS_STANDARD=1 and REF_REP_ID is null'
;
  END IF;

  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE ( INPAR_VAR IN NUMBER ) RETURN VARCHAR2 AS
  VAR      VARCHAR2(2000);
  OUTPUT   VARCHAR2(2000);
 BEGIN
  VAR      := INPAR_VAR;
  OUTPUT   := 'select wm_concat(distinct(TO_char(EFF_DATE,''yyyy/mm/dd'',''nls_calendar=persian''))) as "date" from TBL_LEDGER_ARCHIVE'
;
  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT_DATE;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_EDIT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
 BEGIN
  IF
   ( INPAR_TYPE = 1 )
  THEN
   OUTPUT   := 'select id as "id",name as "des",PROFILE_ID as "ledgerProfileId" ,IS_STANDARD as "isStandard" from TBL_CAR_REP_PROFILE_DETAIL where type=1   and REF_REP_ID = '
|| INPAR_REPORT || '  order by IS_STANDARD desc';
  ELSIF ( INPAR_TYPE = 2 ) THEN
   OUTPUT   := 'select id as "id",name as "des",PROFILE_ID as "ledgerProfileId",IS_STANDARD as "isStandard" from TBL_CAR_REP_PROFILE_DETAIL where type in (2,4)  and REF_REP_ID = '
|| INPAR_REPORT || '  order by IS_STANDARD desc';
  ELSIF ( INPAR_TYPE = 3 ) THEN
   OUTPUT   := 'select id as "id",name as "des",PROFILE_ID as "ledgerProfileId",PERCENT as "zarib",IS_STANDARD as "isStandard" from TBL_CAR_REP_PROFILE_DETAIL where type=3
  and REF_REP_ID = '
|| INPAR_REPORT || '  order by IS_STANDARD desc';
  END IF;

  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE_EDIT ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  
 BEGIN

  OUTPUT   := 'select (TO_char(CAR_DATE,''yyyy/mm/dd'',''nls_calendar=persian'')) as "date" from tbl_CAR_DATE where ref_rep_id =' || INPAR_REPORT
|| '';
  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT_DATE_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_DATE_ID ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
 BEGIN
  OUTPUT   := 'select  ''x''||ID AS "value",(TO_char(CAR_DATE,''yyyy/mm/dd'',''nls_calendar=persian'')) as "header" from tbl_CAR_DATE where ref_rep_id ='
|| INPAR_REPORT || '';
  RETURN OUTPUT;
 END FNC_CAR_GET_DATE_ID;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/


END PKG_CAR;
--------------------------------------------------------
--  DDL for Table PKG_CAR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CAR" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_CAR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_REP_PROFILE_DETAIL (
  INPAR_REF_REP_ID         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_FINAL_REPORT (
  INPAR_REF_REPORT   IN NUMBER
 ,OUTPAR             OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DATE (
  INPAR_INSERT_OR_UPDATE   IN NUMBER
 ,/*if inpar_insert_or_update-1==> insert   else  ==>update*/
  INPAR_REF_REP_ID         IN NUMBER
 ,INPAR_CAR_DATE           IN VARCHAR2
 ,OUTPUT                   OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 
 FUNCTION FNC_CAR_GI_CALC (
  INPAR_ID     IN NUMBER
 ,INPAR_DATE   IN DATE
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_FINAL_REPORT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT ( INPAR_TYPE IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE ( INPAR_VAR IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_EDIT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE_EDIT ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_DATE_ID ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_CAR;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_CAR" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_CAR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,TYPE
   ,CATEGORY
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,INPAR_TYPE
   ,'car'
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
 END PRC_CAR_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_REP_PROFILE_DETAIL (
  INPAR_REF_REP_ID         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_CAR_REP_PROFILE_DETAIL (
    REF_REP_ID
   ,NAME
   ,PROFILE_ID
   ,PERCENT
   ,IS_STANDARD
   ,TYPE
   ) VALUES (
    INPAR_REF_REP_ID
   ,INPAR_NAME
   ,INPAR_PROFILE_ID
   ,INPAR_PERCENT
   ,INPAR_IS_STANDARD
   ,INPAR_TYPE
   );

   COMMIT; 
/*   SELECT*/
/*    ID*/
/*   INTO*/
/*    OUTPAR_ID*/
/*   FROM TBL_CAR_REP_PROFILE_DETAIL*/
/*   WHERE REF_REP_ID   = INPAR_REF_REP_ID;*/
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_CAR_REP_PROFILE_DETAIL
   WHERE ID   = (
     SELECT
      MAX(ID)
     FROM TBL_CAR_REP_PROFILE_DETAIL
    );

  ELSE
   UPDATE TBL_CAR_REP_PROFILE_DETAIL
    SET
     REF_REP_ID = INPAR_REF_REP_ID
    ,NAME = INPAR_NAME
    ,PROFILE_ID = INPAR_PROFILE_ID
    ,PERCENT = INPAR_PERCENT
    ,IS_STANDARD = INPAR_IS_STANDARD
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
 END PRC_CAR_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_FINAL_REPORT (
  INPAR_REF_REPORT   IN NUMBER
 ,OUTPAR             OUT VARCHAR2
 )
  AS
 BEGIN
 
 DELETE FROM TBL_CAR_FINAL_REPORT
  WHERE ref_report = INPAR_REF_REPORT; 
  commit; 
  
  FOR I IN (
   SELECT
    TCP.ID
   ,TC.ID AS ID_DATE
   ,TCP.REF_REP_ID
   ,TC.CAR_DATE
   ,TCP.NAME
   ,TCP.PROFILE_ID
   ,TCP.PERCENT
   ,TCP.TYPE
   FROM TBL_CAR_DATE TC
   ,    TBL_CAR_REP_PROFILE_DETAIL TCP
   WHERE TC.REF_REP_ID    = TCP.REF_REP_ID
    AND
     TCP.REF_REP_ID   = INPAR_REF_REPORT
  ) LOOP
   IF
    ( I.TYPE IN (
      1,2
     )
    )
   THEN
    INSERT INTO TBL_CAR_FINAL_REPORT (
     REF_CAR_REP_DETAIL
    ,REF_CAR_DATE
    ,BALANCE
    ,REF_REPORT
    ,REPORT_DATE
    ,NAME
    ,TYPE
    ,PERCENT
    ) VALUES (
     I.ID
    ,I.ID_DATE
    ,PKG_CAR.FNC_CAR_GI_CALC(
      I.PROFILE_ID
     ,I.CAR_DATE
     )
    ,INPAR_REF_REPORT
    ,I.CAR_DATE
    ,I.NAME
    ,I.TYPE
    ,I.PERCENT
    );

    COMMIT;
   ELSE
    INSERT INTO TBL_CAR_FINAL_REPORT (
     REF_CAR_REP_DETAIL
    ,REF_CAR_DATE
    ,BALANCE
    ,REF_REPORT
    ,REPORT_DATE
    ,NAME
    ,TYPE
    ,PERCENT
    ) VALUES (
     I.ID
    ,I.ID_DATE
    ,PKG_CAR.FNC_CAR_GI_CALC(
      I.PROFILE_ID
     ,I.CAR_DATE
     ) * I.PERCENT / 100
    ,INPAR_REF_REPORT
    ,I.CAR_DATE
    ,I.NAME
    ,I.TYPE
    ,I.PERCENT
    );

    COMMIT;
   END IF;

   COMMIT;
   UPDATE TBL_CAR_FINAL_REPORT
    SET
     BALANCE = (
      SELECT
       SUM(CURRENT_AMOUNT)
      FROM AKIN.TBL_LOAN
      WHERE LON_ID IN (
        SELECT
         REF_LON_ID
        FROM AKIN.TBL_LOAN_PAYMENT
        WHERE DUE_DATE >= I.CAR_DATE + 1800
        GROUP BY
         REF_LON_ID
       )
     )
   WHERE REPORT_DATE   = I.CAR_DATE
    AND
     TYPE          = 4;

   COMMIT;
  END LOOP;

  OUTPAR   := 1;
 END PRC_CAR_FINAL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_CAR_REP_PROFILE_DETAIL WHERE REF_REP_ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_CAR_FINAL_REPORT WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_CAR_DATE WHERE REF_REP_ID   = INPAR_ID;

  COMMIT;
  OUTPAR   := 1;
 END PRC_CAR_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_DATE (
  INPAR_INSERT_OR_UPDATE   IN NUMBER  /*if inpar_insert_or_update-1==> insert   else  ==>update*/
 ,INPAR_REF_REP_ID         IN NUMBER
 ,INPAR_CAR_DATE           IN VARCHAR2
 ,OUTPUT                   OUT VARCHAR2
 )
  AS
 BEGIN
 /*
  Programmer Name: sobhan
  Release Date/Time:1396/07/15
  Version: 1.0
  Category:
  Description:
  */
  IF
   ( INPAR_INSERT_OR_UPDATE =-1 )
  THEN
   INSERT INTO TBL_CAR_DATE ( REF_REP_ID,CAR_DATE ) ( SELECT
    INPAR_REF_REP_ID
   ,TO_DATE(D,'yyyy/mm/dd','nls_calendar=persian')
   FROM (
     SELECT
      INPAR_REF_REP_ID
     ,REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) AS D
     FROM DUAL
     CONNECT BY
      REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) IS NOT NULL
    )
   );

  ELSE
   DELETE FROM TBL_CAR_DATE WHERE REF_REP_ID   = INPAR_REF_REP_ID;

   INSERT INTO TBL_CAR_DATE ( REF_REP_ID,CAR_DATE ) ( SELECT
    INPAR_REF_REP_ID
   ,TO_DATE(D,'yyyy/mm/dd','nls_calendar=persian')
   FROM (
     SELECT
      INPAR_REF_REP_ID
     ,REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) AS D
     FROM DUAL
     CONNECT BY
      REGEXP_SUBSTR(
       INPAR_CAR_DATE
      ,'[^#]+'
      ,1
      ,LEVEL
      ) IS NOT NULL
    )
   );

  END IF;

  OUTPUT   := NULL;
 END PRC_CAR_DATE;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GI_CALC (
  INPAR_ID     IN NUMBER
 ,INPAR_DATE   IN DATE
 ) RETURN VARCHAR2 AS
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
 BEGIN
  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = ' ||
   INPAR_ID ||
   '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = trunc(TO_DATE(''' ||
   INPAR_DATE ||
   ''')))
 '
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  RETURN abs(to_number(VAR2));
  --RETURN VAR;
 END FNC_CAR_GI_CALC;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''CAR''';
  RETURN VAR2;
 END FNC_CAR_ALL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_FINAL_REPORT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2 AS
  VAR           VARCHAR2(10000);
  VAR_TIMING    VARCHAR2(1000);
  VAR_TIMING1   VARCHAR2(1000);
 BEGIN
  SELECT
   WMSYS.WM_CONCAT( (
    SELECT
     ID ||
     ' AS "x' ||
     REPLACE(ID,' ','_') ||
     '"'
    FROM DUAL
   ) )
  INTO
   VAR_TIMING
  FROM TBL_CAR_DATE
  WHERE REF_REP_ID   = INPAR_REPORT;

  SELECT
   WMSYS.WM_CONCAT( (
    SELECT
     '  "x' ||
     REPLACE(ID,' ','_') ||
     '"'
    FROM DUAL
   ) )
  INTO
   VAR_TIMING1
  FROM TBL_CAR_DATE
  WHERE REF_REP_ID   = INPAR_REPORT;

  IF
   INPAR_TYPE = 4
  THEN
   VAR   := '
 SELECT name  as "des",' ||
   VAR_TIMING1 ||
   ',type as "type" FROM
(
SELECT
    REF_CAR_DATE,
    BALANCE,
    NAME,type
FROM
    TBL_CAR_FINAL_REPORT
    where  REF_REPORT =' ||
   INPAR_REPORT ||
   '
    and TBL_CAR_FINAL_REPORT.type in (1,2,4)
)
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
)
union    
    SELECT  name  as "des",' ||
   VAR_TIMING1 ||
   ',type as "type"  FROM
(
SELECT
    max(REF_CAR_DATE) as REF_CAR_DATE,
    sum(BALANCE) as BALANCE,
    ''جمع دارايي هاي موزون شده به ريسک'' as NAME,
      max(type) as type
FROM
    TBL_CAR_FINAL_REPORT
    where  REF_REPORT =' ||
   INPAR_REPORT ||
   '
    and TBL_CAR_FINAL_REPORT.type   in (3)
group by REPORT_DATE)
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)
order by "type"';
  END IF;

  IF INPAR_TYPE IN (
    3
   )
  THEN
   VAR   := '    SELECT name  as "des",percent,' ||
   VAR_TIMING1 ||
   ' FROM
(

SELECT
REF_CAR_DATE,
    BALANCE,
    NAME,
    percent
FROM
    TBL_CAR_FINAL_REPORT
    where type = 3 and REF_REPORT = ' ||
   INPAR_REPORT ||
   ')
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)';
  END IF;

  IF INPAR_TYPE IN (
    1
   )
  THEN
   VAR   := '    SELECT name  as "des",' ||
   VAR_TIMING1 ||
   ' FROM
(

SELECT
REF_CAR_DATE,
    BALANCE,
    NAME
FROM
    TBL_CAR_FINAL_REPORT
    where type = ' ||
   INPAR_TYPE ||
   ' and REF_REPORT = ' ||
   INPAR_REPORT ||
   ')
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)';
  END IF;

  IF INPAR_TYPE IN (
    2
   )
  THEN
   VAR   := '    SELECT name  as "des",' ||
   VAR_TIMING1 ||
   ' FROM
(

SELECT
REF_CAR_DATE,
    BALANCE,
    NAME
FROM
    TBL_CAR_FINAL_REPORT
    where type in (2,4) and REF_REPORT = ' ||
   INPAR_REPORT ||
   ')
PIVOT 
(
  sum(BALANCE)
  FOR (REF_CAR_DATE)
  IN ( ' ||
   VAR_TIMING ||
   ' ) 
  
)';
  END IF;

  RETURN VAR;
 END FNC_CAR_FINAL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT ( INPAR_TYPE IN NUMBER ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
 BEGIN
  IF
   ( INPAR_TYPE = 1 )
  THEN
   OUTPUT   := 'select name as "des" from TBL_CAR_REP_PROFILE_DETAIL where type=1 and IS_STANDARD=1 and REF_REP_ID is null';
  ELSIF ( INPAR_TYPE = 2 ) THEN
   OUTPUT   := 'select name as "des" from TBL_CAR_REP_PROFILE_DETAIL where  type in (2,4) and IS_STANDARD=1 and REF_REP_ID is null';
  ELSIF ( INPAR_TYPE = 3 ) THEN
   OUTPUT   := 'select name as "des",PERCENT as "zarib" from TBL_CAR_REP_PROFILE_DETAIL where type=3
 and IS_STANDARD=1 and REF_REP_ID is null'
;
  END IF;

  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE ( INPAR_VAR IN NUMBER ) RETURN VARCHAR2 AS
  VAR      VARCHAR2(2000);
  OUTPUT   VARCHAR2(2000);
 BEGIN
  VAR      := INPAR_VAR;
  OUTPUT   := 'select wm_concat(distinct(TO_char(EFF_DATE,''yyyy/mm/dd'',''nls_calendar=persian''))) as "date" from TBL_LEDGER_ARCHIVE'
;
  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT_DATE;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_EDIT (
  INPAR_REPORT   IN NUMBER
 ,INPAR_TYPE     IN NUMBER
 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
 BEGIN
  IF
   ( INPAR_TYPE = 1 )
  THEN
   OUTPUT   := 'select id as "id",name as "des",PROFILE_ID as "ledgerProfileId" ,IS_STANDARD as "isStandard" from TBL_CAR_REP_PROFILE_DETAIL where type=1   and REF_REP_ID = '
|| INPAR_REPORT || '  order by IS_STANDARD desc';
  ELSIF ( INPAR_TYPE = 2 ) THEN
   OUTPUT   := 'select id as "id",name as "des",PROFILE_ID as "ledgerProfileId",IS_STANDARD as "isStandard" from TBL_CAR_REP_PROFILE_DETAIL where type in (2,4)  and REF_REP_ID = '
|| INPAR_REPORT || '  order by IS_STANDARD desc';
  ELSIF ( INPAR_TYPE = 3 ) THEN
   OUTPUT   := 'select id as "id",name as "des",PROFILE_ID as "ledgerProfileId",PERCENT as "zarib",IS_STANDARD as "isStandard" from TBL_CAR_REP_PROFILE_DETAIL where type=3
  and REF_REP_ID = '
|| INPAR_REPORT || '  order by IS_STANDARD desc';
  END IF;

  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_INPUT_DATE_EDIT ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  
 BEGIN

  OUTPUT   := 'select (TO_char(CAR_DATE,''yyyy/mm/dd'',''nls_calendar=persian'')) as "date" from tbl_CAR_DATE where ref_rep_id =' || INPAR_REPORT
|| '';
  RETURN OUTPUT;
 END FNC_CAR_GET_INPUT_DATE_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CAR_GET_DATE_ID ( INPAR_REPORT IN NUMBER ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
 BEGIN
  OUTPUT   := 'select  ''x''||ID AS "value",(TO_char(CAR_DATE,''yyyy/mm/dd'',''nls_calendar=persian'')) as "header" from tbl_CAR_DATE where ref_rep_id ='
|| INPAR_REPORT || '';
  RETURN OUTPUT;
 END FNC_CAR_GET_DATE_ID;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/


END PKG_CAR;
--------------------------------------------------------
--  DDL for Table PKG_COM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_COM" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_COM_GI_CALC ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

-- FUNCTION FNC_COM_FINAL_REPORT (
--  INPAR_REPORT   IN NUMBER
-- ,INPAR_TYPE     IN NUMBER
-- ) RETURN VARCHAR2;
-- 
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;

 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_COM_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 , INPAR_ref_ledger_code              IN VARCHAR2
  ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
  /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_COM_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_FIRST_DATE         IN VARCHAR2
 ,INPAR_BAZEH              IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
  /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GET_INPUT ( INPAR_VAR IN VARCHAR2 ) RETURN VARCHAR2;
  /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2 ) RETURN VARCHAR2;
  /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/
 

 PROCEDURE PRC_COM_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
   /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/
  PROCEDURE prc_com_value 
(
  INPAR_ID IN VARCHAR2 
);
   /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_COM_RESULT 
(
  INPAR_REPREQ IN VARCHAR2 ,
  INPAR_bazeh IN VARCHAR2 
) RETURN VARCHAR2 ;
     /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_COM_GET_RESULT(
    INPAR_DATE IN NUMBER ,
    INPAR_TYPE IN NUMBER ,
        INPAR_period IN NUMBER )

  RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_COM;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_COM" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GI_CALC ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
 BEGIN
  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = '
|| INPAR_ID || '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = (select trunc(max(eff_date)) from  TBL_LEDGER_archive))
 '
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  RETURN ABS(TO_NUMBER(VAR2) );
 END FNC_COM_GI_CALC;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "description",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''COM'' order by id';
  RETURN VAR2;
 END FNC_COM_GET_REPORT_INFO;

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_COM_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_ref_ledger_code              IN VARCHAR2
  ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_COM_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,REF_LEDGER_CODE
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) VALUES (
    INPAR_REF_REPORT
   ,INPAR_NAME
   ,INPAR_PROFILE_ID
   ,INPAR_ref_ledger_code
   ,0
   ,INPAR_TYPE
   ,INPAR_TITLE
   );

   COMMIT;
/*   SELECT*/
/*    ID*/
/*   INTO*/
/*    OUTPAR_ID*/
/*   FROM TBL_COM_REP_PROFILE_DETAIL*/
/*   WHERE REF_REPORT   = INPAR_REF_REPORT;*/
   OUTPAR_ID   := INPAR_REF_REPORT;
  ELSE
   UPDATE TBL_COM_REP_PROFILE_DETAIL
    SET
     REF_REPORT = INPAR_REF_REPORT
    ,NAME = INPAR_NAME
    ,PROFILE_ID = INPAR_PROFILE_ID
    , ref_ledger_code = INPAR_ref_ledger_code
     ,IS_STANDARD = 0
    ,TYPE = INPAR_TYPE
    ,TITLE = INPAR_TITLE
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
 END PRC_COM_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_COM_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_FIRST_DATE         IN VARCHAR2
 ,INPAR_BAZEH              IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,TYPE
   ,BAZEH
   ,FIRST_DATE
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'com2'
   ,INPAR_TYPE
   ,INPAR_BAZEH
   ,TO_DATE(INPAR_FIRST_DATE,'YYYY/MM/DD')
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
    ,FIRST_DATE = TO_DATE(INPAR_FIRST_DATE,'YYYY/MM/DD')
    ,BAZEH = INPAR_BAZEH
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
    update tbl_report set  H_ID = id where CATEGORY ='com2' AND H_ID IS NULL;
  commit;
 END PRC_COM_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GET_INPUT ( INPAR_VAR IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
 BEGIN
  VAR      := INPAR_VAR;
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title"
FROM TBL_COM_REP_PROFILE_DETAIL where  is_standard =1 order by type'
;
  RETURN OUTPUT;
 END FNC_COM_GET_INPUT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
 
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title",
  to_char(VALUE) as "manualValue",
  PROFILE_ID as "profileId"
FROM TBL_COM_REP_PROFILE_DETAIL where REF_REPORT = '
|| INPAR_REPORT || ' order by type ';
  RETURN OUTPUT;
 END FNC_COM_GET_INPUT_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_COM_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_COM_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
  OUTPAR   := 1;
 END PRC_COM_DELETE_REPORT;
 
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE prc_com_value 
(
  INPAR_ID IN VARCHAR2 
) AS 
 
 VAR_PROFILE         NUMBER;
 VAR_PIVOT           CLOB;
 VAR_REPORT_DATE     DATE;
  VAR_max_DATE     DATE;
var_clob clob;
 VAR_REPORT_BAZEH    NUMBER;
 VAR_SECOND_SELECT   CLOB;
 VAR_FIRST_SELECT    CLOB;
 VAR_REP_REQ_ID number;
 var_count number;
  PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
select max(eff_date) into VAR_max_DATE from TBL_LEDGER_ARCHIVE; --08-AUG-17 max(eff_date)
  
 for j in (SELECT
 D - N AS DATE1
FROM (
  SELECT
   SYSDATE AS D
  FROM DUAL
 )
 ,    (
  SELECT
   N
  FROM (
    SELECT
     ROWNUM N
    FROM DUAL
    CONNECT BY
     LEVEL <= 365
   )
  WHERE N >= 1
 )
WHERE to_date(D,'dd-mm-yyyy') - N NOT IN (
  SELECT DISTINCT
to_date(eff_date,'dd-mm-yyyy') 
  FROM TBL_COM_VALUE  )) loop
  select count(*) into var_count from TBL_LEDGER_ARCHIVE where to_char(EFF_DATE,'j') = to_char(j.DATE1,'j');

  if (var_count >0) then
 FOR I IN (
  SELECT
   *
  FROM TBL_COM_REP_PROFILE_DETAIL where TYPE = 1
 ) LOOP
/*==============================================================================*/
  SELECT
   WMSYS.WM_CONCAT(SPLIT_VALUES ||
   ' as ' ||
   '"' ||
   SPLIT_VALUES ||
   '"')
  INTO
   VAR_PIVOT
  FROM (
    WITH T AS (
     SELECT
      REPLACE(
       FORMULA ||
       '+'
      ,','
      ,''
      ) STR
     FROM TBL_LEDGER_REPORT_MAP
     WHERE ID   = I.PROFILE_ID
    ) SELECT
     REGEXP_SUBSTR(
      STR
     ,'[0-9]+'
     ,1
     ,LEVEL
     ) SPLIT_VALUES
    FROM T
    CONNECT BY
     LEVEL <= (
      SELECT
       LENGTH(REPLACE(STR,'-',NULL) )
      FROM T
     )
   )
  WHERE SPLIT_VALUES IS NOT NULL;
/*==================================================================================*/

  SELECT
   WMSYS.WM_CONCAT('"' ||
   SPLIT_VALUES ||
   '"')
  INTO
   VAR_SECOND_SELECT
  FROM (
    WITH T AS (
     SELECT
      REPLACE(
       FORMULA ||
       '+'
      ,','
      ,''
      ) STR
     FROM TBL_LEDGER_REPORT_MAP
     WHERE ID   = I.PROFILE_ID
    ) SELECT
     REGEXP_SUBSTR(
      STR
     ,'[0-9]+'
     ,1
     ,LEVEL
     ) SPLIT_VALUES
    FROM T
    CONNECT BY
     LEVEL <= (
      SELECT
       LENGTH(REPLACE(STR,'-',NULL) )
      FROM T
     )
   )
  WHERE SPLIT_VALUES IS NOT NULL;
/*==================================================================================*/

  SELECT
   LISTAGG(SPLIT_VALUES,'') WITHIN GROUP(ORDER BY SPLIT_VALUES DESC) ||
   0
  INTO
   VAR_FIRST_SELECT
  FROM (
    SELECT
     CONCAT(
      'nvl(' ||
      '"' ||
      SPLIT_VALUES ||
      '"' ||
      ',0)'
     ,SPLIT_SING
     ) AS SPLIT_VALUES
    FROM (
      WITH T AS (
       SELECT
        REPLACE(
         FORMULA ||
         '+'
        ,','
        ,''
        ) STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE ID   = I.PROFILE_ID
      ) SELECT
       REGEXP_SUBSTR(
        STR
       ,'[0-9]+'
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,'[^0-9]+'
       ,1
       ,LEVEL
       ) SPLIT_SING
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,'-',NULL) )
        FROM T
       )
     )
    WHERE SPLIT_VALUES IS NOT NULL
   );

/*==================================================================================*/

 var_clob:= 'begin  INSERT  INTO TBL_COM_VALUE (
 REF_BRANCH
 ,VALUE
 ,REF_DETAIL_ID
 ,TITLE
 ,REF_REPORT,
 eff_date
)
(
select  ref_branch,' ||
  VAR_FIRST_SELECT ||
  ' ,' ||
  I.ID ||
  ',''' ||
  I.TITLE ||
  ''',' ||
  1 ||
  ',to_date(''' ||
  j.DATE1  ||
  ''')  
  from (
SELECT   ref_branch,' ||
  VAR_SECOND_SELECT ||
  ' FROM
(
  SELECT 
LEDGER_CODE,sum(BALANCE) as balance,REF_BRANCH,EFF_DATE
FROM TBL_LEDGER_BRANCH
WHERE REF_BRANCH IN (
   SELECT
    BRN_ID
   FROM TBL_BRANCH
  )
 AND
  to_date(TBL_LEDGER_BRANCH.EFF_DATE  ,''dd-mm-yyyy'' )= to_date(''' ||
   j.DATE1  ||
  ''',''dd-mm-yyyy'')  
  and LEDGER_CODE in (select * from (  WITH T AS (
       SELECT
       REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = ' ||
  I.PROFILE_ID ||
  '  ) SELECT 
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES

      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT 
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )       ) where SPLIT_VALUES is not null
  ) 
  group by  LEDGER_CODE,REF_BRANCH,EFF_DATE
)
PIVOT
(
  sum( balance )
  FOR ledger_code IN (' ||
  VAR_PIVOT ||
  ')
))); end;';

 
 


EXECUTE IMMEDIATE to_char(var_clob);

commit;
 end loop;
end if;
 END LOOP;
  --EXECUTE IMMEDIATE to_char(var_clob);
commit;
 DBMS_OUTPUT.PUT_LINE(var_clob);

--
--FOR i IN 1..3
--loop
--INSERT INTO TBL_COM_RESULT (
-- CHILD
--  ,DRCI
-- ,IDRCI
-- ,DEPTH
-- ,PARENT
-- ,NAME
-- ) SELECT
-- 100000 || REF_BRANCH AS REF_BRANCH
--  ,( DCI - SD1 * ( VI / V ) ) / ( VI * ( 1 - SD - LD ) ) AS DRCI
-- ,( HRCI + RCI + DPI + ECI + ICI + EECI + OCI + MCI + NPLCI + FCI ) / ( VI * ( 1 - SD - LD ) ) AS IDRCI
-- ,3 AS DEPTH
-- ,TB.REF_STA_ID
-- ,TB.NAME
-- FROM (
--  SELECT
--   TBL_COM_VALUE.REF_BRANCH
--   ,TBL_COM_VALUE.TITLE
--  ,TBL_COM_VALUE.VALUE
--   FROM TBL_COM_VALUE
--  
-- )
--  PIVOT ( MAX ( VALUE )
--   FOR TITLE
--   IN ( 'Ici' AS ICI,'Dci' AS DCI,'Dpi' AS DPI,'Eci' AS ECI,'EECi' AS EECI,'FCi' AS FCI,'HrCi' AS HRCI,'IC' AS IC,'LD' AS LD,'Mci' AS MCI,'NPLCi' AS NPLCI,'OCi'
--AS OCI,'RCi' AS RCI,'SD' AS SD,'V' AS V,'Sd' AS SD1,'Vi' AS VI )
--  )
-- ,    TBL_BRANCH TB
--WHERE TB.BRN_ID   = REF_BRANCH;
--end loop;




END prc_com_value;

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_COM_RESULT 
(
  INPAR_REPREQ IN VARCHAR2 ,
  INPAR_bazeh IN VARCHAR2 
) RETURN VARCHAR2 AS 
BEGIN
  RETURN 'select
 parent as "parent",child as "id",depth as "level",name as "text" ,DRCi as "value1",IDRCi as "value2" ,VALUE3 as "value3"
from ( select * from 
     TBL_COM_RESULT
  where REF_REP_REQ = '||INPAR_REPREQ||' and bazeh = '||INPAR_bazeh||')
start with
  parent is null
connect by
  prior child=parent';
END FNC_COM_RESULT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_COM_GET_RESULT(
    INPAR_DATE IN NUMBER , -- day = 1 , week =2 , month = 3
    INPAR_TYPE IN NUMBER ,
    INPAR_period IN NUMBER --hamin = 1 , dore ghable hamin = 2, moshabehe sale ghabl = 3
    )

  RETURN VARCHAR2
AS
VAR_GHARZALHASANE NUMBER;
VAR_MODATDAR NUMBER;
VAR_KOTAH_MODAT NUMBER;
VAR_JARI NUMBER;
VAR_DATE DATE;
BEGIN

select max(eff_date) into Var_date from tbl_com_result;
if (INPAR_period = 1 ) then
  IF (INPAR_DATE = 1) THEN
   --  case when tcr.CHILD>1000 then tcr.NAME||'-'||substr(tcr.CHILD,7) else tcr.NAME end "text",

   return 'SELECT
      "parent","id","level","text","direct","indirect","total","balance"

FROM
   (SELECT tcr.PARENT "parent",
  tcr.CHILD "id",
  tcr.DEPTH "level",
   tcr.NAME   "text",
  tcr.DIRECT "direct",
  tcr.INDIRECT "indirect",
  tcr.TOTAL "total",
  tcr.balance "balance"
  FROM TBL_COM_RESULT tcr 
  WHERE (tcr.TYPE                        = '||inpar_type||'

AND to_date(tcr.EFF_DATE,''dd-mm-yyyy'')= to_date('''||Var_date||''',''dd-mm-yyyy'')) OR tcr.type                          IS NULL order by child 
)
START WITH
   "parent" is null
CONNECT BY
   PRIOR "id" ="parent"
';


  END IF;
  IF (INPAR_DATE = 2) THEN
   NULL;
  END IF;
  IF (INPAR_DATE = 3) THEN
  NULL;
  END IF;
  end if;
  if(INPAR_period = 2) then
  IF (INPAR_DATE = 1) THEN
   --TOTAL BAYAD TAghsim bar balance beshe
   return '  
  SELECT 
  TOTAL/1 as "balanceOne"
  ,child,
  parent
FROM TBL_COM_RESULT
WHERE (TYPE                        = '||inpar_type||'

AND to_date(EFF_DATE,''dd-mm-yyyy'')= to_date('''||Var_date||''',''dd-mm-yyyy'')-1) OR type                          IS NULL order by child';


  END IF;
  end if;
    if(INPAR_period = 3) then
 IF (INPAR_DATE = 1) THEN
      --TOTAL BAYAD TAghsim bar balance beshe

   return '
  SELECT 
  TOTAL/1 as "balanceTwo"
  ,child,
  parent
FROM TBL_COM_RESULT
WHERE (TYPE                        = '||inpar_type||'

AND to_date(EFF_DATE,''dd-mm-yyyy'')= to_date('''||Var_date||''',''dd-mm-yyyy'')-365) OR type                          IS NULL order by child';
end if;
  end if;
END FNC_COM_GET_RESULT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
END PKG_COM;
--------------------------------------------------------
--  DDL for Table PKG_COM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_COM" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_COM_GI_CALC ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

-- FUNCTION FNC_COM_FINAL_REPORT (
--  INPAR_REPORT   IN NUMBER
-- ,INPAR_TYPE     IN NUMBER
-- ) RETURN VARCHAR2;
-- 
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;

 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_COM_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 , INPAR_ref_ledger_code              IN VARCHAR2
  ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
  /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_COM_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_FIRST_DATE         IN VARCHAR2
 ,INPAR_BAZEH              IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
  /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GET_INPUT ( INPAR_VAR IN VARCHAR2 ) RETURN VARCHAR2;
  /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2 ) RETURN VARCHAR2;
  /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/
 

 PROCEDURE PRC_COM_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
   /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/
  PROCEDURE prc_com_value 
(
  INPAR_ID IN VARCHAR2 
);
   /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_COM_RESULT 
(
  INPAR_REPREQ IN VARCHAR2 ,
  INPAR_bazeh IN VARCHAR2 
) RETURN VARCHAR2 ;
     /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_COM_GET_RESULT(
    INPAR_DATE IN NUMBER ,
    INPAR_TYPE IN NUMBER ,
        INPAR_period IN NUMBER )

  RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_COM;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_COM" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GI_CALC ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
 BEGIN
  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = '
|| INPAR_ID || '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = (select trunc(max(eff_date)) from  TBL_LEDGER_archive))
 '
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  RETURN ABS(TO_NUMBER(VAR2) );
 END FNC_COM_GI_CALC;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "description",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''COM'' order by id';
  RETURN VAR2;
 END FNC_COM_GET_REPORT_INFO;

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_COM_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_ref_ledger_code              IN VARCHAR2
  ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_COM_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,REF_LEDGER_CODE
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) VALUES (
    INPAR_REF_REPORT
   ,INPAR_NAME
   ,INPAR_PROFILE_ID
   ,INPAR_ref_ledger_code
   ,0
   ,INPAR_TYPE
   ,INPAR_TITLE
   );

   COMMIT;
/*   SELECT*/
/*    ID*/
/*   INTO*/
/*    OUTPAR_ID*/
/*   FROM TBL_COM_REP_PROFILE_DETAIL*/
/*   WHERE REF_REPORT   = INPAR_REF_REPORT;*/
   OUTPAR_ID   := INPAR_REF_REPORT;
  ELSE
   UPDATE TBL_COM_REP_PROFILE_DETAIL
    SET
     REF_REPORT = INPAR_REF_REPORT
    ,NAME = INPAR_NAME
    ,PROFILE_ID = INPAR_PROFILE_ID
    , ref_ledger_code = INPAR_ref_ledger_code
     ,IS_STANDARD = 0
    ,TYPE = INPAR_TYPE
    ,TITLE = INPAR_TITLE
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
 END PRC_COM_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_COM_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_FIRST_DATE         IN VARCHAR2
 ,INPAR_BAZEH              IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,TYPE
   ,BAZEH
   ,FIRST_DATE
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'com2'
   ,INPAR_TYPE
   ,INPAR_BAZEH
   ,TO_DATE(INPAR_FIRST_DATE,'YYYY/MM/DD')
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
    ,FIRST_DATE = TO_DATE(INPAR_FIRST_DATE,'YYYY/MM/DD')
    ,BAZEH = INPAR_BAZEH
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
    update tbl_report set  H_ID = id where CATEGORY ='com2' AND H_ID IS NULL;
  commit;
 END PRC_COM_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GET_INPUT ( INPAR_VAR IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
 BEGIN
  VAR      := INPAR_VAR;
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title"
FROM TBL_COM_REP_PROFILE_DETAIL where  is_standard =1 order by type'
;
  RETURN OUTPUT;
 END FNC_COM_GET_INPUT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_COM_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
 
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title",
  to_char(VALUE) as "manualValue",
  PROFILE_ID as "profileId"
FROM TBL_COM_REP_PROFILE_DETAIL where REF_REPORT = '
|| INPAR_REPORT || ' order by type ';
  RETURN OUTPUT;
 END FNC_COM_GET_INPUT_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_COM_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_COM_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
  OUTPAR   := 1;
 END PRC_COM_DELETE_REPORT;
 
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE prc_com_value 
(
  INPAR_ID IN VARCHAR2 
) AS 
 
 VAR_PROFILE         NUMBER;
 VAR_PIVOT           CLOB;
 VAR_REPORT_DATE     DATE;
  VAR_max_DATE     DATE;
var_clob clob;
 VAR_REPORT_BAZEH    NUMBER;
 VAR_SECOND_SELECT   CLOB;
 VAR_FIRST_SELECT    CLOB;
 VAR_REP_REQ_ID number;
 var_count number;
  PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN
select max(eff_date) into VAR_max_DATE from TBL_LEDGER_ARCHIVE; --08-AUG-17 max(eff_date)
  
 for j in (SELECT
 D - N AS DATE1
FROM (
  SELECT
   SYSDATE AS D
  FROM DUAL
 )
 ,    (
  SELECT
   N
  FROM (
    SELECT
     ROWNUM N
    FROM DUAL
    CONNECT BY
     LEVEL <= 365
   )
  WHERE N >= 1
 )
WHERE to_date(D,'dd-mm-yyyy') - N NOT IN (
  SELECT DISTINCT
to_date(eff_date,'dd-mm-yyyy') 
  FROM TBL_COM_VALUE  )) loop
  select count(*) into var_count from TBL_LEDGER_ARCHIVE where to_char(EFF_DATE,'j') = to_char(j.DATE1,'j');

  if (var_count >0) then
 FOR I IN (
  SELECT
   *
  FROM TBL_COM_REP_PROFILE_DETAIL where TYPE = 1
 ) LOOP
/*==============================================================================*/
  SELECT
   WMSYS.WM_CONCAT(SPLIT_VALUES ||
   ' as ' ||
   '"' ||
   SPLIT_VALUES ||
   '"')
  INTO
   VAR_PIVOT
  FROM (
    WITH T AS (
     SELECT
      REPLACE(
       FORMULA ||
       '+'
      ,','
      ,''
      ) STR
     FROM TBL_LEDGER_REPORT_MAP
     WHERE ID   = I.PROFILE_ID
    ) SELECT
     REGEXP_SUBSTR(
      STR
     ,'[0-9]+'
     ,1
     ,LEVEL
     ) SPLIT_VALUES
    FROM T
    CONNECT BY
     LEVEL <= (
      SELECT
       LENGTH(REPLACE(STR,'-',NULL) )
      FROM T
     )
   )
  WHERE SPLIT_VALUES IS NOT NULL;
/*==================================================================================*/

  SELECT
   WMSYS.WM_CONCAT('"' ||
   SPLIT_VALUES ||
   '"')
  INTO
   VAR_SECOND_SELECT
  FROM (
    WITH T AS (
     SELECT
      REPLACE(
       FORMULA ||
       '+'
      ,','
      ,''
      ) STR
     FROM TBL_LEDGER_REPORT_MAP
     WHERE ID   = I.PROFILE_ID
    ) SELECT
     REGEXP_SUBSTR(
      STR
     ,'[0-9]+'
     ,1
     ,LEVEL
     ) SPLIT_VALUES
    FROM T
    CONNECT BY
     LEVEL <= (
      SELECT
       LENGTH(REPLACE(STR,'-',NULL) )
      FROM T
     )
   )
  WHERE SPLIT_VALUES IS NOT NULL;
/*==================================================================================*/

  SELECT
   LISTAGG(SPLIT_VALUES,'') WITHIN GROUP(ORDER BY SPLIT_VALUES DESC) ||
   0
  INTO
   VAR_FIRST_SELECT
  FROM (
    SELECT
     CONCAT(
      'nvl(' ||
      '"' ||
      SPLIT_VALUES ||
      '"' ||
      ',0)'
     ,SPLIT_SING
     ) AS SPLIT_VALUES
    FROM (
      WITH T AS (
       SELECT
        REPLACE(
         FORMULA ||
         '+'
        ,','
        ,''
        ) STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE ID   = I.PROFILE_ID
      ) SELECT
       REGEXP_SUBSTR(
        STR
       ,'[0-9]+'
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,'[^0-9]+'
       ,1
       ,LEVEL
       ) SPLIT_SING
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,'-',NULL) )
        FROM T
       )
     )
    WHERE SPLIT_VALUES IS NOT NULL
   );

/*==================================================================================*/

 var_clob:= 'begin  INSERT  INTO TBL_COM_VALUE (
 REF_BRANCH
 ,VALUE
 ,REF_DETAIL_ID
 ,TITLE
 ,REF_REPORT,
 eff_date
)
(
select  ref_branch,' ||
  VAR_FIRST_SELECT ||
  ' ,' ||
  I.ID ||
  ',''' ||
  I.TITLE ||
  ''',' ||
  1 ||
  ',to_date(''' ||
  j.DATE1  ||
  ''')  
  from (
SELECT   ref_branch,' ||
  VAR_SECOND_SELECT ||
  ' FROM
(
  SELECT 
LEDGER_CODE,sum(BALANCE) as balance,REF_BRANCH,EFF_DATE
FROM TBL_LEDGER_BRANCH
WHERE REF_BRANCH IN (
   SELECT
    BRN_ID
   FROM TBL_BRANCH
  )
 AND
  to_date(TBL_LEDGER_BRANCH.EFF_DATE  ,''dd-mm-yyyy'' )= to_date(''' ||
   j.DATE1  ||
  ''',''dd-mm-yyyy'')  
  and LEDGER_CODE in (select * from (  WITH T AS (
       SELECT
       REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = ' ||
  I.PROFILE_ID ||
  '  ) SELECT 
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES

      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT 
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )       ) where SPLIT_VALUES is not null
  ) 
  group by  LEDGER_CODE,REF_BRANCH,EFF_DATE
)
PIVOT
(
  sum( balance )
  FOR ledger_code IN (' ||
  VAR_PIVOT ||
  ')
))); end;';

 
 


EXECUTE IMMEDIATE to_char(var_clob);

commit;
 end loop;
end if;
 END LOOP;
  --EXECUTE IMMEDIATE to_char(var_clob);
commit;
 DBMS_OUTPUT.PUT_LINE(var_clob);

--
--FOR i IN 1..3
--loop
--INSERT INTO TBL_COM_RESULT (
-- CHILD
--  ,DRCI
-- ,IDRCI
-- ,DEPTH
-- ,PARENT
-- ,NAME
-- ) SELECT
-- 100000 || REF_BRANCH AS REF_BRANCH
--  ,( DCI - SD1 * ( VI / V ) ) / ( VI * ( 1 - SD - LD ) ) AS DRCI
-- ,( HRCI + RCI + DPI + ECI + ICI + EECI + OCI + MCI + NPLCI + FCI ) / ( VI * ( 1 - SD - LD ) ) AS IDRCI
-- ,3 AS DEPTH
-- ,TB.REF_STA_ID
-- ,TB.NAME
-- FROM (
--  SELECT
--   TBL_COM_VALUE.REF_BRANCH
--   ,TBL_COM_VALUE.TITLE
--  ,TBL_COM_VALUE.VALUE
--   FROM TBL_COM_VALUE
--  
-- )
--  PIVOT ( MAX ( VALUE )
--   FOR TITLE
--   IN ( 'Ici' AS ICI,'Dci' AS DCI,'Dpi' AS DPI,'Eci' AS ECI,'EECi' AS EECI,'FCi' AS FCI,'HrCi' AS HRCI,'IC' AS IC,'LD' AS LD,'Mci' AS MCI,'NPLCi' AS NPLCI,'OCi'
--AS OCI,'RCi' AS RCI,'SD' AS SD,'V' AS V,'Sd' AS SD1,'Vi' AS VI )
--  )
-- ,    TBL_BRANCH TB
--WHERE TB.BRN_ID   = REF_BRANCH;
--end loop;




END prc_com_value;

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_COM_RESULT 
(
  INPAR_REPREQ IN VARCHAR2 ,
  INPAR_bazeh IN VARCHAR2 
) RETURN VARCHAR2 AS 
BEGIN
  RETURN 'select
 parent as "parent",child as "id",depth as "level",name as "text" ,DRCi as "value1",IDRCi as "value2" ,VALUE3 as "value3"
from ( select * from 
     TBL_COM_RESULT
  where REF_REP_REQ = '||INPAR_REPREQ||' and bazeh = '||INPAR_bazeh||')
start with
  parent is null
connect by
  prior child=parent';
END FNC_COM_RESULT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_COM_GET_RESULT(
    INPAR_DATE IN NUMBER , -- day = 1 , week =2 , month = 3
    INPAR_TYPE IN NUMBER ,
    INPAR_period IN NUMBER --hamin = 1 , dore ghable hamin = 2, moshabehe sale ghabl = 3
    )

  RETURN VARCHAR2
AS
VAR_GHARZALHASANE NUMBER;
VAR_MODATDAR NUMBER;
VAR_KOTAH_MODAT NUMBER;
VAR_JARI NUMBER;
VAR_DATE DATE;
BEGIN

select max(eff_date) into Var_date from tbl_com_result;
if (INPAR_period = 1 ) then
  IF (INPAR_DATE = 1) THEN
   --  case when tcr.CHILD>1000 then tcr.NAME||'-'||substr(tcr.CHILD,7) else tcr.NAME end "text",

   return 'SELECT
      "parent","id","level","text","direct","indirect","total","balance"

FROM
   (SELECT tcr.PARENT "parent",
  tcr.CHILD "id",
  tcr.DEPTH "level",
   tcr.NAME   "text",
  tcr.DIRECT "direct",
  tcr.INDIRECT "indirect",
  tcr.TOTAL "total",
  tcr.balance "balance"
  FROM TBL_COM_RESULT tcr 
  WHERE (tcr.TYPE                        = '||inpar_type||'

AND to_date(tcr.EFF_DATE,''dd-mm-yyyy'')= to_date('''||Var_date||''',''dd-mm-yyyy'')) OR tcr.type                          IS NULL order by child 
)
START WITH
   "parent" is null
CONNECT BY
   PRIOR "id" ="parent"
';


  END IF;
  IF (INPAR_DATE = 2) THEN
   NULL;
  END IF;
  IF (INPAR_DATE = 3) THEN
  NULL;
  END IF;
  end if;
  if(INPAR_period = 2) then
  IF (INPAR_DATE = 1) THEN
   --TOTAL BAYAD TAghsim bar balance beshe
   return '  
  SELECT 
  TOTAL/1 as "balanceOne"
  ,child,
  parent
FROM TBL_COM_RESULT
WHERE (TYPE                        = '||inpar_type||'

AND to_date(EFF_DATE,''dd-mm-yyyy'')= to_date('''||Var_date||''',''dd-mm-yyyy'')-1) OR type                          IS NULL order by child';


  END IF;
  end if;
    if(INPAR_period = 3) then
 IF (INPAR_DATE = 1) THEN
      --TOTAL BAYAD TAghsim bar balance beshe

   return '
  SELECT 
  TOTAL/1 as "balanceTwo"
  ,child,
  parent
FROM TBL_COM_RESULT
WHERE (TYPE                        = '||inpar_type||'

AND to_date(EFF_DATE,''dd-mm-yyyy'')= to_date('''||Var_date||''',''dd-mm-yyyy'')-365) OR type                          IS NULL order by child';
end if;
  end if;
END FNC_COM_GET_RESULT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
END PKG_COM;
--------------------------------------------------------
--  DDL for Table PKG_NIIM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_NIIM" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_NIIM_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NIIM_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_VALUE              IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NIIM_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE prc_niim_update_gi_calc(INPAR_ref_report IN VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NIIM_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NIIM_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 ;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NIIM_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NIIM_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2;
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_NIIM;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_NIIM" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_NIIM_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_NIIM_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
 END PRC_NIIM_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NIIM_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_VALUE              IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_NIIM_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,VALUE
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) VALUES (
    INPAR_REF_REPORT
   ,INPAR_NAME
   ,INPAR_PROFILE_ID
   ,INPAR_VALUE
   ,0
   ,INPAR_TYPE
   ,INPAR_TITLE
   );

   COMMIT;
/*   SELECT*/
/*    ID*/
/*   INTO*/
/*    OUTPAR_ID*/
/*   FROM TBL_COM_REP_PROFILE_DETAIL*/
/*   WHERE REF_REPORT   = INPAR_REF_REPORT;*/
   OUTPAR_ID   := INPAR_REF_REPORT;
  ELSE
   UPDATE TBL_NIIM_REP_PROFILE_DETAIL
    SET
     REF_REPORT = INPAR_REF_REPORT
    ,NAME = INPAR_NAME
    ,PROFILE_ID = INPAR_PROFILE_ID
    ,VALUE = INPAR_VALUE
    ,IS_STANDARD = 0
    ,TYPE = INPAR_TYPE
    ,TITLE = INPAR_TITLE
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
 END PRC_NIIM_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NIIM_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,TYPE
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'niim'
   ,inpar_type
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
  
  --=============
  INSERT INTO TBL_NIIM_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,VALUE
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) (select(select max(id) from tbl_report where upper(type) = 'NIIM'),NAME
   ,0
   ,0
   ,0
   ,TYPE
   ,TITLE
   from tbl_niim_rep_profile_detail where is_standard=1
   );
   COMMIT;
  --==============
 END PRC_NIIM_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_NIIM_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2 AS
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
 BEGIN
 if INPAR_ID is not null then
  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = '
|| INPAR_ID || '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = (select trunc(max(eff_date)) from  TBL_LEDGER_archive))
 '
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  RETURN abs(TO_number(VAR2));
  else 
   RETURN 0;
  end if;
 END FNC_NIIM_GI_CALC;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NIIM_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
 BEGIN
  
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title"
FROM TBL_NIIM_REP_PROFILE_DETAIL where  is_standard =1 and  type = '||INPAR_type||''
;
  RETURN OUTPUT;
 END FNC_NIIM_GET_INPUT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NIIM_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "description",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''NIIM'' order by id';
  RETURN VAR2;
 END FNC_NIIM_GET_REPORT_INFO;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 
 FUNCTION FNC_NIIM_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
   pragma autonomous_transaction;
 BEGIN
 pkg_niim.prc_niim_update_gi_calc(INPAR_REPORT);
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title",
  to_char(VALUE) as "manualValue",
  PROFILE_ID as "profileId"
FROM TBL_NIIM_REP_PROFILE_DETAIL where REF_REPORT = '
|| INPAR_REPORT || ' AND TYPE = '
|| INPAR_TYPE || ' order by type ';
  RETURN OUTPUT;
 END FNC_NIIM_GET_INPUT_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE prc_niim_update_gi_calc(
    INPAR_ref_report IN VARCHAR2 )
AS
BEGIN
  FOR i IN
  (SELECT * FROM TBL_niim_REP_PROFILE_DETAIL WHERE ref_report = INPAR_ref_report
  )
  LOOP
    IF(i.profile_id IS NOT NULL) THEN
      UPDATE TBL_niim_REP_PROFILE_DETAIL
      SET value        = pkg_niim.FNC_niim_GI_CALC(i.profile_id)
      WHERE ref_report = INPAR_ref_report
      AND i.id         =id ;
      COMMIT;
    END IF;
  END LOOP;
END prc_niim_update_gi_calc;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
END PKG_NIIM;
--------------------------------------------------------
--  DDL for Table PKG_NIIM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_NIIM" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_NIIM_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NIIM_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_VALUE              IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NIIM_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE prc_niim_update_gi_calc(INPAR_ref_report IN VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NIIM_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NIIM_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 ;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NIIM_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NIIM_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2;
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_NIIM;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_NIIM" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_NIIM_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_NIIM_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
 END PRC_NIIM_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NIIM_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_VALUE              IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_NIIM_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,VALUE
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) VALUES (
    INPAR_REF_REPORT
   ,INPAR_NAME
   ,INPAR_PROFILE_ID
   ,INPAR_VALUE
   ,0
   ,INPAR_TYPE
   ,INPAR_TITLE
   );

   COMMIT;
/*   SELECT*/
/*    ID*/
/*   INTO*/
/*    OUTPAR_ID*/
/*   FROM TBL_COM_REP_PROFILE_DETAIL*/
/*   WHERE REF_REPORT   = INPAR_REF_REPORT;*/
   OUTPAR_ID   := INPAR_REF_REPORT;
  ELSE
   UPDATE TBL_NIIM_REP_PROFILE_DETAIL
    SET
     REF_REPORT = INPAR_REF_REPORT
    ,NAME = INPAR_NAME
    ,PROFILE_ID = INPAR_PROFILE_ID
    ,VALUE = INPAR_VALUE
    ,IS_STANDARD = 0
    ,TYPE = INPAR_TYPE
    ,TITLE = INPAR_TITLE
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
 END PRC_NIIM_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NIIM_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,TYPE
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'niim'
   ,inpar_type
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
  
  --=============
  INSERT INTO TBL_NIIM_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,VALUE
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) (select(select max(id) from tbl_report where upper(type) = 'NIIM'),NAME
   ,0
   ,0
   ,0
   ,TYPE
   ,TITLE
   from tbl_niim_rep_profile_detail where is_standard=1
   );
   COMMIT;
  --==============
 END PRC_NIIM_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_NIIM_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2 AS
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
 BEGIN
 if INPAR_ID is not null then
  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = '
|| INPAR_ID || '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = (select trunc(max(eff_date)) from  TBL_LEDGER_archive))
 '
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  RETURN abs(TO_number(VAR2));
  else 
   RETURN 0;
  end if;
 END FNC_NIIM_GI_CALC;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NIIM_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
 BEGIN
  
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title"
FROM TBL_NIIM_REP_PROFILE_DETAIL where  is_standard =1 and  type = '||INPAR_type||''
;
  RETURN OUTPUT;
 END FNC_NIIM_GET_INPUT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NIIM_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "description",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''NIIM'' order by id';
  RETURN VAR2;
 END FNC_NIIM_GET_REPORT_INFO;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 
 FUNCTION FNC_NIIM_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
   pragma autonomous_transaction;
 BEGIN
 pkg_niim.prc_niim_update_gi_calc(INPAR_REPORT);
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title",
  to_char(VALUE) as "manualValue",
  PROFILE_ID as "profileId"
FROM TBL_NIIM_REP_PROFILE_DETAIL where REF_REPORT = '
|| INPAR_REPORT || ' AND TYPE = '
|| INPAR_TYPE || ' order by type ';
  RETURN OUTPUT;
 END FNC_NIIM_GET_INPUT_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE prc_niim_update_gi_calc(
    INPAR_ref_report IN VARCHAR2 )
AS
BEGIN
  FOR i IN
  (SELECT * FROM TBL_niim_REP_PROFILE_DETAIL WHERE ref_report = INPAR_ref_report
  )
  LOOP
    IF(i.profile_id IS NOT NULL) THEN
      UPDATE TBL_niim_REP_PROFILE_DETAIL
      SET value        = pkg_niim.FNC_niim_GI_CALC(i.profile_id)
      WHERE ref_report = INPAR_ref_report
      AND i.id         =id ;
      COMMIT;
    END IF;
  END LOOP;
END prc_niim_update_gi_calc;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
END PKG_NIIM;
--------------------------------------------------------
--  DDL for Table PKG_NPL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_NPL" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_NPL_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NPL_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_VALUE              IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NPL_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE prc_npl_update_gi_calc(INPAR_ref_report IN VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NPL_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NPL_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 ;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NPL_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NPL_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2;
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/


END PKG_NPL;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_NPL" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NPL_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_NPL_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
 END PRC_NPL_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NPL_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_VALUE              IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_NPL_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,VALUE
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) VALUES (
    INPAR_REF_REPORT
   ,INPAR_NAME
   ,INPAR_PROFILE_ID
   ,INPAR_VALUE
   ,0
   ,INPAR_TYPE
   ,INPAR_TITLE
   );
  
   COMMIT;
/*   SELECT*/
/*    ID*/
/*   INTO*/
/*    OUTPAR_ID*/
/*   FROM TBL_COM_REP_PROFILE_DETAIL*/
/*   WHERE REF_REPORT   = INPAR_REF_REPORT;*/
   OUTPAR_ID   := INPAR_REF_REPORT;
  ELSE
   UPDATE TBL_NPL_REP_PROFILE_DETAIL
    SET
     REF_REPORT = INPAR_REF_REPORT
    ,NAME = INPAR_NAME
    ,PROFILE_ID = INPAR_PROFILE_ID
    ,VALUE = INPAR_VALUE
    ,IS_STANDARD = 0
    ,TYPE = INPAR_TYPE
    ,TITLE = INPAR_TITLE
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
 END PRC_NPL_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NPL_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,TYPE
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'NPL'
   ,INPAR_TYPE
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
  
  --=============
  INSERT INTO TBL_NPL_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,VALUE
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) (select(select max(id) from tbl_report where upper(type) = 'NPL') ,NAME
   ,0
   ,0
   ,0
   ,TYPE
   ,TITLE
   from tbl_npl_rep_profile_detail where is_standard=1
   );
   COMMIT;
  --==============
  
  
  
 END PRC_NPL_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_NPL_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2 AS
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
 BEGIN
  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = '
|| INPAR_ID || '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = (select trunc(max(eff_date)) from  TBL_LEDGER_archive))
 '
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  RETURN abs(TO_number(VAR2));
 END FNC_NPL_GI_CALC;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NPL_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
 BEGIN
  var:= inpar_type;
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title"
FROM TBL_NPL_REP_PROFILE_DETAIL where  is_standard =1 '
;
  RETURN OUTPUT;
 END FNC_NPL_GET_INPUT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NPL_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "description",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''NPL'' order by id';
  RETURN VAR2;
 END FNC_NPL_GET_REPORT_INFO;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 
 FUNCTION FNC_NPL_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
   pragma autonomous_transaction;
 BEGIN
 pkg_NPL.prc_npl_update_gi_calc(INPAR_REPORT);
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title",
  to_char(VALUE) as "manualValue",
  PROFILE_ID as "profileId"
FROM TBL_NPL_REP_PROFILE_DETAIL where REF_REPORT = '
|| INPAR_REPORT || ' AND TYPE = 2 order by type ';
  RETURN OUTPUT;
 END FNC_NPL_GET_INPUT_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE prc_npl_update_gi_calc(
    INPAR_ref_report IN VARCHAR2 )
AS
BEGIN
  FOR i IN
  (SELECT * FROM TBL_npl_REP_PROFILE_DETAIL WHERE ref_report = INPAR_ref_report
  )
  LOOP
    IF(i.profile_id IS NOT NULL) THEN
      UPDATE TBL_npl_REP_PROFILE_DETAIL
      SET value        = pkg_npl.FNC_npl_GI_CALC(i.profile_id)
      WHERE ref_report = INPAR_ref_report
      AND i.id         =id ;
      COMMIT;
    END IF;
  END LOOP;
END prc_npl_update_gi_calc;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
END PKG_NPL;
--------------------------------------------------------
--  DDL for Table PKG_NPL
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_NPL" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_NPL_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NPL_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_VALUE              IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NPL_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE prc_npl_update_gi_calc(INPAR_ref_report IN VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NPL_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NPL_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 ;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NPL_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NPL_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2;
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/


END PKG_NPL;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_NPL" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NPL_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_NPL_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
 END PRC_NPL_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NPL_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_VALUE              IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_NPL_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,VALUE
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) VALUES (
    INPAR_REF_REPORT
   ,INPAR_NAME
   ,INPAR_PROFILE_ID
   ,INPAR_VALUE
   ,0
   ,INPAR_TYPE
   ,INPAR_TITLE
   );
  
   COMMIT;
/*   SELECT*/
/*    ID*/
/*   INTO*/
/*    OUTPAR_ID*/
/*   FROM TBL_COM_REP_PROFILE_DETAIL*/
/*   WHERE REF_REPORT   = INPAR_REF_REPORT;*/
   OUTPAR_ID   := INPAR_REF_REPORT;
  ELSE
   UPDATE TBL_NPL_REP_PROFILE_DETAIL
    SET
     REF_REPORT = INPAR_REF_REPORT
    ,NAME = INPAR_NAME
    ,PROFILE_ID = INPAR_PROFILE_ID
    ,VALUE = INPAR_VALUE
    ,IS_STANDARD = 0
    ,TYPE = INPAR_TYPE
    ,TITLE = INPAR_TITLE
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
 END PRC_NPL_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NPL_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,TYPE
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'NPL'
   ,INPAR_TYPE
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
  
  --=============
  INSERT INTO TBL_NPL_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,VALUE
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) (select(select max(id) from tbl_report where upper(type) = 'NPL') ,NAME
   ,0
   ,0
   ,0
   ,TYPE
   ,TITLE
   from tbl_npl_rep_profile_detail where is_standard=1
   );
   COMMIT;
  --==============
  
  
  
 END PRC_NPL_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_NPL_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2 AS
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
 BEGIN
  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = '
|| INPAR_ID || '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = (select trunc(max(eff_date)) from  TBL_LEDGER_archive))
 '
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  RETURN abs(TO_number(VAR2));
 END FNC_NPL_GI_CALC;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NPL_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
 BEGIN
  var:= inpar_type;
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title"
FROM TBL_NPL_REP_PROFILE_DETAIL where  is_standard =1 '
;
  RETURN OUTPUT;
 END FNC_NPL_GET_INPUT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NPL_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "description",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''NPL'' order by id';
  RETURN VAR2;
 END FNC_NPL_GET_REPORT_INFO;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 
 FUNCTION FNC_NPL_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
   pragma autonomous_transaction;
 BEGIN
 pkg_NPL.prc_npl_update_gi_calc(INPAR_REPORT);
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title",
  to_char(VALUE) as "manualValue",
  PROFILE_ID as "profileId"
FROM TBL_NPL_REP_PROFILE_DETAIL where REF_REPORT = '
|| INPAR_REPORT || ' AND TYPE = 2 order by type ';
  RETURN OUTPUT;
 END FNC_NPL_GET_INPUT_EDIT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE prc_npl_update_gi_calc(
    INPAR_ref_report IN VARCHAR2 )
AS
BEGIN
  FOR i IN
  (SELECT * FROM TBL_npl_REP_PROFILE_DETAIL WHERE ref_report = INPAR_ref_report
  )
  LOOP
    IF(i.profile_id IS NOT NULL) THEN
      UPDATE TBL_npl_REP_PROFILE_DETAIL
      SET value        = pkg_npl.FNC_npl_GI_CALC(i.profile_id)
      WHERE ref_report = INPAR_ref_report
      AND i.id         =id ;
      COMMIT;
    END IF;
  END LOOP;
END prc_npl_update_gi_calc;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
END PKG_NPL;
--------------------------------------------------------
--  DDL for Table PKG_LCR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_LCR" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_LCR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_LCR_rep_value (
  inpar_report   IN VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_LCR_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_VALUE              IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_LCR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE prc_lcr_update_gi_calc(INPAR_ref_report IN VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_LCR_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_LCR_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 ;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_LCR_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_LCR_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_LCR;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_LCR" 
AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_LCR_DELETE_REPORT(
    INPAR_ID IN VARCHAR2 ,
    OUTPAR OUT VARCHAR2)
AS
BEGIN
  DELETE FROM TBL_REPORT WHERE ID = INPAR_ID;
  COMMIT;
  DELETE FROM TBL_LCR_REP_PROFILE_DETAIL WHERE REF_REPORT = INPAR_ID;
  COMMIT;
END PRC_LCR_DELETE_REPORT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE PRC_LCR_REP_PROFILE_DETAIL(
    INPAR_REF_REPORT       IN VARCHAR2 ,
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_PROFILE_ID       IN VARCHAR2 ,
    INPAR_VALUE            IN VARCHAR2 ,
    INPAR_IS_STANDARD      IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    INPAR_PERCENT          IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_TITLE            IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS

BEGIN





  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_lcr_REP_PROFILE_DETAIL
      (
        REF_REPORT ,
        NAME ,
        PROFILE_ID ,
        VALUE ,
        IS_STANDARD ,
        percent ,
        TYPE ,
        TITLE
      
      )
      VALUES
      (
        INPAR_REF_REPORT ,
        INPAR_NAME ,
        INPAR_PROFILE_ID ,
        INPAR_VALUE ,
        0 ,
        inpar_percent ,
        INPAR_TYPE ,
        INPAR_TITLE
     
      );
    COMMIT;
    /*   SELECT*/
    /*    ID*/
    /*   INTO*/
    /*    OUTPAR_ID*/
    /*   FROM TBL_COM_REP_PROFILE_DETAIL*/
    /*   WHERE REF_REPORT   = INPAR_REF_REPORT;*/
    OUTPAR_ID := INPAR_REF_REPORT;
  ELSE
    UPDATE TBL_LCR_REP_PROFILE_DETAIL
    SET REF_REPORT = INPAR_REF_REPORT ,
      NAME         = INPAR_NAME ,
      PROFILE_ID   = INPAR_PROFILE_ID ,
      VALUE        = INPAR_VALUE ,
      IS_STANDARD  = 0 ,
      percent      = inpar_percent ,
      TYPE         = INPAR_TYPE ,
      TITLE        = INPAR_TITLE
    WHERE ID       = INPAR_ID;
  END IF;
  COMMIT;
END PRC_LCR_REP_PROFILE_DETAIL;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
 PROCEDURE PRC_LCR_rep_value (
  inpar_report   IN VARCHAR2
 ) as
 var_version number;
 VAR_FORMULA VARCHAR2(30000);
 VAR_SUM NUMBER ;
begin
--=============
 
  
  select max(id) into var_version from TBL_REPREQ;
  --===========
  INSERT
  INTO TBL_lcr_REP_PROFILE_DETAIL
    (
      REF_REPORT ,
      NAME ,
      PROFILE_ID ,
      VALUE ,
      IS_STANDARD ,
      
      percent ,
      TYPE ,
      TITLE,
      ref_repreq,
      IS_SPECIAL_TYPE
    )
    (SELECT
        (--SELECT MAX(id) FROM tbl_report WHERE upper(type) = 'LCR'
        inpar_report
        ),
        NAME ,
        0 ,
        0 ,
        0 ,
        
        percent ,
        TYPE ,
        TITLE,
        var_version,
        IS_SPECIAL_TYPE
      FROM tbl_lcr_rep_profile_detail
      WHERE is_standard=1 and (type <> 2 or title <>1)
    );
    --+*********************************************************************************
        --+*********************************************************************************
    --+*********************************************************************************

    FOR I IN (SELECT * FROM TBL_LCR_REP_PROFILE_DETAIL WHERE TYPE          = 2
 AND
 TITLE         = 1
 AND
  IS_STANDARD   = 1 )
LOOP

SELECT
 FORMULA  INTO VAR_FORMULA
FROM TBL_LCR_REP_PROFILE_DETAIL
WHERE TYPE          = 2
 AND
 TITLE         = 1
 AND
  IS_STANDARD   = 1
 AND
 ID = I.ID;
if( i.IS_SPECIAL_TYPE <> 'more_than_30')
then

SELECT
NVL(sum(balance),0)   INTO VAR_SUM
FROM AKIN.TBL_DEPOSIT
WHERE DUE_DATE<= TRUNC(SYSDATE) + 30
 AND
  REF_DEPOSIT_ACCOUNTING IN (
   SELECT
    AKIN.TBL_DEPOSIT_ACCOUNTING.DEP_ACC_ID
   FROM AKIN.TBL_DEPOSIT_ACCOUNTING where LEDGER_CODE_SELF in (
   select regexp_substr(VAR_FORMULA,'[^,]+', 1, level) from dual
     connect by regexp_substr(VAR_FORMULA, '[^,]+', 1, level) is not null
   )
  );
 
 
   INSERT
  INTO TBL_lcr_REP_PROFILE_DETAIL
    (
      REF_REPORT ,
      NAME ,
      PROFILE_ID ,
      VALUE ,
      IS_STANDARD ,
      percent ,
      TYPE ,
      TITLE,
      ref_repreq,
      IS_SPECIAL_TYPE
    )  
    VALUES(inpar_report,
        I.NAME ,
        0 ,
        VAR_SUM ,
        0 ,
        I.percent ,
        I.TYPE ,
        I.TITLE,
        var_version,
        i.IS_SPECIAL_TYPE);
        else 
        
        SELECT
NVL(sum(balance),0)   INTO VAR_SUM
FROM AKIN.TBL_DEPOSIT
WHERE DUE_DATE> TRUNC(SYSDATE) + 30
 AND
  REF_DEPOSIT_ACCOUNTING IN (
   SELECT
    AKIN.TBL_DEPOSIT_ACCOUNTING.DEP_ACC_ID
   FROM AKIN.TBL_DEPOSIT_ACCOUNTING where LEDGER_CODE_SELF in (
   select regexp_substr(VAR_FORMULA,'[^,]+', 1, level) from dual
     connect by regexp_substr(VAR_FORMULA, '[^,]+', 1, level) is not null
   )
  );
 
 
   INSERT
  INTO TBL_lcr_REP_PROFILE_DETAIL
    (
      REF_REPORT ,
      NAME ,
      PROFILE_ID ,
      VALUE ,
      IS_STANDARD ,
      percent ,
      TYPE ,
      TITLE,
      ref_repreq,
      IS_SPECIAL_TYPE
    )  
    VALUES(inpar_report,
        I.NAME ,
        0 ,
        VAR_SUM ,
        0 ,
        I.percent ,
        I.TYPE ,
        I.TITLE,
        var_version,
        i.IS_SPECIAL_TYPE);
        end if;
  END LOOP;
        
  COMMIT;
  --==============
END PRC_LCR_rep_value;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE PRC_LCR_REP_PROFILE_REPORT(
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_REF_USER         IN VARCHAR2 ,
    INPAR_STATUS           IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS

BEGIN


  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_REPORT
      (
        NAME ,
        DES ,
        CREATE_DATE ,
        REF_USER ,
        STATUS ,
        CATEGORY ,
        TYPE
      )
      VALUES
      (
        INPAR_NAME ,
        INPAR_DES ,
        SYSDATE ,
        INPAR_REF_USER ,
        INPAR_STATUS ,
        'lcr' ,
        INPAR_TYPE
      );
    COMMIT;
    SELECT ID
    INTO OUTPAR_ID
    FROM TBL_REPORT
    WHERE CREATE_DATE =
      ( SELECT MAX(CREATE_DATE) FROM TBL_REPORT
      )
    AND ID =
      ( SELECT MAX(ID) FROM TBL_REPORT
      );
  ELSE
    UPDATE TBL_REPORT
    SET NAME   = INPAR_NAME ,
      DES      = INPAR_DES ,
      REF_USER = INPAR_REF_USER ,
      STATUS   = INPAR_STATUS ,
      TYPE     = INPAR_TYPE
    WHERE ID   = INPAR_ID;
    COMMIT;
  END IF;
  
  update TBL_REPORT
  set H_ID = id
  where type = 'LCR' and H_ID is null;
  commit;
--  --=============
--  
--  INSERT
--INTO TBL_REPREQ
--  (
--
--    REF_REPORT_ID,
--    REQ_DATE,
--    STATUS,
--    TYPE,
--    CATEGORY
--  )
--  values
-- (
-- OUTPAR_ID
-- ,sysdate
-- ,1
-- ,'LCR'
--  ,'LCR'
--  );
--  commit;
--  
--  select max(id) into var_version from TBL_REPREQ;
--  --===========
--  INSERT
--  INTO TBL_lcr_REP_PROFILE_DETAIL
--    (
--      REF_REPORT ,
--      NAME ,
--      PROFILE_ID ,
--      VALUE ,
--      IS_STANDARD ,
--      percent ,
--      TYPE ,
--      TITLE,
--      ref_repreq
--    )
--    (SELECT
--        (SELECT MAX(id) FROM tbl_report WHERE upper(type) = 'LCR'
--        ),
--        NAME ,
--        0 ,
--        0 ,
--        0 ,
--        percent ,
--        TYPE ,
--        TITLE,
--        var_version
--      FROM tbl_lcr_rep_profile_detail
--      WHERE is_standard=1
--    );
--  COMMIT;
--  --==============
END PRC_LCR_REP_PROFILE_REPORT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_LCR_GI_CALC
  (
    INPAR_ID IN VARCHAR2
  )
  RETURN VARCHAR2
AS
  VAR CLOB;
  VAR2 CLOB;
  VAR3 CLOB;
BEGIN

if (INPAR_ID is not null) then
  SELECT '  
SELECT   
REPLACE(    
WMSYS.WM_CONCAT(V)   
,'',''   
,''''   
)   
FROM (    
SELECT     
ABS(DG.BALANCE) ||     
A.SPLIT_SING AS V    
FROM (      
WITH T AS (       
SELECT        
REPLACE(FORMULA||''+'','','','''') STR       
FROM TBL_LEDGER_REPORT_MAP       
WHERE id   = '
    || INPAR_ID
    || '   ) SELECT       
REGEXP_SUBSTR(        
STR       
,''[0-9]+''       
,1       
,LEVEL       
) SPLIT_VALUES      
,REGEXP_SUBSTR(        
STR       
,''[^0-9]+''       
,1       
,LEVEL       
) SPLIT_SING      
,LEVEL AS LEV      
FROM T      
CONNECT BY       
LEVEL <= (        
SELECT         
LENGTH(REPLACE(STR,''-'',NULL) )        
FROM T       
)     
) A    
,TBL_LEDGER_archive DG    
WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES     
AND      
SPLIT_VALUES IS NOT NULL        
AND      
trunc(DG.EFF_DATE)                                          = (select trunc(max(eff_date)) from  TBL_LEDGER_archive)) 
'
  INTO VAR
  FROM DUAL;
  EXECUTE IMMEDIATE VAR INTO VAR3;
  SELECT
    CASE
      WHEN SUBSTR( TO_CHAR(VAR3) ,-1 ) IN ( '-','+' )
      THEN VAR3
        || '0'
      ELSE VAR3
    END
  INTO VAR
  FROM DUAL;
  EXECUTE IMMEDIATE 'select ' || NVL(TO_CHAR(VAR),0) || ' from dual' INTO VAR2;
  RETURN abs(TO_number(VAR2));
  else
  RETURN 0;
  end if;
END FNC_LCR_GI_CALC;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_LCR_GET_INPUT(
    INPAR_type IN VARCHAR2 )
  RETURN VARCHAR2
AS
  OUTPUT VARCHAR2(2000);
  VAR    VARCHAR2(2000);
BEGIN

  OUTPUT := 'select   
id as "id",  
NAME as "infoGroup",  
TYPE as "type",  
TITLE as "title",  
PERCENT as "percent"
FROM TBL_LCR_REP_PROFILE_DETAIL where  is_standard =1 and  type = '||INPAR_type||'' ;
  RETURN OUTPUT;
END FNC_LCR_GET_INPUT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_LCR_GET_REPORT_INFO(
    INPAR_ID IN VARCHAR2 )
  RETURN VARCHAR2
AS
  VAR2 VARCHAR2(3000);
  var_report VARCHAR2(3000);
BEGIN

select ref_report_id into var_report from tbl_repreq where id = INPAR_ID ;

  VAR2 := 'SELECT ID as "id",  
NAME as "name",  
DES as "description",  
CREATE_DATE as "createDate",  
REF_USER as "refUser",  
STATUS as "status",  
CATEGORY as "category"
FROM TBL_REPORT 
where id = ' || var_report || ' and upper(category) = ''LCR'' order by id';

RETURN VAR2;

 
END FNC_LCR_GET_REPORT_INFO;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_LCR_GET_INPUT_EDIT(
    INPAR_REPORT IN VARCHAR2,
    INPAR_TYPE   IN VARCHAR2 )
  RETURN VARCHAR2
  
AS
  OUTPUT VARCHAR2(32000);
  VAR    VARCHAR2(32000);
   pragma autonomous_transaction;
BEGIN
--===========
pkg_LCR.prc_lcr_update_gi_calc(INPAR_REPORT);
--============

  OUTPUT := 'select   
id as "id",  
NAME as "infoGroup",  
TYPE as "type",  
TITLE as "title",  
PERCENT as "percent",  
to_char(VALUE) as "manualValue",  
is_special_type as "isSpecial",
458000000000 as "tazminZemanat",
PROFILE_ID as "profileId"
FROM TBL_lcr_REP_PROFILE_DETAIL where REF_repreq = ' || INPAR_REPORT || ' AND TYPE = ' || INPAR_TYPE || ' order by type ';

  RETURN OUTPUT;
  
END FNC_LCR_GET_INPUT_EDIT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE prc_lcr_update_gi_calc(
    INPAR_ref_report IN VARCHAR2 )
AS
BEGIN
  FOR i IN
  (SELECT * FROM TBL_LCR_REP_PROFILE_DETAIL WHERE ref_report = INPAR_ref_report
  )
  LOOP
    IF(i.profile_id IS NOT NULL) THEN
      UPDATE TBL_LCR_REP_PROFILE_DETAIL
      SET value        = pkg_lcr.FNC_LCR_GI_CALC(i.profile_id)
      WHERE ref_report = INPAR_ref_report
      AND i.id         =id ;
      COMMIT;
    END IF;
  END LOOP;
END prc_lcr_update_gi_calc;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
END PKG_LCR;
--------------------------------------------------------
--  DDL for Table PKG_LCR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_LCR" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_LCR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_LCR_rep_value (
  inpar_report   IN VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_LCR_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_VALUE              IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_LCR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE prc_lcr_update_gi_calc(INPAR_ref_report IN VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_LCR_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_LCR_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 ;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_LCR_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_LCR_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_LCR;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_LCR" 
AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_LCR_DELETE_REPORT(
    INPAR_ID IN VARCHAR2 ,
    OUTPAR OUT VARCHAR2)
AS
BEGIN
  DELETE FROM TBL_REPORT WHERE ID = INPAR_ID;
  COMMIT;
  DELETE FROM TBL_LCR_REP_PROFILE_DETAIL WHERE REF_REPORT = INPAR_ID;
  COMMIT;
END PRC_LCR_DELETE_REPORT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE PRC_LCR_REP_PROFILE_DETAIL(
    INPAR_REF_REPORT       IN VARCHAR2 ,
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_PROFILE_ID       IN VARCHAR2 ,
    INPAR_VALUE            IN VARCHAR2 ,
    INPAR_IS_STANDARD      IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    INPAR_PERCENT          IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_TITLE            IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS

BEGIN





  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_lcr_REP_PROFILE_DETAIL
      (
        REF_REPORT ,
        NAME ,
        PROFILE_ID ,
        VALUE ,
        IS_STANDARD ,
        percent ,
        TYPE ,
        TITLE
      
      )
      VALUES
      (
        INPAR_REF_REPORT ,
        INPAR_NAME ,
        INPAR_PROFILE_ID ,
        INPAR_VALUE ,
        0 ,
        inpar_percent ,
        INPAR_TYPE ,
        INPAR_TITLE
     
      );
    COMMIT;
    /*   SELECT*/
    /*    ID*/
    /*   INTO*/
    /*    OUTPAR_ID*/
    /*   FROM TBL_COM_REP_PROFILE_DETAIL*/
    /*   WHERE REF_REPORT   = INPAR_REF_REPORT;*/
    OUTPAR_ID := INPAR_REF_REPORT;
  ELSE
    UPDATE TBL_LCR_REP_PROFILE_DETAIL
    SET REF_REPORT = INPAR_REF_REPORT ,
      NAME         = INPAR_NAME ,
      PROFILE_ID   = INPAR_PROFILE_ID ,
      VALUE        = INPAR_VALUE ,
      IS_STANDARD  = 0 ,
      percent      = inpar_percent ,
      TYPE         = INPAR_TYPE ,
      TITLE        = INPAR_TITLE
    WHERE ID       = INPAR_ID;
  END IF;
  COMMIT;
END PRC_LCR_REP_PROFILE_DETAIL;

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
 PROCEDURE PRC_LCR_rep_value (
  inpar_report   IN VARCHAR2
 ) as
 var_version number;
 VAR_FORMULA VARCHAR2(30000);
 VAR_SUM NUMBER ;
begin
--=============
 
  
  select max(id) into var_version from TBL_REPREQ;
  --===========
  INSERT
  INTO TBL_lcr_REP_PROFILE_DETAIL
    (
      REF_REPORT ,
      NAME ,
      PROFILE_ID ,
      VALUE ,
      IS_STANDARD ,
      
      percent ,
      TYPE ,
      TITLE,
      ref_repreq,
      IS_SPECIAL_TYPE
    )
    (SELECT
        (--SELECT MAX(id) FROM tbl_report WHERE upper(type) = 'LCR'
        inpar_report
        ),
        NAME ,
        0 ,
        0 ,
        0 ,
        
        percent ,
        TYPE ,
        TITLE,
        var_version,
        IS_SPECIAL_TYPE
      FROM tbl_lcr_rep_profile_detail
      WHERE is_standard=1 and (type <> 2 or title <>1)
    );
    --+*********************************************************************************
        --+*********************************************************************************
    --+*********************************************************************************

    FOR I IN (SELECT * FROM TBL_LCR_REP_PROFILE_DETAIL WHERE TYPE          = 2
 AND
 TITLE         = 1
 AND
  IS_STANDARD   = 1 )
LOOP

SELECT
 FORMULA  INTO VAR_FORMULA
FROM TBL_LCR_REP_PROFILE_DETAIL
WHERE TYPE          = 2
 AND
 TITLE         = 1
 AND
  IS_STANDARD   = 1
 AND
 ID = I.ID;
if( i.IS_SPECIAL_TYPE <> 'more_than_30')
then

SELECT
NVL(sum(balance),0)   INTO VAR_SUM
FROM AKIN.TBL_DEPOSIT
WHERE DUE_DATE<= TRUNC(SYSDATE) + 30
 AND
  REF_DEPOSIT_ACCOUNTING IN (
   SELECT
    AKIN.TBL_DEPOSIT_ACCOUNTING.DEP_ACC_ID
   FROM AKIN.TBL_DEPOSIT_ACCOUNTING where LEDGER_CODE_SELF in (
   select regexp_substr(VAR_FORMULA,'[^,]+', 1, level) from dual
     connect by regexp_substr(VAR_FORMULA, '[^,]+', 1, level) is not null
   )
  );
 
 
   INSERT
  INTO TBL_lcr_REP_PROFILE_DETAIL
    (
      REF_REPORT ,
      NAME ,
      PROFILE_ID ,
      VALUE ,
      IS_STANDARD ,
      percent ,
      TYPE ,
      TITLE,
      ref_repreq,
      IS_SPECIAL_TYPE
    )  
    VALUES(inpar_report,
        I.NAME ,
        0 ,
        VAR_SUM ,
        0 ,
        I.percent ,
        I.TYPE ,
        I.TITLE,
        var_version,
        i.IS_SPECIAL_TYPE);
        else 
        
        SELECT
NVL(sum(balance),0)   INTO VAR_SUM
FROM AKIN.TBL_DEPOSIT
WHERE DUE_DATE> TRUNC(SYSDATE) + 30
 AND
  REF_DEPOSIT_ACCOUNTING IN (
   SELECT
    AKIN.TBL_DEPOSIT_ACCOUNTING.DEP_ACC_ID
   FROM AKIN.TBL_DEPOSIT_ACCOUNTING where LEDGER_CODE_SELF in (
   select regexp_substr(VAR_FORMULA,'[^,]+', 1, level) from dual
     connect by regexp_substr(VAR_FORMULA, '[^,]+', 1, level) is not null
   )
  );
 
 
   INSERT
  INTO TBL_lcr_REP_PROFILE_DETAIL
    (
      REF_REPORT ,
      NAME ,
      PROFILE_ID ,
      VALUE ,
      IS_STANDARD ,
      percent ,
      TYPE ,
      TITLE,
      ref_repreq,
      IS_SPECIAL_TYPE
    )  
    VALUES(inpar_report,
        I.NAME ,
        0 ,
        VAR_SUM ,
        0 ,
        I.percent ,
        I.TYPE ,
        I.TITLE,
        var_version,
        i.IS_SPECIAL_TYPE);
        end if;
  END LOOP;
        
  COMMIT;
  --==============
END PRC_LCR_rep_value;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE PRC_LCR_REP_PROFILE_REPORT(
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_REF_USER         IN VARCHAR2 ,
    INPAR_STATUS           IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS

BEGIN


  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_REPORT
      (
        NAME ,
        DES ,
        CREATE_DATE ,
        REF_USER ,
        STATUS ,
        CATEGORY ,
        TYPE
      )
      VALUES
      (
        INPAR_NAME ,
        INPAR_DES ,
        SYSDATE ,
        INPAR_REF_USER ,
        INPAR_STATUS ,
        'lcr' ,
        INPAR_TYPE
      );
    COMMIT;
    SELECT ID
    INTO OUTPAR_ID
    FROM TBL_REPORT
    WHERE CREATE_DATE =
      ( SELECT MAX(CREATE_DATE) FROM TBL_REPORT
      )
    AND ID =
      ( SELECT MAX(ID) FROM TBL_REPORT
      );
  ELSE
    UPDATE TBL_REPORT
    SET NAME   = INPAR_NAME ,
      DES      = INPAR_DES ,
      REF_USER = INPAR_REF_USER ,
      STATUS   = INPAR_STATUS ,
      TYPE     = INPAR_TYPE
    WHERE ID   = INPAR_ID;
    COMMIT;
  END IF;
  
  update TBL_REPORT
  set H_ID = id
  where type = 'LCR' and H_ID is null;
  commit;
--  --=============
--  
--  INSERT
--INTO TBL_REPREQ
--  (
--
--    REF_REPORT_ID,
--    REQ_DATE,
--    STATUS,
--    TYPE,
--    CATEGORY
--  )
--  values
-- (
-- OUTPAR_ID
-- ,sysdate
-- ,1
-- ,'LCR'
--  ,'LCR'
--  );
--  commit;
--  
--  select max(id) into var_version from TBL_REPREQ;
--  --===========
--  INSERT
--  INTO TBL_lcr_REP_PROFILE_DETAIL
--    (
--      REF_REPORT ,
--      NAME ,
--      PROFILE_ID ,
--      VALUE ,
--      IS_STANDARD ,
--      percent ,
--      TYPE ,
--      TITLE,
--      ref_repreq
--    )
--    (SELECT
--        (SELECT MAX(id) FROM tbl_report WHERE upper(type) = 'LCR'
--        ),
--        NAME ,
--        0 ,
--        0 ,
--        0 ,
--        percent ,
--        TYPE ,
--        TITLE,
--        var_version
--      FROM tbl_lcr_rep_profile_detail
--      WHERE is_standard=1
--    );
--  COMMIT;
--  --==============
END PRC_LCR_REP_PROFILE_REPORT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_LCR_GI_CALC
  (
    INPAR_ID IN VARCHAR2
  )
  RETURN VARCHAR2
AS
  VAR CLOB;
  VAR2 CLOB;
  VAR3 CLOB;
BEGIN

if (INPAR_ID is not null) then
  SELECT '  
SELECT   
REPLACE(    
WMSYS.WM_CONCAT(V)   
,'',''   
,''''   
)   
FROM (    
SELECT     
ABS(DG.BALANCE) ||     
A.SPLIT_SING AS V    
FROM (      
WITH T AS (       
SELECT        
REPLACE(FORMULA||''+'','','','''') STR       
FROM TBL_LEDGER_REPORT_MAP       
WHERE id   = '
    || INPAR_ID
    || '   ) SELECT       
REGEXP_SUBSTR(        
STR       
,''[0-9]+''       
,1       
,LEVEL       
) SPLIT_VALUES      
,REGEXP_SUBSTR(        
STR       
,''[^0-9]+''       
,1       
,LEVEL       
) SPLIT_SING      
,LEVEL AS LEV      
FROM T      
CONNECT BY       
LEVEL <= (        
SELECT         
LENGTH(REPLACE(STR,''-'',NULL) )        
FROM T       
)     
) A    
,TBL_LEDGER_archive DG    
WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES     
AND      
SPLIT_VALUES IS NOT NULL        
AND      
trunc(DG.EFF_DATE)                                          = (select trunc(max(eff_date)) from  TBL_LEDGER_archive)) 
'
  INTO VAR
  FROM DUAL;
  EXECUTE IMMEDIATE VAR INTO VAR3;
  SELECT
    CASE
      WHEN SUBSTR( TO_CHAR(VAR3) ,-1 ) IN ( '-','+' )
      THEN VAR3
        || '0'
      ELSE VAR3
    END
  INTO VAR
  FROM DUAL;
  EXECUTE IMMEDIATE 'select ' || NVL(TO_CHAR(VAR),0) || ' from dual' INTO VAR2;
  RETURN abs(TO_number(VAR2));
  else
  RETURN 0;
  end if;
END FNC_LCR_GI_CALC;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_LCR_GET_INPUT(
    INPAR_type IN VARCHAR2 )
  RETURN VARCHAR2
AS
  OUTPUT VARCHAR2(2000);
  VAR    VARCHAR2(2000);
BEGIN

  OUTPUT := 'select   
id as "id",  
NAME as "infoGroup",  
TYPE as "type",  
TITLE as "title",  
PERCENT as "percent"
FROM TBL_LCR_REP_PROFILE_DETAIL where  is_standard =1 and  type = '||INPAR_type||'' ;
  RETURN OUTPUT;
END FNC_LCR_GET_INPUT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_LCR_GET_REPORT_INFO(
    INPAR_ID IN VARCHAR2 )
  RETURN VARCHAR2
AS
  VAR2 VARCHAR2(3000);
  var_report VARCHAR2(3000);
BEGIN

select ref_report_id into var_report from tbl_repreq where id = INPAR_ID ;

  VAR2 := 'SELECT ID as "id",  
NAME as "name",  
DES as "description",  
CREATE_DATE as "createDate",  
REF_USER as "refUser",  
STATUS as "status",  
CATEGORY as "category"
FROM TBL_REPORT 
where id = ' || var_report || ' and upper(category) = ''LCR'' order by id';

RETURN VAR2;

 
END FNC_LCR_GET_REPORT_INFO;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_LCR_GET_INPUT_EDIT(
    INPAR_REPORT IN VARCHAR2,
    INPAR_TYPE   IN VARCHAR2 )
  RETURN VARCHAR2
  
AS
  OUTPUT VARCHAR2(32000);
  VAR    VARCHAR2(32000);
   pragma autonomous_transaction;
BEGIN
--===========
pkg_LCR.prc_lcr_update_gi_calc(INPAR_REPORT);
--============

  OUTPUT := 'select   
id as "id",  
NAME as "infoGroup",  
TYPE as "type",  
TITLE as "title",  
PERCENT as "percent",  
to_char(VALUE) as "manualValue",  
is_special_type as "isSpecial",
458000000000 as "tazminZemanat",
PROFILE_ID as "profileId"
FROM TBL_lcr_REP_PROFILE_DETAIL where REF_repreq = ' || INPAR_REPORT || ' AND TYPE = ' || INPAR_TYPE || ' order by type ';

  RETURN OUTPUT;
  
END FNC_LCR_GET_INPUT_EDIT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE prc_lcr_update_gi_calc(
    INPAR_ref_report IN VARCHAR2 )
AS
BEGIN
  FOR i IN
  (SELECT * FROM TBL_LCR_REP_PROFILE_DETAIL WHERE ref_report = INPAR_ref_report
  )
  LOOP
    IF(i.profile_id IS NOT NULL) THEN
      UPDATE TBL_LCR_REP_PROFILE_DETAIL
      SET value        = pkg_lcr.FNC_LCR_GI_CALC(i.profile_id)
      WHERE ref_report = INPAR_ref_report
      AND i.id         =id ;
      COMMIT;
    END IF;
  END LOOP;
END prc_lcr_update_gi_calc;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
END PKG_LCR;
--------------------------------------------------------
--  DDL for Table PKG_NSFR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_NSFR" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_NSFR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NSFR_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_VALUE              IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NSFR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE prc_NSFR_update_gi_calc(INPAR_ref_report IN VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NSFR_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NSFR_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 ;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NSFR_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NSFR_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_NSFR;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_NSFR" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_NSFR_DELETE_REPORT(
    INPAR_ID IN VARCHAR2 ,
    OUTPAR OUT VARCHAR2 )
AS
BEGIN
  DELETE FROM TBL_REPORT WHERE ID = INPAR_ID;
  COMMIT;
  DELETE FROM TBL_NSFR_REP_PROFILE_DETAIL WHERE REF_REPORT = INPAR_ID;
  COMMIT;
END PRC_NSFR_DELETE_REPORT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

PROCEDURE PRC_NSFR_REP_PROFILE_DETAIL(
    INPAR_REF_REPORT       IN VARCHAR2 ,
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_PROFILE_ID       IN VARCHAR2 ,
    INPAR_VALUE            IN VARCHAR2 ,
    INPAR_IS_STANDARD      IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    INPAR_PERCENT          IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_TITLE            IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS
BEGIN
  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_NSFR_REP_PROFILE_DETAIL
      (
        REF_REPORT ,
        NAME ,
        PROFILE_ID ,
        VALUE ,
        IS_STANDARD ,
        percent ,
        TYPE ,
        TITLE
      )
      VALUES
      (
        INPAR_REF_REPORT ,
        INPAR_NAME ,
        INPAR_PROFILE_ID ,
        INPAR_VALUE ,
        0 ,
        inpar_percent ,
        INPAR_TYPE ,
        INPAR_TITLE
      );
    COMMIT;
    /*   SELECT*/
    /*    ID*/
    /*   INTO*/
    /*    OUTPAR_ID*/
    /*   FROM TBL_COM_REP_PROFILE_DETAIL*/
    /*   WHERE REF_REPORT   = INPAR_REF_REPORT;*/
    OUTPAR_ID := INPAR_REF_REPORT;
  ELSE
    UPDATE TBL_NSFR_REP_PROFILE_DETAIL
    SET REF_REPORT = INPAR_REF_REPORT ,
      NAME         = INPAR_NAME ,
      PROFILE_ID   = INPAR_PROFILE_ID ,
      VALUE        = INPAR_VALUE ,
      IS_STANDARD  = 0 ,
      percent      = inpar_percent ,
      TYPE         = INPAR_TYPE ,
      TITLE        = INPAR_TITLE
    WHERE ID       = INPAR_ID;
  END IF;
  COMMIT;
END PRC_NSFR_REP_PROFILE_DETAIL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE PRC_NSFR_REP_PROFILE_REPORT(
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_REF_USER         IN VARCHAR2 ,
    INPAR_STATUS           IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS
BEGIN
  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_REPORT
      (
        NAME ,
        DES ,
        CREATE_DATE ,
        REF_USER ,
        STATUS ,
        CATEGORY ,
        TYPE
      )
      VALUES
      (
        INPAR_NAME ,
        INPAR_DES ,
        SYSDATE ,
        INPAR_REF_USER ,
        INPAR_STATUS ,
        'NSFR' ,
        INPAR_TYPE
      );
    COMMIT;
    SELECT ID
    INTO OUTPAR_ID
    FROM TBL_REPORT
    WHERE CREATE_DATE =
      ( SELECT MAX(CREATE_DATE) FROM TBL_REPORT
      )
    AND ID =
      ( SELECT MAX(ID) FROM TBL_REPORT
      );
  ELSE
    UPDATE TBL_REPORT
    SET NAME   = INPAR_NAME ,
      DES      = INPAR_DES ,
      REF_USER = INPAR_REF_USER ,
      STATUS   = INPAR_STATUS ,
      TYPE     = INPAR_TYPE
    WHERE ID   = INPAR_ID;
    COMMIT;
  END IF;
  --=============
  INSERT
  INTO TBL_NSFR_REP_PROFILE_DETAIL
    (
      REF_REPORT ,
      NAME ,
      PROFILE_ID ,
      VALUE ,
      IS_STANDARD ,
      percent ,
      TYPE ,
      TITLE
    )
    (SELECT
        (SELECT MAX(id) FROM tbl_report WHERE upper(type) = 'NSFR'
        ),
        NAME ,
        0 ,
        0 ,
        0 ,
        0 ,
        TYPE ,
        TITLE
      FROM tbl_NSFR_rep_profile_detail
      WHERE is_standard=1
    );
  COMMIT;
  --==============
END PRC_NSFR_REP_PROFILE_REPORT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_NSFR_GI_CALC
  (
    INPAR_ID IN VARCHAR2
  )
  RETURN VARCHAR2
AS
  VAR CLOB;
  VAR2 CLOB;
  VAR3 CLOB;
BEGIN
if (INPAR_ID != null) then
  SELECT '  
SELECT   
REPLACE(    
WMSYS.WM_CONCAT(V)   
,'',''   
,''''   
)   
FROM (    
SELECT     
ABS(DG.BALANCE) ||     
A.SPLIT_SING AS V    
FROM (      
WITH T AS (       
SELECT        
REPLACE(FORMULA||''+'','','','''') STR       
FROM TBL_LEDGER_REPORT_MAP       
WHERE id   = '
    || INPAR_ID
    || '   ) SELECT       
REGEXP_SUBSTR(        
STR       
,''[0-9]+''       
,1       
,LEVEL       
) SPLIT_VALUES      
,REGEXP_SUBSTR(        
STR       
,''[^0-9]+''       
,1       
,LEVEL       
) SPLIT_SING      
,LEVEL AS LEV      
FROM T      
CONNECT BY       
LEVEL <= (        
SELECT         
LENGTH(REPLACE(STR,''-'',NULL) )        
FROM T       
)     
) A    
,TBL_LEDGER_archive DG    
WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES     
AND      
SPLIT_VALUES IS NOT NULL        
AND      
trunc(DG.EFF_DATE)                                          = (select trunc(max(eff_date)) from  TBL_LEDGER_archive)) 
'
  INTO VAR
  FROM DUAL;
  EXECUTE IMMEDIATE VAR INTO VAR3;
  SELECT
    CASE
      WHEN SUBSTR( TO_CHAR(VAR3) ,-1 ) IN ( '-','+' )
      THEN VAR3
        || '0'
      ELSE VAR3
    END
  INTO VAR
  FROM DUAL;
  EXECUTE IMMEDIATE 'select ' || NVL(TO_CHAR(VAR),0) || ' from dual' INTO VAR2;
  RETURN abs(TO_number(VAR2));
  else 
  return 0 ;
  end if;
END FNC_NSFR_GI_CALC;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_NSFR_GET_INPUT(
    INPAR_type IN VARCHAR2 )
  RETURN VARCHAR2
AS
  OUTPUT VARCHAR2(2000);
  VAR    VARCHAR2(2000);
BEGIN
  OUTPUT := 'select   
id as "id",  
NAME as "infoGroup",  
TYPE as "type",  
TITLE as "title",  
PERCENT as "percent"
FROM TBL_NSFR_REP_PROFILE_DETAIL where  is_standard =1 and  type = '||INPAR_type||'' ;
  RETURN OUTPUT;
END FNC_NSFR_GET_INPUT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_NSFR_GET_REPORT_INFO(
    INPAR_ID IN VARCHAR2 )
  RETURN VARCHAR2
AS
  VAR2 VARCHAR2(3000);
BEGIN
  VAR2 := 'SELECT ID as "id",  
NAME as "name",  
DES as "description",  
CREATE_DATE as "createDate",  
REF_USER as "refUser",  
STATUS as "status",  
CATEGORY as "category"
FROM TBL_REPORT 
where id = ' || INPAR_ID || ' and upper(category) = ''NSFR'' order by id';
  RETURN VAR2;
END FNC_NSFR_GET_REPORT_INFO;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_NSFR_GET_INPUT_EDIT(
    INPAR_REPORT IN VARCHAR2,
    INPAR_TYPE   IN VARCHAR2 )
  RETURN VARCHAR2
AS
  OUTPUT VARCHAR2(2000);
  VAR    VARCHAR2(2000);
   pragma autonomous_transaction;
BEGIN
pkg_NSFR.prc_NSFR_update_gi_calc(INPAR_REPORT);
  OUTPUT := 'select   
id as "id",  
NAME as "infoGroup",  
TYPE as "type",  
TITLE as "title",  
PERCENT as "percent",  
to_char(VALUE) as "manualValue",  
PROFILE_ID as "profileId"
FROM TBL_NSFR_REP_PROFILE_DETAIL where REF_REPORT = ' || INPAR_REPORT || ' AND TYPE = ' || INPAR_TYPE || ' order by type ';
  RETURN OUTPUT;
END FNC_NSFR_GET_INPUT_EDIT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE prc_NSFR_update_gi_calc(
    INPAR_ref_report IN VARCHAR2 )
AS
BEGIN
  FOR i IN
  (SELECT * FROM TBL_NSFR_REP_PROFILE_DETAIL WHERE ref_report = INPAR_ref_report
  )
  LOOP
    IF(i.profile_id IS NOT NULL) THEN
      UPDATE TBL_NSFR_REP_PROFILE_DETAIL
      SET value        = pkg_NSFR.FNC_NSFR_GI_CALC(i.profile_id)
      WHERE ref_report = INPAR_ref_report
      AND i.id         =id ;
      COMMIT;
    END IF;
  END LOOP;
END prc_NSFR_update_gi_calc;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
END PKG_NSFR;
--------------------------------------------------------
--  DDL for Table PKG_NSFR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_NSFR" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_NSFR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NSFR_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_VALUE              IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_PERCENT            IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NSFR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE prc_NSFR_update_gi_calc(INPAR_ref_report IN VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NSFR_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NSFR_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 ;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NSFR_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NSFR_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_NSFR;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_NSFR" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_NSFR_DELETE_REPORT(
    INPAR_ID IN VARCHAR2 ,
    OUTPAR OUT VARCHAR2 )
AS
BEGIN
  DELETE FROM TBL_REPORT WHERE ID = INPAR_ID;
  COMMIT;
  DELETE FROM TBL_NSFR_REP_PROFILE_DETAIL WHERE REF_REPORT = INPAR_ID;
  COMMIT;
END PRC_NSFR_DELETE_REPORT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

PROCEDURE PRC_NSFR_REP_PROFILE_DETAIL(
    INPAR_REF_REPORT       IN VARCHAR2 ,
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_PROFILE_ID       IN VARCHAR2 ,
    INPAR_VALUE            IN VARCHAR2 ,
    INPAR_IS_STANDARD      IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    INPAR_PERCENT          IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_TITLE            IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS
BEGIN
  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_NSFR_REP_PROFILE_DETAIL
      (
        REF_REPORT ,
        NAME ,
        PROFILE_ID ,
        VALUE ,
        IS_STANDARD ,
        percent ,
        TYPE ,
        TITLE
      )
      VALUES
      (
        INPAR_REF_REPORT ,
        INPAR_NAME ,
        INPAR_PROFILE_ID ,
        INPAR_VALUE ,
        0 ,
        inpar_percent ,
        INPAR_TYPE ,
        INPAR_TITLE
      );
    COMMIT;
    /*   SELECT*/
    /*    ID*/
    /*   INTO*/
    /*    OUTPAR_ID*/
    /*   FROM TBL_COM_REP_PROFILE_DETAIL*/
    /*   WHERE REF_REPORT   = INPAR_REF_REPORT;*/
    OUTPAR_ID := INPAR_REF_REPORT;
  ELSE
    UPDATE TBL_NSFR_REP_PROFILE_DETAIL
    SET REF_REPORT = INPAR_REF_REPORT ,
      NAME         = INPAR_NAME ,
      PROFILE_ID   = INPAR_PROFILE_ID ,
      VALUE        = INPAR_VALUE ,
      IS_STANDARD  = 0 ,
      percent      = inpar_percent ,
      TYPE         = INPAR_TYPE ,
      TITLE        = INPAR_TITLE
    WHERE ID       = INPAR_ID;
  END IF;
  COMMIT;
END PRC_NSFR_REP_PROFILE_DETAIL;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE PRC_NSFR_REP_PROFILE_REPORT(
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_REF_USER         IN VARCHAR2 ,
    INPAR_STATUS           IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS
BEGIN
  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_REPORT
      (
        NAME ,
        DES ,
        CREATE_DATE ,
        REF_USER ,
        STATUS ,
        CATEGORY ,
        TYPE
      )
      VALUES
      (
        INPAR_NAME ,
        INPAR_DES ,
        SYSDATE ,
        INPAR_REF_USER ,
        INPAR_STATUS ,
        'NSFR' ,
        INPAR_TYPE
      );
    COMMIT;
    SELECT ID
    INTO OUTPAR_ID
    FROM TBL_REPORT
    WHERE CREATE_DATE =
      ( SELECT MAX(CREATE_DATE) FROM TBL_REPORT
      )
    AND ID =
      ( SELECT MAX(ID) FROM TBL_REPORT
      );
  ELSE
    UPDATE TBL_REPORT
    SET NAME   = INPAR_NAME ,
      DES      = INPAR_DES ,
      REF_USER = INPAR_REF_USER ,
      STATUS   = INPAR_STATUS ,
      TYPE     = INPAR_TYPE
    WHERE ID   = INPAR_ID;
    COMMIT;
  END IF;
  --=============
  INSERT
  INTO TBL_NSFR_REP_PROFILE_DETAIL
    (
      REF_REPORT ,
      NAME ,
      PROFILE_ID ,
      VALUE ,
      IS_STANDARD ,
      percent ,
      TYPE ,
      TITLE
    )
    (SELECT
        (SELECT MAX(id) FROM tbl_report WHERE upper(type) = 'NSFR'
        ),
        NAME ,
        0 ,
        0 ,
        0 ,
        0 ,
        TYPE ,
        TITLE
      FROM tbl_NSFR_rep_profile_detail
      WHERE is_standard=1
    );
  COMMIT;
  --==============
END PRC_NSFR_REP_PROFILE_REPORT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_NSFR_GI_CALC
  (
    INPAR_ID IN VARCHAR2
  )
  RETURN VARCHAR2
AS
  VAR CLOB;
  VAR2 CLOB;
  VAR3 CLOB;
BEGIN
if (INPAR_ID != null) then
  SELECT '  
SELECT   
REPLACE(    
WMSYS.WM_CONCAT(V)   
,'',''   
,''''   
)   
FROM (    
SELECT     
ABS(DG.BALANCE) ||     
A.SPLIT_SING AS V    
FROM (      
WITH T AS (       
SELECT        
REPLACE(FORMULA||''+'','','','''') STR       
FROM TBL_LEDGER_REPORT_MAP       
WHERE id   = '
    || INPAR_ID
    || '   ) SELECT       
REGEXP_SUBSTR(        
STR       
,''[0-9]+''       
,1       
,LEVEL       
) SPLIT_VALUES      
,REGEXP_SUBSTR(        
STR       
,''[^0-9]+''       
,1       
,LEVEL       
) SPLIT_SING      
,LEVEL AS LEV      
FROM T      
CONNECT BY       
LEVEL <= (        
SELECT         
LENGTH(REPLACE(STR,''-'',NULL) )        
FROM T       
)     
) A    
,TBL_LEDGER_archive DG    
WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES     
AND      
SPLIT_VALUES IS NOT NULL        
AND      
trunc(DG.EFF_DATE)                                          = (select trunc(max(eff_date)) from  TBL_LEDGER_archive)) 
'
  INTO VAR
  FROM DUAL;
  EXECUTE IMMEDIATE VAR INTO VAR3;
  SELECT
    CASE
      WHEN SUBSTR( TO_CHAR(VAR3) ,-1 ) IN ( '-','+' )
      THEN VAR3
        || '0'
      ELSE VAR3
    END
  INTO VAR
  FROM DUAL;
  EXECUTE IMMEDIATE 'select ' || NVL(TO_CHAR(VAR),0) || ' from dual' INTO VAR2;
  RETURN abs(TO_number(VAR2));
  else 
  return 0 ;
  end if;
END FNC_NSFR_GI_CALC;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_NSFR_GET_INPUT(
    INPAR_type IN VARCHAR2 )
  RETURN VARCHAR2
AS
  OUTPUT VARCHAR2(2000);
  VAR    VARCHAR2(2000);
BEGIN
  OUTPUT := 'select   
id as "id",  
NAME as "infoGroup",  
TYPE as "type",  
TITLE as "title",  
PERCENT as "percent"
FROM TBL_NSFR_REP_PROFILE_DETAIL where  is_standard =1 and  type = '||INPAR_type||'' ;
  RETURN OUTPUT;
END FNC_NSFR_GET_INPUT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_NSFR_GET_REPORT_INFO(
    INPAR_ID IN VARCHAR2 )
  RETURN VARCHAR2
AS
  VAR2 VARCHAR2(3000);
BEGIN
  VAR2 := 'SELECT ID as "id",  
NAME as "name",  
DES as "description",  
CREATE_DATE as "createDate",  
REF_USER as "refUser",  
STATUS as "status",  
CATEGORY as "category"
FROM TBL_REPORT 
where id = ' || INPAR_ID || ' and upper(category) = ''NSFR'' order by id';
  RETURN VAR2;
END FNC_NSFR_GET_REPORT_INFO;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
FUNCTION FNC_NSFR_GET_INPUT_EDIT(
    INPAR_REPORT IN VARCHAR2,
    INPAR_TYPE   IN VARCHAR2 )
  RETURN VARCHAR2
AS
  OUTPUT VARCHAR2(2000);
  VAR    VARCHAR2(2000);
   pragma autonomous_transaction;
BEGIN
pkg_NSFR.prc_NSFR_update_gi_calc(INPAR_REPORT);
  OUTPUT := 'select   
id as "id",  
NAME as "infoGroup",  
TYPE as "type",  
TITLE as "title",  
PERCENT as "percent",  
to_char(VALUE) as "manualValue",  
PROFILE_ID as "profileId"
FROM TBL_NSFR_REP_PROFILE_DETAIL where REF_REPORT = ' || INPAR_REPORT || ' AND TYPE = ' || INPAR_TYPE || ' order by type ';
  RETURN OUTPUT;
END FNC_NSFR_GET_INPUT_EDIT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE prc_NSFR_update_gi_calc(
    INPAR_ref_report IN VARCHAR2 )
AS
BEGIN
  FOR i IN
  (SELECT * FROM TBL_NSFR_REP_PROFILE_DETAIL WHERE ref_report = INPAR_ref_report
  )
  LOOP
    IF(i.profile_id IS NOT NULL) THEN
      UPDATE TBL_NSFR_REP_PROFILE_DETAIL
      SET value        = pkg_NSFR.FNC_NSFR_GI_CALC(i.profile_id)
      WHERE ref_report = INPAR_ref_report
      AND i.id         =id ;
      COMMIT;
    END IF;
  END LOOP;
END prc_NSFR_update_gi_calc;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
END PKG_NSFR;
--------------------------------------------------------
--  DDL for Table PKG_IDPS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_IDPS" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_IDPS_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_REF_BRANCH_ID      IN VARCHAR2
 ,INPAR_FIRST              IN VARCHAR2
 ,INPAR_END                IN VARCHAR2
 ,LENGTH                   IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_IDPS_DELETE_REPORT (
  INPAR_rep_req   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
  
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_IDPS_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_IDPS_FINAL_RESULT (
  INPAR_REPreq   IN VARCHAR2
 ,INPAR_TYPE     IN VARCHAR2
 ) RETURN CLOB;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION fnc_idps_get_detail_name(
  INPAR_rep_req IN VARCHAR2 
) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE prc_idps_rep_value (
  INPAR_ID   IN VARCHAR2
 );
  
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_IDPS;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_IDPS" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_IDPS_DELETE_REPORT (
  INPAR_rep_req   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 -- var_report number;
 BEGIN
 
  -- select ref_report_id into var_report from TBL_REPREQ where ID = INPAR_REP_REQ; 
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_rep_req;

  COMMIT;
  DELETE FROM TBL_IDPS_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_rep_req;

  COMMIT;
 END PRC_IDPS_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_IDPS_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_REF_BRANCH_ID      IN VARCHAR2
 ,INPAR_FIRST              IN VARCHAR2
 ,INPAR_END                IN VARCHAR2
 ,LENGTH                   IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 ) AS
  VAR_FIRST    DATE;
  VAR_REPORT   NUMBER;
  VAR_END      DATE;
  VAR_ALAN     DATE;
  VAR_I        NUMBER;
 BEGIN
  VAR_FIRST   := TO_DATE(INPAR_FIRST,'yyyy/mm/dd','nls_calendar=persian');
  VAR_END     := TO_DATE(INPAR_END,'yyyy/mm/dd','nls_calendar=persian');
  VAR_I       := 1;
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,TYPE
   ,FIRST_DATE
   ,LAST_DATE
   ,REF_BRN_PROFILE
   ,BAZEH
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'IDPS'
   ,INPAR_TYPE
   ,VAR_FIRST
   ,VAR_END
   ,INPAR_REF_BRANCH_ID
   ,LENGTH
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );
     
  /*=============*/

   VAR_ALAN   := VAR_FIRST;
   WHILE ( VAR_ALAN < VAR_END ) LOOP
    INSERT INTO TBL_IDPS_REP_PROFILE_DETAIL (
     NAME
    ,DES
    ,PERIOD_NAME
    ,REF_BRANCH_ID
    ,REF_REPORT
    ,FIRST
    ,END
    ) VALUES (
     INPAR_NAME
    ,INPAR_DES
    ,VAR_I
    ,INPAR_REF_BRANCH_ID
    ,OUTPAR_ID
    ,VAR_ALAN
    ,CASE
      WHEN VAR_ALAN + LENGTH > VAR_END THEN VAR_END
      ELSE VAR_ALAN + LENGTH
     END
    );

    VAR_ALAN   := VAR_ALAN + LENGTH;
    VAR_I      := VAR_I + 1;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(VAR_FIRST);
   END LOOP;

  /*outpar_id := var_report;*/
  
  /*==============*/

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
    ,FIRST_DATE = VAR_FIRST
    ,LAST_DATE = VAR_END
    ,REF_BRN_PROFILE = INPAR_REF_BRANCH_ID
    ,BAZEH = LENGTH
   WHERE ID   = INPAR_ID;

   COMMIT;
   
   /*================*/
   DELETE FROM TBL_IDPS_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

   COMMIT;
/*  VAR_FIRST      :=TO_DATE(inpar_first);*/
/*  VAR_END        :=TO_DATE(inpar_end);*/
   VAR_I      := 1;
   VAR_ALAN   := VAR_FIRST;
   WHILE ( VAR_ALAN < VAR_END ) LOOP
    INSERT INTO TBL_IDPS_REP_PROFILE_DETAIL (
     NAME
    ,DES
    ,PERIOD_NAME
    ,REF_BRANCH_ID
    ,REF_REPORT
    ,FIRST
    ,END
    ) VALUES (
     INPAR_NAME
    ,INPAR_DES
    ,VAR_I
    ,INPAR_REF_BRANCH_ID
    ,INPAR_ID
    ,VAR_ALAN
    ,CASE
      WHEN VAR_ALAN + LENGTH > VAR_END THEN VAR_END
      ELSE VAR_ALAN + LENGTH
     END
    );

    VAR_ALAN   := VAR_ALAN + LENGTH;
    VAR_I      := VAR_I + 1;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(VAR_FIRST);
   END LOOP;

   /*================*/

  END IF;
  
  update tbl_report set  H_ID = id where CATEGORY ='IDPS' AND H_ID IS NULL;
  commit;

 END PRC_IDPS_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_IDPS_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
   ,to_char(to_date(first_date),''yyyy/mm/dd'',''nls_calendar=persian'') as "startDate"
  ,to_char(to_date(last_date),''yyyy/mm/dd'',''nls_calendar=persian'') as "endDate"
  ,bazeh as "duration",ref_brn_profile as "branchProfile"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''IDPS'' order by id';
  RETURN VAR2;
 END FNC_IDPS_GET_REPORT_INFO;
 
  
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_IDPS_FINAL_RESULT (
  INPAR_REPreq   IN VARCHAR2
 ,INPAR_TYPE     IN VARCHAR2
 ) RETURN CLOB AS
  VAR_BRANCH    NUMBER;
  VAR           CLOB;
  VAR_TIMING    CLOB;
  VAR_TIMING2   CLOB;
  var_report number;
 BEGIN
 
 select REF_REPORT_ID into var_report from TBL_REPREQ where ID = INPAR_REPreq;
 
  SELECT
   REF_BRN_PROFILE
  INTO
   VAR_BRANCH
  FROM TBL_REPORT
  WHERE ID   = var_report;

  SELECT
   WMSYS.WM_CONCAT(PERIOD_NAME ||
   ' as "x' ||
   PERIOD_NAME ||
   '"')
  INTO
   VAR_TIMING
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = var_report;

  SELECT
   WMSYS.WM_CONCAT('"x' ||
   PERIOD_NAME ||
   '"')
  INTO
   VAR_TIMING2
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = var_report;

 var:= ' select /*+ PARALLEL(AUTO) */  "parent","level","id","name",' ||
   VAR_TIMING2 ||
   ' from(
SELECT /*+ PARALLEL(AUTO) */ 
 
ID as "id"
 ,NAME as "name"
 ,PARENT as "parent"
 ,DEPTH as "level"
 ,VALUE as "value"
 ,PERIOD as "period"
 ,TYPE
FROM TBL_IDPS_REP_VALUE
where REF_REPREQ = '||INPAR_REPreq||' and type = '||INPAR_type||' 
)
 PIVOT (max("value") for "period" in (' ||
   VAR_TIMING ||
   '))  order by "id","level"';

  RETURN VAR;
 END FNC_IDPS_FINAL_RESULT;

 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_IDPS_GET_DETAIL_NAME ( INPAR_rep_req IN VARCHAR2 ) RETURN VARCHAR2
  AS
  var_report NUMBER;
 BEGIN
 select ref_report_id into var_report from TBL_REPREQ where id = INPAR_rep_req;
  RETURN 'select ''x''||PERIOD_NAME as "value",to_char(to_date(END,''dd-mm-yy''),''yyyy-mm-dd'',''nls_calendar=persian'') "header"  from TBL_IDPS_REP_PROFILE_DETAIL where ref_report='|| var_report || ' order by to_number(PERIOD_NAME)
';
 END FNC_IDPS_GET_DETAIL_NAME;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_IDPS_REP_VALUE ( INPAR_ID IN VARCHAR2 ) AS
  VAR_BRANCH       NUMBER;
  VAR_REP_REQ_ID   NUMBER;
  VAR              VARCHAR2(32000);
 BEGIN
  SELECT
   REF_BRN_PROFILE
  INTO
   VAR_BRANCH
  FROM TBL_REPORT
  WHERE ID   = INPAR_ID;

  SELECT
   MAX(ID)
  INTO
   VAR_REP_REQ_ID
  FROM TBL_REPREQ;
  EXECUTE IMMEDIATE   ' BEGIN INSERT /*+ PARALLEL(AUTO) */  INTO TBL_IDPS_REP_VALUE (
 REF_REPREQ
 ,ID
 ,NAME
 ,PARENT
 ,DEPTH
 ,VALUE
 ,PERIOD
 ,TYPE
) 

SELECT /*+ PARALLEL(AUTO) */ 
' ||
  VAR_REP_REQ_ID ||
  ',
 LEDGER_CODE AS "id",
  max(name) as "name",
 max(parent_code) as "parent",
 max(depth) as "level",
 SUM(abs(BALANCE)) as "value",
 MAX(A.PERIOD_NAME) as "period",
 1
FROM TBL_LEDGER_BRANCH,(
  SELECT /*+ PARALLEL(AUTO) */ 
   TBL_IDPS_REP_PROFILE_DETAIL.END,
   PERIOD_NAME
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = ' ||
  INPAR_ID ||
  '
 )A
WHERE EFF_DATE =A.END  AND REF_BRANCH IN (  ' ||
  FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',VAR_BRANCH) ||
  ' ) GROUP BY LEDGER_CODE,A.END; end;';

DBMS_OUTPUT.PUT_LINE(var);
  EXECUTE IMMEDIATE ' BEGIN INSERT /*+ PARALLEL(AUTO) */  INTO TBL_IDPS_REP_VALUE (
 REF_REPREQ
 ,ID
 ,NAME
 ,PARENT
 ,DEPTH
 ,VALUE
 ,PERIOD
 ,TYPE
) 

SELECT /*+ PARALLEL(AUTO) */ 
' ||
  VAR_REP_REQ_ID ||
  ',
 LEDGER_CODE AS "id",
  max(name) as "name",
 max(parent_code) as "parent",
 max(depth) as "level",
 round(AVG(abs(BALANCE)),2) as "value",
 MAX(A.PERIOD_NAME) as "period",
 2
FROM TBL_LEDGER_BRANCH,(
  SELECT /*+ PARALLEL(AUTO) */ 
   TBL_IDPS_REP_PROFILE_DETAIL.END,
   PERIOD_NAME
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = ' ||
  INPAR_ID ||
  '
 )A
WHERE EFF_DATE =A.END  AND REF_BRANCH IN (  ' ||
  FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',VAR_BRANCH) ||
  ' ) GROUP BY LEDGER_CODE,A.END; end;';

  EXECUTE IMMEDIATE ' BEGIN INSERT /*+ PARALLEL(AUTO) */  INTO TBL_IDPS_REP_VALUE (
 REF_REPREQ
 ,ID
 ,NAME
 ,PARENT
 ,DEPTH
 ,VALUE
 ,PERIOD
 ,TYPE
) 

SELECT /*+ PARALLEL(AUTO) */ 
' ||
  VAR_REP_REQ_ID ||
  ',
 LEDGER_CODE AS "id",
  max(name) as "name",
 max(parent_code) as "parent",
 max(depth) as "level",
MAX(abs(BALANCE)) as "value",
 MAX(A.PERIOD_NAME) as "period",
 3
FROM TBL_LEDGER_BRANCH,(
  SELECT /*+ PARALLEL(AUTO) */ 
   TBL_IDPS_REP_PROFILE_DETAIL.END,
   PERIOD_NAME
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = ' ||
  INPAR_ID ||
  '
 )A
WHERE EFF_DATE =A.END  AND REF_BRANCH IN (  ' ||
  FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',VAR_BRANCH) ||
  ' ) GROUP BY LEDGER_CODE,A.END; end;';

  EXECUTE IMMEDIATE ' BEGIN INSERT /*+ PARALLEL(AUTO) */  INTO TBL_IDPS_REP_VALUE (
 REF_REPREQ
 ,ID
 ,NAME
 ,PARENT
 ,DEPTH
 ,VALUE
 ,PERIOD
 ,TYPE
) 

SELECT /*+ PARALLEL(AUTO) */ 
' ||
  VAR_REP_REQ_ID ||
  ',
 LEDGER_CODE AS "id",
  max(name) as "name",
 max(parent_code) as "parent",
 max(depth) as "level",
 MIN(ABS(BALANCE)) as "value",
 MAX(A.PERIOD_NAME) as "period",
 4
FROM TBL_LEDGER_BRANCH,(
  SELECT /*+ PARALLEL(AUTO) */ 
   TBL_IDPS_REP_PROFILE_DETAIL.END,
   PERIOD_NAME
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = ' ||
  INPAR_ID ||
  '
 )A
WHERE EFF_DATE =A.END  AND REF_BRANCH IN (  ' ||
  FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',VAR_BRANCH) ||
  ' ) GROUP BY LEDGER_CODE,A.END; end;';

  EXECUTE IMMEDIATE ' BEGIN INSERT /*+ PARALLEL(AUTO) */  INTO TBL_IDPS_REP_VALUE (
 REF_REPREQ
 ,ID
 ,NAME
 ,PARENT
 ,DEPTH
 ,VALUE
 ,PERIOD
 ,TYPE
) 

SELECT /*+ PARALLEL(AUTO) */ 
' ||
  VAR_REP_REQ_ID ||
  ',
 LEDGER_CODE AS "id",
  max(name) as "name",
 max(parent_code) as "parent",
 max(depth) as "level",
SUM(abs(DEBT_FLOW)) as "value",
MAX(A.PERIOD_NAME) as "period",
5
FROM TBL_LEDGER_BRANCH,(
  SELECT /*+ PARALLEL(AUTO) */ 
   TBL_IDPS_REP_PROFILE_DETAIL.END,
   PERIOD_NAME
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = ' ||
  INPAR_ID ||
  '
 )A
WHERE EFF_DATE =A.END  AND REF_BRANCH IN (  ' ||
  FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',VAR_BRANCH) ||
  ' ) GROUP BY LEDGER_CODE,A.END; end;';

  EXECUTE IMMEDIATE ' BEGIN INSERT /*+ PARALLEL(AUTO) */  INTO TBL_IDPS_REP_VALUE (
 REF_REPREQ
 ,ID
 ,NAME
 ,PARENT
 ,DEPTH
 ,VALUE
 ,PERIOD
 ,TYPE
) 

SELECT /*+ PARALLEL(AUTO) */ 
' ||
  VAR_REP_REQ_ID ||
  ',
 LEDGER_CODE AS "id",
  max(name) as "name",
 max(parent_code) as "parent",
 max(depth) as "level",
  SUM(abs(CRE_FLOW)) as "value",
MAX(A.PERIOD_NAME) as "period",
6
FROM TBL_LEDGER_BRANCH,(
  SELECT /*+ PARALLEL(AUTO) */ 
   TBL_IDPS_REP_PROFILE_DETAIL.END,
   PERIOD_NAME
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = ' ||
  INPAR_ID ||
  '
 )A
WHERE EFF_DATE =A.END  AND REF_BRANCH IN (  ' ||
  FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',VAR_BRANCH) ||
  ' ) GROUP BY LEDGER_CODE,A.END; end;';

  COMMIT;
 END PRC_IDPS_REP_VALUE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_IDPS;
--------------------------------------------------------
--  DDL for Table PKG_IDPS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_IDPS" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_IDPS_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_REF_BRANCH_ID      IN VARCHAR2
 ,INPAR_FIRST              IN VARCHAR2
 ,INPAR_END                IN VARCHAR2
 ,LENGTH                   IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_IDPS_DELETE_REPORT (
  INPAR_rep_req   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
  
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_IDPS_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_IDPS_FINAL_RESULT (
  INPAR_REPreq   IN VARCHAR2
 ,INPAR_TYPE     IN VARCHAR2
 ) RETURN CLOB;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION fnc_idps_get_detail_name(
  INPAR_rep_req IN VARCHAR2 
) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE prc_idps_rep_value (
  INPAR_ID   IN VARCHAR2
 );
  
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_IDPS;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_IDPS" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_IDPS_DELETE_REPORT (
  INPAR_rep_req   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 -- var_report number;
 BEGIN
 
  -- select ref_report_id into var_report from TBL_REPREQ where ID = INPAR_REP_REQ; 
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_rep_req;

  COMMIT;
  DELETE FROM TBL_IDPS_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_rep_req;

  COMMIT;
 END PRC_IDPS_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_IDPS_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_REF_BRANCH_ID      IN VARCHAR2
 ,INPAR_FIRST              IN VARCHAR2
 ,INPAR_END                IN VARCHAR2
 ,LENGTH                   IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 ) AS
  VAR_FIRST    DATE;
  VAR_REPORT   NUMBER;
  VAR_END      DATE;
  VAR_ALAN     DATE;
  VAR_I        NUMBER;
 BEGIN
  VAR_FIRST   := TO_DATE(INPAR_FIRST,'yyyy/mm/dd','nls_calendar=persian');
  VAR_END     := TO_DATE(INPAR_END,'yyyy/mm/dd','nls_calendar=persian');
  VAR_I       := 1;
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,TYPE
   ,FIRST_DATE
   ,LAST_DATE
   ,REF_BRN_PROFILE
   ,BAZEH
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'IDPS'
   ,INPAR_TYPE
   ,VAR_FIRST
   ,VAR_END
   ,INPAR_REF_BRANCH_ID
   ,LENGTH
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );
     
  /*=============*/

   VAR_ALAN   := VAR_FIRST;
   WHILE ( VAR_ALAN < VAR_END ) LOOP
    INSERT INTO TBL_IDPS_REP_PROFILE_DETAIL (
     NAME
    ,DES
    ,PERIOD_NAME
    ,REF_BRANCH_ID
    ,REF_REPORT
    ,FIRST
    ,END
    ) VALUES (
     INPAR_NAME
    ,INPAR_DES
    ,VAR_I
    ,INPAR_REF_BRANCH_ID
    ,OUTPAR_ID
    ,VAR_ALAN
    ,CASE
      WHEN VAR_ALAN + LENGTH > VAR_END THEN VAR_END
      ELSE VAR_ALAN + LENGTH
     END
    );

    VAR_ALAN   := VAR_ALAN + LENGTH;
    VAR_I      := VAR_I + 1;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(VAR_FIRST);
   END LOOP;

  /*outpar_id := var_report;*/
  
  /*==============*/

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
    ,FIRST_DATE = VAR_FIRST
    ,LAST_DATE = VAR_END
    ,REF_BRN_PROFILE = INPAR_REF_BRANCH_ID
    ,BAZEH = LENGTH
   WHERE ID   = INPAR_ID;

   COMMIT;
   
   /*================*/
   DELETE FROM TBL_IDPS_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

   COMMIT;
/*  VAR_FIRST      :=TO_DATE(inpar_first);*/
/*  VAR_END        :=TO_DATE(inpar_end);*/
   VAR_I      := 1;
   VAR_ALAN   := VAR_FIRST;
   WHILE ( VAR_ALAN < VAR_END ) LOOP
    INSERT INTO TBL_IDPS_REP_PROFILE_DETAIL (
     NAME
    ,DES
    ,PERIOD_NAME
    ,REF_BRANCH_ID
    ,REF_REPORT
    ,FIRST
    ,END
    ) VALUES (
     INPAR_NAME
    ,INPAR_DES
    ,VAR_I
    ,INPAR_REF_BRANCH_ID
    ,INPAR_ID
    ,VAR_ALAN
    ,CASE
      WHEN VAR_ALAN + LENGTH > VAR_END THEN VAR_END
      ELSE VAR_ALAN + LENGTH
     END
    );

    VAR_ALAN   := VAR_ALAN + LENGTH;
    VAR_I      := VAR_I + 1;
    COMMIT;
    DBMS_OUTPUT.PUT_LINE(VAR_FIRST);
   END LOOP;

   /*================*/

  END IF;
  
  update tbl_report set  H_ID = id where CATEGORY ='IDPS' AND H_ID IS NULL;
  commit;

 END PRC_IDPS_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_IDPS_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
   ,to_char(to_date(first_date),''yyyy/mm/dd'',''nls_calendar=persian'') as "startDate"
  ,to_char(to_date(last_date),''yyyy/mm/dd'',''nls_calendar=persian'') as "endDate"
  ,bazeh as "duration",ref_brn_profile as "branchProfile"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''IDPS'' order by id';
  RETURN VAR2;
 END FNC_IDPS_GET_REPORT_INFO;
 
  
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_IDPS_FINAL_RESULT (
  INPAR_REPreq   IN VARCHAR2
 ,INPAR_TYPE     IN VARCHAR2
 ) RETURN CLOB AS
  VAR_BRANCH    NUMBER;
  VAR           CLOB;
  VAR_TIMING    CLOB;
  VAR_TIMING2   CLOB;
  var_report number;
 BEGIN
 
 select REF_REPORT_ID into var_report from TBL_REPREQ where ID = INPAR_REPreq;
 
  SELECT
   REF_BRN_PROFILE
  INTO
   VAR_BRANCH
  FROM TBL_REPORT
  WHERE ID   = var_report;

  SELECT
   WMSYS.WM_CONCAT(PERIOD_NAME ||
   ' as "x' ||
   PERIOD_NAME ||
   '"')
  INTO
   VAR_TIMING
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = var_report;

  SELECT
   WMSYS.WM_CONCAT('"x' ||
   PERIOD_NAME ||
   '"')
  INTO
   VAR_TIMING2
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = var_report;

 var:= ' select /*+ PARALLEL(AUTO) */  "parent","level","id","name",' ||
   VAR_TIMING2 ||
   ' from(
SELECT /*+ PARALLEL(AUTO) */ 
 
ID as "id"
 ,NAME as "name"
 ,PARENT as "parent"
 ,DEPTH as "level"
 ,VALUE as "value"
 ,PERIOD as "period"
 ,TYPE
FROM TBL_IDPS_REP_VALUE
where REF_REPREQ = '||INPAR_REPreq||' and type = '||INPAR_type||' 
)
 PIVOT (max("value") for "period" in (' ||
   VAR_TIMING ||
   '))  order by "id","level"';

  RETURN VAR;
 END FNC_IDPS_FINAL_RESULT;

 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_IDPS_GET_DETAIL_NAME ( INPAR_rep_req IN VARCHAR2 ) RETURN VARCHAR2
  AS
  var_report NUMBER;
 BEGIN
 select ref_report_id into var_report from TBL_REPREQ where id = INPAR_rep_req;
  RETURN 'select ''x''||PERIOD_NAME as "value",to_char(to_date(END,''dd-mm-yy''),''yyyy-mm-dd'',''nls_calendar=persian'') "header"  from TBL_IDPS_REP_PROFILE_DETAIL where ref_report='|| var_report || ' order by to_number(PERIOD_NAME)
';
 END FNC_IDPS_GET_DETAIL_NAME;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_IDPS_REP_VALUE ( INPAR_ID IN VARCHAR2 ) AS
  VAR_BRANCH       NUMBER;
  VAR_REP_REQ_ID   NUMBER;
  VAR              VARCHAR2(32000);
 BEGIN
  SELECT
   REF_BRN_PROFILE
  INTO
   VAR_BRANCH
  FROM TBL_REPORT
  WHERE ID   = INPAR_ID;

  SELECT
   MAX(ID)
  INTO
   VAR_REP_REQ_ID
  FROM TBL_REPREQ;
  EXECUTE IMMEDIATE   ' BEGIN INSERT /*+ PARALLEL(AUTO) */  INTO TBL_IDPS_REP_VALUE (
 REF_REPREQ
 ,ID
 ,NAME
 ,PARENT
 ,DEPTH
 ,VALUE
 ,PERIOD
 ,TYPE
) 

SELECT /*+ PARALLEL(AUTO) */ 
' ||
  VAR_REP_REQ_ID ||
  ',
 LEDGER_CODE AS "id",
  max(name) as "name",
 max(parent_code) as "parent",
 max(depth) as "level",
 SUM(abs(BALANCE)) as "value",
 MAX(A.PERIOD_NAME) as "period",
 1
FROM TBL_LEDGER_BRANCH,(
  SELECT /*+ PARALLEL(AUTO) */ 
   TBL_IDPS_REP_PROFILE_DETAIL.END,
   PERIOD_NAME
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = ' ||
  INPAR_ID ||
  '
 )A
WHERE EFF_DATE =A.END  AND REF_BRANCH IN (  ' ||
  FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',VAR_BRANCH) ||
  ' ) GROUP BY LEDGER_CODE,A.END; end;';

DBMS_OUTPUT.PUT_LINE(var);
  EXECUTE IMMEDIATE ' BEGIN INSERT /*+ PARALLEL(AUTO) */  INTO TBL_IDPS_REP_VALUE (
 REF_REPREQ
 ,ID
 ,NAME
 ,PARENT
 ,DEPTH
 ,VALUE
 ,PERIOD
 ,TYPE
) 

SELECT /*+ PARALLEL(AUTO) */ 
' ||
  VAR_REP_REQ_ID ||
  ',
 LEDGER_CODE AS "id",
  max(name) as "name",
 max(parent_code) as "parent",
 max(depth) as "level",
 round(AVG(abs(BALANCE)),2) as "value",
 MAX(A.PERIOD_NAME) as "period",
 2
FROM TBL_LEDGER_BRANCH,(
  SELECT /*+ PARALLEL(AUTO) */ 
   TBL_IDPS_REP_PROFILE_DETAIL.END,
   PERIOD_NAME
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = ' ||
  INPAR_ID ||
  '
 )A
WHERE EFF_DATE =A.END  AND REF_BRANCH IN (  ' ||
  FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',VAR_BRANCH) ||
  ' ) GROUP BY LEDGER_CODE,A.END; end;';

  EXECUTE IMMEDIATE ' BEGIN INSERT /*+ PARALLEL(AUTO) */  INTO TBL_IDPS_REP_VALUE (
 REF_REPREQ
 ,ID
 ,NAME
 ,PARENT
 ,DEPTH
 ,VALUE
 ,PERIOD
 ,TYPE
) 

SELECT /*+ PARALLEL(AUTO) */ 
' ||
  VAR_REP_REQ_ID ||
  ',
 LEDGER_CODE AS "id",
  max(name) as "name",
 max(parent_code) as "parent",
 max(depth) as "level",
MAX(abs(BALANCE)) as "value",
 MAX(A.PERIOD_NAME) as "period",
 3
FROM TBL_LEDGER_BRANCH,(
  SELECT /*+ PARALLEL(AUTO) */ 
   TBL_IDPS_REP_PROFILE_DETAIL.END,
   PERIOD_NAME
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = ' ||
  INPAR_ID ||
  '
 )A
WHERE EFF_DATE =A.END  AND REF_BRANCH IN (  ' ||
  FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',VAR_BRANCH) ||
  ' ) GROUP BY LEDGER_CODE,A.END; end;';

  EXECUTE IMMEDIATE ' BEGIN INSERT /*+ PARALLEL(AUTO) */  INTO TBL_IDPS_REP_VALUE (
 REF_REPREQ
 ,ID
 ,NAME
 ,PARENT
 ,DEPTH
 ,VALUE
 ,PERIOD
 ,TYPE
) 

SELECT /*+ PARALLEL(AUTO) */ 
' ||
  VAR_REP_REQ_ID ||
  ',
 LEDGER_CODE AS "id",
  max(name) as "name",
 max(parent_code) as "parent",
 max(depth) as "level",
 MIN(ABS(BALANCE)) as "value",
 MAX(A.PERIOD_NAME) as "period",
 4
FROM TBL_LEDGER_BRANCH,(
  SELECT /*+ PARALLEL(AUTO) */ 
   TBL_IDPS_REP_PROFILE_DETAIL.END,
   PERIOD_NAME
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = ' ||
  INPAR_ID ||
  '
 )A
WHERE EFF_DATE =A.END  AND REF_BRANCH IN (  ' ||
  FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',VAR_BRANCH) ||
  ' ) GROUP BY LEDGER_CODE,A.END; end;';

  EXECUTE IMMEDIATE ' BEGIN INSERT /*+ PARALLEL(AUTO) */  INTO TBL_IDPS_REP_VALUE (
 REF_REPREQ
 ,ID
 ,NAME
 ,PARENT
 ,DEPTH
 ,VALUE
 ,PERIOD
 ,TYPE
) 

SELECT /*+ PARALLEL(AUTO) */ 
' ||
  VAR_REP_REQ_ID ||
  ',
 LEDGER_CODE AS "id",
  max(name) as "name",
 max(parent_code) as "parent",
 max(depth) as "level",
SUM(abs(DEBT_FLOW)) as "value",
MAX(A.PERIOD_NAME) as "period",
5
FROM TBL_LEDGER_BRANCH,(
  SELECT /*+ PARALLEL(AUTO) */ 
   TBL_IDPS_REP_PROFILE_DETAIL.END,
   PERIOD_NAME
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = ' ||
  INPAR_ID ||
  '
 )A
WHERE EFF_DATE =A.END  AND REF_BRANCH IN (  ' ||
  FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',VAR_BRANCH) ||
  ' ) GROUP BY LEDGER_CODE,A.END; end;';

  EXECUTE IMMEDIATE ' BEGIN INSERT /*+ PARALLEL(AUTO) */  INTO TBL_IDPS_REP_VALUE (
 REF_REPREQ
 ,ID
 ,NAME
 ,PARENT
 ,DEPTH
 ,VALUE
 ,PERIOD
 ,TYPE
) 

SELECT /*+ PARALLEL(AUTO) */ 
' ||
  VAR_REP_REQ_ID ||
  ',
 LEDGER_CODE AS "id",
  max(name) as "name",
 max(parent_code) as "parent",
 max(depth) as "level",
  SUM(abs(CRE_FLOW)) as "value",
MAX(A.PERIOD_NAME) as "period",
6
FROM TBL_LEDGER_BRANCH,(
  SELECT /*+ PARALLEL(AUTO) */ 
   TBL_IDPS_REP_PROFILE_DETAIL.END,
   PERIOD_NAME
  FROM TBL_IDPS_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = ' ||
  INPAR_ID ||
  '
 )A
WHERE EFF_DATE =A.END  AND REF_BRANCH IN (  ' ||
  FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',VAR_BRANCH) ||
  ' ) GROUP BY LEDGER_CODE,A.END; end;';

  COMMIT;
 END PRC_IDPS_REP_VALUE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_IDPS;
--------------------------------------------------------
--  DDL for Table PKG_LEDGER_SENS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_LEDGER_SENS" 
AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  PROCEDURE prc_ledger_sens_profile_report(
      INPAR_NAME             IN VARCHAR2 ,
      INPAR_DES              IN VARCHAR2 ,
      INPAR_REF_USER         IN VARCHAR2 ,
      INPAR_STATUS           IN VARCHAR2 ,
      inpar_ledger_profile   IN VARCHAR2 ,
      INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
      INPAR_ID               IN VARCHAR2 ,
      INPAR_TYPE             IN VARCHAR2 ,
      OUTPAR_ID OUT VARCHAR2 );
  /*=============================================================*/
  FUNCTION fnc_ledger_sens_get_query_date(
      VAR VARCHAR2 )
    RETURN VARCHAR2;
  /*=============================================================*/
  FUNCTION fnc_ledger_sens_get_report(
      inpar_report IN VARCHAR2 ,
      inpar_date           IN VARCHAR2 
   --   INPAR_CURRENCY       IN VARCHAR2
   )
    RETURN VARCHAR2;
  /*=============================================================*/
END pkg_ledger_sens;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_LEDGER_SENS" as
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
procedure prc_ledger_sens_profile_report(
  inpar_name               in varchar2
 ,inpar_des                in varchar2
 ,inpar_ref_user           in varchar2
 ,inpar_status             in varchar2
 ,inpar_ledger_profile     in varchar2
 ,inpar_insert_or_update   in varchar2
 ,inpar_id                 in varchar2
 ,inpar_type               in varchar2
 ,outpar_id                out varchar2
 ) as
  begin
    IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,REF_LEDGER_PROFIEL
   ,TYPE
   ,CATEGORY
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,inpar_ledger_profile
   ,INPAR_TYPE
   ,'ledgerSens'
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );
     
     update tbl_report set h_id =OUTPAR_ID
     where id = OUTPAR_ID;
     commit;

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,REF_LEDGER_PROFIEL = inpar_ledger_profile
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
  end prc_ledger_sens_profile_report;
/*=============================================================*/
function fnc_ledger_sens_get_query_date (var varchar2 )return varchar2 as
 VAR_QUERY VARCHAR2(3000);
  begin
   VAR_QUERY := VAR;
  VAR_QUERY := 'SELECT  WMSYS.Wm_Concat(to_char( "date",''yyyy/mm/dd'',''nls_calendar=persian'')) as "date"
FROM  (SELECT distinct 
EFF_DATE "date"
FROM TBL_LEDGER_ARCHIVE)';
  RETURN VAR_QUERY;
  end fnc_ledger_sens_get_query_date;
/*=============================================================*/
function fnc_ledger_sens_get_report(
    inpar_report in varchar2 ,
    inpar_date           in varchar2 
    --inpar_currency       in varchar2
    )
  return varchar2 as
  var_ledger_profile number;
  var_max_ledger_profile number;

  begin
  select REF_LEDGER_PROFIEL into var_ledger_profile  from TBL_REPORT where ID = inpar_report;
  select max(id) into var_max_ledger_profile from TBL_LEDGER_PROFILE where H_ID = var_ledger_profile;
 RETURN 'select  det.CODE as "id" ,max(det.REF_LEDGER_PROFILE) as "ledgerProfile",max(det.NAME) as "name",max(le.eff_date) as "date",
max(det.PARENT_CODE) as "parent", max(det.DEPTH) as "level",sum(le.BALANCE) as "balance"
from TBL_LEDGER_PROFILE_DETAIL det left JOIN TBL_LEDGER_ARCHIVE le
on det.code = le.LEDGER_CODE
where det.REF_LEDGER_PROFILE = '||var_max_ledger_profile||' and trunc(le.eff_date) = to_date('''||INPAR_DATE||''',''yyyy-mm-dd'') 
group by det.code
order by det.code';
  end fnc_ledger_sens_get_report;

end pkg_ledger_sens;
--------------------------------------------------------
--  DDL for Table PKG_LEDGER_SENS
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_LEDGER_SENS" 
AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  PROCEDURE prc_ledger_sens_profile_report(
      INPAR_NAME             IN VARCHAR2 ,
      INPAR_DES              IN VARCHAR2 ,
      INPAR_REF_USER         IN VARCHAR2 ,
      INPAR_STATUS           IN VARCHAR2 ,
      inpar_ledger_profile   IN VARCHAR2 ,
      INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
      INPAR_ID               IN VARCHAR2 ,
      INPAR_TYPE             IN VARCHAR2 ,
      OUTPAR_ID OUT VARCHAR2 );
  /*=============================================================*/
  FUNCTION fnc_ledger_sens_get_query_date(
      VAR VARCHAR2 )
    RETURN VARCHAR2;
  /*=============================================================*/
  FUNCTION fnc_ledger_sens_get_report(
      inpar_report IN VARCHAR2 ,
      inpar_date           IN VARCHAR2 
   --   INPAR_CURRENCY       IN VARCHAR2
   )
    RETURN VARCHAR2;
  /*=============================================================*/
END pkg_ledger_sens;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_LEDGER_SENS" as
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
procedure prc_ledger_sens_profile_report(
  inpar_name               in varchar2
 ,inpar_des                in varchar2
 ,inpar_ref_user           in varchar2
 ,inpar_status             in varchar2
 ,inpar_ledger_profile     in varchar2
 ,inpar_insert_or_update   in varchar2
 ,inpar_id                 in varchar2
 ,inpar_type               in varchar2
 ,outpar_id                out varchar2
 ) as
  begin
    IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,REF_LEDGER_PROFIEL
   ,TYPE
   ,CATEGORY
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,inpar_ledger_profile
   ,INPAR_TYPE
   ,'ledgerSens'
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );
     
     update tbl_report set h_id =OUTPAR_ID
     where id = OUTPAR_ID;
     commit;

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,REF_LEDGER_PROFIEL = inpar_ledger_profile
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
  end prc_ledger_sens_profile_report;
/*=============================================================*/
function fnc_ledger_sens_get_query_date (var varchar2 )return varchar2 as
 VAR_QUERY VARCHAR2(3000);
  begin
   VAR_QUERY := VAR;
  VAR_QUERY := 'SELECT  WMSYS.Wm_Concat(to_char( "date",''yyyy/mm/dd'',''nls_calendar=persian'')) as "date"
FROM  (SELECT distinct 
EFF_DATE "date"
FROM TBL_LEDGER_ARCHIVE)';
  RETURN VAR_QUERY;
  end fnc_ledger_sens_get_query_date;
/*=============================================================*/
function fnc_ledger_sens_get_report(
    inpar_report in varchar2 ,
    inpar_date           in varchar2 
    --inpar_currency       in varchar2
    )
  return varchar2 as
  var_ledger_profile number;
  var_max_ledger_profile number;

  begin
  select REF_LEDGER_PROFIEL into var_ledger_profile  from TBL_REPORT where ID = inpar_report;
  select max(id) into var_max_ledger_profile from TBL_LEDGER_PROFILE where H_ID = var_ledger_profile;
 RETURN 'select  det.CODE as "id" ,max(det.REF_LEDGER_PROFILE) as "ledgerProfile",max(det.NAME) as "name",max(le.eff_date) as "date",
max(det.PARENT_CODE) as "parent", max(det.DEPTH) as "level",sum(le.BALANCE) as "balance"
from TBL_LEDGER_PROFILE_DETAIL det left JOIN TBL_LEDGER_ARCHIVE le
on det.code = le.LEDGER_CODE
where det.REF_LEDGER_PROFILE = '||var_max_ledger_profile||' and trunc(le.eff_date) = to_date('''||INPAR_DATE||''',''yyyy-mm-dd'') 
group by det.code
order by det.code';
  end fnc_ledger_sens_get_report;

end pkg_ledger_sens;
--------------------------------------------------------
--  DDL for Table PKG_CONC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CONC" AS 
/*---------------------------------------------------------------------------------------------*/
--------------تمرکز سپرده
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_CAR_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_STATE_REPORT RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_MAIN_REPORT RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_STATE_DETAIL_REPORT ( INPAR_STATE IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_BRANCH_REPORT RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION     FNC_PAGING_QUERY 
(
  INPAR_PAGE_SIZE IN NUMBER 
, INPAR_PAGE_NUMBER IN NUMBER 

) RETURN clob ;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_PAGE_NUMBER 

(
  INAPR_PAGE_SIZE IN NUMBER 

) RETURN varchar2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_CONC;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_CONC" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_REP_PROFILE_REPORT
  AS
 BEGIN
  INSERT INTO TBL_CONC_RPORT_DETAIL (
   CUSTOMER_NUMBER
  ,REF_BRANCH
  ,BALANCE
  ,BRANCH_NAME
  ,REF_CITY
  ,CITY_NAME
  ,REF_STATE
  ,STATE_NAME
  ) SELECT
   A.REF_CUSTOMER
  ,A.REF_BRANCH
  ,A.BALANCE
  ,B.NAME
  ,B.REF_CTY_ID
  ,B.CITY_NAME
  ,B.REF_STA_ID
  ,B.STA_NAME
  FROM (
    SELECT
     REF_CUSTOMER
    ,REF_BRANCH
    ,SUM(BALANCE) AS BALANCE
    FROM AKIN.TBL_DEPOSIT
    GROUP BY
     REF_CUSTOMER
    ,REF_BRANCH
   ) A
  ,    TBL_BRANCH B
  WHERE A.REF_BRANCH   = B.BRN_ID;

 END PRC_CAR_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_STATE_REPORT RETURN VARCHAR2 AS
  VAR_SUM_BALANCE   NUMBER;
 BEGIN
  SELECT
   SUM(BALANCE)
  INTO
   VAR_SUM_BALANCE
  FROM TBL_CONC_RPORT_DETAIL;

  RETURN 'select ref_state "hc-key",sum(balance) "value",max(state_name)"name",to_char(0||round(sum(balance)/' || VAR_SUM_BALANCE || ',5)) as "percent" from tbl_conc_rport_detail group by ref_state order by ref_state'
;
 END FNC_CONC_STATE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_MAIN_REPORT RETURN VARCHAR2 AS
  VAR_COUNT         NUMBER;
  VAR_SUM_BALANCE   NUMBER;
  VAR_PERCENT_100   NUMBER;
 BEGIN
  SELECT
   COUNT(DISTINCT CUSTOMER_NUMBER)
  INTO
   VAR_COUNT
  FROM TBL_CONC_RPORT_DETAIL;

  SELECT
   SUM(BALANCE)
  INTO
   VAR_SUM_BALANCE
  FROM TBL_CONC_RPORT_DETAIL;

  SELECT
   TO_CHAR(ROUND(
    SUM(BALANCE) / VAR_SUM_BALANCE
   ,5
   )*100)
  INTO
   VAR_PERCENT_100
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,BALANCE
    FROM (
      SELECT
       CUSTOMER_NUMBER
      ,SUM(BALANCE) AS BALANCE
      FROM TBL_CONC_RPORT_DETAIL
      GROUP BY
       CUSTOMER_NUMBER
     )
    ORDER BY BALANCE DESC
   )
  WHERE ROWNUM <= 100;

  RETURN 'SELECT
 1
 ,ROUND(0.1 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 , TO_CHAR(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent" 
 ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"
FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.1 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 1 union
 SELECT
 2
 ,ROUND(0.25 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 , TO_CHAR(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.25 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 2 union
 SELECT
 3
 ,ROUND(0.5 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 , TO_CHAR(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.5 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 3 union
 SELECT
 4
 ,ROUND(0.75 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 , TO_CHAR(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.75 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 4 union
 SELECT
 5
 ,ROUND(1 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 , TO_CHAR(ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 1 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 5';

 END FNC_CONC_MAIN_REPORT;

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_STATE_DETAIL_REPORT ( INPAR_STATE IN NUMBER ) RETURN VARCHAR2 AS
  VAR_COUNT         NUMBER;
  VAR_SUM_BALANCE   NUMBER;
  VAR_PERCENT_100   NUMBER;
 BEGIN
  SELECT
   COUNT(DISTINCT CUSTOMER_NUMBER)
  INTO
   VAR_COUNT
  FROM TBL_CONC_RPORT_DETAIL
  WHERE REF_STATE   = INPAR_STATE;

  SELECT
   SUM(BALANCE)
  INTO
   VAR_SUM_BALANCE
  FROM TBL_CONC_RPORT_DETAIL
  WHERE REF_STATE   = INPAR_STATE;

  SELECT
   to_char(ROUND(
    SUM(BALANCE) / VAR_SUM_BALANCE
   ,5
   )*100)
  INTO
   VAR_PERCENT_100
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,BALANCE
    FROM (
      SELECT
       CUSTOMER_NUMBER
      ,SUM(BALANCE) AS BALANCE
      FROM TBL_CONC_RPORT_DETAIL
      WHERE REF_STATE   = INPAR_STATE
      GROUP BY
       CUSTOMER_NUMBER
     )
    ORDER BY BALANCE DESC
   )
  WHERE ROWNUM <= 100;

  RETURN 'SELECT
 1
 ,''0.1'' as "ha"
 ,ROUND(0.1 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 ,to_char(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent" 
 ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"
FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL where ref_state =' ||
  INPAR_STATE ||
  '
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.1 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 1 union
 SELECT
 2
 ,''0.25'' as "ha"
 ,ROUND(0.25 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 ,to_char(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL where ref_state =' ||
  INPAR_STATE ||
  '
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.25 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 2 union
 SELECT
 3
 ,''0.5'' as "ha"
 ,ROUND(0.5 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 ,to_char(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL where ref_state =' ||
  INPAR_STATE ||
  '
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.5 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 3 union
 SELECT
 4
 ,''0.75'' as "ha"
 ,ROUND(0.75 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 ,to_char(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL where ref_state =' ||
  INPAR_STATE ||
  '
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.75 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 4 union
 SELECT
 5
 ,''1'' as "ha"
 ,ROUND(1 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 ,to_char(ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL where ref_state =' ||
  INPAR_STATE ||
  '
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 1 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 5';

 END FNC_CONC_STATE_DETAIL_REPORT;

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_BRANCH_REPORT RETURN VARCHAR2 AS
  VAR_SUM_BALANCE   NUMBER;
 BEGIN
  SELECT
   SUM(BALANCE)
  INTO
   VAR_SUM_BALANCE
  FROM TBL_CONC_RPORT_DETAIL;

  RETURN 'SELECT
 to_number(REF_BRANCH)"id"
 ,BALANCE "value"
 ,NAME as "name"
 ,to_char(0||round(BALANCE/' || VAR_SUM_BALANCE || ',6)) "percent"
FROM (
  SELECT
   REF_BRANCH
  ,SUM(BALANCE) AS BALANCE
  ,MAX(TBL_BRANCH.NAME) AS NAME
  FROM TBL_CONC_RPORT_DETAIL
  ,   TBL_BRANCH
  WHERE TBL_BRANCH.BRN_ID   = TBL_CONC_RPORT_DETAIL.REF_BRANCH
  GROUP BY
   REF_BRANCH
 )
ORDER BY BALANCE DESC'
;
 END FNC_CONC_BRANCH_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
FUNCTION   FNC_PAGING_QUERY 
(
--======YEK QUERY V PAGE-SIZE V PAGE-NUMBER MIGIRE VA DADEHASHO PAS MIDE
  INPAR_PAGE_SIZE IN NUMBER 
, INPAR_PAGE_NUMBER IN NUMBER 
 
) RETURN clob AS 
  LOC_QUERY clob; 
  LOC_LOW NUMBER := (INPAR_PAGE_NUMBER-1)*INPAR_PAGE_SIZE+1; 
  LOC_UP NUMBER := INPAR_PAGE_NUMBER*INPAR_PAGE_SIZE;  
  INPAR_QUERY  clob := pkg_conc.FNC_CONC_BRANCH_REPORT();
BEGIN
  LOC_QUERY := 'SELECT * FROM (
                              SELECT ROWNUM "رديف", t.*
                              FROM (' || INPAR_QUERY ||')T)
                              WHERE  "رديف" BETWEEN ' || LOC_LOW || ' AND ' ||LOC_UP;
 RETURN LOC_QUERY;
END FNC_PAGING_QUERY;

-----------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION    FNC_PAGE_NUMBER 

(

  INAPR_PAGE_SIZE IN NUMBER 

) RETURN varchar2 AS 
 LOC_QUERY VARCHAR2(4000);
 LOC_CNT varchar2(4000);
 inpar_query varchar2(32000);
BEGIN
  inpar_query := pkg_conc.FNC_CONC_BRANCH_REPORT();
  LOC_QUERY :='SELECT FLOOR((COUNT(*)/'|| INAPR_PAGE_SIZE ||')+1)  FROM ('||INPAR_QUERY||')';
  EXECUTE IMMEDIATE LOC_QUERY INTO LOC_CNT;
  RETURN LOC_CNT;
END FNC_PAGE_NUMBER;

-----------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
END PKG_CONC;
--------------------------------------------------------
--  DDL for Table PKG_CONC
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_CONC" AS 
/*---------------------------------------------------------------------------------------------*/
--------------تمرکز سپرده
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_CAR_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_STATE_REPORT RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_MAIN_REPORT RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_STATE_DETAIL_REPORT ( INPAR_STATE IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_BRANCH_REPORT RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION     FNC_PAGING_QUERY 
(
  INPAR_PAGE_SIZE IN NUMBER 
, INPAR_PAGE_NUMBER IN NUMBER 

) RETURN clob ;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_PAGE_NUMBER 

(
  INAPR_PAGE_SIZE IN NUMBER 

) RETURN varchar2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_CONC;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_CONC" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_CAR_REP_PROFILE_REPORT
  AS
 BEGIN
  INSERT INTO TBL_CONC_RPORT_DETAIL (
   CUSTOMER_NUMBER
  ,REF_BRANCH
  ,BALANCE
  ,BRANCH_NAME
  ,REF_CITY
  ,CITY_NAME
  ,REF_STATE
  ,STATE_NAME
  ) SELECT
   A.REF_CUSTOMER
  ,A.REF_BRANCH
  ,A.BALANCE
  ,B.NAME
  ,B.REF_CTY_ID
  ,B.CITY_NAME
  ,B.REF_STA_ID
  ,B.STA_NAME
  FROM (
    SELECT
     REF_CUSTOMER
    ,REF_BRANCH
    ,SUM(BALANCE) AS BALANCE
    FROM AKIN.TBL_DEPOSIT
    GROUP BY
     REF_CUSTOMER
    ,REF_BRANCH
   ) A
  ,    TBL_BRANCH B
  WHERE A.REF_BRANCH   = B.BRN_ID;

 END PRC_CAR_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_STATE_REPORT RETURN VARCHAR2 AS
  VAR_SUM_BALANCE   NUMBER;
 BEGIN
  SELECT
   SUM(BALANCE)
  INTO
   VAR_SUM_BALANCE
  FROM TBL_CONC_RPORT_DETAIL;

  RETURN 'select ref_state "hc-key",sum(balance) "value",max(state_name)"name",to_char(0||round(sum(balance)/' || VAR_SUM_BALANCE || ',5)) as "percent" from tbl_conc_rport_detail group by ref_state order by ref_state'
;
 END FNC_CONC_STATE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_MAIN_REPORT RETURN VARCHAR2 AS
  VAR_COUNT         NUMBER;
  VAR_SUM_BALANCE   NUMBER;
  VAR_PERCENT_100   NUMBER;
 BEGIN
  SELECT
   COUNT(DISTINCT CUSTOMER_NUMBER)
  INTO
   VAR_COUNT
  FROM TBL_CONC_RPORT_DETAIL;

  SELECT
   SUM(BALANCE)
  INTO
   VAR_SUM_BALANCE
  FROM TBL_CONC_RPORT_DETAIL;

  SELECT
   TO_CHAR(ROUND(
    SUM(BALANCE) / VAR_SUM_BALANCE
   ,5
   )*100)
  INTO
   VAR_PERCENT_100
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,BALANCE
    FROM (
      SELECT
       CUSTOMER_NUMBER
      ,SUM(BALANCE) AS BALANCE
      FROM TBL_CONC_RPORT_DETAIL
      GROUP BY
       CUSTOMER_NUMBER
     )
    ORDER BY BALANCE DESC
   )
  WHERE ROWNUM <= 100;

  RETURN 'SELECT
 1
 ,ROUND(0.1 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 , TO_CHAR(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent" 
 ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"
FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.1 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 1 union
 SELECT
 2
 ,ROUND(0.25 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 , TO_CHAR(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.25 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 2 union
 SELECT
 3
 ,ROUND(0.5 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 , TO_CHAR(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.5 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 3 union
 SELECT
 4
 ,ROUND(0.75 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 , TO_CHAR(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.75 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 4 union
 SELECT
 5
 ,ROUND(1 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 , TO_CHAR(ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 1 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 5';

 END FNC_CONC_MAIN_REPORT;

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_STATE_DETAIL_REPORT ( INPAR_STATE IN NUMBER ) RETURN VARCHAR2 AS
  VAR_COUNT         NUMBER;
  VAR_SUM_BALANCE   NUMBER;
  VAR_PERCENT_100   NUMBER;
 BEGIN
  SELECT
   COUNT(DISTINCT CUSTOMER_NUMBER)
  INTO
   VAR_COUNT
  FROM TBL_CONC_RPORT_DETAIL
  WHERE REF_STATE   = INPAR_STATE;

  SELECT
   SUM(BALANCE)
  INTO
   VAR_SUM_BALANCE
  FROM TBL_CONC_RPORT_DETAIL
  WHERE REF_STATE   = INPAR_STATE;

  SELECT
   to_char(ROUND(
    SUM(BALANCE) / VAR_SUM_BALANCE
   ,5
   )*100)
  INTO
   VAR_PERCENT_100
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,BALANCE
    FROM (
      SELECT
       CUSTOMER_NUMBER
      ,SUM(BALANCE) AS BALANCE
      FROM TBL_CONC_RPORT_DETAIL
      WHERE REF_STATE   = INPAR_STATE
      GROUP BY
       CUSTOMER_NUMBER
     )
    ORDER BY BALANCE DESC
   )
  WHERE ROWNUM <= 100;

  RETURN 'SELECT
 1
 ,''0.1'' as "ha"
 ,ROUND(0.1 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 ,to_char(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent" 
 ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"
FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL where ref_state =' ||
  INPAR_STATE ||
  '
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.1 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 1 union
 SELECT
 2
 ,''0.25'' as "ha"
 ,ROUND(0.25 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 ,to_char(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL where ref_state =' ||
  INPAR_STATE ||
  '
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.25 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 2 union
 SELECT
 3
 ,''0.5'' as "ha"
 ,ROUND(0.5 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 ,to_char(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL where ref_state =' ||
  INPAR_STATE ||
  '
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.5 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 3 union
 SELECT
 4
 ,''0.75'' as "ha"
 ,ROUND(0.75 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 ,to_char(0||ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL where ref_state =' ||
  INPAR_STATE ||
  '
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 0.75 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 4 union
 SELECT
 5
 ,''1'' as "ha"
 ,ROUND(1 * ' ||
  VAR_COUNT ||
  ') AS "count"
 ,SUM(BALANCE) "value"
 ,to_char(ROUND(
  SUM(BALANCE) / ' ||
  VAR_SUM_BALANCE ||
  '
 ,5
 )) "percent"
  ,' ||
  VAR_PERCENT_100 ||
  ' as "top100"

FROM (
  SELECT
   CUSTOMER_NUMBER
  ,BALANCE
  FROM (
    SELECT
     CUSTOMER_NUMBER
    ,SUM(BALANCE) AS BALANCE
    FROM TBL_CONC_RPORT_DETAIL where ref_state =' ||
  INPAR_STATE ||
  '
    GROUP BY
     CUSTOMER_NUMBER
   )
  ORDER BY BALANCE DESC
 )
WHERE ROWNUM <= 1 * ' ||
  VAR_COUNT ||
  '
GROUP BY
 5';

 END FNC_CONC_STATE_DETAIL_REPORT;

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_CONC_BRANCH_REPORT RETURN VARCHAR2 AS
  VAR_SUM_BALANCE   NUMBER;
 BEGIN
  SELECT
   SUM(BALANCE)
  INTO
   VAR_SUM_BALANCE
  FROM TBL_CONC_RPORT_DETAIL;

  RETURN 'SELECT
 to_number(REF_BRANCH)"id"
 ,BALANCE "value"
 ,NAME as "name"
 ,to_char(0||round(BALANCE/' || VAR_SUM_BALANCE || ',6)) "percent"
FROM (
  SELECT
   REF_BRANCH
  ,SUM(BALANCE) AS BALANCE
  ,MAX(TBL_BRANCH.NAME) AS NAME
  FROM TBL_CONC_RPORT_DETAIL
  ,   TBL_BRANCH
  WHERE TBL_BRANCH.BRN_ID   = TBL_CONC_RPORT_DETAIL.REF_BRANCH
  GROUP BY
   REF_BRANCH
 )
ORDER BY BALANCE DESC'
;
 END FNC_CONC_BRANCH_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
FUNCTION   FNC_PAGING_QUERY 
(
--======YEK QUERY V PAGE-SIZE V PAGE-NUMBER MIGIRE VA DADEHASHO PAS MIDE
  INPAR_PAGE_SIZE IN NUMBER 
, INPAR_PAGE_NUMBER IN NUMBER 
 
) RETURN clob AS 
  LOC_QUERY clob; 
  LOC_LOW NUMBER := (INPAR_PAGE_NUMBER-1)*INPAR_PAGE_SIZE+1; 
  LOC_UP NUMBER := INPAR_PAGE_NUMBER*INPAR_PAGE_SIZE;  
  INPAR_QUERY  clob := pkg_conc.FNC_CONC_BRANCH_REPORT();
BEGIN
  LOC_QUERY := 'SELECT * FROM (
                              SELECT ROWNUM "رديف", t.*
                              FROM (' || INPAR_QUERY ||')T)
                              WHERE  "رديف" BETWEEN ' || LOC_LOW || ' AND ' ||LOC_UP;
 RETURN LOC_QUERY;
END FNC_PAGING_QUERY;

-----------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION    FNC_PAGE_NUMBER 

(

  INAPR_PAGE_SIZE IN NUMBER 

) RETURN varchar2 AS 
 LOC_QUERY VARCHAR2(4000);
 LOC_CNT varchar2(4000);
 inpar_query varchar2(32000);
BEGIN
  inpar_query := pkg_conc.FNC_CONC_BRANCH_REPORT();
  LOC_QUERY :='SELECT FLOOR((COUNT(*)/'|| INAPR_PAGE_SIZE ||')+1)  FROM ('||INPAR_QUERY||')';
  EXECUTE IMMEDIATE LOC_QUERY INTO LOC_CNT;
  RETURN LOC_CNT;
END FNC_PAGE_NUMBER;

-----------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
END PKG_CONC;
--------------------------------------------------------
--  DDL for Table PKG_DU_GAP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_DU_GAP" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_DU_GAP_DELTA_NWA (
  INPAR_DUR_ASSET     IN FLOAT
 ,INPAR_DUR_LIA       IN FLOAT
 ,INPAR_ASSET_VALUE   IN FLOAT
 ,INPAR_LIA_VALUE     IN FLOAT
 ,INPAR_I1            IN FLOAT
 ,INPAR_I2            IN FLOAT
 ) RETURN FLOAT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_DELTAP (
  INPAR_DUR_ASSET   IN FLOAT
 ,INPAR_DUR_LIA     IN FLOAT
 ,INPAR_I1          IN FLOAT
 ,INPAR_I2          IN FLOAT
 ,INPAR_TYPE        IN VARCHAR2
 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_DURGAP (
  INPAR_DUR_ASSET     IN FLOAT
 ,INPAR_DUR_LIA       IN FLOAT
 ,INPAR_ASSET_VALUE   IN FLOAT
 ,INPAR_LIA_VALUE     IN FLOAT
 ) RETURN FLOAT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DU_GAP_REPORT_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_GET_REPORT_INFO RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
function fnc_du_gap_total_result 

(
inpar_I1 in float,
inpar_I2 in float

)
return varchar2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_DU_GAP;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_DU_GAP" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_DELTA_NWA (
  INPAR_DUR_ASSET     IN FLOAT
 ,INPAR_DUR_LIA       IN FLOAT
 ,INPAR_ASSET_VALUE   IN FLOAT
 ,INPAR_LIA_VALUE     IN FLOAT
 ,INPAR_I1            IN FLOAT
 ,INPAR_I2            IN FLOAT
 ) RETURN FLOAT AS
  OUTPAR_DELTA_NWA   FLOAT;
 BEGIN
  OUTPAR_DELTA_NWA   := ROUND(
   ( (-1) * FNC_DU_GAP_DURGAP(
    INPAR_DUR_ASSET
   ,INPAR_DUR_LIA
   ,INPAR_ASSET_VALUE
   ,INPAR_LIA_VALUE
   ) ) * ( (INPAR_I2 - INPAR_I1) / (1 + INPAR_I1) )
  ,3
  );

  RETURN OUTPAR_DELTA_NWA;
 END FNC_DU_GAP_DELTA_NWA;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_DELTAP (
  INPAR_DUR_ASSET   IN FLOAT
 ,INPAR_DUR_LIA     IN FLOAT
 ,INPAR_I1          IN FLOAT
 ,INPAR_I2          IN FLOAT
 ,INPAR_TYPE        IN VARCHAR2
 ) RETURN VARCHAR2 AS
  OUTPAR_DELTAP_ASSET   FLOAT;
  OUTPAR_DELTAP_LIA     FLOAT;
  VAR_DUR_ASSET         FLOAT;
  VAR_DUR_LIA           FLOAT;
 BEGIN
  IF
   ( INPAR_TYPE = 1 )
  THEN
   VAR_DUR_ASSET         := (-1 ) * INPAR_DUR_ASSET;
   OUTPAR_DELTAP_ASSET   := ROUND(
    (VAR_DUR_ASSET) * ( (INPAR_I2 - INPAR_I1) / (1 + INPAR_I1) )
   ,3
   );

   RETURN OUTPAR_DELTAP_ASSET;
  ELSE
   VAR_DUR_LIA         := (-1 ) * INPAR_DUR_LIA;
   OUTPAR_DELTAP_LIA   := ROUND(
    (VAR_DUR_LIA) * ( (INPAR_I2 - INPAR_I1) / (1 + INPAR_I1) )
   ,3
   );

   RETURN OUTPAR_DELTAP_LIA;
  END IF;
  /*RETURN OUTPAR_DELTAP_ASSET || ',' || OUTPAR_DELTAP_LIA;*/
 END FNC_DU_GAP_DELTAP;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_DURGAP (
  INPAR_DUR_ASSET     IN FLOAT
 ,INPAR_DUR_LIA       IN FLOAT
 ,INPAR_ASSET_VALUE   IN FLOAT
 ,INPAR_LIA_VALUE     IN FLOAT
 ) RETURN FLOAT AS
  OUTPAR_DURGAP   FLOAT;
 BEGIN
  OUTPAR_DURGAP   := ROUND(
   ( (INPAR_DUR_ASSET) - ( (INPAR_LIA_VALUE / INPAR_ASSET_VALUE) * INPAR_DUR_LIA) )
  ,3
  );

  RETURN OUTPAR_DURGAP;
  --RETURN NULL;
 END FNC_DU_GAP_DURGAP;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DU_GAP_REPORT_DETAIL
  AS
 BEGIN
  EXECUTE IMMEDIATE 'truncate table TBL_DU_GAP_REPORT_DETAIL';
  INSERT INTO TBL_DU_GAP_REPORT_DETAIL (
   AMOUNT
  ,DURATION
  ,TYPE
  ,TITLE
  ,TOTAL_ASSETS_WEIGHT
  ,TOTAL_LIA_WEIGHT
  ,TOTAL_ASSETS_AMOUNT
  ,TOTAL_LIA_AMOUNT
  ,NAME
  ) SELECT
   SUM(BALANCE) AS AMOUNT
  ,'0.4'
  ,1
  ,1
  ,''
  ,''
  ,''
  ,''
  ,'سپرده کمتر از يک سال'
  FROM AKIN.TBL_DEPOSIT
  WHERE DUE_DATE <= SYSDATE + 365
   OR
    DUE_DATE IS NULL;

  COMMIT;
  INSERT INTO TBL_DU_GAP_REPORT_DETAIL (
   AMOUNT
  ,DURATION
  ,TYPE
  ,TITLE
  ,TOTAL_ASSETS_WEIGHT
  ,TOTAL_LIA_WEIGHT
  ,TOTAL_ASSETS_AMOUNT
  ,TOTAL_LIA_AMOUNT
  ,NAME
  ) SELECT
   SUM(BALANCE) AS AMOUNT
  ,'0.4'
  ,1
  ,2
  ,''
  ,''
  ,''
  ,''
  ,'سپرده بين يک تا دو سال'
  FROM AKIN.TBL_DEPOSIT
  WHERE DUE_DATE >= SYSDATE + 365
   AND
    DUE_DATE <= SYSDATE + 730;

  COMMIT;
  INSERT INTO TBL_DU_GAP_REPORT_DETAIL (
   AMOUNT
  ,DURATION
  ,TYPE
  ,TITLE
  ,TOTAL_ASSETS_WEIGHT
  ,TOTAL_LIA_WEIGHT
  ,TOTAL_ASSETS_AMOUNT
  ,TOTAL_LIA_AMOUNT
  ,NAME
  ) SELECT
   SUM(BALANCE) AS AMOUNT
  ,'0.4'
  ,1
  ,3
  ,''
  ,''
  ,''
  ,''
  ,'سپرده بيشتر از دو سال'
  FROM AKIN.TBL_DEPOSIT
  WHERE DUE_DATE > SYSDATE + 730;

  COMMIT;
  INSERT INTO TBL_DU_GAP_REPORT_DETAIL (
   AMOUNT
  ,DURATION
  ,TYPE
  ,TITLE
  ,TOTAL_ASSETS_WEIGHT
  ,TOTAL_LIA_WEIGHT
  ,TOTAL_ASSETS_AMOUNT
  ,TOTAL_LIA_AMOUNT
  ,NAME
  ) SELECT
   SUM(AMOUNT) AS AMOUNT
  ,'0.4'
  ,2
  ,1
  ,''
  ,''
  ,''
  ,''
  ,'تسهيلات کمتر از يک سال'
  FROM AKIN.TBL_LOAN_PAYMENT
  WHERE DUE_DATE >= SYSDATE
   AND
    DUE_DATE <= SYSDATE + 365;

  COMMIT;
  INSERT INTO TBL_DU_GAP_REPORT_DETAIL (
   AMOUNT
  ,DURATION
  ,TYPE
  ,TITLE
  ,TOTAL_ASSETS_WEIGHT
  ,TOTAL_LIA_WEIGHT
  ,TOTAL_ASSETS_AMOUNT
  ,TOTAL_LIA_AMOUNT
  ,NAME
  ) SELECT
   SUM(AMOUNT) AS AMOUNT
  ,'0.4'
  ,2
  ,2
  ,''
  ,''
  ,''
  ,''
  ,'تسهيلات بين يک تا دو سال'
  FROM AKIN.TBL_LOAN_PAYMENT
  WHERE DUE_DATE > SYSDATE + 365
   AND
    DUE_DATE <= SYSDATE + 730;

  COMMIT;
  INSERT INTO TBL_DU_GAP_REPORT_DETAIL (
   AMOUNT
  ,DURATION
  ,TYPE
  ,TITLE
  ,TOTAL_ASSETS_WEIGHT
  ,TOTAL_LIA_WEIGHT
  ,TOTAL_ASSETS_AMOUNT
  ,TOTAL_LIA_AMOUNT
  ,NAME
  ) SELECT
   SUM(AMOUNT) AS AMOUNT
  ,'0.4'
  ,2
  ,3
  ,''
  ,''
  ,''
  ,''
  ,'تسهيلات بيشتر از دو سال'
  FROM AKIN.TBL_LOAN_PAYMENT
  WHERE DUE_DATE > SYSDATE + 730;

  COMMIT;
  UPDATE TBL_DU_GAP_REPORT_DETAIL
   SET
    TOTAL_LIA_AMOUNT = (
     SELECT
      SUM(AMOUNT)
     FROM TBL_DU_GAP_REPORT_DETAIL
     WHERE TYPE   = 2
    )
  WHERE TYPE   = 2;

  COMMIT;
  UPDATE TBL_DU_GAP_REPORT_DETAIL
   SET
    TOTAL_ASSETS_AMOUNT = (
     SELECT
      SUM(AMOUNT)
     FROM TBL_DU_GAP_REPORT_DETAIL
     WHERE TYPE   = 1
    )
  WHERE TYPE   = 1;

  COMMIT;
  UPDATE TBL_DU_GAP_REPORT_DETAIL
   SET
    TOTAL_ASSETS_WEIGHT = (
     SELECT
      SUM(WEIGHT)
     FROM TBL_DU_GAP_REPORT_DETAIL
     WHERE TYPE   = 1
    ) / (
     SELECT DISTINCT
      MAX(TOTAL_ASSETS_AMOUNT)
     FROM TBL_DU_GAP_REPORT_DETAIL
    )
  WHERE TYPE   = 1;

  COMMIT;
  UPDATE TBL_DU_GAP_REPORT_DETAIL
   SET
    TOTAL_LIA_WEIGHT = (
     SELECT
      SUM(WEIGHT)
     FROM TBL_DU_GAP_REPORT_DETAIL
     WHERE TYPE   = 2
    ) / (
     SELECT DISTINCT
      MAX(TOTAL_LIA_AMOUNT)
     FROM TBL_DU_GAP_REPORT_DETAIL
    )
  WHERE TYPE   = 2;

  COMMIT;
 END PRC_DU_GAP_REPORT_DETAIL;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_TOTAL_RESULT (
  INPAR_I1   IN FLOAT
 ,INPAR_I2   IN FLOAT
 ) RETURN VARCHAR2 AS

  VAR_DUR_ASSET        FLOAT;
  VAR_DUR_LIA          FLOAT;
  VAR_ASSET_VALUE      FLOAT;
  VAR_LIA_VALUE        FLOAT;
  OUTPAR_DLTAP_ASSET   varchar2(8000);
  OUTPAR_DLTAP_LIA     varchar2(8000);
  OUTPAR_DURGAP        varchar2(8000);
  OUTPAR_DELTA_NWA     varchar2(8000);
 BEGIN
  SELECT DISTINCT
   ( TOTAL_ASSETS_WEIGHT )
  INTO
   VAR_DUR_ASSET
  FROM TBL_DU_GAP_REPORT_DETAIL
  WHERE TYPE   = 1;

  SELECT DISTINCT
   ( TOTAL_LIA_WEIGHT )
  INTO
   VAR_DUR_LIA
  FROM TBL_DU_GAP_REPORT_DETAIL
  WHERE TYPE   = 2;

  SELECT DISTINCT
   ( TOTAL_ASSETS_AMOUNT )
  INTO
   VAR_ASSET_VALUE
  FROM TBL_DU_GAP_REPORT_DETAIL
  WHERE TYPE   = 1;

  SELECT DISTINCT
   ( TOTAL_LIA_AMOUNT )
  INTO
   VAR_LIA_VALUE
  FROM TBL_DU_GAP_REPORT_DETAIL
  WHERE TYPE   = 2;

  OUTPAR_DLTAP_ASSET   := PKG_DU_GAP.FNC_DU_GAP_DELTAP(
   VAR_DUR_ASSET
  ,VAR_DUR_LIA
  ,INPAR_I1
  ,INPAR_I2
  ,1
  );
   select REPLACE(to_char(OUTPAR_DLTAP_ASSET), '.', '0.') into OUTPAR_DLTAP_ASSET from dual;
   
  OUTPAR_DLTAP_LIA     := PKG_DU_GAP.FNC_DU_GAP_DELTAP(
   VAR_DUR_ASSET
  ,VAR_DUR_LIA
  ,INPAR_I1
  ,INPAR_I2
  ,0
  );
  
  select REPLACE(to_char(OUTPAR_DLTAP_LIA), '.', '0.') into OUTPAR_DLTAP_LIA from dual;
  OUTPAR_DURGAP        := PKG_DU_GAP.FNC_DU_GAP_DURGAP(
   VAR_DUR_ASSET
  ,VAR_DUR_LIA
  ,VAR_ASSET_VALUE
  ,VAR_LIA_VALUE
  );
  
    select REPLACE(to_char(OUTPAR_DURGAP), '.', '0.') into OUTPAR_DURGAP from dual;

  OUTPAR_DELTA_NWA     := PKG_DU_GAP.FNC_DU_GAP_DELTA_NWA(
   VAR_DUR_ASSET
  ,VAR_DUR_LIA
  ,VAR_ASSET_VALUE
  ,VAR_LIA_VALUE
  ,INPAR_I1
  ,INPAR_I2
  );
   select REPLACE(to_char(OUTPAR_DELTA_NWA), '.0', '0.0') into OUTPAR_DELTA_NWA from dual;

  RETURN 'select ''' ||
  OUTPAR_DLTAP_ASSET ||
  ''' as "deltapAsset",''' ||
  OUTPAR_DLTAP_LIA ||
  ''' as "deltapLia",''' ||
  OUTPAR_DURGAP ||
  ''' as "durGap" ,''' ||
  OUTPAR_DELTA_NWA ||
  ''' as "deltaNwa" from dual';

 END FNC_DU_GAP_TOTAL_RESULT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_GET_REPORT_INFO RETURN VARCHAR2
  AS
 BEGIN
  RETURN 'SELECT
 NAME"name"
 ,to_char(AMOUNT)"value"
 ,TYPE"type"
 ,TITLE"title"
FROM TBL_DU_GAP_REPORT_DETAIL union
SELECT distinct
''TOTAL_ASSETS_WEIGHT'' as "name"
,case when  to_char(TOTAL_ASSETS_WEIGHT)< 1 then to_char(0||TOTAL_ASSETS_WEIGHT) else to_char(TOTAL_ASSETS_WEIGHT) end as "value"
 ,''3'' "type",''3''  "title" 
FROM TBL_DU_GAP_REPORT_DETAIL where total_assets_weight is not null union
SELECT distinct
''TOTAL_LIA_WEIGHT'' as "name"
,case when  to_char(TOTAL_LIA_WEIGHT)< 1 then to_char(0||TOTAL_LIA_WEIGHT) else to_char(TOTAL_LIA_WEIGHT) end as "value"
 ,''4'' "type",''4''  "title" 
FROM TBL_DU_GAP_REPORT_DETAIL where TOTAL_LIA_WEIGHT is not null union
SELECT distinct
''TOTAL_ASSETS_AMOUNT'' as "name"
,to_char(TOTAL_ASSETS_AMOUNT) as "value"
 ,''5'' "type",''5''  "title" 
FROM TBL_DU_GAP_REPORT_DETAIL where TOTAL_ASSETS_AMOUNT is not null union
SELECT distinct
''TOTAL_LIA_AMOUNT'' as "name"
,to_char(TOTAL_LIA_AMOUNT) as "value"
 ,''6'' "type",''6''  "title" 
FROM TBL_DU_GAP_REPORT_DETAIL where TOTAL_LIA_AMOUNT is not null'
;
 END FNC_DU_GAP_GET_REPORT_INFO;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_DU_GAP;
--------------------------------------------------------
--  DDL for Table PKG_DU_GAP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_DU_GAP" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_DU_GAP_DELTA_NWA (
  INPAR_DUR_ASSET     IN FLOAT
 ,INPAR_DUR_LIA       IN FLOAT
 ,INPAR_ASSET_VALUE   IN FLOAT
 ,INPAR_LIA_VALUE     IN FLOAT
 ,INPAR_I1            IN FLOAT
 ,INPAR_I2            IN FLOAT
 ) RETURN FLOAT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_DELTAP (
  INPAR_DUR_ASSET   IN FLOAT
 ,INPAR_DUR_LIA     IN FLOAT
 ,INPAR_I1          IN FLOAT
 ,INPAR_I2          IN FLOAT
 ,INPAR_TYPE        IN VARCHAR2
 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_DURGAP (
  INPAR_DUR_ASSET     IN FLOAT
 ,INPAR_DUR_LIA       IN FLOAT
 ,INPAR_ASSET_VALUE   IN FLOAT
 ,INPAR_LIA_VALUE     IN FLOAT
 ) RETURN FLOAT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DU_GAP_REPORT_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_GET_REPORT_INFO RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
function fnc_du_gap_total_result 

(
inpar_I1 in float,
inpar_I2 in float

)
return varchar2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_DU_GAP;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_DU_GAP" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_DELTA_NWA (
  INPAR_DUR_ASSET     IN FLOAT
 ,INPAR_DUR_LIA       IN FLOAT
 ,INPAR_ASSET_VALUE   IN FLOAT
 ,INPAR_LIA_VALUE     IN FLOAT
 ,INPAR_I1            IN FLOAT
 ,INPAR_I2            IN FLOAT
 ) RETURN FLOAT AS
  OUTPAR_DELTA_NWA   FLOAT;
 BEGIN
  OUTPAR_DELTA_NWA   := ROUND(
   ( (-1) * FNC_DU_GAP_DURGAP(
    INPAR_DUR_ASSET
   ,INPAR_DUR_LIA
   ,INPAR_ASSET_VALUE
   ,INPAR_LIA_VALUE
   ) ) * ( (INPAR_I2 - INPAR_I1) / (1 + INPAR_I1) )
  ,3
  );

  RETURN OUTPAR_DELTA_NWA;
 END FNC_DU_GAP_DELTA_NWA;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_DELTAP (
  INPAR_DUR_ASSET   IN FLOAT
 ,INPAR_DUR_LIA     IN FLOAT
 ,INPAR_I1          IN FLOAT
 ,INPAR_I2          IN FLOAT
 ,INPAR_TYPE        IN VARCHAR2
 ) RETURN VARCHAR2 AS
  OUTPAR_DELTAP_ASSET   FLOAT;
  OUTPAR_DELTAP_LIA     FLOAT;
  VAR_DUR_ASSET         FLOAT;
  VAR_DUR_LIA           FLOAT;
 BEGIN
  IF
   ( INPAR_TYPE = 1 )
  THEN
   VAR_DUR_ASSET         := (-1 ) * INPAR_DUR_ASSET;
   OUTPAR_DELTAP_ASSET   := ROUND(
    (VAR_DUR_ASSET) * ( (INPAR_I2 - INPAR_I1) / (1 + INPAR_I1) )
   ,3
   );

   RETURN OUTPAR_DELTAP_ASSET;
  ELSE
   VAR_DUR_LIA         := (-1 ) * INPAR_DUR_LIA;
   OUTPAR_DELTAP_LIA   := ROUND(
    (VAR_DUR_LIA) * ( (INPAR_I2 - INPAR_I1) / (1 + INPAR_I1) )
   ,3
   );

   RETURN OUTPAR_DELTAP_LIA;
  END IF;
  /*RETURN OUTPAR_DELTAP_ASSET || ',' || OUTPAR_DELTAP_LIA;*/
 END FNC_DU_GAP_DELTAP;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_DURGAP (
  INPAR_DUR_ASSET     IN FLOAT
 ,INPAR_DUR_LIA       IN FLOAT
 ,INPAR_ASSET_VALUE   IN FLOAT
 ,INPAR_LIA_VALUE     IN FLOAT
 ) RETURN FLOAT AS
  OUTPAR_DURGAP   FLOAT;
 BEGIN
  OUTPAR_DURGAP   := ROUND(
   ( (INPAR_DUR_ASSET) - ( (INPAR_LIA_VALUE / INPAR_ASSET_VALUE) * INPAR_DUR_LIA) )
  ,3
  );

  RETURN OUTPAR_DURGAP;
  --RETURN NULL;
 END FNC_DU_GAP_DURGAP;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DU_GAP_REPORT_DETAIL
  AS
 BEGIN
  EXECUTE IMMEDIATE 'truncate table TBL_DU_GAP_REPORT_DETAIL';
  INSERT INTO TBL_DU_GAP_REPORT_DETAIL (
   AMOUNT
  ,DURATION
  ,TYPE
  ,TITLE
  ,TOTAL_ASSETS_WEIGHT
  ,TOTAL_LIA_WEIGHT
  ,TOTAL_ASSETS_AMOUNT
  ,TOTAL_LIA_AMOUNT
  ,NAME
  ) SELECT
   SUM(BALANCE) AS AMOUNT
  ,'0.4'
  ,1
  ,1
  ,''
  ,''
  ,''
  ,''
  ,'سپرده کمتر از يک سال'
  FROM AKIN.TBL_DEPOSIT
  WHERE DUE_DATE <= SYSDATE + 365
   OR
    DUE_DATE IS NULL;

  COMMIT;
  INSERT INTO TBL_DU_GAP_REPORT_DETAIL (
   AMOUNT
  ,DURATION
  ,TYPE
  ,TITLE
  ,TOTAL_ASSETS_WEIGHT
  ,TOTAL_LIA_WEIGHT
  ,TOTAL_ASSETS_AMOUNT
  ,TOTAL_LIA_AMOUNT
  ,NAME
  ) SELECT
   SUM(BALANCE) AS AMOUNT
  ,'0.4'
  ,1
  ,2
  ,''
  ,''
  ,''
  ,''
  ,'سپرده بين يک تا دو سال'
  FROM AKIN.TBL_DEPOSIT
  WHERE DUE_DATE >= SYSDATE + 365
   AND
    DUE_DATE <= SYSDATE + 730;

  COMMIT;
  INSERT INTO TBL_DU_GAP_REPORT_DETAIL (
   AMOUNT
  ,DURATION
  ,TYPE
  ,TITLE
  ,TOTAL_ASSETS_WEIGHT
  ,TOTAL_LIA_WEIGHT
  ,TOTAL_ASSETS_AMOUNT
  ,TOTAL_LIA_AMOUNT
  ,NAME
  ) SELECT
   SUM(BALANCE) AS AMOUNT
  ,'0.4'
  ,1
  ,3
  ,''
  ,''
  ,''
  ,''
  ,'سپرده بيشتر از دو سال'
  FROM AKIN.TBL_DEPOSIT
  WHERE DUE_DATE > SYSDATE + 730;

  COMMIT;
  INSERT INTO TBL_DU_GAP_REPORT_DETAIL (
   AMOUNT
  ,DURATION
  ,TYPE
  ,TITLE
  ,TOTAL_ASSETS_WEIGHT
  ,TOTAL_LIA_WEIGHT
  ,TOTAL_ASSETS_AMOUNT
  ,TOTAL_LIA_AMOUNT
  ,NAME
  ) SELECT
   SUM(AMOUNT) AS AMOUNT
  ,'0.4'
  ,2
  ,1
  ,''
  ,''
  ,''
  ,''
  ,'تسهيلات کمتر از يک سال'
  FROM AKIN.TBL_LOAN_PAYMENT
  WHERE DUE_DATE >= SYSDATE
   AND
    DUE_DATE <= SYSDATE + 365;

  COMMIT;
  INSERT INTO TBL_DU_GAP_REPORT_DETAIL (
   AMOUNT
  ,DURATION
  ,TYPE
  ,TITLE
  ,TOTAL_ASSETS_WEIGHT
  ,TOTAL_LIA_WEIGHT
  ,TOTAL_ASSETS_AMOUNT
  ,TOTAL_LIA_AMOUNT
  ,NAME
  ) SELECT
   SUM(AMOUNT) AS AMOUNT
  ,'0.4'
  ,2
  ,2
  ,''
  ,''
  ,''
  ,''
  ,'تسهيلات بين يک تا دو سال'
  FROM AKIN.TBL_LOAN_PAYMENT
  WHERE DUE_DATE > SYSDATE + 365
   AND
    DUE_DATE <= SYSDATE + 730;

  COMMIT;
  INSERT INTO TBL_DU_GAP_REPORT_DETAIL (
   AMOUNT
  ,DURATION
  ,TYPE
  ,TITLE
  ,TOTAL_ASSETS_WEIGHT
  ,TOTAL_LIA_WEIGHT
  ,TOTAL_ASSETS_AMOUNT
  ,TOTAL_LIA_AMOUNT
  ,NAME
  ) SELECT
   SUM(AMOUNT) AS AMOUNT
  ,'0.4'
  ,2
  ,3
  ,''
  ,''
  ,''
  ,''
  ,'تسهيلات بيشتر از دو سال'
  FROM AKIN.TBL_LOAN_PAYMENT
  WHERE DUE_DATE > SYSDATE + 730;

  COMMIT;
  UPDATE TBL_DU_GAP_REPORT_DETAIL
   SET
    TOTAL_LIA_AMOUNT = (
     SELECT
      SUM(AMOUNT)
     FROM TBL_DU_GAP_REPORT_DETAIL
     WHERE TYPE   = 2
    )
  WHERE TYPE   = 2;

  COMMIT;
  UPDATE TBL_DU_GAP_REPORT_DETAIL
   SET
    TOTAL_ASSETS_AMOUNT = (
     SELECT
      SUM(AMOUNT)
     FROM TBL_DU_GAP_REPORT_DETAIL
     WHERE TYPE   = 1
    )
  WHERE TYPE   = 1;

  COMMIT;
  UPDATE TBL_DU_GAP_REPORT_DETAIL
   SET
    TOTAL_ASSETS_WEIGHT = (
     SELECT
      SUM(WEIGHT)
     FROM TBL_DU_GAP_REPORT_DETAIL
     WHERE TYPE   = 1
    ) / (
     SELECT DISTINCT
      MAX(TOTAL_ASSETS_AMOUNT)
     FROM TBL_DU_GAP_REPORT_DETAIL
    )
  WHERE TYPE   = 1;

  COMMIT;
  UPDATE TBL_DU_GAP_REPORT_DETAIL
   SET
    TOTAL_LIA_WEIGHT = (
     SELECT
      SUM(WEIGHT)
     FROM TBL_DU_GAP_REPORT_DETAIL
     WHERE TYPE   = 2
    ) / (
     SELECT DISTINCT
      MAX(TOTAL_LIA_AMOUNT)
     FROM TBL_DU_GAP_REPORT_DETAIL
    )
  WHERE TYPE   = 2;

  COMMIT;
 END PRC_DU_GAP_REPORT_DETAIL;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_TOTAL_RESULT (
  INPAR_I1   IN FLOAT
 ,INPAR_I2   IN FLOAT
 ) RETURN VARCHAR2 AS

  VAR_DUR_ASSET        FLOAT;
  VAR_DUR_LIA          FLOAT;
  VAR_ASSET_VALUE      FLOAT;
  VAR_LIA_VALUE        FLOAT;
  OUTPAR_DLTAP_ASSET   varchar2(8000);
  OUTPAR_DLTAP_LIA     varchar2(8000);
  OUTPAR_DURGAP        varchar2(8000);
  OUTPAR_DELTA_NWA     varchar2(8000);
 BEGIN
  SELECT DISTINCT
   ( TOTAL_ASSETS_WEIGHT )
  INTO
   VAR_DUR_ASSET
  FROM TBL_DU_GAP_REPORT_DETAIL
  WHERE TYPE   = 1;

  SELECT DISTINCT
   ( TOTAL_LIA_WEIGHT )
  INTO
   VAR_DUR_LIA
  FROM TBL_DU_GAP_REPORT_DETAIL
  WHERE TYPE   = 2;

  SELECT DISTINCT
   ( TOTAL_ASSETS_AMOUNT )
  INTO
   VAR_ASSET_VALUE
  FROM TBL_DU_GAP_REPORT_DETAIL
  WHERE TYPE   = 1;

  SELECT DISTINCT
   ( TOTAL_LIA_AMOUNT )
  INTO
   VAR_LIA_VALUE
  FROM TBL_DU_GAP_REPORT_DETAIL
  WHERE TYPE   = 2;

  OUTPAR_DLTAP_ASSET   := PKG_DU_GAP.FNC_DU_GAP_DELTAP(
   VAR_DUR_ASSET
  ,VAR_DUR_LIA
  ,INPAR_I1
  ,INPAR_I2
  ,1
  );
   select REPLACE(to_char(OUTPAR_DLTAP_ASSET), '.', '0.') into OUTPAR_DLTAP_ASSET from dual;
   
  OUTPAR_DLTAP_LIA     := PKG_DU_GAP.FNC_DU_GAP_DELTAP(
   VAR_DUR_ASSET
  ,VAR_DUR_LIA
  ,INPAR_I1
  ,INPAR_I2
  ,0
  );
  
  select REPLACE(to_char(OUTPAR_DLTAP_LIA), '.', '0.') into OUTPAR_DLTAP_LIA from dual;
  OUTPAR_DURGAP        := PKG_DU_GAP.FNC_DU_GAP_DURGAP(
   VAR_DUR_ASSET
  ,VAR_DUR_LIA
  ,VAR_ASSET_VALUE
  ,VAR_LIA_VALUE
  );
  
    select REPLACE(to_char(OUTPAR_DURGAP), '.', '0.') into OUTPAR_DURGAP from dual;

  OUTPAR_DELTA_NWA     := PKG_DU_GAP.FNC_DU_GAP_DELTA_NWA(
   VAR_DUR_ASSET
  ,VAR_DUR_LIA
  ,VAR_ASSET_VALUE
  ,VAR_LIA_VALUE
  ,INPAR_I1
  ,INPAR_I2
  );
   select REPLACE(to_char(OUTPAR_DELTA_NWA), '.0', '0.0') into OUTPAR_DELTA_NWA from dual;

  RETURN 'select ''' ||
  OUTPAR_DLTAP_ASSET ||
  ''' as "deltapAsset",''' ||
  OUTPAR_DLTAP_LIA ||
  ''' as "deltapLia",''' ||
  OUTPAR_DURGAP ||
  ''' as "durGap" ,''' ||
  OUTPAR_DELTA_NWA ||
  ''' as "deltaNwa" from dual';

 END FNC_DU_GAP_TOTAL_RESULT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DU_GAP_GET_REPORT_INFO RETURN VARCHAR2
  AS
 BEGIN
  RETURN 'SELECT
 NAME"name"
 ,to_char(AMOUNT)"value"
 ,TYPE"type"
 ,TITLE"title"
FROM TBL_DU_GAP_REPORT_DETAIL union
SELECT distinct
''TOTAL_ASSETS_WEIGHT'' as "name"
,case when  to_char(TOTAL_ASSETS_WEIGHT)< 1 then to_char(0||TOTAL_ASSETS_WEIGHT) else to_char(TOTAL_ASSETS_WEIGHT) end as "value"
 ,''3'' "type",''3''  "title" 
FROM TBL_DU_GAP_REPORT_DETAIL where total_assets_weight is not null union
SELECT distinct
''TOTAL_LIA_WEIGHT'' as "name"
,case when  to_char(TOTAL_LIA_WEIGHT)< 1 then to_char(0||TOTAL_LIA_WEIGHT) else to_char(TOTAL_LIA_WEIGHT) end as "value"
 ,''4'' "type",''4''  "title" 
FROM TBL_DU_GAP_REPORT_DETAIL where TOTAL_LIA_WEIGHT is not null union
SELECT distinct
''TOTAL_ASSETS_AMOUNT'' as "name"
,to_char(TOTAL_ASSETS_AMOUNT) as "value"
 ,''5'' "type",''5''  "title" 
FROM TBL_DU_GAP_REPORT_DETAIL where TOTAL_ASSETS_AMOUNT is not null union
SELECT distinct
''TOTAL_LIA_AMOUNT'' as "name"
,to_char(TOTAL_LIA_AMOUNT) as "value"
 ,''6'' "type",''6''  "title" 
FROM TBL_DU_GAP_REPORT_DETAIL where TOTAL_LIA_AMOUNT is not null'
;
 END FNC_DU_GAP_GET_REPORT_INFO;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_DU_GAP;
--------------------------------------------------------
--  DDL for Table PKG_STATE_REPORT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_STATE_REPORT" 
AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  PROCEDURE PRC_STATE_REP_PROFILE_DETAIL(
      INPAR_REPORT IN NUMBER 
      ,INPAR_NOTIF_ID in NUMBER,
    OUTPAR_RES out varchar2);
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  PROCEDURE PRC_STATE_REPORT_PROFILE(
      INPAR_NAME                IN VARCHAR2 ,
      INPAR_DES                 IN VARCHAR2 ,
      INPAR_REF_USER            IN VARCHAR2 ,
      INPAR_STATUS              IN VARCHAR2 ,
      INPAR_INSERT_OR_UPDATE    IN VARCHAR2 ,
      inpar_ledger_profile      IN VARCHAR2,
      inpar_timing_profile      IN VARCHAR2,
      inpar_dep_profile         IN VARCHAR2,
      inpar_loan_profile        IN VARCHAR2,
      inpar_brn_profile         IN VARCHAR2,
      inpar_cus_profile         IN VARCHAR2,
      inpar_cur_profile         IN VARCHAR2,
      inpar_timing_profile_type IN VARCHAR2,
      INPAR_ID                  IN VARCHAR2 ,
      INPAR_TYPE                IN VARCHAR2 , -- manzoor riali,....
      OUTPAR_ID OUT VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION fnc_state_report_get_map(
      inpar_report IN VARCHAR2)
    RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION fnc_state_rep_get_map_detail(
      inpar_report IN VARCHAR2,
      inpar_state  IN VARCHAR2)
    RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/        
    PROCEDURE PRC_state_rep_DELETE_archive (
  INPAR_ID   IN VARCHAR2,
  inpar_version IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/ 
  FUNCTION FNC_state_rep_GET_INPUT_edit(
    inpar_report IN VARCHAR2 )
  RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_state_rep_GET_INPUT_time(
    inpar_report IN VARCHAR2 )
  RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/ 
  FUNCTION fnc_state_rep_get_map_archive(
      inpar_report IN VARCHAR2,
      inpar_version in varchar2)
    RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_state_rep_GET_detail_time(
    inpar_report IN VARCHAR2 )
  RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/ 
END PKG_STATE_REPORT;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_STATE_REPORT" 
AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_STATE_REP_PROFILE_DETAIL(
    INPAR_REPORT IN NUMBER ,
    INPAR_NOTIF_ID in NUMBER,
    OUTPAR_RES out varchar2)
AS
var_notif_id number;
var_version number;
var_version_notif number;
var_count number;

BEGIN
 

  PRC_REPORT_VALUE(INPAR_REPORT);
--  DELETE FROM TBL_STATE_REP_PROFILE_DETAIL WHERE ref_report= INPAR_REPORT;
--  COMMIT;

  --========== Fill REPREQ FOR ARCHIVE REPORT
  
  INSERT
INTO TBL_REPREQ
  (

    REF_REPORT_ID,
    REQ_DATE,
    STATUS,
    TYPE,
    CATEGORY
  )
  values
 (
 INPAR_REPORT
 ,sysdate
 ,1
 ,'composite'
  ,'province'
  );
  commit;
  
  select max(id) into var_version from TBL_REPREQ;
  --===========
  


--select COALESCE(sum(version),0) into var_version from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = INPAR_REPORT;


  INSERT INTO TBL_STATE_REP_PROFILE_DETAIL
    (
      VERSION,
      REF_REPORT,
      OUTPUT_BALANCE,
      INPUT_BALANCE,
      REF_STATE,
      TIMING
      
    )
  
  SELECT var_version,inpar_report,
    NVL(
    CASE
      WHEN SUM(BALANCE)<=0
      THEN ABS(SUM(BALANCE))
    END,0) AS output,
    NVL(
    CASE
      WHEN SUM(BALANCE)>0
      THEN ABS(SUM(BALANCE))
    END,0) AS input,
    REF_STA_ID,
    REF_TIMING_ID
  FROM TBL_VALUE_TEMP
  GROUP BY REF_STA_ID,
  REF_TIMING_ID,ref_modality_type;
  commit;
--else
--   INSERT INTO TBL_STATE_REP_PROFILE_DETAIL
--    (
--      VERSION,
--      REF_REPORT,
--      OUTPUT_BALANCE,
--      INPUT_BALANCE,
--      REF_STATE,
--      TIMING
--      )
--   
--  SELECT  (select max(version)+1 from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = INPAR_REPORT),inpar_report,
--    NVL(
--    CASE
--      WHEN SUM(BALANCE)<=0
--      THEN ABS(SUM(BALANCE))
--    END,0) AS output,
--    NVL(
--    CASE
--      WHEN SUM(BALANCE)>0
--      THEN ABS(SUM(BALANCE))
--    END,0) AS input,
--    REF_STA_ID,
--    REF_TIMING_ID
--  FROM TBL_VALUE_TEMP
--  GROUP BY REF_STA_ID,
--  REF_TIMING_ID;
--  commit;
--  END IF;
    
    select count(*) into var_count from TBL_STATE_REP_PROFILE_DETAIL where ref_report = inpar_report;
    
    if (var_count =0) then 
          INSERT INTO TBL_STATE_REP_PROFILE_DETAIL (
 VERSION
 ,REF_REPORT
 ,OUTPUT_BALANCE
 ,INPUT_BALANCE
 ,REF_STATE
 ,TIMING
)
 select * from  (select  
var_version as version,
inpar_report,
0 as out,0 as "in",1 from dual) a ,(select id as a from tbl_timing_profile_detail where ref_timing_profile =
(SELECT REF_PROFILE_TIME
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = inpar_report))b;
  commit;
  end if;
    
    
    INSERT INTO TBL_STATE_REP_PROFILE_DETAIL (
 VERSION
 ,REF_REPORT
 ,OUTPUT_BALANCE
 ,INPUT_BALANCE
 ,REF_STATE
 ,TIMING
) SELECT
 (
  SELECT
   MAX(VERSION)
  FROM TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = INPAR_REPORT
 )
 ,INPAR_REPORT
 ,0
 ,0
 ,S.STA_ID
 ,A.TIMING
FROM TBL_STATE S
 ,    (
  SELECT DISTINCT
   TIMING
  FROM TBL_STATE_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = INPAR_REPORT
   AND
    VERSION      = (
     SELECT
      MAX(VERSION)
     FROM TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT =INPAR_REPORT
    )
 ) A
WHERE S.STA_ID || A.TIMING NOT IN (
  SELECT
   REF_STATE || TIMING
  FROM TBL_STATE_REP_PROFILE_DETAIL
  ,    TBL_STATE
  WHERE REF_REPORT   = INPAR_REPORT
   AND
    VERSION      = (
     SELECT
      MAX(VERSION)
     FROM TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT =INPAR_REPORT
    )
 );
 commit;
 SELECT
      MAX(VERSION) into var_version_notif
     FROM TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT =INPAR_REPORT;
 
    --berozresani elanat

 PRC_NOTIFICATION(
  'update'
 ,INPAR_NOTIF_ID
 ,''
 ,''
 ,''
 ,'finished'
 ,0
 ,''
 ,0
 ,var_version_notif
 ,''
 ,'0'
 ,VAR_NOTIF_ID
 );   --khoroji alaki
  OUTPAR_RES := var_notif_id;
  
  

END PRC_STATE_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_STATE_REPORT_PROFILE(
    INPAR_NAME                IN VARCHAR2 ,
    INPAR_DES                 IN VARCHAR2 ,
    INPAR_REF_USER            IN VARCHAR2 ,
    INPAR_STATUS              IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE    IN VARCHAR2 ,
    inpar_ledger_profile      IN VARCHAR2,
    inpar_timing_profile      IN VARCHAR2,
    inpar_dep_profile         IN VARCHAR2,
    inpar_loan_profile        IN VARCHAR2,
    inpar_brn_profile         IN VARCHAR2,
    inpar_cus_profile         IN VARCHAR2,
    inpar_cur_profile         IN VARCHAR2,
    inpar_timing_profile_type IN VARCHAR2,
    INPAR_ID                  IN VARCHAR2 ,
    INPAR_TYPE                IN VARCHAR2 , -- manzoor riali,....
    OUTPAR_ID OUT VARCHAR2 )
AS
    var_ledger_profile      number;
    var_timing_profile      number;
    var_dep_profile         number;
    var_loan_profile        number;
    var_brn_profile         number;
    var_cus_profile         number;
    var_cur_profile         number;
BEGIN

select max(id) into  var_dep_profile from tbl_profile where upper(type)='TBL_DEPOSIT' and  h_id = inpar_dep_profile;
select max(id) into  var_loan_profile from tbl_profile where upper(type)='TBL_LOAN' and  h_id = inpar_loan_profile;
select max(id) into  var_brn_profile from tbl_profile where upper(type)='TBL_BRANCH' and  h_id = inpar_brn_profile;
select max(id) into  var_cur_profile from tbl_profile where upper(type)='TBL_CURRENCY' and  h_id = inpar_cur_profile;
select max(id) into  var_cus_profile from tbl_profile where upper(type)='TBL_CUSTOMER' and  h_id = inpar_cus_profile;
select max(id) into  var_timing_profile from TBL_TIMING_PROFILE where type in (1,2) and h_id = inpar_timing_profile;
select max(id) into  var_ledger_profile from TBL_LEDGER_PROFILE where upper(type)='TBL_LEDGER' and  h_id = inpar_ledger_profile;



  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_REPORT
      (
        NAME ,
        DES ,
        CREATE_DATE ,
        REF_USER ,
        STATUS ,
        CATEGORY ,
        TYPE,
        REF_LEDGER_PROFIEL,
        ref_timing_profile,
        REF_DEP_PROFILE,
        REF_LON_PROFILE,
        REF_BRN_PROFILE,
        REF_CUS_PROFILE,
        REF_CUR_PROFILE,
        TIMING_PROFILE_TYPE
      )
      VALUES
      (
        INPAR_NAME ,
        INPAR_DES ,
        SYSDATE ,
        INPAR_REF_USER ,
        INPAR_STATUS ,
        'province' ,
        INPAR_TYPE,
        var_ledger_profile ,
        var_timing_profile,
        var_dep_profile ,
        var_loan_profile ,
        var_brn_profile ,
        var_cus_profile ,
        var_cur_profile ,
        inpar_timing_profile_type
      );
    COMMIT;
    SELECT ID
    INTO OUTPAR_ID
    FROM TBL_REPORT
    WHERE CREATE_DATE =
      ( SELECT MAX(CREATE_DATE) FROM TBL_REPORT
      )
    AND ID =
      ( SELECT MAX(ID) FROM TBL_REPORT
      );
  ELSE
    UPDATE TBL_REPORT
    SET NAME              = INPAR_NAME ,
      DES                 = INPAR_DES ,
      REF_USER            = INPAR_REF_USER ,
      STATUS              = INPAR_STATUS ,
      TYPE                = INPAR_TYPE,
      REF_LEDGER_PROFIEL  = var_ledger_profile ,
      REF_TIMING_PROFILE  = var_timing_profile,
      REF_DEP_PROFILE     = var_dep_profile ,
      REF_LON_PROFILE     = var_loan_profile ,
      REF_BRN_PROFILE     = var_brn_profile ,
      REF_CUS_PROFILE     = var_cus_profile ,
      REF_CUR_PROFILE     = var_cur_profile ,
      timing_profile_type = inpar_timing_profile_type
    WHERE ID              = INPAR_ID;
    COMMIT;
  END IF;
  --=============
  --==============
END PRC_STATE_REPORT_PROFILE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION fnc_state_report_get_map(
    inpar_report IN VARCHAR2)
  RETURN VARCHAR2
AS
BEGIN
  RETURN 'select max(version) as version,ref_state,sum(GAP) as GAP,sum(INPUT_BALANCE) as INPUT_BALANCE,sum(OUTPUT_BALANCE) as OUTPUT_BALANCE,TIMING from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = '||inpar_report||' and version in (select max(version) from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = '||inpar_report||')  group by ref_report,ref_state,TIMING  ';
END fnc_state_report_get_map;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION fnc_state_rep_get_map_archive(
    inpar_report IN VARCHAR2,
    inpar_version in varchar2)
  RETURN VARCHAR2
AS
BEGIN
  RETURN 'select '||inpar_version||' "version" ,ref_state "hc-key",sum(GAP) "gap",sum(INPUT_BALANCE) "input",sum(OUTPUT_BALANCE) "output",TIMING "time" from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = '||inpar_report||' and version ='||inpar_version||' group by ref_report,ref_state,TIMING ';
END fnc_state_rep_get_map_archive;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/


FUNCTION fnc_state_rep_get_map_detail(
    inpar_report IN VARCHAR2,
    inpar_state  IN VARCHAR2)
  RETURN VARCHAR2
AS
BEGIN
  RETURN 'select version "version" ,ref_state "hc-key",GAP "gap",INPUT_BALANCE "input",OUTPUT_BALANCE "output",TIMING "time"  from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = '||inpar_report||' and REF_state = '||inpar_state||' version in (select max(version) from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = '||inpar_report||') ';
END fnc_state_rep_get_map_detail;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_state_rep_DELETE_archive (
  INPAR_ID   IN VARCHAR2,
  inpar_version IN VARCHAR2,
 OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_STATE_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID and VERSION = inpar_version;

  COMMIT;
 END PRC_state_rep_DELETE_archive;
 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/ 
 FUNCTION FNC_state_rep_GET_INPUT_edit(
    inpar_report IN VARCHAR2 )
  RETURN VARCHAR2
AS
  OUTPUT VARCHAR2(2000);
  VAR    VARCHAR2(2000);
BEGIN
  OUTPUT := '
SELECT
  NAME,
  DES,
  CREATE_DATE,
  REF_USER,
  STATUS,
  REF_LEDGER_PROFIEL,
  REF_TIMING_PROFILE,
  REF_DEP_PROFILE,
  REF_LON_PROFILE,
  REF_BRN_PROFILE,
  REF_CUS_PROFILE,
  REF_CUR_PROFILE,
  TYPE,
  CATEGORY,
  TIMING_PROFILE_TYPE
FROM TBL_REPORT where id = '||inpar_report||'' ;
  RETURN OUTPUT;
END FNC_state_rep_GET_INPUT_edit;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_state_rep_GET_INPUT_time(
    inpar_report IN VARCHAR2 )
  RETURN VARCHAR2
AS
  OUTPUT VARCHAR2(2000);
  VAR    VARCHAR2(2000);
BEGIN
  OUTPUT := '
    select id,TIMING from TBL_STATE_REP_PROFILE_DETAIL where ref_report = '||inpar_report||'' ;
  RETURN OUTPUT;
END FNC_state_rep_GET_INPUT_time;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_state_rep_GET_detail_time(
    inpar_report IN VARCHAR2 )
  RETURN VARCHAR2
AS
  OUTPUT VARCHAR2(2000);
  VAR    VARCHAR2(2000);
BEGIN

  select REF_PROFILE_TIME into VAR from tbl_report_profile where REF_REPORT = inpar_report;

  OUTPUT := '
    select id "id",period_name "name" from tbl_timing_profile_detail where ref_timing_profile = '||VAR||'' ;
  RETURN OUTPUT;
END FNC_state_rep_GET_detail_time;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_STATE_REPORT;
--------------------------------------------------------
--  DDL for Table PKG_STATE_REPORT
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_STATE_REPORT" 
AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  PROCEDURE PRC_STATE_REP_PROFILE_DETAIL(
      INPAR_REPORT IN NUMBER 
      ,INPAR_NOTIF_ID in NUMBER,
    OUTPAR_RES out varchar2);
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  PROCEDURE PRC_STATE_REPORT_PROFILE(
      INPAR_NAME                IN VARCHAR2 ,
      INPAR_DES                 IN VARCHAR2 ,
      INPAR_REF_USER            IN VARCHAR2 ,
      INPAR_STATUS              IN VARCHAR2 ,
      INPAR_INSERT_OR_UPDATE    IN VARCHAR2 ,
      inpar_ledger_profile      IN VARCHAR2,
      inpar_timing_profile      IN VARCHAR2,
      inpar_dep_profile         IN VARCHAR2,
      inpar_loan_profile        IN VARCHAR2,
      inpar_brn_profile         IN VARCHAR2,
      inpar_cus_profile         IN VARCHAR2,
      inpar_cur_profile         IN VARCHAR2,
      inpar_timing_profile_type IN VARCHAR2,
      INPAR_ID                  IN VARCHAR2 ,
      INPAR_TYPE                IN VARCHAR2 , -- manzoor riali,....
      OUTPAR_ID OUT VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION fnc_state_report_get_map(
      inpar_report IN VARCHAR2)
    RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION fnc_state_rep_get_map_detail(
      inpar_report IN VARCHAR2,
      inpar_state  IN VARCHAR2)
    RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/        
    PROCEDURE PRC_state_rep_DELETE_archive (
  INPAR_ID   IN VARCHAR2,
  inpar_version IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/ 
  FUNCTION FNC_state_rep_GET_INPUT_edit(
    inpar_report IN VARCHAR2 )
  RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_state_rep_GET_INPUT_time(
    inpar_report IN VARCHAR2 )
  RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/ 
  FUNCTION fnc_state_rep_get_map_archive(
      inpar_report IN VARCHAR2,
      inpar_version in varchar2)
    RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_state_rep_GET_detail_time(
    inpar_report IN VARCHAR2 )
  RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/ 
END PKG_STATE_REPORT;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_STATE_REPORT" 
AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_STATE_REP_PROFILE_DETAIL(
    INPAR_REPORT IN NUMBER ,
    INPAR_NOTIF_ID in NUMBER,
    OUTPAR_RES out varchar2)
AS
var_notif_id number;
var_version number;
var_version_notif number;
var_count number;

BEGIN
 

  PRC_REPORT_VALUE(INPAR_REPORT);
--  DELETE FROM TBL_STATE_REP_PROFILE_DETAIL WHERE ref_report= INPAR_REPORT;
--  COMMIT;

  --========== Fill REPREQ FOR ARCHIVE REPORT
  
  INSERT
INTO TBL_REPREQ
  (

    REF_REPORT_ID,
    REQ_DATE,
    STATUS,
    TYPE,
    CATEGORY
  )
  values
 (
 INPAR_REPORT
 ,sysdate
 ,1
 ,'composite'
  ,'province'
  );
  commit;
  
  select max(id) into var_version from TBL_REPREQ;
  --===========
  


--select COALESCE(sum(version),0) into var_version from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = INPAR_REPORT;


  INSERT INTO TBL_STATE_REP_PROFILE_DETAIL
    (
      VERSION,
      REF_REPORT,
      OUTPUT_BALANCE,
      INPUT_BALANCE,
      REF_STATE,
      TIMING
      
    )
  
  SELECT var_version,inpar_report,
    NVL(
    CASE
      WHEN SUM(BALANCE)<=0
      THEN ABS(SUM(BALANCE))
    END,0) AS output,
    NVL(
    CASE
      WHEN SUM(BALANCE)>0
      THEN ABS(SUM(BALANCE))
    END,0) AS input,
    REF_STA_ID,
    REF_TIMING_ID
  FROM TBL_VALUE_TEMP
  GROUP BY REF_STA_ID,
  REF_TIMING_ID,ref_modality_type;
  commit;
--else
--   INSERT INTO TBL_STATE_REP_PROFILE_DETAIL
--    (
--      VERSION,
--      REF_REPORT,
--      OUTPUT_BALANCE,
--      INPUT_BALANCE,
--      REF_STATE,
--      TIMING
--      )
--   
--  SELECT  (select max(version)+1 from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = INPAR_REPORT),inpar_report,
--    NVL(
--    CASE
--      WHEN SUM(BALANCE)<=0
--      THEN ABS(SUM(BALANCE))
--    END,0) AS output,
--    NVL(
--    CASE
--      WHEN SUM(BALANCE)>0
--      THEN ABS(SUM(BALANCE))
--    END,0) AS input,
--    REF_STA_ID,
--    REF_TIMING_ID
--  FROM TBL_VALUE_TEMP
--  GROUP BY REF_STA_ID,
--  REF_TIMING_ID;
--  commit;
--  END IF;
    
    select count(*) into var_count from TBL_STATE_REP_PROFILE_DETAIL where ref_report = inpar_report;
    
    if (var_count =0) then 
          INSERT INTO TBL_STATE_REP_PROFILE_DETAIL (
 VERSION
 ,REF_REPORT
 ,OUTPUT_BALANCE
 ,INPUT_BALANCE
 ,REF_STATE
 ,TIMING
)
 select * from  (select  
var_version as version,
inpar_report,
0 as out,0 as "in",1 from dual) a ,(select id as a from tbl_timing_profile_detail where ref_timing_profile =
(SELECT REF_PROFILE_TIME
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = inpar_report))b;
  commit;
  end if;
    
    
    INSERT INTO TBL_STATE_REP_PROFILE_DETAIL (
 VERSION
 ,REF_REPORT
 ,OUTPUT_BALANCE
 ,INPUT_BALANCE
 ,REF_STATE
 ,TIMING
) SELECT
 (
  SELECT
   MAX(VERSION)
  FROM TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = INPAR_REPORT
 )
 ,INPAR_REPORT
 ,0
 ,0
 ,S.STA_ID
 ,A.TIMING
FROM TBL_STATE S
 ,    (
  SELECT DISTINCT
   TIMING
  FROM TBL_STATE_REP_PROFILE_DETAIL
  WHERE REF_REPORT   = INPAR_REPORT
   AND
    VERSION      = (
     SELECT
      MAX(VERSION)
     FROM TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT =INPAR_REPORT
    )
 ) A
WHERE S.STA_ID || A.TIMING NOT IN (
  SELECT
   REF_STATE || TIMING
  FROM TBL_STATE_REP_PROFILE_DETAIL
  ,    TBL_STATE
  WHERE REF_REPORT   = INPAR_REPORT
   AND
    VERSION      = (
     SELECT
      MAX(VERSION)
     FROM TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT =INPAR_REPORT
    )
 );
 commit;
 SELECT
      MAX(VERSION) into var_version_notif
     FROM TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT =INPAR_REPORT;
 
    --berozresani elanat

 PRC_NOTIFICATION(
  'update'
 ,INPAR_NOTIF_ID
 ,''
 ,''
 ,''
 ,'finished'
 ,0
 ,''
 ,0
 ,var_version_notif
 ,''
 ,'0'
 ,VAR_NOTIF_ID
 );   --khoroji alaki
  OUTPAR_RES := var_notif_id;
  
  

END PRC_STATE_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_STATE_REPORT_PROFILE(
    INPAR_NAME                IN VARCHAR2 ,
    INPAR_DES                 IN VARCHAR2 ,
    INPAR_REF_USER            IN VARCHAR2 ,
    INPAR_STATUS              IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE    IN VARCHAR2 ,
    inpar_ledger_profile      IN VARCHAR2,
    inpar_timing_profile      IN VARCHAR2,
    inpar_dep_profile         IN VARCHAR2,
    inpar_loan_profile        IN VARCHAR2,
    inpar_brn_profile         IN VARCHAR2,
    inpar_cus_profile         IN VARCHAR2,
    inpar_cur_profile         IN VARCHAR2,
    inpar_timing_profile_type IN VARCHAR2,
    INPAR_ID                  IN VARCHAR2 ,
    INPAR_TYPE                IN VARCHAR2 , -- manzoor riali,....
    OUTPAR_ID OUT VARCHAR2 )
AS
    var_ledger_profile      number;
    var_timing_profile      number;
    var_dep_profile         number;
    var_loan_profile        number;
    var_brn_profile         number;
    var_cus_profile         number;
    var_cur_profile         number;
BEGIN

select max(id) into  var_dep_profile from tbl_profile where upper(type)='TBL_DEPOSIT' and  h_id = inpar_dep_profile;
select max(id) into  var_loan_profile from tbl_profile where upper(type)='TBL_LOAN' and  h_id = inpar_loan_profile;
select max(id) into  var_brn_profile from tbl_profile where upper(type)='TBL_BRANCH' and  h_id = inpar_brn_profile;
select max(id) into  var_cur_profile from tbl_profile where upper(type)='TBL_CURRENCY' and  h_id = inpar_cur_profile;
select max(id) into  var_cus_profile from tbl_profile where upper(type)='TBL_CUSTOMER' and  h_id = inpar_cus_profile;
select max(id) into  var_timing_profile from TBL_TIMING_PROFILE where type in (1,2) and h_id = inpar_timing_profile;
select max(id) into  var_ledger_profile from TBL_LEDGER_PROFILE where upper(type)='TBL_LEDGER' and  h_id = inpar_ledger_profile;



  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_REPORT
      (
        NAME ,
        DES ,
        CREATE_DATE ,
        REF_USER ,
        STATUS ,
        CATEGORY ,
        TYPE,
        REF_LEDGER_PROFIEL,
        ref_timing_profile,
        REF_DEP_PROFILE,
        REF_LON_PROFILE,
        REF_BRN_PROFILE,
        REF_CUS_PROFILE,
        REF_CUR_PROFILE,
        TIMING_PROFILE_TYPE
      )
      VALUES
      (
        INPAR_NAME ,
        INPAR_DES ,
        SYSDATE ,
        INPAR_REF_USER ,
        INPAR_STATUS ,
        'province' ,
        INPAR_TYPE,
        var_ledger_profile ,
        var_timing_profile,
        var_dep_profile ,
        var_loan_profile ,
        var_brn_profile ,
        var_cus_profile ,
        var_cur_profile ,
        inpar_timing_profile_type
      );
    COMMIT;
    SELECT ID
    INTO OUTPAR_ID
    FROM TBL_REPORT
    WHERE CREATE_DATE =
      ( SELECT MAX(CREATE_DATE) FROM TBL_REPORT
      )
    AND ID =
      ( SELECT MAX(ID) FROM TBL_REPORT
      );
  ELSE
    UPDATE TBL_REPORT
    SET NAME              = INPAR_NAME ,
      DES                 = INPAR_DES ,
      REF_USER            = INPAR_REF_USER ,
      STATUS              = INPAR_STATUS ,
      TYPE                = INPAR_TYPE,
      REF_LEDGER_PROFIEL  = var_ledger_profile ,
      REF_TIMING_PROFILE  = var_timing_profile,
      REF_DEP_PROFILE     = var_dep_profile ,
      REF_LON_PROFILE     = var_loan_profile ,
      REF_BRN_PROFILE     = var_brn_profile ,
      REF_CUS_PROFILE     = var_cus_profile ,
      REF_CUR_PROFILE     = var_cur_profile ,
      timing_profile_type = inpar_timing_profile_type
    WHERE ID              = INPAR_ID;
    COMMIT;
  END IF;
  --=============
  --==============
END PRC_STATE_REPORT_PROFILE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION fnc_state_report_get_map(
    inpar_report IN VARCHAR2)
  RETURN VARCHAR2
AS
BEGIN
  RETURN 'select max(version) as version,ref_state,sum(GAP) as GAP,sum(INPUT_BALANCE) as INPUT_BALANCE,sum(OUTPUT_BALANCE) as OUTPUT_BALANCE,TIMING from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = '||inpar_report||' and version in (select max(version) from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = '||inpar_report||')  group by ref_report,ref_state,TIMING  ';
END fnc_state_report_get_map;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION fnc_state_rep_get_map_archive(
    inpar_report IN VARCHAR2,
    inpar_version in varchar2)
  RETURN VARCHAR2
AS
BEGIN
  RETURN 'select '||inpar_version||' "version" ,ref_state "hc-key",sum(GAP) "gap",sum(INPUT_BALANCE) "input",sum(OUTPUT_BALANCE) "output",TIMING "time" from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = '||inpar_report||' and version ='||inpar_version||' group by ref_report,ref_state,TIMING ';
END fnc_state_rep_get_map_archive;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/


FUNCTION fnc_state_rep_get_map_detail(
    inpar_report IN VARCHAR2,
    inpar_state  IN VARCHAR2)
  RETURN VARCHAR2
AS
BEGIN
  RETURN 'select version "version" ,ref_state "hc-key",GAP "gap",INPUT_BALANCE "input",OUTPUT_BALANCE "output",TIMING "time"  from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = '||inpar_report||' and REF_state = '||inpar_state||' version in (select max(version) from TBL_STATE_REP_PROFILE_DETAIL where REF_REPORT = '||inpar_report||') ';
END fnc_state_rep_get_map_detail;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_state_rep_DELETE_archive (
  INPAR_ID   IN VARCHAR2,
  inpar_version IN VARCHAR2,
 OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_STATE_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID and VERSION = inpar_version;

  COMMIT;
 END PRC_state_rep_DELETE_archive;
 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/ 
 FUNCTION FNC_state_rep_GET_INPUT_edit(
    inpar_report IN VARCHAR2 )
  RETURN VARCHAR2
AS
  OUTPUT VARCHAR2(2000);
  VAR    VARCHAR2(2000);
BEGIN
  OUTPUT := '
SELECT
  NAME,
  DES,
  CREATE_DATE,
  REF_USER,
  STATUS,
  REF_LEDGER_PROFIEL,
  REF_TIMING_PROFILE,
  REF_DEP_PROFILE,
  REF_LON_PROFILE,
  REF_BRN_PROFILE,
  REF_CUS_PROFILE,
  REF_CUR_PROFILE,
  TYPE,
  CATEGORY,
  TIMING_PROFILE_TYPE
FROM TBL_REPORT where id = '||inpar_report||'' ;
  RETURN OUTPUT;
END FNC_state_rep_GET_INPUT_edit;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_state_rep_GET_INPUT_time(
    inpar_report IN VARCHAR2 )
  RETURN VARCHAR2
AS
  OUTPUT VARCHAR2(2000);
  VAR    VARCHAR2(2000);
BEGIN
  OUTPUT := '
    select id,TIMING from TBL_STATE_REP_PROFILE_DETAIL where ref_report = '||inpar_report||'' ;
  RETURN OUTPUT;
END FNC_state_rep_GET_INPUT_time;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_state_rep_GET_detail_time(
    inpar_report IN VARCHAR2 )
  RETURN VARCHAR2
AS
  OUTPUT VARCHAR2(2000);
  VAR    VARCHAR2(2000);
BEGIN

  select REF_PROFILE_TIME into VAR from tbl_report_profile where REF_REPORT = inpar_report;

  OUTPUT := '
    select id "id",period_name "name" from tbl_timing_profile_detail where ref_timing_profile = '||VAR||'' ;
  RETURN OUTPUT;
END FNC_state_rep_GET_detail_time;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_STATE_REPORT;
--------------------------------------------------------
--  DDL for Table PKG_JOB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_JOB" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_JOB_PROFILE (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_CREATED_BY         IN VARCHAR2
 ,INPAR_RUN_TIME           IN VARCHAR2
 ,INPAR_IS_ENABLED         IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_IS_YEARLY          IN VARCHAR2
 ,INPAR_JOB_YEARS          IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_JOB_PROFILE_DETAIL (
  INPAR_JOB_REPORTS   IN VARCHAR2
 ,INPAR_JOB_DATE      IN VARCHAR2
 ,INPAR_ID            IN VARCHAR2
 ,OUTPAR_ID           OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_GET_PROFILE_LIST RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_GET_PROFILE ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_STORE_DATE ( INPAR_REPORT IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_JOB_DELETE_PROFILE (
  INPAR_ID    IN VARCHAR2
 ,OUTPAR_ID   OUT VARCHAR2
 );

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_GET_JOB_REPORTS ( INPAR_REPORT IN VARCHAR2 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_GET_JOB_DATE ( INPAR_REPORT IN VARCHAR2 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_STATUS ( INPAR_REPORT IN VARCHAR2,INPAR_STATUS  IN VARCHAR2) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_create_body ( INPAR_REPORT IN VARCHAR2 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_JOB;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_JOB" 
AS
  /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Category:2
  Description:
  */
  /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_JOB_DELETE_PROFILE(
    INPAR_ID IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS
BEGIN
  /*disable job*/
  /*delete job */
  DELETE
  FROM TBL_JOB_PROFILE
  WHERE ID = INPAR_ID;
  COMMIT;
  OUTPAR_ID := 1;
END PRC_JOB_DELETE_PROFILE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_JOB_PROFILE(
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_CREATED_BY       IN VARCHAR2 ,
    INPAR_RUN_TIME         IN VARCHAR2 ,
    INPAR_IS_ENABLED       IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    INPAR_IS_YEARLY        IN VARCHAR2 ,
    INPAR_JOB_YEARS        IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS
BEGIN
  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_JOB_PROFILE
      (
        NAME ,
        DESCRIPTION ,
        CREATE_DATE ,
        RUN_TIME ,
        CREATED_BY ,
        IS_ENABLE ,
        IS_YEARLY ,
        JOB_YEARS
      )
      VALUES
      (
        INPAR_NAME ,
        INPAR_DES ,
        SYSDATE ,
        INPAR_RUN_TIME ,
        INPAR_CREATED_BY ,
        INPAR_IS_ENABLED ,
        INPAR_IS_YEARLY ,
        INPAR_JOB_YEARS
      );
    COMMIT;
    SELECT ID
    INTO OUTPAR_ID
    FROM TBL_JOB_PROFILE
    WHERE CREATE_DATE =
      ( SELECT MAX(CREATE_DATE) FROM TBL_JOB_PROFILE
      )
    AND ID =
      ( SELECT MAX(ID) FROM TBL_JOB_PROFILE
      );
  ELSE
    /* DBMS_SCHEDULER.DISABLE(INPAR_ID);*/
    /* remove_job bayad ezafe shvad;*/
    UPDATE TBL_JOB_PROFILE
    SET NAME      = INPAR_NAME ,
      DESCRIPTION = INPAR_DES ,
      CREATE_DATE = SYSDATE ,
      RUN_TIME    = INPAR_RUN_TIME ,
      CREATED_BY  = INPAR_CREATED_BY ,
      IS_ENABLE   = INPAR_IS_ENABLED ,
      IS_YEARLY   = INPAR_IS_YEARLY ,
      JOB_YEARS   = INPAR_JOB_YEARS
    WHERE ID      = INPAR_ID;
    COMMIT;
    /*   DELETE FROM TBL_JOB_PROFILE WHERE ID   = INPAR_ID;*/
    /**/
    /*   COMMIT;*/
    /*   INSERT INTO TBL_JOB_PROFILE (*/
    /*    NAME*/
    /*   ,DESCRIPTION*/
    /*   ,CREATE_DATE*/
    /*   ,RUN_TIME*/
    /*   ,CREATED_BY*/
    /*   ,IS_ENABLE*/
    /*   ,IS_YEARLY*/
    /*   ,JOB_YEARS*/
    /*   ) VALUES (*/
    /*    INPAR_NAME*/
    /*   ,INPAR_DES*/
    /*   ,SYSDATE*/
    /*   ,INPAR_RUN_TIME*/
    /*   ,INPAR_CREATED_BY*/
    /*   ,INPAR_IS_ENABLED*/
    /*   ,INPAR_IS_YEARLY  */
    /*   ,INPAR_JOB_YEARS */
    /*   );*/
    /**/
    /*   COMMIT;*/
    /*   SELECT*/
    /*    ID*/
    /*   INTO*/
    /*    OUTPAR_ID*/
    /*   FROM TBL_JOB_PROFILE*/
    /*   WHERE CREATE_DATE   = (*/
    /*      SELECT*/
    /*       MAX(CREATE_DATE)*/
    /*      FROM TBL_JOB_PROFILE*/
    /*     )*/
    /*    AND*/
    /*     ID            = (*/
    /*      SELECT*/
    /*       MAX(ID)*/
    /*      FROM TBL_JOB_PROFILE*/
    /*     );*/
  END IF;
  /* sakhte jobe jadid*/
END PRC_JOB_PROFILE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_JOB_PROFILE_DETAIL(
    INPAR_JOB_REPORTS IN VARCHAR2 ,
    INPAR_JOB_DATE    IN VARCHAR2 ,
    INPAR_ID          IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS
  var_name     VARCHAR2(2000);
  var_name_job VARCHAR2(2000);
  var_dec      VARCHAR2(20000);
  var_job_date VARCHAR2(20000);
  var_schedule VARCHAR2(32000);
  var_job      VARCHAR2(32000);
  var_count    NUMBER :=0;
    var_count_job    NUMBER :=0;

BEGIN
  UPDATE TBL_JOB_PROFILE
  SET JOB_REPORTS = INPAR_JOB_REPORTS ,
    JOB_DATE      = REPLACE(INPAR_JOB_DATE,'NaN',1)
  WHERE ID        = INPAR_ID;
  COMMIT;
  SELECT 'sch_'||id INTO var_name FROM TBL_JOB_PROFILE WHERE id = inpar_id;
  SELECT 'job_'||id INTO var_name_job FROM TBL_JOB_PROFILE WHERE id = inpar_id;
  SELECT DESCRIPTION INTO var_dec FROM TBL_JOB_PROFILE WHERE id = inpar_id;
  var_job_date :=REPLACE(INPAR_JOB_DATE,'NaN',1);
  SELECT COUNT(OBJECT_NAME)
  INTO var_count
  FROM all_objects
  WHERE owner     ='PRAGG'
  AND OBJECT_TYPE ='SCHEDULE'
  AND OBJECT_NAME =upper(var_name);
  
  var_schedule := 'begin DBMS_SCHEDULER.CREATE_SCHEDULE ( repeat_interval => '''||var_job_date||''', comments =>'''|| var_dec||''', schedule_name => '''||var_name||'''); end;';
  SELECT COUNT(OBJECT_NAME)
  INTO var_count_job
  FROM all_objects
  WHERE owner     ='PRAGG'
  AND OBJECT_TYPE ='JOB'
  AND OBJECT_NAME =upper(var_name_job);
  IF var_count_job    >0 THEN
    dbms_scheduler.drop_job(job_name => upper(var_name_job),
                                defer => false,
                                force => true);
  END IF;
IF var_count    >0 THEN
    BEGIN
      DBMS_SCHEDULER.DROP_SCHEDULE(schedule_name => 'PRAGG.'||var_name, force => false);
    END;
  END IF;
  EXECUTE IMMEDIATE var_schedule;

  var_job:='  
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
job_name => ''PRAGG.'||var_name_job||''',            
schedule_name => ''PRAGG.'||var_name||''',            
job_type => ''PLSQL_BLOCK'',            
job_action => '''||FNC_JOB_create_body(INPAR_ID)||''',            
number_of_arguments => 0,            
enabled => FALSE,            
auto_drop => FALSE,                           
comments => '''||var_dec||''');                   

DBMS_SCHEDULER.SET_ATTRIBUTE(
name => ''PRAGG.'||var_name_job||''',              
attribute => ''logging_level'', value => DBMS_SCHEDULER.LOGGING_OFF);                

DBMS_SCHEDULER.enable(
name => ''PRAGG.'||var_name_job||''');
END;';
 EXECUTE IMMEDIATE var_job;
  OUTPAR_ID := inpar_id;
END PRC_JOB_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_GET_PROFILE_LIST
  RETURN VARCHAR2
AS
BEGIN
  RETURN ' 
SELECT ID as "id",  
NAME as "name",  
DESCRIPTION as "description",  
CREATE_DATE as "createDate",  
CREATED_BY as "createBy"
FROM TBL_JOB_PROFILE ' ;
END FNC_JOB_GET_PROFILE_LIST;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_GET_PROFILE(
    INPAR_ID IN VARCHAR2 )
  RETURN VARCHAR2
AS
BEGIN
  RETURN 'SELECT ID as "id",  
NAME as "name",  
DESCRIPTION as "description",  
CREATE_DATE as "createDate",  
CREATED_BY as "createBy",  
is_yearly as "isYearly",  
job_years as "years",  
run_time as "runTime"
FROM TBL_JOB_PROFILE where id = ''' || INPAR_ID || '''';
END FNC_JOB_GET_PROFILE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_STORE_DATE(
    INPAR_REPORT IN VARCHAR2 )
  RETURN VARCHAR2
AS
  VAR_QUERY  VARCHAR2(30000);
  VAR_QUERY2 VARCHAR2(30000);
  NUMBER_ONE NUMBER;
  NUMBER_TWO NUMBER;
  VAR_RETURN VARCHAR2(30000);
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  EXECUTE IMMEDIATE 'alter session set nls_date_format=''RRRRMMDD''';
  DELETE FROM TBL_JOB_STORE_DATE WHERE REF_REPORT = INPAR_REPORT;
  SELECT JOB_DATE INTO VAR_QUERY FROM TBL_JOB_PROFILE WHERE ID = INPAR_REPORT;
  IF (VAR_QUERY IS NOT NULL)THEN
    SELECT REGEXP_INSTR(VAR_QUERY,'BYDATE') + 7 INTO NUMBER_ONE FROM DUAL;
    SELECT REGEXP_INSTR(VAR_QUERY,'BYHOUR') - 1 INTO NUMBER_TWO FROM DUAL;
    SELECT SUBSTR( VAR_QUERY ,NUMBER_ONE ,NUMBER_TWO - NUMBER_ONE )
    INTO VAR_RETURN
    FROM DUAL;
    SELECT 'insert all '
      || LISTAGG('into tbl_job_store_date (REF_REPORT,JOB_DATE) values( '
      || INPAR_REPORT
      || ',to_char(to_date(''2017'
      || REGEXP_SUBSTR( VAR_RETURN ,'[^,]+' ,1 ,LEVEL )
      || ''',''yyyymmdd''),''yyyy-mm-dd'',''nls_calendar=persian'')) ',' ') WITHIN GROUP(
    ORDER BY 'into tbl_job_store_date (REF_REPORT,JOB_DATE) values( '
      || INPAR_REPORT
      || ',to_char(to_date(''2017'
      || REGEXP_SUBSTR( VAR_RETURN ,'[^,]+' ,1 ,LEVEL )
      || ''',''yyyymmdd''),''yyyy-mm-dd'',''nls_calendar=persian'')) ')
      || ' select * from dual'
    INTO VAR_QUERY2
    FROM DUAL
      CONNECT BY REGEXP_SUBSTR( VAR_RETURN ,'[^,]+' ,1 ,LEVEL ) IS NOT NULL;
    EXECUTE IMMEDIATE 'begin ' || VAR_QUERY2 || '; end;';
    COMMIT;
    UPDATE tbl_job_store_date
    SET job_date     = REPLACE(job_date, '1395','1396')
    WHERE ref_report =INPAR_REPORT;
    COMMIT;
  ELSE
    NULL;
    COMMIT;
  END IF;
  RETURN 1;
END FNC_JOB_STORE_DATE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_GET_JOB_REPORTS(
    INPAR_REPORT IN VARCHAR2 )
  RETURN VARCHAR2
AS
  VAR  VARCHAR2(30000);
  VAR1 VARCHAR2(30000);
BEGIN
  SELECT JOB_REPORTS INTO VAR1 FROM tbl_job_profile WHERE ID = INPAR_REPORT ;
  VAR := 'select id "reportId",TYPE "reportType",CATEGORY "category",name "reportName" from tbl_report where id in ( select regexp_substr('''||VAR1||''',''[^,]+'', 1, level) from dual     
connect by regexp_substr('''||VAR1||''', ''[^,]+'', 1, level) is not null)';
  RETURN VAR;
END FNC_JOB_GET_JOB_REPORTS;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_GET_JOB_DATE(
    INPAR_REPORT IN VARCHAR2 )
  RETURN VARCHAR2
AS
  VAR VARCHAR2(30000);
BEGIN
  VAR := FNC_JOB_STORE_DATE(INPAR_REPORT);
  VAR := 'SELECT 
JOB_DATE "date"
FROM TBL_JOB_STORE_DATE WHERE REF_REPORT  =' || INPAR_REPORT || ' ';
  RETURN VAR;
END FNC_JOB_GET_JOB_DATE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_STATUS(
    INPAR_REPORT IN VARCHAR2,
    INPAR_STATUS IN VARCHAR2)
  RETURN VARCHAR2
AS
  VAR VARCHAR2(30000);
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  UPDATE tbl_job_profile SET IS_ENABLE = INPAR_STATUS WHERE ID =INPAR_REPORT;
  COMMIT;
  RETURN 1;
END FNC_JOB_STATUS;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_create_body(
    INPAR_REPORT IN VARCHAR2 )
  RETURN VARCHAR2
AS
  var_notif      NUMBER;
  var_reports    VARCHAR2(20000);
  var_type       VARCHAR2(50);
  var_cat        VARCHAR2(50);
  var_name       VARCHAR2(100);
  var_out        VARCHAR2(2000);
  var_job_action VARCHAR2(32000);
BEGIN
  SELECT JOB_REPORTS
  INTO var_reports
  FROM TBL_JOB_PROFILE
  WHERE id       = INPAR_REPORT;
  var_job_action:= 'declare   var_notif   NUMBER; var_out VARCHAR2(2000); begin ';
  FOR i IN
  (SELECT regexp_substr(var_reports,'[^,]+', 1, level) AS a
  FROM dual
    CONNECT BY regexp_substr(var_reports, '[^,]+', 1, level) IS NOT NULL
  )
  LOOP
    SELECT type,
      category,
      name
    INTO var_type,
      var_cat,
      var_name
    FROM tbl_report
    WHERE id         = i.a;
    IF ( var_cat     ='gap'  ) THEN
      var_job_action:=var_job_action ||' PRC_NOTIFICATION(''''insert'''','''''''',''''normal'''',''''lug'''','''''||var_name||''''',''''progress'''',''''job'''',''''gap/rial'''','||i.a||','''''''','''''''',var_notif);      
PRC_CREATE_REPORT_REQUEST('||i.a||',''''job'''',var_notif,var_out);';
    END IF;
    IF ( var_cat ='liquidity') THEN
      var_job_action:=var_job_action ||' PRC_NOTIFICATION(''''insert'''','''''''',''''normal'''',''''lug'''','''''||var_name||''''',''''progress'''',''''job'''',''''liquidity/rial'''','||i.a||','''''''','''''''',var_notif);      
PRC_CREATE_REPORT_REQUEST('||i.a||',''''job'''',var_notif,var_out);';
    END IF;
    IF ( var_cat     ='province') THEN
      var_job_action:=var_job_action ||' PRC_NOTIFICATION(''''insert'''','''''''',''''normal'''',''''province'''','''''||var_name||''''',''''progress'''',''''job'''',''''province/composite'''','||i.a||','''''''','''''''',var_notif);      
PKG_STATE_REPORT.PRC_STATE_REP_PROFILE_DETAIL('''''||i.a||''''',var_notif,var_out);';
    END IF;
  END LOOP;
  var_job_action:=var_job_action ||'end;';
  RETURN var_job_action;
END FNC_JOB_create_body;
END PKG_JOB;
--------------------------------------------------------
--  DDL for Table PKG_JOB
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_JOB" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_JOB_PROFILE (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_CREATED_BY         IN VARCHAR2
 ,INPAR_RUN_TIME           IN VARCHAR2
 ,INPAR_IS_ENABLED         IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_IS_YEARLY          IN VARCHAR2
 ,INPAR_JOB_YEARS          IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_JOB_PROFILE_DETAIL (
  INPAR_JOB_REPORTS   IN VARCHAR2
 ,INPAR_JOB_DATE      IN VARCHAR2
 ,INPAR_ID            IN VARCHAR2
 ,OUTPAR_ID           OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_GET_PROFILE_LIST RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_GET_PROFILE ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_STORE_DATE ( INPAR_REPORT IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_JOB_DELETE_PROFILE (
  INPAR_ID    IN VARCHAR2
 ,OUTPAR_ID   OUT VARCHAR2
 );

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_GET_JOB_REPORTS ( INPAR_REPORT IN VARCHAR2 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_GET_JOB_DATE ( INPAR_REPORT IN VARCHAR2 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_STATUS ( INPAR_REPORT IN VARCHAR2,INPAR_STATUS  IN VARCHAR2) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_JOB_create_body ( INPAR_REPORT IN VARCHAR2 ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_JOB;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_JOB" 
AS
  /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Category:2
  Description:
  */
  /*---------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_JOB_DELETE_PROFILE(
    INPAR_ID IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS
BEGIN
  /*disable job*/
  /*delete job */
  DELETE
  FROM TBL_JOB_PROFILE
  WHERE ID = INPAR_ID;
  COMMIT;
  OUTPAR_ID := 1;
END PRC_JOB_DELETE_PROFILE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_JOB_PROFILE(
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_CREATED_BY       IN VARCHAR2 ,
    INPAR_RUN_TIME         IN VARCHAR2 ,
    INPAR_IS_ENABLED       IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    INPAR_IS_YEARLY        IN VARCHAR2 ,
    INPAR_JOB_YEARS        IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS
BEGIN
  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_JOB_PROFILE
      (
        NAME ,
        DESCRIPTION ,
        CREATE_DATE ,
        RUN_TIME ,
        CREATED_BY ,
        IS_ENABLE ,
        IS_YEARLY ,
        JOB_YEARS
      )
      VALUES
      (
        INPAR_NAME ,
        INPAR_DES ,
        SYSDATE ,
        INPAR_RUN_TIME ,
        INPAR_CREATED_BY ,
        INPAR_IS_ENABLED ,
        INPAR_IS_YEARLY ,
        INPAR_JOB_YEARS
      );
    COMMIT;
    SELECT ID
    INTO OUTPAR_ID
    FROM TBL_JOB_PROFILE
    WHERE CREATE_DATE =
      ( SELECT MAX(CREATE_DATE) FROM TBL_JOB_PROFILE
      )
    AND ID =
      ( SELECT MAX(ID) FROM TBL_JOB_PROFILE
      );
  ELSE
    /* DBMS_SCHEDULER.DISABLE(INPAR_ID);*/
    /* remove_job bayad ezafe shvad;*/
    UPDATE TBL_JOB_PROFILE
    SET NAME      = INPAR_NAME ,
      DESCRIPTION = INPAR_DES ,
      CREATE_DATE = SYSDATE ,
      RUN_TIME    = INPAR_RUN_TIME ,
      CREATED_BY  = INPAR_CREATED_BY ,
      IS_ENABLE   = INPAR_IS_ENABLED ,
      IS_YEARLY   = INPAR_IS_YEARLY ,
      JOB_YEARS   = INPAR_JOB_YEARS
    WHERE ID      = INPAR_ID;
    COMMIT;
    /*   DELETE FROM TBL_JOB_PROFILE WHERE ID   = INPAR_ID;*/
    /**/
    /*   COMMIT;*/
    /*   INSERT INTO TBL_JOB_PROFILE (*/
    /*    NAME*/
    /*   ,DESCRIPTION*/
    /*   ,CREATE_DATE*/
    /*   ,RUN_TIME*/
    /*   ,CREATED_BY*/
    /*   ,IS_ENABLE*/
    /*   ,IS_YEARLY*/
    /*   ,JOB_YEARS*/
    /*   ) VALUES (*/
    /*    INPAR_NAME*/
    /*   ,INPAR_DES*/
    /*   ,SYSDATE*/
    /*   ,INPAR_RUN_TIME*/
    /*   ,INPAR_CREATED_BY*/
    /*   ,INPAR_IS_ENABLED*/
    /*   ,INPAR_IS_YEARLY  */
    /*   ,INPAR_JOB_YEARS */
    /*   );*/
    /**/
    /*   COMMIT;*/
    /*   SELECT*/
    /*    ID*/
    /*   INTO*/
    /*    OUTPAR_ID*/
    /*   FROM TBL_JOB_PROFILE*/
    /*   WHERE CREATE_DATE   = (*/
    /*      SELECT*/
    /*       MAX(CREATE_DATE)*/
    /*      FROM TBL_JOB_PROFILE*/
    /*     )*/
    /*    AND*/
    /*     ID            = (*/
    /*      SELECT*/
    /*       MAX(ID)*/
    /*      FROM TBL_JOB_PROFILE*/
    /*     );*/
  END IF;
  /* sakhte jobe jadid*/
END PRC_JOB_PROFILE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_JOB_PROFILE_DETAIL(
    INPAR_JOB_REPORTS IN VARCHAR2 ,
    INPAR_JOB_DATE    IN VARCHAR2 ,
    INPAR_ID          IN VARCHAR2 ,
    OUTPAR_ID OUT VARCHAR2 )
AS
  var_name     VARCHAR2(2000);
  var_name_job VARCHAR2(2000);
  var_dec      VARCHAR2(20000);
  var_job_date VARCHAR2(20000);
  var_schedule VARCHAR2(32000);
  var_job      VARCHAR2(32000);
  var_count    NUMBER :=0;
    var_count_job    NUMBER :=0;

BEGIN
  UPDATE TBL_JOB_PROFILE
  SET JOB_REPORTS = INPAR_JOB_REPORTS ,
    JOB_DATE      = REPLACE(INPAR_JOB_DATE,'NaN',1)
  WHERE ID        = INPAR_ID;
  COMMIT;
  SELECT 'sch_'||id INTO var_name FROM TBL_JOB_PROFILE WHERE id = inpar_id;
  SELECT 'job_'||id INTO var_name_job FROM TBL_JOB_PROFILE WHERE id = inpar_id;
  SELECT DESCRIPTION INTO var_dec FROM TBL_JOB_PROFILE WHERE id = inpar_id;
  var_job_date :=REPLACE(INPAR_JOB_DATE,'NaN',1);
  SELECT COUNT(OBJECT_NAME)
  INTO var_count
  FROM all_objects
  WHERE owner     ='PRAGG'
  AND OBJECT_TYPE ='SCHEDULE'
  AND OBJECT_NAME =upper(var_name);
  
  var_schedule := 'begin DBMS_SCHEDULER.CREATE_SCHEDULE ( repeat_interval => '''||var_job_date||''', comments =>'''|| var_dec||''', schedule_name => '''||var_name||'''); end;';
  SELECT COUNT(OBJECT_NAME)
  INTO var_count_job
  FROM all_objects
  WHERE owner     ='PRAGG'
  AND OBJECT_TYPE ='JOB'
  AND OBJECT_NAME =upper(var_name_job);
  IF var_count_job    >0 THEN
    dbms_scheduler.drop_job(job_name => upper(var_name_job),
                                defer => false,
                                force => true);
  END IF;
IF var_count    >0 THEN
    BEGIN
      DBMS_SCHEDULER.DROP_SCHEDULE(schedule_name => 'PRAGG.'||var_name, force => false);
    END;
  END IF;
  EXECUTE IMMEDIATE var_schedule;

  var_job:='  
BEGIN
DBMS_SCHEDULER.CREATE_JOB (
job_name => ''PRAGG.'||var_name_job||''',            
schedule_name => ''PRAGG.'||var_name||''',            
job_type => ''PLSQL_BLOCK'',            
job_action => '''||FNC_JOB_create_body(INPAR_ID)||''',            
number_of_arguments => 0,            
enabled => FALSE,            
auto_drop => FALSE,                           
comments => '''||var_dec||''');                   

DBMS_SCHEDULER.SET_ATTRIBUTE(
name => ''PRAGG.'||var_name_job||''',              
attribute => ''logging_level'', value => DBMS_SCHEDULER.LOGGING_OFF);                

DBMS_SCHEDULER.enable(
name => ''PRAGG.'||var_name_job||''');
END;';
 EXECUTE IMMEDIATE var_job;
  OUTPAR_ID := inpar_id;
END PRC_JOB_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_GET_PROFILE_LIST
  RETURN VARCHAR2
AS
BEGIN
  RETURN ' 
SELECT ID as "id",  
NAME as "name",  
DESCRIPTION as "description",  
CREATE_DATE as "createDate",  
CREATED_BY as "createBy"
FROM TBL_JOB_PROFILE ' ;
END FNC_JOB_GET_PROFILE_LIST;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_GET_PROFILE(
    INPAR_ID IN VARCHAR2 )
  RETURN VARCHAR2
AS
BEGIN
  RETURN 'SELECT ID as "id",  
NAME as "name",  
DESCRIPTION as "description",  
CREATE_DATE as "createDate",  
CREATED_BY as "createBy",  
is_yearly as "isYearly",  
job_years as "years",  
run_time as "runTime"
FROM TBL_JOB_PROFILE where id = ''' || INPAR_ID || '''';
END FNC_JOB_GET_PROFILE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_STORE_DATE(
    INPAR_REPORT IN VARCHAR2 )
  RETURN VARCHAR2
AS
  VAR_QUERY  VARCHAR2(30000);
  VAR_QUERY2 VARCHAR2(30000);
  NUMBER_ONE NUMBER;
  NUMBER_TWO NUMBER;
  VAR_RETURN VARCHAR2(30000);
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  EXECUTE IMMEDIATE 'alter session set nls_date_format=''RRRRMMDD''';
  DELETE FROM TBL_JOB_STORE_DATE WHERE REF_REPORT = INPAR_REPORT;
  SELECT JOB_DATE INTO VAR_QUERY FROM TBL_JOB_PROFILE WHERE ID = INPAR_REPORT;
  IF (VAR_QUERY IS NOT NULL)THEN
    SELECT REGEXP_INSTR(VAR_QUERY,'BYDATE') + 7 INTO NUMBER_ONE FROM DUAL;
    SELECT REGEXP_INSTR(VAR_QUERY,'BYHOUR') - 1 INTO NUMBER_TWO FROM DUAL;
    SELECT SUBSTR( VAR_QUERY ,NUMBER_ONE ,NUMBER_TWO - NUMBER_ONE )
    INTO VAR_RETURN
    FROM DUAL;
    SELECT 'insert all '
      || LISTAGG('into tbl_job_store_date (REF_REPORT,JOB_DATE) values( '
      || INPAR_REPORT
      || ',to_char(to_date(''2017'
      || REGEXP_SUBSTR( VAR_RETURN ,'[^,]+' ,1 ,LEVEL )
      || ''',''yyyymmdd''),''yyyy-mm-dd'',''nls_calendar=persian'')) ',' ') WITHIN GROUP(
    ORDER BY 'into tbl_job_store_date (REF_REPORT,JOB_DATE) values( '
      || INPAR_REPORT
      || ',to_char(to_date(''2017'
      || REGEXP_SUBSTR( VAR_RETURN ,'[^,]+' ,1 ,LEVEL )
      || ''',''yyyymmdd''),''yyyy-mm-dd'',''nls_calendar=persian'')) ')
      || ' select * from dual'
    INTO VAR_QUERY2
    FROM DUAL
      CONNECT BY REGEXP_SUBSTR( VAR_RETURN ,'[^,]+' ,1 ,LEVEL ) IS NOT NULL;
    EXECUTE IMMEDIATE 'begin ' || VAR_QUERY2 || '; end;';
    COMMIT;
    UPDATE tbl_job_store_date
    SET job_date     = REPLACE(job_date, '1395','1396')
    WHERE ref_report =INPAR_REPORT;
    COMMIT;
  ELSE
    NULL;
    COMMIT;
  END IF;
  RETURN 1;
END FNC_JOB_STORE_DATE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_GET_JOB_REPORTS(
    INPAR_REPORT IN VARCHAR2 )
  RETURN VARCHAR2
AS
  VAR  VARCHAR2(30000);
  VAR1 VARCHAR2(30000);
BEGIN
  SELECT JOB_REPORTS INTO VAR1 FROM tbl_job_profile WHERE ID = INPAR_REPORT ;
  VAR := 'select id "reportId",TYPE "reportType",CATEGORY "category",name "reportName" from tbl_report where id in ( select regexp_substr('''||VAR1||''',''[^,]+'', 1, level) from dual     
connect by regexp_substr('''||VAR1||''', ''[^,]+'', 1, level) is not null)';
  RETURN VAR;
END FNC_JOB_GET_JOB_REPORTS;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_GET_JOB_DATE(
    INPAR_REPORT IN VARCHAR2 )
  RETURN VARCHAR2
AS
  VAR VARCHAR2(30000);
BEGIN
  VAR := FNC_JOB_STORE_DATE(INPAR_REPORT);
  VAR := 'SELECT 
JOB_DATE "date"
FROM TBL_JOB_STORE_DATE WHERE REF_REPORT  =' || INPAR_REPORT || ' ';
  RETURN VAR;
END FNC_JOB_GET_JOB_DATE;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_STATUS(
    INPAR_REPORT IN VARCHAR2,
    INPAR_STATUS IN VARCHAR2)
  RETURN VARCHAR2
AS
  VAR VARCHAR2(30000);
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  UPDATE tbl_job_profile SET IS_ENABLE = INPAR_STATUS WHERE ID =INPAR_REPORT;
  COMMIT;
  RETURN 1;
END FNC_JOB_STATUS;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_JOB_create_body(
    INPAR_REPORT IN VARCHAR2 )
  RETURN VARCHAR2
AS
  var_notif      NUMBER;
  var_reports    VARCHAR2(20000);
  var_type       VARCHAR2(50);
  var_cat        VARCHAR2(50);
  var_name       VARCHAR2(100);
  var_out        VARCHAR2(2000);
  var_job_action VARCHAR2(32000);
BEGIN
  SELECT JOB_REPORTS
  INTO var_reports
  FROM TBL_JOB_PROFILE
  WHERE id       = INPAR_REPORT;
  var_job_action:= 'declare   var_notif   NUMBER; var_out VARCHAR2(2000); begin ';
  FOR i IN
  (SELECT regexp_substr(var_reports,'[^,]+', 1, level) AS a
  FROM dual
    CONNECT BY regexp_substr(var_reports, '[^,]+', 1, level) IS NOT NULL
  )
  LOOP
    SELECT type,
      category,
      name
    INTO var_type,
      var_cat,
      var_name
    FROM tbl_report
    WHERE id         = i.a;
    IF ( var_cat     ='gap'  ) THEN
      var_job_action:=var_job_action ||' PRC_NOTIFICATION(''''insert'''','''''''',''''normal'''',''''lug'''','''''||var_name||''''',''''progress'''',''''job'''',''''gap/rial'''','||i.a||','''''''','''''''',var_notif);      
PRC_CREATE_REPORT_REQUEST('||i.a||',''''job'''',var_notif,var_out);';
    END IF;
    IF ( var_cat ='liquidity') THEN
      var_job_action:=var_job_action ||' PRC_NOTIFICATION(''''insert'''','''''''',''''normal'''',''''lug'''','''''||var_name||''''',''''progress'''',''''job'''',''''liquidity/rial'''','||i.a||','''''''','''''''',var_notif);      
PRC_CREATE_REPORT_REQUEST('||i.a||',''''job'''',var_notif,var_out);';
    END IF;
    IF ( var_cat     ='province') THEN
      var_job_action:=var_job_action ||' PRC_NOTIFICATION(''''insert'''','''''''',''''normal'''',''''province'''','''''||var_name||''''',''''progress'''',''''job'''',''''province/composite'''','||i.a||','''''''','''''''',var_notif);      
PKG_STATE_REPORT.PRC_STATE_REP_PROFILE_DETAIL('''''||i.a||''''',var_notif,var_out);';
    END IF;
  END LOOP;
  var_job_action:=var_job_action ||'end;';
  RETURN var_job_action;
END FNC_JOB_create_body;
END PKG_JOB;
--------------------------------------------------------
--  DDL for Table PKG_DUE_DATE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_DUE_DATE" AS 

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_DUE_DATE_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_TIMING_PROFILE     IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_REPORT_VALUE ( INPAR_ID_REPORT IN NUMBER );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_TREE RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_LEAF ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_DETAIL (
  INPAR_ID     IN NUMBER
 ,INPAR_TYPE   IN VARCHAR2
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_count ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_FIRS_TIME;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/


END PKG_DUE_DATE;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_DUE_DATE" AS

 PROCEDURE PRC_DUE_DATE_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_TIMING_PROFILE     IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,REF_TIMING_PROFILE
   ,TYPE
   ,CATEGORY
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,INPAR_TIMING_PROFILE
   ,INPAR_TYPE
   ,'DUE_DATE'
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,REF_TIMING_PROFILE = INPAR_TIMING_PROFILE
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
 END PRC_DUE_DATE_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_REPORT_VALUE ( INPAR_ID_REPORT IN NUMBER ) AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Morteza.Sahhi
  Editor Name:
  Release Date/Time:1396/02/24-10:00
  Edit Name:
  Version: 1.1
  Category:2
  Description:in procedure baraye enteghal dadehaye morde niaz az value be TBL_VALUE_TEMP bar asas profilehaye mokhtalefist ke karbar taeen karde
  */
  /*------------------------------------------------------------------------------*/

  VAR_QUERY     VARCHAR2(4000);
  ID_LOAN       NUMBER;
  ID_DEP        NUMBER;
  ID_CUR        NUMBER;
  ID_CUS        NUMBER;
  ID_BRANCH     NUMBER;
  ID_TIMING     NUMBER;
  DATE_TYPE1    DATE := SYSDATE;
  VAR_REP_REQ   NUMBER;
  LOC_S         TIMESTAMP;
  LOC_F         TIMESTAMP;
  LOC_MEGHDAR   NUMBER;
 BEGIN
  EXECUTE IMMEDIATE 'alter session set nls_date_format=''DD-MM-RRRR''';
/*  execute immediate 'alter session set nls_date_format=''DD-MM-RRRR''';*/
  SYS.DBMS_OUTPUT.ENABLE(3000000);
  /******profilhaye mokhtalefi ke karbar baraye in gozaresh entekhab karde ra daron moteghayer ham nam profil mirizim ******/
  SELECT
   MAX(ID)
  INTO
   ID_TIMING
  FROM TBL_TIMING_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_TIMING_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );
  
  /******be ezaye tedad bazehayee ke dar profile zamani vojod darad halghe ro ejra mikonim*****--*/

  COMMIT;
  SELECT
   MAX(ID)
  INTO
   VAR_REP_REQ
  FROM TBL_REPREQ;
    /*--------------TBL_REPPER-----------------*/
  /******enteghal profile zamani be jadval repper*****--*/
  /*-----------------------------------------*/

  INSERT INTO TBL_REPPER (
   REF_TIMING_PROFILE
  ,PERIOD_NAME
  ,PERIOD_DATE
  ,PERIOD_START
  ,PERIOD_END
  ,PERIOD_COLOR
  ,REF_REPORT_ID
  ,OLD_ID
  ,REF_REQ_ID
  ) SELECT
   REF_TIMING_PROFILE
  ,PERIOD_NAME
  ,PERIOD_DATE
  ,PERIOD_START
  ,PERIOD_END
  ,PERIOD_COLOR
  ,INPAR_ID_REPORT
  ,ID
  ,VAR_REP_REQ
  FROM TBL_TIMING_PROFILE_DETAIL
  WHERE REF_TIMING_PROFILE   = ID_TIMING;

  COMMIT;
  FOR I IN (
   SELECT
    TTPD.ID
   ,TTP.TYPE
   ,TTPD.PERIOD_NAME
   ,TTPD.PERIOD_DATE
   ,TTPD.PERIOD_START
   ,TTPD.PERIOD_END
   ,TTPD.PERIOD_COLOR
   FROM TBL_TIMING_PROFILE TTP
   ,    TBL_TIMING_PROFILE_DETAIL TTPD
   WHERE TTP.ID   = TTPD.REF_TIMING_PROFILE
    AND
     TTP.ID   = ID_TIMING
  ) LOOP
   IF
    ( I.TYPE = 1 )
   THEN
      /******agar profile zamani entekhab shode bazehee bashad *****--*/
    SELECT
     '  
INSERT INTO TBL_DUE_DATE_DETAIL (
 REP_REQ
 ,PARENT
 ,CHILD
 ,VALUE
 ,DEPTH
 ,REF_EFF_DATE
 ,REGION_ID
 ,TYPE
 ,RATE,
 name,
 count
)  
SELECT
' ||
     VAR_REP_REQ ||
     '
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_DEPOSIT_TYPE AS REF_DEPOSIT_TYPE
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_DEPOSIT_TYPE ||
 100 ||
 TD.RATE AS RATE
 ,SUM(TD.BALANCE)
 ,4
 ,' ||
     I.ID ||
     '
 ,TB.REGION_ID ,
 TD.REF_DEPOSIT_TYPE,
 TD.RATE  ,
  ''نرخ سود ''||TD.RATE ,
   case when count(TD.RATE) is null then 0 else count(TD.RATE) end
FROM AKIN.TBL_DEPOSIT TD
 ,  TBL_BRANCH TB
WHERE DUE_DATE > to_date(''' ||
     DATE_TYPE1 ||
     ''') and DUE_DATE <= to_date(''' ||
     DATE_TYPE1 ||
     ''')+' ||
     I.PERIOD_DATE ||
     ' and TD.REF_BRANCH   = TB.BRN_ID
GROUP BY
 TB.REGION_ID
 ,TD.REF_DEPOSIT_TYPE
 ,TD.RATE;

'
    INTO
     VAR_QUERY
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;

    
    DATE_TYPE1   := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
   ELSE
      /******agar profile zamani entekhab shode tarikhi bashad *****--*/
    SELECT
     '  
INSERT INTO TBL_DUE_DATE_DETAIL (
 REP_REQ
 ,PARENT
 ,CHILD
 ,VALUE
 ,DEPTH
 ,REF_EFF_DATE
 ,REGION_ID
 ,TYPE
 ,RATE,
 name,
 count
) 
SELECT
' ||
     VAR_REP_REQ ||
     '
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_DEPOSIT_TYPE AS REF_DEPOSIT_TYPE
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_DEPOSIT_TYPE ||
 100 ||
 TD.RATE AS RATE
 ,SUM(TD.BALANCE)
 ,4
 ,' ||
     I.ID ||
     '
 ,TB.REGION_ID ,
 TD.REF_DEPOSIT_TYPE,
 TD.RATE  ,
 ''نرخ سود ''||TD.RATE ,
   case when count(TD.RATE) is null then 0 else count(TD.RATE) end

FROM AKIN.TBL_DEPOSIT TD
 ,  TBL_BRANCH TB
WHERE TD.DUE_DATE > to_date(''' ||
     I.PERIOD_START ||
     ''',''dd-mm-yyyy'') and TD.DUE_DATE <= to_date(''' ||
     I.PERIOD_END ||
     ''',''dd-mm-yyyy'') and TD.REF_BRANCH   = TB.BRN_ID
GROUP BY
 TB.REGION_ID
 ,TD.REF_DEPOSIT_TYPE
 ,TD.RATE;'
    INTO
     VAR_QUERY
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
        COMMIT;


    
   END IF;
  END LOOP;

  COMMIT;
  UPDATE TBL_DUE_DATE_DETAIL DDD
   SET
    DDD.REF_EFF_DATE = (
     SELECT
      ID
     FROM TBL_REPPER
     WHERE REF_REQ_ID          = VAR_REP_REQ
      AND
       TBL_REPPER.OLD_ID   = DDD.REF_EFF_DATE
    )
  WHERE DDD.REP_REQ   = VAR_REP_REQ;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   VAR_REP_REQ
  ,DDD.PARENT
  ,DDD.CHILD
  ,0
  ,DDD.DEPTH
  ,TP.ID
  ,DDD.REGION_ID
  ,DDD.TYPE
  ,DDD.RATE
  ,DDD.NAME
  FROM TBL_DUE_DATE_DETAIL DDD
  ,    TBL_REPPER TP
  WHERE DDD.REP_REQ     = 0
   AND
    DDD.DEPTH       = 4
   AND
    TP.REF_REQ_ID   = VAR_REP_REQ
   AND
    DDD.CHILD || TP.ID NOT IN (
     SELECT
      CHILD || REF_EFF_DATE
     FROM TBL_DUE_DATE_DETAIL
     WHERE REP_REQ   = VAR_REP_REQ
    );

  COMMIT;
  
  update TBL_DUE_DATE_DETAIL set count = 0 where rep_req = VAR_REP_REQ and count is null ;
  commit;
  
  /*-------------------------------------------------------------------------------------------*/
  LOC_F         := SYSTIMESTAMP;
  LOC_MEGHDAR   := SQL%ROWCOUNT;
 EXCEPTION
  WHEN OTHERS THEN
   RAISE;
 END PRC_DUE_DATE_REPORT_VALUE;

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''DUE_DATE''';
  RETURN VAR2;
 END FNC_DUE_DATE_ALL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_TREE RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'select
 parent as "parent",child as "id",depth as "level",name as "text",RATE "rate",type "type",REGION_ID "regionId"
from
  tbl_due_date_detail
  where rep_req = 0
start with
  parent is null
connect by
  prior child=parent'
;
  RETURN VAR2;
 END FNC_DUE_DATE_GET_TREE;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_LEAF ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := ' SELECT
  PARENT as "parent"
 ,CHILD as "id"
 ,VALUE as "value"
 ,DEPTH as "depth"
 ,REF_EFF_DATE as "effDate"
 ,REGION_ID as "regionId"
 ,TYPE as "type"
 ,RATE as "rate"
 ,count as "xcount"
FROM TBL_DUE_DATE_DETAIL
where REP_REQ ='
|| INPAR_ID || '';
  RETURN VAR2;
 END FNC_DUE_DATE_GET_LEAF;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

  FUNCTION FNC_DUE_DATE_GET_DETAIL (
  INPAR_ID     IN NUMBER
 ,INPAR_TYPE   IN VARCHAR2
 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  IF
   ( UPPER(INPAR_TYPE) = 'TYPE' )
  THEN
   VAR2   := 'SELECT DISTINCT DDD.TYPE AS "id",DT.NAME as "name" FROM TBL_DUE_DATE_DETAIL DDD,TBL_DEPOSIT_TYPE DT  WHERE DDD.REP_REQ = '
|| INPAR_ID || ' AND DDD.TYPE = DT.REF_DEPOSIT_TYPE
ORDER BY DT.NAME';
  END IF;

  IF
   ( UPPER(INPAR_TYPE) = 'RATE' )
  THEN
   VAR2   := 'SELECT DISTINCT DDD.RATE as "id",DDD.NAME as "name" FROM TBL_DUE_DATE_DETAIL DDD WHERE DDD.REP_REQ = ' || INPAR_ID || ' 
ORDER BY DDD.RATE'
;
  END IF;

  IF
   ( UPPER(INPAR_TYPE) = 'REGION' )
  THEN
   VAR2   := 'SELECT DISTINCT DDD.REGION_ID as "id",TB.REGION_NAME as "name"  FROM TBL_DUE_DATE_DETAIL DDD,TBL_BRANCH TB WHERE DDD.REP_REQ = '
|| INPAR_ID || ' AND TB.REGION_ID = DDD.REGION_ID 
ORDER BY DDD.REGION_ID';
  END IF;

  RETURN VAR2;
 END FNC_DUE_DATE_GET_DETAIL;
 
 /*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_count ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT
  PARENT as "parent"
 ,CHILD as "id"
 ,VALUE as "value"
 ,DEPTH as "depth"
 ,REF_EFF_DATE as "effDate"
 ,REGION_ID as "regionId"
 ,TYPE as "type"
 ,RATE as "rate"
FROM TBL_DUE_DATE_DETAIL
where REP_REQ ='
|| INPAR_ID || ' and DEPTH is null';
  RETURN VAR2;
 END FNC_DUE_DATE_GET_count;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_FIRS_TIME
  AS
 BEGIN
  INSERT INTO TBL_DUE_DATE_DETAIL (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   0
  ,100 ||
   TB.REGION_ID ||
   100 ||
   TD.REF_DEPOSIT_TYPE AS REF_DEPOSIT_TYPE
  ,100 ||
   TB.REGION_ID ||
   100 ||
   TD.REF_DEPOSIT_TYPE ||
   100 ||
   TD.RATE AS RATE
  ,SUM(TD.BALANCE)
  ,4
  ,0000
  ,TB.REGION_ID
  ,TD.REF_DEPOSIT_TYPE
  ,TD.RATE
  ,'نرخ سود ' || TD.RATE
  FROM AKIN.TBL_DEPOSIT TD
  ,    TBL_BRANCH TB
  WHERE TD.REF_BRANCH   = TB.BRN_ID
  GROUP BY
   TB.REGION_ID
  ,TD.REF_DEPOSIT_TYPE
  ,TD.RATE;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   0 AS REP_REQ
  ,100 || REGION_ID
  ,PARENT
  ,SUM(VALUE)
  ,3
  ,0 AS EFFDATE
  ,REGION_ID
  ,MAX(TYPE)
  ,-1 AS RATE
  ,MAX( (
    SELECT DISTINCT
     TDT.NAME
    FROM TBL_DEPOSIT_TYPE TDT
    WHERE TDT.REF_DEPOSIT_TYPE   = TYPE
   ) ) AS NAME
  FROM TBL_DUE_DATE_DETAIL
  GROUP BY
   PARENT
  ,REGION_ID;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  )  SELECT
   0
  ,0
  ,b.PARENT
  ,SUM(b.VALUE)
  ,2
  ,0
  ,b.REGION_ID
  ,0
  ,-1
  ,max((select  distinct TBL_BRANCH.REGION_NAME from TBL_BRANCH where TBL_BRANCH.REGION_ID =b.REGION_ID)) as name
  FROM TBL_DUE_DATE_DETAIL  b
  WHERE b.DEPTH   = 3
  GROUP BY
   b.PARENT
  ,b.REGION_ID;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   0
  ,''
  ,0
  ,SUM(VALUE)
  ,1
  ,0
  ,0
  ,0
  ,-1
  ,'کل'
  FROM TBL_DUE_DATE_DETAIL
  WHERE DEPTH   = 2
  GROUP BY
   PARENT;

  COMMIT;
 END;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

END PKG_DUE_DATE;
--------------------------------------------------------
--  DDL for Table PKG_DUE_DATE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_DUE_DATE" AS 

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_DUE_DATE_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_TIMING_PROFILE     IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_REPORT_VALUE ( INPAR_ID_REPORT IN NUMBER );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_TREE RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_LEAF ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_DETAIL (
  INPAR_ID     IN NUMBER
 ,INPAR_TYPE   IN VARCHAR2
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_count ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_FIRS_TIME;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/


END PKG_DUE_DATE;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_DUE_DATE" AS

 PROCEDURE PRC_DUE_DATE_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_TIMING_PROFILE     IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,REF_TIMING_PROFILE
   ,TYPE
   ,CATEGORY
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,INPAR_TIMING_PROFILE
   ,INPAR_TYPE
   ,'DUE_DATE'
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,REF_TIMING_PROFILE = INPAR_TIMING_PROFILE
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
 END PRC_DUE_DATE_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_REPORT_VALUE ( INPAR_ID_REPORT IN NUMBER ) AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Morteza.Sahhi
  Editor Name:
  Release Date/Time:1396/02/24-10:00
  Edit Name:
  Version: 1.1
  Category:2
  Description:in procedure baraye enteghal dadehaye morde niaz az value be TBL_VALUE_TEMP bar asas profilehaye mokhtalefist ke karbar taeen karde
  */
  /*------------------------------------------------------------------------------*/

  VAR_QUERY     VARCHAR2(4000);
  ID_LOAN       NUMBER;
  ID_DEP        NUMBER;
  ID_CUR        NUMBER;
  ID_CUS        NUMBER;
  ID_BRANCH     NUMBER;
  ID_TIMING     NUMBER;
  DATE_TYPE1    DATE := SYSDATE;
  VAR_REP_REQ   NUMBER;
  LOC_S         TIMESTAMP;
  LOC_F         TIMESTAMP;
  LOC_MEGHDAR   NUMBER;
 BEGIN
  EXECUTE IMMEDIATE 'alter session set nls_date_format=''DD-MM-RRRR''';
/*  execute immediate 'alter session set nls_date_format=''DD-MM-RRRR''';*/
  SYS.DBMS_OUTPUT.ENABLE(3000000);
  /******profilhaye mokhtalefi ke karbar baraye in gozaresh entekhab karde ra daron moteghayer ham nam profil mirizim ******/
  SELECT
   MAX(ID)
  INTO
   ID_TIMING
  FROM TBL_TIMING_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_TIMING_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );
  
  /******be ezaye tedad bazehayee ke dar profile zamani vojod darad halghe ro ejra mikonim*****--*/

  COMMIT;
  SELECT
   MAX(ID)
  INTO
   VAR_REP_REQ
  FROM TBL_REPREQ;
    /*--------------TBL_REPPER-----------------*/
  /******enteghal profile zamani be jadval repper*****--*/
  /*-----------------------------------------*/

  INSERT INTO TBL_REPPER (
   REF_TIMING_PROFILE
  ,PERIOD_NAME
  ,PERIOD_DATE
  ,PERIOD_START
  ,PERIOD_END
  ,PERIOD_COLOR
  ,REF_REPORT_ID
  ,OLD_ID
  ,REF_REQ_ID
  ) SELECT
   REF_TIMING_PROFILE
  ,PERIOD_NAME
  ,PERIOD_DATE
  ,PERIOD_START
  ,PERIOD_END
  ,PERIOD_COLOR
  ,INPAR_ID_REPORT
  ,ID
  ,VAR_REP_REQ
  FROM TBL_TIMING_PROFILE_DETAIL
  WHERE REF_TIMING_PROFILE   = ID_TIMING;

  COMMIT;
  FOR I IN (
   SELECT
    TTPD.ID
   ,TTP.TYPE
   ,TTPD.PERIOD_NAME
   ,TTPD.PERIOD_DATE
   ,TTPD.PERIOD_START
   ,TTPD.PERIOD_END
   ,TTPD.PERIOD_COLOR
   FROM TBL_TIMING_PROFILE TTP
   ,    TBL_TIMING_PROFILE_DETAIL TTPD
   WHERE TTP.ID   = TTPD.REF_TIMING_PROFILE
    AND
     TTP.ID   = ID_TIMING
  ) LOOP
   IF
    ( I.TYPE = 1 )
   THEN
      /******agar profile zamani entekhab shode bazehee bashad *****--*/
    SELECT
     '  
INSERT INTO TBL_DUE_DATE_DETAIL (
 REP_REQ
 ,PARENT
 ,CHILD
 ,VALUE
 ,DEPTH
 ,REF_EFF_DATE
 ,REGION_ID
 ,TYPE
 ,RATE,
 name,
 count
)  
SELECT
' ||
     VAR_REP_REQ ||
     '
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_DEPOSIT_TYPE AS REF_DEPOSIT_TYPE
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_DEPOSIT_TYPE ||
 100 ||
 TD.RATE AS RATE
 ,SUM(TD.BALANCE)
 ,4
 ,' ||
     I.ID ||
     '
 ,TB.REGION_ID ,
 TD.REF_DEPOSIT_TYPE,
 TD.RATE  ,
  ''نرخ سود ''||TD.RATE ,
   case when count(TD.RATE) is null then 0 else count(TD.RATE) end
FROM AKIN.TBL_DEPOSIT TD
 ,  TBL_BRANCH TB
WHERE DUE_DATE > to_date(''' ||
     DATE_TYPE1 ||
     ''') and DUE_DATE <= to_date(''' ||
     DATE_TYPE1 ||
     ''')+' ||
     I.PERIOD_DATE ||
     ' and TD.REF_BRANCH   = TB.BRN_ID
GROUP BY
 TB.REGION_ID
 ,TD.REF_DEPOSIT_TYPE
 ,TD.RATE;

'
    INTO
     VAR_QUERY
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;

    
    DATE_TYPE1   := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
   ELSE
      /******agar profile zamani entekhab shode tarikhi bashad *****--*/
    SELECT
     '  
INSERT INTO TBL_DUE_DATE_DETAIL (
 REP_REQ
 ,PARENT
 ,CHILD
 ,VALUE
 ,DEPTH
 ,REF_EFF_DATE
 ,REGION_ID
 ,TYPE
 ,RATE,
 name,
 count
) 
SELECT
' ||
     VAR_REP_REQ ||
     '
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_DEPOSIT_TYPE AS REF_DEPOSIT_TYPE
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_DEPOSIT_TYPE ||
 100 ||
 TD.RATE AS RATE
 ,SUM(TD.BALANCE)
 ,4
 ,' ||
     I.ID ||
     '
 ,TB.REGION_ID ,
 TD.REF_DEPOSIT_TYPE,
 TD.RATE  ,
 ''نرخ سود ''||TD.RATE ,
   case when count(TD.RATE) is null then 0 else count(TD.RATE) end

FROM AKIN.TBL_DEPOSIT TD
 ,  TBL_BRANCH TB
WHERE TD.DUE_DATE > to_date(''' ||
     I.PERIOD_START ||
     ''',''dd-mm-yyyy'') and TD.DUE_DATE <= to_date(''' ||
     I.PERIOD_END ||
     ''',''dd-mm-yyyy'') and TD.REF_BRANCH   = TB.BRN_ID
GROUP BY
 TB.REGION_ID
 ,TD.REF_DEPOSIT_TYPE
 ,TD.RATE;'
    INTO
     VAR_QUERY
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
        COMMIT;


    
   END IF;
  END LOOP;

  COMMIT;
  UPDATE TBL_DUE_DATE_DETAIL DDD
   SET
    DDD.REF_EFF_DATE = (
     SELECT
      ID
     FROM TBL_REPPER
     WHERE REF_REQ_ID          = VAR_REP_REQ
      AND
       TBL_REPPER.OLD_ID   = DDD.REF_EFF_DATE
    )
  WHERE DDD.REP_REQ   = VAR_REP_REQ;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   VAR_REP_REQ
  ,DDD.PARENT
  ,DDD.CHILD
  ,0
  ,DDD.DEPTH
  ,TP.ID
  ,DDD.REGION_ID
  ,DDD.TYPE
  ,DDD.RATE
  ,DDD.NAME
  FROM TBL_DUE_DATE_DETAIL DDD
  ,    TBL_REPPER TP
  WHERE DDD.REP_REQ     = 0
   AND
    DDD.DEPTH       = 4
   AND
    TP.REF_REQ_ID   = VAR_REP_REQ
   AND
    DDD.CHILD || TP.ID NOT IN (
     SELECT
      CHILD || REF_EFF_DATE
     FROM TBL_DUE_DATE_DETAIL
     WHERE REP_REQ   = VAR_REP_REQ
    );

  COMMIT;
  
  update TBL_DUE_DATE_DETAIL set count = 0 where rep_req = VAR_REP_REQ and count is null ;
  commit;
  
  /*-------------------------------------------------------------------------------------------*/
  LOC_F         := SYSTIMESTAMP;
  LOC_MEGHDAR   := SQL%ROWCOUNT;
 EXCEPTION
  WHEN OTHERS THEN
   RAISE;
 END PRC_DUE_DATE_REPORT_VALUE;

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''DUE_DATE''';
  RETURN VAR2;
 END FNC_DUE_DATE_ALL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_TREE RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'select
 parent as "parent",child as "id",depth as "level",name as "text",RATE "rate",type "type",REGION_ID "regionId"
from
  tbl_due_date_detail
  where rep_req = 0
start with
  parent is null
connect by
  prior child=parent'
;
  RETURN VAR2;
 END FNC_DUE_DATE_GET_TREE;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_LEAF ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := ' SELECT
  PARENT as "parent"
 ,CHILD as "id"
 ,VALUE as "value"
 ,DEPTH as "depth"
 ,REF_EFF_DATE as "effDate"
 ,REGION_ID as "regionId"
 ,TYPE as "type"
 ,RATE as "rate"
 ,count as "xcount"
FROM TBL_DUE_DATE_DETAIL
where REP_REQ ='
|| INPAR_ID || '';
  RETURN VAR2;
 END FNC_DUE_DATE_GET_LEAF;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

  FUNCTION FNC_DUE_DATE_GET_DETAIL (
  INPAR_ID     IN NUMBER
 ,INPAR_TYPE   IN VARCHAR2
 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  IF
   ( UPPER(INPAR_TYPE) = 'TYPE' )
  THEN
   VAR2   := 'SELECT DISTINCT DDD.TYPE AS "id",DT.NAME as "name" FROM TBL_DUE_DATE_DETAIL DDD,TBL_DEPOSIT_TYPE DT  WHERE DDD.REP_REQ = '
|| INPAR_ID || ' AND DDD.TYPE = DT.REF_DEPOSIT_TYPE
ORDER BY DT.NAME';
  END IF;

  IF
   ( UPPER(INPAR_TYPE) = 'RATE' )
  THEN
   VAR2   := 'SELECT DISTINCT DDD.RATE as "id",DDD.NAME as "name" FROM TBL_DUE_DATE_DETAIL DDD WHERE DDD.REP_REQ = ' || INPAR_ID || ' 
ORDER BY DDD.RATE'
;
  END IF;

  IF
   ( UPPER(INPAR_TYPE) = 'REGION' )
  THEN
   VAR2   := 'SELECT DISTINCT DDD.REGION_ID as "id",TB.REGION_NAME as "name"  FROM TBL_DUE_DATE_DETAIL DDD,TBL_BRANCH TB WHERE DDD.REP_REQ = '
|| INPAR_ID || ' AND TB.REGION_ID = DDD.REGION_ID 
ORDER BY DDD.REGION_ID';
  END IF;

  RETURN VAR2;
 END FNC_DUE_DATE_GET_DETAIL;
 
 /*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_count ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT
  PARENT as "parent"
 ,CHILD as "id"
 ,VALUE as "value"
 ,DEPTH as "depth"
 ,REF_EFF_DATE as "effDate"
 ,REGION_ID as "regionId"
 ,TYPE as "type"
 ,RATE as "rate"
FROM TBL_DUE_DATE_DETAIL
where REP_REQ ='
|| INPAR_ID || ' and DEPTH is null';
  RETURN VAR2;
 END FNC_DUE_DATE_GET_count;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_FIRS_TIME
  AS
 BEGIN
  INSERT INTO TBL_DUE_DATE_DETAIL (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   0
  ,100 ||
   TB.REGION_ID ||
   100 ||
   TD.REF_DEPOSIT_TYPE AS REF_DEPOSIT_TYPE
  ,100 ||
   TB.REGION_ID ||
   100 ||
   TD.REF_DEPOSIT_TYPE ||
   100 ||
   TD.RATE AS RATE
  ,SUM(TD.BALANCE)
  ,4
  ,0000
  ,TB.REGION_ID
  ,TD.REF_DEPOSIT_TYPE
  ,TD.RATE
  ,'نرخ سود ' || TD.RATE
  FROM AKIN.TBL_DEPOSIT TD
  ,    TBL_BRANCH TB
  WHERE TD.REF_BRANCH   = TB.BRN_ID
  GROUP BY
   TB.REGION_ID
  ,TD.REF_DEPOSIT_TYPE
  ,TD.RATE;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   0 AS REP_REQ
  ,100 || REGION_ID
  ,PARENT
  ,SUM(VALUE)
  ,3
  ,0 AS EFFDATE
  ,REGION_ID
  ,MAX(TYPE)
  ,-1 AS RATE
  ,MAX( (
    SELECT DISTINCT
     TDT.NAME
    FROM TBL_DEPOSIT_TYPE TDT
    WHERE TDT.REF_DEPOSIT_TYPE   = TYPE
   ) ) AS NAME
  FROM TBL_DUE_DATE_DETAIL
  GROUP BY
   PARENT
  ,REGION_ID;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  )  SELECT
   0
  ,0
  ,b.PARENT
  ,SUM(b.VALUE)
  ,2
  ,0
  ,b.REGION_ID
  ,0
  ,-1
  ,max((select  distinct TBL_BRANCH.REGION_NAME from TBL_BRANCH where TBL_BRANCH.REGION_ID =b.REGION_ID)) as name
  FROM TBL_DUE_DATE_DETAIL  b
  WHERE b.DEPTH   = 3
  GROUP BY
   b.PARENT
  ,b.REGION_ID;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   0
  ,''
  ,0
  ,SUM(VALUE)
  ,1
  ,0
  ,0
  ,0
  ,-1
  ,'کل'
  FROM TBL_DUE_DATE_DETAIL
  WHERE DEPTH   = 2
  GROUP BY
   PARENT;

  COMMIT;
 END;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

END PKG_DUE_DATE;
--------------------------------------------------------
--  DDL for Table PKG_TJR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_TJR" AS 

PROCEDURE PRC_TRANSFER_BRANCH;
PROCEDURE PRC_TRANSFER_CITY;
PROCEDURE PRC_TRANSFER_CURRENCY_REL;--**
PROCEDURE PRC_TRANSFER_CUSTOMER;
PROCEDURE PRC_TRANSFER_DEPOSIT_TYPE;
PROCEDURE PRC_TRANSFER_LEDGER; 
PROCEDURE PRC_TRANSFER_LOAN_TYPE;
PROCEDURE PRC_LEDGER_ARCHIVE(in_date in date);
PROCEDURE PRC_LEDGER_BRANCH(in_date in date);
PROCEDURE prc_other_code;
PROCEDURE PRC_LOAN(RUN_DATE IN DATE );
PROCEDURE PRC_deposit(RUN_DATE IN DATE );


END PKG_TJR;







--
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_TJR" AS

  PROCEDURE PRC_TRANSFER_BRANCH AS
  BEGIN
    insert into PRAGG.TBL_BRANCH(BRN_ID,name,CITY_NAME,REF_CTY_ID,ref_sta_id,region_id,REGION_NAME)
(select shobe.brnch_cd,shobe.brnch_dsc,shahr.nam,shobe.ar_cd,shahr.ostan_id,shobe.ar_cd,shahr.nam from TEJARAT_DB.tbbranch  shobe ,satrap_tejarat.bi_table_shahr@SATRAP shahr
where shobe.ar_cd = shahr.id
and shobe.brnch_dsc  is not null

);
commit;

  END PRC_TRANSFER_BRANCH;

  PROCEDURE PRC_TRANSFER_CITY AS
  BEGIN
insert into TBL_CITY(cty_id,CTY_name,des,ref_sta_id)
(select id,nam,tozih,ostan_id from satrap_tejarat.bi_table_shahr@SATRAP shahr);
commit;

  END PRC_TRANSFER_CITY;

  PROCEDURE PRC_TRANSFER_CURRENCY_REL AS
  BEGIN
    NULL;
  END PRC_TRANSFER_CURRENCY_REL;

  PROCEDURE PRC_TRANSFER_CUSTOMER AS
  BEGIN
   insert into tbl_customer(cus_id,nat_reg_code,name,family)
  (select /*+ PARALLEL(AUTO)*/ id, melli, name, unistr(replace(asciistr(family),'\200F',' ')) from(  --tabdile nim fasele be fasele
  select /*+ PARALLEL(AUTO)*/ nvl(id,1) as id, nvl(melli,1) as melli, name, family, row_number() over (partition by melli order by melli) as row_num,count(*) over (partition by melli) as cnt from(
      SELECT  /*+ PARALLEL(AUTO)*/ DISTINCT to_number(trim(MELLI_ID)) AS id, trim(MELLI_ID) as melli, max(name2) as name, '' as family
        FROM TEJARAT_DB.CUSTOMER_NCOMPANY
        where MELLI_ID is not null and replace(TRANSLATE(trim(MELLI_ID), '0123456789','0000000000'),'0','') IS NULL group by MELLI_ID
    UNION
      SELECT /*+ PARALLEL(AUTO) */ DISTINCT to_number(trim(COD_MELI)) AS id, trim(COD_MELI) as melli,max(name1) as name,max(famili1) as family
        FROM TEJARAT_DB.CUSTOMER_NPERSON
        where cod_meli is not null and replace(TRANSLATE(trim(cod_meli), '0123456789','0000000000'),'0','') IS NULL group by COD_MELI)
        )where row_num = 1 and cnt = 1);
        commit;
  END PRC_TRANSFER_CUSTOMER;

  PROCEDURE PRC_TRANSFER_DEPOSIT_TYPE AS
  BEGIN
insert into PRAGG.TBL_DEPOSIT_TYPE(ref_deposit_type,name)
  (select grp,grp_kind from tejarat_db.sep_kind); 
commit;
END PRC_TRANSFER_DEPOSIT_TYPE;

  PROCEDURE PRC_TRANSFER_LEDGER AS
  BEGIN
INSERT INTO TBL_LEDGER (
 LEDGER_CODE
 ,NAME
 ,DEPTH
 ,PARENT_CODE
) SELECT
 ID
 ,NAME
 ,DEPTH
 ,FATHER_ID
FROM TEJARAT_DB.GL_CODE;
  END PRC_TRANSFER_LEDGER;

  PROCEDURE PRC_TRANSFER_LOAN_TYPE AS
  BEGIN
insert into TBL_LOAN_TYPE(ref_loan_type,name)
  (SELECT REF_NOE_TASHILAT ,NAME 
  from (SELECT DISTINCT CODE as REF_NOE_TASHILAT,NAME  FROM TEJARAT_DB.noe_tashilat ))
;
commit;

INSERT INTO TBL_LEDGER (LEDGER_CODE, NAME, DEPTH) VALUES ('0', 'ريشه', '1');

commit;
END PRC_TRANSFER_LOAN_TYPE;
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\
  PROCEDURE PRC_LEDGER_ARCHIVE(in_date in date) AS
  BEGIN
insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,EFF_DATE,REF_CUR_ID)
    select b.id,b.name,b.father_id,a.mande,b.depth, trunc(in_date),4 from
    (
      select cbi_db, sum(blnc_db + blnc_cr) as mande from tejarat_db.taledger 
        where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db not in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1330','K1320','A0080','A0140','A0160','B0230','C0796') group by cbi_db
    ) a, akin.tbl_treenode_tejarat_5 b where a.cbi_db = b.code;
  commit;
  insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,EFF_DATE,REF_CUR_ID)
    select b.id,b.name,b.father_id,a.mande,b.depth,trunc(in_date),4 from
    (
      select cbi_db, sum(blnc_cr) as mande from tejarat_db.taledger 
        where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db
    ) a, akin.tbl_treenode_tejarat_5 b where a.cbi_db = b.code;
  commit;
  insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,EFF_DATE,REF_CUR_ID)
    select b.id,b.name,b.father_id,a.mande,b.depth, trunc(in_date),4 from
    (
      select cbi_db, sum(blnc_db) as mande from tejarat_db.taledger 
        where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db
    ) a, akin.tbl_treenode_tejarat_5 b, tejarat_db.cbi_map c where a.cbi_db = c.CBI and c.cbi2 = b.code;
  commit;

  for i in reverse 3..5
  loop
  insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,EFF_DATE,REF_CUR_ID)
      select b.id,b.name,b.father_id,a.mande,b.depth,a.tarikh,4 from
        (select sum(balance) as mande, PARENT_CODE, max(eff_date) as tarikh from TBL_LEDGER_ARCHIVE where depth = i and PARENT_CODE not in ('5310210','5320200') group by PARENT_CODE) a,
        akin.tbl_treenode_tejarat_5 b where a.PARENT_CODE = b.id;
        commit;
        if (i = 5) then
  insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,EFF_DATE,REF_CUR_ID)
            select 5310210,'حسابهاي انتظامي',28,a.mande,4, trunc(in_date),4 from
            (
              select sum(blnc_cr) as mande from tejarat_db.taledger 
              where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
              ('X9950','X9951','X9955','X9995','X9997','X9998','L0210','X9954','X9990','X9991','X9994','X9996','x9998')
            ) a;
          commit;
  insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,EFF_DATE,REF_CUR_ID)
            select 5320200,'طرف حسابهاي انتظامي',47,a.mande,4, trunc(in_date),4 from
            (
              select sum(blnc_db) as mande from tejarat_db.taledger 
              where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
              ('X9950','X9951','X9955','X9995','X9997','X9998','L0210','X9954','X9990','X9991','X9994','X9996','x9998')
            ) a;
            commit;
        end if;
        commit;
  end loop;
  commit;  END PRC_LEDGER_ARCHIVE;
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

  PROCEDURE PRC_LEDGER_BRANCH(in_date in date) AS
  BEGIN
 execute immediate 'truncate table tjr_varsa.tejarat_gl_br';
  commit;
      insert into TBL_LEDGER_BRANCH(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,REF_BRANCH,EFF_DATE,REF_CUR_ID) 
    select b.id,b.name,b.father_id,a.mande,b.depth,a.brnch_cd, in_date,4 from
    (
      select cbi_db, brnch_cd, sum(blnc_db + blnc_cr) as mande from tejarat_db.taledger 
        where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db not in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db,brnch_cd
    ) a, akin.tbl_treenode_tejarat_5 b where a.cbi_db = b.code;
  commit;
      insert into TBL_LEDGER_BRANCH(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,REF_BRANCH,EFF_DATE,REF_CUR_ID) 
    select b.id,b.name,b.father_id,a.mande,b.depth,a.brnch_cd, in_date,4 from
    (
      select cbi_db, brnch_cd, sum(blnc_cr) as mande from tejarat_db.taledger 
        where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db,brnch_cd
    ) a, akin.tbl_treenode_tejarat_5 b where a.cbi_db = b.code;
  commit;
      insert into TBL_LEDGER_BRANCH(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,REF_BRANCH,EFF_DATE,REF_CUR_ID) 
    select b.id,b.name,b.father_id,a.mande,b.depth,a.brnch_cd, in_date,4 from
    (
      select cbi_db, brnch_cd, sum(blnc_db) as mande from tejarat_db.taledger 
        where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db,brnch_cd
    ) a, akin.tbl_treenode_tejarat_5 b, tejarat_db.cbi_map c where a.cbi_db = c.CBI and c.cbi2 = b.code;
  commit;

  for i in reverse 3..5
  loop
      insert into TBL_LEDGER_BRANCH(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,REF_BRANCH,EFF_DATE,REF_CUR_ID) 
      select b.id,b.name,b.father_id,a.mande,b.depth,a.ref_branch,a.tarikh,4 from
        (select sum(balance) as mande, parent_code, ref_branch, max(eff_date) as tarikh from TBL_LEDGER_BRANCH where depth = i group by parent_code,ref_branch) a,
        akin.tbl_treenode_tejarat_5 b where a.PARENT_CODE = b.id;
        commit;
        if (i = 5) then
    insert into TBL_LEDGER_BRANCH(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,REF_BRANCH,EFF_DATE,REF_CUR_ID)
            select 5310210,'حساب هاي انتظامي',28,a.mande,4, a.brnch_cd, in_date,4 from
            (
              select brnch_cd, sum(blnc_cr) as mande from tejarat_db.taledger 
              where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
              ('X9950','X9951','X9955','X9995','X9997','X9998','L0210','X9954','X9990','X9991','X9994','X9996','x9998') GROUP BY brnch_cd
            ) a;
          commit;
    insert into TBL_LEDGER_BRANCH(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,REF_BRANCH,EFF_DATE,REF_CUR_ID)
            select 5320200,'طرف حساب هاي انتظامي',47,a.mande,4, a.brnch_cd, in_date,4 from
            (
              select brnch_cd, sum(blnc_db) as mande from tejarat_db.taledger 
              where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
              ('X9950','X9951','X9955','X9995','X9997','X9998','L0210','X9954','X9990','X9991','X9994','X9996','x9998') GROUP BY brnch_cd
            ) a;
            commit;
        end if;
        commit;
  end loop;
  commit;  END PRC_LEDGER_BRANCH;
  
--****************************************************
--///////////////////////////////////////////////////
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--****************************************************

procedure prc_other_code
as
  code VARCHAR2(32000);

begin


  SELECT WMSYS.WM_CONCAT(dk.ID)
INTO code
  FROM akin.TEJARAT_GL dk
  WHERE dk.DEPTH = 5
  AND dk.mande  <> 0
  AND dk.ID     <> 3100700070
  AND dk.id NOT IN
    (SELECT DISTINCT ref_leger_code FROM TBL_VALUE where ref_leger_code is not null
    );
  -- DBMS_OUTPUT.PUT_LINE(code);
  INSERT /*+ APPEND PARALLEL(auto)   */
  INTO tbl_value
    (
      REF_MODALITY_TYPE,
      REF_LEGER_CODE,
      DUE_DATE,
      BALANCE,
      REF_CUR_ID
    )
   SELECT 4,
  a.REF_SARFASL,
  a.tarikh,
  (nvl(-a.bes,0)+nvl(a.bed,0))
  ,4
FROM
  (SELECT 4,a.REF_SARFASL,a.tarikh,
 round( CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 1
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_MAH)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 2
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_MAH)/100
    ELSE NULL
  END,0) BES,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 3
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_MAH)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 4
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_MAH)/100
    ELSE NULL
  END,0) BED,
  4
FROM
  (SELECT 
    tsn.REF_SARFASL,
    sysdate+1 as tarikh,
    TSN.YEK_MAH
  FROM akin.TBL_SHIVE_NEGASHT_IFRS tsn
  WHERE tsn.REF_SARFASL IN (
    (SELECT trim(regexp_substr(code, '[^,]+', 1, LEVEL)) AS VALUE
    FROM dual
      CONNECT BY instr(code, ',', 1, LEVEL - 1) > 0
    )) and TSN.YEK_MAH <> '0'
  ) a,
  akin.TEJARAT_GL tg
WHERE a.REF_SARFASL = TG.id )a,
  akin.TEJARAT_GL tg
WHERE tg.id = a.ref_sarfasl;

commit;
  INSERT /*+ APPEND PARALLEL(auto)   */
  INTO tbl_value
    (
      REF_MODALITY_TYPE,
      REF_LEGER_CODE,
      DUE_DATE,
      BALANCE,
      REF_CUR_ID
    )SELECT 4,
  a.REF_SARFASL,
  a.tarikh,
  (nvl(-a.bes,0)+nvl(a.bed,0))
  ,4
FROM
  (
  SELECT 4,a.REF_SARFASL,a.tarikh,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 1
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_SEMAH)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 2
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_SEMAH)/100
    ELSE NULL
  END,0) BES,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 3
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_SEMAH)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 4
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_SEMAH)/100
    ELSE NULL
  END,0) BED,
  4
FROM
  (SELECT 
    tsn.REF_SARFASL,
    sysdate+80 as tarikh,
    TSN.YEK_TA_SEMAH
  FROM akin.TBL_SHIVE_NEGASHT_IFRS tsn
  WHERE tsn.REF_SARFASL IN (
    (SELECT trim(regexp_substr(code, '[^,]+', 1, LEVEL)) AS VALUE
    FROM dual
      CONNECT BY instr(code, ',', 1, LEVEL - 1) > 0
    )) and TSN.YEK_TA_SEMAH <> '0'
  ) a,
  akin.TEJARAT_GL tg
WHERE a.REF_SARFASL = TG.id )a,
  akin.TEJARAT_GL tg
WHERE tg.id = a.ref_sarfasl;

commit;
  INSERT /*+ APPEND PARALLEL(auto)   */
  INTO tbl_value
    (
      REF_MODALITY_TYPE,
      REF_LEGER_CODE,
      DUE_DATE,
      BALANCE,
      REF_CUR_ID
    )SELECT 41,
  a.REF_SARFASL,
  a.tarikh,
  (nvl(-a.bes,0)+nvl(a.bed,0))
  ,4
FROM
  (
  SELECT 41,a.REF_SARFASL,a.tarikh,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 1
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.SEMAH_TA_YEKSAL)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 2
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.SEMAH_TA_YEKSAL)/100
    ELSE NULL
  END,0) BES,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 3
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.SEMAH_TA_YEKSAL)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 4
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.SEMAH_TA_YEKSAL)/100
    ELSE NULL
  END,0) BED,
  4
FROM
  (SELECT 
    tsn.REF_SARFASL,
    sysdate+350 as tarikh,
    TSN.SEMAH_TA_YEKSAL
  FROM akin.TBL_SHIVE_NEGASHT_IFRS tsn
  WHERE tsn.REF_SARFASL IN (
    (SELECT trim(regexp_substr(code, '[^,]+', 1, LEVEL)) AS VALUE
    FROM dual
      CONNECT BY instr(code, ',', 1, LEVEL - 1) > 0
    )) and TSN.SEMAH_TA_YEKSAL <> '0'
  ) a,
  akin.TEJARAT_GL tg
WHERE a.REF_SARFASL = TG.id )a,
  akin.TEJARAT_GL tg
WHERE tg.id = a.ref_sarfasl;

commit;
  INSERT /*+ APPEND PARALLEL(auto)   */
  INTO tbl_value
    (
      REF_MODALITY_TYPE,
      REF_LEGER_CODE,
      DUE_DATE,
      BALANCE,
      REF_CUR_ID
    )SELECT 4,
  a.REF_SARFASL,
  a.tarikh,
  (nvl(-a.bes,0)+nvl(a.bed,0))
   ,4
FROM
  (
  SELECT 4,a.REF_SARFASL,a.tarikh,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 1
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_5SAL)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 2
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_5SAL)/100
    ELSE NULL
  END,0) BES,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 3
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_5SAL)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 4
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_5SAL)/100
    ELSE NULL
  END,0) BED,
  4
FROM
  (SELECT 
    tsn.REF_SARFASL,
    sysdate+1840 as tarikh,
    TSN.YEK_TA_5SAL
  FROM akin.TBL_SHIVE_NEGASHT_IFRS tsn
  WHERE tsn.REF_SARFASL IN (
    (SELECT trim(regexp_substr(code, '[^,]+', 1, LEVEL)) AS VALUE
    FROM dual
      CONNECT BY instr(code, ',', 1, LEVEL - 1) > 0
    )) and TSN.YEK_TA_5SAL <> '0'
  ) a,
  akin.TEJARAT_GL tg
WHERE a.REF_SARFASL = TG.id )a,
  akin.TEJARAT_GL tg
WHERE tg.id = a.ref_sarfasl;

commit;
 INSERT /*+ APPEND PARALLEL(auto)   */
  INTO tbl_value
    (
      REF_MODALITY_TYPE,
      REF_LEGER_CODE,
      DUE_DATE,
      BALANCE,
      REF_CUR_ID
    )SELECT 4,
  a.REF_SARFASL,
  a.tarikh,
  (nvl(-a.bes,0)+nvl(a.bed,0))
  ,4
FROM
  (
  SELECT 41,a.REF_SARFASL,a.tarikh,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 1
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BISHTAR_AZ_5SAL)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 2
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BISHTAR_AZ_5SAL)/100
    ELSE NULL
  END,0) BES,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 3
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BISHTAR_AZ_5SAL)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 4
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BISHTAR_AZ_5SAL)/100
    ELSE NULL
  END,0) BED,
  4
FROM
  (SELECT 
    tsn.REF_SARFASL,
    sysdate+2500 as tarikh,
    TSN.BISHTAR_AZ_5SAL
  FROM akin.TBL_SHIVE_NEGASHT_IFRS tsn
  WHERE tsn.REF_SARFASL IN (
    (SELECT trim(regexp_substr(code, '[^,]+', 1, LEVEL)) AS VALUE
    FROM dual
      CONNECT BY instr(code, ',', 1, LEVEL - 1) > 0
    )) and TSN.BISHTAR_AZ_5SAL <> '0'
  ) a,
  akin.TEJARAT_GL tg
WHERE a.REF_SARFASL = TG.id )a,
  akin.TEJARAT_GL tg
WHERE tg.id = a.ref_sarfasl;

commit;
  INSERT /*+ APPEND PARALLEL(auto)   */
  INTO tbl_value
    (
      REF_MODALITY_TYPE,
      REF_LEGER_CODE,
      DUE_DATE,
      BALANCE,
      REF_CUR_ID
    )SELECT 4,
  a.REF_SARFASL,
  a.tarikh,
  (nvl(-a.bes,0)+nvl(a.bed,0))
   ,4
FROM
  (
  SELECT 41,a.REF_SARFASL,a.tarikh,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 1
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BEDONE_JARIAN)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
      StART WITH ID       = 2
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BEDONE_JARIAN)/100
    ELSE NULL
  END,0) BES,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 3
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BEDONE_JARIAN)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 4
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BEDONE_JARIAN)/100
    ELSE NULL
  END,0) BED,
  4
FROM
  (SELECT 
    tsn.REF_SARFASL,
    null  as tarikh,
    TSN.BEDONE_JARIAN
  FROM akin.TBL_SHIVE_NEGASHT_IFRS tsn
  WHERE tsn.REF_SARFASL IN (
    (SELECT trim(regexp_substr(code, '[^,]+', 1, LEVEL)) AS VALUE
    FROM dual
      CONNECT BY instr(code, ',', 1, LEVEL - 1) > 0
    )) and TSN.BEDONE_JARIAN <> '0'
  ) a,
  akin.TEJARAT_GL tg
WHERE a.REF_SARFASL = TG.id )a,
  akin.TEJARAT_GL tg
WHERE tg.id = a.ref_sarfasl;

commit;
----------------------------- tafavothaye riali ra insert mikonad    1 baraye bed & 0 baraye bes
--   INSERT /*+ APPEND PARALLEL(auto)   */
--  INTO tbl_value
--    (
--      REF_MODALITY_TYPE,
--      REF_LEGER_CODE,
--      DUE_DATE,
--      BALANCE,
--      REF_CUR_ID
--    )
--select 4.1,id,TARIKH_MOASSER,noe,4 from 
--(SELECT -(a.bed-b.mande) as tafazol,
--  b.id,
--  noe,TARIKH_MOASSER
--FROM
--  (SELECT tbl_value.REF_LEGER_CODE,
--    SUM(nvl(BALANCE,0)) AS bed,
--    MAX(due_date) as TARIKH_MOASSER,
--   max( tbl_value.BALANCE) as noe
--  FROM tbl_value
--  WHERE tbl_value.REF_MODALITY_TYPE = 41
--  GROUP BY REF_LEGER_CODE
--  )a,
--  (SELECT id,ABS(NVL(mande,0)) AS mande FROM akin.TEJARAT_GL
--  )b
--WHERE a.REF_LEGER_CODE = b.id
--AND a.bed          <>b.mande);
commit;
end prc_other_code;

  
--****************************************************
--///////////////////////////////////////////////////
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--****************************************************


 PROCEDURE PRC_LOAN(
    RUN_DATE IN DATE )
AS
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:in prasiger shamel tamam amaliyat hay marbot be tashilat mibashad.
  ke iz an dar mpdel ejray farayand estefade mishavad. */
  --------------------------------------------------------------------------------
BEGIN
  DELETE FROM TBL_RATE WHERE TYPE = 'TBL_LOAN';
  COMMIT;
  AKIN.pkg_tjr.PRC_TRANSFER_ACCOUNTING();
  AKIN.pkg_tjr.PRC_TRANSFER_PAYMENT( );
  AKIN.pkg_tjr.PRC_TRANSFER_LOAN( );
  ----------------------------------------TBL_RATE  TBL_LOAN
  INSERT
  INTO PRAGG.TBL_RATE
    (
      RATE,
      TYPE
    )
  SELECT DISTINCT RATE AS NERKH_SUD,
    'TBL_LOAN'
  FROM AKIN.TBL_LOAN
  WHERE RATE IS NOT NULL;
  COMMIT;
  ----------------------------------------UPDATE TBL_LOAN RATE
  UPDATE AKIN.TBL_LOAN a
  SET a.REF_RATE =
    (SELECT r.ref_rate
    FROM tbl_rate r
    WHERE r.rate = a.rate
    AND r.type   ='TBL_LOAN'
    );
  COMMIT;
END PRC_LOAN;


  
--****************************************************
--///////////////////////////////////////////////////
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--****************************************************


 PROCEDURE PRC_DEPOSIT ( RUN_DATE IN DATE )
 AS

 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:in prasiger shamel tamam amaliyat hay marbot be seporde mibashad.
  ke iz an dar mpdel ejray farayand estefade mishavad.
  */
  /*------------------------------------------------------------------------------*/
BEGIN
 DELETE FROM TBL_RATE WHERE TYPE   = 'TBL_DEPOSIT';

 COMMIT;
  AKIN.PRC_TRANSFER_MODALITY_TYPE ();
 COMMIT;
 AKIN.pkg_tjr.PRC_TRANSFER_ACCOUNTING ();
 AKIN.pkg_tjr.PRC_TRANSFER_DEPOSIT( );
 AKIN.pkg_tjr.PRC_TRANSFER_DEPOSIT_PROFIT(TO_DATE(RUN_DATE) );
  /*--------------------------------------TBL_RATE   TBL_DEPOSIT*/
 INSERT INTO PRAGG.TBL_RATE ( RATE,TYPE ) SELECT DISTINCT
  RATE AS NERKH_SUD
 ,'TBL_DEPOSIT'
 FROM AKIN.TBL_DEPOSIT
 WHERE RATE IS NOT NULL;

 COMMIT;
  /*--------------------------------------UPDATE TBL_DEPOSIT RATE*/
 UPDATE AKIN.TBL_DEPOSIT A
  SET
   A.REF_RATE = (
    SELECT
     R.REF_RATE
    FROM TBL_RATE R
    WHERE R.RATE   = A.RATE
     AND
      R.TYPE   = 'TBL_DEPOSIT'
   );

 COMMIT;

END PRC_DEPOSIT;

  
--****************************************************
--///////////////////////////////////////////////////
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--****************************************************


END PKG_TJR;
--------------------------------------------------------
--  DDL for Table PKG_TJR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_TJR" AS 

PROCEDURE PRC_TRANSFER_BRANCH;
PROCEDURE PRC_TRANSFER_CITY;
PROCEDURE PRC_TRANSFER_CURRENCY_REL;--**
PROCEDURE PRC_TRANSFER_CUSTOMER;
PROCEDURE PRC_TRANSFER_DEPOSIT_TYPE;
PROCEDURE PRC_TRANSFER_LEDGER; 
PROCEDURE PRC_TRANSFER_LOAN_TYPE;
PROCEDURE PRC_LEDGER_ARCHIVE(in_date in date);
PROCEDURE PRC_LEDGER_BRANCH(in_date in date);
PROCEDURE prc_other_code;
PROCEDURE PRC_LOAN(RUN_DATE IN DATE );
PROCEDURE PRC_deposit(RUN_DATE IN DATE );


END PKG_TJR;







--
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_TJR" AS

  PROCEDURE PRC_TRANSFER_BRANCH AS
  BEGIN
    insert into PRAGG.TBL_BRANCH(BRN_ID,name,CITY_NAME,REF_CTY_ID,ref_sta_id,region_id,REGION_NAME)
(select shobe.brnch_cd,shobe.brnch_dsc,shahr.nam,shobe.ar_cd,shahr.ostan_id,shobe.ar_cd,shahr.nam from TEJARAT_DB.tbbranch  shobe ,satrap_tejarat.bi_table_shahr@SATRAP shahr
where shobe.ar_cd = shahr.id
and shobe.brnch_dsc  is not null

);
commit;

  END PRC_TRANSFER_BRANCH;

  PROCEDURE PRC_TRANSFER_CITY AS
  BEGIN
insert into TBL_CITY(cty_id,CTY_name,des,ref_sta_id)
(select id,nam,tozih,ostan_id from satrap_tejarat.bi_table_shahr@SATRAP shahr);
commit;

  END PRC_TRANSFER_CITY;

  PROCEDURE PRC_TRANSFER_CURRENCY_REL AS
  BEGIN
    NULL;
  END PRC_TRANSFER_CURRENCY_REL;

  PROCEDURE PRC_TRANSFER_CUSTOMER AS
  BEGIN
   insert into tbl_customer(cus_id,nat_reg_code,name,family)
  (select /*+ PARALLEL(AUTO)*/ id, melli, name, unistr(replace(asciistr(family),'\200F',' ')) from(  --tabdile nim fasele be fasele
  select /*+ PARALLEL(AUTO)*/ nvl(id,1) as id, nvl(melli,1) as melli, name, family, row_number() over (partition by melli order by melli) as row_num,count(*) over (partition by melli) as cnt from(
      SELECT  /*+ PARALLEL(AUTO)*/ DISTINCT to_number(trim(MELLI_ID)) AS id, trim(MELLI_ID) as melli, max(name2) as name, '' as family
        FROM TEJARAT_DB.CUSTOMER_NCOMPANY
        where MELLI_ID is not null and replace(TRANSLATE(trim(MELLI_ID), '0123456789','0000000000'),'0','') IS NULL group by MELLI_ID
    UNION
      SELECT /*+ PARALLEL(AUTO) */ DISTINCT to_number(trim(COD_MELI)) AS id, trim(COD_MELI) as melli,max(name1) as name,max(famili1) as family
        FROM TEJARAT_DB.CUSTOMER_NPERSON
        where cod_meli is not null and replace(TRANSLATE(trim(cod_meli), '0123456789','0000000000'),'0','') IS NULL group by COD_MELI)
        )where row_num = 1 and cnt = 1);
        commit;
  END PRC_TRANSFER_CUSTOMER;

  PROCEDURE PRC_TRANSFER_DEPOSIT_TYPE AS
  BEGIN
insert into PRAGG.TBL_DEPOSIT_TYPE(ref_deposit_type,name)
  (select grp,grp_kind from tejarat_db.sep_kind); 
commit;
END PRC_TRANSFER_DEPOSIT_TYPE;

  PROCEDURE PRC_TRANSFER_LEDGER AS
  BEGIN
INSERT INTO TBL_LEDGER (
 LEDGER_CODE
 ,NAME
 ,DEPTH
 ,PARENT_CODE
) SELECT
 ID
 ,NAME
 ,DEPTH
 ,FATHER_ID
FROM TEJARAT_DB.GL_CODE;
  END PRC_TRANSFER_LEDGER;

  PROCEDURE PRC_TRANSFER_LOAN_TYPE AS
  BEGIN
insert into TBL_LOAN_TYPE(ref_loan_type,name)
  (SELECT REF_NOE_TASHILAT ,NAME 
  from (SELECT DISTINCT CODE as REF_NOE_TASHILAT,NAME  FROM TEJARAT_DB.noe_tashilat ))
;
commit;

INSERT INTO TBL_LEDGER (LEDGER_CODE, NAME, DEPTH) VALUES ('0', 'ريشه', '1');

commit;
END PRC_TRANSFER_LOAN_TYPE;
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\
  PROCEDURE PRC_LEDGER_ARCHIVE(in_date in date) AS
  BEGIN
insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,EFF_DATE,REF_CUR_ID)
    select b.id,b.name,b.father_id,a.mande,b.depth, trunc(in_date),4 from
    (
      select cbi_db, sum(blnc_db + blnc_cr) as mande from tejarat_db.taledger 
        where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db not in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1330','K1320','A0080','A0140','A0160','B0230','C0796') group by cbi_db
    ) a, akin.tbl_treenode_tejarat_5 b where a.cbi_db = b.code;
  commit;
  insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,EFF_DATE,REF_CUR_ID)
    select b.id,b.name,b.father_id,a.mande,b.depth,trunc(in_date),4 from
    (
      select cbi_db, sum(blnc_cr) as mande from tejarat_db.taledger 
        where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db
    ) a, akin.tbl_treenode_tejarat_5 b where a.cbi_db = b.code;
  commit;
  insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,EFF_DATE,REF_CUR_ID)
    select b.id,b.name,b.father_id,a.mande,b.depth, trunc(in_date),4 from
    (
      select cbi_db, sum(blnc_db) as mande from tejarat_db.taledger 
        where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db
    ) a, akin.tbl_treenode_tejarat_5 b, tejarat_db.cbi_map c where a.cbi_db = c.CBI and c.cbi2 = b.code;
  commit;

  for i in reverse 3..5
  loop
  insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,EFF_DATE,REF_CUR_ID)
      select b.id,b.name,b.father_id,a.mande,b.depth,a.tarikh,4 from
        (select sum(balance) as mande, PARENT_CODE, max(eff_date) as tarikh from TBL_LEDGER_ARCHIVE where depth = i and PARENT_CODE not in ('5310210','5320200') group by PARENT_CODE) a,
        akin.tbl_treenode_tejarat_5 b where a.PARENT_CODE = b.id;
        commit;
        if (i = 5) then
  insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,EFF_DATE,REF_CUR_ID)
            select 5310210,'حسابهاي انتظامي',28,a.mande,4, trunc(in_date),4 from
            (
              select sum(blnc_cr) as mande from tejarat_db.taledger 
              where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
              ('X9950','X9951','X9955','X9995','X9997','X9998','L0210','X9954','X9990','X9991','X9994','X9996','x9998')
            ) a;
          commit;
  insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,EFF_DATE,REF_CUR_ID)
            select 5320200,'طرف حسابهاي انتظامي',47,a.mande,4, trunc(in_date),4 from
            (
              select sum(blnc_db) as mande from tejarat_db.taledger 
              where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
              ('X9950','X9951','X9955','X9995','X9997','X9998','L0210','X9954','X9990','X9991','X9994','X9996','x9998')
            ) a;
            commit;
        end if;
        commit;
  end loop;
  commit;  END PRC_LEDGER_ARCHIVE;
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
--/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\

  PROCEDURE PRC_LEDGER_BRANCH(in_date in date) AS
  BEGIN
 execute immediate 'truncate table tjr_varsa.tejarat_gl_br';
  commit;
      insert into TBL_LEDGER_BRANCH(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,REF_BRANCH,EFF_DATE,REF_CUR_ID) 
    select b.id,b.name,b.father_id,a.mande,b.depth,a.brnch_cd, in_date,4 from
    (
      select cbi_db, brnch_cd, sum(blnc_db + blnc_cr) as mande from tejarat_db.taledger 
        where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db not in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db,brnch_cd
    ) a, akin.tbl_treenode_tejarat_5 b where a.cbi_db = b.code;
  commit;
      insert into TBL_LEDGER_BRANCH(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,REF_BRANCH,EFF_DATE,REF_CUR_ID) 
    select b.id,b.name,b.father_id,a.mande,b.depth,a.brnch_cd, in_date,4 from
    (
      select cbi_db, brnch_cd, sum(blnc_cr) as mande from tejarat_db.taledger 
        where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db,brnch_cd
    ) a, akin.tbl_treenode_tejarat_5 b where a.cbi_db = b.code;
  commit;
      insert into TBL_LEDGER_BRANCH(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,REF_BRANCH,EFF_DATE,REF_CUR_ID) 
    select b.id,b.name,b.father_id,a.mande,b.depth,a.brnch_cd, in_date,4 from
    (
      select cbi_db, brnch_cd, sum(blnc_db) as mande from tejarat_db.taledger 
        where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db,brnch_cd
    ) a, akin.tbl_treenode_tejarat_5 b, tejarat_db.cbi_map c where a.cbi_db = c.CBI and c.cbi2 = b.code;
  commit;

  for i in reverse 3..5
  loop
      insert into TBL_LEDGER_BRANCH(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,REF_BRANCH,EFF_DATE,REF_CUR_ID) 
      select b.id,b.name,b.father_id,a.mande,b.depth,a.ref_branch,a.tarikh,4 from
        (select sum(balance) as mande, parent_code, ref_branch, max(eff_date) as tarikh from TBL_LEDGER_BRANCH where depth = i group by parent_code,ref_branch) a,
        akin.tbl_treenode_tejarat_5 b where a.PARENT_CODE = b.id;
        commit;
        if (i = 5) then
    insert into TBL_LEDGER_BRANCH(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,REF_BRANCH,EFF_DATE,REF_CUR_ID)
            select 5310210,'حساب هاي انتظامي',28,a.mande,4, a.brnch_cd, in_date,4 from
            (
              select brnch_cd, sum(blnc_cr) as mande from tejarat_db.taledger 
              where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
              ('X9950','X9951','X9955','X9995','X9997','X9998','L0210','X9954','X9990','X9991','X9994','X9996','x9998') GROUP BY brnch_cd
            ) a;
          commit;
    insert into TBL_LEDGER_BRANCH(LEDGER_CODE,NAME,PARENT_CODE,BALANCE,DEPTH,REF_BRANCH,EFF_DATE,REF_CUR_ID)
            select 5320200,'طرف حساب هاي انتظامي',47,a.mande,4, a.brnch_cd, in_date,4 from
            (
              select brnch_cd, sum(blnc_db) as mande from tejarat_db.taledger 
              where tr_dt = to_char(in_date,'yyyymmdd','nls_calendar = persian') and RCRD_TYP = 1 and cbi_db in
              ('X9950','X9951','X9955','X9995','X9997','X9998','L0210','X9954','X9990','X9991','X9994','X9996','x9998') GROUP BY brnch_cd
            ) a;
            commit;
        end if;
        commit;
  end loop;
  commit;  END PRC_LEDGER_BRANCH;
  
--****************************************************
--///////////////////////////////////////////////////
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--****************************************************

procedure prc_other_code
as
  code VARCHAR2(32000);

begin


  SELECT WMSYS.WM_CONCAT(dk.ID)
INTO code
  FROM akin.TEJARAT_GL dk
  WHERE dk.DEPTH = 5
  AND dk.mande  <> 0
  AND dk.ID     <> 3100700070
  AND dk.id NOT IN
    (SELECT DISTINCT ref_leger_code FROM TBL_VALUE where ref_leger_code is not null
    );
  -- DBMS_OUTPUT.PUT_LINE(code);
  INSERT /*+ APPEND PARALLEL(auto)   */
  INTO tbl_value
    (
      REF_MODALITY_TYPE,
      REF_LEGER_CODE,
      DUE_DATE,
      BALANCE,
      REF_CUR_ID
    )
   SELECT 4,
  a.REF_SARFASL,
  a.tarikh,
  (nvl(-a.bes,0)+nvl(a.bed,0))
  ,4
FROM
  (SELECT 4,a.REF_SARFASL,a.tarikh,
 round( CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 1
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_MAH)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 2
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_MAH)/100
    ELSE NULL
  END,0) BES,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 3
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_MAH)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 4
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_MAH)/100
    ELSE NULL
  END,0) BED,
  4
FROM
  (SELECT 
    tsn.REF_SARFASL,
    sysdate+1 as tarikh,
    TSN.YEK_MAH
  FROM akin.TBL_SHIVE_NEGASHT_IFRS tsn
  WHERE tsn.REF_SARFASL IN (
    (SELECT trim(regexp_substr(code, '[^,]+', 1, LEVEL)) AS VALUE
    FROM dual
      CONNECT BY instr(code, ',', 1, LEVEL - 1) > 0
    )) and TSN.YEK_MAH <> '0'
  ) a,
  akin.TEJARAT_GL tg
WHERE a.REF_SARFASL = TG.id )a,
  akin.TEJARAT_GL tg
WHERE tg.id = a.ref_sarfasl;

commit;
  INSERT /*+ APPEND PARALLEL(auto)   */
  INTO tbl_value
    (
      REF_MODALITY_TYPE,
      REF_LEGER_CODE,
      DUE_DATE,
      BALANCE,
      REF_CUR_ID
    )SELECT 4,
  a.REF_SARFASL,
  a.tarikh,
  (nvl(-a.bes,0)+nvl(a.bed,0))
  ,4
FROM
  (
  SELECT 4,a.REF_SARFASL,a.tarikh,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 1
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_SEMAH)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 2
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_SEMAH)/100
    ELSE NULL
  END,0) BES,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 3
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_SEMAH)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 4
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_SEMAH)/100
    ELSE NULL
  END,0) BED,
  4
FROM
  (SELECT 
    tsn.REF_SARFASL,
    sysdate+80 as tarikh,
    TSN.YEK_TA_SEMAH
  FROM akin.TBL_SHIVE_NEGASHT_IFRS tsn
  WHERE tsn.REF_SARFASL IN (
    (SELECT trim(regexp_substr(code, '[^,]+', 1, LEVEL)) AS VALUE
    FROM dual
      CONNECT BY instr(code, ',', 1, LEVEL - 1) > 0
    )) and TSN.YEK_TA_SEMAH <> '0'
  ) a,
  akin.TEJARAT_GL tg
WHERE a.REF_SARFASL = TG.id )a,
  akin.TEJARAT_GL tg
WHERE tg.id = a.ref_sarfasl;

commit;
  INSERT /*+ APPEND PARALLEL(auto)   */
  INTO tbl_value
    (
      REF_MODALITY_TYPE,
      REF_LEGER_CODE,
      DUE_DATE,
      BALANCE,
      REF_CUR_ID
    )SELECT 41,
  a.REF_SARFASL,
  a.tarikh,
  (nvl(-a.bes,0)+nvl(a.bed,0))
  ,4
FROM
  (
  SELECT 41,a.REF_SARFASL,a.tarikh,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 1
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.SEMAH_TA_YEKSAL)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 2
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.SEMAH_TA_YEKSAL)/100
    ELSE NULL
  END,0) BES,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 3
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.SEMAH_TA_YEKSAL)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 4
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.SEMAH_TA_YEKSAL)/100
    ELSE NULL
  END,0) BED,
  4
FROM
  (SELECT 
    tsn.REF_SARFASL,
    sysdate+350 as tarikh,
    TSN.SEMAH_TA_YEKSAL
  FROM akin.TBL_SHIVE_NEGASHT_IFRS tsn
  WHERE tsn.REF_SARFASL IN (
    (SELECT trim(regexp_substr(code, '[^,]+', 1, LEVEL)) AS VALUE
    FROM dual
      CONNECT BY instr(code, ',', 1, LEVEL - 1) > 0
    )) and TSN.SEMAH_TA_YEKSAL <> '0'
  ) a,
  akin.TEJARAT_GL tg
WHERE a.REF_SARFASL = TG.id )a,
  akin.TEJARAT_GL tg
WHERE tg.id = a.ref_sarfasl;

commit;
  INSERT /*+ APPEND PARALLEL(auto)   */
  INTO tbl_value
    (
      REF_MODALITY_TYPE,
      REF_LEGER_CODE,
      DUE_DATE,
      BALANCE,
      REF_CUR_ID
    )SELECT 4,
  a.REF_SARFASL,
  a.tarikh,
  (nvl(-a.bes,0)+nvl(a.bed,0))
   ,4
FROM
  (
  SELECT 4,a.REF_SARFASL,a.tarikh,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 1
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_5SAL)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 2
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_5SAL)/100
    ELSE NULL
  END,0) BES,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 3
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_5SAL)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 4
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.YEK_TA_5SAL)/100
    ELSE NULL
  END,0) BED,
  4
FROM
  (SELECT 
    tsn.REF_SARFASL,
    sysdate+1840 as tarikh,
    TSN.YEK_TA_5SAL
  FROM akin.TBL_SHIVE_NEGASHT_IFRS tsn
  WHERE tsn.REF_SARFASL IN (
    (SELECT trim(regexp_substr(code, '[^,]+', 1, LEVEL)) AS VALUE
    FROM dual
      CONNECT BY instr(code, ',', 1, LEVEL - 1) > 0
    )) and TSN.YEK_TA_5SAL <> '0'
  ) a,
  akin.TEJARAT_GL tg
WHERE a.REF_SARFASL = TG.id )a,
  akin.TEJARAT_GL tg
WHERE tg.id = a.ref_sarfasl;

commit;
 INSERT /*+ APPEND PARALLEL(auto)   */
  INTO tbl_value
    (
      REF_MODALITY_TYPE,
      REF_LEGER_CODE,
      DUE_DATE,
      BALANCE,
      REF_CUR_ID
    )SELECT 4,
  a.REF_SARFASL,
  a.tarikh,
  (nvl(-a.bes,0)+nvl(a.bed,0))
  ,4
FROM
  (
  SELECT 41,a.REF_SARFASL,a.tarikh,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 1
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BISHTAR_AZ_5SAL)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 2
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BISHTAR_AZ_5SAL)/100
    ELSE NULL
  END,0) BES,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 3
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BISHTAR_AZ_5SAL)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 4
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BISHTAR_AZ_5SAL)/100
    ELSE NULL
  END,0) BED,
  4
FROM
  (SELECT 
    tsn.REF_SARFASL,
    sysdate+2500 as tarikh,
    TSN.BISHTAR_AZ_5SAL
  FROM akin.TBL_SHIVE_NEGASHT_IFRS tsn
  WHERE tsn.REF_SARFASL IN (
    (SELECT trim(regexp_substr(code, '[^,]+', 1, LEVEL)) AS VALUE
    FROM dual
      CONNECT BY instr(code, ',', 1, LEVEL - 1) > 0
    )) and TSN.BISHTAR_AZ_5SAL <> '0'
  ) a,
  akin.TEJARAT_GL tg
WHERE a.REF_SARFASL = TG.id )a,
  akin.TEJARAT_GL tg
WHERE tg.id = a.ref_sarfasl;

commit;
  INSERT /*+ APPEND PARALLEL(auto)   */
  INTO tbl_value
    (
      REF_MODALITY_TYPE,
      REF_LEGER_CODE,
      DUE_DATE,
      BALANCE,
      REF_CUR_ID
    )SELECT 4,
  a.REF_SARFASL,
  a.tarikh,
  (nvl(-a.bes,0)+nvl(a.bed,0))
   ,4
FROM
  (
  SELECT 41,a.REF_SARFASL,a.tarikh,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 1
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BEDONE_JARIAN)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
      StART WITH ID       = 2
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BEDONE_JARIAN)/100
    ELSE NULL
  END,0) BES,
  round(CASE
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 3
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BEDONE_JARIAN)/100
    WHEN tg.id IN
      (SELECT t.ID
      FROM akin.TEJARAT_GL T
      WHERE DEPTH           = 5
        START WITH ID       = 4
        CONNECT BY PRIOR ID = T.FATHER_ID
      )
    THEN ABS(tg.MANDE)*(a.BEDONE_JARIAN)/100
    ELSE NULL
  END,0) BED,
  4
FROM
  (SELECT 
    tsn.REF_SARFASL,
    null  as tarikh,
    TSN.BEDONE_JARIAN
  FROM akin.TBL_SHIVE_NEGASHT_IFRS tsn
  WHERE tsn.REF_SARFASL IN (
    (SELECT trim(regexp_substr(code, '[^,]+', 1, LEVEL)) AS VALUE
    FROM dual
      CONNECT BY instr(code, ',', 1, LEVEL - 1) > 0
    )) and TSN.BEDONE_JARIAN <> '0'
  ) a,
  akin.TEJARAT_GL tg
WHERE a.REF_SARFASL = TG.id )a,
  akin.TEJARAT_GL tg
WHERE tg.id = a.ref_sarfasl;

commit;
----------------------------- tafavothaye riali ra insert mikonad    1 baraye bed & 0 baraye bes
--   INSERT /*+ APPEND PARALLEL(auto)   */
--  INTO tbl_value
--    (
--      REF_MODALITY_TYPE,
--      REF_LEGER_CODE,
--      DUE_DATE,
--      BALANCE,
--      REF_CUR_ID
--    )
--select 4.1,id,TARIKH_MOASSER,noe,4 from 
--(SELECT -(a.bed-b.mande) as tafazol,
--  b.id,
--  noe,TARIKH_MOASSER
--FROM
--  (SELECT tbl_value.REF_LEGER_CODE,
--    SUM(nvl(BALANCE,0)) AS bed,
--    MAX(due_date) as TARIKH_MOASSER,
--   max( tbl_value.BALANCE) as noe
--  FROM tbl_value
--  WHERE tbl_value.REF_MODALITY_TYPE = 41
--  GROUP BY REF_LEGER_CODE
--  )a,
--  (SELECT id,ABS(NVL(mande,0)) AS mande FROM akin.TEJARAT_GL
--  )b
--WHERE a.REF_LEGER_CODE = b.id
--AND a.bed          <>b.mande);
commit;
end prc_other_code;

  
--****************************************************
--///////////////////////////////////////////////////
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--****************************************************


 PROCEDURE PRC_LOAN(
    RUN_DATE IN DATE )
AS
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:in prasiger shamel tamam amaliyat hay marbot be tashilat mibashad.
  ke iz an dar mpdel ejray farayand estefade mishavad. */
  --------------------------------------------------------------------------------
BEGIN
  DELETE FROM TBL_RATE WHERE TYPE = 'TBL_LOAN';
  COMMIT;
  AKIN.pkg_tjr.PRC_TRANSFER_ACCOUNTING();
  AKIN.pkg_tjr.PRC_TRANSFER_PAYMENT( );
  AKIN.pkg_tjr.PRC_TRANSFER_LOAN( );
  ----------------------------------------TBL_RATE  TBL_LOAN
  INSERT
  INTO PRAGG.TBL_RATE
    (
      RATE,
      TYPE
    )
  SELECT DISTINCT RATE AS NERKH_SUD,
    'TBL_LOAN'
  FROM AKIN.TBL_LOAN
  WHERE RATE IS NOT NULL;
  COMMIT;
  ----------------------------------------UPDATE TBL_LOAN RATE
  UPDATE AKIN.TBL_LOAN a
  SET a.REF_RATE =
    (SELECT r.ref_rate
    FROM tbl_rate r
    WHERE r.rate = a.rate
    AND r.type   ='TBL_LOAN'
    );
  COMMIT;
END PRC_LOAN;


  
--****************************************************
--///////////////////////////////////////////////////
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--****************************************************


 PROCEDURE PRC_DEPOSIT ( RUN_DATE IN DATE )
 AS

 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:in prasiger shamel tamam amaliyat hay marbot be seporde mibashad.
  ke iz an dar mpdel ejray farayand estefade mishavad.
  */
  /*------------------------------------------------------------------------------*/
BEGIN
 DELETE FROM TBL_RATE WHERE TYPE   = 'TBL_DEPOSIT';

 COMMIT;
  AKIN.PRC_TRANSFER_MODALITY_TYPE ();
 COMMIT;
 AKIN.pkg_tjr.PRC_TRANSFER_ACCOUNTING ();
 AKIN.pkg_tjr.PRC_TRANSFER_DEPOSIT( );
 AKIN.pkg_tjr.PRC_TRANSFER_DEPOSIT_PROFIT(TO_DATE(RUN_DATE) );
  /*--------------------------------------TBL_RATE   TBL_DEPOSIT*/
 INSERT INTO PRAGG.TBL_RATE ( RATE,TYPE ) SELECT DISTINCT
  RATE AS NERKH_SUD
 ,'TBL_DEPOSIT'
 FROM AKIN.TBL_DEPOSIT
 WHERE RATE IS NOT NULL;

 COMMIT;
  /*--------------------------------------UPDATE TBL_DEPOSIT RATE*/
 UPDATE AKIN.TBL_DEPOSIT A
  SET
   A.REF_RATE = (
    SELECT
     R.REF_RATE
    FROM TBL_RATE R
    WHERE R.RATE   = A.RATE
     AND
      R.TYPE   = 'TBL_DEPOSIT'
   );

 COMMIT;

END PRC_DEPOSIT;

  
--****************************************************
--///////////////////////////////////////////////////
--\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--****************************************************


END PKG_TJR;
--------------------------------------------------------
--  DDL for Table PKG_BALANCE_SHEET
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_BALANCE_SHEET" as 

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_COMPARE_BALANCE_SHEET 
(
  INPAR_DATE IN VARCHAR2 
, INPAR_cur IN NUMBER 
, INPAR_DATE2 IN VARCHAR2 
, inpar_cur2 IN NUMBER 
)RETURN VARCHAR2 ;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

end PKG_BALANCE_SHEET;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_BALANCE_SHEET" as
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
function fnc_compare_balance_sheet 
(
  inpar_date in varchar2 
, inpar_cur in number 
, inpar_date2 in varchar2 
, inpar_cur2 in number 
)return varchar2  as
  begin
   RETURN 
'SELECT LEDGER_CODE as "id"
 ,NAME as "text"
 ,DEPTH as "level"
 ,PARENT_CODE as "parent"
  ,nvl("1",0) "x1",nvl("2",0) "x2"
  FROM
(
select LEDGER_CODE
 ,NAME
 ,DEPTH
 ,PARENT_CODE
 , BALANCE
 ,REF_CUR_ID
  from TBL_LEDGER_ARCHIVE where to_date(EFF_DATE,''yyyy-mm-dd'') =to_date(to_date('''||INPAR_DATE||''',''yyyy-mm-dd''),''yyyy-mm-dd'') and REF_CUR_ID = '||INPAR_cur||'
union
select LEDGER_CODE
 ,NAME
 ,DEPTH
 ,PARENT_CODE
 ,  BALANCE
 ,REF_CUR_ID+200
 from TBL_LEDGER_ARCHIVE where to_date(EFF_DATE,''yyyy-mm-dd'') =to_date(to_date('''||INPAR_DATE||''',''yyyy-mm-dd''),''yyyy-mm-dd'') and REF_CUR_ID = '||INPAR_cur2||')
PIVOT
(
  max(balance)
  FOR REF_CUR_ID IN ('||INPAR_cur||' as "1", '||INPAR_cur2||'+200 as "2")
) order by ledger_code';
  end fnc_compare_balance_sheet;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
end pkg_balance_sheet;
--------------------------------------------------------
--  DDL for Table PKG_BALANCE_SHEET
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_BALANCE_SHEET" as 

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_COMPARE_BALANCE_SHEET 
(
  INPAR_DATE IN VARCHAR2 
, INPAR_cur IN NUMBER 
, INPAR_DATE2 IN VARCHAR2 
, inpar_cur2 IN NUMBER 
)RETURN VARCHAR2 ;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

end PKG_BALANCE_SHEET;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_BALANCE_SHEET" as
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
function fnc_compare_balance_sheet 
(
  inpar_date in varchar2 
, inpar_cur in number 
, inpar_date2 in varchar2 
, inpar_cur2 in number 
)return varchar2  as
  begin
   RETURN 
'SELECT LEDGER_CODE as "id"
 ,NAME as "text"
 ,DEPTH as "level"
 ,PARENT_CODE as "parent"
  ,nvl("1",0) "x1",nvl("2",0) "x2"
  FROM
(
select LEDGER_CODE
 ,NAME
 ,DEPTH
 ,PARENT_CODE
 , BALANCE
 ,REF_CUR_ID
  from TBL_LEDGER_ARCHIVE where to_date(EFF_DATE,''yyyy-mm-dd'') =to_date(to_date('''||INPAR_DATE||''',''yyyy-mm-dd''),''yyyy-mm-dd'') and REF_CUR_ID = '||INPAR_cur||'
union
select LEDGER_CODE
 ,NAME
 ,DEPTH
 ,PARENT_CODE
 ,  BALANCE
 ,REF_CUR_ID+200
 from TBL_LEDGER_ARCHIVE where to_date(EFF_DATE,''yyyy-mm-dd'') =to_date(to_date('''||INPAR_DATE||''',''yyyy-mm-dd''),''yyyy-mm-dd'') and REF_CUR_ID = '||INPAR_cur2||')
PIVOT
(
  max(balance)
  FOR REF_CUR_ID IN ('||INPAR_cur||' as "1", '||INPAR_cur2||'+200 as "2")
) order by ledger_code';
  end fnc_compare_balance_sheet;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
end pkg_balance_sheet;
--------------------------------------------------------
--  DDL for Table PKG_DUE_DATE_LOAN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_DUE_DATE_LOAN" AS 

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_DUE_DATE_PROFILE_REPORT (  --OK
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_TIMING_PROFILE     IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_REPORT_VALUE ( INPAR_ID_REPORT IN NUMBER );--OK
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;--OK
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_TREE RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_LEAF ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_DETAIL (
  INPAR_ID     IN NUMBER
 ,INPAR_TYPE   IN VARCHAR2
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_count ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_DUE_DATE_FIRS_TIME;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_DUE_DATE_loan;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_DUE_DATE_LOAN" AS

 
 PROCEDURE PRC_DUE_DATE_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_TIMING_PROFILE     IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,REF_TIMING_PROFILE
   ,TYPE
   ,CATEGORY
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,INPAR_TIMING_PROFILE
   ,INPAR_TYPE
   ,'DUEDATE_LOAN'
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,REF_TIMING_PROFILE = INPAR_TIMING_PROFILE
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
 END PRC_DUE_DATE_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_REPORT_VALUE ( INPAR_ID_REPORT IN NUMBER ) AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Morteza.Sahhi
  Editor Name:
  Release Date/Time:1396/02/24-10:00
  Edit Name:
  Version: 1.1
  Category:2
  Description:in procedure baraye enteghal dadehaye morde niaz az value be TBL_VALUE_TEMP bar asas profilehaye mokhtalefist ke karbar taeen karde
  */
  /*------------------------------------------------------------------------------*/

  VAR_QUERY     VARCHAR2(4000);
  ID_LOAN       NUMBER;
  ID_DEP        NUMBER;
  ID_CUR        NUMBER;
  ID_CUS        NUMBER;
  ID_BRANCH     NUMBER;
  ID_TIMING     NUMBER;
  DATE_TYPE1    DATE := SYSDATE;
  VAR_REP_REQ   NUMBER;
  LOC_S         TIMESTAMP;
  LOC_F         TIMESTAMP;
  LOC_MEGHDAR   NUMBER;
 BEGIN
  EXECUTE IMMEDIATE 'alter session set nls_date_format=''DD-MM-RRRR''';
/*  execute immediate 'alter session set nls_date_format=''DD-MM-RRRR''';*/
  SYS.DBMS_OUTPUT.ENABLE(3000000);
  /******profilhaye mokhtalefi ke karbar baraye in gozaresh entekhab karde ra daron moteghayer ham nam profil mirizim ******/
  SELECT
   MAX(ID)
  INTO
   ID_TIMING
  FROM TBL_TIMING_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_TIMING_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );
  
  /******be ezaye tedad bazehayee ke dar profile zamani vojod darad halghe ro ejra mikonim*****--*/

  COMMIT;
  SELECT
   MAX(ID)
  INTO
   VAR_REP_REQ
  FROM TBL_REPREQ;
    /*--------------TBL_REPPER-----------------*/
  /******enteghal profile zamani be jadval repper*****--*/
  /*-----------------------------------------*/

  INSERT INTO TBL_REPPER (
   REF_TIMING_PROFILE
  ,PERIOD_NAME
  ,PERIOD_DATE
  ,PERIOD_START
  ,PERIOD_END
  ,PERIOD_COLOR
  ,REF_REPORT_ID
  ,OLD_ID
  ,REF_REQ_ID
  ) SELECT
   REF_TIMING_PROFILE
  ,PERIOD_NAME
  ,PERIOD_DATE
  ,PERIOD_START
  ,PERIOD_END
  ,PERIOD_COLOR
  ,INPAR_ID_REPORT
  ,ID
  ,VAR_REP_REQ
  FROM TBL_TIMING_PROFILE_DETAIL
  WHERE REF_TIMING_PROFILE   = ID_TIMING;

  COMMIT;
  FOR I IN (
   SELECT
    TTPD.ID
   ,TTP.TYPE
   ,TTPD.PERIOD_NAME
   ,TTPD.PERIOD_DATE
   ,TTPD.PERIOD_START
   ,TTPD.PERIOD_END
   ,TTPD.PERIOD_COLOR
   FROM TBL_TIMING_PROFILE TTP
   ,    TBL_TIMING_PROFILE_DETAIL TTPD
   WHERE TTP.ID   = TTPD.REF_TIMING_PROFILE
    AND
     TTP.ID   = ID_TIMING
  ) LOOP
   IF
    ( I.TYPE = 1 )
   THEN
      /******agar profile zamani entekhab shode bazehee bashad *****--*/
    SELECT
     '  
INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
 REP_REQ
 ,PARENT
 ,CHILD
 ,VALUE
 ,DEPTH
 ,REF_EFF_DATE
 ,REGION_ID
 ,TYPE
 ,RATE,
 name,
 count
)  
SELECT ' ||
     VAR_REP_REQ ||
     ' AS REP_REQ
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_LOAN_TYPE  AS REF_LOAN_TYPE
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_LOAN_TYPE ||
 100 ||
 TD.RATE AS RATE
 ,SUM(TLP.AMOUNT)
 ,4 AS DEPTH
 ,' ||
     I.ID ||
     '
 ,TB.REGION_ID ,
 TD.REF_LOAN_TYPE,
 TD.RATE  ,
 ''نرخ سود ''||TD.RATE,
 count(TD.RATE)
 FROM AKIN.TBL_LOAN TD,
AKIN.TBL_LOAN_PAYMENT TLP
 ,  TBL_BRANCH TB
WHERE DUE_DATE > to_date(''' ||
     DATE_TYPE1 ||
     ''') and DUE_DATE <= to_date(''' ||
     DATE_TYPE1 ||
     ''')+' ||
     I.PERIOD_DATE ||
     ' and TLP.REF_LON_ID = TD.LON_ID AND  TD.REF_BRANCH   = TB.BRN_ID
GROUP BY
 TB.REGION_ID
 ,TD.REF_LOAN_TYPE
 ,TD.RATE;
'
    INTO
     VAR_QUERY
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;

    
    
    DATE_TYPE1   := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
   ELSE
      /******agar profile zamani entekhab shode tarikhi bashad *****--*/
    SELECT
     '  
INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
 REP_REQ
 ,PARENT
 ,CHILD
 ,VALUE
 ,DEPTH
 ,REF_EFF_DATE
 ,REGION_ID
 ,TYPE
 ,RATE,
 name,
 count
)  
SELECT ' ||
     VAR_REP_REQ ||
     ' AS REP_REQ
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_LOAN_TYPE  AS REF_LOAN_TYPE
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_LOAN_TYPE ||
 100 ||
 TD.RATE AS RATE
 ,SUM(TLP.AMOUNT)
 ,4 AS DEPTH
 ,' ||
     I.ID ||
     '
 ,TB.REGION_ID ,
 TD.REF_LOAN_TYPE,
 TD.RATE  ,
 ''نرخ سود ''||TD.RATE,
 count(TD.RATE)
 FROM AKIN.TBL_LOAN TD,
AKIN.TBL_LOAN_PAYMENT TLP
 ,  TBL_BRANCH TB
WHERE DUE_DATE > to_date(''' ||
     I.PERIOD_START ||
     ''',''dd-mm-yyyy'') and TD.DUE_DATE <= to_date(''' ||
     I.PERIOD_END ||
     ''',''dd-mm-yyyy'') AND TLP.REF_LON_ID = TD.LON_ID AND  TD.REF_BRANCH   = TB.BRN_ID
GROUP BY
 TB.REGION_ID
 ,TD.REF_LOAN_TYPE
 ,TD.RATE;
 '
    INTO
     VAR_QUERY
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;
  
   END IF;
  END LOOP;

  COMMIT;
  UPDATE TBL_DUE_DATE_DETAIL_LOAN DDD
   SET
    DDD.REF_EFF_DATE = (
     SELECT
      ID
     FROM TBL_REPPER
     WHERE REF_REQ_ID          = VAR_REP_REQ
      AND
       TBL_REPPER.OLD_ID   = DDD.REF_EFF_DATE
    )
  WHERE DDD.REP_REQ   = VAR_REP_REQ;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   VAR_REP_REQ
  ,DDD.PARENT
  ,DDD.CHILD
  ,0
  ,DDD.DEPTH
  ,TP.ID
  ,DDD.REGION_ID
  ,DDD.TYPE
  ,DDD.RATE
  ,DDD.NAME
  FROM TBL_DUE_DATE_DETAIL_LOAN DDD
  ,    TBL_REPPER TP
  WHERE DDD.REP_REQ     = 0
   AND
    DDD.DEPTH       = 4
   AND
    TP.REF_REQ_ID   = VAR_REP_REQ
   AND
    DDD.CHILD || TP.ID NOT IN (
     SELECT
      CHILD || REF_EFF_DATE
     FROM TBL_DUE_DATE_DETAIL_LOAN
     WHERE REP_REQ   = VAR_REP_REQ
    );

  COMMIT;
  /*-------------------------------------------------------------------------------------------*/
  LOC_F         := SYSTIMESTAMP;
  LOC_MEGHDAR   := SQL%ROWCOUNT;
 EXCEPTION
  WHEN OTHERS THEN
   RAISE;
 END PRC_DUE_DATE_REPORT_VALUE;

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''DUEDATE_LOAN''';
  RETURN VAR2;
 END FNC_DUE_DATE_ALL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_TREE RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'select
 parent as "parent",child as "id",depth as "level",name as "text",RATE "rate",type "type",REGION_ID "regionId"
from
  tbl_due_date_detail_loan
  where rep_req = 0
start with
  parent is null
connect by
  prior child=parent'
;
  RETURN VAR2;
 END FNC_DUE_DATE_GET_TREE;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_LEAF ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := ' SELECT
  PARENT as "parent"
 ,CHILD as "id"
 ,VALUE as "value"
 ,DEPTH as "depth"
 ,REF_EFF_DATE as "effDate"
 ,REGION_ID as "regionId"
 ,TYPE as "type"
 ,RATE as "rate"
 , count as "xcount"
FROM TBL_DUE_DATE_DETAIL_loan
where REP_REQ ='
|| INPAR_ID || '';
  RETURN VAR2;
 END FNC_DUE_DATE_GET_LEAF;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_DETAIL (
  INPAR_ID     IN NUMBER
 ,INPAR_TYPE   IN VARCHAR2
 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  IF
   ( UPPER(INPAR_TYPE) = 'TYPE' )
  THEN
   VAR2   := 'SELECT DISTINCT DDD.TYPE AS "id",DT.NAME as "name" FROM TBL_DUE_DATE_DETAIL_loan DDD,TBL_loan_TYPE DT  WHERE DDD.REP_REQ = '
|| INPAR_ID || ' AND DDD.TYPE = DT.REF_loan_TYPE
ORDER BY DT.NAME';
  END IF;

  IF
   ( UPPER(INPAR_TYPE) = 'RATE' )
  THEN
   VAR2   := 'SELECT DISTINCT DDD.RATE as "id",DDD.NAME as "name" FROM TBL_DUE_DATE_DETAIL_loan DDD WHERE DDD.REP_REQ = ' || INPAR_ID || ' and ddd.RATE is not null  
ORDER BY DDD.RATE'
;
  END IF;

  IF
   ( UPPER(INPAR_TYPE) = 'REGION' )
  THEN
   VAR2   := 'SELECT DISTINCT DDD.REGION_ID as "id",TB.REGION_NAME as "name"  FROM TBL_DUE_DATE_DETAIL_loan DDD,TBL_BRANCH TB WHERE DDD.REP_REQ = '
|| INPAR_ID || ' AND TB.REGION_ID = DDD.REGION_ID 
ORDER BY DDD.REGION_ID';
  END IF;

  RETURN VAR2;
 END FNC_DUE_DATE_GET_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_FIRS_TIME
  AS
 BEGIN
  INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   0
  ,100 ||
   TB.REGION_ID ||
   100 ||
   TD.REF_LOAN_TYPE AS REF_LOAN_TYPE
  ,100 ||
   TB.REGION_ID ||
   100 ||
   TD.REF_LOAN_TYPE ||
   100 ||
   TD.RATE AS RATE
  ,SUM(TD.CURRENT_AMOUNT)
  ,4
  ,0000
  ,TB.REGION_ID
  ,TD.REF_LOAN_TYPE
  ,TD.RATE
  ,'نرخ سود ' || TD.RATE
  FROM AKIN.TBL_LOAN TD
  ,    TBL_BRANCH TB
  WHERE TD.REF_BRANCH   = TB.BRN_ID
  GROUP BY
   TB.REGION_ID
  ,TD.REF_LOAN_TYPE
  ,TD.RATE;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   0 AS REP_REQ
  ,100 || REGION_ID
  ,PARENT
  ,SUM(VALUE)
  ,3
  ,0 AS EFFDATE
  ,REGION_ID
  ,MAX(TYPE)
  ,-1 AS RATE
  ,MAX( (
    SELECT DISTINCT
     TDT.NAME
    FROM TBL_LOAN_TYPE TDT
    WHERE TDT.REF_LOAN_TYPE   = TYPE
   ) ) AS NAME
  FROM TBL_DUE_DATE_DETAIL_LOAN
  GROUP BY
   PARENT
  ,REGION_ID;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  )  SELECT
   0
  ,0
  ,b.PARENT
  ,SUM(b.VALUE)
  ,2
  ,0
  ,b.REGION_ID
  ,0
  ,-1
  ,max((select  distinct TBL_BRANCH.REGION_NAME from TBL_BRANCH where TBL_BRANCH.REGION_ID =b.REGION_ID)) as name
  FROM TBL_DUE_DATE_DETAIL_LOAN b
  WHERE b.DEPTH   = 3
  GROUP BY
   b.PARENT
  ,b.REGION_ID;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   0
  ,''
  ,0
  ,SUM(VALUE)
  ,1
  ,0
  ,0
  ,0
  ,-1
  ,'??'
  FROM TBL_DUE_DATE_DETAIL_LOAN
  WHERE DEPTH   = 2
  GROUP BY
   PARENT;

  COMMIT;
 END;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_count ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT
  PARENT as "parent"
 ,CHILD as "id"
 ,VALUE as "value"
 ,DEPTH as "depth"
 ,REF_EFF_DATE as "effDate"
 ,REGION_ID as "regionId"
 ,TYPE as "type"
 ,RATE as "rate"
FROM TBL_DUE_DATE_DETAIL_LOAN
where REP_REQ ='
|| INPAR_ID || ' and DEPTH is null';
  RETURN VAR2;
 END FNC_DUE_DATE_GET_count;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

END PKG_DUE_DATE_LOAN;
--------------------------------------------------------
--  DDL for Table PKG_DUE_DATE_LOAN
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_DUE_DATE_LOAN" AS 

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_DUE_DATE_PROFILE_REPORT (  --OK
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_TIMING_PROFILE     IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_REPORT_VALUE ( INPAR_ID_REPORT IN NUMBER );--OK
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;--OK
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_TREE RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_LEAF ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_DETAIL (
  INPAR_ID     IN NUMBER
 ,INPAR_TYPE   IN VARCHAR2
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_count ( INPAR_ID IN NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_DUE_DATE_FIRS_TIME;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_DUE_DATE_loan;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_DUE_DATE_LOAN" AS

 
 PROCEDURE PRC_DUE_DATE_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_TIMING_PROFILE     IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,REF_TIMING_PROFILE
   ,TYPE
   ,CATEGORY
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,INPAR_TIMING_PROFILE
   ,INPAR_TYPE
   ,'DUEDATE_LOAN'
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,REF_TIMING_PROFILE = INPAR_TIMING_PROFILE
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
 END PRC_DUE_DATE_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_REPORT_VALUE ( INPAR_ID_REPORT IN NUMBER ) AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Morteza.Sahhi
  Editor Name:
  Release Date/Time:1396/02/24-10:00
  Edit Name:
  Version: 1.1
  Category:2
  Description:in procedure baraye enteghal dadehaye morde niaz az value be TBL_VALUE_TEMP bar asas profilehaye mokhtalefist ke karbar taeen karde
  */
  /*------------------------------------------------------------------------------*/

  VAR_QUERY     VARCHAR2(4000);
  ID_LOAN       NUMBER;
  ID_DEP        NUMBER;
  ID_CUR        NUMBER;
  ID_CUS        NUMBER;
  ID_BRANCH     NUMBER;
  ID_TIMING     NUMBER;
  DATE_TYPE1    DATE := SYSDATE;
  VAR_REP_REQ   NUMBER;
  LOC_S         TIMESTAMP;
  LOC_F         TIMESTAMP;
  LOC_MEGHDAR   NUMBER;
 BEGIN
  EXECUTE IMMEDIATE 'alter session set nls_date_format=''DD-MM-RRRR''';
/*  execute immediate 'alter session set nls_date_format=''DD-MM-RRRR''';*/
  SYS.DBMS_OUTPUT.ENABLE(3000000);
  /******profilhaye mokhtalefi ke karbar baraye in gozaresh entekhab karde ra daron moteghayer ham nam profil mirizim ******/
  SELECT
   MAX(ID)
  INTO
   ID_TIMING
  FROM TBL_TIMING_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_TIMING_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );
  
  /******be ezaye tedad bazehayee ke dar profile zamani vojod darad halghe ro ejra mikonim*****--*/

  COMMIT;
  SELECT
   MAX(ID)
  INTO
   VAR_REP_REQ
  FROM TBL_REPREQ;
    /*--------------TBL_REPPER-----------------*/
  /******enteghal profile zamani be jadval repper*****--*/
  /*-----------------------------------------*/

  INSERT INTO TBL_REPPER (
   REF_TIMING_PROFILE
  ,PERIOD_NAME
  ,PERIOD_DATE
  ,PERIOD_START
  ,PERIOD_END
  ,PERIOD_COLOR
  ,REF_REPORT_ID
  ,OLD_ID
  ,REF_REQ_ID
  ) SELECT
   REF_TIMING_PROFILE
  ,PERIOD_NAME
  ,PERIOD_DATE
  ,PERIOD_START
  ,PERIOD_END
  ,PERIOD_COLOR
  ,INPAR_ID_REPORT
  ,ID
  ,VAR_REP_REQ
  FROM TBL_TIMING_PROFILE_DETAIL
  WHERE REF_TIMING_PROFILE   = ID_TIMING;

  COMMIT;
  FOR I IN (
   SELECT
    TTPD.ID
   ,TTP.TYPE
   ,TTPD.PERIOD_NAME
   ,TTPD.PERIOD_DATE
   ,TTPD.PERIOD_START
   ,TTPD.PERIOD_END
   ,TTPD.PERIOD_COLOR
   FROM TBL_TIMING_PROFILE TTP
   ,    TBL_TIMING_PROFILE_DETAIL TTPD
   WHERE TTP.ID   = TTPD.REF_TIMING_PROFILE
    AND
     TTP.ID   = ID_TIMING
  ) LOOP
   IF
    ( I.TYPE = 1 )
   THEN
      /******agar profile zamani entekhab shode bazehee bashad *****--*/
    SELECT
     '  
INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
 REP_REQ
 ,PARENT
 ,CHILD
 ,VALUE
 ,DEPTH
 ,REF_EFF_DATE
 ,REGION_ID
 ,TYPE
 ,RATE,
 name,
 count
)  
SELECT ' ||
     VAR_REP_REQ ||
     ' AS REP_REQ
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_LOAN_TYPE  AS REF_LOAN_TYPE
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_LOAN_TYPE ||
 100 ||
 TD.RATE AS RATE
 ,SUM(TLP.AMOUNT)
 ,4 AS DEPTH
 ,' ||
     I.ID ||
     '
 ,TB.REGION_ID ,
 TD.REF_LOAN_TYPE,
 TD.RATE  ,
 ''نرخ سود ''||TD.RATE,
 count(TD.RATE)
 FROM AKIN.TBL_LOAN TD,
AKIN.TBL_LOAN_PAYMENT TLP
 ,  TBL_BRANCH TB
WHERE DUE_DATE > to_date(''' ||
     DATE_TYPE1 ||
     ''') and DUE_DATE <= to_date(''' ||
     DATE_TYPE1 ||
     ''')+' ||
     I.PERIOD_DATE ||
     ' and TLP.REF_LON_ID = TD.LON_ID AND  TD.REF_BRANCH   = TB.BRN_ID
GROUP BY
 TB.REGION_ID
 ,TD.REF_LOAN_TYPE
 ,TD.RATE;
'
    INTO
     VAR_QUERY
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;

    
    
    DATE_TYPE1   := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
   ELSE
      /******agar profile zamani entekhab shode tarikhi bashad *****--*/
    SELECT
     '  
INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
 REP_REQ
 ,PARENT
 ,CHILD
 ,VALUE
 ,DEPTH
 ,REF_EFF_DATE
 ,REGION_ID
 ,TYPE
 ,RATE,
 name,
 count
)  
SELECT ' ||
     VAR_REP_REQ ||
     ' AS REP_REQ
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_LOAN_TYPE  AS REF_LOAN_TYPE
 ,100 ||
 TB.REGION_ID ||
 100 ||
 TD.REF_LOAN_TYPE ||
 100 ||
 TD.RATE AS RATE
 ,SUM(TLP.AMOUNT)
 ,4 AS DEPTH
 ,' ||
     I.ID ||
     '
 ,TB.REGION_ID ,
 TD.REF_LOAN_TYPE,
 TD.RATE  ,
 ''نرخ سود ''||TD.RATE,
 count(TD.RATE)
 FROM AKIN.TBL_LOAN TD,
AKIN.TBL_LOAN_PAYMENT TLP
 ,  TBL_BRANCH TB
WHERE DUE_DATE > to_date(''' ||
     I.PERIOD_START ||
     ''',''dd-mm-yyyy'') and TD.DUE_DATE <= to_date(''' ||
     I.PERIOD_END ||
     ''',''dd-mm-yyyy'') AND TLP.REF_LON_ID = TD.LON_ID AND  TD.REF_BRANCH   = TB.BRN_ID
GROUP BY
 TB.REGION_ID
 ,TD.REF_LOAN_TYPE
 ,TD.RATE;
 '
    INTO
     VAR_QUERY
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;
  
   END IF;
  END LOOP;

  COMMIT;
  UPDATE TBL_DUE_DATE_DETAIL_LOAN DDD
   SET
    DDD.REF_EFF_DATE = (
     SELECT
      ID
     FROM TBL_REPPER
     WHERE REF_REQ_ID          = VAR_REP_REQ
      AND
       TBL_REPPER.OLD_ID   = DDD.REF_EFF_DATE
    )
  WHERE DDD.REP_REQ   = VAR_REP_REQ;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   VAR_REP_REQ
  ,DDD.PARENT
  ,DDD.CHILD
  ,0
  ,DDD.DEPTH
  ,TP.ID
  ,DDD.REGION_ID
  ,DDD.TYPE
  ,DDD.RATE
  ,DDD.NAME
  FROM TBL_DUE_DATE_DETAIL_LOAN DDD
  ,    TBL_REPPER TP
  WHERE DDD.REP_REQ     = 0
   AND
    DDD.DEPTH       = 4
   AND
    TP.REF_REQ_ID   = VAR_REP_REQ
   AND
    DDD.CHILD || TP.ID NOT IN (
     SELECT
      CHILD || REF_EFF_DATE
     FROM TBL_DUE_DATE_DETAIL_LOAN
     WHERE REP_REQ   = VAR_REP_REQ
    );

  COMMIT;
  /*-------------------------------------------------------------------------------------------*/
  LOC_F         := SYSTIMESTAMP;
  LOC_MEGHDAR   := SQL%ROWCOUNT;
 EXCEPTION
  WHEN OTHERS THEN
   RAISE;
 END PRC_DUE_DATE_REPORT_VALUE;

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_ALL_REPORT ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''DUEDATE_LOAN''';
  RETURN VAR2;
 END FNC_DUE_DATE_ALL_REPORT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_TREE RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'select
 parent as "parent",child as "id",depth as "level",name as "text",RATE "rate",type "type",REGION_ID "regionId"
from
  tbl_due_date_detail_loan
  where rep_req = 0
start with
  parent is null
connect by
  prior child=parent'
;
  RETURN VAR2;
 END FNC_DUE_DATE_GET_TREE;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_LEAF ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := ' SELECT
  PARENT as "parent"
 ,CHILD as "id"
 ,VALUE as "value"
 ,DEPTH as "depth"
 ,REF_EFF_DATE as "effDate"
 ,REGION_ID as "regionId"
 ,TYPE as "type"
 ,RATE as "rate"
 , count as "xcount"
FROM TBL_DUE_DATE_DETAIL_loan
where REP_REQ ='
|| INPAR_ID || '';
  RETURN VAR2;
 END FNC_DUE_DATE_GET_LEAF;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_DETAIL (
  INPAR_ID     IN NUMBER
 ,INPAR_TYPE   IN VARCHAR2
 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  IF
   ( UPPER(INPAR_TYPE) = 'TYPE' )
  THEN
   VAR2   := 'SELECT DISTINCT DDD.TYPE AS "id",DT.NAME as "name" FROM TBL_DUE_DATE_DETAIL_loan DDD,TBL_loan_TYPE DT  WHERE DDD.REP_REQ = '
|| INPAR_ID || ' AND DDD.TYPE = DT.REF_loan_TYPE
ORDER BY DT.NAME';
  END IF;

  IF
   ( UPPER(INPAR_TYPE) = 'RATE' )
  THEN
   VAR2   := 'SELECT DISTINCT DDD.RATE as "id",DDD.NAME as "name" FROM TBL_DUE_DATE_DETAIL_loan DDD WHERE DDD.REP_REQ = ' || INPAR_ID || ' and ddd.RATE is not null  
ORDER BY DDD.RATE'
;
  END IF;

  IF
   ( UPPER(INPAR_TYPE) = 'REGION' )
  THEN
   VAR2   := 'SELECT DISTINCT DDD.REGION_ID as "id",TB.REGION_NAME as "name"  FROM TBL_DUE_DATE_DETAIL_loan DDD,TBL_BRANCH TB WHERE DDD.REP_REQ = '
|| INPAR_ID || ' AND TB.REGION_ID = DDD.REGION_ID 
ORDER BY DDD.REGION_ID';
  END IF;

  RETURN VAR2;
 END FNC_DUE_DATE_GET_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DUE_DATE_FIRS_TIME
  AS
 BEGIN
  INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   0
  ,100 ||
   TB.REGION_ID ||
   100 ||
   TD.REF_LOAN_TYPE AS REF_LOAN_TYPE
  ,100 ||
   TB.REGION_ID ||
   100 ||
   TD.REF_LOAN_TYPE ||
   100 ||
   TD.RATE AS RATE
  ,SUM(TD.CURRENT_AMOUNT)
  ,4
  ,0000
  ,TB.REGION_ID
  ,TD.REF_LOAN_TYPE
  ,TD.RATE
  ,'نرخ سود ' || TD.RATE
  FROM AKIN.TBL_LOAN TD
  ,    TBL_BRANCH TB
  WHERE TD.REF_BRANCH   = TB.BRN_ID
  GROUP BY
   TB.REGION_ID
  ,TD.REF_LOAN_TYPE
  ,TD.RATE;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   0 AS REP_REQ
  ,100 || REGION_ID
  ,PARENT
  ,SUM(VALUE)
  ,3
  ,0 AS EFFDATE
  ,REGION_ID
  ,MAX(TYPE)
  ,-1 AS RATE
  ,MAX( (
    SELECT DISTINCT
     TDT.NAME
    FROM TBL_LOAN_TYPE TDT
    WHERE TDT.REF_LOAN_TYPE   = TYPE
   ) ) AS NAME
  FROM TBL_DUE_DATE_DETAIL_LOAN
  GROUP BY
   PARENT
  ,REGION_ID;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  )  SELECT
   0
  ,0
  ,b.PARENT
  ,SUM(b.VALUE)
  ,2
  ,0
  ,b.REGION_ID
  ,0
  ,-1
  ,max((select  distinct TBL_BRANCH.REGION_NAME from TBL_BRANCH where TBL_BRANCH.REGION_ID =b.REGION_ID)) as name
  FROM TBL_DUE_DATE_DETAIL_LOAN b
  WHERE b.DEPTH   = 3
  GROUP BY
   b.PARENT
  ,b.REGION_ID;

  COMMIT;
  INSERT INTO TBL_DUE_DATE_DETAIL_LOAN (
   REP_REQ
  ,PARENT
  ,CHILD
  ,VALUE
  ,DEPTH
  ,REF_EFF_DATE
  ,REGION_ID
  ,TYPE
  ,RATE
  ,NAME
  ) SELECT
   0
  ,''
  ,0
  ,SUM(VALUE)
  ,1
  ,0
  ,0
  ,0
  ,-1
  ,'??'
  FROM TBL_DUE_DATE_DETAIL_LOAN
  WHERE DEPTH   = 2
  GROUP BY
   PARENT;

  COMMIT;
 END;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DUE_DATE_GET_count ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT
  PARENT as "parent"
 ,CHILD as "id"
 ,VALUE as "value"
 ,DEPTH as "depth"
 ,REF_EFF_DATE as "effDate"
 ,REGION_ID as "regionId"
 ,TYPE as "type"
 ,RATE as "rate"
FROM TBL_DUE_DATE_DETAIL_LOAN
where REP_REQ ='
|| INPAR_ID || ' and DEPTH is null';
  RETURN VAR2;
 END FNC_DUE_DATE_GET_count;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

END PKG_DUE_DATE_LOAN;
--------------------------------------------------------
--  DDL for Table PKG_NOP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_NOP" as 

  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_NOP_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

PROCEDURE prc_nop_GI_CALC (
   INPAR_ID     IN NUMBER,
   inpar_REPREQ in number ,
    inpar_REF_REPORT in number,
    inpar_TITLE in number,
    inapr_REF_TIMING in number
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/


 PROCEDURE PRC_NOP_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NOP_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_NOP_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 ;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NOP_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NOP_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2;
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_REPORT_VALUE_nop( INPAR_ID_REPORT IN NUMBER );


end pkg_nop;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_NOP" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NOP_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_NOP_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
 END PRC_NOP_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NOP_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_NOP_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) VALUES (
    INPAR_REF_REPORT
   ,INPAR_NAME
   ,INPAR_PROFILE_ID
   ,0
   ,INPAR_TYPE
   ,INPAR_TITLE
   );
  
   COMMIT;
/*   SELECT*/
/*    ID*/
/*   INTO*/
/*    OUTPAR_ID*/
/*   FROM TBL_COM_REP_PROFILE_DETAIL*/
/*   WHERE REF_REPORT   = INPAR_REF_REPORT;*/
   OUTPAR_ID   := INPAR_REF_REPORT;
  ELSE
   UPDATE TBL_NOP_REP_PROFILE_DETAIL
    SET
     REF_REPORT = INPAR_REF_REPORT
    ,NAME = INPAR_NAME
    ,PROFILE_ID = INPAR_PROFILE_ID
    ,IS_STANDARD = 0
    ,TYPE = INPAR_TYPE
    ,TITLE = INPAR_TITLE
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
 END PRC_NOP_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NOP_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,TYPE
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'NOP'
   ,INPAR_TYPE
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
  
  --=============
  INSERT INTO TBL_NOP_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) (select(select max(id) from tbl_report where upper(type) = 'NOP') ,NAME
   ,0
   ,0
   ,TYPE
   ,TITLE
   from tbl_NOP_rep_profile_detail where is_standard=1
   );
   COMMIT;
  --==============
  
  
  
 END PRC_NOP_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_NOP_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2 AS
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
 BEGIN
  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = '
|| INPAR_ID || '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = (select trunc(max(eff_date)) from  TBL_LEDGER_archive))
 '
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  RETURN abs(TO_number(VAR2));
 END FNC_NOP_GI_CALC;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NOP_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
 BEGIN
  var:= inpar_type;
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title"
FROM TBL_NOP_REP_PROFILE_DETAIL where  is_standard =1 '
;
  RETURN OUTPUT;
 END FNC_NOP_GET_INPUT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NOP_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "description",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''NOP'' order by id';
  RETURN VAR2;
 END FNC_NOP_GET_REPORT_INFO;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 
 FUNCTION FNC_NOP_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
   pragma autonomous_transaction;
 BEGIN
 --pkg_NOP.prc_NOP_update_gi_calc(INPAR_REPORT);
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title",
  to_char(VALUE) as "manualValue",
  PROFILE_ID as "profileId"
FROM TBL_NOP_REP_PROFILE_DETAIL where REF_REPORT = '
|| INPAR_REPORT || ' AND TYPE = 2 order by type ';
  RETURN OUTPUT;
 END FNC_NOP_GET_INPUT_EDIT;
-----------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

PROCEDURE PRC_REPORT_VALUE_nop(
    INPAR_ID_REPORT IN NUMBER )
AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Morteza.Sahhi
  Editor Name:
  Release Date/Time:1396/02/24-10:00
  Edit Name:
  Version: 1.1
  Category:2
  Description:in procedure baraye enteghal dadehaye morde niaz az value be TBL_VALUE_TEMP bar asas profilehaye mokhtalefist ke karbar taeen karde
  */
  /*------------------------------------------------------------------------------*/
  VAR_QUERY  VARCHAR2(4000);
  ID_LOAN    NUMBER;
  ID_DEP     NUMBER;
  ID_CUR     NUMBER;
  ID_CUS     NUMBER;
  ID_BRANCH  NUMBER;
  ID_TIMING  NUMBER;
  DATE_TYPE1 DATE := SYSDATE;
  LOC_S  TIMESTAMP;
  LOC_F  TIMESTAMP;
  LOC_MEGHDAR NUMBER;
  VAR_REPREQ NUMBER;
  min_time varchar2(300);
BEGIN
  execute immediate 'alter session set nls_date_format=''DD-MM-RRRR''';
  SYS.DBMS_OUTPUT.ENABLE(3000000);
  EXECUTE IMMEDIATE 'truncate table TBL_VALUE_TEMP';
  /******profilhaye mokhtalefi ke karbar baraye in gozaresh entekhab karde ra daron moteghayer ham nam profil mirizim ******/
   
  SELECT REF_PROFILE_CURRENCY
  INTO ID_CUR
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = INPAR_ID_REPORT;
  SELECT REF_PROFILE_CUSTOMER
  INTO ID_CUS
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = INPAR_ID_REPORT;
  SELECT REF_PROFILE_BRANCH
  INTO ID_BRANCH
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = INPAR_ID_REPORT;
  SELECT REF_PROFILE_DEPOSIT
  INTO ID_DEP
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = INPAR_ID_REPORT;
  SELECT REF_PROFILE_TIME
  INTO ID_TIMING
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = INPAR_ID_REPORT;
  SELECT REF_PROFILE_LOAN
  INTO ID_LOAN
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = INPAR_ID_REPORT;
   SELECT
  MAX(ID)
 INTO
  VAR_REPREQ
 FROM TBL_REPREQ;
 
   /************/

  INSERT INTO TBL_REPPER (
  REF_TIMING_PROFILE
 ,PERIOD_NAME
 ,PERIOD_DATE
 ,PERIOD_START
 ,PERIOD_END
 ,PERIOD_COLOR
 ,REF_REPORT_ID
 ,OLD_ID
 ,REF_REQ_ID
 ) SELECT
  ID_TIMING
 ,PERIOD_NAME
 ,PERIOD_DATE
 ,PERIOD_START
 ,PERIOD_END
 ,PERIOD_COLOR
 ,INPAR_ID_REPORT
 ,ID
 ,VAR_REPREQ
 FROM TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = ID_TIMING;

 COMMIT;
 
 
 
 
  /******be ezaye tedad bazehayee ke dar profile zamani vojod darad halghe ro ejra mikonim*****--*/
  FOR I IN
  (SELECT TTPD.ID ,
    TTP.TYPE ,
    TTPD.PERIOD_NAME ,
    TTPD.PERIOD_DATE ,
    TTPD.PERIOD_START ,
    TTPD.PERIOD_END ,
    TTPD.PERIOD_COLOR
  FROM TBL_TIMING_PROFILE TTP ,
    TBL_TIMING_PROFILE_DETAIL TTPD
  WHERE TTP.ID = TTPD.REF_TIMING_PROFILE
  AND TTP.ID   = ID_TIMING
  )
  LOOP
    IF ( I.TYPE = 1 ) THEN
      /******agar profile zamani entekhab shode bazehee bashad *****--*/
      SELECT '  
INSERT
INTO TBL_VALUE_TEMP  
(    
REF_MODALITY_TYPE,   
REF_ID,   
BALANCE,   
REF_BRANCH,   
DUE_DATE,   
REF_TYPE,   
REF_LEGER_CODE,   
REF_CUR_ID,   
REF_STA_ID,   
REF_CTY_ID,   
REF_CUS_ID ,
REF_TIMING_ID,
TIMING_NAME,
TIMING_color
) 
SELECT REF_MODALITY_TYPE, 
REF_ID, 
BALANCE, 
REF_BRANCH, 
DUE_DATE, 
REF_TYPE, 
REF_LEGER_CODE, 
REF_CUR_ID, 
REF_STA_ID, 
REF_CTY_ID, 
REF_CUS_ID,
'''
        || I.ID
        || ''',
'''
        || I.PERIOD_NAME
        || ''',
'''
        || I.PERIOD_COLOR
        || '''
FROM TBL_VALUE WHERE  REF_CUR_ID IN (select CUR_ID from tbl_currency where cur_id <> 4)'
        || ' AND REF_CUS_ID IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',ID_CUS)
        || ')'
        || ' AND REF_BRANCH IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH)
        || ')  AND DUE_DATE > to_date('''
        || DATE_TYPE1
        || ''',''dd-mm-yyyy'''''') and DUE_DATE <= to_date('''
        || DATE_TYPE1
        || ''',''dd-mm-yyyy'''''')+'
        || I.PERIOD_DATE
        || '  ;'
      INTO VAR_QUERY
      FROM DUAL;
      DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;     
      
      DATE_TYPE1 := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
    ELSE
      /******agar profile zamani entekhab shode tarikhi bashad *****--*/
      SELECT '  
INSERT
INTO TBL_VALUE_TEMP  
(    
REF_MODALITY_TYPE,   
REF_ID,   
BALANCE,
REF_BRANCH,   
DUE_DATE,   
REF_TYPE,   
REF_LEGER_CODE,   
REF_CUR_ID,   
REF_STA_ID,   
REF_CTY_ID,   
REF_CUS_ID  ,
REF_TIMING_ID,
TIMING_NAME,
TIMING_color 
) 
SELECT REF_MODALITY_TYPE, 
REF_ID, 
BALANCE,   
REF_BRANCH, 
DUE_DATE, 
REF_TYPE, 
REF_LEGER_CODE, 
REF_CUR_ID, 
REF_STA_ID, 
REF_CTY_ID, 
REF_CUS_ID,
'''
        || I.ID
        || ''',
'''
        || I.PERIOD_NAME
        || ''',
'''
        || I.PERIOD_COLOR
        || '''
FROM TBL_VALUE WHERE  REF_CUR_ID IN (select CUR_ID from tbl_currency where cur_id <> 4)'
        || ' AND REF_CUS_ID IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',ID_CUS)
        || ')'
        || ' AND REF_BRANCH IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH)
        || ') AND DUE_DATE > to_date('''
        || I.PERIOD_START
        || ''',''dd-mm-yyyy'') and DUE_DATE <= to_date('''
        || I.PERIOD_END
        || ''',''dd-mm-yyyy'') ;'
      INTO VAR_QUERY
      FROM DUAL;
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;
     
    END IF;
  END LOOP;
  COMMIT;
  
-- insert to final result baraye tashilat

INSERT INTO tbl_nop_final_result (
    repreq,
    ref_report,
    title,
    ref_timing,
    ref_currency,
    balance,
    moadel_arzi
)
    SELECT
        var_repreq,
        INPAR_ID_REPORT,
        1,
        tvm.ref_timing_id,
        tvm.ref_cur_id,
        SUM(tvm.balance),
        SUM(tvm.balance) / (
            SELECT
                change_rate
            FROM
                tbl_currency_rel
            WHERE
                rel_date = (
                    SELECT
                        MAX(rel_date)
                    FROM
                        tbl_currency_rel
                )
                AND src_cur_id = tvm.ref_cur_id
        ) AS moadel_riali
    FROM
        tbl_value_temp tvm
    WHERE
        tvm.ref_modality_type IN (
            2,
            21
        )
    GROUP BY
        tvm.ref_timing_id,
        tvm.ref_cur_id;
  
  -- insert to final result baraye seprde ha

INSERT INTO tbl_nop_final_result (
    repreq,
    ref_report,
    title,
    ref_timing,
    ref_currency,
    balance,
    moadel_arzi
)
    SELECT
        var_repreq,
        INPAR_ID_REPORT,
        2,
        tvm.ref_timing_id,
        tvm.ref_cur_id,
        SUM(tvm.balance),
        SUM(tvm.balance) /(
            SELECT
                change_rate
            FROM
                tbl_currency_rel
            WHERE
                rel_date = (
                    SELECT
                        MAX(rel_date)
                    FROM
                        tbl_currency_rel
                )
                AND src_cur_id = tvm.ref_cur_id
        ) AS moadel_riali
    FROM
        tbl_value_temp tvm
    WHERE
        tvm.ref_modality_type IN (
            1,
            11
        )
    GROUP BY
        tvm.ref_timing_id,
        tvm.ref_cur_id;
  
  commit;
  update TBL_NOP_REP_PROFILE_DETAIL set REF_REPREQ =var_repreq
  where REF_REPREQ is null and IS_STANDARD<>1;
  
      commit;
--======
select min(ref_timing) into min_time from tbl_nop_final_result where repreq = var_repreq ;
  --======
  for i in (select * from tbl_nop_rep_profile_detail where is_standard <>1 and ref_repreq = var_repreq)
  loop
   prc_nop_GI_CALC (
   i.profile_id       
 , var_repreq  ,
    INPAR_ID_REPORT ,
    i.title ,
  min_time
 ) ;
 end loop;
  --======
  ---------------------------
/*  LOC_F := SYSTIMESTAMP;
       LOC_MEGHDAR := SQL%ROWCOUNT;
  EXCEPTION 
WHEN OTHERS THEN
RAISE;*/
END PRC_REPORT_VALUE_nop;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

PROCEDURE prc_nop_GI_CALC (
   INPAR_ID     IN NUMBER
 , inpar_REPREQ in number ,
    inpar_REF_REPORT in number,
    inpar_TITLE in number,
    inapr_REF_TIMING in number
 ) as
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
  var_date date;
 BEGIN
 select max(eff_date) into var_date from TBL_LEDGER_archive;
 
 for i in (select * from tbl_currency_rel where rel_date = (select max(rel_date) from tbl_currency_rel))
 loop
  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = ' ||
   INPAR_ID ||
   '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
     ref_cur_id = '||i.src_cur_id||'
     and
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = trunc(TO_DATE(''' ||
   var_date ||
   ''')))'
  INTO
   VAR
  FROM DUAL;
DBMS_OUTPUT.PUT_LINE(var);
  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  --RETURN abs(to_number(VAR2));
  --RETURN VAR;
  
  INSERT
INTO TBL_NOP_FINAL_RESULT
  (
   
    REPREQ,
    REF_REPORT,
    TITLE,
    REF_TIMING,
    REF_CURRENCY,
    BALANCE,
    MOADEL_arzi
  )
  VALUES
  (
 
   inpar_REPREQ,
    inpar_REF_REPORT,
    inpar_TITLE,
    inapr_REF_TIMING,
    i.src_cur_id,
    abs(to_number(VAR2)),
    abs(to_number(VAR2))/ i.change_rate
  );
  commit;
  end loop;
 END prc_nop_GI_CALC;


/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

END PKG_NOP;
--------------------------------------------------------
--  DDL for Table PKG_NOP
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_NOP" as 

  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_NOP_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

PROCEDURE prc_nop_GI_CALC (
   INPAR_ID     IN NUMBER,
   inpar_REPREQ in number ,
    inpar_REF_REPORT in number,
    inpar_TITLE in number,
    inapr_REF_TIMING in number
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/


 PROCEDURE PRC_NOP_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NOP_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_NOP_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 ;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_NOP_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NOP_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2;
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_REPORT_VALUE_nop( INPAR_ID_REPORT IN NUMBER );


end pkg_nop;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_NOP" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  /*
  Package Programmers Name:  morteza.sahi & Navid.Sedigh
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: 
  */
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NOP_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_NOP_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
 END PRC_NOP_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NOP_REP_PROFILE_DETAIL (
  INPAR_REF_REPORT         IN VARCHAR2
 ,INPAR_NAME               IN VARCHAR2
 ,INPAR_PROFILE_ID         IN VARCHAR2
 ,INPAR_IS_STANDARD        IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_TITLE              IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_NOP_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) VALUES (
    INPAR_REF_REPORT
   ,INPAR_NAME
   ,INPAR_PROFILE_ID
   ,0
   ,INPAR_TYPE
   ,INPAR_TITLE
   );
  
   COMMIT;
/*   SELECT*/
/*    ID*/
/*   INTO*/
/*    OUTPAR_ID*/
/*   FROM TBL_COM_REP_PROFILE_DETAIL*/
/*   WHERE REF_REPORT   = INPAR_REF_REPORT;*/
   OUTPAR_ID   := INPAR_REF_REPORT;
  ELSE
   UPDATE TBL_NOP_REP_PROFILE_DETAIL
    SET
     REF_REPORT = INPAR_REF_REPORT
    ,NAME = INPAR_NAME
    ,PROFILE_ID = INPAR_PROFILE_ID
    ,IS_STANDARD = 0
    ,TYPE = INPAR_TYPE
    ,TITLE = INPAR_TITLE
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
 END PRC_NOP_REP_PROFILE_DETAIL;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_NOP_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,TYPE
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'NOP'
   ,INPAR_TYPE
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;
  
  --=============
  INSERT INTO TBL_NOP_REP_PROFILE_DETAIL (
    REF_REPORT
   ,NAME
   ,PROFILE_ID
   ,IS_STANDARD
   ,TYPE
   ,TITLE
   ) (select(select max(id) from tbl_report where upper(type) = 'NOP') ,NAME
   ,0
   ,0
   ,TYPE
   ,TITLE
   from tbl_NOP_rep_profile_detail where is_standard=1
   );
   COMMIT;
  --==============
  
  
  
 END PRC_NOP_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_NOP_GI_CALC ( INPAR_ID IN varchar2 ) RETURN VARCHAR2 AS
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
 BEGIN
  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = '
|| INPAR_ID || '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = (select trunc(max(eff_date)) from  TBL_LEDGER_archive))
 '
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  RETURN abs(TO_number(VAR2));
 END FNC_NOP_GI_CALC;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NOP_GET_INPUT ( INPAR_type IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
 BEGIN
  var:= inpar_type;
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title"
FROM TBL_NOP_REP_PROFILE_DETAIL where  is_standard =1 '
;
  RETURN OUTPUT;
 END FNC_NOP_GET_INPUT;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_NOP_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "description",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''NOP'' order by id';
  RETURN VAR2;
 END FNC_NOP_GET_REPORT_INFO;
/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/
 
 FUNCTION FNC_NOP_GET_INPUT_EDIT ( INPAR_REPORT IN VARCHAR2,INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2 AS
  OUTPUT   VARCHAR2(2000);
  VAR      VARCHAR2(2000);
   pragma autonomous_transaction;
 BEGIN
 --pkg_NOP.prc_NOP_update_gi_calc(INPAR_REPORT);
  OUTPUT   := 'select
   id as "id",
  NAME as "infoGroup",
  TYPE as "type",
  TITLE as "title",
  to_char(VALUE) as "manualValue",
  PROFILE_ID as "profileId"
FROM TBL_NOP_REP_PROFILE_DETAIL where REF_REPORT = '
|| INPAR_REPORT || ' AND TYPE = 2 order by type ';
  RETURN OUTPUT;
 END FNC_NOP_GET_INPUT_EDIT;
-----------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

PROCEDURE PRC_REPORT_VALUE_nop(
    INPAR_ID_REPORT IN NUMBER )
AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Morteza.Sahhi
  Editor Name:
  Release Date/Time:1396/02/24-10:00
  Edit Name:
  Version: 1.1
  Category:2
  Description:in procedure baraye enteghal dadehaye morde niaz az value be TBL_VALUE_TEMP bar asas profilehaye mokhtalefist ke karbar taeen karde
  */
  /*------------------------------------------------------------------------------*/
  VAR_QUERY  VARCHAR2(4000);
  ID_LOAN    NUMBER;
  ID_DEP     NUMBER;
  ID_CUR     NUMBER;
  ID_CUS     NUMBER;
  ID_BRANCH  NUMBER;
  ID_TIMING  NUMBER;
  DATE_TYPE1 DATE := SYSDATE;
  LOC_S  TIMESTAMP;
  LOC_F  TIMESTAMP;
  LOC_MEGHDAR NUMBER;
  VAR_REPREQ NUMBER;
  min_time varchar2(300);
BEGIN
  execute immediate 'alter session set nls_date_format=''DD-MM-RRRR''';
  SYS.DBMS_OUTPUT.ENABLE(3000000);
  EXECUTE IMMEDIATE 'truncate table TBL_VALUE_TEMP';
  /******profilhaye mokhtalefi ke karbar baraye in gozaresh entekhab karde ra daron moteghayer ham nam profil mirizim ******/
   
  SELECT REF_PROFILE_CURRENCY
  INTO ID_CUR
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = INPAR_ID_REPORT;
  SELECT REF_PROFILE_CUSTOMER
  INTO ID_CUS
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = INPAR_ID_REPORT;
  SELECT REF_PROFILE_BRANCH
  INTO ID_BRANCH
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = INPAR_ID_REPORT;
  SELECT REF_PROFILE_DEPOSIT
  INTO ID_DEP
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = INPAR_ID_REPORT;
  SELECT REF_PROFILE_TIME
  INTO ID_TIMING
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = INPAR_ID_REPORT;
  SELECT REF_PROFILE_LOAN
  INTO ID_LOAN
  FROM TBL_REPORT_PROFILE
  WHERE REF_REPORT = INPAR_ID_REPORT;
   SELECT
  MAX(ID)
 INTO
  VAR_REPREQ
 FROM TBL_REPREQ;
 
   /************/

  INSERT INTO TBL_REPPER (
  REF_TIMING_PROFILE
 ,PERIOD_NAME
 ,PERIOD_DATE
 ,PERIOD_START
 ,PERIOD_END
 ,PERIOD_COLOR
 ,REF_REPORT_ID
 ,OLD_ID
 ,REF_REQ_ID
 ) SELECT
  ID_TIMING
 ,PERIOD_NAME
 ,PERIOD_DATE
 ,PERIOD_START
 ,PERIOD_END
 ,PERIOD_COLOR
 ,INPAR_ID_REPORT
 ,ID
 ,VAR_REPREQ
 FROM TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = ID_TIMING;

 COMMIT;
 
 
 
 
  /******be ezaye tedad bazehayee ke dar profile zamani vojod darad halghe ro ejra mikonim*****--*/
  FOR I IN
  (SELECT TTPD.ID ,
    TTP.TYPE ,
    TTPD.PERIOD_NAME ,
    TTPD.PERIOD_DATE ,
    TTPD.PERIOD_START ,
    TTPD.PERIOD_END ,
    TTPD.PERIOD_COLOR
  FROM TBL_TIMING_PROFILE TTP ,
    TBL_TIMING_PROFILE_DETAIL TTPD
  WHERE TTP.ID = TTPD.REF_TIMING_PROFILE
  AND TTP.ID   = ID_TIMING
  )
  LOOP
    IF ( I.TYPE = 1 ) THEN
      /******agar profile zamani entekhab shode bazehee bashad *****--*/
      SELECT '  
INSERT
INTO TBL_VALUE_TEMP  
(    
REF_MODALITY_TYPE,   
REF_ID,   
BALANCE,   
REF_BRANCH,   
DUE_DATE,   
REF_TYPE,   
REF_LEGER_CODE,   
REF_CUR_ID,   
REF_STA_ID,   
REF_CTY_ID,   
REF_CUS_ID ,
REF_TIMING_ID,
TIMING_NAME,
TIMING_color
) 
SELECT REF_MODALITY_TYPE, 
REF_ID, 
BALANCE, 
REF_BRANCH, 
DUE_DATE, 
REF_TYPE, 
REF_LEGER_CODE, 
REF_CUR_ID, 
REF_STA_ID, 
REF_CTY_ID, 
REF_CUS_ID,
'''
        || I.ID
        || ''',
'''
        || I.PERIOD_NAME
        || ''',
'''
        || I.PERIOD_COLOR
        || '''
FROM TBL_VALUE WHERE  REF_CUR_ID IN (select CUR_ID from tbl_currency where cur_id <> 4)'
        || ' AND REF_CUS_ID IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',ID_CUS)
        || ')'
        || ' AND REF_BRANCH IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH)
        || ')  AND DUE_DATE > to_date('''
        || DATE_TYPE1
        || ''',''dd-mm-yyyy'''''') and DUE_DATE <= to_date('''
        || DATE_TYPE1
        || ''',''dd-mm-yyyy'''''')+'
        || I.PERIOD_DATE
        || '  ;'
      INTO VAR_QUERY
      FROM DUAL;
      DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;     
      
      DATE_TYPE1 := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
    ELSE
      /******agar profile zamani entekhab shode tarikhi bashad *****--*/
      SELECT '  
INSERT
INTO TBL_VALUE_TEMP  
(    
REF_MODALITY_TYPE,   
REF_ID,   
BALANCE,
REF_BRANCH,   
DUE_DATE,   
REF_TYPE,   
REF_LEGER_CODE,   
REF_CUR_ID,   
REF_STA_ID,   
REF_CTY_ID,   
REF_CUS_ID  ,
REF_TIMING_ID,
TIMING_NAME,
TIMING_color 
) 
SELECT REF_MODALITY_TYPE, 
REF_ID, 
BALANCE,   
REF_BRANCH, 
DUE_DATE, 
REF_TYPE, 
REF_LEGER_CODE, 
REF_CUR_ID, 
REF_STA_ID, 
REF_CTY_ID, 
REF_CUS_ID,
'''
        || I.ID
        || ''',
'''
        || I.PERIOD_NAME
        || ''',
'''
        || I.PERIOD_COLOR
        || '''
FROM TBL_VALUE WHERE  REF_CUR_ID IN (select CUR_ID from tbl_currency where cur_id <> 4)'
        || ' AND REF_CUS_ID IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',ID_CUS)
        || ')'
        || ' AND REF_BRANCH IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH)
        || ') AND DUE_DATE > to_date('''
        || I.PERIOD_START
        || ''',''dd-mm-yyyy'') and DUE_DATE <= to_date('''
        || I.PERIOD_END
        || ''',''dd-mm-yyyy'') ;'
      INTO VAR_QUERY
      FROM DUAL;
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;
     
    END IF;
  END LOOP;
  COMMIT;
  
-- insert to final result baraye tashilat

INSERT INTO tbl_nop_final_result (
    repreq,
    ref_report,
    title,
    ref_timing,
    ref_currency,
    balance,
    moadel_arzi
)
    SELECT
        var_repreq,
        INPAR_ID_REPORT,
        1,
        tvm.ref_timing_id,
        tvm.ref_cur_id,
        SUM(tvm.balance),
        SUM(tvm.balance) / (
            SELECT
                change_rate
            FROM
                tbl_currency_rel
            WHERE
                rel_date = (
                    SELECT
                        MAX(rel_date)
                    FROM
                        tbl_currency_rel
                )
                AND src_cur_id = tvm.ref_cur_id
        ) AS moadel_riali
    FROM
        tbl_value_temp tvm
    WHERE
        tvm.ref_modality_type IN (
            2,
            21
        )
    GROUP BY
        tvm.ref_timing_id,
        tvm.ref_cur_id;
  
  -- insert to final result baraye seprde ha

INSERT INTO tbl_nop_final_result (
    repreq,
    ref_report,
    title,
    ref_timing,
    ref_currency,
    balance,
    moadel_arzi
)
    SELECT
        var_repreq,
        INPAR_ID_REPORT,
        2,
        tvm.ref_timing_id,
        tvm.ref_cur_id,
        SUM(tvm.balance),
        SUM(tvm.balance) /(
            SELECT
                change_rate
            FROM
                tbl_currency_rel
            WHERE
                rel_date = (
                    SELECT
                        MAX(rel_date)
                    FROM
                        tbl_currency_rel
                )
                AND src_cur_id = tvm.ref_cur_id
        ) AS moadel_riali
    FROM
        tbl_value_temp tvm
    WHERE
        tvm.ref_modality_type IN (
            1,
            11
        )
    GROUP BY
        tvm.ref_timing_id,
        tvm.ref_cur_id;
  
  commit;
  update TBL_NOP_REP_PROFILE_DETAIL set REF_REPREQ =var_repreq
  where REF_REPREQ is null and IS_STANDARD<>1;
  
      commit;
--======
select min(ref_timing) into min_time from tbl_nop_final_result where repreq = var_repreq ;
  --======
  for i in (select * from tbl_nop_rep_profile_detail where is_standard <>1 and ref_repreq = var_repreq)
  loop
   prc_nop_GI_CALC (
   i.profile_id       
 , var_repreq  ,
    INPAR_ID_REPORT ,
    i.title ,
  min_time
 ) ;
 end loop;
  --======
  ---------------------------
/*  LOC_F := SYSTIMESTAMP;
       LOC_MEGHDAR := SQL%ROWCOUNT;
  EXCEPTION 
WHEN OTHERS THEN
RAISE;*/
END PRC_REPORT_VALUE_nop;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

PROCEDURE prc_nop_GI_CALC (
   INPAR_ID     IN NUMBER
 , inpar_REPREQ in number ,
    inpar_REF_REPORT in number,
    inpar_TITLE in number,
    inapr_REF_TIMING in number
 ) as
  VAR    CLOB;
  VAR2   CLOB;
  VAR3   CLOB;
  var_date date;
 BEGIN
 select max(eff_date) into var_date from TBL_LEDGER_archive;
 
 for i in (select * from tbl_currency_rel where rel_date = (select max(rel_date) from tbl_currency_rel))
 loop
  SELECT
   '
  SELECT
   REPLACE(
    WMSYS.WM_CONCAT(V)
   ,'',''
   ,''''
   )
   FROM (
    SELECT
     ABS(DG.BALANCE) ||
     A.SPLIT_SING AS V
    FROM (
      WITH T AS (
       SELECT
        REPLACE(FORMULA||''+'','','','''') STR
       FROM TBL_LEDGER_REPORT_MAP
       WHERE id   = ' ||
   INPAR_ID ||
   '   ) SELECT
       REGEXP_SUBSTR(
        STR
       ,''[0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_VALUES
      ,REGEXP_SUBSTR(
        STR
       ,''[^0-9]+''
       ,1
       ,LEVEL
       ) SPLIT_SING
      ,LEVEL AS LEV
      FROM T
      CONNECT BY
       LEVEL <= (
        SELECT
         LENGTH(REPLACE(STR,''-'',NULL) )
        FROM T
       )
     ) A
    ,TBL_LEDGER_archive DG
    WHERE DG.LEDGER_CODE   = A.SPLIT_VALUES
     AND
     ref_cur_id = '||i.src_cur_id||'
     and
      SPLIT_VALUES IS NOT NULL
        AND
      trunc(DG.EFF_DATE)                                          = trunc(TO_DATE(''' ||
   var_date ||
   ''')))'
  INTO
   VAR
  FROM DUAL;
DBMS_OUTPUT.PUT_LINE(var);
  EXECUTE IMMEDIATE VAR INTO
   VAR3;
  SELECT
   CASE
    WHEN SUBSTR(
     TO_CHAR(VAR3)
    ,-1
    ) IN (
     '-','+'
    ) THEN VAR3 ||
    '0'
    ELSE VAR3
   END
  INTO
   VAR
  FROM DUAL;

  EXECUTE IMMEDIATE 'select ' ||
  NVL(TO_CHAR(VAR),0) ||
  ' from dual' INTO
   VAR2;

  --RETURN abs(to_number(VAR2));
  --RETURN VAR;
  
  INSERT
INTO TBL_NOP_FINAL_RESULT
  (
   
    REPREQ,
    REF_REPORT,
    TITLE,
    REF_TIMING,
    REF_CURRENCY,
    BALANCE,
    MOADEL_arzi
  )
  VALUES
  (
 
   inpar_REPREQ,
    inpar_REF_REPORT,
    inpar_TITLE,
    inapr_REF_TIMING,
    i.src_cur_id,
    abs(to_number(VAR2)),
    abs(to_number(VAR2))/ i.change_rate
  );
  commit;
  end loop;
 END prc_nop_GI_CALC;


/*---------------------------------------------------------------------------------------------*/
/***********************************************************************************************/
/*---------------------------------------------------------------------------------------------*/

END PKG_NOP;
--------------------------------------------------------
--  DDL for Table PKG_NOP_SIMPLE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_NOP_SIMPLE" as 

   FUNCTION FNC_NOP_RESULT (inpar_date varchar2)  RETURN clob ; 
   FUNCTION FNC_NOP_simple_tree  RETURN VARCHAR2 ; 
   FUNCTION FNC_NOP_GET_DETAIL_NAME(inpar_date varchar2)  RETURN VARCHAR2 ; 


end pkg_nop_simple;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_NOP_SIMPLE" as

function fnc_nop_result (inpar_date varchar2)  return clob  as



var_pivot VARCHAR2(30000);
var_select VARCHAR2(30000);
var_selectnvl VARCHAR2(30000);
var_pivoty VARCHAR2(30000);
var_selecty VARCHAR2(30000);
var_selectynvl VARCHAR2(30000);
var_pivotz VARCHAR2(30000);
var_selectz VARCHAR2(30000);
var_selectznvl VARCHAR2(30000);
var_change_rate number;

VAR_DATE VARCHAR2(30000);
  begin

 IF
  ( ( TRUNC(TO_DATE(INPAR_DATE,'yyyy-mm-dd') ) ) = ( TRUNC(SYSDATE) ) )
 THEN
  SELECT
   MAX(TO_CHAR(EFF_DATE,'yyyy-mm-dd') )
  INTO
   VAR_DATE
  FROM TBL_LEDGER_ARCHIVE;

 ELSE
  VAR_DATE   := INPAR_DATE;
 END IF;
 
 select CHANGE_RATE into var_change_rate from TBL_CURRENCY_REL where trunc(REL_DATE) = to_date(VAR_DATE ,'yyyy-mm-dd') and SRC_CUR_ID =1;
 
 SELECT
 WMSYS.WM_CONCAT( (
  SELECT
   REF_CUR_ID ||
   ' AS "x' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '"'
  FROM DUAL
 ) ) ||',200 as "x200"' into var_pivot
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 
  SELECT
 WMSYS.WM_CONCAT( (
  SELECT
      
   '"x' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '"'
  FROM DUAL
 ) ) ||' ,"x200"' into var_select
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE  trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 SELECT
 WMSYS.WM_CONCAT( (
  SELECT
      
   'nvl("x' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '",0) as "x' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '" '
  FROM DUAL
 ) ) ||' ,nvl("x200",0) as "x200" ' into var_selectnvl
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE  trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 SELECT
 WMSYS.WM_CONCAT( (
  SELECT
   REF_CUR_ID ||
   ' AS "y' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '"'
  FROM DUAL
 ) ) ||',200 as "y200"' into var_pivoty
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
  SELECT
 WMSYS.WM_CONCAT( (
  SELECT
      
   '"y' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '"'
  FROM DUAL
 ) ) ||' ,"y200"' into var_selecty
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE  trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 SELECT
 WMSYS.WM_CONCAT( (
  SELECT
      
   'nvl("y' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '",0) as "y' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '" '
  FROM DUAL
 ) ) ||' ,nvl("y200",0) as "y200"' into var_selectynvl
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE  trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 
 
 
 
 SELECT
 WMSYS.WM_CONCAT( (
  SELECT
   REF_CUR_ID ||
   ' AS "z' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '"'
  FROM DUAL
 ) ) ||',200 as "z200"' into var_pivotz
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 
  SELECT
 WMSYS.WM_CONCAT( (
  SELECT
      
   '"z' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '"'
  FROM DUAL
 ) ) ||' ,"z200"' into var_selectz
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE  trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 SELECT
 WMSYS.WM_CONCAT( (
  SELECT
      
   'nvl("z' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '",0) as "z' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '" '
  FROM DUAL
 ) ) ||' ,nvl("z200",0) as "z200" ' into var_selectznvl
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE  trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 
 
 
 
 
 if (replace(var_select,' ,"x200"',null) is null) then 
 RETurn ' select null from dual';
 else
 
 return 
 'select a."id",a."name",a."parent" ,'||var_selectnvl||','||var_selectynvl||','||var_selectznvl||' from (select LEDGER_CODE as "id" ,name as "name",parent as "parent",'||var_select||' from (

select * from (
select LEDGER_CODE,name,abs(cur_balance) as cur_balance,REF_CUR_ID,100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,cur_balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =  to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 100000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as cur_balance,max(REF_CUR_ID),100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 100000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
   select LEDGER_CODE,name,abs(cur_balance) as cur_balance,REF_CUR_ID,200000000, ''بدهي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,cur_balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =    to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 200000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as cur_balance,max(REF_CUR_ID),200000000 as parent,  ''بدهي هاي ارزي'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,200000000 as parent,  ''بدهي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 200000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
    select LEDGER_CODE,name,abs(cur_balance) as cur_balance,REF_CUR_ID,702000000, ''دارايي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,cur_balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 702000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as cur_balance,max(REF_CUR_ID),702000000 as parent,  ''دارايي هاي زير خط'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,702000000 as parent,  ''دارايي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 702000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
    select LEDGER_CODE,name,abs(balance) as balance,REF_CUR_ID,704000000, ''بدهي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =    to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 704000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),704000000 as parent,  ''بدهي هاي زير خط'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,704000000 as parent,  ''بدهي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 704000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE)
   pivot
   (
  max(cur_balance)
  FOR REF_CUR_ID IN ('||var_pivot||')
) ORDER BY parent
)
)a, (
select LEDGER_CODE as "id" ,name as "name",parent as "parent",'||var_selecty||' from (

select * from (
select LEDGER_CODE,name,abs(balance) as balance,REF_CUR_ID,100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =  to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 100000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 100000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
   select LEDGER_CODE,name,abs(balance) as balance,REF_CUR_ID,200000000, ''بدهي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =    to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 200000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),200000000 as parent,  ''بدهي هاي ارزي'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,200000000 as parent,  ''بدهي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 200000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
    select LEDGER_CODE,name,abs(balance) as balance,REF_CUR_ID,702000000, ''دارايي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 702000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),702000000 as parent,  ''دارايي هاي زير خط'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,702000000 as parent,  ''دارايي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 702000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
    select LEDGER_CODE,name,abs(balance) as balance,REF_CUR_ID,704000000, ''بدهي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =    to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 704000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),704000000 as parent,  ''بدهي هاي زير خط'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,704000000 as parent,  ''بدهي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 704000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE)
   pivot
   (
  max(balance)
  FOR REF_CUR_ID IN ('||var_pivoty||')
) ORDER BY parent
))b , (
select LEDGER_CODE as "id" ,name as "name",parent as "parent",'||var_selectz||' from (

select * from (
select LEDGER_CODE,name,round(abs(balance)/'||var_change_rate||',2) as balance,REF_CUR_ID,100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =  to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 100000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 100000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
   select LEDGER_CODE,name,round(abs(balance)/'||var_change_rate||',2) as balance,REF_CUR_ID,200000000, ''بدهي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =    to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 200000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),200000000 as parent,  ''بدهي هاي ارزي'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,200000000 as parent,  ''بدهي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 200000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
    select LEDGER_CODE,name,round(abs(balance)/'||var_change_rate||',2) as balance,REF_CUR_ID,702000000, ''دارايي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 702000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),702000000 as parent,  ''دارايي هاي زير خط'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,702000000 as parent,  ''دارايي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 702000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
    select LEDGER_CODE,name,round(abs(balance)/'||var_change_rate||',2) as balance,REF_CUR_ID,704000000, ''بدهي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =    to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 704000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),704000000 as parent,  ''بدهي هاي زير خط'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,704000000 as parent,  ''بدهي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 704000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE)
   pivot
   (
  max(balance)
  FOR REF_CUR_ID IN ('||var_pivotz||')
) ORDER BY parent
))c  where a."id" = b."id" and a."id" = c."id"';
 end if ;
  
  end fnc_nop_result;


--/\/\/\/\/\/\/\/\/\/\//\\/\\


function FNC_NOP_simple_tree  return varchar2  as
begin
RETURN 'SELECT
 ID as "id"
 ,NAME "name"
 ,PARENT "parent"
 ,DEPTH "level"
FROM TBL_NOP_SIMPLE_TREE
order by ID';
end;

--/\\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
FUNCTION FNC_NOP_GET_DETAIL_NAME (inpar_date varchar2)  RETURN VARCHAR2
  AS
 var_date varchar2(2000);
 BEGIN
 IF
  ( ( TRUNC(TO_DATE(INPAR_DATE,'yyyy-mm-dd') ) ) = ( TRUNC(SYSDATE) ) )
 THEN
  SELECT
   MAX(TO_CHAR(EFF_DATE,'yyyy-mm-dd') )
  INTO
   VAR_DATE
  FROM TBL_LEDGER_ARCHIVE;

 ELSE
  VAR_DATE   := INPAR_DATE;
 END IF;
 
 
  RETURN 'select "value","header" from(select distinct ''x''||CUR_ID as "value",cur_name as "header",cur_id as "cur" from TBL_currency,tbl_ledger_archive a where ref_cur_id=cur_id  
  and a.ref_cur_id <>4 and trunc(a.eff_date) = to_date('''||VAR_DATE||''' ,''yyyy-mm-dd'') order by CUR_ID) union all select ''x200'' as "value" , ''جمع ريالي'' as "header" from dual
  
  union all 
  select "value","header" from(
  select distinct ''y''||CUR_ID as "value",cur_name as "header",cur_id as "cur" from TBL_currency,tbl_ledger_archive a where ref_cur_id=cur_id  
  and a.ref_cur_id <>4 and trunc(a.eff_date) = to_date('''||VAR_DATE||''' ,''yyyy-mm-dd'')
  order by CUR_ID
  )
  union all select ''y200'' as "value" , ''جمع ريالي'' as "header" from dual
  
  union all 
  select "value","header" from(
  select distinct ''z''||CUR_ID as "value",cur_name as "header",cur_id as "cur" from TBL_currency,tbl_ledger_archive a where ref_cur_id=cur_id  
  and a.ref_cur_id <>4 and trunc(a.eff_date) = to_date('''||VAR_DATE||''' ,''yyyy-mm-dd'')
  order by CUR_ID
  )
  union all select ''z200'' as "value" , ''جمع ريالي'' as "header" from dual
  
  union all
  select ''t200'' as "value",to_char(sum(balance)) as "header" from tbl_ledger_archive where ledger_code in (100000000,200000000) and trunc(eff_date)=to_date('''||VAR_DATE||''' ,''yyyy-mm-dd'')
';
 END FNC_NOP_GET_DETAIL_NAME;


end pkg_nop_simple;
--------------------------------------------------------
--  DDL for Table PKG_NOP_SIMPLE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_NOP_SIMPLE" as 

   FUNCTION FNC_NOP_RESULT (inpar_date varchar2)  RETURN clob ; 
   FUNCTION FNC_NOP_simple_tree  RETURN VARCHAR2 ; 
   FUNCTION FNC_NOP_GET_DETAIL_NAME(inpar_date varchar2)  RETURN VARCHAR2 ; 


end pkg_nop_simple;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_NOP_SIMPLE" as

function fnc_nop_result (inpar_date varchar2)  return clob  as



var_pivot VARCHAR2(30000);
var_select VARCHAR2(30000);
var_selectnvl VARCHAR2(30000);
var_pivoty VARCHAR2(30000);
var_selecty VARCHAR2(30000);
var_selectynvl VARCHAR2(30000);
var_pivotz VARCHAR2(30000);
var_selectz VARCHAR2(30000);
var_selectznvl VARCHAR2(30000);
var_change_rate number;

VAR_DATE VARCHAR2(30000);
  begin

 IF
  ( ( TRUNC(TO_DATE(INPAR_DATE,'yyyy-mm-dd') ) ) = ( TRUNC(SYSDATE) ) )
 THEN
  SELECT
   MAX(TO_CHAR(EFF_DATE,'yyyy-mm-dd') )
  INTO
   VAR_DATE
  FROM TBL_LEDGER_ARCHIVE;

 ELSE
  VAR_DATE   := INPAR_DATE;
 END IF;
 
 select CHANGE_RATE into var_change_rate from TBL_CURRENCY_REL where trunc(REL_DATE) = to_date(VAR_DATE ,'yyyy-mm-dd') and SRC_CUR_ID =1;
 
 SELECT
 WMSYS.WM_CONCAT( (
  SELECT
   REF_CUR_ID ||
   ' AS "x' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '"'
  FROM DUAL
 ) ) ||',200 as "x200"' into var_pivot
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 
  SELECT
 WMSYS.WM_CONCAT( (
  SELECT
      
   '"x' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '"'
  FROM DUAL
 ) ) ||' ,"x200"' into var_select
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE  trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 SELECT
 WMSYS.WM_CONCAT( (
  SELECT
      
   'nvl("x' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '",0) as "x' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '" '
  FROM DUAL
 ) ) ||' ,nvl("x200",0) as "x200" ' into var_selectnvl
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE  trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 SELECT
 WMSYS.WM_CONCAT( (
  SELECT
   REF_CUR_ID ||
   ' AS "y' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '"'
  FROM DUAL
 ) ) ||',200 as "y200"' into var_pivoty
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
  SELECT
 WMSYS.WM_CONCAT( (
  SELECT
      
   '"y' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '"'
  FROM DUAL
 ) ) ||' ,"y200"' into var_selecty
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE  trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 SELECT
 WMSYS.WM_CONCAT( (
  SELECT
      
   'nvl("y' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '",0) as "y' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '" '
  FROM DUAL
 ) ) ||' ,nvl("y200",0) as "y200"' into var_selectynvl
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE  trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 
 
 
 
 SELECT
 WMSYS.WM_CONCAT( (
  SELECT
   REF_CUR_ID ||
   ' AS "z' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '"'
  FROM DUAL
 ) ) ||',200 as "z200"' into var_pivotz
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 
  SELECT
 WMSYS.WM_CONCAT( (
  SELECT
      
   '"z' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '"'
  FROM DUAL
 ) ) ||' ,"z200"' into var_selectz
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE  trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 SELECT
 WMSYS.WM_CONCAT( (
  SELECT
      
   'nvl("z' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '",0) as "z' ||
   REPLACE(REF_CUR_ID,' ','_') ||
   '" '
  FROM DUAL
 ) ) ||' ,nvl("z200",0) as "z200" ' into var_selectznvl
FROM (
  SELECT DISTINCT
   REF_CUR_ID
  FROM TBL_LEDGER_ARCHIVE
  WHERE  trunc(EFF_DATE)   = to_date(VAR_DATE ,'yyyy-mm-dd')
   AND
    REF_CUR_ID <> 4
    ORDER BY REF_CUR_ID
 );
 
 
 
 
 
 
 if (replace(var_select,' ,"x200"',null) is null) then 
 RETurn ' select null from dual';
 else
 
 return 
 'select a."id",a."name",a."parent" ,'||var_selectnvl||','||var_selectynvl||','||var_selectznvl||' from (select LEDGER_CODE as "id" ,name as "name",parent as "parent",'||var_select||' from (

select * from (
select LEDGER_CODE,name,abs(cur_balance) as cur_balance,REF_CUR_ID,100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,cur_balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =  to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 100000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as cur_balance,max(REF_CUR_ID),100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 100000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
   select LEDGER_CODE,name,abs(cur_balance) as cur_balance,REF_CUR_ID,200000000, ''بدهي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,cur_balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =    to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 200000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as cur_balance,max(REF_CUR_ID),200000000 as parent,  ''بدهي هاي ارزي'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,200000000 as parent,  ''بدهي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 200000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
    select LEDGER_CODE,name,abs(cur_balance) as cur_balance,REF_CUR_ID,702000000, ''دارايي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,cur_balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 702000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as cur_balance,max(REF_CUR_ID),702000000 as parent,  ''دارايي هاي زير خط'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,702000000 as parent,  ''دارايي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 702000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
    select LEDGER_CODE,name,abs(balance) as balance,REF_CUR_ID,704000000, ''بدهي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =    to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 704000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),704000000 as parent,  ''بدهي هاي زير خط'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,704000000 as parent,  ''بدهي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 704000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE)
   pivot
   (
  max(cur_balance)
  FOR REF_CUR_ID IN ('||var_pivot||')
) ORDER BY parent
)
)a, (
select LEDGER_CODE as "id" ,name as "name",parent as "parent",'||var_selecty||' from (

select * from (
select LEDGER_CODE,name,abs(balance) as balance,REF_CUR_ID,100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =  to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 100000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 100000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
   select LEDGER_CODE,name,abs(balance) as balance,REF_CUR_ID,200000000, ''بدهي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =    to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 200000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),200000000 as parent,  ''بدهي هاي ارزي'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,200000000 as parent,  ''بدهي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 200000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
    select LEDGER_CODE,name,abs(balance) as balance,REF_CUR_ID,702000000, ''دارايي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 702000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),702000000 as parent,  ''دارايي هاي زير خط'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,702000000 as parent,  ''دارايي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 702000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
    select LEDGER_CODE,name,abs(balance) as balance,REF_CUR_ID,704000000, ''بدهي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =    to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 704000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),704000000 as parent,  ''بدهي هاي زير خط'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,704000000 as parent,  ''بدهي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 704000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE)
   pivot
   (
  max(balance)
  FOR REF_CUR_ID IN ('||var_pivoty||')
) ORDER BY parent
))b , (
select LEDGER_CODE as "id" ,name as "name",parent as "parent",'||var_selectz||' from (

select * from (
select LEDGER_CODE,name,round(abs(balance)/'||var_change_rate||',2) as balance,REF_CUR_ID,100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =  to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 100000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,100000000 as parent,  ''دارايي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 100000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
   select LEDGER_CODE,name,round(abs(balance)/'||var_change_rate||',2) as balance,REF_CUR_ID,200000000, ''بدهي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =    to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 200000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),200000000 as parent,  ''بدهي هاي ارزي'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,200000000 as parent,  ''بدهي هاي ارزي'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 200000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
    select LEDGER_CODE,name,round(abs(balance)/'||var_change_rate||',2) as balance,REF_CUR_ID,702000000, ''دارايي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 702000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),702000000 as parent,  ''دارايي هاي زير خط'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,702000000 as parent,  ''دارايي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 702000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE
   union
    select LEDGER_CODE,name,round(abs(balance)/'||var_change_rate||',2) as balance,REF_CUR_ID,704000000, ''بدهي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =    to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 704000000)
   where s = 1 and REF_CUR_ID <>4
    union
         select LEDGER_CODE,max(name),sum(abs(balance)) as balance,max(REF_CUR_ID),704000000 as parent,  ''بدهي هاي زير خط'' "parentName" from (
select LEDGER_CODE,name,abs(balance) as balance,200 as REF_CUR_ID,704000000 as parent,  ''بدهي هاي زير خط'' "parentName" from (
SELECT  
   LEDGER_CODE,level as s,balance,REF_CUR_ID,name 
FROM
( select * from  
   TBL_LEDGER_ARCHIVE where  trunc(EFF_DATE) =   to_date('''||VAR_DATE||''' ,''yyyy-mm-dd''))
CONNECT BY
   PRIOR  LEDGER_CODE =PARENT_CODE 
START WITH
   PARENT_CODE  = 704000000)
   where s = 1 and REF_CUR_ID <>4
   )
   group by LEDGER_CODE)
   pivot
   (
  max(balance)
  FOR REF_CUR_ID IN ('||var_pivotz||')
) ORDER BY parent
))c  where a."id" = b."id" and a."id" = c."id"';
 end if ;
  
  end fnc_nop_result;


--/\/\/\/\/\/\/\/\/\/\//\\/\\


function FNC_NOP_simple_tree  return varchar2  as
begin
RETURN 'SELECT
 ID as "id"
 ,NAME "name"
 ,PARENT "parent"
 ,DEPTH "level"
FROM TBL_NOP_SIMPLE_TREE
order by ID';
end;

--/\\//\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
FUNCTION FNC_NOP_GET_DETAIL_NAME (inpar_date varchar2)  RETURN VARCHAR2
  AS
 var_date varchar2(2000);
 BEGIN
 IF
  ( ( TRUNC(TO_DATE(INPAR_DATE,'yyyy-mm-dd') ) ) = ( TRUNC(SYSDATE) ) )
 THEN
  SELECT
   MAX(TO_CHAR(EFF_DATE,'yyyy-mm-dd') )
  INTO
   VAR_DATE
  FROM TBL_LEDGER_ARCHIVE;

 ELSE
  VAR_DATE   := INPAR_DATE;
 END IF;
 
 
  RETURN 'select "value","header" from(select distinct ''x''||CUR_ID as "value",cur_name as "header",cur_id as "cur" from TBL_currency,tbl_ledger_archive a where ref_cur_id=cur_id  
  and a.ref_cur_id <>4 and trunc(a.eff_date) = to_date('''||VAR_DATE||''' ,''yyyy-mm-dd'') order by CUR_ID) union all select ''x200'' as "value" , ''جمع ريالي'' as "header" from dual
  
  union all 
  select "value","header" from(
  select distinct ''y''||CUR_ID as "value",cur_name as "header",cur_id as "cur" from TBL_currency,tbl_ledger_archive a where ref_cur_id=cur_id  
  and a.ref_cur_id <>4 and trunc(a.eff_date) = to_date('''||VAR_DATE||''' ,''yyyy-mm-dd'')
  order by CUR_ID
  )
  union all select ''y200'' as "value" , ''جمع ريالي'' as "header" from dual
  
  union all 
  select "value","header" from(
  select distinct ''z''||CUR_ID as "value",cur_name as "header",cur_id as "cur" from TBL_currency,tbl_ledger_archive a where ref_cur_id=cur_id  
  and a.ref_cur_id <>4 and trunc(a.eff_date) = to_date('''||VAR_DATE||''' ,''yyyy-mm-dd'')
  order by CUR_ID
  )
  union all select ''z200'' as "value" , ''جمع ريالي'' as "header" from dual
  
  union all
  select ''t200'' as "value",to_char(sum(balance)) as "header" from tbl_ledger_archive where ledger_code in (100000000,200000000) and trunc(eff_date)=to_date('''||VAR_DATE||''' ,''yyyy-mm-dd'')
';
 END FNC_NOP_GET_DETAIL_NAME;


end pkg_nop_simple;
--------------------------------------------------------
--  DDL for Table PKG_DUE_DATE_DEPOSIT_RATE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_DUE_DATE_DEPOSIT_RATE" AS

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/


 FUNCTION FNC_DDDR_TREE_BUILDER ( inpar_report IN number,inpar_repreq in number ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  PROCEDURE prc_DDDR_GET_DETAIL ( inpar_report in varchar2  );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_DDDR_DELETE_REPORT(
    INPAR_ID IN VARCHAR2 ,
    OUTPAR OUT VARCHAR2);
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
    
    PROCEDURE PRC_dddr_REP_PROFILE_REPORT(
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_REF_USER         IN VARCHAR2 ,
    INPAR_STATUS           IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    inpar_first_date  in varchar2,
    inpar_last_date in varchar2,
    inpar_tree in varchar2,
    OUTPAR_ID OUT VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_DDDR_deposit_type  RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

function fnc_dddr_get_tree_detail(inpar_repreq in number) return varchar2;


/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_DDDR_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_DDDR_GET_detail_child ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_DDDR_GET_count ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_DUE_DATE_DEPOSIT_RATE;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_DUE_DATE_DEPOSIT_RATE" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DDDR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_DDDR_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
 END PRC_DDDR_DELETE_REPORT;
/*------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------*/

 PROCEDURE PRC_DDDR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_FIRST_DATE         IN VARCHAR2
 ,INPAR_LAST_DATE          IN VARCHAR2
 ,INPAR_TREE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 ) AS
  VAR_TREE     VARCHAR2(100);
  MAX_REPREQ   NUMBER;
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,FIRST_DATE
   ,LAST_DATE
   ,TYPE
   ,REF_LEDGER_PROFIEL
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'DDDR'
   ,INPAR_FIRST_DATE
   ,INPAR_LAST_DATE
   ,INPAR_TYPE
   ,INPAR_TREE
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
    ,FIRST_DATE = INPAR_FIRST_DATE
    ,LAST_DATE = INPAR_LAST_DATE
    ,REF_LEDGER_PROFIEL = INPAR_TREE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;

  UPDATE TBL_REPORT
   SET
    H_ID = ID
  WHERE UPPER(TYPE) = 'DDDR'
   AND
    H_ID IS NULL;

  COMMIT;
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   SELECT
    MAX(REF_REPREQ)
   INTO
    MAX_REPREQ
   FROM TBL_DDLT_TREE
   WHERE REF_REPORT   = OUTPAR_ID;

   IF
    ( MAX_REPREQ IS NULL
    )
   THEN
    MAX_REPREQ   :=-1;
   END IF;
   SELECT
    PKG_DUE_DATE_DEPOSIT_RATE.FNC_DDDR_TREE_BUILDER(OUTPAR_ID,MAX_REPREQ)
   INTO
    VAR_TREE
   FROM DUAL;

  ELSE
   SELECT
    MAX(REF_REPREQ)
   INTO
    MAX_REPREQ
   FROM TBL_DDLT_TREE
   WHERE REF_REPORT   = INPAR_ID;

   IF
    ( MAX_REPREQ IS NULL
    )
   THEN
    MAX_REPREQ   :=-1;
   END IF;
   SELECT
    PKG_DUE_DATE_DEPOSIT_RATE.FNC_DDDR_TREE_BUILDER(INPAR_ID,MAX_REPREQ)
   INTO
    VAR_TREE
   FROM DUAL;

  END IF;

  COMMIT;
 END PRC_DDDR_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDDR_TREE_BUILDER (
  INPAR_REPORT   IN NUMBER
 ,INPAR_REPREQ   IN NUMBER
 ) RETURN VARCHAR2 AS
  VAR_PARENT_ID   NUMBER := 1;
  INPAR_TREE      VARCHAR2(30000);
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
  SELECT
   REF_LEDGER_PROFIEL
  INTO
   INPAR_TREE
  FROM TBL_REPORT
  WHERE ID   = INPAR_REPORT;

  DELETE FROM TBL_DDDR_TREE WHERE REF_REPORT   = INPAR_REPORT
   AND
    REF_REPREQ   = INPAR_REPREQ;

  COMMIT;
  FOR I IN (
   SELECT
    REGEXP_SUBSTR(
     INPAR_TREE
    ,'[^;]+'
    ,1
    ,LEVEL
    ) AS S
   FROM DUAL
   CONNECT BY
    REGEXP_SUBSTR(
     INPAR_TREE
    ,'[^;]+'
    ,1
    ,LEVEL
    ) IS NOT NULL
  ) LOOP
   INSERT INTO TBL_DDDR_TREE (
    PARENT_ID
   ,PARENT_NAME
   ,CHILD_ID
   ,CHILD_NAME
   ,DEPTH
   ,REF_REPREQ
   ,REF_REPORT
   ) SELECT
    0
   ,NULL
   ,VAR_PARENT_ID
   ,SUBSTR(
     I.S
    ,-LENGTH(I.S)
    ,INSTR(I.S,'#') - 1
    ) AS NAME
   ,1
   ,INPAR_REPREQ
   ,INPAR_REPORT
   FROM DUAL;

   COMMIT;
   INSERT INTO TBL_DDDR_TREE (
    PARENT_ID
   ,PARENT_NAME
   ,CHILD_ID
   ,CHILD_NAME
   ,DEPTH
   ,REF_REPREQ
   ,REF_REPORT
   ) SELECT
    VAR_PARENT_ID
   ,NULL
   ,REGEXP_SUBSTR(
     SUBSTR(
      I.S
     ,INSTR(I.S,'#') + 1
     )
    ,'[^,]+'
    ,1
    ,LEVEL
    ) AS S
   ,NULL
   ,2
   ,INPAR_REPREQ
   ,INPAR_REPORT
   FROM DUAL
   CONNECT BY
    REGEXP_SUBSTR(
     SUBSTR(
      I.S
     ,INSTR(I.S,'#') + 1
     )
    ,'[^,]+'
    ,1
    ,LEVEL
    ) IS NOT NULL;

   VAR_PARENT_ID   := VAR_PARENT_ID + 1;
  END LOOP;

  COMMIT;
  UPDATE TBL_DDDR_TREE
   SET
    CHILD_NAME = (
     SELECT
      NAME
     FROM TBL_DEPOSIT_TYPE
     WHERE TBL_DDDR_TREE.CHILD_ID   = REF_DEPOSIT_TYPE
    )
  WHERE CHILD_NAME IS NULL
   AND
    DEPTH   = 2;

  COMMIT;
  RETURN NULL;
 END FNC_DDDR_TREE_BUILDER;
  /*<><><><><><><><><><><><><><><><><><><><><><><>--*/
  /*<><><><><><><><><><><><><><><><><><><><><><><>--*/
  /*<><><><><><><><><><><><><><><><><><><><><><><>--*/
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDDR_DEPOSIT_TYPE RETURN VARCHAR2
  AS
 BEGIN
  RETURN 'select  ref_deposit_type as "id" ,name as "name" from tbl_deposit_type';
 END FNC_DDDR_DEPOSIT_TYPE;

  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDDR_GET_TREE_DETAIL ( INPAR_REPREQ IN NUMBER ) RETURN VARCHAR2
  AS
 BEGIN
  RETURN ' SELECT  "id","name","parent","level"
FROM (SELECT
 CHILD_ID AS "id"
 ,CHILD_NAME AS "name"
 ,PARENT_ID AS "parent"
 ,PARENT_NAME AS "parentName"
 ,DEPTH AS "level"
FROM TBL_DDDR_TREE
WHERE REF_REPORT   = ' ||
  INPAR_REPREQ ||
  '
 AND
  REF_REPREQ   = (
   SELECT
    MAX(REF_REPREQ)
   FROM TBL_DDDR_TREE
   WHERE REF_REPORT   = ' ||
  INPAR_REPREQ ||
  '
  ))
START WITH "parent" =0
CONNECT BY prior "id" ="parent"';
 END FNC_DDDR_GET_TREE_DETAIL;

  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDDR_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
  ,to_char(to_date(first_date,''yyyy-mm-dd''),''yyyy/mm/dd'',''nls_calendar=persian'') as "startDate"
  ,to_char(to_date(last_date,''yyyy-mm-dd''),''yyyy/mm/dd'',''nls_calendar=persian'') as "endDate"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''DDDR'' order by id';
  RETURN VAR2;
 END FNC_DDDR_GET_REPORT_INFO;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDDR_GET_DETAIL_CHILD ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'select   X1 as "x1"
 ,X2 as "x2"
 ,X3 as "x3"
 ,X4 as "x4"
 ,X5 as "x5"
 ,X6 as "x6"
 ,X7 as "x7"
 ,REF_DEPOSIT_TYPE as "id" from TBL_DDDR_REP_PROFILE_DETAIL where REF_REPREQ =  '
|| INPAR_ID || '  order by REF_DEPOSIT_TYPE';
  RETURN VAR2;
 END FNC_DDDR_GET_DETAIL_CHILD;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDDR_GET_COUNT ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'select   X1 as "x1"
 ,X2 as "x2"
 ,X3 as "x3"
 ,X4 as "x4"
 ,X5 as "x5"
 ,X6 as "x6"
 ,X7 as "x7"
 ,REF_DEPOSIT_TYPE as "id" from TBL_DDDR_REP_PROFILE_DETAIL where REF_REPREQ = '
|| INPAR_ID || '  and REF_DEPOSIT_TYPE =-1  order by REF_DEPOSIT_TYPE';
  RETURN VAR2;
 END FNC_DDDR_GET_COUNT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DDDR_GET_DETAIL ( INPAR_REPORT IN VARCHAR2 ) AS

  INPAR_DATE_FIRST   VARCHAR2(200);
  INPAR_DATE_LAST    VARCHAR2(200);
  VAR_MAX_REPREQ     NUMBER;
  VAR_TREE           VARCHAR2(100);
  VAR                VARCHAR2(30000);
 BEGIN
  SELECT
   FIRST_DATE
  INTO
   INPAR_DATE_FIRST
  FROM TBL_REPORT
  WHERE ID   = INPAR_REPORT;

  SELECT
   LAST_DATE
  INTO
   INPAR_DATE_LAST
  FROM TBL_REPORT
  WHERE ID   = INPAR_REPORT;

  SELECT
   MAX(ID)
  INTO
   VAR_MAX_REPREQ
  FROM TBL_REPREQ;

  SELECT
   PKG_DUE_DATE_DEPOSIT_RATE.FNC_DDDR_TREE_BUILDER(INPAR_REPORT,VAR_MAX_REPREQ)
  INTO
   VAR_TREE
  FROM DUAL;

  IF
   ( ( TRUNC(TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') ) ) <= ( TRUNC(SYSDATE) ) )
  THEN
   INSERT INTO TBL_DDDR_REP_PROFILE_DETAIL (
    REF_REPORT
   ,REF_DEPOSIT_TYPE
   ,X1
   ,X2
   ,X3
   ,X4
   ,X5
   ,X6
   ,X7
   ,REF_REPREQ
   ) SELECT
    INPAR_REPORT
   ,/*+ PARALLEL(auto) */
    REF_DEPOSIT_TYPE "id"
   ,NVL(
     SUM(
      CASE
       WHEN RATE < 15 THEN(BALANCE)
      END
     )
    ,0
    ) AS "1"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 15 AND 15.99 THEN(BALANCE)
      END
     )
    ,0
    ) "2"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 16 AND 16.99 THEN(BALANCE)
      END
     )
    ,0
    ) "3"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 17 AND 17.99 THEN(BALANCE)
      END
     )
    ,0
    ) "4"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 18 AND 18.99 THEN(BALANCE)
      END
     )
    ,0
    ) "5"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 19 AND 19.99 THEN(BALANCE)
      END
     )
    ,0
    ) "6"
   ,NVL(
     SUM(
      CASE
       WHEN RATE >= 20 THEN(BALANCE)
      END
     )
    ,0
    ) "7"
   ,VAR_MAX_REPREQ
   FROM AKIN.TBL_DEPOSIT
   WHERE TRUNC(DUE_DATE) BETWEEN TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') AND TO_DATE(INPAR_DATE_LAST,'yyyy-mm-dd')
   GROUP BY
    REF_DEPOSIT_TYPE
   UNION
   SELECT
    INPAR_REPORT
   ,/*+ PARALLEL(auto) */
    REF_DEPOSIT_TYPE "id"
   ,NVL(
     SUM(
      CASE
       WHEN RATE < 15 THEN(BALANCE)
      END
     )
    ,0
    ) AS "1"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 15 AND 15.99 THEN(BALANCE)
      END
     )
    ,0
    ) "2"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 16 AND 16.99 THEN(BALANCE)
      END
     )
    ,0
    ) "3"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 17 AND 17.99 THEN(BALANCE)
      END
     )
    ,0
    ) "4"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 18 AND 18.99 THEN(BALANCE)
      END
     )
    ,0
    ) "5"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 19 AND 19.99 THEN(BALANCE)
      END
     )
    ,0
    ) "6"
   ,NVL(
     SUM(
      CASE
       WHEN RATE >= 20 THEN(BALANCE)
      END
     )
    ,0
    ) "7"
   ,VAR_MAX_REPREQ
   FROM AKIN.TBL_DEPOSIT
   WHERE ( DUE_DATE ) IS NULL
   GROUP BY
    REF_DEPOSIT_TYPE;

   COMMIT;
   INSERT INTO TBL_DDDR_REP_PROFILE_DETAIL (
   REF_REPORT
   ,REF_DEPOSIT_TYPE
   ,X1
   ,X2
   ,X3
   ,X4
   ,X5
   ,X6
   ,X7
   ,REF_REPREQ
   ) SELECT
    INPAR_REPORT
   ,max( "id")
   ,SUM("1") as "1"
   ,SUM("2")  as "2"
   ,SUM("3")  as "3"
   ,SUM("4")  as "4"
   ,SUM("5")  as "5"
   ,SUM("6")  as "6"
   ,SUM("7")  as "7"
   ,VAR_MAX_REPREQ
   FROM (
     SELECT
      /*+ PARALLEL(auto) */
      -1 "id"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE < 15 THEN(BALANCE)
        END
       )
      ,0
      ) AS "1"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 15 AND 15.99 THEN(BALANCE)
        END
       )
      ,0
      ) "2"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 16 AND 16.99 THEN(BALANCE)
        END
       )
      ,0
      ) "3"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 17 AND 17.99 THEN(BALANCE)
        END
       )
      ,0
      ) "4"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 18 AND 18.99 THEN(BALANCE)
        END
       )
      ,0
      ) "5"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 19 AND 19.99 THEN(BALANCE)
        END
       )
      ,0
      ) "6"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE >= 20 THEN(BALANCE)
        END
       )
      ,0
      ) "7"
     
     FROM AKIN.TBL_DEPOSIT
     WHERE TRUNC(DUE_DATE) BETWEEN TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') AND TO_DATE(INPAR_DATE_LAST,'yyyy-mm-dd')
     UNION
     SELECT
     /*+ PARALLEL(auto) */
      -1 "ID"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE < 15 THEN(BALANCE)
        END
       )
      ,0
      ) AS "1"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 15 AND 15.99 THEN(BALANCE)
        END
       )
      ,0
      ) "2"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 16 AND 16.99 THEN(BALANCE)
        END
       )
      ,0
      ) "3"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 17 AND 17.99 THEN(BALANCE)
        END
       )
      ,0
      ) "4"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 18 AND 18.99 THEN(BALANCE)
        END
       )
      ,0
      ) "5"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 19 AND 19.99 THEN(BALANCE)
        END
       )
      ,0
      ) "6"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE >= 20 THEN(BALANCE)
        END
       )
      ,0
      ) "7"
     
     FROM AKIN.TBL_DEPOSIT
     WHERE ( DUE_DATE ) IS NULL
    )
   GROUP BY
    INPAR_REPORT;

   COMMIT;
  ELSE
   INSERT INTO TBL_DDDR_REP_PROFILE_DETAIL (
    REF_REPORT
   ,REF_DEPOSIT_TYPE
   ,X1
   ,X2
   ,X3
   ,X4
   ,X5
   ,X6
   ,X7
   ,REF_REPREQ
   ) SELECT
    INPAR_REPORT
   ,/*+ PARALLEL(auto) */
    REF_DEPOSIT_TYPE "id"
   ,NVL(
     SUM(
      CASE
       WHEN RATE < 15 THEN(BALANCE)
      END
     )
    ,0
    ) AS "1"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 15 AND 15.99 THEN(BALANCE)
      END
     )
    ,0
    ) "2"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 16 AND 16.99 THEN(BALANCE)
      END
     )
    ,0
    ) "3"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 17 AND 17.99 THEN(BALANCE)
      END
     )
    ,0
    ) "4"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 18 AND 18.99 THEN(BALANCE)
      END
     )
    ,0
    ) "5"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 19 AND 19.99 THEN(BALANCE)
      END
     )
    ,0
    ) "6"
   ,NVL(
     SUM(
      CASE
       WHEN RATE >= 20 THEN(BALANCE)
      END
     )
    ,0
    ) "7"
   ,VAR_MAX_REPREQ
   FROM AKIN.TBL_DEPOSIT
   WHERE TRUNC(DUE_DATE) BETWEEN TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') AND TO_DATE(INPAR_DATE_LAST,'yyyy-mm-dd')
   GROUP BY
    REF_DEPOSIT_TYPE;

   COMMIT;
   INSERT INTO TBL_DDDR_REP_PROFILE_DETAIL (
    REF_REPORT
   ,REF_DEPOSIT_TYPE
   ,X1
   ,X2
   ,X3
   ,X4
   ,X5
   ,X6
   ,X7
   ,REF_REPREQ
   ) SELECT
    INPAR_REPORT
   ,/*+ PARALLEL(auto) */
    -1 "id"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE < 15 THEN(BALANCE)
      END
     )
    ,0
    ) AS "1"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE BETWEEN 15 AND 15.99 THEN(BALANCE)
      END
     )
    ,0
    ) "2"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE BETWEEN 16 AND 16.99 THEN(BALANCE)
      END
     )
    ,0
    ) "3"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE BETWEEN 17 AND 17.99 THEN(BALANCE)
      END
     )
    ,0
    ) "4"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE BETWEEN 18 AND 18.99 THEN(BALANCE)
      END
     )
    ,0
    ) "5"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE BETWEEN 19 AND 19.99 THEN(BALANCE)
      END
     )
    ,0
    ) "6"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE >= 20 THEN(BALANCE)
      END
     )
    ,0
    ) "7"
   ,VAR_MAX_REPREQ
   FROM AKIN.TBL_DEPOSIT
   WHERE TRUNC(DUE_DATE) BETWEEN TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') AND TO_DATE(INPAR_DATE_LAST,'yyyy-mm-dd');

   COMMIT;
  END IF;

 END PRC_DDDR_GET_DETAIL;
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_DUE_DATE_DEPOSIT_RATE;
--------------------------------------------------------
--  DDL for Table PKG_DUE_DATE_DEPOSIT_RATE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_DUE_DATE_DEPOSIT_RATE" AS

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/


 FUNCTION FNC_DDDR_TREE_BUILDER ( inpar_report IN number,inpar_repreq in number ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  PROCEDURE prc_DDDR_GET_DETAIL ( inpar_report in varchar2  );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_DDDR_DELETE_REPORT(
    INPAR_ID IN VARCHAR2 ,
    OUTPAR OUT VARCHAR2);
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
    
    PROCEDURE PRC_dddr_REP_PROFILE_REPORT(
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_REF_USER         IN VARCHAR2 ,
    INPAR_STATUS           IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    inpar_first_date  in varchar2,
    inpar_last_date in varchar2,
    inpar_tree in varchar2,
    OUTPAR_ID OUT VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_DDDR_deposit_type  RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

function fnc_dddr_get_tree_detail(inpar_repreq in number) return varchar2;


/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_DDDR_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_DDDR_GET_detail_child ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_DDDR_GET_count ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_DUE_DATE_DEPOSIT_RATE;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_DUE_DATE_DEPOSIT_RATE" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DDDR_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_DDDR_REP_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
 END PRC_DDDR_DELETE_REPORT;
/*------------------------------------------------------------------------------*/
/*------------------------------------------------------------------------------*/

 PROCEDURE PRC_DDDR_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_FIRST_DATE         IN VARCHAR2
 ,INPAR_LAST_DATE          IN VARCHAR2
 ,INPAR_TREE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 ) AS
  VAR_TREE     VARCHAR2(100);
  MAX_REPREQ   NUMBER;
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,FIRST_DATE
   ,LAST_DATE
   ,TYPE
   ,REF_LEDGER_PROFIEL
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'DDDR'
   ,INPAR_FIRST_DATE
   ,INPAR_LAST_DATE
   ,INPAR_TYPE
   ,INPAR_TREE
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
    ,FIRST_DATE = INPAR_FIRST_DATE
    ,LAST_DATE = INPAR_LAST_DATE
    ,REF_LEDGER_PROFIEL = INPAR_TREE
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;

  UPDATE TBL_REPORT
   SET
    H_ID = ID
  WHERE UPPER(TYPE) = 'DDDR'
   AND
    H_ID IS NULL;

  COMMIT;
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   SELECT
    MAX(REF_REPREQ)
   INTO
    MAX_REPREQ
   FROM TBL_DDLT_TREE
   WHERE REF_REPORT   = OUTPAR_ID;

   IF
    ( MAX_REPREQ IS NULL
    )
   THEN
    MAX_REPREQ   :=-1;
   END IF;
   SELECT
    PKG_DUE_DATE_DEPOSIT_RATE.FNC_DDDR_TREE_BUILDER(OUTPAR_ID,MAX_REPREQ)
   INTO
    VAR_TREE
   FROM DUAL;

  ELSE
   SELECT
    MAX(REF_REPREQ)
   INTO
    MAX_REPREQ
   FROM TBL_DDLT_TREE
   WHERE REF_REPORT   = INPAR_ID;

   IF
    ( MAX_REPREQ IS NULL
    )
   THEN
    MAX_REPREQ   :=-1;
   END IF;
   SELECT
    PKG_DUE_DATE_DEPOSIT_RATE.FNC_DDDR_TREE_BUILDER(INPAR_ID,MAX_REPREQ)
   INTO
    VAR_TREE
   FROM DUAL;

  END IF;

  COMMIT;
 END PRC_DDDR_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDDR_TREE_BUILDER (
  INPAR_REPORT   IN NUMBER
 ,INPAR_REPREQ   IN NUMBER
 ) RETURN VARCHAR2 AS
  VAR_PARENT_ID   NUMBER := 1;
  INPAR_TREE      VARCHAR2(30000);
  PRAGMA AUTONOMOUS_TRANSACTION;
 BEGIN
  SELECT
   REF_LEDGER_PROFIEL
  INTO
   INPAR_TREE
  FROM TBL_REPORT
  WHERE ID   = INPAR_REPORT;

  DELETE FROM TBL_DDDR_TREE WHERE REF_REPORT   = INPAR_REPORT
   AND
    REF_REPREQ   = INPAR_REPREQ;

  COMMIT;
  FOR I IN (
   SELECT
    REGEXP_SUBSTR(
     INPAR_TREE
    ,'[^;]+'
    ,1
    ,LEVEL
    ) AS S
   FROM DUAL
   CONNECT BY
    REGEXP_SUBSTR(
     INPAR_TREE
    ,'[^;]+'
    ,1
    ,LEVEL
    ) IS NOT NULL
  ) LOOP
   INSERT INTO TBL_DDDR_TREE (
    PARENT_ID
   ,PARENT_NAME
   ,CHILD_ID
   ,CHILD_NAME
   ,DEPTH
   ,REF_REPREQ
   ,REF_REPORT
   ) SELECT
    0
   ,NULL
   ,VAR_PARENT_ID
   ,SUBSTR(
     I.S
    ,-LENGTH(I.S)
    ,INSTR(I.S,'#') - 1
    ) AS NAME
   ,1
   ,INPAR_REPREQ
   ,INPAR_REPORT
   FROM DUAL;

   COMMIT;
   INSERT INTO TBL_DDDR_TREE (
    PARENT_ID
   ,PARENT_NAME
   ,CHILD_ID
   ,CHILD_NAME
   ,DEPTH
   ,REF_REPREQ
   ,REF_REPORT
   ) SELECT
    VAR_PARENT_ID
   ,NULL
   ,REGEXP_SUBSTR(
     SUBSTR(
      I.S
     ,INSTR(I.S,'#') + 1
     )
    ,'[^,]+'
    ,1
    ,LEVEL
    ) AS S
   ,NULL
   ,2
   ,INPAR_REPREQ
   ,INPAR_REPORT
   FROM DUAL
   CONNECT BY
    REGEXP_SUBSTR(
     SUBSTR(
      I.S
     ,INSTR(I.S,'#') + 1
     )
    ,'[^,]+'
    ,1
    ,LEVEL
    ) IS NOT NULL;

   VAR_PARENT_ID   := VAR_PARENT_ID + 1;
  END LOOP;

  COMMIT;
  UPDATE TBL_DDDR_TREE
   SET
    CHILD_NAME = (
     SELECT
      NAME
     FROM TBL_DEPOSIT_TYPE
     WHERE TBL_DDDR_TREE.CHILD_ID   = REF_DEPOSIT_TYPE
    )
  WHERE CHILD_NAME IS NULL
   AND
    DEPTH   = 2;

  COMMIT;
  RETURN NULL;
 END FNC_DDDR_TREE_BUILDER;
  /*<><><><><><><><><><><><><><><><><><><><><><><>--*/
  /*<><><><><><><><><><><><><><><><><><><><><><><>--*/
  /*<><><><><><><><><><><><><><><><><><><><><><><>--*/
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDDR_DEPOSIT_TYPE RETURN VARCHAR2
  AS
 BEGIN
  RETURN 'select  ref_deposit_type as "id" ,name as "name" from tbl_deposit_type';
 END FNC_DDDR_DEPOSIT_TYPE;

  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDDR_GET_TREE_DETAIL ( INPAR_REPREQ IN NUMBER ) RETURN VARCHAR2
  AS
 BEGIN
  RETURN ' SELECT  "id","name","parent","level"
FROM (SELECT
 CHILD_ID AS "id"
 ,CHILD_NAME AS "name"
 ,PARENT_ID AS "parent"
 ,PARENT_NAME AS "parentName"
 ,DEPTH AS "level"
FROM TBL_DDDR_TREE
WHERE REF_REPORT   = ' ||
  INPAR_REPREQ ||
  '
 AND
  REF_REPREQ   = (
   SELECT
    MAX(REF_REPREQ)
   FROM TBL_DDDR_TREE
   WHERE REF_REPORT   = ' ||
  INPAR_REPREQ ||
  '
  ))
START WITH "parent" =0
CONNECT BY prior "id" ="parent"';
 END FNC_DDDR_GET_TREE_DETAIL;

  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDDR_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
  ,to_char(to_date(first_date,''yyyy-mm-dd''),''yyyy/mm/dd'',''nls_calendar=persian'') as "startDate"
  ,to_char(to_date(last_date,''yyyy-mm-dd''),''yyyy/mm/dd'',''nls_calendar=persian'') as "endDate"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''DDDR'' order by id';
  RETURN VAR2;
 END FNC_DDDR_GET_REPORT_INFO;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDDR_GET_DETAIL_CHILD ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'select   X1 as "x1"
 ,X2 as "x2"
 ,X3 as "x3"
 ,X4 as "x4"
 ,X5 as "x5"
 ,X6 as "x6"
 ,X7 as "x7"
 ,REF_DEPOSIT_TYPE as "id" from TBL_DDDR_REP_PROFILE_DETAIL where REF_REPREQ =  '
|| INPAR_ID || '  order by REF_DEPOSIT_TYPE';
  RETURN VAR2;
 END FNC_DDDR_GET_DETAIL_CHILD;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDDR_GET_COUNT ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'select   X1 as "x1"
 ,X2 as "x2"
 ,X3 as "x3"
 ,X4 as "x4"
 ,X5 as "x5"
 ,X6 as "x6"
 ,X7 as "x7"
 ,REF_DEPOSIT_TYPE as "id" from TBL_DDDR_REP_PROFILE_DETAIL where REF_REPREQ = '
|| INPAR_ID || '  and REF_DEPOSIT_TYPE =-1  order by REF_DEPOSIT_TYPE';
  RETURN VAR2;
 END FNC_DDDR_GET_COUNT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DDDR_GET_DETAIL ( INPAR_REPORT IN VARCHAR2 ) AS

  INPAR_DATE_FIRST   VARCHAR2(200);
  INPAR_DATE_LAST    VARCHAR2(200);
  VAR_MAX_REPREQ     NUMBER;
  VAR_TREE           VARCHAR2(100);
  VAR                VARCHAR2(30000);
 BEGIN
  SELECT
   FIRST_DATE
  INTO
   INPAR_DATE_FIRST
  FROM TBL_REPORT
  WHERE ID   = INPAR_REPORT;

  SELECT
   LAST_DATE
  INTO
   INPAR_DATE_LAST
  FROM TBL_REPORT
  WHERE ID   = INPAR_REPORT;

  SELECT
   MAX(ID)
  INTO
   VAR_MAX_REPREQ
  FROM TBL_REPREQ;

  SELECT
   PKG_DUE_DATE_DEPOSIT_RATE.FNC_DDDR_TREE_BUILDER(INPAR_REPORT,VAR_MAX_REPREQ)
  INTO
   VAR_TREE
  FROM DUAL;

  IF
   ( ( TRUNC(TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') ) ) <= ( TRUNC(SYSDATE) ) )
  THEN
   INSERT INTO TBL_DDDR_REP_PROFILE_DETAIL (
    REF_REPORT
   ,REF_DEPOSIT_TYPE
   ,X1
   ,X2
   ,X3
   ,X4
   ,X5
   ,X6
   ,X7
   ,REF_REPREQ
   ) SELECT
    INPAR_REPORT
   ,/*+ PARALLEL(auto) */
    REF_DEPOSIT_TYPE "id"
   ,NVL(
     SUM(
      CASE
       WHEN RATE < 15 THEN(BALANCE)
      END
     )
    ,0
    ) AS "1"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 15 AND 15.99 THEN(BALANCE)
      END
     )
    ,0
    ) "2"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 16 AND 16.99 THEN(BALANCE)
      END
     )
    ,0
    ) "3"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 17 AND 17.99 THEN(BALANCE)
      END
     )
    ,0
    ) "4"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 18 AND 18.99 THEN(BALANCE)
      END
     )
    ,0
    ) "5"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 19 AND 19.99 THEN(BALANCE)
      END
     )
    ,0
    ) "6"
   ,NVL(
     SUM(
      CASE
       WHEN RATE >= 20 THEN(BALANCE)
      END
     )
    ,0
    ) "7"
   ,VAR_MAX_REPREQ
   FROM AKIN.TBL_DEPOSIT
   WHERE TRUNC(DUE_DATE) BETWEEN TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') AND TO_DATE(INPAR_DATE_LAST,'yyyy-mm-dd')
   GROUP BY
    REF_DEPOSIT_TYPE
   UNION
   SELECT
    INPAR_REPORT
   ,/*+ PARALLEL(auto) */
    REF_DEPOSIT_TYPE "id"
   ,NVL(
     SUM(
      CASE
       WHEN RATE < 15 THEN(BALANCE)
      END
     )
    ,0
    ) AS "1"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 15 AND 15.99 THEN(BALANCE)
      END
     )
    ,0
    ) "2"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 16 AND 16.99 THEN(BALANCE)
      END
     )
    ,0
    ) "3"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 17 AND 17.99 THEN(BALANCE)
      END
     )
    ,0
    ) "4"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 18 AND 18.99 THEN(BALANCE)
      END
     )
    ,0
    ) "5"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 19 AND 19.99 THEN(BALANCE)
      END
     )
    ,0
    ) "6"
   ,NVL(
     SUM(
      CASE
       WHEN RATE >= 20 THEN(BALANCE)
      END
     )
    ,0
    ) "7"
   ,VAR_MAX_REPREQ
   FROM AKIN.TBL_DEPOSIT
   WHERE ( DUE_DATE ) IS NULL
   GROUP BY
    REF_DEPOSIT_TYPE;

   COMMIT;
   INSERT INTO TBL_DDDR_REP_PROFILE_DETAIL (
   REF_REPORT
   ,REF_DEPOSIT_TYPE
   ,X1
   ,X2
   ,X3
   ,X4
   ,X5
   ,X6
   ,X7
   ,REF_REPREQ
   ) SELECT
    INPAR_REPORT
   ,max( "id")
   ,SUM("1") as "1"
   ,SUM("2")  as "2"
   ,SUM("3")  as "3"
   ,SUM("4")  as "4"
   ,SUM("5")  as "5"
   ,SUM("6")  as "6"
   ,SUM("7")  as "7"
   ,VAR_MAX_REPREQ
   FROM (
     SELECT
      /*+ PARALLEL(auto) */
      -1 "id"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE < 15 THEN(BALANCE)
        END
       )
      ,0
      ) AS "1"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 15 AND 15.99 THEN(BALANCE)
        END
       )
      ,0
      ) "2"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 16 AND 16.99 THEN(BALANCE)
        END
       )
      ,0
      ) "3"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 17 AND 17.99 THEN(BALANCE)
        END
       )
      ,0
      ) "4"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 18 AND 18.99 THEN(BALANCE)
        END
       )
      ,0
      ) "5"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 19 AND 19.99 THEN(BALANCE)
        END
       )
      ,0
      ) "6"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE >= 20 THEN(BALANCE)
        END
       )
      ,0
      ) "7"
     
     FROM AKIN.TBL_DEPOSIT
     WHERE TRUNC(DUE_DATE) BETWEEN TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') AND TO_DATE(INPAR_DATE_LAST,'yyyy-mm-dd')
     UNION
     SELECT
     /*+ PARALLEL(auto) */
      -1 "ID"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE < 15 THEN(BALANCE)
        END
       )
      ,0
      ) AS "1"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 15 AND 15.99 THEN(BALANCE)
        END
       )
      ,0
      ) "2"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 16 AND 16.99 THEN(BALANCE)
        END
       )
      ,0
      ) "3"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 17 AND 17.99 THEN(BALANCE)
        END
       )
      ,0
      ) "4"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 18 AND 18.99 THEN(BALANCE)
        END
       )
      ,0
      ) "5"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE BETWEEN 19 AND 19.99 THEN(BALANCE)
        END
       )
      ,0
      ) "6"
     ,NVL(
       COUNT(
        CASE
         WHEN RATE >= 20 THEN(BALANCE)
        END
       )
      ,0
      ) "7"
     
     FROM AKIN.TBL_DEPOSIT
     WHERE ( DUE_DATE ) IS NULL
    )
   GROUP BY
    INPAR_REPORT;

   COMMIT;
  ELSE
   INSERT INTO TBL_DDDR_REP_PROFILE_DETAIL (
    REF_REPORT
   ,REF_DEPOSIT_TYPE
   ,X1
   ,X2
   ,X3
   ,X4
   ,X5
   ,X6
   ,X7
   ,REF_REPREQ
   ) SELECT
    INPAR_REPORT
   ,/*+ PARALLEL(auto) */
    REF_DEPOSIT_TYPE "id"
   ,NVL(
     SUM(
      CASE
       WHEN RATE < 15 THEN(BALANCE)
      END
     )
    ,0
    ) AS "1"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 15 AND 15.99 THEN(BALANCE)
      END
     )
    ,0
    ) "2"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 16 AND 16.99 THEN(BALANCE)
      END
     )
    ,0
    ) "3"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 17 AND 17.99 THEN(BALANCE)
      END
     )
    ,0
    ) "4"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 18 AND 18.99 THEN(BALANCE)
      END
     )
    ,0
    ) "5"
   ,NVL(
     SUM(
      CASE
       WHEN RATE BETWEEN 19 AND 19.99 THEN(BALANCE)
      END
     )
    ,0
    ) "6"
   ,NVL(
     SUM(
      CASE
       WHEN RATE >= 20 THEN(BALANCE)
      END
     )
    ,0
    ) "7"
   ,VAR_MAX_REPREQ
   FROM AKIN.TBL_DEPOSIT
   WHERE TRUNC(DUE_DATE) BETWEEN TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') AND TO_DATE(INPAR_DATE_LAST,'yyyy-mm-dd')
   GROUP BY
    REF_DEPOSIT_TYPE;

   COMMIT;
   INSERT INTO TBL_DDDR_REP_PROFILE_DETAIL (
    REF_REPORT
   ,REF_DEPOSIT_TYPE
   ,X1
   ,X2
   ,X3
   ,X4
   ,X5
   ,X6
   ,X7
   ,REF_REPREQ
   ) SELECT
    INPAR_REPORT
   ,/*+ PARALLEL(auto) */
    -1 "id"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE < 15 THEN(BALANCE)
      END
     )
    ,0
    ) AS "1"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE BETWEEN 15 AND 15.99 THEN(BALANCE)
      END
     )
    ,0
    ) "2"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE BETWEEN 16 AND 16.99 THEN(BALANCE)
      END
     )
    ,0
    ) "3"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE BETWEEN 17 AND 17.99 THEN(BALANCE)
      END
     )
    ,0
    ) "4"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE BETWEEN 18 AND 18.99 THEN(BALANCE)
      END
     )
    ,0
    ) "5"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE BETWEEN 19 AND 19.99 THEN(BALANCE)
      END
     )
    ,0
    ) "6"
   ,NVL(
     COUNT(
      CASE
       WHEN RATE >= 20 THEN(BALANCE)
      END
     )
    ,0
    ) "7"
   ,VAR_MAX_REPREQ
   FROM AKIN.TBL_DEPOSIT
   WHERE TRUNC(DUE_DATE) BETWEEN TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') AND TO_DATE(INPAR_DATE_LAST,'yyyy-mm-dd');

   COMMIT;
  END IF;

 END PRC_DDDR_GET_DETAIL;
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_DUE_DATE_DEPOSIT_RATE;
--------------------------------------------------------
--  DDL for Table PKG_DUE_DATE_LOAN_TYPE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_DUE_DATE_LOAN_TYPE" AS


/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_DDLT_TREE_BUILDER (
  INPAR_REPORT   IN NUMBER
 ,INPAR_REPREQ   IN NUMBER
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DDLT_GET_DETAIL ( INPAR_REPORT IN VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DDLT_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DDLT_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_FIRST_DATE         IN VARCHAR2
 ,INPAR_LAST_DATE          IN VARCHAR2
 ,INPAR_TREE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_LOAN_TYPE RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_GET_TREE_DETAIL ( INPAR_REPREQ IN NUMBER ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_GET_DETAIL_CHILD ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_GET_COUNT ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_GET_REPORT_DETAIL ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_GET_REPORT_DETAIL_COL ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_DUE_DATE_LOAN_TYPE;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_DUE_DATE_LOAN_TYPE" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_DDLT_DELETE_REPORT(
    INPAR_ID IN VARCHAR2 ,
    OUTPAR OUT VARCHAR2)
AS
BEGIN
  DELETE FROM TBL_REPORT WHERE ID = INPAR_ID;
  COMMIT;
  DELETE FROM TBL_DDLT_REP_PROFILE_DETAIL WHERE REF_REPORT = INPAR_ID;
  COMMIT;
END PRC_DDLT_DELETE_REPORT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE PRC_DDLT_REP_PROFILE_REPORT(
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_REF_USER         IN VARCHAR2 ,
    INPAR_STATUS           IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    inpar_first_date  in varchar2,
    inpar_last_date in varchar2,
    inpar_tree in varchar2,
    OUTPAR_ID OUT VARCHAR2 )
AS
var_tree varchar2(100);
max_repreq number;
BEGIN


  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_REPORT
      (
        NAME ,
        DES ,
        CREATE_DATE ,
        REF_USER ,
        STATUS ,
        CATEGORY ,
        FIRST_DATE,
        LAST_DATE,
        TYPE,
        REF_LEDGER_PROFIEL
      )
      VALUES
      (
        INPAR_NAME ,
        INPAR_DES ,
        SYSDATE ,
        INPAR_REF_USER ,
        INPAR_STATUS ,
        'DDLT' ,
        inpar_first_date,
        inpar_last_date,
        INPAR_TYPE,
        inpar_tree
      );
    COMMIT;
    SELECT ID
    INTO OUTPAR_ID
    FROM TBL_REPORT
    WHERE CREATE_DATE =
      ( SELECT MAX(CREATE_DATE) FROM TBL_REPORT
      )
    AND ID =
      ( SELECT MAX(ID) FROM TBL_REPORT
      );
  ELSE
    UPDATE TBL_REPORT
    SET NAME   = INPAR_NAME ,
      DES      = INPAR_DES ,
      REF_USER = INPAR_REF_USER ,
      STATUS   = INPAR_STATUS ,
      TYPE     = INPAR_TYPE,
      first_date = inpar_first_date,
      last_date = inpar_last_date,
      REF_LEDGER_PROFIEL=inpar_tree
    WHERE ID   = INPAR_ID;
    COMMIT;
  END IF;
  
  update TBL_REPORT
  set H_ID = id
  where upper(type) = 'DDLT' and H_ID is null;
  commit;

  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    select max(REF_REPREQ) into max_repreq from TBL_DDLT_TREE where REF_REPORT = OUTPAR_ID;
    if (max_repreq is null) then max_repreq := -1; end if;
  select pkg_due_date_LOAN_type.FNC_DDLT_TREE_BUILDER(OUTPAR_ID,max_repreq) into var_tree from dual;
  ELSE
      select max(REF_REPREQ) into max_repreq from TBL_DDLT_TREE where REF_REPORT = INPAR_ID;
    if (max_repreq is null) then max_repreq := -1;end if;
    select pkg_due_date_LOAN_type.FNC_DDLT_TREE_BUILDER(INPAR_ID,max_repreq) into var_tree from dual;
  END IF;

commit;
  end PRC_DDLT_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_DDLT_TREE_BUILDER ( inpar_report in number, inpar_repreq in number) RETURN VARCHAR2 AS
  var_parent_id number:=1;
  INPAR_TREE varchar2(30000);
  pragma autonomous_transaction;
  BEGIN
  
  select REF_LEDGER_PROFIEL  into INPAR_TREE from TBL_REPORT where ID = inpar_report;
  
  delete from TBL_DDLT_TREE where REF_REPORT = inpar_report and REF_REPREQ = inpar_repreq;
  commit;
     for i in(select regexp_substr( INPAR_TREE,'[^;]+', 1, level) as s from dual
     connect by regexp_substr(INPAR_TREE, '[^;]+', 1, level) is not null) loop
     INSERT INTO TBL_DDLT_TREE (
 PARENT_ID
 ,PARENT_NAME
 ,CHILD_ID
 ,CHILD_NAME
 ,DEPTH
 ,REF_REPREQ
 ,REF_REPORT
) 
       select null,null,var_parent_id,substr(i.s, -length(i.s), INSTR(i.s ,'#' )-1)as name,1,inpar_repreq,inpar_report  from dual;
       commit;
          INSERT INTO TBL_DDLT_TREE (
 PARENT_ID
 ,PARENT_NAME
 ,CHILD_ID
 ,CHILD_NAME
 ,DEPTH
 ,REF_REPREQ
 ,REF_REPORT
) 
   select var_parent_id,null,regexp_substr(substr(i.s,   INSTR(i.s ,'#' )+1 ) ,'[^,]+', 1, level) as s,null,2,inpar_repreq,inpar_report from dual
     connect by regexp_substr(substr(i.s,   INSTR(i.s ,'#' )+1 ) , '[^,]+', 1, level) is not null;
     var_parent_id:=var_parent_id+1;
     
     end loop;
     commit;
     UPDATE TBL_DDLT_TREE
 SET
 CHILD_NAME = (select name from TBL_LOAN_TYPE where TBL_DDLT_TREE.CHILD_ID = REF_LOAN_TYPE)
WHERE  
CHILD_NAME is null
  and DEPTH = 2;
   commit;
    RETURN NULL;
  END FNC_DDLT_TREE_BUILDER;
  --<><><><><><><><><><><><><><><><><><><><><><><>--
  --<><><><><><><><><><><><><><><><><><><><><><><>--
  --<><><><><><><><><><><><><><><><><><><><><><><>--
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_DDLT_LOAN_type  RETURN VARCHAR2 AS
  

  BEGIN
   
    RETURN 'select  ref_LOAN_type as "id" , name as "name" from tbl_LOAN_type';
  END FNC_DDLT_LOAN_type;


  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 

function fnc_DDLT_get_tree_detail(inpar_repreq in number) return varchar2
as 

begin
return ' SELECT  "id","name","parent","level"
FROM (SELECT
 CHILD_ID AS "id"
 ,CHILD_NAME AS "name"
 ,PARENT_ID AS "parent"
 ,PARENT_NAME AS "parentName"
 ,DEPTH AS "level"
FROM TBL_DDLT_TREE
WHERE REF_REPORT   = '||inpar_repreq||'
 AND
  REF_REPREQ   = (
   SELECT
    MAX(REF_REPREQ)
   FROM TBL_DDLT_TREE
   WHERE REF_REPORT   = '||inpar_repreq||'
  ))
START WITH "parent" is null
CONNECT BY prior "id" ="parent"';

end fnc_DDLT_get_tree_detail;


  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_DDLT_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
  ,to_char(to_date(first_date,''yyyy-mm-dd''),''yyyy/mm/dd'',''nls_calendar=persian'') as "startDate"
  ,to_char(to_date(last_date,''yyyy-mm-dd''),''yyyy/mm/dd'',''nls_calendar=persian'') as "endDate"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''DDLT'' order by id';
  RETURN VAR2;
 END FNC_DDLT_GET_REPORT_INFO;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_DDLT_GET_detail_child ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'select   X1 as "x1"
  ,REF_LOAN_TYPE as "id" from TBL_DDLT_REP_PROFILE_DETAIL where REF_REPREQ =  '|| INPAR_ID || '  order by REF_LOAN_TYPE';
  RETURN VAR2;
 END FNC_DDLT_GET_detail_child;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_DDLT_GET_count ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'select   X1 as "x1"

 ,REF_LOAN_TYPE as "id" from TBL_DDLT_REP_PROFILE_DETAIL where REF_REPREQ = '|| INPAR_ID || '  and REF_LOAN_TYPE =-1  order by REF_LOAN_TYPE';
  RETURN VAR2;
 END FNC_DDLT_GET_count;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_DDlt_GET_DETAIL ( INPAR_REPORT IN VARCHAR2 ) AS

  INPAR_DATE_FIRST   VARCHAR2(200);
 INPAR_DATE_LAST    VARCHAR2(200);
 VAR_MAX_REPREQ     NUMBER;
 var_tree varchar2(100);
BEGIN
 SELECT
  FIRST_DATE
 INTO
  INPAR_DATE_FIRST
 FROM TBL_REPORT
 WHERE ID   = INPAR_REPORT;

 SELECT
  last_DATE
 INTO
  INPAR_DATE_LAST
 FROM TBL_REPORT
 WHERE ID   = INPAR_REPORT;

 SELECT
  MAX(ID)
 INTO
  VAR_MAX_REPREQ
 FROM TBL_REPREQ;
select pkg_due_date_loan_type.FNC_DDlt_TREE_BUILDER(INPAR_REPORT,VAR_MAX_REPREQ) into var_tree from dual;
 
  
  INSERT INTO TBL_DDlt_REP_PROFILE_DETAIL (
   REF_REPORT
  ,REF_loan_TYPE
  ,X1
  ,REF_REPREQ
  ) SELECT INPAR_REPORT,
 TL.REF_LOAN_TYPE
 ,SUM(TLP.PROFIT_AMOUNT + TLP.AMOUNT),VAR_MAX_REPREQ
FROM AKIN.TBL_LOAN TL
 ,    AKIN.TBL_LOAN_PAYMENT TLP
WHERE TL.LON_ID   = TLP.REF_LON_ID
 AND
 TRUNC( TLP.DUE_DATE ) BETWEEN TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') AND TO_DATE(INPAR_DATE_LAST,'yyyy-mm-dd')
GROUP BY
 TL.REF_LOAN_TYPE;
 
 commit;
   INSERT INTO TBL_DDlt_REP_PROFILE_DETAIL (
   REF_REPORT
  ,REF_loan_TYPE
  ,X1
  ,REF_REPREQ
  ) SELECT INPAR_REPORT,
 -1
 ,count(distinct TL.LON_ID )
 ,VAR_MAX_REPREQ
FROM AKIN.TBL_LOAN TL
 ,    AKIN.TBL_LOAN_PAYMENT TLP
WHERE TL.LON_ID   = TLP.REF_LON_ID
 AND
 TRUNC( TLP.DUE_DATE ) BETWEEN TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') AND TO_DATE(INPAR_DATE_LAST,'yyyy-mm-dd')
GROUP BY
 TL.REF_LOAN_TYPE;
  commit;

 
 END PRC_ddlt_GET_DETAIL;
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_DDLT_GET_report_detail ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
  start_date VARCHAR2(3000);
  end_date VARCHAR2(3000);
 BEGIN
 select TO_DATE(FIRST_DATE,'yyyy-mm-dd')  into start_date from TBL_REPORT where ID = (select ref_report_id from TBL_REPREQ where id = INPAR_ID );
select  TO_DATE(LAST_DATE,'yyyy-mm-dd') into end_date from TBL_REPORT where ID = (select ref_report_id from TBL_REPREQ where id = INPAR_ID );
    
 
  VAR2 := '
  SELECT
 TL.LON_ID "x1",
(select name from tbl_loan_type where ref_loan_type =  TL.REF_LOAN_TYPE) as "x2",
(TLP.AMOUNT + TLP.PROFIT_AMOUNT) "x3",
TB.BRN_ID "x4",
TB.NAME "x5",
TB.REGION_ID "x6",
TB.REGION_NAME "x7",
REF_LOAN_TYPE "x8",
TLP.DUE_DATE "x9"
FROM AKIN.TBL_LOAN TL
 ,    AKIN.TBL_LOAN_PAYMENT TLP
 , TBL_BRANCH tb
 WHERE TL.LON_ID   = TLP.REF_LON_ID
 AND
 TB.BRN_ID = TL.REF_BRANCH
 and  TLP.DUE_DATE  between
 to_date('''||start_date||''' ) and   to_date('''||end_date||''')
 and TL.REF_LOAN_TYPE in (select CHILD_ID from tbl_ddlt_tree where REF_REPREQ = '||INPAR_ID||' and DEPTH = 2)
  ';

  RETURN VAR2;
 END FNC_DDLT_GET_report_detail;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_DDLT_GET_report_detail_col ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
   
 BEGIN
  

  RETURN ' SELECT
      REGEXP_SUBSTR(
       ''id#type#balance#branch#branchName#regionId#regionName#loanType#dueDate''
      ,''[^#]+''
      ,1
      ,LEVEL
      ) AS "header" ,''x''||rownum as "value"
     FROM DUAL
     CONNECT BY
      REGEXP_SUBSTR(
        ''id#type#balance#branch#branchName#regionId#regionName#loanType#dueDate''
      ,''[^#]+''
      ,1
      ,LEVEL
      ) IS NOT NULL';
 END FNC_DDLT_GET_report_detail_col;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_DUE_DATE_LOAN_TYPE;
--------------------------------------------------------
--  DDL for Table PKG_DUE_DATE_LOAN_TYPE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_DUE_DATE_LOAN_TYPE" AS


/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 FUNCTION FNC_DDLT_TREE_BUILDER (
  INPAR_REPORT   IN NUMBER
 ,INPAR_REPREQ   IN NUMBER
 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DDLT_GET_DETAIL ( INPAR_REPORT IN VARCHAR2 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DDLT_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_DDLT_REP_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_FIRST_DATE         IN VARCHAR2
 ,INPAR_LAST_DATE          IN VARCHAR2
 ,INPAR_TREE               IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_LOAN_TYPE RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_GET_TREE_DETAIL ( INPAR_REPREQ IN NUMBER ) RETURN VARCHAR2;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_GET_DETAIL_CHILD ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_GET_COUNT ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_GET_REPORT_DETAIL ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_DDLT_GET_REPORT_DETAIL_COL ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_DUE_DATE_LOAN_TYPE;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_DUE_DATE_LOAN_TYPE" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_DDLT_DELETE_REPORT(
    INPAR_ID IN VARCHAR2 ,
    OUTPAR OUT VARCHAR2)
AS
BEGIN
  DELETE FROM TBL_REPORT WHERE ID = INPAR_ID;
  COMMIT;
  DELETE FROM TBL_DDLT_REP_PROFILE_DETAIL WHERE REF_REPORT = INPAR_ID;
  COMMIT;
END PRC_DDLT_DELETE_REPORT;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
PROCEDURE PRC_DDLT_REP_PROFILE_REPORT(
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_REF_USER         IN VARCHAR2 ,
    INPAR_STATUS           IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    INPAR_ID               IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    inpar_first_date  in varchar2,
    inpar_last_date in varchar2,
    inpar_tree in varchar2,
    OUTPAR_ID OUT VARCHAR2 )
AS
var_tree varchar2(100);
max_repreq number;
BEGIN


  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    INSERT
    INTO TBL_REPORT
      (
        NAME ,
        DES ,
        CREATE_DATE ,
        REF_USER ,
        STATUS ,
        CATEGORY ,
        FIRST_DATE,
        LAST_DATE,
        TYPE,
        REF_LEDGER_PROFIEL
      )
      VALUES
      (
        INPAR_NAME ,
        INPAR_DES ,
        SYSDATE ,
        INPAR_REF_USER ,
        INPAR_STATUS ,
        'DDLT' ,
        inpar_first_date,
        inpar_last_date,
        INPAR_TYPE,
        inpar_tree
      );
    COMMIT;
    SELECT ID
    INTO OUTPAR_ID
    FROM TBL_REPORT
    WHERE CREATE_DATE =
      ( SELECT MAX(CREATE_DATE) FROM TBL_REPORT
      )
    AND ID =
      ( SELECT MAX(ID) FROM TBL_REPORT
      );
  ELSE
    UPDATE TBL_REPORT
    SET NAME   = INPAR_NAME ,
      DES      = INPAR_DES ,
      REF_USER = INPAR_REF_USER ,
      STATUS   = INPAR_STATUS ,
      TYPE     = INPAR_TYPE,
      first_date = inpar_first_date,
      last_date = inpar_last_date,
      REF_LEDGER_PROFIEL=inpar_tree
    WHERE ID   = INPAR_ID;
    COMMIT;
  END IF;
  
  update TBL_REPORT
  set H_ID = id
  where upper(type) = 'DDLT' and H_ID is null;
  commit;

  IF ( INPAR_INSERT_OR_UPDATE = 0 ) THEN
    select max(REF_REPREQ) into max_repreq from TBL_DDLT_TREE where REF_REPORT = OUTPAR_ID;
    if (max_repreq is null) then max_repreq := -1; end if;
  select pkg_due_date_LOAN_type.FNC_DDLT_TREE_BUILDER(OUTPAR_ID,max_repreq) into var_tree from dual;
  ELSE
      select max(REF_REPREQ) into max_repreq from TBL_DDLT_TREE where REF_REPORT = INPAR_ID;
    if (max_repreq is null) then max_repreq := -1;end if;
    select pkg_due_date_LOAN_type.FNC_DDLT_TREE_BUILDER(INPAR_ID,max_repreq) into var_tree from dual;
  END IF;

commit;
  end PRC_DDLT_REP_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
  FUNCTION FNC_DDLT_TREE_BUILDER ( inpar_report in number, inpar_repreq in number) RETURN VARCHAR2 AS
  var_parent_id number:=1;
  INPAR_TREE varchar2(30000);
  pragma autonomous_transaction;
  BEGIN
  
  select REF_LEDGER_PROFIEL  into INPAR_TREE from TBL_REPORT where ID = inpar_report;
  
  delete from TBL_DDLT_TREE where REF_REPORT = inpar_report and REF_REPREQ = inpar_repreq;
  commit;
     for i in(select regexp_substr( INPAR_TREE,'[^;]+', 1, level) as s from dual
     connect by regexp_substr(INPAR_TREE, '[^;]+', 1, level) is not null) loop
     INSERT INTO TBL_DDLT_TREE (
 PARENT_ID
 ,PARENT_NAME
 ,CHILD_ID
 ,CHILD_NAME
 ,DEPTH
 ,REF_REPREQ
 ,REF_REPORT
) 
       select null,null,var_parent_id,substr(i.s, -length(i.s), INSTR(i.s ,'#' )-1)as name,1,inpar_repreq,inpar_report  from dual;
       commit;
          INSERT INTO TBL_DDLT_TREE (
 PARENT_ID
 ,PARENT_NAME
 ,CHILD_ID
 ,CHILD_NAME
 ,DEPTH
 ,REF_REPREQ
 ,REF_REPORT
) 
   select var_parent_id,null,regexp_substr(substr(i.s,   INSTR(i.s ,'#' )+1 ) ,'[^,]+', 1, level) as s,null,2,inpar_repreq,inpar_report from dual
     connect by regexp_substr(substr(i.s,   INSTR(i.s ,'#' )+1 ) , '[^,]+', 1, level) is not null;
     var_parent_id:=var_parent_id+1;
     
     end loop;
     commit;
     UPDATE TBL_DDLT_TREE
 SET
 CHILD_NAME = (select name from TBL_LOAN_TYPE where TBL_DDLT_TREE.CHILD_ID = REF_LOAN_TYPE)
WHERE  
CHILD_NAME is null
  and DEPTH = 2;
   commit;
    RETURN NULL;
  END FNC_DDLT_TREE_BUILDER;
  --<><><><><><><><><><><><><><><><><><><><><><><>--
  --<><><><><><><><><><><><><><><><><><><><><><><>--
  --<><><><><><><><><><><><><><><><><><><><><><><>--
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_DDLT_LOAN_type  RETURN VARCHAR2 AS
  

  BEGIN
   
    RETURN 'select  ref_LOAN_type as "id" , name as "name" from tbl_LOAN_type';
  END FNC_DDLT_LOAN_type;


  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 

function fnc_DDLT_get_tree_detail(inpar_repreq in number) return varchar2
as 

begin
return ' SELECT  "id","name","parent","level"
FROM (SELECT
 CHILD_ID AS "id"
 ,CHILD_NAME AS "name"
 ,PARENT_ID AS "parent"
 ,PARENT_NAME AS "parentName"
 ,DEPTH AS "level"
FROM TBL_DDLT_TREE
WHERE REF_REPORT   = '||inpar_repreq||'
 AND
  REF_REPREQ   = (
   SELECT
    MAX(REF_REPREQ)
   FROM TBL_DDLT_TREE
   WHERE REF_REPORT   = '||inpar_repreq||'
  ))
START WITH "parent" is null
CONNECT BY prior "id" ="parent"';

end fnc_DDLT_get_tree_detail;


  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_DDLT_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category"
  ,to_char(to_date(first_date,''yyyy-mm-dd''),''yyyy/mm/dd'',''nls_calendar=persian'') as "startDate"
  ,to_char(to_date(last_date,''yyyy-mm-dd''),''yyyy/mm/dd'',''nls_calendar=persian'') as "endDate"
FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''DDLT'' order by id';
  RETURN VAR2;
 END FNC_DDLT_GET_REPORT_INFO;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_DDLT_GET_detail_child ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'select   X1 as "x1"
  ,REF_LOAN_TYPE as "id" from TBL_DDLT_REP_PROFILE_DETAIL where REF_REPREQ =  '|| INPAR_ID || '  order by REF_LOAN_TYPE';
  RETURN VAR2;
 END FNC_DDLT_GET_detail_child;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_DDLT_GET_count ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'select   X1 as "x1"

 ,REF_LOAN_TYPE as "id" from TBL_DDLT_REP_PROFILE_DETAIL where REF_REPREQ = '|| INPAR_ID || '  and REF_LOAN_TYPE =-1  order by REF_LOAN_TYPE';
  RETURN VAR2;
 END FNC_DDLT_GET_count;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_DDlt_GET_DETAIL ( INPAR_REPORT IN VARCHAR2 ) AS

  INPAR_DATE_FIRST   VARCHAR2(200);
 INPAR_DATE_LAST    VARCHAR2(200);
 VAR_MAX_REPREQ     NUMBER;
 var_tree varchar2(100);
BEGIN
 SELECT
  FIRST_DATE
 INTO
  INPAR_DATE_FIRST
 FROM TBL_REPORT
 WHERE ID   = INPAR_REPORT;

 SELECT
  last_DATE
 INTO
  INPAR_DATE_LAST
 FROM TBL_REPORT
 WHERE ID   = INPAR_REPORT;

 SELECT
  MAX(ID)
 INTO
  VAR_MAX_REPREQ
 FROM TBL_REPREQ;
select pkg_due_date_loan_type.FNC_DDlt_TREE_BUILDER(INPAR_REPORT,VAR_MAX_REPREQ) into var_tree from dual;
 
  
  INSERT INTO TBL_DDlt_REP_PROFILE_DETAIL (
   REF_REPORT
  ,REF_loan_TYPE
  ,X1
  ,REF_REPREQ
  ) SELECT INPAR_REPORT,
 TL.REF_LOAN_TYPE
 ,SUM(TLP.PROFIT_AMOUNT + TLP.AMOUNT),VAR_MAX_REPREQ
FROM AKIN.TBL_LOAN TL
 ,    AKIN.TBL_LOAN_PAYMENT TLP
WHERE TL.LON_ID   = TLP.REF_LON_ID
 AND
 TRUNC( TLP.DUE_DATE ) BETWEEN TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') AND TO_DATE(INPAR_DATE_LAST,'yyyy-mm-dd')
GROUP BY
 TL.REF_LOAN_TYPE;
 
 commit;
   INSERT INTO TBL_DDlt_REP_PROFILE_DETAIL (
   REF_REPORT
  ,REF_loan_TYPE
  ,X1
  ,REF_REPREQ
  ) SELECT INPAR_REPORT,
 -1
 ,count(distinct TL.LON_ID )
 ,VAR_MAX_REPREQ
FROM AKIN.TBL_LOAN TL
 ,    AKIN.TBL_LOAN_PAYMENT TLP
WHERE TL.LON_ID   = TLP.REF_LON_ID
 AND
 TRUNC( TLP.DUE_DATE ) BETWEEN TO_DATE(INPAR_DATE_FIRST,'yyyy-mm-dd') AND TO_DATE(INPAR_DATE_LAST,'yyyy-mm-dd')
GROUP BY
 TL.REF_LOAN_TYPE;
  commit;

 
 END PRC_ddlt_GET_DETAIL;
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_DDLT_GET_report_detail ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
  start_date VARCHAR2(3000);
  end_date VARCHAR2(3000);
 BEGIN
 select TO_DATE(FIRST_DATE,'yyyy-mm-dd')  into start_date from TBL_REPORT where ID = (select ref_report_id from TBL_REPREQ where id = INPAR_ID );
select  TO_DATE(LAST_DATE,'yyyy-mm-dd') into end_date from TBL_REPORT where ID = (select ref_report_id from TBL_REPREQ where id = INPAR_ID );
    
 
  VAR2 := '
  SELECT
 TL.LON_ID "x1",
(select name from tbl_loan_type where ref_loan_type =  TL.REF_LOAN_TYPE) as "x2",
(TLP.AMOUNT + TLP.PROFIT_AMOUNT) "x3",
TB.BRN_ID "x4",
TB.NAME "x5",
TB.REGION_ID "x6",
TB.REGION_NAME "x7",
REF_LOAN_TYPE "x8",
TLP.DUE_DATE "x9"
FROM AKIN.TBL_LOAN TL
 ,    AKIN.TBL_LOAN_PAYMENT TLP
 , TBL_BRANCH tb
 WHERE TL.LON_ID   = TLP.REF_LON_ID
 AND
 TB.BRN_ID = TL.REF_BRANCH
 and  TLP.DUE_DATE  between
 to_date('''||start_date||''' ) and   to_date('''||end_date||''')
 and TL.REF_LOAN_TYPE in (select CHILD_ID from tbl_ddlt_tree where REF_REPREQ = '||INPAR_ID||' and DEPTH = 2)
  ';

  RETURN VAR2;
 END FNC_DDLT_GET_report_detail;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

FUNCTION FNC_DDLT_GET_report_detail_col ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
   
 BEGIN
  

  RETURN ' SELECT
      REGEXP_SUBSTR(
       ''id#type#balance#branch#branchName#regionId#regionName#loanType#dueDate''
      ,''[^#]+''
      ,1
      ,LEVEL
      ) AS "header" ,''x''||rownum as "value"
     FROM DUAL
     CONNECT BY
      REGEXP_SUBSTR(
        ''id#type#balance#branch#branchName#regionId#regionName#loanType#dueDate''
      ,''[^#]+''
      ,1
      ,LEVEL
      ) IS NOT NULL';
 END FNC_DDLT_GET_report_detail_col;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PKG_DUE_DATE_LOAN_TYPE;
--------------------------------------------------------
--  DDL for Table PKG_GAP_NIIM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_GAP_NIIM" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_GAP_NIIM_PROFILE_REPORT (
  INPAR_NAME                  IN VARCHAR2
 ,INPAR_DES                   IN VARCHAR2
 ,INPAR_REF_USER              IN VARCHAR2
 ,INPAR_STATUS                IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE      IN VARCHAR2
 ,INPAR_ID                    IN VARCHAR2
 ,INPAR_TYPE                  IN VARCHAR2
 ,INPAR_TIMING_PROFILE        IN VARCHAR2
 ,INPAR_DEP_PROFILE           IN VARCHAR2
 ,INPAR_LON_PROFILE           IN VARCHAR2
 ,INPAR_CUS_PROFILE           IN VARCHAR2
 ,INPAR_CUR_PROFILE           IN VARCHAR2
 ,INPAR_BRN_PROFILE           IN VARCHAR2
 ,INPAR_TIMING_PROFILE_TYPE   IN VARCHAR2
 ,inpar_tahlil_hasasiat     in varchar2 
 ,OUTPAR_ID                   OUT VARCHAR2
 );

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_GAP_NIIM_REPORT_VALUE ( INPAR_ID_REPORT IN VARCHAR2 );

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_GAP_NIIM_taAhodi_VALUE ;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_GAP_NIIM_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_GAP_NIIM_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_GAP_NIIM_GET_REPORT_sens ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_GAP_NIIM_GET_REPORT_QUERY ( INPAR_ID NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_GAP_NIIM_GET_DETAIL_TIMING ( INPAR_ID NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_GAP_NIIM;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_GAP_NIIM" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_GAP_NIIM_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_TIMING_PROFILE     IN VARCHAR2
 ,INPAR_DEP_PROFILE        IN VARCHAR2
 ,INPAR_LON_PROFILE        IN VARCHAR2
 ,INPAR_CUS_PROFILE        IN VARCHAR2
 ,INPAR_CUR_PROFILE        IN VARCHAR2
 ,INPAR_BRN_PROFILE        IN VARCHAR2,
 inpar_timing_profile_type in varchar2,
 inpar_tahlil_hasasiat     in varchar2   --ke dar sotoone REF_LEDGER_PROFIEL dar jadvale report rikhte mishavad
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,TYPE
   ,REF_TIMING_PROFILE
   ,REF_LON_PROFILE
   ,REF_DEP_PROFILE
   ,REF_CUS_PROFILE
   ,REF_CUR_PROFILE
   ,REF_BRN_PROFILE
   ,TIMING_PROFILE_TYPE
   ,REF_LEDGER_PROFIEL
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'GAP_NIIM'
   ,INPAR_TYPE
   ,INPAR_TIMING_PROFILE
   ,INPAR_LON_PROFILE
   ,INPAR_DEP_PROFILE
   ,INPAR_CUS_PROFILE
   ,INPAR_CUR_PROFILE
   ,INPAR_BRN_PROFILE
   ,inpar_timing_profile_type,
   inpar_tahlil_hasasiat
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
    ,REF_TIMING_PROFILE = INPAR_TIMING_PROFILE
    ,REF_DEP_PROFILE = INPAR_DEP_PROFILE
    ,REF_LON_PROFILE = INPAR_LON_PROFILE
    ,REF_CUS_PROFILE = INPAR_CUS_PROFILE
    ,REF_CUR_PROFILE = INPAR_CUR_PROFILE
    ,REF_BRN_PROFILE = INPAR_BRN_PROFILE
    ,TIMING_PROFILE_TYPE = inpar_timing_profile_type
    ,REF_LEDGER_PROFIEL  = inpar_tahlil_hasasiat
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;

  UPDATE TBL_REPORT
   SET
    H_ID = ID
  WHERE TYPE   = 'GAP_NIIM'
   AND
    H_ID IS NULL;

  COMMIT;
 END PRC_GAP_NIIM_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_GAP_NIIM_REPORT_VALUE ( INPAR_ID_REPORT IN VARCHAR2 ) AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Morteza.Sahhi
  Editor Name:
  Release Date/Time:1396/02/24-10:00
  Edit Name:
  Version: 1.1
  Category:2
  Description:in procedure baraye enteghal dadehaye morde niaz az value be TBL_VALUE_TEMP bar asas profilehaye mokhtalefist ke karbar taeen karde
  */
  /*------------------------------------------------------------------------------*/

  VAR_QUERY     VARCHAR2(4000);
  ID_LOAN       NUMBER;
  ID_DEP        NUMBER;
  ID_CUR        NUMBER;
  ID_CUS        NUMBER;
  ID_BRANCH     NUMBER;
  ID_TIMING     NUMBER;
  DATE_TYPE1    DATE := SYSDATE;
  LOC_S         TIMESTAMP;
  LOC_F         TIMESTAMP;
  LOC_MEGHDAR   NUMBER;
  VAR_REPREQ    NUMBER;
 BEGIN
  EXECUTE IMMEDIATE 'alter session set nls_date_format=''DD-MM-RRRR''';
  SYS.DBMS_OUTPUT.ENABLE(3000000);
  EXECUTE IMMEDIATE 'truncate table TBL_VALUE_TEMP';
  /******profilhaye mokhtalefi ke karbar baraye in gozaresh entekhab karde ra daron moteghayer ham nam profil mirizim ******/
  SELECT
   MAX(ID)
  INTO
   VAR_REPREQ
  FROM TBL_REPREQ
  WHERE REF_REPORT_ID   = INPAR_ID_REPORT;

  SELECT
   MAX(ID)
  INTO
   ID_CUR
  FROM TBL_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_CUR_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );

  SELECT
   MAX(ID)
  INTO
   ID_CUS
  FROM TBL_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_CUS_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );

  SELECT
   MAX(ID)
  INTO
   ID_BRANCH
  FROM TBL_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_BRN_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );

  SELECT
   MAX(ID)
  INTO
   ID_DEP
  FROM TBL_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_DEP_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );

  SELECT
   MAX(ID)
  INTO
   ID_TIMING
  FROM TBL_TIMING_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_TIMING_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );

  SELECT
   MAX(ID)
  INTO
   ID_LOAN
  FROM TBL_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_LON_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );
  /******be ezaye tedad bazehayee ke dar profile zamani vojod darad halghe ro ejra mikonim*****--*/

  FOR I IN (
   SELECT
    TTPD.ID
   ,TTP.TYPE
   ,TTPD.PERIOD_NAME
   ,TTPD.PERIOD_DATE
   ,TTPD.PERIOD_START
   ,TTPD.PERIOD_END
   ,TTPD.PERIOD_COLOR
   FROM TBL_TIMING_PROFILE TTP
   ,    TBL_TIMING_PROFILE_DETAIL TTPD
   WHERE TTP.ID   = TTPD.REF_TIMING_PROFILE
    AND
     TTP.ID   = ID_TIMING
  ) LOOP
   IF
    ( I.TYPE = 1 )
   THEN
      /******agar profile zamani entekhab shode bazehee bashad *****--*/
    SELECT
     '  
INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE_TEMP  
(    
REF_MODALITY_TYPE,
REF_ID,
BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID ,
REF_TIMING_ID,
TIMING_NAME,
TIMING_color
) 
SELECT /*+   PARALLEL(auto)   */ REF_MODALITY_TYPE,
REF_ID,
case when REF_MODALITY_TYPE in (2,21) then  -1*BALANCE else BALANCE end as BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID,
''' ||
     I.ID ||
     ''',
''' ||
     I.PERIOD_NAME ||
     ''',
''' ||
     I.PERIOD_COLOR ||
     '''
FROM TBL_VALUE WHERE REF_ID IN (  
' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',ID_LOAN) ||
     ') AND REF_CUR_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR) ||
     ')' ||
     ' AND REF_CUS_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',ID_CUS) ||
     ')' ||
     ' AND REF_BRANCH IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH) ||
     ')  AND DUE_DATE > to_date(''' ||
     DATE_TYPE1 ||
     ''',''dd-mm-yyyy'''''') and DUE_DATE <= to_date(''' ||
     DATE_TYPE1 ||
     ''',''dd-mm-yyyy'''''')+' ||
     I.PERIOD_DATE ||
     '  ;'
    INTO
     VAR_QUERY
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;
    SELECT
     '  
INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE_TEMP  
(    
REF_MODALITY_TYPE,
REF_ID,
BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID ,
REF_TIMING_ID,
TIMING_NAME,
TIMING_color
) 
SELECT /*+   PARALLEL(auto)   */ REF_MODALITY_TYPE,
REF_ID,
case when REF_MODALITY_TYPE in (2,21) then  -1*BALANCE else BALANCE end as BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID,
''' ||
     I.ID ||
     ''',
''' ||
     I.PERIOD_NAME ||
     ''',
''' ||
     I.PERIOD_COLOR ||
     '''
FROM TBL_VALUE WHERE REF_ID IN (  
' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_DEPOSIT',ID_DEP) ||
     ') AND REF_CUR_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR) ||
     ')' ||
     ' AND REF_CUS_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',ID_CUS) ||
     ')' ||
     ' AND REF_BRANCH IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH) ||
     ')  AND DUE_DATE > to_date(''' ||
     DATE_TYPE1 ||
     ''',''dd-mm-yyyy'''''') and DUE_DATE <= to_date(''' ||
     DATE_TYPE1 ||
     ''',''dd-mm-yyyy'''''')+' ||
     I.PERIOD_DATE ||
     '  ;'
    INTO
     VAR_QUERY
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;
    DATE_TYPE1   := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
   ELSE
      /******agar profile zamani entekhab shode tarikhi bashad *****--*/
    SELECT
     '  
INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE_TEMP  
(    
REF_MODALITY_TYPE,
REF_ID,
BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID  ,
REF_TIMING_ID,
TIMING_NAME,
TIMING_color 
) 
SELECT /*+   PARALLEL(auto)   */ REF_MODALITY_TYPE,
REF_ID,
case when REF_MODALITY_TYPE in (2,21) then  -1*BALANCE else BALANCE end as BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID,
''' ||
     I.ID ||
     ''',
''' ||
     I.PERIOD_NAME ||
     ''',
''' ||
     I.PERIOD_COLOR ||
     '''
FROM TBL_VALUE WHERE REF_ID IN (  
' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_DEPOSIT',ID_DEP) ||
     ') AND REF_CUR_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR) ||
     ')' ||
     ' AND REF_CUS_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',ID_CUS) ||
     ')' ||
     ' AND REF_BRANCH IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH) ||
     ') AND DUE_DATE > to_date(''' ||
     I.PERIOD_START ||
     ''',''dd-mm-yyyy'') and DUE_DATE <= to_date(''' ||
     I.PERIOD_END ||
     ''',''dd-mm-yyyy'') ;'
    INTO
     VAR_QUERY
    FROM DUAL;

    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;
    SELECT
     '  
INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE_TEMP  
(    
REF_MODALITY_TYPE,
REF_ID,
BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID  ,
REF_TIMING_ID,
TIMING_NAME,
TIMING_color 
) 
SELECT /*+   PARALLEL(auto)   */ REF_MODALITY_TYPE,
REF_ID,
case when REF_MODALITY_TYPE in (2,21) then  -1*BALANCE else BALANCE end as BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID,
''' ||
     I.ID ||
     ''',
''' ||
     I.PERIOD_NAME ||
     ''',
''' ||
     I.PERIOD_COLOR ||
     '''
FROM TBL_VALUE WHERE REF_ID IN (  
' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',ID_LOAN) ||
     ') AND REF_CUR_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR) ||
     ')' ||
     ' AND REF_CUS_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',ID_CUS) ||
     ')' ||
     ' AND REF_BRANCH IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH) ||
     ') AND DUE_DATE > to_date(''' ||
     I.PERIOD_START ||
     ''',''dd-mm-yyyy'') and DUE_DATE <= to_date(''' ||
     I.PERIOD_END ||
     ''',''dd-mm-yyyy'') ;'
    INTO
     VAR_QUERY
    FROM DUAL;

    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;
   END IF;
  END LOOP;

  COMMIT;
  INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_PROFILE_DETAIL (
   NAME
  ,REF_REPORT
  ,REPREQ
  ,LEDGER_CODE
  ,BALANCE
  ,TIME_PERIOD
  ,MODALITY_TYPE
  ) SELECT /*+  PARALLEL(auto)   */
   (
    SELECT
     NAME
    FROM TBL_LEDGER
    WHERE TBL_LEDGER.LEDGER_CODE   = REF_LEGER_CODE
   )
  ,INPAR_ID_REPORT
  ,VAR_REPREQ
  ,REF_LEGER_CODE
  ,SUM(ABS(BALANCE) )
  ,REF_TIMING_ID
  ,MAX(REF_MODALITY_TYPE)
  FROM TBL_VALUE_TEMP
  WHERE REF_MODALITY_TYPE IN (
    1,2
   )
  GROUP BY
   REF_TIMING_ID
  ,REF_LEGER_CODE;

  COMMIT;
  INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_PROFILE_DETAIL (
   NAME
  ,REF_REPORT
  ,REPREQ
  ,LEDGER_CODE
  ,BALANCE
  ,TIME_PERIOD
  ,MODALITY_TYPE
  ) SELECT /*+  PARALLEL(auto)   */
   (
    SELECT
     NAME
    FROM TBL_LEDGER
    WHERE TBL_LEDGER.LEDGER_CODE   = REF_LEGER_CODE
   )
  ,INPAR_ID_REPORT
  ,VAR_REPREQ
  ,REF_LEGER_CODE
  ,SUM(ABS(BALANCE) )
  ,REF_TIMING_ID
  ,MAX(REF_MODALITY_TYPE)
  FROM TBL_VALUE_TEMP
  WHERE REF_MODALITY_TYPE IN (
    11,21
   )
  GROUP BY
   REF_TIMING_ID
  ,REF_LEGER_CODE;

  COMMIT;
  
  
  
  --=================
  
   INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_GAP_NIIM_PROFILE_DETAIL
  (
   
    name,
    REF_REPORT,
    REPREQ,
    PARENT
  )
  VALUES
  (
    
    'سپرده ها'
    ,INPAR_ID_REPORT
  ,VAR_REPREQ
    ,0
  );
  
  commit;
  --================
  
    INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_GAP_NIIM_PROFILE_DETAIL
  (
   
    name,
    REF_REPORT,
    REPREQ,
    PARENT
  )
  VALUES
  (
    
    'تسهيلات'
    ,INPAR_ID_REPORT
  ,VAR_REPREQ
    ,1
  );
  
  commit;
  
  
  --================
  
  
  
  
  
  
  UPDATE TBL_GAP_NIIM_PROFILE_DETAIL GNPD SET GNPD.PERIOD_NAME = 
(
SELECT TBL_TIMING_PROFILE_DETAIL.PERIOD_NAME FROM TBL_TIMING_PROFILE_DETAIL  WHERE TBL_TIMING_PROFILE_DETAIL.ID = GNPD.TIME_PERIOD
)
WHERE GNPD.REPREQ = VAR_REPREQ;

COMMIT;
  
  PKG_GAP_NIIM.PRC_GAP_NIIM_taAhodi_VALUE();
  DATE_TYPE1:=trunc(sysdate);
  FOR I IN
  (SELECT TTPD.ID ,
    TTP.TYPE ,
    TTPD.PERIOD_NAME ,
    TTPD.PERIOD_DATE ,
    TTPD.PERIOD_START ,
    TTPD.PERIOD_END ,
    TTPD.PERIOD_COLOR
  FROM TBL_TIMING_PROFILE TTP ,
    TBL_TIMING_PROFILE_DETAIL TTPD
  WHERE TTP.ID = TTPD.REF_TIMING_PROFILE
  AND TTP.ID   = ID_TIMING
  )
  LOOP
    IF ( I.TYPE = 1 ) THEN
      /******agar profile zamani entekhab shode bazehee bashad *****--*/
      SELECT '  
 INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_PROFILE_DETAIL (
   NAME
  ,REF_REPORT
  ,REPREQ
  ,LEDGER_CODE
  ,BALANCE
  ,TIME_PERIOD
  ,MODALITY_TYPE
  )
  SELECT /*+   PARALLEL(auto)   */ null,'||INPAR_ID_REPORT||','||VAR_REPREQ||',null,sum(gap_rate),
''' ||
     I.ID ||
     ''',111
FROM TBL_GAP_NIIM_VALUE WHERE type = 11  AND eff_date > to_date('''
        || DATE_TYPE1
        || ''',''dd-mm-yyyy'''''') and eff_date <= to_date('''
        || DATE_TYPE1
        || ''',''dd-mm-yyyy'''''')+'
        || I.PERIOD_DATE
        || '  ;'
      INTO VAR_QUERY
      FROM DUAL;
      DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;
      SELECT '  
 INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_PROFILE_DETAIL (
   NAME
  ,REF_REPORT
  ,REPREQ
  ,LEDGER_CODE
  ,BALANCE
  ,TIME_PERIOD
  ,MODALITY_TYPE
  )
  SELECT /*+   PARALLEL(auto)   */ null,'||INPAR_ID_REPORT||','||VAR_REPREQ||',null,sum(gap_rate),
''' ||
     I.ID ||
     ''',211
FROM TBL_GAP_NIIM_VALUE WHERE type = 21  AND eff_date > to_date('''
        || DATE_TYPE1
        || ''',''dd-mm-yyyy'''''') and eff_date <= to_date('''
        || DATE_TYPE1
        || ''',''dd-mm-yyyy'''''')+'
        || I.PERIOD_DATE
        || '  ;'
      INTO VAR_QUERY
      FROM DUAL;
      DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;

      ------/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/
      

      
      DATE_TYPE1 := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
      
      
    ELSE
      /******agar profile zamani entekhab shode tarikhi bashad *****--*/
      SELECT '  
 INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_PROFILE_DETAIL (
   NAME
  ,REF_REPORT
  ,REPREQ
  ,LEDGER_CODE
  ,BALANCE
  ,TIME_PERIOD
  ,MODALITY_TYPE
  )
  SELECT /*+   PARALLEL(auto)   */ null,'||INPAR_ID_REPORT||','||VAR_REPREQ||',null,sum(gap_rate),
''' ||
     I.ID ||
     ''',111
FROM TBL_GAP_NIIM_VALUE WHERE type = 11 AND eff_date > to_date(''' ||
     I.PERIOD_START ||
     ''',''dd-mm-yyyy'') and eff_date <= to_date(''' ||
     I.PERIOD_END ||
     ''',''dd-mm-yyyy'') ;'
      INTO VAR_QUERY
      FROM DUAL;
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;
      SELECT '  
    INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_PROFILE_DETAIL (
   NAME
  ,REF_REPORT
  ,REPREQ
  ,LEDGER_CODE
  ,BALANCE
  ,TIME_PERIOD
  ,MODALITY_TYPE
  )
  SELECT /*+   PARALLEL(auto)   */ null,'||INPAR_ID_REPORT||','||VAR_REPREQ||',null,sum(gap_rate),
''' ||
     I.ID ||
     ''',211
FROM TBL_GAP_NIIM_VALUE WHERE type = 21 AND eff_date > to_date(''' ||
     I.PERIOD_START ||
     ''',''dd-mm-yyyy'') and eff_date <= to_date(''' ||
     I.PERIOD_END ||
     ''',''dd-mm-yyyy'') ;'
      INTO VAR_QUERY
      FROM DUAL;
            

      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
  end if;
  end loop;
  /*-------------------------*/
  LOC_F         := SYSTIMESTAMP;
  LOC_MEGHDAR   := SQL%ROWCOUNT;
/* EXCEPTION*/
/*  WHEN OTHERS THEN*/
/*   RAISE;*/
 END PRC_GAP_NIIM_REPORT_VALUE;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_gap_niim_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
 END PRC_gap_niim_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_GAP_NIIM_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category",
  ref_timing_profile as "timeProfile",
  ref_dep_profile as "depProfile",
  ref_lon_profile as "lonProfile",
  ref_cus_profile as "cusProfile",
  ref_cur_profile as "curProfile",
  ref_brn_profile as "brnProfile",
  timing_profile_type as "timingType",
  REF_LEDGER_PROFIEL as "tahlilHasasiat"
 FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''GAP_NIIM'' order by id';
  RETURN VAR2;
 END FNC_GAP_NIIM_GET_REPORT_INFO;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_GAP_NIIM_GET_REPORT_sens ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
  var_tahlil VARCHAR2(3000);
  var_report VARCHAR2(3000);
 BEGIN
 select REF_REPORT_ID into var_report from TBL_REPREQ where ID = INPAR_ID; 
 select REF_LEDGER_PROFIEL into var_tahlil from tbl_report where ID = var_report;

  VAR2   := 'select regexp_substr(str, ''[^,]+'', 1, 1) as "name", 
       regexp_substr(str, ''[^,]+'', 1, 2) as "rate"
       from (select regexp_substr ('''||var_tahlil||''', ''[^#]+'',1, rownum) str
from dual
connect by level <= regexp_count ('''||var_tahlil||''', ''[^#]+'')) ';

  RETURN VAR2;
 END FNC_GAP_NIIM_GET_REPORT_sens;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 
 
 FUNCTION FNC_GAP_NIIM_GET_REPORT_QUERY(INPAR_ID NUMBER)RETURN VARCHAR2 AS
 VAR_SELECT VARCHAR2(30000);
 VAR_PIVOT VARCHAR2(30000);
 
BEGIN

SELECT WMSYS.WM_CONCAT(TIME_PERIOD)  into VAR_PIVOT   FROM 
(SELECT DISTINCT TIME_PERIOD  || ' AS "x' || TIME_PERIOD ||'"' AS TIME_PERIOD FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ = INPAR_ID and time_period is not null ORDER BY TIME_PERIOD);

SELECT WMSYS.WM_CONCAT(TIME_PERIOD)  into VAR_SELECT   FROM 
(SELECT DISTINCT  '  "x' || TIME_PERIOD ||'"' AS TIME_PERIOD FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ = INPAR_ID and time_period is not null ORDER BY TIME_PERIOD);

-- SELECT DISTINCT   TIME_PERIOD  , PERIOD_NAME FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ = INPAR_ID ORDER BY TIME_PERIOD;


return
'
SELECT NAME as "text",
LEDGER_CODE as "code",MODALITY_TYPE as "type", '||VAR_SELECT||', parent as "parent" FROM (
SELECT NAME,
parent,
LEDGER_CODE,
BALANCE,
TIME_PERIOD,
MODALITY_TYPE
FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ = '||INPAR_ID||' AND MODALITY_TYPE IN (1,2) )
PIVOT (SUM(BALANCE) FOR TIME_PERIOD IN ( '||VAR_PIVOT||'))

union

SELECT NAME as "text",
LEDGER_CODE as "code",MODALITY_TYPE as "type", '||VAR_SELECT||', parent as "parent" FROM (
SELECT NAME,
parent,
LEDGER_CODE,
BALANCE,
TIME_PERIOD,
MODALITY_TYPE
FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ =  '||INPAR_ID||'  AND MODALITY_TYPE IN (111,211) )
PIVOT (SUM(BALANCE) FOR TIME_PERIOD IN ('||VAR_PIVOT||'))



union
SELECT NAME as "text", 
LEDGER_CODE as "code",MODALITY_TYPE as "type", '||VAR_SELECT||',"parent" FROM (
SELECT NAME,
parent  as "parent",
LEDGER_CODE,
BALANCE,
TIME_PERIOD,
MODALITY_TYPE,
parent
FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE parent is not null and REPREQ =  '||INPAR_ID||'  )
PIVOT (SUM(BALANCE) FOR TIME_PERIOD IN ('||VAR_PIVOT||'))


UNION 


SELECT   NAME as "text",1 as "code" , MODALITY_TYPE as "type", '||VAR_SELECT||',"parent" 
FROM (
SELECT ''NO_NAME'' as name,
max(parent)  as "parent",
SUM(BALANCE) AS BALANCE,
TIME_PERIOD,
 MODALITY_TYPE
 FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ =   '||INPAR_ID||'  AND MODALITY_TYPE IN (11,21) GROUP BY MODALITY_TYPE,TIME_PERIOD )
PIVOT (SUM(BALANCE) FOR TIME_PERIOD IN ('||VAR_PIVOT||'))


ORDER BY "type"';




 
END;
 
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 
 FUNCTION FNC_GAP_NIIM_GET_DETAIL_TIMING(INPAR_ID NUMBER)RETURN VARCHAR2 AS
 VAR_SELECT VARCHAR2(30000);
 VAR_PIVOT VARCHAR2(30000);
 
BEGIN


return 'SELECT DISTINCT    ''x''||TIME_PERIOD "value"  , PERIOD_NAME "header" FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ = '||INPAR_ID||' and TIME_PERIOD is not null and PERIOD_NAME is not null ORDER BY "value"';

END;
 
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_GAP_NIIM_taAhodi_VALUE AS
 VAR_DATE   DATE;
 VAR_MAX    DATE;
BEGIN

execute immediate 'truncate table TBL_GAP_NIIM_VALUE';

 SELECT /*+ PARALLEL(auto)   */
  MAX(TRUNC(DUE_DATE) )
 INTO
  VAR_MAX
 FROM TBL_VALUE_temp;

 VAR_DATE   := SYSDATE;
 
 LOOP
  INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_VALUE ( TYPE,GAP_RATE,EFF_DATE ) ( SELECT
   ID
  ,RATE
  ,DT
  FROM (
    SELECT /*+  PARALLEL(auto)   */
     REF_MODALITY_TYPE as id
    ,ROUND(
      SUM(BALANCE) / 30
     ,2
     ) as rate
    FROM TBL_VALUE
    WHERE DUE_DATE BETWEEN TRUNC(VAR_DATE) AND TRUNC(VAR_DATE + 30)
     AND
      REF_MODALITY_TYPE IN (
       11,21
      )
    GROUP BY
     REF_MODALITY_TYPE
   )
  ,    (
    SELECT /*+  PARALLEL(auto)   */
     TRUNC(VAR_DATE - 1 + ROWNUM) DT
    FROM DUAL
    CONNECT BY
     ROWNUM < 31
   )
  );

  COMMIT;
  VAR_DATE   := VAR_DATE + 30;
  EXIT WHEN trunc(VAR_DATE) > trunc(VAR_MAX);
 END LOOP;

END PRC_GAP_NIIM_taAhodi_VALUE;



  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/




 
END PKG_GAP_NIIM;
--------------------------------------------------------
--  DDL for Table PKG_GAP_NIIM
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_GAP_NIIM" AS 
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PROCEDURE PRC_GAP_NIIM_PROFILE_REPORT (
  INPAR_NAME                  IN VARCHAR2
 ,INPAR_DES                   IN VARCHAR2
 ,INPAR_REF_USER              IN VARCHAR2
 ,INPAR_STATUS                IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE      IN VARCHAR2
 ,INPAR_ID                    IN VARCHAR2
 ,INPAR_TYPE                  IN VARCHAR2
 ,INPAR_TIMING_PROFILE        IN VARCHAR2
 ,INPAR_DEP_PROFILE           IN VARCHAR2
 ,INPAR_LON_PROFILE           IN VARCHAR2
 ,INPAR_CUS_PROFILE           IN VARCHAR2
 ,INPAR_CUR_PROFILE           IN VARCHAR2
 ,INPAR_BRN_PROFILE           IN VARCHAR2
 ,INPAR_TIMING_PROFILE_TYPE   IN VARCHAR2
 ,inpar_tahlil_hasasiat     in varchar2 
 ,OUTPAR_ID                   OUT VARCHAR2
 );

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_GAP_NIIM_REPORT_VALUE ( INPAR_ID_REPORT IN VARCHAR2 );

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_GAP_NIIM_taAhodi_VALUE ;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_GAP_NIIM_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 );
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_GAP_NIIM_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_GAP_NIIM_GET_REPORT_sens ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_GAP_NIIM_GET_REPORT_QUERY ( INPAR_ID NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 FUNCTION FNC_GAP_NIIM_GET_DETAIL_TIMING ( INPAR_ID NUMBER ) RETURN VARCHAR2;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

END PKG_GAP_NIIM;
CREATE OR REPLACE PACKAGE BODY "PRAGG"."PKG_GAP_NIIM" AS
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_GAP_NIIM_PROFILE_REPORT (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,INPAR_TYPE               IN VARCHAR2
 ,INPAR_TIMING_PROFILE     IN VARCHAR2
 ,INPAR_DEP_PROFILE        IN VARCHAR2
 ,INPAR_LON_PROFILE        IN VARCHAR2
 ,INPAR_CUS_PROFILE        IN VARCHAR2
 ,INPAR_CUR_PROFILE        IN VARCHAR2
 ,INPAR_BRN_PROFILE        IN VARCHAR2,
 inpar_timing_profile_type in varchar2,
 inpar_tahlil_hasasiat     in varchar2   --ke dar sotoone REF_LEDGER_PROFIEL dar jadvale report rikhte mishavad
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,CATEGORY
   ,TYPE
   ,REF_TIMING_PROFILE
   ,REF_LON_PROFILE
   ,REF_DEP_PROFILE
   ,REF_CUS_PROFILE
   ,REF_CUR_PROFILE
   ,REF_BRN_PROFILE
   ,TIMING_PROFILE_TYPE
   ,REF_LEDGER_PROFIEL
   ) VALUES (
    INPAR_NAME
   ,INPAR_DES
   ,SYSDATE
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,'GAP_NIIM'
   ,INPAR_TYPE
   ,INPAR_TIMING_PROFILE
   ,INPAR_LON_PROFILE
   ,INPAR_DEP_PROFILE
   ,INPAR_CUS_PROFILE
   ,INPAR_CUR_PROFILE
   ,INPAR_BRN_PROFILE
   ,inpar_timing_profile_type,
   inpar_tahlil_hasasiat
   );

   COMMIT;
   SELECT
    ID
   INTO
    OUTPAR_ID
   FROM TBL_REPORT
   WHERE CREATE_DATE   = (
      SELECT
       MAX(CREATE_DATE)
      FROM TBL_REPORT
     )
    AND
     ID            = (
      SELECT
       MAX(ID)
      FROM TBL_REPORT
     );

  ELSE
   UPDATE TBL_REPORT
    SET
     NAME = INPAR_NAME
    ,DES = INPAR_DES
    ,REF_USER = INPAR_REF_USER
    ,STATUS = INPAR_STATUS
    ,TYPE = INPAR_TYPE
    ,REF_TIMING_PROFILE = INPAR_TIMING_PROFILE
    ,REF_DEP_PROFILE = INPAR_DEP_PROFILE
    ,REF_LON_PROFILE = INPAR_LON_PROFILE
    ,REF_CUS_PROFILE = INPAR_CUS_PROFILE
    ,REF_CUR_PROFILE = INPAR_CUR_PROFILE
    ,REF_BRN_PROFILE = INPAR_BRN_PROFILE
    ,TIMING_PROFILE_TYPE = inpar_timing_profile_type
    ,REF_LEDGER_PROFIEL  = inpar_tahlil_hasasiat
   WHERE ID   = INPAR_ID;

   COMMIT;
  END IF;

  UPDATE TBL_REPORT
   SET
    H_ID = ID
  WHERE TYPE   = 'GAP_NIIM'
   AND
    H_ID IS NULL;

  COMMIT;
 END PRC_GAP_NIIM_PROFILE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_GAP_NIIM_REPORT_VALUE ( INPAR_ID_REPORT IN VARCHAR2 ) AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Morteza.Sahhi
  Editor Name:
  Release Date/Time:1396/02/24-10:00
  Edit Name:
  Version: 1.1
  Category:2
  Description:in procedure baraye enteghal dadehaye morde niaz az value be TBL_VALUE_TEMP bar asas profilehaye mokhtalefist ke karbar taeen karde
  */
  /*------------------------------------------------------------------------------*/

  VAR_QUERY     VARCHAR2(4000);
  ID_LOAN       NUMBER;
  ID_DEP        NUMBER;
  ID_CUR        NUMBER;
  ID_CUS        NUMBER;
  ID_BRANCH     NUMBER;
  ID_TIMING     NUMBER;
  DATE_TYPE1    DATE := SYSDATE;
  LOC_S         TIMESTAMP;
  LOC_F         TIMESTAMP;
  LOC_MEGHDAR   NUMBER;
  VAR_REPREQ    NUMBER;
 BEGIN
  EXECUTE IMMEDIATE 'alter session set nls_date_format=''DD-MM-RRRR''';
  SYS.DBMS_OUTPUT.ENABLE(3000000);
  EXECUTE IMMEDIATE 'truncate table TBL_VALUE_TEMP';
  /******profilhaye mokhtalefi ke karbar baraye in gozaresh entekhab karde ra daron moteghayer ham nam profil mirizim ******/
  SELECT
   MAX(ID)
  INTO
   VAR_REPREQ
  FROM TBL_REPREQ
  WHERE REF_REPORT_ID   = INPAR_ID_REPORT;

  SELECT
   MAX(ID)
  INTO
   ID_CUR
  FROM TBL_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_CUR_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );

  SELECT
   MAX(ID)
  INTO
   ID_CUS
  FROM TBL_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_CUS_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );

  SELECT
   MAX(ID)
  INTO
   ID_BRANCH
  FROM TBL_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_BRN_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );

  SELECT
   MAX(ID)
  INTO
   ID_DEP
  FROM TBL_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_DEP_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );

  SELECT
   MAX(ID)
  INTO
   ID_TIMING
  FROM TBL_TIMING_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_TIMING_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );

  SELECT
   MAX(ID)
  INTO
   ID_LOAN
  FROM TBL_PROFILE
  WHERE H_ID   = (
    SELECT
     REF_LON_PROFILE
    FROM TBL_REPORT
    WHERE ID   = INPAR_ID_REPORT
   );
  /******be ezaye tedad bazehayee ke dar profile zamani vojod darad halghe ro ejra mikonim*****--*/

  FOR I IN (
   SELECT
    TTPD.ID
   ,TTP.TYPE
   ,TTPD.PERIOD_NAME
   ,TTPD.PERIOD_DATE
   ,TTPD.PERIOD_START
   ,TTPD.PERIOD_END
   ,TTPD.PERIOD_COLOR
   FROM TBL_TIMING_PROFILE TTP
   ,    TBL_TIMING_PROFILE_DETAIL TTPD
   WHERE TTP.ID   = TTPD.REF_TIMING_PROFILE
    AND
     TTP.ID   = ID_TIMING
  ) LOOP
   IF
    ( I.TYPE = 1 )
   THEN
      /******agar profile zamani entekhab shode bazehee bashad *****--*/
    SELECT
     '  
INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE_TEMP  
(    
REF_MODALITY_TYPE,
REF_ID,
BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID ,
REF_TIMING_ID,
TIMING_NAME,
TIMING_color
) 
SELECT /*+   PARALLEL(auto)   */ REF_MODALITY_TYPE,
REF_ID,
case when REF_MODALITY_TYPE in (2,21) then  -1*BALANCE else BALANCE end as BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID,
''' ||
     I.ID ||
     ''',
''' ||
     I.PERIOD_NAME ||
     ''',
''' ||
     I.PERIOD_COLOR ||
     '''
FROM TBL_VALUE WHERE REF_ID IN (  
' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',ID_LOAN) ||
     ') AND REF_CUR_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR) ||
     ')' ||
     ' AND REF_CUS_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',ID_CUS) ||
     ')' ||
     ' AND REF_BRANCH IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH) ||
     ')  AND DUE_DATE > to_date(''' ||
     DATE_TYPE1 ||
     ''',''dd-mm-yyyy'''''') and DUE_DATE <= to_date(''' ||
     DATE_TYPE1 ||
     ''',''dd-mm-yyyy'''''')+' ||
     I.PERIOD_DATE ||
     '  ;'
    INTO
     VAR_QUERY
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;
    SELECT
     '  
INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE_TEMP  
(    
REF_MODALITY_TYPE,
REF_ID,
BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID ,
REF_TIMING_ID,
TIMING_NAME,
TIMING_color
) 
SELECT /*+   PARALLEL(auto)   */ REF_MODALITY_TYPE,
REF_ID,
case when REF_MODALITY_TYPE in (2,21) then  -1*BALANCE else BALANCE end as BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID,
''' ||
     I.ID ||
     ''',
''' ||
     I.PERIOD_NAME ||
     ''',
''' ||
     I.PERIOD_COLOR ||
     '''
FROM TBL_VALUE WHERE REF_ID IN (  
' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_DEPOSIT',ID_DEP) ||
     ') AND REF_CUR_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR) ||
     ')' ||
     ' AND REF_CUS_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',ID_CUS) ||
     ')' ||
     ' AND REF_BRANCH IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH) ||
     ')  AND DUE_DATE > to_date(''' ||
     DATE_TYPE1 ||
     ''',''dd-mm-yyyy'''''') and DUE_DATE <= to_date(''' ||
     DATE_TYPE1 ||
     ''',''dd-mm-yyyy'''''')+' ||
     I.PERIOD_DATE ||
     '  ;'
    INTO
     VAR_QUERY
    FROM DUAL;

    DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;
    DATE_TYPE1   := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
   ELSE
      /******agar profile zamani entekhab shode tarikhi bashad *****--*/
    SELECT
     '  
INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE_TEMP  
(    
REF_MODALITY_TYPE,
REF_ID,
BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID  ,
REF_TIMING_ID,
TIMING_NAME,
TIMING_color 
) 
SELECT /*+   PARALLEL(auto)   */ REF_MODALITY_TYPE,
REF_ID,
case when REF_MODALITY_TYPE in (2,21) then  -1*BALANCE else BALANCE end as BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID,
''' ||
     I.ID ||
     ''',
''' ||
     I.PERIOD_NAME ||
     ''',
''' ||
     I.PERIOD_COLOR ||
     '''
FROM TBL_VALUE WHERE REF_ID IN (  
' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_DEPOSIT',ID_DEP) ||
     ') AND REF_CUR_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR) ||
     ')' ||
     ' AND REF_CUS_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',ID_CUS) ||
     ')' ||
     ' AND REF_BRANCH IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH) ||
     ') AND DUE_DATE > to_date(''' ||
     I.PERIOD_START ||
     ''',''dd-mm-yyyy'') and DUE_DATE <= to_date(''' ||
     I.PERIOD_END ||
     ''',''dd-mm-yyyy'') ;'
    INTO
     VAR_QUERY
    FROM DUAL;

    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;
    SELECT
     '  
INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE_TEMP  
(    
REF_MODALITY_TYPE,
REF_ID,
BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID  ,
REF_TIMING_ID,
TIMING_NAME,
TIMING_color 
) 
SELECT /*+   PARALLEL(auto)   */ REF_MODALITY_TYPE,
REF_ID,
case when REF_MODALITY_TYPE in (2,21) then  -1*BALANCE else BALANCE end as BALANCE,
REF_BRANCH,
DUE_DATE,
REF_TYPE,
REF_LEGER_CODE,
REF_CUR_ID,
REF_STA_ID,
REF_CTY_ID,
REF_CUS_ID,
''' ||
     I.ID ||
     ''',
''' ||
     I.PERIOD_NAME ||
     ''',
''' ||
     I.PERIOD_COLOR ||
     '''
FROM TBL_VALUE WHERE REF_ID IN (  
' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',ID_LOAN) ||
     ') AND REF_CUR_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR) ||
     ')' ||
     ' AND REF_CUS_ID IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',ID_CUS) ||
     ')' ||
     ' AND REF_BRANCH IN ( ' ||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',ID_BRANCH) ||
     ') AND DUE_DATE > to_date(''' ||
     I.PERIOD_START ||
     ''',''dd-mm-yyyy'') and DUE_DATE <= to_date(''' ||
     I.PERIOD_END ||
     ''',''dd-mm-yyyy'') ;'
    INTO
     VAR_QUERY
    FROM DUAL;

    EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
    COMMIT;
   END IF;
  END LOOP;

  COMMIT;
  INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_PROFILE_DETAIL (
   NAME
  ,REF_REPORT
  ,REPREQ
  ,LEDGER_CODE
  ,BALANCE
  ,TIME_PERIOD
  ,MODALITY_TYPE
  ) SELECT /*+  PARALLEL(auto)   */
   (
    SELECT
     NAME
    FROM TBL_LEDGER
    WHERE TBL_LEDGER.LEDGER_CODE   = REF_LEGER_CODE
   )
  ,INPAR_ID_REPORT
  ,VAR_REPREQ
  ,REF_LEGER_CODE
  ,SUM(ABS(BALANCE) )
  ,REF_TIMING_ID
  ,MAX(REF_MODALITY_TYPE)
  FROM TBL_VALUE_TEMP
  WHERE REF_MODALITY_TYPE IN (
    1,2
   )
  GROUP BY
   REF_TIMING_ID
  ,REF_LEGER_CODE;

  COMMIT;
  INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_PROFILE_DETAIL (
   NAME
  ,REF_REPORT
  ,REPREQ
  ,LEDGER_CODE
  ,BALANCE
  ,TIME_PERIOD
  ,MODALITY_TYPE
  ) SELECT /*+  PARALLEL(auto)   */
   (
    SELECT
     NAME
    FROM TBL_LEDGER
    WHERE TBL_LEDGER.LEDGER_CODE   = REF_LEGER_CODE
   )
  ,INPAR_ID_REPORT
  ,VAR_REPREQ
  ,REF_LEGER_CODE
  ,SUM(ABS(BALANCE) )
  ,REF_TIMING_ID
  ,MAX(REF_MODALITY_TYPE)
  FROM TBL_VALUE_TEMP
  WHERE REF_MODALITY_TYPE IN (
    11,21
   )
  GROUP BY
   REF_TIMING_ID
  ,REF_LEGER_CODE;

  COMMIT;
  
  
  
  --=================
  
   INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_GAP_NIIM_PROFILE_DETAIL
  (
   
    name,
    REF_REPORT,
    REPREQ,
    PARENT
  )
  VALUES
  (
    
    'سپرده ها'
    ,INPAR_ID_REPORT
  ,VAR_REPREQ
    ,0
  );
  
  commit;
  --================
  
    INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_GAP_NIIM_PROFILE_DETAIL
  (
   
    name,
    REF_REPORT,
    REPREQ,
    PARENT
  )
  VALUES
  (
    
    'تسهيلات'
    ,INPAR_ID_REPORT
  ,VAR_REPREQ
    ,1
  );
  
  commit;
  
  
  --================
  
  
  
  
  
  
  UPDATE TBL_GAP_NIIM_PROFILE_DETAIL GNPD SET GNPD.PERIOD_NAME = 
(
SELECT TBL_TIMING_PROFILE_DETAIL.PERIOD_NAME FROM TBL_TIMING_PROFILE_DETAIL  WHERE TBL_TIMING_PROFILE_DETAIL.ID = GNPD.TIME_PERIOD
)
WHERE GNPD.REPREQ = VAR_REPREQ;

COMMIT;
  
  PKG_GAP_NIIM.PRC_GAP_NIIM_taAhodi_VALUE();
  DATE_TYPE1:=trunc(sysdate);
  FOR I IN
  (SELECT TTPD.ID ,
    TTP.TYPE ,
    TTPD.PERIOD_NAME ,
    TTPD.PERIOD_DATE ,
    TTPD.PERIOD_START ,
    TTPD.PERIOD_END ,
    TTPD.PERIOD_COLOR
  FROM TBL_TIMING_PROFILE TTP ,
    TBL_TIMING_PROFILE_DETAIL TTPD
  WHERE TTP.ID = TTPD.REF_TIMING_PROFILE
  AND TTP.ID   = ID_TIMING
  )
  LOOP
    IF ( I.TYPE = 1 ) THEN
      /******agar profile zamani entekhab shode bazehee bashad *****--*/
      SELECT '  
 INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_PROFILE_DETAIL (
   NAME
  ,REF_REPORT
  ,REPREQ
  ,LEDGER_CODE
  ,BALANCE
  ,TIME_PERIOD
  ,MODALITY_TYPE
  )
  SELECT /*+   PARALLEL(auto)   */ null,'||INPAR_ID_REPORT||','||VAR_REPREQ||',null,sum(gap_rate),
''' ||
     I.ID ||
     ''',111
FROM TBL_GAP_NIIM_VALUE WHERE type = 11  AND eff_date > to_date('''
        || DATE_TYPE1
        || ''',''dd-mm-yyyy'''''') and eff_date <= to_date('''
        || DATE_TYPE1
        || ''',''dd-mm-yyyy'''''')+'
        || I.PERIOD_DATE
        || '  ;'
      INTO VAR_QUERY
      FROM DUAL;
      DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;
      SELECT '  
 INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_PROFILE_DETAIL (
   NAME
  ,REF_REPORT
  ,REPREQ
  ,LEDGER_CODE
  ,BALANCE
  ,TIME_PERIOD
  ,MODALITY_TYPE
  )
  SELECT /*+   PARALLEL(auto)   */ null,'||INPAR_ID_REPORT||','||VAR_REPREQ||',null,sum(gap_rate),
''' ||
     I.ID ||
     ''',211
FROM TBL_GAP_NIIM_VALUE WHERE type = 21  AND eff_date > to_date('''
        || DATE_TYPE1
        || ''',''dd-mm-yyyy'''''') and eff_date <= to_date('''
        || DATE_TYPE1
        || ''',''dd-mm-yyyy'''''')+'
        || I.PERIOD_DATE
        || '  ;'
      INTO VAR_QUERY
      FROM DUAL;
      DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;

      ------/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/
      

      
      DATE_TYPE1 := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
      
      
    ELSE
      /******agar profile zamani entekhab shode tarikhi bashad *****--*/
      SELECT '  
 INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_PROFILE_DETAIL (
   NAME
  ,REF_REPORT
  ,REPREQ
  ,LEDGER_CODE
  ,BALANCE
  ,TIME_PERIOD
  ,MODALITY_TYPE
  )
  SELECT /*+   PARALLEL(auto)   */ null,'||INPAR_ID_REPORT||','||VAR_REPREQ||',null,sum(gap_rate),
''' ||
     I.ID ||
     ''',111
FROM TBL_GAP_NIIM_VALUE WHERE type = 11 AND eff_date > to_date(''' ||
     I.PERIOD_START ||
     ''',''dd-mm-yyyy'') and eff_date <= to_date(''' ||
     I.PERIOD_END ||
     ''',''dd-mm-yyyy'') ;'
      INTO VAR_QUERY
      FROM DUAL;
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;
      SELECT '  
    INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_PROFILE_DETAIL (
   NAME
  ,REF_REPORT
  ,REPREQ
  ,LEDGER_CODE
  ,BALANCE
  ,TIME_PERIOD
  ,MODALITY_TYPE
  )
  SELECT /*+   PARALLEL(auto)   */ null,'||INPAR_ID_REPORT||','||VAR_REPREQ||',null,sum(gap_rate),
''' ||
     I.ID ||
     ''',211
FROM TBL_GAP_NIIM_VALUE WHERE type = 21 AND eff_date > to_date(''' ||
     I.PERIOD_START ||
     ''',''dd-mm-yyyy'') and eff_date <= to_date(''' ||
     I.PERIOD_END ||
     ''',''dd-mm-yyyy'') ;'
      INTO VAR_QUERY
      FROM DUAL;
            

      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
  end if;
  end loop;
  /*-------------------------*/
  LOC_F         := SYSTIMESTAMP;
  LOC_MEGHDAR   := SQL%ROWCOUNT;
/* EXCEPTION*/
/*  WHEN OTHERS THEN*/
/*   RAISE;*/
 END PRC_GAP_NIIM_REPORT_VALUE;

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
PROCEDURE PRC_gap_niim_DELETE_REPORT (
  INPAR_ID   IN VARCHAR2
 ,OUTPAR     OUT VARCHAR2
 )
  AS
 BEGIN
  DELETE FROM TBL_REPORT WHERE ID   = INPAR_ID;

  COMMIT;
  DELETE FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REF_REPORT   = INPAR_ID;

  COMMIT;
 END PRC_gap_niim_DELETE_REPORT;
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_GAP_NIIM_GET_REPORT_INFO ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
 BEGIN
  VAR2   := 'SELECT ID as "id",
  NAME as "name",
  DES as "des",
  CREATE_DATE as "createDate",
  REF_USER as "refUser",
  STATUS as "status",
  CATEGORY as "category",
  ref_timing_profile as "timeProfile",
  ref_dep_profile as "depProfile",
  ref_lon_profile as "lonProfile",
  ref_cus_profile as "cusProfile",
  ref_cur_profile as "curProfile",
  ref_brn_profile as "brnProfile",
  timing_profile_type as "timingType",
  REF_LEDGER_PROFIEL as "tahlilHasasiat"
 FROM TBL_REPORT 
where id = '
|| INPAR_ID || ' and upper(category) = ''GAP_NIIM'' order by id';
  RETURN VAR2;
 END FNC_GAP_NIIM_GET_REPORT_INFO;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
FUNCTION FNC_GAP_NIIM_GET_REPORT_sens ( INPAR_ID IN VARCHAR2 ) RETURN VARCHAR2 AS
  VAR2   VARCHAR2(3000);
  var_tahlil VARCHAR2(3000);
  var_report VARCHAR2(3000);
 BEGIN
 select REF_REPORT_ID into var_report from TBL_REPREQ where ID = INPAR_ID; 
 select REF_LEDGER_PROFIEL into var_tahlil from tbl_report where ID = var_report;

  VAR2   := 'select regexp_substr(str, ''[^,]+'', 1, 1) as "name", 
       regexp_substr(str, ''[^,]+'', 1, 2) as "rate"
       from (select regexp_substr ('''||var_tahlil||''', ''[^#]+'',1, rownum) str
from dual
connect by level <= regexp_count ('''||var_tahlil||''', ''[^#]+'')) ';

  RETURN VAR2;
 END FNC_GAP_NIIM_GET_REPORT_sens;
 /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 
 
 FUNCTION FNC_GAP_NIIM_GET_REPORT_QUERY(INPAR_ID NUMBER)RETURN VARCHAR2 AS
 VAR_SELECT VARCHAR2(30000);
 VAR_PIVOT VARCHAR2(30000);
 
BEGIN

SELECT WMSYS.WM_CONCAT(TIME_PERIOD)  into VAR_PIVOT   FROM 
(SELECT DISTINCT TIME_PERIOD  || ' AS "x' || TIME_PERIOD ||'"' AS TIME_PERIOD FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ = INPAR_ID and time_period is not null ORDER BY TIME_PERIOD);

SELECT WMSYS.WM_CONCAT(TIME_PERIOD)  into VAR_SELECT   FROM 
(SELECT DISTINCT  '  "x' || TIME_PERIOD ||'"' AS TIME_PERIOD FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ = INPAR_ID and time_period is not null ORDER BY TIME_PERIOD);

-- SELECT DISTINCT   TIME_PERIOD  , PERIOD_NAME FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ = INPAR_ID ORDER BY TIME_PERIOD;


return
'
SELECT NAME as "text",
LEDGER_CODE as "code",MODALITY_TYPE as "type", '||VAR_SELECT||', parent as "parent" FROM (
SELECT NAME,
parent,
LEDGER_CODE,
BALANCE,
TIME_PERIOD,
MODALITY_TYPE
FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ = '||INPAR_ID||' AND MODALITY_TYPE IN (1,2) )
PIVOT (SUM(BALANCE) FOR TIME_PERIOD IN ( '||VAR_PIVOT||'))

union

SELECT NAME as "text",
LEDGER_CODE as "code",MODALITY_TYPE as "type", '||VAR_SELECT||', parent as "parent" FROM (
SELECT NAME,
parent,
LEDGER_CODE,
BALANCE,
TIME_PERIOD,
MODALITY_TYPE
FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ =  '||INPAR_ID||'  AND MODALITY_TYPE IN (111,211) )
PIVOT (SUM(BALANCE) FOR TIME_PERIOD IN ('||VAR_PIVOT||'))



union
SELECT NAME as "text", 
LEDGER_CODE as "code",MODALITY_TYPE as "type", '||VAR_SELECT||',"parent" FROM (
SELECT NAME,
parent  as "parent",
LEDGER_CODE,
BALANCE,
TIME_PERIOD,
MODALITY_TYPE,
parent
FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE parent is not null and REPREQ =  '||INPAR_ID||'  )
PIVOT (SUM(BALANCE) FOR TIME_PERIOD IN ('||VAR_PIVOT||'))


UNION 


SELECT   NAME as "text",1 as "code" , MODALITY_TYPE as "type", '||VAR_SELECT||',"parent" 
FROM (
SELECT ''NO_NAME'' as name,
max(parent)  as "parent",
SUM(BALANCE) AS BALANCE,
TIME_PERIOD,
 MODALITY_TYPE
 FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ =   '||INPAR_ID||'  AND MODALITY_TYPE IN (11,21) GROUP BY MODALITY_TYPE,TIME_PERIOD )
PIVOT (SUM(BALANCE) FOR TIME_PERIOD IN ('||VAR_PIVOT||'))


ORDER BY "type"';




 
END;
 
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 
 FUNCTION FNC_GAP_NIIM_GET_DETAIL_TIMING(INPAR_ID NUMBER)RETURN VARCHAR2 AS
 VAR_SELECT VARCHAR2(30000);
 VAR_PIVOT VARCHAR2(30000);
 
BEGIN


return 'SELECT DISTINCT    ''x''||TIME_PERIOD "value"  , PERIOD_NAME "header" FROM TBL_GAP_NIIM_PROFILE_DETAIL WHERE REPREQ = '||INPAR_ID||' and TIME_PERIOD is not null and PERIOD_NAME is not null ORDER BY "value"';

END;
 
  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/

 PROCEDURE PRC_GAP_NIIM_taAhodi_VALUE AS
 VAR_DATE   DATE;
 VAR_MAX    DATE;
BEGIN

execute immediate 'truncate table TBL_GAP_NIIM_VALUE';

 SELECT /*+ PARALLEL(auto)   */
  MAX(TRUNC(DUE_DATE) )
 INTO
  VAR_MAX
 FROM TBL_VALUE_temp;

 VAR_DATE   := SYSDATE;
 
 LOOP
  INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_GAP_NIIM_VALUE ( TYPE,GAP_RATE,EFF_DATE ) ( SELECT
   ID
  ,RATE
  ,DT
  FROM (
    SELECT /*+  PARALLEL(auto)   */
     REF_MODALITY_TYPE as id
    ,ROUND(
      SUM(BALANCE) / 30
     ,2
     ) as rate
    FROM TBL_VALUE
    WHERE DUE_DATE BETWEEN TRUNC(VAR_DATE) AND TRUNC(VAR_DATE + 30)
     AND
      REF_MODALITY_TYPE IN (
       11,21
      )
    GROUP BY
     REF_MODALITY_TYPE
   )
  ,    (
    SELECT /*+  PARALLEL(auto)   */
     TRUNC(VAR_DATE - 1 + ROWNUM) DT
    FROM DUAL
    CONNECT BY
     ROWNUM < 31
   )
  );

  COMMIT;
  VAR_DATE   := VAR_DATE + 30;
  EXIT WHEN trunc(VAR_DATE) > trunc(VAR_MAX);
 END LOOP;

END PRC_GAP_NIIM_taAhodi_VALUE;



  /*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/




 
END PKG_GAP_NIIM;
