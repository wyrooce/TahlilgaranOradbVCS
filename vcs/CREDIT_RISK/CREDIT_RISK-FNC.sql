--------------------------------------------------------
--  DDL for Function FNC_PROFILE_CREATE_QUERY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_PROFILE_CREATE_QUERY" (
        INPAR_ID IN NUMBER ,
        inpar_type in number) -- if =1 paging else = 0
 --RETURN VARCHAR2
 RETURN clob
  --return varchar2
AS
iidd number;
--------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh
  Editor Name: 
  Release Date/Time:1396/02/18-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description: Query saz baraE profile ha . 
  */
--------------------------------------------------------------------------------
pragma autonomous_transaction;

  v_name_input_tbl VARCHAR2(32001);
  --where_condition  VARCHAR2(32001);
  where_condition  clob;
  v_count number;
  
  --var varchar2(32000);
  var clob;
BEGIN

select  max(id) into iidd

FROM TBL_PROFILE
where h_id = inpar_id
group by name ;

 -- EXECUTE IMMEDIATE 'delete from tbl_profile_detail where condition is NULL';
 --commit;
  
  SELECT type INTO v_name_input_tbl FROM tbl_profile WHERE id=iidd;
  select count(*) into v_count from tbl_profile_detail where ref_profile=iidd;

-- if(v_count=1) then
--    SELECT SUBSTR(REPLACE(wm_concat(SRC_COLUMN
--    || REPLACE(CONDITION,'#',' or '
--    ||SRC_COLUMN
--    ||' ')
--    ||''),',',' '),0,LENGTH(REPLACE(wm_concat(SRC_COLUMN
--    || REPLACE(CONDITION,'#',' and '
--    ||SRC_COLUMN
--    ||' ')
--    ||' and'),',',' ')))
--  INTO where_condition
--  FROM tbl_profile_detail
--  WHERE ref_profile = INPAR_ID;
--  
--  else
--   SELECT SUBSTR(REPLACE(wm_concat(SRC_COLUMN
--    || REPLACE(CONDITION,'#',' or '
--    ||SRC_COLUMN
--    ||' ')
--    ||') and ('),',',' '),0,LENGTH(REPLACE(wm_concat(SRC_COLUMN
--    || REPLACE(CONDITION,'#',' or '
--    ||SRC_COLUMN
--    ||' ')
--    ||') and ('),',',' '))-5)
--  INTO where_condition
--  FROM tbl_profile_detail
--  WHERE ref_profile = INPAR_ID;
--  
--  where_condition:='('||where_condition;
--  
--    end if;


--SELECT LISTAGG('('||SRC_COLUMN||REPLACE(CONDITION,'#',' or '|| SRC_COLUMN), ') and ') WITHIN GROUP (ORDER BY id desc) "where_condition" into  where_condition
--FROM tbl_profile_detail
--WHERE ref_profile = iidd;

    --================================== XML kardan khorojoo query zamani ke query kheili toolani bashad.
  
    
--    SELECT rtrim(xmlagg(XMLELEMENT(e,'('
--    ||TBL_PROFILE.type||'.'||SRC_COLUMN
--    ||REPLACE(CONDITION,'#',' or '
--    || TBL_PROFILE.type||'.'||SRC_COLUMN), ') and ').EXTRACT('//text()')
--    ).GetClobVal(),',') "where_condition"
--    FROM tbl_profile_detail,TBL_PROFILE
--        WHERE ref_profile = iidd
--        and ref_profile = TBL_PROFILE.id;
--    
    
    SELECT rtrim(xmlagg(XMLELEMENT(e,'('
    ||SRC_COLUMN
    ||REPLACE(CONDITION,'#',' or '
    || SRC_COLUMN), ') and ').EXTRACT('//text()')
    ).GetClobVal(),',') "where_condition"   into  where_condition
    FROM tbl_profile_detail
    WHERE ref_profile = iidd;
    
      
      
    select substr(where_condition,0,LENGTH(where_condition)-6) into where_condition from dual;
    --=================================
      
    --===========================
    select REPLACE(where_condition, '&gt;', '>') into where_condition from dual;
    select REPLACE(where_condition, '&apos;', '''') into where_condition from dual;
    select REPLACE(where_condition, '&lt;', '<') into where_condition from dual;
    --============================
      
      where_condition:=where_condition||')';








if(inpar_type=1) then
   
    select REPLACE(where_condition,'''', '''''') into where_condition from dual;
    --select REPLACE(where_condition, ''',''', ''''',''''') into where_condition from dual;
    --select REPLACE(where_condition, 'yyyy/mm/dd''', 'yyyy/mm/dd''''') into where_condition from dual;
end if;


--------------------------------------------------------------------------------  
--  if (v_name_input_tbl='TBL_DEPOSIT' or v_name_input_tbl='TBL_LOAN') then
--  
--  var:=' select * from AKIN.'||v_name_input_tbl||' where '||where_condition||';';
--  
--  else
--    var:='select * from '||v_name_input_tbl||' where '||where_condition||';';
--
--  end if;--  if (v_name_input_tbl='TBL_DEPOSIT' or v_name_input_tbl='TBL_LOAN') then
--------------------------------------------------------------------------------

  if(v_name_input_tbl='TBL_DEPOSIT') then
    if(inpar_type!=1) then
       if(v_count!=0) then
      
     
            var:='select 
            tbl_profile.name as "profileName", tbl_profile.des as "profileDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
            DEP_ID as "depositId",
            dep.REF_DEPOSIT_TYPE as "depositTypeId",
            typee.name as "name",
            REF_BRANCH as "branchId",
            REF_CUSTOMER as "customerId",
            TO_CHAR(DUE_DATE,''yyyy/mm/dd'',''nls_calendar= persian'')  as "dueDate",
            BALANCE as "mande",
            TO_CHAR(OPENING_DATE,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
            RATE as "rate",
            MODALITY_TYPE as "tafkikSeporde",
            REF_DEPOSIT_ACCOUNTING as "hesabdariSepordeId",
            REF_CURRENCY as "currencyId"
            from akin.TBL_DEPOSIT dep,tbl_profile , TBL_DEPOSIT_TYPE typee where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' and typee.REF_DEPOSIT_TYPE=dep.REF_DEPOSIT_TYPE';
            
        else
            var:='select 
            tbl_profile.name as "profileName", tbl_profile.des as "profileDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
            DEP_ID as "depositId",
            dep.REF_DEPOSIT_TYPE as "depositTypeId",
            typee.name as "name",
            REF_BRANCH as "branchId",
            REF_CUSTOMER as "customerId",
            TO_CHAR(DUE_DATE,''yyyy/mm/dd'',''nls_calendar= persian'')  as "dueDate",
            BALANCE as "mande",
            TO_CHAR(OPENING_DATE,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
            RATE as "rate",
            MODALITY_TYPE as "tafkikSeporde",
            REF_DEPOSIT_ACCOUNTING as "hesabdariSepordeId",
            REF_CURRENCY as "currencyId"
            from akin.TBL_DEPOSIT dep, TBL_DEPOSIT_TYPE typee ,tbl_profile where tbl_profile.id = '||iidd||' and  typee.REF_DEPOSIT_TYPE=dep.REF_DEPOSIT_TYPE';
            --where_condition := NULL;
      end if;
    else
    if(v_count!=0) then
      
     
            var:='select 
            tbl_profile.name as "profileName", tbl_profile.des as "profileDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
            DEP_ID as "depositId",
            dep.REF_DEPOSIT_TYPE as "depositTypeId",
            typee.name as "name",
            REF_BRANCH as "branchId",
            REF_CUSTOMER as "customerId",
            TO_CHAR(DUE_DATE,''''yyyy/mm/dd'''',''''nls_calendar= persian'''')  as "dueDate",
            BALANCE as "mande",
            TO_CHAR(OPENING_DATE,''''yyyy/mm/dd'''',''''nls_calendar= persian'''') as "openingDate",
            RATE as "rate",
            MODALITY_TYPE as "tafkikSeporde",
            REF_DEPOSIT_ACCOUNTING as "hesabdariSepordeId",
            REF_CURRENCY as "currencyId"
           from akin.TBL_DEPOSIT dep,tbl_profile , TBL_DEPOSIT_TYPE typee where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' and typee.REF_DEPOSIT_TYPE=dep.REF_DEPOSIT_TYPE';
            
        else
            var:='select 
            tbl_profile.name as "profileName", tbl_profile.des as "profileDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
            DEP_ID as "depositId",
            dep.REF_DEPOSIT_TYPE as "depositTypeId",
            typee.name as "name",
            REF_BRANCH as "branchId",
            REF_CUSTOMER as "customerId",
            TO_CHAR(DUE_DATE,''''yyyy/mm/dd'''',''''nls_calendar= persian'''')  as "dueDate",
            BALANCE as "mande",
            TO_CHAR(OPENING_DATE,''''yyyy/mm/dd'''',''''nls_calendar= persian'''') as "openingDate",
            RATE as "rate",
            MODALITY_TYPE as "tafkikSeporde",
            REF_DEPOSIT_ACCOUNTING as "hesabdariSepordeId",
            REF_CURRENCY as "currencyId"
            from akin.TBL_DEPOSIT dep, TBL_DEPOSIT_TYPE typee ,tbl_profile where tbl_profile.id = '||iidd||' and  typee.REF_DEPOSIT_TYPE=dep.REF_DEPOSIT_TYPE';
            --where_condition := NULL;
        
      end if;
      end if;

--------------------------------------------------------------------------------

elsif (v_name_input_tbl='TBL_LOAN') then
 if(inpar_type!=1) then
      if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
           lo.id as "loanId",
          lo.COD_NOE_TASHILAT as "loanTypeId",
          lo.NAM_NOE_TASHILAT "name",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
          TO_CHAR(TARIKH_TASHKIL,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH_MOSAVVAB as "mablaghMosavab",
          MANDE_KOL_VAM as "mandeJari",
          MANDE_SARRESID_GOZASHTE as "mandeSarresidGozashte",
          MANDE_MOAVVAGH as "mandeMoavagh",
          MANDE_MASHKUKOLVOSUL as "mandeMashkokVosol",
          rate as "rate"
          from TBL_LOAN lo,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||'';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
           lo.id as "loanId",
          lo.COD_NOE_TASHILAT as "loanTypeId",
          lo.NAM_NOE_TASHILAT "name",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
          TO_CHAR(TARIKH_TASHKIL,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH_MOSAVVAB as "mablaghMosavab",
          MANDE_KOL_VAM as "mandeJari",
          MANDE_SARRESID_GOZASHTE as "mandeSarresidGozashte",
          MANDE_MOAVVAGH as "mandeMoavagh",
          MANDE_MASHKUKOLVOSUL as "mandeMashkokVosol",
          rate as "rate"
          from TBL_LOAN lo,tbl_profile where  tbl_profile.id = '||iidd||' ' ;
          --where_condition := NULL;
      end if;
      else
    if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
         lo.ID as "loanId",
          lo.COD_NOE_TASHILAT as "loanTypeId",
          lo.NAM_NOE_TASHILAT "name",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
          TO_CHAR(TARIKH_TASHKIL,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH_MOSAVVAB as "mablaghMosavab",
          MANDE_KOL_VAM as "mandeJari",
          MANDE_SARRESID_GOZASHTE as "mandeSarresidGozashte",
          MANDE_MOAVVAGH as "mandeMoavagh",
          MANDE_MASHKUKOLVOSUL as "mandeMashkokVosol",
          rate as "rate"
          from TBL_LOAN lo,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' ';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
          lo.id as "loanId",
          lo.COD_NOE_TASHILAT as "loanTypeId",
          lo.NAM_NOE_TASHILAT "name",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
          TO_CHAR(TARIKH_TASHKIL,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH_MOSAVVAB as "mablaghMosavab",
          MANDE_KOL_VAM as "mandeJari",
          MANDE_SARRESID_GOZASHTE as "mandeSarresidGozashte",
          MANDE_MOAVVAGH as "mandeMoavagh",
          MANDE_MASHKUKOLVOSUL as "mandeMashkokVosol",
          rate as "rate"
          from TBL_LOAN lo,tbl_profile where  tbl_profile.id = '||iidd||'' ;
          --where_condition := NULL;
          end if;
          end if;
--------------------------------------------------------------------------------




elsif (v_name_input_tbl='TBL_GUARANTEE') then
 if(inpar_type!=1) then
      if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
           lo.id as "guaranteeId",
          lo.COD_NOE_zemanat as "guaranteeTypeId",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
          TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhSarresid",
           TO_CHAR(TARIKH_SODUR,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH as "mablaghZemanat",
          EMKAN_TAMDID as "emkanTamdid",
          MABLAGH_NAGHDI as "mablaghZemanatNaghdi",
          MABLAGH_GHEYR_NAGHDI as "mablaghZemanatGheirNaghdi"
          from TBL_GUARANTEE lo ,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' ';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
           lo.id as "guaranteeId",
          lo.COD_NOE_zemanat as "guaranteeTypeId",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
           TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhSarresid",
           TO_CHAR(TARIKH_SODUR,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH as "mablaghZemanat",
          EMKAN_TAMDID as "emkanTamdid",
          MABLAGH_NAGHDI as "mablaghZemanatNaghdi",
          MABLAGH_GHEYR_NAGHDI as "mablaghZemanatGheirNaghdi"
          from TBL_GUARANTEE lo,tbl_profile where  tbl_profile.id = '||iidd||' ' ;
          --where_condition := NULL;
      end if;
      else
    if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
         lo.id as "guaranteeId",
          lo.COD_NOE_zemanat as "guaranteeTypeId",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
           TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhSarresid",
           TO_CHAR(TARIKH_SODUR,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH as "mablaghZemanat",
          EMKAN_TAMDID as "emkanTamdid",
          MABLAGH_NAGHDI as "mablaghZemanatNaghdi",
          MABLAGH_GHEYR_NAGHDI as "mablaghZemanatGheirNaghdi"
          from TBL_GUARANTEE lo,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' ';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
          lo.id as "guaranteeId",
          lo.COD_NOE_zemanat as "guaranteeTypeId",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
           TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhSarresid",
           TO_CHAR(TARIKH_SODUR,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH as "mablaghZemanat",
          EMKAN_TAMDID as "emkanTamdid",
          MABLAGH_NAGHDI as "mablaghZemanatNaghdi",
          MABLAGH_GHEYR_NAGHDI as "mablaghZemanatGheirNaghdi"
          from TBL_GUARANTEE lo,tbl_profile where  tbl_profile.id = '||iidd||' ' ;
          --where_condition := NULL;
          end if;
          end if;








--------------------------------------------------------------------------------

--------------------------------------------------------------------------------




elsif (v_name_input_tbl='TBL_COLLATERAL') then
 if(inpar_type!=1) then
      if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
           lo.id as "collateralId",
          lo.COD_NOE_vasighe as "collateralTypeId",
          nam_noe_vasighe as "collateralTypeName",
          REF_MOSHTARI as "customerId",
          ARZESH_TARHIN_SHODE as "arzeshTarhinShode",
          TO_CHAR(TARIKH_TARHIN,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhTarhin",
          TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          ARZESH_ARZYABI_SHODE as "arzeshArzyabiShode",
          ZARIB_NAGHDINEGI as "zaribNaghdShavandegi"
          
          from TBL_COLLATERAL lo ,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' ';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
            lo.id as "collateralId",
          lo.COD_NOE_vasighe as "collateralTypeId",
          nam_noe_vasighe as "collateralTypeName",
          REF_MOSHTARI as "customerId",
          ARZESH_TARHIN_SHODE as "arzeshTarhinShode",
          TO_CHAR(TARIKH_TARHIN,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhTarhin",
          TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          ARZESH_ARZYABI_SHODE as "arzeshArzyabiShode",
          ZARIB_NAGHDINEGI as "zaribNaghdShavandegi"
          from TBL_COLLATERAL lo,tbl_profile where  tbl_profile.id = '||iidd||' ' ;
          --where_condition := NULL;
      end if;
      else
    if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
         lo.id as "collateralId",
          lo.COD_NOE_vasighe as "collateralTypeId",
          nam_noe_vasighe as "collateralTypeName",
          REF_MOSHTARI as "customerId",
          ARZESH_TARHIN_SHODE as "arzeshTarhinShode",
          TO_CHAR(TARIKH_TARHIN,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhTarhin",
          TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          ARZESH_ARZYABI_SHODE as "arzeshArzyabiShode",
          ZARIB_NAGHDINEGI as "zaribNaghdShavandegi"
          from TBL_COLLATERAL lo,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' ';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
          lo.id as "collateralId",
          lo.COD_NOE_vasighe as "collateralTypeId",
          nam_noe_vasighe as "collateralTypeName",
          REF_MOSHTARI as "customerId",
          ARZESH_TARHIN_SHODE as "arzeshTarhinShode",
          TO_CHAR(TARIKH_TARHIN,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhTarhin",
          TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          ARZESH_ARZYABI_SHODE as "arzeshArzyabiShode",
          ZARIB_NAGHDINEGI as "zaribNaghdShavandegi"
          from TBL_COLLATERAL lo,tbl_profile where  tbl_profile.id = '||iidd||' ' ;
          --where_condition := NULL;
          end if;
          end if;








--------------------------------------------------------------------------------







elsif (v_name_input_tbl='TBL_BRANCH') then
    if(v_count!=0) then
    select REPLACE(where_condition, 'and', 'or') into where_condition from dual;
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
          br.id as "branchID",
          br.NAM as "branchName",
          COD_SHAHR as "cityId",
          NAM_SHAHR as "cityName",
          COD_OSTAN as "stateId",
          NAM_OSTAN as "stateName"
          from TBL_BRANCH br,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd;
    else
        --var:='select 
        --tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
        --BRN_ID as "branchId",
        --br.NAME as "branchName",
        --REF_CTY_ID as "cityId",
        --CITY_NAME as "cityName",
        --REF_STA_ID as "stateId",
        --STA_NAME as "stateName"
        --from TBL_BRANCH br,tbl_profile where tbl_profile.id = '||INPAR_ID; 
        where_condition := NULL;
end if;
--------------------------------------------------------------------------------
elsif (v_name_input_tbl='TBL_CITY') then
if(v_count!=0) then

var:='select
tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
cty.id as "cityId",
nam as "cityName",
cty.tozih as "cityDes",
OSTAN_ID as "stateId"
from TBL_shahr cty,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd;
else
--var:='select
--tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
--CTY_ID as "cityId",
--CTY_NAME as "cityName",
--cty.DES as "cityDes",
--REF_STA_ID as "stateId"
--from TBL_CITY cty,tbl_profile where tbl_profile.id = '||INPAR_ID; 
where_condition := NULL;
end if;
--------------------------------------------------------------------------------
elsif (v_name_input_tbl='TBL_CURRENCY') then
if(v_count!=0) then

var:='select
tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
cur.id as "id",
name_arz as "curName",
arz as "swiftCode"
from tbl_arz cur,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd;
else
--var:='select
--tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
--CUR_ID as "id",
--CUR_NAME as "curName",
--SWIFT_CODE as "swiftCode",
--cur.DES as "curDes"
--from TBL_CURRENCY cur,tbl_profile where tbl_profile.id = '||INPAR_ID;
where_condition := NULL;
end if;
--------------------------------------------------------------------------------
elsif (v_name_input_tbl='TBL_CUSTOMER') then
if(v_count!=0) then

var:='select
tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
TBL_CUSTOMER.id as "id",
TBL_CUSTOMER.NAM as "customerName",
TBL_CUSTOMER.COD_MELLI as "meliCode",
TBL_CUSTOMER.ADDRESS as "address",
TBL_CUSTOMER.TARIKH_TAVVALOD as "birthdate",
TBL_CUSTOMER.JENSIAT as "gender",
TBL_CUSTOMER.MAHIAT_MOSHTARI as "customerType",
TBL_CUSTOMER.REF_SHOBE as "branchId"
from TBL_CUSTOMER ,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd;
else
--var:='select
--"profileName","des","createDate",
--CUS_ID as "id",
-- "customerName",
--FAMILY as "customerFamily",
--NAT_REG_CODE as "meliCode",
--ADDRESS as "address",
--BIRTHDATE as "birthdate",
--GENDER as "gender",
--BRANCH_ID as "branchId" from(
--
--select
--tbl_profile.name as "profileName", tbl_profile.des as "des" ,tbl_profile.create_date as "createDate",
--CUS_ID  ,
--cus.NAME as "customerName",
--FAMILY,
--NAT_REG_CODE ,
--ADDRESS ,
--BIRTHDATE ,
--GENDER as ,
--BRANCH_ID 
--from TBL_CUSTOMER cus,tbl_profile where tbl_profile.id = '||INPAR_ID||'
-- ORDER BY (cus.CUS_ID) desc
-- )
--WHERE ROWNUM <= 50';
where_condition := NULL;
end if;
--------------------------------------------------------------------------------
end if;
if(where_condition is null) then
  RETURN 'select * from dual where 1>2';
  else 
  
  --var:=to_char(var);
  return var;
  end if;

  
END FNC_PROFILE_CREATE_QUERY;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_COLUMN_CHART
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_REPORT_COLUMN_CHART" (inpar_report IN NUMBER ) RETURN VARCHAR2 AS 
 /*
  Programmer Name: MYM
  Release Date/Time:1395/05/23-14:14
  Version: 1.0
  Category: 2
  Description: SAKHT GOZARESH(CHART) AZ RUYE KHORUJIYE NAMAYE
                      Y-AXIS = LGD
                      X-AXIS = NOE TASHILAT
  */
    var_loan number;
var_GUARANTEE number;
var_COLLATERAL number;
var_BRANCH number;
var_customer number;
  LOC_NAMAYE clob;
BEGIN



select ref_loan into var_loan from tbl_report where id = inpar_report;
select REF_GUARANTEE into var_GUARANTEE from tbl_report where id = inpar_report;
select REF_COLLATERAL into var_COLLATERAL from tbl_report where id = inpar_report;
select REF_BRANCH into var_BRANCH from tbl_report where id = inpar_report;
select REF_CUSTOMER into var_customer from tbl_report where id = inpar_report;





  
  select '
select *
from tbl_loan lo
where 

lo.id in
     ( '|| FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',var_loan) ||')
     AND REF_MOSHTARI IN ('||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',var_customer) ||')
    
      AND REF_SHOBE IN ( '||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH)||' )



     '
INTO
     LOC_NAMAYE
    FROM DUAL;

  LOC_NAMAYE := CASE WHEN LOC_NAMAYE IS NULL THEN 'TBL_LOAN' ELSE LOC_NAMAYE END ;
  -- ROUND(SUM(N.LGD),2) ezafe shod
  LOC_NAMAYE := 'SELECT tl.COD_NOE_TASHILAT as "x",MAX(CASE
                  WHEN tl.NAM_NOE_TASHILAT IS NULL
                  THEN '||''''||' نوع تسهيلات'||''''||' || '
                    
                    ||' tl.COD_NOE_TASHILAT  ELSE tl.NAM_NOE_TASHILAT
                END)
                                    AS "name", ROUND(AVG(Na.LGD),2) as "y",tl.COD_NOE_TASHILAT as "کد نوع تسهيلات", max(case when to_char( lo.COD_NOE_TASHILAT)  is null then  ''تسهيلات ''||  tl.COD_NOE_TASHILAT else  to_char(lo.cod_noe_tashilat)  end) AS "نام نوع تسهيلات", ROUND(AVG(Na.LGD),2) as "ميانگين LGD"
                 FROM TBL_NAVIX na,
                ('||LOC_NAMAYE||') lo
               ,tbl_loan tl
                WHERE na.REF_TASHILAT  = lo.id
                and   tl.ID =lo.id
                GROUP BY  tl.COD_NOE_TASHILAT
                ORDER BY AVG(na.LGD)';
RETURN LOC_NAMAYE;





--return 'select id  from tbl_loan where rownum<10';

END FNC_REPORT_COLUMN_CHART;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_HISTOGRAM_CHART
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_REPORT_HISTOGRAM_CHART" (inpar_report IN NUMBER ) RETURN VARCHAR2 AS 
/*
  Programmer Name: NAVID
  Release Date/Time:1395/05/23-13:00
  Version: 1.0
  Category: 2
  Description: SAKHT GOZARESH(CHART) AZ RUYE KHORUJIYE NAMAYE
                      X-AXIS = PD (order by PD value)
                      Y-AXIS = TEDADE_TASHILAT
  */
    var_loan number;
var_GUARANTEE number;
var_COLLATERAL number;
var_BRANCH number;
var_customer number;
  LOC_NAMAYE clob;

BEGIN

select ref_loan into var_loan from tbl_report where id = inpar_report;
select REF_GUARANTEE into var_GUARANTEE from tbl_report where id = inpar_report;
select REF_COLLATERAL into var_COLLATERAL from tbl_report where id = inpar_report;
select REF_BRANCH into var_BRANCH from tbl_report where id = inpar_report;
select REF_CUSTOMER into var_customer from tbl_report where id = inpar_report;



  select '
select *
from tbl_loan lo
where 

lo.id in
     ( '|| FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',var_loan) ||')
     AND REF_MOSHTARI IN ('||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',var_customer) ||')
    
      AND REF_SHOBE IN ( '||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH)||' )



     '
INTO
     LOC_NAMAYE
    FROM DUAL;


  LOC_NAMAYE := CASE WHEN LOC_NAMAYE IS NULL THEN 'TBL_LOAN' ELSE LOC_NAMAYE END ;
  LOC_NAMAYE :=  'SELECT N.PD "name", N.PD "x", count(tl.ID) "y", N.PD "احتمال نوکول", count(tl.ID) "تعداد تسهيلات"
                  FROM TBL_NAVIX N, (' || LOC_NAMAYE || ') L ,tbl_loan tl 
                  WHERE N.REF_TASHILAT = L.id and   tl.ID =l.id
                  GROUP BY N.PD
                  ORDER BY N.PD';
RETURN LOC_NAMAYE;






--return 'SELECT 1 "name", 2 "x", 3 "y",4 "احتمال نوکول", 5 "تعداد تسهيلات" FROM DUAL;';
--return 'select * from tbl_loan where rownum<10';

END FNC_REPORT_HISTOGRAM_CHART;
--------------------------------------------------------
--  DDL for Function FNC_TOTAL_PD
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_TOTAL_PD" RETURN NUMBER AS 
/*
  Programmer Name: MYM
  Release Date/Time:1395/05/23-15:30
  Version: 1.0
  Category: 2
  Description: MIANGIN KOL PD BANK
  */
  LOC_TOTAL_PD NUMBER;
BEGIN
  SELECT AVG(PD) INTO LOC_TOTAL_PD FROM TBL_NAVIX;
RETURN LOC_TOTAL_PD*100;
END FNC_TOTAL_PD;
--------------------------------------------------------
--  DDL for Function TEST_SAKHTE_NAMAYE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."TEST_SAKHTE_NAMAYE" (
        INPAR_ID IN NUMBER ,
        inpar_type in number) -- if =1 paging else = 0
 --RETURN VARCHAR2
 RETURN clob
  --return varchar2
AS
iidd number;
--------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh
  Editor Name: 
  Release Date/Time:1396/02/18-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description: Query saz baraE profile ha . 
  */
--------------------------------------------------------------------------------
pragma autonomous_transaction;

  v_name_input_tbl VARCHAR2(32001);
  --where_condition  VARCHAR2(32001);
  where_condition  clob;
  v_count number;
  
  --var varchar2(32000);
  var clob;
BEGIN

select  max(id) into iidd

FROM TBL_PROFILE
where h_id = inpar_id
group by name ;

 -- EXECUTE IMMEDIATE 'delete from tbl_profile_detail where condition is NULL';
 --commit;
  
  SELECT type INTO v_name_input_tbl FROM tbl_profile WHERE id=iidd;
  select count(*) into v_count from tbl_profile_detail where ref_profile=iidd;

-- if(v_count=1) then
--    SELECT SUBSTR(REPLACE(wm_concat(SRC_COLUMN
--    || REPLACE(CONDITION,'#',' or '
--    ||SRC_COLUMN
--    ||' ')
--    ||''),',',' '),0,LENGTH(REPLACE(wm_concat(SRC_COLUMN
--    || REPLACE(CONDITION,'#',' and '
--    ||SRC_COLUMN
--    ||' ')
--    ||' and'),',',' ')))
--  INTO where_condition
--  FROM tbl_profile_detail
--  WHERE ref_profile = INPAR_ID;
--  
--  else
--   SELECT SUBSTR(REPLACE(wm_concat(SRC_COLUMN
--    || REPLACE(CONDITION,'#',' or '
--    ||SRC_COLUMN
--    ||' ')
--    ||') and ('),',',' '),0,LENGTH(REPLACE(wm_concat(SRC_COLUMN
--    || REPLACE(CONDITION,'#',' or '
--    ||SRC_COLUMN
--    ||' ')
--    ||') and ('),',',' '))-5)
--  INTO where_condition
--  FROM tbl_profile_detail
--  WHERE ref_profile = INPAR_ID;
--  
--  where_condition:='('||where_condition;
--  
--    end if;


--SELECT LISTAGG('('||SRC_COLUMN||REPLACE(CONDITION,'#',' or '|| SRC_COLUMN), ') and ') WITHIN GROUP (ORDER BY id desc) "where_condition" into  where_condition
--FROM tbl_profile_detail
--WHERE ref_profile = iidd;

    --================================== XML kardan khorojoo query zamani ke query kheili toolani bashad.
  
    
--    SELECT rtrim(xmlagg(XMLELEMENT(e,'('
--    ||TBL_PROFILE.type||'.'||SRC_COLUMN
--    ||REPLACE(CONDITION,'#',' or '
--    || TBL_PROFILE.type||'.'||SRC_COLUMN), ') and ').EXTRACT('//text()')
--    ).GetClobVal(),',') "where_condition"
--    FROM tbl_profile_detail,TBL_PROFILE
--        WHERE ref_profile = iidd
--        and ref_profile = TBL_PROFILE.id;
--    
    
    SELECT rtrim(xmlagg(XMLELEMENT(e,'('
    ||SRC_COLUMN
    ||REPLACE(CONDITION,'#',' or '
    || SRC_COLUMN), ') and ').EXTRACT('//text()')
    ).GetClobVal(),',') "where_condition"   into  where_condition
    FROM tbl_profile_detail
    WHERE ref_profile = iidd;
    
      
      
    select substr(where_condition,0,LENGTH(where_condition)-6) into where_condition from dual;
    --=================================
      
    --===========================
    select REPLACE(where_condition, '&gt;', '>') into where_condition from dual;
    select REPLACE(where_condition, '&apos;', '''') into where_condition from dual;
    select REPLACE(where_condition, '&lt;', '<') into where_condition from dual;
    --============================
      
      where_condition:=where_condition||')';








if(inpar_type=1) then
   
    select REPLACE(where_condition,'''', '''''') into where_condition from dual;
    --select REPLACE(where_condition, ''',''', ''''',''''') into where_condition from dual;
    --select REPLACE(where_condition, 'yyyy/mm/dd''', 'yyyy/mm/dd''''') into where_condition from dual;
end if;


--------------------------------------------------------------------------------  
--  if (v_name_input_tbl='TBL_DEPOSIT' or v_name_input_tbl='TBL_LOAN') then
--  
--  var:=' select * from AKIN.'||v_name_input_tbl||' where '||where_condition||';';
--  
--  else
--    var:='select * from '||v_name_input_tbl||' where '||where_condition||';';
--
--  end if;--  if (v_name_input_tbl='TBL_DEPOSIT' or v_name_input_tbl='TBL_LOAN') then
--------------------------------------------------------------------------------

  if(v_name_input_tbl='TBL_DEPOSIT') then
    if(inpar_type!=1) then
       if(v_count!=0) then
      
     
            var:='select 
            tbl_profile.name as "profileName", tbl_profile.des as "profileDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
            DEP_ID as "depositId",
            dep.REF_DEPOSIT_TYPE as "depositTypeId",
            typee.name as "name",
            REF_BRANCH as "branchId",
            REF_CUSTOMER as "customerId",
            TO_CHAR(DUE_DATE,''yyyy/mm/dd'',''nls_calendar= persian'')  as "dueDate",
            BALANCE as "mande",
            TO_CHAR(OPENING_DATE,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
            RATE as "rate",
            MODALITY_TYPE as "tafkikSeporde",
            REF_DEPOSIT_ACCOUNTING as "hesabdariSepordeId",
            REF_CURRENCY as "currencyId"
            from akin.TBL_DEPOSIT dep,tbl_profile , TBL_DEPOSIT_TYPE typee where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' and typee.REF_DEPOSIT_TYPE=dep.REF_DEPOSIT_TYPE';
            
        else
            var:='select 
            tbl_profile.name as "profileName", tbl_profile.des as "profileDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
            DEP_ID as "depositId",
            dep.REF_DEPOSIT_TYPE as "depositTypeId",
            typee.name as "name",
            REF_BRANCH as "branchId",
            REF_CUSTOMER as "customerId",
            TO_CHAR(DUE_DATE,''yyyy/mm/dd'',''nls_calendar= persian'')  as "dueDate",
            BALANCE as "mande",
            TO_CHAR(OPENING_DATE,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
            RATE as "rate",
            MODALITY_TYPE as "tafkikSeporde",
            REF_DEPOSIT_ACCOUNTING as "hesabdariSepordeId",
            REF_CURRENCY as "currencyId"
            from akin.TBL_DEPOSIT dep, TBL_DEPOSIT_TYPE typee ,tbl_profile where tbl_profile.id = '||iidd||' and  typee.REF_DEPOSIT_TYPE=dep.REF_DEPOSIT_TYPE';
            --where_condition := NULL;
      end if;
    else
    if(v_count!=0) then
      
     
            var:='select 
            tbl_profile.name as "profileName", tbl_profile.des as "profileDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
            DEP_ID as "depositId",
            dep.REF_DEPOSIT_TYPE as "depositTypeId",
            typee.name as "name",
            REF_BRANCH as "branchId",
            REF_CUSTOMER as "customerId",
            TO_CHAR(DUE_DATE,''''yyyy/mm/dd'''',''''nls_calendar= persian'''')  as "dueDate",
            BALANCE as "mande",
            TO_CHAR(OPENING_DATE,''''yyyy/mm/dd'''',''''nls_calendar= persian'''') as "openingDate",
            RATE as "rate",
            MODALITY_TYPE as "tafkikSeporde",
            REF_DEPOSIT_ACCOUNTING as "hesabdariSepordeId",
            REF_CURRENCY as "currencyId"
           from akin.TBL_DEPOSIT dep,tbl_profile , TBL_DEPOSIT_TYPE typee where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' and typee.REF_DEPOSIT_TYPE=dep.REF_DEPOSIT_TYPE';
            
        else
            var:='select 
            tbl_profile.name as "profileName", tbl_profile.des as "profileDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
            DEP_ID as "depositId",
            dep.REF_DEPOSIT_TYPE as "depositTypeId",
            typee.name as "name",
            REF_BRANCH as "branchId",
            REF_CUSTOMER as "customerId",
            TO_CHAR(DUE_DATE,''''yyyy/mm/dd'''',''''nls_calendar= persian'''')  as "dueDate",
            BALANCE as "mande",
            TO_CHAR(OPENING_DATE,''''yyyy/mm/dd'''',''''nls_calendar= persian'''') as "openingDate",
            RATE as "rate",
            MODALITY_TYPE as "tafkikSeporde",
            REF_DEPOSIT_ACCOUNTING as "hesabdariSepordeId",
            REF_CURRENCY as "currencyId"
            from akin.TBL_DEPOSIT dep, TBL_DEPOSIT_TYPE typee ,tbl_profile where tbl_profile.id = '||iidd||' and  typee.REF_DEPOSIT_TYPE=dep.REF_DEPOSIT_TYPE';
            --where_condition := NULL;
        
      end if;
      end if;

--------------------------------------------------------------------------------

elsif (v_name_input_tbl='TBL_LOAN') then
 if(inpar_type!=1) then
      if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
           lo.id as "loanId",
          lo.COD_NOE_TASHILAT as "loanTypeId",
          typee.name as "name",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
          TO_CHAR(TARIKH_TASHKIL,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH_MOSAVVAB as "mablaghMosavab",
          MANDE_KOL_VAM as "mandeJari",
          MANDE_SARRESID_GOZASHTE as "mandeSarresidGozashte",
          MANDE_MOAVVAGH as "mandeMoavagh",
          MANDE_MASHKUKOLVOSUL as "mandeMashkokVosol",
          rate as "rate"
          from TBL_LOAN lo,TBL_LOAN_TYpe typee,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' and typee.ref_loan_type =lo.COD_NOE_TASHILAT';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
           lo.id as "loanId",
          lo.COD_NOE_TASHILAT as "loanTypeId",
          typee.name as "name",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
          TO_CHAR(TARIKH_TASHKIL,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH_MOSAVVAB as "mablaghMosavab",
          MANDE_KOL_VAM as "mandeJari",
          MANDE_SARRESID_GOZASHTE as "mandeSarresidGozashte",
          MANDE_MOAVVAGH as "mandeMoavagh",
          MANDE_MASHKUKOLVOSUL as "mandeMashkokVosol",
          rate as "rate"
          from TBL_LOAN lo,tbl_loan_type typee,tbl_profile where  tbl_profile.id = '||iidd||' and typee.ref_loan_type =lo.COD_NOE_TASHILAT' ;
          --where_condition := NULL;
      end if;
      else
    if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
         lo.ID as "loanId",
          lo.COD_NOE_TASHILAT as "loanTypeId",
          typee.name as "name",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
          TO_CHAR(TARIKH_TASHKIL,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH_MOSAVVAB as "mablaghMosavab",
          MANDE_KOL_VAM as "mandeJari",
          MANDE_SARRESID_GOZASHTE as "mandeSarresidGozashte",
          MANDE_MOAVVAGH as "mandeMoavagh",
          MANDE_MASHKUKOLVOSUL as "mandeMashkokVosol",
          rate as "rate"
          from TBL_LOAN lo,TBL_LOAN_TYpe typee,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' and typee.ref_loan_type =lo.COD_NOE_TASHILAT';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
          lo.id as "loanId",
          lo.COD_NOE_TASHILAT as "loanTypeId",
          typee.name as "name",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
          TO_CHAR(TARIKH_TASHKIL,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH_MOSAVVAB as "mablaghMosavab",
          MANDE_KOL_VAM as "mandeJari",
          MANDE_SARRESID_GOZASHTE as "mandeSarresidGozashte",
          MANDE_MOAVVAGH as "mandeMoavagh",
          MANDE_MASHKUKOLVOSUL as "mandeMashkokVosol",
          rate as "rate"
          from TBL_LOAN lo,tbl_loan_type typee,tbl_profile where  tbl_profile.id = '||iidd||' and typee.ref_loan_type =lo.COD_NOE_TASHILAT' ;
          --where_condition := NULL;
          end if;
          end if;
--------------------------------------------------------------------------------




elsif (v_name_input_tbl='TBL_GUARANTEE') then
 if(inpar_type!=1) then
      if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
           lo.id as "guaranteeId",
          lo.COD_NOE_zemanat as "guaranteeTypeId",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
          TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhSarresid",
           TO_CHAR(TARIKH_SODUR,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH as "mablaghZemanat",
          EMKAN_TAMDID as "emkanTamdid",
          MABLAGH_NAGHDI as "mablaghZemanatNaghdi",
          MABLAGH_GHEYR_NAGHDI as "mablaghZemanatGheirNaghdi"
          from TBL_GUARANTEE lo ,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' ';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
           lo.id as "guaranteeId",
          lo.COD_NOE_zemanat as "guaranteeTypeId",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
           TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhSarresid",
           TO_CHAR(TARIKH_SODUR,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH as "mablaghZemanat",
          EMKAN_TAMDID as "emkanTamdid",
          MABLAGH_NAGHDI as "mablaghZemanatNaghdi",
          MABLAGH_GHEYR_NAGHDI as "mablaghZemanatGheirNaghdi"
          from TBL_GUARANTEE lo,tbl_profile where  tbl_profile.id = '||iidd||' ' ;
          --where_condition := NULL;
      end if;
      else
    if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
         lo.id as "guaranteeId",
          lo.COD_NOE_zemanat as "guaranteeTypeId",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
           TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhSarresid",
           TO_CHAR(TARIKH_SODUR,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH as "mablaghZemanat",
          EMKAN_TAMDID as "emkanTamdid",
          MABLAGH_NAGHDI as "mablaghZemanatNaghdi",
          MABLAGH_GHEYR_NAGHDI as "mablaghZemanatGheirNaghdi"
          from TBL_GUARANTEE lo,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' ';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
          lo.id as "guaranteeId",
          lo.COD_NOE_zemanat as "guaranteeTypeId",
          REF_SHOBE as "branchId",
          REF_MOSHTARI as "customerId",
          arz as "currencyId",
           TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhSarresid",
           TO_CHAR(TARIKH_SODUR,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          MABLAGH as "mablaghZemanat",
          EMKAN_TAMDID as "emkanTamdid",
          MABLAGH_NAGHDI as "mablaghZemanatNaghdi",
          MABLAGH_GHEYR_NAGHDI as "mablaghZemanatGheirNaghdi"
          from TBL_GUARANTEE lo,tbl_profile where  tbl_profile.id = '||iidd||' ' ;
          --where_condition := NULL;
          end if;
          end if;








--------------------------------------------------------------------------------

--------------------------------------------------------------------------------




elsif (v_name_input_tbl='TBL_COLLATERAL') then
 if(inpar_type!=1) then
      if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
           lo.id as "collateralId",
          lo.COD_NOE_vasighe as "collateralTypeId",
          nam_noe_vasighe as "collateralTypeName",
          REF_MOSHTARI as "customerId",
          ARZESH_TARHIN_SHODE as "arzeshTarhinShode",
          TO_CHAR(TARIKH_TARHIN,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhTarhin",
          TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          ARZESH_ARZYABI_SHODE as "arzeshArzyabiShode",
          ZARIB_NAGHDINEGI as "zaribNaghdShavandegi"
          
          from TBL_COLLATERAL lo ,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' ';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
            lo.id as "collateralId",
          lo.COD_NOE_vasighe as "collateralTypeId",
          nam_noe_vasighe as "collateralTypeName",
          REF_MOSHTARI as "customerId",
          ARZESH_TARHIN_SHODE as "arzeshTarhinShode",
          TO_CHAR(TARIKH_TARHIN,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhTarhin",
          TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          ARZESH_ARZYABI_SHODE as "arzeshArzyabiShode",
          ZARIB_NAGHDINEGI as "zaribNaghdShavandegi"
          from TBL_COLLATERAL lo,tbl_profile where  tbl_profile.id = '||iidd||' ' ;
          --where_condition := NULL;
      end if;
      else
    if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
         lo.id as "collateralId",
          lo.COD_NOE_vasighe as "collateralTypeId",
          nam_noe_vasighe as "collateralTypeName",
          REF_MOSHTARI as "customerId",
          ARZESH_TARHIN_SHODE as "arzeshTarhinShode",
          TO_CHAR(TARIKH_TARHIN,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhTarhin",
          TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          ARZESH_ARZYABI_SHODE as "arzeshArzyabiShode",
          ZARIB_NAGHDINEGI as "zaribNaghdShavandegi"
          from TBL_COLLATERAL lo,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' ';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
          lo.id as "collateralId",
          lo.COD_NOE_vasighe as "collateralTypeId",
          nam_noe_vasighe as "collateralTypeName",
          REF_MOSHTARI as "customerId",
          ARZESH_TARHIN_SHODE as "arzeshTarhinShode",
          TO_CHAR(TARIKH_TARHIN,''yyyy/mm/dd'',''nls_calendar= persian'') as "tarikhTarhin",
          TO_CHAR(TARIKH_SARRESID,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          ARZESH_ARZYABI_SHODE as "arzeshArzyabiShode",
          ZARIB_NAGHDINEGI as "zaribNaghdShavandegi"
          from TBL_COLLATERAL lo,tbl_profile where  tbl_profile.id = '||iidd||' ' ;
          --where_condition := NULL;
          end if;
          end if;








--------------------------------------------------------------------------------







elsif (v_name_input_tbl='TBL_BRANCH') then
    if(v_count!=0) then
    select REPLACE(where_condition, 'and', 'or') into where_condition from dual;
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
          br.id as "branchID",
          br.NAM as "branchName",
          COD_SHAHR as "cityId",
          NAM_SHAHR as "cityName",
          COD_OSTAN as "stateId",
          NAM_OSTAN as "stateName"
          from TBL_BRANCH br,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd;
    else
        --var:='select 
        --tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
        --BRN_ID as "branchId",
        --br.NAME as "branchName",
        --REF_CTY_ID as "cityId",
        --CITY_NAME as "cityName",
        --REF_STA_ID as "stateId",
        --STA_NAME as "stateName"
        --from TBL_BRANCH br,tbl_profile where tbl_profile.id = '||INPAR_ID; 
        where_condition := NULL;
end if;
--------------------------------------------------------------------------------
elsif (v_name_input_tbl='TBL_CITY') then
if(v_count!=0) then

var:='select
tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
cty.id as "cityId",
nam as "cityName",
cty.tozih as "cityDes",
OSTAN_ID as "stateId"
from TBL_shahr cty,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd;
else
--var:='select
--tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
--CTY_ID as "cityId",
--CTY_NAME as "cityName",
--cty.DES as "cityDes",
--REF_STA_ID as "stateId"
--from TBL_CITY cty,tbl_profile where tbl_profile.id = '||INPAR_ID; 
where_condition := NULL;
end if;
--------------------------------------------------------------------------------
elsif (v_name_input_tbl='TBL_CURRENCY') then
if(v_count!=0) then

var:='select
tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
cur.id as "id",
name_arz as "curName",
arz as "swiftCode"
from tbl_arz cur,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd;
else
--var:='select
--tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
--CUR_ID as "id",
--CUR_NAME as "curName",
--SWIFT_CODE as "swiftCode",
--cur.DES as "curDes"
--from TBL_CURRENCY cur,tbl_profile where tbl_profile.id = '||INPAR_ID;
where_condition := NULL;
end if;
--------------------------------------------------------------------------------
elsif (v_name_input_tbl='TBL_CUSTOMER') then
if(v_count!=0) then

var:='select
tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
TBL_CUSTOMER.id as "id",
TBL_CUSTOMER.NAM as "customerName",
TBL_CUSTOMER.COD_MELLI as "meliCode",
TBL_CUSTOMER.ADDRESS as "address",
TBL_CUSTOMER.TARIKH_TAVVALOD as "birthdate",
TBL_CUSTOMER.JENSIAT as "gender",
TBL_CUSTOMER.MAHIAT_MOSHTARI as "customerType",
TBL_CUSTOMER.REF_SHOBE as "branchId"
from TBL_CUSTOMER ,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd;
else
--var:='select
--"profileName","des","createDate",
--CUS_ID as "id",
-- "customerName",
--FAMILY as "customerFamily",
--NAT_REG_CODE as "meliCode",
--ADDRESS as "address",
--BIRTHDATE as "birthdate",
--GENDER as "gender",
--BRANCH_ID as "branchId" from(
--
--select
--tbl_profile.name as "profileName", tbl_profile.des as "des" ,tbl_profile.create_date as "createDate",
--CUS_ID  ,
--cus.NAME as "customerName",
--FAMILY,
--NAT_REG_CODE ,
--ADDRESS ,
--BIRTHDATE ,
--GENDER as ,
--BRANCH_ID 
--from TBL_CUSTOMER cus,tbl_profile where tbl_profile.id = '||INPAR_ID||'
-- ORDER BY (cus.CUS_ID) desc
-- )
--WHERE ROWNUM <= 50';
where_condition := NULL;
end if;
--------------------------------------------------------------------------------
end if;
if(where_condition is null) then
  RETURN 'select * from dual where 1>2';
  else 
  
  --var:=to_char(var);
  return var;
  end if;

  
END TEST_SAKHTE_NAMAYE;
--------------------------------------------------------
--  DDL for Function FNC_NORMSINV
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_NORMSINV" 
 /*
  Programmer Name: MYM
  Release Date/Time:1395/06/06-17:00
  Version: 1.0
  Category: 2
  Description: MOADEL TABE EXCEL: NORM.S.INV(0.9)
  */
(
  INPAR_PROB IN FLOAT 
) RETURN FLOAT AS 
  A1 FLOAT := -39.6968302866538;
  A2 FLOAT := 220.946098424521;
  A3 FLOAT := -275.928510446969;
  A4 FLOAT := 138.357751867269;
  A5 FLOAT := -30.6647980661472;
  A6 FLOAT := 2.50662827745924;
  
  B1 FLOAT := -54.4760987982241;
  B2 FLOAT := 161.585836858041;
  B3 FLOAT := -155.698979859887;
  B4 FLOAT := 66.8013118877197;
  B5 FLOAT := -13.2806815528857;
  
  C1 FLOAT := -7.78489400243029E-03;
  C2 FLOAT := -0.322396458041136;
  C3 FLOAT := -2.40075827716184;
  C4 FLOAT := -2.54973253934373;
  C5 FLOAT := 4.37466414146497;
  C6 FLOAT := 2.93816398269878;
  
  D1 FLOAT := 7.78469570904146E-03;
  D2 FLOAT := 0.32246712907004;
  D3 FLOAT := 2.445134137143;
  D4 FLOAT := 3.75440866190742;
  
  P_LOW FLOAT := 0.02425;
  P_HIGH FLOAT := 1-P_LOW;
  LOC_Q FLOAT;
  LOC_R FLOAT;
  LOC_RETVAL FLOAT;
  
BEGIN
  IF((INPAR_PROB < 0) OR (INPAR_PROB > 1))THEN
    RETURN -1;
  ELSIF(INPAR_PROB < P_LOW) THEN
    LOC_Q := SQRT(-2*LN(INPAR_PROB));-----PAYE LOG??
    LOC_RETVAL := (((((C1 * LOC_Q + C2) * LOC_Q + C3) * LOC_Q + C4) * LOC_Q + C5) * LOC_Q + C6) / ((((D1 * LOC_Q + D2) * LOC_Q + D3) * LOC_Q + D4) * LOC_Q + 1);
  ELSIF (INPAR_PROB <= P_HIGH) THEN
    LOC_Q := INPAR_PROB - 0.5;
    LOC_R := LOC_Q * LOC_Q;
    LOC_RETVAL := (((((A1 * LOC_R + A2) * LOC_R + A3) * LOC_R + A4) * LOC_R + A5) * LOC_R + A6) * LOC_Q / (((((B1 * LOC_R + B2) * LOC_R + B3) * LOC_R + B4) * LOC_R + B5) * LOC_R + 1);
  ELSE
    LOC_Q := SQRT(-2 * LN(1 - INPAR_PROB));
    LOC_RETVAL := -(((((C1 * LOC_Q + C2) * LOC_Q + C3) * LOC_Q + C4) * LOC_Q + C5) * LOC_Q + C6) / ((((D1 * LOC_Q + D2) * LOC_Q + D3) * LOC_Q + D4) * LOC_Q + 1);
  END IF;
  RETURN LOC_RETVAL;
END FNC_NORMSINV;
--------------------------------------------------------
--  DDL for Function FNC_NORMSDIST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_NORMSDIST" 
 /*
  Programmer Name: MYM
  Release Date/Time:1395/06/06-17:23
  Version: 1.0
  Category: 2
  Description: MOADEL TAABE EXCEL: NORM.S.DIST(1.33333, 1)
  */
(
  INPAR_X IN FLOAT 
) RETURN FLOAT AS 
  LOC_RESULT FLOAT;
  LOC_L FLOAT := 0;
  LOC_K FLOAT := 0;
  LOC_DCND FLOAT := 0;
  LOC_PI FLOAT := 3.1415926535897932384626433832795;
  A1 FLOAT := 0.31938153;
  A2 FLOAT := -0.356563782;
  A3 FLOAT := 1.781477937;
  A4 FLOAT := -1.821255978;
  A5 FLOAT := 1.330274429;

BEGIN
    LOC_L := ABS(INPAR_X);

   IF(LOC_L >= 30)THEN
        IF( SIGN(INPAR_X) = 1)THEN
            LOC_RESULT := 1;
        ELSE
            LOC_RESULT := 0;
        END IF;
    ELSE
    -- perform calculation
        LOC_K := 1.0 / (1.0 + 0.2316419 * LOC_L);
        LOC_DCND := 1.0 - 1.0 / SQRT(2 * LOC_PI) * EXP(-LOC_L * LOC_L / 2.0) *
        (A1 * LOC_K + A2 * LOC_K * LOC_K + A3 * POWER(LOC_K, 3.0) + A4 * POWER(LOC_K, 4.0) + A5 * POWER (LOC_K, 5.0));
        IF (INPAR_X < 0) THEN
            LOC_RESULT := 1 - LOC_DCND;
        ELSE
        LOC_RESULT := LOC_DCND;
        END IF;
    END IF;
		RETURN LOC_RESULT;
END FNC_NORMSDIST;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_DF_VARIANCE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_REPORT_DF_VARIANCE" (inpar_report IN NUMBER ) RETURN VARCHAR2 AS
/*
  Programmer Name: NAVID
  Release Date/Time:1395/06/18-11:14
  Version: 1.0
  Category: 2
  Description: SAKHT GOZARESH(CHART) AZ RUYE KHORUJIYE NAMAYE
                      Y-AXIS = LGD
                      X-AXIS = NOE TASHILAT
                      NAME = NAME_TASHILAT
  */
     var_loan number;
var_GUARANTEE number;
var_COLLATERAL number;
var_BRANCH number;
var_customer number;
  LOC_NAMAYE clob;

BEGIN

select ref_loan into var_loan from tbl_report where id = inpar_report;
select REF_GUARANTEE into var_GUARANTEE from tbl_report where id = inpar_report;
select REF_COLLATERAL into var_COLLATERAL from tbl_report where id = inpar_report;
select REF_BRANCH into var_BRANCH from tbl_report where id = inpar_report;
select REF_CUSTOMER into var_customer from tbl_report where id = inpar_report;



  select '
select *
from tbl_loan lo
where 

lo.id in
     ( '|| FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',var_loan) ||')
     AND REF_MOSHTARI IN ('||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',var_customer) ||')
    
      AND REF_SHOBE IN ( '||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH)||' )



     '
INTO
     LOC_NAMAYE
    FROM DUAL;

  LOC_NAMAYE := CASE WHEN LOC_NAMAYE IS NULL THEN 'TBL_LOAN' ELSE LOC_NAMAYE END ;
  LOC_NAMAYE := 'SELECT n.COD_NOE_TASHILAT AS "x" ,
                  MAX(CASE
                  WHEN n.NAM_NOE_TASHILAT IS NULL
                  THEN '||''''||' نوع تسهيلات'||''''||' || '
                    
                    ||' n.COD_NOE_TASHILAT  ELSE n.NAM_NOE_TASHILAT
                END)
                                    AS "name",
                 round( VARIANCE(n.MANDE_MOAVVAGH),3) AS "y",
                 n.COD_NOE_TASHILAT AS "کد نوع تسهيلات" ,
                  MAX(CASE
                  WHEN n.NAM_NOE_TASHILAT IS NULL
                  THEN '||''''||' نوع تسهيلات'||''''||' || '
                    
                    ||' n.COD_NOE_TASHILAT  ELSE n.NAM_NOE_TASHILAT
                END)
                                    AS "نام نوع تسهيلات",
                 round( VARIANCE(n.MANDE_MOAVVAGH),3) AS "واريانس مانده معوق"
                                FROM TBL_LOAN N, (' || LOC_NAMAYE || ') lo
                                WHERE N.id = Lo.id
                                GROUP BY n.COD_NOE_TASHILAT';  
  RETURN LOC_NAMAYE;
END FNC_REPORT_DF_VARIANCE;
--------------------------------------------------------
--  DDL for Function FNC_RWA
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_RWA" 
 /*
  Programmer Name: morteza.sahi
  Release Date/Time:1395/06/18-15:14
  Version: 1.0
  Category: 2
  Description: SAKHT GOZARESH(CHART) AZ RUYE KHORUJIYE NAMAYE

  */
(
  INPAR_STR IN number 
) RETURN VARCHAR2 AS 
var varchar2(4000);
BEGIN
var:='SELECT    tl.COD_NOE_TASHILAT as "x",
max(case when lo."نوع"  is null then  ''تسهيلات ''||  tl.COD_NOE_TASHILAT else  lo."نوع"  end) AS "name"  ,
     round( avg(na.rwa),2) AS "y",
       tl.COD_NOE_TASHILAT as "کد نوع تسهيلات",
max(case when lo."نوع"  is null then  ''تسهيلات ''||  tl.COD_NOE_TASHILAT else  lo."نوع"  end) AS "نام نوع تسهيلات"  ,
     round( avg(na.rwa),2) AS "ميانگين دارايي موزون به ريسک"
  FROM TBL_NAVIX na,
    ('||FNC_PROFILE_CREATE_QUERY(INPAR_STR)||') lo
   ,tbl_loan tl
  WHERE na.REF_TASHILAT  = lo."شناسه"
  and   tl.ID =lo."شناسه"
  --AND lo.MANDE_MOAVVAGH != 0
  GROUP BY  tl.COD_NOE_TASHILAT';
  RETURN var;
END FNC_RWA;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_DF_CV
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_REPORT_DF_CV" (inpar_report IN NUMBER ) RETURN VARCHAR2 AS 
/*
  Programmer Name: NAVID
  Release Date/Time:1395/06/18-14:14
  Version: 1.0
  Category: 2
  Description: SAKHT GOZARESH(CHART) AZ RUYE KHORUJIYE NAMAYE
                      Y-AXIS = CV
                      X-AXIS = NOE TASHILAT
  */
   var_loan number;
var_GUARANTEE number;
var_COLLATERAL number;
var_BRANCH number;
var_customer number;
  LOC_NAMAYE clob;
BEGIN


select ref_loan into var_loan from tbl_report where id = inpar_report;
select REF_GUARANTEE into var_GUARANTEE from tbl_report where id = inpar_report;
select REF_COLLATERAL into var_COLLATERAL from tbl_report where id = inpar_report;
select REF_BRANCH into var_BRANCH from tbl_report where id = inpar_report;
select REF_CUSTOMER into var_customer from tbl_report where id = inpar_report;




select '
select *
from tbl_loan lo
where 

lo.id in
     ( '|| FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',var_loan) ||')
     AND REF_MOSHTARI IN ('||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',var_customer) ||')
    
      AND REF_SHOBE IN ( '||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH)||' )



     '
INTO
     LOC_NAMAYE
    FROM DUAL;



LOC_NAMAYE := CASE WHEN LOC_NAMAYE IS NULL THEN 'TBL_LOAN' ELSE LOC_NAMAYE END ;
LOC_NAMAYE := 'SELECT n.COD_NOE_TASHILAT AS "x" ,
                  MAX(CASE
                  WHEN n.NAM_NOE_TASHILAT IS NULL
                  THEN '||''''||' نوع تسهيلات'||''''||' || '
                    
                    ||' n.COD_NOE_TASHILAT  ELSE n.NAM_NOE_TASHILAT
                END)
                                    AS "name",
                  round( ((STDDEV(n.MANDE_MOAVVAGH) / AVG(n.MANDE_MOAVVAGH))),3) AS "y",
                   n.COD_NOE_TASHILAT AS "کد نوع تسهيلات" ,
                  MAX(CASE
                  WHEN n.NAM_NOE_TASHILAT IS NULL
                  THEN '||''''||' نوع تسهيلات'||''''||' || '
                    
                    ||' n.COD_NOE_TASHILAT  ELSE n.NAM_NOE_TASHILAT
                END)
                                    AS "نام نوع تسهيلات",
                  round( ((STDDEV(n.MANDE_MOAVVAGH) / AVG(n.MANDE_MOAVVAGH))),3) AS "ضريب تغييرات مانده معوق"
                                FROM TBL_LOAN N, (' || LOC_NAMAYE || ') lo
                                WHERE N.id = Lo.id AND n.MANDE_MOAVVAGH != 0
                                GROUP BY n.COD_NOE_TASHILAT';
                                
  RETURN LOC_NAMAYE;
END FNC_REPORT_DF_CV;
--------------------------------------------------------
--  DDL for Function FNC_LOAN_TYPE_VARIANCE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_LOAN_TYPE_VARIANCE" (inpar_report IN NUMBER )
  RETURN VARCHAR2
AS
  /*
  Programmer Name: NAVID
  Release Date/Time:1395/06/20-11:14
  Version: 1.0
  Category: 2
  Description: SAKHT GOZARESH(CHART) AZ RUYE KHORUJIYE NAMAYE
  Y-AXIS = var(pd)
  X-AXIS = NOE TASHILAT
  NAME = NAME_TASHILAT
  */
  
  var_loan number;
var_GUARANTEE number;
var_COLLATERAL number;
var_BRANCH number;
var_customer number;
  LOC_NAMAYE clob;
  
BEGIN


select ref_loan into var_loan from tbl_report where id = inpar_report;
select REF_GUARANTEE into var_GUARANTEE from tbl_report where id = inpar_report;
select REF_COLLATERAL into var_COLLATERAL from tbl_report where id = inpar_report;
select REF_BRANCH into var_BRANCH from tbl_report where id = inpar_report;
select REF_CUSTOMER into var_customer from tbl_report where id = inpar_report;





select '
select *
from tbl_loan lo
where 

lo.id in
     ( '|| FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',var_loan) ||')
     AND REF_MOSHTARI IN ('||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',var_customer) ||')
    
      AND REF_SHOBE IN ( '||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH)||' )



     '
INTO
     LOC_NAMAYE
    FROM DUAL;




  --LOC_NAMAYE := FNC_PROFILE_CREATE_QUERY(INPAR_REF_ABAR_NAMAYE,0);
  LOC_NAMAYE :=
  CASE
  WHEN LOC_NAMAYE IS NULL THEN
    'TBL_LOAN'
  ELSE
    LOC_NAMAYE
  END ;
  LOC_NAMAYE :=' SELECT tl.COD_NOE_TASHILAT AS "x" ,    
                MAX(    
                CASE      
                WHEN tl.NAM_NOE_TASHILAT IS NULL       
                THEN '||''''||' نوع تسهيلات'||''''||' || ' ||' tl.COD_NOE_TASHILAT  ELSE tl.NAM_NOE_TASHILAT                
                END)                   AS "name",    
                ROUND(VARIANCE(n.pd),5)   AS "y"
                FROM TBL_NAVIX n,    
                (' || LOC_NAMAYE || ') lo   
                ,tbl_loan tl  
                WHERE n.REF_TASHILAT  = lo.id
                and   tl.ID =lo.id
                GROUP BY  tl.COD_NOE_TASHILAT';
  RETURN LOC_NAMAYE;




--return 'select id from tbl_loan where rownum<10';

END FNC_LOAN_TYPE_VARIANCE;
--------------------------------------------------------
--  DDL for Function FNC_TOP_TEN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_TOP_TEN" 
(
  inpar_report IN number 
) RETURN VARCHAR2 
AS 

var_loan number;
var_GUARANTEE number;
var_COLLATERAL number;
var_BRANCH number;
var_customer number;
VAR_QUERY varchar2(4000);

BEGIN


select ref_loan into var_loan from tbl_report where id = inpar_report;
select REF_GUARANTEE into var_GUARANTEE from tbl_report where id = inpar_report;
select REF_COLLATERAL into var_COLLATERAL from tbl_report where id = inpar_report;
select REF_BRANCH into var_BRANCH from tbl_report where id = inpar_report;
select REF_CUSTOMER into var_customer from tbl_report where id = inpar_report;






select '

select 
cod_noe_tashilat as "کد نوع تسهيلات",
nam_noe_tashilat as "نام نوع تسهيلات",
MABLAGH_MOSAVVAB as "مبلغ مصوب",
mande_asl_vam as "مانده اصل وام",
mande_kol_vam as "مانده کل وام",
MANDE_SARRESID_GOZASHTE as "مانده سررسيد گذشته",
MANDE_MASHKUKOLVOSUL as "مانده مشکوک الوصول",
MANDE_MOAVVAGH as "مانده معوق",
TARIKH_SARREDID as "تاريخ سررسيد"

from 
(select * from tbl_loan lo
where 

lo.id in
     ( '|| FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',var_loan) ||')
     AND REF_MOSHTARI IN ('||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',var_customer) ||')
    
      AND REF_SHOBE IN ( '||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH)||' )
order by MABLAGH_MOSAVVAB desc)   where rownum <11 


     '
INTO
     VAR_QUERY
    FROM DUAL;

 return VAR_QUERY;


--var_query:='select * from 
--(SELECT    lo.*
--  FROM     ('||FNC_PROFILE_CREATE_QUERY(INPAR_report,0)||') lo
--   ,tbl_loan tl
--  WHERE   tl.ID ="loanId"
--   order by lo. "mablaghMosavab" DESC) where  ROWNUM <11';
--   
--   RETURN var_query;
--   
END FNC_TOP_TEN;
--------------------------------------------------------
--  DDL for Function FNC_IRB
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_IRB" ( inpar_report IN NUMBER ) RETURN VARCHAR2 AS

var_loan number;
var_GUARANTEE number;
var_COLLATERAL number;
var_BRANCH number;
var_customer number;

 VAR_QUERY   CLOB;
BEGIN

select ref_loan into var_loan from tbl_report where id = inpar_report;
select REF_GUARANTEE into var_GUARANTEE from tbl_report where id = inpar_report;
select REF_COLLATERAL into var_COLLATERAL from tbl_report where id = inpar_report;
select REF_BRANCH into var_BRANCH from tbl_report where id = inpar_report;
select REF_CUSTOMER into var_customer from tbl_report where id = inpar_report;

-- VAR   := 'SELECT    lo.*,round(tn.RWA,2) as "دارايي موزون شده به ريسک" ,tn.pd as "احتمال نکول"
--  FROM       (' ||
-- FNC_PROFILE_CREATE_QUERY(INPAR_STR,0) ||
-- ') lo
--   ,tbl_navix tn
--     WHERE  -- tl.ID =lo."شناسه" 
--    -- and  
--     tn.REF_TASHILAT ="loanId"
--';
-- RETURN VAR;
select '
select
lo.MABLAGH_MOSAVVAB as "مبلغ مصوب",
lo.cod_noe_tashilat as "کد نوع تسهيلات",
lo.nam_noe_tashilat as "نام نوع تسهيلات",
lo.mande_asl_vam as "مانده اصل وام",
lo.mande_kol_vam as "مانده کل وام",
lo.MANDE_SARRESID_GOZASHTE as "مانده سررسيد گذشته",
lo.MANDE_MASHKUKOLVOSUL as "مانده مشکوک الوصول",
lo.MANDE_MOAVVAGH as "مانده معوق",
lo.TARIKH_SARREDID as "تاريخ سررسيد",
lo.EMHAL_SHODE_NASHODE as "وضعيت امحال",
round(tn.RWA,2) as "دارايي موزون شده به ريسک" ,
tn.pd as "احتمال نکول"
from tbl_loan lo,tbl_navix tn
where  tn.REF_TASHILAT =lo.id 
  and 

lo.id in
     ( '|| FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',var_loan) ||')
     AND REF_MOSHTARI IN ('||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',var_customer) ||')
    
      AND REF_SHOBE IN ( '||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH)||' )



     '
INTO
     VAR_QUERY
    FROM DUAL;

 

--  AND REF_VASIGHE IN ( 
--     FNC_PRIVATE_CREATE_QUERY('TBL_GUARANTEE',var_GUARANTEE))





return VAR_QUERY;
END FNC_IRB;
--------------------------------------------------------
--  DDL for Function FNC_PAGING_QUERY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_PAGING_QUERY" 
 /*
  Programmer Name: MYM
  Release Date/Time:1395/06/22
  Version: 1.0
  Category:2
  Description: YEK QUERY V PAGE-SIZE V PAGE-NUMBER MIGIRE VA DADEHASHO PAS MIDE
  */
(
  INPAR_PAGE_SIZE IN NUMBER 
, INPAR_PAGE_NUMBER IN NUMBER 
, INPAR_QUERY IN clob 
) RETURN clob AS 
  LOC_QUERY clob; 
  LOC_LOW NUMBER := (INPAR_PAGE_NUMBER-1)*INPAR_PAGE_SIZE+1; 
  LOC_UP NUMBER := INPAR_PAGE_NUMBER*INPAR_PAGE_SIZE;  
BEGIN
  LOC_QUERY := 'SELECT * FROM (
                              SELECT ROWNUM "رديف", t.*
                              FROM (' || INPAR_QUERY ||')T)
                              WHERE  "رديف" BETWEEN ' || LOC_LOW || ' AND ' ||LOC_UP;
 RETURN LOC_QUERY;
END FNC_PAGING_QUERY;
--------------------------------------------------------
--  DDL for Function FNC_PAGE_NUMBER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_PAGE_NUMBER" 
 /*
  Programmer Name: MYM
  Release Date/Time:1395/06/23
  Version: 1.0
  Category:2
  Description: YEK QUERY V PAGE SIZE MIGIRE VA TEDAD PAGE RO MIDE
  */
(
  INAPR_PAGE_SIZE IN NUMBER 
, INPAR_QUERY IN VARCHAR2 
) RETURN varchar2 AS 
 LOC_QUERY VARCHAR2(4000);
 LOC_CNT varchar2(4000);
BEGIN
  LOC_QUERY :='SELECT FLOOR((COUNT(*)/'|| INAPR_PAGE_SIZE ||')+1)  FROM ('||INPAR_QUERY||')';
  EXECUTE IMMEDIATE LOC_QUERY INTO LOC_CNT;
  RETURN LOC_CNT;
END FNC_PAGE_NUMBER;
--------------------------------------------------------
--  DDL for Function FNC_AVG_MIN_MAX
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_AVG_MIN_MAX" 
 /*
  Programmer Name: morteza.sahi
  Release Date/Time:1395/06/18-15:14
  Version: 1.0
  Category: 2
  Description: SAKHT GOZARESH(CHART) AZ RUYE KHORUJIYE NAMAYE

  */
(
  INPAR_report IN number 
) RETURN VARCHAR2 AS 

  var_loan number;
var_GUARANTEE number;
var_COLLATERAL number;
var_BRANCH number;
var_customer number;
  LOC_NAMAYE clob;




BEGIN


select ref_loan into var_loan from tbl_report where id = inpar_report;
select REF_GUARANTEE into var_GUARANTEE from tbl_report where id = inpar_report;
select REF_COLLATERAL into var_COLLATERAL from tbl_report where id = inpar_report;
select REF_BRANCH into var_BRANCH from tbl_report where id = inpar_report;
select REF_CUSTOMER into var_customer from tbl_report where id = inpar_report;

select '
select *
from tbl_loan lo
where 

lo.id in
     ( '|| FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',var_loan) ||')
     AND REF_MOSHTARI IN ('||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',var_customer) ||')
    
      AND REF_SHOBE IN ( '||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH)||' )



     '
INTO
     LOC_NAMAYE
    FROM DUAL;





LOC_NAMAYE :=
  CASE
  WHEN LOC_NAMAYE IS NULL THEN
    'TBL_LOAN'
  ELSE
    LOC_NAMAYE
  END ;
  LOC_NAMAYE :='SELECT * FROM 
(
SELECT MIN(TL.MABLAGH_MOSAVVAB) AS "min",
  MAX(TL.MABLAGH_MOSAVVAB) AS "max",
  ROUND(AVG(TL.MABLAGH_MOSAVVAB),2) AS "avg",
  TL.COD_NOE_TASHILAT AS "code",
  max(case when TL.NAM_NOE_TASHILAT  is null then '' تسهيلات ''||  tl.COD_NOE_TASHILAT else  TL.NAM_NOE_TASHILAT end) AS "name",
  ROUND(AVG(tn.pd),2) AS "pd"
FROM credit_risk.TBL_LOAN TL,
CREDIT_RISK.tbl_navix TN,
 (' || LOC_NAMAYE || ') lo  
WHERE TL.ID = tn.ref_tashilat
AND LO.id = TL.ID
GROUP BY TL.COD_NOE_TASHILAT)
ORDER BY "pd"';




  RETURN LOC_NAMAYE;
END FNC_AVG_MIN_MAX;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_TAFKIK_EGHTESADI
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_REPORT_TAFKIK_EGHTESADI" 
 /*
  Programmer Name: MYM
  Release Date/Time:1395/07/07
  Version: 1.0
  Category: 2
  Description: gozaresh, mileei tafkiki 
                x: noe_tashilat
                y: mablagh-mosavvab be tafkik bakhsh eghtesadi bank

  */
(
  inpar_report IN NUMBER 
) RETURN VARCHAR2 AS 


  var_loan number;
var_GUARANTEE number;
var_COLLATERAL number;
var_BRANCH number;
var_customer number;
  LOC_NAMAYE clob;
  
  
  
BEGIN

select ref_loan into var_loan from tbl_report where id = inpar_report;
select REF_GUARANTEE into var_GUARANTEE from tbl_report where id = inpar_report;
select REF_COLLATERAL into var_COLLATERAL from tbl_report where id = inpar_report;
select REF_BRANCH into var_BRANCH from tbl_report where id = inpar_report;
select REF_CUSTOMER into var_customer from tbl_report where id = inpar_report;



select '
select *
from tbl_loan lo
where 

lo.id in
     ( '|| FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',var_loan) ||')
     AND REF_MOSHTARI IN ('||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',var_customer) ||')
    
      AND REF_SHOBE IN ( '||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH)||' )



     '
INTO
     LOC_NAMAYE
    FROM DUAL;





  LOC_NAMAYE := CASE WHEN LOC_NAMAYE IS NULL THEN 'TBL_LOAN' ELSE LOC_NAMAYE END ;
  LOC_NAMAYE := 'SELECT T.*
                FROM (
                SELECT n.COD_NOE_TASHILAT  "name", SUM(CASE WHEN n.COD_BAKHSH_EGHTESADI = 1 THEN n.MABLAGH_MOSAVVAB ELSE 0 END) "y1", 
                SUM(CASE WHEN n.COD_BAKHSH_EGHTESADI = 2 THEN n.MABLAGH_MOSAVVAB ELSE 0 END) "y2",
                SUM(CASE WHEN n.COD_BAKHSH_EGHTESADI = 3 THEN n.MABLAGH_MOSAVVAB ELSE 0 END) "y3",
                SUM(CASE WHEN n.COD_BAKHSH_EGHTESADI = 4 THEN n.MABLAGH_MOSAVVAB ELSE 0 END) "y4",
                SUM(CASE WHEN n.COD_BAKHSH_EGHTESADI = 5 THEN n.MABLAGH_MOSAVVAB ELSE 0 END) "y5"
                FROM TBL_LOAN N, (' || LOC_NAMAYE || ') LO
                WHERE N.ID = LO.id
                GROUP BY N.COD_NOE_TASHILAT
                ORDER BY "name") T';
RETURN LOC_NAMAYE;
END FNC_REPORT_TAFKIK_EGHTESADI;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_SPIDERWEB_EGHTESADI
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_REPORT_SPIDERWEB_EGHTESADI" 
  /*
  Programmer Name: morteza.sahi
  Release Date/Time:1395/06/18-15:14
  Version: 1.0
  Category: 2
  Description: SAKHT GOZARESH(CHART) AZ RUYE KHORUJIYE NAMAYE
  */
  (
    inpar_report IN NUMBER )
  RETURN VARCHAR2
AS
var_loan number;
var_GUARANTEE number;
var_COLLATERAL number;
var_BRANCH number;
var_customer number;

  LOC_NAMAYE clob;
BEGIN
select ref_loan into var_loan from tbl_report where id = inpar_report;
select REF_GUARANTEE into var_GUARANTEE from tbl_report where id = inpar_report;
select REF_COLLATERAL into var_COLLATERAL from tbl_report where id = inpar_report;
select REF_BRANCH into var_BRANCH from tbl_report where id = inpar_report;
select REF_CUSTOMER into var_customer from tbl_report where id = inpar_report;

select '
select *
from tbl_loan lo
where 

lo.id in
     ( '|| FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',var_loan) ||')
     AND REF_MOSHTARI IN ('||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',var_customer) ||')
    
      AND REF_SHOBE IN ( '||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH)||' )



     '
INTO
     LOC_NAMAYE
    FROM DUAL;



  LOC_NAMAYE := CASE WHEN LOC_NAMAYE IS NULL THEN 'TBL_LOAN' ELSE LOC_NAMAYE END ;
  LOC_NAMAYE :='SELECT 
max( case when tl.COD_BAKHSH_EGHTESADI=1 then  ''کشاورزي''            
when tl.COD_BAKHSH_EGHTESADI=2 then   ''صنعت و معدن''            
when tl.COD_BAKHSH_EGHTESADI=3 then   ''مسکن''            
when tl.COD_BAKHSH_EGHTESADI=4 then   ''بازرگاني''            
when tl.COD_BAKHSH_EGHTESADI=5 then    ''خدمات''            
end) as "name" ,  
SUM(tl.MANDE_MASHKUKOLVOSUL+tl.MANDE_SARRESID_GOZASHTE+tl.MANDE_MOAVVAGH) AS MANDE_GOZASHTE,  
SUM(tl.MANDE_kol_VAM)                                                     AS kol_vam_mande,  
SUM(a.asl_sud)                                                            AS asl_sud
FROM TBL_LOAN tl,  
(SELECT REF_TASHILAT,    
SUM(tp.MABLAGH_ASL+tp.SUD_MOSTATER) AS asl_sud  
FROM TBL_PAYMENT tp   
GROUP BY tp.REF_TASHILAT  
)a,   
(' || LOC_NAMAYE || ') LO
WHERE tl.id = a.REF_TASHILAT
and   tl.ID =lo.id
GROUP BY tl.COD_BAKHSH_EGHTESADI';
  RETURN LOC_NAMAYE;




--return 'select id from tbl_loan where rownum < 10';
END fnc_report_Spiderweb_eghtesadi ;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_TAFKIK_FASLI
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_REPORT_TAFKIK_FASLI" 
  /*
  Programmer Name: morteza.um
  Release Date/Time:1395/07/07-15:14
  Version: 1.0
  Category: 2
  Description: SAKHT GOZARESH(CHART) AZ RUYE KHORUJIYE NAMAYE
  */
  (
    inpar_report IN NUMBER )
  RETURN VARCHAR2
AS
  var_loan number;
var_GUARANTEE number;
var_COLLATERAL number;
var_BRANCH number;
var_customer number;
  LOC_NAMAYE clob;
  
  
BEGIN

select ref_loan into var_loan from tbl_report where id = inpar_report;
select REF_GUARANTEE into var_GUARANTEE from tbl_report where id = inpar_report;
select REF_COLLATERAL into var_COLLATERAL from tbl_report where id = inpar_report;
select REF_BRANCH into var_BRANCH from tbl_report where id = inpar_report;
select REF_CUSTOMER into var_customer from tbl_report where id = inpar_report;

select '
select *
from tbl_loan lo
where 

lo.id in
     ( '|| FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',var_loan) ||')
     AND REF_MOSHTARI IN ('||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',var_customer) ||')
    
      AND REF_SHOBE IN ( '||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH)||' )



     '
INTO
     LOC_NAMAYE
    FROM DUAL;



  LOC_NAMAYE := CASE WHEN LOC_NAMAYE IS NULL THEN 'TBL_LOAN' ELSE LOC_NAMAYE END ;
  LOC_NAMAYE :='SELECT  
  max( case when tl.COD_BAKHSH_EGHTESADI=1 then  ''کشاورزي''            
  when tl.COD_BAKHSH_EGHTESADI=2 then   ''صنعت و معدن''            
  when tl.COD_BAKHSH_EGHTESADI=3 then   ''مسکن''            
  when tl.COD_BAKHSH_EGHTESADI=4 then   ''بازرگاني''            
  when tl.COD_BAKHSH_EGHTESADI=5 then    ''خدمات''            
  end) as "name" ,
    SUM(CASE WHEN TO_CHAR(tl.TARIKH_TASHKIL, ''DDD'') >= 90 AND TO_CHAR(tl.TARIKH_TASHKIL, ''DDD'') < 173 THEN tl.MABLAGH_MOSAVVAB ELSE 0 END) "spring",
    SUM(CASE WHEN TO_CHAR(tl.TARIKH_TASHKIL, ''DDD'') >= 173 AND TO_CHAR(tl.TARIKH_TASHKIL, ''DDD'') < 266 THEN tl.MABLAGH_MOSAVVAB ELSE 0 END)"summer",
    SUM(CASE WHEN TO_CHAR(tl.TARIKH_TASHKIL, ''DDD'') >= 266 AND TO_CHAR(tl.TARIKH_TASHKIL, ''DDD'') < 356 THEN tl.MABLAGH_MOSAVVAB ELSE 0 END) "fall",
    SUM(CASE WHEN TO_CHAR(tl.TARIKH_TASHKIL, ''DDD'') >= 356 OR TO_CHAR(tl.TARIKH_TASHKIL, ''DDD'') < 90 THEN tl.MABLAGH_MOSAVVAB ELSE 0 END) "winter"
  FROM TBL_LOAN tl,(' || LOC_NAMAYE || ') LO
  where  tl.ID =lo.id
  GROUP BY tl.COD_BAKHSH_EGHTESADI
  ORDER BY tl.COD_BAKHSH_EGHTESADI';
  RETURN LOC_NAMAYE;
END fnc_report_tafkik_fasli ;
--------------------------------------------------------
--  DDL for Function FNC_POISSON_DISTRIBUTION
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_POISSON_DISTRIBUTION" (
    M IN NUMBER , -- m= pd * range_count
    N IN NUMBER )
  RETURN NUMBER
AS
  ------------------------------------------------------------------------------
  /*
  Programmer Name:  NAVID 
  Release Date/Time:1395/07/28-11:44
  Version: 1.0
  Category:2
  Description: Sakhte toziE Poisson
  */
  ------------------------------------------------------------------------------
  power1     NUMBER;
  exponetial NUMBER;
  fact1      NUMBER;
  poisson    NUMBER;
  ------------------------------------------------------------------------------
--Calculating poisson_distribution
BEGIN
  power1    := power(m,n);
  exponetial:= exp(-m);
  fact1     := FNC_FACTORIAL(n);
  poisson   := ROUND(((power1*exponetial)/fact1),4);
  RETURN poisson;
END FNC_POISSON_DISTRIBUTION;
--------------------------------------------------------
--  DDL for Function FNC_FACTORIAL
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_FACTORIAL" (
    p_MyNum IN NUMBER )
  RETURN NUMBER
AS
--------------------------------------------------------------------------------
  /*
  Programmer Name:  NAVID
  Release Date/Time:1395/07/28-9:30
  Version: 1.0
  Category:2
  Description: mohasebeE factorial
  */
--------------------------------------------------------------------------------
BEGIN
--------------------------------------------------------------------------------
-- Start of Factorial Function
IF (p_MyNum = 1 OR p_MyNum=0) THEN -- Checking for last value to process of n-1
    RETURN 1;
ELSE
    RETURN(p_MyNum * FNC_FACTORIAL(p_MyNum-1)); -- Recursive
END IF;
--------------------------------------------------------------------------------  
END FNC_FACTORIAL;
--------------------------------------------------------
--  DDL for Function FNC_ESFAND
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_ESFAND" 
(
  INPAR_DATE IN DATE 
) RETURN DATE AS 
var_date date;
BEGIN
SELECT  distinct MAX (effdate) into var_date
FROM DADEKAVAN_DAY.loan
WHERE SUBSTR(TO_CHAR(effdate,'yyyy/mm/dd','nls_calendar=persian'),1,7) 
  =     substr(to_char(EXTRACT(YEAR FROM  to_date(to_char(INPAR_DATE,'yyyy/mm/dd','nls_calendar=persian'),'yyyy/mm/dd'))-1||'/12'),1,7);
 return var_date;
 END FNC_ESFAND;
--------------------------------------------------------
--  DDL for Function FNC_PRE_MONTH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_PRE_MONTH" 
(
  INPAR_DATE IN DATE 
) RETURN DATE AS 
var_date date;
BEGIN

if(lpad(substr(to_char(INPAR_DATE,'yyyy/mm/dd','nls_calendar=persian'),6,2)-1,2,0) =01)then
SELECT  distinct MAX (effdate)  into var_date
FROM DADEKAVAN_DAY.loan
WHERE SUBSTR(TO_CHAR(effdate,'yyyy/mm/dd','nls_calendar=persian'),1,7) 
  =    substr(to_char(EXTRACT(YEAR FROM  to_date(to_char(INPAR_DATE,'yyyy/mm/dd','nls_calendar=persian'),'yyyy/mm/dd'))||'/'||case when lpad(substr(to_char(INPAR_DATE ,'yyyy/mm/dd','nls_calendar=persian'),6,2)-1,2,0) = 01 then '12' else lpad(substr(to_char(INPAR_DATE,'yyyy/mm/dd','nls_calendar=persian'),6,2)-1,2,0) end),1,7);
else 
SELECT  distinct MAX (effdate)  into var_date
FROM DADEKAVAN_DAY.loan
WHERE SUBSTR(TO_CHAR(effdate,'yyyy/mm/dd','nls_calendar=persian'),1,7) 
  =    substr(to_char(EXTRACT(YEAR FROM  to_date(to_char(INPAR_DATE,'yyyy/mm/dd','nls_calendar=persian'),'yyyy/mm/dd')) ||'/'||case when lpad(substr(to_char(INPAR_DATE ,'yyyy/mm/dd','nls_calendar=persian'),6,2)-1,2,0) = 01 then '12' else lpad(substr(to_char(INPAR_DATE,'yyyy/mm/dd','nls_calendar=persian'),6,2)-1,2,0) end),1,7);
end if;
 return var_date;
 END FNC_pre_month;
--------------------------------------------------------
--  DDL for Function FNC_PRE_YEAR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_PRE_YEAR" 
(
  INPAR_DATE IN DATE 
) RETURN DATE AS 
var_date date;
BEGIN


SELECT  distinct MAX (effdate) into var_date
FROM DADEKAVAN_DAY.loan
WHERE SUBSTR(TO_CHAR(effdate,'yyyy/mm/dd','nls_calendar=persian'),1,7) 
  =     substr(to_char(EXTRACT(YEAR FROM  to_date(to_char(INPAR_DATE,'yyyy/mm/dd','nls_calendar=persian'),'yyyy/mm/dd'))-1||substr(to_char(sysdate-1,'yyyy/mm/dd','nls_calendar=persian'),5)),1,7);
 return var_date;
 END FNC_pre_year;
--------------------------------------------------------
--  DDL for Function FNC_RISK_MAP_CHART
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_RISK_MAP_CHART" 
(
  OSTAN IN NUMBER 
, SHAHR IN NUMBER 
, SHOBE IN NUMBER 
, pd_or_rr IN NUMBER
) RETURN VARCHAR2 AS 
ret_query VARCHAR2(2000);
BEGIN

if (pd_or_rr =1) then
if (ostan <>0 and shahr<>0 and shobe <>0) then
ret_query:=' select * from(select EDATE,round(avg(MAX_PD),5) as "AVG(MAX_PD)",ROUND(avg(AVG_PD),5) AS "AVG(AVG_PD)",ROUND(avg(MIN_PD),5) AS "AVG(MIN_PD)"  from TBL_CHANGE_IN_TIME where
  REF_SHOBE = '||SHOBE||'
  group by EDATE
        order by edate ) where ROWNUM<31'
;
elsif(ostan <>0 and shahr<>0 and shobe =0) then
ret_query:='select * from(select EDATE,round(avg(MAX_PD),5) as "AVG(MAX_PD)",ROUND(avg(AVG_PD),5) AS "AVG(AVG_PD)",ROUND(avg(MIN_PD),5) AS "AVG(MIN_PD)"  from TBL_CHANGE_IN_TIME where
  REF_SHAHR =  '||SHAHR||'
  group by EDATE
        order by edate  ) where ROWNUM<31';
elsif (ostan <>0 and shahr=0 and shobe =0)then
ret_query:='select * from(select EDATE,round(avg(MAX_PD),5) as "AVG(MAX_PD)",ROUND(avg(AVG_PD),5) AS "AVG(AVG_PD)",ROUND(avg(MIN_PD),5) AS "AVG(MIN_PD)"  from TBL_CHANGE_IN_TIME where
  REF_OSTAN =  '||ostan||'
  group by EDATE
        order by edate ) where ROWNUM<31';
end if;
else
if (ostan <>0 and shahr<>0 and shobe <>0) then
ret_query:='select * from(select EDATE,ROUND(avg(MAX_RR),5) AS "AVG(MAX_RR)" ,ROUND(avg(AVG_RR),5) AS "AVG(AVG_RR)",ROUND(avg(MIN_RR),5) AS "AVG(MIN_RR)" from TBL_CHANGE_IN_TIME where
  REF_SHOBE = '||SHOBE||'
  group by EDATE
        order by edate ) where ROWNUM<31'
;
elsif(ostan <>0 and shahr<>0 and shobe =0) then
ret_query:='select * from(select EDATE,ROUND(avg(MAX_RR),5) AS "AVG(MAX_RR)" ,ROUND(avg(AVG_RR),5) AS "AVG(AVG_RR)",ROUND(avg(MIN_RR),5) AS "AVG(MIN_RR)" from TBL_CHANGE_IN_TIME where
  REF_SHAHR =  '||SHAHR||'
  group by EDATE
        order by edate ) where ROWNUM<31';
elsif (ostan <>0 and shahr=0 and shobe =0)then
ret_query:='select * from(select EDATE,ROUND(avg(MAX_RR),5) AS "AVG(MAX_RR)" ,ROUND(avg(AVG_RR),5) AS "AVG(AVG_RR)",ROUND(avg(MIN_RR),5) AS "AVG(MIN_RR)" from TBL_CHANGE_IN_TIME where
  REF_OSTAN =  '||ostan||'
  group by EDATE
        order by edate ) where ROWNUM<31';
end if;
end if;
  RETURN ret_query;
END FNC_RISK_MAP_CHART;
--------------------------------------------------------
--  DDL for Function FNC_RISK_MAP_CHART_SYN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_RISK_MAP_CHART_SYN" 
(
  OSTAN IN NUMBER 
, SHAHR IN NUMBER 
, SHOBE IN NUMBER 
--, pd_or_rr IN NUMBER
) RETURN VARCHAR2 AS 
ret_query VARCHAR2(2000);
BEGIN


if (ostan <>0 and shahr<>0 and shobe <>0) then
ret_query:=' select * from(select EDATE,ROUND((AVG_PD),0) AS "AVG(AVG_PD)",ROUND((AVG_RR),0) AS "AVG(AVG_RR)" ,(sum_rwa) AS "SUM(SUM_RWA)" from TBL_CHANGE_IN_TIME where
  REF_SHOBE = '||SHOBE||'   order by edate  ) where ROWNUM<31'
;
elsif(ostan <>0 and shahr<>0 and shobe =0) then
ret_query:=' select * from(select  EDATE,avg(AVG_PD),avg(AVG_RR),sum(sum_rwa) from TBL_CHANGE_IN_TIME where
  REF_SHAHR =  '||SHAHR||'
    group by EDATE
      order by edate  ) where ROWNUM<31';
elsif (ostan <>0 and shahr=0 and shobe =0)then
ret_query:=' select * from(select  EDATE,avg(AVG_PD),avg(AVG_RR),sum(sum_rwa) from TBL_CHANGE_IN_TIME where
  REF_OSTAN =  '||ostan||'
  group by EDATE
    order by edate  ) where ROWNUM<31';
end if;
  RETURN ret_query;
END FNC_RISK_MAP_CHART_syn;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_DAILY_MAP_RWA
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_REPORT_DAILY_MAP_RWA" 
(
  INPAR_DATE IN VARCHAR2 
) RETURN VARCHAR2 AS 
var_query VARCHAR2(2000);
BEGIN
  var_query:=' select TCP.ID,
  TCP.NAM_OSTAN,
  round(TCP.RWA,0) as RWA from TBL_CREDIT_MAP tcp where TCP.EFFDATE ='''||INPAR_DATE||'''';
 RETURN var_query;
END FNC_REPORT_DAILY_MAP_RWA;
--------------------------------------------------------
--  DDL for Function FNC_CUSTOMER_PAGING
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_CUSTOMER_PAGING" 
(
  IN_NAME IN VARCHAR2 
, IN_FAMILY IN VARCHAR2 
, IN_NAT_REG_CODE IN VARCHAR2 
,in_type in varchar2
,in_gender in varchar2
,in_tel in varchar2
,in_mobile in varchar2
,in_postal_code in varchar2
,in_father_name in varchar2
,in_birth_place in varchar2
,in_grade in varchar2
, INPAR_LOAN IN NUMBER 
, INPAR_BRANCH IN NUMBER 
, INPAR_DEPOSIT IN NUMBER 
)
RETURN CLOB
AS 
--------------------------------------------------------------------------------
  /*
  Programmer Name:  Sobhan.Sadeghzade 
  Editor Name: 
  Release Date/Time:1396/03/22-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description: az in function baraye sakhte queriye select , baraye filter kardane moshtari ha bar asase shart haye entekhab shode tavassote karbar, estefade mishavad
  */
--------------------------------------------------------------------------------
pragma autonomous_transaction;

v_queri clob;
v_queri_temp clob;
v_where1 clob;
v_where2 clob;
v_where clob;
v_tables varchar2(32000);
v_columns varchar2(32000);
v_result clob;
v_count1 number;
v_count2 number;
BEGIN

-------------------------------------------------------------------------------------
--

EXECUTE IMMEDIATE ' truncate table TBL_CUSTOMER_SEARCH_ITEM';


--shart haye ke karbar entekhab mikonad dar in jadval insert mishavad
--agar har yek az profile haye loan ya branch ya deposit entekhab shavand ,sotune value meghdar migirad .
commit;
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (1,'NAM',IN_NAME,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (3,'COD_MELLI',IN_NAT_REG_CODE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (4,'P_LOAN',INPAR_LOAN,'l."customerId"=c.id');
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (5,'P_BRANCH',INPAR_BRANCH,'b."branchID"=c.REF_SHOBE');
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (7,'MAHIAT_MOSHTARI',IN_TYPE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (8,'JENSIAT',IN_GENDER,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (13,'SHAHR_TAVVALOD',IN_BIRTH_PLACE,null);
commit;
---------------------------------------------------------------------------------------

for i in (select * from TBL_CUSTOMER_SEARCH_ITEM where id in (4,5,6) and value is not null)
loop
  v_queri_temp:=FNC_PROFILE_CREATE_QUERY(i.value,1);
  
  
  if(v_queri_temp='select * from dual where 1>2') then 
  v_queri:=null;
  update TBL_CUSTOMER_SEARCH_ITEM set EXIST_PROFILE_DETAIL=0 where VALUE=i.VALUE;
  end if;
  commit;
--
   
  if(v_queri_temp is null  ) then
 
  if(i.column_type='P_LOAN')then
  v_queri:='('||v_queri_temp||') l ,';
  elsif(i.column_type='P_BRANCH')then
  v_queri:='('||v_queri_temp||') b ,';
  elsif(i.column_type='P_DEPOSIT')then
  v_queri:='('||v_queri_temp||') d ,';
  end if;--if(i.column_type='P_LOAN')then
 
  elsif(v_queri_temp is not null  and v_queri_temp!='select * from dual where 1>2') then --if(v_queri_temp is null) then
  if(i.column_type='P_LOAN')then
  v_queri:=v_queri||'('||v_queri_temp||') l ,';
  elsif(i.column_type='P_BRANCH')then
  v_queri:=v_queri||'('||v_queri_temp||') b ,';
  elsif(i.column_type='P_DEPOSIT')then
  v_queri:=v_queri||'('||v_queri_temp||') d ,';
  end if; --if(i.column_type='P_LOAN')then
 
  end if;
end loop;

-----------------------------------------------------------------------------------------------
select count (*) into v_count1 from TBL_CUSTOMER_SEARCH_ITEM where id in (1,2,3,7,8,9,10,11,12,13,14) and value is not null;  
select count (*) into v_count2 from TBL_CUSTOMER_SEARCH_ITEM where id in (4,5,6) and value is not null;  
------------------- where
if(v_count1!=0 and v_count2=0 or v_queri is null) then  --name,family,code
SELECT LISTAGG('c.'||column_type||' like '||''''||''''||'%'||value||'%'||''''||'''',' and ') WITHIN GROUP (ORDER BY id ) "where_condition" into v_where1
FROM TBL_CUSTOMER_SEARCH_ITEM where  id in (1,2,3,7,8,9,10,11,12,13,14) and value is not null ;
v_where:=v_where1;

elsif(v_count1=0 and v_count2!=0 and v_queri is not null) then --profil ha
SELECT LISTAGG(condition, ' and ') WITHIN GROUP (ORDER BY id ) "where_condition" into v_where2
FROM TBL_CUSTOMER_SEARCH_ITEM where  id in (4,5,6) and value is not null and  EXIST_PROFILE_DETAIL!=0;
v_where:=v_where2;

elsif(v_count1!=0 and v_count2!=0) then   
SELECT LISTAGG('c.'||column_type||' like '||''''||''''||'%'||value||'%'||''''||'''',' and ') WITHIN GROUP (ORDER BY id ) "where_condition" into v_where1
FROM TBL_CUSTOMER_SEARCH_ITEM where  id in (1,2,3,9,10,11,12,13,14) and value is not null;
SELECT LISTAGG(condition, ' and ') WITHIN GROUP (ORDER BY id ) "where_condition" into v_where2
FROM TBL_CUSTOMER_SEARCH_ITEM where  id in (4,5,6) and value is not null and  EXIST_PROFILE_DETAIL!=0;
v_where:=v_where1||' and '||v_where2;

end if;

---------------------------------------------------------------------------

if (v_queri is not null) then 
v_result:='select c.nam as "customerName",c.id as "id",c.MAHIAT_MOSHTARI as "type",c.JENSIAT as "GENDER"
,c.SHAHR_TAVVALOD as "birth_place" from '||v_queri||'tbl_customer c where '||v_where;
elsif( (v_queri is null or v_queri='(select * from dual where 1>2) l ,' ) and v_where is null) then
v_result:='select c.nam as "customerName",c.id as "id",c.MAHIAT_MOSHTARI as "type",c.JENSIAT as "GENDER",c.SHAHR_TAVVALOD as "birth_place"  from tbl_customer c ';
else
v_result:='select c.nam as "customerName",c.id as "id",c.MAHIAT_MOSHTARI as "type",c.JENSIAT as "GENDER",c.SHAHR_TAVVALOD as "birth_place"  from tbl_customer c where '||v_where;
end if;

select REPLACE(v_result, 'to_date(''', 'to_date(''') into v_result from dual;
select REPLACE(v_result, 'YYYY-MM-DD''', 'YYYY-MM-DD''') into v_result from dual;

return v_result;
  
END FNC_CUSTOMER_PAGING;
--------------------------------------------------------
--  DDL for Function FNC_CUSTOMER_SEARCHING_ENG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_CUSTOMER_SEARCHING_ENG" 
(
  IN_NAME IN VARCHAR2 
, IN_FAMILY IN VARCHAR2 
, IN_NAT_REG_CODE IN VARCHAR2 
,in_type in varchar2
,in_gender in varchar2
,in_tel in varchar2
,in_mobile in varchar2
,in_postal_code in varchar2
,in_father_name in varchar2
,in_birth_place in varchar2
,in_grade in varchar2
, INPAR_LOAN IN NUMBER 
, INPAR_BRANCH IN NUMBER 
, INPAR_DEPOSIT IN NUMBER 

)
RETURN clob
AS 
--------------------------------------------------------------------------------
  /*
  Programmer Name:  Sobhan.Sadeghzade 
  Editor Name: 
  Release Date/Time:1396/03/22-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description:
   az in function baraye sakhte queriye select , baraye filter kardane moshtari ha bar asase shart haye entekhab shode tavassote karbar, estefade mishavad
  */
--------------------------------------------------------------------------------
pragma autonomous_transaction;


v_queri clob;
v_queri_temp clob;
v_where1 clob;
v_where2 clob;
v_where clob;
v_tables clob;
v_columns clob;
v_result clob;
v_count1 number;
v_count2 number;

BEGIN

------------------------------------------------------------------
EXECUTE IMMEDIATE ' truncate table TBL_CUSTOMER_SEARCH_ITEM';
commit;

--3 satre avvad baraye filter kardan bar asase name,family va code melli  mibashad
--3 satre dovvom baraye filter kardan barr asase profile haye entekhab shode mibashasd
--har yek az 3 profile ba bayad ba jadvake CUSToMER join zade shavand. sotune condition jadval  TBL_CUSTOMER_SEARCH_ITEM be hamin manzur mibashad
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (1,'NAM',IN_NAME,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (3,'COD_MELLI',IN_NAT_REG_CODE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (4,'P_LOAN',INPAR_LOAN,'l."customerId"=c.id');
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (5,'P_BRANCH',INPAR_BRANCH,'b."branchID"=c.REF_SHOBE');
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (7,'MAHIAT_MOSHTARI',IN_TYPE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (8,'JENSIAT',IN_GENDER,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (13,'SHAHR_TAVVALOD',IN_BIRTH_PLACE,null);

commit;
--------------------------------------------------------------------------------------------------------------

--dar for zir agar meghdar 'value=null' bashad be maniye in mibashad ke dar filter(search) estefade nashode ast.
--meghdar value haman shomare profile entekhab shode mibashad 

for i in (select * from TBL_CUSTOMER_SEARCH_ITEM where id in (4,5,6) and value is not null)
loop
  v_queri_temp:=FNC_PROFILE_CREATE_QUERY(i.value,0);
 
    if(v_queri_temp='select * from dual where 1>2') then
  v_queri:=null;
  update TBL_CUSTOMER_SEARCH_ITEM set EXIST_PROFILE_DETAIL=0 where VALUE=i.VALUE;
  end if;
  commit; 
 
 
  if(v_queri_temp is null) then
 
  if(i.column_type='P_LOAN')then
  v_queri:='('||v_queri_temp||') l ,';
  elsif(i.column_type='P_BRANCH')then
  v_queri:='('||v_queri_temp||') b ,';
  elsif(i.column_type='P_DEPOSIT')then
  v_queri:='('||v_queri_temp||') d ,';
  end if;--if(i.column_type='P_LOAN')then
 
   elsif(v_queri_temp is not null  and v_queri_temp!='select * from dual where 1>2') then --if(v_queri_temp is null) then
  if(i.column_type='P_LOAN')then
  v_queri:=v_queri||'('||v_queri_temp||') l ,';
  elsif(i.column_type='P_BRANCH')then
  v_queri:=v_queri||'('||v_queri_temp||') b ,';
  elsif(i.column_type='P_DEPOSIT')then
  v_queri:=v_queri||'('||v_queri_temp||') d ,';
  end if; --if(i.column_type='P_LOAN')then
 
  end if;
end loop;

------------------------------------------------ 
select count (*) into v_count1 from TBL_CUSTOMER_SEARCH_ITEM where id in (1,2,3,7,8,9,10,11,12,13,14) and value is not null;  
select count (*) into v_count2 from TBL_CUSTOMER_SEARCH_ITEM where id in (4,5,6) and value is not null;  

if(v_count1!=0 and v_count2=0) then  --name,family,code
SELECT LISTAGG('c.'||column_type||' like '||''''||'%'||value||'%'||'''',' and ') WITHIN GROUP (ORDER BY id ) "where_condition" into v_where1
FROM TBL_CUSTOMER_SEARCH_ITEM where  id in (1,2,3,7,8,9,10,11,12,13,14) and value is not null;
v_where:=v_where1;

elsif(v_count1=0 and v_count2!=0 and v_queri is not null) then --profil ha 
SELECT LISTAGG(condition, ' and ') WITHIN GROUP (ORDER BY id ) "where_condition" into v_where2
FROM TBL_CUSTOMER_SEARCH_ITEM where  id in (4,5,6) and value is not null and  EXIST_PROFILE_DETAIL!=0;
v_where:=v_where2;


elsif(v_count1!=0 and v_count2!=0) then   

SELECT LISTAGG('c.'||column_type||' like '||''''||'%'||value||'%'||'''',' and ') WITHIN GROUP (ORDER BY id ) "where_condition" into v_where1
FROM TBL_CUSTOMER_SEARCH_ITEM where  id in (1,2,3,7,8,9,10,11,12,13,14) and value is not null;
SELECT LISTAGG(condition, ' and ') WITHIN GROUP (ORDER BY id ) "where_condition" into v_where2
FROM TBL_CUSTOMER_SEARCH_ITEM where  id in (4,5,6) and value is not null and  EXIST_PROFILE_DETAIL!=0;

v_where:=v_where1||' and '||v_where2;

end if;

----------------------------------------------------------------------
if (v_queri is not null) then 
v_result:='select c.nam as "customerName",c.id as "id",c.MAHIAT_MOSHTARI as "type",c.JENSIAT as "GENDER"
,c.SHAHR_TAVVALOD as "birth_place" from '||v_queri||'tbl_customer c where '||v_where;
elsif( (v_queri is null or v_queri='(select * from dual where 1>2) l ,' ) and v_where is null) then
v_result:='select c.nam as "customerName",c.id as "id",c.MAHIAT_MOSHTARI as "type",c.JENSIAT as "GENDER",c.SHAHR_TAVVALOD as "birth_place"  from tbl_customer c ';
else
v_result:='select c.nam as "customerName",c.id as "id",c.MAHIAT_MOSHTARI as "type",c.JENSIAT as "GENDER",c.SHAHR_TAVVALOD as "birth_place"  from tbl_customer c where '||v_where;
end if;

return v_result;
  
  
END FNC_CUSTOMER_SEARCHING_ENG;
--------------------------------------------------------
--  DDL for Function FNC_GET_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_GET_PROFILE" (
    INPAR_TYPE IN VARCHAR2 )
  RETURN VARCHAR2
AS
pragma autonomous_transaction;
--------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh
  Editor Name:
  Release Date/Time:1396/03/10-15:00
  Edit Name:
  Version: 1
  Category:
  Description:  in function koliE profile ha ra bar asase noE profile ha barmigardanad.
  */
--------------------------------------------------------------------------------  
BEGIN
 prc_is_empty();

if(upper(INPAR_TYPE)='TARIKH') then
return 'SELECT 
  ID as "profileId",
  NAME as "name",
  TYPE as "type",
  CREATE_DATE as "createDate",
  REF_USER as "user",
  DES as "des",
  UPDATE_DATE as "updateDate",
  REF_USER_UPDATE as "userUpdate",
  H_ID as "id",
  IS_EMPTY as "is_empty",
  report_cnt as "reportCount",
  PERIOD_DURATION as "PeriodDuration"
FROM TBL_TIMING_PROFILE 
where TYPE =2 and  status=1
and id in  (select distinct first_value(ID)over ( partition BY H_ID order by id DESC )FROM TBL_TIMING_PROFILE)
order by id desc';

else if(upper(INPAR_TYPE)='BAZEH') then
return 'SELECT 
  ID as "profileId",
  NAME as "name",
  TYPE as "type",
  CREATE_DATE as "createDate",
  REF_USER as "user",
  DES as "des",
  UPDATE_DATE as "updateDate",
  REF_USER_UPDATE as "userUpdate",
  H_ID as "id",
  IS_EMPTY as "is_empty",
  report_cnt as "reportCount",
  PERIOD_DURATION as "PeriodDuration"
FROM TBL_TIMING_PROFILE 
where TYPE =1 and  status=1
and id in  (select distinct first_value(ID)over ( partition BY H_ID order by id DESC )FROM TBL_TIMING_PROFILE) order by id desc';

else if(upper(INPAR_TYPE) in ('TBL_LEDGER', 'CUR_SENS','NIIM','NPL','CAR','COM')) then



return 'SELECT 
  ID as "profileId",
  NAME as "name",
  TYPE as "type",
  CREATE_DATE as "createDate",
  REF_USER as "user",
  DES as "des",
  H_ID as "id",
  IS_EMPTY as "is_empty",
  report_cnt as "reportCount"
FROM TBL_LEDGER_PROFILE 
where  status=1 and upper(TYPE) =upper('''||INPAR_TYPE||''')
and id in  (select distinct first_value(ID)over ( partition BY H_ID order by id DESC )FROM TBL_LEDGER_PROFILE) order by id desc';


else if(upper(inpar_type)='ALL') then
return 'SELECT 
  ID as "profileId",
  NAME as "name",
  TYPE as "type",
  CREATE_DATE as "createDate",
  REF_USER as "user",
  DES as "des",
  H_ID as "id",
  IS_EMPTY as "is_empty",
  report_cnt as "reportCount"
FROM TBL_LEDGER_PROFILE 
where  status=1 
and id in  (select distinct first_value(ID)over ( partition BY H_ID order by id DESC )FROM TBL_LEDGER_PROFILE) order by id desc';

else
  RETURN '
SELECT 
  ID as "profileId",
  NAME as "name",
  TYPE as "type",
  CREATE_DATE as "createDate",
  REF_USER as "user",
  DES as "des",
  UPDATE_DATE as "updateDate",
  REF_USER_UPDATE as "userUpdate",
  H_ID as "id",
  IS_EMPTY as "is_empty",
  item_cnt as "itemCount",
  report_cnt as "reportCount"
FROM TBL_PROFILE 
where   status=1 AND upper(TYPE) =upper('''||INPAR_TYPE||''')
and id in  (select distinct first_value(ID)over ( partition BY H_ID order by id DESC )FROM TBL_PROFILE)
       order by id desc ' ;
end if;
end if;
end if;
end if;

END FNC_GET_PROFILE;
--------------------------------------------------------
--  DDL for Function FNC_GET_QUERY_RESULT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_GET_QUERY_RESULT" (
    inpar_type IN VARCHAR2 ,
    inpar_noe IN VARCHAR2) -- if inpar_noe=1 then date , if 2 then rate, if 3 then name  tashilat
  RETURN VARCHAR2
AS
--------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh
  Editor Name:
  Release Date/Time:1396/03/16-15:00
  Edit Name:
  Version: 1
  Category:
  Description: in Function baraE bargardandane Item haE profile ha mibashad.ke 
               vorodi inpar_type, noE profile ra moshakhas mikonad. dar profile
               haE seporde va tashilat be dalile inke az 3 ghesmate(mablagh-tarikh
               / nerkh arz / noE) tashkil shode ast in func yek vorodi inpar_no
               ham migirad baraE moshkhas shodan yeki az in 3 ghesmate seporde ya
               tashilat.
  */
--------------------------------------------------------------------------------  
BEGIN
  IF (upper(inpar_type)='TBL_CURRENCY') THEN
      RETURN 'SELECT id as "id", name_arz as "curName", arz as "swiftCode" FROM tbl_arz ';
  ELSE
    IF(upper(inpar_type)='TBL_BRANCH' and upper(inpar_noe)='BRANCH') THEN
      RETURN 'SELECT p.nam "provinceName",                                            
              c.nam "cityName",                                            
              p.id "provinceId",                                            
              c.id "cityId",                                            
              s.NAM "label",                                            
              s.ID "id",
              ''brn_id'' "type"
              FROM TBL_BRANCH s                                          
              LEFT OUTER JOIN TBL_shahr c                                          
              ON s.cod_shahr = c.id                                          
              LEFT OUTER JOIN TBL_ostan p                                          
              ON p.ID = c.ostan_id';
  Else
    IF(upper(inpar_type)='TBL_BRANCH' and upper(inpar_noe)='CITY')then
    return '   SELECT distinct(bts.id) "id", bts.nam "label", bto.id "provinceId", ''cod_shahr'' "type"
          FROM TBL_shahr bts, TBL_ostan bto,TBL_BRANCH bts1 
          WHERE bts.ostan_id = bto.id and bts1.cod_shahr = bts.id ORDER BY "label"';
  Else
    IF(upper(inpar_type)='TBL_BRANCH' and upper(inpar_noe)='STATE') then
    return ' SELECT distinct(bto.id) "id", bto.nam "label",''cod_ostan'' "type"
               FROM TBL_shahr bts, TBL_ostan bto, TBL_BRANCH bts1 
              where  bts.ostan_id = bto.id and bts1.cod_shahr= bts.id ORDER BY "label"';
  Else  
    IF(upper(inpar_type)='TBL_LOAN' AND  upper(inpar_noe)='DATE') then             
      RETURN 'SELECT ID as "loanId",
             cod_noe_tashilat as "loanType",
              tarikh_tashkil as "openDate",
              mablagh_mosavvab as "mablaghMosavab",
              mande_kol_vam as "mandeJari",
              mande_sarresid_gozashte as "mandeSarresidGozashte",
              mande_moavvagh as "mandeMoavagh",
              mande_mashkukolvosul as "mandeMashkookolVosool"
              FROM CREDIT_RISK.TBL_LOAN' ;           
  ELSE
    IF (upper(inpar_type)='TBL_LOAN' AND  upper(inpar_noe)='RATE') THEN
      --RETURN 'SELECT ref_rate as "id", RATE as "name", TYPE as "type" FROM TBL_RATE where upper(TYPE) = ''TBL_LOAN''';
      RETURN 'SELECT distinct RATE as "id",RATE as "name" FROM tbl_loan where rate is not null order by rate';
  ELSE
    IF(upper(inpar_type)='TBL_LOAN' AND upper(inpar_noe)='CODE') THEN
      RETURN 'SELECT distinct COD_NOE_TASHILAT as "code" , NAM_NOE_TASHILAT as "name",COD_NOE_TASHILAT as "id" FROM TBL_LOAN' ;
  Else
    IF (upper(inpar_type)='TBL_DEPOSIT' AND  upper(inpar_noe)='DATE') then
      RETURN 'SELECT 
              DEP_ID as "depId",
              REF_DEPOSIT_TYPE as "depType",
              BALANCE as "mande",
              OPENING_DATE as "openDate",
              DUE_DATE as "endDate"
              FROM AKIN.TBL_DEPOSIT' ;
  ELSE
    IF (upper(inpar_type)='TBL_DEPOSIT' AND  upper(inpar_noe)='RATE') THEN
      RETURN 'SELECT ref_rate as "id", RATE as "name", TYPE as "type" FROM TBL_RATE where TYPE = ''TBL_DEPOSIT''';
  ELSE
    IF(upper(inpar_type)='TBL_DEPOSIT' AND  upper(inpar_noe)='CODE') THEN
      RETURN 'SELECT ID as "code", NAME as "name", dep.REF_DEPOSIT_TYPE as "id" FROM TBL_DEPOSIT_TYPE dep' ;
  Else
    IF(upper(inpar_type)='TBL_CUSTOMER') THEN
      RETURN 'SELECT id as "customerId",
              nam as "customerName",
              cod_meli as "meliCode",
              ADDRESS as "address",
              TARIKH_TAVVALOD as "birthdate",
              JENSIAT as "gender",
              REF_SHOBE as "branchId"
              FROM TBL_CUSTOMER';
  Else
    IF(upper(inpar_type)='TIMING' AND  upper(inpar_noe)='TARIKH') THEN
    return    'SELECT det.ID as "id",
              det.REF_TIMING_PROFILE as "timing_profile_id",
              det.PERIOD_NAME as "name",
              det.PERIOD_START as "startDate",
              det.PERIOD_END as "endDate",
              det.PERIOD_COLOR as "color"
              FROM TBL_TIMING_PROFILE_DETAIL det
               order by det.id';
  Else
    IF (upper(inpar_type)='TIMING' AND  upper(inpar_noe)='BAZEH') THEN
    return 'SELECT det.ID as "id",
            det.PERIOD_NAME as "name",
            det.REF_TIMING_PROFILE as "timing_profile_id",
            det.PERIOD_DATE as "periodDate",
            det.PERIOD_COLOR as "color"
            FROM TBL_TIMING_PROFILE_DETAIL det
            order by det.id';
            
            
             Else  
    IF(upper(inpar_type)='TBL_GUARANTEE' AND  upper(inpar_noe)='DATE') then             
      RETURN 'SELECT ID as "guaranteeId",
             tarikh_sodur as "tarikhSodur",
              tarikh_sarresid as "tarikhSarresid",
              mablagh as "mablaghZemanat",
              emkan_tamdid as "emkanTamdid"
              FROM CREDIT_RISK.TBL_GUARANTEE' ;           

  ELSE
    IF(upper(inpar_type)='TBL_GUARANTEE' AND upper(inpar_noe)='CODE') THEN
      RETURN 'SELECT distinct cod_noe_zemanat as "code", NAM_noe_zemanat as "name" FROM CREDIT_RISK.TBL_GUARANTEE ' ;
           
           
           
                  Else  
    IF(upper(inpar_type)='TBL_COLLATERAL' AND  upper(inpar_noe)='DATE') then             
      RETURN 'SELECT ID as "collateralID",
             TARIKH_TARHIN as "tarikhTarhin",
              ARZESH_TARHIN_SHODE as "arzeshTarhin",
              ARZESH_VASIGHE as "arzeshVasighe",
              TARIKH_SARRESID as "tarikhSarresid",
              ARZESH_ARZYABI_SHODE as "arzeshArzyabiShode",
              ZARIB_NAGHDINEGI as "zaribNaghdShavandegi"
              FROM CREDIT_RISK.TBL_COLLATERAL where rownum <12 ' ;           

  ELSE
    IF(upper(inpar_type)='TBL_COLLATERAL' AND upper(inpar_noe)='CODE') THEN
      RETURN 'SELECT distinct cod_noe_vasighe as "code", NAM_noe_vasighe as "name" FROM CREDIT_RISK.TBL_COLLATERAL ' ; 
            
    
    END IF;
    END IF;
    END IF;
    END IF;
    END IF;
    END IF;
    END IF;
    END IF;
    END IF;
    END IF;
    END IF;
    End if;
    End if;
    End if;
    END IF;
    END IF;
  END IF;
  --SELECT distinct ID as "code", NAME as "name", lo.REF_LOAN_TYPE as "id" FROM TBL_LOAN_TYPE lo
END fnc_get_query_result;
--------------------------------------------------------
--  DDL for Function FNC_PAGE_NUMBER_CUSTOMER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_PAGE_NUMBER_CUSTOMER" 
--------------------------------------------------------------------------------
    /*
  Programmer Name: Navid Sedigh
  Release Date/Time:1396/06/1 : 10:00
  Version: 1.0
  Category:2
  Description: YEK QUERY V PAGE-SIZE V PAGE-NUMBER MIGIRE VA DADEHASHO PAS MIDE
  */
--------------------------------------------------------------------------------  
(
  INAPR_PAGE_SIZE IN NUMBER ,
 
IN_NAME IN VARCHAR2 
, IN_FAMILY IN VARCHAR2 
, IN_NAT_REG_CODE IN VARCHAR2 
,in_type in varchar2
,in_gender in varchar2
,in_tel in varchar2
,in_mobile in varchar2
,in_postal_code in varchar2
,in_father_name in varchar2
,in_birth_place in varchar2
,in_grade in varchar2
, INPAR_LOAN IN NUMBER 
, INPAR_BRANCH IN NUMBER 
, INPAR_DEPOSIT IN NUMBER 
) RETURN number AS 


 LOC_QUERY clob;
 LOC_CNT number;
 var clob;
 
BEGIN

  -- var:=to_char(var);
    
    select FNC_CUSTOMER_SEARCHING_ENG(IN_NAME ,IN_FAMILY , IN_NAT_REG_CODE ,in_type,in_gender,in_tel,in_mobile,in_postal_code ,in_father_name,in_birth_place,in_grade,INPAR_LOAN,INPAR_BRANCH,INPAR_DEPOSIT) into var from dual ;
    

 -- LOC_QUERY :='SELECT FLOOR((COUNT(*)/'|| INAPR_PAGE_SIZE ||')+1)  FROM ('||INPAR_QUERY||')';
  LOC_QUERY :='select count(*) from('||var||')';
  EXECUTE IMMEDIATE LOC_QUERY INTO LOC_CNT;
  RETURN LOC_CNT;
END FNC_PAGE_NUMBER_customer;
--------------------------------------------------------
--  DDL for Function FNC_PAGE_NUMBER2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_PAGE_NUMBER2" 
--------------------------------------------------------------------------------
    /*
  Programmer Name: Navid Sedigh
  Release Date/Time:1396/04/1
  Version: 1.0
  Category:2
  Description: YEK ID PROFILE V PAGE-SIZE V PAGE-NUMBER MIGIRE VA DADEHASHO PAS MIDE
  */
--------------------------------------------------------------------------------  
(
  INAPR_PAGE_SIZE IN NUMBER ,
 inpar_id IN number 
 
) RETURN number AS 


 LOC_QUERY clob;
 LOC_CNT number;
 var clob;
 
BEGIN

  -- var:=to_char(var);
    
    select FNC_PROFILE_CREATE_QUERY(inpar_id,0) into var from dual;
    

 -- LOC_QUERY :='SELECT FLOOR((COUNT(*)/'|| INAPR_PAGE_SIZE ||')+1)  FROM ('||INPAR_QUERY||')';
  LOC_QUERY :='select count(*) from('||var||')';
  EXECUTE IMMEDIATE LOC_QUERY INTO LOC_CNT;
  RETURN LOC_CNT;
END FNC_PAGE_NUMBER2;
--------------------------------------------------------
--  DDL for Function FNC_PAGING_QUERY_CUSTOMER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_PAGING_QUERY_CUSTOMER" 
--------------------------------------------------------------------------------
  /*
  Programmer Name: Navid Sedigh
  Release Date/Time:1396/06/1 : 16:00
  Version: 1.0
  Category:2
  Description: TAMAME ETELAATI KE BARAE FILTER MOSHTARI LAZEM DARAD
               RA MIGIRAD V YEK QUERY SELECT TAVASOTE FUNCTION ZIR
               MISAZAD:
               FNC_PAGE_NUMBER_customer(INPAR_PAGE_SIZE,IN_NAME,IN_FAMILY,IN_NAT_REG_CODE,INPAR_LOAN,INPAR_BRANCH,INPAR_DEPOSIT)
               VA DADEHASHO KE NATIJE EJRAE SELECT FOGH AST RA PAS MIDE.
  */
--------------------------------------------------------------------------------  
(
  INPAR_PAGE_SIZE IN NUMBER 
, INPAR_PAGE_NUMBER IN NUMBER 
,IN_NAME IN VARCHAR2 
, IN_FAMILY IN VARCHAR2 
, IN_NAT_REG_CODE IN VARCHAR2 
,in_type in varchar2
,in_gender in varchar2
,in_tel in varchar2
,in_mobile in varchar2
,in_postal_code in varchar2
,in_father_name in varchar2
,in_birth_place in varchar2
,in_grade in varchar2
, INPAR_LOAN IN NUMBER 
, INPAR_BRANCH IN NUMBER 
, INPAR_DEPOSIT IN NUMBER 
) RETURN clob AS 
var clob;
  LOC_QUERY clob; 
  total_number number:=FNC_PAGE_NUMBER_customer(INPAR_PAGE_SIZE,IN_NAME ,IN_FAMILY , IN_NAT_REG_CODE ,in_type,in_gender,in_tel,in_mobile,in_postal_code ,in_father_name,in_birth_place,in_grade,INPAR_LOAN,INPAR_BRANCH,INPAR_DEPOSIT) ;
  LOC_LOW NUMBER := (INPAR_PAGE_NUMBER-1)*INPAR_PAGE_SIZE+1; 
  LOC_UP NUMBER := INPAR_PAGE_NUMBER*INPAR_PAGE_SIZE; 
BEGIN

  if (LOC_UP>total_number) then 
  LOC_UP:=total_number;
  end if;

  select FNC_CUSTOMER_SEARCHING_ENG (IN_NAME ,IN_FAMILY , IN_NAT_REG_CODE ,in_type,in_gender,in_tel,in_mobile,in_postal_code ,in_father_name,in_birth_place,in_grade,INPAR_LOAN,INPAR_BRANCH,INPAR_DEPOSIT) into var from dual ;


  LOC_QUERY := 'SELECT * FROM (
                              SELECT ROWNUM "رديف", t.*
                              FROM (' || var ||')T)
                              WHERE  "رديف" BETWEEN ' || LOC_LOW || ' AND ' ||LOC_UP;
 RETURN LOC_QUERY;
END FNC_PAGING_QUERY_customer;
--------------------------------------------------------
--  DDL for Function FNC_PAGING_QUERY2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_PAGING_QUERY2" 
--------------------------------------------------------------------------------
  /*
  Programmer Name: Navid Sedigh
  Release Date/Time:1396/04/1
  Version: 1.0
  Category:2
  Description: YEK QUERY V PAGE-SIZE V PAGE-NUMBER MIGIRE VA DADEHASHO PAS MIDE
  */
--------------------------------------------------------------------------------  
(
  INPAR_PAGE_SIZE IN NUMBER 
, INPAR_PAGE_NUMBER IN NUMBER 
, INPAR_QUERY IN number
) RETURN clob AS 
var clob;
  LOC_QUERY clob; 
  total_number number:=FNC_PAGE_NUMBER2(INPAR_PAGE_SIZE,INPAR_QUERY) ;
  LOC_LOW NUMBER := (INPAR_PAGE_NUMBER-1)*INPAR_PAGE_SIZE+1; 
  LOC_UP NUMBER := INPAR_PAGE_NUMBER*INPAR_PAGE_SIZE; 
BEGIN

  if (LOC_UP>total_number) then 
  LOC_UP:=total_number;
  end if;

   select FNC_PROFILE_CREATE_QUERY(INPAR_QUERY,0) into var from dual;


  LOC_QUERY := 'SELECT * FROM (
                              SELECT ROWNUM "رديف", t.*
                              FROM (' || var ||')T)
                              WHERE  "رديف" BETWEEN ' || LOC_LOW || ' AND ' ||LOC_UP;
 RETURN LOC_QUERY;
END FNC_PAGING_QUERY2;
--------------------------------------------------------
--  DDL for Function FNC_PRIVATE_CREATE_QUERY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_PRIVATE_CREATE_QUERY" (
    INPAR_TYPE IN varchar2,
    INPAR_ID IN NUMBER)
    RETURN clob
AS
    iidd number;
--------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh
  Editor Name: 
  Release Date/Time:1396/02/21-15:00
  Edit Name: 1395/05/27-18:00
  Version: 1.1
  Category:2
  Description: function Query saz baraE report ha.
  */
--------------------------------------------------------------------------------
  v_name_input_tbl VARCHAR2(4000);
  where_condition  clob;
  v_count number;
  var clob;
  BEGIN
  
  --select max(id) into  iidd from tbl_profile where h_id = INPAR_ID;

  
  if(upper(INPAR_TYPE)is not null and INPAR_ID is not null) then
  SELECT type INTO v_name_input_tbl FROM credit_risk.tbl_profile WHERE id=INPAR_ID;
  select count(*) into v_count from credit_risk.tbl_profile_detail where ref_profile=INPAR_ID;
--------------------------------------------------------------------------------
  
  
--  SELECT LISTAGG('('||SRC_COLUMN||REPLACE(CONDITION,'#',' or '|| SRC_COLUMN), ') and ') WITHIN GROUP (ORDER BY id desc) "where_condition" into  where_condition
--  FROM tbl_profile_detail
--    WHERE ref_profile = inpar_id;


--================================== shakhte where baraE query ba tavajoh be jadvale tbl_profile_detail dar ghalebe XML
SELECT rtrim(xmlagg(XMLELEMENT(e,'('
  ||SRC_COLUMN
  ||REPLACE(CONDITION,'#',' or '
  || SRC_COLUMN), ') and ').EXTRACT('//text()')
                     ).GetClobVal(),',') "where_condition" into  where_condition
  FROM credit_risk.tbl_profile_detail
WHERE ref_profile = INPAR_ID;


select substr(where_condition,0,LENGTH(where_condition)-6) into where_condition from dual;
--=================================

    --=========================== eslahe khoroji XML
     select REPLACE(where_condition, ';', '>') into where_condition from dual;
    select REPLACE(where_condition, ';', '''') into where_condition from dual;
    select REPLACE(where_condition, ';', '<') into where_condition from dual;
    --============================

  
  where_condition:=where_condition||')';
--------------------------------------------------------------------------------  
  
  if(v_name_input_tbl='TBL_DEPOSIT') then
    if(v_count!=0) then
    var:='select 
    DEP_ID as "depositId"
    from TBL_DEPOSIT dep,tbl_profile where '||'('||where_condition ||')'||'and credit_risk.tbl_profile.id = '||INPAR_ID;
    else
    var:='select 
    DEP_ID as "depositId"
    from TBL_DEPOSIT,.tbl_profile where tbl_profile.id = '||INPAR_ID;
  end if;
--------------------------------------------------------------------------------
  elsif (v_name_input_tbl='TBL_LOAN') then
    if(v_count!=0) then
    
    var:='select 
    lo.id as "loanId" 
    from TBL_LOAN lo ,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||INPAR_ID;
    else
    var:='select 
    lo.id as "loanId"
    from TBL_LOAN lo,tbl_profile where  tbl_profile.id = '||INPAR_ID;
  end if;
--------------------------------------------------------------------------------



  elsif (v_name_input_tbl='TBL_BRANCH' ) then
    if(v_count!=0) then
    select REPLACE(where_condition, 'and', 'or') into where_condition from dual;
    var:='select 
    br.id as "branchId"
    from credit_risk.TBL_BRANCH br,credit_risk.tbl_profile where '||'('||where_condition ||')'||'and credit_risk.tbl_profile.id = '||INPAR_ID;
    else
    var:='select 
    br.id as "branchId"
    from credit_risk.TBL_BRANCH br,credit_risk.tbl_profile where credit_risk.tbl_profile.id = '||INPAR_ID; 
  end if;
--------------------------------------------------------------------------------
  elsif (v_name_input_tbl='TBL_CITY') then
    if(v_count!=0) then
    var:='select
    cty.id as "cityId"
    from credit_risk.TBL_shahr cty,credit_risk.tbl_profile where '||'('||where_condition ||')'||'and credit_risk.tbl_profile.id = '||INPAR_ID;
    else
    var:='select
    cty.id as "cityId",
    from credit_risk.TBL_shahr cty,credit_risk.tbl_profile where credit_risk.tbl_profile.id = '||INPAR_ID; 
  end if;
--------------------------------------------------------------------------------
  elsif (v_name_input_tbl='TBL_CURRENCY') then
    if(v_count!=0) then
    var:='select
    cur.id as "currencyID"
    from credit_risk.TBL_arz cur,credit_risk.tbl_profile where '||'('||where_condition ||')'||'and credit_risk.tbl_profile.id = '||INPAR_ID;
    else
    var:='select
    cur.id as "currencyId"
    from credit_risk.TBL_arz cur,credit_risk.tbl_profile where credit_risk.tbl_profile.id = '||INPAR_ID;
  end if;
--------------------------------------------------------------------------------
  elsif (v_name_input_tbl='TBL_CUSTOMER') then
    if(v_count!=0) then
    var:='select
    cu.id as "customerId"
    from credit_risk.TBL_CUSTOMER cu,credit_risk.tbl_profile where '||'('||where_condition ||')'||'and credit_risk.tbl_profile.id = '||INPAR_ID; 
    else
    var:='select
    cu.id as "customerId"
    from credit_risk.TBL_CUSTOMER cu,credit_risk.tbl_profile where credit_risk.tbl_profile.id = '||INPAR_ID; 
  end if;
--------------------------------------------------------------------------------

elsif (v_name_input_tbl='TBL_COLLATERAL') then
    if(v_count!=0) then
    
    var:='select 
    lo.id as "collateralId" 
    from TBL_COLLATERAL lo ,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||INPAR_ID;
    else
    var:='select 
    lo.id as "collateralId"
    from TBL_COLLATERAL lo,tbl_profile where  tbl_profile.id = '||INPAR_ID;
  end if;


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

elsif (v_name_input_tbl='TBL_GUARANTEE') then
    if(v_count!=0) then
    
    var:='select 
    lo.id as "guaranteeId" 
    from TBL_GUARANTEE lo ,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||INPAR_ID;
    else
    var:='select 
    lo.id as "guaranteeId"
    from TBL_GUARANTEE lo,tbl_profile where  tbl_profile.id = '||INPAR_ID;
  end if;


--------------------------------------------------------------------------------
  end if;
--------------------------------------------------------------------------------
  else
  
  if(upper(inpar_type) = 'TBL_LOAN') then
    var:='select 
    id as "loanId"
    from TBL_LOAN';
    
  end if;
  
  if(upper(inpar_type) = 'TBL_DEPOSIT') then
    var:='select 
    DEP_ID as "depositId"
    from TBL_DEPOSIT';
  
  end if;
  
  
  
   if(upper(inpar_type) = 'TBL_COLLATERAL') then
    var:='select 
    id as "collateralId"
    from TBL_COLLATERAL';
  
  end if;
  
  
  
   if(upper(inpar_type) = 'TBL_GUARANTEE') then
    var:='select 
    id as "guaranteeId"
    from TBL_GUARANTEE';
  
  end if;
  
  
  
  if(upper(inpar_type) = 'TBL_BRANCH') then
    var:='select 
    id as "branchId"
    from credit_risk.TBL_BRANCH';
  
  end if;
  
  if(upper(inpar_type) = 'TBL_CITY') then
    var:='select
    id as "cityId",
    from credit_risk.TBL_shahr';
  
  end if;
  
  if(upper(inpar_type) = 'TBL_CURRENCY') then
    var:='select
   4 as "currencyId"
    from credit_risk.TBL_arz';
  
  end if;
  
  if(upper(inpar_type) = 'TBL_CUSTOMER') then
    var:='select
    id as "customerId"
    from credit_risk.TBL_CUSTOMER';
  
  end if;
  end if;
RETURN var;
  
--------------------------------------------------------------------------------
END FNC_PRIVATE_CREATE_QUERY;
--------------------------------------------------------
--  DDL for Function FNC_PROFILE_WHERE_CONDITION
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_PROFILE_WHERE_CONDITION" (
    INPAR_ID IN NUMBER)
  RETURN VARCHAR2
AS
  v_name_input_tbl VARCHAR2(4000);
  where_condition  clob;
  v_count number;
  iidd number;
  outpar_id number;
  var clob;
BEGIN
--------------------------------------------------------------------------------
  /*
  Programmer Name: NAVID 
  Editor Name: 
  Release Date/Time:1396/03/21-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description:
  az in fnc baraye sakhte ghesmate  "where" queri saz  estefade mishavad
  */
--------------------------------------------------------------------------------
SELECT MAX(id)
INTO iidd
FROM TBL_PROFILE
WHERE h_id = inpar_id
GROUP BY name ; 

  SELECT type INTO v_name_input_tbl FROM tbl_profile WHERE id=iidd;
SELECT COUNT(*) INTO v_count FROM tbl_profile_detail WHERE ref_profile=iidd; 
  
 IF(v_count=1) THEN
  SELECT SRC_COLUMN
    ||' '
    || CONDITION
  INTO where_condition
  FROM tbl_profile_detail
  WHERE ref_profile = iidd;
  
  else

SELECT LISTAGG(SRC_COLUMN
  ||CONDITION, '; ') WITHIN GROUP (
ORDER BY id DESC) "where_condition"
INTO where_condition
FROM tbl_profile_detail
WHERE ref_profile = iidd;
  
    end if;
    
-- select max(id) into outpar_id FROM tbl_profile_detail
--WHERE ref_profile = iidd;   

  RETURN  where_condition;
END FNC_PROFILE_WHERE_CONDITION;
--------------------------------------------------------
--  DDL for Function FNC_TOP_CUSTOMER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_TOP_CUSTOMER" (
    inpar_number IN NUMBER )
  RETURN VARCHAR2
AS
  --------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh
  Editor Name:
  Release Date/Time:1396/03/21-15:00
  Edit Name:
  Version: 1
  Category:2
  Description: dar profile moshtari, be tedade addade entekhabi tavasote karbar
               moshtariyani ke bishtarin mande seporde ra darand bar migardanad.
  */
  --------------------------------------------------------------------------------
BEGIN
  RETURN 'SELECT  NAME as "customerName", FAMILY as "customerFamily",CUS_ID as "id",BALANCE  as "amount"  
          FROM(  
            SELECT NAME , FAMILY , CUS_ID ,sum(lo.BALANCE)  as BALANCE 
          FROM  
          TBL_CUSTOMER cus,AKIN.TBL_DEPOSIT lo  
          where lo.REF_CUSTOMER = cus.cus_id  
          group by CUS_ID,FAMILY,NAME
          ORDER BY sum(lo.BALANCE) desc    
          )    
          WHERE ROWNUM <='||inpar_number||' ORDER BY  "amount" desc';
END fnc_top_customer;
--------------------------------------------------------
--  DDL for Function FNC_FARSIVALIDATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_FARSIVALIDATE" (str nvarchar2)
  RETURN nvarchar2
is
  tempStr nvarchar2(1000);
begin

     tempStr := str;

     -- Ya Validation: "\064a" , "\06cc"
   tempStr := replace(tempStr, UNISTR('\064a'), UNISTR('\06cc'));
    -- tempStr := UNISTR(replace(asciistr(tempStr), '\064A', '\06CC'));

     -- Kaf Validation: "\06a9" , "\0643"
     tempStr := replace(tempStr, UNISTR('\0643'), UNISTR('\06a9'));

     return tempStr;

end fnc_FarsiValidate;
--------------------------------------------------------
--  DDL for Function FNC_GET_REPORT_LIST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_GET_REPORT_LIST" 
(
  
  inpar_TYPE IN VARCHAR2 
  
) RETURN VARCHAR2 AS 
outpar_var varchar2(4000);
v_max_id number;
BEGIN
   --SELECT MAX(id) INTO v_max_id FROM tbl_report WHERE h_id= INPAR_ID;
 
  outpar_var:='select max(id) as "id",name as "name",max(des) as "des", max(ref_user) as "createdBy",max(create_date) as "created" from tbl_report where STATUS=1
  and upper(type)='||''''||upper(inpar_TYPE)||''''||' group by name';


  return outpar_var;
  
END FNC_GET_REPORT_LIST ;
--------------------------------------------------------
--  DDL for Function FNC_GET_REPORT_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_GET_REPORT_PROFILE" (
    INPAR_ID IN NUMBER )
  RETURN VARCHAR2
AS
  INPAR_OUT VARCHAR2(4000);
  v_max_id  NUMBER;
BEGIN
  --SELECT h_id INTO v_max_id FROM tbl_report WHERE id= INPAR_ID;
  INPAR_OUT:='select 
ID                  as "id",
NAME                as "name",
DES                 as "des",
CREATE_DATE         as "createDate",
REF_USER            as "user",
STATUS              as "status",
(select h_id from tbl_profile where id = REF_LOan)            as "loanProfileId",
(select h_id from tbl_profile where id = REF_BRANCH)          as "branchProfileId",
(select h_id from tbl_profile where id = REF_CUSTOMER)        as "customerProfileId",
(select h_id from tbl_profile where id = REF_COLLATERAL)      as "collateralProfileId",
(select h_id from tbl_profile where id = REF_GUARANTEE)       as "guaranteeProfileId",
VERSION             as "version",
TYPE                as "type"
from tbl_report where id='||INPAR_ID;
  RETURN INPAR_OUT;
END FNC_GET_REPORT_PROFILE;
--------------------------------------------------------
--  DDL for Function TEEEEEST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."TEEEEEST" return clob as 

where_condition clob;
begin


  with tmp as(
 SELECT rtrim(xmlagg(XMLELEMENT(e,text,' ')
    .EXTRACT('//text()')
    ).GetClobVal(),',') wc  
    FROM user_source
    where type = 'PROCEDURE'
    group by name)
    
    
    select   REPLACE(REPLACE(REPLACE(wc, '&gt;', '>'), '&apos;', ''''), '&lt;', '<') from tmp;
    
      
    
      

    
end teeeeest;
--------------------------------------------------------
--  DDL for Function FNC_LOAN_BASE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "CREDIT_RISK"."FNC_LOAN_BASE" ( inpar_report IN NUMBER ) RETURN VARCHAR2 AS

var_loan number;
var_GUARANTEE number;
var_COLLATERAL number;
var_BRANCH number;
var_customer number;

 VAR_QUERY   CLOB;
BEGIN

select ref_loan into var_loan from tbl_report where id = inpar_report;
select REF_GUARANTEE into var_GUARANTEE from tbl_report where id = inpar_report;
select REF_COLLATERAL into var_COLLATERAL from tbl_report where id = inpar_report;
select REF_BRANCH into var_BRANCH from tbl_report where id = inpar_report;
select REF_CUSTOMER into var_customer from tbl_report where id = inpar_report;




select '

select 
lo.cod_noe_tashilat as "کد نوع تسهيلات",
lo.nam_noe_tashilat as "نام نوع تسهيلات",
MABLAGH_MOSAVVAB as "مبلغ مصوب",
lo.mande_asl_vam as "مانده اصل وام",
lo.mande_kol_vam as "مانده کل وام",
lo.MANDE_SARRESID_GOZASHTE as "مانده سررسيد گذشته",
lo.MANDE_MASHKUKOLVOSUL as "مانده مشکوک الوصول",
lo.MANDE_MOAVVAGH as "مانده معوق",
lo.TARIKH_SARREDID as "تاريخ سررسيد"

from tbl_loan lo
where 

lo.id in
     ( '|| FNC_PRIVATE_CREATE_QUERY('TBL_LOAN',var_loan) ||')
     AND REF_MOSHTARI IN ('||
     FNC_PRIVATE_CREATE_QUERY('TBL_CUSTOMER',var_customer) ||')
    
      AND REF_SHOBE IN ( '||
     FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH)||' )



     '
INTO
     VAR_QUERY
    FROM DUAL;

 return VAR_QUERY;
end fnc_loan_base;
