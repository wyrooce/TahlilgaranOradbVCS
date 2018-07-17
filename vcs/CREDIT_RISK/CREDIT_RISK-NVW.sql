--------------------------------------------------------
--  DDL for View NVW_REPORT_LOAN_STATE
--------------------------------------------------------
SELECT SUM(MANDE_MASHKUKOLVOSUL) AS MASHKUK,               SUM(MANDE_SARRESID_GOZASHTE) AS SARRESID_GOZASHTE,               SUM(MANDE_MOAVVAGH) AS MOAVVAGH,               SUM(MABLAGH_MOSAVVAB) - SUM(MANDE_MASHKUKOLVOSUL) - SUM(MANDE_MASHKUKOLVOSUL) - SUM(MANDE_MOAVVAGH) AS MAMULI FROM TBL_LOAN
--------------------------------------------------------
--  DDL for View NVW_DEFERRED_LOAN_LGD
--------------------------------------------------------
SELECT lo.COD_NOE_TASHILAT AS "NO_TASHILAT" ,     MAX(     CASE       WHEN lo.NAM_NOE_TASHILAT IS NULL       THEN 'نوع تسهيلات'         || ' '         || lo.COD_NOE_TASHILAT       ELSE lo.NAM_NOE_TASHILAT     END)                   AS "NAM_TASHILAT",     SUM(lo.MANDE_MOAVVAGH) AS "MANDE_MOAVAGH" ,     ROUND(AVG(na.LGD),2)   AS "LGD"   FROM TBL_NAVIX na,     TBL_LOAN lo   WHERE na.REF_TASHILAT  = lo.ID   AND lo.MANDE_MOAVVAGH != 0   GROUP BY lo.COD_NOE_TASHILAT
--------------------------------------------------------
--  DDL for View NVW_TOP_FIVE_RISKY_BRANCH
--------------------------------------------------------
SELECT "MAX_PD_IN_SHOBE","BR_CODE","COD_SHAHR","NAM_SHOBE","NAM_SHAHR","PD" from(select max(na.ead) as "MAX_PD_IN_SHOBE", br.ID AS "BR_CODE" ,   max(br.cod_shahr) as "COD_SHAHR",   MAX(br.nam) as "NAM_SHOBE",   MAX(BR.NAM_SHAHR) AS "NAM_SHAHR",   round(AVG(na.ead),0) as "PD" FROM TBL_NAVIX na,   TBL_LOAN lo,   TBL_BRANCH br WHERE na.ref_tashilat = lo.id AND lo.ref_shobe      = br.id GROUP BY br.ID  ORDER BY avg(na.ead) desc) al where rownum           <=5 order by rownum
--------------------------------------------------------
--  DDL for View NVW_DEFERRED_LOAN_CV
--------------------------------------------------------
SELECT lo.COD_NOE_TASHILAT AS "نوع تسهيلات" ,     MAX(     CASE       WHEN lo.NAM_NOE_TASHILAT IS NULL       THEN 'نوع تسهيلات'         || ' '         || lo.COD_NOE_TASHILAT       ELSE lo.NAM_NOE_TASHILAT     END)                   AS "نام تسهيلات",    round( ((STDDEV(lo.MANDE_MOAVVAGH) / AVG(lo.MANDE_MOAVVAGH))),2) AS "ضريب تغييرات مانده معوق"   FROM TBL_NAVIX na,     TBL_LOAN lo   WHERE na.REF_TASHILAT  = lo.ID   AND lo.MANDE_MOAVVAGH != 0   GROUP BY lo.COD_NOE_TASHILAT
--------------------------------------------------------
--  DDL for View NVW_DEFERRED_LOAN_VARIANCE
--------------------------------------------------------
SELECT lo.COD_NOE_TASHILAT AS "نوع تسهيلات" ,     MAX(     CASE       WHEN lo.NAM_NOE_TASHILAT IS NULL       THEN 'نوع تسهيلات'         || ' '         || lo.COD_NOE_TASHILAT       ELSE lo.NAM_NOE_TASHILAT     END)                   AS "نام تسهيلات",    round( VARIANCE(lo.MANDE_MOAVVAGH),2) AS "انحراف از معيار مانده هاي معوق"   FROM TBL_NAVIX na,     TBL_LOAN lo   WHERE na.REF_TASHILAT  = lo.ID   AND lo.MANDE_MOAVVAGH != 0   GROUP BY lo.COD_NOE_TASHILAT
--------------------------------------------------------
--  DDL for View NVW_UI_LIST_MASTER_PROFILE
--------------------------------------------------------
SELECT   CASE     WHEN SUM(NVL2(R.REL_ABAR_NAMAYE,1,0)) = 0     THEN 1     ELSE 0   END "isEmpty",   M.ID "id",   MAX(M.NAM) "name",   MAX(M.VAZIAT) "status",   MAX(M.TOZIHAT) "description",   MAX(M.TARIKH_IJAD) "created",   MAX(M.NAM_SAZANDE) "createdBy",   SUBSTR(LOWER(MAX(M.JADVAL_ASLI)),5) "type",   MAX(M.SYSTEMI) "systemic" FROM CREDIT_RISK.TBL_PROFILE_MASTER M LEFT JOIN CREDIT_RISK.TBL_REL_PROFILE_MASTER_PROFILE R ON M.ID             = R.REL_ABAR_NAMAYE --WHERE M.JADVAL_ASLI = 'TBL_LOAN' GROUP BY M.ID
--------------------------------------------------------
--  DDL for View NVW_LOAN_TYPE_VARIANCE
--------------------------------------------------------
SELECT lo.COD_NOE_TASHILAT AS "نوع تسهيلات" ,     MAX(     CASE       WHEN lo.NAM_NOE_TASHILAT IS NULL       THEN 'نوع تسهيلات'         || ' '         || lo.COD_NOE_TASHILAT       ELSE lo.NAM_NOE_TASHILAT     END)                   AS "نام تسهيلات",     ROUND(VARIANCE(na.pd),2)   AS "واريانس"   FROM TBL_NAVIX na,     TBL_LOAN lo   WHERE na.REF_TASHILAT  = lo.ID   AND lo.MANDE_MOAVVAGH != 0   GROUP BY lo.COD_NOE_TASHILAT
--------------------------------------------------------
--  DDL for View NVW_RWA
--------------------------------------------------------
SELECT lo.COD_NOE_TASHILAT AS "نوع تسهيلات" ,     MAX(     CASE       WHEN lo.NAM_NOE_TASHILAT IS NULL       THEN 'نوع تسهيلات'         || ' '         || lo.COD_NOE_TASHILAT       ELSE lo.NAM_NOE_TASHILAT     END)                   AS "نام تسهيلات",    round( avg(na.rwa),2) AS "دارايي موزون شده به ريسك"   FROM TBL_NAVIX na,     TBL_LOAN lo   WHERE na.REF_TASHILAT  = lo.ID   AND lo.MANDE_MOAVVAGH != 0   GROUP BY lo.COD_NOE_TASHILAT
--------------------------------------------------------
--  DDL for View NVW_UI_LIST_PROFILE
--------------------------------------------------------
SELECT    P.ID "id",   MAX(P.NAM) "name",   SUBSTR(LOWER(MAX(P.JADVAL)),5) "type",   MAX(P.TOZIHAT) "description",   MAX(P.VAZIAT) "status",   MAX(P.NAM_SAZANDE) "createdBy",   MAX(P.TARIKH_IJAD) "created",   CASE WHEN SUM(NVL(R.REL_ABAR_NAMAYE, 0)) = 0 THEN 0 ELSE 1 END "isUsed" FROM TBL_PROFILE P LEFT JOIN (TBL_REL_PROFILE_MASTER_PROFILE R JOIN TBL_PROFILE_MASTER M ON M.ID = R.REL_ABAR_NAMAYE AND SYSTEMI = 0) ON P.ID = R.REL_NAMAYE GROUP BY P.ID
--------------------------------------------------------
--  DDL for View NVW_RWA_TAFKIK_BAKHSHHA
--------------------------------------------------------
WITH tmp AS   (SELECT round(SUM(tn.rwa),0)      AS rwa,     MAX(tlc.CATEGORY_NAME) AS CATEGORY_NAME,     tlc.CATEGORY_ID   FROM TBL_NAVIX tn,     TBL_LOAN tl,     (SELECT TYPE_ID,       CASE         WHEN CATEGORY_ID IS NULL         THEN 6         ELSE CATEGORY_ID       END AS CATEGORY_ID,       CASE         WHEN CATEGORY_NAME IS NULL         THEN 'خرد / ساير'         ELSE CATEGORY_NAME       END AS CATEGORY_NAME     FROM TBL_LOAN_CATEGORY     ) tlc   WHERE tlc.TYPE_ID   = tl.COD_NOE_TASHILAT   AND tn.REF_TASHILAT = tl.ID   GROUP BY tlc.CATEGORY_ID   )   select rwa as "value",CATEGORY_NAME as "name",CATEGORY_id as "id" from( SELECT SUM(round(rwa,0)) AS rwa , 'all' AS CATEGORY_NAME, 0 AS CATEGORY_id FROM tmp UNION SELECT * FROM tmp) order by CATEGORY_id
--------------------------------------------------------
--  DDL for View NVW_FIVE_TYPE_LOAN
--------------------------------------------------------
SELECT "SUM(RWA)" as "value","COD_NOE_TASHILAT" as "id","name"   FROM     (SELECT SUM(rwa),       TL.COD_NOE_TASHILAT,   max(case when TL.NAM_NOE_TASHILAT  is null then ' تسهيلات '||  tl.COD_NOE_TASHILAT else  TL.NAM_NOE_TASHILAT end) AS "name"     FROM TBL_NAVIX tn,       tbl_loan tl     WHERE tn.REF_TASHILAT = TL.ID     GROUP BY TL.COD_NOE_TASHILAT     ORDER BY SUM(rwa) DESC     )   WHERE ROWNUM <6
--------------------------------------------------------
--  DDL for View NVW_KHOLASE_IRB
--------------------------------------------------------
SELECT   ROUND(AVG(PD),3)  AS " احتمال نکول",   ROUND(AVG(r),3)   AS " همبستگي احتمال نکول",   ROUND(AVG(b),3)   AS " ضريب تعديل سررسيد",   ROUND(AVG(k),3)   AS " ضريب سرمايه موردنياز",   ROUND(AVG(lgd),3) AS "  ضريب زيان در صورت نكول"   FROM TBL_NAVIX
--------------------------------------------------------
--  DDL for View NVW_CUMULATIVE_DEFAULT
--------------------------------------------------------
SELECT ID "x", CUMULATIVE_PO "y", range_id                   FROM TBL_RANGE_DETAIL                   order by range_id, id
--------------------------------------------------------
--  DDL for View NVW_DENSITY_DEFAULT
--------------------------------------------------------
SELECT ID "x", POISSON "y", range_id                   FROM TBL_RANGE_DETAIL                   order by range_id, id
--------------------------------------------------------
--  DDL for View NVW_RANGE_build
--------------------------------------------------------
select range_id,eead as eead ,uead as uead,count,pd*100 as pd,cvar as cvar,r.START_RANGE,r.END_RANGE from tbl_range r, TBL_RANGE_RESULT rr where r.id = rr.range_id
--------------------------------------------------------
--  DDL for View NVW_RANGE_INFO
--------------------------------------------------------
SELECT "نام", "مقدار", "RANGE_ID" FROM "CREDIT_RISK"."NVW_RANGE_build" UNPIVOT ("مقدار" FOR "نام" IN ("EEAD" AS 'زيان منتظره', "UEAD" AS 'زيان غير منتظره', "COUNT" as 'تعداد تسهيلات', "PD" as 'احتمال نکول',"CVAR" as 'ارزش در معرض ريسک',"START_RANGE" as 'ابتداي بازه',"END_RANGE" as 'انتهاي بازه'))
--------------------------------------------------------
--  DDL for View RANGE_FINAL_RESULT
--------------------------------------------------------
SELECT  sum(CVAR) as CVaR,sum(EEAD) as EEAD,sum(UEAD) as UEAD,sum(EC) as EC from tbl_range r, TBL_RANGE_RESULT rr where r.id = rr.range_id
--------------------------------------------------------
--  DDL for View NVW_REPORT1
--------------------------------------------------------
SELECT SUM(MANDE_KOL_VAM)+SUM( MANDE_SARRESID_GOZASHTE)+SUM( MANDE_MASHKUKOLVOSUL) +SUM( MANDE_MOAVVAGH) AS mablagh ,   SUM(MANDE_SARRESID_GOZASHTE) as sarresid_gozashte,   SUM(MANDE_MOAVVAGH) as moavagh,   SUM(MANDE_MASHKUKOLVOSUL) as mashkukolvosoul,   SUM( MANDE_SARRESID_GOZASHTE)+SUM( MANDE_MASHKUKOLVOSUL) +SUM( MANDE_MOAVVAGH)     AS mablagh_kol,   round(((SUM( MANDE_SARRESID_GOZASHTE)+SUM( MANDE_MASHKUKOLVOSUL) +SUM( MANDE_MOAVVAGH))/(SUM(MANDE_KOL_VAM)+SUM( MANDE_SARRESID_GOZASHTE)+SUM( MANDE_MASHKUKOLVOSUL) +SUM( MANDE_MOAVVAGH)))*100,2) AS darsad FROM TBL_LOAN
--------------------------------------------------------
--  DDL for View NVW_RANGE_OVERVIEW
--------------------------------------------------------
select r.id , r.pd, r.START_RANGE ,r.END_RANGE ,ri.CVAR  from tbl_range r,tbl_range_result ri where ri.range_id=r.id
--------------------------------------------------------
--  DDL for View NVW_KEYFIAT_PORTFOLI_TAFKIK
--------------------------------------------------------
(SELECT SANAT,MABLAGH1,SAHM1,MABLAGH2,SAHM2,SHAKHES_RISK from TABLE_REPORT_S5) order by id
--------------------------------------------------------
--  DDL for View VTN1
--------------------------------------------------------
SELECT "NAME","MAH_JARI","MAH_GOZASHTE","DARSADE","MAH_JARI2","MAH_GOZASHTE2","DARSAD2","SHAKHES","ID" from (   SELECT "NAME","MAH_JARI","MAH_GOZASHTE","DARSADE","MAH_JARI2","MAH_GOZASHTE2","DARSAD2","SHAKHES","ID"       FROM TBL_REPORT_5_SHOBE order by SHAKHES DESC) where id <6
--------------------------------------------------------
--  DDL for View VTN2
--------------------------------------------------------
SELECT "ID","NAME","SHAKHES1","SHAKHES2","DARSAD"      FROM TBL_REPORT_TAGHIR_NPL_SHOAB order by DARSAD desc
--------------------------------------------------------
--  DDL for View VS2
--------------------------------------------------------
SELECT "TEDAD1","SAHM1","TEDAD2","SAHM2","ID"       FROM table_s1
--------------------------------------------------------
--  DDL for View VS1
--------------------------------------------------------
SELECT "NAME","ASL","SARRESID_GOZASHTE","MOAVAGH","MASHKOOK","SAYER","KHESARAT","TOTAL","DARSAD","ID" FROM  (SELECT       NAME,       ASL,       SARRESID_GOZASHTE,       MOAVAGH,       MASHKOOK,       SAYER,       KHESARAT,       TOTAL,       DARSAD,       ID     FROM       table_report8_branch        order by TOTAL desc) WHERE rownum <21
--------------------------------------------------------
--  DDL for View VS3
--------------------------------------------------------
select cu.nam,lo.MANDE_ASL_VAM, lo.MANDE_SARRESID_GOZASHTE,lo.MANDE_MOAVVAGH,lo.MANDE_MASHKUKOLVOSUL,0,0,lo.MANDE_KOL_VAM,round(lo.MANDE_ASL_VAM/lo.MANDE_KOL_VAM,2),lo.ID     from tbl_loan lo, tbl_customer cu     where cu.id = lo.ref_moshtari
--------------------------------------------------------
--  DDL for View NVW_REPORT2
--------------------------------------------------------
SELECT a."PRE_YEAR",     a."ESFAND",     a."PRE_MONTH",     a."CURRENT_MONTH",     a."BE_PRE_MONTH",     a."BE_ESFAND",     a."BE_PRE_YEAR",     b."PRE_YEAR",     b."ESFAND",     b."PRE_MONTH",     b."CURRENT_MONTH",     b."BE_PRE_MONTH",     b."BE_ESFAND",     b."BE_PRE_YEAR"   FROM     (SELECT PRE_YEAR,       ESFAND,       PRE_MONTH,       CURRENT_MONTH,       BE_ESFAND,       BE_PRE_MONTH,       BE_PRE_YEAR     FROM TBL_REPORT_MANDE_TASHILAT     WHERE kol_or_ghaire_jari = 1     ) b,     (SELECT PRE_YEAR,       ESFAND,       PRE_MONTH,       CURRENT_MONTH,       BE_ESFAND,       BE_PRE_MONTH,       BE_PRE_YEAR     FROM TBL_REPORT_MANDE_TASHILAT     WHERE kol_or_ghaire_jari = 0     )a
--------------------------------------------------------
--  DDL for View VIEW_REPORT_S5
--------------------------------------------------------
SELECT "ID","SANAT","MABLAGH1" , case when to_char("SAHM1") < 1 then  to_char(0||"SAHM1") else  to_char("SAHM1") end  ,"MABLAGH2", case when to_char("SAHM2") < 1 then  to_char(0||"SAHM2") else  to_char("SAHM2") end,   case when  to_char("SHAKHES_RISK") < 1 then  to_char(0||"SHAKHES_RISK") else  to_char(0||"SHAKHES_RISK") end     FROM TABLE_REPORT_S5
--------------------------------------------------------
--  DDL for View NVW_RISK_TAFKIK_ARZ
--------------------------------------------------------
(select SHAKHES,M1,M2,M3,M4,M5,M6,m7 from CREDIT_RISK.TBL_REPORT4_SHAKHES_RISK )order by id
--------------------------------------------------------
--  DDL for View NVW_REPORT_SAHM_AZ_KOL_NOE
--------------------------------------------------------
select "ID","NAME","VALUE","DARSAD","CODE_NOE" from TBL_REPORT_SAHM_AZ_KOL where ID = 1
--------------------------------------------------------
--  DDL for View NVW_REPORT_SAHM_AZ_KOL_RIAL
--------------------------------------------------------
select "ID","NAME","VALUE","DARSAD","CODE_NOE" from TBL_REPORT_SAHM_AZ_KOL where ID = 2
--------------------------------------------------------
--  DDL for View NVW_REPORT_SAHM_AZ_KOL_SHOBE
--------------------------------------------------------
select "ID","NAME","VALUE","DARSAD","CODE_NOE" from TBL_REPORT_SAHM_AZ_KOL where ID = 3
--------------------------------------------------------
--  DDL for View NVW_REPORT_SAHM_AZ_KOL_OSTAN
--------------------------------------------------------
select "ID","NAME","VALUE","DARSAD","CODE_NOE" from TBL_REPORT_SAHM_AZ_KOL where ID = 4
--------------------------------------------------------
--  DDL for View NVW_REPORT_SAHM_AZ_KOL_SHAHR
--------------------------------------------------------
select "ID","NAME","VALUE","DARSAD","CODE_NOE" from TBL_REPORT_SAHM_AZ_KOL where ID = 5
--------------------------------------------------------
--  DDL for View NVW_REPORT_BUBBLE
--------------------------------------------------------
SELECT   round(avg(TN.PD),5)as pd,  round(avg(TN.RR),5) as rr, round(SUM(TN.RWA),0) as rwa, max(TB.NAM_SHAHR) as shahr FROM TBL_LOAN tl,   tbl_navix tn,   TBL_BRANCH tb WHERE TN.REF_TASHILAT = TL.ID and TL.REF_SHOBE = TB.ID  GROUP BY TB.COD_SHAHR
--------------------------------------------------------
--  DDL for View NVW_CRPLUS_OSTAN_RANGE
--------------------------------------------------------
select ostan_id as ostan_id,to_char(trunc(datee),'yyyy-mm-dd','nls_calendar=persian') as eff_date,max(os.nam) as NAME, sum(eead) as EEAD, sum(cvar) as CVaR, sum(ec) as EC, sum(uead) as UEAD from tbl_range_result_ostan, tbl_ostan os where ostan_id = os.ID group by ostan_id,trunc(datee)
--------------------------------------------------------
--  DDL for View NVW_CREDIT_MAP_TARKIBI
--------------------------------------------------------
SELECT TCP.ID,   TCP.NAM_OSTAN,   TCP.EAD,   TCP.AVG_PD,   TCP.RWA,   NCOR.CVAR FROM TBL_CREDIT_MAP TCP,   NVW_CRPLUS_OSTAN_RANGE NCOR WHERE TCP.EFFDATE =   (SELECT MAX(EFFDATE) FROM TBL_CREDIT_MAP   ) AND   NCOR."ostan_id" = TCP.ID   AND NCOR."eff_date" = (SELECT MAX("eff_date") FROM  NVW_CRPLUS_OSTAN_RANGE)
--------------------------------------------------------
--  DDL for View NVW_CREDIT_VAR_MAP
--------------------------------------------------------
SELECT "ostan_id" AS ID,   NAME,     CVAR AS VAR,       EC ,       UEAD AS UL,       EEAD AS EL FROM NVW_CRPLUS_OSTAN_RANGE    WHERE  "eff_date" = (SELECT MAX("eff_date") FROM NVW_CRPLUS_OSTAN_RANGE )
--------------------------------------------------------
--  DDL for View NVW_REPORT_DASHBOARD_3D
--------------------------------------------------------
SELECT tl.cod_noe_tashilat as id,   MAX(tl.nam_noe_tashilat) as name,   ROUND(AVG(tn.PD),2) as pd,   COUNT(tl.id) as count,   ROUND(AVG(tn.RR),2) as rr   FROM TBL_NAVIX tn,   tbl_loan tl WHERE tn.ref_tashilat = tl.id GROUP BY tl.cod_noe_tashilat
