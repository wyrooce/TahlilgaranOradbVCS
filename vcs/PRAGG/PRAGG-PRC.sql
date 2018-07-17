--------------------------------------------------------
--  DDL for Procedure PRC_PRE_AGGREGATION
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_PRE_AGGREGATION" AS 
--------------------------------------------------------------------------------
  /*
  Programmer Name: rasool_jahani
  Editor Name: 
  Release Date/Time:1396/02/24-10:00
  Edit Name: 1396/02/10-10:00
  Version: 1.1
  Category:2
  Description:Anjam tajmi avaliyeh.tamam mojodiyat hay dakhil dar mohaseebe shekaf
              be shekl sanad hesabdari dar yek jadval jamavari mishavand.
  */
--------------------------------------------------------------------------------

BEGIN
   EXECUTE IMMEDIATE 'alter session enable parallel dml';
  EXECUTE IMMEDIATE 'truncate table TBL_VALUE';

---/////////////////////////////////
---/////Insert  Sood Seporde  /////
--////////////////////////////////
INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE
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
    REF_CUS_ID
   )
SELECT  /*+ PARALLEL(auto) */ 
21,
  PAY.REF_DEP_ID,
  sum(PROFIT_AMOUNT),
  --PROFIT_AMOUNT,
  DEP.REF_BRANCH,
  trunc(PAY.DUE_DATE),
  DEP.REF_DEPOSIT_TYPE,
  AC.LEDGER_CODE_PROFIT,
  DEP.REF_CURRENCY,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID,
  DEP.REF_CUSTOMER
FROM AKIN.TBL_DEPOSIT_INTEREST_PAYMENT PAY
JOIN AKIN.TBL_DEPOSIT DEP
ON PAY.REF_DEP_ID = DEP.DEP_ID
JOIN AKIN.TBL_DEPOSIT_ACCOUNTING AC
ON DEP.REF_DEPOSIT_ACCOUNTING = AC.DEP_ACC_ID 
JOIN TBL_BRANCH BRN
ON BRN.BRN_ID = DEP.REF_BRANCH
GROUP BY trunc(PAY.DUE_DATE) ,
  AC.LEDGER_CODE_PROFIT,
  DEP.REF_BRANCH,
  DEP.REF_CURRENCY,
  DEP.REF_CUSTOMER,
  DEP.REF_DEPOSIT_TYPE,
  PAY.REF_DEP_ID,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID;
---/////////////////////////////////
---////Insert  Sood Tashilat  /////
--////////////////////////////////
commit;
INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE
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
    REF_CUS_ID
   )
SELECT /*+ PARALLEL(auto)  */
11,
  PAY.REF_LON_ID,
  sum(PROFIT_AMOUNT),
  --PROFIT_AMOUNT,
  LON.REF_BRANCH,
  trunc(PAY.DUE_DATE),
  LON.REF_LOAN_TYPE,
  AC.LEDGER_CODE_PROFIT,
  LON.REF_CURRENCY,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID,
  LON.REF_CUSTOMER
FROM AKIN.TBL_LOAN_PAYMENT PAY
JOIN AKIN.TBL_LOAN LON
ON PAY.REF_LON_ID = LON.LON_ID
JOIN AKIN.TBL_LOAN_ACCOUNTING AC
ON LON.REF_LOAN_ACCOUNTING = AC.LON_ACC_ID 
JOIN TBL_BRANCH BRN
ON BRN.BRN_ID = LON.REF_BRANCH
GROUP BY trunc(PAY.DUE_DATE) ,
  AC.LEDGER_CODE_PROFIT,
  LON.REF_BRANCH,
  LON.REF_CURRENCY,
  LON.REF_CUSTOMER,
  LON.REF_LOAN_TYPE,
  PAY.REF_LON_ID,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID;
---/////////////////////////////////
---////Insert  Asl Aghsat  ////////
--////////////////////////////////
commit;

INSERT
/*+ APPEND PARALLEL(auto)  */
INTO TBL_VALUE
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
    REF_CUS_ID
   )
SELECT /*+ PARALLEL(auto)   */
1,
  PAY.REF_LON_ID,
  sum(PAY.AMOUNT),
  LON.REF_BRANCH,
  trunc(PAY.DUE_DATE),
  LON.REF_LOAN_TYPE,
  AC.LEDGER_CODE_SELF,
  LON.REF_CURRENCY,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID,
  LON.REF_CUSTOMER
FROM AKIN.TBL_LOAN_PAYMENT PAY
JOIN AKIN.TBL_LOAN LON
ON PAY.REF_LON_ID = LON.LON_ID
JOIN AKIN.TBL_LOAN_ACCOUNTING AC
ON LON.REF_LOAN_ACCOUNTING = AC.LON_ACC_ID 
JOIN TBL_BRANCH BRN
ON BRN.BRN_ID = LON.REF_BRANCH
GROUP BY trunc(PAY.DUE_DATE) ,
  AC.LEDGER_CODE_SELF,
  LON.REF_BRANCH,
  LON.REF_CURRENCY,
  LON.REF_CUSTOMER,
  LON.REF_LOAN_TYPE,
  PAY.REF_LON_ID,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID;
---/////////////////////////////////
---//////Insert Asl Seporde  //////
--////////////////////////////////
commit;

INSERT
/*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE
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
    REF_CUS_ID
   )
SELECT /*+ PARALLEL(auto)   */
2,
DEP.DEP_ID,
SUM(DEP.BALANCE),
DEP.REF_BRANCH,
CASE
    WHEN  trunc(DEP.DUE_DATE) IS NULL
    THEN sysdate +1
    ELSE  trunc(DEP.DUE_DATE)
  END AS DUE_DATE ,
DEP.REF_DEPOSIT_TYPE,
AC.LEDGER_CODE_SELF,
DEP.REF_CURRENCY,
BRN.REF_STA_ID,
BRN.REF_CTY_ID,
DEP.REF_CUSTOMER
FROM AKIN.TBL_DEPOSIT DEP
JOIN AKIN.TBL_DEPOSIT_ACCOUNTING AC
ON DEP.REF_DEPOSIT_ACCOUNTING = AC.DEP_ACC_ID
JOIN TBL_BRANCH BRN
ON DEP.REF_BRANCH = BRN.BRN_ID
WHERE 
  CASE
    WHEN  trunc(DEP.DUE_DATE) IS NULL
    THEN sysdate +1
    ELSE  trunc(DEP.DUE_DATE)
  END > sysdate
  GROUP BY trunc(DEP.DUE_DATE) ,
  DEP.DEP_ID,
  AC.LEDGER_CODE_SELF,
  DEP.REF_BRANCH,
  DEP.REF_CURRENCY,
  DEP.REF_CUSTOMER,
  DEP.REF_DEPOSIT_TYPE,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID;
commit;
END PRC_PRE_AGGREGATION;
--------------------------------------------------------
--  DDL for Procedure PRC_PROFILE_DETAIL
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_PROFILE_DETAIL" (
    INPAR_REF_PROFILE      IN VARCHAR2 ,
    INPAR_COLUMN           IN VARCHAR2 ,
    INPAR_CONDITION        IN VARCHAR2 ,
    INPAR_insert_or_update IN VARCHAR2 -- insert = 1 & update = 2
    ,
    INPAR_record IN VARCHAR2 , --0 EDAME DARAD VA 1 TAMAM
    outpar_id OUT VARCHAR2
    )
AS
iidd number;
  --------------------------------------------------------------------------------
  /*
  Programmer Name: Morteza.Sahhi
  Editor Name:
  Release Date/Time:1396/02/24-10:00
  Edit Name: 1396/02/16-12:00
  Version: 1.1
  Category:2
  Description:
  */
  --------------------------------------------------------------------------------
  isempty     NUMBER;
  VAR_VERSION NUMBER;
  INPAR_insert_or_update2 number;--insert = 0 & update <>0
BEGIN

select max(id) into iidd
FROM TBL_PROFILE
where h_id = INPAR_REF_PROFILE
group by name ;


  select count(*) into INPAR_insert_or_update2 from  TBL_PROFILE_DETAIL where SRC_COLUMN=INPAR_COLUMN and REF_PROFILE = iidd;
  
    IF (INPAR_insert_or_update2 = 0) THEN
      INSERT
      INTO TBL_PROFILE_DETAIL
        (
          REF_PROFILE,
          SRC_COLUMN,
          CONDITION
        )
        VALUES
        (
          iidd,
          INPAR_COLUMN,
          INPAR_CONDITION
        );
        commit;
        select id into outpar_id from TBL_PROFILE_DETAIL where SRC_COLUMN=INPAR_COLUMN and REF_PROFILE = iidd;
    ELSE
      UPDATE TBL_PROFILE_DETAIL
      SET CONDITION     =INPAR_CONDITION
      WHERE REF_PROFILE = iidd
      AND SRC_COLUMN    = INPAR_COLUMN;
    END IF;
    EXECUTE IMMEDIATE 'delete from tbl_profile_detail where  src_column is not null and condition is NULL';
    commit;
END PRC_PROFILE_detail;
--------------------------------------------------------
--  DDL for Procedure PRC_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_PROFILE" (
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    INPAR_CREATE_DATE      IN VARCHAR2 , 
    INPAR_REF_USER         IN VARCHAR2 ,   
    INPAR_STATUS           IN VARCHAR2 , 
    inpar_insert_or_update IN VARCHAR2 , --insert = 1 & update = 0
    inpar_id               IN VARCHAR2 , 
    INPAR_REF_PROFILE      IN VARCHAR2 ,
    INPAR_COLUMN           IN VARCHAR2 ,
    INPAR_CONDITION        IN NVARCHAR2 ,
    outpar_id OUT VARCHAR2 )
AS
  --------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh
  Editor Name: 
  Release Date/Time:1396/04/14-16:00
  Edit Name: 
  Version: 1.1
  Category:2
  Description: in procedure bareE sakht, virayesh va koliE tanzimate profile ha mibashad
  */

  --------------------------------------------------------------------------------

  var_count NUMBER;
  var_version Number;
  max_id number;
  iidd number;
  INPAR_insert_or_update2 number;
  var clob;
  cnt number;
  cnt_id number;
  
BEGIN

var_version:=1;
  --select count(*) into var_count from TBL_PROFILE where name||type = INPAR_NAME||INPAR_TYPE;
  --if (var_count = 0) then
  
  --select 'nam tekrari ast' into outpar_id from dual;
  --end if;
--------------------------------------------------------------------------------  
if(upper(INPAR_TYPE)='TARIKH') then
 IF (inpar_insert_or_update= 1) THEN
    INSERT
    INTO TBL_TIMING_PROFILE
      (
        NAME,
        DES,
        TYPE,
        CREATE_DATE,
        REF_USER,
        STATUS,
        version
      )
      VALUES
      (
        fnc_FarsiValidate(INPAR_NAME) ,
        INPAR_DES ,
        2 ,
        sysdate ,
        INPAR_REF_USER ,
        INPAR_STATUS,
        var_version
      );
    COMMIT;
--    SELECT id
--    INTO outpar_id
--    FROM TBL_TIMING_PROFILE
--    WHERE CREATE_DATE =
--      (SELECT MAX(CREATE_DATE) FROM TBL_TIMING_PROFILE
--      );
SELECT id
        INTO outpar_id
        FROM TBL_TIMING_PROFILE
        WHERE  id =
          (SELECT MAX(id) FROM TBL_TIMING_PROFILE 
          );
      
        update TBL_TIMING_PROFILE
    set H_ID= id
    where id = outpar_id;
    commit;
    
    
  ELSE
    INSERT
    INTO TBL_TIMING_PROFILE
      (
        NAME,
        DES,
        TYPE,
        CREATE_DATE,
        update_date,
        REF_USER,
        REF_USER_UPDATE,
        STATUS,
        version,
        H_ID
      )
      VALUES
      (
        fnc_FarsiValidate(INPAR_NAME) ,
        INPAR_DES ,
        2 ,
        (select max(create_date) from TBL_TIMING_PROFILE where H_ID = inpar_REF_PROFILE),
        sysdate ,
        (select max(ref_user) from TBL_TIMING_PROFILE where H_ID = inpar_REF_PROFILE),
        INPAR_REF_USER ,
        INPAR_STATUS,
       (select max(version)+1 from TBL_TIMING_PROFILE where H_ID = inpar_REF_PROFILE),
        inpar_id
      );
    COMMIT;
    
--    SELECT id
--    INTO outpar_id
--    FROM TBL_TIMING_PROFILE
--    WHERE CREATE_DATE =
--      (SELECT MAX(CREATE_DATE) FROM TBL_TIMING_PROFILE
--      );
     SELECT id
        INTO outpar_id
        FROM TBL_TIMING_PROFILE
        WHERE  id =
          (SELECT MAX(id) FROM TBL_TIMING_PROFILE where h_id = INPAR_REF_PROFILE
          );
  END IF;

-------------------------------------------------------------------------------------------------------------------------  
  else if(upper(INPAR_TYPE)='BAZEH') then
  IF (inpar_insert_or_update= 1) THEN
    INSERT
    INTO TBL_TIMING_PROFILE
      (
        NAME,
        DES,
        TYPE,
        CREATE_DATE,
        REF_USER,
        STATUS,
        version
      )
      VALUES
      (
        fnc_FarsiValidate(INPAR_NAME) ,
        INPAR_DES ,
        1 ,
        sysdate ,
        INPAR_REF_USER ,
        INPAR_STATUS,
        var_version
      );
    COMMIT;
--    SELECT id
--    INTO outpar_id
--    FROM TBL_TIMING_PROFILE
--    WHERE CREATE_DATE =
--      (SELECT MAX(CREATE_DATE) FROM TBL_TIMING_PROFILE
--      );

 SELECT id
    INTO outpar_id
    FROM TBL_TIMING_PROFILE
    WHERE id =
          (SELECT MAX(id) FROM TBL_TIMING_PROFILE
          );
      
      
       update TBL_TIMING_PROFILE
    set H_ID= id
    where id = outpar_id;
    commit;
    
    
  ELSE
    INSERT
    INTO TBL_TIMING_PROFILE
      (
        NAME,
        DES,
        TYPE,
        CREATE_DATE,
        update_date,
        REF_USER,
        REF_USER_UPDATE,
        STATUS,
        version,
        H_ID
      )
      VALUES
      (
        fnc_FarsiValidate(INPAR_NAME ),
        INPAR_DES ,
        1 ,
       ( select max(create_date) from TBL_TIMING_PROFILE where H_ID = inpar_REF_PROFILE),
        sysdate ,
        ( select max(ref_user) from TBL_TIMING_PROFILE where H_ID = inpar_REF_PROFILE),
        INPAR_REF_USER ,
        INPAR_STATUS,
        (select max(version)+1 from TBL_TIMING_PROFILE where H_ID = inpar_REF_PROFILE),
        inpar_id
      );
    COMMIT;
--    SELECT id
--    INTO outpar_id
--    FROM TBL_TIMING_PROFILE
--    WHERE CREATE_DATE =
--      (SELECT MAX(CREATE_DATE) FROM TBL_TIMING_PROFILE
--      );

 SELECT id
    INTO outpar_id
    FROM TBL_TIMING_PROFILE
    WHERE id =
          (SELECT MAX(id) FROM TBL_TIMING_PROFILE where h_id = INPAR_REF_PROFILE
          );
      


  end if;
  --select 'nam tekrari ast' into outpar_id from dual;
  --end if;
  
--------------------------------------------------------------------------------
  else if(upper(INPAR_TYPE) in ('TBL_LEDGER', 'CUR_SENS','NIIM','NPL','CAR','COM')) then
   IF (inpar_insert_or_update= 1) THEN
    INSERT INTO TBL_LEDGER_PROFILE
      (
        NAME,
        DES,
        VERSION,
        CREATE_DATE,
        REF_USER,
        STATUS,
        TYPE
        
      )
      VALUES
      (
       fnc_FarsiValidate( INPAR_NAME ),
        INPAR_DES ,
        var_version,
        sysdate ,
        INPAR_REF_USER ,
        INPAR_STATUS,
      INPAR_TYPE
        
      );
    COMMIT;
    
    SELECT id
    INTO outpar_id
    FROM TBL_LEDGER_PROFILE
    WHERE id =
          (SELECT MAX(id) FROM TBL_LEDGER_PROFILE
          );
      update TBL_LEDGER_PROFILE
    set H_ID= id
    where id = outpar_id;
    commit;
    
  ELSE
    INSERT
    INTO tbl_ledger_profile
      (
        NAME,
        DES,
        version,
        CREATE_DATE,
     
        REF_USER,
        
        STATUS,
         TYPE,
         H_ID
         
      )
      VALUES
      (
        fnc_FarsiValidate(INPAR_NAME),
        INPAR_DES ,
        (select max(version)+1 from tbl_ledger_profile where H_id = INPAR_REF_PROFILE),
       
        sysdate ,
        INPAR_REF_USER ,
        INPAR_STATUS,
        INPAR_TYPE ,
         inpar_id
         
      );
    COMMIT;
   SELECT id
    INTO outpar_id
    FROM TBL_ledger_PROFILE
    WHERE id =
          (SELECT MAX(id) FROM TBL_ledger_PROFILE where h_id = INPAR_REF_PROFILE
          );
  end if;
  --select 'nam tekrari ast' into outpar_id from dual;
  --end if;
---------------------------------------------------------------------------------------------------

---======HOSSEIIINNNNNNNNNN
--=======SENARA
--=======TEST

  else if(upper(INPAR_TYPE) in ('TBL_SENARA')) then
   IF (inpar_insert_or_update= 1) THEN
    INSERT INTO TBL_PROFILE
      (
        NAME,
        DES,
        VERSION,
        CREATE_DATE,
        REF_USER,
        STATUS,
        TYPE
        
      )
      VALUES
      (
       fnc_FarsiValidate( INPAR_NAME ),
        INPAR_DES ,
        var_version,
        sysdate ,
        INPAR_REF_USER ,
        INPAR_STATUS,
      INPAR_TYPE
        
      );
    COMMIT;
    
    SELECT id
    INTO outpar_id
    FROM TBL_PROFILE
    WHERE id =
          (SELECT MAX(id) FROM TBL_PROFILE
          );
      update TBL_PROFILE
    set H_ID= id
    where id = outpar_id;
    commit;
    
  ELSE
    INSERT
    INTO tbl_profile
      (
        NAME,
        DES,
        version,
        CREATE_DATE,
     
        REF_USER,
        
        STATUS,
         TYPE,
         H_ID
         
      )
      VALUES
      (
        fnc_FarsiValidate(INPAR_NAME),
        INPAR_DES ,
        (select max(version)+1 from tbl_profile where H_id = INPAR_REF_PROFILE),
       
        sysdate ,
        INPAR_REF_USER ,
        INPAR_STATUS,
        INPAR_TYPE ,
         inpar_id
         
      );
    COMMIT;
   SELECT id
    INTO outpar_id
    FROM TBL_PROFILE
    WHERE id =
          (SELECT MAX(id) FROM TBL_PROFILE where h_id = INPAR_REF_PROFILE
          );
  end if;
  --select 'nam tekrari ast' into outpar_id from dual;
  --end if;


---======HOSSEIIINNNNNNNNNN
--=======SENARA
--=======TEST




-----------------------------------------------------------------------------------------------------  
  else
  IF (inpar_insert_or_update= 1) THEN
    INSERT
    INTO TBL_PROFILE
      (
        NAME,
        DES,
        TYPE,
        CREATE_DATE,
        REF_USER,
        STATUS,
        version
      )
      VALUES
      (
        fnc_FarsiValidate(INPAR_NAME) ,
        INPAR_DES ,
        upper( INPAR_TYPE) ,
        sysdate ,
        INPAR_REF_USER ,
        INPAR_STATUS,
        var_version
      );
    COMMIT;
--  SELECT id
--    INTO outpar_id
--    FROM TBL_PROFILE
--    WHERE CREATE_DATE =
--      (SELECT MAX(CREATE_DATE) FROM TBL_PROFILE
--      ) and id =  (SELECT MAX(id) FROM TBL_PROFILE);

 SELECT id
    INTO outpar_id
    FROM TBL_PROFILE
    WHERE id =
          (SELECT MAX(id) FROM TBL_PROFILE 
          );
 -----------------------------------------------------------------------------
         update TBL_PROFILE
    set H_ID= id
    where id = outpar_id;
    commit;
    
    
       --============ item_cnt
     var:=to_char(var);
    
    select FNC_PROFILE_CREATE_QUERY(outpar_id,0) into var from dual;
    EXECUTE IMMEDIATE 'select count(*)  from ('||var||')'  into cnt;
    update tbl_profile set item_cnt = cnt where id = outpar_id;
    commit;
    --============

    
   
  ELSE
  ---baraE fahymidan inke bishtarn idiEE ke dar detail zakhire boode chi hast
  select max(tbl_profile.id) into max_id  from tbl_profile where h_id = inpar_id  group by h_id;    
    
    INSERT
    INTO TBL_PROFILE
      (
        NAME,
        DES,
        TYPE,
      CREATE_DATE,
        UPDATE_DATE,
        REF_USER,
        REF_USER_UPDATE,
        STATUS,
        version,
        h_id
      )
      VALUES
      (
        fnc_FarsiValidate(INPAR_NAME) ,
        INPAR_DES ,
        upper( INPAR_TYPE) ,
         (select max(create_date) from TBL_PROFILE where H_ID = inpar_REF_PROFILE),
        sysdate ,
        (select max(ref_user) from TBL_PROFILE where H_ID = inpar_REF_PROFILE),
        INPAR_REF_USER ,
        INPAR_STATUS,
        (select max(version)+1 from TBL_PROFILE where H_ID = inpar_REF_PROFILE),
        inpar_id
      );
    COMMIT;
     SELECT id
    INTO outpar_id
    FROM TBL_PROFILE
    WHERE id =  (SELECT MAX(id) FROM TBL_PROFILE where h_id = Inpar_Ref_Profile);
----------------------------------------------------------------------newwww      
 select max(id) into iidd
FROM TBL_PROFILE
where h_id = INPAR_REF_PROFILE 
group by name ;     
 if(inpar_column <> 'empty' )  then
      INSERT
INTO TBL_PROFILE_DETAIL
  (

    REF_PROFILE,
    SRC_COLUMN,
    CONDITION
  )
  (SELECT  outpar_id, SRC_COLUMN, CONDITION FROM TBL_PROFILE_DETAIL,tbl_profile where REF_PROFILE=tbl_profile.id and REF_PROFILE= max_id);
   commit; 
   
   
   
   select count(*) into INPAR_insert_or_update2 from  TBL_PROFILE_DETAIL where SRC_COLUMN=INPAR_COLUMN and REF_PROFILE = iidd;
  
    IF (INPAR_insert_or_update2 = 0) THEN
      INSERT
      INTO TBL_PROFILE_DETAIL
        (
          REF_PROFILE,
          SRC_COLUMN,
          CONDITION
        )
        VALUES
        (
          iidd,
          INPAR_COLUMN,
          INPAR_CONDITION
        );
        commit;
        select id into outpar_id from TBL_PROFILE_DETAIL where SRC_COLUMN=INPAR_COLUMN and REF_PROFILE = iidd;
    ELSE
      UPDATE TBL_PROFILE_DETAIL
      SET CONDITION     =INPAR_CONDITION
      WHERE REF_PROFILE = iidd
      AND SRC_COLUMN    = INPAR_COLUMN;
    END IF;
    EXECUTE IMMEDIATE 'delete from tbl_profile_detail where  src_column is not null and condition is NULL';
    
    commit;
-------------------------------------------------------------------------    
   end if; 
  --============ item_cnt
     var:=to_char(var);
    select max(id) into cnt_id from tbl_profile where h_id = INPAR_REF_PROFILE;
    select FNC_PROFILE_CREATE_QUERY(INPAR_REF_PROFILE,0) into var from dual;
    EXECUTE IMMEDIATE 'select count(*)  from ('||var||')'  into cnt;
    update tbl_profile set item_cnt = nvl(cnt,0) where id = cnt_id;
    commit;
    --============
   
  end if;
  
 end if;
  
  end if;
  
  
end if;


  
  

update tbl_profile 
set status = 0
where id not in (select max(id) from tbl_profile group by h_id);
commit;

update tbl_ledger_profile 
set status = 0
where id not in (select max(id) from tbl_ledger_profile group by h_id);
commit;

update tbl_timing_profile 
set status = 0
where id not in (select max(id) from tbl_timing_profile group by h_id);
commit;
UPDATE TBL_PROFILE TP
  SET
   TP.REPORT_CNT =0
 WHERE  TP.REPORT_CNT is null;
 commit;

prc_update_report_id();
prc_update_dashboard_id();
prc_is_empty();


--notif
for i in (select * from tbl_report_profile
where  REF_REPORT in (select distinct ref_report from TBL_NOTIFICATIONS)
)
loop

if (i.REF_LEDGER_PROFILE = outpar_id or i.REF_PROFILE_TIME = outpar_id or i.REF_PROFILE_CURRENCY = outpar_id or 
i.REF_PROFILE_CUSTOMER = outpar_id or i.REF_PROFILE_BRANCH = outpar_id or i.REF_PROFILE_DEPOSIT = outpar_id or i.REF_PROFILE_LOAN = outpar_id)
then
update 
TBL_NOTIFICATIONS
set flag = 1
where tbl_notifications.ref_report = i.ref_report;
end if;
end loop;
--end notif

--------------------------------------------------------------------------------
--======HOSSEIIIIIIN
--======SENARAAAAAAA
--======TEST
end if;
--======HOSSEIIIIIIN
--======SENARAAAAAAA
--======TEST
--------------------------------------------------------------------------------

END PRC_PROFILE;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_VALUE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_REPORT_VALUE" (
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
'''
        || I.ID
        || ''',
'''
        || I.PERIOD_NAME
        || ''',
'''
        || I.PERIOD_COLOR
        || '''
FROM TBL_VALUE WHERE REF_ID IN (  
'
        || FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',ID_LOAN)
        || ') AND REF_CUR_ID IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR)
        || ')'
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
      SELECT '  
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
'''
        || I.ID
        || ''',
'''
        || I.PERIOD_NAME
        || ''',
'''
        || I.PERIOD_COLOR
        || '''
FROM TBL_VALUE WHERE REF_ID IN (  
'
        || FNC_PRIVATE_CREATE_QUERY('TBL_DEPOSIT',ID_DEP)
        || ') AND REF_CUR_ID IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR)
        || ')'
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
          REF_CUS_ID,
          REF_TIMING_ID,
          TIMING_NAME,
          TIMING_color
        )
      SELECT  /*+  PARALLEL(auto)   */ REF_MODALITY_TYPE,
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
        I.ID ,
        I.PERIOD_NAME ,
        I.PERIOD_COLOR
      FROM TBL_VALUE
      WHERE OTHER_TYPE = 3
      AND DUE_DATE     > to_date( DATE_TYPE1)
      AND DUE_DATE    <= to_date( DATE_TYPE1)+ I.PERIOD_DATE;
      COMMIT;
      
      ------/\/\/\/\/\/\/\/\/\/\/\//\/\/\/\/\/\/\/\/\/
      
       SELECT '  
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
FROM TBL_VALUE WHERE REF_MODALITY_TYPE in (4 ,4.1,41) AND REF_CUR_ID IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR)
        || ')'
        || '    AND DUE_DATE > to_date('''
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
'''
        || I.ID
        || ''',
'''
        || I.PERIOD_NAME
        || ''',
'''
        || I.PERIOD_COLOR
        || '''
FROM TBL_VALUE WHERE REF_ID IN (  
'
        || FNC_PRIVATE_CREATE_QUERY('TBL_DEPOSIT',ID_DEP)
        || ') AND REF_CUR_ID IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR)
        || ')'
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
      SELECT '  
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
'''
        || I.ID
        || ''',
'''
        || I.PERIOD_NAME
        || ''',
'''
        || I.PERIOD_COLOR
        || '''
FROM TBL_VALUE WHERE REF_ID IN (  
'
        || FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',ID_LOAN)
        || ') AND REF_CUR_ID IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR)
        || ')'
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
          REF_CUS_ID,
          REF_TIMING_ID,
          TIMING_NAME,
          TIMING_color
        )
      SELECT /*+   PARALLEL(auto)   */ REF_MODALITY_TYPE,
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
        I.ID ,
        I.PERIOD_NAME ,
        I.PERIOD_COLOR
      FROM TBL_VALUE
      WHERE OTHER_TYPE = 3
      AND DUE_DATE     > to_date(I.PERIOD_START)
      AND DUE_DATE     <= to_date( I.PERIOD_END) ;
      COMMIT;
      
      ---/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
      
      SELECT '  
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
FROM TBL_VALUE WHERE REF_MODALITY_TYPE IN (4,4.1,41) AND REF_CUR_ID IN ( '
        || FNC_PRIVATE_CREATE_QUERY('TBL_CURRENCY',ID_CUR)
        || ')'
        || ' AND DUE_DATE > to_date('''
        || I.PERIOD_START
        || ''',''dd-mm-yyyy'') and DUE_DATE <= to_date('''
        || I.PERIOD_END
        || ''',''dd-mm-yyyy'') ;'
      INTO VAR_QUERY
      FROM DUAL;
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;
      DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
    END IF;
  END LOOP;
  COMMIT;
  
  --- insert other code with null date 
  --== insert ref_timing_id = -1
  
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
select /*+   PARALLEL(auto)   */ REF_MODALITY_TYPE,   
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
-1,
null,
null 
from tbl_value where DUE_DATE is null;
  
  commit;
  ---------------------------
  LOC_F := SYSTIMESTAMP;
       LOC_MEGHDAR := SQL%ROWCOUNT;
  EXCEPTION 
WHEN OTHERS THEN
RAISE;
END PRC_REPORT_VALUE;
--------------------------------------------------------
--  DDL for Procedure PRC_DEPOSIT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DEPOSIT" ( RUN_DATE IN DATE )
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
 AKIN.PRC_TRANSFER_ACCOUNTING ();
 AKIN.PRC_TRANSFER_DEPOSIT(TO_DATE(RUN_DATE) );
 AKIN.PRC_TRANSFER_DEPOSIT_PROFIT(TO_DATE(RUN_DATE) );
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
--------------------------------------------------------
--  DDL for Procedure PRC_LOAN
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_LOAN" (
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
  AKIN.PRC_TRANSFER_ACCOUNTING();
  AKIN.PRC_TRANSFER_PAYMENT(to_date(RUN_DATE));
  AKIN.PRC_TRANSFER_LOAN(to_date(RUN_DATE));
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
--------------------------------------------------------
--  DDL for Procedure PRC_OTHER
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_OTHER" 
AS
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:prosijeri shamel tamami farayandhay mostaghel.
  */
  --------------------------------------------------------------------------------
BEGIN
null;--TRANSFER_ENTITIES_TO_PRAGG();
END PRC_OTHER;
--------------------------------------------------------
--  DDL for Procedure PRC_FLOW
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_FLOW" 
(
  inpar_id in number 
, eff_date in date 
) as
--------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh & Sobhan.Sadeghdeh 
  Editor Name: 
  Release Date/Time:1396/02/18-15:00
  Edit Name: 1396/03/01-13:00
  Version: 1.1
  Category:2
  Description:
  */
--------------------------------------------------------------------------------
v_queue varchar2(2000);
var varchar2(2000);
var_time1 TIMESTAMP;
var_time2 TIMESTAMP;
var_date date;

begin
EXECUTE IMMEDIATE 'truncate table tbl_log';
select qeue into v_queue from tbl_flow where inpar_id=id;
for i in ( 
 select  trim(regexp_substr(v_queue,'[^,]+', 1, level) ) as q --,rownum
from dual
connect by regexp_substr(v_queue, '[^,]+', 1, level) is not null
order by level) loop
select sysdate into var_date from dual;
select  SYSTIMESTAMP into var_time1 from dual;
var:='DECLARE
                                  eff_date DATE :=  TO_DATE(''' || eff_date ||''');
begin '||i.q||';end;';
execute immediate var;
select  SYSTIMESTAMP into var_time2 from dual;
INSERT INTO tbl_log (
    rundate,
    name,
    duration
) 
values(to_char((var_date),'YYYY-MM-DD  HH24:MI:SS'),i.q,(
with rws as (
  select var_time1 t1, 
         var_time2 t2 
  from dual
)
 select extract(hour from (t2-t1)) *3600 +
         extract(minute from (t2-t1))*60 +
         extract(second from (t2-t1)) secs
  from rws)
  )
;

commit;

end loop;
INSERT INTO tbl_log (
    rundate,
    name,
    duration
)  values(sysdate,'SUM_ALL_TIME',(
select sum(duration) from tbl_log)
);
commit;

end prc_flow;
--------------------------------------------------------
--  DDL for Procedure PRC_DEPOSIT_TEST
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DEPOSIT_TEST" 
AS
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Morteza.Sahi
  Editor Name:
  Release Date/Time:1396/04/21-10:00
  Edit Name:
  Version: 1
  Description:farayandhay test marbot be seporde
  */
  --------------------------------------------------------------------------------
BEGIN
DBMS_OUTPUT.PUT_LINE(' همه چي آرومه :)  الکي مثلا');
END PRC_DEPOSIT_TEST;
--------------------------------------------------------
--  DDL for Procedure PRC_LOAN_TEST
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_LOAN_TEST" 
AS
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Morteza.Sahi
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:farayandhay test marbot be tashilat
  */
  --------------------------------------------------------------------------------
BEGIN
DBMS_OUTPUT.PUT_LINE(' همه چي آرومه :)  الکي مثلا');
END PRC_LOAN_TEST;
--------------------------------------------------------
--  DDL for Procedure PRC_TIMING_PROFILE_DETAIL
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_TIMING_PROFILE_DETAIL" (
    INPAR_NAME               IN VARCHAR2 ,
    INPAR_DES                IN VARCHAR2 ,
    INPAR_TYPE               IN VARCHAR2 ,
    INPAR_CREATE_DATE        IN VARCHAR2 , --be date in future
    INPAR_REF_USER           IN VARCHAR2 , -- number
    INPAR_STATUS             IN VARCHAR2 , --number
    inpar_insert_or_update   IN VARCHAR2 , --insert = 1 & update = 0
    inpar_REF_TIMING_PROFILE IN VARCHAR2 ,
    inpar_PERIOD_NAME        IN VARCHAR2 ,
    inpar_PERIOD_DATE        IN NVARCHAR2 ,
    inpar_PERIOD_START       IN VARCHAR2 ,
    inpar_PERIOD_END         IN VARCHAR2 ,
    inpar_PERIOD_COLOR       IN VARCHAR2 ,
    inpar_PERIOD_STATUS      IN VARCHAR2 ,
    inpar_id                 IN NUMBER,
    outpar_id OUT varchar2 )
AS
-------------------------------------------------------------------------------
/*
  Programmer Name:Navid.Seddigh
  Editor Name: 
  Release Date/Time:1396/04/21-16:00
  Edit Name: 
  Version: 1.2
  Category:2
  Description: bade az sakhte yek profile zamani tavasote prc_profile digar ba oon procedure
               kari nadarim va control tamami amali ke dar profile zamani anjam mishavad
               be daste in procedure mioftad.
  */
--------------------------------------------------------------------------------

  var_count               NUMBER;
  var_version             NUMBER;
  max_id                  NUMBER;
  iidd                    NUMBER;
  INPAR_insert_or_update2 NUMBER;
BEGIN


  var_version:=1;
  --select count(*) into var_count from TBL_PROFILE where name||type = INPAR_NAME||INPAR_TYPE;
  --if (var_count = 0) then
  --select 'nam tekrari ast' into outpar_id from dual;
  --end if;
  --------------------------------------------------------------------------------
  IF(upper(INPAR_TYPE)        ='TARIKH') THEN
    IF (inpar_insert_or_update= 1) THEN
      
      INSERT
      INTO TBL_TIMING_PROFILE
        (
          NAME,
          DES,
          TYPE,
          CREATE_DATE,
          REF_USER,
          STATUS,
          version
        )
        VALUES
        (
          INPAR_NAME ,
          INPAR_DES ,
          2 ,
          sysdate ,
          INPAR_REF_USER ,
          INPAR_STATUS,
          var_version
        );
      COMMIT;
      --    SELECT id
      --    INTO outpar_id
      --    FROM TBL_TIMING_PROFILE
      --    WHERE CREATE_DATE =
      --      (SELECT MAX(CREATE_DATE) FROM TBL_TIMING_PROFILE
      --      );
      SELECT id
      INTO outpar_id
      FROM TBL_TIMING_PROFILE
      WHERE CREATE_DATE =
        (SELECT MAX(CREATE_DATE) FROM TBL_TIMING_PROFILE
        )
      AND id =
        (SELECT MAX(id) FROM TBL_TIMING_PROFILE
        );
      UPDATE TBL_TIMING_PROFILE SET H_ID= id WHERE id = outpar_id;
      COMMIT;
      end if;
    if(inpar_insert_or_update<>1 and inpar_REF_TIMING_PROFILE = inpar_id) then
    
      ---baraE fahymidan inke bishtarn idiEE ke dar detail zakhire boode chi hast
      SELECT MAX(TBL_TIMING_PROFILE.id)
      INTO max_id
      FROM TBL_TIMING_PROFILE
      WHERE h_id = inpar_id
      GROUP BY h_id;
      INSERT
      INTO TBL_TIMING_PROFILE
        (
          NAME,
          DES,
          TYPE,
          CREATE_DATE,
          UPDATE_DATE,
          REF_USER,
          REF_USER_UPDATE,
          STATUS,
          version,
          H_ID
        )
        VALUES
        (
          INPAR_NAME ,
          INPAR_DES ,
          2 ,
           (SELECT MAX(create_date) FROM TBL_TIMING_PROFILE  where H_ID = inpar_REF_TIMING_PROFILE),
          sysdate ,
           (SELECT MAX(REF_USER) FROM TBL_TIMING_PROFILE  where H_ID = inpar_REF_TIMING_PROFILE),
          INPAR_REF_USER ,
          INPAR_STATUS,
          (SELECT MAX(version)+1 FROM TBL_TIMING_PROFILE  where H_ID = inpar_REF_TIMING_PROFILE),
          inpar_id
        );
      COMMIT;
      SELECT id
      INTO outpar_id
      FROM TBL_TIMING_PROFILE
      WHERE  id =
        (SELECT MAX(id) FROM TBL_TIMING_PROFILE where h_id = Inpar_Ref_Timing_Profile
        );
    
      ------------------------------------------------------------------------new
      SELECT MAX(id)
      INTO iidd
      FROM TBL_TIMING_PROFILE
      WHERE h_id = INPAR_REF_TIMING_PROFILE
      GROUP BY name ;
      --------------------------------------------------------------------------
            INSERT
            INTO TBL_TIMING_PROFILE_detail
              (
                REF_TIMING_PROFILE,
                PERIOD_NAME,
                PERIOD_DATE,
                PERIOD_START,
                PERIOD_END,
                PERIOD_COLOR,
                PERIOD_STATUS
              )
              (SELECT outpar_id,
                  PERIOD_NAME,
                  PERIOD_DATE,
                  PERIOD_START,
                  PERIOD_END,
                  PERIOD_COLOR,
                  PERIOD_STATUS
                FROM TBL_TIMING_PROFILE_DETAIL,
                  tbl_TIMING_profile
                WHERE REF_TIMING_PROFILE=tbl_TIMING_profile.id
                AND REF_TIMING_PROFILE  = max_id
              );
            COMMIT;
      SELECT COUNT(*)
      INTO var_count
      FROM TBL_TIMING_PROFILE_DETAIL
      WHERE PERIOD_NAME      =inpar_PERIOD_NAME
     AND REF_TIMING_PROFILE = inpar_REF_TIMING_PROFILE;
   --AND REF_TIMING_PROFILE = max_id;
   
      IF (var_count          =0) THEN
        INSERT
        INTO TBL_TIMING_PROFILE_DETAIL
          (
            REF_TIMING_PROFILE,
            PERIOD_NAME,
            PERIOD_DATE,
            PERIOD_START,
            PERIOD_END,
            PERIOD_COLOR,
            PERIOD_STATUS
          )
          VALUES
          (
            iidd ,
            inpar_PERIOD_NAME ,
            inpar_PERIOD_DATE ,
            -- inpar_PERIOD_START ,
            to_date(inpar_PERIOD_START,'yyyy/mm/dd','nls_calendar=persian'),
            --inpar_PERIOD_END ,
            to_date(inpar_PERIOD_END,'yyyy/mm/dd','nls_calendar=persian'),
            inpar_PERIOD_COLOR ,
            inpar_PERIOD_STATUS
          );
        COMMIT;
        SELECT max(id)
        INTO outpar_id
        FROM TBL_TIMING_PROFILE_DETAIL
        WHERE PERIOD_NAME      = inpar_PERIOD_NAME
        AND REF_TIMING_PROFILE = iidd;
      ELSE
        UPDATE TBL_TIMING_PROFILE_DETAIL
        SET REF_TIMING_PROFILE = iidd ,
          PERIOD_NAME          = inpar_PERIOD_NAME ,
          PERIOD_DATE          = inpar_PERIOD_DATE ,
          PERIOD_START         = to_date(inpar_PERIOD_START,'yyyy/mm/dd','nls_calendar=persian'),
          PERIOD_END           = to_date(inpar_PERIOD_END,'yyyy/mm/dd','nls_calendar=persian'),
          PERIOD_COLOR         = inpar_PERIOD_COLOR ,
          PERIOD_STATUS        = inpar_PERIOD_STATUS
        WHERE ID               = inpar_id ;
       -- where REF_TIMING_PROFILE = inpar_id ;
        COMMIT;
      END IF;
   end if;
  ---------------------------for update  
  if (inpar_insert_or_update<>1 and inpar_REF_TIMING_PROFILE <> inpar_id) then
---
 SELECT MAX(id)
      INTO iidd
      FROM TBL_TIMING_PROFILE
      WHERE h_id = INPAR_REF_TIMING_PROFILE
      GROUP BY name ;
---
  INSERT
INTO TBL_TIMING_PROFILE_DETAIL_TEMP
  (
    ID,
    REF_TIMING_PROFILE,
    PERIOD_NAME,
    PERIOD_DATE,
    PERIOD_START,
    PERIOD_END,
    PERIOD_COLOR,
    PERIOD_STATUS
  )
  (SELECT ID,
  REF_TIMING_PROFILE,
  PERIOD_NAME,
  PERIOD_DATE,
  PERIOD_START,
  PERIOD_END,
  PERIOD_COLOR,
  PERIOD_STATUS
FROM TBL_TIMING_PROFILE_DETAIL where ref_timing_profile = iidd );
commit;



 UPDATE TBL_TIMING_PROFILE_DETAIL_temp
        SET 
          PERIOD_NAME          = inpar_PERIOD_NAME ,
          PERIOD_DATE          = inpar_PERIOD_DATE ,
          PERIOD_START         = to_date(inpar_PERIOD_START,'yyyy/mm/dd','nls_calendar=persian'),
          PERIOD_END           = to_date(inpar_PERIOD_END,'yyyy/mm/dd','nls_calendar=persian'),
          PERIOD_COLOR         = inpar_PERIOD_COLOR ,
          PERIOD_STATUS        = inpar_PERIOD_STATUS
        WHERE ID               = inpar_id ;
       -- where REF_TIMING_PROFILE = inpar_id ;
        COMMIT;
 INSERT
      INTO TBL_TIMING_PROFILE
        (
          NAME,
          DES,
          TYPE,
          CREATE_DATE,
          UPDATE_DATE,
          REF_USER,
          REF_USER_UPDATE,
          STATUS,
          version,
          H_ID
        )
        VALUES
        (
        INPAR_NAME ,
          INPAR_DES ,
          2 ,
          (SELECT MAX(CREATE_DATE) FROM TBL_TIMING_PROFILE  where H_ID = inpar_REF_TIMING_PROFILE),
          sysdate ,
           (SELECT MAX(REF_USER) FROM TBL_TIMING_PROFILE  where H_ID = inpar_REF_TIMING_PROFILE),
          INPAR_REF_USER ,
          INPAR_STATUS,
          (SELECT MAX(version)+1 FROM TBL_TIMING_PROFILE  where H_ID = inpar_REF_TIMING_PROFILE),
          inpar_REF_TIMING_PROFILE
        );
      COMMIT;
      SELECT id
      INTO outpar_id
      FROM TBL_TIMING_PROFILE
      WHERE  id =
        (SELECT MAX(id) FROM TBL_TIMING_PROFILE where h_id = Inpar_Ref_Timing_Profile
        );
        
        INSERT
INTO TBL_TIMING_PROFILE_DETAIL
  (
   
    REF_TIMING_PROFILE,
    PERIOD_NAME,
    PERIOD_DATE,
    PERIOD_START,
    PERIOD_END,
    PERIOD_COLOR,
    PERIOD_STATUS
  )
  (SELECT 
  outpar_id,
  PERIOD_NAME,
  PERIOD_DATE,
  PERIOD_START,
  PERIOD_END,
  PERIOD_COLOR,
  PERIOD_STATUS
FROM TBL_TIMING_PROFILE_DETAIL_temp where ref_timing_profile=iidd );
commit;
 EXECUTE immediate 'truncate table TBL_TIMING_PROFILE_DETAIL_temp';

   end if;
  
    -----------------------




-----------------------------------------------------------------------------------------------------------
   else --IF(upper(INPAR_TYPE)='BAZEH') THEN
      IF (inpar_insert_or_update= 1) THEN
        INSERT
        INTO TBL_TIMING_PROFILE
          (
            NAME,
            DES,
            TYPE,
            CREATE_DATE,
            REF_USER,
            STATUS,
            version
          )
          VALUES
          (
            INPAR_NAME ,
            INPAR_DES ,
            1 ,
            sysdate ,
            INPAR_REF_USER ,
            INPAR_STATUS,
            var_version
          );
        COMMIT;
      
--        SELECT id
--        INTO outpar_id
--        FROM TBL_TIMING_PROFILE
--        WHERE CREATE_DATE =
--          (SELECT MAX(CREATE_DATE) FROM TBL_TIMING_PROFILE
--          )
--        AND id =
--          (SELECT MAX(id) FROM TBL_TIMING_PROFILE
--          );


        SELECT id
        INTO outpar_id
        FROM TBL_TIMING_PROFILE
        WHERE  id =
          (SELECT MAX(id) FROM TBL_TIMING_PROFILE 
          );
          
          
        UPDATE TBL_TIMING_PROFILE SET H_ID= id WHERE id = outpar_id;
        COMMIT;
      end if;
      if(inpar_insert_or_update<>1 and inpar_REF_TIMING_PROFILE = inpar_id) then
        ---baraE fahymidan inke bishtarn idiEE ke dar detail zakhire boode chi hast
        SELECT MAX(TBL_TIMING_PROFILE.id)
        INTO max_id
        FROM TBL_TIMING_PROFILE
        WHERE h_id = inpar_id
        GROUP BY h_id;
        INSERT
        INTO TBL_TIMING_PROFILE
          (
            NAME,
            DES,
            TYPE,
            CREATE_DATE,
            UPDATE_DATE,
            REF_USER,
            REF_USER_UPDATE,
            STATUS,
            version,
            H_ID
          )
          VALUES
          (
           INPAR_NAME ,
            INPAR_DES ,
            1 ,
            (SELECT MAX(create_date) FROM TBL_TIMING_PROFILE where H_ID = inpar_REF_TIMING_PROFILE),
            sysdate ,
            (SELECT MAX(REF_USER) FROM TBL_TIMING_PROFILE where H_ID = inpar_REF_TIMING_PROFILE),
            INPAR_REF_USER ,
            INPAR_STATUS,
            (SELECT MAX(version)+1 FROM TBL_TIMING_PROFILE where H_ID = inpar_REF_TIMING_PROFILE),
            inpar_id
          );
        COMMIT;
        
      
          SELECT id
        INTO outpar_id
        FROM TBL_TIMING_PROFILE
        WHERE  id =
          (SELECT MAX(id) FROM TBL_TIMING_PROFILE where h_id = Inpar_Ref_Timing_Profile
          );
          
        
        ------------------------------------------------------------------------new
        SELECT MAX(id)
        INTO iidd
        FROM TBL_TIMING_PROFILE
        WHERE h_id = INPAR_REF_TIMING_PROFILE
        GROUP BY name ;
        --------------------------------------------------------------------
                INSERT
                INTO TBL_TIMING_PROFILE_detail
                  (
                    REF_TIMING_PROFILE,
                    PERIOD_NAME,
                    PERIOD_DATE,
                    PERIOD_START,
                    PERIOD_END,
                    PERIOD_COLOR,
                    PERIOD_STATUS
                  )
                  (SELECT outpar_id,
                      PERIOD_NAME,
                      PERIOD_DATE,
                      PERIOD_START,
                      PERIOD_END,
                      PERIOD_COLOR,
                      PERIOD_STATUS
                    FROM TBL_TIMING_PROFILE_DETAIL,
                      tbl_TIMING_profile
                    WHERE REF_TIMING_PROFILE=tbl_TIMING_profile.id
                    AND REF_TIMING_PROFILE  = max_id
                  );
                COMMIT;
        SELECT COUNT(*)
        INTO var_count
        FROM TBL_TIMING_PROFILE_DETAIL
        WHERE PERIOD_NAME      =inpar_PERIOD_NAME
       AND REF_TIMING_PROFILE = inpar_REF_TIMING_PROFILE;
       --AND REF_TIMING_PROFILE =max_id;
        IF (var_count          =0) THEN
          INSERT
          INTO TBL_TIMING_PROFILE_DETAIL
            (
              REF_TIMING_PROFILE,
              PERIOD_NAME,
              PERIOD_DATE,
              PERIOD_START,
              PERIOD_END,
              PERIOD_COLOR,
              PERIOD_STATUS
            )
            VALUES
            (
              iidd ,
              inpar_PERIOD_NAME ,
              inpar_PERIOD_DATE ,
              -- inpar_PERIOD_START ,
              to_date(inpar_PERIOD_START,'yyyy/mm/dd','nls_calendar=persian'),
              --inpar_PERIOD_END ,
              to_date(inpar_PERIOD_END,'yyyy/mm/dd','nls_calendar=persian'),
              inpar_PERIOD_COLOR ,
              inpar_PERIOD_STATUS
            );
          COMMIT;
          SELECT id
          INTO outpar_id
          FROM TBL_TIMING_PROFILE_DETAIL
          WHERE PERIOD_NAME      = inpar_PERIOD_NAME
          AND REF_TIMING_PROFILE = iidd;
        ELSE
          UPDATE TBL_TIMING_PROFILE_DETAIL
          SET REF_TIMING_PROFILE = iidd ,
            PERIOD_NAME          = inpar_PERIOD_NAME ,
            PERIOD_DATE          = inpar_PERIOD_DATE ,
            PERIOD_START         = to_date(inpar_PERIOD_START,'yyyy/mm/dd','nls_calendar=persian'),
            PERIOD_END           = to_date(inpar_PERIOD_END,'yyyy/mm/dd','nls_calendar=persian'),
            PERIOD_COLOR         = inpar_PERIOD_COLOR ,
            PERIOD_STATUS        = inpar_PERIOD_STATUS
          WHERE ID               = inpar_id ;
          COMMIT;
      
     END IF;
     end if;
--end if;


 ---------------------------for update  
  if (inpar_insert_or_update<>1 and inpar_REF_TIMING_PROFILE <> inpar_id) then
---
 SELECT MAX(id)
      INTO iidd
      FROM TBL_TIMING_PROFILE
      WHERE h_id = INPAR_REF_TIMING_PROFILE
      GROUP BY name ;
---
  INSERT
INTO TBL_TIMING_PROFILE_DETAIL_TEMP
  (
    ID,
    REF_TIMING_PROFILE,
    PERIOD_NAME,
    PERIOD_DATE,
    PERIOD_START,
    PERIOD_END,
    PERIOD_COLOR,
    PERIOD_STATUS
  )
  (SELECT ID,
  REF_TIMING_PROFILE,
  PERIOD_NAME,
  PERIOD_DATE,
  PERIOD_START,
  PERIOD_END,
  PERIOD_COLOR,
  PERIOD_STATUS
FROM TBL_TIMING_PROFILE_DETAIL where ref_timing_profile = iidd );


commit;



 UPDATE TBL_TIMING_PROFILE_DETAIL_temp
        SET 
          PERIOD_NAME          = inpar_PERIOD_NAME ,
          PERIOD_DATE          = inpar_PERIOD_DATE ,
          PERIOD_START         = to_date(inpar_PERIOD_START,'yyyy/mm/dd','nls_calendar=persian'),
          PERIOD_END           = to_date(inpar_PERIOD_END,'yyyy/mm/dd','nls_calendar=persian'),
          PERIOD_COLOR         = inpar_PERIOD_COLOR ,
          PERIOD_STATUS        = inpar_PERIOD_STATUS
        WHERE ID               = inpar_id ;
       -- where REF_TIMING_PROFILE = inpar_id ;
        COMMIT;
 INSERT
      INTO TBL_TIMING_PROFILE
        (
          NAME,
          DES,
          TYPE,
          CREATE_DATE,
          UPDATE_DATE,
          REF_USER,
          REF_USER_UPDATE,
          STATUS,
          version,
          H_ID
        )
        VALUES
        (
          INPAR_NAME,
          INPAR_DES ,
          1 ,
           (SELECT MAX(create_date) FROM TBL_TIMING_PROFILE  where H_ID = inpar_REF_TIMING_PROFILE),
          sysdate ,
           (SELECT MAX(REF_USER) FROM TBL_TIMING_PROFILE  where H_ID = inpar_REF_TIMING_PROFILE),
          INPAR_REF_USER ,
          INPAR_STATUS,
          (SELECT MAX(version)+1 FROM TBL_TIMING_PROFILE  where H_ID = inpar_REF_TIMING_PROFILE),
          inpar_REF_TIMING_PROFILE
        );
      COMMIT;
--      SELECT id
--      INTO outpar_id
--      FROM TBL_TIMING_PROFILE
--      WHERE CREATE_DATE =
--        (SELECT MAX(CREATE_DATE) FROM TBL_TIMING_PROFILE
--        )
--      AND id =
--        (SELECT MAX(id) FROM TBL_TIMING_PROFILE
--        );
   SELECT id
        INTO outpar_id
        FROM TBL_TIMING_PROFILE
        WHERE  id =
          (SELECT MAX(id) FROM TBL_TIMING_PROFILE where h_id = Inpar_Ref_Timing_Profile
          );
          
        
        INSERT
INTO TBL_TIMING_PROFILE_DETAIL
  (
   
    REF_TIMING_PROFILE,
    PERIOD_NAME,
    PERIOD_DATE,
    PERIOD_START,
    PERIOD_END,
    PERIOD_COLOR,
    PERIOD_STATUS
  )
  (SELECT 
  outpar_id,
  PERIOD_NAME,
  PERIOD_DATE,
  PERIOD_START,
  PERIOD_END,
  PERIOD_COLOR,
  PERIOD_STATUS
FROM TBL_TIMING_PROFILE_DETAIL_temp where ref_timing_profile=iidd );
commit;
 EXECUTE immediate 'truncate table TBL_TIMING_PROFILE_DETAIL_temp';

   end if;
   END IF;
   
   delete from tbl_TIMING_profile_detail where  period_status=0;
    commit;
    -----------------------
    update tbl_timing_profile 
set status = 0
where id not in (select max(id) from tbl_timing_profile group by h_id);
commit;
    
prc_is_empty();
prc_update_dashboard_id();
prc_update_report_id();
prc_update_PERIOD_DURATION();

--notif
for i in (select * from tbl_report_profile
where  REF_REPORT in (select distinct ref_report from TBL_NOTIFICATIONS)
)
loop

if (i.REF_LEDGER_PROFILE = outpar_id or i.REF_PROFILE_TIME = outpar_id or i.REF_PROFILE_CURRENCY = outpar_id or 
i.REF_PROFILE_CUSTOMER = outpar_id or i.REF_PROFILE_BRANCH = outpar_id or i.REF_PROFILE_DEPOSIT = outpar_id or i.REF_PROFILE_LOAN = outpar_id)
then
update 
TBL_NOTIFICATIONS
set flag = 1
where tbl_notifications.ref_report = i.ref_report;
end if;
end loop;
--end notif
END PRC_TIMING_PROFILE_DETAIL;
--------------------------------------------------------
--  DDL for Procedure PRC_DELETE_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DELETE_PROFILE" (
    inpar_id IN NUMBER ,
    INPAR_TYPE VARCHAR2,
    output OUT VARCHAR2 )
AS
  --------------------------------------------------------------------------------
  /*
  Programmer Name: NAVID
  Release Date/Time:1396/03/21-16:00
  Version: 1.0
  Category:2
  Description: bar asase noE profile va Id profile status an profile az yek be 
               sefr taghir mikonad ke dar asl be sorate manteghi hazf migardad na
               phiziki.
  */
  --------------------------------------------------------------------------------
BEGIN

  IF(upper(INPAR_TYPE) <>'TBL_LEDGER' and upper(INPAR_TYPE) <> 'TARIKH' and upper(INPAR_TYPE) <>'BAZEH') THEN
    UPDATE tbl_profile SET STATUS = 0 WHERE H_ID = inpar_id;
    COMMIT;
    output:=NULL;
    else if(upper(INPAR_TYPE)='TBL_LEDGER') then
     UPDATE tbl_ledger_profile SET status=0 WHERE H_ID = inpar_id;
    COMMIT;
    output:=NULL;
  ELSE if(upper(INPAR_TYPE) ='TARIKH' or upper(INPAR_TYPE) ='BAZEH') then
    UPDATE tbl_timing_profile SET status=0 WHERE H_ID = inpar_id;
    COMMIT;
    output:=NULL;
  END IF;
  end if;
  end if;
 --------------------------------------------------------------------------------
  --if(INPAR_TYPE is null) then
  --  delete from TBL_PROFILE where id = inpar_id;
  --  commit;
  --  DELETE FROM tbl_profile_detail WHERE REF_PROFILE = inpar_id;
  --  commit;
  --  output:=null;
  --
  --  else
  --   delete from TBL_TIMING_PROFILE where id = inpar_id;
  --  commit;
  --  DELETE FROM tbl_TIMING_profile_detail WHERE REF_TIMING_PROFILE = inpar_id;
  --  commit;
  --  output:=null;
  --  end if;
  ------------------------------------------------------------------------------
END prc_delete_profile;
--------------------------------------------------------
--  DDL for Procedure PRC_TRANSFER_CUSTOMER
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_TRANSFER_CUSTOMER" AS 
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Morteza.Sahi
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:enteghal moshtariha ha az server bank be pragg
  */
  --------------------------------------------------------------------------------
BEGIN
   INSERT 
   /*+ APPEND PARALLEL(auto)   */
  INTO TBL_CUSTOMER
    (
      CUS_ID,
      NAME,
      FAMILY,
      NAT_REG_CODE,
      ADDRESS,
      BIRTHDATE,
      GENDER,
      TYPE,
      BRANCH_ID
    )
  SELECT /*+   PARALLEL(auto)   */ DISTINCT CUSTOMERNO,
   case when  FIRSTNAME is null then CUTOMERNAME else FIRSTNAME end as FIRSTNAME ,
    LASTNAME,
    SSN,
    '',
    BIRTH_DATE,
    '',
    '',
    BR_CODE+10000
  FROM DADEKAVAN_DAY.etelaate_moshtari;
  COMMIT ;
  INSERT INTO TBL_CUSTOMER
    (CUS_ID, NAME, FAMILY
    )
  SELECT 99999, 'ناشناس', '' FROM dual;
  COMMIT ;
END PRC_TRANSFER_Customer;
--------------------------------------------------------
--  DDL for Procedure PRC_TRANSFER_LEDGER
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_TRANSFER_LEDGER" AS
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Morteza.Sahi
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:enteghal daftarkol ha az server bank be pragg
  */
  --------------------------------------------------------------------------------
BEGIN

execute immediate 'truncate table TBL_LEDGER';
  /******ebteda hame bargha ra dar TBL_LEDGER mirizim va baed az an be tartib sath be sath bala miaim va sum childha ro hesab mikonim ******/

INSERT INTO TBL_LEDGER (LEDGER_CODE,NAME,PARENT_CODE,node_TYPE,DEPTH)     select gl_code,fnc_FarsiValidate(gl_name),substr(gl_code,1,7)||'00',case when GL_CODE like '1%'or GL_CODE like '4%' or GL_CODE like '6%' then 1
    when GL_CODE like '2%'or GL_CODE like '3%' or GL_CODE like '5%' or GL_CODE like '7%' then 2
    end  as nd,5 from DADEKAVAN_DAY.gf1glet  where substr (gl_code,8,2) != 0;
  commit;
INSERT INTO TBL_LEDGER (LEDGER_CODE,NAME,PARENT_CODE,node_TYPE,DEPTH)     select gl_code,fnc_FarsiValidate(gl_name),substr(gl_code,1,5)||'0000',case when GL_CODE like '1%'or GL_CODE like '4%' or GL_CODE like '6%' then 1
    when GL_CODE like '2%'or GL_CODE like '3%' or GL_CODE like '5%' or GL_CODE like '7%' then 2
    end  as nd,4 from DADEKAVAN_DAY.gf1glet where substr(gl_code,6,2) != 0 and substr(gl_code,8,2) = 0;
  commit;
INSERT INTO TBL_LEDGER (LEDGER_CODE,NAME,PARENT_CODE,node_TYPE,DEPTH)     select gl_code,fnc_FarsiValidate(gl_name),substr(gl_code,1,3)||'000000',case when GL_CODE like '1%'or GL_CODE like '4%' or GL_CODE like '6%' then 1
    when GL_CODE like '2%'or GL_CODE like '3%' or GL_CODE like '5%' or GL_CODE like '7%' then 2
    end  as nd,3 from DADEKAVAN_DAY.gf1glet where substr(gl_code,4,2) != 0 and substr(gl_code,6,4) = 0;
  commit;
INSERT INTO TBL_LEDGER (LEDGER_CODE,NAME,PARENT_CODE,node_TYPE,DEPTH)     select gl_code,fnc_FarsiValidate(gl_name),substr(gl_code,1,1)||'00000000',case when GL_CODE like '1%'or GL_CODE like '4%' or GL_CODE like '6%' then 1
    when GL_CODE like '2%'or GL_CODE like '3%' or GL_CODE like '5%' or GL_CODE like '7%' then 2
  end  as nd,2 from DADEKAVAN_DAY.gf1glet where substr(gl_code,2,2) != 0 and substr(gl_code,4,6) = 0;
  commit;
INSERT INTO TBL_LEDGER (LEDGER_CODE,NAME,PARENT_CODE,node_TYPE,DEPTH)     select gl_code,fnc_FarsiValidate(gl_name),0,case when GL_CODE like '1%'or GL_CODE like '4%' or GL_CODE like '6%' then 1
    when GL_CODE like '2%'or GL_CODE like '3%' or GL_CODE like '5%' or GL_CODE like '7%' then 2
  end  as nd,1 from DADEKAVAN_DAY.gf1glet where substr(gl_code,1,1) != 0 and substr(gl_code,2,8) = 0;
  commit;
    /******ezafe kardanerishe be derakht ******/

INSERT INTO TBL_LEDGER (LEDGER_CODE,NAME,PARENT_CODE,node_TYPE,DEPTH)     values (000000,'ريشه',null,null,0);
  commit;

END PRC_TRANSFER_LEDGER;
--------------------------------------------------------
--  DDL for Procedure PRC_TRANSFER_BRANCH
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_TRANSFER_BRANCH" AS 
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Moeteza.Sahi
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:enteghal shobe ha az server bank be pragg
  */
  --------------------------------------------------------------------------------
BEGIN
   INSERT
  INTO TBL_BRANCH
    (
      BRN_ID,
      NAME,
      REF_CTY_ID,
      CITY_NAME,
      REF_STA_ID,
      STA_NAME
    )
  SELECT CODE+10000,
    BR_NAME,
    SHAHR_CODE,
    SHAHR_NAME,
    '',
    ''
  FROM DADEKAVAN_DAY.ETELAATE_SHOBE ;
END PRC_TRANSFER_BRANCH;
--------------------------------------------------------
--  DDL for Procedure PRC_TRANSFER_CITY
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_TRANSFER_CITY" AS 
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Morteza.Sahi
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:enteghal shar ha az server bank be pragg
  */
  --------------------------------------------------------------------------------
BEGIN
    INSERT
  INTO TBL_CITY
    (
      CTY_ID,
      CTY_NAME,
      DES,
      REF_STA_ID
    )
  SELECT DISTINCT SHAHR_CODE,
    DADEKAVAN_DAY.ETELAATE_SHOBE.SHAHR_NAME,
    '',
    ''
  FROM DADEKAVAN_DAY.ETELAATE_SHOBE ;
END PRC_TRANSFER_CITY;
--------------------------------------------------------
--  DDL for Procedure PRC_TRANSFER_CURRENCY_REL
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_TRANSFER_CURRENCY_REL" AS 
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Morteza.Sahi
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:enteghal rabete arzha ha az server bank be pragg
  */
  --------------------------------------------------------------------------------
BEGIN
  INSERT
  INTO TBL_CURRENCY_REL
    (
      SRC_CUR_ID,
      DEST_CUR_ID,
      REL_DATE,
      CHANGE_RATE
    )
  SELECT b.CUR_ID,
    4,
    sysdate,
    RATE_AMOUNT
  FROM DADEKAVAN_DAY.ARZ_RELATION a,
    TBL_CURRENCY b
  WHERE B.SWIFT_CODE   =A.Code
  AND a.EFFDATE =
    (SELECT DISTINCT MAX(EFFDATE) FROM DADEKAVAN_DAY.ARZ_RELATION
    ) ;
END PRC_TRANSFER_CURRENCY_REL;
--------------------------------------------------------
--  DDL for Procedure PRC_TRANSFER_LOAN_TYPE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_TRANSFER_LOAN_TYPE" AS 
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Morteza.Sahi
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:enteghal noe tashilat ha az server bank be pragg
  */
  --------------------------------------------------------------------------------
BEGIN
   INSERT
  INTO TBL_LOAN_TYPE
    (
      REF_LOAN_TYPE,
      NAME
    )
  SELECT DISTINCT SUBSTR(TYPE_CODE,3,3),
    CASE
      WHEN MAX(TITLE) IS NULL
      THEN 'تسهيلات نوع '
        ||SUBSTR(TYPE_CODE,3,3)
      ELSE MAX(TITLE)
    END
  FROM DADEKAVAN_DAY.NOE_TASHILAT
  GROUP BY SUBSTR(TYPE_CODE,3,3);
  commit;
END PRC_TRANSFER_LOAN_TYPE;
--------------------------------------------------------
--  DDL for Procedure PRC_TRANSFER_DEPOSIT_TYPE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_TRANSFER_DEPOSIT_TYPE" AS 
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Morteza.Sahi joooooooooooooooon
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:enteghal noe sepordeha ha az server bank be pragg
  */
  --------------------------------------------------------------------------------
BEGIN
  INSERT
  INTO TBL_DEPOSIT_TYPE
    (
      REF_DEPOSIT_TYPE ,
      NAME
    )
  SELECT DISTINCT SUBSTR(DP_TYPE_CODE,3,4),
    TITLE
  FROM DADEKAVAN_DAY.NOE_SEPORDE;
  commit;
END PRC_TRANSFER_DEPOSIT_TYPE;
--------------------------------------------------------
--  DDL for Procedure PRC_AGGREGATION
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_AGGREGATION" ( INPAR_REF_REQ_ID IN NUMBER ) AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: rasool.jahani,morteza.sahi
  Editor Name:
  Release Date/Time:1396/04/26-10:00
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
 VAR_MAX_EFFDATE_LEDGER     DATE;
 LOC_S                      TIMESTAMP;
 LOC_F                      TIMESTAMP;
 LOC_MEGHDAR                NUMBER;
BEGIN
 EXECUTE IMMEDIATE 'truncate table TBL_VALUE_AGGRIGATION';
  
 /*EXECUTE IMMEDIATE 'truncate table tbl_other_ledger_code';*/
 SELECT
  MAX(EFF_DATE)
 INTO
  VAR_MAX_EFFDATE_LEDGER
 FROM TBL_LEDGER_ARCHIVE; /*-----****************************************************/
 

    /****** be dast avardane profil haye gozaresh mord niaz va bishtarin sathe daftar kol *****--*/

 SELECT
  REF_REPORT_ID
 INTO
  VAR_REF_REPORT_ID
 FROM TBL_REPREQ
 WHERE ID   = INPAR_REF_REQ_ID;

 SELECT
  REF_LEDGER_PROFILE
 INTO
  VAR_REF_LEDGER_PROFILE
 FROM TBL_REPORT_PROFILE
 WHERE REF_REPORT   = VAR_REF_REPORT_ID;

 SELECT
  REF_PROFILE_TIME
 INTO
  VAR_REF_PROFILE_TIME
 FROM TBL_REPORT_PROFILE
 WHERE REF_REPORT   = VAR_REF_REPORT_ID;

 SELECT
  TO_NUMBER(MAX(DEPTH) )
 INTO
  VAR_MAX_LEVEL_LEDGER
 FROM TBL_LEDGER_PROFILE_DETAIL
 WHERE REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE;

 SELECT
  SYSDATE
 INTO
  VAR_DATE_INSERT
 FROM DUAL;
  
  
  /******enteghal har code sarfasl dar har baze zamani be jadval aggrigation******/

 INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_VALUE_AGGRIGATION ( LEDGER_CODE,BALANCE,REF_TIMING_ID ) SELECT /*+   PARALLEL(auto)   */
  REF_LEGER_CODE
 ,SUM(BALANCE)
 ,REF_TIMING_ID
 FROM TBL_VALUE_TEMP
 GROUP BY
  REF_LEGER_CODE
 ,REF_TIMING_ID;

 COMMIT;
 
 

      /******  ezefe kardane code sarfaslhaee ke dar value nabode ba code meghdar "0"  *****--*/
 INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_VALUE_AGGRIGATION ( LEDGER_CODE,BALANCE,REF_TIMING_ID ) SELECT /*+   PARALLEL(auto)   */  DISTINCT
  B.CODE
 ,0
 ,A.REF_TIMING_ID
 FROM (
   SELECT
    CODE
   FROM TBL_LEDGER_PROFILE_DETAIL
   WHERE REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE
    AND
     DEPTH                = VAR_MAX_LEVEL_LEDGER
  ) B
 ,    (
   SELECT
    LEDGER_CODE
   ,TBL_VALUE_AGGRIGATION.REF_TIMING_ID
   FROM TBL_VALUE_AGGRIGATION
  ) A
 WHERE A.LEDGER_CODE <> B.CODE;

 COMMIT;
 
 
 

      /******  ezefe kardane mande be onvan yek repper   *****--*/
-- INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_VALUE_AGGRIGATION ( LEDGER_CODE,BALANCE,REF_TIMING_ID ) SELECT /*+  PARALLEL(auto)   */
--  REF_LEGER_CODE
-- ,BALANCE
-- ,-1
-- FROM TBL_VALUE_TEMP
-- WHERE TBL_VALUE_TEMP.DUE_DATE IS NULL;
--
-- COMMIT;



      /******  ezefe kardane mande be onvan yek repper   *****--*/
 INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_VALUE_AGGRIGATION ( LEDGER_CODE,BALANCE,REF_TIMING_ID ) SELECT /*+  PARALLEL(auto)   */
  LEDGER_CODE
 ,BALANCE
 ,0
 FROM TBL_LEDGER_ARCHIVE
 WHERE EFF_DATE             = VAR_MAX_EFFDATE_LEDGER
  AND
   LEDGER_CODE IN (
    SELECT
     CODE
    FROM TBL_LEDGER_PROFILE_DETAIL
    WHERE REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE
     AND
      DEPTH                = VAR_MAX_LEVEL_LEDGER
   );

 COMMIT;

  
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
 ,VAR_REF_REPORT_ID
 ,ID
 ,INPAR_REF_REQ_ID
 FROM TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = VAR_REF_PROFILE_TIME;

 COMMIT;
  /*-----------------------------------------*/
   /******tajmie daftar kol baraye har baze zamani dar repval (enteghale barghaye tajmie shode be repval)*****--*/
  /*-----------------------------------------*/
 INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_REPVAL (
  REF_REPREQ_ID
 ,REF_REPPER_ID
 ,LEDGER_CODE
 ,VALUE
 ,PARENT_CODE
 ,DEPTH
 ,NAME
 ) SELECT /*+   PARALLEL(auto)   */
  INPAR_REF_REQ_ID
 , CASE
    WHEN NVL(
     (
      SELECT
       ID
      FROM TBL_REPPER
      WHERE OLD_ID          = TVA.REF_TIMING_ID
       AND
        REF_REPORT_ID   = VAR_REF_REPORT_ID
       AND
        REF_REQ_ID      = INPAR_REF_REQ_ID
     )
    ,0
    ) = 0 THEN TVA.REF_TIMING_ID
   else  NVL( to_char(
     (
      SELECT
       ID
      FROM TBL_REPPER
      WHERE OLD_ID          = TVA.REF_TIMING_ID
       AND
        REF_REPORT_ID   = VAR_REF_REPORT_ID
       AND
        REF_REQ_ID      = INPAR_REF_REQ_ID
     ))
    ,0
    ) 
   END
  AS REF_TIMING_ID
 ,TVA.LEDGER_CODE
 ,TVA.BALANCE
 ,TLPD.PARENT_CODE
 ,VAR_MAX_LEVEL_LEDGER
 ,TLPD.NAME
 FROM TBL_VALUE_AGGRIGATION TVA
 ,    TBL_LEDGER_PROFILE_DETAIL TLPD
 WHERE TLPD.CODE                 = TVA.LEDGER_CODE
  AND
   TLPD.REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE;

 COMMIT;
  /*-----------------------------------------*/
     /******tajmie daftar kol baraye har baze zamani dar repval barasas daftar kole taen shode *****--*/
  /*-----------------------------------------*/
 FOR I IN REVERSE 1..VAR_MAX_LEVEL_LEDGER LOOP
  INSERT /*+ APPEND PARALLEL(auto)   */ INTO TBL_REPVAL (
   REF_REPREQ_ID
  ,REF_REPPER_ID
  ,LEDGER_CODE
  ,VALUE
  ,PARENT_CODE
  ,DEPTH
  ) SELECT /*+  PARALLEL(auto)   */ DISTINCT
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
    FROM TBL_REPVAL TR
     LEFT JOIN TBL_LEDGER_PROFILE_DETAIL TLPD ON TLPD.CODE   = TR.PARENT_CODE
    WHERE TLPD.DEPTH                = I
     AND
      TLPD.REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE
     AND
      TR.REF_REPREQ_ID          = INPAR_REF_REQ_ID         /*------------------------*/
    GROUP BY
     TR.PARENT_CODE
    ,TR.REF_REPPER_ID
   ) A
   RIGHT JOIN (
    SELECT
     *
    FROM TBL_LEDGER_PROFILE_DETAIL
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
 FROM TBL_REPPER
 WHERE REF_REPORT_ID   = VAR_REF_REPORT_ID;
       /******hazf kardan node haye ke eshtebah vard shodan(bedone zaman hastand)*****--*/

 DELETE FROM (
  SELECT
   *
  FROM TBL_REPVAL
  WHERE LEDGER_CODE IN (
    SELECT
     LEDGER_CODE
    FROM TBL_REPVAL
    GROUP BY
     LEDGER_CODE
    HAVING COUNT(*) = VAR_CNT_REF_PROFILE_TIME
   )
 ) WHERE REF_REPPER_ID IS NULL;

 COMMIT;

   /******ezafe kardane name code sarfaslha baraye jologiri az join ezafe dar namayesh gozaresh*****--*/
 UPDATE TBL_REPVAL T
  SET
   T.NAME = (
    SELECT
     NAME
    FROM TBL_LEDGER_PROFILE_DETAIL
    WHERE TBL_LEDGER_PROFILE_DETAIL.REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE
     AND
      TBL_LEDGER_PROFILE_DETAIL.CODE                 = T.LEDGER_CODE
   )
 WHERE T.REF_REPREQ_ID   = INPAR_REF_REQ_ID;

 COMMIT;
  /*-----------------------------------------*/
 LOC_F         := SYSTIMESTAMP;
 LOC_MEGHDAR   := SQL%ROWCOUNT;
/*      EXCEPTION */
/*      WHEN OTHERS THEN*/
/*      RAISE;*/
  /*-----------------------------------------*/
END PRC_AGGREGATION;
--------------------------------------------------------
--  DDL for Procedure PRC_RESET
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_RESET" AS 
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:truncate kardan jadval hay asli system be manzor ejray mojadad
  */
  --------------------------------------------------------------------------------
BEGIN

  EXECUTE IMMEDIATE 'truncate table TBL_LEDGER';
 -- EXECUTE IMMEDIATE 'truncate table TBL_CURRENCY_REL';
 -- EXECUTE IMMEDIATE 'truncate table TBL_STATE';
  EXECUTE IMMEDIATE 'truncate table TBL_CUSTOMER';
  EXECUTE IMMEDIATE 'truncate table TBL_LOAN_TYPE';
  EXECUTE IMMEDIATE 'truncate table TBL_DEPOSIT_TYPE';
  EXECUTE IMMEDIATE 'truncate table TBL_BRANCH';
  EXECUTE IMMEDIATE 'truncate table TBL_CITY';
 
  END PRC_RESET;
--------------------------------------------------------
--  DDL for Procedure PRC_LIKEN
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_LIKEN" (
    INPAR_RUNDATE IN DATE )
AS
BEGIN
  
INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE
  (
    REF_MODALITY_TYPE,
    REF_CUR_ID,
    REF_CUS_ID,
    REF_TYPE,
    REF_LEGER_CODE,
    REF_ID,
    REF_BRANCH,
    DUE_DATE,
    BALANCE,
    other_type
  )
WITH t_hami AS
  (SELECT REF_LEGER_CODE as id,
    SUM(BALANCE) as mande,
    COUNT(balance) as cnt,
    REF_CUR_ID as arz,
    max(other_type) as other
  FROM tbl_value
  GROUP BY REF_LEGER_CODE,
    ref_cur_id--t_hami
  ),
  t_df
AS
  (SELECT ledger_code as id,
    SUM(ABS(balance)) as mande,
    REF_CUR_ID as arz
  FROM TBL_LEDGER_ARCHIVE
  where eff_date = INPAR_RUNDATE
  GROUP BY LEDGER_CODE,
    REF_CUR_ID --t_df
  ),
   DIFF AS
  (SELECT DF.ID,
    ((DF.MANDE - TH.MANDE)/th.mande) DIV,
    df.arz,
    th.other
  FROM T_DF DF,
    T_HAMI TH
  WHERE   TH.ID    = DF.ID
--  AND (TH.ID LIKE '1%'
--  OR TH.ID LIKE '2%')
  )
SELECT --0,
h.ref_modality_type,
  H.ref_cur_id,
  H.ref_cus_id,
  H.ref_type,
  H.ref_leger_code,
  H.ref_id,
  H.ref_branch,
  H.due_date,

  CASE
    WHEN REF_id IS not NULL
    THEN FLOOR(DIV*NVL(balance, 0))
    ELSE NULL
  END BED,
  0
FROM DIFF D
JOIN TBL_VALUE H
ON D.ID    = H.ref_leger_code
WHERE DIV <> 0;
commit;

INSERT /*+ APPEND PARALLEL(auto)   */
INTO TBL_VALUE
  (
    REF_MODALITY_TYPE,
    REF_LEGER_CODE,
    REF_CUR_ID,
    BALANCE,
    DUE_DATE,
    other_type,
    ref_id,
    ref_cty_id,
    ref_cus_id,
    ref_branch
  )


WITH t_hami AS
  (SELECT REF_LEGER_CODE as id,
   max(rEF_MODALITY_TYPE) as modal,
    SUM(BALANCE) as mande,
    COUNT(nvl(balance,0)) as cnt,
    REF_CUR_ID as arz,
    max(other_type) as other,
    max(ref_id) as code,
    max(ref_cty_id) as city_id,
    max(ref_cus_id) as cus_id,
    max(ref_branch) as branch_id
  FROM tbl_value
  GROUP BY REF_LEGER_CODE,
    ref_cur_id--t_hami
  ),
  t_df
AS
  (SELECT ledger_code as id,
    SUM(ABS(balance)) as mande,
    REF_CUR_ID as arz
  FROM TBL_LEDGER_ARCHIVE
  where eff_date = INPAR_RUNDATE
  GROUP BY LEDGER_CODE,
    REF_CUR_ID --t_dif
  ),
   DIFF AS
  (SELECT DF.ID,
    ((DF.MANDE - TH.MANDE)) DIV,
    df.arz,
    modal,
    other,
    code,
    cus_id,
    branch_id,
    city_id
  FROM T_DF DF,
    T_HAMI TH
  WHERE  TH.ID    = DF.ID
-- AND (TH.ID LIKE '1%'
-- OR TH.ID LIKE '2%')
  )
select modal,id,4,round(div),INPAR_RUNDATE+1,0,code,city_id,cus_id,branch_id
from diff 
where div<>0;



commit;

END PRC_LIKEN;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_REPORT_PROFILE" (
 INPAR_INSERT_OR_UPDATE     IN NUMBER
 ,INPAR_NAME                 IN VARCHAR2
 ,INPAR_DES                  IN VARCHAR2
 ,INPAR_CREATE_DATE          IN VARCHAR2
 ,INPAR_REF_USER             IN VARCHAR2
 ,INPAR_STATUS               IN NUMBER
 ,INPAR_REF_LEDGER_PROFILE   IN VARCHAR2
 ,INPAR_REF_TIMING_PROFILE   IN VARCHAR2
 ,INPAR_TIMING_PRFILE_TYPE   IN VARCHAR2  /*meghdare 1 bazei va meghdare 2 tarikhi*/
 ,INPAR_REF_DEP_PROFILE      IN VARCHAR2
 ,INPAR_REF_LON_PROFILE      IN VARCHAR2
 ,INPAR_REF_BRN_PROFILE      IN VARCHAR2
 ,INPAR_REF_CUS_PROFILE      IN VARCHAR2
 ,INPAR_REF_CUR_PROFILE      IN VARCHAR2
 ,INPAR_TYPE                 IN VARCHAR2
 ,INPAR_CATEGORY             IN VARCHAR2
 ,OUTPAR_ID                  OUT VARCHAR2
) AS 
  /*
  Programmer Name: sobhan sadeghzadeh
  Editor Name:
  Release Date/Time:1396/04/25
  Edit Name: 
  Version: 1
  Category:
  Description: az in prc baraye sakht gazarsh bar asase profile haye entekhab shode estefade mishavad 
  
  */
 VAR_VERSION      NUMBER;
 VAR_MAX_ID       NUMBER;
 VAR_MIN_ID       NUMBER;
 VAR_NAME_COUNT   VARCHAR2(2000);
BEGIN
 VAR_VERSION   := 1;

/*barrasi inke aya gozareshi hamname  gozaresh jadid mojud mibashad ya na */
 SELECT
  COUNT(NAME)
 INTO
  VAR_NAME_COUNT
 FROM TBL_REPORT
 WHERE NAME       = INPAR_NAME
  AND
   STATUS     = 1
  AND
   TYPE       = INPAR_TYPE
  AND
   CATEGORY   = INPAR_CATEGORY;

/* agar name gozaresh tekrari bashad ,meghdare output=-1 mishavad va gozaresh sakhte nemishavad*/

 IF
  ( INPAR_INSERT_OR_UPDATE = 1 AND VAR_NAME_COUNT != 0 )
 THEN
  OUTPAR_ID   :=-1;
 ELSE

/* if(inpar_insert_or_update= 1)  ==> new report*/
  IF
   ( INPAR_INSERT_OR_UPDATE = 1 )
  THEN
   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,REF_LEDGER_PROFIEL
   ,REF_TIMING_PROFILE
   ,TIMING_PROFILE_TYPE
   ,REF_DEP_PROFILE
   ,REF_LON_PROFILE
   ,REF_BRN_PROFILE
   ,REF_CUS_PROFILE
   ,REF_CUR_PROFILE
   ,VERSION
   ,TYPE
   ,CATEGORY
   ) VALUES (
   INPAR_NAME
   ,INPAR_DES
  -- ,TO_DATE(INPAR_CREATE_DATE,'yyyy/mm/dd')
  ,sysdate
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,INPAR_REF_LEDGER_PROFILE
   ,INPAR_REF_TIMING_PROFILE
   ,INPAR_TIMING_PRFILE_TYPE
   ,INPAR_REF_DEP_PROFILE
   ,INPAR_REF_LON_PROFILE
   ,INPAR_REF_BRN_PROFILE
   ,INPAR_REF_CUS_PROFILE
   ,INPAR_REF_CUR_PROFILE
   ,VAR_VERSION
   ,INPAR_TYPE
   ,INPAR_CATEGORY
   );

   COMMIT;
   
   
   /*dar TBL_REPORT   max(id) baraye akharin ruz be be dast amade va dar outpar_id rikhte mishavad*/
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
  /*chon dar inja in gozaresh jadid mibashad ,meghdare h-id barabare id mibashad */

   UPDATE TBL_REPORT
    SET
     H_ID = ID
   WHERE ID   = OUTPAR_ID;

   COMMIT;
  ELSE   /*update report*/
 /*var_min_id baraye meghdardehi be h_id estefade mishavad.meghdare tamame reporthayi ke ba name anha barabare name vorudi mibashad barabare var_min_id mibashad.  */
   SELECT
    MIN(ID)
   INTO
    VAR_MIN_ID
   FROM TBL_REPORT
   WHERE NAME   = INPAR_NAME
   and CATEGORY = INPAR_CATEGORY;
 
 /*baraye update ,gazareshe jadidi ba maghdire jadid  dar TBL_REPORT insert mishavad */
 /*meghdare version 1 vahed afzayesh peyda mikonad.*/
 /*meghdare h_id barabare var_min_id mishavad*/

   INSERT INTO TBL_REPORT (
    NAME
   ,DES
   ,CREATE_DATE
   ,REF_USER
   ,STATUS
   ,REF_LEDGER_PROFIEL
   ,REF_TIMING_PROFILE
   ,TIMING_PROFILE_TYPE
   ,REF_DEP_PROFILE
   ,REF_LON_PROFILE
   ,REF_BRN_PROFILE
   ,REF_CUS_PROFILE
   ,REF_CUR_PROFILE
   ,VERSION
   ,H_ID
   ,TYPE
   ,CATEGORY
   ) VALUES (
   INPAR_NAME
   ,INPAR_DES
   ,sysdate
   ,INPAR_REF_USER
   ,INPAR_STATUS
   ,INPAR_REF_LEDGER_PROFILE
   ,INPAR_REF_TIMING_PROFILE
   ,INPAR_TIMING_PRFILE_TYPE
   ,INPAR_REF_DEP_PROFILE
   ,INPAR_REF_LON_PROFILE
   ,INPAR_REF_BRN_PROFILE
   ,INPAR_REF_CUS_PROFILE
   ,INPAR_REF_CUR_PROFILE
   ,(
     SELECT
      MAX(VERSION) + 1
     FROM TBL_REPORT
    )
   ,VAR_MIN_ID
   ,INPAR_TYPE
   ,INPAR_CATEGORY
   );

   COMMIT;
   --===============
   update tbl_report
   set status = 0
   where id not in (select max(id) from tbl_report where h_id = VAR_MIN_ID) and name = INPAR_NAME and type = INPAR_TYPE and CATEGORY =  INPAR_CATEGORY ;
   commit;
   --================
   SELECT
    OUT_ID
   INTO
    OUTPAR_ID
   FROM (
     SELECT
      MAX(ID)
     ,NAME
     ,MAX(H_ID) AS OUT_ID
     FROM TBL_REPORT
     WHERE NAME   = INPAR_NAME
     GROUP BY
      NAME
    );

  END IF;
  /*--------------------------------------------------------------------*/

  SELECT
   MAX(ID)
  INTO
   VAR_MAX_ID
  FROM TBL_REPORT
  WHERE 
/*    CREATE_DATE =*/
/*      (SELECT MAX(CREATE_DATE) FROM TBL_REPORT*/
/*      )*/
/*      and */
   NAME   =INPAR_NAME;
      

/*jadadtarin gazaresh sakhte shode  va akharin taghyorat anjam shode (bar asase var_max_id) ,dar tbl_report_profile  insert mishavad*/

  INSERT INTO TBL_REPORT_PROFILE (
   REF_REPORT
  ,REF_LEDGER_PROFILE
  ,REF_PROFILE_TIME
  ,REF_PROFILE_CURRENCY
  ,REF_PROFILE_CUSTOMER
  ,REF_PROFILE_BRANCH
  ,REF_PROFILE_DEPOSIT
  ,REF_PROFILE_LOAN
  ) VALUES (
   VAR_MAX_ID
  ,INPAR_REF_LEDGER_PROFILE
  ,INPAR_REF_TIMING_PROFILE
  ,INPAR_REF_CUR_PROFILE
  ,INPAR_REF_CUS_PROFILE
  ,INPAR_REF_BRN_PROFILE
  ,INPAR_REF_DEP_PROFILE
  ,INPAR_REF_LON_PROFILE
  );

  COMMIT;
 END IF;/*if(inpar_insert_or_update= 1 and inpar_NAME=var_name) then*/

/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
 PRC_UPDATE_REPORT_ID ();
 PRC_UPDATE_DASHBOARD_ID ();
 commit;
 UPDATE TBL_PROFILE TP
  SET
   TP.REPORT_CNT =  nvl((
    SELECT
     COUNT(*)
    FROM TBL_REPORT_PROFILE
    WHERE REF_PROFILE_LOAN   = TP.ID
   ),0)
 WHERE TP.ID IN (
   SELECT DISTINCT
    REF_PROFILE_LOAN
   FROM TBL_REPORT_PROFILE
  );

 UPDATE TBL_PROFILE TP
  SET
   TP.REPORT_CNT =  nvl((
    SELECT
     COUNT(*)
    FROM TBL_REPORT_PROFILE
    WHERE REF_PROFILE_CURRENCY   = TP.ID
   ),0)
 WHERE TP.ID IN (
   SELECT DISTINCT
    REF_PROFILE_CURRENCY
   FROM TBL_REPORT_PROFILE  
  );

 UPDATE TBL_PROFILE TP
  SET
   TP.REPORT_CNT = nvl((
    SELECT
     COUNT(*)
    FROM TBL_REPORT_PROFILE
    WHERE REF_PROFILE_CUSTOMER   = TP.ID
   ),0)
 WHERE TP.ID IN (
   SELECT DISTINCT
    REF_PROFILE_CUSTOMER
   FROM TBL_REPORT_PROFILE
  );

 UPDATE TBL_PROFILE TP
  SET
   TP.REPORT_CNT = nvl((
    SELECT
     COUNT(*)
    FROM TBL_REPORT_PROFILE
    WHERE REF_PROFILE_BRANCH   = TP.ID
   ),0)
 WHERE TP.ID IN (
   SELECT DISTINCT
    REF_PROFILE_BRANCH
   FROM TBL_REPORT_PROFILE
  );

 UPDATE TBL_PROFILE TP
  SET
   TP.REPORT_CNT = nvl((
    SELECT
     COUNT(*)
    FROM TBL_REPORT_PROFILE
    WHERE REF_PROFILE_DEPOSIT   = TP.ID
   ),0)
 WHERE TP.ID IN (
   SELECT DISTINCT
    REF_PROFILE_DEPOSIT
   FROM TBL_REPORT_PROFILE
  );

 UPDATE TBL_LEDGER_PROFILE TLP
  SET
   TLP.REPORT_CNT =nvl( (
    SELECT
     COUNT(*)
    FROM TBL_REPORT_PROFILE
    WHERE REF_LEDGER_PROFILE   = TLP.ID
   ),0)
 WHERE TLP.ID IN (
   SELECT DISTINCT
    REF_LEDGER_PROFILE
   FROM TBL_REPORT_PROFILE
  );

 UPDATE TBL_TIMING_PROFILE TTP
  SET
   TTP.REPORT_CNT = nvl((
    SELECT
     COUNT(*)
    FROM TBL_REPORT_PROFILE
    WHERE REF_PROFILE_TIME   = TTP.ID
   ),0)
 WHERE TTP.ID IN (
   SELECT DISTINCT
    REF_PROFILE_TIME
   FROM TBL_REPORT_PROFILE
  );
   COMMIT;

UPDATE TBL_PROFILE TP
  SET
   TP.REPORT_CNT =0
 WHERE  TP.REPORT_CNT is null;
 COMMIT;

   prc_NOTIF_CHECK_REPEAT(OUTPAR_ID);
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------*/
END PRC_REPORT_PROFILE;
--------------------------------------------------------
--  DDL for Procedure PRC_CREATE_REPORT_REQUEST
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_CREATE_REPORT_REQUEST" (
 INPAR_REPORT_ID   IN NUMBER
 ,INPAR_USER_ID     IN VARCHAR2
 ,INPAR_NOTIF_ID    IN NUMBER
 ,OUTPAR_RES        OUT NUMBER
) AS
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/19-10:00
  Edit Name:
  Version: 1
  Description:darkhast baray ijad yek gozaresh jadid
  */
  /*------------------------------------------------------------------------------*/

 VAR_REP_REQ_ID        NUMBER;
 VAR_NOTIF_ID          VARCHAR2(50);
 VAR_REPPER_DATE       DATE;
 VAR_INPAR_REPORT_ID   NUMBER;
 V_R                   NUMBER;
 LOC_MEGHDAR           VARCHAR2(4000);
 VAR_TYPE              VARCHAR2(200);
BEGIN

/*yaftane id gozaresh az jadval gozareshat*/
 SELECT
  MAX(ID)
 INTO
  VAR_INPAR_REPORT_ID
 FROM TBL_REPORT
 WHERE H_ID   = (
   SELECT
    H_ID
   FROM TBL_REPORT
   WHERE ID   = INPAR_REPORT_ID
  )
 GROUP BY
  H_ID;

/* darj yek darkhast gozaresh jadid dar jadval TBL_REP_REQ*/

 INSERT INTO TBL_REPREQ (
  REF_REPORT_ID
 ,REF_USER_ID
 ,REQ_DATE
 ,STATUS
 ,REF_LEDGER_PROFILE
 ,REF_PROFILE_TIME
 ,REF_PROFILE_CURRENCY
 ,REF_PROFILE_CUSTOMER
 ,REF_PROFILE_BRANCH
 ,REF_PROFILE_DEPOSIT
 ,REF_PROFILE_LOAN
 ,REF_HID_REPORT
 ,TYPE
 ,CATEGORY
 ) VALUES (
  VAR_INPAR_REPORT_ID
 ,INPAR_USER_ID
 ,SYSDATE
 ,0
 ,(
   SELECT
    REF_LEDGER_PROFILE
   FROM TBL_REPORT_PROFILE
   WHERE REF_REPORT   = VAR_INPAR_REPORT_ID
  )
 ,(
   SELECT
    REF_PROFILE_TIME
   FROM TBL_REPORT_PROFILE
   WHERE REF_REPORT   = VAR_INPAR_REPORT_ID
  )
 ,(
   SELECT
    REF_PROFILE_CURRENCY
   FROM TBL_REPORT_PROFILE
   WHERE REF_REPORT   = VAR_INPAR_REPORT_ID
  )
 ,(
   SELECT
    REF_PROFILE_CUSTOMER
   FROM TBL_REPORT_PROFILE
   WHERE REF_REPORT   = VAR_INPAR_REPORT_ID
  )
 ,(
   SELECT
    REF_PROFILE_BRANCH
   FROM TBL_REPORT_PROFILE
   WHERE REF_REPORT   = VAR_INPAR_REPORT_ID
  )
 ,(
   SELECT
    REF_PROFILE_DEPOSIT
   FROM TBL_REPORT_PROFILE
   WHERE REF_REPORT   = VAR_INPAR_REPORT_ID
  )
 ,(
   SELECT
    REF_PROFILE_LOAN
   FROM TBL_REPORT_PROFILE
   WHERE REF_REPORT   = VAR_INPAR_REPORT_ID
  )
 ,(
   SELECT
    H_ID
   FROM TBL_REPORT
   WHERE ID   = VAR_INPAR_REPORT_ID
  )
 ,(
   SELECT
    TYPE
   FROM TBL_REPORT
   WHERE ID   = VAR_INPAR_REPORT_ID
  )
 ,(
   SELECT
    CATEGORY
   FROM TBL_REPORT
   WHERE ID   = VAR_INPAR_REPORT_ID
  )
 );

 COMMIT;
  
  /*yaftan id darkhast ijad shode*/
 SELECT
  MAX(ID)
 INTO
  VAR_REP_REQ_ID
 FROM TBL_REPREQ;
  /*--------------------------*/

 SELECT
  TYPE
 INTO
  VAR_TYPE
 FROM TBL_REPORT
 WHERE ID   = VAR_INPAR_REPORT_ID;

 IF
  ( VAR_TYPE = 'duedate' )
 THEN
  PKG_DUE_DATE.PRC_DUE_DATE_REPORT_VALUE(VAR_INPAR_REPORT_ID);
 ELSIF ( VAR_TYPE = 'IDPS' ) THEN
  PKG_IDPS.PRC_IDPS_REP_VALUE(VAR_INPAR_REPORT_ID);
 ELSIF ( VAR_TYPE = 'com2' ) THEN
  PKG_COM.PRC_COM_VALUE(VAR_INPAR_REPORT_ID);
 ELSIF ( VAR_TYPE = 'LCR' ) THEN
  PKG_LCR.PRC_LCR_REP_VALUE(VAR_INPAR_REPORT_ID);
 ELSIF ( VAR_TYPE = 'duedate_loan' ) THEN
  PKG_DUE_DATE_LOAN.PRC_DUE_DATE_REPORT_VALUE(VAR_INPAR_REPORT_ID);
 ELSIF ( VAR_TYPE = 'NOP' ) THEN
  PKG_NOP.PRC_REPORT_VALUE_NOP(VAR_INPAR_REPORT_ID);
 ELSIF ( UPPER(VAR_TYPE) = 'DDDR' ) THEN
  PKG_DUE_DATE_DEPOSIT_RATE.PRC_DDDR_GET_DETAIL(VAR_INPAR_REPORT_ID);
 ELSIF ( VAR_TYPE = 'GAP_NIIM' ) THEN
  PKG_GAP_NIIM.PRC_GAP_NIIM_REPORT_VALUE(VAR_INPAR_REPORT_ID);
   ELSIF ( UPPER(VAR_TYPE) = 'DDLT' ) THEN
  PKG_DUE_DATE_LOAN_TYPE.prc_DDLT_GET_DETAIL(VAR_INPAR_REPORT_ID);
 ELSE
  
  /*ejra prasijer baray filter kardan dadeh hay gozersh*/
  PRC_REPORT_VALUE(VAR_INPAR_REPORT_ID);
  
  /*ejra tajmi*/
  PRC_AGGREGATION(VAR_REP_REQ_ID);
  
  /*PRC_GET_QUERY_REPORT(var_Rep_Req_ID,var_report_name);*/
 END IF;
  
  /*berozresani vaziat gozaresh be payan yafte dar jadval darkhastha */

 UPDATE TBL_REPREQ
  SET
   STATUS = 1
 WHERE ID   = VAR_REP_REQ_ID;

 COMMIT;
  
 /* prc_liken(to_date('15-NOV-17'));*/
  /*berozresani elanat*/
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
 ,VAR_REP_REQ_ID
 ,''
 ,'0'
 ,VAR_NOTIF_ID
 );
  
  /*khoroji alaki*/

 OUTPAR_RES   := VAR_NOTIF_ID;
EXCEPTION
 WHEN OTHERS THEN
  LOC_MEGHDAR   := SQLERRM;
  PRC_NOTIFICATION(
   'update'
  ,INPAR_NOTIF_ID
  ,''
  ,''
  ,''
  ,'error'
  ,0
  ,''
  ,0
  ,VAR_REP_REQ_ID
  ,''
  ,'1'
  ,VAR_NOTIF_ID
  );

  COMMIT;
  DELETE FROM TBL_REPREQ WHERE ID   = VAR_REP_REQ_ID;

  COMMIT;
  LOC_MEGHDAR   := SQLCODE;
  UPDATE TBL_NOTIFICATIONS
   SET
    ERROR = LOC_MEGHDAR
  WHERE ID   = INPAR_NOTIF_ID;

  COMMIT;
/*     INSERT INTO TABLE1 (P) VALUES (LOC_MEGHDAR);*/
/*       LOC_MEGHDAR := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;*/
/*       INSERT INTO TABLE1 (P) VALUES (LOC_MEGHDAR);*/
END PRC_CREATE_REPORT_REQUEST;
--------------------------------------------------------
--  DDL for Procedure PRC_DELETE_REPORT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DELETE_REPORT" 
(
  inpar_ID IN NUMBER,
  outpar out VARCHAR2

) AS 
var_CATEGORY VARCHAR2(200);
var_h_id number;

 /*
  Programmer Name: sobhan sadeghzade
  Editor Name:
  Release Date/Time:1396/04/28
  Edit Name:
  Version: 1
  Category:
  Description:  namayesh nadadane report hayi ke hazf mishavand 
  report hayi ke baraye anha status=0 bashad namayesh dade nemishavnd.
  
  
  ** gozareshate "SENSITIVE" be tore kamel hazf mishavand 
  
  baraye gozaresh haye "SENSITIVE" ==> id=inpar_ID
  baraye sayere gozareshat ==> h_id=inpar_ID
 
  */
BEGIN
select h_id into var_h_id from tbl_report where id = inpar_ID;
  
  select CATEGORY into var_CATEGORY from tbl_report where id = inpar_ID;
  if(upper(var_CATEGORY)!='SENSITIVE') then   -- hameye gozareshha be joz gozareshat "SENSITIVE"
  
  update tbl_report set STATUS=0 where h_id=var_h_id;
  outpar:=null;
  update tbl_report set STATUS=0 where id=inpar_ID;

  end if;
  if(upper(var_CATEGORY)='SENSITIVE') then
          delete from TBL_REPORT where id=INPAR_ID;
          delete from TBL_REP_DETAIL_PROFIL_CUR_SECS where REF_ID=INPAR_ID;
       end if;
  
       
  
END PRC_DELETE_REPORT;
--------------------------------------------------------
--  DDL for Procedure PRC_NOTIFICATION
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_NOTIFICATION" 
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
  Programmer Name: Rasool.Jahani
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
INTO TBL_NOTIFICATIONS
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
  
  select max(id) into OUTPAR_STATUS from TBL_NOTIFICATIONS;
  Commit;
 END IF; 
 
IF INPAR_OPT_TYPE = 'update' THEN 
  --=======UPDATE================Berozresani yek elan mojod.
   UPDATE TBL_NOTIFICATIONS
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
  FROM TBL_NOTIFICATIONS
  WHERE ID        = INPAR_ID;
  Commit;
END IF;

IF INPAR_OPT_TYPE = 'check' THEN
  --=======CHECK STATUS================  Bargardandan tamimi vaziyat yek elan mojod.
  SELECT 
  STATUS
  into OUTPAR_STATUS
  FROM TBL_NOTIFICATIONS
  
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
FROM TBL_NOTIFICATIONS
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
--  DDL for Procedure PRC_SIMILAR_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_SIMILAR_PROFILE" 
(
--------------------------------------------------------------------------------
  /*
  Programmer Name: NAVID.SEDIGH
  Release Date/Time:1396/05/2-16:00
  Version: 1.0
  Category:2
  Description: in procedure bare sakhte profile moshabeh dar risk naghdinegi
               estefade mishavad.
  */
--------------------------------------------------------------------------------
  inpar_type in varchar2, --zamani --ledger --other
  inpar_id in number ,
  inpar_name in varchar2,
  inpar_des in varchar2,
  outpar_id out VARCHAR2 --id
  
  ) as 
  
  iidd number;
  profile_id varchar2(40); --h_id
  outpar_id2 varchar(40); -- id
  begin
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
  if(upper(inpar_type)='OTHER') then
  
  
  select  max(id) into iidd
  FROM TBL_PROFILE
  where h_id = inpar_id
  group by name ;
  
   INSERT INTO TBL_PROFILE
  (
   
    TYPE,
    CREATE_DATE,
    REF_USER,
    STATUS,
    VERSION,
    ITEM_CNT
    
  )
 
  (
   select type, sysdate,ref_user,status,1,ITEM_CNT from tbl_profile where id = iidd
  );
             --==================================================
  SELECT id
    INTO outpar_id2
    FROM TBL_PROFILE
    WHERE id =  (SELECT MAX(id) FROM TBL_PROFILE );
    
      outpar_id:=outpar_id2;
    
             --====================================================   
    update TBL_PROFILE
    set H_ID= id,
    name = inpar_name,
    des = inpar_des
    where id = outpar_id;
    commit;
             --==================================================== 
    SELECT h_id
    INTO profile_id
    FROM TBL_PROFILE
    WHERE id =  (SELECT MAX(id) FROM TBL_PROFILE );
    
    
    outpar_id := outpar_id||','||profile_id;
              --====================================================    
  INSERT INTO TBL_PROFILE_DETAIL
  (
   
    REF_PROFILE, 
    SRC_COLUMN,
    CONDITION
  )
  (select outpar_id2,src_column,condition from TBL_PROFILE_DETAIL where REF_PROFILE= iidd);
  commit;
              --====================================================
  end if; 
  
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if(upper(inpar_type)='ZAMANI') then

select  max(id) into iidd
FROM TBL_TIMING_PROFILE
where h_id = inpar_id
group by name ;

             --==================================================
INSERT INTO TBL_TIMING_PROFILE
  (
   
   
    TYPE,
    CREATE_DATE,
    REF_USER,
    STATUS,
    VERSION 
  )
  (
   select type, sysdate,ref_user,status,1 from tbl_TIMING_profile where id = iidd
  );
  commit;
             --==================================================  
    SELECT id
    INTO outpar_id2
    FROM TBL_TIMING_PROFILE
    WHERE  id =  (SELECT MAX(id) FROM TBL_TIMING_PROFILE );
      
      outpar_id:=outpar_id2;
             --==================================================      
     update TBL_TIMING_PROFILE
    set H_ID= id,
    name = inpar_name,
    des = inpar_des
    where id = outpar_id;
    commit;     
             --===================================================  
             --==================================================== 
    SELECT h_id
    INTO profile_id
    FROM TBL_TIMING_PROFILE
    WHERE id =  (SELECT MAX(id) FROM TBL_TIMING_PROFILE );
   
   outpar_id := outpar_id||','||profile_id;
              --====================================================              
  
  INSERT INTO TBL_TIMING_PROFILE_DETAIL
  (
    
    REF_TIMING_PROFILE,
    PERIOD_NAME,
    PERIOD_DATE,
    PERIOD_START,
    PERIOD_END,
    PERIOD_COLOR,
    PERIOD_STATUS
  )
  (select outpar_id2,period_name,PERIOD_DATE,PERIOD_START,PERIOD_END,PERIOD_COLOR,PERIOD_STATUS from TBL_TIMING_PROFILE_DETAIL where REF_TIMING_PROFILE=iidd);
  commit;
             --==================================================  
end if; 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if(upper(INPAR_TYPE) in ('TBL_LEDGER', 'CUR_SENS','NIIM','NPL','CAR','COM')) then

select  max(id) into iidd
  FROM TBL_LEDGER_PROFILE
  where h_id = inpar_id
  group by name ;
             --==================================================
INSERT INTO TBL_LEDGER_PROFILE
  (
    CREATE_DATE,
    REF_USER,
    STATUS,
    type,
    VERSION

  )
  (
   select  sysdate,ref_user,status,type,1 from TBL_LEDGER_PROFILE where id = iidd
  );
  commit;
             --==================================================  
SELECT id
    INTO outpar_id2
    FROM TBL_LEDGER_PROFILE
    WHERE  id =  (SELECT MAX(id) FROM TBL_LEDGER_PROFILE );
      outpar_id:=outpar_id2;
             --==================================================      
     update TBL_LEDGER_PROFILE
    set H_ID= id,
    name = inpar_name,
    des = inpar_des,
    type = inpar_type
    where id = outpar_id;
    commit;      
                 --============================================== 
    SELECT h_id
    INTO profile_id
    FROM TBL_LEDGER_PROFILE
    WHERE id =  (SELECT MAX(id) FROM TBL_LEDGER_PROFILE );
   outpar_id := outpar_id||','||profile_id;
             --==================================================
             --==================================================  
             
   INSERT
INTO TBL_LEDGER_PROFILE_DETAIL
  (
   
    REF_LEDGER_PROFILE,
    CODE,
    NAME,
    PARENT_CODE,
    DEPTH,
    STATUS
  )
(select outpar_id2,code,name,PARENT_CODE,DEPTH,STATUS from TBL_LEDGER_PROFILE_DETAIL where REF_LEDGER_PROFILE= iidd);
commit;

update TBL_LEDGER_PROFILE_DETAIL
set PARENT_CODE = outpar_id2
where ref_ledger_profile =outpar_id2 and depth =1;
commit;
             --==================================================  
end if;
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end prc_similar_profile;
--------------------------------------------------------
--  DDL for Procedure PRC_IS_EMPTY
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_IS_EMPTY" as 
cnt number;
--------------------------------------------------------------------------------
  /*
  Programmer Name: NAVID.Seddigh
  Release Date/Time:1396/05/2-16:00
  Version: 1.0
  Category:2
  Description: In procedure profile haE bedoone Item va Item dar ra az ham mojaza
               mikonad.
  */
--------------------------------------------------------------------------------
begin

    --====================
    /* in halghe for rooye satre jadvale tbl_profile harekat mikonad va har profile 
    ra baresi mikonad ke aya dar jadvale tbl_profile_detial meghdar darad ya na?! */
   
 for i in (select id from tbl_profile)
 loop
    select count(*) into cnt from tbl_profile_detail where REF_PROFILE = i.id ;
    if (cnt = 0) then 
      update tbl_profile set is_empty = 1 where id = i.id;
      commit;
    else if(cnt > 0 ) then
      update tbl_profile set is_empty = 0 where id = i.id;
      commit;
    end if;
    end if;
 end loop;
    --====================
     /* in halghe for rooye satre jadvale tbl_ledger_profile harekat mikonad va har profile 
    ra baresi mikonad ke aya dar jadvale tbl_ledger_profile_detial meghdar darad ya na ?!*/
cnt:=0; 
for i in(select  id from tbl_ledger_profile)
  loop 
    select count(*) into cnt from tbl_ledger_profile_detail where ref_ledger_profile = i.id;
    if(cnt=0) then 
      update tbl_ledger_profile set is_empty = 1 where id = i.id;
      commit;
    else if(cnt>0) then
      update tbl_ledger_profile set is_empty = 0 where id = i.id;
      commit;
    end if;
    end if;
  end loop;
     --====================
      /* in halghe for rooye satre jadvale tbl_timing_profile harekat mikonad va har profile 
    ra baresi mikonad ke aya dar jadvale tbl_timing_profile_detail meghdar darad ya na ?!*/
cnt:=0;
for i in(select  id from tbl_timing_profile)
  loop 
    select count(*) into cnt from tbl_timing_profile_detail where ref_timing_profile = i.id;
    if(cnt=0) then 
      update tbl_timing_profile set is_empty = 1 where id = i.id;
      commit;
    else if(cnt>0) then
      update tbl_timing_profile set is_empty = 0 where id = i.id;
      commit;
    end if;
    end if;
  end loop;
   --====================
end prc_is_empty;
--------------------------------------------------------
--  DDL for Procedure PRC_DELETE_ZAMANI_DETAIL
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DELETE_ZAMANI_DETAIL" (
INPAR_NAME               IN VARCHAR2 ,
    INPAR_DES                IN VARCHAR2 ,
    INPAR_TYPE               IN VARCHAR2 ,
    INPAR_CREATE_DATE        IN VARCHAR2 , --be date in future
    INPAR_REF_USER           IN VARCHAR2 , -- number
    INPAR_STATUS             IN VARCHAR2 , --number
    
    inpar_REF_TIMING_PROFILE IN VARCHAR2 ,
    
    inpar_id                 IN NUMBER,
    outpar_id OUT NUMBER
)
as 
iidd number;
  --------------------------------------------------------------------------------
  /*
  Programmer Name: NAVID
  Release Date/Time:1396/05/05-12:00
  Version: 1.0
  Category:2
  Description:
  */
  --------------------------------------------------------------------------------
begin
 
---
 SELECT MAX(id)
      INTO iidd
      FROM TBL_TIMING_PROFILE
      WHERE h_id = INPAR_REF_TIMING_PROFILE
      GROUP BY name ;
---
  INSERT
INTO TBL_TIMING_PROFILE_DETAIL_TEMP
  (
    ID,
    REF_TIMING_PROFILE,
    PERIOD_NAME,
    PERIOD_DATE,
    PERIOD_START,
    PERIOD_END,
    PERIOD_COLOR,
    PERIOD_STATUS
  )
  (SELECT ID,
  REF_TIMING_PROFILE,
  PERIOD_NAME,
  PERIOD_DATE,
  PERIOD_START,
  PERIOD_END,
  PERIOD_COLOR,
  PERIOD_STATUS
FROM TBL_TIMING_PROFILE_DETAIL where ref_timing_profile = iidd );


commit;




delete from TBL_TIMING_PROFILE_DETAIL_TEMP
where id= inpar_id;
    
        COMMIT;
 INSERT
      INTO TBL_TIMING_PROFILE
        (
          NAME,
          DES,
          TYPE,
          CREATE_DATE,
          REF_USER,
          STATUS,
          version,
          H_ID
        )
        VALUES
        (
          upper(INPAR_NAME) ,
          INPAR_DES ,
          INPAR_TYPE ,
          sysdate ,
          INPAR_REF_USER ,
          INPAR_STATUS,
          (SELECT MAX(version)+1 FROM TBL_TIMING_PROFILE  where H_ID = inpar_REF_TIMING_PROFILE),
          inpar_REF_TIMING_PROFILE
        );
      COMMIT;
      SELECT id
      INTO outpar_id
      FROM TBL_TIMING_PROFILE
      WHERE CREATE_DATE =
        (SELECT MAX(CREATE_DATE) FROM TBL_TIMING_PROFILE
        )
      AND id =
        (SELECT MAX(id) FROM TBL_TIMING_PROFILE
        );
        
        INSERT
INTO TBL_TIMING_PROFILE_DETAIL
  (
   
    REF_TIMING_PROFILE,
    PERIOD_NAME,
    PERIOD_DATE,
    PERIOD_START,
    PERIOD_END,
    PERIOD_COLOR,
    PERIOD_STATUS
  )
  (SELECT 
  outpar_id,
  PERIOD_NAME,
  PERIOD_DATE,
  PERIOD_START,
  PERIOD_END,
  PERIOD_COLOR,
  PERIOD_STATUS
FROM TBL_TIMING_PROFILE_DETAIL_temp where ref_timing_profile=iidd );
commit;
 EXECUTE immediate 'truncate table TBL_TIMING_PROFILE_DETAIL_temp';
  
end prc_delete_zamani_detail;
--------------------------------------------------------
--  DDL for Procedure PRC_DELETE_ARCHIVE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DELETE_ARCHIVE" (
 INPAR_REP_REQ_ID   IN NUMBER
 ,OUT_PAR            OUT NUMBER
)
 AS
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Morteza.Sahi
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description: be manzore hazf kardan gozareshat archiv shode az in procedure estefade mishavad.
  */
  /*------------------------------------------------------------------------------*/
BEGIN
 DELETE FROM TBL_REPREQ WHERE ID   = INPAR_REP_REQ_ID;

 COMMIT;
 DELETE FROM TBL_REPVAL WHERE REF_REPREQ_ID   = INPAR_REP_REQ_ID;

 COMMIT;
    /****** hazf ref_zamani marbot be gozaresh hazf shode*****--*/
 DELETE FROM TBL_REPPER WHERE REF_REQ_ID   = INPAR_REP_REQ_ID;
 
 COMMIT;
 DELETE FROM TBL_DUE_DATE_DETAIL WHERE REP_REQ    = INPAR_REP_REQ_ID;

 COMMIT;
  DELETE FROM TBL_STATE_REP_PROFILE_DETAIL WHERE VERSION    = INPAR_REP_REQ_ID;

 COMMIT;
  DELETE FROM TBL_NOTIFICATIONS WHERE  REF_REPREQ  = INPAR_REP_REQ_ID;

  COMMIT;

 OUT_PAR   := 0;
END PRC_DELETE_ARCHIVE;
--------------------------------------------------------
--  DDL for Procedure PRC_UPDATE_REPORT_ID
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_UPDATE_REPORT_ID" as 

ledger number;
timing number;
loan number;
currency number;
customer number;
branch number;
deposit number;
v_st number;

begin
  --------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh
  Editor Name: 
  Release Date/Time:1396/05/09-16:00
  Edit Name: 
  Version: 1.1
  Category:2
  Description: zamani ke version profili taghir konad, satr be satre jadvale 
               tbl_report_profile peymayesh mishavad va ID profile ha bar asase
               be rooz tarin version update mishavad.
  */
  --------------------------------------------------------------------------------

    
for i in (select * from tbl_report_profile) 
loop
    if(i.ref_profile_loan is not null) then
    select max(id) into loan from tbl_profile
    where h_id in(
    select h_id from tbl_profile p
    where p.id in (select ref_profile_loan from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and r.STATUS=1 and ref_profile_loan = i.ref_profile_loan ));
    select status into v_st from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and rp.id = i.id; 
    if(v_st !=0) then
      update tbl_report_profile 
      set ref_profile_loan = loan
      where id = i.id;
      commit; 
      end if;
    end if;
    v_st:=null;
    if(i.ref_profile_currency is not null) then
    select max(id) into currency from tbl_profile
    where h_id in(
    select h_id from tbl_profile p
    where p.id in (select ref_profile_currency from tbl_report_profile rp ,tbl_report r where rp.REF_REPORT = r.id and r.STATUS=1 and ref_profile_currency = i.ref_profile_currency));
    select status into v_st from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and rp.id = i.id;
    if(v_st !=0) then
      update tbl_report_profile 
      set ref_profile_currency = currency
      where id = i.id;
      commit; 
      end if;
    end if;
    v_st:=null;
    if(i.ref_profile_customer is not null) then
    select max(id) into customer from tbl_profile
    where h_id in(
    select h_id from tbl_profile p
    where p.id in (select ref_profile_customer from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and r.STATUS=1 and ref_profile_customer = i.ref_profile_customer ));
    select status into v_st from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and rp.id = i.id;
    if(v_st !=0) then
      update tbl_report_profile 
      set ref_profile_customer = customer
      where id = i.id;
      commit; 
      end if;
    end if;
    v_st:=null;
    if(i.ref_profile_branch is not null) then
    select max(id) into branch from tbl_profile
    where h_id in(
    select h_id from tbl_profile p
    where p.id in (select ref_profile_branch from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and r.STATUS=1 and ref_profile_branch = i.ref_profile_branch  ));
    select status into v_st from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and rp.id = i.id;
    if(v_st !=0) then
      update tbl_report_profile 
      set ref_profile_branch = branch
      where id = i.id;
      commit; 
      end if;
    end if;
    v_st:= null;
    if(i.ref_profile_deposit is not null) then
    select max(id) into deposit from tbl_profile
    where h_id in(
    select h_id from tbl_profile p
    where p.id in (select ref_profile_deposit from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and r.STATUS=1 and ref_profile_deposit = i.ref_profile_deposit  ));
    select status into v_st from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and rp.id = i.id;
    if(v_st !=0) then
      update tbl_report_profile 
      set ref_profile_deposit = deposit
      where id = i.id;
      commit; 
      end if;
    end if;
    v_st:=null; 
    if(i.ref_ledger_profile is not null) then
    select max(id) into ledger from tbl_ledger_profile
    where h_id in(
    select h_id from tbl_ledger_profile p
    where p.id in (select ref_ledger_profile from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and r.STATUS=1 and ref_ledger_profile = i.ref_ledger_profile  ));
    select status into v_st from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and rp.id = i.id;
    if(v_st !=0) then
      update tbl_report_profile 
      set ref_ledger_profile = ledger
      where id = i.id;
      commit; 
      end if;
    end if;
    v_st:=null;
    if(i.ref_profile_time is not null) then
    select max(id) into timing from tbl_timing_profile
    where h_id in(
    select h_id from tbl_timing_profile p
    where p.id in (select ref_profile_time from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and r.STATUS=1 and ref_profile_time = i.ref_profile_time  ));
    select status into v_st from tbl_report_profile rp,tbl_report r where rp.REF_REPORT = r.id and rp.id = i.id;
    if(v_st !=0) then
      update tbl_report_profile 
      set ref_profile_time = timing
      where id = i.id; 
      commit; 
     end if;
     end if;
     v_st := null;
end loop;

--================================= For dynamic risk 
for i in (select * from DYNAMIC_LQ.REPORTS) 
loop
    if(i.LEDGER_PROFILE_ID is not null) then
    select max(id) into ledger from tbl_ledger_profile
    where h_id in(
    select h_id from tbl_ledger_profile p
    where p.id in (select LEDGER_PROFILE_ID from DYNAMIC_LQ.REPORTS  where  LEDGER_PROFILE_ID = i.LEDGER_PROFILE_ID ));
    
      update DYNAMIC_LQ.REPORTS 
      set LEDGER_PROFILE_ID = ledger
      where id = i.id;
      commit; 
    end if;



    if(i.CUR_PROFILE_ID is not null) then
    select max(id) into currency from tbl_profile
    where h_id in(
    select h_id from tbl_profile p
    where p.id in (select CUR_PROFILE_ID from DYNAMIC_LQ.REPORTS  where  CUR_PROFILE_ID = i.CUR_PROFILE_ID));
    
    
      update DYNAMIC_LQ.REPORTS 
      set CUR_PROFILE_ID = currency
      where id = i.id;
      commit; 
    end if;
 
 
 
    if(i.TIMING_PROFILE_ID is not null) then
    select max(id) into timing from tbl_timing_profile
    where h_id in(
    select h_id from tbl_timing_profile p
    where p.id in (select TIMING_PROFILE_ID from DYNAMIC_LQ.REPORTS where  TIMING_PROFILE_ID = i.TIMING_PROFILE_ID  ));
    
      update DYNAMIC_LQ.REPORTS 
      set TIMING_PROFILE_ID = timing
      where id = i.id; 
      commit; 
     end if;
   
end loop;

--===================================
end prc_update_report_id;
--------------------------------------------------------
--  DDL for Procedure PRC_LEDGER_ARCHIVE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_LEDGER_ARCHIVE" (inpar_date in date)
as
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Morteza.Sahi
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description: baraye enteghal daftar kol be jadval  TBL_LEDGER_ARCHIVE be manzore negah dashtane tarikhie daftarkol
  */
  --------------------------------------------------------------------------------
begin
  /******ebteda hame bargha ra dar TBL_LEDGER_ARCHIVE mirizim va baed az an be tartib sath be sath bala miaim va sum childha ro hesab mikonim ******/

insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,PARENT_CODE,DEPTH,BALANCE,REF_CUR_ID,name,eff_date,CUR_BALANCE)
select a.GL_CODE, substr(a.GL_CODE,1,7)||'00', 5, sum (a.final_bal), b.id, max(a.gl_name),inpar_date,0 from dadekavan_day.balance_mv a, satrap_day.bi_table_arz@satrap b where 
trunc(a.effdate) <= trunc(inpar_date) and a.curr_cod = b.nam and  a.curr_cod ='IRR'  group by GL_CODE,b.id;
commit;

insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,PARENT_CODE,DEPTH,BALANCE,REF_CUR_ID,name,eff_date,CUR_BALANCE)
select a.GL_CODE, substr(a.GL_CODE,1,7)||'00', 5, sum (a.final_bal_moadel), b.id, max(a.gl_name),inpar_date, sum (a.final_bal) from dadekavan_day.balance_mv a, satrap_day.bi_table_arz@satrap b where 
trunc(a.effdate) <= trunc(inpar_date) and a.curr_cod = b.nam and  a.curr_cod <>'IRR'  group by GL_CODE,b.id;
commit;

insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,PARENT_CODE,DEPTH,BALANCE,REF_CUR_ID,eff_date,CUR_BALANCE)
(select PARENT_CODE, substr(PARENT_CODE,1,5)||'0000', 4, sum(BALANCE), REF_CUR_ID,inpar_date,sum(CUR_BALANCE) from TBL_LEDGER_ARCHIVE where depth = 5 and EFF_DATE = inpar_date  group by PARENT_CODE,REF_CUR_ID);
commit;

insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,PARENT_CODE,DEPTH,BALANCE,REF_CUR_ID,eff_date,cur_balance)
(select PARENT_CODE, substr(PARENT_CODE,1,3)||'000000', 3, sum(BALANCE), REF_CUR_ID,inpar_date,sum(CUR_BALANCE) from TBL_LEDGER_ARCHIVE where depth = 4 and EFF_DATE = inpar_date group by PARENT_CODE,REF_CUR_ID);
commit;

insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,PARENT_CODE,DEPTH,BALANCE,REF_CUR_ID,eff_date,cur_balance)
(select PARENT_CODE, substr(PARENT_CODE,1,1)||'00000000', 2, sum(BALANCE), REF_CUR_ID,inpar_date,sum(CUR_BALANCE) from TBL_LEDGER_ARCHIVE where depth = 3 and EFF_DATE = inpar_date group by PARENT_CODE,REF_CUR_ID);
commit;

insert into TBL_LEDGER_ARCHIVE(LEDGER_CODE,PARENT_CODE,DEPTH,BALANCE,REF_CUR_ID,eff_date,CUR_BALANCE)
(select PARENT_CODE, 0, 1, sum(BALANCE), REF_CUR_ID ,inpar_date,sum(CUR_BALANCE) from TBL_LEDGER_ARCHIVE where depth = 2 and EFF_DATE = inpar_date group by PARENT_CODE,REF_CUR_ID);
commit;
UPDATE TBL_LEDGER_ARCHIVE t
SET t.NAME =
  (SELECT MAX(GL_NAME)
  FROM DADEKAVAN_DAY.gf1glet
  WHERE  GL_CODE   = t.ledger_code
  )
WHERE t.eff_date = inpar_date
and t.depth<> 5;
commit;

END ;
--------------------------------------------------------
--  DDL for Procedure PRC_LEDGER_BRANCH
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_LEDGER_BRANCH" (inpar_date in date)
as
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Morteza.Sahi
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:baraye enteghal daftar kol ba tafkik shobe be jadval  TBL_LEDGER_BRANCH  ast.
  */
  --------------------------------------------------------------------------------
begin
  /******ebteda hame bargha ra ba tafkik shobe dar TBL_LEDGER_BRANCH mirizim va baed az an be tartib sath be sath bala miaim va sum childha ro hesab mikonim ******/

insert into TBL_LEDGER_BRANCH(LEDGER_CODE,PARENT_CODE,DEPTH,BALANCE,REF_CUR_ID,name,eff_date,ref_branch)
select a.GL_CODE, substr(a.GL_CODE,1,7)||'00', 5, sum (a.final_bal), b.id, max(a.gl_name),inpar_date,a.br_code+10000 from dadekavan_day.balance_mv a, satrap_day.bi_table_arz@satrap b where 
trunc(a.effdate) <= trunc(inpar_date) and a.curr_cod = b.nam group by GL_CODE,b.id,a.br_code;
commit;

insert into TBL_LEDGER_BRANCH(LEDGER_CODE,PARENT_CODE,DEPTH,BALANCE,REF_CUR_ID,eff_date,ref_branch)
(select PARENT_CODE, substr(PARENT_CODE,1,5)||'0000', 4, sum(BALANCE), REF_CUR_ID,inpar_date,ref_branch from TBL_LEDGER_BRANCH where depth = 5 and EFF_DATE = inpar_date  group by PARENT_CODE,REF_CUR_ID,ref_branch );
commit;

insert into TBL_LEDGER_BRANCH(LEDGER_CODE,PARENT_CODE,DEPTH,BALANCE,REF_CUR_ID,eff_date,ref_branch)
(select PARENT_CODE, substr(PARENT_CODE,1,3)||'000000', 3, sum(BALANCE), REF_CUR_ID,inpar_date,ref_branch  from TBL_LEDGER_BRANCH where depth = 4 and EFF_DATE = inpar_date group by PARENT_CODE,REF_CUR_ID,ref_branch );
commit;

insert into TBL_LEDGER_BRANCH(LEDGER_CODE,PARENT_CODE,DEPTH,BALANCE,REF_CUR_ID,eff_date,ref_branch)
(select PARENT_CODE, substr(PARENT_CODE,1,1)||'00000000', 2, sum(BALANCE), REF_CUR_ID,inpar_date,ref_branch  from TBL_LEDGER_BRANCH where depth = 3 and EFF_DATE = inpar_date group by PARENT_CODE,REF_CUR_ID,ref_branch );
commit;

insert into TBL_LEDGER_BRANCH(LEDGER_CODE,PARENT_CODE,DEPTH,BALANCE,REF_CUR_ID,eff_date,ref_branch)
(select PARENT_CODE, 0, 1, sum(BALANCE), REF_CUR_ID ,inpar_date,ref_branch  from TBL_LEDGER_BRANCH where depth = 2 and EFF_DATE = inpar_date group by PARENT_CODE,REF_CUR_ID,ref_branch );
commit;
UPDATE TBL_LEDGER_BRANCH t
SET t.NAME =
  (SELECT MAX(GL_NAME)
  FROM DADEKAVAN_DAY.gf1glet
  WHERE  GL_CODE   = t.ledger_code
  )
WHERE t.eff_date = inpar_date
and t.depth<> 5;
commit;

END ;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_SETTING
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_REPORT_SETTING" (
INPAR_REP_ID IN NUMBER
,  INPAR_SHOW_SAYER IN VARCHAR2 
, INPAR_SHOW_MANDE IN VARCHAR2 
, INPAR_LEVELS IN VARCHAR2
,OUTPAR_ONE OUT NUMBER
) AS 
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:
  */
  --------------------------------------------------------------------------------
var_rep_Id number;
BEGIN

select count(*) into var_rep_id from Tbl_Report_Setting where Rep_Id = inpar_rep_id;

if (Var_Rep_Id != 0) then

UPDATE TBL_REPORT_SETTING
SET Show_Sayer=Inpar_Show_Sayer,Show_Mande=Inpar_Show_Mande , Levels = Inpar_Levels where Rep_Id = Inpar_Rep_Id;
Commit;

  else
  INSERT
INTO TBL_REPORT_SETTING
  (
   
    SHOW_SAYER,
    SHOW_MANDE,
    LEVELS,
    REP_ID
  )
  VALUES
  (
    INPAR_SHOW_SAYER,
    INPAR_SHOW_MANDE,
    INPAR_LEVELS,
    INPAR_REP_ID
  );
  commit;
  end if;
  Outpar_One := 1;
END PRC_REPORT_SETTING;
--------------------------------------------------------
--  DDL for Procedure PRC_DASHBOARD_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DASHBOARD_PROFILE" 
(
  inpar_ledger_profile in varchar2 
, inpar_timing_profile in varchar2 ,
inpar_type in varchar,
 outpar_id out varchar2 
) as 
--------------------------------------------------------------------------------
  /*
  Programmer Name: NAVID
  Release Date/Time:1396/05/17-16:00
  Version: 1.0
  Category:2
  Description: in procedure baraE entekhabe profile haE mibashad ke in profileha
               gharar ast baraE namayesh gozareshate dashbord estefade shavad va
               masiri ke az in procedure estefade mikonad ebarat ast az : 
               (Tanzimat -> Modiriyate gozareshat -> TanzimateDashboard).khoroji
               dar jadvali be name TBL_dashboard_profile zakhire mishavad ke in 
               jadval tanha yek satr darad.
  */
--------------------------------------------------------------------------------
var_ledger number;
var_timing number;
begin

UPDATE TBL_DASHBOARD_PROFILE
SET REF_LEDGER_PROFILE = inpar_ledger_profile,
REF_TIMING_PROFILE = inpar_timing_profile,
 typee = inpar_type;
commit; 
-----------------------------------------
outpar_id := 1;
end prc_dashboard_profile;
--------------------------------------------------------
--  DDL for Procedure PRC_J_PRE_AGGREGATION
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_J_PRE_AGGREGATION" AS 
--------------------------------------------------------------------------------
  /*
  Programmer Name: rasool_jahani
  Editor Name: 
  Release Date/Time:1396/02/24-10:00
  Edit Name: 1396/02/10-10:00
  Version: 1.1
  Category:2
  Description: enteghal har code sarfasl dar har baze zamani be jadval aggrigation
               enteghal profile zamani be jadval repper
               tajmie daftar kol baraye har baze zamani dar repval
 */
--------------------------------------------------------------------------------

BEGIN
  EXECUTE IMMEDIATE 'truncate table TBL_J_VALUE';

---/////////////////////////////////
---/////Insert  Sood Seporde  /////
--////////////////////////////////
INSERT
INTO TBL_J_VALUE
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
    REF_CUS_ID
   )
SELECT 21,
  PAY.REF_DEP_ID,
  sum(PROFIT_AMOUNT),
  --PROFIT_AMOUNT,
  DEP.REF_BRANCH,
  trunc(PAY.DUE_DATE),
  DEP.REF_DEPOSIT_TYPE,
  AC.LEDGER_CODE_PROFIT,
  DEP.REF_CURRENCY,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID,
  DEP.REF_CUSTOMER
FROM AKIN.TBL_DEPOSIT_INTEREST_PAYMENT PAY
JOIN AKIN.TBL_DEPOSIT DEP
ON PAY.REF_DEP_ID = DEP.DEP_ID
JOIN AKIN.TBL_DEPOSIT_ACCOUNTING AC
ON DEP.REF_DEPOSIT_ACCOUNTING = AC.DEP_ACC_ID 
JOIN TBL_BRANCH BRN
ON BRN.BRN_ID = DEP.REF_BRANCH
GROUP BY trunc(PAY.DUE_DATE) ,
  AC.LEDGER_CODE_PROFIT,
  DEP.REF_BRANCH,
  DEP.REF_CURRENCY,
  DEP.REF_CUSTOMER,
  DEP.REF_DEPOSIT_TYPE,
  PAY.REF_DEP_ID,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID;
---/////////////////////////////////
---////Insert  Sood Tashilat  /////
--////////////////////////////////
commit;
INSERT
INTO TBL_J_VALUE
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
    REF_CUS_ID
   )
SELECT 11,
  PAY.REF_LON_ID,
  sum(PROFIT_AMOUNT),
  --PROFIT_AMOUNT,
  LON.REF_BRANCH,
  trunc(PAY.DUE_DATE),
  LON.REF_LOAN_TYPE,
  AC.LEDGER_CODE_PROFIT,
  LON.REF_CURRENCY,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID,
  LON.REF_CUSTOMER
FROM AKIN.TBL_LOAN_PAYMENT PAY
JOIN AKIN.TBL_LOAN LON
ON PAY.REF_LON_ID = LON.LON_ID
JOIN AKIN.TBL_LOAN_ACCOUNTING AC
ON LON.REF_LOAN_ACCOUNTING = AC.LON_ACC_ID 
JOIN TBL_BRANCH BRN
ON BRN.BRN_ID = LON.REF_BRANCH
GROUP BY trunc(PAY.DUE_DATE) ,
  AC.LEDGER_CODE_PROFIT,
  LON.REF_BRANCH,
  LON.REF_CURRENCY,
  LON.REF_CUSTOMER,
  LON.REF_LOAN_TYPE,
  PAY.REF_LON_ID,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID;
---/////////////////////////////////
---////Insert  Asl Aghsat  ////////
--////////////////////////////////
commit;

INSERT
INTO TBL_J_VALUE
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
    REF_CUS_ID
   )
SELECT 1,
  PAY.REF_LON_ID,
  sum(PAY.AMOUNT),
  LON.REF_BRANCH,
  trunc(PAY.DUE_DATE),
  LON.REF_LOAN_TYPE,
  AC.LEDGER_CODE_SELF,
  LON.REF_CURRENCY,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID,
  LON.REF_CUSTOMER
FROM AKIN.TBL_LOAN_PAYMENT PAY
JOIN AKIN.TBL_LOAN LON
ON PAY.REF_LON_ID = LON.LON_ID
JOIN AKIN.TBL_LOAN_ACCOUNTING AC
ON LON.REF_LOAN_ACCOUNTING = AC.LON_ACC_ID 
JOIN TBL_BRANCH BRN
ON BRN.BRN_ID = LON.REF_BRANCH
GROUP BY trunc(PAY.DUE_DATE) ,
  AC.LEDGER_CODE_SELF,
  LON.REF_BRANCH,
  LON.REF_CURRENCY,
  LON.REF_CUSTOMER,
  LON.REF_LOAN_TYPE,
  PAY.REF_LON_ID,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID;
---/////////////////////////////////
---//////Insert Asl Seporde  //////
--////////////////////////////////
commit;

INSERT
INTO TBL_J_VALUE
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
    REF_CUS_ID
   )
SELECT 2,
DEP.DEP_ID,
SUM(DEP.BALANCE),
DEP.REF_BRANCH,
CASE
    WHEN  trunc(DEP.DUE_DATE) IS NULL
    THEN sysdate +1
    ELSE  trunc(DEP.DUE_DATE)
  END AS DUE_DATE ,
DEP.REF_DEPOSIT_TYPE,
AC.LEDGER_CODE_SELF,
DEP.REF_CURRENCY,
BRN.REF_STA_ID,
BRN.REF_CTY_ID,
DEP.REF_CUSTOMER
FROM AKIN.TBL_DEPOSIT DEP
JOIN AKIN.TBL_DEPOSIT_ACCOUNTING AC
ON DEP.REF_DEPOSIT_ACCOUNTING = AC.DEP_ACC_ID
JOIN TBL_BRANCH BRN
ON DEP.REF_BRANCH = BRN.BRN_ID
WHERE 
  CASE
    WHEN  trunc(DEP.DUE_DATE) IS NULL
    THEN sysdate +1
    ELSE  trunc(DEP.DUE_DATE)
  END > sysdate
  GROUP BY trunc(DEP.DUE_DATE) ,
  DEP.DEP_ID,
  AC.LEDGER_CODE_SELF,
  DEP.REF_BRANCH,
  DEP.REF_CURRENCY,
  DEP.REF_CUSTOMER,
  DEP.REF_DEPOSIT_TYPE,
  BRN.REF_STA_ID,
  BRN.REF_CTY_ID;

END PRC_J_PRE_AGGREGATION;
--------------------------------------------------------
--  DDL for Procedure PRC_J_REPORT_VALUE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_J_REPORT_VALUE" ( INPAR_ID_REPORT IN NUMBER ) AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Morteza.Sahhi
  Editor Name:
  Release Date/Time:1396/02/24-10:00
  Edit Name: 1396/02/24-18:00
  Version: 1.1
  Category:2
  Description:in procedure baraye enteghal dadehaye morde niaz az value be TBL_VALUE_TEMP bar asas profilehaye mokhtalefist ke karbar taeen karde
              albate lazem be zekr ast ke dar inja faghat baraye gozareshat tarikhi in kar anjam mishavad.
  */
  /*------------------------------------------------------------------------------*/

 VAR_QUERY    VARCHAR2(4000);
 ID_LOAN      NUMBER;
 ID_DEP       NUMBER;
 ID_CUR       NUMBER;
 ID_CUS       NUMBER;
 ID_BRANCH    NUMBER;
 ID_TIMING    NUMBER;
 DATE_TYPE1   DATE := SYSDATE;
BEGIN
 SYS.DBMS_OUTPUT.ENABLE(3000000);
 EXECUTE IMMEDIATE 'truncate table TBL_VALUE_TEMP';
  /******profilhaye mokhtalefi ke karbar baraye in gozaresh entekhab karde ra daron moteghayer ham nam profil mirizim ******/
 SELECT
  REF_PROFILE_CURRENCY
 INTO
  ID_CUR
 FROM TBL_REPORT_PROFILE
 WHERE REF_REPORT   = INPAR_ID_REPORT;

 SELECT
  REF_PROFILE_CUSTOMER
 INTO
  ID_CUS
 FROM TBL_REPORT_PROFILE
 WHERE REF_REPORT   = INPAR_ID_REPORT;

 SELECT
  REF_PROFILE_BRANCH
 INTO
  ID_BRANCH
 FROM TBL_REPORT_PROFILE
 WHERE REF_REPORT   = INPAR_ID_REPORT;

 SELECT
  REF_PROFILE_DEPOSIT
 INTO
  ID_DEP
 FROM TBL_REPORT_PROFILE
 WHERE REF_REPORT   = INPAR_ID_REPORT;

 SELECT
  REF_PROFILE_TIME
 INTO
  ID_TIMING
 FROM TBL_REPORT_PROFILE
 WHERE REF_REPORT   = INPAR_ID_REPORT;

 SELECT
  REF_PROFILE_LOAN
 INTO
  ID_LOAN
 FROM TBL_REPORT_PROFILE
 WHERE REF_REPORT   = INPAR_ID_REPORT;
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
  THEN     /******agar profile zamani entekhab shode bazehee bashad *****--*/
   SELECT
    '  
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
FROM TBL_J_VALUE WHERE REF_ID IN (  
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
    ''') and DUE_DATE <= to_date(''' ||
    DATE_TYPE1 ||
    ''')+' ||
    I.PERIOD_DATE ||
    '  ;'
   INTO
    VAR_QUERY
   FROM DUAL;

   EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
   COMMIT;
   SELECT
    '  
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
FROM TBL_J_VALUE WHERE REF_ID IN (  
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
    DATE_TYPE1 ||
    ''') and DUE_DATE <= to_date(''' ||
    DATE_TYPE1 ||
    ''')+' ||
    I.PERIOD_DATE ||
    '  ;'
   INTO
    VAR_QUERY
   FROM DUAL;

   DATE_TYPE1   := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
   DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
   EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
   COMMIT;
  ELSE     /******agar profile zamani entekhab shode tarikhi bashad *****--*/
   SELECT
    '  
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
FROM TBL_J_VALUE WHERE REF_ID IN (  
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
    ''') and DUE_DATE <= to_date(''' ||
    I.PERIOD_END ||
    ''') ;'
   INTO
    VAR_QUERY
   FROM DUAL;

   EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
   COMMIT;
   SELECT
    '  
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
FROM TBL_J_VALUE WHERE REF_ID IN (  
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
    ''') and DUE_DATE <= to_date(''' ||
    I.PERIOD_END ||
    ''') ;'
   INTO
    VAR_QUERY
   FROM DUAL;

   DATE_TYPE1   := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
   EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
   COMMIT;
  END IF;
 END LOOP;

END PRC_J_REPORT_VALUE;
--------------------------------------------------------
--  DDL for Procedure PRC_J_ARCH_REPORT_REQUEST
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_J_ARCH_REPORT_REQUEST" (
    INPAR_REPORT_ID IN NUMBER ,
    INPAR_USER_ID   IN VARCHAR2 ,
    INPAR_NOTIF_ID  IN NUMBER ,
    INPAR_REQ_DATE IN VARCHAR2 ,
    OUTPAR_RES OUT NUMBER )
AS
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:servic darkhast ijad gozaresh tarikhi(az dade hay archive)
  */
  --------------------------------------------------------------------------------
 var_Rep_Req_ID  NUMBER;
  var_notif_id    VARCHAR2(50);
  var_repper_date DATE;
BEGIN

DELETE FROM TBL_RATE WHERE TYPE = 'TBL_DEPOSIT';
  DELETE FROM TBL_RATE WHERE TYPE = 'TBL_LOAN';
commit;
AKIN.Prc_J_Transfer_Accounting(to_date(Inpar_Req_Date,'yyyy-mm-dd'));
AKIN.Prc_J_Transfer_Deposit(to_date(Inpar_Req_Date,'yyyy-mm-dd'));
AKIN.Prc_J_Transfer_Deposit_Profit(to_date(Inpar_Req_Date,'yyyy-mm-dd'));
AKIN.Prc_J_Transfer_Loan(to_date(Inpar_Req_Date,'yyyy-mm-dd'));
AKIN.Prc_J_Transfer_Payment(to_date(Inpar_Req_Date,'yyyy-mm-dd'));
PRC_J_PRE_AGGREGATION();
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
  ----------------------------------------TBL_RATE   TBL_DEPOSIT
  INSERT
  INTO PRAGG.TBL_RATE
    (
      RATE,
      TYPE
    )
  SELECT DISTINCT RATE AS NERKH_SUD,
    'TBL_DEPOSIT'
  FROM AKIN.TBL_DEPOSIT
  WHERE RATE IS NOT NULL;
  COMMIT;
  ----------------------------------------UPDATE TBL_DEPOSIT RATE
  UPDATE AKIN.TBL_DEPOSIT a
  SET a.REF_RATE =
    (SELECT r.ref_rate
    FROM tbl_rate r
    WHERE r.rate = a.rate
    AND r.type   ='TBL_DEPOSIT'
    );
  COMMIT;

--------------------------------------------------

-- darj yek darkhast gozaresh jadid dar jadval TBL_REP_REQ

  INSERT
  INTO TBL_REPREQ
    (
      REF_REPORT_ID,
      REF_USER_ID,
      REQ_DATE,
      STATUS,
      REF_LEDGER_PROFILE,
      REF_PROFILE_TIME,
      REF_PROFILE_CURRENCY,
      REF_PROFILE_CUSTOMER,
      REF_PROFILE_BRANCH,
      REF_PROFILE_DEPOSIT,
      REF_PROFILE_LOAN,
      REF_HID_REPORT,
      TYPE,
      CATEGORY,
      DATA_DATE
    )
    VALUES
    (
      INPAR_REPORT_ID,
      INPAR_USER_ID,
      sysdate,
      0,
      (SELECT REF_LEDGER_PROFILE
      FROM TBL_REPORT_PROFILE
      WHERE REF_REPORT = INPAR_REPORT_ID
      ),
      (SELECT REF_PROFILE_TIME
      FROM TBL_REPORT_PROFILE
      WHERE REF_REPORT = INPAR_REPORT_ID
      ),
      (SELECT REF_PROFILE_CURRENCY
      FROM TBL_REPORT_PROFILE
      WHERE REF_REPORT = INPAR_REPORT_ID
      ),
      (SELECT REF_PROFILE_CUSTOMER
      FROM TBL_REPORT_PROFILE
      WHERE REF_REPORT = INPAR_REPORT_ID
      ),
      (SELECT REF_PROFILE_BRANCH
      FROM TBL_REPORT_PROFILE
      WHERE REF_REPORT = INPAR_REPORT_ID
      ),
      (SELECT REF_PROFILE_DEPOSIT
      FROM TBL_REPORT_PROFILE
      WHERE REF_REPORT = INPAR_REPORT_ID
      ),
      (SELECT REF_PROFILE_LOAN
      FROM TBL_REPORT_PROFILE
      WHERE REF_REPORT = INPAR_REPORT_ID
      ),
      (SELECT H_ID FROM TBL_REPORT WHERE id = INPAR_REPORT_ID
      ) ,
      (SELECT TYPE FROM TBL_REPORT WHERE id = INPAR_REPORT_ID
      ) ,
      (SELECT CATEGORY FROM TBL_REPORT WHERE id = INPAR_REPORT_ID
      )
      ,to_date(Inpar_Req_Date,'yyyy-mm-dd')
    );
  COMMIT;
  
  
    --yaftan id darkhast ijad shode
  SELECT MAX(id) INTO var_Rep_Req_ID FROM TBL_REPREQ ;
  --PRC_NOTIFICATION( 'insert', 0,'report', INPAR_NOTIF_TITLE, 'progress', INPAR_USER_ID,'Create Report Request'||INPAR_NOTIF_TITLE,var_Rep_Req_ID,aa );
  
  
    --ejra prasijer baray filter kardan dadeh hay gozersh
  PRC_J_REPORT_VALUE(INPAR_REPORT_ID);
  
    --ejra tajmi
  PRC_AGGREGATION(var_Rep_Req_ID);

  
   --berozresani vaziat gozaresh be payan yafte dar jadval darkhastha 
  UPDATE TBL_REPREQ
SET STATUS                    =1
WHERE ID                 = var_Rep_Req_ID;
commit;
  
  
  
    --berozresani elanat
  PRC_NOTIFICATION( 'update', INPAR_NOTIF_ID,'', '' ,'', 'finished', 0,'',0,var_Rep_Req_ID,'',0,var_notif_id );
  
  
    --khoroji alaki
  OUTPAR_RES := var_notif_id; 
  
 
  
END PRC_J_ARCH_REPORT_REQUEST;
--------------------------------------------------------
--  DDL for Procedure PRC_ARCH_ADD_REQ_DATE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_ARCH_ADD_REQ_DATE" 
(
  INPAR_REQ_DATE IN VARCHAR2 
, INPAR_DESCRIPTION IN VARCHAR2 
, OUTPAR_OUT OUT number 
) AS 

 --------------------------------------------------------------------------------
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/20-10:00
  Edit Name:
  Version: 1
  Description:ezafe kardan yek tarikh baray arshiv kardan dade dar an rooz.
  */
  --------------------------------------------------------------------------------
  
BEGIN
--darj tarikh jadid dar list tarikhhay lazem
INSERT
INTO TBL_ARCHIVE_DATES@pragg_to_archive 
  (
    ARCHIVE_DATE,
    DESCRIPTION
    )
  VALUES
  (
   to_date (INPAR_REQ_DATE,'yyyy/mm/dd','nls_calendar=persian') ,
    INPAR_DESCRIPTION
  );
Commit;
  Outpar_Out := 1;
END PRC_ARCH_ADD_REQ_DATE;
--------------------------------------------------------
--  DDL for Procedure PRC_ARCH_REMOVE_DATA
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_ARCH_REMOVE_DATA" (
    INPAR_REMOVE_DATE IN VARCHAR2 ,
    OUTPAR_OUT OUT NUMBER  )

     --------------------------------------------------------------------------------
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/20-10:00
  Edit Name:
  Version: 1
  Description:hazf yek tarikh az list tarikhhay darkhasti baray arshiv dade
  */
  --------------------------------------------------------------------------------
AS
  var_exc NUMBER;
  var_remove_date date;
BEGIN
  --tabdil tarikh vorodi be shamsi
  Var_Remove_Date := to_date(INPAR_REMOVE_DATE,'yyyy/mm/dd','nls_calendar=persian');
  
  --barresi inke aya dadeh baray tarikh vorodi arshiv shode ya na
  SELECT EXISTENT
  INTO var_exc
  FROM tbl_ARCHIVE_DATES@pragg_to_archive
  WHERE ARCHIVE_DATE = Var_Remove_Date;
  
  
  
  
  IF (Var_Exc        = 0) THEN
  --agar dade baray in rooz vojod nadasht
    DELETE FROM TBL_ARCHIVE_DATES@pragg_to_archive  WHERE ARCHIVE_DATE = Var_Remove_Date;
  ELSE
  --agar dade vojod dasht
  DELETE FROM TBL_ARCHIVE_DATES@pragg_to_archive  WHERE ARCHIVE_DATE = Var_Remove_Date;
  
  
  --hazf dade hay arshiv shode
  DELETE FROM ARZ_RELATION@pragg_to_archive  WHERE EFFDATE = Var_Remove_Date;
  
  DELETE FROM DAY_GL@pragg_to_archive WHERE EFFDATE   = Var_Remove_Date;
  
  DELETE FROM DEPOSIT@pragg_to_archive WHERE EFFDATE=Var_Remove_Date ;
  
  DELETE FROM ETELAATE_MOSHTARI@pragg_to_archive WHERE EFFDATE =Var_Remove_Date ;
  
  DELETE FROM ETELAATE_SHOBE@pragg_to_archive WHERE EFFDATE = Var_Remove_Date;
  
  DELETE FROM LOAN@pragg_to_archive WHERE  EFFDATE =Var_Remove_Date ;
  
  DELETE FROM NOE_SEPORDE@pragg_to_archive WHERE EFFDATE = Var_Remove_Date;
  
  DELETE FROM NOE_TASHILAT@pragg_to_archive WHERE  EFFDATE     = Var_Remove_Date;
  
  DELETE FROM PAYMENT@pragg_to_archive WHERE EFFDATE  =Var_Remove_Date;
  
  DELETE FROM SEPORDE_DAFTAR_KOL@pragg_to_archive WHERE EFFDATE =Var_Remove_Date ;
  
  DELETE FROM SEPORDE_MOSHTARI@pragg_to_archive WHERE EFFDATE = Var_Remove_Date;
  
  DELETE FROM SEPORDE_SOOD@pragg_to_archive WHERE EFFDATE = Var_Remove_Date;
  
  DELETE FROM SEPORDE_SOOD_PELEKANI@pragg_to_archive WHERE EFFDATE = Var_Remove_Date;
  
  DELETE FROM SEPORDE_SOOD_TAVAFOGHI@pragg_to_archive WHERE EFFDATE    = Var_Remove_Date;
  
  DELETE FROM TASHILAT_DAFTAR_KOL@pragg_to_archive WHERE EFFDATE = Var_Remove_Date;
 
  
  END IF;
  
  
 OUTPAR_OUT := 1;
END PRC_ARCH_REMOVE_DATA;
--------------------------------------------------------
--  DDL for Procedure PRC_DASHBOARD_GAP
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DASHBOARD_GAP" AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Morteza.Sahhi
  Editor Name:
  Release Date/Time:1396/05/24-10:00
  Edit Name:  
  Version: 1.1
  Category:2
  Description: be dast avardane maghadir shekaf baraye nemodarhaye shekafe riali va shekafe riali be tafkik ostan
  */
  /*------------------------------------------------------------------------------*/

 VAR_QUERY    VARCHAR2(4000);
 ID_LOAN      NUMBER;
 ID_DEP       NUMBER;
 ID_CUR       NUMBER;
 ID_CUS       NUMBER;
 ID_BRANCH    NUMBER;
 ID_TIMING    NUMBER;
 DATE_TYPE1   DATE := SYSDATE;
BEGIN
  execute immediate 'alter session set nls_date_format=''DD-MM-RRRR''';

 SYS.DBMS_OUTPUT.ENABLE(3000000);
    /****** baraye inke in gozaresh ro besazim niaz be daftar kol va profile zamani darim ke karbar az pish entekhab karde
    ba estefade az profilhaye ke karbar entekhab kare az value group by gerefte va dar TBL_VALUE_TEMP mirizim
    va gozaresh haye ro ke mad nazaremone az in jadval estekhraj mikonim
    *****--*/
 EXECUTE IMMEDIATE 'truncate table TBL_VALUE_TEMP';
 SELECT
  NULL
 INTO
  ID_CUR
 FROM DUAL;

 SELECT
  NULL
 INTO
  ID_CUS
 FROM DUAL;

 SELECT
  NULL
 INTO
  ID_BRANCH
 FROM DUAL;

 SELECT
  NULL
 INTO
  ID_DEP
 FROM DUAL;

 SELECT
  REF_TIMING_PROFILE
 INTO
  ID_TIMING
 FROM TBL_DASHBOARD_PROFILE;

 SELECT
  NULL
 INTO
  ID_LOAN
 FROM DUAL;

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
   SELECT
    '  
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
    ''') and DUE_DATE <= to_date(''' ||
    DATE_TYPE1 ||
    ''')+' ||
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
    ''') and DUE_DATE <= to_date(''' ||
    DATE_TYPE1 ||
    ''')+' ||
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
   SELECT
    '  
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
    ''') and DUE_DATE <= to_date(''' ||
    I.PERIOD_END ||
    ''') ;'
   INTO
    VAR_QUERY
   FROM DUAL;

   EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
   COMMIT;
   SELECT
    '  
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
    ''') and DUE_DATE <= to_date(''' ||
    I.PERIOD_END ||
    ''') ;'
   INTO
    VAR_QUERY
   FROM DUAL;

   EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
   COMMIT;
  END IF;
 END LOOP;

 COMMIT;
 EXECUTE IMMEDIATE 'truncate table TBL_DASHBOARD_GAP_RIALI';
 INSERT INTO TBL_DASHBOARD_GAP_RIALI (
  NAME
 ,PERIODID
 ,VALUE_IN
 ,VALUE_OUT
 ) SELECT
  (
   SELECT
    PERIOD_NAME
   FROM TBL_TIMING_PROFILE_DETAIL
   WHERE ID   = A.REF_TIMING_ID
  ) AS NAME
 ,A.REF_TIMING_ID
 ,A."in"
 ,B."out"
 FROM (
   SELECT DISTINCT
    REF_TIMING_ID
   ,SUM(BALANCE) AS "in"
   FROM TBL_VALUE_TEMP
   WHERE REF_MODALITY_TYPE IN (
     1,11
    )
   GROUP BY
    REF_TIMING_ID
  ) A
 ,    (
   SELECT DISTINCT
    REF_TIMING_ID
   ,SUM(BALANCE) AS "out"
   FROM TBL_VALUE_TEMP
   WHERE REF_MODALITY_TYPE IN (
     2,21
    )
   GROUP BY
    REF_TIMING_ID
  ) B
 WHERE A.REF_TIMING_ID   = B.REF_TIMING_ID
 ORDER BY A.REF_TIMING_ID;

 COMMIT;
 EXECUTE IMMEDIATE 'truncate table TBL_DASHBOARD_GAP_STATE';
 INSERT INTO TBL_DASHBOARD_GAP_STATE (
  STATE_CODE
 ,STATE_NAME
 ,VALUE_IN
 ,PERIOD_NAME
 ,PERIOD_ID
 ) SELECT
  REF_STA_ID
 ,(
   SELECT
    STA_NAME
   FROM TBL_STATE
   WHERE STA_ID   = REF_STA_ID
  ) AS NAME
 ,SUM(BALANCE) AS VALUE
 ,MAX(TIMING_NAME)
 ,REF_TIMING_ID
 FROM TBL_VALUE_TEMP
 WHERE REF_MODALITY_TYPE IN (
   1,11
  )
 GROUP BY
  REF_STA_ID
 ,REF_TIMING_ID;

 COMMIT;
 INSERT INTO TBL_DASHBOARD_GAP_STATE (
  STATE_CODE
 ,STATE_NAME
 ,VALUE_OUT
 ,PERIOD_NAME
 ,PERIOD_ID
 ) SELECT
  REF_STA_ID
 ,(
   SELECT
    STA_NAME
   FROM TBL_STATE
   WHERE STA_ID   = REF_STA_ID
  ) AS NAME
 ,SUM(BALANCE) AS VALUE
 ,MAX(TIMING_NAME)
 ,REF_TIMING_ID
 FROM TBL_VALUE_TEMP
 WHERE REF_MODALITY_TYPE IN (
   2,21
  )
 GROUP BY
  REF_STA_ID
 ,REF_TIMING_ID;

 COMMIT;
 INSERT INTO TBL_DASHBOARD_GAP_STATE (
  STATE_CODE
 ,STATE_NAME
 ,VALUE_IN
 ,PERIOD_NAME
 ,PERIOD_ID
 ) SELECT
  *
 FROM (
   SELECT
    TBL_STATE.STA_ID
   ,TBL_STATE.STA_NAME
   ,0
   ,A.PERIOD_NAME
   ,A.ID
   FROM TBL_STATE
   ,    (
     SELECT
      ID
     ,REF_TIMING_PROFILE
     ,PERIOD_NAME
     FROM TBL_TIMING_PROFILE_DETAIL
     WHERE REF_TIMING_PROFILE   = (
       SELECT
        REF_TIMING_PROFILE
       FROM TBL_DASHBOARD_PROFILE
      )
    ) A
  ) B
 WHERE B.STA_ID || B.ID NOT IN (
   SELECT
    STATE_CODE || PERIOD_ID
   FROM TBL_DASHBOARD_GAP_STATE
   WHERE VALUE_OUT IS NULL
  );

 COMMIT;
 INSERT INTO TBL_DASHBOARD_GAP_STATE (
  STATE_CODE
 ,STATE_NAME
 ,VALUE_OUT
 ,PERIOD_NAME
 ,PERIOD_ID
 ) SELECT
  *
 FROM (
   SELECT
    TBL_STATE.STA_ID
   ,TBL_STATE.STA_NAME
   ,0
   ,A.PERIOD_NAME
   ,A.ID
   FROM TBL_STATE
   ,    (
     SELECT
      ID
     ,REF_TIMING_PROFILE
     ,PERIOD_NAME
     FROM TBL_TIMING_PROFILE_DETAIL
     WHERE REF_TIMING_PROFILE   = (
       SELECT
        REF_TIMING_PROFILE
       FROM TBL_DASHBOARD_PROFILE
      )
    ) A
  ) B
 WHERE B.STA_ID || B.ID NOT IN (
   SELECT
    STATE_CODE || PERIOD_ID
   FROM TBL_DASHBOARD_GAP_STATE
   WHERE VALUE_IN IS NULL
  );

END PRC_DASHBOARD_GAP;
--------------------------------------------------------
--  DDL for Procedure PRC_UPDATE_DASHBOARD_ID
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_UPDATE_DASHBOARD_ID" as 

ledger number;
timing number;




begin
  --------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh
  Editor Name: 
  Release Date/Time:1396/05/24-10:00
  Edit Name: 
  Version: 1.1
  Category:2
  Description: zamani ke profile ha version jadid bokhorand, dar safeh va javdal
               tanzimate version jadide profile be soorate automatic update mishavad.
  */
  --------------------------------------------------------------------------------

    
    select max(id) into ledger from tbl_ledger_profile
    where h_id in(
    select h_id from tbl_ledger_profile 
    where id in (select ref_ledger_profile from tbl_dashboard_profile ));
   
      update tbl_dashboard_profile 
      set ref_ledger_profile = ledger;
      commit; 
 
 
    
   
    select max(id) into timing from tbl_timing_profile
    where h_id in(
    select h_id from tbl_timing_profile 
    where id in (select ref_timing_profile from tbl_dashboard_profile ));
      
    
      update tbl_dashboard_profile 
      set ref_timing_profile = timing;
      commit; 
      
 

end prc_update_dashboard_id;
--------------------------------------------------------
--  DDL for Procedure PRC_ADD_USERS
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_ADD_USERS" 
(
  INPAR_NAME IN VARCHAR2 
, INPAR_USERNAME IN VARCHAR2 
, OUTPAR OUT VARCHAR2 
) AS 
BEGIN
  
  insert into tbl_users (name,USERNAME) values (INPAR_NAME,INPAR_USERNAME);
  commit; 
  select max(id) into outpar from  tbl_users ;
  
  
END PRC_add_USERS;
--------------------------------------------------------
--  DDL for Procedure PRC_DELETE_USERS
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DELETE_USERS" 
(
  INPAR_USERNAME IN VARCHAR2 
, OUTPAR OUT VARCHAR2 
) AS 
BEGIN
  delete from tbl_users where USERNAME=INPAR_USERNAME;
  OUTPAR:=null;
END PRC_DELETE_USERS;
--------------------------------------------------------
--  DDL for Procedure PRC_DASHBOARD_DAILY_REPORT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DASHBOARD_DAILY_REPORT" 
 AS 
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name:  morteza.sahi
  Editor Name:
  Release Date/Time:1396/05/26-10:00
  Edit Name:
  Version: 1
  Description:  sakht gozaresh dashbord (gozareshe rozane);
  */
  /*------------------------------------------------------------------------------*/
BEGIN
 EXECUTE IMMEDIATE 'truncate table TBL_DASHBOaRD_DAILY_REPORT';
  /****** az jadval value maghadir marbot be  vorodi ha bar asa  roz jame shode va az jame maghadir khorouji kam mishavad(tafrigh da jadval va ba virtual anjam mishavad)*****--*/
 INSERT INTO TBL_DASHBOARD_DAILY_REPORT ( DUE_DATE,IN_FLOW,OUT_FLOW ) SELECT
  A.DUE_DATE
 ,A."in"
 ,B."out"
 FROM (
   SELECT DISTINCT
    DUE_DATE
   ,SUM(BALANCE) AS "in"
   FROM TBL_VALUE
   WHERE DUE_DATE < SYSDATE + 365
    AND
     DUE_DATE >= SYSDATE
    AND
     REF_MODALITY_TYPE IN (
      1,11
     )
   GROUP BY
    DUE_DATE
  ) A
 ,    (
   SELECT DISTINCT
    DUE_DATE
   ,SUM(BALANCE) AS "out"
   FROM TBL_VALUE
   WHERE DUE_DATE < SYSDATE + 365
    AND
     DUE_DATE >= SYSDATE
    AND
     REF_MODALITY_TYPE IN (
      2,21
     )
   GROUP BY
    DUE_DATE
  ) B
 WHERE A.DUE_DATE   = B.DUE_DATE
 ORDER BY A.DUE_DATE;

END PRC_DASHBOARD_DAILY_REPORT;
--------------------------------------------------------
--  DDL for Procedure PRC_DASHBOARD_STATE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DASHBOARD_STATE" 
 AS
  /*
  Programmer Name: navid & morteza
  Release Date/Time:1396/08/25
  Version: 1.0
  Category:
  Description:
  */
BEGIN
 EXECUTE IMMEDIATE 'truncate table TBL_DASHBOARD_STATE';
 INSERT INTO TBL_DASHBOARD_STATE ( STATE_ID,NODE_ID,BALANCE ) SELECT
  N.REF_STA_ID
 ,N.LEDGER_CODE
 ,ABS(SUM(NVL(N.BALANCE,0) ) )
 FROM (
   SELECT
    L.LEDGER_CODE
   ,L.BALANCE
   ,TB.REF_STA_ID
   FROM TBL_BRANCH TB
   ,    (
     SELECT
      LEDGER_CODE
     ,SUM(BALANCE) AS BALANCE
     ,REF_BRANCH
     FROM TBL_LEDGER_BRANCH
     WHERE DEPTH   = 1
      AND
       TRUNC(EFF_DATE) = (
        SELECT
         MAX(TRUNC(EFF_DATE) )
        FROM TBL_LEDGER_BRANCH
       )
     GROUP BY
      REF_BRANCH
     ,LEDGER_CODE
    ) L
   WHERE L.REF_BRANCH   = TB.BRN_ID
  ) N
 GROUP BY
  N.REF_STA_ID
 ,N.LEDGER_CODE;

 COMMIT;
 INSERT INTO TBL_DASHBOARD_STATE ( STATE_ID,NODE_ID,BALANCE ) SELECT
  B.STA_ID
 ,A.NODE_ID
 ,0
 FROM (
   SELECT
    NODE_ID
   FROM TBL_DASHBOARD_STATE
   GROUP BY
    NODE_ID
  ) A
 ,    TBL_STATE B
 WHERE A.NODE_ID || B.STA_ID NOT IN (
   SELECT
    NODE_ID || STATE_ID
   FROM TBL_DASHBOARD_STATE
  );

 COMMIT;
END PRC_DASHBOARD_STATE;
--------------------------------------------------------
--  DDL for Procedure PRC_PROFILE_UPDATE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_PROFILE_UPDATE" (
    INPAR_DES IN VARCHAR2, --new
    INPAR_REF_USER_UPDATE IN VARCHAR2, --new
    INPAR_UPDATE_DATE IN varchar2, --new
    INPAR_TYPE IN VARCHAR2 ,
    inpar_h_id IN VARCHAR2,
    outpar out VARCHAR2)
AS
  var_max_id      NUMBER;
  var_max_version NUMBER;
  var_SRC_COLUMN  VARCHAR2(2000);
  var_CONDITION   VARCHAR2(2000);
 /*
  Programmer Name: sobhan sadeghzade
  Editor Name:
  Release Date/Time:1396/05/30
  Edit Name:
  Version: 1
  Category:
  Description:
  az in prc baraye update tozihat,tarikhe be ruz resani va shakhsi ke taghyirat ra anjam dade ast estefade mishavad 
  */
BEGIN
  ------------------------ tbl_profile
--profile haye marbuz be jadvalhaye TBL_LOAN,TBL_DEPOSIT,TBL_BRANCH,TBL_CUSTOMER,TBL_CURRENCY dar jadval tbl_profile gharar darand va mghadire be ruz resani shode dar in jadvale tbl_profile be ruz resani mishavand.
--akharin satr marbut be profile update mishavad 
  IF (upper(INPAR_TYPE)='TBL_LOAN' OR upper(INPAR_TYPE)='TBL_DEPOSIT' OR upper(INPAR_TYPE)='TBL_BRANCH' OR upper(INPAR_TYPE)='TBL_CUSTOMER' OR upper(INPAR_TYPE)='TBL_CURRENCY') THEN
    SELECT MAX(id) INTO var_max_id FROM tbl_profile WHERE h_id=inpar_h_id;
    UPDATE tbl_profile
    SET DES          =INPAR_DES,
      UPDATE_DATE    =to_date(INPAR_UPDATE_DATE,'YYYY/MM/DD HH:MI:SS'),
      REF_USER_UPDATE=INPAR_REF_USER_UPDATE
    WHERE id         =var_max_id
    AND h_id         =inpar_h_id;
 
    --------------------------------tbl_timing_profile
 --profile haye zamani dar jadval tbl_timing_profile gharar darand va mghadire be ruz resani shode dar in jadval  be ruz resani mishavand.   
 --akharin satr marbut be profile update mishavad 
  elsif(INPAR_TYPE='1' OR INPAR_TYPE='2') THEN
    SELECT MAX(id) INTO var_max_id FROM tbl_timing_profile WHERE h_id=inpar_h_id;
    UPDATE tbl_timing_profile
    SET DES          =INPAR_DES,
      UPDATE_DATE    =to_date(INPAR_UPDATE_DATE,'YYYY/MM/DD HH:MI:SS'),
      REF_USER_UPDATE=INPAR_REF_USER_UPDATE
    WHERE id         =var_max_id
    AND h_id         =inpar_h_id;
 
    -------------------------tbl_ledger_profile
     --profile daftare kol dar jadval tbl_timing_profile gharar darand va mghadire be ruz resani shode dar in jadval  be ruz resani mishavand.   
 --akharin satr marbut be profile update mishavad 
  elsif(upper(INPAR_TYPE)='TBL_LEDGER') THEN
    SELECT MAX(id) INTO var_max_id FROM TBL_LEDGER_profile WHERE h_id=inpar_h_id;
    UPDATE tbl_ledger_profile
    SET DES =INPAR_DES

    WHERE id =var_max_id
    AND h_id =inpar_h_id ;

  END IF;
  COMMIT;
  outpar:='1';
END PRC_PROFILE_UPDATE;
--------------------------------------------------------
--  DDL for Procedure PRC_DELETE_UNUSED_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DELETE_UNUSED_PROFILE" 
 AS
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Morteza.Sahi
  Editor Name: 
  Release Date/Time:1396/05/08-16:00
  Edit Name: 
  Version: 1.1
  Category:2
  Description: hazf kardane profile hayee ke dar archive va gozareshat dige estefade nemishavand
  */
  /*------------------------------------------------------------------------------*/
BEGIN
  /****** hazf kardane profilhaye daftar kol az jadval detail*****--*/
 DELETE FROM TBL_LEDGER_PROFILE_DETAIL WHERE REF_LEDGER_PROFILE IN (
   SELECT
    ID
   FROM TBL_LEDGER_PROFILE
   WHERE ID NOT IN (
      (
       SELECT DISTINCT
        REF_LEDGER_PROFILE
       FROM TBL_REPREQ
      )
     )
    AND
     STATUS   = 0
    AND
     H_ID <> ID
  );

 COMMIT;
    /****** hazf kardane profilhaye daftar kol az jadval profil*****--*/
 DELETE FROM TBL_LEDGER_PROFILE WHERE ID NOT IN (
    (
     SELECT DISTINCT
      REF_LEDGER_PROFILE
     FROM TBL_REPREQ
    )
   )
  AND
   STATUS   = 0
  AND
   H_ID <> ID;

 COMMIT;
 DELETE FROM TBL_TIMING_PROFILE_DETAIL WHERE REF_TIMING_PROFILE IN (
   SELECT
    ID
   FROM TBL_TIMING_PROFILE
   WHERE ID NOT IN (
      (
       SELECT DISTINCT
        TBL_REPREQ.REF_PROFILE_TIME
       FROM TBL_REPREQ
      )
     )
    AND
     STATUS   = 0
    AND
     H_ID <> ID
  );

 COMMIT;
  /****** hazf kardane profilhaye zamani az profile *****--*/
 DELETE FROM TBL_TIMING_PROFILE WHERE ID NOT IN (
    (
     SELECT DISTINCT
      TBL_REPREQ.REF_PROFILE_TIME
     FROM TBL_REPREQ
    )
   )
  AND
   STATUS   = 0
  AND
   H_ID <> ID;

 COMMIT;
    /****** hazf kardane profilhaye zamani az detail*****--*/
 DELETE FROM TBL_PROFILE_DETAIL WHERE REF_PROFILE IN (
   SELECT
    ID
   FROM TBL_PROFILE
   WHERE ID NOT IN (
      SELECT DISTINCT
       *
      FROM (
        SELECT DISTINCT
         NVL(REF_PROFILE_CURRENCY,0)
        FROM TBL_REPREQ
        UNION
        SELECT DISTINCT
         NVL(REF_PROFILE_BRANCH,0)
        FROM TBL_REPREQ
        UNION
        SELECT DISTINCT
         NVL(REF_PROFILE_CUSTOMER,0)
        FROM TBL_REPREQ
        UNION
        SELECT DISTINCT
         NVL(REF_PROFILE_DEPOSIT,0)
        FROM TBL_REPREQ
        UNION
        SELECT DISTINCT
         NVL(REF_PROFILE_LOAN,0)
        FROM TBL_REPREQ
       )
     )
    AND
     STATUS   = 0
    AND
     H_ID <> ID
  );

 COMMIT;
    /****** hazf kardane profilhaye digar az jadval profile*****--*/
 DELETE FROM TBL_PROFILE WHERE ID NOT IN (
    SELECT DISTINCT
     *
    FROM (
      SELECT DISTINCT
       NVL(REF_PROFILE_CURRENCY,0)
      FROM TBL_REPREQ
      UNION
      SELECT DISTINCT
       NVL(REF_PROFILE_BRANCH,0)
      FROM TBL_REPREQ
      UNION
      SELECT DISTINCT
       NVL(REF_PROFILE_CUSTOMER,0)
      FROM TBL_REPREQ
      UNION
      SELECT DISTINCT
       NVL(REF_PROFILE_DEPOSIT,0)
      FROM TBL_REPREQ
      UNION
      SELECT DISTINCT
       NVL(REF_PROFILE_LOAN,0)
      FROM TBL_REPREQ
     )
   )
  AND
   STATUS   = 0
  AND
   H_ID <> ID;

END PRC_DELETE_UNUSED_PROFILE;
--------------------------------------------------------
--  DDL for Procedure MAKING_DEPOSIT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."MAKING_DEPOSIT" 
 IS
BEGIN
 FOR I IN 1..1000 LOOP
  INSERT INTO AKIN.TBL_DEPOSIT (
   DEP_ID
  ,REF_DEPOSIT_TYPE
  ,REF_BRANCH
  ,REF_CUSTOMER
  ,DUE_DATE
  ,BALANCE
  ,OPENING_DATE
  ,RATE
  ,MODALITY_TYPE
,REF_DEPOSIT_ACCOUNTING
  ,REF_CURRENCY
  ) VALUES (
   I
  ,TRUNC(DBMS_RANDOM.VALUE(1,10) )
  ,TRUNC(DBMS_RANDOM.VALUE(1,310) )
  ,TRUNC(DBMS_RANDOM.VALUE(1,300) )
  ,SYSDATE + TRUNC(DBMS_RANDOM.VALUE(1,2000) )
  ,TRUNC(DBMS_RANDOM.VALUE(1000000,1000000000) )
  ,SYSDATE - TRUNC(DBMS_RANDOM.VALUE(10,400) )
  ,1
  ,1
  ,TRUNC(DBMS_RANDOM.VALUE(3,10) )
  ,4
  );

 END LOOP;
END;
--------------------------------------------------------
--  DDL for Procedure PRC_UPDATE_PERIOD_DURATION
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_UPDATE_PERIOD_DURATION" 
as
begin
update TBL_TIMING_PROFILE tt set tt.PERIOD_DURATION = (select a.PERIOD_DURATION from  (
SELECT REF_TIMING_PROFILE,sum(PERIOD_DATE)as PERIOD_DURATION FROM TBL_TIMING_PROFILE_DETAIL where REF_TIMING_PROFILE in (select id from TBL_TIMING_PROFILE where type = 1)
group by TBL_TIMING_PROFILE_DETAIL.REF_TIMING_PROFILE)a where A.REF_TIMING_PROFILE = tt.id)
where tt.type = 1 ;
commit;
update TBL_TIMING_PROFILE tt set tt.PERIOD_DURATION = 
(select a.PERIOD_DURATION from  (
select REF_TIMING_PROFILE,max(PERIOD_END)-min(PERIOD_START)as PERIOD_DURATION from TBL_TIMING_PROFILE_DETAIL where REF_TIMING_PROFILE in (select id from TBL_TIMING_PROFILE where type = 2)
group by TBL_TIMING_PROFILE_DETAIL.REF_TIMING_PROFILE)a where A.REF_TIMING_PROFILE = tt.id)
where tt.type = 2 ;
commit;
end;
--------------------------------------------------------
--  DDL for Procedure PRC_LCR_UPDATE_GI_CALC
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_LCR_UPDATE_GI_CALC" (
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
--------------------------------------------------------
--  DDL for Procedure PRC_LEDGER_SENS_PROFILE_REPORT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_LEDGER_SENS_PROFILE_REPORT" (
  INPAR_NAME               IN VARCHAR2
 ,INPAR_DES                IN VARCHAR2
 ,INPAR_REF_USER           IN VARCHAR2
 ,INPAR_STATUS             IN VARCHAR2
 ,inpar_ledger_profile     in varchar2
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
   ,'ledger-sens'
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
--------------------------------------------------------
--  DDL for Procedure PRC_STATE_REPORT_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_STATE_REPORT_PROFILE" (
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_REF_USER         IN VARCHAR2 ,
    INPAR_STATUS           IN VARCHAR2 ,
    INPAR_INSERT_OR_UPDATE IN VARCHAR2 ,
    inpar_ledger_profile in varchar2,
    inpar_timing_profile in varchar2,
    inpar_dep_profile in varchar2,
    inpar_loan_profile in varchar2,
    inpar_brn_profile in varchar2,
    inpar_cus_profile in varchar2,
    inpar_cur_profile in varchar2,
    inpar_timing_profile_type in varchar2,
    INPAR_ID               IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 , -- manzoor riali,....
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
   'STATE' ,
    INPAR_TYPE,
    inpar_ledger_profile ,
    inpar_timing_profile,
    inpar_dep_profile ,
    inpar_loan_profile ,
    inpar_brn_profile ,
    inpar_cus_profile ,
    inpar_cur_profile ,
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
    SET NAME   = INPAR_NAME ,
      DES      = INPAR_DES ,
      REF_USER = INPAR_REF_USER ,
      STATUS   = INPAR_STATUS ,
      TYPE     = INPAR_TYPE,
  REF_LEDGER_PROFIEL       =   inpar_ledger_profile ,
  REF_TIMING_PROFILE             =   inpar_timing_profile,
  REF_DEP_PROFILE             =   inpar_dep_profile ,
      REF_LON_PROFILE         =   inpar_loan_profile ,
      REF_BRN_PROFILE   =   inpar_brn_profile ,
        REF_CUS_PROFILE       =   inpar_cus_profile ,
           REF_CUR_PROFILE    =   inpar_cur_profile ,
           timing_profile_type    =   inpar_timing_profile_type
    WHERE ID   = INPAR_ID;
    COMMIT;
  END IF;
  --=============

  --==============
END PRC_STATE_REPORT_PROFILE;
--------------------------------------------------------
--  DDL for Procedure PRC_LEGAL_DEPOSIT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_LEGAL_DEPOSIT" 
(
  INPAR_DATE IN DATE 
  --,  inpar_ledger_code in varchar2
) AS 
LOC_SEPORDE_GHANUNI NUMBER;
  LOC_NESBAT NUMBER;
  LOC_MEGHDAR VARCHAR2(500);
BEGIN
  SELECT abs(balance) into loc_seporde_ghanuni -- 53340024266
 FROM TBL_LEDGER_ARCHIVE
 WHERE ledger_code = 3100700070 and eff_date = INPAR_DATE;
 
 
 
 SELECT loc_seporde_ghanuni / SUM(balance) INTO LOC_NESBAT
 FROM TBL_value
 WHERE REF_LEGER_CODE IN (SELECT distinct AKIN.TBL_DEPOSIT_ACCOUNTING.LEDGER_CODE_SELF FROM AKIN.TBL_DEPOSIT_ACCOUNTING);
 
    INSERT INTO TBL_value(REF_MODALITY_TYPE, --ID_INSERT = 3
                                          REF_LEGER_CODE, 
                                         DUE_DATE, 
                                          REF_CUR_ID, 
                                          BALANCE,
                                          other_type)
 SELECT 2, --inpar_ledger_code
          3100700070
        ,TARIKH_MOASSER, 4, TRUNC(SUM(mande)) AS MANDE,3  FROM
  (
  SELECT 2, 
  3100700070,
  CASE WHEN due_date IS NULL THEN TRUNC(INPAR_DATE)+1 ELSE due_date END AS TARIKH_MOASSER, 
  REF_CUR_ID,
  (balance)*LOC_NESBAT MANDE
    FROM TBL_VALUE
    WHERE  ref_leger_code IN (SELECT DISTINCT akin.TBL_DEPOSIT_ACCOUNTING.LEDGER_CODE_SELF FROM AKIN.TBL_DEPOSIT_ACCOUNTING)
    )
    GROUP BY TARIKH_MOASSER, REF_CUR_ID;
    COMMIT;
    ------------------------------------------------------------------
    SELECT loc_seporde_ghanuni - SUM(balance) INTO LOC_MEGHDAR 
    FROM TBL_value WHERE REF_LEGER_CODE = 3100700070;
  
    INSERT INTO TBL_value(REF_MODALITY_TYPE, --ID_INSERT = 3.1
                                          REF_LEGER_CODE, 
                                          DUE_DATE, 
                                          REF_CUR_ID, 
                                          BALANCE,
                                          other_type)
    VALUES(2, 3100700070, TRUNC(inpar_date)+1 , 4, ROUND(LOC_MEGHDAR),3.1);
    COMMIT;
    
END PRC_LEGAL_DEPOSIT;
--------------------------------------------------------
--  DDL for Procedure UPDATE_LEDGER_NODE_ID_TYPE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."UPDATE_LEDGER_NODE_ID_TYPE" 
 AS 
BEGIN

for i in (select * from pragg.tbl_ledger where PARENT_CODE=0 and node_type is not null) loop

if(i.ledger_code=10000000000 or i.ledger_code=50000000000 or i.ledger_code=30000000000) then  -- type=2
UPDATE pragg.tbl_ledger
SET node_type      ='2'
WHERE ledger_code IN
  (SELECT LEDGER_CODE
  FROM pragg.tbl_ledger
    CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE
    START WITH LEDGER_CODE       = i.ledger_code
  );
  
ELSIF (i.ledger_code=40000000000 or i.ledger_code=20000000000 ) then  -- type=1
UPDATE pragg.tbl_ledger
SET node_type      ='1'
WHERE ledger_code IN
  (SELECT LEDGER_CODE
  FROM pragg.tbl_ledger
    CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE
    START WITH LEDGER_CODE       = i.ledger_code
  ); 
   end if;
 end loop; 
   commit;
END update_ledger_node_id_type;
--------------------------------------------------------
--  DDL for Procedure PRC_LEDGER_PROFILE_INSERT_ALL
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_LEDGER_PROFILE_INSERT_ALL" (
 INPAR_QUERY    IN CLOB
 ,INPAR_ID       IN NUMBER
 ,OUTPAR_QUERY   OUT VARCHAR2
)
 AS
 var_id number;
BEGIN
select max(id) into var_id from tbl_ledger_profile where h_id = INPAR_ID;
 EXECUTE IMMEDIATE 'begin ' || INPAR_QUERY || ' end;';
 --EXECUTE IMMEDIATE INPAR_QUERY;
 OUTPAR_QUERY   := 1;


END PRC_LEDGER_PROFILE_INSERT_ALL;
--------------------------------------------------------
--  DDL for Procedure PRC_DUE_DATE_REPORT_VALUE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_DUE_DATE_REPORT_VALUE" (
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
  var_rep_req number;
BEGIN
--  execute immediate 'alter session set nls_date_format=''DD-MM-RRRR''';
  SYS.DBMS_OUTPUT.ENABLE(3000000);
  /******profilhaye mokhtalefi ke karbar baraye in gozaresh entekhab karde ra daron moteghayer ham nam profil mirizim ******/

  SELECT REF_TIMING_PROFILE
  INTO ID_TIMING
  FROM TBL_REPORT 
  WHERE ID = INPAR_ID_REPORT;
  /******be ezaye tedad bazehayee ke dar profile zamani vojod darad halghe ro ejra mikonim*****--*/

   INSERT
  INTO TBL_REPREQ
    (
      REF_REPORT_ID,
      REF_USER_ID,
      REQ_DATE,
      STATUS,
      REF_LEDGER_PROFILE,
      REF_PROFILE_TIME,
      REF_PROFILE_CURRENCY,
      REF_PROFILE_CUSTOMER,
      REF_PROFILE_BRANCH,
      REF_PROFILE_DEPOSIT,
      REF_PROFILE_LOAN,
      REF_HID_REPORT,
      TYPE,
      CATEGORY
    )
  values(
  INPAR_ID_REPORT,
  (select REF_USER from tbl_report where id =INPAR_ID_REPORT ),
  sysdate,
  0,
  0,
  ID_TIMING,
  0,0,0,0,0,0,'DUE_DATE','DUE_DATE'
  );
  commit;

  select max(id) into var_rep_req from tbl_repreq ;

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
INSERT INTO TBL_DUE_DATE_DETAIL (
 REP_REQ
 ,PARENT
 ,CHILD
 ,VALUE
 ,DEPTH
 ,REF_EFF_DATE
 ,BRANCH
 ,TYPE
 ,RATE,
 name
)  
   SELECT
 '||var_rep_req||'
 ,100000 ||
 REF_BRANCH ||
 100 ||
 REF_DEPOSIT_TYPE AS BACHE2
 ,100000 ||
 REF_BRANCH ||
 100 ||
 REF_DEPOSIT_TYPE ||
 RATE AS BACHE1
 ,SUM(BALANCE)
 ,4
 ,'||I.ID||'
 ,REF_BRANCH
 ,REF_DEPOSIT_TYPE
 ,RATE
 , ''نرخ سود '' || RATE
FROM AKIN.TBL_DEPOSIT
WHERE  AND DUE_DATE > to_date('''
        || DATE_TYPE1
        || ''') and DUE_DATE <= to_date('''
        || DATE_TYPE1
        || ''')+'
        || I.PERIOD_DATE
        || '
 AND
  RATE IS NOT NULL
GROUP BY
 REF_BRANCH
 ,REF_DEPOSIT_TYPE
 ,RATE;'    
      INTO VAR_QUERY
      FROM DUAL;
      DBMS_OUTPUT.PUT_LINE(VAR_QUERY);
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;
        DATE_TYPE1 := DATE_TYPE1 + TO_NUMBER(I.PERIOD_DATE);
    ELSE
      /******agar profile zamani entekhab shode tarikhi bashad *****--*/
      SELECT '  
INSERT INTO TBL_DUE_DATE_DETAIL (
 REP_REQ
 ,PARENT
 ,CHILD
 ,VALUE
 ,DEPTH
 ,REF_EFF_DATE
 ,BRANCH
 ,TYPE
 ,RATE,
 name
) 
SELECT
 '||var_rep_req||'
 ,100000 ||
 REF_BRANCH ||
 100 ||
 REF_DEPOSIT_TYPE AS BACHE2
 ,100000 ||
 REF_BRANCH ||
 100 ||
 REF_DEPOSIT_TYPE ||
 RATE AS BACHE1
 ,SUM(BALANCE)
 ,4
 ,'||I.ID||'
 ,REF_BRANCH
 ,REF_DEPOSIT_TYPE
 ,RATE
 , ''نرخ سود '' || RATE
FROM AKIN.TBL_DEPOSIT
WHERE DUE_DATE > to_date('''
        || I.PERIOD_START
        || ''',''dd-mm-yyyy'') and DUE_DATE <= to_date('''
        || I.PERIOD_END
        || ''',''dd-mm-yyyy'') 
 AND
  RATE IS NOT NULL
GROUP BY
 REF_BRANCH
 ,REF_DEPOSIT_TYPE
 ,RATE;'
      INTO VAR_QUERY
      FROM DUAL;
      EXECUTE IMMEDIATE 'BEGIN ' || VAR_QUERY || ' END;';
      COMMIT;

    END IF;
  END LOOP;
  COMMIT;
END PRC_due_date_report_value;
--------------------------------------------------------
--  DDL for Procedure PRC_INSERT_COM_RESULT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_INSERT_COM_RESULT" 
AS
VAR_DATE DATE;
BEGIN
SELECT MAX(EFF_DATE) INTO VAR_DATE FROM TBL_COM_VALUE;
FOR I IN 1..60 LOOP
--------------------------------------------------------------------------------
INSERT INTO TBL_COM_RESULT (
EFF_DATE ,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(ODCi-(VOi/Vi)*sd)/(VTi*(1-SOD-LD)) AS direct
 ,(HCi*(NODi/NDi)+VCi*(VOi/Vi))/(VOi*(1-SOD-LD)) AS indirect
 , (ODCi-(VOi/Vi)*sd)/(VTi*(1-SOD-LD)) + (HCi*(NODi/NDi)+VCi*(VOi/Vi))/(VOi*(1-SOD-LD))  TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,10,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'ODCi' AS ODCi,'VOi' AS VOi,'Vi' AS Vi,'sd' AS sd,'VTi' AS VTi,'SOD' AS SOD,'LD' AS LD,'IC' AS IC,'HCi' AS HCi,'NODi' AS NODi,'NDi' AS NDi,'VCi'
AS VCi )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;  
 --*********************************************************

 
  INSERT INTO TBL_COM_RESULT (
  EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,
 BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
    ,(HCi*(NDDi/NDi)+VCi*(VDi/Vi))/(VDi*(1-SDD-LD)) - ((VDi/V)*sd)/(VDi*(1-SDD-LD)) AS direct
 ,(HCi*(NDDi/NDi)+VCi*(VDi/Vi))/(VDi*(1-SDD-LD)) AS indirect
 ,  ((VDi/V)*sd)/(VDi*(1-SDD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,9,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'VDi' AS VDi,'V' AS V,'sd' AS sd,'SDD' AS SDD,'LD' AS LD,'HCi' AS HCi,'NDDi' AS NDDi,'NDi' AS NDi,'VCi'
AS VCi,'Vi' AS Vi )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
 COMMIT;
-- ******************************************************
 INSERT INTO TBL_COM_RESULT (
 EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,((VSi/V)*sd)/(VSi*(1-SSD-LD))  AS direct
 ,((HCi*(NSDi/NDi)+VCi*(VSi/Vi))/(VSi*(1-SSD-LD))) AS indirect
 , ((HCi*(NSDi/NDi)+VCi*(VSi/Vi))/(VSi*(1-SSD-LD))) + ((VSi/V)*sd)/(VSi*(1-SSD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,8,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'VSi' AS VSi,'V' AS V,'sd' AS sd,'SSD' AS SSD,'LD' AS LD,'HCi' AS HCi,'NSDi' AS NSDi,'NDi' AS NDi,'VCi' AS VCi,'Vi' AS Vi )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
 
 COMMIT;
--*************************************************************

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(TDCI-(VTI/VI)*SD1)/(VTI*(1-STD-LD))  AS direct
 ,(HCI*(NTDi/NDI)+VCI*(VTI/VI))/(VTI*(1-STD-LD)) AS indirect
 , (TDCI-(VTI/VI)*SD1)/(VTI*(1-STD-LD)) +  (HCI*(NTDI/NDI)+VCI*(VTI/VI))/(VTI*(1-STD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,7,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'TDCi' AS TDCI,'VTi' AS VTI,'sd' AS SD1,'Vi' AS VI,'LD' AS LD,'STD' AS STD,'HCi' AS HCI,'NTDi' AS NTDI,'VCi' AS VCI,'NDI' as NDI
   )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
--*************************************************************
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(Dci-sd1*(Vi/V))/(Vi*(1-SD-LD))  AS direct
 ,(HrCi+RCi+Dpi+Eci+Ici+EECi+OCi+Mci+NPLCi+FCi)/(Vi*(1-SD-LD))  AS indirect
 , (Dci-sd1*(Vi/V))/(Vi*(1-SD-LD)) +  (HrCi+RCi+Dpi+Eci+Ici+EECi+OCi+Mci+NPLCi+FCi)/(Vi*(1-SD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,6,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'Dci' AS Dci,'sd' AS sd1,'Vi' AS Vi,'V' AS V,'SD' AS SD,'LD' AS LD,'HrCi' AS HrCi,'RCi' AS RCi,'Dpi' AS Dpi,'Eci' as Eci
  ,'Ici' AS Ici,'EECi' AS EECi,'OCi' AS OCi,'Mci' as Mci,'NPLCi' AS NPLCi,'FCi' AS FCi  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
  COMMIT;
 -- ************************************************************
  --================================================================ type = 1
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(DC-SD1)/(V*(1-SD-LD)) AS direct
 ,(OC+CC+FC+NPLC)/(V*(1-SD-LD)) AS indirect
 , ((DC-SD1)/(V*(1-SD-LD))+(OC+CC+FC+NPLC)/(V*(1-SD-LD))) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '1' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'DC' AS DC,'sd' AS SD1,'V' AS V,'SD' AS SD, 'LD' as LD, 'OC' as OC, 'CC' as CC
   ,'FC' as FC,'NPLC' as NPLC
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
--============================================================================================
/*
--====================================================================================type = 2 
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(TDC-(VT/V)*SD1)/(VS*(1-SSD-LD)) AS direct
 ,(HC*(NTD/ND)+VC*(VT/V))/(VT*(1-STD-LD)) AS indirect
 , ((TDC-(VT/V)*SD1)/(VS*(1-SSD-LD))+(HC*(NTD/ND)+VC*(VT/V))/(VT*(1-STD-LD))) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '2' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'TDC' AS TDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
--=================================================================================================
*/
/*
--====================================================================================type = 3

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SDC-(VS/V)*SD1)/(VS*(1-SSD-LD))AS direct
 ,(HC*(NSD/ND)+VC*(VS/V))/(VS*(1-SSD-LD)) AS indirect
 , (SDC-(VS/V)*SD1)/(VS*(1-SSD-LD))+(HC*(NSD/ND)+VC*(VS/V))/(VS*(1-SSD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '3' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'SDC' AS SDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;


COMMIT;
--=========================================================================================
*/
/*
--=======================================================================type = 4
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(ODC-(VO/V)*SD1)/(VO*(1-SOD-LD)) AS direct
 ,(HC*(NOD/ND)+VC*(VO/V))/(VO*(1-SOD-LD)) AS indirect
 , (ODC-(VO/V)*SD1)/(VO*(1-SOD-LD))+(HC*(NOD/ND)+VC*(VO/V))/(VO*(1-SOD-LD))  TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '4' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'ODC' AS ODC,'VO' AS VO,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SOD' as SOD, 'NOD' as NOD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;

COMMIT;
--==============================================================================
*/
/*
--========================================================================type = 5

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,((VD/V)*SD1)/(VD*(1-SDD-LD)) AS direct
 , (HC*(NDD/ND)+VC*(VD/V))/(VD*(1-SDD-LD)) AS indirect
 , ((VD/V)*SD1)/(VD*(1-SDD-LD))-(HC*(NDD/ND)+VC*(VD/V))/(VD*(1-SDD-LD))  TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '5' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'ODC' AS ODC,'VO' AS VO,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SOD' as SOD, 'NOD' as NOD,'SDD' as SDD,'NDD' as NDD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
--=============================================================================
*/
--====================================================================================type = 11

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SPBB-(MTBB/V)*SD1)/(MTBB*(1-SSD-LD)) AS direct
 ,1000 AS indirect
 , 1000 TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '11' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'SDC' AS SDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SPBB' as SPBB, 'MTBB' as MTBB
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;


COMMIT;
--=========================================================================================

--====================================================================================type = 12

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SPBM-(MTBM/V)*SD1)/(MTBM*(1-SSD-LD)) AS direct
 ,1000 AS indirect
 , 1000 TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '12' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'SDC' AS SDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SPBM' as SPBM, 'MTBM' as MTBM
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;


COMMIT;
--=========================================================================================



END LOOP;

FOR I IN 335..365 LOOP

INSERT INTO TBL_COM_RESULT (
EFF_DATE ,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(ODCi-(VOi/Vi)*sd)/(VTi*(1-SOD-LD)) AS direct
 ,(HCi*(NODi/NDi)+VCi*(VOi/Vi))/(VOi*(1-SOD-LD)) AS indirect
 , (ODCi-(VOi/Vi)*sd)/(VTi*(1-SOD-LD)) + (HCi*(NODi/NDi)+VCi*(VOi/Vi))/(VOi*(1-SOD-LD))  TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,10,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'ODCi' AS ODCi,'VOi' AS VOi,'Vi' AS Vi,'sd' AS sd,'VTi' AS VTi,'SOD' AS SOD,'LD' AS LD,'IC' AS IC,'HCi' AS HCi,'NODi' AS NODi,'NDi' AS NDi,'VCi'
AS VCi )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;  
 --*********************************************************

 
  INSERT INTO TBL_COM_RESULT (
  EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
 
  ,(HCi*(NDDi/NDi)+VCi*(VDi/Vi))/(VDi*(1-SDD-LD)) - ((VDi/V)*sd)/(VDi*(1-SDD-LD)) AS direct
 ,(HCi*(NDDi/NDi)+VCi*(VDi/Vi))/(VDi*(1-SDD-LD)) AS indirect
 ,  ((VDi/V)*sd)/(VDi*(1-SDD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,9,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'VDi' AS VDi,'V' AS V,'sd' AS sd,'SDD' AS SDD,'LD' AS LD,'HCi' AS HCi,'NDDi' AS NDDi,'NDi' AS NDi,'VCi'
AS VCi,'Vi' AS Vi )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
 COMMIT;
-- ******************************************************
 INSERT INTO TBL_COM_RESULT (
 EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,((VSi/V)*sd)/(VSi*(1-SSD-LD))  AS direct
 ,((HCi*(NSDi/NDi)+VCi*(VSi/Vi))/(VSi*(1-SSD-LD))) AS indirect
 , ((HCi*(NSDi/NDi)+VCi*(VSi/Vi))/(VSi*(1-SSD-LD))) + ((VSi/V)*sd)/(VSi*(1-SSD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,8,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'VSi' AS VSi,'V' AS V,'sd' AS sd,'SSD' AS SSD,'LD' AS LD,'HCi' AS HCi,'NSDi' AS NSDi,'NDi' AS NDi,'VCi' AS VCi,'Vi' AS Vi )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
 
 COMMIT;
--*************************************************************

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(TDCI-(VTI/VI)*SD1)/(VTI*(1-STD-LD))  AS direct
 ,(HCI*(NTDi/NDI)+VCI*(VTI/VI))/(VTI*(1-STD-LD)) AS indirect
 , (TDCI-(VTI/VI)*SD1)/(VTI*(1-STD-LD)) +  (HCI*(NTDI/NDI)+VCI*(VTI/VI))/(VTI*(1-STD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,7,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'TDCi' AS TDCI,'VTi' AS VTI,'sd' AS SD1,'Vi' AS VI,'LD' AS LD,'STD' AS STD,'HCi' AS HCI,'NTDi' AS NTDI,'VCi' AS VCI,'NDI' as NDI
   )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
--*************************************************************
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(Dci-sd1*(Vi/V))/(Vi*(1-SD-LD))  AS direct
 ,(HrCi+RCi+Dpi+Eci+Ici+EECi+OCi+Mci+NPLCi+FCi)/(Vi*(1-SD-LD))  AS indirect
 , (Dci-sd1*(Vi/V))/(Vi*(1-SD-LD)) +  (HrCi+RCi+Dpi+Eci+Ici+EECi+OCi+Mci+NPLCi+FCi)/(Vi*(1-SD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,6,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'Dci' AS Dci,'sd' AS sd1,'Vi' AS Vi,'V' AS V,'SD' AS SD,'LD' AS LD,'HrCi' AS HrCi,'RCi' AS RCi,'Dpi' AS Dpi,'Eci' as Eci
  ,'Ici' AS Ici,'EECi' AS EECi,'OCi' AS OCi,'Mci' as Mci,'NPLCi' AS NPLCi,'FCi' AS FCi  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
  COMMIT;
 -- ************************************************************
  --================================================================ type = 1
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(DC-SD1)/(V*(1-SD-LD)) AS direct
 ,(OC+CC+FC+NPLC)/(V*(1-SD-LD)) AS indirect
 , ((DC-SD1)/(V*(1-SD-LD))+(OC+CC+FC+NPLC)/(V*(1-SD-LD))) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '1' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'DC' AS DC,'sd' AS SD1,'V' AS V,'SD' AS SD, 'LD' as LD, 'OC' as OC, 'CC' as CC
   ,'FC' as FC,'NPLC' as NPLC
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
--============================================================================================
/*
--====================================================================================type = 2 
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(TDC-(VT/V)*SD1)/(VS*(1-SSD-LD)) AS direct
 ,(HC*(NTD/ND)+VC*(VT/V))/(VT*(1-STD-LD)) AS indirect
 , ((TDC-(VT/V)*SD1)/(VS*(1-SSD-LD))+(HC*(NTD/ND)+VC*(VT/V))/(VT*(1-STD-LD))) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '2' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'TDC' AS TDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
--=================================================================================================
*/
/*
--====================================================================================type = 3

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SDC-(VS/V)*SD1)/(VS*(1-SSD-LD))AS direct
 ,(HC*(NSD/ND)+VC*(VS/V))/(VS*(1-SSD-LD)) AS indirect
 , (SDC-(VS/V)*SD1)/(VS*(1-SSD-LD))+(HC*(NSD/ND)+VC*(VS/V))/(VS*(1-SSD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '3' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'SDC' AS SDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;


COMMIT;
--=========================================================================================
*/
/*
--=======================================================================type = 4
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(ODC-(VO/V)*SD1)/(VO*(1-SOD-LD)) AS direct
 ,(HC*(NOD/ND)+VC*(VO/V))/(VO*(1-SOD-LD)) AS indirect
 , (ODC-(VO/V)*SD1)/(VO*(1-SOD-LD))+(HC*(NOD/ND)+VC*(VO/V))/(VO*(1-SOD-LD))  TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '4' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'ODC' AS ODC,'VO' AS VO,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SOD' as SOD, 'NOD' as NOD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;

COMMIT;
--==============================================================================
*/
/*
--========================================================================type = 5

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH

  , ((VD/V)*SD1)/(VD*(1-SDD-LD))-(HC*(NDD/ND)+VC*(VD/V))/(VD*(1-SDD-LD))  AS direct
 , (HC*(NDD/ND)+VC*(VD/V))/(VD*(1-SDD-LD)) AS indirect
 ,  ((VD/V)*SD1)/(VD*(1-SDD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '5' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'ODC' AS ODC,'VO' AS VO,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SOD' as SOD, 'NOD' as NOD,'SDD' as SDD,'NDD' as NDD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
*/
--=========================================================================
--====================================================================================type = 11

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SPBB-(MTBB/V)*SD1)/(MTBB*(1-SSD-LD)) AS direct
 ,1000 AS indirect
 , 1000 TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '11' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'SDC' AS SDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SPBB' as SPBB, 'MTBB' as MTBB
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;


COMMIT;
--=========================================================================================

--====================================================================================type = 12

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SPBM-(MTBM/V)*SD1)/(MTBM*(1-SSD-LD)) AS direct
 ,1000 AS indirect
 , 1000 TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '12' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'SDC' AS SDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SPBM' as SPBM, 'MTBM' as MTBM
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;


COMMIT;
--=========================================================================================





END LOOP;




END;
--------------------------------------------------------
--  DDL for Procedure PRC_AGGREGATION2
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_AGGREGATION2" ( INPAR_REF_REQ_ID IN NUMBER ) AS
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: rasool.jahani,morteza.sahi
  Editor Name:
  Release Date/Time:1396/04/26-10:00
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
 var_max_effdate_ledger date;
  LOC_S  TIMESTAMP;
 LOC_F  TIMESTAMP;
 LOC_MEGHDAR NUMBER;
BEGIN
 EXECUTE IMMEDIATE 'truncate table TBL_VALUE_AGGRIGATION';
  
 --EXECUTE IMMEDIATE 'truncate table tbl_other_ledger_code';

select max(EFF_DATE)into var_max_effdate_ledger from tbl_ledger_archive; -------***************************************************
 

    /****** be dast avardane profil haye gozaresh mord niaz va bishtarin sathe daftar kol *****--*/
 SELECT
  REF_REPORT_ID
 INTO
  VAR_REF_REPORT_ID
 FROM TBL_REPREQ
 WHERE ID   = INPAR_REF_REQ_ID;

 SELECT
  REF_LEDGER_PROFILE
 INTO
  VAR_REF_LEDGER_PROFILE
 FROM TBL_REPORT_PROFILE
 WHERE REF_REPORT   = VAR_REF_REPORT_ID;

 SELECT
  REF_PROFILE_TIME
 INTO
  VAR_REF_PROFILE_TIME
 FROM TBL_REPORT_PROFILE
 WHERE REF_REPORT   = VAR_REF_REPORT_ID;

 SELECT
  TO_NUMBER(MAX(DEPTH) )
 INTO
  VAR_MAX_LEVEL_LEDGER
 FROM TBL_LEDGER_PROFILE_DETAIL
 WHERE REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE;

 SELECT
  SYSDATE
 INTO
  VAR_DATE_INSERT
 FROM DUAL;
  
  
  /******enteghal har code sarfasl dar har baze zamani be jadval aggrigation******/
 INSERT INTO TBL_VALUE_AGGRIGATION ( LEDGER_CODE,BALANCE,REF_TIMING_ID ) SELECT
  REF_LEGER_CODE
 ,SUM(BALANCE)
 ,REF_TIMING_ID
 FROM TBL_VALUE_TEMP
 GROUP BY
  REF_LEGER_CODE
 ,REF_TIMING_ID;

 COMMIT;
       /******  ezefe kardane code sarfaslhaee ke dar value nabode be jadval other  *****--*/
insert into tbl_other_ledger_code(ledger_code,balance,PARENT,DEPTH,REP_REQ)
SELECT
 LEDGER_CODE
 ,BALANCE,
PARENT_CODE,
DEPTH,
INPAR_REF_REQ_ID FROM TBL_LEDGER_ARCHIVE
WHERE EFF_DATE   = (
  SELECT
   MAX(EFF_DATE)
  FROM TBL_LEDGER_ARCHIVE
 ) and DEPTH = VAR_MAX_LEVEL_LEDGER 
 --and ledger_code not in 
 --(SELECT distinct ledger_code from TBL_VALUE_AGGRIGATION where ledger_code is not null)
 ;
 commit;
  FOR I IN REVERSE 1..VAR_MAX_LEVEL_LEDGER LOOP
 insert into tbl_other_ledger_code(ledger_code,balance,PARENT,DEPTH,REP_REQ)SELECT DISTINCT
  B.CODE
  ,NVL(A.VALUE,0)
  ,B.PARENT_CODE
  ,I
  ,a.REP_REQ
  FROM (
    SELECT
    tr.REP_REQ,
     TR.PARENT AS CODE
    ,SUM(NVL(tr.balance,0) ) AS VALUE
    ,MAX(TLPD.PARENT_CODE) AS PARENT_CODE
    FROM tbl_other_ledger_code TR
     LEFT JOIN TBL_LEDGER_PROFILE_DETAIL TLPD ON TLPD.CODE   = TR.PARENT
    WHERE TLPD.DEPTH                = I
     AND
      TLPD.REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE
      and tr.REP_REQ = INPAR_REF_REQ_ID
    GROUP BY
     TR.PARENT,
      tr.REP_REQ
   ) A
   RIGHT JOIN (
    SELECT
     *
    FROM TBL_LEDGER_PROFILE_DETAIL
    WHERE DEPTH                = I
     AND
      REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE
   ) B ON A.CODE   = B.CODE;


  COMMIT;
 END LOOP;
  
  
 COMMIT;
 DELETE FROM tbl_other_ledger_code where depth is null;
  COMMIT;

      /******  ezefe kardane code sarfaslhaee ke dar value nabode ba code meghdar "0"  *****--*/
      
 INSERT INTO TBL_VALUE_AGGRIGATION ( LEDGER_CODE,BALANCE,REF_TIMING_ID ) SELECT DISTINCT
  B.LEDGER_CODE
 ,0
 ,A.REF_TIMING_ID
 FROM TBL_LEDGER B
 ,    (
   SELECT
   
    LEDGER_CODE
   ,TBL_VALUE_AGGRIGATION.REF_TIMING_ID
   FROM TBL_VALUE_AGGRIGATION
  ) A
 WHERE A.LEDGER_CODE <> B.LEDGER_CODE
  AND
   B.DEPTH   = VAR_MAX_LEVEL_LEDGER;


--INSERT INTO TBL_VALUE_AGGRIGATION ( LEDGER_CODE,BALANCE,REF_TIMING_ID ) SELECT DISTINCT
-- B.LEDGER_CODE
-- , CASE
--   WHEN B.LEDGER_CODE LIKE '1%'
--   OR
--    B.LEDGER_CODE LIKE '2%'
--   THEN -1 * ( B.BALANCE )
--   ELSE B.BALANCE
--  END
-- AS BALANCE
-- ,A.REF_TIMING_ID
--FROM TBL_LEDGER_ARCHIVE B
-- ,    (
--  SELECT
--   LEDGER_CODE
--  ,TBL_VALUE_AGGRIGATION.REF_TIMING_ID
--  FROM TBL_VALUE_AGGRIGATION
-- ) A
--WHERE A.LEDGER_CODE <> B.LEDGER_CODE
-- AND
--  B.DEPTH      = VAR_MAX_LEVEL_LEDGER
-- AND
--  B.EFF_DATE   = (
--   SELECT
--    MAX(EFF_DATE)
--   FROM TBL_LEDGER_ARCHIVE
--  );
--
-- COMMIT;
  
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
 ,VAR_REF_REPORT_ID
 ,ID
 ,INPAR_REF_REQ_ID
 FROM TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = VAR_REF_PROFILE_TIME;

 COMMIT;
  /*-----------------------------------------*/
   /******tajmie daftar kol baraye har baze zamani dar repval (enteghale barghaye tajmie shode be repval)*****--*/
  /*-----------------------------------------*/
 INSERT INTO TBL_REPVAL (
  REF_REPREQ_ID
 ,REF_REPPER_ID
 ,LEDGER_CODE
 ,VALUE
 ,PARENT_CODE
 ,DEPTH
 ,NAME,
 mande                        -------***************************************************
 ) SELECT
  INPAR_REF_REQ_ID
 ,(
   SELECT
    ID
   FROM TBL_REPPER
   WHERE OLD_ID          = TVA.REF_TIMING_ID
    AND
     REF_REPORT_ID   = VAR_REF_REPORT_ID
    AND
     REF_REQ_ID      = INPAR_REF_REQ_ID
  ) AS REF_TIMING_ID
 ,TVA.LEDGER_CODE
 ,TVA.BALANCE
 ,TLPD.PARENT_CODE
 ,VAR_MAX_LEVEL_LEDGER
 ,TLPD.NAME
 ,(select  SUM(ABS(BALANCE) ) from tbl_ledger_archive where eff_date= var_max_effdate_ledger and TVA.LEDGER_CODE =LEDGER_CODE ) -------***************************************************
 FROM TBL_VALUE_AGGRIGATION TVA
 ,    TBL_LEDGER_PROFILE_DETAIL TLPD
 WHERE TLPD.CODE                 = TVA.LEDGER_CODE
  AND
   TLPD.REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE;

 COMMIT;
  /*-----------------------------------------*/
     /******tajmie daftar kol baraye har baze zamani dar repval barasas daftar kole taen shode *****--*/
  /*-----------------------------------------*/
 FOR I IN REVERSE 1..VAR_MAX_LEVEL_LEDGER LOOP
  INSERT INTO TBL_REPVAL (
   REF_REPREQ_ID
  ,REF_REPPER_ID
  ,LEDGER_CODE
  ,VALUE
  ,PARENT_CODE
  ,DEPTH,
  mande -------***************************************************
  ) SELECT DISTINCT
   INPAR_REF_REQ_ID
  ,A.REF_REPPER_ID
  ,B.CODE
  ,NVL(A.VALUE,0)
  ,B.PARENT_CODE
  ,I
 ,NVL(A.mande,0) -------***************************************************

  FROM (
    SELECT
     MAX(TR.REF_REPREQ_ID) AS REF_REPREQ_ID
    ,TR.REF_REPPER_ID
    ,TR.PARENT_CODE AS CODE
    ,SUM(NVL(TR.VALUE,0) ) AS VALUE
    ,SUM(NVL(TR.mande,0) ) AS mande -------***************************************************
    ,MAX(TLPD.PARENT_CODE) AS PARENT_CODE
    FROM TBL_REPVAL TR
     LEFT JOIN TBL_LEDGER_PROFILE_DETAIL TLPD ON TLPD.CODE   = TR.PARENT_CODE
    WHERE TLPD.DEPTH                = I
     AND
      TLPD.REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE
       and tr.ref_repreq_id =INPAR_REF_REQ_ID         --------------------------
    GROUP BY
     TR.PARENT_CODE
    ,TR.REF_REPPER_ID
   ) A
   RIGHT JOIN (
    SELECT
     *
    FROM TBL_LEDGER_PROFILE_DETAIL
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
 FROM TBL_REPPER
 WHERE REF_REPORT_ID   = VAR_REF_REPORT_ID;
       /******hazf kardan node haye ke eshtebah vard shodan(bedone zaman hastand)*****--*/

 DELETE FROM (
  SELECT
   *
  FROM TBL_REPVAL
  WHERE LEDGER_CODE IN (
    SELECT
     LEDGER_CODE
    FROM TBL_REPVAL
    GROUP BY
     LEDGER_CODE
    HAVING COUNT(*) = VAR_CNT_REF_PROFILE_TIME
   )
 ) WHERE REF_REPPER_ID IS NULL;

 COMMIT;

   /******ezafe kardane name code sarfaslha baraye jologiri az join ezafe dar namayesh gozaresh*****--*/
 UPDATE TBL_REPVAL T
  SET
   T.NAME = (
    SELECT
     NAME
    FROM TBL_LEDGER_PROFILE_DETAIL
    WHERE TBL_LEDGER_PROFILE_DETAIL.REF_LEDGER_PROFILE   = VAR_REF_LEDGER_PROFILE
     AND
      TBL_LEDGER_PROFILE_DETAIL.CODE                 = T.LEDGER_CODE
   )
 WHERE T.REF_REPREQ_ID = INPAR_REF_REQ_ID;

 COMMIT;
  /*-----------------------------------------*/
       LOC_F := SYSTIMESTAMP;
       LOC_MEGHDAR := SQL%ROWCOUNT;
      EXCEPTION 
      WHEN OTHERS THEN
      RAISE;
  /*-----------------------------------------*/
END PRC_AGGREGATION2;
--------------------------------------------------------
--  DDL for Procedure PRC_INSERT_COM_RESULT_TEST
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_INSERT_COM_RESULT_TEST" 
AS
NBB number;
KM number;
JA number;
GH number;
NBM number;
BM number;
NSS number;
NBB_value number;
KM_value number;
JA_value number;
GH_value number;
NBM_value number;
BM_value number;
NSS_value number;
VAR_DATE DATE;
hajme_seporde number;
total_indirect number;
hajme_seporde_shobe number;

BEGIN
SELECT MAX(EFF_DATE) INTO VAR_DATE FROM TBL_COM_VALUE;
--=======newwww
select ref_ledger_code into NSS from tbl_com_rep_profile_detail where title = 'NSS';
select balance into NSS_value from TBL_LEDGER_ARCHIVE where LEDGER_CODE = NSS and TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY');


select ref_ledger_code into NBB from tbl_com_rep_profile_detail where title = 'NBB';
select balance into NBB_value from TBL_LEDGER_ARCHIVE where LEDGER_CODE = NBB and TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY');

select ref_ledger_code into KM from tbl_com_rep_profile_detail where title = 'KM';
select balance into KM_value from TBL_LEDGER_ARCHIVE where LEDGER_CODE = KM and TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY');

select ref_ledger_code into JA from tbl_com_rep_profile_detail where title = 'JA';
select balance into JA_value from TBL_LEDGER_ARCHIVE where LEDGER_CODE = JA and TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY');

select ref_ledger_code into GH from tbl_com_rep_profile_detail where title = 'GH';
select balance into GH_value from TBL_LEDGER_ARCHIVE where LEDGER_CODE = GH and TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY');

select ref_ledger_code into NBM from tbl_com_rep_profile_detail where title = 'NBM';
select balance into NBM_value from TBL_LEDGER_ARCHIVE where LEDGER_CODE = NBM and TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY');

select ref_ledger_code into BM from tbl_com_rep_profile_detail where title = 'BM';
select balance into BM_value from TBL_LEDGER_ARCHIVE where LEDGER_CODE = BM and TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY');

hajme_seporde := NBB_value + KM_value + JA_value + GH_value + NBM_value + BM_value + NSS_value; 

NBB_value := (NBB_value/hajme_seporde)*total_indirect;
KM_value := (KM_value/hajme_seporde)*total_indirect;
JA_value := (JA_value/hajme_seporde)*total_indirect;
GH_value := (GH_value/hajme_seporde)*total_indirect;
NBM_value := (NBM_value/hajme_seporde)*total_indirect;
BM_value := (BM_value/hajme_seporde)*total_indirect;
NSS_value :=(NSS_value/hajme_seporde)*total_indirect;

hajme_seporde_shobe:=NBB_value + KM_value + JA_value + GH_value + NBM_value + BM_value+ NSS_value;

NBM_value:= (NBM_value/hajme_seporde_shobe)*1 ;
NBB_value:= (NBB_value/hajme_seporde_shobe)*1;



--============ biroone halghe
 --================================================================ type = 1
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY'),
 100000 || REF_BRANCH AS REF_BRANCH
  ,(DC-SD1)/(V*(1-SD-LD)) AS direct
 ,(OC+CC+FC+NPLC)/(V*(1-SD-LD)) AS indirect 
 , ((DC-SD1)/(V*(1-SD-LD))+(OC+CC+FC+NPLC)/(V*(1-SD-LD))) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '1' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') 
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY')
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'DC' AS DC,'sd' AS SD1,'V' AS V,'SD' AS SD, 'LD' as LD, 'OC' as OC, 'CC' as CC
   ,'FC' as FC,'NPLC' as NPLC
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;


--============
FOR I IN 1..60 LOOP
--------------------------------------------------------------------------------
INSERT INTO TBL_COM_RESULT (
EFF_DATE ,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(ODCi-(VOi/Vi)*sd)/(VTi*(1-SOD-LD)) AS direct
 ,(HCi*(NODi/NDi)+VCi*(VOi/Vi))/(VOi*(1-SOD-LD)) AS indirect
 , (ODCi-(VOi/Vi)*sd)/(VTi*(1-SOD-LD)) + (HCi*(NODi/NDi)+VCi*(VOi/Vi))/(VOi*(1-SOD-LD))  TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,10,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'ODCi' AS ODCi,'VOi' AS VOi,'Vi' AS Vi,'sd' AS sd,'VTi' AS VTi,'SOD' AS SOD,'LD' AS LD,'IC' AS IC,'HCi' AS HCi,'NODi' AS NODi,'NDi' AS NDi,'VCi'
AS VCi )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;  
 --*********************************************************

 
  INSERT INTO TBL_COM_RESULT (
  EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,
 BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
    ,(HCi*(NDDi/NDi)+VCi*(VDi/Vi))/(VDi*(1-SDD-LD)) - ((VDi/V)*sd)/(VDi*(1-SDD-LD)) AS direct
 ,(HCi*(NDDi/NDi)+VCi*(VDi/Vi))/(VDi*(1-SDD-LD)) AS indirect
 ,  ((VDi/V)*sd)/(VDi*(1-SDD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,9,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'VDi' AS VDi,'V' AS V,'sd' AS sd,'SDD' AS SDD,'LD' AS LD,'HCi' AS HCi,'NDDi' AS NDDi,'NDi' AS NDi,'VCi'
AS VCi,'Vi' AS Vi )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
 COMMIT;
-- ******************************************************
 INSERT INTO TBL_COM_RESULT (
 EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,((VSi/V)*sd)/(VSi*(1-SSD-LD))  AS direct
 ,((HCi*(NSDi/NDi)+VCi*(VSi/Vi))/(VSi*(1-SSD-LD))) AS indirect
 , ((HCi*(NSDi/NDi)+VCi*(VSi/Vi))/(VSi*(1-SSD-LD))) + ((VSi/V)*sd)/(VSi*(1-SSD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,8,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'VSi' AS VSi,'V' AS V,'sd' AS sd,'SSD' AS SSD,'LD' AS LD,'HCi' AS HCi,'NSDi' AS NSDi,'NDi' AS NDi,'VCi' AS VCi,'Vi' AS Vi )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
 
 COMMIT;
--*************************************************************type = 7 

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(TDCI-(VTI/VI)*SD1)/(VTI*(1-STD-LD))  AS direct
 ,(HCI*(NTDi/NDI)+VCI*(VTI/VI))/(VTI*(1-STD-LD)) AS indirect
 , (TDCI-(VTI/VI)*SD1)/(VTI*(1-STD-LD)) +  (HCI*(NTDI/NDI)+VCI*(VTI/VI))/(VTI*(1-STD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,7,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'TDCi' AS TDCI,'VTi' AS VTI,'sd' AS SD1,'Vi' AS VI,'LD' AS LD,'STD' AS STD,'HCi' AS HCI,'NTDi' AS NTDI,'VCi' AS VCI,'NDI' as NDI
   )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;

--=========================================type = 71


INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SPSBSH -(MSBSH /VI ) *SD1 )/(MSBSH *(1 -NSGHSBMB -LD ))  AS direct
 ,(HCI *(TASSBSH/NDI)+VCI *(MSBSH/VI))/(MSBSH*( 1-NSGHSBMB -LD )) AS indirect
 , (SPSBSH -(MSBSH /VI ) *SD1 )/(MSBSH *(1 -NSGHSBMB -LD )) + (HCI *(TASSBSH/NDI)+VCI *(MSBSH/VI))/(MSBSH*( 1-NSGHSBMB -LD )) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,71,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'TDCi' AS TDCI,'VTi' AS VTI,'sd' AS SD1,'Vi' AS VI,'LD' AS LD,'STD' AS STD,'HCi' AS HCI,'NTDi' AS NTDI,'VCi' AS VCI,'NDI' as NDI,'SPSBSH' as SPSBSH
   ,'MSBSH' as MSBSH,'NSGHSBMB' as NSGHSBMB,'TASSBSH' as TASSBSH
   )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;







--============================================type = 72


INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SPSKSH-(MSKSH /VI)*SD1)/(MSKSH*(1-NSGHSKMB -LD))  AS direct
 ,(HCI*(TASSSKSH/NDI)+VCI*(MSKSH/VI))/(MSKSH*(1-NSGHSKMB-LD)) AS indirect
 , (SPSKSH-(MSKSH /VI)*SD1)/(MSKSH*(1-NSGHSKMB -LD)) +  (HCI*(TASSSKSH/NDI)+VCI*(MSKSH/VI))/(MSKSH*(1-NSGHSKMB-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,72,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'TDCi' AS TDCI,'VTi' AS VTI,'sd' AS SD1,'Vi' AS VI,'LD' AS LD,'STD' AS STD,'HCi' AS HCI,'NTDi' AS NTDI,'VCi' AS VCI,'NDI' as NDI
   ,'SPSKSH' as SPSKSH,'MSKSH' as MSKSH, 'NSGHSKMB' as NSGHSKMB,'TASSSKSH' as TASSSKSH
   )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
















--*************************************************************
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(Dci-sd1*(Vi/V))/(Vi*(1-SD-LD))  AS direct
 ,(HrCi+RCi+Dpi+Eci+Ici+EECi+OCi+Mci+NPLCi+FCi)/(Vi*(1-SD-LD))  AS indirect
 , (Dci-sd1*(Vi/V))/(Vi*(1-SD-LD)) +  (HrCi+RCi+Dpi+Eci+Ici+EECi+OCi+Mci+NPLCi+FCi)/(Vi*(1-SD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,6,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'Dci' AS Dci,'sd' AS sd1,'Vi' AS Vi,'V' AS V,'SD' AS SD,'LD' AS LD,'HrCi' AS HrCi,'RCi' AS RCi,'Dpi' AS Dpi,'Eci' as Eci
  ,'Ici' AS Ici,'EECi' AS EECi,'OCi' AS OCi,'Mci' as Mci,'NPLCi' AS NPLCi,'FCi' AS FCi  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
  COMMIT;
 -- ************************************************************
 

--============================================================================================
/*
--====================================================================================type = 2 
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(TDC-(VT/V)*SD1)/(VS*(1-SSD-LD)) AS direct
 ,(HC*(NTD/ND)+VC*(VT/V))/(VT*(1-STD-LD)) AS indirect
 , ((TDC-(VT/V)*SD1)/(VS*(1-SSD-LD))+(HC*(NTD/ND)+VC*(VT/V))/(VT*(1-STD-LD))) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '2' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'TDC' AS TDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
--=================================================================================================
*/
/*
--====================================================================================type = 3

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SDC-(VS/V)*SD1)/(VS*(1-SSD-LD))AS direct
 ,(HC*(NSD/ND)+VC*(VS/V))/(VS*(1-SSD-LD)) AS indirect
 , (SDC-(VS/V)*SD1)/(VS*(1-SSD-LD))+(HC*(NSD/ND)+VC*(VS/V))/(VS*(1-SSD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '3' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'SDC' AS SDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;


COMMIT;
--=========================================================================================
*/
/*
--=======================================================================type = 4
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(ODC-(VO/V)*SD1)/(VO*(1-SOD-LD)) AS direct
 ,(HC*(NOD/ND)+VC*(VO/V))/(VO*(1-SOD-LD)) AS indirect
 , (ODC-(VO/V)*SD1)/(VO*(1-SOD-LD))+(HC*(NOD/ND)+VC*(VO/V))/(VO*(1-SOD-LD))  TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '4' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'ODC' AS ODC,'VO' AS VO,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SOD' as SOD, 'NOD' as NOD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;

COMMIT;
--==============================================================================
*/
/*
--========================================================================type = 5

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,((VD/V)*SD1)/(VD*(1-SDD-LD)) AS direct
 , (HC*(NDD/ND)+VC*(VD/V))/(VD*(1-SDD-LD)) AS indirect
 , ((VD/V)*SD1)/(VD*(1-SDD-LD))-(HC*(NDD/ND)+VC*(VD/V))/(VD*(1-SDD-LD))  TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '5' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'ODC' AS ODC,'VO' AS VO,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SOD' as SOD, 'NOD' as NOD,'SDD' as SDD,'NDD' as NDD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
--=============================================================================
*/
--====================================================================================type = 11

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SPBB-(MTBB/V)*SD1)/(MTBB*(1-SSD-LD)) AS direct
 ,1000 AS indirect
 , 1000 TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '11' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'SDC' AS SDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SPBB' as SPBB, 'MTBB' as MTBB
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;


COMMIT;
--=========================================================================================

--====================================================================================type = 12

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SPBM-(MTBM/V)*SD1)/(MTBM*(1-SSD-LD)) AS direct
 ,1000 AS indirect
 , 1000 TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '12' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'SDC' AS SDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SPBM' as SPBM, 'MTBM' as MTBM
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;


COMMIT;
--=========================================================================================



END LOOP;

FOR I IN 335..365 LOOP

INSERT INTO TBL_COM_RESULT (
EFF_DATE ,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(ODCi-(VOi/Vi)*sd)/(VTi*(1-SOD-LD)) AS direct
 ,(HCi*(NODi/NDi)+VCi*(VOi/Vi))/(VOi*(1-SOD-LD)) AS indirect
 , (ODCi-(VOi/Vi)*sd)/(VTi*(1-SOD-LD)) + (HCi*(NODi/NDi)+VCi*(VOi/Vi))/(VOi*(1-SOD-LD))  TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,10,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'ODCi' AS ODCi,'VOi' AS VOi,'Vi' AS Vi,'sd' AS sd,'VTi' AS VTi,'SOD' AS SOD,'LD' AS LD,'IC' AS IC,'HCi' AS HCi,'NODi' AS NODi,'NDi' AS NDi,'VCi'
AS VCi )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;  
 --*********************************************************

 
  INSERT INTO TBL_COM_RESULT (
  EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
 
  ,(HCi*(NDDi/NDi)+VCi*(VDi/Vi))/(VDi*(1-SDD-LD)) - ((VDi/V)*sd)/(VDi*(1-SDD-LD)) AS direct
 ,(HCi*(NDDi/NDi)+VCi*(VDi/Vi))/(VDi*(1-SDD-LD)) AS indirect
 ,  ((VDi/V)*sd)/(VDi*(1-SDD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,9,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'VDi' AS VDi,'V' AS V,'sd' AS sd,'SDD' AS SDD,'LD' AS LD,'HCi' AS HCi,'NDDi' AS NDDi,'NDi' AS NDi,'VCi'
AS VCi,'Vi' AS Vi )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
 COMMIT;
-- ******************************************************
 INSERT INTO TBL_COM_RESULT (
 EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,((VSi/V)*sd)/(VSi*(1-SSD-LD))  AS direct
 ,((HCi*(NSDi/NDi)+VCi*(VSi/Vi))/(VSi*(1-SSD-LD))) AS indirect
 , ((HCi*(NSDi/NDi)+VCi*(VSi/Vi))/(VSi*(1-SSD-LD))) + ((VSi/V)*sd)/(VSi*(1-SSD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,8,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'VSi' AS VSi,'V' AS V,'sd' AS sd,'SSD' AS SSD,'LD' AS LD,'HCi' AS HCi,'NSDi' AS NSDi,'NDi' AS NDi,'VCi' AS VCi,'Vi' AS Vi )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
 
 COMMIT;
--************************************************************* type = 7

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(TDCI-(VTI/VI)*SD1)/(VTI*(1-STD-LD))  AS direct
 ,(HCI*(NTDi/NDI)+VCI*(VTI/VI))/(VTI*(1-STD-LD)) AS indirect
 , (TDCI-(VTI/VI)*SD1)/(VTI*(1-STD-LD)) +  (HCI*(NTDI/NDI)+VCI*(VTI/VI))/(VTI*(1-STD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,7,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'TDCi' AS TDCI,'VTi' AS VTI,'sd' AS SD1,'Vi' AS VI,'LD' AS LD,'STD' AS STD,'HCi' AS HCI,'NTDi' AS NTDI,'VCi' AS VCI,'NDI' as NDI
   )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
--=========================================type = 71


INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SPSBSH -(MSBSH /VI ) *SD1 )/(MSBSH *(1 -NSGHSBMB -LD ))  AS direct
 ,(HCI *(TASSBSH/NDI)+VCI *(MSBSH/VI))/(MSBSH*( 1-NSGHSBMB -LD )) AS indirect
 , (SPSBSH -(MSBSH /VI ) *SD1 )/(MSBSH *(1 -NSGHSBMB -LD )) + (HCI *(TASSBSH/NDI)+VCI *(MSBSH/VI))/(MSBSH*( 1-NSGHSBMB -LD )) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,71,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'TDCi' AS TDCI,'VTi' AS VTI,'sd' AS SD1,'Vi' AS VI,'LD' AS LD,'STD' AS STD,'HCi' AS HCI,'NTDi' AS NTDI,'VCi' AS VCI,'NDI' as NDI,'SPSBSH' as SPSBSH
   ,'MSBSH' as MSBSH,'NSGHSBMB' as NSGHSBMB,'TASSBSH' as TASSBSH
   )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;







--============================================type = 72


INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SPSKSH-(MSKSH /VI)*SD1)/(MSKSH*(1-NSGHSKMB -LD))  AS direct
 ,(HCI*(TASSSKSH/NDI)+VCI*(MSKSH/VI))/(MSKSH*(1-NSGHSKMB-LD)) AS indirect
 , (SPSKSH-(MSKSH /VI)*SD1)/(MSKSH*(1-NSGHSKMB -LD)) +  (HCI*(TASSSKSH/NDI)+VCI*(MSKSH/VI))/(MSKSH*(1-NSGHSKMB-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,72,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'TDCi' AS TDCI,'VTi' AS VTI,'sd' AS SD1,'Vi' AS VI,'LD' AS LD,'STD' AS STD,'HCi' AS HCI,'NTDi' AS NTDI,'VCi' AS VCI,'NDI' as NDI
   ,'SPSKSH' as SPSKSH,'MSKSH' as MSKSH, 'NSGHSKMB' as NSGHSKMB,'TASSSKSH' as TASSSKSH
   )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;







--*************************************************************
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(Dci-sd1*(Vi/V))/(Vi*(1-SD-LD))  AS direct
 ,(HrCi+RCi+Dpi+Eci+Ici+EECi+OCi+Mci+NPLCi+FCi)/(Vi*(1-SD-LD))  AS indirect
 , (Dci-sd1*(Vi/V))/(Vi*(1-SD-LD)) +  (HrCi+RCi+Dpi+Eci+Ici+EECi+OCi+Mci+NPLCi+FCi)/(Vi*(1-SD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 ,6,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'Dci' AS Dci,'sd' AS sd1,'Vi' AS Vi,'V' AS V,'SD' AS SD,'LD' AS LD,'HrCi' AS HrCi,'RCi' AS RCi,'Dpi' AS Dpi,'Eci' as Eci
  ,'Ici' AS Ici,'EECi' AS EECi,'OCi' AS OCi,'Mci' as Mci,'NPLCi' AS NPLCi,'FCi' AS FCi  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
  COMMIT;
 -- ************************************************************
  --================================================================ type = 1
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(DC-SD1)/(V*(1-SD-LD)) AS direct
 ,(OC+CC+FC+NPLC)/(V*(1-SD-LD)) AS indirect
 , ((DC-SD1)/(V*(1-SD-LD))+(OC+CC+FC+NPLC)/(V*(1-SD-LD))) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '1' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'DC' AS DC,'sd' AS SD1,'V' AS V,'SD' AS SD, 'LD' as LD, 'OC' as OC, 'CC' as CC
   ,'FC' as FC,'NPLC' as NPLC
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
--============================================================================================
/*
--====================================================================================type = 2 
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(TDC-(VT/V)*SD1)/(VS*(1-SSD-LD)) AS direct
 ,(HC*(NTD/ND)+VC*(VT/V))/(VT*(1-STD-LD)) AS indirect
 , ((TDC-(VT/V)*SD1)/(VS*(1-SSD-LD))+(HC*(NTD/ND)+VC*(VT/V))/(VT*(1-STD-LD))) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '2' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'TDC' AS TDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
--=================================================================================================
*/
/*
--====================================================================================type = 3

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SDC-(VS/V)*SD1)/(VS*(1-SSD-LD))AS direct
 ,(HC*(NSD/ND)+VC*(VS/V))/(VS*(1-SSD-LD)) AS indirect
 , (SDC-(VS/V)*SD1)/(VS*(1-SSD-LD))+(HC*(NSD/ND)+VC*(VS/V))/(VS*(1-SSD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '3' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'SDC' AS SDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;


COMMIT;
--=========================================================================================
*/
/*
--=======================================================================type = 4
INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(ODC-(VO/V)*SD1)/(VO*(1-SOD-LD)) AS direct
 ,(HC*(NOD/ND)+VC*(VO/V))/(VO*(1-SOD-LD)) AS indirect
 , (ODC-(VO/V)*SD1)/(VO*(1-SOD-LD))+(HC*(NOD/ND)+VC*(VO/V))/(VO*(1-SOD-LD))  TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '4' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'ODC' AS ODC,'VO' AS VO,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SOD' as SOD, 'NOD' as NOD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;

COMMIT;
--==============================================================================
*/
/*
--========================================================================type = 5

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH

  , ((VD/V)*SD1)/(VD*(1-SDD-LD))-(HC*(NDD/ND)+VC*(VD/V))/(VD*(1-SDD-LD))  AS direct
 , (HC*(NDD/ND)+VC*(VD/V))/(VD*(1-SDD-LD)) AS indirect
 ,  ((VD/V)*SD1)/(VD*(1-SDD-LD)) TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '5' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'ODC' AS ODC,'VO' AS VO,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SOD' as SOD, 'NOD' as NOD,'SDD' as SDD,'NDD' as NDD
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;
COMMIT;
*/
--=========================================================================
--====================================================================================type = 11

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SPBB-(MTBB/V)*SD1)/(MTBB*(1-SSD-LD)) AS direct
 ,1000 AS indirect
 , 1000 TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '11' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'SDC' AS SDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SPBB' as SPBB, 'MTBB' as MTBB
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;


COMMIT;
--=========================================================================================

--====================================================================================type = 12

INSERT INTO TBL_COM_RESULT ( EFF_DATE,
 CHILD
  ,direct
 ,indirect
 ,TOTAL
 ,DEPTH
 ,PARENT
 ,NAME
 ,type,BALANCE
 ) SELECT to_date(VAR_DATE,'DD-MM-YYYY') -I,
 100000 || REF_BRANCH AS REF_BRANCH
  ,(SPBM-(MTBM/V)*SD1)/(MTBM*(1-SSD-LD)) AS direct
 ,1000 AS indirect
 , 1000 TOTAL
 ,3 AS DEPTH
 ,TB.REF_STA_ID
 ,TB.NAME
 , '12' as type,
  (SELECT balance
  FROM tbl_ledger_branch
  WHERE TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -i
  AND LEDGER_CODE                      =10611011101
  AND tbl_ledger_branch.REF_BRANCH     = tb.BRN_ID
  ) AS BALANCE
 FROM (
  SELECT
   TBL_COM_VALUE.REF_BRANCH
   ,TBL_COM_VALUE.TITLE
  ,TBL_COM_VALUE.VALUE
   FROM TBL_COM_VALUE where TO_DATE(EFF_DATE,'DD-MM-YYYY') =to_date(VAR_DATE,'DD-MM-YYYY') -I
  
 )
  PIVOT ( MAX ( VALUE )
   FOR TITLE
   IN ( 'SDC' AS SDC,'VT' AS VT,'V' AS V, 'sd' as SD1, 'VS' as VS, 'SSD' as SSD
   ,'LD' as LD,'HC' as HC, 'NTD' as NTD,'ND' as ND,'VC' as VC,'VD' as VD,'STD' as STD,
   'NSD' as NSD, 'SPBM' as SPBM, 'MTBM' as MTBM
  )
  )
 ,    TBL_BRANCH TB
WHERE TB.BRN_ID   = REF_BRANCH;


COMMIT;
--=========================================================================================





END LOOP;




END;
--------------------------------------------------------
--  DDL for Procedure PRC_NOTIF_CHECK_REPEAT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_NOTIF_CHECK_REPEAT" ( INPAR_REPORT IN NUMBER )  AS

 VAR_REF_LEDGER_PROFILE     NUMBER;
 VAR_REF_PROFILE_TIME       NUMBER;
 VAR_REF_PROFILE_CURRENCY   NUMBER;
 VAR_REF_PROFILE_CUSTOMER   NUMBER;
 VAR_REF_PROFILE_BRANCH     NUMBER;
 VAR_REF_PROFILE_DEPOSIT    NUMBER;
 VAR_REF_PROFILE_LOAN       NUMBER;
 REF_LEDGER_PROFILE_NEW     NUMBER;
 REF_PROFILE_TIME_NEW       NUMBER;
 REF_PROFILE_CURRENCY_NEW   NUMBER;
 REF_PROFILE_CUSTOMER_NEW   NUMBER;
 REF_PROFILE_BRANCH_NEW     NUMBER;
 REF_PROFILE_DEPOSIT_NEW    NUMBER;
 REF_PROFILE_LOAN_NEW       NUMBER;
 var_count   number;
  
--pragma autonomous_transaction;
BEGIN
 SELECT
  REF_LEDGER_PROFILE
 ,REF_PROFILE_TIME
 ,REF_PROFILE_CURRENCY
 ,REF_PROFILE_CUSTOMER
 ,REF_PROFILE_BRANCH
 ,REF_PROFILE_DEPOSIT
 ,REF_PROFILE_LOAN
 INTO
  VAR_REF_LEDGER_PROFILE,VAR_REF_PROFILE_TIME,VAR_REF_PROFILE_CURRENCY,VAR_REF_PROFILE_CUSTOMER,VAR_REF_PROFILE_BRANCH,VAR_REF_PROFILE_DEPOSIT
,VAR_REF_PROFILE_LOAN
 FROM TBL_REPORT_PROFILE where REF_REPORT =INPAR_REPORT;



SELECT
    count(ID) into var_count
   FROM TBL_REPREQ
   WHERE TBL_REPREQ.REF_REPORT_ID   in (select id from tbl_report where h_id = ( select h_id from tbl_report where id = INPAR_REPORT));

if(var_count <> 0)
then
 SELECT
  REF_LEDGER_PROFILE
 ,REF_PROFILE_TIME
 ,REF_PROFILE_CURRENCY
 ,REF_PROFILE_CUSTOMER
 ,REF_PROFILE_BRANCH
 ,REF_PROFILE_DEPOSIT
 ,REF_PROFILE_LOAN
 INTO
  REF_LEDGER_PROFILE_NEW,REF_PROFILE_TIME_NEW,REF_PROFILE_CURRENCY_NEW,REF_PROFILE_CUSTOMER_NEW,REF_PROFILE_BRANCH_NEW,REF_PROFILE_DEPOSIT_NEW
,REF_PROFILE_LOAN_NEW
 FROM TBL_REPREQ
 WHERE ID                         = (
   SELECT
    MAX(ID)
   FROM TBL_REPREQ
   WHERE TBL_REPREQ.REF_REPORT_ID   in (select id from tbl_report where h_id = ( select h_id from tbl_report where id = INPAR_REPORT))
  )
  and trunc(REQ_DATE) = trunc(sysdate);
else

select 0,0,0,0,0,0,0
INTO
  REF_LEDGER_PROFILE_NEW,REF_PROFILE_TIME_NEW,REF_PROFILE_CURRENCY_NEW,REF_PROFILE_CUSTOMER_NEW,REF_PROFILE_BRANCH_NEW,REF_PROFILE_DEPOSIT_NEW
,REF_PROFILE_LOAN_NEW
from dual;




end if;
 IF
  ( VAR_REF_LEDGER_PROFILE <> REF_LEDGER_PROFILE_NEW OR VAR_REF_PROFILE_TIME <> REF_PROFILE_TIME_NEW OR VAR_REF_PROFILE_CURRENCY <> REF_PROFILE_CURRENCY_NEW
OR VAR_REF_PROFILE_CUSTOMER <> REF_PROFILE_CUSTOMER_NEW OR VAR_REF_PROFILE_BRANCH <> REF_PROFILE_BRANCH_NEW OR VAR_REF_PROFILE_DEPOSIT <> REF_PROFILE_DEPOSIT_NEW
OR VAR_REF_PROFILE_LOAN <> REF_PROFILE_LOAN_NEW )
 THEN
  update TBL_NOTIFICATIONS set FLAG =1;
 
 END IF;

END prc_NOTIF_CHECK_REPEAT;
--------------------------------------------------------
--  DDL for Procedure PRC_NOTIF_DAILY_DELETE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_NOTIF_DAILY_DELETE" as 
begin


--EXECUTE IMMEDIATE  'truncate table TBL_NOTIFICATIONS_TEMP';

INSERT INTO TBL_NOTIFICATIONS_TEMP (
 ID
 ,TITLE
 ,TYPE
 ,REF_USER
 ,START_TIME
 ,END_TIME
 ,STATUS
 ,DESCRIPTION
 ,OPT_TYPE
 ,REF_REPORT
 ,REF_REPREQ
 ,REF_REPPER_DATE
 ,CLASS
 ,ERROR
 ,FLAG
)
SELECT
 ID
 ,TITLE
 ,TYPE
 ,REF_USER
 ,START_TIME
 ,END_TIME
 ,STATUS
 ,DESCRIPTION
 ,OPT_TYPE
 ,REF_REPORT
 ,REF_REPREQ
 ,REF_REPPER_DATE
 ,CLASS
 ,ERROR
 ,FLAG
FROM TBL_NOTIFICATIONS;
commit;
  delete 
  from TBL_NOTIFICATIONS
  where trunc(END_TIME) <> trunc(sysdate)
  and upper(status) = 'VISITED';
  commit;
end prc_notif_daily_delete;
--------------------------------------------------------
--  DDL for Procedure PRC_TEST_DELAY2
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_TEST_DELAY2" (IN_TIME in number) AS 

  

v_now DATE;
begin
-- 1) Get the date & time 
SELECT SYSDATE 
  INTO v_now
  FROM DUAL;

-- 2) Loop until the original timestamp plus the amount of seconds <= current date
LOOP
  EXIT WHEN v_now + (IN_TIME * (1/86400)) <= SYSDATE;
END LOOP;

END PRC_TEST_DELAY2;
--------------------------------------------------------
--  DDL for Procedure TEST_LOCK2
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."TEST_LOCK2" (inpar_num in number) AS 

l_status number;
    l_lock_handle varchar2(128);
    l_lock_request integer;
BEGIN



 DBMS_LOCK.ALLOCATE_UNIQUE ( lockname =>  'xx', lockhandle => l_lock_handle);
    l_status := DBMS_LOCK.REQUEST(lockhandle => l_lock_handle, timeout => 15);
   if (l_status = 0) then
      -- Plase your code here
        update ZTEST_LOCK
  set value = 1;
  commit;
      -- Only one thread can work here
      l_lock_request  := DBMS_LOCK.release(l_lock_handle);
  
    
else
 DBMS_LOCK.ALLOCATE_UNIQUE ( lockname =>  'yy', lockhandle => l_lock_handle);
    l_status := DBMS_LOCK.REQUEST(lockhandle => l_lock_handle, timeout => 15);
 update ZTEST_LOCK
  set value = 22222222
  where value = 1;
  commit;
  l_lock_request  := DBMS_LOCK.release(l_lock_handle);
end if;


END TEST_LOCK2;
--------------------------------------------------------
--  DDL for Procedure TEST_LOCK
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."TEST_LOCK" AS 
l_status number;
    l_lock_handle varchar2(128);
    l_lock_request integer;
BEGIN

--
--
-- DBMS_LOCK.ALLOCATE_UNIQUE ( lockname =>  'NAME_OF_YOUR_LOCK', lockhandle => l_lock_handle);
--    l_status := DBMS_LOCK.REQUEST(lockhandle => l_lock_handle, timeout => 15);
--    if (l_status = 0) then
--      -- Plase your code here
--   update ZTEST_LOCK
--  set value = 22222222
--  where value = 11111111;
--  commit;
--      -- Only one thread can work here
--      l_lock_request  := DBMS_LOCK.release(l_lock_handle);
--  
--    end if;


 update ZTEST_LOCK
  set value = 22222222
  where value = 11111111;
  commit;

END TEST_LOCK;
--------------------------------------------------------
--  DDL for Procedure PRC_LOG
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."PRC_LOG" (
/*
  Programmer Name: MYM
  Release Date/Time: 1397/03/05
  Version: 1.0
  Category: 2
  Description: POR KARDAN JADVAL LOG V DETAIL
  */
    INPAR_NAM       IN VARCHAR2,
    INPAR_MEGHDAR   IN VARCHAR2,
    INPAR_SCHEMA    IN VARCHAR2,
    INPAR_PROCEDURE IN VARCHAR2,
    INPAR_SHOMARE_KHAT    IN NUMBER,
    INPAR_PARAMETR IN NUMBER)
IS
  LOC_NAM_FARSI VARCHAR2(200);
  LOC_AKHARIN_LOG NUMBER;
BEGIN
  LOC_NAM_FARSI :=
  CASE
    WHEN INPAR_NAM LIKE 'NEGASHT_TIME' THEN 'زمان اجراي نگاشت '|| INPAR_PARAMETR
    WHEN INPAR_NAM LIKE 'NEGASHT_CNT' THEN 'تعداد سطرهاي نگاشت '|| INPAR_PARAMETR
    
    WHEN INPAR_NAM LIKE 'DEP_CNT' THEN    'تعداد سپرده‌ها'
    WHEN INPAR_NAM LIKE 'DEP_TIME' THEN 'زمان انتقال سپرده'
    WHEN INPAR_NAM LIKE 'DEP_IGN_CNT' THEN    'تعداد سپرده معيوب'
    WHEN INPAR_NAM LIKE 'DEP_ACC_CNT' THEN  'تعداد حسابداري سپرده'
    WHEN INPAR_NAM LIKE 'DEP_ACC_TIME' THEN 'زمان انتقال حسابداري سپرده'
    
    WHEN INPAR_NAM LIKE 'LOAN_CNT' THEN    'تعداد تسهيلات'
    WHEN INPAR_NAM LIKE 'LOAN_TIME' THEN 'زمان انتقال تسهيلات'
    WHEN INPAR_NAM LIKE 'LOAN_IGN_CNT' THEN    'تعداد تسهيلات معيوب'
    WHEN INPAR_NAM LIKE 'LOAN_ACC_CNT' THEN    'تعداد تسهيلات'
    WHEN INPAR_NAM LIKE 'LOAN_ACC_TIME' THEN 'زمان انتقال حسابداري تسهيلات'
    
    WHEN INPAR_NAM LIKE 'PAY_CNT' THEN    'تعداد اقساط'
    WHEN INPAR_NAM LIKE 'PAY_TIME' THEN 'زمان انتقال اقساط'
    WHEN INPAR_NAM LIKE 'PAY_IGN_CNT' THEN 'تعداد اقساط معيوب'
    
    WHEN INPAR_NAM LIKE 'EXP_CODE' THEN 'کد خطا'
    WHEN INPAR_NAM LIKE 'EXP_MSG' THEN 'پيام خطا'
    WHEN INPAR_NAM LIKE 'EXP_TRC' THEN 'پيگرد خطا'
  END;
     SELECT MAX(ID) INTO LOC_AKHARIN_LOG FROM TBL_LOG;
    INSERT INTO TBL_LOG_DETAIL(REF_LOG, NAM, NAM_FARSI, MEGHDAR, SCHEMA, SHOMARE_KHAT, PROCEDURE )
      VALUES (LOC_AKHARIN_LOG, INPAR_NAM, LOC_NAM_FARSI, INPAR_MEGHDAR, INPAR_SCHEMA, INPAR_SHOMARE_KHAT, INPAR_PROCEDURE );

  END;
--------------------------------------------------------
--  DDL for Procedure TEST_GAP_NIIM
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "PRAGG"."TEST_GAP_NIIM" AS
 VAR_DATE   DATE;
 VAR_MAX    DATE;
BEGIN
 SELECT
  MAX(TRUNC(DUE_DATE) )
 INTO
  VAR_MAX
 FROM TBL_VALUE_temp;

 VAR_DATE   := SYSDATE;
 
 LOOP
  INSERT INTO TBL_GAP_NIIM_VALUE ( TYPE,GAP_RATE,EFF_DATE ) ( SELECT
   ID
  ,RATE
  ,DT
  FROM (
    SELECT
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
    SELECT
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

END TEST_GAP_NIIM;
