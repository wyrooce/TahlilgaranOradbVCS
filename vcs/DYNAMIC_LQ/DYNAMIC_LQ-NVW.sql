--------------------------------------------------------
--  DDL for View NVW_TST_TABLE_FNC
--------------------------------------------------------
with tree_date as     (select r.start_date aghaz,       r.end_date payan,       r.fromday fromday,       r.today today,       r.type z_type,       r.id     from bi_profile_date_item r     where r.profile_id = 84),     tree_data_type(data_type) as     (select distinct r.data_type     from reports_data r     where r.report_id = (select yy.ORIGINAL_ID from reports yy where yy.id=308)     and r.node_id is not null     and r.data_type = 3),     tree_query(id,       parent,       mande,       zaman_id,       data_type) as     (select s.id,       s.parent_id,       round(sum(nvl(a.rate,1)*nvl(r.mande,0)),2),       z.id zaman_id,       t.data_type     from bi_profile_ledger_item s     join tree_date z     on (1 = 1)     join tree_data_type t     on (1 = 1)     left outer join (select rr.data_type,s.ORIGINAL_ID,       rr.eff_date,       rr.mande,       rr.node_id,       rr.arz_id,       s.created     from reports_data rr, reports s,(select f.src_id from bi_profile_item f where f.profile_id=85) c     where rr.report_id = (select yy.ORIGINAL_ID from reports yy where yy.id=308)     and s.id = rr.report_id     and rr.arz_id=c.src_id     and rr.node_id is not null     and rr.data_type = 3) r     on (r.node_id = s.treenode_id and t.data_type = r.data_type and     (case     when (z.z_type = 2 and z.fromday is not null and     trunc(r.created + r.eff_date) - trunc(sysdate) >= z.fromday AND     ((trunc(r.created + r.eff_date) - trunc(sysdate) <= z.today and     z.today is not null) or (z.today is null)) or     (z.z_type = 5 and     trunc(r.created + r.eff_date) >= trunc(z.aghaz) and     ((trunc(r.created + r.eff_date) <= trunc(z.payan) and     z.payan is not null) or (z.payan is null)))) then     -1   else     null     end) is not null)     left outer join ARZ_PRD_DATA a on (r.original_id = a.report_id     and r.arz_id = a.arz1_id and a.eff_date = r.eff_date and a.arz2_id = 4)     where s.profile_id = 106     group by s.id,s.parent_id,z.id ,t.data_type),     tree_final_query(id,       parent,       mande,       zaman_id,       data_type,       idd) as     (select s.id, s.parent,  s.mande, s.zaman_id, s.data_type, s.id     from tree_query s     union all     select s1.id,       s1.parent,       s1.mande,       s1.zaman_id,       s1.data_type,       s2.idd     from tree_query s1     join tree_final_query s2     on (s2.id = nvl(s1.parent, -1) and s1.zaman_id = s2.zaman_id)),      tree_pivot as (     select *     from (select s.id "id", (select gg.archived from reports gg where gg.id=308) "archived",  s.parent_id "parent", s.name "text", nvl(s1.mande, 0) mande,       z.id zaman_id     from bi_profile_ledger_item s join tree_date z     on (1 = 1)     join tree_data_type t     on (1 = 1)     left outer join tree_final_query s1     on (s1.idd = s.id and s1.zaman_id = z.id and     s1.data_type = t.data_type)     where s.profile_id = 106) pivot(sum(mande) for zaman_id in(23,24,25,26)))     SELECT y."id",y."archived",y."parent",y."text",y."23",y."24",y."25",y."26",level "level",max(level) over() as "maxlevel" FROM tree_pivot y START WITH y."parent" IS NULL connect BY prior y."id"=y."parent"
