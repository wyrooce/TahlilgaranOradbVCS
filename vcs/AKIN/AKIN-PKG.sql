--------------------------------------------------------
--  DDL for Table PKG_TJR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "AKIN"."PKG_TJR" AS
 PROCEDURE PRC_TRANSFER_ACCOUNTING;

 PROCEDURE PRC_TRANSFER_DEPOSIT;

 PROCEDURE PRC_TRANSFER_LOAN;

 PROCEDURE PRC_TRANSFER_PAYMENT;

 PROCEDURE PRC_TRANSFER_DEPOSIT_PROFIT ( RUN_DATE DATE );

 PROCEDURE PRC_J_TRANSFER_DEPOSIT ( INPAR_DATE DATE );

 PROCEDURE PRC_J_TRANSFER_LOAN ( INPAR_DATE DATE );

 PROCEDURE PRC_J_TRANSFER_DEPOSIT_PROFIT (RUN_DATE  DATE);

 PROCEDURE PRC_J_TRANSFER_PAYMENT ( INPAR_DATE DATE );
 END PKG_TJR;
CREATE OR REPLACE PACKAGE BODY "AKIN"."PKG_TJR" AS

  PROCEDURE PRC_TRANSFER_ACCOUNTING  AS
  BEGIN
    -- TODO: Implementation required for PROCEDURE PKG_TJR."PRC_TRANSFER_ACCOUNTING"
EXECUTE IMMEDIATE 'truncate table akin.TBL_DEPOSIT_ACCOUNTING';
  EXECUTE IMMEDIATE 'truncate table akin.TBL_LOAN_ACCOUNTING';
  DELETE
  FROM TEJARAT_DB.gharardad
  WHERE NOT REGEXP_LIKE(SHO_GHAR, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(SHOB_CD, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(NOA_GHAR, '^[[:digit:]]+$');
  COMMIT;
  INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO akin.TBL_LOAN_ACCOUNTING
    (
      LON_ACC_ID,
LEDGER_CODE_SELF,
LEDGER_CODE_PROFIT
    )
    (SELECT DISTINCT
        /*+ PARALLEL(AUTO) */
        A.Acnt_no AS GOZINESH,
        CASE
          WHEN MAX(
            CASE
              WHEN ((SELECT COUNT(code_sarfasl_asl)
                FROM tbl_map_cbk
                WHERE TYPE  = 2
                AND ref_noe = g.NOA_GHAR) > 0)
              THEN
                (SELECT code_sarfasl_asl
                FROM tbl_map_cbk
                WHERE TYPE  = 2
                AND ref_noe = g.NOA_GHAR
                )
              ELSE 0
            END) = 0
          THEN MAX(TCT.id)
          ELSE MAX(
            CASE
              WHEN ((SELECT COUNT(code_sarfasl_asl)
                FROM tbl_map_cbk
                WHERE TYPE  = 2
                AND ref_noe = g.NOA_GHAR) > 0)
              THEN
                (SELECT code_sarfasl_asl
                FROM tbl_map_cbk
                WHERE TYPE  = 2
                AND ref_noe = g.NOA_GHAR
                )
              ELSE 0
            END)
        END AS REF_SARFASL_asl,
        MAX(
        CASE
          WHEN ((SELECT COUNT(code_sarfasl_sud)
            FROM tbl_map_cbk
            WHERE TYPE  = 2
            AND ref_noe = g.NOA_GHAR) > 0)
          THEN
            (SELECT code_sarfasl_sud
            FROM tbl_map_cbk
            WHERE TYPE  = 2
            AND ref_noe = g.NOA_GHAR
            )
          ELSE
            CASE
              WHEN g.NOA_GHAR IN (11,12)
              THEN 3208000800
              ELSE 3207700770
            END
        END) AS REF_SARFASL_sud
      FROM tejarat_db.nac a,
        CBI_TO_ID TCT,
        TEJARAT_DB.GHARARDAD g
      WHERE G.TAS_ACCNO_1 = A.ACNT_NO
      AND A.CBI_DB        = TCT.CODE
      AND a.CBI_DB IN (SELECT CBI_DB FROM TBL_VALID_CBI_DB)
      GROUP BY A.Acnt_no
    );
   INSERT
  /*+ APPEND PARALLEL(auto)   */
  INTO akin.TBL_DEPOSIT_ACCOUNTING
    (
      DEP_ACC_ID,
LEDGER_CODE_SELF,
LEDGER_CODE_PROFIT
    )
  SELECT
    /*+ PARALLEL(AUTO) */
    DISTINCT T.GOZINESH AS GOZINESH,
    T.REF_SARFASL_ASL,
    B.REF_SARFASL_SUD
  FROM
    (SELECT
      /*+ PARALLEL(AUTO) */
      S.ACNT_NO AS GOZINESH,
      CASE
        WHEN MAX(
          CASE
            WHEN ((SELECT COUNT(code_sarfasl_asl)
              FROM tbl_map_cbk
              WHERE TYPE  = 1
              AND ref_noe = S.GRP) > 0)
            THEN
              (SELECT code_sarfasl_asl
              FROM tbl_map_cbk
              WHERE TYPE  = 1
              AND ref_noe = S.GRP
              )
            ELSE 0
          END) = 0
        THEN MAX(TCT.id)
        ELSE MAX(
          CASE
            WHEN ((SELECT COUNT(code_sarfasl_asl)
              FROM tbl_map_cbk
              WHERE TYPE  = 1
              AND ref_noe = S.GRP) > 0)
            THEN
              (SELECT code_sarfasl_asl FROM tbl_map_cbk WHERE TYPE = 1 AND ref_noe = S.GRP
              )
            ELSE 0
          END)
      END AS REF_SARFASL_asl
    FROM TEJARAT_DB.SEPORDE S,
      TEJARAT_DB.NAC N,
      CBI_TO_ID TCT
    WHERE S.ACNT_NO = N.ACNT_NO
    AND N.CBI_DB    = TCT.CODE
    GROUP BY (S.ACNT_NO)
    ) T,
    (SELECT
      /*+ PARALLEL(AUTO) */
      S.ACNT_NO AS GOZINESH,
      CASE
        WHEN ((SELECT
            /*+ PARALLEL(AUTO) */
            COUNT(code_sarfasl_sud)
          FROM tbl_map_cbk
          WHERE TYPE  = 1
          AND ref_noe = S.GRP) > 0)
        THEN
          (SELECT code_sarfasl_sud FROM tbl_map_cbk WHERE TYPE = 1 AND ref_noe = S.GRP
          )
        ELSE 3112701270
      END AS REF_SARFASL_sud
    FROM TEJARAT_DB.SEPORDE S,
      TEJARAT_DB.NAC N,
      CBI_TO_ID TCT
    WHERE S.ACNT_NO = N.ACNT_NO
    AND N.CBI_DB    = TCT.CODE
    ) B
  WHERE T.GOZINESH = B.GOZINESH;
  COMMIT;
  INSERT
  /*+ APPEND PARALLEL(auto)   */
  INTO akin.TBL_DEPOSIT_ACCOUNTING
    (
      DEP_ACC_ID,
LEDGER_CODE_SELF,
LEDGER_CODE_PROFIT
    )
  SELECT
    /*+ PARALLEL(AUTO) */
    S.ACNT_NO AS GOZINESH,
    MAX(
    CASE
      WHEN ((SELECT COUNT(code_sarfasl_sud)
        FROM tbl_map_cbk
        WHERE TYPE  = 1
        AND ref_noe = S.GRP) > 0)
      THEN
        (SELECT code_sarfasl_sud
        FROM tbl_map_cbk
        WHERE TYPE  = 1
        AND ref_noe = S.GRP
        )
      ELSE 3112701270
    END) AS REF_SARFASL_sud,
    CASE
      WHEN MAX(
        CASE
          WHEN ((SELECT COUNT(code_sarfasl_asl)
            FROM tbl_map_cbk
            WHERE TYPE  = 1
            AND ref_noe = S.GRP) > 0)
          THEN
            (SELECT code_sarfasl_asl
            FROM tbl_map_cbk
            WHERE TYPE  = 1
            AND ref_noe = S.GRP
            )
          ELSE 0
        END) = 0
      THEN MAX(TCT.id)
      ELSE MAX(
        CASE
          WHEN ((SELECT COUNT(code_sarfasl_asl)
            FROM tbl_map_cbk
            WHERE TYPE  = 1
            AND ref_noe = S.GRP) > 0)
          THEN
            (SELECT code_sarfasl_asl FROM tbl_map_cbk WHERE TYPE = 1 AND ref_noe = S.GRP
            )
          ELSE 0
        END)
    END AS REF_SARFASL_asl
    -- 311270 AS REF_SARFASL_sud
  FROM TEJARAT_DB.SEPORDE_KOTAHMODAT S,
    TEJARAT_DB.NAC N,
    TJR_VARSA.CBI_TO_ID TCT
  WHERE S.ACNT_NO = N.ACNT_NO
  AND N.CBI_DB    = TCT.code
  GROUP BY S.ACNT_NO;
  COMMIT;
  INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO akin.TBL_DEPOSIT_ACCOUNTING
    (
    DEP_ACC_ID,
LEDGER_CODE_SELF,
LEDGER_CODE_PROFIT
    )
  SELECT s.DEP_ID,
    cti.id,
    3112701270
  FROM seporde s,
    CBI_TO_ID cti
  WHERE s.cbi = cti.code;
  commit;
  ------------------------------------------------------------
     END PRC_TRANSFER_ACCOUNTING;
     
     --*************************************************
          --*************************************************
     --*************************************************

     
     PROCEDURE PRC_TRANSFER_DEPOSIT as
     begin
     EXECUTE IMMEDIATE 'truncate table akin.tbl_deposit';

    INSERT
        /*+ APPEND PARALLEL(auto)   */
    INTO akin.tbl_deposit
      (
        DEP_ID,
        REF_DEPOSIT_TYPE,
        OPENING_DATE,
        DUE_DATE,
        RATE,
        REF_BRANCH,
        BALANCE,
        REF_CUSTOMER,
        REF_DEPOSIT_ACCOUNTING,
        MODALITY_TYPE,
        REF_CURRENCY
      )
      ( SELECT DISTINCT
     /*+ PARALLEL(AUTO) */
          a.Acnt_no                                                  AS DEP_ID,
          MAX(a.GRP)                                                 AS REF_DEPOSIT_TYPE,
          to_date( MAX(a.Open_dt),'yy/mm/dd','nls_calendar=persian') AS OPENING_DATE,
          to_date( MAX(a.EXP_DT),'yy/mm/dd','nls_calendar=persian')  AS DUE_DATE,
          TO_NUMBER(MAX((a.Rate/1000)+(nvl(Ratem,0)/100)))       AS RATE,
          MAX(a.BRNCH_CD)                                            AS REF_BRANCH,
          max(a.AMNT)                                                as BALANCE,
          case when MAX(b.MELLI) is not null then max(b.melli) else '99999' end  AS REF_CUSTOMER,
          max(a.ACNT_NO)                                             as REF_DEPOSIT_ACCOUNTING,
          case when MAX(T.NAHVE_TOZIE)is not null then MAX(T.NAHVE_TOZIE) else '1' end AS MODALITY_TYPE,
          max(4)                                                     as REF_CURRENCY
        FROM tejarat_db.SEPORDE a left outer join 
          (

  SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO AS ACNT,
            regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID  , '[[:space:]]*','')                AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NCOMPANY
            where MELLI_ID is not null and LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
          UNION
          SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO AS ACNT ,
           regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','')              AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NPERSON
            where cod_meli is not null and LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS  NULL  
          ) B
          on a.ACNT_NO =B.ACNT 
          left outer join  
          TBL_API_NOE_SEPORDE T
          on T.NOE_SEPORDE = A.GRP
        WHERE 
        SUBSTR((a.EXP_DT),1,4) >=substr(to_char(SYSDATE,'yyyy/mm/dd','nls_calendar=persian'),1,4)
        AND SUBSTR((a.EXP_DT), 5,2) BETWEEN 1 AND 12
        AND SUBSTR((a.EXP_DT),7,2) BETWEEN 1 AND 31
        and length(a.EXP_DT)=8
          AND SUBSTR((a.OPEN_DT), 5,2) BETWEEN 1 AND 12
        AND SUBSTR((a.OPEN_DT),7,2) BETWEEN 1 AND 31
        and length(a.OPEN_DT)=8
        AND a.exp_dt > to_char(SYSDATE,'yyyymmdd','nls_calendar=persian')
        AND a.Status_cd  != 4
        GROUP BY a.acnt_no
      );
    COMMIT;
    INSERT
 /*+ APPEND PARALLEL(auto)   */
 INTO akin.tbl_deposit
      (
        DEP_ID,
        REF_DEPOSIT_TYPE,
        OPENING_DATE,
        DUE_DATE,
        RATE,
        REF_BRANCH,
        BALANCE,
        REF_CUSTOMER,
        REF_DEPOSIT_ACCOUNTING,
        MODALITY_TYPE,
        REF_CURRENCY
      )
(SELECT
     /*+ PARALLEL(AUTO) */
          a.Acnt_no                                                  AS DEP_ID,
          MAX(a.GRP)            
          AS REF_DEPOSIT_TYPE,
           case when MAX(a.Open_dt) is null then sysdate else to_date(MAX(a.Open_dt),'yy/mm/dd','nls_calendar=persian') end AS OPENING_DATE,
          TO_DATE( max(a.EXP_DT),'yy/mm/dd','nls_calendar=persian')  as DUE_DATE,
          case when MAX(TAS.RATE) is not null then MAX(TAS.RATE) else 10 end  AS RATE,
          MAX(a.BRNCH_CD)                                            AS REF_BRANCH,
          max(a.AMNT)                                                as BALANCE,
           case when MAX(b.MELLI) is not null then max(b.melli) else '99999' end  AS REF_CUSTOMER,
          max(a.ACNT_NO)                                   as REF_DEPOSIT_ACCOUNTING,
          case when MAX(TAS.NAHVE_TOZIE)is not null then MAX(TAS.NAHVE_TOZIE) else '3' end AS MODALITY_TYPE,
          MAX(4)                                                     AS REF_CURRENCY
        from TEJARAT_DB.SEPORDE_KOTAHMODAT a
        left outer join
        TBL_API_NOE_SEPORDE TAS
        on TAS.NOE_SEPORDE= A.GRP 
        left outer join
            (

  SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO AS ACNT,
            regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID  , '[[:space:]]*','')                AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NCOMPANY
            where MELLI_ID is not null and LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
          UNION
          SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO AS ACNT ,
           regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','')              AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NPERSON
            where cod_meli is not null and LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS  NULL  
          ) B 
          on a.Acnt_no               =b.ACNT
          where a.amnt > 0--------------------------------------mym
              GROUP BY a.acnt_no
      );
  --v_seporde_tbl_number := FNC_SET_SEPORDE_EMRUZ();  -- AKHARE EJRAYE SYSTEM BASHE
  COMMIT;
  
  INSERT
   /*+ APPEND PARALLEL(auto)   */
INTO akin.tbl_deposit
  (
    DEP_ID,
    REF_DEPOSIT_TYPE,
    REF_BRANCH,
    REF_CUSTOMER,
    DUE_DATE,
    BALANCE,
    OPENING_DATE,
    RATE,
    REF_CURRENCY,
    MODALITY_TYPE,
    REF_DEPOSIT_ACCOUNTING
  )
SELECT s.DEP_ID,
  s.REF_DEPOSIT_TYPE,
  s.REF_BRANCH,
  s.REF_CUSTOMER,
  s.DUE_DATE,
  s.BALANCE,
  s.OPENING_DATE,
  s.RATE,
  s.REF_CURRENCY,
  a.tafkik,
  s.DEP_ID as REF_DEPOSIT_ACCOUNTING
FROM SEPORDE s,
  (SELECT NOE_SEPORDE, TAFKIK FROM TBL_SEPORDE_MODATDAR
  UNION
  SELECT NOE_SEPORDE, TAFKIK FROM TBL_SEPORDE_ROZ_SHOMAR
  )a
WHERE s.REF_DEPOSIT_TYPE = a.noe_seporde; 
commit;
  ------------ TARIKH KARABHA
        INSERT
         /*+ APPEND PARALLEL(auto)   */
    INTO akin.tbl_deposit
      (
        DEP_ID,
        REF_DEPOSIT_TYPE,
        OPENING_DATE,
        DUE_DATE,
        RATE,
        REF_BRANCH,
        BALANCE,
        REF_CUSTOMER,
        REF_DEPOSIT_ACCOUNTING,
        MODALITY_TYPE,
        REF_CURRENCY
      ) 
      ( SELECT DISTINCT
  /*+ PARALLEL(AUTO) */
  a.Acnt_no                     AS DEP_ID,
  MAX(a.GRP)                    AS REF_DEPOSIT_TYPE,
  TRUNC(SYSDATE)                AS OPENING_DATE,
  TRUNC(SYSDATE       +1)       AS DUE_DATE,
  TO_NUMBER(MAX(a.Rate/1000)) AS RATE,
  MAX(a.BRNCH_CD)               AS REF_BRANCH,
  MAX(a.AMNT)                   AS BALANCE,
  CASE
    WHEN MAX(b.MELLI) IS NOT NULL
    THEN MAX(b.melli)
    ELSE '99999'
  END            AS REF_CUSTOMER,
  MAX(a.ACNT_NO) AS REF_DEPOSIT_ACCOUNTING,
  CASE
    WHEN MAX(T.NAHVE_TOZIE)IS NOT NULL
    THEN MAX(T.NAHVE_TOZIE)
    ELSE '1'
  END    AS MODALITY_TYPE,
  MAX(4) AS REF_CURRENCY
FROM tejarat_db.SEPORDE a
LEFT OUTER JOIN
  (SELECT
    /*+ PARALLEL(AUTO) */
    DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO                             AS ACNT,
    regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID , '[[:space:]]*','') AS MELLI
  FROM TEJARAT_DB.CUSTOMER_NCOMPANY
  WHERE MELLI_ID                                          IS NOT NULL
  AND LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
  UNION
  SELECT
    /*+ PARALLEL(AUTO) */
    DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO                             AS ACNT ,
    regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','') AS MELLI
  FROM TEJARAT_DB.CUSTOMER_NPERSON
  WHERE cod_meli                                          IS NOT NULL
  AND LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS NULL
  ) B
ON a.ACNT_NO =B.ACNT
LEFT OUTER JOIN TBL_API_NOE_SEPORDE T
ON T.NOE_SEPORDE   = A.GRP
WHERE a.Status_cd != 4
AND a.Acnt_no NOT IN
  (SELECT akin.tbl_deposit.DEP_ID
  FROM akin.tbl_deposit
  )
   GROUP BY a.acnt_no
);
        COMMIT;
  
  
     end PRC_TRANSFER_DEPOSIT;
     
     --**************************************************
          --**************************************************

     --**************************************************

     PROCEDURE PRC_TRANSFER_LOAN AS
     BEGIN
     
     EXECUTE IMMEDIATE 'truncate table AKIN.TBL_LOAN';
  DELETE
  FROM TEJARAT_DB.gharardad
  WHERE NOT REGEXP_LIKE(SHO_GHAR, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(SHOB_CD, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(NOA_GHAR, '^[[:digit:]]+$');
  COMMIT;
      INSERT /*+ APPEND PARALLEL(auto)   */ INTO tbl_loan (
        approved_amount,
        opening_date,
        lon_id,
        ref_currency,
        ref_loan_type,
        ref_branch,
        ref_customer,
        ref_loan_accounting,
        rate,
        current_amount,
        overdue_amount,
        deferred_amount,
        doubtful_amount
    )
        ( SELECT /*+ PARALLEL(auto) */
            a.*,
            b.jari,
            b.sarresid,
            b.moavagh,
            b.mashkok
          FROM
            (
                SELECT
    /*+ PARALLEL(auto) */
                    MAX(mablagh_ghr),
                    TO_DATE(MAX(gharardad_date),'yy/mm/dd','nls_calendar=persian'),
                    TRIM(sho_ghar)
                    || TRIM(shob_cd)
                    || TRIM(noa_ghar) AS lon_id,
                    4,
                    MAX(noa_ghar),
                    MAX(shob_cd_ref),
                    CASE
                            WHEN MAX(n.melli) IS NOT NULL THEN MAX(n.melli)
                            ELSE '99999'
                        END
                    AS melli,
                    MAX(g.tas_accno_1),
                    MAX(g.nerkh_sood)
                FROM
                    tejarat_db.gharardad g
                    LEFT OUTER JOIN (
                        SELECT
      /*+ PARALLEL(AUTO) */ DISTINCT
                            tejarat_db.customer_ncompany.acnt_no AS acnt,
                            regexp_replace(tejarat_db.customer_ncompany.melli_id,'[[:space:]]*','') AS melli
                        FROM
                            tejarat_db.customer_ncompany
                        WHERE
                            melli_id IS NOT NULL
                            AND length(TRIM(translate(melli_id,'0123456789',' ') ) ) IS NULL
                        UNION
                        SELECT
      /*+ PARALLEL(AUTO) */ DISTINCT
                            tejarat_db.customer_nperson.acnt_no AS acnt,
                            regexp_replace(tejarat_db.customer_nperson.cod_meli,'[[:space:]]*','') AS melli
                        FROM
                            tejarat_db.customer_nperson
                        WHERE
                            cod_meli IS NOT NULL
                            AND length(TRIM(translate(cod_meli,'0123456789',' ') ) ) IS NULL
                    ) n ON g.tas_accno_1 = n.acnt
                WHERE
                    length(gharardad_date) = 6
                    AND 0 < substr( (gharardad_date),5,2)
                    AND substr( (gharardad_date),5,2) < 32
                    AND substr( (gharardad_date),1,2) > 70
                    AND amal_cd <> '5'
                    AND rc_stat = '0'
                GROUP BY
                    TRIM(sho_ghar)
                    || TRIM(shob_cd)
                    || TRIM(noa_ghar)
            ) a,
            (
                SELECT /*+ PARALLEL(auto) */ DISTINCT
                    TRIM(lpad(tb.cnt_no,9,0) )
                    || TRIM(lpad(tb.branch_cd,6,0) )
                    || TRIM(lpad(tb.cnt_type,3,0) ) AS id,
                    mblaslbedjari AS jari,
                    mblaslbedsar AS sarresid,
                    mblaslbedmoav AS moavagh,
                    mblaslbedmash AS mashkok
                FROM
                    tejarat_db.tas_balance tb
            ) b
          WHERE
            a.lon_id = b.id
        );
    
commit;
------------------------------------------------- takmil_hesabdari
INSERT  /*+ APPEND PARALLEL(auto)   */ INTO TBL_LOAN_ACCOUNTING(LON_ACC_ID, LEDGER_CODE_SELF, LEDGER_CODE_PROFIT)
WITH g AS (
SELECT LON_ID, REF_LOAN_ACCOUNTING
FROM AKIN.TBL_LOAN
WHERE REF_LOAN_ACCOUNTING NOT IN (SELECT TBL_LOAN_ACCOUNTING.LON_ACC_ID FROM TBL_LOAN_ACCOUNTING))
SELECT distinct REF_LOAN_ACCOUNTING, ID asl, 3107970797 sud
FROM g, tejarat_db.nac n, cbi_to_id c
WHERE g.REF_LOAN_ACCOUNTING = n.acnt_no AND c.code = n.cbi_db
and c.code IN (SELECT CBI_DB FROM TBL_VALID_CBI_DB);
--------------------------------------------------
    COMMIT;
  
  UPDATE TBL_LOAN_ACCOUNTING
  SET LEDGER_CODE_PROFIT = LEDGER_CODE_SELF
  WHERE LON_ACC_ID     IN
    (SELECT g.tas_accno_1
    FROM tbl_valid_cbi_db v,
      cbi_to_id c,
      archive_raw_bank_data.GHARARDAD g ,
      tejarat_db.nac n
    WHERE c.code     = v.cbi_db
    AND n.acnt_no    = g.tas_accno_1
    AND n.cbi_db     = v.cbi_db
    AND v.nahve_tajmi= 'asl+sud'
    );
    commit;
      UPDATE TBL_LOAN_ACCOUNTING
  SET LEDGER_CODE_PROFIT = LEDGER_CODE_SELF
  WHERE LON_ACC_ID     IN
    (SELECT g.tas_accno
    FROM tbl_valid_cbi_db v,
      cbi_to_id c,
      archive_raw_bank_data.Tas_Balance g ,
      tejarat_db.nac n
    WHERE c.code     = v.cbi_db
    AND n.acnt_no    = g.tas_accno
    AND n.cbi_db     = v.cbi_db
    AND v.nahve_tajmi= 'asl+sud'
    );
    commit;
     END PRC_TRANSFER_LOAN;
     
     
     --*********************************
     --*********************************
     --*********************************
     PROCEDURE prc_transfer_payment
as
begin
 EXECUTE IMMEDIATE 'truncate table  TBL_LOAN_PAYMENT';
  DELETE
  FROM TEJARAT_DB.AGHSAT
  WHERE NOT REGEXP_LIKE(AKNO_GH, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(AKCOD_SH, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(QARARDAD_TYPE, '^[[:digit:]]+$');
  COMMIT;
  INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO TBL_LOAN_PAYMENT
    (
      payment_number,
      ref_lon_id,
      profit_amount,
      DUE_DATE,
      amount
    )
    (SELECT 0,
        TASHILAT,
        SOD_MOSTATER_DAR_GHEST,
        TARIKH_SARRESID ,
        mablagh_ghest
      FROM
        (SELECT
          /*+ PARALLEL(AUTO) */
          0,
          TRIM(AKNO_GH)
          || TRIM(AKCOD_SH)
          || trim(QARARDAD_TYPE) AS TASHILAT ,
          CASE
            WHEN QARARDAD_TYPE IN (11,12)
            THEN DARAMAD_SAAL
            ELSE MBLGH_FAR_GHST
          END                                   AS SOD_MOSTATER_DAR_GHEST ,
          FNC_CHECK_VALID_DATE( SRCD_GHST_DATE) AS TARIKH_SARRESID,
          MBLGH_ASL_GHST                        AS mablagh_ghest
        FROM tejarat_db.Aghsat
        WHERE tejarat_db.aghsat.rec_typ_code ='3'
        AND TARIKH_DARYAFT                   = 0
        AND qarardad_type NOT               IN ('021','022','023','024','025','026')
          /* WHERE SUBSTR((SRCD_GHST_DATE), 1,2) >= 90
          AND SUBSTR((SRCD_GHST_DATE), 3,2) BETWEEN 1 AND 12
          AND SUBSTR((SRCD_GHST_DATE), 5,2) BETWEEN 1 AND 31
          AND LENGTH(SRCD_GHST_DATE)=6*/
        )
      WHERE TARIKH_SARRESID     IS NOT NULL
      AND TRUNC(TARIKH_SARRESID) > TRUNC(sysdate)
    );
  COMMIT;
  
  INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO TBL_LOAN_PAYMENT
    (
      payment_number,
      ref_lon_id,
      profit_amount,
      DUE_DATE,
      amount
    )
     SELECT 0,
  TRIM(a.AKNO_GH)
  || TRIM(a.AKCOD_SH)
  || trim(a.QARARDAD_TYPE),
  MAX(tb.mblsodbedjari) ,
 case when  tjr_varsa.FNC_CHECK_VALID_DATE(MAX(a.srcd_ghst_date)) < sysdate then  sysdate+1 else tjr_varsa.FNC_CHECK_VALID_DATE(MAX(a.srcd_ghst_date)) end ,
  MAX(tb.mblaslbedjari)
  FROM  (select t.TAR_EJRA,t.MBLASLBEDJARI,t.mblsodbedjari,r.tash from
(select  max(tb.TAR_EJRA) as TAR_EJRA,trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)) as tash from TEJARAT_DB.TAS_BALANCE tb
      group by trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)))r
      INNER JOIN TEJARAT_DB.TAS_BALANCE t
      on r.tash = trim(lpad(t.cnt_no,9,0))
      ||trim(lpad(t.branch_cd,6,0))
      ||trim(lpad(t.CNT_TYPE,3,0))
      and r.TAR_EJRA =t.TAR_EJRA
      and t.asnad_cd>'0'            and t.EKHTESASI_CD != 53

      ) tb ,
  tejarat_db.aghsat a
where TRIM(a.AKNO_GH)
  || TRIM(a.AKCOD_SH)
  || trim(a.QARARDAD_TYPE) =tb.tash
AND a.QARARDAD_TYPE      IN ('021','022','023','024','025','026')
AND NOT (tb.mblaslbedjari =0
AND tb.mblsodbedjari      = 0 )
--AND a.srcd_ghst_date      > TO_CHAR(sysdate,'yymmdd','nls_calendar=persian')
AND a.TARIKH_DARYAFT = 0
GROUP BY TRIM(a.AKNO_GH)
  || TRIM(a.AKCOD_SH)
  || trim(a.QARARDAD_TYPE) ; 
  COMMIT;
  -------------------------------------------- aghsati ke dar tas balance hast vali dar aghsat na
   INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO TBL_LOAN_PAYMENT
    (
      payment_number,
      ref_lon_id,
      profit_amount,
      DUE_DATE,
      amount
    )
  select * from (select 1,r.tash,t.mblsodbedjari,sysdate+1,t.MBLASLBEDJARI from
(select  max(tb.TAR_EJRA) as TAR_EJRA,trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)) as tash from TEJARAT_DB.TAS_BALANCE tb
      group by trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)))r
      INNER JOIN TEJARAT_DB.TAS_BALANCE t
      on r.tash = trim(lpad(t.cnt_no,9,0))
      ||trim(lpad(t.branch_cd,6,0))
      ||trim(lpad(t.CNT_TYPE,3,0))
      and r.TAR_EJRA =t.TAR_EJRA
      and t.asnad_cd>'0'            and t.EKHTESASI_CD != 53
and t.rc_stat = 0 and t.tabagheh != 4
      ) tb where tb.tash not in (select distinct ref_lon_id from TBL_LOAN_PAYMENT)
      and not (tb.mblaslbedjari=0 and tb.mblsodbedjari = 0);
  
  commit;
 
end prc_transfer_payment;
     --**************************************
     --**************************************
     --**************************************
     PROCEDURE PRC_TRANSFER_DEPOSIT_PROFIT ( RUN_DATE DATE ) AS
  /*
  Programmer Name: morteza sahi
  Release Date/Time:1396/05/12-10:00
  Version:
  Category: 
  Description: ijad sode sepordeha 
  */
 EFF_DATE   DATE;
 VAR        VARCHAR2(4000);
BEGIN
 EXECUTE IMMEDIATE 'ALTER SESSION FORCE PARALLEL DML';
 EXECUTE IMMEDIATE 'truncate table akin.TBL_DEPOSIT_INTEREST_PAYMENT';
  /***  bar asas tarikh sarresid sepordeha zaman pardakht sod va mablagh sod pardakhti ra taeen mikonim  ***/
 INSERT  /*+ APPEND PARALLEL(auto)   */ INTO TBL_DEPOSIT_INTEREST_PAYMENT ( REF_DEP_ID,DUE_DATE,PROFIT_AMOUNT ) WITH SEP AS (
  SELECT
      /*+  PARALLEL(auto) */
   ROUND(
    MONTHS_BETWEEN(
     E.DUE_DATE
    ,E.OPENING_DATE
    )
   ,0
   ) FASELE
  ,ROUND(
    MONTHS_BETWEEN(SYSDATE,E.OPENING_DATE)
   ,0
   ) FASEL
  ,E.DEP_ID
  ,E.REF_CURRENCY
  ,E.REF_CUSTOMER
  ,E.REF_DEPOSIT_TYPE
  ,E.REF_BRANCH
  ,E.DUE_DATE
  ,E.OPENING_DATE
  ,ROUND( (E.BALANCE * E.RATE) / 1200) AS BED
  ,HS.LEDGER_CODE_PROFIT
  ,E.MODALITY_TYPE
  FROM TBL_DEPOSIT E
  ,    TBL_DEPOSIT_ACCOUNTING HS
  WHERE HS.DEP_ACC_ID     = E.REF_DEPOSIT_ACCOUNTING
   AND
    E.DUE_DATE >= RUN_DATE
   AND
    E.MODALITY_TYPE   = 1
   AND
    E.BALANCE <> 0
 ),NUM AS (
  SELECT
   ROWNUM R
  FROM DUAL
  CONNECT BY
   ROWNUM <= 500
 )/*max FASELE MAHI EFF V END*/ SELECT
  SEP.DEP_ID
 ,ADD_MONTHS(
   SEP.OPENING_DATE
  ,NUM.R
  )
 ,SEP.BED
 FROM SEP
 ,    NUM
 WHERE NUM.R <= SEP.FASELE
  AND
   NUM.R > SEP.FASEL;

 COMMIT;
    
/*===========================================================*/
/*===========================================================*/
END PRC_TRANSFER_DEPOSIT_PROFIT;
       --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/

     
      PROCEDURE PRC_j_TRANSFER_DEPOSIT(inpar_date date) as 
     begin
     EXECUTE IMMEDIATE 'truncate table akin.tbl_deposit';

    INSERT
         /*+ APPEND PARALLEL(auto)   */
    INTO akin.tbl_deposit
      (
        DEP_ID,
        REF_DEPOSIT_TYPE,
        OPENING_DATE,
        DUE_DATE,
        RATE,
        REF_BRANCH,
        BALANCE,
        REF_CUSTOMER,
        REF_DEPOSIT_ACCOUNTING,
        MODALITY_TYPE,
        REF_CURRENCY
      )
      ( SELECT DISTINCT
     /*+ PARALLEL(AUTO) */
          a.Acnt_no                                                  AS DEP_ID,
          MAX(a.GRP)                                                 AS REF_DEPOSIT_TYPE,
          to_date( MAX(a.Open_dt),'yy/mm/dd','nls_calendar=persian') AS OPENING_DATE,
          to_date( MAX(a.EXP_DT),'yy/mm/dd','nls_calendar=persian')  AS DUE_DATE,
          TO_NUMBER(MAX((a.Rate/1000)+(nvl(Ratem,0)/100)))       AS RATE,
          MAX(a.BRNCH_CD)                                            AS REF_BRANCH,
          max(a.AMNT)                                                as BALANCE,
          case when MAX(b.MELLI) is not null then max(b.melli) else '99999' end  AS REF_CUSTOMER,
          max(a.ACNT_NO)                                             as REF_DEPOSIT_ACCOUNTING,
          case when MAX(T.NAHVE_TOZIE)is not null then MAX(T.NAHVE_TOZIE) else '1' end AS MODALITY_TYPE,
          max(4)                                                     as REF_CURRENCY
        FROM archive_raw_bank_data.SEPORDE a left outer join 
          (

  SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO AS ACNT,
            regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID  , '[[:space:]]*','')                AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NCOMPANY
            where MELLI_ID is not null and LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
          UNION
          SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO AS ACNT ,
           regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','')              AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NPERSON
            where cod_meli is not null and LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS  NULL  
          ) B
          on a.ACNT_NO =B.ACNT and A.EFF_DATE = inpar_date
          left outer join  
          TBL_API_NOE_SEPORDE T
          on T.NOE_SEPORDE = A.GRP
        WHERE 
        SUBSTR((a.EXP_DT),1,4) >=substr(to_char(SYSDATE,'yyyy/mm/dd','nls_calendar=persian'),1,4)
        AND SUBSTR((a.EXP_DT), 5,2) BETWEEN 1 AND 12
        AND SUBSTR((a.EXP_DT),7,2) BETWEEN 1 AND 31
        and length(a.EXP_DT)=8
          AND SUBSTR((a.OPEN_DT), 5,2) BETWEEN 1 AND 12
        AND SUBSTR((a.OPEN_DT),7,2) BETWEEN 1 AND 31
        and length(a.OPEN_DT)=8
        AND a.exp_dt > to_char(SYSDATE,'yyyymmdd','nls_calendar=persian')
        AND a.Status_cd  != 4
        GROUP BY a.acnt_no
      );
    COMMIT;
    INSERT
         /*+ APPEND PARALLEL(auto)   */
    INTO akin.tbl_deposit
      (
        DEP_ID,
        REF_DEPOSIT_TYPE,
        OPENING_DATE,
        DUE_DATE,
        RATE,
        REF_BRANCH,
        BALANCE,
        REF_CUSTOMER,
        REF_DEPOSIT_ACCOUNTING,
        MODALITY_TYPE,
        REF_CURRENCY
      )
(SELECT
     /*+ PARALLEL(AUTO) */
          a.Acnt_no                                                  AS DEP_ID,
          MAX(a.GRP)            
          AS REF_DEPOSIT_TYPE,
           case when MAX(a.Open_dt) is null then sysdate else to_date(MAX(a.Open_dt),'yy/mm/dd','nls_calendar=persian') end AS OPENING_DATE,
          TO_DATE( max(a.EXP_DT),'yy/mm/dd','nls_calendar=persian')  as DUE_DATE,
          case when MAX(TAS.RATE) is not null then MAX(TAS.RATE) else 10 end  AS RATE,
          MAX(a.BRNCH_CD)                                            AS REF_BRANCH,
          max(a.AMNT)                                                as BALANCE,
           case when MAX(b.MELLI) is not null then max(b.melli) else '99999' end  AS REF_CUSTOMER,
          max(a.ACNT_NO)                                   as REF_DEPOSIT_ACCOUNTING,
          case when MAX(TAS.NAHVE_TOZIE)is not null then MAX(TAS.NAHVE_TOZIE) else '3' end AS MODALITY_TYPE,
          MAX(4)                                                     AS REF_CURRENCY
        from archive_raw_bank_data.SEPORDE_KOTAHMODAT a
        left outer join
        TBL_API_NOE_SEPORDE TAS
        on TAS.NOE_SEPORDE= A.GRP  and A.EFF_DATE = inpar_date
        left outer join
            (

  SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO AS ACNT,
            regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID  , '[[:space:]]*','')                AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NCOMPANY
            where MELLI_ID is not null and LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
          UNION
          SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO AS ACNT ,
           regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','')              AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NPERSON
            where cod_meli is not null and LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS  NULL  
          ) B 
          on a.Acnt_no               =b.ACNT
          where a.amnt > 0--------------------------------------mym
              GROUP BY a.acnt_no
      );
  --v_seporde_tbl_number := FNC_SET_SEPORDE_EMRUZ();  -- AKHARE EJRAYE SYSTEM BASHE
  COMMIT;
  
  INSERT
   /*+ APPEND PARALLEL(auto)   */
INTO akin.tbl_deposit
  (
    DEP_ID,
    REF_DEPOSIT_TYPE,
    REF_BRANCH,
    REF_CUSTOMER,
    DUE_DATE,
    BALANCE,
    OPENING_DATE,
    RATE,
    REF_CURRENCY,
    MODALITY_TYPE,
    REF_DEPOSIT_ACCOUNTING
  )
SELECT s.DEP_ID,
  s.REF_DEPOSIT_TYPE,
  s.REF_BRANCH,
  s.REF_CUSTOMER,
  s.DUE_DATE,
  s.BALANCE,
  s.OPENING_DATE,
  s.RATE,
  s.REF_CURRENCY,
  a.tafkik,
  s.DEP_ID as REF_DEPOSIT_ACCOUNTING
FROM SEPORDE s,
  (SELECT NOE_SEPORDE, TAFKIK FROM TBL_SEPORDE_MODATDAR
  UNION
  SELECT NOE_SEPORDE, TAFKIK FROM TBL_SEPORDE_ROZ_SHOMAR
  )a
WHERE s.REF_DEPOSIT_TYPE = a.noe_seporde; 
commit;
  ------------ TARIKH KARABHA
        INSERT
       /*+ APPEND PARALLEL(auto)   */
    INTO akin.tbl_deposit
      (
        DEP_ID,
        REF_DEPOSIT_TYPE,
        OPENING_DATE,
        DUE_DATE,
        RATE,
        REF_BRANCH,
        BALANCE,
        REF_CUSTOMER,
        REF_DEPOSIT_ACCOUNTING,
        MODALITY_TYPE,
        REF_CURRENCY
      ) 
      ( SELECT DISTINCT
  /*+ PARALLEL(AUTO) */
  a.Acnt_no                     AS DEP_ID,
  MAX(a.GRP)                    AS REF_DEPOSIT_TYPE,
  TRUNC(SYSDATE)                AS OPENING_DATE,
  TRUNC(SYSDATE       +1)       AS DUE_DATE,
  TO_NUMBER(MAX(a.Rate/1000)) AS RATE,
  MAX(a.BRNCH_CD)               AS REF_BRANCH,
  MAX(a.AMNT)                   AS BALANCE,
  CASE
    WHEN MAX(b.MELLI) IS NOT NULL
    THEN MAX(b.melli)
    ELSE '99999'
  END            AS REF_CUSTOMER,
  MAX(a.ACNT_NO) AS REF_DEPOSIT_ACCOUNTING,
  CASE
    WHEN MAX(T.NAHVE_TOZIE)IS NOT NULL
    THEN MAX(T.NAHVE_TOZIE)
    ELSE '1'
  END    AS MODALITY_TYPE,
  MAX(4) AS REF_CURRENCY
FROM archive_raw_bank_data.SEPORDE a
LEFT OUTER JOIN
  (SELECT
    /*+ PARALLEL(AUTO) */
    DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO                             AS ACNT,
    regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID , '[[:space:]]*','') AS MELLI
  FROM TEJARAT_DB.CUSTOMER_NCOMPANY
  WHERE MELLI_ID                                          IS NOT NULL
  AND LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
  UNION
  SELECT
    /*+ PARALLEL(AUTO) */
    DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO                             AS ACNT ,
    regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','') AS MELLI
  FROM TEJARAT_DB.CUSTOMER_NPERSON
  WHERE cod_meli                                          IS NOT NULL
  AND LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS NULL
  ) B
ON a.ACNT_NO =B.ACNT  and A.EFF_DATE = inpar_date
LEFT OUTER JOIN TBL_API_NOE_SEPORDE T
ON T.NOE_SEPORDE   = A.GRP  and A.EFF_DATE = inpar_date
WHERE a.Status_cd != 4
AND a.Acnt_no NOT IN
  (SELECT akin.tbl_deposit.DEP_ID
  FROM akin.tbl_deposit
  )
   GROUP BY a.acnt_no
);
        COMMIT;
  end;
  
  --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
  --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
  --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
    
     PROCEDURE PRC_j_TRANSFER_LOAN(inpar_date date) AS
     BEGIN
     
     EXECUTE IMMEDIATE 'truncate table AKIN.TBL_LOAN';
  DELETE
  FROM TEJARAT_DB.gharardad
  WHERE NOT REGEXP_LIKE(SHO_GHAR, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(SHOB_CD, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(NOA_GHAR, '^[[:digit:]]+$');
  COMMIT;
    INSERT
     /*+ APPEND PARALLEL(auto)   */
  INTO AKIN.TBL_LOAN
    (
      APPROVED_AMOUNT,
      OPENING_DATE,
      LON_ID,
      REF_CURRENCY,
      REF_LOAN_TYPE,
      REF_BRANCH,
      REF_CUSTOMER,
      REF_LOAN_ACCOUNTING
    )
select a.* from 
    (
    SELECT
    /*+ PARALLEL(auto) */
    MAX(MABLAGH_GHR),
    to_date( MAX(GHARARDAD_DATE), 'yy/mm/dd','nls_calendar=persian'),
    trim(SHO_GHAR)
    ||trim(SHOB_CD)
    ||trim(NOA_GHAR) AS LON_ID,
    4,
    MAX(NOA_GHAR),
    MAX(SHOB_CD_ref),
    CASE
      WHEN MAX(n.MELLI) IS NOT NULL
      THEN MAX(n.MELLI)
      ELSE '99999'
    END AS melli,
    MAX(G.Tas_Accno_1)
  FROM archive_raw_bank_data.GHARARDAD G
  LEFT OUTER JOIN
    (SELECT
      /*+ PARALLEL(AUTO) */
      DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO                             AS ACNT,
      regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID , '[[:space:]]*','') AS MELLI
    FROM TEJARAT_DB.CUSTOMER_NCOMPANY
    WHERE MELLI_ID                                          IS NOT NULL
    AND LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
    UNION
    SELECT
      /*+ PARALLEL(AUTO) */
      DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO                             AS ACNT ,
      regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','') AS MELLI
    FROM TEJARAT_DB.CUSTOMER_NPERSON
    WHERE cod_meli                                          IS NOT NULL
    AND LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS NULL
    ) N
  ON G.Tas_Accno_1                 = N.Acnt
  WHERE LENGTH(GHARARDAD_DATE)     =6
  AND 0                            <SUBSTR((GHARARDAD_DATE), 5,2)
  AND SUBSTR((GHARARDAD_DATE), 5,2)<32
  AND SUBSTR((GHARARDAD_DATE), 1,2)>70
  and amal_cd <> '5'
  and RC_STAT ='0'
  GROUP BY trim(SHO_GHAR)
    ||trim(SHOB_CD)
    ||trim(NOA_GHAR)
    )a, (SELECT distinct 
  Trim(Lpad(Tb.Cnt_No,9,0))
      ||Trim(Lpad(Tb.Branch_Cd,6,0))
      ||Trim(Lpad(Tb.Cnt_Type,3,0)) as id
    FROM archive_raw_bank_data.Tas_Balance Tb where TB.EFF_DATE = inpar_date
    )b
    where a.LON_ID = b. id;
    
commit;
------------------------------------------------- takmil_hesabdari
INSERT  /*+ APPEND PARALLEL(auto)   */ INTO TBL_LOAN_ACCOUNTING(LON_ACC_ID, LEDGER_CODE_SELF,LEDGER_CODE_PROFIT )
WITH g AS (
SELECT LON_ID, REF_LOAN_ACCOUNTING
FROM AKIN.TBL_LOAN
WHERE REF_LOAN_ACCOUNTING NOT IN (SELECT TBL_LOAN_ACCOUNTING.LON_ACC_ID FROM TBL_LOAN_ACCOUNTING))
SELECT distinct REF_LOAN_ACCOUNTING, ID asl, 3107970797 sud
FROM g, tejarat_db.nac n, cbi_to_id c
WHERE g.REF_LOAN_ACCOUNTING = n.acnt_no AND c.code = n.cbi_db
and c.code IN (SELECT CBI_DB FROM TBL_VALID_CBI_DB);
--------------------------------------------------
  COMMIT;
  
  UPDATE TBL_LOAN_ACCOUNTING
  SET LEDGER_CODE_PROFIT = LEDGER_CODE_SELF
  WHERE LON_ACC_ID     IN
    (SELECT g.tas_accno_1
    FROM tbl_valid_cbi_db v,
      cbi_to_id c,
      archive_raw_bank_data.GHARARDAD g ,
      tejarat_db.nac n
    WHERE c.code     = v.cbi_db
    AND n.acnt_no    = g.tas_accno_1
    AND n.cbi_db     = v.cbi_db
    AND v.nahve_tajmi= 'asl+sud'
    and G.EFF_DATE =inpar_date
    );
    commit;
      UPDATE TBL_LOAN_ACCOUNTING
  SET LEDGER_CODE_PROFIT = LEDGER_CODE_SELF
  WHERE LON_ACC_ID     IN
    (SELECT g.tas_accno
    FROM tbl_valid_cbi_db v,
      cbi_to_id c,
      archive_raw_bank_data.Tas_Balance g ,
      tejarat_db.nac n
    WHERE c.code     = v.cbi_db
    AND n.acnt_no    = g.tas_accno
    AND n.cbi_db     = v.cbi_db
    AND v.nahve_tajmi= 'asl+sud'
    and G.EFF_DATE =inpar_date
    );
    commit;
     END PRC_j_TRANSFER_LOAN;
      
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     
  PROCEDURE PRC_J_TRANSFER_DEPOSIT_PROFIT ( RUN_DATE DATE ) AS
 
 EFF_DATE   DATE;
 VAR        VARCHAR2(4000);
BEGIN
 EXECUTE IMMEDIATE 'ALTER SESSION FORCE PARALLEL DML';
 EXECUTE IMMEDIATE 'truncate table akin.TBL_DEPOSIT_INTEREST_PAYMENT';
 /***  bar asas tarikh sarresid sepordeha zaman pardakht sod va mablagh sod pardakhti ra taeen mikonim  ***/
 INSERT  /*+ APPEND PARALLEL(auto)   */ INTO TBL_DEPOSIT_INTEREST_PAYMENT ( REF_DEP_ID,DUE_DATE,PROFIT_AMOUNT ) WITH SEP AS (
  SELECT
      /*+  PARALLEL(auto) */
   ROUND(
    MONTHS_BETWEEN(
     E.DUE_DATE
    ,E.OPENING_DATE
    )
   ,0
   ) FASELE
  ,ROUND(
    MONTHS_BETWEEN(SYSDATE,E.OPENING_DATE)
   ,0
   ) FASEL
  ,E.DEP_ID
  ,E.REF_CURRENCY
  ,E.REF_CUSTOMER
  ,E.REF_DEPOSIT_TYPE
  ,E.REF_BRANCH
  ,E.DUE_DATE
  ,E.OPENING_DATE
  ,ROUND( (E.BALANCE * E.RATE) / 1200) AS BED
  ,HS.LEDGER_CODE_PROFIT
  ,E.MODALITY_TYPE
  FROM TBL_DEPOSIT E
  ,    TBL_DEPOSIT_ACCOUNTING HS
  WHERE HS.DEP_ACC_ID     = E.REF_DEPOSIT_ACCOUNTING
   AND
    E.DUE_DATE >= RUN_DATE
   AND
    E.MODALITY_TYPE   = 1
   AND
    E.BALANCE <> 0
 ),NUM AS (
  SELECT
   ROWNUM R
  FROM DUAL
  CONNECT BY
   ROWNUM <= 500
 )/*max FASELE MAHI EFF V END*/ SELECT
  SEP.DEP_ID
 ,ADD_MONTHS(
   SEP.OPENING_DATE
  ,NUM.R
  )
 ,SEP.BED
 FROM SEP
 ,    NUM
 WHERE NUM.R <= SEP.FASELE
  AND
   NUM.R > SEP.FASEL;

 COMMIT;
    
/*===========================================================*/
/*===========================================================*/
END PRC_J_TRANSFER_DEPOSIT_PROFIT;

     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/

 PROCEDURE prc_j_transfer_payment(inpar_date date)
as
begin
 EXECUTE IMMEDIATE 'truncate table  TBL_LOAN_PAYMENT';
  DELETE
  FROM TEJARAT_DB.AGHSAT
  WHERE NOT REGEXP_LIKE(AKNO_GH, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(AKCOD_SH, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(QARARDAD_TYPE, '^[[:digit:]]+$');
  COMMIT;
  INSERT
   /*+ APPEND PARALLEL(auto)   */
  INTO TBL_LOAN_PAYMENT
    (
      payment_number,
      ref_lon_id,
      profit_amount,
      DUE_DATE,
      amount
    )
    (SELECT 0,
        TASHILAT,
        SOD_MOSTATER_DAR_GHEST,
        TARIKH_SARRESID ,
        mablagh_ghest
      FROM
        (SELECT
          /*+ PARALLEL(AUTO) */
          0,
          TRIM(AKNO_GH)
          || TRIM(AKCOD_SH)
          || trim(QARARDAD_TYPE) AS TASHILAT ,
          CASE
            WHEN QARARDAD_TYPE IN (11,12)
            THEN DARAMAD_SAAL
            ELSE MBLGH_FAR_GHST
          END                                   AS SOD_MOSTATER_DAR_GHEST ,
          FNC_CHECK_VALID_DATE( SRCD_GHST_DATE) AS TARIKH_SARRESID,
          MBLGH_ASL_GHST                        AS mablagh_ghest
        FROM archive_raw_bank_data.Aghsat
        WHERE archive_raw_bank_data.Aghsat.rec_typ_code ='3'
        AND TARIKH_DARYAFT                   = 0
        AND qarardad_type NOT               IN ('021','022','023','024','025','026')
        and ARCHIVE_RAW_BANK_DATA.AGHSAT.EFF_DATE = inpar_date
          /* WHERE SUBSTR((SRCD_GHST_DATE), 1,2) >= 90
          AND SUBSTR((SRCD_GHST_DATE), 3,2) BETWEEN 1 AND 12
          AND SUBSTR((SRCD_GHST_DATE), 5,2) BETWEEN 1 AND 31
          AND LENGTH(SRCD_GHST_DATE)=6*/
        )
      WHERE TARIKH_SARRESID     IS NOT NULL
      AND TRUNC(TARIKH_SARRESID) > TRUNC(sysdate)
    );
  COMMIT;
  
  INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO TBL_LOAN_PAYMENT
    (
      payment_number,
      ref_lon_id,
      profit_amount,
      DUE_DATE,
      amount
    )
     SELECT 0,
  TRIM(a.AKNO_GH)
  || TRIM(a.AKCOD_SH)
  || trim(a.QARARDAD_TYPE),
  MAX(tb.mblsodbedjari) ,
 case when  tjr_varsa.FNC_CHECK_VALID_DATE(MAX(a.srcd_ghst_date)) < sysdate then  sysdate+1 else tjr_varsa.FNC_CHECK_VALID_DATE(MAX(a.srcd_ghst_date)) end ,
  MAX(tb.mblaslbedjari)
  FROM  (select t.TAR_EJRA,t.MBLASLBEDJARI,t.mblsodbedjari,r.tash from
(select  max(tb.TAR_EJRA) as TAR_EJRA,trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)) as tash from archive_raw_bank_data.TAS_BALANCE tb
      group by trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)))r
      INNER JOIN archive_raw_bank_data.TAS_BALANCE t
      on r.tash = trim(lpad(t.cnt_no,9,0))
      ||trim(lpad(t.branch_cd,6,0))
      ||trim(lpad(t.CNT_TYPE,3,0))
      and r.TAR_EJRA =t.TAR_EJRA
      and t.asnad_cd>'0'            and t.EKHTESASI_CD != 53
      and T.EFF_DATE = inpar_date

      ) tb ,
  archive_raw_bank_data.Aghsat a
where TRIM(a.AKNO_GH)
  || TRIM(a.AKCOD_SH)
  || trim(a.QARARDAD_TYPE) =tb.tash
AND a.QARARDAD_TYPE      IN ('021','022','023','024','025','026')
AND NOT (tb.mblaslbedjari =0
AND tb.mblsodbedjari      = 0 )
and A.EFF_DATE = inpar_date
--AND a.srcd_ghst_date      > TO_CHAR(sysdate,'yymmdd','nls_calendar=persian')
AND a.TARIKH_DARYAFT = 0
GROUP BY TRIM(a.AKNO_GH)
  || TRIM(a.AKCOD_SH)
  || trim(a.QARARDAD_TYPE) ; 
  COMMIT;
  -------------------------------------------- aghsati ke dar tas balance hast vali dar aghsat na
   INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO TBL_LOAN_PAYMENT
    (
      payment_number,
      ref_lon_id,
      profit_amount,
      DUE_DATE,
      amount
    )
  select * from (select 1,r.tash,t.mblsodbedjari,sysdate+1,t.MBLASLBEDJARI from
(select  max(tb.TAR_EJRA) as TAR_EJRA,trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)) as tash from archive_raw_bank_data.TAS_BALANCE tb where     Tb.EFF_DATE =INPAR_DATE
      group by trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)))r
      INNER JOIN archive_raw_bank_data.TAS_BALANCE t
      on r.tash = trim(lpad(t.cnt_no,9,0))
      ||trim(lpad(t.branch_cd,6,0))
      ||trim(lpad(t.CNT_TYPE,3,0))
      and r.TAR_EJRA =t.TAR_EJRA
      and t.asnad_cd>'0'            and t.EKHTESASI_CD != 53
      and T.EFF_DATE =INPAR_DATE
       
and t.rc_stat = 0 and t.tabagheh != 4
      ) tb where tb.tash not in (select distinct ref_lon_id from TBL_LOAN_PAYMENT)
      and not (tb.mblaslbedjari=0 and tb.mblsodbedjari = 0);
  
  commit;
 
end prc_j_transfer_payment;

     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     
     

END PKG_TJR;
--------------------------------------------------------
--  DDL for Table PKG_TJR
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "AKIN"."PKG_TJR" AS
 PROCEDURE PRC_TRANSFER_ACCOUNTING;

 PROCEDURE PRC_TRANSFER_DEPOSIT;

 PROCEDURE PRC_TRANSFER_LOAN;

 PROCEDURE PRC_TRANSFER_PAYMENT;

 PROCEDURE PRC_TRANSFER_DEPOSIT_PROFIT ( RUN_DATE DATE );

 PROCEDURE PRC_J_TRANSFER_DEPOSIT ( INPAR_DATE DATE );

 PROCEDURE PRC_J_TRANSFER_LOAN ( INPAR_DATE DATE );

 PROCEDURE PRC_J_TRANSFER_DEPOSIT_PROFIT (RUN_DATE  DATE);

 PROCEDURE PRC_J_TRANSFER_PAYMENT ( INPAR_DATE DATE );
 END PKG_TJR;
CREATE OR REPLACE PACKAGE BODY "AKIN"."PKG_TJR" AS

  PROCEDURE PRC_TRANSFER_ACCOUNTING  AS
  BEGIN
    -- TODO: Implementation required for PROCEDURE PKG_TJR."PRC_TRANSFER_ACCOUNTING"
EXECUTE IMMEDIATE 'truncate table akin.TBL_DEPOSIT_ACCOUNTING';
  EXECUTE IMMEDIATE 'truncate table akin.TBL_LOAN_ACCOUNTING';
  DELETE
  FROM TEJARAT_DB.gharardad
  WHERE NOT REGEXP_LIKE(SHO_GHAR, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(SHOB_CD, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(NOA_GHAR, '^[[:digit:]]+$');
  COMMIT;
  INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO akin.TBL_LOAN_ACCOUNTING
    (
      LON_ACC_ID,
LEDGER_CODE_SELF,
LEDGER_CODE_PROFIT
    )
    (SELECT DISTINCT
        /*+ PARALLEL(AUTO) */
        A.Acnt_no AS GOZINESH,
        CASE
          WHEN MAX(
            CASE
              WHEN ((SELECT COUNT(code_sarfasl_asl)
                FROM tbl_map_cbk
                WHERE TYPE  = 2
                AND ref_noe = g.NOA_GHAR) > 0)
              THEN
                (SELECT code_sarfasl_asl
                FROM tbl_map_cbk
                WHERE TYPE  = 2
                AND ref_noe = g.NOA_GHAR
                )
              ELSE 0
            END) = 0
          THEN MAX(TCT.id)
          ELSE MAX(
            CASE
              WHEN ((SELECT COUNT(code_sarfasl_asl)
                FROM tbl_map_cbk
                WHERE TYPE  = 2
                AND ref_noe = g.NOA_GHAR) > 0)
              THEN
                (SELECT code_sarfasl_asl
                FROM tbl_map_cbk
                WHERE TYPE  = 2
                AND ref_noe = g.NOA_GHAR
                )
              ELSE 0
            END)
        END AS REF_SARFASL_asl,
        MAX(
        CASE
          WHEN ((SELECT COUNT(code_sarfasl_sud)
            FROM tbl_map_cbk
            WHERE TYPE  = 2
            AND ref_noe = g.NOA_GHAR) > 0)
          THEN
            (SELECT code_sarfasl_sud
            FROM tbl_map_cbk
            WHERE TYPE  = 2
            AND ref_noe = g.NOA_GHAR
            )
          ELSE
            CASE
              WHEN g.NOA_GHAR IN (11,12)
              THEN 3208000800
              ELSE 3207700770
            END
        END) AS REF_SARFASL_sud
      FROM tejarat_db.nac a,
        CBI_TO_ID TCT,
        TEJARAT_DB.GHARARDAD g
      WHERE G.TAS_ACCNO_1 = A.ACNT_NO
      AND A.CBI_DB        = TCT.CODE
      AND a.CBI_DB IN (SELECT CBI_DB FROM TBL_VALID_CBI_DB)
      GROUP BY A.Acnt_no
    );
   INSERT
  /*+ APPEND PARALLEL(auto)   */
  INTO akin.TBL_DEPOSIT_ACCOUNTING
    (
      DEP_ACC_ID,
LEDGER_CODE_SELF,
LEDGER_CODE_PROFIT
    )
  SELECT
    /*+ PARALLEL(AUTO) */
    DISTINCT T.GOZINESH AS GOZINESH,
    T.REF_SARFASL_ASL,
    B.REF_SARFASL_SUD
  FROM
    (SELECT
      /*+ PARALLEL(AUTO) */
      S.ACNT_NO AS GOZINESH,
      CASE
        WHEN MAX(
          CASE
            WHEN ((SELECT COUNT(code_sarfasl_asl)
              FROM tbl_map_cbk
              WHERE TYPE  = 1
              AND ref_noe = S.GRP) > 0)
            THEN
              (SELECT code_sarfasl_asl
              FROM tbl_map_cbk
              WHERE TYPE  = 1
              AND ref_noe = S.GRP
              )
            ELSE 0
          END) = 0
        THEN MAX(TCT.id)
        ELSE MAX(
          CASE
            WHEN ((SELECT COUNT(code_sarfasl_asl)
              FROM tbl_map_cbk
              WHERE TYPE  = 1
              AND ref_noe = S.GRP) > 0)
            THEN
              (SELECT code_sarfasl_asl FROM tbl_map_cbk WHERE TYPE = 1 AND ref_noe = S.GRP
              )
            ELSE 0
          END)
      END AS REF_SARFASL_asl
    FROM TEJARAT_DB.SEPORDE S,
      TEJARAT_DB.NAC N,
      CBI_TO_ID TCT
    WHERE S.ACNT_NO = N.ACNT_NO
    AND N.CBI_DB    = TCT.CODE
    GROUP BY (S.ACNT_NO)
    ) T,
    (SELECT
      /*+ PARALLEL(AUTO) */
      S.ACNT_NO AS GOZINESH,
      CASE
        WHEN ((SELECT
            /*+ PARALLEL(AUTO) */
            COUNT(code_sarfasl_sud)
          FROM tbl_map_cbk
          WHERE TYPE  = 1
          AND ref_noe = S.GRP) > 0)
        THEN
          (SELECT code_sarfasl_sud FROM tbl_map_cbk WHERE TYPE = 1 AND ref_noe = S.GRP
          )
        ELSE 3112701270
      END AS REF_SARFASL_sud
    FROM TEJARAT_DB.SEPORDE S,
      TEJARAT_DB.NAC N,
      CBI_TO_ID TCT
    WHERE S.ACNT_NO = N.ACNT_NO
    AND N.CBI_DB    = TCT.CODE
    ) B
  WHERE T.GOZINESH = B.GOZINESH;
  COMMIT;
  INSERT
  /*+ APPEND PARALLEL(auto)   */
  INTO akin.TBL_DEPOSIT_ACCOUNTING
    (
      DEP_ACC_ID,
LEDGER_CODE_SELF,
LEDGER_CODE_PROFIT
    )
  SELECT
    /*+ PARALLEL(AUTO) */
    S.ACNT_NO AS GOZINESH,
    MAX(
    CASE
      WHEN ((SELECT COUNT(code_sarfasl_sud)
        FROM tbl_map_cbk
        WHERE TYPE  = 1
        AND ref_noe = S.GRP) > 0)
      THEN
        (SELECT code_sarfasl_sud
        FROM tbl_map_cbk
        WHERE TYPE  = 1
        AND ref_noe = S.GRP
        )
      ELSE 3112701270
    END) AS REF_SARFASL_sud,
    CASE
      WHEN MAX(
        CASE
          WHEN ((SELECT COUNT(code_sarfasl_asl)
            FROM tbl_map_cbk
            WHERE TYPE  = 1
            AND ref_noe = S.GRP) > 0)
          THEN
            (SELECT code_sarfasl_asl
            FROM tbl_map_cbk
            WHERE TYPE  = 1
            AND ref_noe = S.GRP
            )
          ELSE 0
        END) = 0
      THEN MAX(TCT.id)
      ELSE MAX(
        CASE
          WHEN ((SELECT COUNT(code_sarfasl_asl)
            FROM tbl_map_cbk
            WHERE TYPE  = 1
            AND ref_noe = S.GRP) > 0)
          THEN
            (SELECT code_sarfasl_asl FROM tbl_map_cbk WHERE TYPE = 1 AND ref_noe = S.GRP
            )
          ELSE 0
        END)
    END AS REF_SARFASL_asl
    -- 311270 AS REF_SARFASL_sud
  FROM TEJARAT_DB.SEPORDE_KOTAHMODAT S,
    TEJARAT_DB.NAC N,
    TJR_VARSA.CBI_TO_ID TCT
  WHERE S.ACNT_NO = N.ACNT_NO
  AND N.CBI_DB    = TCT.code
  GROUP BY S.ACNT_NO;
  COMMIT;
  INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO akin.TBL_DEPOSIT_ACCOUNTING
    (
    DEP_ACC_ID,
LEDGER_CODE_SELF,
LEDGER_CODE_PROFIT
    )
  SELECT s.DEP_ID,
    cti.id,
    3112701270
  FROM seporde s,
    CBI_TO_ID cti
  WHERE s.cbi = cti.code;
  commit;
  ------------------------------------------------------------
     END PRC_TRANSFER_ACCOUNTING;
     
     --*************************************************
          --*************************************************
     --*************************************************

     
     PROCEDURE PRC_TRANSFER_DEPOSIT as
     begin
     EXECUTE IMMEDIATE 'truncate table akin.tbl_deposit';

    INSERT
        /*+ APPEND PARALLEL(auto)   */
    INTO akin.tbl_deposit
      (
        DEP_ID,
        REF_DEPOSIT_TYPE,
        OPENING_DATE,
        DUE_DATE,
        RATE,
        REF_BRANCH,
        BALANCE,
        REF_CUSTOMER,
        REF_DEPOSIT_ACCOUNTING,
        MODALITY_TYPE,
        REF_CURRENCY
      )
      ( SELECT DISTINCT
     /*+ PARALLEL(AUTO) */
          a.Acnt_no                                                  AS DEP_ID,
          MAX(a.GRP)                                                 AS REF_DEPOSIT_TYPE,
          to_date( MAX(a.Open_dt),'yy/mm/dd','nls_calendar=persian') AS OPENING_DATE,
          to_date( MAX(a.EXP_DT),'yy/mm/dd','nls_calendar=persian')  AS DUE_DATE,
          TO_NUMBER(MAX((a.Rate/1000)+(nvl(Ratem,0)/100)))       AS RATE,
          MAX(a.BRNCH_CD)                                            AS REF_BRANCH,
          max(a.AMNT)                                                as BALANCE,
          case when MAX(b.MELLI) is not null then max(b.melli) else '99999' end  AS REF_CUSTOMER,
          max(a.ACNT_NO)                                             as REF_DEPOSIT_ACCOUNTING,
          case when MAX(T.NAHVE_TOZIE)is not null then MAX(T.NAHVE_TOZIE) else '1' end AS MODALITY_TYPE,
          max(4)                                                     as REF_CURRENCY
        FROM tejarat_db.SEPORDE a left outer join 
          (

  SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO AS ACNT,
            regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID  , '[[:space:]]*','')                AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NCOMPANY
            where MELLI_ID is not null and LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
          UNION
          SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO AS ACNT ,
           regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','')              AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NPERSON
            where cod_meli is not null and LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS  NULL  
          ) B
          on a.ACNT_NO =B.ACNT 
          left outer join  
          TBL_API_NOE_SEPORDE T
          on T.NOE_SEPORDE = A.GRP
        WHERE 
        SUBSTR((a.EXP_DT),1,4) >=substr(to_char(SYSDATE,'yyyy/mm/dd','nls_calendar=persian'),1,4)
        AND SUBSTR((a.EXP_DT), 5,2) BETWEEN 1 AND 12
        AND SUBSTR((a.EXP_DT),7,2) BETWEEN 1 AND 31
        and length(a.EXP_DT)=8
          AND SUBSTR((a.OPEN_DT), 5,2) BETWEEN 1 AND 12
        AND SUBSTR((a.OPEN_DT),7,2) BETWEEN 1 AND 31
        and length(a.OPEN_DT)=8
        AND a.exp_dt > to_char(SYSDATE,'yyyymmdd','nls_calendar=persian')
        AND a.Status_cd  != 4
        GROUP BY a.acnt_no
      );
    COMMIT;
    INSERT
 /*+ APPEND PARALLEL(auto)   */
 INTO akin.tbl_deposit
      (
        DEP_ID,
        REF_DEPOSIT_TYPE,
        OPENING_DATE,
        DUE_DATE,
        RATE,
        REF_BRANCH,
        BALANCE,
        REF_CUSTOMER,
        REF_DEPOSIT_ACCOUNTING,
        MODALITY_TYPE,
        REF_CURRENCY
      )
(SELECT
     /*+ PARALLEL(AUTO) */
          a.Acnt_no                                                  AS DEP_ID,
          MAX(a.GRP)            
          AS REF_DEPOSIT_TYPE,
           case when MAX(a.Open_dt) is null then sysdate else to_date(MAX(a.Open_dt),'yy/mm/dd','nls_calendar=persian') end AS OPENING_DATE,
          TO_DATE( max(a.EXP_DT),'yy/mm/dd','nls_calendar=persian')  as DUE_DATE,
          case when MAX(TAS.RATE) is not null then MAX(TAS.RATE) else 10 end  AS RATE,
          MAX(a.BRNCH_CD)                                            AS REF_BRANCH,
          max(a.AMNT)                                                as BALANCE,
           case when MAX(b.MELLI) is not null then max(b.melli) else '99999' end  AS REF_CUSTOMER,
          max(a.ACNT_NO)                                   as REF_DEPOSIT_ACCOUNTING,
          case when MAX(TAS.NAHVE_TOZIE)is not null then MAX(TAS.NAHVE_TOZIE) else '3' end AS MODALITY_TYPE,
          MAX(4)                                                     AS REF_CURRENCY
        from TEJARAT_DB.SEPORDE_KOTAHMODAT a
        left outer join
        TBL_API_NOE_SEPORDE TAS
        on TAS.NOE_SEPORDE= A.GRP 
        left outer join
            (

  SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO AS ACNT,
            regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID  , '[[:space:]]*','')                AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NCOMPANY
            where MELLI_ID is not null and LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
          UNION
          SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO AS ACNT ,
           regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','')              AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NPERSON
            where cod_meli is not null and LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS  NULL  
          ) B 
          on a.Acnt_no               =b.ACNT
          where a.amnt > 0--------------------------------------mym
              GROUP BY a.acnt_no
      );
  --v_seporde_tbl_number := FNC_SET_SEPORDE_EMRUZ();  -- AKHARE EJRAYE SYSTEM BASHE
  COMMIT;
  
  INSERT
   /*+ APPEND PARALLEL(auto)   */
INTO akin.tbl_deposit
  (
    DEP_ID,
    REF_DEPOSIT_TYPE,
    REF_BRANCH,
    REF_CUSTOMER,
    DUE_DATE,
    BALANCE,
    OPENING_DATE,
    RATE,
    REF_CURRENCY,
    MODALITY_TYPE,
    REF_DEPOSIT_ACCOUNTING
  )
SELECT s.DEP_ID,
  s.REF_DEPOSIT_TYPE,
  s.REF_BRANCH,
  s.REF_CUSTOMER,
  s.DUE_DATE,
  s.BALANCE,
  s.OPENING_DATE,
  s.RATE,
  s.REF_CURRENCY,
  a.tafkik,
  s.DEP_ID as REF_DEPOSIT_ACCOUNTING
FROM SEPORDE s,
  (SELECT NOE_SEPORDE, TAFKIK FROM TBL_SEPORDE_MODATDAR
  UNION
  SELECT NOE_SEPORDE, TAFKIK FROM TBL_SEPORDE_ROZ_SHOMAR
  )a
WHERE s.REF_DEPOSIT_TYPE = a.noe_seporde; 
commit;
  ------------ TARIKH KARABHA
        INSERT
         /*+ APPEND PARALLEL(auto)   */
    INTO akin.tbl_deposit
      (
        DEP_ID,
        REF_DEPOSIT_TYPE,
        OPENING_DATE,
        DUE_DATE,
        RATE,
        REF_BRANCH,
        BALANCE,
        REF_CUSTOMER,
        REF_DEPOSIT_ACCOUNTING,
        MODALITY_TYPE,
        REF_CURRENCY
      ) 
      ( SELECT DISTINCT
  /*+ PARALLEL(AUTO) */
  a.Acnt_no                     AS DEP_ID,
  MAX(a.GRP)                    AS REF_DEPOSIT_TYPE,
  TRUNC(SYSDATE)                AS OPENING_DATE,
  TRUNC(SYSDATE       +1)       AS DUE_DATE,
  TO_NUMBER(MAX(a.Rate/1000)) AS RATE,
  MAX(a.BRNCH_CD)               AS REF_BRANCH,
  MAX(a.AMNT)                   AS BALANCE,
  CASE
    WHEN MAX(b.MELLI) IS NOT NULL
    THEN MAX(b.melli)
    ELSE '99999'
  END            AS REF_CUSTOMER,
  MAX(a.ACNT_NO) AS REF_DEPOSIT_ACCOUNTING,
  CASE
    WHEN MAX(T.NAHVE_TOZIE)IS NOT NULL
    THEN MAX(T.NAHVE_TOZIE)
    ELSE '1'
  END    AS MODALITY_TYPE,
  MAX(4) AS REF_CURRENCY
FROM tejarat_db.SEPORDE a
LEFT OUTER JOIN
  (SELECT
    /*+ PARALLEL(AUTO) */
    DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO                             AS ACNT,
    regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID , '[[:space:]]*','') AS MELLI
  FROM TEJARAT_DB.CUSTOMER_NCOMPANY
  WHERE MELLI_ID                                          IS NOT NULL
  AND LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
  UNION
  SELECT
    /*+ PARALLEL(AUTO) */
    DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO                             AS ACNT ,
    regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','') AS MELLI
  FROM TEJARAT_DB.CUSTOMER_NPERSON
  WHERE cod_meli                                          IS NOT NULL
  AND LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS NULL
  ) B
ON a.ACNT_NO =B.ACNT
LEFT OUTER JOIN TBL_API_NOE_SEPORDE T
ON T.NOE_SEPORDE   = A.GRP
WHERE a.Status_cd != 4
AND a.Acnt_no NOT IN
  (SELECT akin.tbl_deposit.DEP_ID
  FROM akin.tbl_deposit
  )
   GROUP BY a.acnt_no
);
        COMMIT;
  
  
     end PRC_TRANSFER_DEPOSIT;
     
     --**************************************************
          --**************************************************

     --**************************************************

     PROCEDURE PRC_TRANSFER_LOAN AS
     BEGIN
     
     EXECUTE IMMEDIATE 'truncate table AKIN.TBL_LOAN';
  DELETE
  FROM TEJARAT_DB.gharardad
  WHERE NOT REGEXP_LIKE(SHO_GHAR, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(SHOB_CD, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(NOA_GHAR, '^[[:digit:]]+$');
  COMMIT;
      INSERT /*+ APPEND PARALLEL(auto)   */ INTO tbl_loan (
        approved_amount,
        opening_date,
        lon_id,
        ref_currency,
        ref_loan_type,
        ref_branch,
        ref_customer,
        ref_loan_accounting,
        rate,
        current_amount,
        overdue_amount,
        deferred_amount,
        doubtful_amount
    )
        ( SELECT /*+ PARALLEL(auto) */
            a.*,
            b.jari,
            b.sarresid,
            b.moavagh,
            b.mashkok
          FROM
            (
                SELECT
    /*+ PARALLEL(auto) */
                    MAX(mablagh_ghr),
                    TO_DATE(MAX(gharardad_date),'yy/mm/dd','nls_calendar=persian'),
                    TRIM(sho_ghar)
                    || TRIM(shob_cd)
                    || TRIM(noa_ghar) AS lon_id,
                    4,
                    MAX(noa_ghar),
                    MAX(shob_cd_ref),
                    CASE
                            WHEN MAX(n.melli) IS NOT NULL THEN MAX(n.melli)
                            ELSE '99999'
                        END
                    AS melli,
                    MAX(g.tas_accno_1),
                    MAX(g.nerkh_sood)
                FROM
                    tejarat_db.gharardad g
                    LEFT OUTER JOIN (
                        SELECT
      /*+ PARALLEL(AUTO) */ DISTINCT
                            tejarat_db.customer_ncompany.acnt_no AS acnt,
                            regexp_replace(tejarat_db.customer_ncompany.melli_id,'[[:space:]]*','') AS melli
                        FROM
                            tejarat_db.customer_ncompany
                        WHERE
                            melli_id IS NOT NULL
                            AND length(TRIM(translate(melli_id,'0123456789',' ') ) ) IS NULL
                        UNION
                        SELECT
      /*+ PARALLEL(AUTO) */ DISTINCT
                            tejarat_db.customer_nperson.acnt_no AS acnt,
                            regexp_replace(tejarat_db.customer_nperson.cod_meli,'[[:space:]]*','') AS melli
                        FROM
                            tejarat_db.customer_nperson
                        WHERE
                            cod_meli IS NOT NULL
                            AND length(TRIM(translate(cod_meli,'0123456789',' ') ) ) IS NULL
                    ) n ON g.tas_accno_1 = n.acnt
                WHERE
                    length(gharardad_date) = 6
                    AND 0 < substr( (gharardad_date),5,2)
                    AND substr( (gharardad_date),5,2) < 32
                    AND substr( (gharardad_date),1,2) > 70
                    AND amal_cd <> '5'
                    AND rc_stat = '0'
                GROUP BY
                    TRIM(sho_ghar)
                    || TRIM(shob_cd)
                    || TRIM(noa_ghar)
            ) a,
            (
                SELECT /*+ PARALLEL(auto) */ DISTINCT
                    TRIM(lpad(tb.cnt_no,9,0) )
                    || TRIM(lpad(tb.branch_cd,6,0) )
                    || TRIM(lpad(tb.cnt_type,3,0) ) AS id,
                    mblaslbedjari AS jari,
                    mblaslbedsar AS sarresid,
                    mblaslbedmoav AS moavagh,
                    mblaslbedmash AS mashkok
                FROM
                    tejarat_db.tas_balance tb
            ) b
          WHERE
            a.lon_id = b.id
        );
    
commit;
------------------------------------------------- takmil_hesabdari
INSERT  /*+ APPEND PARALLEL(auto)   */ INTO TBL_LOAN_ACCOUNTING(LON_ACC_ID, LEDGER_CODE_SELF, LEDGER_CODE_PROFIT)
WITH g AS (
SELECT LON_ID, REF_LOAN_ACCOUNTING
FROM AKIN.TBL_LOAN
WHERE REF_LOAN_ACCOUNTING NOT IN (SELECT TBL_LOAN_ACCOUNTING.LON_ACC_ID FROM TBL_LOAN_ACCOUNTING))
SELECT distinct REF_LOAN_ACCOUNTING, ID asl, 3107970797 sud
FROM g, tejarat_db.nac n, cbi_to_id c
WHERE g.REF_LOAN_ACCOUNTING = n.acnt_no AND c.code = n.cbi_db
and c.code IN (SELECT CBI_DB FROM TBL_VALID_CBI_DB);
--------------------------------------------------
    COMMIT;
  
  UPDATE TBL_LOAN_ACCOUNTING
  SET LEDGER_CODE_PROFIT = LEDGER_CODE_SELF
  WHERE LON_ACC_ID     IN
    (SELECT g.tas_accno_1
    FROM tbl_valid_cbi_db v,
      cbi_to_id c,
      archive_raw_bank_data.GHARARDAD g ,
      tejarat_db.nac n
    WHERE c.code     = v.cbi_db
    AND n.acnt_no    = g.tas_accno_1
    AND n.cbi_db     = v.cbi_db
    AND v.nahve_tajmi= 'asl+sud'
    );
    commit;
      UPDATE TBL_LOAN_ACCOUNTING
  SET LEDGER_CODE_PROFIT = LEDGER_CODE_SELF
  WHERE LON_ACC_ID     IN
    (SELECT g.tas_accno
    FROM tbl_valid_cbi_db v,
      cbi_to_id c,
      archive_raw_bank_data.Tas_Balance g ,
      tejarat_db.nac n
    WHERE c.code     = v.cbi_db
    AND n.acnt_no    = g.tas_accno
    AND n.cbi_db     = v.cbi_db
    AND v.nahve_tajmi= 'asl+sud'
    );
    commit;
     END PRC_TRANSFER_LOAN;
     
     
     --*********************************
     --*********************************
     --*********************************
     PROCEDURE prc_transfer_payment
as
begin
 EXECUTE IMMEDIATE 'truncate table  TBL_LOAN_PAYMENT';
  DELETE
  FROM TEJARAT_DB.AGHSAT
  WHERE NOT REGEXP_LIKE(AKNO_GH, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(AKCOD_SH, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(QARARDAD_TYPE, '^[[:digit:]]+$');
  COMMIT;
  INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO TBL_LOAN_PAYMENT
    (
      payment_number,
      ref_lon_id,
      profit_amount,
      DUE_DATE,
      amount
    )
    (SELECT 0,
        TASHILAT,
        SOD_MOSTATER_DAR_GHEST,
        TARIKH_SARRESID ,
        mablagh_ghest
      FROM
        (SELECT
          /*+ PARALLEL(AUTO) */
          0,
          TRIM(AKNO_GH)
          || TRIM(AKCOD_SH)
          || trim(QARARDAD_TYPE) AS TASHILAT ,
          CASE
            WHEN QARARDAD_TYPE IN (11,12)
            THEN DARAMAD_SAAL
            ELSE MBLGH_FAR_GHST
          END                                   AS SOD_MOSTATER_DAR_GHEST ,
          FNC_CHECK_VALID_DATE( SRCD_GHST_DATE) AS TARIKH_SARRESID,
          MBLGH_ASL_GHST                        AS mablagh_ghest
        FROM tejarat_db.Aghsat
        WHERE tejarat_db.aghsat.rec_typ_code ='3'
        AND TARIKH_DARYAFT                   = 0
        AND qarardad_type NOT               IN ('021','022','023','024','025','026')
          /* WHERE SUBSTR((SRCD_GHST_DATE), 1,2) >= 90
          AND SUBSTR((SRCD_GHST_DATE), 3,2) BETWEEN 1 AND 12
          AND SUBSTR((SRCD_GHST_DATE), 5,2) BETWEEN 1 AND 31
          AND LENGTH(SRCD_GHST_DATE)=6*/
        )
      WHERE TARIKH_SARRESID     IS NOT NULL
      AND TRUNC(TARIKH_SARRESID) > TRUNC(sysdate)
    );
  COMMIT;
  
  INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO TBL_LOAN_PAYMENT
    (
      payment_number,
      ref_lon_id,
      profit_amount,
      DUE_DATE,
      amount
    )
     SELECT 0,
  TRIM(a.AKNO_GH)
  || TRIM(a.AKCOD_SH)
  || trim(a.QARARDAD_TYPE),
  MAX(tb.mblsodbedjari) ,
 case when  tjr_varsa.FNC_CHECK_VALID_DATE(MAX(a.srcd_ghst_date)) < sysdate then  sysdate+1 else tjr_varsa.FNC_CHECK_VALID_DATE(MAX(a.srcd_ghst_date)) end ,
  MAX(tb.mblaslbedjari)
  FROM  (select t.TAR_EJRA,t.MBLASLBEDJARI,t.mblsodbedjari,r.tash from
(select  max(tb.TAR_EJRA) as TAR_EJRA,trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)) as tash from TEJARAT_DB.TAS_BALANCE tb
      group by trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)))r
      INNER JOIN TEJARAT_DB.TAS_BALANCE t
      on r.tash = trim(lpad(t.cnt_no,9,0))
      ||trim(lpad(t.branch_cd,6,0))
      ||trim(lpad(t.CNT_TYPE,3,0))
      and r.TAR_EJRA =t.TAR_EJRA
      and t.asnad_cd>'0'            and t.EKHTESASI_CD != 53

      ) tb ,
  tejarat_db.aghsat a
where TRIM(a.AKNO_GH)
  || TRIM(a.AKCOD_SH)
  || trim(a.QARARDAD_TYPE) =tb.tash
AND a.QARARDAD_TYPE      IN ('021','022','023','024','025','026')
AND NOT (tb.mblaslbedjari =0
AND tb.mblsodbedjari      = 0 )
--AND a.srcd_ghst_date      > TO_CHAR(sysdate,'yymmdd','nls_calendar=persian')
AND a.TARIKH_DARYAFT = 0
GROUP BY TRIM(a.AKNO_GH)
  || TRIM(a.AKCOD_SH)
  || trim(a.QARARDAD_TYPE) ; 
  COMMIT;
  -------------------------------------------- aghsati ke dar tas balance hast vali dar aghsat na
   INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO TBL_LOAN_PAYMENT
    (
      payment_number,
      ref_lon_id,
      profit_amount,
      DUE_DATE,
      amount
    )
  select * from (select 1,r.tash,t.mblsodbedjari,sysdate+1,t.MBLASLBEDJARI from
(select  max(tb.TAR_EJRA) as TAR_EJRA,trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)) as tash from TEJARAT_DB.TAS_BALANCE tb
      group by trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)))r
      INNER JOIN TEJARAT_DB.TAS_BALANCE t
      on r.tash = trim(lpad(t.cnt_no,9,0))
      ||trim(lpad(t.branch_cd,6,0))
      ||trim(lpad(t.CNT_TYPE,3,0))
      and r.TAR_EJRA =t.TAR_EJRA
      and t.asnad_cd>'0'            and t.EKHTESASI_CD != 53
and t.rc_stat = 0 and t.tabagheh != 4
      ) tb where tb.tash not in (select distinct ref_lon_id from TBL_LOAN_PAYMENT)
      and not (tb.mblaslbedjari=0 and tb.mblsodbedjari = 0);
  
  commit;
 
end prc_transfer_payment;
     --**************************************
     --**************************************
     --**************************************
     PROCEDURE PRC_TRANSFER_DEPOSIT_PROFIT ( RUN_DATE DATE ) AS
  /*
  Programmer Name: morteza sahi
  Release Date/Time:1396/05/12-10:00
  Version:
  Category: 
  Description: ijad sode sepordeha 
  */
 EFF_DATE   DATE;
 VAR        VARCHAR2(4000);
BEGIN
 EXECUTE IMMEDIATE 'ALTER SESSION FORCE PARALLEL DML';
 EXECUTE IMMEDIATE 'truncate table akin.TBL_DEPOSIT_INTEREST_PAYMENT';
  /***  bar asas tarikh sarresid sepordeha zaman pardakht sod va mablagh sod pardakhti ra taeen mikonim  ***/
 INSERT  /*+ APPEND PARALLEL(auto)   */ INTO TBL_DEPOSIT_INTEREST_PAYMENT ( REF_DEP_ID,DUE_DATE,PROFIT_AMOUNT ) WITH SEP AS (
  SELECT
      /*+  PARALLEL(auto) */
   ROUND(
    MONTHS_BETWEEN(
     E.DUE_DATE
    ,E.OPENING_DATE
    )
   ,0
   ) FASELE
  ,ROUND(
    MONTHS_BETWEEN(SYSDATE,E.OPENING_DATE)
   ,0
   ) FASEL
  ,E.DEP_ID
  ,E.REF_CURRENCY
  ,E.REF_CUSTOMER
  ,E.REF_DEPOSIT_TYPE
  ,E.REF_BRANCH
  ,E.DUE_DATE
  ,E.OPENING_DATE
  ,ROUND( (E.BALANCE * E.RATE) / 1200) AS BED
  ,HS.LEDGER_CODE_PROFIT
  ,E.MODALITY_TYPE
  FROM TBL_DEPOSIT E
  ,    TBL_DEPOSIT_ACCOUNTING HS
  WHERE HS.DEP_ACC_ID     = E.REF_DEPOSIT_ACCOUNTING
   AND
    E.DUE_DATE >= RUN_DATE
   AND
    E.MODALITY_TYPE   = 1
   AND
    E.BALANCE <> 0
 ),NUM AS (
  SELECT
   ROWNUM R
  FROM DUAL
  CONNECT BY
   ROWNUM <= 500
 )/*max FASELE MAHI EFF V END*/ SELECT
  SEP.DEP_ID
 ,ADD_MONTHS(
   SEP.OPENING_DATE
  ,NUM.R
  )
 ,SEP.BED
 FROM SEP
 ,    NUM
 WHERE NUM.R <= SEP.FASELE
  AND
   NUM.R > SEP.FASEL;

 COMMIT;
    
/*===========================================================*/
/*===========================================================*/
END PRC_TRANSFER_DEPOSIT_PROFIT;
       --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/

     
      PROCEDURE PRC_j_TRANSFER_DEPOSIT(inpar_date date) as 
     begin
     EXECUTE IMMEDIATE 'truncate table akin.tbl_deposit';

    INSERT
         /*+ APPEND PARALLEL(auto)   */
    INTO akin.tbl_deposit
      (
        DEP_ID,
        REF_DEPOSIT_TYPE,
        OPENING_DATE,
        DUE_DATE,
        RATE,
        REF_BRANCH,
        BALANCE,
        REF_CUSTOMER,
        REF_DEPOSIT_ACCOUNTING,
        MODALITY_TYPE,
        REF_CURRENCY
      )
      ( SELECT DISTINCT
     /*+ PARALLEL(AUTO) */
          a.Acnt_no                                                  AS DEP_ID,
          MAX(a.GRP)                                                 AS REF_DEPOSIT_TYPE,
          to_date( MAX(a.Open_dt),'yy/mm/dd','nls_calendar=persian') AS OPENING_DATE,
          to_date( MAX(a.EXP_DT),'yy/mm/dd','nls_calendar=persian')  AS DUE_DATE,
          TO_NUMBER(MAX((a.Rate/1000)+(nvl(Ratem,0)/100)))       AS RATE,
          MAX(a.BRNCH_CD)                                            AS REF_BRANCH,
          max(a.AMNT)                                                as BALANCE,
          case when MAX(b.MELLI) is not null then max(b.melli) else '99999' end  AS REF_CUSTOMER,
          max(a.ACNT_NO)                                             as REF_DEPOSIT_ACCOUNTING,
          case when MAX(T.NAHVE_TOZIE)is not null then MAX(T.NAHVE_TOZIE) else '1' end AS MODALITY_TYPE,
          max(4)                                                     as REF_CURRENCY
        FROM archive_raw_bank_data.SEPORDE a left outer join 
          (

  SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO AS ACNT,
            regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID  , '[[:space:]]*','')                AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NCOMPANY
            where MELLI_ID is not null and LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
          UNION
          SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO AS ACNT ,
           regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','')              AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NPERSON
            where cod_meli is not null and LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS  NULL  
          ) B
          on a.ACNT_NO =B.ACNT and A.EFF_DATE = inpar_date
          left outer join  
          TBL_API_NOE_SEPORDE T
          on T.NOE_SEPORDE = A.GRP
        WHERE 
        SUBSTR((a.EXP_DT),1,4) >=substr(to_char(SYSDATE,'yyyy/mm/dd','nls_calendar=persian'),1,4)
        AND SUBSTR((a.EXP_DT), 5,2) BETWEEN 1 AND 12
        AND SUBSTR((a.EXP_DT),7,2) BETWEEN 1 AND 31
        and length(a.EXP_DT)=8
          AND SUBSTR((a.OPEN_DT), 5,2) BETWEEN 1 AND 12
        AND SUBSTR((a.OPEN_DT),7,2) BETWEEN 1 AND 31
        and length(a.OPEN_DT)=8
        AND a.exp_dt > to_char(SYSDATE,'yyyymmdd','nls_calendar=persian')
        AND a.Status_cd  != 4
        GROUP BY a.acnt_no
      );
    COMMIT;
    INSERT
         /*+ APPEND PARALLEL(auto)   */
    INTO akin.tbl_deposit
      (
        DEP_ID,
        REF_DEPOSIT_TYPE,
        OPENING_DATE,
        DUE_DATE,
        RATE,
        REF_BRANCH,
        BALANCE,
        REF_CUSTOMER,
        REF_DEPOSIT_ACCOUNTING,
        MODALITY_TYPE,
        REF_CURRENCY
      )
(SELECT
     /*+ PARALLEL(AUTO) */
          a.Acnt_no                                                  AS DEP_ID,
          MAX(a.GRP)            
          AS REF_DEPOSIT_TYPE,
           case when MAX(a.Open_dt) is null then sysdate else to_date(MAX(a.Open_dt),'yy/mm/dd','nls_calendar=persian') end AS OPENING_DATE,
          TO_DATE( max(a.EXP_DT),'yy/mm/dd','nls_calendar=persian')  as DUE_DATE,
          case when MAX(TAS.RATE) is not null then MAX(TAS.RATE) else 10 end  AS RATE,
          MAX(a.BRNCH_CD)                                            AS REF_BRANCH,
          max(a.AMNT)                                                as BALANCE,
           case when MAX(b.MELLI) is not null then max(b.melli) else '99999' end  AS REF_CUSTOMER,
          max(a.ACNT_NO)                                   as REF_DEPOSIT_ACCOUNTING,
          case when MAX(TAS.NAHVE_TOZIE)is not null then MAX(TAS.NAHVE_TOZIE) else '3' end AS MODALITY_TYPE,
          MAX(4)                                                     AS REF_CURRENCY
        from archive_raw_bank_data.SEPORDE_KOTAHMODAT a
        left outer join
        TBL_API_NOE_SEPORDE TAS
        on TAS.NOE_SEPORDE= A.GRP  and A.EFF_DATE = inpar_date
        left outer join
            (

  SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO AS ACNT,
            regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID  , '[[:space:]]*','')                AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NCOMPANY
            where MELLI_ID is not null and LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
          UNION
          SELECT      /*+ PARALLEL(AUTO) */ DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO AS ACNT ,
           regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','')              AS MELLI
          FROM TEJARAT_DB.CUSTOMER_NPERSON
            where cod_meli is not null and LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS  NULL  
          ) B 
          on a.Acnt_no               =b.ACNT
          where a.amnt > 0--------------------------------------mym
              GROUP BY a.acnt_no
      );
  --v_seporde_tbl_number := FNC_SET_SEPORDE_EMRUZ();  -- AKHARE EJRAYE SYSTEM BASHE
  COMMIT;
  
  INSERT
   /*+ APPEND PARALLEL(auto)   */
INTO akin.tbl_deposit
  (
    DEP_ID,
    REF_DEPOSIT_TYPE,
    REF_BRANCH,
    REF_CUSTOMER,
    DUE_DATE,
    BALANCE,
    OPENING_DATE,
    RATE,
    REF_CURRENCY,
    MODALITY_TYPE,
    REF_DEPOSIT_ACCOUNTING
  )
SELECT s.DEP_ID,
  s.REF_DEPOSIT_TYPE,
  s.REF_BRANCH,
  s.REF_CUSTOMER,
  s.DUE_DATE,
  s.BALANCE,
  s.OPENING_DATE,
  s.RATE,
  s.REF_CURRENCY,
  a.tafkik,
  s.DEP_ID as REF_DEPOSIT_ACCOUNTING
FROM SEPORDE s,
  (SELECT NOE_SEPORDE, TAFKIK FROM TBL_SEPORDE_MODATDAR
  UNION
  SELECT NOE_SEPORDE, TAFKIK FROM TBL_SEPORDE_ROZ_SHOMAR
  )a
WHERE s.REF_DEPOSIT_TYPE = a.noe_seporde; 
commit;
  ------------ TARIKH KARABHA
        INSERT
       /*+ APPEND PARALLEL(auto)   */
    INTO akin.tbl_deposit
      (
        DEP_ID,
        REF_DEPOSIT_TYPE,
        OPENING_DATE,
        DUE_DATE,
        RATE,
        REF_BRANCH,
        BALANCE,
        REF_CUSTOMER,
        REF_DEPOSIT_ACCOUNTING,
        MODALITY_TYPE,
        REF_CURRENCY
      ) 
      ( SELECT DISTINCT
  /*+ PARALLEL(AUTO) */
  a.Acnt_no                     AS DEP_ID,
  MAX(a.GRP)                    AS REF_DEPOSIT_TYPE,
  TRUNC(SYSDATE)                AS OPENING_DATE,
  TRUNC(SYSDATE       +1)       AS DUE_DATE,
  TO_NUMBER(MAX(a.Rate/1000)) AS RATE,
  MAX(a.BRNCH_CD)               AS REF_BRANCH,
  MAX(a.AMNT)                   AS BALANCE,
  CASE
    WHEN MAX(b.MELLI) IS NOT NULL
    THEN MAX(b.melli)
    ELSE '99999'
  END            AS REF_CUSTOMER,
  MAX(a.ACNT_NO) AS REF_DEPOSIT_ACCOUNTING,
  CASE
    WHEN MAX(T.NAHVE_TOZIE)IS NOT NULL
    THEN MAX(T.NAHVE_TOZIE)
    ELSE '1'
  END    AS MODALITY_TYPE,
  MAX(4) AS REF_CURRENCY
FROM archive_raw_bank_data.SEPORDE a
LEFT OUTER JOIN
  (SELECT
    /*+ PARALLEL(AUTO) */
    DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO                             AS ACNT,
    regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID , '[[:space:]]*','') AS MELLI
  FROM TEJARAT_DB.CUSTOMER_NCOMPANY
  WHERE MELLI_ID                                          IS NOT NULL
  AND LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
  UNION
  SELECT
    /*+ PARALLEL(AUTO) */
    DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO                             AS ACNT ,
    regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','') AS MELLI
  FROM TEJARAT_DB.CUSTOMER_NPERSON
  WHERE cod_meli                                          IS NOT NULL
  AND LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS NULL
  ) B
ON a.ACNT_NO =B.ACNT  and A.EFF_DATE = inpar_date
LEFT OUTER JOIN TBL_API_NOE_SEPORDE T
ON T.NOE_SEPORDE   = A.GRP  and A.EFF_DATE = inpar_date
WHERE a.Status_cd != 4
AND a.Acnt_no NOT IN
  (SELECT akin.tbl_deposit.DEP_ID
  FROM akin.tbl_deposit
  )
   GROUP BY a.acnt_no
);
        COMMIT;
  end;
  
  --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
  --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
  --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
    
     PROCEDURE PRC_j_TRANSFER_LOAN(inpar_date date) AS
     BEGIN
     
     EXECUTE IMMEDIATE 'truncate table AKIN.TBL_LOAN';
  DELETE
  FROM TEJARAT_DB.gharardad
  WHERE NOT REGEXP_LIKE(SHO_GHAR, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(SHOB_CD, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(NOA_GHAR, '^[[:digit:]]+$');
  COMMIT;
    INSERT
     /*+ APPEND PARALLEL(auto)   */
  INTO AKIN.TBL_LOAN
    (
      APPROVED_AMOUNT,
      OPENING_DATE,
      LON_ID,
      REF_CURRENCY,
      REF_LOAN_TYPE,
      REF_BRANCH,
      REF_CUSTOMER,
      REF_LOAN_ACCOUNTING
    )
select a.* from 
    (
    SELECT
    /*+ PARALLEL(auto) */
    MAX(MABLAGH_GHR),
    to_date( MAX(GHARARDAD_DATE), 'yy/mm/dd','nls_calendar=persian'),
    trim(SHO_GHAR)
    ||trim(SHOB_CD)
    ||trim(NOA_GHAR) AS LON_ID,
    4,
    MAX(NOA_GHAR),
    MAX(SHOB_CD_ref),
    CASE
      WHEN MAX(n.MELLI) IS NOT NULL
      THEN MAX(n.MELLI)
      ELSE '99999'
    END AS melli,
    MAX(G.Tas_Accno_1)
  FROM archive_raw_bank_data.GHARARDAD G
  LEFT OUTER JOIN
    (SELECT
      /*+ PARALLEL(AUTO) */
      DISTINCT TEJARAT_DB.CUSTOMER_NCOMPANY.ACNT_NO                             AS ACNT,
      regexp_replace(TEJARAT_DB.CUSTOMER_NCOMPANY.MELLI_ID , '[[:space:]]*','') AS MELLI
    FROM TEJARAT_DB.CUSTOMER_NCOMPANY
    WHERE MELLI_ID                                          IS NOT NULL
    AND LENGTH(TRIM(TRANSLATE(MELLI_ID, '0123456789',' '))) IS NULL
    UNION
    SELECT
      /*+ PARALLEL(AUTO) */
      DISTINCT TEJARAT_DB.CUSTOMER_NPERSON.ACNT_NO                             AS ACNT ,
      regexp_replace(TEJARAT_DB.CUSTOMER_NPERSON.COD_MELI , '[[:space:]]*','') AS MELLI
    FROM TEJARAT_DB.CUSTOMER_NPERSON
    WHERE cod_meli                                          IS NOT NULL
    AND LENGTH(TRIM(TRANSLATE(cod_meli, '0123456789',' '))) IS NULL
    ) N
  ON G.Tas_Accno_1                 = N.Acnt
  WHERE LENGTH(GHARARDAD_DATE)     =6
  AND 0                            <SUBSTR((GHARARDAD_DATE), 5,2)
  AND SUBSTR((GHARARDAD_DATE), 5,2)<32
  AND SUBSTR((GHARARDAD_DATE), 1,2)>70
  and amal_cd <> '5'
  and RC_STAT ='0'
  GROUP BY trim(SHO_GHAR)
    ||trim(SHOB_CD)
    ||trim(NOA_GHAR)
    )a, (SELECT distinct 
  Trim(Lpad(Tb.Cnt_No,9,0))
      ||Trim(Lpad(Tb.Branch_Cd,6,0))
      ||Trim(Lpad(Tb.Cnt_Type,3,0)) as id
    FROM archive_raw_bank_data.Tas_Balance Tb where TB.EFF_DATE = inpar_date
    )b
    where a.LON_ID = b. id;
    
commit;
------------------------------------------------- takmil_hesabdari
INSERT  /*+ APPEND PARALLEL(auto)   */ INTO TBL_LOAN_ACCOUNTING(LON_ACC_ID, LEDGER_CODE_SELF,LEDGER_CODE_PROFIT )
WITH g AS (
SELECT LON_ID, REF_LOAN_ACCOUNTING
FROM AKIN.TBL_LOAN
WHERE REF_LOAN_ACCOUNTING NOT IN (SELECT TBL_LOAN_ACCOUNTING.LON_ACC_ID FROM TBL_LOAN_ACCOUNTING))
SELECT distinct REF_LOAN_ACCOUNTING, ID asl, 3107970797 sud
FROM g, tejarat_db.nac n, cbi_to_id c
WHERE g.REF_LOAN_ACCOUNTING = n.acnt_no AND c.code = n.cbi_db
and c.code IN (SELECT CBI_DB FROM TBL_VALID_CBI_DB);
--------------------------------------------------
  COMMIT;
  
  UPDATE TBL_LOAN_ACCOUNTING
  SET LEDGER_CODE_PROFIT = LEDGER_CODE_SELF
  WHERE LON_ACC_ID     IN
    (SELECT g.tas_accno_1
    FROM tbl_valid_cbi_db v,
      cbi_to_id c,
      archive_raw_bank_data.GHARARDAD g ,
      tejarat_db.nac n
    WHERE c.code     = v.cbi_db
    AND n.acnt_no    = g.tas_accno_1
    AND n.cbi_db     = v.cbi_db
    AND v.nahve_tajmi= 'asl+sud'
    and G.EFF_DATE =inpar_date
    );
    commit;
      UPDATE TBL_LOAN_ACCOUNTING
  SET LEDGER_CODE_PROFIT = LEDGER_CODE_SELF
  WHERE LON_ACC_ID     IN
    (SELECT g.tas_accno
    FROM tbl_valid_cbi_db v,
      cbi_to_id c,
      archive_raw_bank_data.Tas_Balance g ,
      tejarat_db.nac n
    WHERE c.code     = v.cbi_db
    AND n.acnt_no    = g.tas_accno
    AND n.cbi_db     = v.cbi_db
    AND v.nahve_tajmi= 'asl+sud'
    and G.EFF_DATE =inpar_date
    );
    commit;
     END PRC_j_TRANSFER_LOAN;
      
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     
  PROCEDURE PRC_J_TRANSFER_DEPOSIT_PROFIT ( RUN_DATE DATE ) AS
 
 EFF_DATE   DATE;
 VAR        VARCHAR2(4000);
BEGIN
 EXECUTE IMMEDIATE 'ALTER SESSION FORCE PARALLEL DML';
 EXECUTE IMMEDIATE 'truncate table akin.TBL_DEPOSIT_INTEREST_PAYMENT';
 /***  bar asas tarikh sarresid sepordeha zaman pardakht sod va mablagh sod pardakhti ra taeen mikonim  ***/
 INSERT  /*+ APPEND PARALLEL(auto)   */ INTO TBL_DEPOSIT_INTEREST_PAYMENT ( REF_DEP_ID,DUE_DATE,PROFIT_AMOUNT ) WITH SEP AS (
  SELECT
      /*+  PARALLEL(auto) */
   ROUND(
    MONTHS_BETWEEN(
     E.DUE_DATE
    ,E.OPENING_DATE
    )
   ,0
   ) FASELE
  ,ROUND(
    MONTHS_BETWEEN(SYSDATE,E.OPENING_DATE)
   ,0
   ) FASEL
  ,E.DEP_ID
  ,E.REF_CURRENCY
  ,E.REF_CUSTOMER
  ,E.REF_DEPOSIT_TYPE
  ,E.REF_BRANCH
  ,E.DUE_DATE
  ,E.OPENING_DATE
  ,ROUND( (E.BALANCE * E.RATE) / 1200) AS BED
  ,HS.LEDGER_CODE_PROFIT
  ,E.MODALITY_TYPE
  FROM TBL_DEPOSIT E
  ,    TBL_DEPOSIT_ACCOUNTING HS
  WHERE HS.DEP_ACC_ID     = E.REF_DEPOSIT_ACCOUNTING
   AND
    E.DUE_DATE >= RUN_DATE
   AND
    E.MODALITY_TYPE   = 1
   AND
    E.BALANCE <> 0
 ),NUM AS (
  SELECT
   ROWNUM R
  FROM DUAL
  CONNECT BY
   ROWNUM <= 500
 )/*max FASELE MAHI EFF V END*/ SELECT
  SEP.DEP_ID
 ,ADD_MONTHS(
   SEP.OPENING_DATE
  ,NUM.R
  )
 ,SEP.BED
 FROM SEP
 ,    NUM
 WHERE NUM.R <= SEP.FASELE
  AND
   NUM.R > SEP.FASEL;

 COMMIT;
    
/*===========================================================*/
/*===========================================================*/
END PRC_J_TRANSFER_DEPOSIT_PROFIT;

     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/

 PROCEDURE prc_j_transfer_payment(inpar_date date)
as
begin
 EXECUTE IMMEDIATE 'truncate table  TBL_LOAN_PAYMENT';
  DELETE
  FROM TEJARAT_DB.AGHSAT
  WHERE NOT REGEXP_LIKE(AKNO_GH, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(AKCOD_SH, '^[[:digit:]]+$')
  OR NOT REGEXP_LIKE(QARARDAD_TYPE, '^[[:digit:]]+$');
  COMMIT;
  INSERT
   /*+ APPEND PARALLEL(auto)   */
  INTO TBL_LOAN_PAYMENT
    (
      payment_number,
      ref_lon_id,
      profit_amount,
      DUE_DATE,
      amount
    )
    (SELECT 0,
        TASHILAT,
        SOD_MOSTATER_DAR_GHEST,
        TARIKH_SARRESID ,
        mablagh_ghest
      FROM
        (SELECT
          /*+ PARALLEL(AUTO) */
          0,
          TRIM(AKNO_GH)
          || TRIM(AKCOD_SH)
          || trim(QARARDAD_TYPE) AS TASHILAT ,
          CASE
            WHEN QARARDAD_TYPE IN (11,12)
            THEN DARAMAD_SAAL
            ELSE MBLGH_FAR_GHST
          END                                   AS SOD_MOSTATER_DAR_GHEST ,
          FNC_CHECK_VALID_DATE( SRCD_GHST_DATE) AS TARIKH_SARRESID,
          MBLGH_ASL_GHST                        AS mablagh_ghest
        FROM archive_raw_bank_data.Aghsat
        WHERE archive_raw_bank_data.Aghsat.rec_typ_code ='3'
        AND TARIKH_DARYAFT                   = 0
        AND qarardad_type NOT               IN ('021','022','023','024','025','026')
        and ARCHIVE_RAW_BANK_DATA.AGHSAT.EFF_DATE = inpar_date
          /* WHERE SUBSTR((SRCD_GHST_DATE), 1,2) >= 90
          AND SUBSTR((SRCD_GHST_DATE), 3,2) BETWEEN 1 AND 12
          AND SUBSTR((SRCD_GHST_DATE), 5,2) BETWEEN 1 AND 31
          AND LENGTH(SRCD_GHST_DATE)=6*/
        )
      WHERE TARIKH_SARRESID     IS NOT NULL
      AND TRUNC(TARIKH_SARRESID) > TRUNC(sysdate)
    );
  COMMIT;
  
  INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO TBL_LOAN_PAYMENT
    (
      payment_number,
      ref_lon_id,
      profit_amount,
      DUE_DATE,
      amount
    )
     SELECT 0,
  TRIM(a.AKNO_GH)
  || TRIM(a.AKCOD_SH)
  || trim(a.QARARDAD_TYPE),
  MAX(tb.mblsodbedjari) ,
 case when  tjr_varsa.FNC_CHECK_VALID_DATE(MAX(a.srcd_ghst_date)) < sysdate then  sysdate+1 else tjr_varsa.FNC_CHECK_VALID_DATE(MAX(a.srcd_ghst_date)) end ,
  MAX(tb.mblaslbedjari)
  FROM  (select t.TAR_EJRA,t.MBLASLBEDJARI,t.mblsodbedjari,r.tash from
(select  max(tb.TAR_EJRA) as TAR_EJRA,trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)) as tash from archive_raw_bank_data.TAS_BALANCE tb
      group by trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)))r
      INNER JOIN archive_raw_bank_data.TAS_BALANCE t
      on r.tash = trim(lpad(t.cnt_no,9,0))
      ||trim(lpad(t.branch_cd,6,0))
      ||trim(lpad(t.CNT_TYPE,3,0))
      and r.TAR_EJRA =t.TAR_EJRA
      and t.asnad_cd>'0'            and t.EKHTESASI_CD != 53
      and T.EFF_DATE = inpar_date

      ) tb ,
  archive_raw_bank_data.Aghsat a
where TRIM(a.AKNO_GH)
  || TRIM(a.AKCOD_SH)
  || trim(a.QARARDAD_TYPE) =tb.tash
AND a.QARARDAD_TYPE      IN ('021','022','023','024','025','026')
AND NOT (tb.mblaslbedjari =0
AND tb.mblsodbedjari      = 0 )
and A.EFF_DATE = inpar_date
--AND a.srcd_ghst_date      > TO_CHAR(sysdate,'yymmdd','nls_calendar=persian')
AND a.TARIKH_DARYAFT = 0
GROUP BY TRIM(a.AKNO_GH)
  || TRIM(a.AKCOD_SH)
  || trim(a.QARARDAD_TYPE) ; 
  COMMIT;
  -------------------------------------------- aghsati ke dar tas balance hast vali dar aghsat na
   INSERT
    /*+ APPEND PARALLEL(auto)   */
  INTO TBL_LOAN_PAYMENT
    (
      payment_number,
      ref_lon_id,
      profit_amount,
      DUE_DATE,
      amount
    )
  select * from (select 1,r.tash,t.mblsodbedjari,sysdate+1,t.MBLASLBEDJARI from
(select  max(tb.TAR_EJRA) as TAR_EJRA,trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)) as tash from archive_raw_bank_data.TAS_BALANCE tb where     Tb.EFF_DATE =INPAR_DATE
      group by trim(lpad(tb.cnt_no,9,0))
      ||trim(lpad(tb.branch_cd,6,0))
      ||trim(lpad(tb.CNT_TYPE,3,0)))r
      INNER JOIN archive_raw_bank_data.TAS_BALANCE t
      on r.tash = trim(lpad(t.cnt_no,9,0))
      ||trim(lpad(t.branch_cd,6,0))
      ||trim(lpad(t.CNT_TYPE,3,0))
      and r.TAR_EJRA =t.TAR_EJRA
      and t.asnad_cd>'0'            and t.EKHTESASI_CD != 53
      and T.EFF_DATE =INPAR_DATE
       
and t.rc_stat = 0 and t.tabagheh != 4
      ) tb where tb.tash not in (select distinct ref_lon_id from TBL_LOAN_PAYMENT)
      and not (tb.mblaslbedjari=0 and tb.mblsodbedjari = 0);
  
  commit;
 
end prc_j_transfer_payment;

     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     --\/\/\/\/\/\/\\/\/\//\\/\/\/\/\/\/\/\\\//\/\/
     
     

END PKG_TJR;
