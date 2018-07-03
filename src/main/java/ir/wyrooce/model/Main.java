package ir.wyrooce.model;

import org.hibernate.jdbc.util.BasicFormatterImpl;

public class Main {
    public static void main(String[] args) {
        System.out.println("Salaam");

        String sql = "\n" +
                "  CREATE OR REPLACE FUNCTION \"PRAGG\".\"FNC_DASHBOARD_PROFILE\" return varchar2 as \n" +
                "--------------------------------------------------------------------------------\n" +
                "  /*\n" +
                "  Programmer Name:  navid\n" +
                "  Editor Name: \n" +
                "  Release Date/Time:1396/03/22-15:00\n" +
                "  Edit Name: \n" +
                "  Version: 1\n" +
                "  Category:2\n" +
                "  Description:\n" +
                "  */\n" +
                "--------------------------------------------------------------------------------\n" +
                "begin\n" +
                "  return 'SELECT REF_LEDGER_PROFILE as \"ledgerProfileId\",\n" +
                "  REF_TIMING_PROFILE as \"timingProfileId\",\n" +
                "  ID as \"id\",\n" +
                "  TYPEE as \"type\"\n" +
                "FROM                TBL_DASHBOARD_PROFILE';\n" +
                "end fnc_dashboard_profile;";
        System.out.println(Util.formatter2(sql));
        System.out.println("-----------------------------------------------------");
        System.out.println("-----------------------------------------------------");
        System.out.println(Util.formatter(sql));


    }
}