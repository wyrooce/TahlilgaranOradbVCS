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
--------------------------------------------------------
--  DDL for Table PKG_NOP_SIMPLE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_NOP_SIMPLE" as 

   FUNCTION FNC_NOP_RESULT (inpar_date varchar2)  RETURN clob ; 
   FUNCTION FNC_NOP_simple_tree  RETURN VARCHAR2 ; 
   FUNCTION FNC_NOP_GET_DETAIL_NAME(inpar_date varchar2)  RETURN VARCHAR2 ; 


end pkg_nop_simple;
--------------------------------------------------------
--  DDL for Table PKG_NOP_SIMPLE
--------------------------------------------------------

  CREATE OR REPLACE PACKAGE "PRAGG"."PKG_NOP_SIMPLE" as 

   FUNCTION FNC_NOP_RESULT (inpar_date varchar2)  RETURN clob ; 
   FUNCTION FNC_NOP_simple_tree  RETURN VARCHAR2 ; 
   FUNCTION FNC_NOP_GET_DETAIL_NAME(inpar_date varchar2)  RETURN VARCHAR2 ; 


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
