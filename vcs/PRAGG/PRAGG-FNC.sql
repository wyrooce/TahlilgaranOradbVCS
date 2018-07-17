--------------------------------------------------------
--  DDL for Function FNC_PROFILE_CREATE_QUERY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_PROFILE_CREATE_QUERY" (
        INPAR_ID IN NUMBER ,
        inpar_type in number) -- if =1 paging else = 0
 --RETURN VARCHAR2
 RETURN clob
  --return varchar2
AS
iidd number;
--------------------------------------------------------------------------------
  /*
  Programmer Name: Sobhan.Sadeghdeh & Navid.Seddigh
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
    SELECT rtrim(xmlagg(XMLELEMENT(e,'('
    ||SRC_COLUMN
    ||REPLACE(CONDITION,'#',' or '
    || SRC_COLUMN), ') and ').EXTRACT('//text()')
    ).GetClobVal(),',') "where_condition" into  where_condition
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
          LON_ID as "loanId",
         
          lo.REF_LOAN_TYPE as "loanTypeId",
          typee.name as "name",
          REF_BRANCH as "branchId",
          REF_CUSTOMER as "customerId",
          REF_CURRENCY as "currencyId",
          TO_CHAR(OPENING_DATE,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          APPROVED_AMOUNT as "mablaghMosavab",
          current_amount as "mandeJari",
          overdue_amount as "mandeSarresidGozashte",
          deferred_amount as "mandeMoavagh",
          doubtful_amount as "mandeMashkokVosol",
          REF_LOAN_ACCOUNTING as "hesabdariTashilatId",
          rate as "rate"
          from akin.TBL_LOAN lo,TBL_LOAN_TYpe typee,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' and typee.ref_loan_type =lo.REF_loan_TYPE';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''yyyy/mm/dd'') as "createDate",
          LON_ID as "loanId",
         
          lo.REF_LOAN_TYPE as "loanTypeId",
          typee.name as "name",
          REF_BRANCH as "branchId",
          REF_CUSTOMER as "customerId",
          REF_CURRENCY as "currencyId",
          TO_CHAR(OPENING_DATE,''yyyy/mm/dd'',''nls_calendar= persian'') as "openingDate",
          APPROVED_AMOUNT as "mablaghMosavab",
          current_amount as "mandeJari",
          overdue_amount as "mandeSarresidGozashte",
          deferred_amount as "mandeMoavagh",
          doubtful_amount as "mandeMashkokVosol",
          REF_LOAN_ACCOUNTING as "hesabdariTashilatId"
          from akin.TBL_LOAN lo,tbl_loan_type typee,tbl_profile where  tbl_profile.id = '||iidd||' and typee.ref_loan_type =lo.REF_loan_TYPE' ;
          --where_condition := NULL;
      end if;
      else
    if(v_count!=0) then
      
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
          LON_ID as "loanId",
         
          lo.REF_LOAN_TYPE as "loanTypeId",
          typee.name as "name",
          REF_BRANCH as "branchId",
          REF_CUSTOMER as "customerId",
          REF_CURRENCY as "currencyId",
          TO_CHAR(OPENING_DATE,''''yyyy/mm/dd'''',''''nls_calendar= persian'''') as "openingDate",
          APPROVED_AMOUNT as "mablaghMosavab",
          current_amount as "mandeJari",
          overdue_amount as "mandeSarresidGozashte",
          deferred_amount as "mandeMoavagh",
          doubtful_amount as "mandeMashkokVosol",
          REF_LOAN_ACCOUNTING as "hesabdariTashilatId",
          rate as "rate"
          from akin.TBL_LOAN lo,TBL_LOAN_TYpe typee,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd||' and typee.ref_loan_type =lo.REF_loan_TYPE';
      else
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profielDes",TO_CHAR(tbl_profile.create_date,''''yyyy/mm/dd'''') as "createDate",
          LON_ID as "loanId",
          
          lo.REF_LOAN_TYPE as "loanTypeId",
          typee.name as "name",
          REF_BRANCH as "branchId",
          REF_CUSTOMER as "customerId",
          REF_CURRENCY as "currencyId",
          TO_CHAR(OPENING_DATE,''''yyyy/mm/dd'''',''''nls_calendar= persian'''') as "openingDate",
          APPROVED_AMOUNT as "mablaghMosavab",
          current_amount as "mandeJari",
          overdue_amount as "mandeSarresidGozashte",
          deferred_amount as "mandeMoavagh",
          doubtful_amount as "mandeMashkokVosol",
          REF_LOAN_ACCOUNTING as "hesabdariTashilatId"
          from akin.TBL_LOAN lo,tbl_loan_type typee,tbl_profile where  tbl_profile.id = '||iidd||' and typee.ref_loan_type =lo.REF_loan_TYPE' ;
          --where_condition := NULL;
          end if;
          end if;
--------------------------------------------------------------------------------
elsif (v_name_input_tbl='TBL_BRANCH') then
    if(v_count!=0) then
    select REPLACE(where_condition, 'and', 'or') into where_condition from dual;
          var:='select 
          tbl_profile.name as "profileName", tbl_profile.des as "profileDes",tbl_profile.create_date as "createDate",
          BRN_ID as "branchID",
          br.NAME as "branchName",
          REF_CTY_ID as "cityId",
          CITY_NAME as "cityName",
          REF_STA_ID as "stateId",
          STA_NAME as "stateName"
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
CTY_ID as "cityId",
CTY_NAME as "cityName",
cty.DES as "cityDes",
REF_STA_ID as "stateId"
from TBL_CITY cty,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd;
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
CUR_ID as "id",
CUR_NAME as "curName",
SWIFT_CODE as "swiftCode",
cur.DES as "curDes"
from TBL_CURRENCY cur,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd;
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
TBL_CUSTOMER.CUS_ID as "id",
TBL_CUSTOMER.NAME as "customerName",
TBL_CUSTOMER.FAMILY as "customerFamily",
TBL_CUSTOMER.NAT_REG_CODE as "meliCode",
TBL_CUSTOMER.ADDRESS as "address",
TBL_CUSTOMER.BIRTHDATE as "birthdate",
TBL_CUSTOMER.GENDER as "gender",
TBL_CUSTOMER.TYPE as "customerType",
TBL_CUSTOMER.BRANCH_ID as "branchId"
from TBL_CUSTOMER,tbl_profile where '||'('||where_condition ||')'||'and tbl_profile.id = '||iidd;
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
--  DDL for Function FNC_PRIVATE_CREATE_QUERY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_PRIVATE_CREATE_QUERY" (
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
  

  
  if(upper(INPAR_TYPE)is not null and inpar_id is not null) then
  SELECT type INTO v_name_input_tbl FROM pragg.tbl_profile WHERE id=inpar_id;
  select count(*) into v_count from pragg.tbl_profile_detail where ref_profile=inpar_id;
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
  FROM pragg.tbl_profile_detail
WHERE ref_profile = inpar_id;


select substr(where_condition,0,LENGTH(where_condition)-6) into where_condition from dual;
--=================================

    --=========================== eslahe khoroji XML
     select REPLACE(where_condition, '&gt;', '>') into where_condition from dual;
    select REPLACE(where_condition, '&apos;', '''') into where_condition from dual;
    select REPLACE(where_condition, '&lt;', '<') into where_condition from dual;
    --============================

  
  where_condition:=where_condition||')';
--------------------------------------------------------------------------------  
  
  if(v_name_input_tbl='TBL_DEPOSIT') then
    if(v_count!=0) then
    var:='select 
    DEP_ID as "depositId"
    from akin.TBL_DEPOSIT dep,pragg.tbl_profile where '||'('||where_condition ||')'||'and pragg.tbl_profile.id = '||inpar_id;
    else
    var:='select 
    DEP_ID as "depositId"
    from akin.TBL_DEPOSIT,pragg.tbl_profile where pragg.tbl_profile.id = '||inpar_id;
  end if;
--------------------------------------------------------------------------------
  elsif (v_name_input_tbl='TBL_LOAN') then
    if(v_count!=0) then
    
    var:='select 
    LON_ID as "loanId" 
    from akin.TBL_LOAN lo ,pragg.tbl_profile where '||'('||where_condition ||')'||'and pragg.tbl_profile.id = '||inpar_id;
    else
    var:='select 
    LON_ID as "loanId"
    from akin.TBL_LOAN,pragg.tbl_profile where  pragg.tbl_profile.id = '||inpar_id;
  end if;
--------------------------------------------------------------------------------
  elsif (v_name_input_tbl='TBL_BRANCH' ) then
    if(v_count!=0) then
    select REPLACE(where_condition, 'and', 'or') into where_condition from dual;
    var:='select 
    BRN_ID as "branchId"
    from pragg.TBL_BRANCH br,pragg.tbl_profile where '||'('||where_condition ||')'||'and pragg.tbl_profile.id = '||inpar_id;
    else
    var:='select 
    BRN_ID as "branchId"
    from pragg.TBL_BRANCH br,pragg.tbl_profile where pragg.tbl_profile.id = '||inpar_id; 
  end if;
--------------------------------------------------------------------------------
  elsif (v_name_input_tbl='TBL_CITY') then
    if(v_count!=0) then
    var:='select
    CTY_ID as "cityId"
    from pragg.TBL_CITY cty,pragg.tbl_profile where '||'('||where_condition ||')'||'and pragg.tbl_profile.id = '||inpar_id;
    else
    var:='select
    CTY_ID as "cityId",
    from pragg.TBL_CITY cty,pragg.tbl_profile where pragg.tbl_profile.id = '||inpar_id; 
  end if;
--------------------------------------------------------------------------------
  elsif (v_name_input_tbl='TBL_CURRENCY') then
    if(v_count!=0) then
    var:='select
    CUR_ID as "currencyID"
    from pragg.TBL_CURRENCY cur,pragg.tbl_profile where '||'('||where_condition ||')'||'and pragg.tbl_profile.id = '||inpar_id;
    else
    var:='select
    CUR_ID as "currencyId"
    from pragg.TBL_CURRENCY cur,pragg.tbl_profile where pragg.tbl_profile.id = '||inpar_id;
  end if;
--------------------------------------------------------------------------------
  elsif (v_name_input_tbl='TBL_CUSTOMER') then
    if(v_count!=0) then
    var:='select
    CUS_ID as "customerId"
    from pragg.TBL_CUSTOMER,pragg.tbl_profile where '||'('||where_condition ||')'||'and pragg.tbl_profile.id = '||inpar_id; 
    else
    var:='select
    CUS_ID as "customerId"
    from pragg.TBL_CUSTOMER,pragg.tbl_profile where pragg.tbl_profile.id = '||inpar_id; 
  end if;
--------------------------------------------------------------------------------
  end if;
--------------------------------------------------------------------------------
  else
  
  if(upper(inpar_type) = 'TBL_LOAN') then
    var:='select 
    LON_ID as "loanId"
    from akin.TBL_LOAN';
    
  end if;
  
  if(upper(inpar_type) = 'TBL_DEPOSIT') then
    var:='select 
    DEP_ID as "depositId"
    from akin.TBL_DEPOSIT';
  
  end if;
  
  if(upper(inpar_type) = 'TBL_BRANCH') then
    var:='select 
    BRN_ID as "branchId"
    from pragg.TBL_BRANCH';
  
  end if;
  
  if(upper(inpar_type) = 'TBL_CITY') then
    var:='select
    CTY_ID as "cityId",
    from pragg.TBL_CITY';
  
  end if;
  
  if(upper(inpar_type) = 'TBL_CURRENCY') then
    var:='select
   4 as "currencyId"
    from pragg.TBL_CURRENCY';
  
  end if;
  
  if(upper(inpar_type) = 'TBL_CUSTOMER') then
    var:='select
    CUS_ID as "customerId"
    from pragg.TBL_CUSTOMER';
  
  end if;
  end if;
RETURN var;
  
--------------------------------------------------------------------------------
END FNC_PRIVATE_CREATE_QUERY;
--------------------------------------------------------
--  DDL for Function FNC_GET_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_PROFILE" (
    INPAR_TYPE IN VARCHAR2 )
  RETURN VARCHAR2
AS
pragma autonomous_transaction;
--------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh & Morteza.Sahhi
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

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_QUERY_RESULT" (
    inpar_type IN VARCHAR2 ,
    inpar_noe IN VARCHAR2) -- if inpar_noe=1 then date , if 2 then rate, if 3 then name & code tashilat
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
      RETURN 'SELECT CUR_ID as "id", CUR_NAME as "curName", SWIFT_CODE as "swiftCode", DES as "des" FROM TBL_CURRENCY ';
  ELSE
    IF(upper(inpar_type)='TBL_BRANCH' and upper(inpar_noe)='BRANCH') THEN
      RETURN 'SELECT p.STA_NAME "provinceName",                                            
              c.CTY_NAME "cityName",                                            
              p.STA_ID "provinceId",                                            
              c.CTY_ID "cityId",                                            
              s.NAME "label",                                            
              s.BRN_ID "id",
              ''brn_id'' "type"
              FROM TBL_BRANCH s                                          
              LEFT OUTER JOIN TBL_CITY c                                          
              ON s.REF_CTY_ID = c.cty_id                                          
              LEFT OUTER JOIN TBL_STATE p                                          
              ON p.STA_ID = c.REF_STA_ID';
  Else
    IF(upper(inpar_type)='TBL_BRANCH' and upper(inpar_noe)='CITY')then
    return '   SELECT distinct(bts.cty_id) "id", bts.cty_name "label", bto.sta_id "provinceId", ''ref_cty_id'' "type"
          FROM TBL_CITY bts, TBL_STATE bto,TBL_BRANCH bts1 
          WHERE bts.ref_sta_id = bto.sta_id and bts1.ref_cty_id = bts.cty_id ORDER BY "label"';
  Else
    IF(upper(inpar_type)='TBL_BRANCH' and upper(inpar_noe)='STATE') then
    return ' SELECT distinct(bto.sta_id) "id", bto.sta_name "label",''ref_sta_id'' "type"
               FROM TBL_CITY bts, TBL_STATE bto, TBL_BRANCH bts1 
              where  bts.ref_sta_id = bto.sta_id and bts1.ref_cty_id = bts.cty_id ORDER BY "label"';
  Else  
    IF(upper(inpar_type)='TBL_LOAN' AND  upper(inpar_noe)='DATE') then             
      RETURN 'SELECT LON_ID as "loanId",
              REF_LOAN_TYPE as "loanType",
              OPENING_DATE as "openDate",
              APPROVED_AMOUNT as "mablaghMosavab",
              CURRENT_AMOUNT as "mandeJari",
              OVERDUE_AMOUNT as "mandeSarresidGozashte",
              DEFERRED_AMOUNT as "mandeMoavagh",
              DOUBTFUL_AMOUNT as "mandeMashkookolVosool"
              FROM AKIN.TBL_LOAN' ;           
  ELSE
    IF (upper(inpar_type)='TBL_LOAN' AND  upper(inpar_noe)='RATE') THEN
      RETURN 'SELECT ref_rate as "id", RATE as "name", TYPE as "type" FROM TBL_RATE where TYPE = ''TBL_LOAN''';
  ELSE
    IF(upper(inpar_type)='TBL_LOAN' AND upper(inpar_noe)='CODE') THEN
      RETURN 'SELECT ID as "code", NAME as "name", lo.REF_LOAN_TYPE as "id" FROM TBL_LOAN_TYPE lo' ;
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
      RETURN 'SELECT CUS_ID as "customerId",
              NAME as "customerName",
              FAMILY as "customerFamily",
              NAT_REG_CODE as "meliCode",
              ADDRESS as "address",
              BIRTHDATE as "birthdate",
              GENDER as "gender",
              BRANCH_ID as "branchId"
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
    END IF;
    END IF;
  END IF;
END fnc_get_query_result;
--------------------------------------------------------
--  DDL for Function FNC_PROFILE_WHERE_CONDITION
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_PROFILE_WHERE_CONDITION" (
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
  Programmer Name:  Sobhan.Sadeghzade 
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

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_TOP_CUSTOMER" (
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
--  DDL for Function FNC_CUSTOMER_SEARCHING_ENG
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_CUSTOMER_SEARCHING_ENG" 
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
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (1,'NAME',IN_NAME,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (2,'family',IN_FAMILY,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (3,'NAT_REG_CODE',IN_NAT_REG_CODE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (4,'P_LOAN',INPAR_LOAN,'l."customerId"=c.CUS_ID');
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (5,'P_BRANCH',INPAR_BRANCH,'b."branchID"=c.BRANCH_ID');
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (6,'P_DEPOSIT',INPAR_DEPOSIT,'d."customerId"=c.CUS_ID');
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (7,'TYPE',IN_TYPE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (8,'GENDER',IN_GENDER,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (9,'TEL',IN_TEL,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (10,'MOBILE',IN_MOBILE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (11,'POSTAL_CODE',IN_POSTAL_CODE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (12,'FATHER_NAME',IN_FATHER_NAME,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (13,'BIRTH_PLACE',IN_BIRTH_PLACE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (14,'GRADE',IN_GRADE,null);
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
v_result:='select c.name as "customerName",c.family as "customerFamily",c.CUS_ID as "id",c.type as "type",c.gender as "GENDER"
,c.tel as "tel", c.mobile as "mobile",c.postal_code as "postal_code", c.father_name as "father_name",c.birth_place as "birth_place",c.grade as "mizane_tashilat" from '||v_queri||'tbl_customer c where '||v_where;
elsif( (v_queri is null or v_queri='(select * from dual where 1>2) l ,' ) and v_where is null) then
v_result:='select c.name as "customerName",c.family as "customerFamily",c.CUS_ID as "id",c.type as "type",c.gender as "GENDER",c.tel as "tel", c.mobile as "mobile",c.postal_code as "postal_code", c.father_name as "father_name",c.birth_place as "birth_place",c.grade as "mizane_tashilat"  from tbl_customer c ';
else
v_result:='select c.name as "customerName",c.family as "customerFamily",c.CUS_ID as "id",c.type as "type",c.gender as "GENDER",c.tel as "tel", c.mobile as "mobile",c.postal_code as "postal_code", c.father_name as "father_name",c.birth_place as "birth_place",c.grade as "mizane_tashilat"  from tbl_customer c where '||v_where;
end if;

return v_result;
  
  
END FNC_CUSTOMER_SEARCHING_ENG;
--------------------------------------------------------
--  DDL for Function FNC_GET_TIMING_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_TIMING_PROFILE" (
    INPAR_TYPE IN number -- 2 tarikh dar , 1 bazehi
    )
  RETURN VARCHAR2
AS
pragma autonomous_transaction;
--------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh
  Editor Name:
  Release Date/Time:1396/03/23-15:00
  Edit Name:
  Version: 1
  Category:
  Description:
  */
--------------------------------------------------------------------------------  
BEGIN
prc_is_empty();
  RETURN 'SELECT ID as "id",
          NAME as "name",
          CREATE_DATE as "createDate",
          REF_USER as "user",
          DES as "des",
          UPDATE_DATE as "updateDate",
          REF_USER_UPDATE as "userUpdate",
          PERIOD_DURATION as "PeriodDuration"
          FROM TBL_TIMING_PROFILE
          where type ='''||INPAR_TYPE||'''';
END FNC_GET_TIMING_PROFILE;
--------------------------------------------------------
--  DDL for Function FNC_TIMING_PROFILE_RESULT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_TIMING_PROFILE_RESULT" 
(
  inpar_type in varchar2,
  inpar_id in varchar2 
) return varchar2 as 
pragma autonomous_transaction;
iidd number;
begin

--------------------------------------------------------------------------------
  /*
  Programmer Name: Navid.Seddigh
  Editor Name:
  Release Date/Time:1396/04/8-15:00
  Edit Name:
  Version: 1
  Category:
  Description: In fumction 2 voroodi inpar_type va inpar_id migirad. agar inpar_
               type = "tarikh" bashad profile tarikh va agar inpar_type ="bazeh"
               bashad profile zamani bazeEi ast.va ba vared kardne ID profile ma_
               rboote, moshkhasat va be ebarati detail on profile namayesh dade
               mishavad.
  */
--------------------------------------------------------------------------------  
prc_is_empty();
select  max(id) into iidd

FROM TBL_TIMING_PROFILE
where h_id = inpar_id
group by name ;

if(upper(inpar_type)='TARIKH') then
 return 'SELECT det.ID as "id",
              h_id  as "timing_profile_id",
              det.PERIOD_NAME as "name",
              to_char(det.PERIOD_START,''YYYY-MM-DD'') as "startDate",
              to_char(det.PERIOD_END,''YYYY-MM-DD'') as "endDate",
              det.PERIOD_COLOR as "color"
              FROM TBL_TIMING_PROFILE_DETAIL det, TBL_TIMING_PROFILE po 
              where det.REF_TIMING_PROFILE = po.ID and po.TYPE=2 and  det.ref_timing_profile = '||iidd||' and PERIOD_STATUS = 1  order by det.id';
              
else

if(upper(inpar_type)='BAZEH') then
return' SELECT det.ID as "id",
            det.PERIOD_NAME as "name",
            h_id  as "timing_profile_id",
            det.PERIOD_DATE as "periodDate",
            det.PERIOD_COLOR as "color"
            FROM TBL_TIMING_PROFILE_DETAIL det, TBL_TIMING_PROFILE po 
            where det.REF_TIMING_PROFILE = po.ID and po.TYPE=1 and  det.ref_timing_profile = '||iidd||' and PERIOD_STATUS = 1 order by det.id';
end if;
end if;
 
end fnc_timing_profile_result;
--------------------------------------------------------
--  DDL for Function FNC_PAGING_QUERY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_PAGING_QUERY" 
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
, INPAR_QUERY IN varchar2
) RETURN clob AS 
  LOC_QUERY clob; 
  total_number number:=FNC_PAGE_NUMBER(INPAR_PAGE_SIZE,INPAR_QUERY) ;
  LOC_LOW NUMBER := (INPAR_PAGE_NUMBER-1)*INPAR_PAGE_SIZE+1; 
  LOC_UP NUMBER := INPAR_PAGE_NUMBER*INPAR_PAGE_SIZE; 
BEGIN

  if (LOC_UP>total_number) then 
  LOC_UP:=total_number;
  end if;

   -- select FNC_PROFILE_CREATE_QUERY(inpar_id,0) into var from dual;


  LOC_QUERY := 'SELECT * FROM (
                              SELECT ROWNUM "رديف", t.*
                              FROM (' || INPAR_QUERY ||')T)
                              WHERE  "رديف" BETWEEN ' || LOC_LOW || ' AND ' ||LOC_UP;
 RETURN LOC_QUERY;
END FNC_PAGING_QUERY;
--------------------------------------------------------
--  DDL for Function FNC_CUSTOMER_PAGING
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_CUSTOMER_PAGING" 
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
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (1,'NAME',IN_NAME,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (2,'family',IN_FAMILY,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (3,'NAT_REG_CODE',IN_NAT_REG_CODE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (4,'P_LOAN',INPAR_LOAN,'l."customerId"=c.CUS_ID');
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (5,'P_BRANCH',INPAR_BRANCH,'b."branchID"=c.BRANCH_ID');
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (6,'P_DEPOSIT',INPAR_DEPOSIT,'d."customerId"=c.CUS_ID');
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (7,'TYPE',IN_TYPE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (8,'GENDER',IN_GENDER,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (9,'TEL',IN_TEL,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (10,'MOBILE',IN_MOBILE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (11,'POSTAL_CODE',IN_POSTAL_CODE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (12,'FATHER_NAME',IN_FATHER_NAME,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (13,'BIRTH_PLACE',IN_BIRTH_PLACE,null);
insert into  TBL_CUSTOMER_SEARCH_ITEM (ID,COLUMN_TYPE,VALUE,CONDITION) values (14,'GRADE',IN_GRADE,null);
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
v_result:='select c.name as "customerName",c.family as "customerFamily",c.CUS_ID as "id",c.type as "type",c.gender as "GENDER",c.tel as "tel", c.mobile as "mobile",c.postal_code as "postal_code", c.father_name as "father_name",c.birth_place as "birth_place",c.grade as "mizane_tashilat" from '||v_queri||'tbl_customer c where '||v_where;

elsif( (v_queri is null or v_queri='(select * from dual where 1>2) l ,' ) and v_where is null) then
v_result:='select c.name as "customerName",c.family as "customerFamily",c.CUS_ID as "id",c.type as "type",c.gender as "GENDER",c.tel as "tel", c.mobile as "mobile",c.postal_code as "postal_code", c.father_name as "father_name",c.birth_place as "birth_place",c.grade as "mizane_tashilat"  from tbl_customer c ';
else
v_result:='select c.name as "customerName",c.family as "customerFamily",c.CUS_ID as "id",c.type as "type",c.gender as "GENDER",c.tel as "tel", c.mobile as "mobile",c.postal_code as "postal_code", c.father_name as "father_name",c.birth_place as "birth_place",c.grade as "mizane_tashilat"  from tbl_customer c where '||v_where;
end if;

select REPLACE(v_result, 'to_date(''', 'to_date(''') into v_result from dual;
select REPLACE(v_result, 'YYYY-MM-DD''', 'YYYY-MM-DD''') into v_result from dual;

return v_result;
  
END FNC_CUSTOMER_PAGING;
--------------------------------------------------------
--  DDL for Function FNC_LEDGER_ITEM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_LEDGER_ITEM" ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
 IIDD   NUMBER;
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Navid.Seddigh
  Editor Name:
  Release Date/Time:1396/04/11-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description: bargardandane dadehaE daftare kol bar asase id daftar kol entekhabi.
               
  */
  /*------------------------------------------------------------------------------*/
BEGIN
 SELECT
  MAX(ID)
 INTO
  IIDD
 FROM TBL_LEDGER_PROFILE
 WHERE H_ID   = INPAR_ID
 GROUP BY
  NAME;

 RETURN 'SELECT distinct(CODE) as "id",
(select distinct(max(depth)) from TBL_LEDGER_PROFILE_DETAIL)  as "maxlev" ,
  NAME as "text",
  PARENT_CODE as "parent",
  DEPTH as "level" 
FROM TBL_LEDGER_PROFILE_DETAIL 
where REF_LEDGER_PROFILE='
|| IIDD || '
--connect by prior CODE=PARENT_CODE
order by CODE';
END FNC_LEDGER_ITEM;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_LIST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_REPORT_LIST" 
(
  inpar_category IN VARCHAR2 ,
  inpar_TYPE IN VARCHAR2 
  
) RETURN VARCHAR2 AS 
outpar_var varchar2(4000);
  /*
  Programmer Name: sobhan sadeghzadeh
  Editor Name:
  Release Date/Time:1396/04/27
  Edit Name:
  Version: 1
  Category:
  Description:
  queri select baraye namayesh report ha bar asase "category" va "type"
  */
BEGIN
  
  
  outpar_var:='select id as "id",name as "name",des as "des" from tbl_report where category='||''''||inpar_category||''''||' and  type='||''''||inpar_TYPE||'''';
  
  return outpar_var;
  
END FNC_REPORT_LIST;
--------------------------------------------------------
--  DDL for Function FNC_NOTIFICATION
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_NOTIFICATION" 
(
  INPAR_OPT_TYPE IN VARCHAR2
, INPAR_ID IN NUMBER  DEFAULT NULL
, INPAR_TYPE IN VARCHAR2  DEFAULT NULL
, INPAR_TITLE IN VARCHAR2 DEFAULT NULL
, INPAR_STATUS IN VARCHAR2 DEFAULT NULL
, INPAR_USER_ID IN NUMBER DEFAULT NULL
, INPAR_DESCRIPTION IN VARCHAR2 DEFAULT NULL
) RETURN NUMBER AS 
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
pragma autonomous_transaction;
Var_STATUS VARCHAR2(20);
BEGIN


IF INPAR_OPT_TYPE = 'insert' THEN 
  --=======INSERT================
INSERT
INTO TBL_NOTIFICATIONS
  (
   
    TITLE,
    TYPE,
    REF_USER,
    START_TIME,
    STATUS,
    DESCRIPTION
  )
  VALUES
  (
   
    INPAR_TITLE,
    INPAR_TYPE,
    INPAR_USER_ID,
    sysdate,
    'progress',
    INPAR_DESCRIPTION
  );
  
 END IF; 
 
IF INPAR_OPT_TYPE = 'upadate' THEN 
  --=======UPDATE================
   UPDATE TBL_NOTIFICATIONS
   SET STATUS           =INPAR_STATUS , END_TIME = sysdate
   WHERE ID        = INPAR_ID
   ;
 END IF; 
  return 1;
IF INPAR_OPT_TYPE = 'delete' THEN
  --=======DELETE================  
  DELETE
  FROM TBL_NOTIFICATIONS
  WHERE ID        = INPAR_ID;
END IF;
return 1;
IF INPAR_OPT_TYPE = 'check' THEN
  --=======CHECK STATUS================  
  SELECT 
  STATUS
  into Var_STATUS
  FROM TBL_NOTIFICATIONS
  
  where ID = INPAR_ID;
  return Var_STATUS ;
END IF;
  
  
END FNC_NOTIFICATION;
--------------------------------------------------------
--  DDL for Function FNC_GET_REPORT_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_REPORT_PROFILE" 
(
  INPAR_ID IN NUMBER 

) RETURN VARCHAR2 AS 

 INPAR_OUT varchar2(4000);
 v_max_id number;
   /*
  Programmer Name: sobhan sadeghzadeh
  Editor Name:
  Release Date/Time:1396/04/31
  Edit Name:
  Version: 1
  Category:
  Description:
  queri select  baraye namayesh akharin vaziat report bar asase h_id
  */
  
BEGIN
  
select max(id) into v_max_id from tbl_report where h_id= INPAR_ID; 

  
INPAR_OUT:='select 
ID                  as "id",
NAME                as "name",
DES                 as "description",
CREATE_DATE         as "createDate",
REF_USER            as "user",
STATUS              as "status",
REF_LEDGER_PROFIEL  as "ledgerProfileId",
REF_TIMING_PROFILE  as "dateProfileId",
TIMING_PROFILE_TYPE as "dateType",
REF_DEP_PROFILE     as "depositProfileId",
REF_LON_PROFILE     as "loanProfileId",
REF_BRN_PROFILE     as "branchProfileId",
REF_CUS_PROFILE     as "customerProfileId",
REF_CUR_PROFILE     as "currencyProfileId",
VERSION             as "version",
TYPE                as "type",
CATEGORY            as "category" 
from tbl_report where id='||v_max_id;

return INPAR_OUT;
  
END FNC_GET_REPORT_PROFILE;
--------------------------------------------------------
--  DDL for Function FNC_GET_REPORT_LIST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_REPORT_LIST" 
(
  inpar_category IN VARCHAR2 ,
  inpar_TYPE IN VARCHAR2 
  
) RETURN VARCHAR2 AS 
outpar_var varchar2(4000);
  /*
  Programmer Name: sobhan sadeghzadeh
  Editor Name:
  Release Date/Time:1396/04/27
  Edit Name:
  Version: 1
  Category:
  Description:
  namayesh akharin vaziat har report e fa'al bar asase "category" va "type" 
  */
BEGIN
  
  if(upper(inpar_category)  in ('COM','COM2','IDPS','CAR','LCR','NPL','NSFR','SENSIVITY','NIIM','IDPS','LEDGER-SENS','SENSITIVE'))
  then
  outpar_var:='select id as "id",name as "name",des as "des", ref_user as "createdBy",create_date as "created" from tbl_report where STATUS=1 and upper(category)='||''''||upper(inpar_category)||''''||' and  upper(type)='||''''||upper(inpar_TYPE)||''''||' order by id'; 
  else
  outpar_var:='select max(h_id) as "id",name as "name",max(des) as "des", max(ref_user) as "createdBy",max(create_date) as "created" from tbl_report where STATUS=1 and upper(category)='||''''||upper(inpar_category)||''''||' and  upper(type)='||''''||upper(inpar_TYPE)||''''||' group by name';
  end if;
  
  return outpar_var;
  
END FNC_GET_REPORT_LIST ;
--------------------------------------------------------
--  DDL for Function FNC_GET_QUERY_REPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_QUERY_REPORT" ( INPAR_REF_REPREQ IN VARCHAR2 ) RETURN VARCHAR2 AS 
   /*------------------------------------------------------------------------------*/
  /*
  Programmer Name:  morteza.sahi 
  Editor Name: 
  Release Date/Time:1396/05/18-11:00
  Edit Name: 
  Version: 1
  Category:2
  Description: query derakht daftarkol nahaee ba maghadir ra barmigardanad
  */
/*------------------------------------------------------------------------------*/

 OUTPAR_REF_REPREQ   VARCHAR2(2000);
 VAR_REF_REPORT_ID   NUMBER;
 VAR_TIMING          VARCHAR2(1000);
 VAR_TIMING1         VARCHAR2(1000);
 var_ledger_profile number;
BEGIN
 SYS.DBMS_OUTPUT.ENABLE(3000000);
 /****** peyda kardane gozaresh entekhab shode ******/
 SELECT
  REF_REPORT_ID
 INTO
  VAR_REF_REPORT_ID
 FROM TBL_REPREQ
 WHERE ID = INPAR_REF_REPREQ;
 select ref_ledger_profile into var_ledger_profile from TBL_REPREQ where ID   = INPAR_REF_REPREQ;
 /****** peyda kardane profile zamani entekhab shode baraye select nahaee ******/

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
 FROM TBL_REPPER
 WHERE REF_REPORT_ID           = VAR_REF_REPORT_ID
  AND
   TBL_REPPER.REF_REQ_ID   = INPAR_REF_REPREQ;
 /****** peyda kardane esme profile zamani entekhab shode baraye select nahaee ******/

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
 FROM TBL_REPPER
 WHERE REF_REPORT_ID           = VAR_REF_REPORT_ID
  AND
   TBL_REPPER.REF_REQ_ID   = INPAR_REF_REPREQ;
 /****** ijad kardane select nahaee az TBL_REPVAL ******/

 SELECT
  '
select "id","parent","text", "mande","other",' ||
  VAR_TIMING1 ||
  ',"level"  from(
SELECT 
 * FROM
(
SELECT *
FROM   (SELECT 
  tr.REF_REPPER_ID,
  tr.LEDGER_CODE as "id",
   tr.name as "text",
  tr.VALUE,
  tr.PARENT_CODE as "parent",
  tr.depth as "level"
 FROM  (select  REF_REPPER_ID,LEDGER_CODE,name,PARENT_CODE,depth,VALUE,mande from TBL_REPVAL where  REF_REPREQ_ID ='||INPAR_REF_REPREQ||'  )tr)
PIVOT  (sum(nvl(VALUE,0))  FOR (REF_REPPER_ID) IN (' ||
  VAR_TIMING ||
  ' ,0 AS "mande" 
  ,-1 AS "other"))
ORDER BY "id")a) '
 INTO
  OUTPAR_REF_REPREQ
 FROM DUAL;

 RETURN OUTPAR_REF_REPREQ;
END FNC_GET_QUERY_REPORT;
--------------------------------------------------------
--  DDL for Function FNC_GET_DETAIL_TIMING
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_DETAIL_TIMING" 
(
  inpar_ref_repreq IN VARCHAR2 
) RETURN VARCHAR2 AS 
--------------------------------------------------------------------------------
  /*
  Programmer Name:  morteza.sahi 
  Editor Name: 
  Release Date/Time:1396/05/22-13:00
  Edit Name: 
  Version: 1
  Category:2
  Description:bar asas gozaresh entekhab shode etelaate profile zamani ke entekhab karde ra bar migardanad
  */
--------------------------------------------------------------------------------
var_REF_REPORT_ID number;
BEGIN
select REF_REPORT_ID into var_REF_REPORT_ID from  TBL_REPREQ where id = inpar_ref_repreq;


  RETURN 'select ID "value",PERIOD_NAME "header",PERIOD_COLOR "color" from tbl_repper where REF_REPORT_ID ='||var_REF_REPORT_ID||' and REF_REQ_ID = '||inpar_ref_repreq||'';
END FNC_GET_DETAIL_TIMING;
--------------------------------------------------------
--  DDL for Function GET_QUERY_GAP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."GET_QUERY_GAP" ( INPAR_REF_REQ_ID IN NUMBER ) RETURN VARCHAR2 AS 
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name:  morteza.sahi 
  Editor Name: 
  Release Date/Time:1396/05/18-16:00
  Edit Name: 
  Version: 1
  Category:2
  Description: query shekaf ra bar migardanad
  */
/*------------------------------------------------------------------------------*/

 VAR_REF_REPORT_ID        NUMBER;
 VAR_REF_LEDGER_PROFILE   NUMBER;
 VAR_TIMING               VARCHAR2(1000);
 VAR_TIMING1              VARCHAR2(1000);
 VAR_HID_LEDGER_PROFILE   NUMBER;
BEGIN
 SYS.DBMS_OUTPUT.ENABLE(3000000);
  /****** peyda kardane gozaresh entekhab shode ******/
 SELECT
  REF_REPORT_ID
 INTO
  VAR_REF_REPORT_ID
 FROM TBL_REPREQ
 WHERE ID   = INPAR_REF_REQ_ID;
 /****** peyda kardane profile daftarkol ******/

 SELECT
  REF_LEDGER_PROFILE
 INTO
  VAR_REF_LEDGER_PROFILE
 FROM TBL_REPORT_PROFILE
 WHERE REF_REPORT   = VAR_REF_REPORT_ID;
 /****** peyda kardane id asli profile daftarkol entekhab shode ******/

 SELECT
  H_ID
 INTO
  VAR_HID_LEDGER_PROFILE
 FROM TBL_LEDGER_PROFILE
 WHERE ID   = VAR_REF_LEDGER_PROFILE;
  /****** peyda kardane gozaresh entekhab shode ******/

 SELECT
  REF_REPORT_ID
 INTO
  VAR_REF_REPORT_ID
 FROM TBL_REPREQ
 WHERE ID   = INPAR_REF_REQ_ID;
 /****** peyda kardane profile zamani entekhab shode baraye select nahaee ******/

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
 FROM TBL_REPPER
 WHERE REF_REPORT_ID           = VAR_REF_REPORT_ID
  AND
   TBL_REPPER.REF_REQ_ID   = INPAR_REF_REQ_ID;
 /****** peyda kardane esme profile zamani entekhab shode baraye select nahaee ******/

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
 FROM TBL_REPPER
 WHERE REF_REPORT_ID           = VAR_REF_REPORT_ID
  AND
   TBL_REPPER.REF_REQ_ID   = INPAR_REF_REQ_ID;
 /****** ijad kardane select nahaee az TBL_REPVAL ******/

 RETURN '
select  ' ||
 VAR_TIMING1 ||
 ' from
(
select  REF_REPPER_ID,sum(value) as VALUE from tbl_repval where PARENT_CODE = ' ||
 VAR_HID_LEDGER_PROFILE ||
 ' and ref_repreq_id =' ||
 INPAR_REF_REQ_ID ||
 ' 
group by REF_REPPER_ID  )
PIVOT  (max(nvl(VALUE,0))  FOR (REF_REPPER_ID) IN (' ||
 VAR_TIMING ||
 '))';

 RETURN NULL;
END GET_QUERY_GAP;
--------------------------------------------------------
--  DDL for Function FNC_GET_REPORT_ARCHIVE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_REPORT_ARCHIVE" RETURN VARCHAR2 AS 
BEGIN
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
return 
'SELECT
 REQ.ID AS "id"
 ,REP.NAME AS "name"
 ,REF_USER_ID AS "user"
 ,REQ.TYPE AS "type"
 ,REQ.CATEGORY AS "cat"
 ,TO_CHAR(REQ.REQ_DATE,''yyyy/MM/dd'') AS "requestDate"
 ,TO_CHAR(REQ.DATA_DATE,''yyyy/MM/dd'') AS "dataDate"
 ,TO_CHAR(REQ.READY_DATE,''yyyy/MM/dd'') AS "readyDate"
 ,REQ.STATUS AS "status"
 ,REP.H_ID AS "profileId"
 ,REP.ID AS "repId"
FROM TBL_REPREQ REQ
 JOIN TBL_REPORT REP ON REQ.REF_REPORT_ID   = REP.ID 
order by  "id" desc';

END FNC_GET_REPORT_ARCHIVE;
--------------------------------------------------------
--  DDL for Function FNC_CURRENCT_RATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_CURRENCT_RATE" (
    INPAR_CUR_ID IN NUMBER )
  RETURN NUMBER
AS
--------------------------------------------------------------------------------
  /*
  Programmer Name:  Rasool.Jahani 
  Editor Name: 
  Release Date/Time:1396/03/22-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description:bargardandan nerkh barabari arz ha.
  */
--------------------------------------------------------------------------------
  var_rate NUMBER;
BEGIN
if(INPAR_CUR_ID = 4) then RETURN 1;
else
  FOR i IN
  (SELECT CHANGE_RATE ,
    DEST_CUR_ID ,
    REL_DATE ,
    SRC_CUR_ID
  FROM TBL_CURRENCY_REL
  WHERE REL_DATE > sysdate -30
  AND SRC_CUR_ID = INPAR_CUR_ID
  and DEST_CUR_ID = 4
  ORDER BY REL_DATE
  )
  LOOP
    IF (i.CHANGE_RATE IS NOT NULL) THEN
      var_rate        := i.CHANGE_RATE;
      RETURN var_rate;
    ELSE
      RETURN 0;
    END IF;
  END LOOP;
  end if;
RETURN 0;
END FNC_CURRENCT_RATE;
--------------------------------------------------------
--  DDL for Function FNC_GET_LEDGER_REPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_LEDGER_REPORT" (
 INPAR_DATE       IN VARCHAR2
 ,INPAR_CURRENCY   IN VARCHAR2
) RETURN VARCHAR2 AS
 VAR_DATE   VARCHAR2(200);
BEGIN /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:
  */
  /*------------------------------------------------------------------------------*/
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

 IF
  ( INPAR_CURRENCY = '*' )
 THEN
  RETURN 'SELECT LEDGER_CODE "id",
  max(NAME) "text",
  max(DEPTH) "level",
  max(PARENT_CODE) "parent",
  sum(BALANCE) "x0",
  ''' ||
  VAR_DATE ||
  '''  "date"
  FROM TBL_LEDGER_ARCHIVE 
where  trunc(eff_date) = to_date(''' ||
  VAR_DATE ||
  ''',''yyyy-mm-dd'')
group by ledger_code
order by ledger_code
 ';
 ELSE
  RETURN 'SELECT LEDGER_CODE "id",
  max(NAME) "text",
  max(DEPTH) "level",
  max(PARENT_CODE) "parent",
  sum(BALANCE) "x0",
  ''' ||
  VAR_DATE ||
  '''  "date"
  FROM TBL_LEDGER_ARCHIVE 
  where ref_cur_id in (' ||
  INPAR_CURRENCY ||
  ') 
and trunc(eff_date) = to_date(''' ||
  VAR_DATE ||
  ''',''yyyy-mm-dd'')
group by ledger_code
order by ledger_code
';
 END IF;

END FNC_GET_LEDGER_REPORT;
--------------------------------------------------------
--  DDL for Function FNC_GET_DASHBOARD_DAILY_REPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_DASHBOARD_DAILY_REPORT" 
  RETURN VARCHAR2
AS
--------------------------------------------------------------------------------
  /*
  Programmer Name:  morteza.sahi
  Editor Name: 
  Release Date/Time:1396/05/22-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description: query gozareshe rozane dashboard az jadvale TBL_DASHBOARD_DAILY_REPORT
  */
--------------------------------------------------------------------------------

BEGIN
return'
  SELECT TO_CHAR (DUE_DATE, ''yyyy/mm/dd'', ''nls_calendar=persian'') AS "date",
    IN_FLOW                                                       AS "input",
    OUT_FLOW                                                      AS "output",
    GAP                                                           AS "gap"
  FROM TBL_DASHBOARD_DAILY_REPORT
 where DUE_DATE > sysdate
  ORDER BY DUE_DATE';
END FNC_GET_DASHBOARD_DAILY_REPORT;
--------------------------------------------------------
--  DDL for Function FNC_GET_DASHBOARD_LEDGER_PIE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_DASHBOARD_LEDGER_PIE" RETURN VARCHAR2 AS 
--------------------------------------------------------------------------------
  /*
  Programmer Name:   morteza.sahi
  Editor Name: 
  Release Date/Time:1396/03/22-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description: query az TBL_LEDGER_ARCHIVE bareye arzhaye riali va fagat sath yeke derakht (gozaresh mande daftar kol dashboard)
  */
--------------------------------------------------------------------------------
BEGIN
  RETURN 'SELECT rownum AS "id",
  LEDGER_CODE   as "nodeId",
  NAME  AS "name",
  BALANCE AS "y"
FROM TBL_LEDGER_ARCHIVE
WHERE eff_date =
  (SELECT MAX(eff_date) FROM TBL_LEDGER_ARCHIVE
  )
AND depth      = 1
AND ref_cur_id = 4
order by LEDGER_CODE';
END FNC_GET_DASHBOARD_LEDGER_PIE;
--------------------------------------------------------
--  DDL for Function FNC_GET_LEDGER_DEPTH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_LEDGER_DEPTH" 
(
  INPAR_REPORT_ID IN NUMBER 
)RETURN NUMBER AS 
VAR_REPREQ_ID NUMBER;
VAR_MAXDEPTH NUMBER;
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
BEGIN
   SELECT ID Into VAR_REPREQ_ID FROM TBL_REPREQ where Ref_Report_Id = Inpar_Report_Id ;
   
   SELECT distinct MAX(DEPTH)INTO VAR_MAXDEPTH FROM TBL_REPVAL where Id = Var_Repreq_Id ;
  RETURN VAR_MAXDEPTH;
END FNC_GET_LEDGER_DEPTH;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_SETTING
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_REPORT_SETTING" (
INPAR_REP_ID IN NUMBER
,  INPAR_SHOW_SAYER IN VARCHAR2 
, INPAR_SHOW_MANDE IN VARCHAR2 
, INPAR_LEVELS IN VARCHAR2

) RETURN VARCHAR2 AS 
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
pragma autonomous_transaction;
var_rep_Id number;
BEGIN

select count(*) into var_rep_id from Tbl_Report_Setting where Rep_Id = inpar_rep_id;

if (Var_Rep_Id != 0) then

UPDATE TBL_REPORT_SETTING
SET Show_Sayer=Inpar_Show_Sayer,Show_Mande=Inpar_Show_Mande , Levels = Inpar_Levels where Rep_Id = Inpar_Rep_Id;
Commit;
      RETURN 1;

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
    RETURN 1;
  end if;
END FNC_REPORT_SETTING;
--------------------------------------------------------
--  DDL for Function FNC_DASHBOARD_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_DASHBOARD_PROFILE" return varchar2 as 
--------------------------------------------------------------------------------
  /*
  Programmer Name:  navid
  Editor Name: 
  Release Date/Time:1396/03/22-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description:
  */
--------------------------------------------------------------------------------
begin
  return 'SELECT REF_LEDGER_PROFILE as "ledgerProfileId",
  REF_TIMING_PROFILE as "timingProfileId",
  ID as "id",
  TYPEE as "type"
FROM TBL_DASHBOARD_PROFILE';
end fnc_dashboard_profile;
--------------------------------------------------------
--  DDL for Function FNC_GET_REPORT_SETTING
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_REPORT_SETTING" (
INPAR_REP_ID IN NUMBER

) RETURN VARCHAR2 AS 

BEGIN

return 'SELECT SHOW_SAYER as "sayer", SHOW_MANDE as "mande", LEVELS as "levels" , rep_id as "id" FROM TBL_REPORT_SETTING where  REP_ID  = '||INPAR_REP_ID ;
END FNC_GET_REPORT_SETTING;
--------------------------------------------------------
--  DDL for Function FNC_DASHBOURD_STATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_DASHBOURD_STATE" 
RETURN VARCHAR2 AS 
 /*
  Programmer Name: sobhan sadeghzadeh
  Editor Name:
  Release Date/Time:1396/05/17
  Edit Name:
  Version: 1
  Category:
  Description:
  mande daftar kol be tafkik ostan
  */

BEGIN
  RETURN 'select STATE_ID as "hc-key",NODE_ID  as "nodeId",BALANCE as "value" from TBL_DASHBOaRD_STATE order by "hc-key","nodeId"';
END FNC_DASHBOURD_STATE;
--------------------------------------------------------
--  DDL for Function FNC_GET_DATE_ARCHIVE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_DATE_ARCHIVE" RETURN VARCHAR2 AS 
 --------------------------------------------------------------------------------
  /*
  Programmer Name: Rasool.Jahani
  Editor Name:
  Release Date/Time:1396/05/21-10:00
  Edit Name:
  Version: 1
  Description:bargardandan tarikhhay arshiv dade.
  */
  --------------------------------------------------------------------------------
BEGIN
  RETURN 'SELECT WMSYS.Wm_Concat(to_char(REAL_TIME,''yyyy/mm/dd'',''nls_calendar=persian'')) as "date"
FROM ARCHIVE_RAW_BANK_DATA.TBL_ARCHIVE_DATES@pragg_to_archive 
where EXISTENT = 1';
END FNC_GET_DATE_ARCHIVE;
--------------------------------------------------------
--  DDL for Function FNC_GET_ARCH_AVA_DATES
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_ARCH_AVA_DATES" RETURN VARCHAR2 AS 
--------------------------------------------------------------------------------
  /*
  Programmer Name:  Rasool.Jahani
  Editor Name: 
  Release Date/Time:1396/03/22-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description:Bargardandan tarikh hay mojod baray arshiv
  */
--------------------------------------------------------------------------------
BEGIN
  RETURN 'SELECT 1 as "id" , WMSYS.Wm_Concat(to_char(ARCHIVE_DATE,''yyyy-mm-dd'',''nls_calendar=persian'')) as "date"
FROM ARCHIVE_RAW_BANK_DATA.TBL_ARCHIVE_DATES@pragg_to_archive 
where EXISTENT = 1';
END FNC_GET_ARCH_AVA_DATES;
--------------------------------------------------------
--  DDL for Function FNC_GET_ARCH_REQ_DATES
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_ARCH_REQ_DATES" RETURN VARCHAR2 AS 
--------------------------------------------------------------------------------
  /*
  Programmer Name:  Rasool.Jahani 
  Editor Name: 
  Release Date/Time:1396/03/22-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description:Bargardandan tarikhhayi ke tavasot karbar baray 
              arshiv sabt shode ast.
  */
--------------------------------------------------------------------------------
BEGIN
  RETURN 'SELECT 2 as "id" , WMSYS.Wm_Concat(to_char(ARCHIVE_DATE,''yyyy-mm-dd'',''nls_calendar=persian'')) as "date"
FROM ARCHIVE_RAW_BANK_DATA.TBL_ARCHIVE_DATES@pragg_to_archive 
';
END FNC_GET_ARCH_REQ_DATES;
--------------------------------------------------------
--  DDL for Function FNC_GET_QUERY_DASHBOARD_GAP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_QUERY_DASHBOARD_GAP" RETURN VARCHAR2
 AS 
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name:  morteza.sahi 
  Editor Name: 
  Release Date/Time:1396/05/18-10:00
  Edit Name: 
  Version: 1
  Category:2
  Description:gozareshe shekaf riali ke dar inja be ezaye profile zamani va daftar koli ke entekhab shode 
  vorodi va khorogi  hara mohasebe va be samt js ferestade mishavad a dar anja az han kam mishavand
  */
/*------------------------------------------------------------------------------*/
BEGIN
 RETURN 'SELECT PERIODID AS "PeriodId",
  VALUE_IN      AS "value",
  NAME          AS "name",
  ''1''           AS "type"
FROM TBL_DASHBOARD_GAP_RIALI
UNION
SELECT PERIODID AS "PeriodId",
 abs( VALUE_OUT)     AS "value",
  NAME          AS "name",
  ''2''           AS "type"
FROM TBL_DASHBOARD_GAP_RIALI  '
;
END FNC_GET_QUERY_DASHBOARD_GAP;
--------------------------------------------------------
--  DDL for Function FNC_GET_DASHBOARD_GAP_STATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_DASHBOARD_GAP_STATE" RETURN VARCHAR2
 AS 
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name:  morteza.sahi
  Editor Name: 
  Release Date/Time:1396/03/22-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description: query gozareshe shekaf ostani az TBL_DASHBOARD_GAP_STATE
  */
/*------------------------------------------------------------------------------*/
BEGIN
  /****** be dalil darkhast bachehaye js (javid)  maghadir baraye har ostan ba code sabete oon ostan dade shode
  ke bareye in kar  majbor shodim az jadval TBL_DASHBOARD_GAP_STATE be sorat PIVOT select begirim  ******/
 RETURN 'select "name" ,"periodId","type",sysdate "date","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31" from (
SELECT *
FROM
  (SELECT STATE_CODE,
    abs(VALUE_OUT) as VALUE_OUT,
    PERIOD_NAME as "name",
    PERIOD_ID as "periodId",
    2 as "type"
  FROM TBL_DASHBOARD_GAP_STATE
  WHERE VALUE_in                        IS NULL
  ) PIVOT ( MAX(VALUE_OUT) FOR STATE_CODE IN ( 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31) )
  )
union
select "name" ,"periodId","type",sysdate "date","1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31" from (
SELECT *
FROM
  (SELECT STATE_CODE,
    abs(VALUE_in) as VALUE_in,
    PERIOD_NAME as "name",
    PERIOD_ID as "periodId",
    1 as "type"
  FROM TBL_DASHBOARD_GAP_STATE
  WHERE VALUE_out                        IS NULL
  ) PIVOT ( MAX(VALUE_in) FOR STATE_CODE IN ( 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31) )
  )  order by "name" desc
'
;
END FNC_GET_DASHBOARD_GAP_STATE;
--------------------------------------------------------
--  DDL for Function FNC_GET_USERS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_USERS" RETURN VARCHAR2 AS 
BEGIN
--------------------------------------------------------------------------------
  /*
  Programmer Name:  
  Editor Name: 
  Release Date/Time:1396/03/22-15:00
  Edit Name: 
  Version: 1
  Category:2
  Description:
  */
--------------------------------------------------------------------------------
  return 'select ID as "id", NAME as "name",USERNAME as "username", EMAIL "email" from tbl_users where DELETE_DATE is null';

  
END FNC_GET_USERS;
--------------------------------------------------------
--  DDL for Function FNC_GET_LEDGER_AVA_DATES
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_LEDGER_AVA_DATES" 
RETURN varchar2 AS
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
BEGIN
  RETURN 'SELECT 1 as "id" , WMSYS.Wm_Concat(to_char(EFF_DATE,''yyyy/mm/dd'',''nls_calendar=persian'')) as "date"
FROM (select distinct EFF_DATE from  TBL_LEDGER_ARCHIVE)';
END FNC_GET_LEDGER_AVA_DATES;
--------------------------------------------------------
--  DDL for Function FNC_PAGE_NUMBER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_PAGE_NUMBER" 
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
  INAPR_PAGE_SIZE IN NUMBER ,
 INPAR_QUERY IN VARCHAR2 
) RETURN varchar2 AS 
 LOC_QUERY VARCHAR2(4000);
 LOC_CNT varchar2(4000);
BEGIN
 -- LOC_QUERY :='SELECT FLOOR((COUNT(*)/'|| INAPR_PAGE_SIZE ||')+1)  FROM ('||INPAR_QUERY||')';
  LOC_QUERY :='select count(*) from('||INPAR_QUERY||')';
  EXECUTE IMMEDIATE LOC_QUERY INTO LOC_CNT;
  RETURN LOC_CNT;
END FNC_PAGE_NUMBER;
--------------------------------------------------------
--  DDL for Function FNC_PAGE_NUMBER2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_PAGE_NUMBER2" 
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
--  DDL for Function FNC_PAGING_QUERY2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_PAGING_QUERY2" 
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
--  DDL for Function FNC_PAGE_NUMBER_CUSTOMER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_PAGE_NUMBER_CUSTOMER" 
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
--  DDL for Function FNC_PAGING_QUERY_CUSTOMER
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_PAGING_QUERY_CUSTOMER" 
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
--  DDL for Function FNC_GET_QUERY_FORMULA_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_QUERY_FORMULA_PROFILE" 
(
  inpar_type in varchar2 
) return varchar2 as 
begin
  return 'SELECT ID as "id",
 
  NAME as "name",
  description as "des"
FROM TBL_LEDGER_report_map
where   upper(standard_type) =upper('''||INPAR_TYPE||''')';
end fnc_get_query_formula_profile;
--------------------------------------------------------
--  DDL for Function FNC_FARSIVALIDATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_FARSIVALIDATE" (str nvarchar2)
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
--  DDL for Function FNC_GET_LEDGER_SENS_REPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_LEDGER_SENS_REPORT" (
  inpar_ledger_profile in varchar2
  , inpar_date in varchar2
  , INPAR_CURRENCY in varchar2
) return varchar2 as
begin
  
return 'select  det.CODE as "code" ,max(det.REF_LEDGER_PROFILE) as "ledgerProfile",max(det.NAME) as "name",max(le.eff_date) as "date",
max(det.PARENT_CODE) as "parentCode", max(det.DEPTH) as "depth",sum(le.BALANCE) as "balance"
from TBL_LEDGER_PROFILE_DETAIL det left JOIN TBL_LEDGER_ARCHIVE le
on det.code = le.LEDGER_CODE
where det.REF_LEDGER_PROFILE = '||inpar_ledger_profile||' and trunc(le.eff_date) = to_date('''||INPAR_DATE||''') and le.ref_cur_id in ('||INPAR_CURRENCY||')
group by det.code
order by det.code';



end fnc_get_ledger_sens_report;
--------------------------------------------------------
--  DDL for Function FNC_LEDGER_SENS_GET_QUERY_DATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_LEDGER_SENS_GET_QUERY_DATE" (VAR VARCHAR2 )
  RETURN VARCHAR2
AS
  VAR_QUERY VARCHAR2(3000);
BEGIN
  VAR_QUERY := VAR;
  VAR_QUERY := 'SELECT  WMSYS.Wm_Concat(to_char( "date",''yyyy/mm/dd'',''nls_calendar=persian'')) as "date"
FROM  (SELECT distinct 
EFF_DATE "date"
FROM TBL_LEDGER_ARCHIVE)';
  RETURN VAR_QUERY;
END fnc_ledger_sens_get_query_date;
--------------------------------------------------------
--  DDL for Function FNC_LEDGER_SENS_GET_REPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_LEDGER_SENS_GET_REPORT" (
    inpar_ledger_profile IN VARCHAR2 ,
    inpar_date           IN VARCHAR2 ,
    INPAR_CURRENCY       IN VARCHAR2 )
  RETURN VARCHAR2
AS
BEGIN
  RETURN 'select  det.CODE as "code" ,max(det.REF_LEDGER_PROFILE) as "ledgerProfile",max(det.NAME) as "name",max(le.eff_date) as "date",
max(det.PARENT_CODE) as "parentCode", max(det.DEPTH) as "depth",sum(le.BALANCE) as "balance"
from TBL_LEDGER_PROFILE_DETAIL det left JOIN TBL_LEDGER_ARCHIVE le
on det.code = le.LEDGER_CODE
where det.REF_LEDGER_PROFILE = '||inpar_ledger_profile||' and trunc(le.eff_date) = to_date('''||INPAR_DATE||''') and le.ref_cur_id in ('||INPAR_CURRENCY||')
group by det.code
order by det.code';
END fnc_ledger_sens_get_report;
--------------------------------------------------------
--  DDL for Function TEST_HOSSEIN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."TEST_HOSSEIN" 
  RETURN VARCHAR2
AS

BEGIN
              
              
              
              return 'asdasdas';

END test_hossein;
--------------------------------------------------------
--  DDL for Function TEST_HOSSEIN2
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."TEST_HOSSEIN2" 
  RETURN VARCHAR2
AS

BEGIN
  return 'asdasdas';

END test_hossein2;
--------------------------------------------------------
--  DDL for Function FNC_GET_REPORT_LEDGER_BRANCH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_GET_REPORT_LEDGER_BRANCH" ( INPAR_BRANCH IN VARCHAR2 ) RETURN VARCHAR2 AS
 VAR_MAX_DATE   DATE;
BEGIN
 SELECT
  MAX(EFF_DATE)
 INTO
  VAR_MAX_DATE
 FROM TBL_LEDGER_BRANCH;

 RETURN '
select LEDGER_CODE "id",NAME "text",DEPTH "level",PARENT_CODE "parent",sum(BALANCE) "x0" from TBL_LEDGER_BRANCH
where EFF_DATE= to_date(''' ||
 VAR_MAX_DATE ||
 ''') and REF_BRANCH in(' ||
 INPAR_BRANCH ||
 ')
group by LEDGER_CODE,NAME,DEPTH,PARENT_CODE order by LEDGER_CODE
';
END FNC_GET_REPORT_LEDGER_BRANCH;
--------------------------------------------------------
--  DDL for Function FNC_TEST_DELAY
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."FNC_TEST_DELAY" return number AS 
BEGIN

  dbms_lock.sleep(60);
  return 0;
  
END fnc_TEST_DELAY;
--------------------------------------------------------
--  DDL for Function SQUIRREL_GET_ERROR_OFFSET
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "PRAGG"."SQUIRREL_GET_ERROR_OFFSET" (query IN varchar2) return number authid current_user is      l_theCursor     integer default dbms_sql.open_cursor;      l_status        integer; begin          begin          dbms_sql.parse(  l_theCursor, query, dbms_sql.native );          exception                  when others then l_status := dbms_sql.last_error_position;          end;          dbms_sql.close_cursor( l_theCursor );          return l_status; end; 
