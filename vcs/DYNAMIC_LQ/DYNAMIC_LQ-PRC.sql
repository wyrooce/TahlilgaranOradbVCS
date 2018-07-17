--------------------------------------------------------
--  DDL for Procedure CLEAR_ARCHIVE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."CLEAR_ARCHIVE" (
    in_type  IN NUMBER,
    in_count IN NUMBER)
AS
BEGIN

  DELETE FROM reports WHERE ORIGINAL_ID IN (SELECT id
  FROM
    ( SELECT * FROM reports WHERE type =in_type and ARCHIVED=1 ORDER BY CREATED
    )
  WHERE rownum <=in_count );
  
  DELETE FROM reports WHERE id IN (SELECT id
  FROM
    ( SELECT * FROM reports WHERE type =in_type and ARCHIVED=1 ORDER BY CREATED
    )
  WHERE rownum <=in_count );
  
END;
--------------------------------------------------------
--  DDL for Procedure ALL_RELATION
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."ALL_RELATION" 
as
begin
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: az in prc baraye por kardene jadvale ARZ_PRD_DATA estefade mishavd .
  be manzure tabdile arz ha be yekdigar dar har ruz bar asase data_type  
  */
  /*------------------------------------------------------------------------------*/

for i in( 
select REPORT_ID,count(*),eff_date from ARZ_PRD_DATA where REPORT_ID=(select max(id) from reports where type=1) group by  REPORT_ID,eff_date having count(*) <15
)
loop
INSERT
INTO DYNAMIC_LQ.ARZ_PRD_DATA
  (
    ID,
    REPORT_ID,
    DATA_TYPE,
    ARZ1_ID,
    ARZ2_ID,
    RATE,
    EFF_DATE
  )
SELECT (l.id),
  (l.REPORT_ID),
  (l.DATA_TYPE),
  (l.ARZ1_ID) as arz,
  (b.ARZ1_ID),
  (round(l.RATE/ b.rate,5)),
     (b.eff_date) 
FROM DYNAMIC_LQ.ARZ_PRD_DATA l,
  DYNAMIC_LQ.ARZ_PRD_DATA b
WHERE b.eff_date = l.eff_date
AND b.arz1_id   <> l.arz1_id
AND b.report_id  = l.report_id
and l.report_id =i.REPORT_ID
and l.eff_date=b.eff_date
and l.eff_date=i.eff_date;
end loop;
end;
--------------------------------------------------------
--  DDL for Procedure PRC_DELETE_REPORT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_DELETE_REPORT" (
 INPAR_ID   IN NUMBER
 ,OUTPAR     OUT VARCHAR2
)
 AS
BEGIN

 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: az in prc baraye faghat hazf profile estefade mishavad .
  archive pak nemishavad
  */
  /*------------------------------------------------------------------------------*/
 DELETE FROM REPORTS WHERE ID   = INPAR_ID;

 COMMIT;
END PRC_DELETE_REPORT;
--------------------------------------------------------
--  DDL for Procedure ARCHIVED
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."ARCHIVED" (r_id in number, status out number) as


  cnt number:=0;
  max_cnt number:=0;

BEGIn

SELECT COUNT (r1.id) into cnt
  FROM reports r1
  WHERE r1.type=
    (SELECT r2.type
    FROM reports r2
    WHERE r2.id=
      (SELECT r3.original_id FROM reports r3 WHERE id=r_id
      )
    )
  AND r1.archived=1;
  
  SELECT (rs.ARCHIVE_NUM_MAX) into max_cnt
  FROM reports_setting rs
  WHERE rs.REPORT_TYPE=
    (SELECT r2.type
    FROM reports r2
    WHERE r2.id=
      (SELECT r3.original_id FROM reports r3 WHERE id=r_id
      ));
      
  if max_cnt-cnt<=0 then status:=-1;
  else
    status:=1;
      update reports s set s.archived=1 where s.id=r_id;
      update reports s set s.archived=1 where s.id=(select f.original_id from reports f where f.id=r_id);
      commit;
  end if;

END;
--------------------------------------------------------
--  DDL for Procedure INSERT_FROM_DAY_TEHRAN
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."INSERT_FROM_DAY_TEHRAN" AS 
begin 
--EXECUTE IMMEDIATE 'truncate table reports';
--EXECUTE IMMEDIATE 'truncate table reports_data';
--EXECUTE IMMEDIATE 'truncate table reports_error';
--EXECUTE IMMEDIATE 'truncate table reports_setting';
--EXECUTE IMMEDIATE 'truncate table back_test_data';
--EXECUTE IMMEDIATE 'truncate table back_test_error';
--EXECUTE IMMEDIATE 'truncate table arz_prd_data';
--EXECUTE IMMEDIATE 'truncate table nn_param';
--EXECUTE IMMEDIATE 'truncate table nn_actv_func_details';
--EXECUTE IMMEDIATE 'truncate table nn_error_func_details';
--EXECUTE IMMEDIATE 'truncate table arima_param';
--EXECUTE IMMEDIATE 'truncate table egarch_param';
--EXECUTE IMMEDIATE 'truncate table time_serie_param';
--EXECUTE IMMEDIATE 'truncate table fit_param';

insert into REPORTS(
ID,
CREATED,
MASTER_PROFILE_ID,
CREATEDBY,
SCHEDULE_ID,
REPORTER_TYPE,
TYPE,
BRANCH_PROFILE_ID,
STATUS,
ARCHIVED,
UPDATED,
VALID_DATA_DATE,
TREE_VERSION_ID,
LEDGER_PROFILE_ID,
SYSTEM_TYPE,
DEP_BR_ERR,
DEP_TYPE_ERR,
LOAN_BR_ERR,
LOAN_TYPE_ERR,
GL_ERR,
DEPB_BR_ERR,
DEPB_TYPE_ERR,
LOANB_BR_ERR,
LOANB_TYPE_ERR,
GLB_ERR,
ORIGINAL_ID,
GL_BR_ERR,
GLB_BR_ERR,
ZDBAR_RSB_ERR,
ZDBAR_RSB_BKT_ERR
)
SELECT 
ID,
CREATED,
MASTER_PROFILE_ID,
CREATEDBY,
SCHEDULE_ID,
REPORTER_TYPE,
TYPE,
BRANCH_PROFILE_ID,
STATUS,
ARCHIVED,
UPDATED,
VALID_DATA_DATE,
TREE_VERSION_ID,
LEDGER_PROFILE_ID,
SYSTEM_TYPE,
DEP_BR_ERR,
DEP_TYPE_ERR,
LOAN_BR_ERR,
LOAN_TYPE_ERR,
GL_ERR,
DEPB_BR_ERR,
DEPB_TYPE_ERR,
LOANB_BR_ERR,
LOANB_TYPE_ERR,
GLB_ERR,
ORIGINAL_ID,
GL_BR_ERR,
GLB_BR_ERR,
ZDBAR_RSB_ERR,
ZDBAR_RSB_BKT_ERR
FROM  DYNAMIC_LQ_day_TEHRAN.REPORTS  where (type=100 ) and STATUS=2 ;
commit;
DBMS_OUTPUT.PUT_LINE('REPORTS');
----*********************************************************************************
--for i in (select * from REPORTS where (type=100 or type=1) and STATUS=2) loop
----*********************************************************************************
--------------------------------------
insert into REPORTS_DATA
(
ID,
REPORT_ID,
DATA_TYPE,
NODE_ID,
SEPORDE_TYPE,
TASHILAT_TYPE,
SHOBE_ID,
ARZ_ID,
SEPORDE_MANDE,
TASHILAT_MANDE,
MANDE,
EFF_DATE,
SHAHR_ID,
OSTAN_ID,
INTERVAL,
PARENT,
DEPTH,
REPORT_TYPE
)
SELECT 
  ID,
REPORT_ID,
DATA_TYPE,
NODE_ID,
SEPORDE_TYPE,
TASHILAT_TYPE,
SHOBE_ID,
ARZ_ID,
SEPORDE_MANDE,
TASHILAT_MANDE,
MANDE,
EFF_DATE,
SHAHR_ID,
OSTAN_ID,
INTERVAL,
PARENT,
DEPTH,
REPORT_TYPE
FROM  DYNAMIC_LQ_day_TEHRAN.REPORTS_DATA  where report_id=(select max(id) from reports where type=100 and status=2)  ;
commit;
DBMS_OUTPUT.PUT_LINE('REPORTS_DATA');
-------------------------------------
insert into BACK_TEST_DATA
(
ID,
REPORT_ID,
DATA_TYPE,
NODE_ID,
SEPORDE_TYPE,
TASHILAT_TYPE,
SHOBE_ID,
ARZ_ID,
SEPORDE_MANDE,
TASHILAT_MANDE,
MANDE,
EFF_DATE,
SHAHR_ID,
OSTAN_ID,
INTERVAL,
PARENT,
DEPTH,
REPORT_TYPE
)
SELECT
 ID,
REPORT_ID,
DATA_TYPE,
NODE_ID,
SEPORDE_TYPE,
TASHILAT_TYPE,
SHOBE_ID,
ARZ_ID,
SEPORDE_MANDE,
TASHILAT_MANDE,
MANDE,
EFF_DATE,
SHAHR_ID,
OSTAN_ID,
INTERVAL,
PARENT,
DEPTH,
REPORT_TYPE
FROM  DYNAMIC_LQ_day_TEHRAN.BACK_TEST_DATA  where report_id=(select max(id) from reports where type=100 and status=2)  ;
commit;
DBMS_OUTPUT.PUT_LINE('BACK_TEST_DATA');
--------------------------------------------
--insert into ARZ_PRD_DATA(
--ID,
--REPORT_ID,
--DATA_TYPE,
--ARZ1_ID,
--ARZ2_ID,
--RATE,
--EFF_DATE,
--REPORT_TYPE
--)
--SELECT
--ID,
--REPORT_ID,
--DATA_TYPE,
--ARZ1_ID,
--ARZ2_ID,
--RATE,
--EFF_DATE,
--REPORT_TYPE
--FROM  DYNAMIC_LQ_day_TEHRAN.ARZ_PRD_DATA  where report_id=(select max(id) from reports where type=1 and status=2)  ;
--commit;
--DBMS_OUTPUT.PUT_LINE('ARZ_PRD_DATA');
------------------------------------
insert into REPORTS_ERROR (
ID,
REPORT_ID,
NODE_ID,
SEPORDE_TYPE,
TASHILAT_TYPE,
SHOBE_ID,
ARZ_ID,
DEP_BR_ERROR,
DEP_TYPE_ERROR,
LOAN_BR_ERROR,
LOAN_TYPE_ERROR,
GL_ERROR,
SUM_TYPE2,
SHAHR_ID,
OSTAN_ID,
REPORT_TYPE,
PARENT,
DEPTH
)
SELECT
 ID,
REPORT_ID,
NODE_ID,
SEPORDE_TYPE,
TASHILAT_TYPE,
SHOBE_ID,
ARZ_ID,
DEP_BR_ERROR,
DEP_TYPE_ERROR,
LOAN_BR_ERROR,
LOAN_TYPE_ERROR,
GL_ERROR,
SUM_TYPE2,
SHAHR_ID,
OSTAN_ID,
REPORT_TYPE,
PARENT,
DEPTH
FROM  DYNAMIC_LQ_day_TEHRAN.REPORTS_ERROR   where report_id=(select max(id) from reports where type=100 and status=2)  ;
commit;
DBMS_OUTPUT.PUT_LINE('REPORTS_ERROR');
-------------------------------
--insert into REPORTS_SETTING(
--ID,
--  REPORT_TYPE,
--  REPORT_NAME,
--  ARCHIVE_PERIOD,
--  ARCHIVE_PERIOD_MAX,
--  ARCHIVE_NUM_MAX
--)
--SELECT ID,
--  REPORT_TYPE,
--  REPORT_NAME,
--  ARCHIVE_PERIOD,
--  ARCHIVE_PERIOD_MAX,
--  ARCHIVE_NUM_MAX
--FROM  DYNAMIC_LQ_day_TEHRAN.REPORTS_SETTING  ;

-------------------------------------------
insert into BACK_TEST_ERROR(
 ID,
REPORT_ID,
NODE_ID,
SEPORDE_TYPE,
TASHILAT_TYPE,
SHOBE_ID,
ARZ_ID,
DEP_BR_ERROR,
DEP_TYPE_ERROR,
LOAN_BR_ERROR,
LOAN_TYPE_ERROR,
GL_ERROR,
SUM_TYPE2,
SHAHR_ID,
OSTAN_ID,
PARENT,
DEPTH,
REPORT_TYPE
)
SELECT 
ID,
REPORT_ID,
NODE_ID,
SEPORDE_TYPE,
TASHILAT_TYPE,
SHOBE_ID,
ARZ_ID,
DEP_BR_ERROR,
DEP_TYPE_ERROR,
LOAN_BR_ERROR,
LOAN_TYPE_ERROR,
GL_ERROR,
SUM_TYPE2,
SHAHR_ID,
OSTAN_ID,
PARENT,
DEPTH,
REPORT_TYPE
FROM  DYNAMIC_LQ_day_TEHRAN.BACK_TEST_ERROR  where report_id=(select max(id) from reports where type=100 and status=2)  ;
commit;
DBMS_OUTPUT.PUT_LINE('BACK_TEST_ERROR');
-------------------------------

-----------------------------------
--insert into NN_PARAM ( ID,
--  ERROR_FUNC,
--  ACTV_FUNC,
--  HIDDEN_SIZE,
--  VALID_CHECK_NUM,
--  LAG,
--  PRD_DAYS,
--  TRAIN_WINDOW,
--  VALIDATION,
--  TEST,
--  BACKTEST_NUM,
--  ACTIVE,
--  LAST_DATE
--)
--SELECT ID,
--  ERROR_FUNC,
--  ACTV_FUNC,
--  HIDDEN_SIZE,
--  VALID_CHECK_NUM,
--  LAG,
--  PRD_DAYS,
--  TRAIN_WINDOW,
--  VALIDATION,
--  TEST,
--  BACKTEST_NUM ,
--  ACTIVE,
--  LAST_DATE
--FROM  DYNAMIC_LQ_day_TEHRAN.NN_PARAM  ;
------------------------------------
--insert into NN_ACTV_FUNC_DETAILS(
--ID, NAME, CODE, DESCRIPTION )
--SELECT ID, NAME, CODE, DESCRIPTION FROM  DYNAMIC_LQ_day_TEHRAN.NN_ACTV_FUNC_DETAILS  ;
------------------------------------
--insert into NN_ERROR_FUNC_DETAILS (ID, NAME, CODE, DESCRIPTION )
--SELECT ID, NAME, CODE, DESCRIPTION FROM  DYNAMIC_LQ_day_TEHRAN.NN_ERROR_FUNC_DETAILS  ;
------------------------------------------------------
--insert into ARIMA_PARAM(ID,
--  P_DEQ,
--  Q_DEQ,
--  D_DEQ,
--  LAG,
--  PRD_DAYS,
--  TRAIN_WINDOW,
--  TEST,
--  BACKTEST_NUM
--)
--SELECT ID,
--  P_DEQ,
--  Q_DEQ,
--  D_DEQ,
--  LAG,
--  PRD_DAYS,
--  TRAIN_WINDOW,
--  TEST,
--  BACKTEST_NUM
--FROM  DYNAMIC_LQ_day_TEHRAN.ARIMA_PARAM  ;
--------------------------------------
--insert into EGARCH_PARAM ( ID,
--  P_DEQ,
--  Q_DEQ,
--  LAG,
--  PRD_DAYS,
--  TRAIN_WINDOW,
--  TEST,
--  BACKTEST_NUM
--)
--SELECT ID,
--  P_DEQ,
--  Q_DEQ,
--  LAG,
--  PRD_DAYS,
--  TRAIN_WINDOW,
--  TEST,
--  BACKTEST_NUM
--FROM  DYNAMIC_LQ_day_TEHRAN.EGARCH_PARAM  ;
-------------------------------------
--insert into TIME_SERIE_PARAM (
--ID,
--  ERROR_FUNC,
--  ACTV_FUNC,
--  HIDDEN_SIZE,
--  VALID_CHECK_NUM,
--  LAG,
--  PRD_DAYS,
--  TRAIN_WINDOW,
--  VALIDATION,
--  TEST,
--  BACKTEST_NUM
--)
--SELECT ID,
--  ERROR_FUNC,
--  ACTV_FUNC,
--  HIDDEN_SIZE,
--  VALID_CHECK_NUM,
--  LAG,
--  PRD_DAYS,
--  TRAIN_WINDOW,
--  VALIDATION,
--  TEST,
--  BACKTEST_NUM
--FROM  DYNAMIC_LQ_day_TEHRAN.TIME_SERIE_PARAM  ;
---------------------------------------
--insert into FIT_PARAM(
-- ID,
--  PRD_DAYS,
--  TRAIN_WINDOW,
--  TEST,
--  DEGREE,
--  LAG,
--  BACKTEST_NUM
--)
--SELECT ID,
--  PRD_DAYS,
--  TRAIN_WINDOW,
--  TEST,
--  DEGREE,
--  LAG,
--  BACKTEST_NUM
--FROM  DYNAMIC_LQ_day_TEHRAN.FIT_PARAM  ;

END INSERT_FROM_DAY_TEHRAN;
--------------------------------------------------------
--  DDL for Procedure PRC_AGGREGATION
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_AGGREGATION" ( INPAR_REF_REQ_ID IN NUMBER ) AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: morteza.sahi
  Editor Name:
  Release Date/Time:1396/07/29-10:00
  Edit Name:
  Version: 1
  Description: enteghal har code sarfasl dar har baze zamani be jadval aggrigation
               enteghal profile zamani be jadval repper
               tajmie daftar kol baraye har baze zamani dar repval
  */
  /*------------------------------------------------------------------------------*/
 VAR_REF_REPORT_ID          NUMBER;
 VAR_REF_LEDGER_PROFILE     NUMBER;
 VAR_REF_PROFILE_TIME       NUMBER;
 VAR_MAX_LEVEL_LEDGER       NUMBER;
 VAR_CNT_REF_PROFILE_TIME   NUMBER;
 VAR_DATE_INSERT            DATE;
BEGIN



      /******  ezefe kardane code sarfaslhaee ke da value nabode ba code meghdar "0"  *****--*/
-- INSERT INTO TBL_VALUE_TEMP ( node_id,MANDE,REF_TIMING_ID ) SELECT DISTINCT
--  B.LEDGER_CODE
-- ,0
-- ,A.REF_TIMING_ID
-- FROM pragg.TBL_LEDGER B
-- ,    (
--   SELECT
--    node_id
--   ,REF_TIMING_ID
--   FROM TBL_VALUE_TEMP
--  ) A
-- WHERE A.node_id <> B.LEDGER_CODE
--  AND
--   B.DEPTH   = 5;
--
-- COMMIT;
    /****** be dast avardane profil haye gozaresh mord niaz va bishtarin sathe daftar kol *****--*/
 SELECT
  REF_REPORT_ID
 INTO
  VAR_REF_REPORT_ID
 FROM pragg.TBL_REPREQ
 WHERE ID   = INPAR_REF_REQ_ID;

 SELECT
  LEDGER_PROFILE_ID
 INTO
  VAR_REF_LEDGER_PROFILE
 FROM REPORTS
 WHERE ID   = VAR_REF_REPORT_ID;

 SELECT
  TIMING_PROFILE_ID
 INTO
  VAR_REF_PROFILE_TIME
 FROM REPORTS
 WHERE ID   = VAR_REF_REPORT_ID;

 SELECT
  TO_NUMBER(MAX(DEPTH) )
 INTO
  VAR_MAX_LEVEL_LEDGER
 FROM pragg.TBL_LEDGER_PROFILE_DETAIL
 WHERE REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE;

 SELECT
  SYSDATE
 INTO
  VAR_DATE_INSERT
 FROM DUAL;
  /*--------------TBL_REPPER-----------------*/
  /******enteghal profile zamani be jadval repper*****--*/
  /*-----------------------------------------*/

 INSERT INTO pragg.TBL_REPPER (
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
 ,VAR_REF_REPORT_ID
 ,ID
 ,INPAR_REF_REQ_ID
 FROM pragg.TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = VAR_REF_PROFILE_TIME;

 COMMIT;
  /*-----------------------------------------*/
   /******tajmie daftar kol baraye har baze zamani dar repval (enteghale barghaye tajmie shode be repval)*****--*/
  /*-----------------------------------------*/
-- INSERT INTO pragg.TBL_REPVAL (
--  REF_REPREQ_ID
-- ,REF_REPPER_ID
-- ,LEDGER_CODE
-- ,VALUE
-- ,PARENT_CODE
-- ,DEPTH
-- ,NAME
-- ) SELECT
--  INPAR_REF_REQ_ID
-- ,(
--   SELECT
--    ID
--   FROM pragg.TBL_REPPER
--   WHERE OLD_ID          = TVA.REF_TIMING_ID
--    AND
--     REF_REPORT_ID   = VAR_REF_REPORT_ID
--    AND
--     REF_REQ_ID      = INPAR_REF_REQ_ID
--  ) AS REF_TIMING_ID
-- ,TVA.node_id
-- ,TVA.mande
-- ,TLPD.PARENT_CODE
-- ,VAR_MAX_LEVEL_LEDGER
-- ,TLPD.NAME
-- FROM TBL_VALUE_TEMP TVA
-- ,    pragg.TBL_LEDGER_PROFILE_DETAIL TLPD
-- WHERE TLPD.CODE                 = TVA.node_id
--  AND
--   TLPD.REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE;


INSERT INTO pragg.TBL_REPVAL (
  REF_REPREQ_ID
 ,REF_REPPER_ID
 ,LEDGER_CODE
 ,VALUE
 ,PARENT_CODE
 ,DEPTH
 ,NAME
 )
 SELECT INPAR_REF_REQ_ID,
1 AS REF_TIMING_ID,
  TVA.NODE_ID,
  TVA.MANDE,
  TLPD.PARENT_CODE,
  VAR_MAX_LEVEL_LEDGER,
  TLPD.NAME
FROM REPORTS_DATA   TVA
 ,    pragg.TBL_LEDGER_PROFILE_DETAIL TLPD
 WHERE TLPD.CODE                 = TVA.node_id
  AND
   TLPD.REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE;






 COMMIT;
  /*-----------------------------------------*/
     /******tajmie daftar kol baraye har baze zamani dar repval barasas daftar kole taen shode *****--*/
  /*-----------------------------------------*/
 FOR I IN REVERSE 1..VAR_MAX_LEVEL_LEDGER LOOP
  INSERT INTO pragg.TBL_REPVAL (
   REF_REPREQ_ID
  ,REF_REPPER_ID
  ,LEDGER_CODE
  ,VALUE
  ,PARENT_CODE
  ,DEPTH
  ) SELECT DISTINCT
   INPAR_REF_REQ_ID
  ,A.REF_REPPER_ID
  ,B.CODE
  ,NVL(A.VALUE,0)
  ,B.PARENT_CODE
  ,I
  FROM (
    SELECT
     MAX(TR.REF_REPREQ_ID) AS REF_REPREQ_ID
    ,TR.REF_REPPER_ID
    ,TR.PARENT_CODE AS CODE
    ,SUM(NVL(TR.VALUE,0) ) AS VALUE
    ,MAX(TLPD.PARENT_CODE) AS PARENT_CODE
    FROM pragg.TBL_REPVAL TR
     LEFT JOIN pragg.TBL_LEDGER_PROFILE_DETAIL TLPD ON TLPD.CODE   = TR.PARENT_CODE
    WHERE TLPD.DEPTH                = I
     AND
      TLPD.REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE
    GROUP BY
     TR.PARENT_CODE
    ,TR.REF_REPPER_ID
   ) A
   RIGHT JOIN (
    SELECT
     *
    FROM pragg.TBL_LEDGER_PROFILE_DETAIL
    WHERE DEPTH                = I
     AND
      REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE
   ) B ON A.CODE   = B.CODE;

  COMMIT;
 END LOOP;

     /******peyda kardan parent akharin daftarkol estefade  shode*****--*/

 SELECT
  COUNT(*) + 1
 INTO
  VAR_CNT_REF_PROFILE_TIME
 FROM pragg.TBL_REPPER
 WHERE REF_REPORT_ID   = VAR_REF_REPORT_ID;
       /******hazf kardan node haye ke eshtebah vard shodan(bedone zaman hastand)*****--*/

 DELETE FROM (
  SELECT
   *
  FROM pragg.TBL_REPVAL
  WHERE LEDGER_CODE IN (
    SELECT
     LEDGER_CODE
    FROM pragg.TBL_REPVAL
    GROUP BY
     LEDGER_CODE
    HAVING COUNT(*) = VAR_CNT_REF_PROFILE_TIME
   )
 ) WHERE REF_REPPER_ID IS NULL;

 COMMIT;

   /******ezafe kardane name code sarfaslha baraye jologiri az join ezafe dar namayesh gozaresh*****--*/
 UPDATE pragg.TBL_REPVAL T
  SET
   T.NAME = (
    SELECT
     NAME
    FROM pragg.TBL_LEDGER_PROFILE_DETAIL
    WHERE pragg.TBL_LEDGER_PROFILE_DETAIL.REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE
     AND
      pragg.TBL_LEDGER_PROFILE_DETAIL.CODE                 = T.LEDGER_CODE
   )
 WHERE T.REF_REPREQ_ID   = INPAR_REF_REQ_ID;

 COMMIT;
  /*-----------------------------------------*/
  /*-----------------------------------------*/
END PRC_AGGREGATION;
--------------------------------------------------------
--  DDL for Procedure PRC_CREATE_REPORT_REQUEST
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_CREATE_REPORT_REQUEST" (
 INPAR_REPORT_ID   IN NUMBER
 ,INPAR_USER_ID     IN VARCHAR2
 ,INPAR_NOTIF_ID    IN NUMBER
 ,OUTPAR_RES        OUT NUMBER
) AS
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name: 
  Version: 1
  Description:darkhast baray ijad yek gozaresh jadid
  gozareshate 103-105-104-106-107
  */
  /*------------------------------------------------------------------------------*/
 VAR_REP_REQ_ID        NUMBER;
 VAR_NOTIF_ID          VARCHAR2(50);
 VAR_REPPER_DATE       DATE;
 VAR_INPAR_REPORT_ID   NUMBER;
 var_out_back_test     number;
 var_type number;
 var_cnt number;
BEGIN

 SELECT
    TYPE
    into var_type
   FROM REPORTS
   WHERE ID   = INPAR_REPORT_ID;

select count(*) into var_cnt  from tbl_rep_req where report_id=INPAR_REPORT_ID  and trunc(REQ_DATE)=trunc(sysdate);

if(var_cnt=0) then

 INSERT INTO TBL_REP_REQ (
  REPORT_ID
 ,REF_USER_ID
 ,REQ_DATE
 ,TYPE
 ,CATEGORY
 ,NAME
 ,ORIGINAL_ID
 ) VALUES (
  INPAR_REPORT_ID
 ,INPAR_USER_ID
 ,SYSDATE
 ,(
   SELECT
    REPORTER_TYPE
   FROM REPORTS
   WHERE ID   = INPAR_REPORT_ID
  )
 ,(
   SELECT
    TYPE
   FROM REPORTS
   WHERE ID   = INPAR_REPORT_ID
  )
 ,(
   SELECT
    NAME
   FROM REPORTS
   WHERE ID   = INPAR_REPORT_ID
  )
  ,(select original_id  FROM REPORTS
   WHERE ID   = INPAR_REPORT_ID)
 );

 COMMIT;
  /*ejra prasijer baray filter kardan dadeh hay gozersh*/
 PRC_REPORT_VALUE(INPAR_REPORT_ID);
  /*berozresani vaziat gozaresh be payan yafte dar jadval darkhastha */
 SELECT
  MAX(ID)
 INTO
  VAR_REP_REQ_ID
 FROM TBL_REP_REQ;

 COMMIT;
 --dar gozaresh 109 (rosub) backtest nadarim
 if(var_type!=109) then
 PRC_REPORT_VALUE_back_test (INPAR_REPORT_ID,var_out_back_test);
 end if;

commit;
  /*berozresani elanat  pas az sakhte shodane gozaresh procedure zir be manzure elam shodane tamam shodan gozaresh farakhani mishavad*/  
 pragg.PRC_NOTIFICATION(
  'update'
 ,INPAR_NOTIF_ID
 ,''
 ,''
 ,''
 ,'finished'
 ,0
 ,''
 ,0
 ,VAR_REP_REQ_ID
 ,''
 ,0
 ,VAR_NOTIF_ID
 );

  /*khoroji alaki*/

 OUTPAR_RES   := VAR_NOTIF_ID;
 
 end if;
 
END PRC_CREATE_REPORT_REQUEST;
--------------------------------------------------------
--  DDL for Procedure PRC_CREATE_REPORT_REQUEST_GAP
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_CREATE_REPORT_REQUEST_GAP" (
 INPAR_REPORT_ID   IN NUMBER
 ,INPAR_USER_ID     IN VARCHAR2
 ,INPAR_NOTIF_ID    IN NUMBER
 ,OUTPAR_RES        OUT NUMBER
) AS
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name:sobhan
  Editor Name:
  Release Date/Time:1396/08/20-10:00
  Edit Name:
  Version: 1
  Description:darkhast baray ijad yek gozaresh shekaf  jadid
  gozareshate 170 - 180
  */
  /*------------------------------------------------------------------------------*/
 VAR_REP_REQ_ID        NUMBER;
 VAR_NOTIF_ID          VARCHAR2(50);
 VAR_REPPER_DATE       DATE;
 VAR_INPAR_REPORT_ID   NUMBER;
 var_cnt NUMBER;
BEGIN

select count(*) into var_cnt  from tbl_rep_req where report_id=INPAR_REPORT_ID  and trunc(REQ_DATE)=trunc(sysdate);

if(var_cnt=0) then


 INSERT INTO TBL_REP_REQ (
  REPORT_ID
 ,REF_USER_ID
 ,REQ_DATE
 ,TYPE
 ,CATEGORY
 ,NAME
 ,original_id
 ) VALUES (
  INPAR_REPORT_ID
 ,INPAR_USER_ID
 ,SYSDATE
 ,(
   SELECT
    REPORTER_TYPE
   FROM REPORTS
   WHERE ID   = INPAR_REPORT_ID
  )
 ,(
   SELECT
    TYPE
   FROM REPORTS
   WHERE ID   = INPAR_REPORT_ID
  )
 ,(
   SELECT
    NAME
   FROM REPORTS
   WHERE ID   = INPAR_REPORT_ID
  )
  ,(select original_id  FROM REPORTS
   WHERE ID   = INPAR_REPORT_ID)
 );

 COMMIT;

  /*ejra prasijer baray filter kardan dadeh hay gozersh*/
 PRC_REPORT_VALUE_GAP(INPAR_REPORT_ID);
  /*berozresani vaziat gozaresh be payan yafte dar jadval darkhastha */
--  SELECT MAX(id) INTO VAR_REP_REQ_ID FROM tbl_rep_req_gap;
  SELECT MAX(id) INTO VAR_REP_REQ_ID FROM tbl_rep_req;
  
 COMMIT;


  /*berozresani elanat  pas az sakhte shodane gozaresh procedure zir be manzure elam shodane tamam shodan gozaresh farakhani mishavad*/  
 pragg.PRC_NOTIFICATION(
  'update'
 ,INPAR_NOTIF_ID
 ,''
 ,''
  ,''
 ,'finished'
 ,0
 ,''
 ,0
 ,VAR_REP_REQ_ID
 ,''
 ,0
 ,VAR_NOTIF_ID
 );

  /*khoroji alaki*/

 OUTPAR_RES   := VAR_NOTIF_ID;
 
  end if;
END PRC_CREATE_REPORT_REQUEST_GAP;
--------------------------------------------------------
--  DDL for Procedure PRC_DELETE_ARCHIVE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_DELETE_ARCHIVE" 
(
  INPAR_REP_REQ_ID IN NUMBER 
, OUT_PAR OUT VARCHAR2 
) AS 
var_CATEGORY number;
BEGIN
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: az in prc baraye pak kardane archive astefade mishavad.
  
  */
  /*------------------------------------------------------------------------------*/
select CATEGORY into var_CATEGORY from TBL_REP_REQ where ID=INPAR_REP_REQ_ID;

if(var_CATEGORY=107 or var_CATEGORY=108 or var_CATEGORY=109 or var_CATEGORY=103 or var_CATEGORY=105  or var_CATEGORY=104  or var_CATEGORY=106)  then 
 DELETE FROM TBL_REP_REQ WHERE ID   = INPAR_REP_REQ_ID;

 COMMIT;
 DELETE FROM TBL_VALUE_TEMP WHERE REQ_ID   = INPAR_REP_REQ_ID;
 DELETE FROM TBL_VALUE WHERE REQ_ID   = INPAR_REP_REQ_ID;

 delete from TBL_BACK_TEST_ARCHIVE where  REQ_ID   = INPAR_REP_REQ_ID;
 delete from TBL_VALUE_TEMP_BACK_TEST where  REQ_ID   = INPAR_REP_REQ_ID;

 COMMIT;

elsif(var_CATEGORY=170 or var_CATEGORY=180) then 
 DELETE FROM TBL_REP_REQ WHERE ID   = INPAR_REP_REQ_ID;  
 DELETE FROM TBL_VALUE_TEMP_gap WHERE REQ_ID   = INPAR_REP_REQ_ID;
 DELETE FROM TBL_VALUE_gap WHERE REQ_ID   = INPAR_REP_REQ_ID;

 COMMIT;
 
 end if ;
 
 delete from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID;
 delete from PRAGG.TBL_NOTIFICATIONS where REF_REPREQ=INPAR_REP_REQ_ID;
 delete from tbl_gap where req_id=INPAR_REP_REQ_ID;
 COMMIT;
 
 -------------------------------
-- DELETE FROM TBL_REP_REQ ;
-- COMMIT;
-- DELETE FROM TBL_VALUE_TEMP;
-- DELETE FROM TBL_VALUE ;
--delete from TBL_BACK_TEST_ARCHIVE ;
-- delete from TBL_VALUE_TEMP_BACK_TEST;
-- COMMIT;
-- DELETE FROM TBL_VALUE_TEMP_gap ;
-- DELETE FROM TBL_VALUE_gap ;
-- COMMIT;
-- delete from tbl_ledger_branch;

 -----------------
 
 OUT_PAR   := 0;
END PRC_DELETE_ARCHIVE;
--------------------------------------------------------
--  DDL for Procedure PRC_TRANSFER_TIMING_VALUE_GAP
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_TRANSFER_TIMING_VALUE_GAP" ( INPAR_REPORT_ID IN VARCHAR2 ) AS

 VAR_QUERY        VARCHAR2(30000);
 VAR_ORGINAL_ID   NUMBER;
 VAR_LEDGER       NUMBER;
 VAR_MAX_LEVEL    NUMBER;
 VAR_CURRENCY     NUMBER;
 ID_TIMING        NUMBER;
 VAR_REQ          NUMBER;
 DATE_TYPE1       NUMBER := TO_CHAR(TO_DATE(sysdate),'J'); /* to_cHAR(sysdate,'J');  */
BEGIN
 SELECT
  MAX(ID)
 INTO
  VAR_REQ
-- FROM TBL_REP_REQ_gap
 FROM TBL_REP_REQ
 WHERE REPORT_ID   = INPAR_REPORT_ID;

 SELECT
  TIMING_PROFILE_ID
 INTO
  ID_TIMING
 FROM REPORTS
 WHERE ID   = INPAR_REPORT_ID;

 SELECT
  LEDGER_PROFILE_ID
 INTO
  VAR_LEDGER
 FROM REPORTS
 WHERE ID   = INPAR_REPORT_ID;

 FOR I IN (
  SELECT
   TTPD.ID
  ,TTP.TYPE
  ,TTPD.PERIOD_NAME
  ,TTPD.PERIOD_DATE
  ,TTPD.PERIOD_START
  ,TTPD.PERIOD_END
  ,TTPD.PERIOD_COLOR
  FROM PRAGG.TBL_TIMING_PROFILE TTP
  ,    PRAGG.TBL_TIMING_PROFILE_DETAIL TTPD
  WHERE TTP.ID   = TTPD.REF_TIMING_PROFILE
   AND
    TTP.ID   = ID_TIMING
    order by TTPD.ID
 ) LOOP
  IF
   ( I.TYPE = 1 )
  THEN/******agar profile zamani entekhab shode bazehee bashad *****--*/
   SELECT
    'INSERT INTO TBL_VALUE_gap (
 REQ_ID
 ,DATA_TYPE
 ,NODE_ID
 ,ARZ_ID
 ,MANDE
 ,EFF_DATE
 ,DEPTH
 ,PARENT
 ,BRANCH_ID
 ,ref_timing
)  SELECT
 REQ_ID
 ,DATA_TYPE
 ,NODE_ID
 ,ARZ_ID
 ,MANDE
 ,EFF_DATE
 ,DEPTH
 ,PARENT
 ,BRANCH_ID,
' ||
    I.ID ||
    '
FROM TBL_VALUE_TEMP_gap
where REQ_ID =' ||
    VAR_REQ ||
    '  and DATA_TYPE =3 and
 EFF_DATE > ' ||
    DATE_TYPE1 ||
    '
    and EFF_DATE <= ' ||
    DATE_TYPE1 ||
    '+' ||
    I.PERIOD_DATE ||
    '  ;'
   INTO
    VAR_QUERY
   FROM DUAL;

--   DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
   EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
   COMMIT;
   DATE_TYPE1   := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
  ELSE /******agar profile zamani entekhab shode tarikhi bashad *****--*/
   SELECT
    'INSERT INTO TBL_VALUE_gap (
 REQ_ID
 ,DATA_TYPE
 ,NODE_ID
 ,ARZ_ID
 ,MANDE
 ,EFF_DATE
 ,DEPTH
 ,PARENT
 ,BRANCH_ID
 ,ref_timing
)  SELECT
 REQ_ID
 ,DATA_TYPE
 ,NODE_ID
 ,ARZ_ID
 ,MANDE
 ,EFF_DATE
 ,DEPTH
 ,PARENT 
 ,BRANCH_ID,
' ||
    I.ID ||
    '
FROM TBL_VALUE_TEMP_gap
where REQ_ID =' ||
    VAR_REQ ||
    '  and DATA_TYPE =3 and EFF_DATE > to_char(to_date(''' ||
    I.PERIOD_START ||
    '''),''j'') and  EFF_DATE <= to_char(to_date (''' ||
    I.PERIOD_END ||
    '''),''j'') ;'
   INTO
    VAR_QUERY
   FROM DUAL;

--   DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
   EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
   COMMIT;
  END IF;
 END LOOP;

 COMMIT;
 
 update tbl_rep_req set is_finish=1 where id=VAR_REQ;
 commit;
 
END PRC_TRANSFER_TIMING_VALUE_GAP;
--------------------------------------------------------
--  DDL for Procedure PRC_ENTEGHAL_DEPOSIT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_ENTEGHAL_DEPOSIT" AS 
var date;
var_max_effdate date;
var_cnt number;
BEGIN
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: az in prc baraye enteghaye seporde ha be surete ruzane jahate estefade dar gozaresh rosub seporde estefade mishavad
  
  */
  /*------------------------------------------------------------------------------*/
 
 --for i in (select distinct(effdate) from DADEKAVAN_DAY.DEPOSIT  ) loop
-- dynamic_lq.PRC_J_TRANSFER_DEPOSIT ( i.effdate );
--  commit;
 -- end loop;
 
 select COUNT(*) into var_cnt from AKIN.TBL_DEPOSIT where ROWNUM<2 ;
 
 if(var_cnt !=0) then
 
 insert into DYNAMIC_LQ.tbl_deposit
 (
 DEP_ID,
REF_DEPOSIT_TYPE,
REF_BRANCH,
REF_CUSTOMER,
DUE_DATE,
BALANCE,
OPENING_DATE,
RATE,
MODALITY_TYPE,
REF_DEPOSIT_ACCOUNTING,
REF_CURRENCY,
REF_RATE,
EFFDATE
 )
 (select 
 DEP_ID,
REF_DEPOSIT_TYPE,
REF_BRANCH,
REF_CUSTOMER,
DUE_DATE,
BALANCE,
OPENING_DATE,
RATE,
MODALITY_TYPE,
REF_DEPOSIT_ACCOUNTING,
REF_CURRENCY,
REF_RATE,
sysdate
from AKIN.TBL_DEPOSIT
 );
 ----------------
 PRC_HOMOGENEOUS_DEPOSIT;
 --------------
 
end if; 
 
 
 
 

END PRC_ENTEGHAL_DEPOSIT;
--------------------------------------------------------
--  DDL for Procedure PRC_ENTEGHAL_TO_DYNAMIC
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_ENTEGHAL_TO_DYNAMIC" 
AS
VAR_MAX_DATE_SEPORDE number;
VAR_MAX_DATE_TASHILAT   number;

BEGIN

select case when  max(to_char(eff_date,'j')) is null then '0' else max(to_char(eff_date,'j')) end  INTO VAR_MAX_DATE_SEPORDE from seporde_shobe_mande;
select case when  max(to_char(eff_date,'j')) is null then '0' else max(to_char(eff_date,'j')) end   INTO VAR_MAX_DATE_TASHILAT from tashilat_shobe_mande;
--
--  EXECUTE IMMEDIATE 'truncate table DYNAMIC_LQ.SEPORDE_TYPE_MANDE';
--  EXECUTE IMMEDIATE 'truncate table DYNAMIC_LQ.TASHILAT_SHOBE_MANDE';
--  EXECUTE IMMEDIATE 'truncate table DYNAMIC_LQ.SEPORDE_SHOBE_MANDE';
--  EXECUTE IMMEDIATE 'truncate table DYNAMIC_LQ.TASHILAT_TYPE_MANDE ';
  EXECUTE IMMEDIATE 'ALTER SESSION FORCE PARALLEL DML';
commit;
-- bar asase sakhtare jadid va ruzane (akin)

--   INSERT
--    /*+   PARALLEL(auto) */
--  INTO DYNAMIC_LQ.SEPORDE_TYPE_MANDE
--    (
--      SEPORDE_TYPE,
--      ARZ_ID,
--      MANDE,
--      EFF_DATE
--    )
--  SELECT
--   REF_DEPOSIT_TYPE,
--   REF_CURRENCY,
--   sum(balance),
--   to_char(sysdate,'j')
--  FROM AKIN.TBL_DEPOSIT  
--    group by REF_DEPOSIT_TYPE,REF_CURRENCY;
--    COMMIT;
--------------------------------------------------------  
--    INSERT
--    /*+   PARALLEL(auto) */
--  INTO DYNAMIC_LQ.SEPORDE_SHOBE_MANDE
--    (
--      SHOBE_ID,
--      ARZ_ID,
--      MANDE,
--      EFF_DATE,
--      OSTAN,
--      shahr
--    )
--select a.*,b.REF_STA_ID,b.REF_CTY_ID from 
--  (SELECT
--   REF_BRANCH,
--   REF_CURRENCY,
--   sum(balance),
--   to_char(sysdate,'j')
--  FROM AKIN.TBL_DEPOSIT  
--    group by REF_BRANCH,REF_CURRENCY)a,
--      pragg.tbl_branch b
--  where a.ref_branch=b.brn_id;
--    COMMIT;
--------------------------------------------------------------  
--  INSERT
--    /*+   PARALLEL(auto) */
--  INTO DYNAMIC_LQ.TASHILAT_TYPE_MANDE
--    (
--      TASHILAT_TYPE,
--      arz_id,
--      MANDE,
--      EFF_DATE
--    )
--  SELECT 
--    l.REF_LOAN_TYPE,
--    l.REF_CURRENCY,
--    sum(lp.PROFIT_AMOUNT),
--     to_char(sysdate,'j')
--     from akin.TBL_LOAN l,akin.TBL_LOAN_PAYMENT lp
--     where l.LON_ID=lp.REF_LON_ID
--     and lp.due_date > sysdate
--     group by l.REF_LOAN_TYPE,l.REF_CURRENCY;
--    
--    COMMIT;
---------------------------------------------------------------------------
--  INSERT
--    /*+   PARALLEL(auto) */
--  INTO DYNAMIC_LQ.TASHILAT_SHOBE_MANDE
--    (
--      SHOBE_ID,
--      ARZ_ID,
--      MANDE,
--      EFF_DATE,
--      ostan,
--      shahr
--    )
--(select a.*,b.REF_STA_ID,b.REF_CTY_ID from 
-- ( SELECT    l.ref_branch,
--    l.REF_CURRENCY,
--    sum(lp.PROFIT_AMOUNT),
--     to_char(sysdate,'j')
--     from akin.TBL_LOAN l,akin.TBL_LOAN_PAYMENT lp
--     where l.LON_ID=lp.REF_LON_ID
--   and lp.due_date > sysdate
--    group by l.REF_CURRENCY,ref_branch)a,
--      pragg.tbl_branch b
--  where a.ref_branch=b.brn_id);
--  commit;
  -------------------------------------------------------------------------------------------------------------
  -------------------------------------------------------------------------
  -------------------------------------------------------------------------
  -----------------------------------------------------------------------
  --max(effdate)  2457579
  --++599
    INSERT
    /*+   PARALLEL(auto) */
  INTO DYNAMIC_LQ.SEPORDE_TYPE_MANDE
    (
      SEPORDE_TYPE,
      ARZ_ID,
      MANDE,
      EFF_DATE,
      shahr,
      ostan,
      SHOBE
    )
 select a.SEPORDE_TYPE,a.CUR_ID,a.mande,a.eff_date,b.REF_CTY_ID,b.REF_STA_ID,b.BRN_ID from (
 
 SELECT SUBSTR(L.PRODUCTTYPECOD,3,4) as SEPORDE_TYPE,
   cur.CUR_ID,
    SUM(l.balance_endday) as mande,
   to_char(L.EFFDATE,'j') as EFF_DATE,
   max(l.BR_CODE+10000) as BR_CODE
  FROM dadekavan_day.DEPOSIT  l,
    PRAGG.TBL_CURRENCY cur
  WHERE cur.SWIFT_CODE = l.CURR_COD
 AND to_char(TRUNC(L.EFFDATE),'j') > VAR_MAX_DATE_SEPORDE
  GROUP BY SUBSTR(L.PRODUCTTYPECOD,3,4),
    cur.CUR_ID,
    l.EFFDATE)a,
    pragg.tbl_branch b
    where a.BR_CODE=b.brn_id;
    COMMIT;
    
delete from SEPORDE_TYPE_MANDE where 
SEPORDE_TYPE||arz_id in (
select SEPORDE_TYPE||arz_id from (
SELECT distinct count(eff_date) cnt,ARZ_ID,SEPORDE_TYPE FROM  SEPORDE_TYPE_MANDE GROUP BY SEPORDE_TYPE,ARZ_ID
)where cnt<30);
  commit;
  -----------------------------------
  INSERT
    /*+   PARALLEL(auto) */
  INTO DYNAMIC_LQ.SEPORDE_SHOBE_MANDE
    (
      SHOBE_ID,
      ARZ_ID,
      MANDE,
      EFF_DATE,
      SHAHR,
      OSTAN
    )
 select a.BR_CODE,a.CUR_ID,a.mande,a.eff_date,b.REF_CTY_ID,b.REF_STA_ID from (

 SELECT l.BR_CODE+10000 as BR_CODE,
     cur.CUR_ID,
    SUM(l.balance_endday) as mande,
    to_char(L.EFFDATE,'j') as eff_date
  FROM dadekavan_day.DEPOSIT  l,
    PRAGG.TBL_CURRENCY cur
  WHERE cur.SWIFT_CODE = l.CURR_COD
 AND to_char(TRUNC(L.EFFDATE),'j') > VAR_MAX_DATE_SEPORDE
  GROUP BY l.BR_CODE,
     cur.CUR_ID,
    l.EFFDATE)a,
    pragg.tbl_branch b
    where a.BR_CODE=b.brn_id;
 commit;
 
 delete from SEPORDE_SHOBE_MANDE where 
SHOBE_ID||arz_id in (
select SHOBE_ID||arz_id from (
SELECT distinct count(eff_date) cnt,ARZ_ID,SHOBE_ID FROM  SEPORDE_SHOBE_MANDE GROUP BY SHOBE_ID,ARZ_ID
)where cnt<30);
  commit;
 -------------------------------
 INSERT
    /*+   PARALLEL(auto) */
  INTO DYNAMIC_LQ.TASHILAT_TYPE_MANDE
    (
      TASHILAT_TYPE,
      arz_id,
      MANDE,
      EFF_DATE,
      SHAHR,
      OSTAN,
      SHOBE
    )
 select c.tashilat_id,c.CUR_ID,c.ghest_mande,c.eff_date,brn.REF_CTY_ID,brn.REF_STA_ID,brn.BRN_ID         from 

( SELECT SUBSTR(l.producttypecode,3,4) as tashilat_id,
    a.CUR_ID,
    SUM(p.PAY_AMOUNT) AS ghest_mande,
    to_char(L.EFFDATE,'j') as eff_date,
    max(p.ABRNCHCOD)+10000 as ABRNCHCOD
  FROM dadekavan_day.PAYMENT  p
  JOIN dadekavan_day.LOAN  l
  ON P.abrnchcod
    || P.lnminortp
    || P.cfcifno
    || P.crserial = L.abrnchcod
    || L.lnminortp
    || L.cfcifno
    || L.crserial
  LEFT JOIN  PRAGG.TBL_CURRENCY  a
  ON l.acurrcode = a.SWIFT_CODE
 WHERE to_char(TRUNC(L.EFFDATE),'j') > VAR_MAX_DATE_TASHILAT
  GROUP BY SUBSTR(l.producttypecode,3,4),
    a.CUR_ID,
    L.EFFDATE)c,
    pragg.tbl_branch brn
    
    where c.ABRNCHCOD=brn.BRN_ID;
  commit;
  
   delete from TASHILAT_TYPE_MANDE where 
TASHILAT_TYPE||arz_id in (
select TASHILAT_TYPE||arz_id from (
SELECT distinct count(eff_date) cnt,ARZ_ID,TASHILAT_TYPE FROM  TASHILAT_TYPE_MANDE GROUP BY TASHILAT_TYPE,ARZ_ID
)where cnt<30);
  commit;
----------------------------------------------------------------------------------  
  
    INSERT
    /*+   PARALLEL(auto) */
  INTO DYNAMIC_LQ.TASHILAT_SHOBE_MANDE
    (
      SHOBE_ID,
      ARZ_ID,
      MANDE,
      EFF_DATE,
      SHAHR,
      OSTAN
    )
 select c.abrnchcod,c.CUR_ID,c.ghest_mande,c.eff_date,brn.REF_CTY_ID,brn.REF_STA_ID         from 

 (SELECT l.abrnchcod+10000 as abrnchcod,
    a.CUR_ID,
    SUM(p.PAY_AMOUNT) AS ghest_mande,
     to_char(L.EFFDATE,'j') as eff_date
  FROM DADEKAVAN_DAY.PAYMENT  p
  JOIN DADEKAVAN_DAY.LOAN  l
  ON P.abrnchcod
    || P.lnminortp
    || P.cfcifno
    || P.crserial = L.abrnchcod
    || L.lnminortp
    || L.cfcifno
    || L.crserial
  LEFT JOIN  PRAGG.TBL_CURRENCY  a
  ON l.acurrcode = a.SWIFT_CODE
    WHERE to_char(TRUNC(L.EFFDATE),'j') > VAR_MAX_DATE_TASHILAT
  GROUP BY l.abrnchcod,
    a.CUR_ID,
    L.EFFDATE
    ) c,
    pragg.tbl_branch brn
    where c.ABRNCHCOD=brn.BRN_ID;
    
  commit;
  
    delete from TASHILAT_SHOBE_MANDE where 
SHOBE_ID||arz_id in (
select SHOBE_ID||arz_id from (
SELECT distinct count(eff_date) cnt,ARZ_ID,SHOBE_ID FROM  TASHILAT_SHOBE_MANDE GROUP BY SHOBE_ID,ARZ_ID
)where cnt<30);
  commit;
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
  ------------------------------------------------------------------------------
 
    
END;
--------------------------------------------------------
--  DDL for Procedure PRC_HOMOGENEOUS_DEPOSIT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_HOMOGENEOUS_DEPOSIT" AS 
max_effdate date;
max_effdate1 date;
var  varchar2(2000);
var1  varchar2(2000);
var_count_due_date number;
max_effdate_type date;


 /*
  Programmer Name: sobhan sadeghzadeh
  Release Date/Time:
  Version:
  Category: 
  Description: 
  dynamic_lq.TBL_DEPOSIT_HOMOGENEOUS : dadeheye ruze ghabl  --sum(balance)  GROUP BY ref_branch, REF_CURRENCY, EFFDATE
  dynamic_lq.tbl_deposit          : dadeheye tamame ruzha
  DYNAMIC_LQ.HOMOGENEOUS_DEPOSIT  : meghdare input va output dadehae emruz va diruz dar in jadvale insert mishavad 
  */
BEGIN
--------------------------------------------------------------------------------------------------------
--EXECUTE IMMEDIATE 'truncate TBL_DEPOSIT_HOMOGENEOUS ';
--EXECUTE IMMEDIATE 'truncate DYNAMIC_LQ.HOMOGENEOUS_DEPOSIT ';
--EXECUTE IMMEDIATE 'truncate DYNAMIC_LQ.HOMOGENEOUS_DEPOSIT_ACCOUNTING ';
--or    delete kardane hameye dade ha be joz dade haye ruze ghabl
select max(effdate) into  max_effdate1 from TBL_DEPOSIT_HOMOGENEOUS; 
delete from TBL_DEPOSIT_HOMOGENEOUS where trunc(effdate) !=trunc(max_effdate1) ;
--------------------------------------------------------------------------------------------------------

for i in (select * from TBL_TYPE_HOMEGENEOUS) loop
-------------------------------------------------------------------------
--faghat dade haye ruze akhar(sysdate) az  dynamic_lq.tbl_DEPOSIT 
var:='  insert into TBL_DEPOSIT_HOMOGENEOUS (
  BRANCH_ID,
  CURRENCY,
  EFFDATE,
  MANDE,
  CATEGORI_ID,
  CATEGORY_NAME
  )
  (
  SELECT ref_branch,
  REF_CURRENCY,
  EFFDATE,
  SUM(BALANCE),'
  ||''''||i.id||''''||','
  ||''''||i.NAME||''''||'
FROM dynamic_lq.tbl_DEPOSIT
WHERE TRUNC(due_date)'|| i.HOMEGENEOUS||' and EFFDATE is not null and trunc(effdate)=trunc(sysdate)
GROUP BY ref_branch,
  REF_CURRENCY,
  EFFDATE)';
--or ------------------------------------------------------------------------  
--  var:='  insert into TBL_DEPOSIT_HOMOGENEOUS (
--  BRANCH_ID,
--  CURRENCY,
--  EFFDATE,
--  MANDE,
--  CATEGORI_ID,
--  CATEGORY_NAME
--  )
--  (
--  SELECT ref_branch,
--  REF_CURRENCY,
--  EFFDATE,
--  SUM(BALANCE),'
--  ||''''||i.id||''''||','
--  ||''''||i.NAME||''''||'
--FROM dynamic_lq.tbl_DEPOSIT
--WHERE TRUNC(due_date)'|| i.HOMEGENEOUS||' and EFFDATE is not null
--GROUP BY ref_branch,
--  REF_CURRENCY,
--  EFFDATE)';
  
  EXECUTE IMMEDIATE var;
  commit;
  
  end loop;
  
  -----------------------------------------------------------------------------------------
delete from  TBL_DEPOSIT_HOMOGENEOUS where BRANCH_ID  in (
select distinct(BRANCH_ID) from (
select 
count(EFFDATE) as cnt,
BRANCH_ID,
CURRENCY,
CATEGORI_ID
from TBL_DEPOSIT_HOMOGENEOUS group by BRANCH_ID,CURRENCY,CATEGORI_ID
)where cnt<30
);
commit;
-----------------------------------------------------------------------------------------------------------------------
--faghat dadehaye emruz va diruz dar TBL_DEPOSIT_HOMOGENEOUS mojud mibashad
insert into DYNAMIC_LQ.HOMOGENEOUS_DEPOSIT (
BRANCH_ID,
CITY_ID,
CITY_NAME,
STA_ID,
STA_NAME,
CATEGORY_id,
CATEGORY,
INPUT_BALANCE,
OUTPU_BALANCE,
MANDE,
EFF_DATE,
arz_id 
)
select
BRANCH_ID,
REF_CTY_ID,
CITY_NAME,
REF_STA_ID,
STA_NAME,
CATEGORI_ID,
CATEGORY_NAME,
case when mande-nvl(mande2,0) >0 then mande-nvl(mande2,0) else 0 end as input,           ------------------------nvl
case when mande-nvl(mande2,0) <0 then abs(mande-nvl(mande2,0)) else 0 end as output,     ------------------------nvl
mande AS mande,
EFFDATE,
CURRENCY
from 
(
select 
  a.BRANCH_ID,
  brn.REF_CTY_ID,
  brn.CITY_NAME,
  brn.REF_STA_ID,
  brn.STA_NAME,
  a.CURRENCY,
  a.EFFDATE, 
  a.CATEGORI_ID,
  a.CATEGORY_NAME,
  a.MANDE,
 (select 
  MANDE
  from TBL_DEPOSIT_HOMOGENEOUS b where  a.BRANCH_ID=b.BRANCH_Id and a.CATEGORI_ID=b.CATEGORI_ID and a.CURRENCY=b.CURRENCY and b.effdate=max_effdate1) as mande2
  from TBL_DEPOSIT_HOMOGENEOUS a  ,pragg.tbl_branch  brn
where a.BRANCH_ID=brn.BRN_ID
and trunc(a.effdate)=trunc(sysdate)
) ;
commit;
---------------------------------------------

---------------------------------------------
--dar jadval  y  mitan fagaht baraye ruze akhar ???????
for j in (select * from TBL_TYPE_HOMEGENEOUS) loop
var:='insert into DYNAMIC_LQ.HOMOGENEOUS_DEPOSIT_ACCOUNTING (
VALUE,
DEPOSIT_ACCOUNTING,
effdate,
ARZ_ID,
code,
BRANCH_ID,
CATEGORY_ID,
CATEGORY_NAME
)
(
select  y.balance,y.REF_DEPOSIT_ACCOUNTING,y.effdate,y.REF_CURRENCY,y.asl,y.REF_BRANCH,yy.CATEGORI_ID,y.CATEGORI_name  from 
-----------------------------------------------------
(select 
a.balance,
a.REF_DEPOSIT_ACCOUNTING,
a.effdate as effdate,
a.REF_CURRENCY,
b.asl,
REF_BRANCH ,'
||''''||j.id||''''||' as CATEGORI_ID,'
||''''||j.name||''''||' as CATEGORI_name
from (
select sum(balance) as balance,REF_DEPOSIT_ACCOUNTING,effdate,REF_CURRENCY,REF_BRANCH from tbl_DEPOSIT  where 
 trunc(due_date) '|| j.HOMEGENEOUS||'
group by REF_BRANCH,REF_DEPOSIT_ACCOUNTING,effdate,REF_CURRENCY)a, 
( SELECT  
* 
FROM (   
SELECT    
SUBSTR(DP_TYPE_CODE,3,4) AS REF_SEPORDE   
,TO_CHAR(REL_TYPE) AS S   
,GLCODE   
FROM dadekavan_day.SEPORDE_DAFTAR_KOL  
)   
PIVOT ( SUM ( GLCODE )    
FOR S    
IN ( ''حساب اصلي'' AS ASL,''حساب سود علي الحساب'' AS SUD )   
) 
WHERE ASL IS NOT NULL 
)b 
where ref_seporde=a.REF_DEPOSIT_ACCOUNTING ) y inner join

(select max(effdate)as max_effdate,CATEGORI_ID,branch_id,CURRENCY from (
select
BRANCH_ID,
REF_CTY_ID,
CITY_NAME,
REF_STA_ID,
STA_NAME,
CURRENCY,
EFFDATE,
CATEGORI_ID,
case when mande-mande2 >0 then mande-mande2 else 0 end as input,  
case when mande-mande2 <0 then abs(mande-mande2) else 0 end as output,  
mande AS mande
from 
(
select 
  a.BRANCH_ID,
  brn.REF_CTY_ID,
  brn.CITY_NAME,
  brn.REF_STA_ID,
  brn.STA_NAME,
  a.CURRENCY,
  a.EFFDATE, 
  a.MANDE,
  a.CATEGORI_ID,
  a.CATEGORY_NAME,
 (select 
  MANDE
  from TBL_DEPOSIT_HOMOGENEOUS b where  a.BRANCH_ID=b.BRANCH_Id and a.CATEGORI_ID=b.CATEGORI_ID and a.CURRENCY=b.CURRENCY and b.effdate='||max_effdate1||') as mande2
  from TBL_DEPOSIT_HOMOGENEOUS a  ,pragg.tbl_branch  brn
where a.BRANCH_ID=brn.BRN_ID and trunc(a.effdate)=trunc(sysdate)) 

) group by branch_id,CATEGORI_ID,CURRENCY
) yy

on  y.effdate=yy.max_effdate and y.CATEGORI_ID=yy.CATEGORI_ID and yy.branch_id=y.REF_BRANCH and yy.CURRENCY=y.REF_CURRENCY
)';
EXECUTE IMMEDIATE var;
commit;
end loop;
-------------------------------------delete count effdate  (BRANCH_ID,ARZ_ID,CATEGORY_ID )<30

-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
--for i in (select a.REF_BRANCH,b.REF_CTY_ID,b.CITY_NAME,b.REF_STA_ID,b.STA_NAME from
--(select distinct(REF_BRANCH) as REF_BRANCH from tbl_DEPOSIT where REF_BRANCH!=10120 ) a,(SELECT * FROM pragg.tbl_branch ) b
--where a.REF_BRANCH=b.brn_id) loop
--
--for b in (select * from TBL_TYPE_HOMEGENEOUS  order by id) loop
--var:='select count(*)  from tbl_DEPOSIT where  REF_BRANCH='||i.REF_BRANCH||' and trunc(DUE_DATE) '|| b.HOMEGENEOUS||' and rownum<2' ;
--execute IMMEDIATE var into var_count_due_date;
--IF(var_count_due_date!=0) THEN
--
--for j in (select distinct(effdate)     from tbl_DEPOSIT where REF_BRANCH =i.REF_BRANCH   order by effdate) loop
--
--var:='select max(effdate)  from tbl_DEPOSIT where  REF_BRANCH='||i.REF_BRANCH||' and trunc(DUE_DATE) '|| b.HOMEGENEOUS||' and effdate<to_date('||''''||j.effdate||''''||')' ;
--execute IMMEDIATE var into max_effdate;
--
--  --------------------------------------------------------------------------------------------------------------------------------------------
--  IF(b.id           =1) THEN --ruzshomar
--    IF(max_effdate IS NULL) THEN
--      var1         :='insert into DYNAMIC_LQ.HOMOGENEOUS_DEPOSIT (
--BRANCH_ID,
--CATEGORY_id,
--CATEGORY,
--INPUT_BALANCE,
--OUTPU_BALANCE,
--MANDE,
--percent,
--EFF_DATE,
--arz_id ,
--CITY_ID,
--CITY_NAME,
--STA_ID,
--STA_NAME
--)
--(
--SELECT      
--'||''''||i.REF_BRANCH||''''||','||'     
--'||''''||b.id||''''||','||'     
--'||''''||b.name||''''||','||'     
--SUM(balance) AS input,     
--0,     
--SUM(balance) AS input,     
--0,     
--MAX(effdate)       AS effdate,     
-- REF_CURRENCY ,'
--||i.REF_CTY_ID||','  
--||''''||i.CITY_NAME||''''||','
--||i.REF_STA_ID||','
--||''''||i.STA_NAME||''''||'
--FROM tbl_DEPOSIT     
--WHERE REF_BRANCH   ='||i.REF_BRANCH||'     
--AND TRUNC(effdate)        ='||''''||j.effdate||''''||'     
--AND TRUNC(due_date) '||b.HOMEGENEOUS||'     
--group by  REF_CURRENCY
--)';
--      EXECUTE IMMEDIATE var1 ;
--      commit;
--    ELSE  -- IF(max_effdate IS NULL) THEN
--      var:='insert into DYNAMIC_LQ.HOMOGENEOUS_DEPOSIT (
--BRANCH_ID,
--CATEGORY_id,
--CATEGORY,
--INPUT_BALANCE,
--OUTPU_BALANCE,
--MANDE,
--percent,
--EFF_DATE,
--arz_id ,
--CITY_ID,
--CITY_NAME,
--STA_ID,
--STA_NAME
--)
--(
--SELECT   
--'||''''||i.REF_BRANCH||''''||',  
--'||''''||b.id||''''||','||'  
--'||''''||b.name||''''||','||'  
--case when a.balance-b.balance >0 then a.balance-b.balance else 0 end as input,  
--case when a.balance-b.balance <0 then abs(a.balance-b.balance) else 0 end as output,  
--a.balance AS mande,  
--case when a.balance-b.balance <0 then abs(((a.balance-b.balance)/b.balance)*100) else 0 end as percent,  
--'||''''||j.effdate||''''||'  
--,a.REF_CURRENCY       AS REF_CURRENCY,'
--||i.REF_CTY_ID||','  
--||''''||i.CITY_NAME||''''||','
--||i.REF_STA_ID||','
--||''''||i.STA_NAME||''''||'
--FROM  
--(SELECT SUM(balance) AS balance,    
--MAX(due_date)      AS due_date,    
--MAX(REF_BRANCH)    AS REF_BRANCH,    
--MAX(effdate)       AS effdate,    
--REF_CURRENCY  
--FROM tbl_DEPOSIT  
--WHERE REF_BRANCH   ='||i.REF_BRANCH||'  
--AND TRUNC(effdate)        ='||''''||j.effdate||''''||'    
--AND TRUNC(due_date) '||b.HOMEGENEOUS||
--      '    
--group by  REF_CURRENCY  
--) a  left outer join 
--(SELECT SUM(balance) AS balance,    
--MAX(due_date)      AS due_date,    
--MAX(REF_BRANCH)    AS REF_BRANCH,    
--MAX(effdate)       AS effdate,    
--REF_CURRENCY  
--FROM tbl_DEPOSIT  
--WHERE REF_BRANCH   ='||i.REF_BRANCH||'  
--AND TRUNC(effdate)        ='||''''||max_effdate||''''||'  
--AND TRUNC(due_date) '||b.HOMEGENEOUS||'  
--group by  REF_CURRENCY  
--) b on a.REF_CURRENCY=b.REF_CURRENCY
--
--)';
--      EXECUTE IMMEDIATE var ;
--      COMMIT;
--    END IF; --IF(max_effdate IS NULL) THEN
----  END IF;--  IF(b.id           =1) THEN --ruzshomar
--else  --  IF(b.id           =1) THEN --ruzshomar
----sysdate+2  ......  
--  ------------------------------------------------------------------------------------------------------------------------------------------------
--  IF(max_effdate IS NULL) THEN
--    var1         :='insert into DYNAMIC_LQ.HOMOGENEOUS_DEPOSIT (
--BRANCH_ID,
--CATEGORY_id,
--CATEGORY,
--INPUT_BALANCE,
--OUTPU_BALANCE,
--MANDE,
--percent,
--EFF_DATE,
--arz_id,
--CITY_ID,
--CITY_NAME,
--STA_ID,
--STA_NAME
--)
--(
--SELECT      
--'||''''||i.REF_BRANCH||''''||','||'     
--'||''''||b.id||''''||','||'     
--'||''''||b.name||''''||','||'     
--SUM(balance) AS input,     
--0,     
--SUM(balance) AS input,     
--0,     
--MAX(effdate)       AS effdate,     
-- REF_CURRENCY ,'
--||i.REF_CTY_ID||','  
--||''''||i.CITY_NAME||''''||','
--||i.REF_STA_ID||','
--||''''||i.STA_NAME||''''||'
--FROM tbl_DEPOSIT     
--WHERE REF_BRANCH   ='||i.REF_BRANCH||'     
--AND TRUNC(effdate)        ='||''''||j.effdate||''''||'     
--AND TRUNC(due_date) '||b.HOMEGENEOUS||'     
--group by  REF_CURRENCY  
--)';
--    EXECUTE IMMEDIATE var1 ;
--  ELSE
--    var:='insert into DYNAMIC_LQ.HOMOGENEOUS_DEPOSIT (
--BRANCH_ID,
--CATEGORY_id,
--CATEGORY,
--INPUT_BALANCE,
--OUTPU_BALANCE,
--MANDE,
--percent,
--EFF_DATE,
--arz_id ,
--CITY_ID,
--CITY_NAME,
--STA_ID,
--STA_NAME
--)
--(
--SELECT   
--'||''''||i.REF_BRANCH||''''||',  
--'||''''||b.id||''''||','||'  
--'||''''||b.name||''''||','||'  
--case when a.balance-b.balance >0 then a.balance-b.balance else 0 end as input,  
--case when a.balance-b.balance <0 then abs(a.balance-b.balance) else 0 end as output,  
--a.balance AS mande,   
--case when a.balance-b.balance <0 then abs(((a.balance-b.balance)/b.balance)*100) else 0 end as percent,  
--'||''''||j.effdate||''''||'  
--,a.REF_CURRENCY       AS REF_CURRENCY,'
--||i.REF_CTY_ID||','  
--||''''||i.CITY_NAME||''''||','
--||i.REF_STA_ID||','
--||''''||i.STA_NAME||''''||'
--FROM  
--(SELECT SUM(balance) AS balance,    
--MAX(due_date)      AS due_date,    
--MAX(REF_BRANCH)    AS REF_BRANCH,    
--MAX(effdate)       AS effdate,    
-- REF_CURRENCY  
--FROM tbl_DEPOSIT  
--WHERE REF_BRANCH   ='||i.REF_BRANCH||'  
--AND TRUNC(effdate)        ='||''''||j.effdate||''''||'    
--AND TRUNC(due_date) '||b.HOMEGENEOUS||
--    '    
--group by  REF_CURRENCY   
--) a left outer join  
--(SELECT SUM(balance) AS balance,    
--MAX(due_date)      AS due_date,    
--MAX(REF_BRANCH)    AS REF_BRANCH,    
--MAX(effdate)       AS effdate,    
-- REF_CURRENCY  
--FROM tbl_DEPOSIT  
--WHERE REF_BRANCH   ='||i.REF_BRANCH||'  
--AND TRUNC(effdate)       ='||''''||max_effdate||''''||'  
--AND TRUNC(due_date) '||b.HOMEGENEOUS||'  
--group by  REF_CURRENCY   
--) b on a.REF_CURRENCY=b.REF_CURRENCY
--
--
--
--)';
--    EXECUTE IMMEDIATE var ;
--    COMMIT;
--  END IF;
--END IF;
--max_effdate_type:=trunc(j.effdate);
--end loop;
----end if;   --
-------------
--var:= ' 
--insert into DYNAMIC_LQ.HOMOGENEOUS_DEPOSIT_ACCOUNTING (
--VALUE,
--DEPOSIT_ACCOUNTING,
--effdate,
--ARZ_ID,
--code,
--BRANCH_ID,
--CATEGORY_ID,
--CATEGORY_NAME
--)
--(
--select 
--a.balance,
--a.REF_DEPOSIT_ACCOUNTING,
--a.effdate as effdate,
--a.REF_CURRENCY,
--b.asl,'
--||i.REF_BRANCH||',
--'||''''||b.id||''''||','||'  
--'||''''||b.name||''''||'
--from (
--select sum(balance) as balance,REF_DEPOSIT_ACCOUNTING,effdate,REF_CURRENCY from tbl_DEPOSIT  where 
--REF_BRANCH ='||i.REF_BRANCH||' and trunc(due_date) '||b.HOMEGENEOUS||' 
--group by REF_DEPOSIT_ACCOUNTING,effdate,REF_CURRENCY)a, 
--( SELECT  
--* 
--FROM (   
--SELECT    
--SUBSTR(DP_TYPE_CODE,3,4) AS REF_SEPORDE   
--,TO_CHAR(REL_TYPE) AS S   
--,GLCODE   
--FROM dadekavan_day.SEPORDE_DAFTAR_KOL  
--)   
--PIVOT ( SUM ( GLCODE )    
--FOR S    
--IN ( ''حساب اصلي'' AS ASL,''حساب سود علي الحساب'' AS SUD )   
--) 
--WHERE ASL IS NOT NULL 
--)b 
--where ref_seporde=a.REF_DEPOSIT_ACCOUNTING  and effdate='||''''||max_effdate_type||''''||')';
--EXECUTE IMMEDIATE var;
--commit;
--------------------------------------------------------------------------------------------------------------------
----end if;
--end if;  --IF(var_count_due_date!=0) THEN
--end loop;
--insert into tbl_test(var) (select i.REF_BRANCH||' == '||sysdate||' == '||to_char(sysdate,'HH24:MI:SS') from dual);
--commit;
--end loop;
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------






----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

END PRC_HOMOGENEOUS_DEPOSIT;
--------------------------------------------------------
--  DDL for Procedure PRC_J_TRANSFER_DEPOSIT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_J_TRANSFER_DEPOSIT" ( RUN_DATE IN DATE ) AS
  /*
  Programmer Name: morteza sahi
  Release Date/Time:1396/05/12-10:00
  Version:
  Category: 
  Description: enteghal be jadavel DEPOSIT be sorate tarikhi
  */
 LOC_S         TIMESTAMP;
 LOC_F         TIMESTAMP;
 LOC_MEGHDAR   NUMBER;
BEGIN
-- EXECUTE IMMEDIATE 'truncate table akin.TBL_DEPOSIT';
 LOC_S   := SYSTIMESTAMP;
 
 
 INSERT
    /*+   PARALLEL(auto) */ into DYNAMIC_LQ.TBL_DEPOSIT (
  DEP_ID
 ,OPENING_DATE
 ,BALANCE
 ,DUE_DATE
 ,REF_DEPOSIT_TYPE
 ,RATE
 ,REF_BRANCH
 ,REF_CUSTOMER
 ,REF_DEPOSIT_ACCOUNTING
 ,MODALITY_TYPE
 ,REF_CURRENCY
 ,effdate
 ) ( SELECT
   CASE
    WHEN T.SHOMARE_SEPORDE IS NOT NULL THEN TO_NUMBER(T.SHOMARE_SEPORDE)
    ELSE 999999
   END
  AS SHOMARE_SEPORDE
 ,T.TARIKH_EFTETAH
 ,T.MOJUDI_SEPORDE
 ,T.TARIKH_SARRESID
 ,T.NOE_SEPORDE
 , CASE
    WHEN ( T.NERKH + NVL(B.RATE,0) ) IS NOT NULL THEN T.NERKH + NVL(B.RATE,0)
    ELSE 10
   END
  AS RATE
 , CASE
    WHEN T.BR_CODE IS NOT NULL THEN TO_NUMBER(T.BR_CODE)
    ELSE 99999
   END
  AS BR_CODE
 , CASE
    WHEN T.CUST_NO IS NOT NULL THEN TO_NUMBER(T.CUST_NO)
    ELSE 99999
   END
  AS CUST_NO
 ,T.NOE_SEPORDE
 ,T.TAFKIK_SEPORDE
 , CASE
    WHEN T.ARZ IS NOT NULL THEN T.ARZ
    ELSE 99999
   END
  AS ARZ
  ,RUN_DATE
 FROM (
   SELECT
          /*+   PARALLEL(auto) */ DISTINCT
    S.DEPNUM AS SHOMARE_SEPORDE
   ,S.OPEN_DATE AS TARIKH_EFTETAH
   ,S.BALANCE_ENDDAY AS MOJUDI_SEPORDE
   ,S.FRZN_AMNT
   ,S.STATE_ENDDAY
   ,ADD_MONTHS(
     S.RENEW_DATE
    ,TS.VALIDITY_DURATION
    ) AS TARIKH_SARRESID
   ,SUBSTR(
     S.PRODUCTTYPECOD
    ,3
    ,4
    ) AS NOE_SEPORDE
   ,A.CUR_ID AS ARZ
   ,SS.RATE AS NERKH
   ,SM.CUST_NO + 0 AS CUST_NO
   ,S.BR_CODE + 10000 AS BR_CODE
   ,TS.MODALITY_TYPE AS TAFKIK_SEPORDE
   ,TS.VALIDITY_DURATION AS MODAT
   FROM dadekavan_day.SEPORDE_SOOD SS
    LEFT OUTER JOIN dadekavan_day.DEPOSIT S ON SUBSTR(
      S.PRODUCTTYPECOD
     ,3
     ,4
     ) = SUBSTR(
      SS.DEPTYPECODE
     ,3
     ,4
     )
    AND
  --  s.BR_CODE in (2501,0146) and 
    
     S.EFFDATE    = TRUNC(RUN_DATE)
    LEFT OUTER JOIN PRAGG.TBL_CURRENCY A ON S.CURR_COD   = A.SWIFT_CODE
    LEFT OUTER JOIN dadekavan_day.SEPORDE_MOSHTARI SM ON SM.DP_NO   = S.DEPNUM
    LEFT OUTER JOIN akin.TBL_MODALITY_TYPE TS ON TS.ID   = SUBSTR(
     S.PRODUCTTYPECOD
    ,3
    ,4
    )
   WHERE S.PRODUCTTYPECOD IS NOT NULL
    AND
     S.BALANCE_ENDDAY > 0

  ) T
  LEFT OUTER JOIN (
   SELECT DISTINCT
    DP_NO
   ,FIRST_VALUE(
     RATE
    ) OVER(PARTITION BY
     DP_NO
     ORDER BY
      BEGIN_DATE
     DESC
    ) AS RATE
   FROM dadekavan_day.SEPORDE_SOOD_TAVAFOGHI
   WHERE BEGIN_DATE < TRUNC(RUN_DATE)
  ) B ON T.SHOMARE_SEPORDE   = B.DP_NO
 );

 COMMIT;
 INSERT
    /*+   PARALLEL(auto) */ into DYNAMIC_LQ.TBL_DEPOSIT (
  DEP_ID
 ,OPENING_DATE
 ,BALANCE
 ,DUE_DATE
 ,REF_DEPOSIT_TYPE
 ,REF_CURRENCY
 ,RATE
 ,REF_CUSTOMER
 ,MODALITY_TYPE
 ,REF_BRANCH
 ,REF_DEPOSIT_ACCOUNTING
 ,effdate
 ) 
 ( SELECT DISTINCT
  T.DEPNUM
 ,MAX(T.OPEN_DATE)
 ,MAX(T.BALANCE_ENDDAY)
 ,MAX(ADD_MONTHS(
   T.RENEW_DATE
  ,TS.VALIDITY_DURATION
  ) )
 ,MAX(SUBSTR(
   T.PRODUCTTYPECOD
  ,3
  ,4
  ) )
 ,CASE
   WHEN MAX(A.CUR_ID) IS NOT NULL THEN MAX(A.CUR_ID)
   ELSE 99999
  END
 ,MAX(
   CASE
    WHEN T.BALANCE_ENDDAY >= T.PELE_BASEAMOUNT THEN T.RATE
    ELSE 0
   END
  )
 ,CASE
   WHEN MAX(SM.CUST_NO) IS NOT NULL THEN MAX(SM.CUST_NO) + 0
   ELSE 99999
  END
 ,MAX(TS.MODALITY_TYPE)
 , CASE
    WHEN MAX(T.BR_CODE) IS NOT NULL THEN TO_NUMBER(MAX(T.BR_CODE) )
    ELSE 99999
   END
  AS BR_CODE
 ,MAX(SUBSTR(
   T.PRODUCTTYPECOD
  ,3
  ,4
  ) )
  ,RUN_DATE
 FROM (
   SELECT
    SP.*
   ,S.DEPOSITKEY
   ,S.DEPNUM
   ,S.BR_CODE + 10000 AS BR_CODE
   ,S.BR_NAME
   ,S.PRODUCTTYPECOD
   ,S.BALANCE_ENDDAY
   ,S.RENEW_DATE
   ,S.CURR_COD
   ,S.CURRENT_STATE
   ,S.FRZN_AMNT
   ,S.EFFDATE AS EFFFDATE
   ,S.STATE_ENDDAY
   ,S.OPEN_DATE
   FROM dadekavan_day.SEPORDE_SOOD_PELEKANI SP
    LEFT OUTER JOIN dadekavan_day.DEPOSIT S ON SUBSTR(
     S.PRODUCTTYPECOD
    ,3
    ,4
    ) = SUBSTR(
     SP.DP_TYPE_CODE
    ,3
    ,4
    )
   WHERE 
  -- s.BR_CODE in (2501,0146) and 
   
   S.BALANCE_ENDDAY >= SP.PELE_BASEAMOUNT
    AND
     S.BALANCE_ENDDAY > 0
    AND
     S.EFFDATE    = TRUNC(RUN_DATE)
  ) T
  LEFT OUTER JOIN PRAGG.TBL_CURRENCY A ON T.CURR_COD   = A.SWIFT_CODE
  LEFT OUTER JOIN dadekavan_day.SEPORDE_MOSHTARI SM ON SM.DP_NO   = T.DEPNUM
  LEFT OUTER JOIN akin.TBL_MODALITY_TYPE TS ON TS.ID        = SUBSTR(
    T.PRODUCTTYPECOD
   ,3
   ,4
   )
 GROUP BY
  T.DEPNUM
 );

 COMMIT;
 INSERT
    /*+   PARALLEL(auto) */ into DYNAMIC_LQ.TBL_DEPOSIT (
  DEP_ID
 ,OPENING_DATE
 ,BALANCE
 ,DUE_DATE
 ,REF_DEPOSIT_TYPE
 ,REF_CURRENCY
 ,RATE
 ,REF_CUSTOMER
 ,MODALITY_TYPE
 ,REF_BRANCH
 ,REF_DEPOSIT_ACCOUNTING
 ,effdate
 ) ( SELECT DISTINCT
  T.DEPNUM
 ,MAX(T.OPEN_DATE)
 ,ROUND(
   MAX(T.BALANCE_ENDDAY)
  ,0
  )
 ,MAX(ADD_MONTHS(
   T.RENEW_DATE
  ,TS.VALIDITY_DURATION
  ) )
 ,MAX(SUBSTR(
   T.PRODUCTTYPECOD
  ,3
  ,4
  ) )
 ,CASE
   WHEN MAX(A.CUR_ID) IS NOT NULL THEN MAX(A.CUR_ID)
   ELSE 99999
  END
 ,MAX(0)
 ,CASE
   WHEN MAX(SM.CUST_NO) IS NOT NULL THEN MAX(SM.CUST_NO) + 0
   ELSE 99999
  END
 ,MAX(TS.MODALITY_TYPE)
 , CASE
    WHEN MAX(T.BR_CODE) IS NOT NULL THEN MAX(T.BR_CODE) + 10000
    ELSE 99999
   END
  AS BR_CODE
 ,MAX(SUBSTR(
   T.PRODUCTTYPECOD
  ,3
  ,4
  ) )
  ,RUN_DATE
 FROM dadekavan_day.DEPOSIT T
  LEFT OUTER JOIN PRAGG.TBL_CURRENCY A ON T.CURR_COD   = A.SWIFT_CODE
  LEFT OUTER JOIN dadekavan_day.SEPORDE_MOSHTARI SM ON SM.DP_NO   = T.DEPNUM
  LEFT OUTER JOIN akin.TBL_MODALITY_TYPE TS ON TS.ID   = SUBSTR(
   T.PRODUCTTYPECOD
  ,3
  ,4
  )
 WHERE 
-- t.BR_CODE in (2501,0146) and 
 TS.MODALITY_TYPE   = 2
  AND
   T.BALANCE_ENDDAY > 0
  AND
   T.EFFDATE          = TRUNC(RUN_DATE)
 GROUP BY
  T.DEPNUM
 );

 COMMIT;
/*  LOC_F := SYSTIMESTAMP;*/
/*  SELECT COUNT(*) INTO LOC_MEGHDAR FROM NEGASHT.TBL_SEPORDE_EMRUZ;*/
/*  HAMI.PRC_LOG('DEP_CNT',LOC_MEGHDAR,USER,$$PLSQL_UNIT,$$PLSQL_LINE,NULL);*/
/*  HAMI.PRC_LOG('DEP_TIME',HAMI.FNC_MODAT_EJRA(LOC_S,LOC_F),USER,$$PLSQL_UNIT,$$PLSQL_LINE,NULL);*/
/*  SELECT COUNT(*)-LOC_MEGHDAR INTO LOC_MEGHDAR FROM dadekavan_day.DEPOSIT;*/
/*  HAMI.PRC_LOG('DEP_IGN_CNT',LOC_MEGHDAR,USER,$$PLSQL_UNIT,$$PLSQL_LINE,NULL);*/
/*  EXCEPTION */
/*WHEN OTHERS THEN*/
/*RAISE;*/
END PRC_J_TRANSFER_DEPOSIT;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_REPORT_PROFILE" 
(
 
 inpar_name    IN VARCHAR2,
 inpar_des    IN VARCHAR2,
 INPAR_created_by                     IN VARCHAR2
 ,INPAR_report_type                    IN VARCHAR2
 ,INPAR_type                           IN VARCHAR2
 ,INPAR_branch_profile_id              IN VARCHAR2
 ,inpar_status in varchar2
 ,inpar_archived in varchar2
 ,inpar_ledger_profile_id in varchar2
 ,inpar_cur_profile_id in varchar2
 ,inpar_tyming_profile_id in varchar2
 ,inpar_DEPOSIT_PROFILE_ID in varchar2
 ,inpar_TASHILAT_PROFILE_ID in varchar2
 ,INPAR_INSERT_OR_UPDATE   IN VARCHAR2
 ,INPAR_ID                 IN VARCHAR2
 ,OUTPAR_ID                OUT VARCHAR2
 )
  AS
 BEGIN
 
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: az in prc baraye insert ya update jadvale dynamic_lq.reports estefade mishavd
  ijad ya update profile
  */
  /*------------------------------------------------------------------------------*/
  IF
   ( INPAR_INSERT_OR_UPDATE = 0 )
  THEN
   INSERT
INTO REPORTS
  (
   name,
   des,
    CREATED,
    CREATEDBY,
    REPORTER_TYPE,
    TYPE,
    BRANCH_PROFILE_ID,
    STATUS,
    ARCHIVED,
    LEDGER_PROFILE_ID,
    ORIGINAL_ID,
    CUR_PROFILE_ID,
    TIMING_PROFILE_ID,
    DEPOSIT_PROFILE_ID,
    TASHILAT_PROFILE_ID
    
  )
  VALUES
  (
  inpar_name,
  inpar_des,
    sysdate                            
 ,INPAR_created_by                     
 ,INPAR_report_type                    
 ,INPAR_type                          
 ,(select max(id) from pragg.TBL_PROFILE where h_id = INPAR_branch_profile_id)             
 ,inpar_status 
 ,inpar_archived 
 ,(select max(id) from pragg.TBL_LEDGER_PROFILE where h_id = inpar_ledger_profile_id)
 ,(select max(id) from reports where type= 100 and status=2)
 ,(select max(id) from pragg.tbl_profile where h_id = inpar_cur_profile_id)
 ,(select max(id) from pragg.TBL_TIMING_PROFILE where h_id = inpar_tyming_profile_id)
 ,(select max(id) from pragg.tbl_profile where h_id = inpar_DEPOSIT_PROFILE_ID)
 ,(select max(id) from pragg.tbl_profile where h_id = inpar_TASHILAT_PROFILE_ID)
 
 
  );

   COMMIT; 

   SELECT
    max(ID)
   INTO
    OUTPAR_ID
   FROM reports;

  ELSE
   UPDATE reports
    SET
    name = inpar_name,
    des = inpar_des,
      updated = sysdate,
    CREATEDBY = INPAR_created_by,
    REPORTER_TYPE = INPAR_report_type,
    TYPE = inpar_type,
    BRANCH_PROFILE_ID = (select max(id) from pragg.TBL_PROFILE where h_id = INPAR_branch_profile_id),
    STATUS = inpar_status,
    ARCHIVED = inpar_archived,
    LEDGER_PROFILE_ID = (select max(id) from pragg.TBL_LEDGER_PROFILE where h_id = inpar_ledger_profile_id),
    CUR_PROFILE_ID    = (select max(id) from pragg.tbl_profile where h_id = inpar_cur_profile_id),
    TIMING_PROFILE_ID = (select max(id) from pragg.TBL_TIMING_PROFILE where h_id = inpar_tyming_profile_id),
    DEPOSIT_PROFILE_ID =(select max(id) from pragg.tbl_profile where h_id = inpar_DEPOSIT_PROFILE_ID),
    TASHILAT_PROFILE_ID=(select max(id) from pragg.tbl_profile where h_id = inpar_TASHILAT_PROFILE_ID)
   WHERE ID   = INPAR_ID;

  END IF;

  COMMIT;
  

END PRC_REPORT_PROFILE;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_VALUE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_REPORT_VALUE" (
    INPAR_REPORT_ID IN VARCHAR2 )
AS
  VAR            VARCHAR2(32000);
  VAR_ORGINAL_ID NUMBER;
  VAR_LEDGER     NUMBER;
  VAR_MAX_LEVEL  NUMBER;
  VAR_CURRENCY   NUMBER;
  VAR_TIMING     NUMBER;
  var_req        NUMBER;
  DATE_TYPE1     NUMBER :=     TO_CHAR(sysdate,'J');      --TO_CHAR(TO_DATE('05-FEB-17'),'J');
  var_type       NUMBER;
  var_BRANCH_PROFILE_ID  NUMBER;
--  var_deposit_type_id number;
--  var_tashilat_type_id number;
  var_seporde_type_condition varchar2(32000);
  var_tashilat_type_condition varchar2(32000);
BEGIN

 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: az in prc dar gozareshat (model szi ) baraye enteghal dedehaye ke tavasote profile ha entekhab shodand estefade mishavad .
  dar in prc , profile zamani dar nazar gerefte nemishavad.
  */
  /*------------------------------------------------------------------------------*/


  execute immediate 'alter session set nls_date_format=''DD-MM-RRRR''';

  /********************************************************************/
  --EXECUTE IMMEDIATE 'truncate table TBL_VALUE_TEMP';
  /********************************************************************/
  SELECT ORIGINAL_ID
  INTO VAR_ORGINAL_ID
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
  /********************************************************************/
  SELECT LEDGER_PROFILE_ID
  INTO VAR_LEDGER
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
  /********************************************************************/
  SELECT CUR_PROFILE_ID
  INTO VAR_CURRENCY
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
  /********************************************************************/
   SELECT BRANCH_PROFILE_ID
  INTO var_BRANCH_PROFILE_ID
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
  /********************************************************************/
--   select 
-- deposit_profile_id
-- into  var_deposit_type_id from reports 
-- WHERE ID   =   INPAR_REPORT_ID;
 
   /********************************************************************/
--  select
--  tashilat_profile_id 
-- into  var_tashilat_type_id from reports 
-- WHERE ID   =INPAR_REPORT_ID;
--  
    /********************************************************************/
  
  SELECT type
  INTO var_type
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
  
  /********************************************************************/
  SELECT MAX(DEPTH)
  INTO VAR_MAX_LEVEL
  FROM PRAGG.TBL_LEDGER_PROFILE_DETAIL
  WHERE REF_LEDGER_PROFILE = VAR_LEDGER;
  /********************************************************************/

  SELECT MAX(id) INTO var_req FROM tbl_rep_req;
 --gozaresh dafterkol 
  if(var_type=107) then 
  
  VAR := 'INSERT INTO TBL_VALUE_TEMP (  

req_id 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth,
BRANCH_ID,
CITY_ID,
STATE_ID
,INTERVAL
) 
SELECT 
'||var_req||' 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth,
SHOBE_ID,
SHAHR_ID,
OSTAN_ID
,INTERVAL
FROM REPORTS_DATA
WHERE report_id   = ' || VAR_ORGINAL_ID || '    
and   
ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ')      
and  NODE_ID IN   ( select code from pragg.tbl_ledger_profile_detail where ref_ledger_profile = ' || VAR_LEDGER || ' and depth = ' || VAR_MAX_LEVEL || ' ) 
and report_type=107;';
--and  SEPORDE_TYPE is null and TASHILAT_TYPE is null and shobe_id is null  ;';
--  DBMS_OUTPUT.PUT_LINE(VAR);
  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
COMMIT;

--  UPDATE tbl_value_temp a
--set
--  a.PARENT           =(select TL.PARENT_CODE from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--,
--  a.DEPTH            =(select TL.DEPTH from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--
--WHERE 
--  a.REQ_ID        =var_req;
--commit;

  FOR j IN 0..3
  LOOP
    FOR i IN reverse 1..VAR_MAX_LEVEL
    LOOP
      INSERT
      INTO TBL_VALUE_TEMP
        (
          req_id,
          DATA_TYPE,
          ARZ_ID,
          node_ID,
          parent,
          mande,
          depth,
          eff_date,
          INTERVAL
        )
      SELECT var_req ,
        j,
        4,
        code,
        MAX(parent_code),
        SUM(mande),
        MAX(b.DEPTH),
        a.EFF_DATE,
         sum(INTERVAL)
      FROM
        (SELECT NODE_ID ,
          MANDE ,
          EFF_DATE ,
          PARENT,
          interval
          FROM TBL_VALUE_TEMP
        WHERE DATA_TYPE = j
        AND req_id   = var_req
        )a
      LEFT JOIN
        (SELECT code,
          parent_code,
          depth
        FROM PRAGG.TBL_LEDGER_PROFILE_DETAIL
        WHERE REF_LEDGER_PROFILE = VAR_LEDGER
        )b
      ON a.PARENT = b.code
      AND B.DEPTH = i
      AND code   IS NOT NULL
      GROUP BY code,
        a.EFF_DATE ;
    END LOOP;
  END LOOP;
  COMMIT;
-------------------------------------------------  -------------------------------
--gozaresh daftar kol shobe
  elsif(var_type=108) then 
   VAR := 'INSERT INTO TBL_VALUE_TEMP (  
req_id 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth,
BRANCH_ID,
CITY_ID,
STATE_ID
,INTERVAL
)
SELECT 
'||var_req||' 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth,
SHOBE_ID,
SHAHR_ID,
OSTAN_ID
,INTERVAL
FROM REPORTS_DATA
WHERE report_id   = ' || VAR_ORGINAL_ID || '    
AND   ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ')  
and  SHOBE_ID in ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_PROFILE_ID) || ')
and  NODE_ID IN   ( select code from pragg.tbl_ledger_profile_detail where ref_ledger_profile = ' || VAR_LEDGER || ' and depth = ' || VAR_MAX_LEVEL || ' ) 
and report_type=108;';
--and  SEPORDE_TYPE is null and TASHILAT_TYPE is null ;';

  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
  COMMIT;
  
--  UPDATE tbl_value_temp a
--set
--  a.PARENT           =(select TL.PARENT_CODE from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--,
--  a.DEPTH            =(select TL.DEPTH from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--
--WHERE 
--  a.REQ_ID        =var_req;
--commit;

  FOR j IN 0..3
  LOOP
    FOR i IN reverse 1..VAR_MAX_LEVEL
    LOOP
      INSERT
      INTO TBL_VALUE_TEMP
        (
          req_id,
          DATA_TYPE,
          ARZ_ID,
          node_ID,
          parent,
          mande,
          depth,
          eff_date,
          BRANCH_ID,
          interval
        )
      SELECT var_req ,
        j,
        4,
        code,
        MAX(parent_code),
        SUM(mande),
        MAX(b.DEPTH),
        a.EFF_DATE,
        a.BRANCH_ID,
        sum(interval)
      FROM
        (SELECT NODE_ID ,
          MANDE ,
          EFF_DATE ,
          PARENT   ,
          BRANCH_ID,
          interval
          FROM TBL_VALUE_TEMP
        WHERE DATA_TYPE = j
        AND req_id   = var_req
        )a
      LEFT JOIN
        (SELECT code,
          parent_code,
          depth
        FROM PRAGG.TBL_LEDGER_PROFILE_DETAIL
        WHERE REF_LEDGER_PROFILE = VAR_LEDGER
        )b
      ON a.PARENT = b.code
      AND B.DEPTH = i
      AND code   IS NOT NULL
      GROUP BY 
      a.BRANCH_ID,
      a.EFF_DATE,
      code ;
    END LOOP;
  END LOOP;
  COMMIT;

  end if;
 ------------------------------------------------------------------------------------------------------------------- 
  if(var_type=109) then   --zudbardahst,rosub
   VAR := 'INSERT INTO TBL_VALUE_TEMP (  
req_id 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth,
BRANCH_ID,
CITY_ID,
STATE_ID
,INTERVAL
) SELECT 
'||var_req||' 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth,
SHOBE_ID,
SHAHR_ID,
OSTAN_ID
,INTERVAL
FROM REPORTS_DATA
WHERE report_id   = ' || VAR_ORGINAL_ID || '    
AND   ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ')  
and  SHOBE_ID in ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_PROFILE_ID) || ')
and  NODE_ID IN   ( select code from pragg.tbl_ledger_profile_detail where ref_ledger_profile = ' || VAR_LEDGER || ' and depth = ' || VAR_MAX_LEVEL || ' ) 
 and report_type=109;';
-- and  SEPORDE_TYPE is not  null  ;';

  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
  COMMIT;
  
--  UPDATE tbl_value_temp a
--set
--  a.PARENT           =(select TL.PARENT_CODE from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--,
--  a.DEPTH            =(select TL.DEPTH from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--
--WHERE 
--  a.REQ_ID        =var_req;
--commit;

  FOR j IN 0..3
  LOOP
    FOR i IN reverse 1..VAR_MAX_LEVEL
    LOOP
      INSERT
      INTO TBL_VALUE_TEMP
        (
          req_id,
          DATA_TYPE,
          ARZ_ID,
          node_ID,
          parent,
          mande,
          depth,
          eff_date,
          BRANCH_ID
        )
      SELECT var_req ,
        j,
        4,
        code,
        MAX(parent_code),
        SUM(mande),
        MAX(b.DEPTH),
        a.EFF_DATE,
        a.BRANCH_ID
      FROM
        (SELECT NODE_ID ,
          MANDE ,
          EFF_DATE ,
          PARENT   ,
          BRANCH_ID
          FROM TBL_VALUE_TEMP
        WHERE DATA_TYPE = j
        AND req_id   = var_req
        )a
      LEFT JOIN
        (SELECT code,
          parent_code,
          depth
        FROM PRAGG.TBL_LEDGER_PROFILE_DETAIL
        WHERE REF_LEDGER_PROFILE = VAR_LEDGER
        )b
      ON a.PARENT = b.code
      AND B.DEPTH = i
      AND code   IS NOT NULL
      GROUP BY 
      a.BRANCH_ID,
      a.EFF_DATE,
      code ;
    END LOOP;
  END LOOP;
  COMMIT; 
  
  end if;
 
 
 ------------------------------------------------------------------------------------------------------------------------
  if(var_type=103) then   --branch_deposit
   VAR := 'INSERT INTO TBL_VALUE_TEMP (  
req_id 
,DATA_TYPE 
,ARZ_ID 
,MANDE 
,EFF_DATE 
,BRANCH_ID,
CITY_ID,
STATE_ID
,INTERVAL
) SELECT 
'||var_req||' 
,DATA_TYPE  
,ARZ_ID 
,SEPORDE_MANDE 
,EFF_DATE 
,SHOBE_ID,
SHAHR_ID,
OSTAN_ID
,INTERVAL
FROM REPORTS_DATA
WHERE report_id   = ' || VAR_ORGINAL_ID || '    
and  ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ')  
and  SHOBE_ID in ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_PROFILE_ID) || ') 
and report_type=103;';
--and   SEPORDE_MANDE is not null and shobe_id is not null ;';

  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
  COMMIT;
  
  end if;
  ----------------------------------------------------------------------------------------------
  if(var_type=105) then   --branch_loan
   VAR := 'INSERT INTO TBL_VALUE_TEMP (  
req_id 
,DATA_TYPE 
,ARZ_ID 
,MANDE 
,EFF_DATE 
,BRANCH_ID,
CITY_ID,
STATE_ID
,INTERVAL
) SELECT 
'||var_req||' 
,DATA_TYPE  
,ARZ_ID 
,TASHILAT_MANDE 
,EFF_DATE 
,SHOBE_ID,
SHAHR_ID,
OSTAN_ID
,INTERVAL
FROM REPORTS_DATA
WHERE report_id   = ' || VAR_ORGINAL_ID || '    
and  ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ')  
and  SHOBE_ID in ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_PROFILE_ID) || ') 
and report_type=105;';
--and TASHILAT_MANDE is not null and shobe_id is not null ;';

  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
  COMMIT;
  
  end if;
-------------------------------------------------------------------------------------------------  
  if(var_type=104) then   --type_deposit
  
  select substr(str,4) into var_seporde_type_condition from (select REPLACE(str, '=',' or seporde_type=') as str from (select REPLACE(CONDITION, '#') as str from (
SELECT CONDITION FROM pragg.tbl_profile_detail
WHERE ref_profile = (select  deposit_profile_id from reports  WHERE ID=INPAR_REPORT_ID) and src_column='dep.ref_deposit_type'
)));
  
  
   VAR := 'INSERT INTO TBL_VALUE_TEMP (  
req_id 
,DATA_TYPE 
,ARZ_ID 
,SEPORDE_TYPE
,MANDE 
,EFF_DATE 
,BRANCH_ID,
CITY_ID,
STATE_ID
,INTERVAL
) SELECT 
'||var_req||' 
,DATA_TYPE  
,ARZ_ID 
,SEPORDE_TYPE
,seporde_MANDE 
,EFF_DATE 
,SHOBE_ID,
SHAHR_ID,
OSTAN_ID
,INTERVAL
FROM REPORTS_DATA
WHERE report_id   = ' || VAR_ORGINAL_ID || '    
and  ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ')
and ('||var_seporde_type_condition||')   
and report_type=104;';
--and seporde_type is not null and  SEPORDE_MANDE is not null  ;';

  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
  COMMIT;
  end if;
 ------------------------------------------------------------------- 
  
   if(var_type=106) then   --type_deposit
   
select substr(str,4) into var_tashilat_type_condition from (select REPLACE(str, '=',' or TASHILAT_TYPE=') as str from (select REPLACE(CONDITION, '#') as str from (
SELECT CONDITION FROM pragg.tbl_profile_detail
WHERE ref_profile = (select  TASHILAT_PROFILE_ID from reports  WHERE ID=INPAR_REPORT_ID) and src_column='lo.ref_loan_type'
)));
   
   VAR := 'INSERT INTO TBL_VALUE_TEMP (  
req_id 
,DATA_TYPE 
,ARZ_ID 
,tashilat_TYPE
,MANDE 
,EFF_DATE 
,BRANCH_ID,
CITY_ID,
STATE_ID
,INTERVAL
) 
SELECT 
'||var_req||' 
,DATA_TYPE  
,ARZ_ID 
,tashilat_TYPE
,tashilat_MANDE 
,EFF_DATE 
,SHOBE_ID,
SHAHR_ID,
OSTAN_ID
,INTERVAL
FROM REPORTS_DATA
WHERE report_id   = ' || VAR_ORGINAL_ID || '    
and  ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ')  
and ('||var_tashilat_type_condition||') 
and report_type=106;';
--and tashilat_type is not null and  tashilat_MANDE is not null  ;';

  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
  COMMIT;
  
  end if;
  
  
-----------------------------------------------------------------------------------------------------------------------  
--  if(var_type!= 103 and var_type!= 105 and var_type!= 104 and var_type!= 106) then  --or var_type!= '105'
--  DELETE FROM TBL_VALUE_TEMP WHERE NODE_ID IS NULL and req_id in (select distinct(id) from tbl_rep_req where category not in (103,105,104,106) );
--  COMMIT;
--  end if;

--baraye profile zamani
  PRC_TRANSFER_TIMING_VALUE ( INPAR_REPORT_ID);
  commit;
 END PRC_REPORT_VALUE;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_VALUE_BACK_TEST
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_REPORT_VALUE_BACK_TEST" (
    INPAR_REPORT_ID IN VARCHAR2
     ,OUTPAR_RES        OUT NUMBER)
AS
  VAR            VARCHAR2(32000);
  VAR_ORGINAL_ID NUMBER;
  VAR_LEDGER     NUMBER;
  VAR_MAX_LEVEL  NUMBER;
  VAR_CURRENCY   NUMBER;
  VAR_TIMING     NUMBER;
  var_req        NUMBER;
  DATE_TYPE1     NUMBER := TO_CHAR(TO_DATE('05-FEB-17'),'J');
  VAR_BRANCH_ID  NUMBER;
  VAR_type  NUMBER;
  var_seporde_type_condition VARCHAR2(32000);
  var_tashilat_type_condition VARCHAR2(32000);
BEGIN
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: backtest baraye gozareshat modelsazi
  */
  /*------------------------------------------------------------------------------*/
  /********************************************************************/
  --EXECUTE IMMEDIATE 'truncate table tbl_value_temp_back_test';
  /********************************************************************/
  SELECT ORIGINAL_ID
  INTO VAR_ORGINAL_ID
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
  /********************************************************************/
  SELECT LEDGER_PROFILE_ID
  INTO VAR_LEDGER
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
  /********************************************************************/
  SELECT CUR_PROFILE_ID
  INTO VAR_CURRENCY
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
  /********************************************************************/
   SELECT BRANCH_PROFILE_ID
  INTO VAR_BRANCH_ID
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
   /********************************************************************/
   SELECT type
  INTO VAR_type
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
  /********************************************************************/
  SELECT MAX(DEPTH)
  INTO VAR_MAX_LEVEL
  FROM PRAGG.TBL_LEDGER_PROFILE_DETAIL
  WHERE REF_LEDGER_PROFILE = VAR_LEDGER;
  /********************************************************************/

  COMMIT;
  SELECT MAX(id) INTO var_req FROM tbl_rep_req where REPORT_ID = INPAR_REPORT_ID;

  if(VAR_type=107) then
  
  
  VAR := 'INSERT INTO tbl_value_temp_back_test (  

req_id 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth,
CITY_ID,
STATE_ID
,interval
) 
SELECT 
'||var_req||' 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth,
SHAHR_ID,
OSTAN_ID
,interval
FROM back_test_data
WHERE report_id   = ' || VAR_ORGINAL_ID || '    
and ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ')      
and  NODE_ID IN   ( select code from pragg.tbl_ledger_profile_detail where ref_ledger_profile = ' || VAR_LEDGER || ' and depth = ' || VAR_MAX_LEVEL || ' )
and report_type=107;';
--and  SEPORDE_TYPE is null and TASHILAT_TYPE is null and shobe_id is null  ;';
  --DBMS_OUTPUT.PUT_LINE(VAR);
  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
  COMMIT;
   COMMIT;
--  UPDATE tbl_value_temp_back_test a
--set
--  a.PARENT           =(select TL.PARENT_CODE from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--,
--  a.DEPTH            =(select TL.DEPTH from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--
--WHERE 
--  a.REQ_ID        =var_req;
--commit;
  FOR j IN 0..3
  LOOP
    FOR i IN reverse 1..VAR_MAX_LEVEL
    LOOP
      INSERT
      INTO tbl_value_temp_back_test
        (
          req_id,
          DATA_TYPE,
          ARZ_ID,
          node_ID,
          parent,
          mande,
          depth,
          eff_date
        )
      SELECT var_req ,
        j,
        4,
        code,
        MAX(parent_code),
        SUM(mande),
        MAX(b.DEPTH),
        a.EFF_DATE
      FROM
        (SELECT NODE_ID ,
          MANDE ,
          EFF_DATE ,
          PARENT         FROM tbl_value_temp_back_test
        WHERE DATA_TYPE = j
        AND req_id   = var_req
        )a
      LEFT JOIN
        (SELECT code,
          parent_code,
          depth
        FROM PRAGG.TBL_LEDGER_PROFILE_DETAIL
        WHERE REF_LEDGER_PROFILE = VAR_LEDGER
        )b
      ON a.PARENT = b.code
      AND B.DEPTH = i
      AND code   IS NOT NULL
      GROUP BY code,
        a.EFF_DATE ;
    END LOOP;
  END LOOP;
  COMMIT;
  
  end if;
----------------------------------------------------------------------------------------------------------------------- 
  if(VAR_type=108) then
  
    
  VAR := 'INSERT INTO tbl_value_temp_back_test (  

req_id 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth,
BRANCH_ID,
CITY_ID,
STATE_ID
,interval
)
SELECT 
'||var_req||' 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth,
SHOBE_ID,
SHAHR_ID,
OSTAN_ID
,interval
FROM back_test_data
WHERE report_id   = ' || VAR_ORGINAL_ID || '    
AND   ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ') 
and  SHOBE_ID in ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_ID) || ')
and  NODE_ID IN   ( select code from pragg.tbl_ledger_profile_detail where ref_ledger_profile = ' || VAR_LEDGER || ' and depth = ' || VAR_MAX_LEVEL || ' ) 
and report_type=108;';
--and  SEPORDE_TYPE is null and TASHILAT_TYPE is null  ;';
  --DBMS_OUTPUT.PUT_LINE(VAR);
  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
  COMMIT;
--   COMMIT;
--  UPDATE tbl_value_temp_back_test a
--set
--  a.PARENT           =(select TL.PARENT_CODE from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--,
--  a.DEPTH            =(select TL.DEPTH from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--
--WHERE 
--  a.REQ_ID        =var_req;
--commit;
  FOR j IN 0..3
  LOOP
    FOR i IN reverse 1..VAR_MAX_LEVEL
    LOOP
      INSERT
      INTO tbl_value_temp_back_test
        (
          req_id,
          DATA_TYPE,
          ARZ_ID,
          node_ID,
          parent,
          mande,
          depth,
          eff_date,
          BRANCH_ID
        )
      SELECT var_req ,
        j,
        4,
        code,
        MAX(parent_code),
        SUM(mande),
        MAX(b.DEPTH),
        a.EFF_DATE,
        a.BRANCH_ID
      FROM
        (SELECT NODE_ID ,
          MANDE ,
          EFF_DATE ,
          PARENT,
          BRANCH_ID
          FROM tbl_value_temp_back_test
        WHERE DATA_TYPE = j
        AND req_id   = var_req
        )a
      LEFT JOIN
        (SELECT code,
          parent_code,
          depth
        FROM PRAGG.TBL_LEDGER_PROFILE_DETAIL
        WHERE REF_LEDGER_PROFILE = VAR_LEDGER
        )b
      ON a.PARENT = b.code
      AND B.DEPTH = i
      AND code   IS NOT NULL
      GROUP BY 
      a.BRANCH_ID,
      a.EFF_DATE,
      code;
    END LOOP;
  END LOOP;
  COMMIT;
  
  end if;
  ------------------------------------------------------------------------------------------------------------
   if(VAR_type=103) then
  
    
  VAR := 'INSERT INTO tbl_value_temp_back_test (  

req_id 
,DATA_TYPE  
,ARZ_ID 
,MANDE 
,EFF_DATE 
,BRANCH_ID
,CITY_ID
,STATE_ID
,interval
) 
SELECT 
'||var_req||' 
,DATA_TYPE  
,ARZ_ID 
,SEPORDE_MANDE 
,EFF_DATE 
,SHOBE_ID
,SHAHR_ID
,OSTAN_ID
,interval
FROM back_test_data
WHERE
report_id   = ' || VAR_ORGINAL_ID || '    
and    ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ') 
and    SHOBE_ID in ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_ID) || ') 
and report_type=103;';
--and    SEPORDE_MANDE is not null and shobe_id is not null ;';
  --DBMS_OUTPUT.PUT_LINE(VAR);
  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
  COMMIT;
  end if;
  ----------------------------------------------------------------------------------------------------------------
    if(VAR_type=105) then
  
    
  VAR := 'INSERT INTO tbl_value_temp_back_test (  

req_id 
,DATA_TYPE  
,ARZ_ID 
,MANDE 
,EFF_DATE 
,BRANCH_ID
,CITY_ID
,STATE_ID
,interval
) 
SELECT 
'||var_req||' 
,DATA_TYPE  
,ARZ_ID 
,TASHILAT_MANDE 
,EFF_DATE 
,SHOBE_ID
,SHAHR_ID
,OSTAN_ID
,interval
FROM back_test_data
WHERE
report_id   = ' || VAR_ORGINAL_ID || '    
and    ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ') 
and    SHOBE_ID in ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_ID) || ') 
and report_type=105;';
--and    TASHILAT_MANDE is not null and shobe_id is not null  ;';
  --DBMS_OUTPUT.PUT_LINE(VAR);
  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
  COMMIT;
  end if;
  
  ----------------------------------------------------------------------------------------------------------------
   if(VAR_type=104) then
   
    select substr(str,4) into var_seporde_type_condition from (select REPLACE(str, '=',' or seporde_type=') as str from (select REPLACE(CONDITION, '#') as str from (
SELECT CONDITION FROM pragg.tbl_profile_detail
WHERE ref_profile = (select  deposit_profile_id from reports  WHERE ID=INPAR_REPORT_ID) and src_column='dep.ref_deposit_type'
)));
  
  
  VAR := 'INSERT INTO tbl_value_temp_back_test (  

req_id 
,DATA_TYPE  
,ARZ_ID
,SEPORDE_TYPE
,MANDE 
,EFF_DATE 
,BRANCH_ID
,CITY_ID
,STATE_ID
,interval
) 
SELECT 
'||var_req||' 
,DATA_TYPE  
,ARZ_ID 
,SEPORDE_TYPE
,SEPORDE_MANDE 
,EFF_DATE 
,SHOBE_ID
,SHAHR_ID
,OSTAN_ID
,interval
FROM back_test_data
WHERE
report_id   = ' || VAR_ORGINAL_ID || '    
and    ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ')  
and ('||var_seporde_type_condition||')  
and report_type=104;';
--and SEPORDE_TYPE is not null and  SEPORDE_MANDE is not null;';
  --DBMS_OUTPUT.PUT_LINE(VAR);
  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
  COMMIT;
  end if;
  -----------------------------------------------------------------
   if(VAR_type=106) then
  
select substr(str,4) into var_tashilat_type_condition from (select REPLACE(str, '=',' or TASHILAT_TYPE=') as str from (select REPLACE(CONDITION, '#') as str from (
SELECT CONDITION FROM pragg.tbl_profile_detail
WHERE ref_profile = (select  TASHILAT_PROFILE_ID from reports  WHERE ID=INPAR_REPORT_ID) and src_column='lo.ref_loan_type'
)));
  
  VAR := 'INSERT INTO tbl_value_temp_back_test (  

req_id 
,DATA_TYPE  
,ARZ_ID
,tashilat_TYPE
,MANDE 
,EFF_DATE 
,BRANCH_ID
,CITY_ID
,STATE_ID
,interval
) 
SELECT 
'||var_req||' 
,DATA_TYPE  
,ARZ_ID 
,tashilat_type
,tashilat_MANDE 
,EFF_DATE 
,SHOBE_ID
,SHAHR_ID
,OSTAN_ID
,interval
FROM back_test_data
WHERE
report_id   = ' || VAR_ORGINAL_ID || '    
and    ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ') 
and ('||var_tashilat_type_condition||') 
and report_type=106;';
--and tashilat_type is not null and  tashilat_MANDE is not null;';
  --DBMS_OUTPUT.PUT_LINE(VAR);
  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
  COMMIT;
  end if;
  
  
  
  
  
  if(VAR_type!=103 and VAR_type!=105 and VAR_type!=104 and VAR_type!=106) then
--  DELETE FROM tbl_value_temp_back_test WHERE NODE_ID IS NULL;
  DELETE FROM tbl_value_temp_back_test WHERE NODE_ID IS NULL and req_id in (select distinct(id) from tbl_rep_req where category not in (103,105,104,106) );

  COMMIT;
  end if;
  OUTPAR_RES:=1;
  UPDATE TBL_REP_REQ
 SET
  BACK_TEST = 1
WHERE  
  REPORT_ID   =INPAR_REPORT_ID
  and id = var_req;
  
   update tbl_rep_req set is_finish=1 where id=var_req;
 commit;
  
  END ;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_VALUE_GAP
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_REPORT_VALUE_GAP" (
    INPAR_REPORT_ID IN VARCHAR2 )
AS
  VAR            VARCHAR2(30000);
  VAR_ORGINAL_ID NUMBER;
  VAR_LEDGER     NUMBER;
  VAR_MAX_LEVEL  NUMBER;
  VAR_CURRENCY   NUMBER;
  VAR_TIMING     NUMBER;
  var_BRANCH_PROFILE_ID number;
  var_type       NUMBER;
  var_req        NUMBER;
  DATE_TYPE1     NUMBER :=     TO_CHAR(sysdate,'J');      --TO_CHAR(TO_DATE('05-FEB-17'),'J');
BEGIN
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: az in prc dar gozareshat (shekaf ) baraye enteghal dedehaye ke tavasote profile ha entekhab shodand estefade mishavad .
  dar in prc , profile zamani dar nazar gerefte nemishavad.
  */
  /*------------------------------------------------------------------------------*/

  /********************************************************************/
  --EXECUTE IMMEDIATE 'truncate table TBL_VALUE_TEMP_GAP';
  /********************************************************************/
  SELECT ORIGINAL_ID
  INTO VAR_ORGINAL_ID
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
  /********************************************************************/
  SELECT LEDGER_PROFILE_ID
  INTO VAR_LEDGER
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
  
--  select max(id)  INTO VAR_LEDGER from PRAGG.TBL_LEDGER_PROFILE where h_id=VAR_LEDGER;--****
  /********************************************************************/
  SELECT CUR_PROFILE_ID
  INTO VAR_CURRENCY
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
--  select max(id)  INTO VAR_CURRENCY from PRAGG.TBL_PROFILE where h_id=VAR_CURRENCY;--******
  /********************************************************************/
  SELECT BRANCH_PROFILE_ID
  INTO var_BRANCH_PROFILE_ID
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;

  /********************************************************************/
  SELECT MAX(DEPTH)
  INTO VAR_MAX_LEVEL
  FROM PRAGG.TBL_LEDGER_PROFILE_DETAIL
  WHERE REF_LEDGER_PROFILE = VAR_LEDGER;
   /********************************************************************/
   SELECT type
  INTO var_type
  FROM REPORTS
  WHERE ID = INPAR_REPORT_ID;
     /********************************************************************/
  /********************************************************************/

  SELECT MAX(id) INTO var_req FROM tbl_rep_req;
  
  --gozaresh shekafe daftar kol
 if(var_type=170) then
  
  VAR := 'INSERT INTO TBL_VALUE_TEMP_GAP (  

req_id 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth
) SELECT 
'||var_req||' 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth
FROM REPORTS_DATA
WHERE report_id   = ' || VAR_ORGINAL_ID || '    
AND  ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ')      
and  NODE_ID IN   ( select code from pragg.tbl_ledger_profile_detail where ref_ledger_profile = ' || VAR_LEDGER || ' and depth = ' || VAR_MAX_LEVEL || ' ) 
and report_type=107;';
--and  SEPORDE_TYPE is null and TASHILAT_TYPE is null and shobe_id is null  ;';

 EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
 COMMIT;
--  UPDATE tbl_value_temp_gap a
--set
--  a.PARENT           =(select TL.PARENT_CODE from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--,
--  a.DEPTH            =(select TL.DEPTH from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--
--WHERE 
--  a.REQ_ID        =var_req;
--commit;

--aggregation
  FOR j IN 0..3
  LOOP
    FOR i IN reverse 1..VAR_MAX_LEVEL
    LOOP
      INSERT
      INTO TBL_VALUE_TEMP_GAP
        (
          req_id,
          DATA_TYPE,
          ARZ_ID,
          node_ID,
          parent,
          mande,
          depth,
          eff_date
        )
      SELECT var_req ,
        j,
        4,
        code,
        MAX(parent_code),
        SUM(mande),
        MAX(b.DEPTH),
        a.EFF_DATE
      FROM
        (SELECT NODE_ID ,
          MANDE ,
          EFF_DATE ,
          PARENT         FROM TBL_VALUE_TEMP_GAP
        WHERE DATA_TYPE = j
        AND req_id   = var_req
        )a
      LEFT JOIN
        (SELECT code,
          parent_code,
          depth
        FROM PRAGG.TBL_LEDGER_PROFILE_DETAIL
        WHERE REF_LEDGER_PROFILE = VAR_LEDGER
        )b
      ON a.PARENT = b.code
      AND B.DEPTH = i
      AND code   IS NOT NULL
      GROUP BY 
      a.EFF_DATE,
      code;
    END LOOP;
  END LOOP;
  COMMIT;

------------------------------------------------------------------------
 --gozaresh shekafe daftar kol branch
  elsif(var_type=180) then  

 VAR := 'INSERT INTO TBL_VALUE_TEMP_GAP (  

req_id 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth,
branch_id

) SELECT 
'||var_req||' 
,DATA_TYPE 
,NODE_ID 
,ARZ_ID 
,MANDE 
,EFF_DATE ,
parent, 
depth,
SHOBE_ID
FROM REPORTS_DATA
WHERE report_id   = ' || VAR_ORGINAL_ID || '    
and  ARZ_ID IN   ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',VAR_CURRENCY) || ')  
and  SHOBE_ID in ( ' || PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_PROFILE_ID) || ')
and  NODE_ID IN   ( select code from pragg.tbl_ledger_profile_detail where ref_ledger_profile = ' || VAR_LEDGER || ' and depth = ' || VAR_MAX_LEVEL || ' ) 
and report_type=108;';
--and  SEPORDE_TYPE is null and TASHILAT_TYPE is null ;';


  EXECUTE IMMEDIATE 'BEGIN ' || VAR || ' END;';
   COMMIT;
--  UPDATE tbl_value_temp_gap a
--set
--  a.PARENT           =(select TL.PARENT_CODE from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--,
--  a.DEPTH            =(select TL.DEPTH from PRAGG.TBL_LEDGER_profile_detail tl where tl.ref_ledger_profile = VAR_LEDGER and TL.CODE = A.NODE_ID   )
--
--WHERE 
--  a.REQ_ID        =var_req;
--commit;

--aggregation
  FOR j IN 0..3
  LOOP
    FOR i IN reverse 1..VAR_MAX_LEVEL
    LOOP
      INSERT
      INTO TBL_VALUE_TEMP_GAP
        (
          req_id,
          DATA_TYPE,
          ARZ_ID,
          node_ID,
          parent,
          mande,
          depth,
          eff_date,
          BRANCH_ID
        )
      SELECT var_req ,
        j,
        4,
        code,
        MAX(parent_code),
        SUM(mande),
        MAX(b.DEPTH),
        a.EFF_DATE,
        a.BRANCH_ID
      FROM
        (SELECT NODE_ID ,
          MANDE ,
          EFF_DATE ,
          PARENT   ,
          BRANCH_ID
          FROM TBL_VALUE_TEMP_GAP
        WHERE DATA_TYPE = j
        AND req_id   = var_req
        )a
      LEFT JOIN
        (SELECT code,
          parent_code,
          depth
        FROM PRAGG.TBL_LEDGER_PROFILE_DETAIL
        WHERE REF_LEDGER_PROFILE = VAR_LEDGER
        )b
      ON a.PARENT = b.code
      AND B.DEPTH = i
      AND code   IS NOT NULL
      GROUP BY 
      a.BRANCH_ID,
      a.EFF_DATE,
      code ;
    END LOOP;
  END LOOP;
  COMMIT;
  
  end if;
  -------------------------------------------------------------
  
--baraye profile zamani
  PRC_TRANSFER_TIMING_VALUE_GAP ( INPAR_REPORT_ID);
  commit;
END PRC_REPORT_VALUE_GAP;
--------------------------------------------------------
--  DDL for Procedure PRC_TRANSFER_LEDGER
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_TRANSFER_LEDGER" AS
 --------------------------------------------------------------------------------
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description:enteghal daftarkol ha az server bank be  dynamic_lq.tbl_ledger  (bank day) 
  */
  --------------------------------------------------------------------------------
BEGIN

execute immediate 'truncate table TBL_LEDGER';
  /******ebteda hame bargha ra dar TBL_LEDGER mirizim va baed az an be tartib sath be sath bala miaim va sum childha ro hesab mikonim ******/

INSERT INTO TBL_LEDGER (LEDGER_CODE,NAME,PARENT_CODE,node_TYPE,DEPTH)     select gl_code,pragg.fnc_FarsiValidate(gl_name),substr(gl_code,1,7)||'00',case when GL_CODE like '1%'or GL_CODE like '4%' or GL_CODE like '6%' then 1
    when GL_CODE like '2%'or GL_CODE like '3%' or GL_CODE like '5%' or GL_CODE like '7%' then 2
    end  as nd,5 from DADEKAVAN_DAY.gf1glet  where substr (gl_code,8,2) != 0;
  commit;
INSERT INTO TBL_LEDGER (LEDGER_CODE,NAME,PARENT_CODE,node_TYPE,DEPTH)     select gl_code,pragg.fnc_FarsiValidate(gl_name),substr(gl_code,1,5)||'0000',case when GL_CODE like '1%'or GL_CODE like '4%' or GL_CODE like '6%' then 1
    when GL_CODE like '2%'or GL_CODE like '3%' or GL_CODE like '5%' or GL_CODE like '7%' then 2
    end  as nd,4 from DADEKAVAN_DAY.gf1glet where substr(gl_code,6,2) != 0 and substr(gl_code,8,2) = 0;
  commit;
INSERT INTO TBL_LEDGER (LEDGER_CODE,NAME,PARENT_CODE,node_TYPE,DEPTH)     select gl_code,pragg.fnc_FarsiValidate(gl_name),substr(gl_code,1,3)||'000000',case when GL_CODE like '1%'or GL_CODE like '4%' or GL_CODE like '6%' then 1
    when GL_CODE like '2%'or GL_CODE like '3%' or GL_CODE like '5%' or GL_CODE like '7%' then 2
    end  as nd,3 from DADEKAVAN_DAY.gf1glet where substr(gl_code,4,2) != 0 and substr(gl_code,6,4) = 0;
  commit;
INSERT INTO TBL_LEDGER (LEDGER_CODE,NAME,PARENT_CODE,node_TYPE,DEPTH)     select gl_code,pragg.fnc_FarsiValidate(gl_name),substr(gl_code,1,1)||'00000000',case when GL_CODE like '1%'or GL_CODE like '4%' or GL_CODE like '6%' then 1
    when GL_CODE like '2%'or GL_CODE like '3%' or GL_CODE like '5%' or GL_CODE like '7%' then 2
  end  as nd,2 from DADEKAVAN_DAY.gf1glet where substr(gl_code,2,2) != 0 and substr(gl_code,4,6) = 0;
  commit;
INSERT INTO TBL_LEDGER (LEDGER_CODE,NAME,PARENT_CODE,node_TYPE,DEPTH)     select gl_code,pragg.fnc_FarsiValidate(gl_name),0,case when GL_CODE like '1%'or GL_CODE like '4%' or GL_CODE like '6%' then 1
    when GL_CODE like '2%'or GL_CODE like '3%' or GL_CODE like '5%' or GL_CODE like '7%' then 2
  end  as nd,1 from DADEKAVAN_DAY.gf1glet where substr(gl_code,1,1) != 0 and substr(gl_code,2,8) = 0;
  commit;
    /******ezafe kardanerishe be derakht ******/

INSERT INTO TBL_LEDGER (LEDGER_CODE,NAME,PARENT_CODE,node_TYPE,DEPTH)     values (000000,'ريشه',null,null,0);
  commit;

PRC_UPDATE_LEDGER_NODE_ID_TYPE;
commit;

END PRC_TRANSFER_LEDGER;
--------------------------------------------------------
--  DDL for Procedure PRC_TRANSFER_TIMING_VALUE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_TRANSFER_TIMING_VALUE" ( INPAR_REPORT_ID IN VARCHAR2 ) AS

 VAR_QUERY        VARCHAR2(30000);
 VAR_ORGINAL_ID   NUMBER;
 VAR_LEDGER       NUMBER;
 VAR_MAX_LEVEL    NUMBER;
 VAR_CURRENCY     NUMBER;
 ID_TIMING        NUMBER;
 VAR_REQ          NUMBER;
 DATE_TYPE1       NUMBER := TO_CHAR(TO_DATE(trunc(sysdate)),'J'); /* to_cHAR(sysdate,'J');  */
 VAR_TYPE         NUMBER;
BEGIN  
 SELECT
  MAX(ID)
 INTO
  VAR_REQ
 FROM TBL_REP_REQ
 WHERE REPORT_ID   = INPAR_REPORT_ID;

 SELECT
  TIMING_PROFILE_ID
 INTO
  ID_TIMING
 FROM REPORTS
 WHERE ID   = INPAR_REPORT_ID;

 SELECT
  LEDGER_PROFILE_ID
 INTO
  VAR_LEDGER
 FROM REPORTS
 WHERE ID   = INPAR_REPORT_ID;

 SELECT
  TYPE
 INTO
  VAR_TYPE
 FROM REPORTS
 WHERE ID   = INPAR_REPORT_ID;


----------------------------------------------------------------------------------------
 FOR I IN (
  SELECT
   TTPD.ID
  ,TTP.TYPE
  ,TTPD.PERIOD_NAME
  ,TTPD.PERIOD_DATE
  ,TTPD.PERIOD_START
  ,TTPD.PERIOD_END
  ,TTPD.PERIOD_COLOR
  FROM PRAGG.TBL_TIMING_PROFILE TTP
  ,    PRAGG.TBL_TIMING_PROFILE_DETAIL TTPD
  WHERE TTP.ID   = TTPD.REF_TIMING_PROFILE
   AND
    TTP.ID   = ID_TIMING
    order by TTPD.ID
 ) LOOP
  IF
   ( I.TYPE = 1 )
  THEN/******agar profile zamani entekhab shode bazehee bashad *****--*/
   SELECT
    'INSERT INTO TBL_VALUE (
 REQ_ID
 ,DATA_TYPE
 ,NODE_ID
 ,ARZ_ID
 ,MANDE
 ,SEPORDE_TYPE
 ,TASHILAT_TYPE
 ,EFF_DATE
 ,DEPTH
 ,PARENT
 ,interval
 ,BRANCH_ID
 ,CITY_ID
 ,STATE_ID
 ,ref_timing

)  SELECT
 REQ_ID
 ,DATA_TYPE
 ,NODE_ID
 ,ARZ_ID
 ,MANDE
 ,SEPORDE_TYPE
 ,TASHILAT_TYPE
 ,EFF_DATE
 ,DEPTH
 ,PARENT
 ,interval
 ,BRANCH_ID
 ,CITY_ID
 ,STATE_ID
 ,
' ||
    I.ID ||
    '
FROM TBL_VALUE_TEMP
where REQ_ID =' ||
    VAR_REQ ||
    '  and DATA_TYPE =3 and
 EFF_DATE > ' ||
    DATE_TYPE1 ||
    '
    and EFF_DATE <= ' ||
    DATE_TYPE1 ||
    '+' ||
    I.PERIOD_DATE ||
    '  ;'
   INTO
    VAR_QUERY
   FROM DUAL;

  -- DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
   EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
   COMMIT;
   DATE_TYPE1   := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
  ELSE /******agar profile zamani entekhab shode tarikhi bashad *****--*/
   SELECT
    'INSERT INTO TBL_VALUE (
 REQ_ID
 ,DATA_TYPE
 ,NODE_ID
 ,ARZ_ID
 ,MANDE
 ,SEPORDE_TYPE
 ,TASHILAT_TYPE
 ,EFF_DATE
 ,DEPTH
 ,PARENT
 ,interval
 ,BRANCH_ID
 ,CITY_ID
 ,STATE_ID
 ,ref_timing
)  SELECT
 REQ_ID
 ,DATA_TYPE
 ,NODE_ID
 ,ARZ_ID
 ,MANDE
 ,SEPORDE_TYPE
 ,TASHILAT_TYPE
 ,EFF_DATE
 ,DEPTH
 ,PARENT 
 ,interval
 ,BRANCH_ID
 ,CITY_ID
 ,STATE_ID
 ,
' ||
    I.ID ||
    '
FROM TBL_VALUE_TEMP
where REQ_ID =' ||
    VAR_REQ ||
    '  and DATA_TYPE =3 and EFF_DATE > to_char(to_date(''' ||
    I.PERIOD_START ||
    '''),''j'') and  EFF_DATE <= to_char(to_date (''' ||
    I.PERIOD_END ||
    '''),''j'') ;'
   INTO
    VAR_QUERY
   FROM DUAL;

 --  DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
   EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
   COMMIT;
  END IF;
 END LOOP;

 COMMIT;
 
--  update tbl_rep_req set is_finish=1 where id=VAR_REQ;
-- commit;
 
END PRC_TRANSFER_TIMING_VALUE;
--------------------------------------------------------
--  DDL for Procedure PRC_DASHBOARD_DAILY_REPORT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_DASHBOARD_DAILY_REPORT" AS 
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name:  sobhan sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description:  sakht gozaresh dashbord ;
  TBL_DASHBOaRD_DAILY_REPORT  be surate ruzane delete mishavad .
  */
  /*------------------------------------------------------------------------------*/
  var_max_report_id number;
BEGIN

 EXECUTE IMMEDIATE 'truncate table dynamic_lq.TBL_DASHBOaRD_DAILY_REPORT';
 commit;
select max(id) into var_max_report_id from reports where type=100 and status=2;


-------------------------------------------------type=1
insert into dynamic_lq.TBL_DASHBOaRD_DAILY_REPORT 
(
EFFDATE,
IN_FLOW,
OUT_FLOW,
GAP,
data_type
)

select 
eff_date,
input,
abs(output),
input-abs(output) as gap,
1
from (
SELECT * FROM
(
select eff_date,sum(gap) as gap,sign from (

select 
eff_date,
gap as gap,
case when gap <0 then -1 else 1 end as sign
from (     

select 
t.eff_date,
CASE
            WHEN l.node_type=2
            THEN t.gap*-1
            WHEN l.node_type=1
            THEN t.gap*1
            ELSE 0
          END AS gap         
 from (   


select 
eff_date,
node_id,
mande-mande2 as gap
 from (
SELECT 
  SUM(a.mande) as mande,
  a.eff_date,
  a.node_id ,
  (SELECT 
  SUM(b.mande) as mande  
FROM reports_data b
WHERE report_id=var_max_report_id and report_type=107   AND data_type=1 
AND b.eff_date BETWEEN TO_CHAR(sysdate,'J')-365 AND TO_CHAR(sysdate,'J')-1
and a.node_id=b.node_id and b.eff_date=a.eff_date-1
GROUP BY eff_date,node_id) as mande2

  
FROM reports_data a
WHERE report_id=var_max_report_id and REPORT_TYPE=107  AND data_type=1 
AND eff_date BETWEEN TO_CHAR(sysdate,'J')-365 AND TO_CHAR(sysdate,'J')-1
GROUP BY eff_date,node_id
)) t
 INNER JOIN tbl_ledger l
        ON t.node_id=l.ledger_code

)
)group by eff_date,sign
)
PIVOT
(
  max(gap)
  FOR sign IN (1 as input,-1 as output)
)

);
commit;
-----------------------------------------------------type=3
insert into dynamic_lq.TBL_DASHBOaRD_DAILY_REPORT 
(
EFFDATE,
IN_FLOW,
OUT_FLOW,
GAP,
data_type
)
select 
eff_date,
input,
abs(output),
input-abs(output) as gap,
3
from (
SELECT * FROM
(
select eff_date,sum(gap) as gap,sign from (

select 
eff_date,
gap as gap,
case when gap <0 then -1 else 1 end as sign
from (     

select 
t.eff_date,
CASE
            WHEN l.node_type=2
            THEN t.gap*-1
            WHEN l.node_type=1
            THEN t.gap*1
            ELSE 0
          END AS gap         
 from (   


select 
eff_date,
node_id,
mande-mande2 as gap
 from (
SELECT 
  SUM(a.mande) as mande,
  a.eff_date,
  a.node_id ,
  (SELECT 
  SUM(b.mande) as mande  
FROM reports_data b
WHERE report_id=var_max_report_id and report_type=107   AND data_type=1 
 and b.eff_date=a.eff_date-1 and a.node_id=b.node_id
GROUP BY eff_date,node_id) as mande2

  
FROM reports_data a
WHERE report_id=var_max_report_id and report_type=107   AND data_type=3 
AND  a.eff_date =TO_CHAR(sysdate,'J')
GROUP BY eff_date,node_id
)) t
 INNER JOIN tbl_ledger l
        ON t.node_id=l.ledger_code

)
)group by eff_date,sign
)
PIVOT
(
  max(gap)
  FOR sign IN (1 as input,-1 as output)
)

);
commit;


--------------------------------------------------type=3
insert into dynamic_lq.TBL_DASHBOaRD_DAILY_REPORT 
(
EFFDATE,
IN_FLOW,
OUT_FLOW,
GAP,
data_type
)
select 
eff_date,
input,
abs(output),
input-abs(output) as gap,
3
from (
SELECT * FROM
(
select eff_date,sum(gap) as gap,sign from (

select 
eff_date,
gap as gap,
case when gap <0 then -1 else 1 end as sign
from (     

select 
t.eff_date,
CASE
            WHEN l.node_type=2
            THEN t.gap*-1
            WHEN l.node_type=1
            THEN t.gap*1
            ELSE 0
          END AS gap         
 from (   


select 
eff_date,
node_id,
mande-mande2 as gap
 from (
SELECT 
  SUM(a.mande) as mande,
  a.eff_date,
  a.node_id ,
  (SELECT 
  SUM(b.mande) as mande  
FROM reports_data b
WHERE report_id=var_max_report_id and report_type=107  AND data_type=3 
and b.eff_date=a.eff_date-1 and a.node_id=b.node_id 
GROUP BY eff_date,node_id) as mande2

  
FROM reports_data a
WHERE report_id=var_max_report_id and report_type=107  AND data_type=3
AND  a.eff_date >TO_CHAR(sysdate,'J')
GROUP BY eff_date,node_id
)) t
 INNER JOIN tbl_ledger l
        ON t.node_id=l.ledger_code

)
)group by eff_date,sign
)
PIVOT
(
  max(gap)
  FOR sign IN (1 as input,-1 as output)
)

);
commit;



 
END prc_DASHBOARD_DAILY_REPORT;
--------------------------------------------------------
--  DDL for Procedure PRC_LEDGER_BRANCH
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_LEDGER_BRANCH" AS 
var_BRANCH_ID            number;
var_parent              number;

BEGIN
EXECUTE IMMEDIATE 'truncate table TBL_LEDGER_BRANCH';

  insert into TBL_LEDGER_BRANCH(
OSTAN_ID,
SHAHR_ID,
SHOBE_ID,
NODE_ID,
PARENT,
NAME,
DEPTH
)
values
(
0,0,0,0,null,'ايران',0
);
commit;

--execute IMMEDIATE  'begin insert into tbl_temp (id) ('||PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_ID)||');end;';
commit;

for i in (select max(STA_NAME)as STA_NAME ,ref_sta_id from pragg.tbl_branch group by ref_sta_id) loop  --ostan
--select max(id)+1 into var_max_id from tbl_get_ledger_branch_gap;
insert into TBL_LEDGER_BRANCH(
OSTAN_ID,
SHAHR_ID,
SHOBE_ID,
NODE_ID,
PARENT,
NAME,
DEPTH
)
values
(
i.REF_STA_ID,
0,
0,
i.REF_STA_ID||'00',
0,
i.STA_NAME,
1
); 
commit;
for b in (select max(CITY_NAME) as CITY_NAME,REF_CTY_ID  ,max(REF_STA_ID)as REF_STA_ID,max(STA_NAME) as STA_NAME from pragg.tbl_branch where  REF_STA_ID=i.REF_STA_ID   group by REF_CTY_ID) loop  --shahr
--select max(id)+1 into var_max_id from tbl_get_ledger_branch_gap;
select distinct(REF_STA_ID)||'00' into var_parent from pragg.tbl_branch where REF_CTY_ID=b.REF_CTY_ID;

insert into TBL_LEDGER_BRANCH(
OSTAN_ID,
SHAHR_ID,
SHOBE_ID,
NODE_ID,
PARENT,
NAME,
DEPTH
)
values
(
b.REF_STA_ID,
b.REF_CTY_ID,
0,
b.REF_STA_ID||b.REF_CTY_ID||0,
var_parent,
b.CITY_NAME,
2
);
commit;

for c in (select * from pragg.tbl_branch where REF_CTY_ID=b.REF_CTY_ID    order by BRN_ID) loop  --shobe
select node_id into var_parent from TBL_LEDGER_BRANCH where OSTAN_ID=c.REF_STA_ID and SHAHR_ID=c.REF_CTY_ID and shobe_id=0;
--select max(id)+1 into var_max_id from tbl_get_ledger_branch_gap;
insert into TBL_LEDGER_BRANCH(
OSTAN_ID,
SHAHR_ID,
SHOBE_ID,
NODE_ID,
PARENT,
NAME,
DEPTH
)
values
(
c.REF_STA_ID,
c.REF_CTY_ID,
c.BRN_ID,
c.REF_STA_ID||c.REF_CTY_ID||c.BRN_ID,
var_parent,
c.NAME,
3
);
commit;


insert into TBL_LEDGER_BRANCH(
OSTAN_ID,
SHAHR_ID,
SHOBE_ID,
NODE_ID,
PARENT,
NAME,
DEPTH,
NODE_TYPE,
code
)
(
select 
c.REF_STA_ID,
c.REF_CTY_ID,
c.BRN_ID,
c.BRN_ID||LEDGER_CODE,
c.REF_STA_ID||c.REF_CTY_ID||c.BRN_ID,
NAME,
4,
NODE_TYPE,
LEDGER_CODE
from tbl_ledger
where depth=1
)
;
commit;
--end loop; -- loop d
end loop; -- loop c
end loop; -- loop b
end loop; 
  
  
  
END PRC_LEDGER_BRANCH;
--------------------------------------------------------
--  DDL for Procedure PRC_UPDATE_LEDGER_NODE_ID_TYPE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_UPDATE_LEDGER_NODE_ID_TYPE" AS 
 
BEGIN

 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: moshakhas kardane mahiyate har code sarfasl ba update kardane jadvale tbl_ledger
  */
  /*------------------------------------------------------------------------------*/
for i in (select * from tbl_ledger where PARENT_CODE=0) loop

if(i.ledger_code=100000000 or i.ledger_code=500000000 or i.ledger_code=600000000) then 
UPDATE tbl_ledger
SET node_type      ='1'
WHERE ledger_code IN
  (SELECT LEDGER_CODE
  FROM tbl_ledger
    CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE
    START WITH LEDGER_CODE       = i.ledger_code
  );
 commit; 
ELSIF (i.ledger_code=400000000 or i.ledger_code=200000000 or i.ledger_code=300000000 or i.ledger_code=700000000) then  
UPDATE tbl_ledger
SET node_type      ='2'
WHERE ledger_code IN
  (SELECT LEDGER_CODE
  FROM tbl_ledger
    CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE
    START WITH LEDGER_CODE       = i.ledger_code
  ); 
  commit;
  ELSIF ( i.ledger_code=800000000) then  -- type=3  -- null
UPDATE tbl_ledger
SET node_type      ='3'
WHERE ledger_code IN
  (SELECT LEDGER_CODE
  FROM tbl_ledger
    CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE
    START WITH LEDGER_CODE       = i.ledger_code
  ); 
    end if;
 end loop; 
   commit;



--if(i.ledger_code=10000000000 or i.ledger_code=50000000000 or i.ledger_code=30000000000) then  -- type=2
--UPDATE tbl_ledger
--SET node_type      ='2'
--WHERE ledger_code IN
--  (SELECT LEDGER_CODE
--  FROM tbl_ledger
--    CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE
--    START WITH LEDGER_CODE       = i.ledger_code
--  );
--  
--ELSIF (i.ledger_code=40000000000 or i.ledger_code=20000000000 ) then  -- type=1
--UPDATE tbl_ledger
--SET node_type      ='1'
--WHERE ledger_code IN
--  (SELECT LEDGER_CODE
--  FROM tbl_ledger
--    CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE
--    START WITH LEDGER_CODE       = i.ledger_code
--  ); 
--  
--  ELSIF (i.ledger_code=600000000 or i.ledger_code=700000000 or i.ledger_code=800000000) then  -- type=3  -- null
--UPDATE tbl_ledger
--SET node_type      ='3'
--WHERE ledger_code IN
--  (SELECT LEDGER_CODE
--  FROM tbl_ledger
--    CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE
--    START WITH LEDGER_CODE       = i.ledger_code
--  ); 
--    end if;
-- end loop; 
--   commit;
END PRC_UPDATE_LEDGER_NODE_ID_TYPE;
--------------------------------------------------------
--  DDL for Procedure PRC_ARZ_RELATION
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_ARZ_RELATION" AS 
VAR_MAX_DATE number;
BEGIN
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: meghdare har arz dar har ruz be surate afzayeshi (baraye estefade hajizade)
  */
  /*------------------------------------------------------------------------------*/
-- EXECUTE IMMEDIATE 'truncate table  DYNAMIC_LQ.arz_relation';
--+599
 select max(eff_date) INTO VAR_MAX_DATE from DYNAMIC_LQ.ARZ_RELATION;
VAR_MAX_DATE:=nvl(VAR_MAX_DATE,0);
 
insert into DYNAMIC_LQ.arz_relation(ARZ_ID,EFF_DATE,RATE)
SELECT distinct 
  c.cur_id,
  TO_CHAR(TO_DATE(ar.EFFDATE),'J'),
  ar.RATE_AMOUNT
FROM DADEKAVAN_DAY.ARZ_RELATION ar,
  PRAGG.TBL_CURRENCY c
WHERE ar.CODE=c.SWIFT_CODE 
and TO_CHAR(trunc(effdate), 'j')>VAR_MAX_DATE;

commit;

delete from dynamic_lq.arz_relation where 
eff_date||ARZ_ID in (
select eff_date||ARZ_ID from (
SELECT distinct count(eff_date) cnt,ARZ_ID,eff_date FROM  arz_relation GROUP BY eff_date,ARZ_ID
)where cnt>1); 



--2458162
END PRC_ARZ_RELATION;
--------------------------------------------------------
--  DDL for Procedure ACTIVE_DEACTIVE_SETTING_MODEL
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."ACTIVE_DEACTIVE_SETTING_MODEL" 
(
  INPAR_ID IN varchar2 ,OUTPAR     OUT VARCHAR2
) AS 
VAR_CNT NUMBER;
var_is_active number;
BEGIN

 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: az in prc baraye active va deactive (entekhab profile) kardane profle haye tanzimate shabake asabi estefade mishav
  */
  /*------------------------------------------------------------------------------*/
--taghirat ebteda dar jadvale TBL_PROFILE_MODEL_SETTING va sepas dar jadvale NN_PARAM(baraye estefade hajizade) emal mishavand

update TBL_PROFILE_MODEL_SETTING
   set IS_ACTIVE = case when IS_ACTIVE = 1 then 0 else 1 end
where ID = INPAR_ID;

update NN_PARAM
   set ACTIVE = case when ACTIVE = 1 then 0 else 1 end
where PROFILE_ID = INPAR_ID;
commit;
------------------------------------------
--baraye active budan faghat yek profile
select IS_ACTIVE into var_is_active from TBL_PROFILE_MODEL_SETTING where ID = INPAR_ID;

if (var_is_active=1) then
update TBL_PROFILE_MODEL_SETTING set IS_ACTIVE=0 where id!=INPAR_ID;
update NN_PARAM                  set ACTIVE=0    where PROFILE_ID!=INPAR_ID;
end if;

--agar hich profili  active nabud   , akharin profile sakhte shode active mabashd
SELECT COUNT (*) INTO VAR_CNT FROM NN_PARAM WHERE ACTIVE=0;
IF(VAR_CNT=0) THEN
UPDATE NN_PARAM SET ACTIVE=1 WHERE ID=(SELECT MAX(ID) FROM NN_PARAM) ;
UPDATE TBL_PROFILE_MODEL_SETTING SET IS_ACTIVE=1 WHERE ID=(SELECT MAX(ID) FROM TBL_PROFILE_MODEL_SETTING) ;
END IF;
-------------------------------------------

END ACTIVE_DEACTIVE_SETTING_MODEL;
--------------------------------------------------------
--  DDL for Procedure PRC_PROFILE_MODEL_SETING
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_PROFILE_MODEL_SETING" (
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    INPAR_CREATE_DATE      IN VARCHAR2 ,
    INPAR_REF_USER         IN VARCHAR2 ,   
    INPAR_STATUS           IN VARCHAR2 , 
    inpar_insert_or_update IN VARCHAR2 , --insert = 1 & update = 0
    inpar_id               IN VARCHAR2 ,  --h_id
    INPAR_REF_PROFILE      IN VARCHAR2 ,
    inpar_REF_USER_UPDATE  IN VARCHAR2 ,


    outpar_id OUT VARCHAR2 ) AS
    
    iidd number;
    var_max_id1 number;
    var_max_id2 number;
    var_cnt     number;
    VAR VARCHAR2(4000);
    var_version number;
BEGIN
 
var_version:=1;
-- 
  IF (inpar_insert_or_update= 1) THEN
    INSERT
    INTO TBL_PROFILE_MODEL_SETTING
      (
        NAME,
        DES,
        CREATE_DATE,
        REF_USER,
        STATUS,
        version
      )
      VALUES
      (
        pragg.fnc_FarsiValidate(INPAR_NAME) ,
        INPAR_DES ,
        sysdate ,
        INPAR_REF_USER ,
        INPAR_STATUS,
        var_version
      );
    COMMIT;
  
  select max(id)  into var_max_id1 from TBL_PROFILE_MODEL_SETTING;
  outpar_id:=var_max_id1;
  
  update TBL_PROFILE_MODEL_SETTING set h_id=var_max_id1 where id=var_max_id1;
  commit;

Insert into nn_param (PROFILE_ID)VALUES(var_max_id1);
 COMMIT;
 
 
 else
 
  INSERT INTO TBL_PROFILE_MODEL_SETTING
      (
        NAME,
        DES,
        CREATE_DATE,
        UPDATE_DATE,
        version,
        REF_USER,
        STATUS,
        H_ID
         
      )
      VALUES
      (
        pragg.fnc_FarsiValidate(INPAR_NAME),
        INPAR_DES ,
        INPAR_CREATE_DATE   ,
        sysdate,
        (select max(version)+1 from TBL_PROFILE_MODEL_SETTING where H_id = INPAR_REF_PROFILE),
        INPAR_REF_USER ,
        INPAR_STATUS,
       inpar_id
         
      );
    COMMIT;
   SELECT id
    INTO outpar_id
    FROM TBL_PROFILE_MODEL_SETTING
    WHERE id =
          (SELECT MAX(id) FROM TBL_PROFILE_MODEL_SETTING where h_id = INPAR_REF_PROFILE
          );
              
  end if;
 
update TBL_PROFILE_MODEL_SETTING 
set status = 0
where id not in (select max(id) from TBL_PROFILE_MODEL_SETTING group by h_id);
commit; 
 
 ------------------------------------------------------------------
 
 var_cnt:=0;
  for i in (select id from TBL_PROFILE_MODEL_SETTING)
 loop
    select count(*) into var_cnt from TBL_PROFIL_MODEL_SETING_DETAIL where REF_PROFILE_ID = i.id and VALUE is not null;
    if (var_cnt = 0) then 
      update TBL_PROFILE_MODEL_SETTING set is_empty = 1 where id = i.id;
      commit;
    else if(var_cnt > 0 ) then
      update TBL_PROFILE_MODEL_SETTING set is_empty = 0 where id = i.id;
      commit;
    end if;
    end if;
 end loop;
 
 
 
 
 
 
 
 
 
 
 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- 
-- select max(id)  into var_max_id2 from nn_param;
-- 
--
----insert into TBL_PROFIL_MODEL_SETING_DETAIL
----(
----FA_NAME,
----EN_NAME,
----DES,
----PROFILE_ID
----)
----select 
----FA_NAME,
----EN_NAME,
----DES,
----var_max_id1
----from TBL_NN_PARAM_NAMES order by id;
----commit;
--
--FOR I IN (SELECT * FROM TBL_NN_PARAM_NAMES) LOOP
--VAR:='UPDATE nn_param SET '||I.EN_NAME||'='||I.VALUE||' WHERE ID='||var_max_id2||';';
--EXECUTE IMMEDIATE VAR;
--END LOOP;
--
----    insert into nn_param(
----    ERROR_FUNC,
----ACTV_FUNC,
----HIDDEN_SIZE,
----VALID_CHECK_NUM,
----LAG,
----PRD_DAYS,
----TRAIN_WINDOW,
----VALIDATION,
----TEST,
----BACKTEST_NUM,
----ACTIVE,
----LAST_DATE,
----SMOOTH_DEG,
----SMOOTH_FRAME,
----PROFILE_ID)
----values
----(
----inpar_ERROR_FUNC,
----inpar_ACTV_FUNC,
----inpar_HIDDEN_SIZE,
----inpar_VALID_CHECK_NUM,
----inpar_LAG,
----inpar_PRD_DAYS,
----inpar_TRAIN_WINDOW,
----inpar_VALIDATION,
----inpar_TEST,
----inpar_BACKTEST_NUM,
----inpar_ACTIVE,
----0,
----inpar_SMOOTH_DEG,
----inpar_SMOOTH_FRAME,
----inpar_PROFILE_ID
----);
--    
--    else -- (inpar_insert_or_update= 0) THEN  
--    
--    update TBL_PROFILE_MODEL_SETTING set
--    
--        DES=INPAR_DES,
--        UPDATE_DATE=inpar_UPDATE_DATE,
--        REF_USER_UPDATE=inpar_REF_USER_UPDATE
--        where id=inpar_id;
--        
--   FOR I IN (SELECT * FROM TBL_NN_PARAM_NAMES) LOOP
--
--VAR:='UPDATE nn_param SET '||I.EN_NAME||'='||I.VALUE||' WHERE PROFILE_ID='||var_max_id2||';';
--EXECUTE IMMEDIATE VAR;
--COMMIT;
--END LOOP;
--    
----    update nn_param set
----    ERROR_FUNC=inpar_ERROR_FUNC,
----    ACTV_FUNC=inpar_ACTV_FUNC,
----    HIDDEN_SIZE=inpar_HIDDEN_SIZE,
----VALID_CHECK_NUM=inpar_VALID_CHECK_NUM,
----LAG=inpar_LAG,
----PRD_DAYS=inpar_PRD_DAYS,
----TRAIN_WINDOW=inpar_TRAIN_WINDOW,
----VALIDATION=inpar_VALIDATION,
----TEST=inpar_TEST,
----BACKTEST_NUM=inpar_BACKTEST_NUM,
----ACTIVE=inpar_ACTIVE,
----LAST_DATE=0,
----SMOOTH_DEG=inpar_SMOOTH_DEG,
----SMOOTH_FRAME=inpar_SMOOTH_FRAME
---- where profile_id=inpar_id;
--    
--  end if;  
--    
    
 
    
   
 
END PRC_profile_MODEL_SETING;
--------------------------------------------------------
--  DDL for Procedure PRC_PROFIL_MODEL_SETING_DETAIL
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_PROFIL_MODEL_SETING_DETAIL" ( 
INPAR_ID               IN VARCHAR2 , --h_id
INPAR_value            IN VARCHAR2,
inpar_EN_NAME          IN VARCHAR2,
outpar                 out varchar2
)AS 
var_cnt number;
var_max_id1  number;
var VARCHAR2(4000);
BEGIN

--select max(id)  into var_max_id1 from TBL_PROFILE_MODEL_SETTING where h_id=INPAR_ID;

update TBL_PROFIL_MODEL_SETING_DETAIL set value=INPAR_value where ref_profile_id=INPAR_ID and EN_NAME=inpar_EN_NAME ;
commit;
var:='begin update nn_param set '||inpar_EN_NAME||'='||INPAR_value||' where PROFILE_ID='||''''||INPAR_ID||''''||';end;';
execute IMMEDIATE var;
commit;


 
END PRC_PROFIL_MODEL_SETING_DETAIL;
--------------------------------------------------------
--  DDL for Procedure PRC_DELETE_PROFILE_SETTING
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_DELETE_PROFILE_SETTING" (inpar_h_id in varchar2,OUTPAR     OUT VARCHAR2) AS 
BEGIN
 
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: az in prc baraye hazf kardane profile tanzimat esefade mishavad
  
  */
  /*------------------------------------------------------------------------------*/
  delete from TBL_PROFIL_MODEL_SETING_DETAIL where REF_PROFILE_ID in (select id from TBL_PROFILE_MODEL_SETTING where  h_id=inpar_h_id);
   delete from TBL_PROFILE_MODEL_SETTING where h_id=inpar_h_id;
   delete from nn_param where profile_id=inpar_h_id;
  commit;
END PRC_DELETE_PROFILE_SETTING;
--------------------------------------------------------
--  DDL for Procedure PRC_DELETE_OLD_REPORTS
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_DELETE_OLD_REPORTS" AS

BEGIN

for i in (
SELECT r.id,r.created,rs.ARCHIVE_PERIOD,TRUNC(r.created+rs.ARCHIVE_PERIOD) as expire_date,r.type,r.archived
FROM dynamic_lq.REPORTS r,dynamic_lq.reports_setting rs
where 
  r.TYPE      =rs.REPORT_TYPE 
AND r.ARCHIVED    =0
and (r.type=100 or  r.type=200 or r.type=1) )
loop


if(i.expire_date<=TRUNC(sysdate)) then
delete from dynamic_lq.reports where id=i.id;
commit;
end if;

end loop;

commit;
END PRC_DELETE_OLD_REPORTS;
--------------------------------------------------------
--  DDL for Procedure FULL_PROC
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."FULL_PROC" AS 
BEGIN

--be surate ruzane
-----------------------------------------
prc_DELETE_OLD_REPORTS;
  commit;
-----------------------------------------
PRC_ARZ_RELATION;        --bank_day /
  commit;
PRC_ENTEGHAL_TO_DYNAMIC; --bank_day /--SEPORDE_TYPE_MANDE - SEPORDE_SHOBE_MANDE - TASHILAT_TYPE_MANDE - TASHILAT_SHOBE_MANDE
  commit;
DAY_HISTORICAL_GL_ARZ;       --bank_day /-
--tjr_HISTORICAL_GL_ARZ;   --tejarat
  commit;
DAY_HISTORICAL_GL_ARZ_SHOBE; --bank_day /-
--tjr_HISTORICAL_GL_ARZ_SHOBE;  --tejarat
  commit;
-----------------------------------------
  ALL_RELATION;
  commit;
--------------------------------------------
 prc_DASHBOARD_DAILY_REPORT;
  commit;
-------------------------------------------
--PRC_ENTEGHAL_DEPOSIT;  --rosub zudbardasht
--commit;


-----------------------------------------------------------------------------------
--//////////////////////////////////////////////////////////////////////////////////////
-----------------------------------------------------------------------------------
--faghat 1 bar
---------------------------------------------------------------------------
--daftar_kol dynamic_lq.tbl_ledger

--  EXECUTE IMMEDIATE 'truncate table TBL_LEDGER';
--  PRC_TRANSFER_LEDGER;  -- bank day
--  PRC_UPDATE_LEDGER_NODE_ID_TYPE;  --bad az por kardane tbl_ledger tavasote hamkarane tehrani
--  commit;
  -------------------------------------------------------------------------

---------- rosub
--  delete from pragg.tbl_timing_profile where ID=-85;
--  delete from PRAGG.TBL_TIMING_PROFILE_DETAIL where REF_TIMING_PROFILE=-85;
--commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE(
--ID,
--NAME,
--TYPE,
--CREATE_DATE,
--REF_USER,
--STATUS,
--DES,
--UPDATE_DATE,
--REF_USER_UPDATE,
--VERSION,
--H_ID,
--IS_EMPTY,
--REPORT_CNT,
--PERIOD_DURATION
--)
--VALUES
--(
--  -85,
--  'بازه هاي همگن زودبرداشت رسوب',
--  1,
--  SYSDATE,
--  'admin',
--  2,
--  NULL,
--  NULL,
--  NULL,
--  1,
--  -85,
--  0,
--  NULL,
--  358
--);
--
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'روز1',1);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'روز2',1);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'روز3',1);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'روز4',1);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'روز5',1);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'روز6',1);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'روز7',1);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'هفته دوم',7);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'هفته سوم',7);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'هفته چهارم',7);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'ماده دوم',30);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'ماه سوم',30);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'ماه چهارم',30);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'ماه پنجم',30);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'ماه ششم',30);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'ماه هفتم',30);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'ماه هشتم',30);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'ماه نهم',30);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'ماه دهم',30);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'ماه يازدهم',30);commit;
--INSERT INTO PRAGG.TBL_TIMING_PROFILE_DETAIL(REF_TIMING_PROFILE,PERIOD_NAME,PERIOD_DATE) VALUES(-85,'ماه دوازدهم',30);commit;

 ----------------------------------------------------------------------- 
  
  
  
END full_proc;
--------------------------------------------------------
--  DDL for Procedure PRC_NOTIFICATION
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."PRC_NOTIFICATION" 
(
  INPAR_OPT_TYPE IN VARCHAR2
, INPAR_ID IN NUMBER  DEFAULT NULL
, INPAR_TYPE IN VARCHAR2  DEFAULT NULL
, INPAR_class IN VARCHAR2  DEFAULT NULL
, INPAR_TITLE IN VARCHAR2 DEFAULT NULL
, INPAR_STATUS IN VARCHAR2 DEFAULT NULL
, INPAR_USER_ID IN VARCHAR2 DEFAULT NULL
, INPAR_DESCRIPTION IN VARCHAR2 DEFAULT NULL
, INPAR_REF_REPORT IN VARCHAR2 DEFAULT NULL 
, INPAR_REF_REPREQ IN VARCHAR2 DEFAULT NULL
, INPAR_REF_REPPER_DATE IN varchar2 DEFAULT NULL
, inpar_flag   IN varchar2 DEFAULT NULL
, OUTPAR_STATUS OUT VARCHAR2
)   AS 
 --------------------------------------------------------------------------------
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:anjam amaliyat hay lazem baray darj - beroz resani - hazf va daryaft elanat
  */
  --------------------------------------------------------------------------------


BEGIN


IF INPAR_OPT_TYPE = 'insert' THEN 
  --=======INSERT================ Darj yek elan jadid.
INSERT
INTO pragg.TBL_NOTIFICATIONS
  (
   
    TITLE,
    TYPE,
    class,
    REF_USER,
    START_TIME,
    STATUS,
    DESCRIPTION,
    REF_REPORT
  )
  VALUES
  (
   
    INPAR_TITLE,
    INPAR_TYPE,
    INPAR_class,
    INPAR_USER_ID,
    sysdate,
    'progress',
    INPAR_DESCRIPTION,
    INPAR_REF_REPORT
  );
  
  select max(id) into OUTPAR_STATUS from pragg.TBL_NOTIFICATIONS;
  Commit;
 END IF; 
 
IF INPAR_OPT_TYPE = 'update' THEN 
  --=======UPDATE================Berozresani yek elan mojod.
   UPDATE pragg.TBL_NOTIFICATIONS
   SET STATUS           =INPAR_STATUS 
   , END_TIME = sysdate 
   , REF_REPREQ = INPAR_REF_REPREQ
   , REF_REPPER_DATE = INPAR_REF_REPPER_DATE
   , flag = inpar_flag
   WHERE ID        = INPAR_ID
   ;
   Commit;
 END IF; 

IF INPAR_OPT_TYPE = 'delete' THEN
  --=======DELETE================  Haz yek elan mojod.
  DELETE
  FROM pragg.TBL_NOTIFICATIONS
  WHERE ID        = INPAR_ID;
  Commit;
END IF;

IF INPAR_OPT_TYPE = 'check' THEN
  --=======CHECK STATUS================  Bargardandan tamimi vaziyat yek elan mojod.
  SELECT 
  STATUS
  into OUTPAR_STATUS
  FROM pragg.TBL_NOTIFICATIONS
  
  where ID = INPAR_ID;
Commit;
END IF;


IF INPAR_OPT_TYPE = 'getall' THEN
  --=======GET ALL================ Bargardandan tamami elanat mojod. 
  SELECT 
  'SELECT ID as "id",
  TITLE  as "title",
  TYPE as "type",
  class as "class",
  REF_USER  as "user",
  to_char(START_TIME,''yyyy/MM/dd'') as "startTime",
  to_char(END_TIME,''yyyy/mm/dd'') as "endTime",
    STATUS as "status",
  DESCRIPTION as "des"
  ,ref_repreq as "ref"
  ,ref_repper_date as "perDate"
  ,REF_REPORT as "refReport"
  , flag as "changed"
FROM pragg.TBL_NOTIFICATIONS
order by START_TIME desc
'

  into OUTPAR_STATUS
  FROM dual
    ;

END IF;

   IF (INPAR_OPT_TYPE = 'visited') then
 
 update pragg.TBL_NOTIFICATIONS set STATUS='visited' ,flag = 0 where id=INPAR_ID;
 commit;
 
 end if;
 
END PRC_NOTIFICATION;
--------------------------------------------------------
--  DDL for Procedure TJR_HISTORICAL_GL_ARZ
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."TJR_HISTORICAL_GL_ARZ" AS
VAR_MAX_DATE number;
var_cnt  number;
  BEGIN
--select case when  max(to_char(eff_date,'j')) is null then '0' else max(to_char(eff_date,'j'))end  INTO VAR_MAX_DATE from dynamic_lq.daftar_kol_tjr;
select case when  max(eff_date) is null then 0 else max(eff_date) end  INTO VAR_MAX_DATE from dynamic_lq.daftar_kol_tjr;


for c in (select distinct trunc(TR_DT) as effdate from tejarat_db.taledger  where to_char(to_date(TR_DT,'yyyymmdd','nls_calendar = persian'),'j') > VAR_MAX_DATE)
loop 

insert into dynamic_lq.daftar_kol_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,EFF_DATE,ARZ_ID)
    select b.id,b.name,b.father_id,a.mande,b.depth ,to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j') as EFF_DATE,4 from
    (
      select cbi_db, sum(blnc_db + blnc_cr) as mande from tejarat_db.taledger 
        where tr_dt = c.effdate and RCRD_TYP = 1 and cbi_db not in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1330','K1320','A0080','A0140','A0160','B0230','C0796') group by cbi_db
    ) a, akin.tbl_treenode_tejarat_5 b where a.cbi_db = b.code;
  commit;
  ----------------------------------
  insert into dynamic_lq.daftar_kol_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,EFF_DATE,ARZ_ID)
    select b.id,b.name,b.father_id,a.mande,b.depth,to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j') as EFF_DATE,4 from
    (
      select cbi_db, sum(blnc_cr) as mande from tejarat_db.taledger 
        where tr_dt = c.effdate and RCRD_TYP = 1 and cbi_db in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db
    ) a, akin.tbl_treenode_tejarat_5 b where a.cbi_db = b.code;
  commit;
  -------------------------------------------
  insert into dynamic_lq.daftar_kol_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,EFF_DATE,ARZ_ID)
    select b.id,b.name,b.father_id,a.mande,b.depth ,to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j') as EFF_DATE,4 from
    (
      select cbi_db, sum(blnc_db) as mande from tejarat_db.taledger 
        where tr_dt = c.effdate and RCRD_TYP = 1 and cbi_db in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db
    ) a, akin.tbl_treenode_tejarat_5 b, tejarat_db.cbi_map c where a.cbi_db = c.CBI and c.cbi2 = b.code;
  commit;
---------------------------------------------------------------------------------------------------------------------------
  for i in reverse 3..5
  loop
  insert into dynamic_lq.daftar_kol_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,EFF_DATE,ARZ_ID)
      select b.id,b.name,b.father_id,a.mande,b.depth,a.tarikh,4 from
        (select sum(mande) as mande, FATHER_ID, max(eff_date) as tarikh from 
        dynamic_lq.daftar_kol_tjr where depth = i and FATHER_ID not in ('5310210','5320200') and eff_date=to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j') group by FATHER_ID) a,
        akin.tbl_treenode_tejarat_5 b where a.FATHER_ID = b.id ;
        --and a.tarikh=(select max(eff_date) from dynamic_lq.daftar_kol_tjr);
        commit;
        if (i = 5) then
  insert into dynamic_lq.daftar_kol_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,EFF_DATE,ARZ_ID)
            select 5310210,'حسابهاي انتظامي',28,a.mande,4, to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j') as EFF_DATE,4 from
            (
              select sum(blnc_cr) as mande from tejarat_db.taledger 
              where tr_dt = c.effdate and RCRD_TYP = 1 and cbi_db in
              ('X9950','X9951','X9955','X9995','X9997','X9998','L0210','X9954','X9990','X9991','X9994','X9996','x9998')
            ) a;
          commit;
  insert into dynamic_lq.daftar_kol_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,EFF_DATE,ARZ_ID)
            select 5320200,'طرف حسابهاي انتظامي',47,a.mande,4, to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j') as EFF_DATE,4 from
            (
              select sum(blnc_db) as mande from tejarat_db.taledger 
              where tr_dt = c.effdate and RCRD_TYP = 1 and cbi_db in
              ('X9950','X9951','X9955','X9995','X9997','X9998','L0210','X9954','X9990','X9991','X9994','X9996','x9998')
            ) a;
            commit;
        end if;
        commit;
        
  end loop; --i
  
  --------------------------- root
insert into dynamic_lq.daftar_kol_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,EFF_DATE,ARZ_ID)values(0,'ريشه',null,null,1,to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j'),4);
commit;
-----------------------------------
  end loop;--c
      delete  from dynamic_lq.DAFTAR_KOL_tjr where 
NODE_ID||ARZ_ID in (
select NODE_ID||ARZ_ID from (
SELECT distinct count(eff_date) cnt,NODE_ID,ARZ_ID FROM  DAFTAR_KOL_tjr GROUP BY NODE_ID,ARZ_ID
)where cnt<30); 
--     delete from dynamic_lq.daftar_kol where node_id in (select node_id from dynamic_lq.daftar_kol group by node_id having count(node_id) < 30);
  commit;
END TJR_HISTORICAL_GL_ARZ;
--------------------------------------------------------
--  DDL for Procedure TJR_HISTORICAL_GL_ARZ_SHOBE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."TJR_HISTORICAL_GL_ARZ_SHOBE" AS
VAR_MAX_DATE number;
var_cnt  number;
  BEGIN
--select case when  max(to_char(eff_date,'j')) is null then '0' else max(to_char(eff_date,'j'))end  INTO VAR_MAX_DATE from dynamic_lq.daftar_kol_tjr;
select case when  max(eff_date) is null then 0 else max(eff_date) end  INTO VAR_MAX_DATE from dynamic_lq.daftar_kol_shobe_tjr;


for c in (select distinct trunc(TR_DT) as effdate from tejarat_db.taledger  where to_char(to_date(TR_DT,'yyyymmdd','nls_calendar = persian'),'j') > VAR_MAX_DATE)
loop 
--------------------------- root
insert into dynamic_lq.daftar_kol_shobe_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,EFF_DATE,ARZ_ID)values(0,'ريشه',null,null,1,to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j'),4);
-----------------------------------
insert into dynamic_lq.daftar_kol_shobe_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,shobe_id,EFF_DATE,ARZ_ID,SHAHR_ID,OSTAN_ID)

select  d.*,brn.REF_CTY_ID,REF_STA_ID  from 
   ( select b.id,b.name,b.father_id,a.mande,b.depth ,a.brnch_cd,to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j') as EFF_DATE,4 from
    (
      select cbi_db,brnch_cd, sum(blnc_db + blnc_cr) as mande from tejarat_db.taledger 
        where tr_dt = c.effdate and RCRD_TYP = 1 and cbi_db not in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1330','K1320','A0080','A0140','A0160','B0230','C0796') group by cbi_db,brnch_cd
    ) a, akin.tbl_treenode_tejarat_5 b where a.cbi_db = b.code) d,PRAGG.TBL_BRANCH brn
    where d.brnch_cd=brn.BRN_ID;
    
    
  commit;
  ----------------------------------
  insert into dynamic_lq.daftar_kol_shobe_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,shobe_id,EFF_DATE,ARZ_ID,SHAHR_ID,OSTAN_ID)
  select  d.*,brn.REF_CTY_ID,REF_STA_ID  from 
   ( select b.id,b.name,b.father_id,a.mande,b.depth,a.brnch_cd,to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j') as EFF_DATE,4 from
    (
      select cbi_db,brnch_cd, sum(blnc_cr) as mande from tejarat_db.taledger 
        where tr_dt = c.effdate and RCRD_TYP = 1 and cbi_db in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db,brnch_cd
    ) a, akin.tbl_treenode_tejarat_5 b where a.cbi_db = b.code) d,PRAGG.TBL_BRANCH brn
    where d.brnch_cd=brn.BRN_ID;
  commit;
  -------------------------------------------
  insert into dynamic_lq.daftar_kol_shobe_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,shobe_id,EFF_DATE,ARZ_ID,SHAHR_ID,OSTAN_ID)
  select  d.*,brn.REF_CTY_ID,REF_STA_ID  from
   ( select b.id,b.name,b.father_id,a.mande,b.depth,a.brnch_cd ,to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j') as EFF_DATE,4 from
    (
      select cbi_db,brnch_cd, sum(blnc_db) as mande from tejarat_db.taledger 
        where tr_dt = c.effdate and RCRD_TYP = 1 and cbi_db in
        ('H1190','H1200','H1210','H1220','H1230','H1240','K1320','K1330','A0080','A0140','A0160','B0230','C0796') group by cbi_db,brnch_cd
    ) a, akin.tbl_treenode_tejarat_5 b, tejarat_db.cbi_map c where a.cbi_db = c.CBI and c.cbi2 = b.code) d,PRAGG.TBL_BRANCH brn
    where d.brnch_cd=brn.BRN_ID;
  commit;
---------------------------------------------------------------------------------------------------------------------------
  for i in reverse 3..5
  loop
  insert into dynamic_lq.daftar_kol_shobe_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,shobe_id,EFF_DATE,ARZ_ID,SHAHR_ID,OSTAN_ID)
  select  d.*,brn.REF_CTY_ID,REF_STA_ID  from
     ( select b.id,b.name,b.father_id,a.mande,b.depth,a.shobe_id,a.tarikh,4 from
        (select sum(mande) as mande, FATHER_ID, max(eff_date) as tarikh,shobe_id from 
        dynamic_lq.daftar_kol_shobe_tjr where depth = i and FATHER_ID not in ('5310210','5320200') and eff_date=to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j') group by FATHER_ID,shobe_id) a,
        akin.tbl_treenode_tejarat_5 b where a.FATHER_ID = b.id ) d,PRAGG.TBL_BRANCH brn
    where d.shobe_id=brn.BRN_ID;
        --and a.tarikh=(select max(eff_date) from dynamic_lq.daftar_kol_tjr);
        commit;
        if (i = 5) then
  insert into dynamic_lq.daftar_kol_shobe_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,shobe_id,EFF_DATE,ARZ_ID,SHAHR_ID,OSTAN_ID)
  select  d.*,brn.REF_CTY_ID,REF_STA_ID  from (
            select 5310210,'حسابهاي انتظامي',28,a.mande,4 as depth,a.brnch_cd, to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j') as EFF_DATE,4 from
            (
              select brnch_cd,sum(blnc_cr) as mande from tejarat_db.taledger 
              where tr_dt = c.effdate and RCRD_TYP = 1 and cbi_db in
              ('X9950','X9951','X9955','X9995','X9997','X9998','L0210','X9954','X9990','X9991','X9994','X9996','x9998') group by brnch_cd
            ) a
            ) d,PRAGG.TBL_BRANCH brn
    where d.brnch_cd=brn.BRN_ID;
          commit;
  insert into dynamic_lq.daftar_kol_shobe_tjr(NODE_ID,NAME,FATHER_ID,MANDE,DEPTH,shobe_id,EFF_DATE,ARZ_ID,SHAHR_ID,OSTAN_ID)
  select  d.*,brn.REF_CTY_ID,REF_STA_ID  from (
            select 5320200,'طرف حسابهاي انتظامي',47,a.mande,4 as depth,a.brnch_cd, to_char(to_date(c.effdate,'yyyymmdd','nls_calendar = persian'),'j') as EFF_DATE,4 from
            (
              select brnch_cd,sum(blnc_db) as mande from tejarat_db.taledger 
              where tr_dt = c.effdate and RCRD_TYP = 1 and cbi_db in
              ('X9950','X9951','X9955','X9995','X9997','X9998','L0210','X9954','X9990','X9991','X9994','X9996','x9998')  group by brnch_cd
            ) a
            ) d,PRAGG.TBL_BRANCH brn
    where d.brnch_cd=brn.BRN_ID;
            commit;
        end if;
        commit;
  end loop; --i
  
  end loop;--c
  
  delete  from DAFTAR_KOL_SHOBE_tjr where 
NODE_ID||ARZ_ID||SHOBE_ID in (
select NODE_ID||ARZ_ID||SHOBE_ID from (
SELECT distinct count(eff_date) cnt,NODE_ID,ARZ_ID,SHOBE_ID FROM  DAFTAR_KOL_SHOBE_tjr    GROUP BY NODE_ID,ARZ_ID,SHOBE_ID
)where cnt<30);
  commit; 
END TJR_HISTORICAL_GL_ARZ_SHOBE;
--------------------------------------------------------
--  DDL for Procedure DAY_HISTORICAL_GL_ARZ
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."DAY_HISTORICAL_GL_ARZ" as
var_shift number;
VAR_MAX_DATE number;
var_cnt number;
begin
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: az in prc be manzure por kardane jadvale daftare kol (bank day) be surate ruzane va afzayeshi estefade mishavad
  */
  /*------------------------------------------------------------------------------*/

--select case when  max(to_char(eff_date,'j')) is null then '0' else max(to_char(eff_date,'j'))end  INTO VAR_MAX_DATE from dynamic_lq.daftar_kol;
select case when  max(eff_date) is null then 0 else max(eff_date) end  INTO VAR_MAX_DATE from dynamic_lq.daftar_kol;

-- +599 
 
  for i in (select distinct trunc(effdate) as effdate from DADEKAVAN_DAY.balance_mv where TO_CHAR(trunc(effdate), 'j') >VAR_MAX_DATE order by effdate)
  loop
 
 --sathe 5 baraye azr rial   
 insert into dynamic_lq.daftar_kol(node_id,father_id,depth,mande,eff_date,arz_id)
  SELECT a.gl_code,
  SUBSTR(a.gl_code,1,7)
  ||'00',
  5,
  CASE
    WHEN SUM (a.final_bal) <= -1
    THEN                      -SUM (a.final_bal)
    WHEN (SUM (a.final_bal) > -1
    AND SUM (a.final_bal)   < 1)
    THEN 1
    ELSE SUM (final_bal)
  END,
  TO_CHAR(i.effdate,'J'),
  b.CUR_ID
FROM DADEKAVAN_DAY.balance_mv a,
  PRAGG.TBL_CURRENCY b
WHERE TRUNC(a.effdate) <= i.effdate
and a.curr_cod ='IRR' 
AND a.curr_cod          = SWIFT_CODE
GROUP BY a.gl_code,b.CUR_ID;
commit;
--sathe 5 baraye azr gheyre rial 
 insert into dynamic_lq.daftar_kol(node_id,father_id,depth,mande,eff_date,arz_id)
  SELECT a.gl_code,
  SUBSTR(a.gl_code,1,7)
  ||'00',
  5,
  CASE
    WHEN SUM (a.FINAL_BAL_MOADEL) <= -1
    THEN                      -SUM (a.FINAL_BAL_MOADEL)
    WHEN (SUM (a.FINAL_BAL_MOADEL) > -1
    AND SUM (a.FINAL_BAL_MOADEL)   < 1)
    THEN 1
    ELSE SUM (FINAL_BAL_MOADEL)
  END,
  TO_CHAR(i.effdate,'J'),
  b.CUR_ID
FROM DADEKAVAN_DAY.balance_mv a,
  PRAGG.TBL_CURRENCY b
WHERE TRUNC(a.effdate) <= i.effdate
and a.curr_cod !='IRR' 
AND a.curr_cod          = SWIFT_CODE
GROUP BY a.gl_code,b.CUR_ID;  
commit;
 
  insert into daftar_kol(node_id,father_id,DEPTH,MANDE,eff_date,arz_id)
  (select father_id, substr(father_id,1,5)||'0000', 4, sum(mande), eff_date, arz_id from daftar_kol where  eff_date=TO_CHAR(trunc(i.effdate), 'j') and depth = 5 group by father_id,eff_date,arz_id);
  commit;
  insert into daftar_kol(node_id,father_id,DEPTH,MANDE,eff_date,arz_id)
  (select father_id, substr(father_id,1,3)||'000000', 3, sum(mande), eff_date, arz_id from daftar_kol where eff_date=TO_CHAR(trunc(i.effdate), 'j') and depth = 4 group by father_id,eff_date,arz_id);
  commit;
  insert into daftar_kol(node_id,father_id,DEPTH,MANDE,eff_date,arz_id)
  (select father_id, substr(father_id,1,1)||'00000000', 2, sum(mande), eff_date, arz_id from daftar_kol where eff_date=TO_CHAR(trunc(i.effdate), 'j') and depth = 3 group by father_id,eff_date,arz_id);
  commit;
  insert into daftar_kol(node_id,father_id,DEPTH,MANDE,eff_date,arz_id)
  (select father_id, 0, 1, sum(mande), eff_date, arz_id from daftar_kol where eff_date=TO_CHAR(trunc(i.effdate), 'j') and depth = 2 group by father_id,eff_date,arz_id);
  commit;
  
 end loop;  

----------------------------------------

---------------------------------------------
  
  delete  from dynamic_lq.DAFTAR_KOL where 
NODE_ID||ARZ_ID in (
select NODE_ID||ARZ_ID from (
SELECT distinct count(eff_date) cnt,NODE_ID,ARZ_ID FROM  DAFTAR_KOL GROUP BY NODE_ID,ARZ_ID
)where cnt<30); 
  commit;
  
  
 -- HISTORICAL_GL_ARZ_SHOBE;
  
  
--------------------------------------------------------------------------------------------------------  
  --jalal
--    insert into dynamic_lq_day.daftar_kol(node_id,father_id,depth,mande,eff_date,arz_id)
--    select a.gl_code, substr(a.gl_code,1,7)||'00', 5, case when sum (a.final_bal) <= -1 then -sum (a.final_bal) when (sum (a.final_bal) > -1 and sum (a.final_bal) < 1) then 1 else sum (final_bal) end,
--    to_char(i.effdate,'J'),b.id
--    from DADEKAVAN_DAY.balance_mv a, dynamic_lq_day.bi_table_arz b where trunc(a.effdate) <= i.effdate and a.curr_cod = b.nam group by a.gl_code,b.id;
--    commit;
--  end loop;
--  delete from dynamic_lq_day.daftar_kol where node_id in (select node_id from dynamic_lq_day.daftar_kol group by node_id having count(node_id) < 30);
--  commit;
--  /*insert into daftar_kol(node_id,father_id,DEPTH,MANDE,eff_date,arz_id)
--  (select father_id, substr(father_id,1,5)||'0000', 4, sum(mande), eff_date, arz_id from daftar_kol where depth = 5 group by father_id,eff_date,arz_id);
--  commit;
--  insert into daftar_kol(node_id,father_id,DEPTH,MANDE,eff_date,arz_id)
--  (select father_id, substr(father_id,1,3)||'000000', 3, sum(mande), eff_date, arz_id from daftar_kol where depth = 4 group by father_id,eff_date,arz_id);
--  commit;
--  insert into daftar_kol(node_id,father_id,DEPTH,MANDE,eff_date,arz_id)
--  (select father_id, substr(father_id,1,1)||'00000000', 2, sum(mande), eff_date, arz_id from daftar_kol where depth = 3 group by father_id,eff_date,arz_id);
--  commit;
--  insert into daftar_kol(node_id,father_id,DEPTH,MANDE,eff_date,arz_id)
--  (select father_id, 0, 1, sum(mande), eff_date, arz_id from daftar_kol where depth = 2 group by father_id,eff_date,arz_id);
--  commit;*/
end;
--------------------------------------------------------
--  DDL for Procedure DAY_HISTORICAL_GL_ARZ_SHOBE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "DYNAMIC_LQ"."DAY_HISTORICAL_GL_ARZ_SHOBE" 
as
VAR_MAX_DATE number;
var_cnt number;
begin
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: az in prc be manzure por kardane jadvale daftare kol shobe (bank day) be surate ruzane va afzayeshi estefade mishavad
  */
  /*------------------------------------------------------------------------------*/

-- +599
select case when  max(eff_date) is null then 0 else max(eff_date) end  INTO VAR_MAX_DATE  from dynamic_lq.daftar_kol_shobe;

  
    for i in (select distinct trunc(effdate) as effdate from DADEKAVAN_DAY.balance_mv where TO_CHAR(trunc(effdate), 'j') >VAR_MAX_DATE)  loop
 --sathe 5 baraye azr  rial
   
  insert /*+parallel(auto)*/ into dynamic_lq.daftar_kol_shobe(node_id,father_id,depth,shobe_id,mande,eff_date,arz_id,shahr_id,ostan_id)
  SELECT /*+parallel(auto)*/ a.gl_code,SUBSTR(a.gl_code,1,7) ||'00',5,brn.BRN_ID, CASE
    WHEN SUM (a.final_bal) <= -1
    THEN                      -SUM (a.final_bal)
    WHEN (SUM (a.final_bal) > -1
    AND SUM (a.final_bal)   < 1)
    THEN 1
    ELSE SUM (final_bal)
  END,
  TO_CHAR(i.effdate,'J'),
  cur.cur_id,
  MAX(brn.REF_CTY_ID),
  MAX(brn.REF_STA_ID)
FROM DADEKAVAN_DAY.balance_mv a,PRAGG.TBL_CURRENCY cur,PRAGG.TBL_branch_day brn --,PRAGG.TBL_city_day d
WHERE 
brn.REF_CTY_ID in (118,122) and   -- just for tehran and mashahd ######################################
TRUNC(a.effdate) <= i.effdate
AND a.curr_cod ='IRR' AND
 a.curr_cod          = SWIFT_CODE 
 and A.BR_CODE + 10000 = brn.BRN_ID 
GROUP BY a.gl_code,cur.cur_id,brn.BRN_ID;
  commit;

--sathe 5 baraye azr gheyre rial
   insert /*+parallel(auto)*/ into dynamic_lq.daftar_kol_shobe(node_id,father_id,depth,shobe_id,mande,eff_date,arz_id,shahr_id,ostan_id)
SELECT /*+parallel(auto)*/ a.gl_code,SUBSTR(a.gl_code,1,7)||'00',5,brn.BRN_ID,
  CASE
    WHEN SUM (a.FINAL_BAL_MOADEL) <= -1
    THEN                      -SUM (a.FINAL_BAL_MOADEL)
    WHEN (SUM (a.FINAL_BAL_MOADEL) > -1
    AND SUM (a.FINAL_BAL_MOADEL)   < 1)
    THEN 1
    ELSE SUM (FINAL_BAL_MOADEL)
  END,
  TO_CHAR(i.effdate,'J'),
  cur.cur_id,
  MAX(brn.REF_CTY_ID),
  -- MAX(d.REF_STA_ID)
  MAX(brn.REF_STA_ID)
FROM DADEKAVAN_DAY.balance_mv a,PRAGG.TBL_CURRENCY cur,PRAGG.TBL_branch_day brn --,PRAGG.TBL_city_day d
WHERE 
brn.REF_CTY_ID in (118,122) and   -- just for tehran and mashahd ######################################
TRUNC(a.effdate) <= i.effdate 
and a.curr_cod !='IRR' 
AND a.curr_cod          = cur.SWIFT_CODE
AND A.BR_CODE + 10000 = brn.BRN_ID
GROUP BY 
  a.gl_code,
  cur.cur_id,
  brn.BRN_ID;
  commit;
 
  
--delete  from dynamic_lq.DAFTAR_KOL_SHOBE where 
--NODE_ID||ARZ_ID||SHOBE_ID in (
--select NODE_ID||ARZ_ID||SHOBE_ID from (
--SELECT distinct count(eff_date) cnt,NODE_ID,ARZ_ID,SHOBE_ID FROM  DAFTAR_KOL_SHOBE GROUP BY NODE_ID,ARZ_ID,SHOBE_ID
--)where cnt<30); 
--   commit; 
  
 insert into dynamic_lq.daftar_kol_shobe(node_id,father_id,depth,shobe_id,mande,eff_date,arz_id,shahr_id,ostan_id)
  (select father_id, substr(father_id,1,5)||'0000', 4, shobe_id, sum(mande), eff_date, arz_id, max(shahr_id), max(ostan_id) from daftar_kol_shobe where eff_date=TO_CHAR(trunc(i.effdate), 'j') and  depth = 5 group by father_id,eff_date,shobe_id,arz_id);
  commit; 
 
  insert into dynamic_lq.daftar_kol_shobe(node_id,father_id,depth,shobe_id,mande,eff_date,arz_id,shahr_id,ostan_id)
  (select father_id, substr(father_id,1,3)||'000000', 3, shobe_id, sum(mande), eff_date, arz_id, max(shahr_id), max(ostan_id) from daftar_kol_shobe where eff_date=TO_CHAR(trunc(i.effdate), 'j') and depth = 4 group by father_id,eff_date,shobe_id,arz_id);
  commit;
  insert into dynamic_lq.daftar_kol_shobe(node_id,father_id,depth,shobe_id,mande,eff_date,arz_id,shahr_id,ostan_id)
  (select father_id, substr(father_id,1,1)||'00000000', 2, shobe_id, sum(mande), eff_date, arz_id, max(shahr_id), max(ostan_id) from daftar_kol_shobe where  eff_date=TO_CHAR(trunc(i.effdate), 'j') and  depth = 3 group by father_id,eff_date,shobe_id,arz_id);
  commit;
  insert into dynamic_lq.daftar_kol_shobe(node_id,father_id,depth,shobe_id,mande,eff_date,arz_id,shahr_id,ostan_id)
  (select father_id, 0, 1, shobe_id, sum(mande), eff_date, arz_id, max(shahr_id), max(ostan_id) from daftar_kol_shobe where  eff_date=TO_CHAR(trunc(i.effdate), 'j') and depth = 2 group by father_id,eff_date,shobe_id,arz_id);
  commit;
 

  
end loop;
  
   delete  from DAFTAR_KOL_SHOBE where 
NODE_ID||ARZ_ID||SHOBE_ID in (
select NODE_ID||ARZ_ID||SHOBE_ID from (
SELECT distinct count(eff_date) cnt,NODE_ID,ARZ_ID,SHOBE_ID FROM  DAFTAR_KOL_SHOBE  GROUP BY NODE_ID,ARZ_ID,SHOBE_ID
)where cnt<30);
  commit; 
  
-- ------------------------------------------- 
 -- PRC_ENTEGHAL_TO_DYNAMIC;
  --------------------------------------------
--jalal 
-----------------------------  
--  for i in (select distinct trunc(effdate) as effdate from DADEKAVAN_DAY.balance_mv)
--  loop
--    insert /*+parallel(auto)*/ into dynamic_lq.daftar_kol_shobe(node_id,father_id,depth,shobe_id,mande,eff_date,arz_id,shahr_id,ostan_id)
--    select /*+parallel(auto)*/ a.gl_code, substr(a.gl_code,1,7)||'00', 5, c.id, case when sum (a.final_bal) <= -1 then -sum (a.final_bal) when (sum (a.final_bal) > -1 and sum (a.final_bal) < 1) then 1 else sum (final_bal) end,
--    to_char(i.effdate,'J'),b.id, max(c.shahr_id), max(d.ostan_id)
--    from DADEKAVAN_DAY.balance_mv a, dynamic_lq_day.bi_table_arz b, dynamic_lq.bi_table_shobe c, bi_table_shahr d
--    where trunc(a.effdate) <= i.effdate
--    and a.curr_cod = b.nam /*join ba jadvale arz*/
--    and A.BR_CODE + 10000 = c.id /*join ba jadvale shobe*/
--    and c.shahr_id = d.id /*join shobe ba jadvale shahr*/
--    group by a.gl_code,b.id,c.id;
--    commit;
--  end loop;
--  delete from dynamic_lq.daftar_kol_shobe where node_id||shobe_id in (select node_id||shobe_id from dynamic_lq.daftar_kol_shobe group by node_id,shobe_id having count(*) < 30);
--  commit;
--  insert into daftar_kol_shobe(node_id,father_id,depth,shobe_id,mande,eff_date,arz_id,shahr_id,ostan_id)
--  (select father_id, substr(father_id,1,5)||'0000', 4, shobe_id, sum(mande), eff_date, arz_id, max(shahr_id), max(ostan_id) from daftar_kol_shobe where depth = 5 group by father_id,eff_date,shobe_id,arz_id);
--  commit;
--  insert into daftar_kol_shobe(node_id,father_id,depth,shobe_id,mande,eff_date,arz_id,shahr_id,ostan_id)
--  (select father_id, substr(father_id,1,3)||'000000', 3, shobe_id, sum(mande), eff_date, arz_id, max(shahr_id), max(ostan_id) from daftar_kol_shobe where depth = 4 group by father_id,eff_date,shobe_id,arz_id);
--  commit;
--  insert into daftar_kol_shobe(node_id,father_id,depth,shobe_id,mande,eff_date,arz_id,shahr_id,ostan_id)
--  (select father_id, substr(father_id,1,1)||'00000000', 2, shobe_id, sum(mande), eff_date, arz_id, max(shahr_id), max(ostan_id) from daftar_kol_shobe where depth = 3 group by father_id,eff_date,shobe_id,arz_id);
--  commit;
--  insert into daftar_kol_shobe(node_id,father_id,depth,shobe_id,mande,eff_date,arz_id,shahr_id,ostan_id)
--  (select father_id, 0, 1, shobe_id, sum(mande), eff_date, arz_id, max(shahr_id), max(ostan_id) from daftar_kol_shobe where depth = 2 group by father_id,eff_date,shobe_id,arz_id);
--  commit;

end;
