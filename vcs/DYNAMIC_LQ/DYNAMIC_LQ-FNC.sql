--------------------------------------------------------
--  DDL for Function FNC_GET_REPORT_ARCHIVE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_GET_REPORT_ARCHIVE" RETURN VARCHAR2 AS 
 --------------------------------------------------------------------------------
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:1396/10/4
  Edit Name:
  Version: 1
  Description:namayeshe archive gozareshate sakhte shode va tamam shode
  */
  --------------------------------------------------------------------------------

BEGIN

return 
'select a.*,TO_CHAR(TO_DATE(b."createdData",''DD-MON-YY'', ''NLS_DATE_LANGUAGE = English''),''yyyy/MM/dd'') as "createdData" from (

SELECT
  REQ.ID AS "id"
 ,REQ.NAME AS "name"
 ,REF_USER_ID AS "user"
 ,REQ.TYPE AS "type"
 ,REQ.CATEGORY AS "cat"
 ,TO_CHAR(REQ.REQ_DATE,''yyyy/MM/dd'') AS "requestDate"
 ,REQ.STATUS AS "status"
 ,REQ.REPORT_ID AS "repId"
 ,REQ.ORIGINAL_ID
FROM TBL_REP_REQ REQ 
where
 req.is_finish=1 
order by  "id" desc

)a join (select id,max(created) as "createdData" from reports where type=100
group by id)b
on
b.id=a.ORIGINAL_ID';
END FNC_GET_REPORT_ARCHIVE;
--------------------------------------------------------
--  DDL for Function FNC_GET_REPORT_LIST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_GET_REPORT_LIST" 
(
   inpar_TYPE IN VARCHAR2 -- number 107,103,......
  
) RETURN VARCHAR2 AS 
outpar_var varchar2(4000);
BEGIN
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: queri profile ke marbut be ettelaate namayesh dade shode bar ruye karthaye profile gozareshat  mibashad 
  */
  /*------------------------------------------------------------------------------*/

  outpar_var:='select id as "id",name as "name",DES as "des",CREATED as "createDate",CREATEDBY as "createBy" from  reports where   type='||''''||inpar_TYPE||''''||' order by CREATED '; 

   return outpar_var;

END ;
--------------------------------------------------------
--  DDL for Function FNC_GET_REPORT_PROFILE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_GET_REPORT_PROFILE" ( INPAR_ID IN NUMBER ) RETURN VARCHAR2 AS
 OUTPAR     VARCHAR2(4000);
BEGIN
--------------------------------------------------------------------------------
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:1396
  Edit Name:
  Version: 1
  Category:
  Description: queri maghadire profile gozaresht
  */
--------------------------------------------------------------------------------


 OUTPAR   := 'select 
ID                  as "id",
NAME                as "name",
DES                 as "description",
CREATED         as "createDate",
CREATEDBY            as "user",
(select h_id from pragg.tbl_ledger_profile where id in (select LEDGER_PROFILE_ID from reports where id = '||INPAR_ID||') ) as "ledgerProfileId",
(select h_id from pragg.TBL_TIMING_PROFILE where id in (select TIMING_PROFILE_ID from reports where id = '||INPAR_ID||') ) as "dateProfileId",
( select tp.type from reports r,pragg.tbl_timing_profile tp where r.id = '||INPAR_ID||' and tp.id=r.TIMING_PROFILE_ID) as "dateType",
(select h_id from pragg.TBL_PROFILE where id in (select BRANCH_PROFILE_ID from reports where id = '||INPAR_ID||') ) as "branchProfileId",
 (select h_id from pragg.TBL_PROFILE where id in (select CUR_PROFILE_ID from reports where id = '||INPAR_ID||') ) as "currencyProfileId",
 (select h_id from pragg.TBL_PROFILE where id in (select DEPOSIT_PROFILE_ID from reports where id = '||INPAR_ID||') ) as "depositProfileId",
 (select h_id from pragg.TBL_PROFILE where id in (select TASHILAT_PROFILE_ID from reports where id = '||INPAR_ID||') ) as "loanProfileId"
 from reports where id='||INPAR_ID||'';
 RETURN OUTPAR;
END FNC_GET_REPORT_PROFILE;
--------------------------------------------------------
--  DDL for Function FNC_REPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_REPORT" (
    INPAR_REPORT_ID IN NUMBER ,
    INPAR_NODE_ID   IN VARCHAR2)--1 leaf  |||||  0 parent
  RETURN VARCHAR2
AS
    var_req   NUMBER;

BEGIN
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: ???????????????????????
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
--  Description: ???????????????????????????????
*/
  /*------------------------------------------------------------------------------*/
  


select max(id) into var_req from TBL_REP_REQ where REPORT_ID = INPAR_REPORT_ID;

RETURN 'SELECT mande,
  EFF_DATE,
  DATA_TYPE
FROM TBL_VALUE_TEMP
WHERE TBL_VALUE_TEMP.NODE_ID = '||INPAR_NODE_ID||'
AND req_id                   = '||var_req||'
AND data_type                = 1
AND EFF_DATE BETWEEN TO_CHAR(SYSDATE,''j'')-365 AND TO_CHAR(SYSDATE,''j'')
UNION ALL
SELECT mande,EFF_DATE,DATA_TYPE FROM TBL_VALUE_TEMP WHERE REQ_ID ='||var_req||' AND DATA_TYPE = 3 AND NODE_ID = '||INPAR_NODE_ID||'
UNION ALL
SELECT mande,
  EFF_DATE,
  DATA_TYPE
FROM TBL_VALUE_TEMP
WHERE TBL_VALUE_TEMP.NODE_ID = '||INPAR_NODE_ID||'
AND req_id                   = '||var_req||'
AND data_type                = 0
AND EFF_DATE BETWEEN TO_CHAR(SYSDATE,''j'')-365 AND TO_CHAR(SYSDATE,''j'')';
END FNC_REPORT;
--------------------------------------------------------
--  DDL for Function FNC_GET_DETAIL_TIMING
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_GET_DETAIL_TIMING" 
(
  inpar_ref_repreq IN VARCHAR2 
) RETURN VARCHAR2 AS 
--------------------------------------------------------------------------------
  /*
  Programmer Name:  sobhan.sadeghzadeh 
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description:bar asas gozaresh entekhab shode etelaate profile zamani ke entekhab karde ra bar migardanad
  id , name va color  baze haye zamani ra bar migardanad
  */
--------------------------------------------------------------------------------
var_timing number;
BEGIN
select TIMING_PROFILE_ID into var_timing from REPORTS where id =(select REPORT_ID from TBL_REP_REQ where ID = inpar_ref_repreq);

  RETURN '  SELECT
 ID "value"
 ,PERIOD_NAME "header"
  ,PERIOD_COLOR "color"
FROM PRAGG.TBL_TIMING_PROFILE_DETAIL where REF_TIMING_PROFILE ='||var_timing||'';
END FNC_GET_DETAIL_TIMING;
--------------------------------------------------------
--  DDL for Function FNC_GET_DETAIL_TIMING_GAP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_GET_DETAIL_TIMING_GAP" (
  inpar_ref_repreq IN VARCHAR2 
) RETURN VARCHAR2 AS 
--------------------------------------------------------------------------------
  /*
  Programmer Name:  sobhan.sadeghzadeh
  Editor Name: 
  Release Date/Time:1396/09/7
  Edit Name: 
  Version: 1
  Category:2
  Description:bar asas gozaresh entekhab shode etelaate profile zamani ke entekhab karde ra bar migardanad
   id , name va color  baze haye zamani ra bar migardanad
  */
--------------------------------------------------------------------------------
var_timing number;
BEGIN
select TIMING_PROFILE_ID into var_timing from REPORTS where id =(select REPORT_ID from TBL_REP_REQ where ID = inpar_ref_repreq);

  RETURN '  SELECT
 ID "value"
 ,PERIOD_NAME "header"
  ,PERIOD_COLOR "color"
FROM PRAGG.TBL_TIMING_PROFILE_DETAIL where REF_TIMING_PROFILE ='||var_timing||'';
END FNC_GET_DETAIL_TIMING_GAP;
--------------------------------------------------------
--  DDL for Function FNC_GET_QUERY_GAP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_GET_QUERY_GAP" 
(
  INPAR_REF_REG_ID IN NUMBER,
  inpar_branch_id  IN NUMBER
) RETURN clob AS
var clob;
var_x_timing_detail_1 varchar2(4000);
var_x_timing_detail varchar2(4000);
INPAR_REPORT_ID number;
var_TIMING_PROFILE_ID number;
var_temp clob;
var_type number;
BEGIN
 /*
  Programmer Name:  Sobhan.Sadeghzade 
  Editor Name: 
  Release Date/Time:
  Edit Name: 
  Version: 1
  Category:2
  Description: mohasebe shekaf baraye sath 1 daftar kol
  
  */

select report_id into INPAR_REPORT_ID from tbl_rep_req where id=INPAR_REF_REG_ID;
select TYPE into var_type from reports where id=INPAR_REPORT_ID;
select TIMING_PROFILE_ID into var_TIMING_PROFILE_ID from reports where id=INPAR_REPORT_ID;

    SELECT
  WMSYS.WM_CONCAT( (
   SELECT
    ' "x' ||
    REPLACE(ID,' ','_') ||
    '"'
   FROM DUAL
  ) )
   into var_x_timing_detail
 FROM pragg.TBL_TIMING_PROFILE_DETAIL
 WHERE ref_timing_profile=var_TIMING_PROFILE_ID;

    SELECT
  WMSYS.WM_CONCAT( (
   SELECT
    ' sum( "x' ||
    REPLACE(ID,' ','_') ||
    '")'
   FROM DUAL
  ) )
   into var_x_timing_detail_1
 FROM pragg.TBL_TIMING_PROFILE_DETAIL
 WHERE ref_timing_profile=var_TIMING_PROFILE_ID;
 
if(var_type=170) then
select fnc_get_dynamic_gap(INPAR_REF_REG_ID) into var_temp from dual;
elsif(var_type=180) then
select FNC_DYNAMIC_GAP_LED_BRANCH (INPAR_REF_REG_ID,inpar_branch_id) into var_temp from dual;
end if;

var:='select '||var_x_timing_detail_1||' from (select * from ('||var_temp||')where "level"=1)';

return var;
END FNC_GET_QUERY_GAP;
--------------------------------------------------------
--  DDL for Function FNC_GET_QUERY_REPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_GET_QUERY_REPORT" ( INPAR_REF_REPREQ IN VARCHAR2 ) RETURN VARCHAR2 AS 
   /*------------------------------------------------------------------------------*/
  /*
  Programmer Name:  morteza.sahi 
  Editor Name: 
  Release Date/Time:1396/05/18-11:00
  Edit Name: sobhan.sadeghzadeh
  Version: 1
  Category:2
  Description: query namayesh derakht dar nemudar jadvali gozareshat  
  */--107,109,104,106
/*------------------------------------------------------------------------------*/

 OUTPAR_REF_REPREQ    VARCHAR2(4000);
 VAR_REF_REPORT_ID    NUMBER;
 VAR_LEDGER_ID        NUMBER;
 VAR_TIMING           VARCHAR2(1000);
 VAR_TIMING1          VARCHAR2(1000);
 VAR_PROFILE_TIMING   NUMBER;
 var_type             NUMBER;
 var_max_level        number;
 max_eff_date number; -- faghat baraye daftarkol 107

BEGIN
 SYS.DBMS_OUTPUT.ENABLE(3000000);
 /****** peyda kardane gozaresh entekhab shode ******/
 /****** peyda kardane profile zamani entekhab shode baraye select nahaee ******/
 SELECT
  REPORT_ID
 INTO
  VAR_REF_REPORT_ID
 FROM TBL_REP_REQ
 WHERE ID   = INPAR_REF_REPREQ;

 SELECT
  LEDGER_PROFILE_ID
 INTO
  VAR_LEDGER_ID
 FROM REPORTS
 WHERE ID   = VAR_REF_REPORT_ID;

 SELECT
  TIMING_PROFILE_ID
 INTO
  VAR_PROFILE_TIMING
 FROM REPORTS
 WHERE ID   = VAR_REF_REPORT_ID;
 
  SELECT
  type
 INTO
  VAR_type
 FROM REPORTS
 WHERE ID   = VAR_REF_REPORT_ID;
 
 
 select max(eff_date)  into max_eff_date from dynamic_lq.daftar_kol; --faghat baraye daftarkol 107
 
 
 select max(depth) into var_max_level from PRAGG.TBL_LEDGER_PROFILE_DETAIL where ref_ledger_profile=VAR_LEDGER_ID;
 

select 
 (select  listagg(id||' AS "x'||id||'"',',') within group (order by id)  from (
select id from(
  SELECt id,max(PERIOD_NAME)
 FROM PRAGG.TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = VAR_PROFILE_TIMING 
GROUP BY id order by id) order by id))
into VAR_TIMING from dual ;
 /****** peyda kardane esme profile zamani entekhab shode baraye select nahaee ******/


 select 
 (select  listagg(' "x'||id||'"',',') within group (order by id)  from (
select id from(
  SELECt id,max(PERIOD_NAME)
 FROM PRAGG.TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = VAR_PROFILE_TIMING 
GROUP BY id order by id) order by id))
into VAR_TIMING1 from dual ;

-------------------------------------------------------------------------------------------------------
 if (VAR_type =104) then ----------------- type-deposit 

select
'
select a.*,nvl(b."mande",0) as "mande" from (

select "id","text",' || VAR_TIMING1 ||' from (
select * from (

select
max(REQ_ID) as req_id,
REF_TIMING as REF_REPPER_ID,
sum(mande) as value ,
max(dt.name) as "text",
dt.ref_deposit_type as "id"
from (
select 
tbl_value.req_id,
tbl_value.REF_TIMING,
tbl_value.eff_date,
tbl_value.mande,
tbl_value.SEPORDE_TYPE
from 
tbl_value ,(
select ref_timing,max(eff_date) as eff_date from tbl_value where req_id=' || INPAR_REF_REPREQ ||' group by ref_timing
)b
where tbl_value.req_id=' || INPAR_REF_REPREQ ||' and tbl_value.REF_TIMING=b.REF_TIMING and tbl_value.eff_date=b.eff_date 
)v
right outer join (select * from pragg.tbl_deposit_type) dt
on
dt.REF_DEPOSIT_TYPE=v.SEPORDE_TYPE
group by dt.REF_DEPOSIT_TYPE,v.REF_TIMING

)
PIVOT  (max(nvl(VALUE,0))  FOR (REF_REPPER_ID) IN(' ||VAR_TIMING ||') )
ORDER BY "id")

) a left outer join 
(select SEPORDE_TYPE,sum(mande) as "mande"  from SEPORDE_TYPE_MANDE where eff_date=(select max(eff_date) from SEPORDE_TYPE_MANDE)  group by SEPORDE_TYPE)b
on a."id"=b.SEPORDE_TYPE 
order by a."id"'
 into  OUTPAR_REF_REPREQ
 FROM DUAL;

 RETURN OUTPAR_REF_REPREQ;

end if;
--------------------------------------------------------------------------
 if (VAR_type =106) then ----------------- type-tashilat

select
'
select a.*,nvl(b."mande",0) as "mande" from (

select "id","text",' || VAR_TIMING1 ||' from (
select * from (

select
max(REQ_ID) as req_id,
REF_TIMING as REF_REPPER_ID,
sum(mande) as value ,
max(dt.name) as "text",
dt.REF_LOAN_TYPE as "id"
from (
select 
tbl_value.req_id,
tbl_value.REF_TIMING,
tbl_value.eff_date,
tbl_value.mande,
tbl_value.TASHILAT_TYPE
from 
tbl_value ,(
select ref_timing,max(eff_date) as eff_date from tbl_value where req_id=' || INPAR_REF_REPREQ ||' group by ref_timing
)b
where tbl_value.req_id=' || INPAR_REF_REPREQ ||' and tbl_value.REF_TIMING=b.REF_TIMING and tbl_value.eff_date=b.eff_date 
)v
right outer join (select * from PRAGG.TBL_LOAN_TYPE) dt
on
dt.REF_LOAN_TYPE=v.TASHILAT_TYPE
group by dt.REF_LOAN_TYPE,v.REF_TIMING

)
PIVOT  (max(nvl(VALUE,0))  FOR (REF_REPPER_ID) IN(' ||VAR_TIMING ||') )
ORDER BY "id")

) a left outer join 
(select TASHILAT_TYPE,sum(mande) as "mande"  from TASHILAT_TYPE_MANDE where eff_date=(select max(eff_date) from TASHILAT_TYPE_MANDE)  group by TASHILAT_TYPE)b
on a."id"=b.TASHILAT_TYPE 
order by a."id"'
 into  OUTPAR_REF_REPREQ
 FROM DUAL;

 RETURN OUTPAR_REF_REPREQ;

end if;





----------------------------------------------------------------------------------------------------------

 if (VAR_type =109) then ----------------- zud bardasht - rosub seporde
 
 select  
'select a.*,b."mande",'||var_max_level||' as "maxLevel"  from (
select "id","parent","text",' ||
  VAR_TIMING1 ||
  ',"level" from (
select ref_ledger_profile,"id","parent","text",' ||
  VAR_TIMING1 ||
  ',"level" from
(
SELECT *
FROM   (  SELECT
 max(REQ_ID) as REQ_ID
 ,a.CODE as "id"
 ,sum(MANDE) as value
 ,REF_TIMING as REF_REPPER_ID
 ,max(a.DEPTH) as "level"
 ,max(a.PARENT_CODE) as "parent"
 ,max(a.name)  as "text"
 ,max(a.ref_ledger_profile) as ref_ledger_profile
FROM 
 (select 
tbl_value.req_id,
tbl_value.REF_TIMING,
tbl_value.eff_date,
tbl_value.mande,
tbl_value.branch_id ,
tbl_value.node_id
from 
tbl_value ,(
select ref_timing,max(eff_date) as eff_date from tbl_value where req_id=' || INPAR_REF_REPREQ ||' group by ref_timing
)b
where tbl_value.req_id=' || INPAR_REF_REPREQ ||' and tbl_value.REF_TIMING=b.REF_TIMING and tbl_value.eff_date=b.eff_date   
) v
right join (select * from PRAGG.TBL_LEDGER_PROFILE_DETAIL where ref_ledger_profile='||VAR_LEDGER_ID ||' )a
 on 
      v.REQ_ID =' || INPAR_REF_REPREQ ||'
  and a.CODE = v.NODE_ID
group by a.CODE,v.REF_TIMING)
PIVOT  (max(nvl(VALUE,0))  FOR (REF_REPPER_ID) IN(' ||
  VAR_TIMING ||
  '))
ORDER BY "id")
) where ref_ledger_profile='||VAR_LEDGER_ID ||' order by "id" 
) a left outer join 
(select ledger_code,sum(BALANCE) as "mande"  from PRAGG.TBL_LEDGER_ARCHIVE where eff_date=(select max(eff_date) from PRAGG.TBL_LEDGER_ARCHIVE)  group by LEDGER_CODE)b
on a."id"=b.ledger_code '
 into  OUTPAR_REF_REPREQ
 FROM DUAL;
 
 RETURN OUTPAR_REF_REPREQ;
 
 end if;
 
----------------------------------------------------------------------------------------------------------------- 
--elsif( VAR_type =103) then

 if (VAR_type =107) then ----------------- zud bardasht - rosub seporde
select  
'
select a.*,b."mande" from (
select "id","parent","text",' ||
  VAR_TIMING1 ||
  ',"level" from (
select ref_ledger_profile,"id","parent","text",' ||
  VAR_TIMING1 ||
  ',"level" from
(
SELECT *
FROM   (  SELECT
 max(REQ_ID) as REQ_ID
 ,a.CODE as "id"
 ,sum(MANDE) as value
 ,REF_TIMING as REF_REPPER_ID
 ,max(a.DEPTH) as "level"
 ,max(a.PARENT_CODE) as "parent"
 ,max(a.name)  as "text"
 ,max(a.ref_ledger_profile) as ref_ledger_profile
FROM 

 (select 
tbl_value.req_id,
tbl_value.REF_TIMING,
tbl_value.eff_date,
tbl_value.mande,
tbl_value.branch_id ,
tbl_value.node_id
from 
tbl_value ,(
select ref_timing,max(eff_date) as eff_date from tbl_value where req_id=' || INPAR_REF_REPREQ ||' group by ref_timing
)b
where tbl_value.req_id=' || INPAR_REF_REPREQ ||' and tbl_value.REF_TIMING=b.REF_TIMING and tbl_value.eff_date=b.eff_date  
) v
right join (select * from PRAGG.TBL_LEDGER_PROFILE_DETAIL where ref_ledger_profile='||VAR_LEDGER_ID ||' )a
 on 
      v.REQ_ID =' || INPAR_REF_REPREQ ||'
  and a.CODE = v.NODE_ID
group by a.CODE,v.REF_TIMING)
PIVOT  (max(nvl(VALUE,0))  FOR (REF_REPPER_ID) IN(' ||
  VAR_TIMING ||
  '))
ORDER BY "id")
) where ref_ledger_profile='||VAR_LEDGER_ID ||' order by "id"
) a left outer join 
(select node_id,sum(mande) as "mande"  from dynamic_lq.daftar_kol where eff_date='||max_eff_date||'  group by node_id)b
on a."id"=b.node_id ORDER BY "id"'
 into  OUTPAR_REF_REPREQ
 FROM DUAL;
 
 RETURN OUTPAR_REF_REPREQ;

end if;

 
 
END FNC_GET_QUERY_REPORT;
--------------------------------------------------------
--  DDL for Function FNC_CURRENCT_RATE_GAP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_CURRENCT_RATE_GAP" 
(
  inpar_rep_req in number,
  INPAR_CUR_ID IN NUMBER
) RETURN VARCHAR2 AS 
var_TIMING_PROFILE_ID number;
var_sysdate number;
var_PERIOD_START number;
var_PERIOD_end number;
var_type_timing_profile  number;
var_ReportId_type1 number;
--var_rate VARCHAR2(4000);
var_report_id number;
pragma autonomous_transaction;
BEGIN

 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: az in prc baraye tabdile arz  ' marja ' dar gozareshat estefade mishavad (faghat baraye data_type=3) 
  meghdare arz marja sakhte shode dar ruz akhar har baze dar jadvale tbl_last_day_arz_rate darj mishavad
  
  meghdare arz marja entekhab shode baraye akharin ruze har baze zamani dar nemudar jadvali 
  */
  /*------------------------------------------------------------------------------*/
  
  EXECUTE IMMEDIATE 'truncate table tbl_last_day_arz_rate';
 -- EXECUTE IMMEDIATE 'truncate table tbl_arz_relation';
  
  select max(id) into  var_ReportId_type1 from reports where type=1 and STATUS=2; 
  select report_id into var_report_id from tbl_rep_req where id=inpar_rep_req;
  commit;

 
 select timing_profile_id into var_TIMING_PROFILE_ID from reports where id=var_report_id;
 select type into var_type_timing_profile from PRAGG.TBL_TIMING_PROFILE where id=var_TIMING_PROFILE_ID; 
 
 


  if(var_type_timing_profile=2) then
  --be dast avardane akharin ruze har baze
 for i in (select * from PRAGG.TBL_TIMING_PROFILE_DETAIL where REF_TIMING_PROFILE=var_TIMING_PROFILE_ID) loop
 
-- select tpd.id,TO_CHAR(TO_DATE(tpd.PERIOD_END),'J'),a.mande from 
--pragg.tbl_timing_profile_detail tpd inner join  
--(select arz_id,mande,eff_date from reports_data where data_type=3 and REPORT_ID=(select max(id) from reports where type=1) and arz_id=1)a 
--on TO_CHAR(TO_DATE(tpd.PERIOD_END),'J')=a.eff_date
--and REF_TIMING_PROFILE=var_TIMING_PROFILE_ID;

 select TO_CHAR(TO_DATE(PERIOD_END),'J')   into var_PERIOD_end   from pragg.TBL_TIMING_PROFILE_DETAIL where id=i.id;
 --akharin ruz har baze dar jadvale tbl_last_day_arz_rate darj mishavad
 insert into tbl_last_day_arz_rate (report_id,ID_TIMING_DETAIL,arz_id,LAST_DAY) values(var_ReportId_type1,i.id,INPAR_CUR_ID,var_PERIOD_end);
 end loop;
--------------------------------------
  else --(var_type_timing_profile=1) then
--be dast avardane akharin ruze har baze
for i in (select * from PRAGG.TBL_TIMING_PROFILE_DETAIL where REF_TIMING_PROFILE=var_TIMING_PROFILE_ID order by id) loop
if(var_sysdate is null) then
 select TO_CHAR(TO_DATE(sysdate),'J') into var_sysdate from dual;
var_PERIOD_START:=var_sysdate;
else
 select TO_CHAR(TO_DATE(sysdate),'J') into var_sysdate from dual;
var_PERIOD_START:=var_PERIOD_end;
end if;
var_PERIOD_end:=var_PERIOD_START+i.PERIOD_DATE;
 --akharin ruz har baze dar jadvale tbl_last_day_arz_rate darj mishavad
 insert into tbl_last_day_arz_rate (report_id,ID_TIMING_DETAIL,arz_id,LAST_DAY) values(var_ReportId_type1,i.id,INPAR_CUR_ID,var_PERIOD_end);
 end loop;
 end if; -- if(var_type_timing_profile=2) then

 commit;
 
--return
--'select a.ID_TIMING_DETAIL as id,b.rate from tbl_last_day_arz_rate a inner join tbl_arz_relation b
--on a.last_day=b.eff_date
--and b.ARZ_ID = a.ARZ_ID order by id';

  if(INPAR_CUR_ID = 4) then --rial
 return 'select ID_TIMING_DETAIL as "id",1 as "rate" from tbl_last_day_arz_rate order by "id"';
 
 else

return
'select a.ID_TIMING_DETAIL as "id",b.rate as "rate" from tbl_last_day_arz_rate a inner join arz_prd_data b
on
a.report_id=b.report_id
and a.last_day=b.eff_date
and a.ARZ_ID=b.ARZ1_ID
and b.data_type=3
and b.arz2_id=4 
and b.report_id='||var_ReportId_type1||' order by "id"';

end if; --  if(INPAR_CUR_ID = 4) then

 
END FNC_CURRENCT_RATE_GAP;
--------------------------------------------------------
--  DDL for Function FNC_GET_QUERY_REPORT_LED_BRANC
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_GET_QUERY_REPORT_LED_BRANC" 
(
  INPAR_REF_REPREQ IN VARCHAR2 
, INPAR_BRANCH_ID IN VARCHAR2 
) RETURN VARCHAR2 AS  
   /*------------------------------------------------------------------------------*/
  /*
  Programmer Name:  sobhan.sadeghzadeh
  Editor Name: 
  Release Date/Time:1396/09/27
  Edit Name: 
  Version: 1
  Category:2
  Description: "model sazi" 
  query namayesh derakht dar nemudar jadvali gozareshati ke shobe darand
  types : 108,103,105
  */
/*------------------------------------------------------------------------------*/

 OUTPAR_REF_REPREQ    VARCHAR2(32000);
 VAR_REF_REPORT_ID    NUMBER;
 VAR_LEDGER_ID        NUMBER;
 VAR_TIMING           VARCHAR2(1000);
 VAR_TIMING1          VARCHAR2(1000);
 VAR_PROFILE_TIMING   NUMBER;
 var_type             NUMBER;
 var_parent           NUMBER;
 var_BRANCH_ID        NUMBER;
 var_cnt number;
 var_max_level number;
 max_eff_date number;
 pragma autonomous_transaction;
BEGIN
 SYS.DBMS_OUTPUT.ENABLE(3000000);
 /****** peyda kardane gozaresh entekhab shode ******/
 /****** peyda kardane profile zamani entekhab shode baraye select nahaee ******/
 
  select max(eff_date)  into max_eff_date from dynamic_lq.daftar_kol_shobe; --faghat baraye daftarkol 107

 
 SELECT
  REPORT_ID
 INTO
  VAR_REF_REPORT_ID
 FROM TBL_REP_REQ
 WHERE ID   = INPAR_REF_REPREQ;

 SELECT
  LEDGER_PROFILE_ID
 INTO
  VAR_LEDGER_ID
 FROM REPORTS
 WHERE ID   = VAR_REF_REPORT_ID;

 SELECT
  TIMING_PROFILE_ID
 INTO
  VAR_PROFILE_TIMING
 FROM REPORTS
 WHERE ID   = VAR_REF_REPORT_ID;
 
  SELECT
  type
 INTO
  VAR_type
 FROM REPORTS
 WHERE ID   = VAR_REF_REPORT_ID;
 
 SELECT BRANCH_PROFILE_ID
INTO var_BRANCH_ID
FROM reports
WHERE id=VAR_REF_REPORT_ID;
 

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
 FROM PRAGG.TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = VAR_PROFILE_TIMING;
 /****** peyda kardane esme profile zamani entekhab shode baraye select nahaee ******/
 
 
 SELECT
  WMSYS.WM_CONCAT( (
--   SELECT
--    '  "x' ||
--    REPLACE(ID,' ','_') ||
--    '"'
--   FROM DUAL
 SELECT
    '  nvl("x' ||
    REPLACE(ID,' ','_') ||
    '",0) as "x'||ID||'"'
   FROM DUAL
  ) )
 INTO
  VAR_TIMING1
 FROM PRAGG.TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = VAR_PROFILE_TIMING;
 /****** ijad kardane select nahaee az TBL_REPVAL ******/
 -----------------------------------------------------------------------------------------------------------------

 
 -------------------------------------------------------------------------------------------------------------------
if (INPAR_BRANCH_ID is not null ) then
  select max(depth) into var_max_level from PRAGG.TBL_LEDGER_PROFILE_DETAIL where ref_ledger_profile=VAR_LEDGER_ID;


select  
'select a.*,b."mande",'||var_max_level||' as "maxLevel" from (

select "id","id" as code,"parent","text",' ||
  VAR_TIMING1 ||
  ',"level" from (
select ref_ledger_profile,"id","parent","text",' ||
  VAR_TIMING1 ||
  ',"level" from
(
SELECT *
FROM   
(  SELECT
  v.REQ_ID 
 ,a.CODE as "id"
 ,v.value as value
 ,v.REF_TIMING as REF_REPPER_ID
 ,a.DEPTH as "level"
 ,a.PARENT_CODE as "parent"
 ,a.name  as "text"
 ,a.ref_ledger_profile as ref_ledger_profile
FROM 
(select max(req_id) as req_id ,sum(mande)as value,eff_date,REF_TIMING,max(BRANCH_ID) as BRANCH_ID,node_id from ( 
 select 
tbl_value.req_id,
tbl_value.REF_TIMING,
tbl_value.eff_date,
tbl_value.mande,
tbl_value.branch_id ,
tbl_value.node_id
from 
tbl_value ,(
select ref_timing,max(eff_date) as eff_date from tbl_value where req_id=' || INPAR_REF_REPREQ ||' group by ref_timing
)b
where tbl_value.req_id=' || INPAR_REF_REPREQ ||' and tbl_value.branch_id= '||INPAR_BRANCH_ID||'  and  tbl_value.REF_TIMING=b.REF_TIMING and tbl_value.eff_date=b.eff_date 
)group by node_id,eff_date,REF_TIMING) v

right join (select * from PRAGG.TBL_LEDGER_PROFILE_DETAIL where ref_ledger_profile='||VAR_LEDGER_ID ||') a
 on 
      v.REQ_ID =' || INPAR_REF_REPREQ ||'
   and v.branch_id='||INPAR_BRANCH_ID||' 
  and a.CODE = v.NODE_ID)
PIVOT  (max(nvl(VALUE,0))  FOR (REF_REPPER_ID) IN(' ||
  VAR_TIMING ||
  '))
ORDER BY "id")
) where ref_ledger_profile='||VAR_LEDGER_ID ||' order by "id"

) a left outer join 
(select node_id,sum(mande) as "mande"  from dynamic_lq.daftar_kol_shobe where SHOBE_ID='||INPAR_BRANCH_ID||' and eff_date='||max_eff_date||'  group by node_id)b
on a.code=b.node_id ORDER BY a.code'
 into  OUTPAR_REF_REPREQ
 FROM DUAL;



 RETURN OUTPAR_REF_REPREQ;
 
 end if;
 --------------------------------------------------------------------------------------------------------------------------------------

 if (INPAR_BRANCH_ID is  null or INPAR_BRANCH_ID='') then
--execute IMMEDIATE 'truncate table TBL_LEDGER_BRANCH';
execute IMMEDIATE 'truncate table tbl_temp';

select count(*) into var_cnt from TBL_LEDGER_BRANCH where req_id=INPAR_REF_REPREQ and ROWNUM<2;
if(var_cnt=0) then 

insert into TBL_LEDGER_BRANCH(
req_id,
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
INPAR_REF_REPREQ,0,0,0,0,null,'ايران',0
);
commit;

execute IMMEDIATE  'begin insert into tbl_temp (id) ('||PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_ID)||');end;';
commit;

for i in (select max(STA_NAME)as STA_NAME ,ref_sta_id from pragg.tbl_branch where BRN_ID in(select id from tbl_temp) group by ref_sta_id) loop  --ostan
insert into TBL_LEDGER_BRANCH(
req_id,
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
INPAR_REF_REPREQ,
i.REF_STA_ID,
0,
0,
i.REF_STA_ID||'00',
0,
i.STA_NAME,
1
); 
commit;
for b in (select max(CITY_NAME) as CITY_NAME,REF_CTY_ID  ,max(REF_STA_ID)as REF_STA_ID,max(STA_NAME) as STA_NAME from pragg.tbl_branch where  REF_STA_ID=i.REF_STA_ID and BRN_ID in(select id from tbl_temp)   group by REF_CTY_ID) loop  --shahr
select distinct(REF_STA_ID)||'00' into var_parent from pragg.tbl_branch where REF_CTY_ID=b.REF_CTY_ID;

insert into TBL_LEDGER_BRANCH(
req_id,
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
INPAR_REF_REPREQ,
b.REF_STA_ID,
b.REF_CTY_ID,
0,
b.REF_STA_ID||b.REF_CTY_ID||0,
var_parent,
b.CITY_NAME,
2
);
commit;

for c in (select * from pragg.tbl_branch where REF_CTY_ID=b.REF_CTY_ID and BRN_ID in(select id from tbl_temp)   order by BRN_ID) loop  --shobe
select node_id into var_parent from TBL_LEDGER_BRANCH where req_id=INPAR_REF_REPREQ and OSTAN_ID=c.REF_STA_ID and SHAHR_ID=c.REF_CTY_ID and shobe_id=0;
insert into TBL_LEDGER_BRANCH(
req_id,
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
INPAR_REF_REPREQ,
c.REF_STA_ID,
c.REF_CTY_ID,
c.BRN_ID,
c.REF_STA_ID||c.REF_CTY_ID||c.BRN_ID,
var_parent,
c.NAME,
3
);
commit;

if(VAR_type!=103 and VAR_type!=105) then 
insert into TBL_LEDGER_BRANCH(
req_id,
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
INPAR_REF_REPREQ,
c.REF_STA_ID,
c.REF_CTY_ID,
c.BRN_ID,
c.BRN_ID||LEDGER_CODE,
c.REF_STA_ID||c.REF_CTY_ID||c.BRN_ID,
NAME,
4,
NODE_TYPE,
LEDGER_CODE
from  tbl_ledger
where  depth=1 
)
;
end if; --if(VAR_type!=103) then 
commit;
end loop; -- loop c
end loop; -- loop b
end loop; -- loop i
end if;-- --if(var_cnt=0) then 
commit;
 select max(depth) into var_max_level from TBL_LEDGER_branch where REQ_ID=INPAR_REF_REPREQ;

 -----------------------------------------------------
 
if(VAR_type =103) then 
 select 
 '
 select a.*,b."mande" from (
 select SHOBE_ID,id,"id","parent","text",'||VAR_TIMING1||',"level",'||''''||var_max_level||''''||' as "maxLevel" from(
select * from (
select 
lb.id,
v.REF_TIMING,
lb.SHOBE_ID ,
lb.NODE_ID as "id",
lb.PARENT as "parent",
lb.NAME as "text",
lb.DEPTH as "level",
nvl(v.value,0) as value
from 

(select sum(mande)as value,eff_date,BRANCH_ID,REF_TIMING from (  
select 
a.REF_TIMING,
a.eff_date,
a.mande,
a.branch_id 
from 
tbl_value a,(
select ref_timing,max(eff_date) as eff_date from tbl_value where req_id='||INPAR_REF_REPREQ||' group by ref_timing
)b
where a.req_id='||INPAR_REF_REPREQ||' and a.REF_TIMING=b.REF_TIMING and a.eff_date=b.eff_date   
)GROUP BY ref_timing,BRANCH_ID,eff_date) v

right join (select * from tbl_ledger_branch where req_id='||INPAR_REF_REPREQ||') lb
on
  v.branch_id=lb.shobe_id
order by id
)
PIVOT  (max(nvl(VALUE,0))  FOR (REF_TIMING) IN (' ||
  VAR_TIMING ||
  '))
ORDER BY id)
) a left outer join 
(select SHOBE_ID,sum(mande) as "mande"  from SEPORDE_SHOBE_MANDE where eff_date=(select max(eff_date) from SEPORDE_SHOBE_MANDE)  group by SHOBE_ID)b
on a.SHOBE_ID=b.SHOBE_ID 
order by a.id'
 INTO
  OUTPAR_REF_REPREQ
 FROM DUAL; 
end if;
-----------------------------------------------------------------------
if(VAR_type =105) then
 select
 '
  select a.*,b."mande" from (
 select SHOBE_ID,id,"id","parent","text",'||VAR_TIMING1||',"level",'||''''||var_max_level||''''||' as "maxLevel" from(
select * from (
select 
lb.id,
v.REF_TIMING,
lb.SHOBE_ID ,
lb.NODE_ID as "id",
lb.PARENT as "parent",
lb.NAME as "text",
lb.DEPTH as "level",
nvl(v.value,0) as value
from 

(select sum(mande)as value,eff_date,BRANCH_ID,REF_TIMING from (  
select 
a.REF_TIMING,
a.eff_date,
a.mande,
a.branch_id 
from 
tbl_value a,(
select ref_timing,max(eff_date) as eff_date from tbl_value where req_id='||INPAR_REF_REPREQ||' group by ref_timing
)b
where a.req_id='||INPAR_REF_REPREQ||' and a.REF_TIMING=b.REF_TIMING and a.eff_date=b.eff_date   
)GROUP BY ref_timing,BRANCH_ID,eff_date) v

right join (select * from tbl_ledger_branch where req_id='||INPAR_REF_REPREQ||') lb
on
  v.branch_id=lb.shobe_id
order by id
)
PIVOT  (max(nvl(VALUE,0))  FOR (REF_TIMING) IN (' ||
  VAR_TIMING ||
  '))
ORDER BY id)

) a left outer join 
(select SHOBE_ID,sum(mande) as "mande"  from tashilat_SHOBE_MANDE where eff_date=(select max(eff_date) from  tashilat_SHOBE_MANDE)  group by SHOBE_ID)b
on a.SHOBE_ID=b.SHOBE_ID 
order by a.id'
 INTO
  OUTPAR_REF_REPREQ
 FROM DUAL; 
end if;



if(VAR_type =108) then ---------------------------------------

 select 

'select a.*,b."mande",4 as "maxLevel" from (

select shobe_id,code,id,"id","parent","text",'||VAR_TIMING1||',"level" from(
select * from (
select 
lb.id,
v.REF_TIMING,
lb.SHOBE_ID ,
lb.NODE_ID as "id",
lb.PARENT as "parent",
lb.NAME as "text",
lb.DEPTH as "level",
lb.code,
v.value
from 
(select sum(mande)as value,eff_date,REF_TIMING,BRANCH_ID,node_id from (  
select 
a.REF_TIMING,
a.node_id,
a.mande,
a.eff_date,
a.branch_id 
from 
tbl_value a,(
select ref_timing,max(eff_date) as eff_date from tbl_value where req_id='||INPAR_REF_REPREQ||' group by ref_timing
)b
where
a.REQ_ID ='||INPAR_REF_REPREQ||' and  a.depth=1 and a.REF_TIMING=b.REF_TIMING and a.eff_date=b.eff_date 
)group by branch_id,node_id,eff_date,REF_TIMING) v

right join (select * from tbl_ledger_branch where req_id='||INPAR_REF_REPREQ||') lb
on
 v.branch_id=lb.shobe_id
and v.node_id=lb.code
order by id
)
PIVOT  (max(nvl(VALUE,0))  FOR (REF_TIMING) IN (' ||
  VAR_TIMING ||
  '))
ORDER BY id)

) a left outer join 
(select shobe_id,node_id,sum(mande) as "mande"  from dynamic_lq.daftar_kol_shobe where  eff_date='||max_eff_date||'  group by node_id,shobe_id)b
on a.code=b.node_id and a.shobe_id=b.shobe_id ORDER BY a.id'
 INTO
  OUTPAR_REF_REPREQ
 FROM DUAL;
 

 ---------------------------------------------------
end if; 

end if;

 RETURN OUTPAR_REF_REPREQ;

 
--  insert into tbl_test (var) values(OUTPAR_REF_REPREQ);
-- commit;
END FNC_GET_QUERY_REPORT_LED_BRANC;
--------------------------------------------------------
--  DDL for Function FNC_GET_QUERY_RESULT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_GET_QUERY_RESULT" (
    inpar_type IN VARCHAR2 ,
    inpar_noe IN VARCHAR2  , 
    inpar_rep_req in number,
    is_gap in number   )
  RETURN VARCHAR2
AS
var_report_id number;
var_BRANCH_ID number;
var varchar2(4000);
--------------------------------------------------------------------------------
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:1396
  Edit Name:
  Version: 1
  Category:
  Description: queri bargardandane shahr ostan shobe  ke dar profile haye entekhab shode tavasote karbar 
  
  in Function baraE bargardandane Item haE profile ha mibashad.ke 
               vorodi inpar_type, noE profile ra moshakhas mikonad. dar profile
               haE seporde va tashilat be dalile inke az 3 ghesmate(mablagh-tarikh
               / nerkh arz / noE) tashkil shode ast in func yek vorodi inpar_no
               ham migirad baraE moshkhas shodan yeki az in 3 ghesmate seporde ya
               tashilat.
  */
-------------------------------------------------------------------------------- 
pragma autonomous_transaction;
BEGIN
--if(upper(inpar_type)!='TBL_CURRENCY' ) then
--execute IMMEDIATE 'truncate table tbl_temp';
if(is_gap=1) then 
--select report_id into var_report_id from tbl_rep_req_gap where id=inpar_rep_req;
select report_id into var_report_id from tbl_rep_req where id=inpar_rep_req;
else
select report_id into var_report_id from tbl_rep_req where id=inpar_rep_req;
end if;
select BRANCH_PROFILE_ID into var_BRANCH_ID from reports where id=var_report_id;
--execute IMMEDIATE  'begin insert into tbl_temp (id) ('||PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_ID)||');end;';
commit;
--end if;

  IF (upper(inpar_type)='TBL_CURRENCY') THEN
      RETURN 'SELECT CUR_ID as "id", CUR_NAME as "curName", SWIFT_CODE as "swiftCode", DES as "des" FROM pragg.TBL_CURRENCY ';
  ELSE
    IF(upper(inpar_type)='TBL_BRANCH' and upper(inpar_noe)='BRANCH') THEN

      RETURN 'select * from (
              SELECT p.STA_NAME "provinceName",                                            
              c.CTY_NAME "cityName",                                            
              p.STA_ID "provinceId",                                            
              c.CTY_ID "cityId",                                            
              s.NAME "label",                                            
              s.BRN_ID "id",
              ''brn_id'' "type"
              FROM pragg.TBL_BRANCH s                                          
              LEFT OUTER JOIN pragg.TBL_CITY c                                          
              ON s.REF_CTY_ID = c.cty_id                                          
              LEFT OUTER JOIN pragg.TBL_STATE p                                          
              ON p.STA_ID = c.REF_STA_ID)
              where "id" in ('||PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_ID)||')';

  Else
    IF(upper(inpar_type)='TBL_BRANCH' and upper(inpar_noe)='CITY')then
--    return '   select * from (
--SELECT distinct(bts.cty_id) "id", bts.cty_name "label", bto.sta_id "provinceId", ''ref_cty_id'' "type"
--          FROM pragg.TBL_CITY bts, pragg.TBL_STATE bto,pragg.TBL_BRANCH bts1 
--          WHERE bts.ref_sta_id = bto.sta_id and bts1.ref_cty_id = bts.cty_id ORDER BY "label"
--          ) where "id" in (select REF_CTY_ID from pragg.tbl_branch where BRN_ID in ( select id from dynamic_lq_tjr.tbl_temp)) ';

    return '   select * from (
SELECT distinct(bts.cty_id) "id", bts.cty_name "label", bto.sta_id "provinceId", ''ref_cty_id'' "type"
          FROM pragg.TBL_CITY bts, pragg.TBL_STATE bto,pragg.TBL_BRANCH bts1 
          WHERE bts.ref_sta_id = bto.sta_id and bts1.ref_cty_id = bts.cty_id ORDER BY "label"
          ) where "id" in (select REF_CTY_ID from pragg.tbl_branch where BRN_ID in ('||PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_ID)||')) ';


  Else
    IF(upper(inpar_type)='TBL_BRANCH' and upper(inpar_noe)='STATE') then
--    return ' select * from (    
--          SELECT distinct(bto.sta_id) "id", bto.sta_name "label",''ref_sta_id'' "type"
--               FROM pragg.TBL_CITY bts, pragg.TBL_STATE bto, pragg.TBL_BRANCH bts1 
--              where  bts.ref_sta_id = bto.sta_id and bts1.ref_cty_id = bts.cty_id ORDER BY "label"
--              )  where "id" in (select REF_STA_ID from pragg.tbl_branch where BRN_ID in ( select id from dynamic_lq_tjr.tbl_temp))';
return ' select * from (    
          SELECT distinct(bto.sta_id) "id", bto.sta_name "label",''ref_sta_id'' "type"
               FROM pragg.TBL_CITY bts, pragg.TBL_STATE bto, pragg.TBL_BRANCH bts1 
              where  bts.ref_sta_id = bto.sta_id and bts1.ref_cty_id = bts.cty_id ORDER BY "label"
              )  where "id" in (select REF_STA_ID from pragg.tbl_branch where BRN_ID in ('||PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_ID)||'))';
              
               END IF;
               END IF;
               END IF;
               END IF;
END FNC_GET_QUERY_RESULT;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_TOTAL_PRE_LEDBRN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_REPORT_TOTAL_PRE_LEDBRN" (
 INPAR_REP_REQ_ID   IN NUMBER
 ,INPAR_NODE_ID      IN VARCHAR2
 ,inpar_branch_id IN NUMBER
)/*1 leaf  |||||  0 parent*/ RETURN VARCHAR2 AS
 VAR_REQ   NUMBER;
 var_shobe_id number;
 var_state_id number;
 var_city_id number;
 var_depth number;
 var_code NUMBER;
 CATEGORY_type number;
 VAR_CREATED_REPORT_DATE NUMBER;
-- 103-105-108
BEGIN
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: TOTAL_PREDICTION  , shobe  //--104-106-107
  */
  /*------------------------------------------------------------------------------*/
select CATEGORY into CATEGORY_type from tbl_rep_req where id=INPAR_REP_REQ_ID;
SELECT TO_CHAR(REQ_DATE,'J') INTO VAR_CREATED_REPORT_DATE FROM tbl_rep_req  where id=INPAR_REP_REQ_ID;
------------------------------------------------------------------------------seleced branch
if(inpar_branch_id is not null ) then --108

RETURN '
select a.*,b."minInt",b."maxInt",b."isActineTunel" from (
select * from(

SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type" 
FROM TBL_VALUE_TEMP
WHERE 
TBL_VALUE_TEMP.branch_id='||inpar_branch_id||' 
and TBL_VALUE_TEMP.NODE_ID = ' || INPAR_NODE_ID || ' 
AND req_id                   = ' || INPAR_REP_REQ_ID || ' 
AND data_type                = 1
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '   
group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type" 
FROM TBL_VALUE_TEMP WHERE
TBL_VALUE_TEMP.branch_id='||inpar_branch_id||' 
and REQ_ID =' ||INPAR_REP_REQ_ID || '
AND DATA_TYPE = 3 
AND NODE_ID = ' ||INPAR_NODE_ID || ' 
group by EFF_DATE 

UNION ALL
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type" 
FROM TBL_VALUE_TEMP
WHERE 
TBL_VALUE_TEMP.branch_id='||inpar_branch_id||' 
and TBL_VALUE_TEMP.NODE_ID = ' || INPAR_NODE_ID ||' AND req_id = ' ||
INPAR_REP_REQ_ID ||' 
AND data_type                = 0
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '   
group by EFF_DATE 
order by "date" desc

)
pivot 
(
max("mande") for "type" in (0,1,3)
)
) a
left join
(select
 to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
sum(round(mande-interval,2)) as "minInt",
sum(round(mande+interval,2)) as "maxInt",max(IS_ACTIVE_TUNEL) as "isActineTunel"
from TBL_VALUE_temp,tbl_rep_req  where req_id=' ||INPAR_rep_req_ID ||' and TBL_VALUE_temp.req_id=tbl_rep_req.id and NODE_ID =  ' ||INPAR_NODE_ID ||' and branch_id='||INPAR_BRANCH_ID||' and data_type=3 group by EFF_DATE)b
on a."date"=b."date" 
order by a."date" ';

-----------------------------------------------------------------------------------------------
ELSIF (inpar_branch_id is  null OR inpar_branch_id='') then 
  select OSTAN_ID,SHAHR_ID,SHOBE_ID,code,DEPTH into var_state_id,var_city_id,var_shobe_id, var_code,var_depth from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and  node_id=INPAR_NODE_ID;

if(CATEGORY_type=103 or CATEGORY_type=105) then  --  deposit_branch

if(var_depth=0) then

RETURN '
select a.*,b."minInt",b."maxInt",b."isActineTunel" from (
select * from(

select "mande","date","type" from (

SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP 
WHERE 

req_id                = ' || INPAR_REP_REQ_ID || ' 
AND data_type             = 1
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '   
group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type" 
FROM TBL_VALUE_TEMP 
WHERE 
req_id                = ' || INPAR_REP_REQ_ID || '
AND DATA_TYPE = 3
group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
 req_id                = ' || INPAR_REP_REQ_ID || '
AND data_type                = 0
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '    
group by EFF_DATE
order by "date" desc) 

order by "date" desc

)
pivot 
(
max("mande") for "type" in (0,1,3)
)
) a
left join
(select
 to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
sum(round(mande-interval,2)) as "minInt",
sum(round(mande+interval,2)) as "maxInt",max(IS_ACTIVE_TUNEL) as "isActineTunel"
from TBL_VALUE_temp,tbl_rep_req  where req_id=' ||INPAR_rep_req_ID ||' and TBL_VALUE_temp.req_id=tbl_rep_req.id  and data_type=3 group by EFF_DATE)b
on a."date"=b."date" 
order by a."date" ';

elsif(var_depth=1) then 
RETURN '
select a.*,b."minInt",b."maxInt",b."isActineTunel" from (
select * from(

select "mande","date","type" from (

SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP 
WHERE 

 TBL_VALUE_TEMP.STATE_ID='||var_state_id||' 
AND req_id                = ' || INPAR_REP_REQ_ID || ' 
AND data_type             = 1
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '   
group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type" 
FROM TBL_VALUE_TEMP 
WHERE 
 TBL_VALUE_TEMP.STATE_ID='||var_state_id||'
AND req_id                = ' || INPAR_REP_REQ_ID || '
AND DATA_TYPE = 3
group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
 TBL_VALUE_TEMP.STATE_ID='||var_state_id||'
AND req_id                = ' || INPAR_REP_REQ_ID || '
AND data_type                = 0
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '    
group by EFF_DATE
order by "date" desc) 

order by "date" desc

)
pivot 
(
max("mande") for "type" in (0,1,3)
)
) a
left join
(select
 to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
sum(round(mande-interval,2)) as "minInt",
sum(round(mande+interval,2)) as "maxInt",max(IS_ACTIVE_TUNEL) as "isActineTunel"
from TBL_VALUE_temp,tbl_rep_req  where req_id=' ||INPAR_rep_req_ID ||' and TBL_VALUE_temp.req_id=tbl_rep_req.id and STATE_ID='||var_state_id||' and data_type=3 group by EFF_DATE)b
on a."date"=b."date" 
order by a."date" ';


elsif(var_depth=2) then 
RETURN '
select a.*,b."minInt",b."maxInt",b."isActineTunel" from (
select * from(

select "mande","date","type" from (

SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP 
WHERE 

 TBL_VALUE_TEMP.CITY_ID='||var_city_id|| '
AND req_id                = ' || INPAR_REP_REQ_ID || ' 
AND data_type             = 1
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '   
group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type" 
FROM TBL_VALUE_TEMP 
WHERE 
 TBL_VALUE_TEMP.CITY_ID='||var_city_id||'
AND req_id                = ' || INPAR_REP_REQ_ID || '
AND DATA_TYPE = 3
group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
 TBL_VALUE_TEMP.CITY_ID='||var_city_id||'
AND req_id                = ' || INPAR_REP_REQ_ID || '
AND data_type                = 0
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '    
group by EFF_DATE
order by "date" desc) 

order by "date" desc

)
pivot 
(
max("mande") for "type" in (0,1,3)
)
) a
left join
(select
 to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
sum(round(mande-interval,2)) as "minInt",
sum(round(mande+interval,2)) as "maxInt",max(IS_ACTIVE_TUNEL) as "isActineTunel"
from TBL_VALUE_temp,tbl_rep_req  where req_id=' ||INPAR_rep_req_ID ||' and TBL_VALUE_temp.req_id=tbl_rep_req.id and CITY_ID='||var_city_id||' and data_type=3 group by EFF_DATE)b
on a."date"=b."date" 
order by a."date" ';

elsif(var_depth=3) then  ---------------------------------
RETURN '
select a.*,b."minInt",b."maxInt",b."isActineTunel" from (
select * from(

select "mande","date","type" from (

SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP 
WHERE 

 TBL_VALUE_TEMP.branch_id='||var_shobe_id||' 
AND req_id                = ' || INPAR_REP_REQ_ID || ' 
AND data_type             = 1
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '   
group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type" 
FROM TBL_VALUE_TEMP 
WHERE 
 TBL_VALUE_TEMP.branch_id='||var_shobe_id||' 
AND req_id                = ' || INPAR_REP_REQ_ID || '
AND DATA_TYPE = 3
group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
 TBL_VALUE_TEMP.branch_id='||var_shobe_id||' 
AND req_id                = ' || INPAR_REP_REQ_ID || '
AND data_type                = 0
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '    
group by EFF_DATE
order by "date" desc) 

order by "date" desc

)
pivot 
(
max("mande") for "type" in (0,1,3)
)
) a
left join
(select
 to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
sum(round(mande-interval,2)) as "minInt",
sum(round(mande+interval,2)) as "maxInt",max(IS_ACTIVE_TUNEL) as "isActineTunel"
from TBL_VALUE_temp,tbl_rep_req  where req_id=' ||INPAR_rep_req_ID ||' and TBL_VALUE_temp.req_id=tbl_rep_req.id and branch_id =  ' ||var_shobe_id ||' and data_type=3 group by EFF_DATE)b
on a."date"=b."date" 
order by a."date" ';

end if;

else  --------------------------------
--109
RETURN '
select * from(

SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP 
WHERE 
TBL_VALUE_TEMP.DEPTH=1 
AND TBL_VALUE_TEMP.branch_id='||var_shobe_id||' 
AND TBL_VALUE_TEMP.NODE_ID='||var_code||'
AND req_id                = ' || INPAR_REP_REQ_ID || ' 
AND data_type             = 1
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '   
group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP 
WHERE 
TBL_VALUE_TEMP.DEPTH=1 
AND TBL_VALUE_TEMP.branch_id='||var_shobe_id||' 
AND TBL_VALUE_TEMP.NODE_ID='||var_code||'
AND req_id                = ' || INPAR_REP_REQ_ID || '
AND DATA_TYPE = 3
group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
TBL_VALUE_TEMP.DEPTH=1 
AND TBL_VALUE_TEMP.branch_id='||var_shobe_id||' 
AND TBL_VALUE_TEMP.NODE_ID='||var_code||'
AND req_id                = ' || INPAR_REP_REQ_ID || '
AND data_type                = 0
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '    
group by EFF_DATE
order by "date" desc 

)
pivot 
(
max("mande") for "type" in (0,1,3)
)
order by "date" ';

end if;--if(CATEGORY_type=103) then  --  deposit_branch
end if;

END FNC_REPORT_TOTAL_PRE_LEDBRN;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_BACK_TEST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_REPORT_BACK_TEST" (
 INPAR_REPreq_ID   IN NUMBER
 ,INPAR_NODE_ID     IN VARCHAR2
 ,INPAR_IS_LEAF     IN VARCHAR2
)/*1 leaf  |||||  0 parent*/
 RETURN VARCHAR2 AS

 VAR_COUNT      NUMBER;
 VAR_COUNT1     NUMBER;
 VAR_NODE_ID    VARCHAR2(30000);
 VAR_MIN_DATE   NUMBER := 0;
 VAR_MAX_DATE   NUMBER := 0;
 var_max_depth  number;
 var_report_id  number;
 var_LEDGER_PROFILE_ID  number;
 var_max_level  number;
 var_category number;
 var_data_types varchar2(4000);
 VAR_MAX_DATE_datatype1 number;
 PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: gozaresh backtest baraye gozareshat daftarkol,seporde noe,tashilat noe
  */
  /*------------------------------------------------------------------------------*/
--107 -106 -104

select report_id into var_report_id from tbl_rep_req where id=INPAR_REPreq_ID;
select LEDGER_PROFILE_ID into var_LEDGER_PROFILE_ID from reports where id=var_report_id ;
select max(depth) into var_max_level from PRAGG.TBL_LEDGER_PROFILE_DETAIL where REF_LEDGER_PROFILE=var_LEDGER_PROFILE_ID ; 

select CATEGORY into var_category from tbl_rep_req where id=INPAR_REPreq_ID;
EXECUTE IMMEDIATE 'truncate table TBL_BACK_TEST_ARCHIVE';

select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp_back_test where req_id=INPAR_REPreq_ID and data_type=1;

if(var_category=107 ) then

select 
 (select  listagg(data_type,',') within group (order by data_type)  from (
select data_type from(
  select distinct(data_type) as data_type from tbl_value_temp_back_test where REQ_Id=INPAR_REPreq_ID  and node_id=INPAR_NODE_ID and EFF_DATE<to_char(sysdate,'j')
GROUP BY data_type ) order by data_type))
into var_data_types from dual ;

 
 IF
  INPAR_IS_LEAF = 1
 THEN
  INSERT INTO TBL_BACK_TEST_ARCHIVE (
   REQ_ID
  ,DATA_TYPE
  ,MIN_DATE
  ,MAX_DATE
  ,NODE_ID
  ) SELECT
   INPAR_REPreq_ID
  ,DATA_TYPE
  ,MAX(MIN)
  ,MIN(MAX)
  ,NODE_ID
  FROM (
    SELECT
     NODE_ID
    ,MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    ,DATA_TYPE
    FROM TBL_VALUE_TEMP_BACK_TEST
    WHERE REQ_ID    = INPAR_REPreq_ID
     AND
      NODE_ID   = INPAR_NODE_ID
    GROUP BY
     NODE_ID
    ,DATA_TYPE
   )
  GROUP BY
   DATA_TYPE
  ,NODE_ID;

  COMMIT;
 ELSE
  FOR I IN (
   SELECT DISTINCT
    DATA_TYPE
   FROM TBL_VALUE_TEMP_BACK_TEST
   WHERE REQ_ID   = INPAR_REPreq_ID
  ) LOOP
   INSERT INTO TBL_BACK_TEST_ARCHIVE (
    REQ_ID
   ,DATA_TYPE
   ,MIN_DATE
   ,MAX_DATE
   ,NODE_ID
   ) SELECT
    INPAR_REPreq_ID
   ,I.DATA_TYPE
   ,MAX(MIN)
   ,MIN(MAX)
   ,INPAR_NODE_ID
   FROM (
     SELECT
      NODE_ID
     ,MIN(EFF_DATE) MIN
     ,MAX(EFF_DATE) MAX
     FROM TBL_VALUE_TEMP_BACK_TEST
     WHERE REQ_ID      = INPAR_REPreq_ID
      AND
       DATA_TYPE   = I.DATA_TYPE /*2457785 2457788*/
      AND
       NODE_ID IN (
SELECT
        ( CODE )
       FROM (
         SELECT DISTINCT
          CODE
         ,DEPTH
         FROM (
           SELECT
            *
           FROM pragg.tbl_ledger_profile_detail where REF_LEDGER_PROFILE=var_LEDGER_PROFILE_ID       ---------------------------------?????????
          )
         START WITH
          PARENT_CODE   = INPAR_NODE_ID
         CONNECT BY
          PRIOR CODE = PARENT_CODE
        )
       WHERE DEPTH   = var_max_level
       )
     GROUP BY
      NODE_ID
    );

  END LOOP;

  COMMIT;
 END IF;

 SELECT
  COUNT(*)
 INTO
  VAR_COUNT
 FROM TBL_BACK_TEST_ARCHIVE
 WHERE MIN_DATE IS NULL
  OR
   MAX_DATE IS NULL;

 SELECT
  COUNT(*)
 INTO
  VAR_COUNT1
 FROM TBL_BACK_TEST_ARCHIVE;

 IF
  ( VAR_COUNT <> 0 OR ( VAR_COUNT1 = 0 AND VAR_COUNT = 0 ) )
 THEN
--  RETURN -1;
  RETURN '
  select * from (
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST WHERE DATA_TYPE=-85

)
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
 
 ELSE
 
  RETURN '
  select * from (
  select  sum("mande") as "mande","date","type" from (
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
  DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
TBL_VALUE_TEMP_BACK_TEST.NODE_ID = ' ||
  INPAR_NODE_ID ||
  ' 
AND req_id              = ' ||
  INPAR_REPreq_ID ||
  ' 
AND data_type              = 1
 AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  

union all

select sum("mande") "mande","date","type" from (

select  tb.mande "mande",
to_char(to_date(tb.EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
tb.DATA_TYPE "type" 
from TBL_VALUE_TEMP_BACK_TEST tb ,TBL_BACK_TEST_ARCHIVE ta 
where 
    tb.NODE_ID = ta.NODE_ID 
    and ta.NODE_ID = ' ||INPAR_NODE_ID ||
  ' and ta.req_id = ' ||INPAR_REPreq_ID ||
  'and ta.req_id =tb.req_id 
   and ta.data_type=tb.data_type 
   and tb.DATA_TYPE not in( 1,0) and 
  tb.EFF_DATE between ta.min_date and ta.max_date
  
)group by "date","type"  
  
union all 
SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
TBL_VALUE_TEMP_BACK_TEST.NODE_ID = ' ||
  INPAR_NODE_ID ||
  ' 
AND req_id              = ' ||
  INPAR_REPreq_ID ||
  ' 
AND data_type              = 0 
 AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
)
group by "date","type"

)
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
 END IF;
 -- AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
---------------------------------------------------------------------------------------------------
elsif(var_category=104) then 

select 
 (select  listagg(data_type,',') within group (order by data_type)  from (
select data_type from(
  select distinct(data_type) as data_type from tbl_value_temp_back_test where REQ_Id=INPAR_REPreq_ID and EFF_DATE<to_char(sysdate,'j')
GROUP BY data_type ) order by data_type))
into var_data_types from dual ;


  INSERT INTO TBL_BACK_TEST_ARCHIVE (
   REQ_ID
  ,DATA_TYPE
  ,MIN_DATE
  ,MAX_DATE
  ,NODE_ID   -- dar inja hamun  "seporde_type"
  ) SELECT
   INPAR_REPreq_ID
  ,DATA_TYPE
  ,MAX(MIN)
  ,MIN(MAX)
  ,SEPORDE_TYPE
  FROM (
    SELECT
     SEPORDE_TYPE
    ,MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    ,DATA_TYPE
    FROM TBL_VALUE_TEMP_BACK_TEST
    WHERE REQ_ID    = INPAR_REPreq_ID
     AND
      SEPORDE_TYPE   = INPAR_NODE_ID   --dar inja hamun  "seporde_type"
    GROUP BY
     SEPORDE_TYPE
    ,DATA_TYPE
   )
  GROUP BY
   DATA_TYPE
  ,SEPORDE_TYPE;

  COMMIT;
SELECT
  COUNT(*)
 INTO
  VAR_COUNT
 FROM TBL_BACK_TEST_ARCHIVE
 WHERE MIN_DATE IS NULL
  OR
   MAX_DATE IS NULL;

 SELECT
  COUNT(*)
 INTO
  VAR_COUNT1
 FROM TBL_BACK_TEST_ARCHIVE;

 IF
  ( VAR_COUNT <> 0 OR ( VAR_COUNT1 = 0 AND VAR_COUNT = 0 ) )
 THEN
--  RETURN -1;
  RETURN 'select * from (  
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST WHERE DATA_TYPE=-85
)
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
 
 ELSE
 
  RETURN '
  select * from (
  select  sum("mande") as "mande","date","type" from (
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
  DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
TBL_VALUE_TEMP_BACK_TEST.SEPORDE_TYPE = ' || INPAR_NODE_ID ||' 
AND req_id              = ' || INPAR_REPreq_ID ||' 
AND data_type              = 1
 AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
union all

select sum("mande") "mande","date","type" from (

select  tb.mande "mande",
to_char(to_date(tb.EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
tb.DATA_TYPE "type" 
from TBL_VALUE_TEMP_BACK_TEST tb ,TBL_BACK_TEST_ARCHIVE ta 
where 
    tb.SEPORDE_TYPE = ta.NODE_ID 
    and ta.NODE_ID = ' ||INPAR_NODE_ID ||
  ' and ta.req_id = ' ||INPAR_REPreq_ID ||
  'and ta.req_id =tb.req_id 
   and ta.data_type=tb.data_type 
   and tb.DATA_TYPE not in( 1,0) and 
  tb.EFF_DATE between ta.min_date and ta.max_date
  
)group by "date","type"  
  
union all 
SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
TBL_VALUE_TEMP_BACK_TEST.SEPORDE_TYPE = ' ||INPAR_NODE_ID || ' 
  AND req_id              = ' ||INPAR_REPreq_ID ||' 
AND data_type              = 0 
 AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
) 
group by "date","type"

)
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';

 END IF;


elsif(var_category=106) then 

select 
 (select  listagg(data_type,',') within group (order by data_type)  from (
select data_type from(
  select distinct(data_type) as data_type from tbl_value_temp_back_test where REQ_Id=INPAR_REPreq_ID and EFF_DATE<to_char(sysdate,'j')
GROUP BY data_type ) order by data_type))
into var_data_types from dual ;

  INSERT INTO TBL_BACK_TEST_ARCHIVE (
   REQ_ID
  ,DATA_TYPE
  ,MIN_DATE
  ,MAX_DATE
  ,NODE_ID   -- dar inja hamun  "seporde_type"
  ) SELECT
   INPAR_REPreq_ID
  ,DATA_TYPE
  ,MAX(MIN)
  ,MIN(MAX)
  ,tashilat_type
  FROM (
    SELECT
     tashilat_type
    ,MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    ,DATA_TYPE
    FROM TBL_VALUE_TEMP_BACK_TEST
    WHERE REQ_ID    = INPAR_REPreq_ID
     AND
      tashilat_type   = INPAR_NODE_ID   --dar inja hamun  "seporde_type"
    GROUP BY
     tashilat_type
    ,DATA_TYPE
   )
  GROUP BY
   DATA_TYPE
  ,tashilat_type;

  COMMIT;
SELECT
  COUNT(*)
 INTO
  VAR_COUNT
 FROM TBL_BACK_TEST_ARCHIVE
 WHERE MIN_DATE IS NULL
  OR
   MAX_DATE IS NULL;

 SELECT
  COUNT(*)
 INTO
  VAR_COUNT1
 FROM TBL_BACK_TEST_ARCHIVE;

 IF
  ( VAR_COUNT <> 0 OR ( VAR_COUNT1 = 0 AND VAR_COUNT = 0 ) )
 THEN
--  RETURN -1;
  RETURN 'select * from (
  
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST WHERE DATA_TYPE=-85
)
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
 
 ELSE
 
  RETURN '
  select * from (
  select  sum("mande") as "mande","date","type" from (
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
  DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
TBL_VALUE_TEMP_BACK_TEST.tashilat_type = ' || INPAR_NODE_ID ||' 
AND req_id              = ' || INPAR_REPreq_ID ||' 
AND data_type              = 1
 AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
union all

select sum("mande") "mande","date","type" from (

select  tb.mande "mande",
to_char(to_date(tb.EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
tb.DATA_TYPE "type" 
from TBL_VALUE_TEMP_BACK_TEST tb ,TBL_BACK_TEST_ARCHIVE ta 
where 
    tb.tashilat_type = ta.NODE_ID 
    and ta.NODE_ID = ' ||INPAR_NODE_ID ||
  ' and ta.req_id = ' ||INPAR_REPreq_ID ||
  'and ta.req_id =tb.req_id 
  and ta.data_type=tb.data_type 
   and tb.DATA_TYPE not in( 1,0) and 
  tb.EFF_DATE between ta.min_date and ta.max_date
  
)group by "date","type"  
  
union all 
SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
TBL_VALUE_TEMP_BACK_TEST.tashilat_type = ' ||INPAR_NODE_ID || ' 
  AND req_id              = ' ||INPAR_REPreq_ID ||' 
AND data_type              = 0 
 AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
) 
group by "date","type"
)
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';

 END IF;



end if;

END FNC_REPORT_BACK_TEST;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_BACK_TEST_LEDBRN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_REPORT_BACK_TEST_LEDBRN" (
 INPAR_REPreq_ID   IN NUMBER
 ,INPAR_NODE_ID     IN VARCHAR2
 ,inpar_branch_id        IN VARCHAR2   -- if null then 108  else 105,107
 ,INPAR_IS_LEAF     IN VARCHAR2
)/*1 leaf  |||||  0 parent*/
 RETURN VARCHAR2 AS

 VAR_COUNT      NUMBER;
 VAR_COUNT1     NUMBER;
  VAR_NODE_ID    VARCHAR2(30000);
 VAR_MIN_DATE   NUMBER := 0;
 VAR_MAX_DATE   NUMBER := 0;
 var_max_depth  number;
 var_report_id  number;
 var_LEDGER_PROFILE_ID  number;
 var_max_level  number;
 var_code       number;
 var_shobe_id number;
 var_state_id number;
 var_city_id number;
 var_depth number;
 CATEGORY_type number;
 var_data_types VARCHAR2(4000);
 VAR_MAX_DATE_datatype1 number;
 PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: gozaresh backtest baraye gozareshat : daftarkol shobe,seporde shobe,tashilat shobe
  */
  /*------------------------------------------------------------------------------*/
--103 - 105 - 108 

 select CATEGORY into CATEGORY_type from tbl_rep_req where id=INPAR_REPreq_ID;
 
select report_id into var_report_id from tbl_rep_req where id=INPAR_REPreq_ID;
select LEDGER_PROFILE_ID into var_LEDGER_PROFILE_ID from reports where id=var_report_id;
select max(depth) into var_max_level from PRAGG.TBL_LEDGER_PROFILE_DETAIL where REF_LEDGER_PROFILE=var_LEDGER_PROFILE_ID ;

 EXECUTE IMMEDIATE 'truncate table TBL_BACK_TEST_ARCHIVE';
 commit;

 
 if(inpar_branch_id is not null) then --  tak shobe
  select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp_back_test where req_id=INPAR_REPreq_ID and branch_id=inpar_branch_id  and data_type=1;
 select 
 (select  listagg(data_type,',') within group (order by data_type)  from (
select data_type from(
  select distinct(data_type) as data_type from tbl_value_temp_back_test where REQ_Id=INPAR_REPreq_ID and  branch_id=inpar_branch_id and node_id=INPAR_NODE_ID and eff_date<to_char(sysdate,'j')
GROUP BY data_type ) order by data_type))
into var_data_types from dual ;

 IF (INPAR_IS_LEAF = 1) THEN
  INSERT INTO TBL_BACK_TEST_ARCHIVE (
   REQ_ID
  ,DATA_TYPE
  ,MIN_DATE
  ,MAX_DATE
  ,NODE_ID
  ,branch_id
  )
  SELECT
   INPAR_REPreq_ID
  ,DATA_TYPE
  ,MAX(MIN)
  ,MIN(MAX)
  ,NODE_ID
  ,inpar_branch_id
  FROM (
    SELECT
     NODE_ID
    ,MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    ,DATA_TYPE
--    ,BRANCH_ID
    FROM TBL_VALUE_TEMP_BACK_TEST 
    WHERE
     REQ_ID         = INPAR_REPreq_ID
     AND branch_id  =inpar_branch_id 
     and  NODE_ID   = INPAR_NODE_ID
    GROUP BY
     NODE_ID
    ,DATA_TYPE
   )
  GROUP BY
   DATA_TYPE
  ,NODE_ID;

  COMMIT;
  
 ELSE -- IF (INPAR_IS_LEAF = 1) THEN
 
--select max(depth) into var_max_depth from DAY_VARSA.DAY_GL ;
 
  FOR I IN (
   SELECT DISTINCT
    DATA_TYPE
   FROM TBL_VALUE_TEMP_BACK_TEST
   WHERE REQ_ID   = INPAR_REPreq_ID
  ) LOOP
   INSERT INTO TBL_BACK_TEST_ARCHIVE (
    REQ_ID
   ,DATA_TYPE
   ,MIN_DATE
   ,MAX_DATE
   ,NODE_ID
   ,branch_id
   ) SELECT
    INPAR_REPreq_ID
   ,I.DATA_TYPE
   ,MAX(MIN)
   ,MIN(MAX)
   ,INPAR_NODE_ID
   ,inpar_branch_id
   FROM (
     SELECT
      NODE_ID
     ,MIN(EFF_DATE) MIN
     ,MAX(EFF_DATE) MAX
     ,max(branch_id) as branch_id
     FROM TBL_VALUE_TEMP_BACK_TEST
     WHERE 
     REQ_ID      = INPAR_REPreq_ID
      AND  branch_id   = inpar_branch_id 
      and  DATA_TYPE   = I.DATA_TYPE /*2457785 2457788*/
      AND  NODE_ID IN (
 SELECT
        ( CODE )
       FROM (
         SELECT DISTINCT
          CODE
         ,DEPTH
         FROM (
           SELECT
            *
           FROM pragg.tbl_ledger_profile_detail where REF_LEDGER_PROFILE=var_LEDGER_PROFILE_ID       ---------------------------------?????????
          )
         START WITH
          PARENT_CODE   = INPAR_NODE_ID
         CONNECT BY
          PRIOR CODE = PARENT_CODE
        )
       WHERE DEPTH   = var_max_level
       )
     GROUP BY
      NODE_ID
    );

  END LOOP;

  COMMIT;
 END IF; -- IF (INPAR_IS_LEAF = 1) THEN


 SELECT                        ----------------------
  COUNT(*)
 INTO
  VAR_COUNT
 FROM TBL_BACK_TEST_ARCHIVE
 WHERE MIN_DATE IS NULL
  OR
   MAX_DATE IS NULL;

 SELECT                     -------------------------
  COUNT(*)
 INTO
  VAR_COUNT1
 FROM TBL_BACK_TEST_ARCHIVE;

 IF ( VAR_COUNT <> 0 OR ( VAR_COUNT1 = 0 AND VAR_COUNT = 0 ) ) THEN
--  RETURN -1;
   RETURN 'select * from (
   
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE data_type=-85
)
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';

 ELSE
 
  RETURN ' select * from (  
  SELECT sum(mande) "mande",
  to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
    NODE_ID            = ' || INPAR_NODE_ID ||
  ' and   branch_id    = ' ||inpar_branch_id ||
  ' AND req_id         = ' ||INPAR_REPreq_ID ||
  ' AND data_type      = 1
    AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
  group by EFF_DATE
  
union all
select sum("mande") "mande","date","type" from (

select   tb.mande "mande",to_char(to_date(tb.EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
tb.DATA_TYPE "type" 
from TBL_VALUE_TEMP_BACK_TEST tb ,TBL_BACK_TEST_ARCHIVE ta 
where 
  tb.NODE_ID = ta.NODE_ID
  and ta.NODE_ID = ' ||INPAR_NODE_ID   ||
' and tb.branch_id   = ' ||inpar_branch_id ||
' and ta.req_id = ' || INPAR_REPreq_ID ||
 'and ta.req_id =tb.req_id 
  and ta.data_type=tb.data_type 
 and tb.DATA_TYPE not in( 1,0)
  and tb.EFF_DATE between ta.min_date and ta.max_date
 
 )group by "date","type"
 
  
union all 
SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
    NODE_ID            = ' ||INPAR_NODE_ID ||
  ' and   branch_id    = ' ||inpar_branch_id ||
  ' AND req_id         = ' ||INPAR_REPreq_ID ||
  ' AND data_type      = 0 
   AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
)
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
 END IF; --IF ( VAR_COUNT <> 0 OR ( VAR_COUNT1 = 0 AND VAR_COUNT = 0 ) ) THEN
--end if; 

------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------
--------------------------------------------------------
-----------------------------------------
--103,105
 elsif(inpar_branch_id is null or inpar_branch_id='')then 
 
  select OSTAN_ID,SHAHR_ID,SHOBE_ID,code,DEPTH,NODE_ID into var_state_id,var_city_id,var_shobe_id, var_code,var_depth,var_node_id from tbl_ledger_branch where req_id=INPAR_REPreq_ID and  node_id=INPAR_NODE_ID;
 
  select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp_back_test where req_id=INPAR_REPreq_ID and branch_id=var_shobe_id  and data_type=1;
 ------------------------------------
 if (CATEGORY_type=103 or CATEGORY_type=105) then -- faghat baraye sathe akhar

 
 
 IF (INPAR_IS_LEAF = 1) THEN
  select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp_back_test where req_id=INPAR_REPreq_ID and branch_id=var_shobe_id  and data_type=1; 
  select 
 (select  listagg(data_type,',') within group (order by data_type)  from (
select data_type from(
  select distinct(data_type) as data_type from tbl_value_temp_back_test where REQ_Id=INPAR_REPreq_ID and  branch_id=var_shobe_id and EFF_DATE<to_char(sysdate,'j')
GROUP BY data_type ) order by data_type))
into var_data_types from dual ;

 FOR I IN (SELECT DISTINCT DATA_TYPE FROM TBL_VALUE_TEMP_BACK_TEST WHERE REQ_ID   = INPAR_REPreq_ID  ) LOOP
 
   INSERT INTO TBL_BACK_TEST_ARCHIVE (
    REQ_ID
   ,DATA_TYPE
   ,MIN_DATE
   ,MAX_DATE
   ,branch_id
   ) 
   SELECT
    INPAR_REPreq_ID
   ,I.DATA_TYPE
   ,MAX(MIN)
   ,MIN(MAX)
   ,var_shobe_id
   FROM (
     SELECT
      MIN(EFF_DATE) MIN
     ,MAX(EFF_DATE) MAX
     ,max(branch_id) as  branch_id
     FROM TBL_VALUE_TEMP_BACK_TEST
     WHERE REQ_ID      = INPAR_REPreq_ID
      AND branch_id    = var_shobe_id 
      and DATA_TYPE    = I.DATA_TYPE /*2457785 2457788*/
    );

  END LOOP;

  COMMIT;
  SELECT                        ----------------------
  COUNT(*)
 INTO
  VAR_COUNT
 FROM TBL_BACK_TEST_ARCHIVE
 WHERE MIN_DATE IS NULL
  OR
   MAX_DATE IS NULL;

 SELECT                     -------------------------
  COUNT(*)
 INTO
  VAR_COUNT1
 FROM TBL_BACK_TEST_ARCHIVE;

 IF ( VAR_COUNT <> 0 OR ( VAR_COUNT1 = 0 AND VAR_COUNT = 0 ) ) THEN
  --RETURN -1;
  RETURN ' select * from (
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE data_type=-85
)
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
  
 ELSE  --IF ( VAR_COUNT <> 0 OR ( VAR_COUNT1 = 0 AND VAR_COUNT = 0 ) )
 
  RETURN ' select * from ( 
  SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
    req_id         = ' ||INPAR_REPreq_ID ||
  ' and   branch_id    = ' ||var_shobe_id ||
  ' AND data_type      = 1
    AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
    group by EFF_DATE
    
union all
select sum("mande") "mande","date","type" from (

select tb.mande "mande",to_char(to_date(tb.EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
tb.DATA_TYPE "type" 
from TBL_VALUE_TEMP_BACK_TEST tb ,TBL_BACK_TEST_ARCHIVE ta 
where 
  ta.branch_id=tb.branch_id
  and ta.req_id       = ' || INPAR_REPreq_ID ||
'  and ta.req_id =tb.req_id
 and tb.branch_id    = ' ||var_shobe_id ||
' and tb.DATA_TYPE not in( 1,0) 
 and ta.data_type=tb.data_type 
  and tb.EFF_DATE between ta.min_date and ta.max_date

)group by "date","type"
   
union all 
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
    req_id         = ' ||INPAR_REPreq_ID ||
  ' and   branch_id    = ' ||var_shobe_id ||
  ' AND data_type      = 0 
   AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
    group by EFF_DATE
    )
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
 end if;
 
 else -- IF (INPAR_IS_LEAF = 1) THEN

 
 FOR I IN (SELECT DISTINCT DATA_TYPE FROM TBL_VALUE_TEMP_BACK_TEST WHERE REQ_ID   = INPAR_REPreq_ID ) LOOP
   INSERT INTO TBL_BACK_TEST_ARCHIVE (
    REQ_ID
   ,DATA_TYPE
   ,MIN_DATE
   ,MAX_DATE
   ,NODE_ID
   ) 
   SELECT
    INPAR_REPreq_ID
   ,i.data_type
   ,MAX(MIN)
   ,MIN(MAX)
   ,var_code
   FROM (
     SELECT
      MIN(EFF_DATE) MIN
     ,MAX(EFF_DATE) MAX
     ,branch_id
     FROM TBL_VALUE_TEMP_BACK_TEST
     WHERE 
     REQ_ID      = INPAR_REPreq_ID 
     and  DATA_TYPE   =i.data_type          -- I.DATA_TYPE /*2457785 2457788*/
       and    branch_id IN 
   (
   select distinct(shobe_id)
  from tbl_ledger_branch 
  where req_id=INPAR_REPreq_ID and shobe_id!=0
  start with node_id=var_node_id
  connect by prior node_id = parent
)
group by branch_id
   );


  END LOOP;

  COMMIT;
  
  end if;
 
 
 

 SELECT                        ----------------------
  COUNT(*)
 INTO
  VAR_COUNT
 FROM TBL_BACK_TEST_ARCHIVE
 WHERE MIN_DATE IS NULL
  OR
   MAX_DATE IS NULL;

 SELECT                     -------------------------
  COUNT(*)
 INTO
  VAR_COUNT1
 FROM TBL_BACK_TEST_ARCHIVE;

 IF ( VAR_COUNT <> 0 OR ( VAR_COUNT1 = 0 AND VAR_COUNT = 0 ) ) THEN
  --RETURN -1;
  
  RETURN ' select * from ( 
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE data_type=-85
)
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
  
 ELSE  --IF ( VAR_COUNT <> 0 OR ( VAR_COUNT1 = 0 AND VAR_COUNT = 0 ) )
 
 if(var_depth=2) then --city
 select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp_back_test where req_id=INPAR_REPreq_ID and CITY_ID=var_city_id  and data_type=1; 
  
  select 
 (select  listagg(data_type,',') within group (order by data_type)  from (
select data_type from(
  select distinct(data_type) as data_type from tbl_value_temp_back_test where REQ_Id=INPAR_REPreq_ID and  city_id=var_city_id and EFF_DATE<to_char(sysdate,'j')
GROUP BY data_type ) order by data_type))
into var_data_types from dual ;
 
  RETURN ' select * from ( 
  SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
    req_id         = ' ||INPAR_REPreq_ID ||
  ' and   CITY_ID    = ' ||var_city_id ||
  ' AND data_type      = 1 
   AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
    group by EFF_DATE
    
union all
select sum("mande") "mande","date","type" from (

select tb.mande "mande",to_char(to_date(tb.EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
tb.DATA_TYPE "type" 
from TBL_VALUE_TEMP_BACK_TEST tb ,TBL_BACK_TEST_ARCHIVE ta 
where 

  ta.req_id       = ' || INPAR_REPreq_ID ||
' and ta.req_id=tb.req_id 
  and tb.CITY_ID    = ' ||var_city_id ||
' and tb.DATA_TYPE not in( 1,0)
  and ta.data_type=tb.data_type 
  and tb.EFF_DATE between ta.min_date and ta.max_date

)group by "date","type"
   
union all 
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
    req_id         = ' ||INPAR_REPreq_ID ||
  ' and   CITY_ID    = ' ||var_city_id ||
  ' AND data_type      = 0
    AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
    group by EFF_DATE
    )
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
    
    
    
    elsif(var_depth=1)then --state
     select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp_back_test where req_id=INPAR_REPreq_ID and STATE_ID=var_state_id  and data_type=1; 

      select 
 (select  listagg(data_type,',') within group (order by data_type)  from (
select data_type from(
  select distinct(data_type) as data_type from tbl_value_temp_back_test where REQ_Id=INPAR_REPreq_ID and  STATE_ID=var_state_id and EFF_DATE<to_char(sysdate,'j')
GROUP BY data_type ) order by data_type))
into var_data_types from dual ;
    
      RETURN ' select * from ( 
      SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
     max(DATA_TYPE) "type"
     FROM TBL_VALUE_TEMP_BACK_TEST
     WHERE 
    req_id         = ' ||INPAR_REPreq_ID ||
  ' and   STATE_ID    = ' ||var_state_id ||
  ' AND data_type      = 1 
   AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
    group by EFF_DATE
    
union all
select sum("mande") "mande","date","type" from (

select tb.mande "mande",to_char(to_date(tb.EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
tb.DATA_TYPE "type" 
from TBL_VALUE_TEMP_BACK_TEST tb ,TBL_BACK_TEST_ARCHIVE ta 
where 

   ta.req_id       = ' || INPAR_REPreq_ID ||
' and ta.req_id=tb.req_id 
  and tb.STATE_ID    = ' ||var_state_id ||
' and tb.DATA_TYPE not in( 1,0) 
  and ta.data_type=tb.data_type
  and tb.EFF_DATE between ta.min_date and ta.max_date

)group by "date","type"
   
union all 
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
    req_id         = ' ||INPAR_REPreq_ID ||
  ' and   STATE_ID    = ' ||var_state_id ||
  ' AND data_type      = 0 
    AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
    group by EFF_DATE
    )
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
    
    elsif(var_depth=0) then --
        select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp_back_test where req_id=INPAR_REPreq_ID   and data_type=1; 
 
       select 
 (select  listagg(data_type,',') within group (order by data_type)  from (
select data_type from(
  select distinct(data_type) as data_type from tbl_value_temp_back_test where REQ_Id=INPAR_REPreq_ID 
GROUP BY data_type ) order by data_type))
into var_data_types from dual ;
    
     RETURN ' select * from ( 
     SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
     max(DATA_TYPE) "type"
     FROM TBL_VALUE_TEMP_BACK_TEST
     WHERE 
    req_id         = ' ||INPAR_REPreq_ID ||
  ' AND data_type      = 1
    AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
    group by EFF_DATE
    
union all
select sum("mande") "mande","date","type" from (

select tb.mande "mande",to_char(to_date(tb.EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
tb.DATA_TYPE "type" 
from TBL_VALUE_TEMP_BACK_TEST tb ,TBL_BACK_TEST_ARCHIVE ta 
where 

  ta.req_id       = ' || INPAR_REPreq_ID ||
'and ta.req_id =tb.req_id   
 and tb.DATA_TYPE not in( 1,0)
  and ta.data_type=tb.data_type
  and tb.EFF_DATE between ta.min_date and ta.max_date

)group by "date","type"
   
union all 
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
    req_id         = ' ||INPAR_REPreq_ID ||
  ' AND data_type      = 0 
    AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
    group by EFF_DATE
    )
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
    
    end if;
    
 end if;-- IF ( VAR_COUNT <> 0 OR ( VAR_COUNT1 = 0 AND VAR_COUNT = 0 ) ) THEN
 END IF; -- if (CATEGORY_type=103) then -- faghat baraye sathe akhar

 
-- else
-- 
--  RETURN 'SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",DATA_TYPE "type"
--FROM TBL_VALUE_TEMP_BACK_TEST
--WHERE data_type=-85';
--
-- end if;
 
---------------------------------------- 
 else -- if (CATEGORY_type=103) then -- faghat baraye sathe akhar

 --108
 
  FOR I IN (
   SELECT DISTINCT
    DATA_TYPE
   FROM TBL_VALUE_TEMP_BACK_TEST
   WHERE REQ_ID   = INPAR_REPreq_ID
  ) LOOP
   INSERT INTO TBL_BACK_TEST_ARCHIVE (
    REQ_ID
   ,DATA_TYPE
   ,MIN_DATE
   ,MAX_DATE
   ,NODE_ID
   ,branch_id
   ) SELECT
    INPAR_REPreq_ID
   ,I.DATA_TYPE
   ,MAX(MIN)
   ,MIN(MAX)
   ,NODE_ID
   ,var_shobe_id
   FROM (
     SELECT
      NODE_ID
     ,MIN(EFF_DATE) MIN
     ,MAX(EFF_DATE) MAX
     ,max(branch_id) as  branch_id
     FROM TBL_VALUE_TEMP_BACK_TEST
     WHERE REQ_ID      = INPAR_REPreq_ID
      AND branch_id    = var_shobe_id 
      and DATA_TYPE    = I.DATA_TYPE /*2457785 2457788*/
      AND
       NODE_ID IN (

 SELECT
        ( CODE )
       FROM (
         SELECT DISTINCT
          CODE
         ,DEPTH
         FROM (
           SELECT
            *
           FROM pragg.tbl_ledger_profile_detail where REF_LEDGER_PROFILE=var_LEDGER_PROFILE_ID       ---------------------------------?????????
          )
         START WITH
          PARENT_CODE   = var_code
         CONNECT BY
          PRIOR CODE = PARENT_CODE
        )
       WHERE DEPTH   = var_max_level
       )
     GROUP BY
      NODE_ID
    );

  END LOOP;

  COMMIT;
-- END IF;

 SELECT                        ----------------------
  COUNT(*)
 INTO
  VAR_COUNT
 FROM TBL_BACK_TEST_ARCHIVE
 WHERE MIN_DATE IS NULL
  OR
   MAX_DATE IS NULL;

 SELECT                     -------------------------
  COUNT(*)
 INTO
  VAR_COUNT1
 FROM TBL_BACK_TEST_ARCHIVE;

 IF ( VAR_COUNT <> 0 OR ( VAR_COUNT1 = 0 AND VAR_COUNT = 0 ) ) THEN
 -- RETURN -1;
  RETURN ' select * from (  
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",DATA_TYPE "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE data_type=-85
)
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
 ELSE
 
  RETURN ' select * from ( 
  SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
    NODE_ID            = ' ||var_code ||
  ' AND req_id         = ' ||INPAR_REPreq_ID ||
  ' and   branch_id    = ' ||var_shobe_id ||
  ' AND data_type      = 1 
   AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
    group by EFF_DATE 
  
union all
select sum("mande") "mande","date","type" from (

select tb.mande "mande",to_char(to_date(tb.EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
tb.DATA_TYPE "type" 
from TBL_VALUE_TEMP_BACK_TEST tb ,TBL_BACK_TEST_ARCHIVE ta 
where 
      tb.NODE_ID      = ta.NODE_ID
  and ta.NODE_ID      = ' ||var_code ||
' and ta.req_id       = ' || INPAR_REPreq_ID ||
' and tb.branch_id    = ' ||var_shobe_id ||
' and ta.req_id =tb.req_id 
  and ta.data_type=tb.data_type 
  and tb.DATA_TYPE not in( 1,0)
  and tb.EFF_DATE between ta.min_date and ta.max_date 
  
  )group by "date","type"
  
union all 
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')  "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP_BACK_TEST
WHERE 
    NODE_ID            = ' ||var_code ||
  ' AND req_id         = ' ||INPAR_REPreq_ID ||
  ' and   branch_id    = ' ||var_shobe_id ||
  ' AND data_type      = 0 
    AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
   group by EFF_DATE 
    )
pivot 
(
max("mande") for "type" in ('||var_data_types||')
)
order by "date" ';
 END IF;-- IF ( VAR_COUNT <> 0 OR ( VAR_COUNT1 = 0 AND VAR_COUNT = 0 ) ) THEN

 end if;-- elsif(inpar_branch_id is null or inpar_branch_id='')then 
 

END FNC_REPORT_BACK_TEST_LEDBRN;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_FUTURE_PREDICTION
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_REPORT_FUTURE_PREDICTION" (
 INPAR_rep_req_ID   IN NUMBER
 ,INPAR_NODE_ID     IN VARCHAR2
) RETURN VARCHAR2 AS
 VAR_REQ   NUMBER;
 var_category NUMBER;


BEGIN
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: FUTURE   ---104-106-107
  */
  /*------------------------------------------------------------------------------*/
select CATEGORY into var_category from tbl_rep_req where id=INPAR_REP_REQ_ID;

if (var_category=104) then 

RETURN '
select a.*,b.IS_ACTIVE_TUNEL as "isActineTunel" from (
select * from(

SELECT max(req_id) as req_id,
sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
max(DATA_TYPE) "type" ,
round(sum(mande)-sum(interval),2) as "minInt",
round(sum(mande)+sum(interval),2) as  "maxInt"
FROM TBL_VALUE_TEMP
WHERE REQ_ID =' ||INPAR_rep_req_ID ||'
AND DATA_TYPE = 3
AND SEPORDE_TYPE = ' ||INPAR_NODE_ID ||' 
 group by EFF_DATE 

 
  )
pivot 
(
max("mande") for "type" in (3)
))
a,tbl_rep_req b
where a.req_id=b.id
order by a."date"';


elsif(var_category=106) then

RETURN '
select a.*,b.IS_ACTIVE_TUNEL as "isActineTunel" from (
select * from(

SELECT max(req_id) as req_id,
sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
max(DATA_TYPE) "type",
round(sum(mande)-sum(interval),2) as "minInt",
round(sum(mande)+sum(interval),2) as  "maxInt"
FROM TBL_VALUE_TEMP WHERE REQ_ID =' ||
 INPAR_rep_req_ID ||
 ' AND DATA_TYPE = 3 AND TASHILAT_TYPE = ' ||INPAR_NODE_ID ||' 
 group by EFF_DATE 

 
 )
pivot 
(
max("mande") for "type" in (3)
))
a,tbl_rep_req b
where a.req_id=b.id
order by a."date"';


elsif(var_category=107) then 

 RETURN '
select a.*,b.IS_ACTIVE_TUNEL as "isActineTunel" from (
select * from(

SELECT max(req_id) as req_id,
sum(mande) "mande",
 to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
max(DATA_TYPE) "type",
round(sum(mande)-sum(interval),2) as "minInt",
round(sum(mande)+sum(interval),2) as  "maxInt" 
 FROM TBL_VALUE_TEMP WHERE REQ_ID =' ||INPAR_rep_req_ID ||
 ' AND DATA_TYPE = 3 AND NODE_ID = ' ||INPAR_NODE_ID ||
 ' group by EFF_DATE 
  )
pivot 
(
max("mande") for "type" in (3)
))
a,tbl_rep_req b
where a.req_id=b.id
order by a."date"';
 
end if;


--------------------------------------------------


--if (var_category=104) then 
--
--RETURN '
--select a.*,b."minInt",b."maxInt",b."isActineTunel" from (
--select * from(
--
--SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",max(DATA_TYPE) "type" FROM TBL_VALUE_TEMP WHERE REQ_ID =' ||
-- INPAR_rep_req_ID ||
-- ' AND DATA_TYPE = 3 AND SEPORDE_TYPE = ' ||INPAR_NODE_ID ||' 
-- group by EFF_DATE 
--
-- 
--  )
--pivot 
--(
--max("mande") for "type" in (3)
--)
--) a
--left join
--(select
-- to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
--sum(round(mande-interval,2)) as "minInt",
--sum(round(mande+interval,2)) as "maxInt"
--,max(IS_ACTIVE_TUNEL) as "isActineTunel"
--from TBL_VALUE_temp,tbl_rep_req  where req_id=' ||INPAR_rep_req_ID ||' and TBL_VALUE_temp.req_id=tbl_rep_req.id and SEPORDE_TYPE =  ' ||INPAR_NODE_ID ||' data_type=3 group by EFF_DATE)b
--on a."date"=b."date" 
--order by a."date" ';
--
--elsif(var_category=106) then
--
--RETURN '
--select a.*,b."minInt",b."maxInt",b."isActineTunel" from (
--select * from(
--
--SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",max(DATA_TYPE) "type" FROM TBL_VALUE_TEMP WHERE REQ_ID =' ||
-- INPAR_rep_req_ID ||
-- ' AND DATA_TYPE = 3 AND TASHILAT_TYPE = ' ||INPAR_NODE_ID ||' 
-- group by EFF_DATE 
--
-- 
-- )
--pivot 
--(
--max("mande") for "type" in (3)
--)
--) a
--left join
--(select
-- to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
--sum(round(mande-interval,2)) as "minInt",
--sum(round(mande+interval,2)) as "maxInt"
--,max(IS_ACTIVE_TUNEL) as "isActineTunel"
--from TBL_VALUE_temp,tbl_rep_req  where req_id=' ||INPAR_rep_req_ID ||' and TBL_VALUE_temp.req_id=tbl_rep_req.id and TASHILAT_TYPE =  ' ||INPAR_NODE_ID ||' data_type=3 group by EFF_DATE)b
--on a."date"=b."date" 
--order by a."date" ';
--
--
--elsif(var_category=107) then 
--
-- RETURN '
-- select a.*,b."minInt",b."maxInt",b."isActineTunel" from (
-- select * from(
-- 
-- SELECT sum(mande) "mande",
-- to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
-- max(DATA_TYPE) "type" 
-- FROM TBL_VALUE_TEMP WHERE REQ_ID =' ||INPAR_rep_req_ID ||
-- ' AND DATA_TYPE = 3 AND NODE_ID = ' ||INPAR_NODE_ID ||
-- ' group by EFF_DATE 
--  )
--pivot 
--(
--max("mande") for "type" in (3)
--)
--) a
--left join
--(select
-- to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
--sum(round(mande-interval,2)) as "minInt",
--sum(round(mande+interval,2)) as "maxInt"
--,max(IS_ACTIVE_TUNEL) as "isActineTunel"
--from TBL_VALUE_temp,tbl_rep_req  where req_id=' ||INPAR_rep_req_ID ||' and TBL_VALUE_temp.req_id=tbl_rep_req.id and NODE_ID =  ' ||INPAR_NODE_ID ||' data_type=3 group by EFF_DATE)b
--on a."date"=b."date"
--order by a."date" ';
-- 
--end if;
END FNC_REPORT_FUTURE_PREDICTION;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_FUTURE_PRE_LEDBRN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_REPORT_FUTURE_PRE_LEDBRN" 
(
  INPAR_REP_REQ_ID IN NUMBER 
, INPAR_NODE_ID IN NUMBER 
, INPAR_BRANCH_ID IN NUMBER 
)RETURN VARCHAR2 AS
 VAR_REQ   NUMBER;
 var_shobe_id number;
 var_state_id number;
 var_city_id number;
 var_depth number;
 var_code number;
 CATEGORY_type number;

BEGIN
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: FUTURE   --103-105-108
  */
  /*------------------------------------------------------------------------------*/
select CATEGORY into CATEGORY_type from tbl_rep_req where id=INPAR_REP_REQ_ID;
------------------------------------------------------------------------------------------------------------
if (INPAR_BRANCH_ID is not null ) then   --108
 RETURN '
  select a.*,b.IS_ACTIVE_TUNEL as "isActineTunel" from (
 select * from (   
 
 SELECT 
 max(req_id) as req_id,
 sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
 max(DATA_TYPE) "type",
round(sum(mande)-sum(interval),2) as  "minInt",
round(sum(mande)+sum(interval),2) as  "maxInt"
 FROM TBL_VALUE_TEMP 
 WHERE REQ_ID =' ||INPAR_rep_req_ID ||
 ' and branch_id='||INPAR_BRANCH_ID||
 ' AND DATA_TYPE = 3 
   AND NODE_ID = ' || INPAR_NODE_ID ||
 ' group by EFF_DATE   
 
   )
pivot 
(
max("mande") for "type" in (3)
)
)
a,tbl_rep_req b
where a.req_id=b.id
order by a."date" ';
 end if ;
 -------------------------------------------------------------------------------------------------------------
 if(INPAR_BRANCH_ID is  null or INPAR_BRANCH_ID='') then  --103-105
  select OSTAN_ID,SHAHR_ID,SHOBE_ID,code,DEPTH into var_state_id,var_city_id,var_shobe_id, var_code,var_depth from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and  node_id=INPAR_NODE_ID;
  
if(CATEGORY_type=103 or CATEGORY_type=105) then 

if(var_depth=0) then

RETURN ' 
 select a.*,b.IS_ACTIVE_TUNEL as "isActineTunel" from (
select * from ( 

SELECT max(req_id) as req_id,
sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
max(DATA_TYPE) "type" ,
round(sum(mande)-sum(interval),2) as  "minInt",
round(sum(mande)+sum(interval),2) as  "maxInt"
 FROM TBL_VALUE_TEMP 
 WHERE REQ_ID =' ||INPAR_rep_req_ID || ' 
 AND DATA_TYPE = 3
 group by EFF_DATE 
 
   )
pivot 
(
max("mande") for "type" in (3)
))
a,tbl_rep_req b
where a.req_id=b.id
order by a."date"';
 
elsif(var_depth=1) then

RETURN ' 
select a.*,b.IS_ACTIVE_TUNEL as "isActineTunel" from (
select * from ( 

SELECT max(req_id) as req_id,
sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
max(DATA_TYPE) "type" ,
round(sum(mande)-sum(interval),2) as  "minInt",
round(sum(mande)+sum(interval),2) as  "maxInt"
 FROM TBL_VALUE_TEMP 
 WHERE REQ_ID =' ||INPAR_rep_req_ID || ' 
 AND DATA_TYPE = 3
   and state_id='||var_state_id||'
 group by EFF_DATE 
 
   )
pivot 
(
max("mande") for "type" in (3)
))
a,tbl_rep_req b
where a.req_id=b.id
order by a."date"';

elsif(var_depth=2) then 

RETURN ' 
 select a.*,b.IS_ACTIVE_TUNEL as "isActineTunel" from (
select * from ( 

SELECT max(req_id) as req_id,
sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
max(DATA_TYPE) "type" ,
round(sum(mande)-sum(interval),2) as  "minInt",
round(sum(mande)+sum(interval),2) as  "maxInt"
 FROM TBL_VALUE_TEMP 
 WHERE REQ_ID =' ||INPAR_rep_req_ID || ' 
 AND DATA_TYPE = 3
   and city_id='||var_city_id||'
 group by EFF_DATE 
 
   )
pivot 
(
max("mande") for "type" in (3)
))
a,tbl_rep_req b
where a.req_id=b.id
order by a."date"';

elsif(var_depth=3) then

RETURN ' 
 select a.*,b.IS_ACTIVE_TUNEL as "isActineTunel" from (
select * from ( 

SELECT max(req_id) as req_id,
sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
max(DATA_TYPE) "type" ,
round(sum(mande)-sum(interval),2) as  "minInt",
round(sum(mande)+sum(interval),2) as  "maxInt"
 FROM TBL_VALUE_TEMP 
 WHERE REQ_ID =' ||INPAR_rep_req_ID || ' 
 AND DATA_TYPE = 3
   and branch_id='||var_shobe_id||'
 group by EFF_DATE 
 
   )
pivot 
(
max("mande") for "type" in (3)
))
a,tbl_rep_req b
where a.req_id=b.id
order by a."date"';


end if; --if(var_depth=1) then

else  --if(CATEGORY_type=103 or CATEGORY_type=105) then  --109


 RETURN ' 
 select a.*,b.IS_ACTIVE_TUNEL as "isActineTunel" from (
select * from ( 

SELECT max(req_id) as req_id, sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
max(DATA_TYPE) "type" ,
round(sum(mande)-sum(interval),2) as  "minInt",
round(sum(mande)+sum(interval),2) as  "maxInt" 
 FROM TBL_VALUE_TEMP 
 WHERE REQ_ID =' ||INPAR_rep_req_ID || 
 ' AND DATA_TYPE = 3
   AND DEPTH=1 
   and branch_id='||var_shobe_id||
 ' AND NODE_ID = ' ||var_code ||
 ' 
 group by EFF_DATE 
 
   )
pivot 
(
max("mande") for "type" in (3)
))
a,tbl_rep_req b
where a.req_id=b.id
order by a."date"';
 
 end if;--if(CATEGORY_type=103) then 

 end if;-- if(INPAR_BRANCH_ID is  null or INPAR_BRANCH_ID='') then
-------------------------------------------------------------------------------------------------------------------

 
 
 
END FNC_REPORT_FUTURE_PRE_LEDBRN;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_MODEL_TEST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_REPORT_MODEL_TEST" (
 INPAR_REPreq_ID   IN NUMBER
 ,INPAR_NODE_ID     IN VARCHAR2
 ,INPAR_IS_LEAF     IN VARCHAR2
)/*1 leaf  |||||  0 parent*/
 RETURN VARCHAR2 AS

 VAR_DEPTH      NUMBER;
 VAR_REQ        NUMBER;
 VAR_NODE_ID    VARCHAR2(30000);
 VAR_MIN_DATE   NUMBER := 0;
 VAR_MAX_DATE   NUMBER := 0;
 var_code       number;
 var_max_level  number;
 var_LEDGER_PROFILE_ID number;
 var_report_id number;
 var_category  number;
 VAR_MAX_DATE_datatype1  number;
BEGIN
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: MODEL_TEST   --104-106-107
  */
  /*------------------------------------------------------------------------------*/
select report_id into var_report_id from tbl_rep_req where id=INPAR_REPreq_ID;
select LEDGER_PROFILE_ID into var_LEDGER_PROFILE_ID from reports where id=var_report_id;

select max(depth) into var_max_level from  pragg.tbl_ledger_profile_detail where REF_LEDGER_PROFILE=var_LEDGER_PROFILE_ID ;

select CATEGORY into var_category from tbl_rep_req where id=INPAR_REPreq_ID;
 --baraye namayesh nemudar az akharin tarikh mojud (type1) ta 365 ruz ghabl - 
 select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp where req_id=INPAR_REPreq_ID and data_type=1;
 
if(var_category=107) then 
 
 IF
  INPAR_IS_LEAF = 1
 THEN
  SELECT
   MAX(MIN)
  ,MIN(MAX)
  INTO
   VAR_MIN_DATE,VAR_MAX_DATE
  FROM (
    SELECT
     NODE_ID
    ,MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    FROM TBL_VALUE_TEMP
    WHERE REQ_ID      = INPAR_REPreq_ID
     AND
      DATA_TYPE   = 2
     AND
      NODE_ID     = INPAR_NODE_ID
    GROUP BY
     NODE_ID
   );

 ELSE
  SELECT
   MAX(MIN)
  ,MIN(MAX)
  INTO
   VAR_MIN_DATE,VAR_MAX_DATE
  FROM (
    SELECT
     NODE_ID
    ,MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    FROM TBL_VALUE_TEMP
    WHERE REQ_ID      = INPAR_REPreq_ID
     AND
      DATA_TYPE   = 2
     AND
      NODE_ID IN (
       SELECT
        ( CODE )
       FROM (
         SELECT DISTINCT
          CODE
         ,DEPTH
         FROM (
           SELECT
            *
           FROM pragg.tbl_ledger_profile_detail where REF_LEDGER_PROFILE=var_LEDGER_PROFILE_ID     
          )
         START WITH
          PARENT_CODE   = INPAR_NODE_ID
         CONNECT BY
          PRIOR CODE = PARENT_CODE
        )
       WHERE DEPTH   = var_max_level
      )
    GROUP BY
     NODE_ID
   );

 END IF;

 IF
  ( VAR_MIN_DATE IS NULL
  OR
   VAR_MAX_DATE IS NULL
  )
 THEN
--  RETURN -1;
  RETURN ' select * from ( 
  
  SELECT mande "mande",
  to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
DATA_TYPE "type"
FROM TBL_VALUE_TEMP WHERE  data_type=-85

  )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';
 
 ELSE
  RETURN ' select * from ( 
  
  SELECT sum(mande) "mande",
  to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
TBL_VALUE_TEMP.NODE_ID = ' ||INPAR_NODE_ID ||' 
AND req_id              = ' ||INPAR_REPreq_ID ||'
AND data_type              = 1
 AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
group by EFF_DATE

union all
select sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
from TBL_VALUE_TEMP where
EFF_DATE between ' ||VAR_MIN_DATE ||'and ' ||VAR_MAX_DATE ||'
and TBL_VALUE_TEMP.NODE_ID = ' ||INPAR_NODE_ID ||'
and req_id = ' ||INPAR_REPreq_ID ||'
and data_type = 2
group by EFF_DATE

union all 

SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
TBL_VALUE_TEMP.NODE_ID = ' ||INPAR_NODE_ID ||' 
AND req_id              = ' || INPAR_REPreq_ID ||' 
AND data_type              = 0 
 AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
group by EFF_DATE 
  )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';
 END IF;

end if;--if(var_category=107) then 
----------------------------------------------------------------------
if(var_category=104) then 

  SELECT
   MAX(MIN)
  ,MIN(MAX)
  INTO
   VAR_MIN_DATE,VAR_MAX_DATE
  FROM (
    SELECT
     seporde_type
    ,MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    FROM TBL_VALUE_TEMP
    WHERE REQ_ID      = INPAR_REPreq_ID
     AND
      DATA_TYPE   = 2
     AND
      seporde_type     = INPAR_NODE_ID
    GROUP BY
     seporde_type
   );

 IF( VAR_MIN_DATE IS NULL OR VAR_MAX_DATE IS NULL) THEN
--  RETURN -1;
  RETURN ' select * from ( 
  
  SELECT mande "mande",
  to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
DATA_TYPE "type"
FROM TBL_VALUE_TEMP WHERE  data_type=-85

  )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';
 
 ELSE
  RETURN ' select * from ( 
  
  SELECT sum(mande) "mande",
  to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
TBL_VALUE_TEMP.seporde_type = ' ||INPAR_NODE_ID ||' 
AND req_id              = ' ||INPAR_REPreq_ID ||'
AND data_type              = 1
group by EFF_DATE

union all
select sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
from TBL_VALUE_TEMP where
EFF_DATE between ' ||VAR_MIN_DATE ||'and ' ||VAR_MAX_DATE ||'
and TBL_VALUE_TEMP.seporde_type = ' ||INPAR_NODE_ID ||'
and req_id = ' ||INPAR_REPreq_ID ||'
and data_type = 2
group by EFF_DATE

union all 

SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
TBL_VALUE_TEMP.seporde_type = ' ||INPAR_NODE_ID ||' 
AND req_id              = ' || INPAR_REPreq_ID ||' 
AND data_type              = 0  
group by EFF_DATE 

  )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';

end if;-- IF( VAR_MIN_DATE IS NULL OR VAR_MAX_DATE IS NULL) THEN

end if;--if(var_category=104) then 

-------------------------------------------------------------------------------------------------------------

if(var_category=106) then 

  SELECT
   MAX(MIN)
  ,MIN(MAX)
  INTO
   VAR_MIN_DATE,VAR_MAX_DATE
  FROM (
    SELECT
     TASHILAT_TYPE
    ,MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    FROM TBL_VALUE_TEMP
    WHERE REQ_ID      = INPAR_REPreq_ID
     AND
      DATA_TYPE   = 2
     AND
      TASHILAT_TYPE     = INPAR_NODE_ID
    GROUP BY
     TASHILAT_TYPE
   );

 IF( VAR_MIN_DATE IS NULL OR VAR_MAX_DATE IS NULL) THEN
--  RETURN -1;
  RETURN ' select * from ( 
  
  SELECT mande "mande",
  to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
DATA_TYPE "type"
FROM TBL_VALUE_TEMP WHERE  data_type=-85

  )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';
 
 ELSE
  RETURN ' select * from ( 
  
  SELECT sum(mande) "mande",
  to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
TBL_VALUE_TEMP.TASHILAT_TYPE = ' ||INPAR_NODE_ID ||' 
AND req_id              = ' ||INPAR_REPreq_ID ||'
AND data_type              = 1
 AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| '  
group by EFF_DATE

union all
select sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
from TBL_VALUE_TEMP where
EFF_DATE between ' ||VAR_MIN_DATE ||'and ' ||VAR_MAX_DATE ||'
and TBL_VALUE_TEMP.TASHILAT_TYPE = ' ||INPAR_NODE_ID ||'
and req_id = ' ||INPAR_REPreq_ID ||'
and data_type = 2
group by EFF_DATE

union all 

SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
TBL_VALUE_TEMP.TASHILAT_TYPE = ' ||INPAR_NODE_ID ||' 
AND req_id              = ' || INPAR_REPreq_ID ||' 
AND data_type              = 0  
group by EFF_DATE

  )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';

end if;-- IF( VAR_MIN_DATE IS NULL OR VAR_MAX_DATE IS NULL) THEN

end if;--if(var_category=104) then 

--TASHILAT_TYPE



END FNC_REPORT_MODEL_TEST;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_MODEL_TEST_LEDBRN
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_REPORT_MODEL_TEST_LEDBRN" (
 INPAR_REPreq_ID   IN NUMBER
 ,INPAR_NODE_ID     IN VARCHAR2
 ,inpar_branch_id  in number
  ,INPAR_IS_LEAF     IN VARCHAR2
)/*1 leaf  |||||  0 parent*/
 RETURN VARCHAR2 AS

 VAR_DEPTH      NUMBER;
 VAR_REQ        NUMBER;
 VAR_NODE_ID    VARCHAR2(30000);
 VAR_MIN_DATE   NUMBER := 0;
 VAR_MAX_DATE   NUMBER := 0;
var_shobe_id number;
 var_state_id number;
 var_city_id number;
-- var_depth number;
--var_node_id number;
 var_code       number;
 var_max_level  number;
 var_LEDGER_PROFILE_ID number;
 var_report_id number;
 CATEGORY_type number;
 VAR_MAX_DATE_datatype1 number;
BEGIN
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: MODEL_TEST   --103-105-108
  */
  /*------------------------------------------------------------------------------*/
select CATEGORY into CATEGORY_type from tbl_rep_req where id=INPAR_REPreq_ID;
select report_id into var_report_id from tbl_rep_req where id=INPAR_REPreq_ID;
select LEDGER_PROFILE_ID into var_LEDGER_PROFILE_ID from reports where id=var_report_id;

if(inpar_branch_id is not null ) then
   select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp where req_id=INPAR_REPreq_ID and branch_id=inpar_branch_id  and data_type=1;

 IF
  INPAR_IS_LEAF = 1
 THEN
  SELECT
   MAX(MIN)
  ,MIN(MAX)
  INTO
   VAR_MIN_DATE,VAR_MAX_DATE
  FROM (
    SELECT
     NODE_ID
    ,MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    FROM TBL_VALUE_TEMP
    WHERE 
    REQ_ID      = INPAR_REPreq_ID
     AND
      branch_id   =inpar_branch_id
      and
      DATA_TYPE   = 2
     AND
      NODE_ID     = INPAR_NODE_ID
    GROUP BY
     NODE_ID
   );

 ELSE
 
-- select max(depth) into var_max_level from DAY_VARSA.DAY_GL ;
select max(depth) into var_max_level from PRAGG.TBL_LEDGER_PROFILE_DETAIL where REF_LEDGER_PROFILE=var_LEDGER_PROFILE_ID ;
 
  SELECT
   MAX(MIN)
  ,MIN(MAX)
  INTO
   VAR_MIN_DATE,VAR_MAX_DATE
  FROM (
    SELECT
     NODE_ID
    ,MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    FROM TBL_VALUE_TEMP
    WHERE 
    REQ_ID            = INPAR_REPreq_ID
      AND branch_id   =inpar_branch_id 
      and DATA_TYPE   = 2
     AND
      NODE_ID IN (
       SELECT
        ( CODE )
       FROM (
         SELECT DISTINCT
          CODE
         ,DEPTH
         FROM (
           SELECT
            *
           FROM pragg.tbl_ledger_profile_detail where REF_LEDGER_PROFILE=var_LEDGER_PROFILE_ID       ---------------------------------?????????
          )
         START WITH
          PARENT_CODE   = INPAR_NODE_ID
         CONNECT BY
          PRIOR CODE = PARENT_CODE
        )
       WHERE DEPTH   = var_max_level
      )
    GROUP BY
     NODE_ID
   );

 END IF;

 IF
  ( VAR_MIN_DATE IS NULL
  OR
   VAR_MAX_DATE IS NULL
  )
 THEN
--  RETURN -1;
  RETURN ' select * from ( 
  
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
  DATA_TYPE "type"
FROM TBL_VALUE_TEMP where data_type=-85

  )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';

 ELSE
  RETURN ' select * from (  
  
  SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
    NODE_ID                     = ' ||INPAR_NODE_ID ||
  ' AND req_id                  = ' ||INPAR_REPreq_ID ||
  ' and TBL_VALUE_TEMP.branch_id='||inpar_branch_id||
  ' AND data_type= 1 
     AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
  group by EFF_DATE

union all
select sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type" 
from TBL_VALUE_TEMP 
where 
  branch_id='||inpar_branch_id||
  ' and EFF_DATE between ' ||VAR_MIN_DATE ||' and ' || VAR_MAX_DATE ||
  ' and TBL_VALUE_TEMP.NODE_ID = ' ||INPAR_NODE_ID ||
  ' and req_id = ' ||INPAR_REPreq_ID ||
  ' and data_type = 2 
  group by EFF_DATE 

union all 
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type" 
FROM TBL_VALUE_TEMP
WHERE 
TBL_VALUE_TEMP.branch_id='||inpar_branch_id||
' and TBL_VALUE_TEMP.NODE_ID = ' || INPAR_NODE_ID ||
' AND req_id  = ' ||INPAR_REPreq_ID ||
' AND data_type  = 0 
   AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
 group by EFF_DATE 
 
   )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';
  END IF;
 end if;
 -----------------------------------------------------------------------------------------------------------
 -----------------------------------------------------------------------------------------------------------
if(inpar_branch_id is null OR inpar_branch_id='') then  -- Dar chand shobei , leaf nadarim
 
  select OSTAN_ID,SHAHR_ID,SHOBE_ID,code,DEPTH,NODE_ID into var_state_id,var_city_id,var_shobe_id, var_code,var_depth,var_node_id from tbl_ledger_branch where req_id=INPAR_REPreq_ID and  node_id=INPAR_NODE_ID;


if(CATEGORY_type=103 or CATEGORY_type=105) then -- deposit_branch    faghat baraye sathe akhar ke shobe ast 

 IF (INPAR_IS_LEAF = 1 )THEN    --Dar chand shobei , leaf nadarim
  select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp where req_id=INPAR_REPreq_ID and branch_id=var_shobe_id  and data_type=1;

SELECT
   MAX(MIN)
  ,MIN(MAX)
  INTO
   VAR_MIN_DATE,VAR_MAX_DATE
  FROM (
    SELECT
    MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    FROM dynamic_lq.TBL_VALUE_TEMP
    WHERE 
    REQ_ID            = INPAR_REPreq_ID
      AND branch_id   =var_shobe_id 
      and DATA_TYPE   = 2 
      );
      
 IF( VAR_MIN_DATE IS NULL OR VAR_MAX_DATE IS NULL )THEN
 
  RETURN ' select * from ( 
  
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
  DATA_TYPE "type"
FROM TBL_VALUE_TEMP where data_type=-85

  )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';

else

 RETURN ' select * from (  
 
 SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
    req_id                  = ' ||INPAR_REPreq_ID ||
  ' and branch_id           = '||var_shobe_id||
  ' AND data_type           =1
     AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
    group by EFF_DATE

union all
select sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
 max(DATA_TYPE) "type"
from TBL_VALUE_TEMP 
where 
    req_id    = ' ||INPAR_REPreq_ID ||
  ' and branch_id ='||var_shobe_id||
  ' and EFF_DATE between ' ||VAR_MIN_DATE ||' and ' || VAR_MAX_DATE ||
  ' and data_type = 2
    group by EFF_DATE

union all 
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
 max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE
   req_id            = ' ||INPAR_REPreq_ID ||
 ' and branch_id     = '||var_shobe_id||
 ' AND data_type     = 0 
    AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
   group by EFF_DATE
   
    )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';
end if;-- IF( VAR_MIN_DATE IS NULL OR VAR_MAX_DATE IS NULL )THEN


else -- IF (INPAR_IS_LEAF = 1 )THEN    --Dar chand shobei , leaf nadarim


 SELECT
 
   MAX(MIN)
  ,MIN(MAX)
INTO
   VAR_MIN_DATE,VAR_MAX_DATE
  FROM (
    SELECT
    branch_id,
     MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    FROM TBL_VALUE_TEMP
    WHERE 
    REQ_ID            = INPAR_REPreq_ID
      and DATA_TYPE   = 2
     AND
      branch_id IN 
   (
   select distinct(shobe_id)
  from tbl_ledger_branch 
  where req_id=INPAR_REPreq_ID and shobe_id!=0
  start with node_id=var_node_id
  connect by prior node_id = parent
)
group by branch_id
   );



end if;

 IF( VAR_MIN_DATE IS NULL OR VAR_MAX_DATE IS NULL )THEN
 
  RETURN ' select * from ( 
  
  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
  DATA_TYPE "type"
FROM TBL_VALUE_TEMP where data_type=-85

  )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';

else 

if(var_depth=2) then  --city
  select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp where req_id=INPAR_REPreq_ID and city_id=var_city_id  and data_type=1;

  RETURN ' select * from (  
  
  SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
    req_id                  = ' ||INPAR_REPreq_ID ||
  ' and CITY_ID           = '||var_city_id||
  ' AND data_type           =1
    AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
    group by EFF_DATE

union all
select sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
 max(DATA_TYPE) "type"
from TBL_VALUE_TEMP 
where 
    req_id    = ' ||INPAR_REPreq_ID ||
  ' and CITY_ID           = '||var_city_id||
  ' and EFF_DATE between ' ||VAR_MIN_DATE ||' and ' || VAR_MAX_DATE ||
  ' and data_type = 2
    group by EFF_DATE

union all 
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
 max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE
   req_id            = ' ||INPAR_REPreq_ID ||
 ' and CITY_ID           = '||var_city_id||
 ' AND data_type     = 0  
   AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
    group by EFF_DATE
  
    )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';
 
 elsif(var_depth=1) then --state
 select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp where req_id=INPAR_REPreq_ID and STATE_ID=var_state_id  and data_type=1;
  RETURN ' select * from ( 
  
  SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
    req_id                  = ' ||INPAR_REPreq_ID ||
  ' and STATE_ID           = '||var_state_id||
  ' AND data_type           =1 
   AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
    group by EFF_DATE

union all
select sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
 max(DATA_TYPE) "type"
from TBL_VALUE_TEMP 
where 
    req_id    = ' ||INPAR_REPreq_ID ||
  ' and STATE_ID           = '||var_state_id||
  ' and EFF_DATE between ' ||VAR_MIN_DATE ||' and ' || VAR_MAX_DATE ||
  ' and data_type = 2
    group by EFF_DATE

union all 
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
 max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE
   req_id            = ' ||INPAR_REPreq_ID ||
 ' and STATE_ID           = '||var_state_id||
 ' AND data_type     = 0  
   AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
   group by EFF_DATE
  
    )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';
 
  elsif(var_depth=0) then --iran
  select max(eff_date) into VAR_MAX_DATE_datatype1 from tbl_value_temp where req_id=INPAR_REPreq_ID   and data_type=1;

  RETURN ' select * from ( 
  
  SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
    req_id                  = ' ||INPAR_REPreq_ID ||
  ' AND data_type           =1 
   AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
    group by EFF_DATE

union all
select sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
 max(DATA_TYPE) "type"
from TBL_VALUE_TEMP 
where 
    req_id    = ' ||INPAR_REPreq_ID ||
  ' and EFF_DATE between ' ||VAR_MIN_DATE ||' and ' || VAR_MAX_DATE ||
  ' and data_type = 2
    group by EFF_DATE

union all 
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
 max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE
   req_id            = ' ||INPAR_REPreq_ID ||
 ' AND data_type     = 0  
  AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
   group by EFF_DATE
  
    )
pivot 
(
max("mande") for "type" in (0,1,2)
)
order by "date"';
 
 
 end if;
 
 
  
end if; -- IF( VAR_MIN_DATE IS NULL OR VAR_MAX_DATE IS NULL )THEN

--else ---- IF (INPAR_IS_LEAF = 1 )THEN
-- RETURN ' select * from (  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
--  DATA_TYPE "type"
--FROM TBL_VALUE_TEMP where data_type=-85';

--end if; -- IF (INPAR_IS_LEAF = 1 )THEN    --Dar chand shobei , leaf nadarim



else  --if(CATEGORY_type=103) then --------------------------------- 109

 select max(depth) into var_max_level from PRAGG.TBL_LEDGER_PROFILE_DETAIL where REF_LEDGER_PROFILE=var_LEDGER_PROFILE_ID ;
 
  SELECT
   MAX(MIN)
  ,MIN(MAX)
  INTO
   VAR_MIN_DATE,VAR_MAX_DATE
  FROM (
    SELECT
     NODE_ID
    ,MIN(EFF_DATE) MIN
    ,MAX(EFF_DATE) MAX
    FROM TBL_VALUE_TEMP
    WHERE 
    REQ_ID      = INPAR_REPreq_ID
     AND
      branch_id=var_shobe_id 
      and
      DATA_TYPE   = 2
     AND
       NODE_ID IN (
 
            SELECT
        ( CODE )
       FROM (
         SELECT DISTINCT
          CODE
         ,DEPTH
         FROM (
           SELECT
            *
           FROM pragg.tbl_ledger_profile_detail where REF_LEDGER_PROFILE=var_LEDGER_PROFILE_ID       ---------------------------------?????????
          )
         START WITH
          PARENT_CODE   = var_code
         CONNECT BY
          PRIOR CODE = PARENT_CODE
        )
       WHERE DEPTH   = var_max_level    ---------------------------------?????????
      )
    GROUP BY
     NODE_ID
   );

 END IF;

 IF
  ( VAR_MIN_DATE IS NULL
  OR
   VAR_MAX_DATE IS NULL
  )
 THEN
 --  RETURN -1;
  RETURN ' select * from (  SELECT mande "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",DATA_TYPE "type"
FROM TBL_VALUE_TEMP where data_type=-85';

 ELSE

  RETURN ' select * from (  SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
  max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
    req_id                  = ' ||INPAR_REPreq_ID ||
  ' and branch_id           = '||var_shobe_id||
  ' and depth               =1
    and  NODE_ID            = ' ||var_code ||
  ' AND data_type           =1
    AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
   group by EFF_DATE
   
union all
select sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type" 
from TBL_VALUE_TEMP 
where 
    req_id    = ' ||INPAR_REPreq_ID ||
  ' and branch_id ='||var_shobe_id||
  ' and EFF_DATE between ' ||VAR_MIN_DATE ||' and ' || VAR_MAX_DATE ||
  ' and NODE_ID = ' ||var_code || 
  ' and data_type = 2
    group by EFF_DATE

union all 
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE
   req_id            = ' ||INPAR_REPreq_ID ||
 ' and branch_id     = '||var_shobe_id||
 ' and NODE_ID       = ' || var_code || 
 ' AND data_type     = 0 
   AND EFF_DATE BETWEEN ('||VAR_MAX_DATE_datatype1||'-365) AND '||VAR_MAX_DATE_datatype1|| ' 
   group by EFF_DATE
  order by "date" desc';

 end if ;--if(CATEGORY_type=103) then
 end if;
 
 
END FNC_REPORT_MODEL_TEST_LEDBRN;
--------------------------------------------------------
--  DDL for Function FNC_REPORT_TOTAL_PREDICTION
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_REPORT_TOTAL_PREDICTION" (
 INPAR_REP_REQ_ID   IN NUMBER
 ,INPAR_NODE_ID      IN VARCHAR2
)/*1 leaf  |||||  0 parent*/ RETURN VARCHAR2 AS
 VAR_REQ   NUMBER;
 var_category number;
 VAR_CREATED_REPORT_DATE NUMBER;
 --104-106-107
BEGIN
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: TOTAL_PREDICTION   --104-106-107
  */
  /*------------------------------------------------------------------------------*/
select CATEGORY into var_category from tbl_rep_req where id=INPAR_REP_REQ_ID;
SELECT TO_CHAR(REQ_DATE,'J') INTO VAR_CREATED_REPORT_DATE FROM tbl_rep_req  where id=INPAR_REP_REQ_ID;
if (var_category=104) then 

 RETURN '
 select a.*,b."minInt",b."maxInt",b."isActineTunel" from (
 select * from(
 
 SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
  req_id= ' ||INPAR_REP_REQ_ID ||
 'and TBL_VALUE_TEMP.SEPORDE_TYPE = ' ||INPAR_NODE_ID || 
 ' AND data_type                = 1
    AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '  
   group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",max(DATA_TYPE) "type" FROM TBL_VALUE_TEMP 
WHERE 
   REQ_ID =' ||INPAR_REP_REQ_ID ||
 ' AND DATA_TYPE = 3  
   AND SEPORDE_TYPE = ' ||INPAR_NODE_ID ||'  
   group by EFF_DATE
   
UNION ALL
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE TBL_VALUE_TEMP.SEPORDE_TYPE = ' ||INPAR_NODE_ID ||' 
AND req_id                   = ' ||INPAR_REP_REQ_ID ||' 
AND data_type                = 0
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '   
group by EFF_DATE 
order by "date"  

)
pivot 
(
max("mande") for "type" in (0,1,3)
)
) a
left join
(select
 to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
sum(round(mande-interval,2)) as "minInt",
sum(round(mande+interval,2)) as "maxInt",max(IS_ACTIVE_TUNEL) as "isActineTunel"
from TBL_VALUE_temp,tbl_rep_req  where req_id=' ||INPAR_rep_req_ID ||' and TBL_VALUE_temp.req_id=tbl_rep_req.id and SEPORDE_TYPE =  ' ||INPAR_NODE_ID ||' and data_type=3 group by EFF_DATE)b
on a."date"=b."date" 
order by a."date" ';
-----------------------------------------------------------------
elsif (var_category=106) then 

 RETURN '
 select a.*,b."minInt",b."maxInt",b."isActineTunel" from (
 select * from(
 
 SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),
''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE 
  req_id= ' ||INPAR_REP_REQ_ID ||
 'and TBL_VALUE_TEMP.TASHILAT_TYPE = ' ||INPAR_NODE_ID || 
 ' AND data_type                = 1
    AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '  
   group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type" 
FROM TBL_VALUE_TEMP 
WHERE 
   REQ_ID =' ||INPAR_REP_REQ_ID ||
 ' AND DATA_TYPE = 3  
   AND TASHILAT_TYPE = ' ||INPAR_NODE_ID ||'  
   group by EFF_DATE
   
UNION ALL
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE TBL_VALUE_TEMP.TASHILAT_TYPE = ' ||INPAR_NODE_ID ||' 
AND req_id                   = ' ||INPAR_REP_REQ_ID ||' 
AND data_type                = 0
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '   
group by EFF_DATE 
order by "date" desc 

)
pivot 
(
max("mande") for "type" in (0,1,3)
)
) a
left join
(select
 to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
sum(round(mande-interval,2)) as "minInt",
sum(round(mande+interval,2)) as "maxInt",max(IS_ACTIVE_TUNEL) as "isActineTunel"
from TBL_VALUE_temp,tbl_rep_req  where req_id=' ||INPAR_rep_req_ID ||' and TBL_VALUE_temp.req_id=tbl_rep_req.id and TASHILAT_TYPE =  ' ||INPAR_NODE_ID ||' and data_type=3 group by EFF_DATE)b
on a."date"=b."date" 
order by a."date" ';
----------------------------------------------------------------------------
elsif (var_category=107) then 

 RETURN '
  select a.*,b."minInt",b."maxInt",b."isActineTunel" from (
 select * from(
 
 SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE TBL_VALUE_TEMP.NODE_ID = ' ||INPAR_NODE_ID ||
 ' AND req_id                   = ' ||INPAR_REP_REQ_ID ||
 ' AND data_type                = 1
    AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '  
   group by EFF_DATE

UNION ALL
SELECT sum(mande) "mande",to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",max(DATA_TYPE) "type" FROM TBL_VALUE_TEMP WHERE REQ_ID =' ||
 INPAR_REP_REQ_ID ||
 ' AND DATA_TYPE = 3  
   AND NODE_ID = ' ||INPAR_NODE_ID ||'  
   group by EFF_DATE
   
UNION ALL
SELECT sum(mande) "mande",
to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') "date",
max(DATA_TYPE) "type"
FROM TBL_VALUE_TEMP
WHERE TBL_VALUE_TEMP.NODE_ID = ' ||INPAR_NODE_ID ||' 
AND req_id                   = ' ||INPAR_REP_REQ_ID ||' 
AND data_type                = 0
 AND EFF_DATE BETWEEN ('||VAR_CREATED_REPORT_DATE||'-365) AND '||VAR_CREATED_REPORT_DATE|| '   
group by EFF_DATE 
order by "date" desc 

)
pivot 
(
max("mande") for "type" in (0,1,3)
)
) a
left join
(select
 to_char(to_date(EFF_DATE,''j''),''yyyy-mm-dd'',''nls_calendar=persian'') as "date",
sum(round(mande-interval,2)) as "minInt",
sum(round(mande+interval,2)) as "maxInt",max(IS_ACTIVE_TUNEL) as "isActineTunel"
from TBL_VALUE_temp,tbl_rep_req  where req_id=' ||INPAR_rep_req_ID ||' and TBL_VALUE_temp.req_id=tbl_rep_req.id and NODE_ID =  ' ||INPAR_NODE_ID ||' and data_type=3 group by EFF_DATE)b
on a."date"=b."date" 
order by a."date" ';

end if;

--select * from(
--)
--pivot 
--(
--max("mande") for "type" in (0,1,3)
--)
--order by "date" desc

END FNC_REPORT_TOTAL_PREDICTION;
--------------------------------------------------------
--  DDL for Function FNC_DASHBOARD_DAILY_REPORT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_DASHBOARD_DAILY_REPORT" RETURN VARCHAR2 AS 
BEGIN
  
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: DASHBOARD
  
  */
  /*------------------------------------------------------------------------------*/
return 'select
sum(IN_FLOW)  as "inFlow",
nvl(sum(OUT_FLOW),0) as "outFlow",
to_char(to_date(effdate,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')       as "effDate",
nvl(sum(GAP),0)      as "gap",
data_type as "dataType"
from TBL_DASHBOARD_DAILY_REPORT
where EFFDATE>to_char(sysdate-150,''j'')
group by effdate,data_type
order by effdate';
  
  
-- return ' select * from (
--  select
--sum(IN_FLOW)  as "inFlow",
--nvl(sum(OUT_FLOW),0) as "outFlow",
--to_char(to_date(effdate,''j''),''yyyy-mm-dd'',''nls_calendar=persian'')       as "effDate",
--nvl(sum(GAP),0)      as "gap",
--data_type as "dataType"
--from TBL_DASHBOARD_DAILY_REPORT
--group by effdate,data_type
--order by effdate  
--  )
--pivot 
--(
--max("mande") for "type" in (1,)
--)
--order by "date" ';
  
END FNC_DASHBOARD_DAILY_REPORT;
--------------------------------------------------------
--  DDL for Function FNC_GET_PARAM
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_GET_PARAM" 
(
  INPAR_ID IN varchar2   --h_id az TBL_PROFIL_MODEL_SETTING

) RETURN VARCHAR2 AS
var_cnt   number;

pragma autonomous_transaction;
BEGIN
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description:
  namayesh shart haye safheye tanzimat shabake asabi
  */
  /*------------------------------------------------------------------------------*/
    
select count(*) into var_cnt from  TBL_PROFIL_MODEL_SETING_DETAIL where REF_PROFILE_ID=INPAR_ID;
  
if(var_cnt=0 ) then --insert
insert into TBL_PROFIL_MODEL_SETING_DETAIL
(
FA_NAME,
EN_NAME,
DES,
REF_PROFILE_ID
)
select 
FA_NAME,
EN_NAME,
DES,
INPAR_ID
from TBL_NN_PARAM_NAMES order by id;
commit;
end if;



return '
select 
msd.id "id",
msd.FA_NAME "faName",
msd.EN_NAME "enName",
msd.DES "description",
msd.value "value",
nn.MIN "min",
nn.max "max"
from  TBL_PROFIL_MODEL_SETING_DETAIL msd ,tbl_nn_param_names nn where
REF_PROFILE_ID='||INPAR_ID||' 
and  msd.EN_NAME=nn.EN_NAME
order by msd.id';

--
--return 'select 
--id "id",
--FA_NAME "faName",
--EN_NAME "enName",
--DES "description",
--value "value"
--from  TBL_PROFIL_MODEL_SETING_DETAIL where REF_PROFILE_ID='||INPAR_ID||' order by id';
END FNC_GET_PARAM;
--------------------------------------------------------
--  DDL for Function FNC_GET_PROFILE_SETTING
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_GET_PROFILE_SETTING" (
    INPAR_TYPE IN VARCHAR2 ) RETURN VARCHAR2 AS 
    var_cnt number;
    pragma autonomous_transaction;
BEGIN
/*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description:
  namayesh etelate profile haye fa'ale tanzimate shabake asabi
  */
  /*------------------------------------------------------------------------------*/
 var_cnt:=0;
 --baraye moshakhas kardane inke shart haye har profile tavasote karbar takmil shodeand ya kheyr 
  for i in (select id from TBL_PROFILE_MODEL_SETTING) loop
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

  return 'SELECT 
  ID as "profileId",
  NAME as "name",
  TYPE as "type",
  CREATE_DATE as "createDate",
  REF_USER as "user",
  DES as "des",
  H_ID as "id",
  IS_EMPTY as "is_empty",
  report_cnt as "reportCount",
  IS_ACTIVE as "isActive"
FROM TBL_PROFILE_MODEL_SETTING 
where  status=1 
and id in  (select distinct first_value(ID)over ( partition BY H_ID order by id DESC )FROM TBL_PROFILE_MODEL_SETTING) order by id desc';


--and upper(TYPE) =upper('''||INPAR_TYPE||''')
END FNC_GET_PROFILE_SETTING;
--------------------------------------------------------
--  DDL for Function FNC_NN_ACTV_ERROR
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_NN_ACTV_ERROR" (INPAR_EN_NAME in varCHar2) RETURN VARCHAR2 AS 
BEGIN
  /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: 
  */
  /*------------------------------------------------------------------------------*/ 
 IF(INPAR_EN_NAME=UPPER('ACTV_FUNC')) THEN
 RETURN ' 
 SELECT 
 CODE AS "code",
 DESCRIPTION as "description"
 FROM NN_ACTV_FUNC_DETAILS
 order by code';
 
 ELSIF(INPAR_EN_NAME=UPPER('ERROR_FUNC')) THEN
 RETURN ' 
 SELECT 
 CODE AS "code",
 DESCRIPTION as "description"
 FROM NN_ERROR_FUNC_DETAILS
  order by code';
 END IF;
  
END FNC_NN_ACTV_ERROR;
--------------------------------------------------------
--  DDL for Function FNC_PERCENTAGE_ERROR_MODELTEST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_PERCENTAGE_ERROR_MODELTEST" 
(
  INPAR_REP_REQ_ID IN VARCHAR2 
, INPAR_NODE_ID IN VARCHAR2 
, INPAR_BRANCH_ID IN VARCHAR2  --if(null)==>report_type: 107(daftarkoll)   else 108 (daftarkol shobe)
, INPAR_IS_LEAF IN VARCHAR2  --1=leaf
) RETURN VARCHAR2 AS 
var1 number;
var2 number;
var_category number;
var_ORIGINAL_ID number;
var_state_id number;
var_city_id number;
var_shobe_id number;
var_code number;
var_depth number;
BEGIN
  select category,ORIGINAL_ID into var_category,var_ORIGINAL_ID from tbl_rep_req where id=INPAR_REP_REQ_ID;
  --select ORIGINAL_ID into var_ORIGINAL_ID from reports where id=(select report_id from tbl_rep_req where  id=INPAR_REP_REQ_ID);

----------------------------------------------------------------------------------------  
   if(var_category=107) then 

   
   if (INPAR_IS_LEAF=1) then 
   return '
   select 
   0||to_char(sum(ROUND(GL_ERROR, 2))) "percentageError"
    from reports_error where REPORT_ID='||var_ORIGINAL_ID||' and REPORT_TYPE=107 and NODE_ID='||INPAR_NODE_ID||'';
    else
    
    select round(sum(a),2) into var1 from (
select node_id,GL_ERROR,sum_type2,GL_ERROR*sum_type2 as a,report_type from REPORTS_ERROR where REPORT_ID=var_ORIGINAL_ID and report_type=107 and  node_id in (
SELECT ledger_code
FROM   TBL_LEDGER
START WITH LEDGER_CODE=INPAR_NODE_ID
CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE )
);

    select round(sum(sum_type2),2) into var2 from (
select node_id,GL_ERROR,sum_type2,report_type from REPORTS_ERROR where REPORT_ID=var_ORIGINAL_ID and report_type=107 and  node_id in (
SELECT ledger_code
FROM   TBL_LEDGER
START WITH LEDGER_CODE=INPAR_NODE_ID
CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE )
);    
 return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual';   
    
  end if;  --if (INPAR_IS_LEAF=1) then
  
  end if;
------------------------------------------------------------------------------  
  if(var_category=108) then 
  --  select OSTAN_ID,SHAHR_ID,SHOBE_ID,code,DEPTH into var_state_id,var_city_id,var_shobe_id, var_code,var_depth from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and  node_id=INPAR_NODE_ID;

  if (INPAR_IS_LEAF=1) then
   return '
   select 
   0||to_char(sum(ROUND(GL_ERROR, 2))) "percentageError"
    from reports_error where REPORT_ID='||var_ORIGINAL_ID||' and REPORT_TYPE=108 and SHOBE_ID='||INPAR_BRANCH_ID||' and  NODE_ID='||INPAR_NODE_ID||'';
  else  --if (INPAR_IS_LEAF=1) then
  
   select sum(a) into var1 from (
select node_id,GL_ERROR,sum_type2,GL_ERROR*sum_type2 as a,report_type from REPORTS_ERROR where REPORT_ID=var_ORIGINAL_ID and report_type=108 and shobe_id=INPAR_BRANCH_ID and  node_id in (
SELECT ledger_code
FROM   TBL_LEDGER
START WITH LEDGER_CODE=INPAR_NODE_ID
CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE )
);

    select sum(sum_type2) into var2 from (
select node_id,GL_ERROR,sum_type2,report_type from REPORTS_ERROR where REPORT_ID=var_ORIGINAL_ID and report_type=108 and  shobe_id=INPAR_BRANCH_ID and  node_id in (
SELECT ledger_code
FROM   TBL_LEDGER
START WITH LEDGER_CODE=INPAR_NODE_ID
CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE )
);    
 return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual';   
 end if; --if(INPAR_BRANCH_ID is not null) then
 end if;
 ------------------------------------- 
    if(var_category=103) then 
    select OSTAN_ID,SHAHR_ID,SHOBE_ID,code,DEPTH into var_state_id,var_city_id,var_shobe_id, var_code,var_depth from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and  node_id=INPAR_NODE_ID;

  if (INPAR_IS_LEAF=1) then
   return '
   select 
   0||to_char(sum(ROUND(DEP_BR_ERROR, 2))) "percentageError"
    from reports_error where REPORT_ID='||var_ORIGINAL_ID||' and REPORT_TYPE=103 and SHOBE_ID='||var_shobe_id||'';
  else
  
   if(var_depth=2) then  --city
     select sum(a) into var1 from (
   select DEP_BR_ERROR,sum_type2,DEP_BR_ERROR*sum_type2 as a,report_type
    from reports_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and shahr_id=var_city_id and shobe_id!=0)
    ) ;
    
      select sum(sum_type2) into var2 from (
   select DEP_BR_ERROR,sum_type2,report_type
    from reports_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and shahr_id=var_city_id and shobe_id!=0)
    ) ; 
    return 'select ROUND('||var1||' / '||var2||', 2) as "percentageError" from dual'; 
    
    elsif(var_depth=1) then --ostan
      select sum(a) into var1 from (
   select DEP_BR_ERROR,sum_type2,DEP_BR_ERROR*sum_type2 as a,report_type
    from reports_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and ostan_id=var_state_id and shobe_id!=0)
    ) ;
    
      select sum(sum_type2) into var2 from (
   select DEP_BR_ERROR,sum_type2,report_type
    from reports_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and ostan_id=var_state_id and shobe_id!=0)
    ) ; 
     return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual'; 
     
      elsif(var_depth=0) then --iran - tamame shobe hayi ke dar profile entekhab shode
      select sum(a) into var1 from (
   select DEP_BR_ERROR,sum_type2,DEP_BR_ERROR*sum_type2 as a,report_type
    from reports_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID  and shobe_id!=0)
    ) ;
    
      select sum(sum_type2) into var2 from (
   select DEP_BR_ERROR,sum_type2,report_type
    from reports_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID  and shobe_id!=0)
    ) ; 
     return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual'; 
     
     
    end if;
 end if; --if(INPAR_BRANCH_ID is not null) then
 end if;
     --------------------------------------------
   if(var_category=105) then 
    select OSTAN_ID,SHAHR_ID,SHOBE_ID,code,DEPTH into var_state_id,var_city_id,var_shobe_id, var_code,var_depth from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and  node_id=INPAR_NODE_ID;

  if (INPAR_IS_LEAF=1) then
   return '
   select 
    0||to_char(sum(ROUND(LOAN_BR_ERROR, 2))) "percentageError"
    from reports_error where REPORT_ID='||var_ORIGINAL_ID||' and REPORT_TYPE=105 and SHOBE_ID='||var_shobe_id||'';
    
  else 
   
   if(var_depth=2) then  --city
   
     select sum(a) into var1 from (
   select LOAN_BR_ERROR,sum_type2,LOAN_BR_ERROR*sum_type2 as a,report_type
    from reports_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=105 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and shahr_id=var_city_id and shobe_id!=0)
    ) ;
    
      select sum(sum_type2) into var2 from (
   select LOAN_BR_ERROR,sum_type2,report_type
    from reports_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=105 and shobe_id in 
     (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and shahr_id=var_city_id and shobe_id!=0)
    ) ; 
    return 'select  0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual'; 
    
    elsif(var_depth=1) then --ostan
    
      select sum(a) into var1 from (
   select LOAN_BR_ERROR,sum_type2,LOAN_BR_ERROR*sum_type2 as a,report_type
    from reports_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=105 and  shobe_id in 
     (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and ostan_id=var_state_id and shobe_id!=0)
    ) ;
    
      select sum(sum_type2) into var2 from (
   select LOAN_BR_ERROR,sum_type2,report_type
    from reports_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=105 and shobe_id in 
     (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and ostan_id=var_state_id and shobe_id!=0)
    ) ; 
     return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual'; 
     
      elsif(var_depth=0) then --iran - tamame shobe hayi ke dar profile entekhab shode
      
      select sum(a) into var1 from (
   select LOAN_BR_ERROR,sum_type2,LOAN_BR_ERROR*sum_type2 as a,report_type
    from reports_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=105 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID  and shobe_id!=0)
    ) ;
    
      select sum(sum_type2) into var2 from (
   select LOAN_BR_ERROR,sum_type2,report_type
    from reports_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=105 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID  and shobe_id!=0)
    ) ; 
     return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual'; 
     
     
    end if;
 end if; --if(INPAR_BRANCH_ID is not null) then
 end if;  
   ------------------------------------------------------------------  
   if(var_category=104) then 

  if (INPAR_IS_LEAF=1) then
   return '
   select 
   0||to_char(sum(ROUND(DEP_TYPE_ERROR, 2))) "percentageError"
    from reports_error where REPORT_ID='||var_ORIGINAL_ID||' and REPORT_TYPE=104 and seporde_type='||INPAR_NODE_ID||'';
  else return 'select -1 as "percentageError" from dual';
 end if; --if(INPAR_BRANCH_ID is not null) then
 end if;  
 ----------------------------------------------------
   if(var_category=106) then 

  if (INPAR_IS_LEAF=1) then
   return '
   select 
   0||to_char(sum(ROUND(LOAN_TYPE_ERROR, 2))) "percentageError"
    from reports_error where REPORT_ID='||var_ORIGINAL_ID||' and REPORT_TYPE=106 and tashilat_type='||INPAR_NODE_ID||'';
  else return 'select -1 as "percentageError" from dual';
 end if; --if(INPAR_BRANCH_ID is not null) then
 end if; 
     
END FNC_PERCENTAGE_ERROR_MODELTEST;
--------------------------------------------------------
--  DDL for Function FNC_PERCENTAGE_ERROR_BACKTEST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_PERCENTAGE_ERROR_BACKTEST" 
(
  INPAR_REP_REQ_ID IN VARCHAR2 
, INPAR_NODE_ID IN VARCHAR2 
, INPAR_BRANCH_ID IN VARCHAR2  --if(null)==>report_type: 107(daftarkoll)   else 108 (daftarkol shobe)
, INPAR_IS_LEAF IN VARCHAR2  --1=leaf
) RETURN VARCHAR2 AS 
var1 number;
var2 number;
var_category number;
var_ORIGINAL_ID number;
var_state_id number;
var_city_id number;
var_shobe_id number;
var_code number;
var_depth number;
BEGIN
   select category,ORIGINAL_ID into var_category,var_ORIGINAL_ID from tbl_rep_req where id=INPAR_REP_REQ_ID;


   if(var_category=107) then 

   
   if (INPAR_IS_LEAF=1) then 
   return '
   select 
    0||to_char(ROUND(GL_ERROR, 2)) "percentageError"
    from back_test_error where REPORT_ID='||var_ORIGINAL_ID||' and REPORT_TYPE=107 and NODE_ID='||INPAR_NODE_ID||'';
    else
    
    select round(sum(a),2) into var1 from (
select node_id,GL_ERROR,sum_type2,GL_ERROR*sum_type2 as a,report_type from back_test_error where REPORT_ID=var_ORIGINAL_ID and report_type=107 and  node_id in (
SELECT ledger_code
FROM   TBL_LEDGER
START WITH LEDGER_CODE=INPAR_NODE_ID
CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE )
);

    select round(sum(sum_type2),2) into var2 from (
select node_id,GL_ERROR,sum_type2,report_type from back_test_error where REPORT_ID=var_ORIGINAL_ID and report_type=107 and  node_id in (
SELECT ledger_code
FROM   TBL_LEDGER
START WITH LEDGER_CODE=INPAR_NODE_ID
CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE )
);    
 return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual';   
    
  end if;  --if (INPAR_IS_LEAF=1) then
  
  end if;
 -------------------------------------------------------- 
  if(var_category=108) then 

  if (INPAR_IS_LEAF=1) then
   return '
   select 
    0||to_char(ROUND(GL_ERROR, 2)) "percentageError"
    from back_test_error where REPORT_ID='||var_ORIGINAL_ID||' and REPORT_TYPE=108 and SHOBE_ID='||INPAR_BRANCH_ID||' NODE_ID='||INPAR_NODE_ID||'';
  else  --if (INPAR_IS_LEAF=1) then
  
   select sum(a) into var1 from (
select node_id,GL_ERROR,sum_type2,GL_ERROR*sum_type2 as a,report_type from back_test_error where REPORT_ID=var_ORIGINAL_ID and report_type=108 and  node_id in (
SELECT ledger_code
FROM   TBL_LEDGER
START WITH LEDGER_CODE=INPAR_NODE_ID
CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE )
);

    select sum(sum_type2) into var2 from (
select node_id,GL_ERROR,sum_type2,report_type from back_test_error where REPORT_ID=var_ORIGINAL_ID and report_type=108 and  node_id in (
SELECT ledger_code
FROM   TBL_LEDGER
START WITH LEDGER_CODE=INPAR_NODE_ID
CONNECT BY PRIOR LEDGER_CODE = PARENT_CODE )
);    
 return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual';   
 end if; --if(INPAR_BRANCH_ID is not null) then
 end if;
 ------------------------------------- 
   if(var_category=103) then 
    select OSTAN_ID,SHAHR_ID,SHOBE_ID,code,DEPTH into var_state_id,var_city_id,var_shobe_id, var_code,var_depth from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and  node_id=INPAR_NODE_ID;

  if (INPAR_IS_LEAF=1) then-- depth3
   return '
   select 
    0||to_char(sum(ROUND(DEP_BR_ERROR, 2))) "percentageError"
    from back_test_error where REPORT_ID='||var_ORIGINAL_ID||' and REPORT_TYPE=103 and SHOBE_ID='||var_shobe_id||'';
   else
   
   if(var_depth=2) then  --city
     select sum(a) into var1 from (
   select DEP_BR_ERROR,sum_type2,DEP_BR_ERROR*sum_type2 as a,report_type
    from back_test_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and shahr_id=var_city_id and shobe_id!=0)
    ) ;
    
      select sum(sum_type2) into var2 from (
   select DEP_BR_ERROR,sum_type2,report_type
    from back_test_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and shahr_id=var_city_id and shobe_id!=0)
    ) ; 
    return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual'; 
    
    elsif(var_depth=1) then --ostan
      select sum(a) into var1 from (
   select DEP_BR_ERROR,sum_type2,DEP_BR_ERROR*sum_type2 as a,report_type
    from back_test_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and ostan_id=var_state_id and shobe_id!=0)
    ) ;
    
      select sum(sum_type2) into var2 from (
   select DEP_BR_ERROR,sum_type2,report_type
    from back_test_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and ostan_id=var_state_id and shobe_id!=0)
    ) ; 
     return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual'; 
     
      elsif(var_depth=0) then --iran - tamame shobe hayi ke dar profile entekhab shode
      select sum(a) into var1 from (
   select DEP_BR_ERROR,sum_type2,DEP_BR_ERROR*sum_type2 as a,report_type
    from back_test_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID  and shobe_id!=0)
    ) ;
    
      select sum(sum_type2) into var2 from (
   select DEP_BR_ERROR,sum_type2,report_type
    from back_test_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID  and shobe_id!=0)
    ) ; 
     return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual'; 
     
     
    end if;
--  else return 'select -1 as "percentageError" from dual';
 end if; --if(INPAR_BRANCH_ID is not null) then
 end if;
     --------------------------------------------
   if(var_category=105) then 
    select OSTAN_ID,SHAHR_ID,SHOBE_ID,code,DEPTH into var_state_id,var_city_id,var_shobe_id, var_code,var_depth from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and  node_id=INPAR_NODE_ID;

  if (INPAR_IS_LEAF=1) then
  
   return '
   select 
    0||to_char(sum(ROUND(LOAN_BR_ERROR, 2))) "percentageError"
    from back_test_error where REPORT_ID='||var_ORIGINAL_ID||' and REPORT_TYPE=105 and SHOBE_ID='||var_shobe_id||'';
    
       else
   
   if(var_depth=2) then  --city
   
     select sum(a) into var1 from (
   select LOAN_BR_ERROR,sum_type2,LOAN_BR_ERROR*sum_type2 as a,report_type
    from back_test_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=105 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and shahr_id=var_city_id and shobe_id!=0)
    ) ;
    
      select sum(sum_type2) into var2 from (
   select LOAN_BR_ERROR,sum_type2,report_type
    from back_test_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=105 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and shahr_id=var_city_id and shobe_id!=0)
    ) ; 
    return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual'; 
    
    elsif(var_depth=1) then --ostan
    
      select sum(a) into var1 from (
   select LOAN_BR_ERROR,sum_type2,LOAN_BR_ERROR*sum_type2 as a,report_type
    from back_test_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=105 and shobe_id in 
     (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and ostan_id=var_state_id and shobe_id!=0)
    ) ;
    
      select sum(sum_type2) into var2 from (
   select LOAN_BR_ERROR,sum_type2,report_type
    from back_test_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=103 and shobe_id in 
     (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID and ostan_id=var_state_id and shobe_id!=0)
    ) ; 
     return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual'; 
     
      elsif(var_depth=0) then --iran - tamame shobe hayi ke dar profile entekhab shode
      
      select sum(a) into var1 from (
   select LOAN_BR_ERROR,sum_type2,LOAN_BR_ERROR*sum_type2 as a,report_type
    from back_test_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=105 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID  and shobe_id!=0)
    ) ;
    
      select sum(sum_type2) into var2 from (
   select LOAN_BR_ERROR,sum_type2,report_type
    from back_test_error where REPORT_ID=var_ORIGINAL_ID and REPORT_TYPE=105 and shobe_id in 
    (select distinct(shobe_id) from tbl_ledger_branch where req_id=INPAR_REP_REQ_ID  and shobe_id!=0)
    ) ; 
     return 'select 0||to_char(ROUND('||var1||' / '||var2||', 2)) as "percentageError" from dual'; 
     
     
    end if;
    
--  else return 'select -1 as "percentageError" from dual';
  
 end if; --if(INPAR_BRANCH_ID is not null) then
 end if;  
   ------------------------------------------------------------------  
   if(var_category=104) then 

  if (INPAR_IS_LEAF=1) then
   return '
   select 
    0||to_char(sum(ROUND(DEP_TYPE_ERROR, 2))) "percentageError"
    from back_test_error where REPORT_ID='||var_ORIGINAL_ID||' and REPORT_TYPE=104 and seporde_type='||INPAR_NODE_ID||'';
  else return 'select -1 as "percentageError" from dual';
  
 end if; --if(INPAR_BRANCH_ID is not null) then
 end if;  
 ----------------------------------------------------
   if(var_category=106) then 

  if (INPAR_IS_LEAF=1) then
   return '
   select 
    0||to_char(sum(ROUND(LOAN_TYPE_ERROR, 2))) "percentageError"
    from back_test_error where REPORT_ID='||var_ORIGINAL_ID||' and REPORT_TYPE=106 and tashilat_type='||INPAR_NODE_ID||'';
    
    else return 'select -1 as "percentageError" from dual';
  
 end if; --if(INPAR_BRANCH_ID is not null) then
 end if;  
END FNC_PERCENTAGE_ERROR_BACKTEST;
--------------------------------------------------------
--  DDL for Function FNC_GET_DYNAMIC_GAP
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_GET_DYNAMIC_GAP" 
(
  INPAR_REP_REQ_ID IN NUMBER  
) RETURN clob AS  
var_TIMING_PROFILE_ID number;
var_type_timing_profile number;
var_PERIOD_START number;
var_PERIOD_end number;
var_PERIOD_DATE number;
var_sysdate number:=null;
var clob:=null;
var_x_timing_detail varchar2(4000);
var_x_timing_detail_1 varchar2(4000);
var_output clob;
INPAR_REPORT_ID number;
var_ledger_ID number;
max_eff_date number;
var_befor_date number;
var_min_effdate number;
var_cnt number;
pragma autonomous_transaction;
BEGIN
-- EXECUTE IMMEDIATE 'truncate table dynamic_lq.TBL_gap ';


select report_id into INPAR_REPORT_ID from tbl_rep_req where id=inpar_rep_req_id and CATEGORY=170;
select TIMING_PROFILE_ID into var_TIMING_PROFILE_ID from reports where id=INPAR_REPORT_ID; -- 2 khatte bala bejaye in  age niyaz be tagheer shod
select type into var_type_timing_profile from PRAGG.TBL_TIMING_PROFILE where id=var_TIMING_PROFILE_ID; 
select LEDGER_PROFILE_ID into var_ledger_ID from reports where id=INPAR_REPORT_ID;
 select max(eff_date)  into max_eff_date from dynamic_lq.daftar_kol; --faghat baraye daftarkol 107


 select 
 (select  listagg(id||' AS "x'||id||'"',',') within group (order by id)  from (
select id from(
  SELECt id,max(PERIOD_NAME)
 FROM PRAGG.TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = var_TIMING_PROFILE_ID 
GROUP BY id order by id) order by id))
into var_x_timing_detail from dual ;

select 
 (select  listagg(' "x'||id||'"',',') within group (order by id)  from (
select id from(
  SELECt id,max(PERIOD_NAME)
 FROM PRAGG.TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = var_TIMING_PROFILE_ID 
GROUP BY id order by id) order by id))
into var_x_timing_detail_1 from dual ;


select count (*) into var_cnt from tbl_gap where req_id=INPAR_REP_REQ_ID and rownum<5;
if(var_cnt=0) then 
------------------------------------------------------------------------------------------------------------------------------------------
 for i in (  select * from PRAGG.TBL_TIMING_PROFILE_DETAIL where REF_TIMING_PROFILE=var_TIMING_PROFILE_ID order by id) loop
 select count (*) into var_cnt from tbl_value_gap where req_id=INPAR_REP_REQ_ID and   REF_TIMING=i.id ;
if(var_cnt!=0) then --agar baze entekhab shode vajod dasht

 if(var_type_timing_profile=2) then --tarikhi
 
  select TO_CHAR(TO_DATE(PERIOD_END),'J')   into var_PERIOD_end   from pragg.TBL_TIMING_PROFILE_DETAIL where id=i.id;

---------------- baraye avalin ruze har baze agar type3 vojud  nadasht ==type1    /// 

 select case when min (eff_date)-1 is null then 0 else min(eff_date)-1 end into var_befor_date  from tbl_value_gap where req_id=INPAR_REP_REQ_ID and REF_TIMING=i.id;
 select count(*) into var_cnt from  tbl_value_gap where req_id=INPAR_REP_REQ_ID and   REF_TIMING=i.id and eff_date=var_befor_date  and rownum<5;
 
 var_min_effdate:=var_befor_date+1;
 
 if (var_cnt!=0) then  --tbl_value_gap
 insert into tbl_gap(
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 a.ref_timing as REF_TIMING_DETAIL
 ,a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_gap b
ON a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
 AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
 
 commit;


 else
 
 dbms_output.put_line(' select case when eff_date is null then 0 else eff_date end  into var_befor_date  from tbl_value_temp_gap where req_id='||INPAR_REP_REQ_ID||' and data_type=3 and eff_date='||var_befor_date||''
);
 
-- select case when eff_date is null then 0 else eff_date end  into var_befor_date  from tbl_value_temp_gap where req_id=INPAR_REP_REQ_ID and data_type=3 and eff_date=var_befor_date;
  select count(*) into var_cnt from  tbl_value_temp_gap where req_id=INPAR_REP_REQ_ID and data_type=3 and eff_date=var_befor_date and rownum<5;

 if (var_cnt!=0) then --tbl_value_temp
 insert into tbl_gap(
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT  a.ref_timing as REF_TIMING_DETAIL,a.NODE_ID,  a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_temp_gap b
ON a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
AND b.data_type=3
AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
 commit;

--  
     else -- if (var_befor_date=!0) then  --tbl_value_temp
     
 insert into tbl_gap(
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT  a.ref_timing as REF_TIMING_DETAIL,a.NODE_ID,  a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_temp_gap b
ON a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
AND b.data_type=1
AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
  
  commit;
  end if;--tbl_value_temp
  end if;--if (var_befor_date!=0) then  --tbl_value_gap
  
-------
------- baraye ruzhaye bad az avvalin ruze har baze 
var_min_effdate:=var_min_effdate+1;
while (var_min_effdate<=var_PERIOD_end ) loop

 insert into tbl_gap(
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 a.ref_timing as REF_TIMING_DETAIL
 ,a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_gap b
ON a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
 AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_min_effdate-1
 AND a.ref_timing=i.id;
commit;
var_min_effdate:=var_min_effdate+1;
end loop;

-------



----------------------------------------------  bazeeeeeeeeeeeeeeeeeeeeeeeee
----------------------------------------------
else

select PERIOD_DATE into var_PERIOD_DATE from pragg.TBL_TIMING_PROFILE_DETAIL where id=i.id;

if(var_sysdate is null) then
 select TO_CHAR(TO_DATE(sysdate),'J') into var_sysdate from dual;
var_PERIOD_START:=var_sysdate;
else
 select TO_CHAR(TO_DATE(sysdate),'J') into var_sysdate from dual;
var_PERIOD_START:=var_PERIOD_end;
end if;
var_PERIOD_end:=var_PERIOD_START+var_PERIOD_DATE;


---------------- baraye avalin ruze har baze agar type3 vojud  nadasht ==type1    /// 

 select case when min (eff_date)-1 is null then 0 else min(eff_date)-1 end into var_befor_date  from tbl_value_gap where req_id=INPAR_REP_REQ_ID and REF_TIMING=i.id;
 select count(*) into var_cnt from  tbl_value_gap where req_id=INPAR_REP_REQ_ID and   REF_TIMING=i.id and eff_date=var_befor_date  and rownum<5;
 
 var_min_effdate:=var_befor_date+1;
 
  if (var_cnt!=0) then  --tbl_value_gap
 insert into tbl_gap(
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 a.ref_timing as REF_TIMING_DETAIL
 ,a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_gap b
ON a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
 AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
 
 commit;


 else
 
 
-- select case when eff_date is null then 0 else eff_date end  into var_befor_date  from tbl_value_temp_gap where req_id=INPAR_REP_REQ_ID and data_type=3 and eff_date=var_befor_date;
  select count(*) into var_cnt from  tbl_value_temp_gap where req_id=INPAR_REP_REQ_ID and data_type=3 and eff_date=var_befor_date and rownum<5;

 if (var_cnt!=0) then --tbl_value_temp
 insert into tbl_gap(
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT  a.ref_timing as REF_TIMING_DETAIL,a.NODE_ID,  a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_temp_gap b
ON a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
AND b.data_type=3
AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
 commit;

--  
     else -- if (var_befor_date=!0) then  --tbl_value_temp
     
 insert into tbl_gap(
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT  a.ref_timing as REF_TIMING_DETAIL,a.NODE_ID,  a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_temp_gap b
ON a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
AND b.data_type=1
AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
  
  commit;
  end if;--tbl_value_temp
  end if;--if (var_befor_date!=0) then  --tbl_value_gap
  
-------
------- baraye ruzhaye bad az avvalin ruze har baze 
var_min_effdate:=var_min_effdate+1;
while (var_min_effdate<=var_PERIOD_end ) loop

 insert into tbl_gap(
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 a.ref_timing as REF_TIMING_DETAIL
 ,a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_gap b
ON a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
 AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_min_effdate-1
 AND a.ref_timing=i.id;
commit;
var_min_effdate:=var_min_effdate+1;
end loop;



end if ; --if(var_type_timing_profile=2) then --tarikhi

end if;--if(var_cnt!=0) then --agar baze entekhab shode vajod dasht
end loop;--
 
end if;--if(var_cnt!=0) then 

var_output:='select a.*,b."mande"  from (

SELECT code AS "id",PARENT_CODE as  "parent", name as "text",'||var_x_timing_detail_1||',"level"
from (
select * 
from (
 select "ref_timing_detail",code,PARENT_CODE,name,"gap","level" from  (
    (SELECT a.*,
      lpd.code,lpd.name,lpd.PARENT_CODE,lpd.REF_LEDGER_PROFILE,lpd.DEPTH as "level"
    FROM
      (SELECT node_id,
        MAX(ref_timing_detail) AS "ref_timing_detail",
        MAX(parent)            AS "parent",
        SUM(gap)               AS "gap"
      FROM (
        (SELECT b.ref_timing_detail,
          b.NODE_ID,
          b.arz_id,
          b.depth,
          b.parent,
          b.MANDE,
          b.EFF_DATE,
          CASE
            WHEN l.node_type=2
            THEN b.gap*-1
            WHEN l.node_type=1
            THEN b.gap*1
            ELSE 0
          END AS gap
        FROM ((select REF_TIMING_DETAIL,NODE_ID,arz_id,depth,parent,mande,eff_date,gap from tbl_gap where req_id='||INPAR_REP_REQ_ID||'
           )b
        INNER JOIN tbl_ledger l
        ON b.node_id=l.ledger_code )
        ) 
        )
      GROUP BY node_id,
        ref_timing_detail
      ) a
    right JOIN pragg.tbl_ledger_profile_detail lpd
    ON   a.node_id  =lpd.code ) 
  )where  rEF_LEDGER_PROFILE='||var_ledger_ID||'
  )
  pivot  
(  
max("gap") for  "ref_timing_detail" in ('||var_x_timing_detail||') 
)  
order by code  
)

) a left outer join 
(select node_id,sum(mande) as "mande"  from dynamic_lq.daftar_kol where eff_date='||max_eff_date||'  group by node_id)b
on a."id"=b.node_id 
order by a."id"';

 
 RETURN var_output;
END "FNC_GET_DYNAMIC_GAP";
--------------------------------------------------------
--  DDL for Function FNC_DYNAMIC_GAP_LED_BRANCH
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "DYNAMIC_LQ"."FNC_DYNAMIC_GAP_LED_BRANCH" (
   INPAR_REP_REQ_ID IN NUMBER 
, INPAR_BRANCH_ID IN NUMBER 
) RETURN clob AS  
var_TIMING_PROFILE_ID   number;
var_type_timing_profile number;
var_PERIOD_START        number;
var_PERIOD_end          number;
var_PERIOD_DATE         number;
var_rep_id              number;
var_sysdate             number:=null;
var                     clob:=null;
var_x_timing_detail     varchar2(4000);
var_x_timing_detail_1   varchar2(4000);
var_output              clob;
INPAR_REPORT_ID         number;
var_parent              number;
var_BRANCH_ID            number;
var_ledger_ID           number;
var_befor_date  number;
var_min_effdate  number;
max_eff_date number;
max_level number;
var_cnt number;
pragma autonomous_transaction;
BEGIN
 /*------------------------------------------------------------------------------*/
  /*
  Programmer Name: sobhan.sadeghzadeh
  Editor Name:
  Release Date/Time:
  Edit Name:
  Version: 1
  Description: namayesh derakht daftar kol shobei baraye gozaresh shekafe daftar kol shobei --180
  baraye tak shobe va chand shobe
  
  */
  /*------------------------------------------------------------------------------*/
execute IMMEDIATE 'truncate table tbl_temp';
var_rep_id:=inpar_rep_req_id;
 select max(eff_date)  into max_eff_date from dynamic_lq.daftar_kol_shobe; --faghat baraye daftarkol 107


SELECT report_id
INTO INPAR_REPORT_ID
FROM tbl_rep_req
WHERE id=inpar_rep_req_id;

SELECT TIMING_PROFILE_ID
INTO var_TIMING_PROFILE_ID
FROM reports
WHERE id=INPAR_REPORT_ID; -- 2 khatte bala bejaye in  age niyaz be tagheer shod

SELECT type
INTO var_type_timing_profile
FROM PRAGG.TBL_TIMING_PROFILE
WHERE id=var_TIMING_PROFILE_ID;

SELECT BRANCH_PROFILE_ID
INTO var_BRANCH_ID
FROM reports
WHERE id=INPAR_REPORT_ID;

SELECT ledger_PROFILE_ID
INTO var_ledger_ID
FROM reports
WHERE id=INPAR_REPORT_ID;

  select 
 (select  listagg(id||' AS "x'||id||'"',',') within group (order by id)  from (
select id from(
  SELECt id,max(PERIOD_NAME)
 FROM PRAGG.TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = var_TIMING_PROFILE_ID 
GROUP BY id order by id) order by id))
into var_x_timing_detail from dual ;
 
 
 select 
 (select  listagg(' "x'||id||'"',',') within group (order by id)  from (
select id from(
  SELECt id,max(PERIOD_NAME)
 FROM PRAGG.TBL_TIMING_PROFILE_DETAIL
 WHERE REF_TIMING_PROFILE   = var_TIMING_PROFILE_ID 
GROUP BY id order by id) order by id))
into var_x_timing_detail_1 from dual ;
----------------------------------------------------------------------------------
-- 1 shobe tavasote karbar entekhab shode  *********************
if(INPAR_BRANCH_ID is not null ) then 
select max(depth )into max_level from PRAGG.TBL_LEDGER_PROFILE_DETAIL where REF_LEDGER_PROFILE=var_ledger_ID;

select count (*) into var_cnt from tbl_gap where req_id=INPAR_REP_REQ_ID and IS_SINGLE_BRANCH=1 and branch_id=INPAR_BRANCH_ID  and rownum<5;
if(var_cnt=0) then  --count(tbl_gap)

-----------------------------
 for i in (  select * from PRAGG.TBL_TIMING_PROFILE_DETAIL where REF_TIMING_PROFILE=var_TIMING_PROFILE_ID order by id) loop
 select count (*) into var_cnt from tbl_value_gap where req_id=INPAR_REP_REQ_ID and   REF_TIMING=i.id ;
if(var_cnt!=0) then --agar baze entekhab shode vajod dasht

 if(var_type_timing_profile=2) then --tarikhi
 
  select TO_CHAR(TO_DATE(PERIOD_END),'J')   into var_PERIOD_end   from pragg.TBL_TIMING_PROFILE_DETAIL where id=i.id;

---------------- baraye avalin ruze har baze agar type3 vojud  nadasht ==type1    /// 

 select case when min (eff_date)-1 is null then 0 else min(eff_date)-1 end into var_befor_date  from tbl_value_gap where req_id=INPAR_REP_REQ_ID and REF_TIMING=i.id;
 select count(*) into var_cnt from  tbl_value_gap where req_id=INPAR_REP_REQ_ID and   REF_TIMING=i.id and eff_date=var_befor_date  and rownum<5;
 
 var_min_effdate:=var_befor_date+1;
 
 if (var_cnt!=0) then  --tbl_value_gap
 insert into tbl_gap(
 IS_SINGLE_BRANCH,
 BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 1,
 INPAR_BRANCH_ID,
 a.ref_timing as REF_TIMING_DETAIL
 ,a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_gap b
ON 
a.BRANCH_ID =INPAR_BRANCH_ID
and a.BRANCH_ID=b.BRANCH_ID
and a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
 AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
 
 commit;


 else
 
 
-- select case when eff_date is null then 0 else eff_date end  into var_befor_date  from tbl_value_temp_gap where req_id=INPAR_REP_REQ_ID and data_type=3 and eff_date=var_befor_date;
  select count(*) into var_cnt from  tbl_value_temp_gap where req_id=INPAR_REP_REQ_ID and data_type=3 and eff_date=var_befor_date and rownum<5;

 if (var_cnt!=0) then --tbl_value_temp
 insert into tbl_gap(
 IS_SINGLE_BRANCH,
 BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT
 1,
 INPAR_BRANCH_ID,
 a.ref_timing as REF_TIMING_DETAIL,a.NODE_ID,  a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_temp_gap b
ON 
a.BRANCH_ID =INPAR_BRANCH_ID
and a.BRANCH_ID=b.BRANCH_ID
and a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
AND b.data_type=3
AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
 commit;

--  
     else -- if (var_befor_date=!0) then  --tbl_value_temp
     
 insert into tbl_gap(
 IS_SINGLE_BRANCH,
 BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 1,
 INPAR_BRANCH_ID,
 a.ref_timing as REF_TIMING_DETAIL,a.NODE_ID,  a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_temp_gap b
ON 
a.BRANCH_ID =INPAR_BRANCH_ID
and a.BRANCH_ID=b.BRANCH_ID
and a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
AND b.data_type=1
AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
  
  commit;
  end if;--tbl_value_temp
  end if;--if (var_befor_date!=0) then  --tbl_value_gap
  
-------
------- baraye ruzhaye bad az avvalin ruze har baze 
var_min_effdate:=var_min_effdate+1;
while (var_min_effdate<=var_PERIOD_end ) loop

 insert into tbl_gap(
 IS_SINGLE_BRANCH,
 BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT
 1,
 INPAR_BRANCH_ID,
 a.ref_timing as REF_TIMING_DETAIL
 ,a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_gap b
ON 
a.BRANCH_ID =INPAR_BRANCH_ID
and a.BRANCH_ID=b.BRANCH_ID
and a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
 AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_min_effdate-1
 AND a.ref_timing=i.id;
commit;
var_min_effdate:=var_min_effdate+1;
end loop;

-------


-- profile bazeeeeeeeeeeeeeeeeeeeeeeeee
----------------------------------------------  
----------------------------------------------
else

select PERIOD_DATE into var_PERIOD_DATE from pragg.TBL_TIMING_PROFILE_DETAIL where id=i.id;

if(var_sysdate is null) then
 select TO_CHAR(TO_DATE(sysdate),'J') into var_sysdate from dual;
var_PERIOD_START:=var_sysdate;
else
 select TO_CHAR(TO_DATE(sysdate),'J') into var_sysdate from dual;
var_PERIOD_START:=var_PERIOD_end;
end if;
var_PERIOD_end:=var_PERIOD_START+var_PERIOD_DATE;


---------------- baraye avalin ruze har baze agar type3 vojud  nadasht ==type1    /// 

 select case when min (eff_date)-1 is null then 0 else min(eff_date)-1 end into var_befor_date  from tbl_value_gap where req_id=INPAR_REP_REQ_ID and REF_TIMING=i.id;
 select count(*) into var_cnt from  tbl_value_gap where req_id=INPAR_REP_REQ_ID and   REF_TIMING=i.id and eff_date=var_befor_date  and rownum<5;
 
 var_min_effdate:=var_befor_date+1;
 
  if (var_cnt!=0) then  --tbl_value_gap
 insert into tbl_gap(IS_SINGLE_BRANCH,BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 1,
 INPAR_BRANCH_ID,
 a.ref_timing as REF_TIMING_DETAIL
 ,a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_gap b
ON 
a.BRANCH_ID =INPAR_BRANCH_ID
and a.BRANCH_ID=b.BRANCH_ID
and a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
 AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
 
 commit;


 else
 
 
-- select case when eff_date is null then 0 else eff_date end  into var_befor_date  from tbl_value_temp_gap where req_id=INPAR_REP_REQ_ID and data_type=3 and eff_date=var_befor_date;
  select count(*) into var_cnt from  tbl_value_temp_gap where req_id=INPAR_REP_REQ_ID and data_type=3 and eff_date=var_befor_date and rownum<5;

 if (var_cnt!=0) then --tbl_value_temp
 insert into tbl_gap(IS_SINGLE_BRANCH,BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT  
 1,
 INPAR_BRANCH_ID,
 a.ref_timing as REF_TIMING_DETAIL,a.NODE_ID,  a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_temp_gap b
ON 
a.BRANCH_ID =INPAR_BRANCH_ID
and a.BRANCH_ID=b.BRANCH_ID
and a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
AND b.data_type=3
AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
 commit;

--  
     else -- if (var_befor_date=!0) then  --tbl_value_temp
     
 insert into tbl_gap(IS_SINGLE_BRANCH,BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 1,
 INPAR_BRANCH_ID,
 a.ref_timing as REF_TIMING_DETAIL,a.NODE_ID,  a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_temp_gap b
ON 
a.BRANCH_ID =INPAR_BRANCH_ID
and a.BRANCH_ID=b.BRANCH_ID
and a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
AND b.data_type=1
AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
  
  commit;
  end if;--tbl_value_temp
  end if;--if (var_befor_date!=0) then  --tbl_value_gap
  
-------
------- baraye ruzhaye bad az avvalin ruze har baze 
var_min_effdate:=var_min_effdate+1;
while (var_min_effdate<=var_PERIOD_end ) loop

 insert into tbl_gap(IS_SINGLE_BRANCH,BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT
 1,
 INPAR_BRANCH_ID,
 a.ref_timing as REF_TIMING_DETAIL
 ,a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_gap b
ON 
a.BRANCH_ID =INPAR_BRANCH_ID
and a.BRANCH_ID=b.BRANCH_ID
and a.node_id  =b.node_id
AND a.arz_id  =b.arz_id
 AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_min_effdate-1
 AND a.ref_timing=i.id;
commit;
var_min_effdate:=var_min_effdate+1;
end loop;



end if ; --if(var_type_timing_profile=2) then --tarikhi

end if;--if(var_cnt!=0) then --agar baze entekhab shode vajod dasht
end loop;--
 
end if;--if(var_cnt!=0) then 

--end if;
var:='select a.*,b."mande",'||max_level||' as "maxLevel"  from (

SELECT '||INPAR_BRANCH_ID||' as shobe_id,code AS "id",code,PARENT_CODE as  "parent", name as "text",'||var_x_timing_detail_1||',"level"
from (
select * 
from (
 select "ref_timing_detail",code,PARENT_CODE,name,"gap","level" from  (
    (SELECT a.*,
      lpd.code,lpd.name,lpd.PARENT_CODE,lpd.REF_LEDGER_PROFILE,lpd.DEPTH as "level"
    FROM
      (SELECT node_id,
        MAX(ref_timing_detail) AS "ref_timing_detail",
        MAX(parent)            AS "parent",
        SUM(gap)               AS "gap"
      FROM (
        (SELECT b.ref_timing_detail,
          b.NODE_ID,
          b.arz_id,
          b.depth,
          b.parent,
          b.MANDE,
          b.EFF_DATE,
          CASE
            WHEN l.node_type=2
            THEN b.gap*-1
            WHEN l.node_type=1
            THEN b.gap*1
            ELSE 0
          END AS gap
        FROM ((select REF_TIMING_DETAIL,NODE_ID,arz_id,depth,parent,mande,eff_date,gap from tbl_gap where req_id='||INPAR_REP_REQ_ID||' and IS_SINGLE_BRANCH=1 and BRANCH_ID='||INPAR_BRANCH_ID||' 
           )b
        INNER JOIN tbl_ledger l
        ON b.node_id=l.ledger_code )
        ) 
        )
      GROUP BY node_id,
        ref_timing_detail
      ) a
    right JOIN pragg.tbl_ledger_profile_detail lpd
    ON   a.node_id  =lpd.code ) 
  )where  rEF_LEDGER_PROFILE='||var_ledger_ID||'
  )
  pivot  
(  
max("gap") for  "ref_timing_detail" in ('||var_x_timing_detail||') 
)  
order by code  
)
) a left outer join 
(select '||INPAR_BRANCH_ID||' as shobe_id,node_id,sum(mande) as "mande"  from dynamic_lq.daftar_kol_shobe where eff_date='||max_eff_date||' and shobe_id='||INPAR_BRANCH_ID||' group by node_id)b
on a."id"=b.node_id and a.shobe_id=b.shobe_id order by a."id"';
var_output:=var;
return var_output;

----------------------------------------------------------------------------------------------
else    -- multi branch
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------
--dar shekafe chand shobe , faghat shekafe sathe avval namayesh dade mishavad 

select count (*) into var_cnt from tbl_gap where req_id=INPAR_REP_REQ_ID  and IS_SINGLE_BRANCH=0 and rownum<5;
if(var_cnt=0) then  --count tbl_gap

----------------------------------------
select count(*) into var_cnt from TBL_LEDGER_BRANCH where req_id=INPAR_REp_REQ_id and ROWNUM<2;
if(var_cnt=0) then --TBL_LEDGER_BRANCH

insert into TBL_LEDGER_BRANCH(
req_id,
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
INPAR_REp_REQ_id,0,0,0,0,null,'ايران',0
);
commit;

execute IMMEDIATE  'begin insert into tbl_temp (id) ('||PRAGG.FNC_PRIVATE_CREATE_QUERY('TBL_BRANCH',var_BRANCH_ID)||');end;';
commit;

for i in (select max(STA_NAME)as STA_NAME ,ref_sta_id from pragg.tbl_branch where BRN_ID in(select id from tbl_temp) group by ref_sta_id) loop  --ostan

insert into TBL_LEDGER_BRANCH(
req_id,
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
INPAR_REp_REQ_id,
i.REF_STA_ID,
0,
0,
i.REF_STA_ID||'00',
0,
i.STA_NAME,
1
); 
commit;
for b in (select max(CITY_NAME) as CITY_NAME,REF_CTY_ID  ,max(REF_STA_ID)as REF_STA_ID,max(STA_NAME) as STA_NAME from pragg.tbl_branch where  REF_STA_ID=i.REF_STA_ID and BRN_ID in(select id from tbl_temp)   group by REF_CTY_ID) loop  --shahr
select distinct(REF_STA_ID)||'00' into var_parent from pragg.tbl_branch where REF_CTY_ID=b.REF_CTY_ID;

insert into TBL_LEDGER_BRANCH(
req_id,
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
INPAR_REp_REQ_id,
b.REF_STA_ID,
b.REF_CTY_ID,
0,
b.REF_STA_ID||b.REF_CTY_ID||0,
var_parent,
b.CITY_NAME,
2
);
commit;

for c in (select * from pragg.tbl_branch where REF_CTY_ID=b.REF_CTY_ID and BRN_ID in(select id from tbl_temp)   order by BRN_ID) loop  --shobe
select node_id into var_parent from TBL_LEDGER_BRANCH where req_id=INPAR_REp_REQ_id and  OSTAN_ID=c.REF_STA_ID and SHAHR_ID=c.REF_CTY_ID and shobe_id=0;

insert into TBL_LEDGER_BRANCH(
req_id,
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
INPAR_REp_REQ_id,
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
req_id,
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
INPAR_REp_REQ_id,
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

end loop; -- loop c
end loop; -- loop b
end loop; -- loop i

end if; --if(var_cnt=0) then --TBL_LEDGER_BRANCH

-----------------------------------------------------------------------------
for c in (select * from pragg.tbl_branch where BRN_ID in (select distinct(shobe_id) from tbl_ledger_branch where req_id =INPAR_REP_REQ_ID  and shobe_id!=0 )) loop
  for i in (  select * from PRAGG.TBL_TIMING_PROFILE_DETAIL where REF_TIMING_PROFILE=var_TIMING_PROFILE_ID order by id) loop
  
 select count (*) into var_cnt from tbl_value_gap where req_id=INPAR_REP_REQ_ID and   REF_TIMING=i.id ;
if(var_cnt!=0) then --agar baze entekhab shode vajod dasht

--profile_tarikhi
 if(var_type_timing_profile=2) then --tarikhi
 
  select TO_CHAR(TO_DATE(PERIOD_END),'J')   into var_PERIOD_end   from pragg.TBL_TIMING_PROFILE_DETAIL where id=i.id;

---------------- baraye avalin ruze har baze agar type3 vojud  nadasht ==type1    /// 

 select case when min (eff_date)-1 is null then 0 else min(eff_date)-1 end into var_befor_date  from tbl_value_gap where req_id=INPAR_REP_REQ_ID and REF_TIMING=i.id;
 select count(*) into var_cnt from  tbl_value_gap where req_id=INPAR_REP_REQ_ID and   REF_TIMING=i.id and eff_date=var_befor_date  and rownum<5;
 
 var_min_effdate:=var_befor_date+1;
 
 if (var_cnt!=0) then  --tbl_value_gap
 insert into tbl_gap(IS_SINGLE_BRANCH,
 BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 0,
 c.BRN_ID,
 a.ref_timing as REF_TIMING_DETAIL
 ,a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_gap b
ON 
a.DEPTH=1 and b.DEPTH=1
and a.node_id  =b.node_id
and a.BRANCH_ID=b.BRANCH_ID
and a.BRANCH_ID ='||c.BRN_ID||'
AND a.arz_id  =b.arz_id
 AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
  commit;
 else
 select count(*) into var_cnt from  tbl_value_temp_gap where req_id=INPAR_REP_REQ_ID and data_type=3 and eff_date=var_befor_date and rownum<5;
 if (var_cnt!=0) then --tbl_value_temp
 
 insert into tbl_gap(IS_SINGLE_BRANCH,
 BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 0,
  c.BRN_ID,
  a.ref_timing as REF_TIMING_DETAIL,
  a.NODE_ID,
  a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_temp_gap b
ON 
a.DEPTH=1 and b.DEPTH=1
and a.node_id  =b.node_id
and a.BRANCH_ID=b.BRANCH_ID
and a.BRANCH_ID =c.BRN_ID
AND a.arz_id  =b.arz_id
AND b.data_type=3
AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
 commit;

--  
     else -- if (var_befor_date=!0) then  --tbl_value_temp
     
 insert into tbl_gap(IS_SINGLE_BRANCH,
 BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 0,
  c.BRN_ID,
 a.ref_timing as REF_TIMING_DETAIL,
 a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_temp_gap b
ON 
a.DEPTH=1 and b.DEPTH=1
and a.node_id  =b.node_id
and a.BRANCH_ID=b.BRANCH_ID
and a.BRANCH_ID =c.BRN_ID
AND a.arz_id  =b.arz_id
AND b.data_type=1
AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
  
  commit;
  end if;--tbl_value_temp
  end if;--if (var_befor_date!=0) then  --tbl_value_gap
  
-------
------- baraye ruzhaye bad az avvalin ruze har baze 
var_min_effdate:=var_min_effdate+1;
while (var_min_effdate<=var_PERIOD_end ) loop

 insert into tbl_gap(IS_SINGLE_BRANCH,
 BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT
 0,
 c.BRN_ID,
 a.ref_timing as REF_TIMING_DETAIL
 ,a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_gap b
ON 
a.DEPTH=1 and b.DEPTH=1
and a.node_id  =b.node_id
and a.BRANCH_ID=b.BRANCH_ID
and a.BRANCH_ID =c.BRN_ID
AND a.arz_id  =b.arz_id
 AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_min_effdate-1
 AND a.ref_timing=i.id;
commit;
var_min_effdate:=var_min_effdate+1;
end loop;
----------------------------------------------  bazeeeeeeeeeeeeeeeeeeeeeeeee
----------------------------------------------
else    --  for i in (  select * from PRAGG.TBL_TIMING_PROFILE_DETAIL where REF_TIMING_PROFILE=var_TIMING_PROFILE_ID order by id) loop

select PERIOD_DATE into var_PERIOD_DATE from pragg.TBL_TIMING_PROFILE_DETAIL where id=i.id;

if(var_sysdate is null) then
 select TO_CHAR(TO_DATE(sysdate),'J') into var_sysdate from dual;
var_PERIOD_START:=var_sysdate;
else
 select TO_CHAR(TO_DATE(sysdate),'J') into var_sysdate from dual;
var_PERIOD_START:=var_PERIOD_end;
end if;
var_PERIOD_end:=var_PERIOD_START+var_PERIOD_DATE;


---------------- baraye avalin ruze har baze agar type3 vojud  nadasht ==type1    /// 

 select case when min (eff_date)-1 is null then 0 else min(eff_date)-1 end into var_befor_date  from tbl_value_gap where req_id=INPAR_REP_REQ_ID and REF_TIMING=i.id;
 select count(*) into var_cnt from  tbl_value_gap where req_id=INPAR_REP_REQ_ID and   REF_TIMING=i.id and eff_date=var_befor_date  and rownum<5;
 
 var_min_effdate:=var_befor_date+1;
 
  if (var_cnt!=0) then  --tbl_value_gap
 insert into tbl_gap(IS_SINGLE_BRANCH,
 BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 0,
 c.BRN_ID,
 a.ref_timing as REF_TIMING_DETAIL
 ,a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_gap b
ON 
a.DEPTH=1 and b.DEPTH=1
and a.node_id  =b.node_id
and a.BRANCH_ID=b.BRANCH_ID
and a.BRANCH_ID =c.BRN_ID
AND a.arz_id  =b.arz_id
 AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
 
 commit;


 else
 
 
-- select case when eff_date is null then 0 else eff_date end  into var_befor_date  from tbl_value_temp_gap where req_id=INPAR_REP_REQ_ID and data_type=3 and eff_date=var_befor_date;
  select count(*) into var_cnt from  tbl_value_temp_gap where req_id=INPAR_REP_REQ_ID and data_type=3 and eff_date=var_befor_date and rownum<5;

 if (var_cnt!=0) then --tbl_value_temp
 insert into tbl_gap(IS_SINGLE_BRANCH,
 BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT
 0,
 c.BRN_ID,
 a.ref_timing as REF_TIMING_DETAIL,
 a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_temp_gap b
ON 
a.DEPTH=1 and b.DEPTH=1
and a.node_id  =b.node_id
and a.BRANCH_ID=b.BRANCH_ID
and a.BRANCH_ID =c.BRN_ID
AND a.arz_id  =b.arz_id
AND b.data_type=3
AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
 commit;

--  
     else -- if (var_befor_date=!0) then  --tbl_value_temp
     
 insert into tbl_gap(IS_SINGLE_BRANCH,
 BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT  
 0,
 c.BRN_ID,
 a.ref_timing as REF_TIMING_DETAIL,
 a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_temp_gap b
ON 
a.DEPTH=1 and b.DEPTH=1
and a.node_id  =b.node_id
and a.BRANCH_ID=b.BRANCH_ID
and a.BRANCH_ID =c.BRN_ID
AND a.arz_id  =b.arz_id
AND b.data_type=1
AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_befor_date
 AND a.ref_timing=i.id;
  
  commit;
  end if;--tbl_value_temp
  end if;--if (var_befor_date!=0) then  --tbl_value_gap
  
-------
------- baraye ruzhaye bad az avvalin ruze har baze 
var_min_effdate:=var_min_effdate+1;
while (var_min_effdate<=var_PERIOD_end ) loop

 insert into tbl_gap(IS_SINGLE_BRANCH,
 BRANCH_ID,
 REF_TIMING_DETAIL,
 NODE_ID,
 ARZ_ID,
 DEPTH,
 PARENT,
 MANDE,
 EFF_DATE,
 GAP,
 REQ_ID)
 SELECT 
 0,
 c.BRN_ID,
 a.ref_timing as REF_TIMING_DETAIL
 ,a.NODE_ID,
 a.arz_id,
  a.depth,
  a.parent,
  a.MANDE,
  a.EFF_DATE as EFF_DATE,
  a.MANDE-b.MANDE AS gap,
  INPAR_REP_REQ_ID
FROM tbl_value_gap a
INNER JOIN tbl_value_gap b
ON 
a.DEPTH=1 and b.DEPTH=1
and a.node_id  =b.node_id
and a.BRANCH_ID=b.BRANCH_ID
and a.BRANCH_ID =c.BRN_ID
AND a.arz_id  =b.arz_id
 AND a.eff_date=var_min_effdate
 AND a.REQ_ID  =INPAR_REP_REQ_ID
 AND b.REQ_ID  =INPAR_REP_REQ_ID
 AND  TO_CHAR(b.eff_date)=var_min_effdate-1
 AND a.ref_timing=i.id;
commit;
var_min_effdate:=var_min_effdate+1;
end loop; --while (var_min_effdate<=var_PERIOD_end ) loop

end if ; --if(var_type_timing_profile=2) then --tarikhi

end if;--if(var_cnt!=0) then --agar baze entekhab shode vajod dasht
end loop;-- 
 end loop;
end if; --if(var_cnt=0) then  --count tbl_gap
---------------------------------------------------
var_output:='select a.*,b."mande",4 as "maxLevel"  from (

SELECT shobe_id,code,id,node_id AS "id", "parent", name as "text",'||var_x_timing_detail_1||',"level"
from (
select * 
from ( 
select * from
(SELECT 
max(id) as id,
shobe_id,
node_id,
max(code ) as code,
max(name) as name,
max(ref_timing_detail) as "ref_timing_detail",  
max(depth)  as "level",  
max(parent) as "parent",  
SUM(gap) as "gap"
FROM ((

select  
lb.id,
lb.shobe_id,
b.ref_timing_detail,          
lb.NODE_ID, 
lb.name,
lb.code ,
b.arz_id,          
lb.depth,          
lb.parent,          
b.MANDE,          
b.EFF_DATE,         
CASE WHEN lb.node_type=2 THEN b.gap*-1                
WHEN lb.node_type=1 THEN b.gap*1              
ELSE 0 END as gap             
from ((select branch_id,REF_TIMING_DETAIL,NODE_ID,arz_id,depth,parent,mande,eff_date,gap from tbl_gap where req_id='||INPAR_REP_REQ_ID||' and IS_SINGLE_BRANCH=0
)b right join (select * from tbl_ledger_branch where req_id='||INPAR_REp_REQ_id||') lb        
on b.branch_id||b.node_id=lb.NODE_ID 
) order by id 
) )
GROUP BY 
shobe_id,
ref_timing_detail,
node_id  
)     
pivot  
(  
max("gap") for  "ref_timing_detail" in ('||var_x_timing_detail||') 
)  
order by node_id  
)) order by id

) a left outer join 
(select node_id,SHOBE_ID,sum(mande) as "mande"  from dynamic_lq.daftar_kol_shobe where eff_date='||max_eff_date||'  group by node_id,SHOBE_ID)b
 on a.code=b.node_id and a.shobe_id=b.SHOBE_ID
 order by id 
';
commit;
--insert into tbl_test(var) values(var_output);
--commit;
return var_output;
end if;--if(INPAR_BRANCH_ID is not null ) then

END FNC_DYNAMIC_GAP_LED_BRANCH;
