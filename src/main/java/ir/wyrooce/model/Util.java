package ir.wyrooce.model;

import gudusoft.gsqlparser.EDbVendor;
import gudusoft.gsqlparser.TGSqlParser;
import gudusoft.gsqlparser.pp.para.GFmtOpt;
import gudusoft.gsqlparser.pp.para.GFmtOptFactory;
import gudusoft.gsqlparser.pp.stmtformattor.FormattorFactory;
import org.hibernate.jdbc.util.BasicFormatterImpl;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;

/**
 * Created by mym on 11/8/16.
 */
public class Util {

    public static String path = "/home/mym/vcs";
    final public static String viewSQL =
            "SELECT view_name, text\n" +
                    "FROM user_views";
    final public static String tableProperty =
            "SELECT  table_name, column_name, data_type, data_length, nullable, data_default  \n" +
                    "FROM dba_tab_columns \n" +
                    "WHERE owner = USER \n" +
                    "AND table_name IN (\n" +
                    "SELECT object_name \n" +
                    "FROM dba_objects\n" +
                    "WHERE owner = USER AND object_type = 'TABLE')";
    final public static String procedureSource =
            "WITH TMP AS\n" +
                    "  (SELECT lower(SUBSTR(type, 1,1)) type,\n" +
                    "    NAME,\n" +
                    "    LINE,\n" +
                    "    SUBSTR(TEXT, 0,\n" +
                    "    CASE\n" +
                    "      WHEN INSTR(TEXT, '--') = 0\n" +
                    "      THEN LENGTH(TEXT)\n" +
                    "      ELSE INSTR(TEXT, '--')-1\n" +
                    "    END) TEXT\n" +
                    "  FROM USER_SOURCE\n" +
                    "  WHERE INSTR(TRIM(TEXT), '--') <> 1\n" +
                    "  AND TRIM(TEXT)                <> CHR(10)\n" +
                    "  AND TYPE                       = 'PROCEDURE'\n" +
                    "  ORDER BY NAME,\n" +
                    "    LINE\n" +
                    "  )\n" +
                    "SELECT NAME,\n" +
                    "  replace( REPLACE( RTRIM(XMLAGG(XMLELEMENT(E, trim(TEXT), '').EXTRACT('//text()')\n" +
                    "ORDER BY LINE).GetClobVal(),','), chr(10), ' '), '&apos;', '''') AS CODe\n" +
                    "FROM TMP\n" +
                    "GROUP BY NAME";
    final public static String functionSource =
            "WITH TMP AS\n" +
                    "  (SELECT lower(SUBSTR(type, 1,1)) type,\n" +
                    "    NAME,\n" +
                    "    LINE,\n" +
                    "    SUBSTR(TEXT, 0,\n" +
                    "    CASE\n" +
                    "      WHEN INSTR(TEXT, '--') = 0\n" +
                    "      THEN LENGTH(TEXT)\n" +
                    "      ELSE INSTR(TEXT, '--')-1\n" +
                    "    END) TEXT\n" +
                    "  FROM USER_SOURCE\n" +
                    "  WHERE INSTR(TRIM(TEXT), '--') <> 1\n" +
                    "  AND TRIM(TEXT)                <> CHR(10)\n" +
                    "  AND TYPE = 'FUNCTION'\n" +
                    "  ORDER BY NAME,\n" +
                    "    LINE\n" +
                    "  )\n" +
                    "SELECT\n" +
                    "  NAME,\n" +
                    "  regexp_replace( REPLACE( RTRIM(XMLAGG(XMLELEMENT(E, trim(TEXT), '').EXTRACT('//text()')\n" +
                    "ORDER BY LINE).GetClobVal(),','), chr(10), ' '), ' +', ' ') AS CODe\n" +
                    "FROM TMP\n" +
                    "GROUP BY NAME\n";
    //-----------------------------------------------------------------------------------------
    final public static String procedureSourceCodeSQL = "with tmp as(\n" +
            "select distinct name, type \n" +
            "from user_source\n" +
            "where type = 'PROCEDURE')\n" +
            "select name, dbms_metadata.get_ddl(type,name) code\n" +
            "from tmp";
    final public static String functionSourceCodeSQL = "with tmp as(\n" +
            "select distinct name, type \n" +
            "from user_source\n" +
            "where type = 'FUNCTION')\n" +
            "select name, dbms_metadata.get_ddl(type,name) code\n" +
            "from tmp";
    final public static String packageSpecSQL = "with tmp as(\n" +
            "            select distinct name, type\n" +
            "            from user_source\n" +
            "            where type LIKE 'PACKAGE')\n" +
            "            select name, dbms_metadata.get_ddl('PACKAGE_SPEC',name) code, TYPE\n" +
            "            from tmp;";

    final public static String packageSQL = "WITH tmp\n" +
            "AS (SELECT DISTINCT\n" +
            "  name,\n" +
            "  type\n" +
            "FROM user_source\n" +
            "WHERE type LIKE 'PACKAGE')\n" +
            "SELECT\n" +
            "  name,\n" +
            "  dbms_metadata.get_ddl('PACKAGE', name) body,\n" +
            "  dbms_metadata.get_ddl('PACKAGE_SPEC', name) spec\n" +
            "FROM tmp";



    public static String sha1(String input) throws NoSuchAlgorithmException {
        MessageDigest mDigest = MessageDigest.getInstance("SHA1");
        byte[] result = mDigest.digest(input.getBytes());
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < result.length; i++) {
            sb.append(Integer.toString((result[i] & 0xff) + 0x100, 16).substring(1));
        }
        return sb.toString();
    }

    public static String formatter2(String sql) {
        TGSqlParser sqlParser = new TGSqlParser(EDbVendor.dbvoracle);
        sqlParser.sqltext = sql;
        String result = null;

        int ret = sqlParser.parse();
        if (ret == 0) {
            GFmtOpt option = GFmtOptFactory.newInstance();
            result = FormattorFactory.pp(sqlParser, option);
        } else {
            System.out.println(sqlParser.getErrormessage());
        }
        return result;
    }

    public static String formatter(String string) {
        //capital kardan query be joz miyane qoutaion ha
        /*ArrayList<String> result = new ArrayList<String>();
        string = string.replace("''", "#");

        boolean secondVisit = false;
        int i = 0;
        for (; i < string.length(); i++) {
            if (string.charAt(i) == '\'') {
                if (secondVisit) {
                    result.add(string.substring(0, i + 1).trim());
                    string = string.substring(i + 1 > string.length() ? string.length() : i + 1);
                } else {
                    result.add(string.substring(0, i).trim().toUpperCase().replaceAll(" +", " "));
                    string = string.substring(i);
                }
                i = 0;
                secondVisit = !secondVisit;
            }

        }
        if (string.trim().length() != 0)
            result.add(string.trim().toUpperCase().replaceAll(" +", " "));

        String tmp = "";
        for (i = 0; i < result.size(); i++) {
            tmp += result.get(i).replace("#", "''") + " ";
        }
        //ba zibasaze hibernate SQL ro ham format mikone
        String formattedSQL = new BasicFormatterImpl().format(tmp);
        return formattedSQL;*/
        return string;
    }


}
