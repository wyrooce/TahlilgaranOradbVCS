package ir.wyrooce.model;

import gudusoft.gsqlparser.EDbVendor;
import gudusoft.gsqlparser.TGSqlParser;
import gudusoft.gsqlparser.pp.para.GFmtOpt;
import gudusoft.gsqlparser.pp.para.GFmtOptFactory;
import gudusoft.gsqlparser.pp.stmtformattor.FormattorFactory;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.*;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Properties;
import java.util.Scanner;

/**
 * Created by mym on 11/8/16.
 */
public class Util {
    //public static String path = "/home/mym/vcs";
    public static String path = "vcs";
    public static String defaultPath = "/home/mym/vcs";




    public static String getDefaultPath(){
        String windowsPath = " C:\\Users\\morteza2\\Documents ";
        String linuxPath = "/home/mym/vcs";

        return path;

    }

    public static Info loadSetting() {
        Info info = new Info();

        JSONParser parser = new JSONParser();
        //Use JSONObject for simple JSON and JSONArray for array of JSON.
        JSONObject data = null;//path to the JSON file.
        try {
            data = (JSONObject) parser.parse(
                    new FileReader(Util.path+"/Config/setting-vcs.json"));
        } catch (IOException e) {
            System.out.println("[ERR] Setting File not found");
            return null;
        } catch (ParseException e) {
            System.out.println("[ERR] Setting File is invalid");
            return null;
        }

        info.host = (String) data.get("host");
        info.sid = (String) data.get("sid");
        ArrayList<JSONObject> users = (ArrayList<JSONObject>) data.get("users");

        for (JSONObject user: users){
            info.addUser(user.get("name").toString(), user.get("password").toString());
        }
        return info;
    }

    final public static String viewSQL =
            "SELECT t.view_name, t.text\n" +
                    "FROM user_views t, user_objects o\n" +
                    "WHERE t.view_name = o.object_name\n" +
                    "ORDER BY o.created";
    final public static String tableProperty = "SELECT table_name, column_name, data_type, data_length, nullable, data_default, column_id\n" +
            "FROM dba_tab_columns, user_objects o\n" +
            "WHERE owner       = USER\n" +
            "AND o.object_name = table_name\n" +
            "AND table_name   IN\n" +
            "  (SELECT object_name\n" +
            "  FROM dba_objects\n" +
            "  WHERE owner     = USER\n" +
            "  AND object_type = 'TABLE'\n" +
            "  )\n" +
            "ORDER BY o.created";
    //-----------------------------------------------------------------------------------------
    final public static String procedureSourceCodeSQL = "WITH tmp AS\n" +
            "  ( SELECT DISTINCT NAME, TYPE FROM user_source WHERE TYPE = 'PROCEDURE')\n" +
            "SELECT t.NAME, dbms_metadata.get_ddl(t.TYPE, t.NAME) code \n" +
            "FROM tmp t,\n" +
            "  user_objects o\n" +
            "WHERE t.NAME = o.object_name\n" +
            "ORDER BY o.created";
    final public static String functionSourceCodeSQL = "WITH tmp AS\n" +
            "  ( SELECT DISTINCT NAME, TYPE FROM user_source WHERE TYPE = 'FUNCTION')\n" +
            "SELECT t.NAME, dbms_metadata.get_ddl(t.TYPE, t.NAME) code \n" +
            "FROM tmp t,\n" +
            "  user_objects o\n" +
            "WHERE t.NAME = o.object_name\n" +
            "ORDER BY o.created";
    final public static String packageSQL = "WITH tmp AS\n" +
            "  ( SELECT DISTINCT NAME, TYPE FROM user_source WHERE TYPE = 'PACKAGE')\n" +
            "SELECT t.NAME, dbms_metadata.get_ddl('PACKAGE', t.NAME) BODY, dbms_metadata.get_ddl('PACKAGE_SPEC', name) SPEC\n" +
            "FROM tmp t,\n" +
            "  user_objects o\n" +
            "WHERE t.NAME = o.object_name\n" +
            "ORDER BY o.created";


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
            result = sql;
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
