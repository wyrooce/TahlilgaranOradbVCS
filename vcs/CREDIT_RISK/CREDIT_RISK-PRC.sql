--------------------------------------------------------
--  DDL for Procedure PRC_INTEGERATE_INPUT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_INTEGERATE_INPUT" (
  run_date IN date 
) 
AS
BEGIN
  /*
  Programmer Name: RASOOL & MORTEZA.SA
  Release Date/Time:1395/05/20-17:00
  Version: 1.0
  Category:2
  Description: enteghal be jadavel CREDIT_RISK
  */
  EXECUTE IMMEDIATE 'ALTER SESSION FORCE PARALLEL DML';
  --// pak kardan jadavel ID
  EXECUTE IMMEDIATE 'truncate table credit_risk.TBL_PAYMENT';
 -- EXECUTE IMMEDIATE 'truncate table credit_risk.TBL_BRANCH';
  EXECUTE IMMEDIATE 'truncate table credit_risk.TBL_CUSTOMER';
  EXECUTE IMMEDIATE 'truncate table credit_risk.TBL_COLLATERAL';
  EXECUTE IMMEDIATE 'truncate table credit_risk.TBL_GUARANTEE';
  EXECUTE IMMEDIATE 'truncate table credit_risk.TBL_navix';
  EXECUTE IMMEDIATE 'truncate table credit_risk.TBL_LOAN';
  --\\
  --//por kardan jadval aghsat---------------------------------------------------------------------------------
  INSERT
    /*+  PARALLEL(auto) */
  INTO TBL_PAYMENT
    (
      REF_TASHILAT,
      SHOMARE_PARDAKHT,
      MABLAGH_ASL,
      SUD_MOSTATER,
      MABLAGH_GHEST_DARYAFT_SHODE,
      TARIKH_SARRESID,
      TARIKH_DARYAFT
    )
SELECT P.abrnchcod
    || P.lnminortp
    || P.cfcifno
    || P.crserial AS tashilat,
    P.PAY_NUMBER,
    P.PAY_AMOUNT-P.PAY_PROFIT,
    P.PAY_PROFIT,
    P.REAL_PAY_AMOUNT,
   P.PAY_DATE,
  P.REAL_PAY_DATE 
  FROM DADEKAVAN_DAY.PAYMENT P;
  COMMIT;
  --\\
  --//por kardan jadval vasighe--------------------------------------------------------------------------------
  INSERT
    /*+  PARALLEL(auto) */
  INTO CREDIT_RISK.TBL_COLLATERAL
    (
      ID,
      ARZESH_VASIGHE,
      COD_NOE_VASIGHE,
      NAM_NOE_VASIGHE,
      REF_MOSHTARI,
      ARZESH_ARZYABI_SHODE,
      ZARIB_NAGHDINEGI,
      REF_TASHILAT
    )
  SELECT DADEKAVAN_DAY.ETELAAT_VASIGHE."شماره وثيقه ",
    DADEKAVAN_DAY.ETELAAT_VASIGHE."ارزش ارزيابي وثيقه",
    DADEKAVAN_DAY.ETELAAT_VASIGHE."کد نوع وثيقه ",
    DADEKAVAN_DAY.ETELAAT_VASIGHE." نوع وثيقه",
    DADEKAVAN_DAY.ETELAAT_VASIGHE."شماره مشتري ",
    DADEKAVAN_DAY.ETELAAT_VASIGHE."ارزش ارزيابي وثيقه",
    case when  TS.ZARIB_NAGHD_SHAVANDEGI is null then '1' else  TS.ZARIB_NAGHD_SHAVANDEGI end as ZARIB_NAGHD_SHAVANDEGI  ,
    REPLACE(vt."کد تسهيلات",'.')
  FROM DADEKAVAN_DAY.ETELAAT_VASIGHE
  LEFT JOIN CREDIT_RISK.TBL_COLLATERAL_SETTING TS
  ON DADEKAVAN_DAY.ETELAAT_VASIGHE."کد نوع وثيقه " = TS.REF_NOE_VASIGHE
  JOIN dadekavan_day.VASIGHE_TASHILAT vt
  ON vt."کد وثيقه" = DADEKAVAN_DAY.ETELAAT_VASIGHE."شماره وثيقه " ;
  COMMIT;
  --\\
  --//por kardan jadval tashilat---------------------------------------------------------------------------------
  INSERT
    /*+  PARALLEL(auto) */
  INTO TBL_LOAN
    (
      ID,
      COD_NOE_TASHILAT,
      NAM_NOE_TASHILAT,
      REF_SHOBE,
      TARIKH_TASHKIL,
      TARIKH_SARREDID,
      COD_BAKHSH_EGHTESADI,
      NAM_BAKHSH_EGHTESADI,
      MABLAGH_MOSAVVAB,
      ARZ,
      NERKH_SUD,
      COD_NAHVE_BAZ_PARDAKHT,
      -- NAM_NAHVE_BAZ_PARDAKHT,
      REF_MOSHTARI,
      MANDE_ASL_VAM,
      MANDE_SARRESID_GOZASHTE,
      MANDE_MASHKUKOLVOSUL,
      MANDE_MOAVVAGH,
      VAZIAT,
      TEDAD_AGHSAT,
      MANDE_KOL_VAM
    )
  SELECT L.abrnchcod
    || L.lnminortp
    || L.cfcifno
    || L.crserial AS tashilat,
    SUBSTR(l.PRODUCTTYPECODE,3,3),
     case when NT.TITLE is not null then NT.TITLE  else u'\062a\0633\0647\064a\0644\0627\062a \0646\0648\0639 '||SUBSTR(l.PRODUCTTYPECODE,3,3) end,
    l.abrnchcod,
    l.crbgndt, 
      l.crenddt,
    SUBSTR(l.PRODUCTTYPECODE,6,1),
    REGEXP_SUBSTR(NT.TITLE, '[^/]+', 1,2),
    l.cracclim,
    l.acurrcode,
    l.prmainrt,
    l.CUST_BAZPARDAKHT_TYPE,
    l.cfcifno,
    l.MANDEH_ASL,
    l.MANDEH_SARRESIDGOZASHTE,
    l.MANDEH_MASHKOOK,
    l.MANDEH_MOAVAGH,
    l.state_endday,
    b.count_ghest,
    b.ghest_mande
  FROM DADEKAVAN_DAY.LOAN l
  JOIN
    (SELECT DISTINCT TYPE_CODE,TITLE FROM DADEKAVAN_DAY.NOE_TASHILAT
    ) nt
  ON SUBSTR(L.PRODUCTTYPECODE,3,4) =SUBSTR(NT.TYPE_CODE,3,4)
  JOIN
    (SELECT COUNT(P.PAY_DATE) AS count_ghest,
      SUM(p.PAY_AMOUNT+p.PAY_PROFIT)       AS ghest_mande,
      L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial AS tashilat
    FROM DADEKAVAN_DAY.PAYMENT p
    JOIN DADEKAVAN_DAY.LOAN l
    ON P.abrnchcod
      || P.lnminortp
      || P.cfcifno
      || P.crserial = L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial
    WHERE L.EFFDATE =trunc(run_date)
      and trunc(p.PAY_DATE) > trunc(run_date)
     and  SUBSTR(l.PRODUCTTYPECODE,0,3)<> 'L31'
     and L.STATE_ENDDAY                  = ANY('5','4','F','3')
    GROUP BY L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial
    )b ON L.abrnchcod
    || L.lnminortp
    || L.cfcifno
    || L.crserial = b.tashilat
  WHERE L.EFFDATE =trunc(run_date);
  COMMIT;
  --\\
  --//por kardan jadval moshtari-------------------------------------------------------------------------------
  INSERT
    /*+  PARALLEL(auto) */
  INTO TBL_CUSTOMER
    (
      id,
      NAM,
      REF_SHOBE,
      COD_MELLI,
      TARIKH_TAVVALOD,
      MAHIAT_MOSHTARI,
      TARIKH_SABT_MOSHTARI
    )
    
  SELECT CUSTOMERNO,
  FIRSTNAME
  ||' '
  || LASTNAME,
  BR_CODE,
  CASE
    WHEN LENGTH(TRIM(TRANSLATE(SSN, '0123456789',' '))) IS NULL
    THEN SSN
  END,
  BIRTH_DATE,
  CUSTOMERTYPE,
  REGIS_DATE
FROM DADEKAVAN_DAY.ETELAATE_MOSHTARI ;
  COMMIT;
  --\\
  --//por kardan jadval zemanat name-----------------------------------------------------------------------
  INSERT
    /*+  PARALLEL(auto) */
  INTO CREDIT_RISK.TBL_GUARANTEE
    (
      TARIKH_SARRESID,
      COD_NOE_ZEMANAT,
      NAM_NOE_ZEMANAT,
      MABLAGH,
      MOZUE_GHARARDAD,
      REF_MOSHTARI,
      ARZ,
      COD_BAKHSH_EGHTESADI,
      MAZMUN_LAH,
      REF_SHOBE,
      EMKAN_TAMDID,
      NAHVE_PARDAKHT
    )
 
    SELECT      "سر رسيد ضمان ",

    "کد نوع ضمانت نامه",
    " نام نوع ضمانت نامه",
    "مبلغ ضمان",
    " موضوع ضمان",
    "شماره مشتري ضمانت خواه",
    "نوع ارز",
    " کد بخش اقتصادي",
    "مضمون له ",
    " شعبه صادر کننده",
    CASE
      WHEN " امکان تمديد " ='غير قابل تمديد'
      THEN 0
      ELSE 1
    END,
    "نحوه پرداخت "
  FROM DADEKAVAN_DAY.ETELAAT_ZEMANATNAME;

  COMMIT;
  --\\
  --//por kardan jadval shobe----------------------------------------------------------------------------------
--  INSERT
--    /*+  PARALLEL(auto) */
--  INTO TBL_BRANCH
--    (
--      ID,
--      NAM,
--      COD_SHAHR,
--      NAM_SHAHR,
--      COD_OSTAN,
--      NAM_OSTAN
--    )
--  SELECT CODE,
--    BR_NAME,
--    SHAHR_CODE,
--    SHAHR_NAME,
--    OSTAN_CODE,
--    OSTAN_NAME
--  FROM DADEKAVAN_DAY.ETELAATE_SHOBE ;
--  COMMIT;
  --\\
END PRC_INTEGERATE_INPUT;
--------------------------------------------------------
--  DDL for Procedure PRC_GENERATE_CR
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_GENERATE_CR" 
AS
  M FLOAT;
  B FLOAT;
  K FLOAT;
  RWA FLOAT;
  R FLOAT;
BEGIN
  /*
  Programmer Name: RASOOL & morteza_SA
  Release Date/Time:1395/05/21-13:15
  Version: 1.0
  Category:2
  Description: mohasebe risk etebari
  */
  EXECUTE IMMEDIATE 'ALTER SESSION FORCE PARALLEL DML';
  --// pak kardan jadavel navix
  EXECUTE IMMEDIATE 'truncate table credit_risk.TBL_navix';
  FOR I IN
  ( SELECT DISTINCT TL.ID,
0||max(tpd.pd)  AS PD,-------------------????az code matlab bayad biad
  MAX(tl.mande_asl_vam) AS ead,
  CASE
    WHEN (1-((SUM(TC.ARZESH_VASIGHE)*max(TC.ZARIB_NAGHDINEGI))/ MAX(tl.MANDE_KOL_VAM+TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE)))<0
    THEN 0
    ELSE (1-((SUM(TC.ARZESH_VASIGHE)*max(TC.ZARIB_NAGHDINEGI))/ MAX(tl.MANDE_KOL_VAM+TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE)))
  END AS LGD,
  (max(tpd.pd) * MAX(tl.mande_asl_vam)*(
  CASE
    WHEN (1-((SUM(TC.ARZESH_VASIGHE)*max(TC.ZARIB_NAGHDINEGI))/ MAX(tl.MANDE_KOL_VAM+TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE)))<0
    THEN 0
    ELSE (1-((SUM(TC.ARZESH_VASIGHE)*max(TC.ZARIB_NAGHDINEGI))/ MAX(tl.MANDE_KOL_VAM+TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE)))
  END ) ) AS EL,
  CASE
    WHEN ( MAX(tl.MANDE_KOL_VAM+TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE)/(SUM(CASE WHEN TC.ARZESH_VASIGHE = 0 THEN '1' ELSE TC.ARZESH_VASIGHE END)*max(TC.ZARIB_NAGHDINEGI)))>1
    THEN 1
    ELSE( MAX(tl.MANDE_KOL_VAM+TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE)/(SUM(CASE WHEN TC.ARZESH_VASIGHE = 0 THEN '1' ELSE TC.ARZESH_VASIGHE END)*max(TC.ZARIB_NAGHDINEGI)))
  END                                            AS rr,
  MAX( C.CATEGORY_ID)                            AS CATEGORY_ID,
  ROUND(COUNT(DISTINCT TP.TARIKH_SARRESID)/12,2) AS M
FROM tbl_loan tl
JOIN TBL_COLLATERAL tc
ON TL.ID = TC.REF_TASHILAT
JOIN TBL_LOAN_CATEGORY c
ON C.type_id = TL.COD_NOE_TASHILAT
JOIN TBL_PAYMENT TP
ON TP.REF_TASHILAT       = TL.id
JOIN tbl_pd TPd
ON tpd.REF_TASHILAT       = TL.id
WHERE TP.TARIKH_DARYAFT IS NULL
GROUP BY tl.id
  )
  LOOP
  
    m  :=0;
    r  :=0;
    b  :=0;
    k  :=0;
    rwa:=0;
    IF (I.CATEGORY_ID IN (1,2,3)) THEN ------  sherkati & dolati & banki
      M                :=I.M;
      R                :=0.12          *(1-EXP(-50*I.PD))/(1-EXP(-50))+0.24 * (1-(1-EXP(-50*I.PD))/(1-EXP(-50)));
      B                :=power((0.11852-0.05478*LN(i.pd)),0.5);
      K                :=( (1          -I.rr) * FNC_NORMSDIST(POWER((1-R),(-0.5)) * FNC_NORMSINV(I.PD) + POWER((R/(1-R)),0.5) * FNC_NORMSINV(0.999))- I.PD * (1-I.RR))*(POWER((1-1.5*B),(-1))) * (1+(M-2.5)*B);
      RWA              := round(K,3)             *12.5 *I.EAD;
    ELSIF (I.CATEGORY_ID=4) THEN ------ manzele maskoni
      M                :=I.M;
      R                := 0.15;
      B                :=0;
      K                :=( (1-I.rr) * FNC_NORMSDIST(POWER((1-R),(-0.5)) * FNC_NORMSINV(I.PD) + POWER((R/(1-R)),0.5) * FNC_NORMSINV(0.999))- I.PD * (1-I.RR))*(POWER((1-1.5*B),(-1))) * (1+(M-2.5)*B);
      RWA              :=  round(K,3)       *12.5*I.EAD;
    ELSIF (I.CATEGORY_ID=5) THEN ------ tajdid shodani ba peyvaste
      M                :=I.M;
      R                := 0.04;
      B                :=0;
      K                :=( (1-I.rr) * FNC_NORMSDIST(POWER((1-R),(-0.5)) * FNC_NORMSINV(I.PD) + POWER((R/(1-R)),0.5) * FNC_NORMSINV(0.999))- I.PD * (1-I.RR))*(POWER((1-1.5*B),(-1))) * (1+(M-2.5)*B);
      RWA              :=  round(K,3)       *12.5*I.EAD;
    ELSIF (I.CATEGORY_ID=6) THEN ------sayer
      M                :=I.M;
      R                := 0.03 *( 1-EXP(-35 * I.PD))/(1-EXP(-35))+ 0.16 * (1-(1-EXP(-35 * I.PD))/(1-EXP(-35))) ;
      B                :=0;
      K                :=( (1-I.rr) * FNC_NORMSDIST(POWER((1-R),(-0.5)) * FNC_NORMSINV(I.PD) + POWER((R/(1-R)),0.5) * FNC_NORMSINV(0.999))- I.PD * (1-I.RR))*(POWER((1-1.5*B),(-1))) * (1+(M-2.5)*B);
      RWA              :=  round(K,3)       *12.5*I.EAD;
    END IF;
    INSERT INTO TBL_NAVIX
      ( REF_TASHILAT, PD, EAD, lgd, EL, RR, M, B, K, RWA, R
      )
    SELECT i.id,
      i.PD,
      i.EAD,
      i.lgd,
      round(i.EL,2),
      round(i.RR,2),
      M,
     round( B,9),
      round(K,3),
      round(CASE
        WHEN k<0
        THEN 0
        ELSE rwa
      END,9) ,
     round( R,9)
    FROM dual;
    COMMIT;
      END LOOP;
      -- INSERT BE JADVAL TBL_DAILY_IRB BARAYE NEGAH DASHTAN RWA,MIANGIN PD VA MIANGIN RR BE SORATE ROZANE
      INSERT INTO CREDIT_RISK.TBL_DAILY_IRB
  (RWA, DATE_REPORT,AVGPD,AVGHR)
sELECT SUM(RWA),TO_CHAR(trunc(SYSDATE),'yyyy-mm-dd','nls_calendar =persian'),'0'||round(avg(pd),3),'0'||round(avg(rr),3) FROM TBL_NAVIX  COMMIT;
END PRC_GENERATE_CR;
--------------------------------------------------------
--  DDL for Procedure PRC_INSERT_RETURN_ID
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_INSERT_RETURN_ID" (t_name   IN  VARCHAR2,
                                                             id_name  IN  VARCHAR2,
                                                             SQL_TEXT IN  VARCHAR2,
                                                             idd      OUT NUMBER)
  /*
    NAME: poorya
    DATE: 
    discription: name table va name field morede nazar (osoolan id) ra migirad va vade ejraye query ke az noe inset hast
          meghdare haman sotoone taghir karde ra bar migardanad
  */
  AS

  BEGIN
    COMMIT;
    EXECUTE IMMEDIATE '
 declare idd number;
 begin ' || SQL_TEXT || ' returning ' || t_name || '.' || id_name || ' into :idd;end;'
    USING OUT idd;


  END;
--------------------------------------------------------
--  DDL for Procedure PRC_COLLATERAL_SETTINGS
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_COLLATERAL_SETTINGS" (INPAR_STR IN NVARCHAR2)
  /*
  NAME: poorya
  DATE:
  DESC: in reval baraye zakhire jadvale TBL_COLLATERAL_SETTING estefade mishavad
        voroodi an be in soorat ast 'ref_no","meghdar";"ref_no","meghdar , .... '
  */
  IS
    LOC_KEY VARCHAR2(100);
    LOC_VAL VARCHAR2(100);
  BEGIN --

    EXECUTE IMMEDIATE 'truncate table credit_risk.TBL_COLLATERAL_SETTING';

    FOR key_val IN (SELECT REGEXP_SUBSTR(INPAR_STR, '[^;]+', 1, LEVEL) AS NAME
        FROM DUAL CONNECT BY REGEXP_SUBSTR(INPAR_STR, '[^;]+', 1, LEVEL) IS NOT NULL)
    LOOP
      --DBMS_OUTPUT.PUT_LINE(key_val.NAME);

      LOC_KEY := SUBSTR(key_val.NAME, 0, INSTR(key_val.NAME, ',') - 1);

      LOC_VAL := SUBSTR(key_val.NAME, INSTR(key_val.NAME, ',') + 1);

      --DBMS_OUTPUT.PUT_LINE(my_key ||' --- ' || my_val);

      INSERT INTO TBL_COLLATERAL_SETTING (
        REF_NOE_VASIGHE, ZARIB_NAGHD_SHAVANDEGI, TARIKH_IJAD
      )
      VALUES (TO_NUMBER(LOC_KEY), TO_NUMBER(LOC_VAL), SYSDATE);

    END LOOP;
    
  --COMMIT;
  END;
--------------------------------------------------------
--  DDL for Procedure PRC_LOAN_CATEGORY
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_LOAN_CATEGORY" (
    INPAR_STR IN VARCHAR2,
    outpar_out OUT NUMBER)
  /*
  NAME: poorya
  DATE:
  DESC: in reval baraye zakhire jadvale TBL_LOAN_CATEGORY estefade mishavad
  voroodi an be in soorat ast 'id","meghdar";"id","meghdar , .... '
  */
IS
  LOC_KEY VARCHAR2(100);
  LOC_VAL VARCHAR2(100);
BEGIN --
  --EXECUTE IMMEDIATE 'truncate table credit_risk.TBL_LOAN_CATEGORY';
  FOR key_val IN
  (SELECT REGEXP_SUBSTR(INPAR_STR, '[^;]+', 1, LEVEL) AS NAME
  FROM DUAL
    CONNECT BY REGEXP_SUBSTR(INPAR_STR, '[^;]+', 1, LEVEL) IS NOT NULL
  )
  LOOP
    --DBMS_OUTPUT.PUT_LINE(key_val.NAME);
    LOC_KEY := TO_NUMBER(SUBSTR(key_val.NAME, 0, INSTR(key_val.NAME, ',') - 1));
    LOC_VAL := TO_NUMBER(SUBSTR(key_val.NAME, INSTR(key_val.NAME, ',')    + 1));
    --DBMS_OUTPUT.PUT_LINE(my_key ||' --- ' || my_val);
    UPDATE TBL_LOAN_CATEGORY
    SET CATEGORY_ID =
      CASE
        WHEN LOC_VAL = 0
        THEN NULL
        ELSE LOC_VAL
      END,
      CATEGORY_NAME =
      CASE
        WHEN LOC_VAL = 0
        THEN NULL
        WHEN LOC_VAL = 1
        THEN 'شركتي'
        WHEN LOC_VAL = 2
        THEN 'دولتي'
        WHEN LOC_VAL = 3
        THEN 'بانكي'
        WHEN LOC_VAL = 4
        THEN 'خرد / رهن مسكوني'
        WHEN LOC_VAL = 5
        THEN 'خرد / تجديدشدني يا پيوسته'
        WHEN LOC_VAL = 6
        THEN 'خرد / ساير'
      END
    WHERE ID = LOC_KEY;
  END LOOP;
  SELECT 1 INTO outpar_out FROM dual;
  COMMIT;
END;
--------------------------------------------------------
--  DDL for Procedure PRC_PD_CALC
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_PD_CALC" AS 
v1 number;
v2 number;
-------------------
  /*
  Programmer Name:   MORTEZA.SA & RASOOL
  Release  :  Date/Time:1395/10/25-10:00
  Version: 1.0
  Category:2
  Description:MOHASEBE PD  
  */
-------------------
BEGIN

EXECUTE IMMEDIATE 'truncate table tbl_pd';
insert into tbl_pd (REF_TASHILAT,pd) (
SELECT REF_TASHILAT,CASE WHEN PD >=1 THEN 0.8 WHEN  PD = 0 THEN 0.0005 ELSE PD END PD FROM (
SELECT REF_TASHILAT,
    CASE
    WHEN ((ASL+SUD)-(SHODE))/(ASL+SUD)<0
    THEN 0.0005
    ELSE ROUND(((ASL+SUD)-SHODE)/(ASL+SUD),5)
  END AS PD
FROM
  (SELECT REF_TASHILAT,
    NVL(SUM(MABLAGH_GHEST_DARYAFT_SHODE),0) AS SHODE,
    SUM(MABLAGH_ASL)                        AS ASL,
    SUM(SUD_MOSTATER)                       AS SUD
    FROM TBL_PAYMENT
  WHERE TARIKH_SARRESID <SYSDATE
  GROUP BY REF_TASHILAT
  ))); 



  
END PRC_PD_CALC;
--------------------------------------------------------
--  DDL for Procedure PRC_PD_CUSTOMER_CALC
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_PD_CUSTOMER_CALC" AS 
v_count number;
v1 number;
v2 number;
v3 number;
v4 number;
-----------------------
  /*
  Programmer Name:  SOBHAN
  Release 
  Version: 1.0
  Category:
  Description: 
  */
-----------------------
BEGIN

--for k in (select * from tbl_customer) loop -- where id=2307962670
--select count(*) into v_count from TBL_LOAN where k.id=REF_MOSHTARI;
--v3:=0;
--if (v_count!=0) then
-- for i in (select * from TBL_LOAN where k.id=REF_MOSHTARI) loop
-- v1:=0;
-- v2:=0;
-- for b in (select * from TBL_payment where REF_TASHILAT=i.id and TARIKH_SARRESID<=sysdate) loop
-- if(b.TARIKH_DARYAFT is not null) then
-- v1:=v1+((b.MABLAGH_ASL+b.SUD_MOSTATER)-b.MABLAGH_GHEST_DARYAFT_SHODE);
-- v2:=v2+((b.MABLAGH_ASL+b.SUD_MOSTATER)-b.MABLAGH_GHEST_DARYAFT_SHODE)*(trunc(sysdate)-trunc(b.TARIKH_DARYAFT));
-- else
--  v1:=v1+((b.MABLAGH_ASL+b.SUD_MOSTATER)-b.MABLAGH_GHEST_DARYAFT_SHODE);
-- v2:=v2+((b.MABLAGH_ASL+b.SUD_MOSTATER)-b.MABLAGH_GHEST_DARYAFT_SHODE)*(trunc(sysdate)-trunc(b.TARIKH_SARRESID));
-- end if;
-- end loop;
--v3:=v3+round( (v1/v2),2);
-- --DBMS_OUTPUT.PUT_LINE(v3);
-- end loop;
--  insert into c_pd (REF_MOSHTARI,c_pd) values (k.id, v3/v_count);
--  end if;
--end loop;
EXECUTE IMMEDIATE 'truncate table tbl_c_pd';
insert into tbl_c_pd (REF_MOSHTARI,c_pd)  select REF_MOSHTARI,(sum_pd/count_tashilat)   from (SELECT lo.REF_MOSHTARI,
  COUNT(po.id) AS count_tashilat ,
  SUM(po.pd)   AS sum_pd
FROM
  (SELECT id,
    v1,
    v2,
     (
  CASE 
    WHEN (v2>0 and v1>=0) THEN ROUND( (v1/v2),5)
    WHEN (v1<0 AND v2 <0) or (v1=0) THEN 0.00001
    
    ELSE 0.00001
  END) AS pd
--    (
--    CASE
--      WHEN v2!=0
--      THEN ROUND( (v1/v2),5)
--      ELSE           -85
--    END) AS pd
  FROM
    (SELECT l.id,
      SUM(((p.MABLAGH_ASL+p.SUD_MOSTATER)-p.MABLAGH_GHEST_DARYAFT_SHODE)) AS v1,
      SUM(
      CASE
        WHEN p.TARIKH_DARYAFT IS NOT NULL
        THEN (((p.MABLAGH_ASL+p.SUD_MOSTATER)-p.MABLAGH_GHEST_DARYAFT_SHODE)*(TRUNC(sysdate)-TRUNC(p.TARIKH_DARYAFT)+1))
        ELSE (((p.MABLAGH_ASL+p.SUD_MOSTATER)-p.MABLAGH_GHEST_DARYAFT_SHODE)*(TRUNC(sysdate)-TRUNC(p.TARIKH_SARRESID)+1))
      END) AS v2
    FROM tbl_loan l
    RIGHT JOIN TBL_PAYMENT p
    ON l.id             =P.REF_TASHILAT
    WHERE p.TARIKH_SARRESID <= sysdate
    GROUP BY l.id
    )
  )po,
  TBL_LOAN lo
WHERE po.id=lo.id
GROUP BY lo.REF_MOSHTARI
);


END PRC_PD_CUSTOMER_CALC;
--------------------------------------------------------
--  DDL for Procedure PRC_CR_RANGE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_CR_RANGE" 
AS
--------------------------------------------------------------------------------
  /*
  Programmer Name:  NAVID
  Release Date/Time:1395/08/15-14:44
  Version: 1.0
  Category:2
  Description: taghsim bazeHa baraE CR+
  */
--------------------------------------------------------------------------------
-- Define Variables
type rang_detail IS VARRAY(31) OF NUMBER;
ranges rang_detail;
r1             NUMBER DEFAULT 0;
r2             NUMBER;
r3             NUMBER;
r4             NUMBER;
r5             NUMBER;
r6             NUMBER;
r7             NUMBER;
r8             NUMBER;
r9             NUMBER;
r10            NUMBER;
r11            NUMBER;
r12            NUMBER;
r13            NUMBER;
r14            NUMBER;
r15            NUMBER;
r16            NUMBER;
r17            NUMBER;
r18            NUMBER;
r19            NUMBER;
r20            NUMBER;
r21            NUMBER;
r22            NUMBER;
r23            NUMBER;
r24            NUMBER;
r25            NUMBER;
r26            NUMBER;
r27            NUMBER;
r28            NUMBER;
r29            NUMBER;
r30            NUMBER;
r31            NUMBER;
max_range      NUMBER;
range_count    NUMBER;
avg_pd         NUMBER;
EEAD2          NUMBER;
UEAD2          NUMBER;
pd_range_count NUMBER DEFAULT 0;
range_pd       NUMBER;
culm_range_pd  NUMBER DEFAULT 0;
CVAR2          NUMBER;
EC2            NUMBER;

--------------------------------------------------------------------------------
BEGIN
--------------------------------------------------------------------------------
 --Truncate all table before system running
  EXECUTE IMMEDIATE 'truncate table tbl_range';
  EXECUTE IMMEDIATE 'truncate table tbl_range_detail';
  EXECUTE IMMEDIATE 'truncate table tbl_range_RESULT';
--------------------------------------------------------------------------------  
  --Initialized all variables
  SELECT MAX(EAD) INTO max_range FROM tbl_navix;
  /*r2     := max_range/10;
  r3     :=r2        + r2;
  r4     :=r3        + r2;
  r5     :=r4        + r2;
  r6     :=r5        + r2;
  r7     :=r6        + r2;
  r8     :=r7        + r2;
  r9     :=r8        + r2;
  r10    :=r9        + r2;
  r11    :=max_range;*/
  
  r2:=17000000;
  r3:=19000000;
  r4:=22000000;
  r5:=25000000;
  r6:=30000000; 
  r7:=32000000;
  r8:=36000000;
  r9:=40000000;
  r10:=42500000;
  r11:=50000000;
  r12:=60000000;
  r13:=65000000;
  r14:=74000000;
  r15:=78000000;
  r16:=80000000;
  r17:=85000000;
  r18:=87000000;
  r19:=92000000;
  r20:=95500000;
  r21:=98000000;
  r22:=99000000;
  r23:=101000000;
  r24:=102000000;
  r25:=110000000;
  r26:=120000000;
  r27:=130000000;
  r28:=140000000;
  r29:=240000000;
  r30:=400000000;
  r31:=max_range;
  ranges := rang_detail(r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31);
--------------------------------------------------------------------------------  
  --Main part of the procedures for filling the proper tables
  FOR i IN 1..30
  LOOP
    SELECT COUNT(ref_tashilat)
    INTO range_count
    FROM TBL_NAVIX
    WHERE EAD >=ranges(i) AND EAD <ranges(i+1);

   SELECT ROUND(AVG(pd),6)/100
    --SELECT AVG(pd)
    INTO avg_pd
    FROM TBL_NAVIX
    WHERE EAD >=ranges(i) AND EAD <ranges(i+1);
   -- EEAD2:= floor(avg_pd  * range_count*45) * ranges(i+1);
    EEAD2:= avg_pd  * range_count *7* ranges(i+1);
    INSERT
    INTO TBL_RANGE
      (
        ID,
        PD,
        COUNT,
        EEAD,
        START_RANGE,
        END_RANGE
      )
      VALUES
      (
        i,
        avg_pd,
        range_count,
        EEAD2,
        ranges(i),
        ranges(i+1)
      );
    COMMIT;
-------------------------------------------- ------------------------------------
    WHILE(FNC_POISSON_DISTRIBUTION (round(avg_pd * range_count,2),pd_range_count)> 0.00000999)
    LOOP
      range_pd := FNC_POISSON_DISTRIBUTION (avg_pd*range_count,pd_range_count);
      culm_range_pd  := culm_range_pd + range_pd;
      pd_range_count := pd_range_count +1;
      INSERT
      INTO TBL_RANGE_DETAIL
      
        (
          RANGE_ID,
          POISSON,
          CUMULATIVE_PO
        )
        VALUES
        (
          i,
          range_pd,
          culm_range_pd
        );
      COMMIT;
    END LOOP;
--------------------------------------------------------------------------------
   if(range_count<10)
   then
    UEAD2 := pd_range_count* 2 * ranges(i+1);
    else if(range_count>=10 and range_count<200) then 
    UEAD2 := pd_range_count* 5 * ranges(i+1);
    else if(range_count>=200 and range_count<600) then 
    UEAD2 := pd_range_count* 6 * ranges(i+1);
    else   UEAD2 := pd_range_count* 10 * ranges(i+1);
    end if;
    end if;
    end if;
    CVAR2 := UEAD2 - EEAD2;
    EC2:= CVAR2 - EEAD2;
    INSERT
    INTO TBL_RANGE_RESULT
      (
        RANGE_ID,
        UEAD,
        CVAR,
        EC
      )
      VALUES
      (
        i,
        UEAD2,
        CVAR2,
        EC2
      );
    COMMIT;
    range_pd       := 0;
    culm_range_pd  := 0;
    pd_range_count  :=0;
  END LOOP;
--------------------------------------------------------------------------------  
END PRC_CR_RANGE;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_NPL_TAGHIR_SHOAB
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_REPORT_NPL_TAGHIR_SHOAB" (
    run_date IN DATE )
AS
  VAR_PRE_MONTH DATE;
  VAR_PRE_YEAR  DATE;
  VAR_ESFAND    DATE;
  var_current   DATE;
BEGIN
/*
  Programmer Name:  MORTEZA.SA
  Release Date/Time:1395/10/13-10:00
  Version: 1.0
  Category:2
  Description:  gozaresh taghrat shoab nesbat  be bazehaye gozashte (zir menu gozareshat etebari)
  */
  var_current   := TRUNC(run_date);
  VAR_PRE_YEAR  :=FNC_pre_year(run_date);
  VAR_PRE_MONTH :=FNC_pre_month(run_date);
  VAR_ESFAND    := FNC_ESFAND(run_date);
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TABLE_S1';
  INSERT
  INTO TABLE_S1
    (
      TEDAD1,
      SAHM1,
      TEDAD2,
      SAHM2,
      ID
    )
    VALUES
    (
      (SELECT COUNT(*)
        FROM
          (SELECT REF_SHOBE,
            SUM(NVL(MANDE_MOAVVAGH,0)+NVL(MANDE_SARRESID_GOZASHTE,0)+NVL(MANDE_MASHKUKOLVOSUL,0)) AS sum_a
          FROM TBL_LOAN_PAST
          WHERE effdate = var_current
          GROUP BY REF_SHOBE
          )a,
          (SELECT REF_SHOBE,
            SUM(NVL(MANDE_MOAVVAGH,0)+NVL(MANDE_SARRESID_GOZASHTE,0)+NVL(MANDE_MASHKUKOLVOSUL,0)) AS sum_b
          FROM TBL_LOAN_PAST
          WHERE effdate = VAR_ESFAND
          GROUP BY REF_SHOBE
          )b
        WHERE a.REF_SHOBE = b.REF_SHOBE
        AND a.sum_a       >b.sum_b
      )
      ,
      1,
      (SELECT COUNT(*)
      FROM
        (SELECT REF_SHOBE,
          SUM(NVL(MANDE_MOAVVAGH,0)+NVL(MANDE_SARRESID_GOZASHTE,0)+NVL(MANDE_MASHKUKOLVOSUL,0)) AS sum_a
        FROM TBL_LOAN_PAST
        WHERE effdate = var_current
        GROUP BY REF_SHOBE
        )a,
        (SELECT REF_SHOBE,
          SUM(NVL(MANDE_MOAVVAGH,0)+NVL(MANDE_SARRESID_GOZASHTE,0)+NVL(MANDE_MASHKUKOLVOSUL,0)) AS sum_b
        FROM TBL_LOAN_PAST
        WHERE effdate = VAR_PRE_MONTH
        GROUP BY REF_SHOBE
        )b
      WHERE a.REF_SHOBE = b.REF_SHOBE
      AND a.sum_a       >b.sum_b
      ),
      1,
      1
    );
  COMMIT;
  INSERT
  INTO TABLE_S1
    (
      TEDAD1,
      SAHM1,
      TEDAD2,
      SAHM2,
      ID
    )
    VALUES
    (
      (SELECT COUNT(*)
        FROM
          (SELECT REF_SHOBE,
            SUM(NVL(MANDE_MOAVVAGH,0)+NVL(MANDE_SARRESID_GOZASHTE,0)+NVL(MANDE_MASHKUKOLVOSUL,0)) AS sum_a
          FROM TBL_LOAN_PAST
          WHERE effdate = var_current
          GROUP BY REF_SHOBE
          )a,
          (SELECT REF_SHOBE,
            SUM(NVL(MANDE_MOAVVAGH,0)+NVL(MANDE_SARRESID_GOZASHTE,0)+NVL(MANDE_MASHKUKOLVOSUL,0)) AS sum_b
          FROM TBL_LOAN_PAST
          WHERE effdate = VAR_ESFAND
          GROUP BY REF_SHOBE
          )b
        WHERE a.REF_SHOBE = b.REF_SHOBE
        AND a.sum_a       =b.sum_b
      )
      ,
      1,
      (SELECT COUNT(*)
      FROM
        (SELECT REF_SHOBE,
          SUM(NVL(MANDE_MOAVVAGH,0)+NVL(MANDE_SARRESID_GOZASHTE,0)+NVL(MANDE_MASHKUKOLVOSUL,0)) AS sum_a
        FROM TBL_LOAN_PAST
        WHERE effdate = var_current
        GROUP BY REF_SHOBE
        )a,
        (SELECT REF_SHOBE,
          SUM(NVL(MANDE_MOAVVAGH,0)+NVL(MANDE_SARRESID_GOZASHTE,0)+NVL(MANDE_MASHKUKOLVOSUL,0)) AS sum_b
        FROM TBL_LOAN_PAST
        WHERE effdate = VAR_PRE_MONTH
        GROUP BY REF_SHOBE
        )b
      WHERE a.REF_SHOBE = b.REF_SHOBE
      AND a.sum_a       =b.sum_b
      ),
      1,
      2
    );
  COMMIT;
  INSERT
  INTO TABLE_S1
    (
      TEDAD1,
      SAHM1,
      TEDAD2,
      SAHM2,
      ID
    )
    VALUES
    (
      (SELECT COUNT(*)
        FROM
          (SELECT REF_SHOBE,
            SUM(NVL(MANDE_MOAVVAGH,0)+NVL(MANDE_SARRESID_GOZASHTE,0)+NVL(MANDE_MASHKUKOLVOSUL,0)) AS sum_a
          FROM TBL_LOAN_PAST
          WHERE effdate = var_current
          GROUP BY REF_SHOBE
          )a,
          (SELECT REF_SHOBE,
            SUM(NVL(MANDE_MOAVVAGH,0)+NVL(MANDE_SARRESID_GOZASHTE,0)+NVL(MANDE_MASHKUKOLVOSUL,0)) AS sum_b
          FROM TBL_LOAN_PAST
          WHERE effdate = VAR_ESFAND
          GROUP BY REF_SHOBE
          )b
        WHERE a.REF_SHOBE = b.REF_SHOBE
        AND a.sum_a       <b.sum_b
      )
      ,
      1,
      (SELECT COUNT(*)
      FROM
        (SELECT REF_SHOBE,
          SUM(NVL(MANDE_MOAVVAGH,0)+NVL(MANDE_SARRESID_GOZASHTE,0)+NVL(MANDE_MASHKUKOLVOSUL,0)) AS sum_a
        FROM TBL_LOAN_PAST
        WHERE effdate = var_current
        GROUP BY REF_SHOBE
        )a,
        (SELECT REF_SHOBE,
          SUM(NVL(MANDE_MOAVVAGH,0)+NVL(MANDE_SARRESID_GOZASHTE,0)+NVL(MANDE_MASHKUKOLVOSUL,0)) AS sum_b
        FROM TBL_LOAN_PAST
        WHERE effdate = VAR_PRE_MONTH
        GROUP BY REF_SHOBE
        )b
      WHERE a.REF_SHOBE = b.REF_SHOBE
      AND a.sum_a       <b.sum_b
      ) ,
      1,
      3
    );
  COMMIT;
  INSERT
  INTO TABLE_S1
    (
      TEDAD1,
      SAHM1,
      TEDAD2,
      SAHM2,
      ID
    )
    VALUES
    (
      (SELECT SUM(TEDAD1) FROM TABLE_S1
      )
      ,
      (SELECT SUM(sahm1) FROM TABLE_S1
      ),
      (SELECT SUM(tedad2) FROM TABLE_S1
      ),
      (SELECT SUM(sahm2) FROM TABLE_S1
      ),
      4
    );
    commit;
  UPDATE TABLE_S1
  SET SAHM1 = ROUND(
    CASE
      WHEN tedad1 = 0
      THEN 0
      ELSE ((tedad1 * 100)/
        (SELECT (CASE WHEN id = 4 THEN tedad1 END) FROM table_s1 WHERE id = 4
        ))
    END,0) ;
    commit;
  UPDATE TABLE_S1
  SET SAHM2 = ROUND(
    CASE
      WHEN tedad2 = 0
      THEN 0
      ELSE ((tedad2 * 100)/
        (SELECT (CASE WHEN id = 4 THEN tedad2 END) FROM table_s1 WHERE id = 4
        ))
    END,0);
END PRC_REPORT_NPL_TAGHIR_SHOAB;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_SHAKHES_RISK
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_REPORT_SHAKHES_RISK" (in_date in date  )AS 
v_pre_month date;
v_esfand date;
v_similar_month date;
BEGIN
 /*
  Programmer Name: sobhan
  Release Date/Time:
  Version: 
  Category:
  Description: por kardane CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK baraye ==> view NVW_RISK_TAFKIK_ARZ
  */
  
  EXECUTE IMMEDIATE 'truncate table CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK';
insert into CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK (id,SHAKHES) VALUES (1,'ارزي');
insert into CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK (id,SHAKHES) VALUES (2,'ريالي');
insert into CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK (id,SHAKHES) VALUES (3,'کل');
-----------------------------------coulmn : m4 -- mahe current_month

-----------------------------------------------------------------------------
--- rial 
--baraye mohasebe shakhese risk etebari rialy , az jadvale tbl_loan_past , maghadire sotun haye(MANDE_SARRESID_GOZASHTE,MANDE_MOAVVAGH ,MANDE_MASHKUKOLVOSUL)
-- meghdare 
commit;
update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m4=(
select round((a.mablagh3/ b.mablagh4),3)*100 from 
(SELECT 
  SUM(MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh3
FROM tbl_loan_past
where trunc(EFFDATE)=TRUNC(in_date) and arz= 'IRR')a
,
(SELECT 
   SUM(MANDE_ASL_VAM+MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh4
FROM tbl_loan_past
where trunc(EFFDATE)=TRUNC(in_date) and arz= 'IRR')b
)
where id=2;
commit;
--- arzi
update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m4=
(
select (case when round((a.mablagh3/ b.mablagh4),3)*100 is null then 0 else (round((a.mablagh3/ b.mablagh4),3)*100) end)from 
(SELECT 
  SUM(MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh3
FROM tbl_loan_past
where trunc(EFFDATE)=TRUNC(in_date) and arz<>'IRR')a
,
(SELECT 
  SUM(MANDE_ASL_VAM+MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh4
FROM tbl_loan_past
where trunc(EFFDATE)=TRUNC(in_date) and arz<>'IRR')b
)
where id=1;
--- sum
commit;
update  CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m4=
(
select sum(m4) from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK WHERE ID!=3
)
where id=3;
commit;
--------------------------------coulmn : m3  --  pre_month
--- rialy
v_pre_month:=FNC_pre_month(in_date);
commit;
update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m3=
(
select round((a.mablagh3/ b.mablagh4),3)*100 from 
(SELECT 
   SUM(MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh3
FROM tbl_loan_past
where trunc(EFFDATE)=v_pre_month and arz='IRR')a
,
(SELECT 
   SUM(MANDE_ASL_VAM+MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh4
FROM tbl_loan_past
where trunc(EFFDATE)=v_pre_month and arz='IRR')b
)
where id=2;
commit;
--- arzi
update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m3=
(
select round((a.mablagh3/ b.mablagh4),3)*100 from 
(SELECT 
   SUM(MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh3
FROM tbl_loan_past
where trunc(EFFDATE)=v_pre_month and arz<>'IRR')a
,
(SELECT 
   SUM(MANDE_ASL_VAM+MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh4
FROM tbl_loan_past
where trunc(EFFDATE)=v_pre_month and arz<>'IRR')b
)
where id=1;
commit;
--- sum
update  CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m3=
(
select sum(m3) from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK WHERE ID!=3
)
where id=3;
commit;
----------------------------coulmn : m2  -- esfand
--- rialy
v_esfand:=FNC_ESFAND(in_date);

update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m2=
(
select round((a.mablagh3/ b.mablagh4),3)*100 from 
(SELECT 
  SUM(MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh3
FROM tbl_loan_past
where trunc(EFFDATE)=v_esfand and arz='IRR')a
,
(SELECT 
  SUM(MANDE_ASL_VAM+MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh4
FROM tbl_loan_past
where trunc(EFFDATE)=v_esfand and arz='IRR')b
)
where id=2;
commit;
--- arzi
update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m2=
(
select round((a.mablagh3/ b.mablagh4),3)*100 from 
(SELECT 
  SUM(MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh3
FROM tbl_loan_past
where trunc(EFFDATE)=v_esfand and arz<>'IRR')a
,
(SELECT 
  SUM(MANDE_ASL_VAM+MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh4
FROM tbl_loan_past
where trunc(EFFDATE)=v_esfand and arz<>'IRR')b
)
where id=1;
commit;
--- sum
update  CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m2=
(
select sum(m2) from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK WHERE ID!=3
)
where id=3;
commit;
---------------------------coulmn : m1  --  similar_month
--- rialy
v_similar_month:=FNC_pre_year(in_date);

update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m1=
(
select round((a.mablagh3/ b.mablagh4),3)*100 from 
(SELECT 
  SUM(MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh3
FROM tbl_loan_past
where trunc(EFFDATE)=v_similar_month and arz='IRR')a
,
(SELECT 
  SUM(MANDE_ASL_VAM+MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh4
FROM tbl_loan_past
where trunc(EFFDATE)=v_similar_month and arz='IRR')b
)
where id=2;
commit;
--- arzi
update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m1=
(
select round((a.mablagh3/ b.mablagh4),3)*100 from 
(SELECT 
  SUM(MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh3
FROM tbl_loan_past
where trunc(EFFDATE)=v_similar_month and arz<>'IRR')a
,
(SELECT 
  SUM(MANDE_ASL_VAM+MANDE_SARRESID_GOZASHTE+MANDE_MOAVVAGH +MANDE_MASHKUKOLVOSUL) AS mablagh4
FROM tbl_loan_past
where trunc(EFFDATE)=v_similar_month and arz<>'IRR')b
)
where id=1;
commit;
--- sum
update  CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m1=
(
select sum(m1) from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK WHERE ID!=3
)
where id=3;
commit;

----------------------- m5
--rialy
update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m5=
(select  (case when m3!=0 then round(((m4-m3)/m3)*100,5) else round(((m4-m3))*100,5) end )  from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK where id=2)
where id=2 ;
commit;
--arzi
update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m5=
(select  (case when m3!=0 then round(((m4-m3)/m3)*100,5) else round(((m4-m3))*100,5) end )  from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK where id=1)
where id=1 ;
commit;
--- sum
update  CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m5=
(
select sum(m5) from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK WHERE ID!=3
)
where id=3;
commit;
----------------------------------m6
--rialy
update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m6=
(select  (case when m2!=0 then round(((m4-m2)/m2)*100,5) else round(((m4-m2))*100,5) end )  from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK where id=2 )
where id=2 ;
commit;
--arzi
update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m6=
(select  (case when m2!=0 then round(((m4-m2)/m2)*100,5) else round(((m4-m2))*100,5) end )  from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK where id=1)
where id=1 ;
commit;
--- sum
update  CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m6=
(
select sum(m6) from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK WHERE ID!=3
)
where id=3;
commit;
------------------------------ m7
--rialy
update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m7=
(select  (case when m1!=0 then round(((m4-m1)/m1)*100,5) else round(((m4-m1))*100,5) end )  from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK where id=2)

where id=2 ;
commit;
--arzi
update CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m7=
(select (case when m1!=0 then round(((m4-m1)/m1)*100,5) else round(((m4-m1))*100,5) end )   from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK where id=1)
where id=1 ;
commit;
--- sum
update  CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK set m7=
(
select sum(m7) from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK WHERE ID!=3
)
where id=3;
commit;




END PRC_REPORT_SHAKHES_RISK;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT8_BRANCH
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_REPORT8_BRANCH" AS 
BEGIN
  /*
  Programmer Name: sobhan
  Release Date/Time:
  Version: 
  Category:
  Description: por kardane CREDIT_RISK.table_report8_branch baraye ==> view s1
  */
  
EXECUTE IMMEDIATE 'truncate table CREDIT_RISK.table_report8_branch';
 
insert into CREDIT_RISK.table_report8_branch(
NAME,
ASL,
SARRESID_GOZASHTE,
MOAVAGH,
MASHKOOK,
SAYER,
KHESARAT,
TOTAL,
DARSAD,
ID
)
SELECT
  name,
  MANDE_ASL_VAM,
  MANDE_SARRESID_GOZASHTE,
  MANDE_MOAVVAGH,
  MANDE_MASHKUKOLVOSUL,
  0,
  0,
  total,
 ( case when total!=0 then round((ma/total)*100,5) else 0 end) as darsad,
 rownum
FROM
  (
    SELECT
      M.NAM AS name,
      L.MANDE_ASL_VAM,
      L.MANDE_SARRESID_GOZASHTE,
      L.MANDE_MOAVVAGH,
      L.MANDE_MASHKUKOLVOSUL,
      (l.MANDE_ASL_VAM+l.MANDE_SARRESID_GOZASHTE+l.MANDE_MOAVVAGH+
      l.MANDE_MASHKUKOLVOSUL) AS total,
       l.MANDE_SARRESID_GOZASHTE+l.MANDE_MOAVVAGH+l.MANDE_MASHKUKOLVOSUL as ma
    FROM
      tbl_loan l,
      TBL_CUSTOMER m
    WHERE
      L.REF_MOSHTARI=M.ID
  ); 
 
 
 
 
 
END PRC_REPORT8_BRANCH;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_5_SHOBE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_REPORT_5_SHOBE" (
    run_date IN DATE )
AS
  VAR_PRE_MONTH DATE;
  VAR_PRE_YEAR  DATE;
  VAR_ESFAND    DATE;
BEGIN
  /*
  Programmer Name:  MORTEZA.SA
  Release Date/Time:1395/10/14-10:00
  Version: 1.0
  Category:2
  Description:  gozaresh 5 shobe ba bishtarin taghir (zir menu gozareshat etebari)
  */
  VAR_PRE_YEAR  :=FNC_PRE_YEAR(run_date);
  VAR_PRE_MONTH :=FNC_PRE_MONTH(run_date);
  VAR_ESFAND    := FNC_ESFAND(run_date);
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TBL_REPORT_5_SHOBE';
  INSERT
  INTO TBL_REPORT_5_SHOBE
    (
      NAME,
      MAH_JARI,
      MAH_GOZASHTE,
      MAH_JARI2,
      MAH_GOZASHTE2,
      ID
    )
  SELECT a.nam,
    a.kol,
    b.kol,
    a.gh,
    b.gh,
    rownum
  FROM
    (SELECT MAX(B.NAM)                                                                          AS nam,
      SUM(L.MANDE_ASL_VAM   +L.MABLAGH_MOSAVVAB+L.MANDE_SARRESID_GOZASHTE+L.MANDE_MASHKUKOLVOSUL) AS kol ,
      SUM(L.MABLAGH_MOSAVVAB+L.MANDE_SARRESID_GOZASHTE+L.MANDE_MASHKUKOLVOSUL)                    AS gh
    FROM TBL_LOAN_PAST l,
      TBL_BRANCH b
    WHERE l.EFFDATE =TRUNC(run_date)
    AND B.ID        = L.REF_SHOBE
    GROUP BY L.REF_SHOBE
    )a ,
    (SELECT MAX(B.NAM)                                                                          AS nam,
      SUM(L.MANDE_ASL_VAM   +L.MABLAGH_MOSAVVAB+L.MANDE_SARRESID_GOZASHTE+L.MANDE_MASHKUKOLVOSUL) AS kol ,
      SUM(L.MABLAGH_MOSAVVAB+L.MANDE_SARRESID_GOZASHTE+L.MANDE_MASHKUKOLVOSUL)                    AS gh
    FROM TBL_LOAN_PAST l,
      TBL_BRANCH b
    WHERE l.EFFDATE =VAR_PRE_MONTH
    AND B.ID        = L.REF_SHOBE
    GROUP BY L.REF_SHOBE
    )b
  WHERE a.nam=b.nam ;
END;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_TAGHIRAT_NPL_SHOAB
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_REPORT_TAGHIRAT_NPL_SHOAB" (
    run_date IN DATE )
AS
  VAR_PRE_MONTH DATE;
  VAR_PRE_YEAR  DATE;
  VAR_ESFAND    DATE;
BEGIN
/*
  Programmer Name:  MORTEZA.SA
  Release Date/Time:1395/10/13-10:00
  Version: 1.0
  Category:2
  Description:  gozaresh TAGHIR NPL SHOAB 
  */
  VAR_PRE_YEAR  :=FNC_PRE_YEAR(run_date);
  VAR_PRE_MONTH :=FNC_PRE_MONTH(run_date);
  VAR_ESFAND    := FNC_ESFAND(run_date);
  EXECUTE IMMEDIATE 'TRUNCATE TABLE TBL_REPORT_TAGHIR_NPL_SHOAB';
  INSERT INTO TBL_REPORT_TAGHIR_NPL_SHOAB
    ( NAME, SHAKHES1, SHAKHES2, ID
    )
  SELECT a.nam,
    ROUND(a.gh/a.kol,5),
    ROUND(b.gh/b.kol,5) ,
    rownum
  FROM
    (SELECT MAX(B.NAM)                                                               AS nam,
      SUM(L.MANDE_ASL_VAM    +L.MANDE_MOAVVAGH+L.MANDE_SARRESID_GOZASHTE+L.MANDE_MASHKUKOLVOSUL) AS kol ,
    SUM(L.MANDE_MOAVVAGH+L.MANDE_SARRESID_GOZASHTE+L.MANDE_MASHKUKOLVOSUL)                  AS gh
    FROM tbl_loan_past l,
          TBL_BRANCH b
    WHERE l.EFFDATE =TRUNC(run_date)
    AND B.ID        = L.REF_SHOBE
    GROUP BY  L.REF_SHOBE
    )a ,
    (SELECT MAX(B.NAM)                                                               AS nam,
      SUM(L.MANDE_ASL_VAM    +L.MANDE_MOAVVAGH+L.MANDE_SARRESID_GOZASHTE+L.MANDE_MASHKUKOLVOSUL) AS kol ,
    SUM(L.MANDE_MOAVVAGH+L.MANDE_SARRESID_GOZASHTE+L.MANDE_MASHKUKOLVOSUL)                  AS gh
    FROM tbl_loan_past l,
          TBL_BRANCH b
    WHERE l.EFFDATE =VAR_PRE_MONTH
    AND B.ID        = L.REF_SHOBE
    GROUP BY  L.REF_SHOBE
    )b
  WHERE a.nam=b.nam;
  COMMIT;
END;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_SAHM_AZ_KOL
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_REPORT_SAHM_AZ_KOL" AS 
BEGIN
/*
  Programmer Name:  MORTEZA.SA
  Release Date/Time:1395/10/13-10:00
  Version: 1.0
  Category:2
  Description:  gozaresh sahme betafkik  har (noe,shobe,riali&arzi,shahr,ostan) be kol sahm be 
  */
 EXECUTE IMMEDIATE 'TRUNCATE TABLE TBL_REPORT_SAHM_AZ_KOL';

INSERT
INTO TBL_REPORT_SAHM_AZ_KOL
  (
    ID,
    CODE_NOE,
    NAME,
    VALUE,
    DARSAD  )
    SELECT 1,
  tl.COD_NOE_TASHILAT,
  MAX(TL.NAM_NOE_TASHILAT),
  SUM(TN.RWA),
  ROUND(SUM(TN.RWA)/
  (SELECT SUM(rwa)FROM tbl_navix
  )*100,1)
FROM TBL_LOAN tl,
  tbl_navix tn
WHERE TN.REF_TASHILAT = TL.ID
GROUP BY tl.COD_NOE_TASHILAT;
commit;
INSERT
INTO TBL_REPORT_SAHM_AZ_KOL
  (
    ID,
    CODE_NOE,
    NAME,
    VALUE,
    DARSAD  )
    SELECT 2,
  TL.ARZ,
  max(TA.NAME_ARZ)
,
  SUM(TN.RWA),
  ROUND(SUM(TN.RWA)/
  (SELECT SUM(rwa)FROM tbl_navix
  )*100,1)
FROM TBL_LOAN tl,
  tbl_navix tn,
  tbl_arz ta
WHERE TN.REF_TASHILAT = TL.ID
and TA.arz = TL.ARZ
GROUP BY TL.ARZ;
commit;
    INSERT
INTO TBL_REPORT_SAHM_AZ_KOL
  (
    ID,
    CODE_NOE,
    NAME,
    VALUE,
    DARSAD  )
    SELECT 3,
  TL.REF_SHOBE,
max(TB.NAM),
  SUM(TN.RWA),
  ROUND(SUM(TN.RWA)/
  (SELECT SUM(rwa)FROM tbl_navix
  )*100,1)
FROM TBL_LOAN tl,
  tbl_navix tn,
  TBL_BRANCH tb
WHERE TN.REF_TASHILAT = TL.ID
and TL.REF_SHOBE = TB.ID 
GROUP BY TL.REF_SHOBE;
commit;
  INSERT
INTO TBL_REPORT_SAHM_AZ_KOL
  (
    ID,
    CODE_NOE,
    NAME,
    VALUE,
    DARSAD  )
    SELECT 4,
max( TB.COD_OSTAN),
 TB.NAM_OSTAN ,
  SUM(TN.RWA),
  ROUND(SUM(TN.RWA)/
  (SELECT SUM(rwa)FROM tbl_navix
  )*100,1)
FROM TBL_LOAN tl,
  tbl_navix tn,
  TBL_BRANCH tb
WHERE TN.REF_TASHILAT = TL.ID
and TL.REF_SHOBE = TB.ID 
GROUP BY TB.NAM_OSTAN;
commit;

  INSERT   --insert be jadval sahm az kol baraye sahm har shahr
INTO TBL_REPORT_SAHM_AZ_KOL
  (
    ID,
    CODE_NOE,
    NAME,
    VALUE,
    DARSAD  )
SELECT 5,
 TB.COD_SHAHR,
max(TB.NAM_SHAHR),
  SUM(TN.RWA),
  ROUND(SUM(TN.RWA)/
  (SELECT SUM(rwa)FROM tbl_navix
  )*100,1)
FROM TBL_LOAN tl,
  tbl_navix tn,
  TBL_BRANCH tb
WHERE TN.REF_TASHILAT = TL.ID
and TL.REF_SHOBE = TB.ID 
GROUP BY TB.COD_SHAHR;

commit;

END PRC_REPORT_SAHM_AZ_KOL;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_NPL_ISIC
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_REPORT_NPL_ISIC" AS 
v_sum number;

BEGIN
  /*
  Programmer Name: sobhan
  Release Date/Time:
  Version: 
  Category:
  Description: por kardane CREDIT_RISK.table_report_s5 baraye ==> view s1
  */
  /*
  Programmer Name: MORTEZA.SA
  Release Date/Time:21-10-95  
  Version:1.1
  Description: عوض کردن کلي پراسيجر  و تبديل از چند حلقه به يک کويري (zir menu gozareshat etebari)
  */
EXECUTE IMMEDIATE 'truncate table credit_risk.table_report_s5';


INSERT
INTO TABLE_REPORT_S5
  (
    SANAT,
    MABLAGH1,
    SAHM1,
    MABLAGH2,
    SAHM2
  
  )
  SELECT TLC.CATEGORY_NAME,
  SUM (tl.MANDE_SARRESID_GOZASHTE        +tl.MANDE_MASHKUKOLVOSUL+tl.MANDE_MOAVVAGH)AS mablagh1 ,
  ROUND(( SUM (tl.MANDE_SARRESID_GOZASHTE+tl.MANDE_MASHKUKOLVOSUL+tl.MANDE_MOAVVAGH)/
  (SELECT SUM (tl.MANDE_SARRESID_GOZASHTE+tl.MANDE_MASHKUKOLVOSUL+tl.MANDE_MOAVVAGH)
  FROM tbl_loan tl
  ))                                     *100,2)                                                     AS sahm,
  SUM (tl.MANDE_SARRESID_GOZASHTE        +tl.MANDE_MASHKUKOLVOSUL+tl.MANDE_MOAVVAGH+tl.MANDE_ASL_VAM)AS mablagh2 ,
  ROUND(( SUM (tl.MANDE_SARRESID_GOZASHTE+tl.MANDE_MASHKUKOLVOSUL+tl.MANDE_MOAVVAGH+tl.MANDE_ASL_VAM)/
  (SELECT SUM (tl.MANDE_SARRESID_GOZASHTE+tl.MANDE_MASHKUKOLVOSUL+tl.MANDE_MOAVVAGH+tl.MANDE_ASL_VAM)
  FROM tbl_loan tl
  ))*100,2) AS sahm
FROM TBL_LOAN tl,
  TBL_LOAN_CATEGORY tlc
WHERE TLC.TYPE_ID = TL.COD_NOE_TASHILAT
GROUP BY TLC.CATEGORY_NAME;
---------------
    
END PRC_REPORT_NPL_ISIC;
--------------------------------------------------------
--  DDL for Procedure PRC_ENTEGHAL_LOAN_PAST
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_ENTEGHAL_LOAN_PAST" (
  run_date IN date 
) 
AS
  VAR_PRE_MONTH DATE;
  VAR_PRE_YEAR  DATE;
  VAR_ESFAND    DATE;
BEGIN
/*
  Programmer Name:  MORTEZA.SA 
  Release Date/Time:1395/10/20-12:00
  Version: 1.0
  Category:2
  Description:  por kardan jadval TBL_LOAN_past baraye rozhaye mokhtalef 
  (baraye 4 baze emroz,akharin roz mah ghabl,akharin roz sal ghabl,akharin roz mah moshabeh sal ghabl)
  */
  VAR_PRE_YEAR  :=FNC_PRE_YEAR(run_date);--mah moshabeh sal ghabl
  VAR_PRE_MONTH :=FNC_PRE_MONTH(run_date);-- akharin roze mah ghabl
  VAR_ESFAND    := FNC_ESFAND(run_date);-- akharin roz sal ghabl
   EXECUTE IMMEDIATE 'TRUNCATE TABLE tbl_loan_past';
-- insert dadehaye bank (tashilat ) baraye emroz(run_date)
INSERT
    /*+  PARALLEL(auto) */
  INTO TBL_LOAN_past
    (
      ID,
      COD_NOE_TASHILAT,
      NAM_NOE_TASHILAT,
      REF_SHOBE,
      TARIKH_TASHKIL,
      TARIKH_SARREDID,
      COD_BAKHSH_EGHTESADI,
      NAM_BAKHSH_EGHTESADI,
      MABLAGH_MOSAVVAB,
      ARZ,
      NERKH_SUD,
      COD_NAHVE_BAZ_PARDAKHT,
      -- NAM_NAHVE_BAZ_PARDAKHT,
      REF_MOSHTARI,
      MANDE_ASL_VAM,
      MANDE_SARRESID_GOZASHTE,
      MANDE_MASHKUKOLVOSUL,
      MANDE_MOAVVAGH,
      VAZIAT,
      TEDAD_AGHSAT,
      MANDE_KOL_VAM,
      EFFDATE
    )
  SELECT L.abrnchcod
    || L.lnminortp
    || L.cfcifno
    || L.crserial AS tashilat,
    SUBSTR(l.PRODUCTTYPECODE,3,3),
    NT.TITLE,
    l.abrnchcod,
    l.crbgndt, 
      l.crenddt,
    SUBSTR(l.PRODUCTTYPECODE,6,1),
    REGEXP_SUBSTR(NT.TITLE, '[^/]+', 1,2),
    l.cracclim,
    l.acurrcode,
    l.prmainrt,
    l.CUST_BAZPARDAKHT_TYPE,
    l.cfcifno,
    l.MANDEH_ASL,
    l.MANDEH_SARRESIDGOZASHTE,
    l.MANDEH_MASHKOOK,
    l.MANDEH_MOAVAGH,
    l.state_endday,
    b.count_ghest,
    b.ghest_mande,
    trunc(run_date)
  FROM DADEKAVAN_DAY.LOAN l
  JOIN
    (SELECT DISTINCT TYPE_CODE,TITLE FROM DADEKAVAN_DAY.NOE_TASHILAT
    ) nt
  ON SUBSTR(L.PRODUCTTYPECODE,3,4) =SUBSTR(NT.TYPE_CODE,3,4)
  JOIN
    (SELECT COUNT(P.PAY_DATE) AS count_ghest,
      SUM(p.PAY_AMOUNT+p.PAY_PROFIT)       AS ghest_mande,
      L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial AS tashilat
    FROM DADEKAVAN_DAY.PAYMENT p
    JOIN DADEKAVAN_DAY.LOAN l
    ON P.abrnchcod
      || P.lnminortp
      || P.cfcifno
      || P.crserial = L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial
    WHERE L.EFFDATE = trunc(run_date)
      and trunc(p.PAY_DATE) > trunc(run_date)
     and  SUBSTR(l.PRODUCTTYPECODE,0,3)<> 'L31'
     and L.STATE_ENDDAY                  = ANY('5','4','F','3')
    GROUP BY L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial
    )b ON L.abrnchcod
    || L.lnminortp
    || L.cfcifno
    || L.crserial = b.tashilat
  WHERE L.EFFDATE = trunc(run_date);
  COMMIT;
-- insert dadehaye bank (tashilat ) baraye VAR_PRE_YEAR(mah moshabeh sal ghabl)

INSERT
    /*+  PARALLEL(auto) */
  INTO TBL_LOAN_past
    (
      ID,
      COD_NOE_TASHILAT,
      NAM_NOE_TASHILAT,
      REF_SHOBE,
      TARIKH_TASHKIL,
      TARIKH_SARREDID,
      COD_BAKHSH_EGHTESADI,
      NAM_BAKHSH_EGHTESADI,
      MABLAGH_MOSAVVAB,
      ARZ,
      NERKH_SUD,
      COD_NAHVE_BAZ_PARDAKHT,
      -- NAM_NAHVE_BAZ_PARDAKHT,
      REF_MOSHTARI,
      MANDE_ASL_VAM,
      MANDE_SARRESID_GOZASHTE,
      MANDE_MASHKUKOLVOSUL,
      MANDE_MOAVVAGH,
      VAZIAT,
      TEDAD_AGHSAT,
      MANDE_KOL_VAM,
      effdate
    )
  SELECT L.abrnchcod
    || L.lnminortp
    || L.cfcifno
    || L.crserial AS tashilat,
    SUBSTR(l.PRODUCTTYPECODE,3,3),
    NT.TITLE,
    l.abrnchcod,
    l.crbgndt, 
      l.crenddt,
    SUBSTR(l.PRODUCTTYPECODE,6,1),
    REGEXP_SUBSTR(NT.TITLE, '[^/]+', 1,2),
    l.cracclim,
    l.acurrcode,
    l.prmainrt,
    l.CUST_BAZPARDAKHT_TYPE,
    l.cfcifno,
    l.MANDEH_ASL,
    l.MANDEH_SARRESIDGOZASHTE,
    l.MANDEH_MASHKOOK,
    l.MANDEH_MOAVAGH,
    l.state_endday,
    b.count_ghest,
    b.ghest_mande,
   VAR_PRE_YEAR
  FROM DADEKAVAN_DAY.LOAN l
  JOIN
    (SELECT DISTINCT TYPE_CODE,TITLE FROM DADEKAVAN_DAY.NOE_TASHILAT
    ) nt
  ON SUBSTR(L.PRODUCTTYPECODE,3,4) =SUBSTR(NT.TYPE_CODE,3,4)
  JOIN
    (SELECT COUNT(P.PAY_DATE) AS count_ghest,
      SUM(p.PAY_AMOUNT+p.PAY_PROFIT)       AS ghest_mande,
      L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial AS tashilat
    FROM DADEKAVAN_DAY.PAYMENT p
    JOIN DADEKAVAN_DAY.LOAN l
    ON P.abrnchcod
      || P.lnminortp
      || P.cfcifno
      || P.crserial = L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial
    WHERE L.EFFDATE = VAR_PRE_YEAR
      and trunc(p.PAY_DATE) >VAR_PRE_YEAR
     and  SUBSTR(l.PRODUCTTYPECODE,0,3)<> 'L31'
     and L.STATE_ENDDAY                  = ANY('5','4','F','3')
    GROUP BY L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial
    )b ON L.abrnchcod
    || L.lnminortp
    || L.cfcifno
    || L.crserial = b.tashilat
  WHERE L.EFFDATE = VAR_PRE_YEAR;
  commit;
  -- insert dadehaye bank (tashilat ) baraye VAR_ESFAND(esfand sal ghabl)

  INSERT
    /*+  PARALLEL(auto) */
  INTO TBL_LOAN_past
    (
      ID,
      COD_NOE_TASHILAT,
      NAM_NOE_TASHILAT,
      REF_SHOBE,
      TARIKH_TASHKIL,
      TARIKH_SARREDID,
      COD_BAKHSH_EGHTESADI,
      NAM_BAKHSH_EGHTESADI,
      MABLAGH_MOSAVVAB,
      ARZ,
      NERKH_SUD,
      COD_NAHVE_BAZ_PARDAKHT,
      -- NAM_NAHVE_BAZ_PARDAKHT,
      REF_MOSHTARI,
      MANDE_ASL_VAM,
      MANDE_SARRESID_GOZASHTE,
      MANDE_MASHKUKOLVOSUL,
      MANDE_MOAVVAGH,
      VAZIAT,
      TEDAD_AGHSAT,
      MANDE_KOL_VAM,
      effdate
    )
  SELECT L.abrnchcod
    || L.lnminortp
    || L.cfcifno
    || L.crserial AS tashilat,
    SUBSTR(l.PRODUCTTYPECODE,3,3),
    NT.TITLE,
    l.abrnchcod,
    l.crbgndt, 
      l.crenddt,
    SUBSTR(l.PRODUCTTYPECODE,6,1),
    REGEXP_SUBSTR(NT.TITLE, '[^/]+', 1,2),
    l.cracclim,
    l.acurrcode,
    l.prmainrt,
    l.CUST_BAZPARDAKHT_TYPE,
    l.cfcifno,
    l.MANDEH_ASL,
    l.MANDEH_SARRESIDGOZASHTE,
    l.MANDEH_MASHKOOK,
    l.MANDEH_MOAVAGH,
    l.state_endday,
    b.count_ghest,
    b.ghest_mande,
    VAR_ESFAND
  FROM DADEKAVAN_DAY.LOAN l
  JOIN
    (SELECT DISTINCT TYPE_CODE,TITLE FROM DADEKAVAN_DAY.NOE_TASHILAT
    ) nt
  ON SUBSTR(L.PRODUCTTYPECODE,3,4) =SUBSTR(NT.TYPE_CODE,3,4)
  JOIN
    (SELECT COUNT(P.PAY_DATE) AS count_ghest,
      SUM(p.PAY_AMOUNT+p.PAY_PROFIT)       AS ghest_mande,
      L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial AS tashilat
    FROM DADEKAVAN_DAY.PAYMENT p
    JOIN DADEKAVAN_DAY.LOAN l
    ON P.abrnchcod
      || P.lnminortp
      || P.cfcifno
      || P.crserial = L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial
    WHERE L.EFFDATE = VAR_ESFAND
      and trunc(p.PAY_DATE) >VAR_ESFAND
     and  SUBSTR(l.PRODUCTTYPECODE,0,3)<> 'L31'
     and L.STATE_ENDDAY                  = ANY('5','4','F','3')
    GROUP BY L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial
    )b ON L.abrnchcod
    || L.lnminortp
    || L.cfcifno
    || L.crserial = b.tashilat
  WHERE L.EFFDATE = VAR_ESFAND;
  commit;
    -- insert dadehaye bank (tashilat ) baraye VAR_PRE_MONTH(mah ghabl)

    INSERT
    /*+  PARALLEL(auto) */
  INTO TBL_LOAN_past
    (
      ID,
      COD_NOE_TASHILAT,
      NAM_NOE_TASHILAT,
      REF_SHOBE,
      TARIKH_TASHKIL,
      TARIKH_SARREDID,
      COD_BAKHSH_EGHTESADI,
      NAM_BAKHSH_EGHTESADI,
      MABLAGH_MOSAVVAB,
      ARZ,
      NERKH_SUD,
      COD_NAHVE_BAZ_PARDAKHT,
      -- NAM_NAHVE_BAZ_PARDAKHT,
      REF_MOSHTARI,
      MANDE_ASL_VAM,
      MANDE_SARRESID_GOZASHTE,
      MANDE_MASHKUKOLVOSUL,
      MANDE_MOAVVAGH,
      VAZIAT,
      TEDAD_AGHSAT,
      MANDE_KOL_VAM,
      effdate
    )
  SELECT L.abrnchcod
    || L.lnminortp
    || L.cfcifno
    || L.crserial AS tashilat,
    SUBSTR(l.PRODUCTTYPECODE,3,3),
    NT.TITLE,
    l.abrnchcod,
    l.crbgndt, 
      l.crenddt,
    SUBSTR(l.PRODUCTTYPECODE,6,1),
    REGEXP_SUBSTR(NT.TITLE, '[^/]+', 1,2),
    l.cracclim,
    l.acurrcode,
    l.prmainrt,
    l.CUST_BAZPARDAKHT_TYPE,
    l.cfcifno,
    l.MANDEH_ASL,
    l.MANDEH_SARRESIDGOZASHTE,
    l.MANDEH_MASHKOOK,
    l.MANDEH_MOAVAGH,
    l.state_endday,
    b.count_ghest,
    b.ghest_mande,
    VAR_PRE_MONTH
  FROM DADEKAVAN_DAY.LOAN l
  JOIN
    (SELECT DISTINCT TYPE_CODE,TITLE FROM DADEKAVAN_DAY.NOE_TASHILAT
    ) nt
  ON SUBSTR(L.PRODUCTTYPECODE,3,4) =SUBSTR(NT.TYPE_CODE,3,4)
  JOIN
    (SELECT COUNT(P.PAY_DATE) AS count_ghest,
      SUM(p.PAY_AMOUNT+p.PAY_PROFIT)       AS ghest_mande,
      L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial AS tashilat
    FROM DADEKAVAN_DAY.PAYMENT p
    JOIN DADEKAVAN_DAY.LOAN l
    ON P.abrnchcod
      || P.lnminortp
      || P.cfcifno
      || P.crserial = L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial
    WHERE L.EFFDATE = VAR_PRE_MONTH
      and trunc(p.PAY_DATE) >VAR_PRE_MONTH
     and  SUBSTR(l.PRODUCTTYPECODE,0,3)<> 'L31'
     and L.STATE_ENDDAY                  = ANY('5','4','F','3')
    GROUP BY L.abrnchcod
      || L.lnminortp
      || L.cfcifno
      || L.crserial
    )b ON L.abrnchcod
    || L.lnminortp
    || L.cfcifno
    || L.crserial = b.tashilat
  WHERE L.EFFDATE = VAR_PRE_MONTH;
  commit;
END;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_MANDE_RIALI_ARZI
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_REPORT_MANDE_RIALI_ARZI" (
  run_date IN date 
) 
AS
  VAR_PRE_MONTH DATE;
  VAR_PRE_YEAR  DATE;
  VAR_ESFAND    DATE;
BEGIN
/*
  Programmer Name:  MORTEZA.SA
  Release Date/Time:1395/10/13-10:00
  Version: 1.0
  Category:2
  Description:  gozaresh mande riali & arzi (zir menu gozareshat etebari)
  */
  VAR_PRE_YEAR  :=FNC_PRE_YEAR(run_date);
  VAR_PRE_MONTH :=FNC_PRE_MONTH(run_date);
  VAR_ESFAND    := FNC_ESFAND(run_date);
   EXECUTE IMMEDIATE 'TRUNCATE TABLE TBL_REPORT_MANDE_RIAL_ARZ';
  INSERT
  INTO TBL_REPORT_MANDE_RIAL_ARZ
    (
      NAME,
      PRE_YEAR,
      ESFAND,
      PRE_MONTH,
      CURRENT_MONTH,
      KOL_OR_GHAIRE_JARI
    )
    VALUES
    (
      'ريالي',
      NVL((SELECT SUM(MANDE_ASL_VAM+MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_PRE_YEAR
      AND ARZ = 'IRR'
      ),0),
      NVL((SELECT SUM(MANDE_ASL_VAM+MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_ESFAND
      AND ARZ = 'IRR'
      ),0),
      NVL((SELECT SUM(MANDE_ASL_VAM+MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_PRE_MONTH
      AND ARZ = 'IRR'
      ),0),
      NVL((SELECT SUM(MANDE_ASL_VAM+MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = TRUNC(run_date)
      AND ARZ = 'IRR'
      ),0
      ),1
    );
    COMMIT;
  INSERT
  INTO TBL_REPORT_MANDE_RIAL_ARZ
    (
      NAME,
      PRE_YEAR,
      ESFAND,
      PRE_MONTH,
      CURRENT_MONTH,
      KOL_OR_GHAIRE_JARI
    )
    VALUES
    (
      'ارزي',
      NVL((SELECT SUM(MANDE_ASL_VAM+MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_PRE_YEAR
      AND ARZ <>'IRR'
      ),0),
      NVL((SELECT SUM(MANDE_ASL_VAM+MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_ESFAND
      AND ARZ <>'IRR'
      ),0),
      NVL((SELECT SUM(MANDE_ASL_VAM+MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_PRE_MONTH
      AND ARZ <>'IRR'
      ),0),
      NVL((SELECT SUM(MANDE_ASL_VAM+MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate =  TRUNC(run_date)
      AND ARZ <>'IRR'
      ),0
      ),1
    );
        COMMIT;
  INSERT
  INTO TBL_REPORT_MANDE_RIAL_ARZ
    (
      NAME,
      PRE_YEAR,
      ESFAND,
      PRE_MONTH,
      CURRENT_MONTH,
      KOL_OR_GHAIRE_JARI
    )
    VALUES
    (
    'کل',
    (SELECT SUM(PRE_YEAR) FROM TBL_REPORT_MANDE_RIAL_ARZ WHERE kol_or_ghaire_jari =1 ),
        (SELECT SUM(ESFAND) FROM TBL_REPORT_MANDE_RIAL_ARZ WHERE kol_or_ghaire_jari =1 ),

    (SELECT SUM(PRE_MONTH) FROM TBL_REPORT_MANDE_RIAL_ARZ WHERE kol_or_ghaire_jari =1 ),
    (SELECT SUM(CURRENT_MONTH) FROM TBL_REPORT_MANDE_RIAL_ARZ WHERE kol_or_ghaire_jari =1 ),
    1
    );
COMMIT;



INSERT
  INTO TBL_REPORT_MANDE_RIAL_ARZ
    (
      NAME,
      PRE_YEAR,
      ESFAND,
      PRE_MONTH,
      CURRENT_MONTH,
      KOL_OR_GHAIRE_JARI
    )
    VALUES
    (
      'ريالي',
       NVL((SELECT SUM(MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_PRE_YEAR
      AND ARZ ='IRR'
      ),0),
      NVL((SELECT SUM(MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_ESFAND
      AND ARZ ='IRR'
      ),0),
      NVL((SELECT SUM(MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_PRE_MONTH
      AND ARZ ='IRR'
      ),0),
      NVL((SELECT SUM(MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate =  TRUNC(run_date)
      AND ARZ ='IRR'
      ),0
      ),2
    );
    COMMIT;
  INSERT
  INTO TBL_REPORT_MANDE_RIAL_ARZ
    (
      NAME,
      PRE_YEAR,
      ESFAND,
      PRE_MONTH,
      CURRENT_MONTH,
      KOL_OR_GHAIRE_JARI
    )
    VALUES
    (
      'ارزي',
       NVL((SELECT SUM(MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_PRE_YEAR
      AND ARZ <>'IRR'
      ),0),
      NVL((SELECT SUM(MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_ESFAND
      AND ARZ <>'IRR'
      ),0),
      NVL((SELECT SUM(MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_PRE_MONTH
      AND ARZ <>'IRR'
      ),0),
      NVL((SELECT SUM(MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate =  TRUNC(run_date)
      AND ARZ <>'IRR'
      ),0
      ),2
    );
        COMMIT;
  INSERT
  INTO TBL_REPORT_MANDE_RIAL_ARZ
    (
      NAME,
      PRE_YEAR,
      ESFAND,
      PRE_MONTH,
      CURRENT_MONTH,
      KOL_OR_GHAIRE_JARI
    )
    VALUES
    (
    'کل',
    (SELECT SUM(PRE_YEAR) FROM TBL_REPORT_MANDE_RIAL_ARZ WHERE kol_or_ghaire_jari =2),
        (SELECT SUM(ESFAND) FROM TBL_REPORT_MANDE_RIAL_ARZ  WHERE kol_or_ghaire_jari =2),

    (SELECT SUM(PRE_MONTH) FROM TBL_REPORT_MANDE_RIAL_ARZ WHERE kol_or_ghaire_jari =2),
    (SELECT SUM(CURRENT_MONTH) FROM TBL_REPORT_MANDE_RIAL_ARZ WHERE kol_or_ghaire_jari =2),
    2
    );




END;
--------------------------------------------------------
--  DDL for Procedure PRC_ALL_REPORT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_ALL_REPORT" 
(
  RUN_DATE IN DATE 
) AS 
BEGIN
/*
  Programmer Name:  MORTEZA.SA
  Release Date/Time:1395/10/15-10:00
  Version: 1.1
  Category:2
  Description: ejraye hame gozareshat marbot be zir menu gozareshat etebari va gheyre
  */
PRC_REPORT_5_SHOBE(RUN_DATE);
prc_report_MANDE_RIALI_ARZI(RUN_DATE);
PRC_REPORT_NPL_ISIC();
PRC_REPORT_NPL_TAGHIR_SHOAB(RUN_DATE);
PRC_REPORT_SAHM_AZ_KOL();
PRC_REPORT_SHAKHES_RISK(RUN_DATE);
PRC_REPORT_taghirat_npl_shoab(RUN_DATE);
PRC_REPORT8_BRANCH();
prc_report_MANDE_tashilat(RUN_DATE);
PRC_CHANGE_IN_TIME(run_date);
PRC_CREDIT_MAP(RUN_DATE);
prc_REPORT_TOZIE();

END PRC_ALL_REPORT;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_MANDE_TASHILAT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_REPORT_MANDE_TASHILAT" (
    run_date IN DATE )
AS
  VAR_PRE_MONTH DATE;
  VAR_PRE_YEAR  DATE;
  VAR_ESFAND    DATE;
BEGIN
/*
  Programmer Name:  MORTEZA.SA
  Release Date/Time:1395/10/13-10:00
  Version: 1.0
  Category:2
  Description:  gozaresh mande  tashilat 
  */
  VAR_PRE_YEAR  :=FNC_pre_year(run_date);
  VAR_PRE_MONTH :=FNC_pre_month(run_date);
  VAR_ESFAND    := FNC_ESFAND(run_date);
   EXECUTE IMMEDIATE 'TRUNCATE TABLE TBL_REPORT_MANDE_TASHILAT';
  INSERT
  INTO TBL_REPORT_MANDE_TASHILAT
    (
      PRE_YEAR,
      ESFAND,
      PRE_MONTH,
      CURRENT_MONTH,
      KOL_OR_GHAIRE_JARI
    )
    VALUES
    (
      NVL((SELECT SUM(MANDE_ASL_VAM+MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_PRE_YEAR
      ),0),
      NVL((SELECT SUM(MANDE_ASL_VAM+MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_ESFAND
      ),0),
      NVL((SELECT SUM(MANDE_ASL_VAM+MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_PRE_MONTH
      ),0),
      NVL((SELECT SUM(MANDE_ASL_VAM+MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = TRUNC(run_date)
      ),0
      ),1
    );
    COMMIT;
   INSERT
  INTO TBL_REPORT_MANDE_TASHILAT
    (
      PRE_YEAR,
      ESFAND,
      PRE_MONTH,
      CURRENT_MONTH,
      KOL_OR_GHAIRE_JARI
    )
    VALUES
    (
      NVL((SELECT SUM(MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_PRE_YEAR
      ),0),
      NVL((SELECT SUM(MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_ESFAND
      ),0),
      NVL((SELECT SUM(MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = VAR_PRE_MONTH
      ),0),
      NVL((SELECT SUM(MANDE_MOAVVAGH+MANDE_SARRESID_GOZASHTE+MANDE_MASHKUKOLVOSUL)
      FROM TBL_LOAN_PAST
      WHERE effdate = TRUNC(run_date)
      ),0
      ),0
    );
        COMMIT;

END;
--------------------------------------------------------
--  DDL for Procedure PRC_CHANGE_IN_TIME
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_CHANGE_IN_TIME" 
(
  RUN_DATE IN DATE 
) AS 
BEGIN
/*
  Programmer Name:  MORTEZA.SA
  Release Date/Time:1395/10/14-10:00
  Version: 1.0
  Category:2
  Description:  por kardan jadval tbl_change_in_time baraye rozhaye mokhtalef 
  */
INSERT
INTO TBL_CHANGE_IN_TIME
  (
    EDATE,
    MAX_PD,
    MIN_PD,
    AVG_PD,
    MAX_RR,
    MIN_RR,
    AVG_RR,
    TYPE_CODE,
    REF_SHOBE,
    REF_SHAHR,
    REF_OSTAN,
    NAM_SHOBE,
    sum_rwa,
    SUM_EAD
  )
  -- BA ESTEFADE AZ JADAVEL NAVIX , BRANCH VA LOAN hadeaghal , hadeaksare va miangin har yek az 
  -- mahiathaye pd ,rr jame rwa , ead be tafkik har shobe bedast miayad
SELECT MAX(to_char(trunc(RUN_DATE),'yyyy-mm-dd','nls_calendar=persian')),
  MAX(tn.PD),
  MIN(tn.PD),
  ROUND(AVG(tn.PD),5),
  MAX(tn.RR),
  MIN(tn.RR),
  ROUND(AVG(tn.RR),5),
  MAX(1),
  MAX(tl.REF_SHOBE),
  MAX(TB.COD_SHAHR),
  MAX( TB.COD_OSTAN),
  MAX(TB.NAM),
  sum(TN.RWA),
  SUM(EAD)
FROM TBL_NAVIX tn,
  TBL_BRANCH tb ,
  TBL_LOAN tl
WHERE TN.REF_TASHILAT = TL.ID
AND TL.REF_SHOBE      = TB.ID
GROUP BY TL.REF_SHOBE;
END PRC_CHANGE_IN_TIME;
--------------------------------------------------------
--  DDL for Procedure PRC_CREDIT_MAP
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_CREDIT_MAP" (
    RUN_DATE IN DATE)
AS
BEGIN
/*
  Programmer Name:  MORTEZA.SA & RASOOL
  Release Date/Time:1395/10/14-10:00
  Version: 1.0
  Category:2
  Description:  por kardan jadval TBL_CREDIT_MAP baraye rozhaye mokhtalef BE TAFKIK OSTAN
  */
  INSERT
  INTO TBL_CREDIT_MAP
    (ID,
      NAM_OSTAN,
      TEDAD_VAM,
      RWA,
      AVG_PD,
      AVG_RR,
      effdate,
      EAD
    )
    -- BA ESTEFADE AZ JADAVEL NAVIX , BRANCH VA LOAN BE TAFKIK OSTAN TEDAD VAM ,JAME RWA MIANGIN PD VA RR
    -- VA JAME EAD MOHASEBE MISHAVAD
    (SELECT tb.COD_OSTAN,
    MAX(tb.nam_ostan)           AS NAM_OSTAN,
        COUNT(DISTINCT tn.ref_tashilat) AS TEDAD_VAM,
        SUM(tn.rwa)                     AS RWA,
        ROUND(AVG(tn.pd),5)             AS AVG_PD,
        ROUND(AVG(tn.rr),5)             AS AVG_RR,
        MAX(TRUNC(RUN_DATE)),
        SUM(TN.EAD)
      FROM TBL_NAVIX tn,
        TBL_BRANCH tb ,
        TBL_LOAN tl
      WHERE TN.REF_TASHILAT = TL.ID
      AND TL.REF_SHOBE      = TB.ID
      GROUP BY tb.COD_OSTAN
    );
  COMMIT;
      -- BA ESTEFADE AZ JADVALE TBL_CRPLUS_RESULT BE TAFKIK OSTAN  EC VA VAR MOHASEBE MISHAVAD VA UPDATE MISHAVAD
  UPDATE TBL_CREDIT_MAP TCM
  SET EC=
    (SELECT TCR.EC 
    FROM nvw_crplus_ostan_range TCR
    WHERE TCR."eff_date"  =    to_char(TCM.EFFDATE,'yyyy-mm-dd','nls_calendar=persian')
    AND TCR.name = TCM.NAM_OSTAN
    ),
    VAR =
    (SELECT  TCR.CVAR
    FROM nvw_crplus_ostan_range TCR
    WHERE TCR."eff_date"  =    to_char(TCM.EFFDATE,'yyyy-mm-dd','nls_calendar=persian')
    AND TCR.name = TCM.NAM_OSTAN
    )
    WHERE TCM.EFFDATE = TRUNC(RUN_DATE);
  COMMIT;
END PRC_CREDIT_MAP;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_TOZIE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_REPORT_TOZIE" 
AS
BEGIN
  /*
  Programmer Name:  MORTEZA.SA
  Release Date/Time:1395/10/18-14:00
  Version: 1.0
  Category:2
  Description: POR KARDAN JADVAL TOZIE BARAYE JARIHA VA GHEYR JARIHA
  */
   EXECUTE IMMEDIATE 'TRUNCATE TABLE TBL_REPORT_TOZIE';
  INSERT
  INTO TBL_REPORT_TOZIE
    (
      ID,
      PD,
      RR,
      TYPE
    )--INSERT TASHILATI KE JARI HASTAND
  
select * from ( SELECT tn.REF_TASHILAT,
    tn.PD,
    tn.RR,
    1
  FROM TBL_NAVIX tn ,
    tbl_loan tl
  WHERE TL.ID                                                               = TN.REF_TASHILAT
  AND TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE =0
  ORDER BY TL.MABLAGH_MOSAVVAB DESC)
  where ROWNUM <501;
  COMMIT;
  INSERT INTO TBL_REPORT_TOZIE
    (ID, PD, RR, TYPE
    )--INSERT TASHILATI KE GHEYR JARI HASTAND
 select * from ( SELECT tn.REF_TASHILAT,
    tn.PD,
    tn.RR,
    2
  FROM TBL_NAVIX tn ,
    tbl_loan tl
  WHERE TL.ID                                                               = TN.REF_TASHILAT
  AND TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE <>0
  ORDER BY TL.MABLAGH_MOSAVVAB DESC)
  where ROWNUM <501;
  COMMIT;
END PRC_REPORT_TOZIE;
--------------------------------------------------------
--  DDL for Procedure PRC_CREDIT_RUN
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_CREDIT_RUN" 
(
  RUN_DATE IN DATE 
)
-------------------
  /*
  Programmer Name:  Morteza_Sa & Rasool
  Release Date:1395-10-21
  Version: 1.0
  Category:
  Description: Ejra kardan Kamel Risk Etebari : Shamel Ejray Bakhsh Mohasebati Va tamami Gozareshat
              --Tarikh Ejra Be mani roozi ast ke ghasd ejra system roy dadeh hay an rooz ra darim.
  */
-------------------
AS 
BEGIN
 DBMS_OUTPUT.PUT_LINE('Credit Risk System Started at: '||'  '||SYSTIMESTAMP ); 
--يکپارچه سازي ورودي هاي لازم براي محاسبه ريسک
PRC_INTEGERATE_INPUT(run_date);
 DBMS_OUTPUT.PUT_LINE('Credit Risk System => Input Integrated at: '||'  '||SYSTIMESTAMP ); 

--محاسبه احتمال نکول تسهيلات
PRC_PD_CALC();
DBMS_OUTPUT.PUT_LINE('Credit Risk System => PD Calculated at: '||'  '||SYSTIMESTAMP ); 

--انتقال داده هاي 4 روز که براي محاسبه گزارشات تاريخي نياز است .اين چهار روز 
--شامل :روز آخر سال گذشته ،روز آخر ماه گذشته ، روز آخر ماه مشابه در سال گذشته و امروز
PRC_ENTEGHAL_LOAN_PAST(run_date);

--محاسبه مقدار ريسک به روش آي آر بي و پر کردن جدول نويکس 
PRC_GENERATE_CR();
DBMS_OUTPUT.PUT_LINE('Credit Risk System =>Credit Risk Data Genarated at: '||'  '||SYSTIMESTAMP ); 

--اجرا و ساخت تمام گزارشات لازم در قالب يک روال
PRC_ALL_REPORT(run_date);
DBMS_OUTPUT.PUT_LINE('Credit Risk System =>Reports Created at: '||'  '||SYSTIMESTAMP ); 

--اجراي پراسيجر محاسبه ريسک اعتباري براي کل بانک
PRC_CR_RANGE();
DBMS_OUTPUT.PUT_LINE('Credit Risk System =>Crplus Report Created at: '||'  '||SYSTIMESTAMP ); 

--اجراي پروسيجر محاسبه ريسک اعتباري به تفکيک استان و تاريخ براي گزارش heat map
PRC_REPORT_HEATMAP();
DBMS_OUTPUT.PUT_LINE('Credit Risk System =>Heat Map Report Created at: '||'  '||SYSTIMESTAMP ); 

END PRC_CREDIT_RUN;
--------------------------------------------------------
--  DDL for Procedure PRC_GENERATE_CR_PLUS
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_GENERATE_CR_PLUS" 
(run_date date)
AS
  M FLOAT;
  B FLOAT;
  K FLOAT;
  RWA FLOAT;
  R FLOAT;
BEGIN
  /*
  Programmer Name:  MORTEZA.SA & RASOOL
  Release Date/Time:1395/10/21-13:15
  Version: 1.0
  Category:2
  Description: mohasebe risk etebari BE SORATE TARIKHI BARAYE ESTEFADE DAR CRPLUS(NEMODAR HEAT)
  */
  EXECUTE IMMEDIATE 'ALTER SESSION FORCE PARALLEL DML';
  --// pak kardan jadavel navix
  EXECUTE IMMEDIATE 'truncate table credit_risk.TBL_navix';
  FOR I IN
  ( SELECT DISTINCT TL.ID,
0||max(tpd.pd)  AS PD,-------------------????az code matlab bayad biad
  MAX(tl.mande_asl_vam) AS ead,
  CASE
    WHEN (1-((SUM(TC.ARZESH_VASIGHE)*max(TC.ZARIB_NAGHDINEGI))/ MAX(tl.MANDE_KOL_VAM+TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE)))<0
    THEN 0
    ELSE (1-((SUM(TC.ARZESH_VASIGHE)*max(TC.ZARIB_NAGHDINEGI))/ MAX(tl.MANDE_KOL_VAM+TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE)))
  END AS LGD,
  (1* MAX(tl.mande_asl_vam)*(
  CASE
    WHEN (1-((SUM(TC.ARZESH_VASIGHE)*max(TC.ZARIB_NAGHDINEGI))/ MAX(tl.MANDE_KOL_VAM+TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE)))<0
    THEN 0
    ELSE (1-((SUM(TC.ARZESH_VASIGHE)*max(TC.ZARIB_NAGHDINEGI))/ MAX(tl.MANDE_KOL_VAM+TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE)))
  END ) ) AS EL,
  CASE
    WHEN ( MAX(tl.MANDE_KOL_VAM+TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE)/(SUM(CASE WHEN TC.ARZESH_VASIGHE = 0 THEN '1' ELSE TC.ARZESH_VASIGHE END)*max(TC.ZARIB_NAGHDINEGI)))>1
    THEN 1
    ELSE( MAX(tl.MANDE_KOL_VAM+TL.MANDE_MASHKUKOLVOSUL+TL.MANDE_MOAVVAGH+TL.MANDE_SARRESID_GOZASHTE)/(SUM(CASE WHEN TC.ARZESH_VASIGHE = 0 THEN '1' ELSE TC.ARZESH_VASIGHE END)*max(TC.ZARIB_NAGHDINEGI)))
  END                                            AS rr,
  MAX( C.CATEGORY_ID)                            AS CATEGORY_ID,
  ROUND(COUNT(DISTINCT TP.TARIKH_SARRESID)/12,2) AS M
FROM TBL_LOAN_PAST tl
JOIN TBL_COLLATERAL tc
ON TL.ID = TC.REF_TASHILAT
JOIN TBL_LOAN_CATEGORY c
ON C.type_id = TL.COD_NOE_TASHILAT
JOIN TBL_PAYMENT TP
ON TP.REF_TASHILAT       = TL.id
JOIN tbl_pd TPd
ON tpd.REF_TASHILAT       = TL.id
WHERE TP.TARIKH_DARYAFT IS NULL
and TL.EFFDATE = trunc(run_date)
GROUP BY tl.id
  )
  LOOP
  
    m  :=0;
    r  :=0;
    b  :=0;
    k  :=0;
    rwa:=0;
    IF (I.CATEGORY_ID IN (1,2,3)) THEN ------  sherkati null null
      M                :=I.M;
      R                :=0.12          *(1-EXP(-50*I.PD))/(1-EXP(-50))+0.24 * (1-(1-EXP(-50*I.PD))/(1-EXP(-50)));
      B                :=power((0.11852-0.05478*LN(i.pd)),0.5);
      K                :=( (1          -I.rr) * FNC_NORMSDIST(POWER((1-R),(-0.5)) * FNC_NORMSINV(I.PD) + POWER((R/(1-R)),0.5) * FNC_NORMSINV(0.999))- I.PD * (1-I.RR))*(POWER((1-1.5*B),(-1))) * (1+(M-2.5)*B);
      RWA              := round(K,3)             *12.5 *I.EAD;
    ELSIF (I.CATEGORY_ID=4) THEN ------ manzele maskoni
      M                :=I.M;
      R                := 0.15;
      B                :=0;
      K                :=( (1-I.rr) * FNC_NORMSDIST(POWER((1-R),(-0.5)) * FNC_NORMSINV(I.PD) + POWER((R/(1-R)),0.5) * FNC_NORMSINV(0.999))- I.PD * (1-I.RR))*(POWER((1-1.5*B),(-1))) * (1+(M-2.5)*B);
      RWA              :=  round(K,3)       *12.5*I.EAD;
    ELSIF (I.CATEGORY_ID=5) THEN ------ tajdid shodani ba peyvaste
      M                :=I.M;
      R                := 0.04;
      B                :=0;
      K                :=( (1-I.rr) * FNC_NORMSDIST(POWER((1-R),(-0.5)) * FNC_NORMSINV(I.PD) + POWER((R/(1-R)),0.5) * FNC_NORMSINV(0.999))- I.PD * (1-I.RR))*(POWER((1-1.5*B),(-1))) * (1+(M-2.5)*B);
      RWA              :=  round(K,3)       *12.5*I.EAD;
    ELSIF (I.CATEGORY_ID=6) THEN ------sayer
      M                :=I.M;
      R                := 0.03 *( 1-EXP(-35 * I.PD))/(1-EXP(-35))+ 0.16 * (1-(1-EXP(-35 * I.PD))/(1-EXP(-35))) ;
      B                :=0;
      K                :=( (1-I.rr) * FNC_NORMSDIST(POWER((1-R),(-0.5)) * FNC_NORMSINV(I.PD) + POWER((R/(1-R)),0.5) * FNC_NORMSINV(0.999))- I.PD * (1-I.RR))*(POWER((1-1.5*B),(-1))) * (1+(M-2.5)*B);
      RWA              :=  round(K,3)       *12.5*I.EAD;
    END IF;
    INSERT INTO TBL_NAVIX
      ( REF_TASHILAT, PD, EAD, lgd, EL, RR, M, B, K, RWA, R
      )
    SELECT i.id,
      i.PD,
      i.EAD,
      i.lgd,
      round(i.EL,2),
      round(i.RR,2),
      M,
     round( B,9),
      round(K,3),
      round(CASE
        WHEN k<0
        THEN 0
        ELSE rwa
      END,9) ,
     round( R,9)
    FROM dual;
    COMMIT;
      END LOOP;
     END PRC_GENERATE_CR_plus;
--------------------------------------------------------
--  DDL for Procedure PRC_CR_RANGE_OSTAN
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_CR_RANGE_OSTAN" 
(
E_DATE IN DATE 
)
 AS 
--------------------------------------------------------------------------------
  /*
  Programmer Name:  NAVID
  Release Date/Time:1395/10/22-14:44
  Version: 1.0
  Category:2
  Description: taghsim bazeHa baraE CR+ be tafkik Ostan ha
  */
--------------------------------------------------------------------------------
-- Define Variables
type rang_detail IS VARRAY(31) OF NUMBER;
ranges rang_detail;
r1             NUMBER DEFAULT 0;
r2             NUMBER;
r3             NUMBER;
r4             NUMBER;
r5             NUMBER;
r6             NUMBER;
r7             NUMBER;
r8             NUMBER;
r9             NUMBER;
r10            NUMBER;
r11            NUMBER;
r12            NUMBER;
r13            NUMBER;
r14            NUMBER;
r15            NUMBER;
r16            NUMBER;
r17            NUMBER;
r18            NUMBER;
r19            NUMBER;
r20            NUMBER;
r21            NUMBER;
r22            NUMBER;
r23            NUMBER;
r24            NUMBER;
r25            NUMBER;
r26            NUMBER;
r27            NUMBER;
r28            NUMBER;
r29            NUMBER;
r30            NUMBER;
r31            NUMBER;
max_range      NUMBER;
range_count    NUMBER;
avg_pd         NUMBER;
EEAD2          NUMBER;
UEAD2          NUMBER;
pd_range_count NUMBER DEFAULT 0;
range_pd       NUMBER;
culm_range_pd  NUMBER DEFAULT 0;
CVAR2          NUMBER;
EC2            NUMBER;
--------------------------------------------------------------------------------
BEGIN
--------------------------------------------------------------------------------
--Truncate all table before system running
--EXECUTE IMMEDIATE 'truncate table tbl_range_ostan';
--EXECUTE IMMEDIATE 'truncate table tbl_range_detail_ostan';
--EXECUTE IMMEDIATE 'truncate table tbl_range_RESULT_ostan';
--------------------------------------------------------------------------------  
  --Initialized all variables
  for j in 1..31
  loop
  SELECT MAX(EAD) INTO max_range FROM tbl_navix navix,tbl_loan loan,tbl_branch branch 
  where navix.REF_TASHILAT=loan.ID and loan.REF_SHOBE= branch.ID and  branch.COD_OSTAN = j
  group by branch.COD_OSTAN;
  /*r2     := max_range/10;
  r3     :=r2        + r2;
  r4     :=r3        + r2;
  r5     :=r4        + r2;
  r6     :=r5        + r2;
  r7     :=r6        + r2;
  r8     :=r7        + r2;
  r9     :=r8        + r2;
  r10    :=r9        + r2;
  r11    :=max_range;*/
  
  r2:=17000000;
  r3:=19000000;
  r4:=22000000;
  r5:=25000000;
  r6:=30000000; 
  r7:=32000000;
  r8:=36000000;
  r9:=40000000;
  r10:=42500000;
  r11:=50000000;
  r12:=60000000;
  r13:=65000000;
  r14:=74000000;
  r15:=78000000;
  r16:=80000000;
  r17:=85000000;
  r18:=87000000;
  r19:=92000000;
  r20:=95500000;
  r21:=98000000;
  r22:=99000000;
  r23:=101000000;
  r24:=102000000;
  r25:=110000000;
  r26:=120000000;
  r27:=130000000;
  r28:=140000000;
  r29:=240000000;
  r30:=400000000;
  r31:=max_range;

  ranges := rang_detail(r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,
  r18,r19,r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31);
--------------------------------------------------------------------------------  
  --Main part of the procedures for filling the proper tables
  FOR i IN 1..30
  LOOP
    SELECT  COALESCE( (select COUNT(ref_tashilat)
    FROM tbl_navix navix,tbl_loan loan,tbl_branch branch
    where navix.REF_TASHILAT=loan.ID and loan.REF_SHOBE= branch.ID and branch.COD_OSTAN = j and (EAD >=ranges(i) AND EAD <ranges(i+1))
    group by branch.COD_OSTAN),0) into range_count from dual;

   SELECT  COALESCE( (select round(avg(pd),6)/100
    FROM tbl_navix navix,tbl_loan loan,tbl_branch branch
    where navix.REF_TASHILAT=loan.ID and loan.REF_SHOBE= branch.ID and branch.COD_OSTAN = j  and (EAD >=ranges(i) AND EAD <ranges(i+1))
    group by branch.COD_OSTAN),0) into avg_pd from dual;
 
    EEAD2:= avg_pd  * range_count*6* ranges(i+1);
    INSERT
    INTO TBL_RANGE_ostan
      (
        ID,
        PD,
        COUNT,
        EEAD,
        START_RANGE,
        END_RANGE,
        ostan_id
      )
      VALUES
      (
        i,
        avg_pd,
        range_count,
        EEAD2,
        ranges(i),
        ranges(i+1),
        j
     
      );
    COMMIT;
-------------------------------------------- ------------------------------------
    WHILE(FNC_POISSON_DISTRIBUTION(avg_pd * range_count,pd_range_count)> 0.0000009)
    LOOP
      range_pd := FNC_POISSON_DISTRIBUTION (avg_pd*range_count,pd_range_count);
      culm_range_pd  := culm_range_pd + range_pd;
      pd_range_count := pd_range_count +1;
      INSERT
      INTO TBL_RANGE_DETAIL_ostan
      
        (
          RANGE_ID,
          POISSON,
          CUMULATIVE_PO,
          ostan_id
        )
        VALUES
        (
          i,
          range_pd,
          culm_range_pd,
          j
        );
      COMMIT;
    END LOOP;
--------------------------------------------------------------------------------
    
      UEAD2 := pd_range_count*2 * ranges(i+1);
    
    CVAR2 := UEAD2 - EEAD2;
    EC2:= CVAR2 - EEAD2;
    INSERT
    INTO TBL_RANGE_RESULT_ostan
      (
        RANGE_ID,
        UEAD,
        CVAR,
        EEAD,
        EC,
        ostan_id,
        datee
      )
      VALUES
      (
        i,
        UEAD2,
        CVAR2,
        EEAD2,
        EC2,
        j,
        E_DATE 
      );
    COMMIT;
    range_pd       := 0;
    culm_range_pd  := 0;
    pd_range_count  :=0;
  END LOOP;
  End Loop;
--------------------------------------------------------------------------------  
END PRC_CR_RANGE_OSTAN;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT_HEATMAP
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_REPORT_HEATMAP" AS 

--------------------------------------------------------------------------------
/*
  Programmer Name:  MORTEZA.SA & NAVID
  Release Date/Time:1395/10/23-15:00
  Version: 1.0
  Category:2
  Description:  fill heat map with ostan_crplus 
  */
--------------------------------------------------------------------------------
BEGIN

 EXECUTE IMMEDIATE 'truncate table tbl_range_ostan';
 EXECUTE IMMEDIATE 'truncate table tbl_range_detail_ostan';
 EXECUTE IMMEDIATE 'truncate table tbl_range_RESULT_ostan';
 --EXECUTE IMMEDIATE 'truncate table tbl_credit_heat_map';
for i in (select distinct(effdate) as eff from TBL_LOAN_PAST  order by effdate asc)
loop
PRC_GENERATE_CR_PLUS(i.eff);
PRC_CR_RANGE_OSTAN(i.eff);
end loop;
END PRC_REPORT_HEATMAP;
--------------------------------------------------------
--  DDL for Procedure PRC_DELETE_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_DELETE_PROFILE" (
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

  IF (upper(INPAR_TYPE) <>'TBL_LEDGER' and upper(INPAR_TYPE) <> 'TARIKH' and upper(INPAR_TYPE) <>'BAZEH') THEN
    UPDATE tbl_profile SET STATUS = 0 WHERE H_ID = inpar_id;
    COMMIT;
    output:=NULL;
    
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
--  DDL for Procedure PRC_IS_EMPTY
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_IS_EMPTY" as 
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

     --====================
      /* in halghe for rooye satre jadvale tbl_timing_profile harekat mikonad va har profile 
    ra baresi mikonad ke aya dar jadvale tbl_timing_profile_detail meghdar darad ya na ?!*/

   --====================
end prc_is_empty;
--------------------------------------------------------
--  DDL for Procedure PRC_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_PROFILE" (
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    INPAR_CREATE_DATE      IN VARCHAR2 , 
    INPAR_REF_USER         IN VARCHAR2 ,   
    INPAR_STATUS           IN VARCHAR2 , 
    inpar_insert_or_update IN VARCHAR2 , --insert = 1  update = 0
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

---======HOSSEIIINNNNNNNNNN
--=======SENARA
--=======TEST

-----------------------------------------------------------------------------------------------------  
  
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
         DBMS_OUTPUT.PUT_LINE(var);

    EXECUTE IMMEDIATE 'select count(*)  from ('||var||')'  into cnt;
    DBMS_OUTPUT.PUT_LINE(var);
    update tbl_profile set item_cnt = nvl(cnt,0) where id = cnt_id;
    commit;
    --============
   
  
  
  
  



update tbl_profile 
set status = 0
where id not in (select max(id) from tbl_profile group by h_id);
commit;

UPDATE TBL_PROFILE TP
  SET
   TP.REPORT_CNT =0
 WHERE  TP.REPORT_CNT is null;
 commit;

prc_update_report_id();
--prc_update_dashboard_id();
prc_is_empty();


--notif

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
--  DDL for Procedure PRC_PROFILE_UPDATE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_PROFILE_UPDATE" (
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
  Programmer Name: NAVID
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
  IF (upper(INPAR_TYPE)='TBL_LOAN' OR upper(INPAR_TYPE)='TBL_DEPOSIT' OR upper(INPAR_TYPE)='TBL_BRANCH' OR upper(INPAR_TYPE)='TBL_CUSTOMER' OR upper(INPAR_TYPE)='TBL_CURRENCY' or upper(INPAR_TYPE)='TBL_GUARANTEE' or upper(INPAR_TYPE)='TBL_COLLATERAL' ) THEN
    SELECT MAX(id) INTO var_max_id FROM tbl_profile WHERE h_id=inpar_h_id;
    UPDATE tbl_profile
    SET DES          =INPAR_DES,
      UPDATE_DATE    =to_date(INPAR_UPDATE_DATE,'YYYY/MM/DD HH:MI:SS'),
      REF_USER_UPDATE=INPAR_REF_USER_UPDATE
    WHERE id         =var_max_id
    AND h_id         =inpar_h_id;
 end if;
    --------------------------------tbl_timing_profile
 --profile haye zamani dar jadval tbl_timing_profile gharar darand va mghadire be ruz resani shode dar in jadval  be ruz resani mishavand.   
 --akharin satr marbut be profile update mishavad 
  
 
    -------------------------tbl_ledger_profile
     --profile daftare kol dar jadval tbl_timing_profile gharar darand va mghadire be ruz resani shode dar in jadval  be ruz resani mishavand.   
 --akharin satr marbut be profile update mishavad 
 
  COMMIT;
  outpar:='1';
END PRC_PROFILE_UPDATE;
--------------------------------------------------------
--  DDL for Procedure PRC_SIMILAR_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_SIMILAR_PROFILE" 
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

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
end prc_similar_profile;
--------------------------------------------------------
--  DDL for Procedure PRC_REPORT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_REPORT" (
    INPAR_NAME             IN VARCHAR2 ,
    INPAR_DES              IN VARCHAR2 ,
    INPAR_TYPE             IN VARCHAR2 ,
    INPAR_REF_USER         IN VARCHAR2 ,
    INPAR_STATUS           IN VARCHAR2 ,
    inpar_insert_or_update IN VARCHAR2 , --insert = 1  update = 0
    inpar_id               IN VARCHAR2 ,
    inpar_loan             IN VARCHAR2,
    inpar_guarantee        IN VARCHAR2,
    inpar_collateral       IN VARCHAR2,
    inpar_branch           IN VARCHAR2,
    inpar_customer         IN VARCHAR2,
    outpar_id OUT VARCHAR2 )
AS
  var_count               NUMBER;
  var_version             NUMBER;
  max_id                  NUMBER;
  iidd                    NUMBER;
  INPAR_insert_or_update2 NUMBER;
  var_loan                NUMBER;
  var_GUARANTEE           NUMBER;
  var_COLLATERAL          NUMBER;
  var_BRANCH              NUMBER;
  var_customer            NUMBER;
  var CLOB;
  cnt    NUMBER;
  cnt_id NUMBER;
BEGIN
  SELECT MAX(id) INTO var_loan FROM tbl_profile WHERE h_id = inpar_loan;
  SELECT MAX(id)
  INTO var_GUARANTEE
  FROM tbl_profile
  WHERE h_id = inpar_guarantee;
  SELECT MAX(id)
  INTO var_COLLATERAL
  FROM tbl_profile
  WHERE h_id = inpar_collateral;
  SELECT MAX(id) INTO var_BRANCH FROM tbl_profile WHERE h_id = inpar_branch;
  SELECT MAX(id) INTO var_customer FROM tbl_profile WHERE h_id = inpar_customer;
  var_version:=1;
  --==========================
  IF (inpar_insert_or_update= 1) THEN
    INSERT
    INTO TBL_REPORT
      (
        NAME,
        DES,
        CREATE_DATE,
        REF_USER,
        STATUS,
        REF_LOAN,
        REF_GUARANTEE,
        REF_COLLATERAL,
        REF_BRANCH,
        REF_CUSTOMER,
        version,
        TYPE
      )
      VALUES
      (
        fnc_FarsiValidate(INPAR_NAME) ,
        INPAR_DES ,
        sysdate ,
        INPAR_REF_USER ,
        INPAR_STATUS,
        var_loan,
        var_guarantee ,
        var_collateral ,
        var_branch ,
        var_customer ,
        var_version,
        upper( INPAR_TYPE)
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
    FROM tbl_report
    WHERE id =
      (SELECT MAX(id) FROM tbl_report
      );
    -----------------------------------------------------------------------------
    UPDATE tbl_report
    SET H_ID = id
    WHERE id = outpar_id;
    COMMIT;
  ELSE
    ---baraE fahymidan inke bishtarn idiEE ke dar detail zakhire boode chi hast
    SELECT MAX(tbl_report.id)
    INTO max_id
    FROM tbl_report
    WHERE id = inpar_id
    GROUP BY h_id;
    INSERT
    INTO TBL_REPORT
      (
        NAME,
        DES,
        update_date,
        TYPE,
        create_date,
        REF_USER,
        ref_user_update,
        STATUS,
        REF_LOAN,
        REF_GUARANTEE,
        REF_COLLATERAL,
        REF_BRANCH,
        REF_CUSTOMER,
        version,
        h_id
      )
      VALUES
      (
        fnc_FarsiValidate(INPAR_NAME) ,
        INPAR_DES ,
        sysdate,
        upper( INPAR_TYPE) ,
        (SELECT MAX(create_date) FROM tbl_report WHERE H_ID = Inpar_id
        ),
        (SELECT MAX(ref_user) FROM tbl_report WHERE H_ID = Inpar_id
        ),
        INPAR_REF_USER,
        INPAR_STATUS,
        var_loan,
        var_guarantee ,
        var_collateral ,
        var_branch ,
        var_customer ,
        (SELECT MAX(version)+1 FROM tbl_report WHERE H_ID = Inpar_id
        ),
        (SELECT h_id FROM tbl_report WHERE id =inpar_id
        )
      );
    COMMIT;
    SELECT id
    INTO outpar_id
    FROM tbl_report
    WHERE id =
      (SELECT MAX(id) FROM tbl_report WHERE h_id = Inpar_id
      );
    --============================
  END IF;
  --========
  UPDATE tbl_report
  SET status    = 0
  WHERE id NOT IN
    (SELECT MAX(id) FROM tbl_report GROUP BY h_id
    );
  COMMIT;
  --========
END prc_report;
--------------------------------------------------------
--  DDL for Procedure PRC_DELETE_REPORT
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_DELETE_REPORT" (  inpar_ID IN NUMBER,
  outpar out VARCHAR2
) as 
var_h_id number;
begin
  select h_id into var_h_id from tbl_report where id = inpar_ID;
  
   update tbl_report set STATUS=0 where h_id=var_h_id;
   outpar:=null;
   update tbl_report set STATUS=0 where id=inpar_ID;
  
end prc_delete_report;
--------------------------------------------------------
--  DDL for Procedure PRC_UPDATE_REPORT_ID
--------------------------------------------------------

  CREATE OR REPLACE PROCEDURE "CREDIT_RISK"."PRC_UPDATE_REPORT_ID" as 

collateral number;
gurantee number;
loan number;

customer number;
branch number;

v_st number;

begin

   
for i in (select * from tbl_report) 
loop
    if(i.ref_loan is not null) then
    select max(id) into loan from tbl_profile
    where h_id in(
    select h_id from tbl_profile p
    where p.id in (select ref_loan from tbl_report r where  r.STATUS=1 and ref_loan = i.ref_loan ));
      update tbl_report 
      set ref_loan = loan
      where id = i.id and i.status =1;
      commit; 
    end if;
   
   
    if(i.REF_GUARANTEE is not null) then
    select max(id) into gurantee from tbl_profile
    where h_id in(
    select h_id from tbl_profile p
    where p.id in (select REF_GUARANTEE from tbl_report r where  r.STATUS=1 and REF_GUARANTEE = i.REF_GUARANTEE ));
      update tbl_report 
      set REF_GUARANTEE = gurantee
      where id = i.id and i.status =1;
      commit; 
    end if;
   
   
   
   
     if(i.REF_COLLATERAL is not null) then
    select max(id) into collateral from tbl_profile
    where h_id in(
    select h_id from tbl_profile p
    where p.id in (select REF_COLLATERAL from tbl_report r where  r.STATUS=1 and REF_COLLATERAL = i.REF_COLLATERAL ));
      update tbl_report 
      set REF_COLLATERAL = collateral
      where id = i.id and i.status =1;
      commit; 
    end if;
   
   
   
   
    if(i.REF_CUSTOMER is not null) then
    select max(id) into customer from tbl_profile
    where h_id in(
    select h_id from tbl_profile p
    where p.id in (select REF_CUSTOMER from tbl_report r where  r.STATUS=1 and REF_CUSTOMER = i.REF_CUSTOMER ));
      update tbl_report 
      set REF_CUSTOMER = customer
      where id = i.id and i.status =1 ;
      commit; 
    end if;
   
   
   
     if(i.REF_BRANCH is not null) then
    select max(id) into branch from tbl_profile
    where h_id in(
    select h_id from tbl_profile p
    where p.id in (select REF_BRANCH from tbl_report r where  r.STATUS=1 and REF_BRANCH = i.REF_BRANCH ));
      update tbl_report 
      set REF_BRANCH = branch
      where id = i.id and i.status = 1;
      commit; 
    end if;
   
   
   
end loop;


--===================================
end prc_update_report_id;
