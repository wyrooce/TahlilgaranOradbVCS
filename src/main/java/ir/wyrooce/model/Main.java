package ir.wyrooce.model;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.lang.reflect.Array;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Created by mym on 7/16/18.
 */
public class Main {
    public static void main(String[] args) throws IOException, ParseException, SQLException, NoSuchAlgorithmException {
//        System.out.println(System.getProperty("user.home"));

        DatabaseAccess da = new DatabaseAccess();
        for (int idx = 0; idx < da.info.userCount(); idx++) {
            Schema schema = new Schema(da.getDBName(idx).toUpperCase());

            ArrayList<Procedure> prc = da.fetchProcedures("connection", idx);
            if (prc != null) {
                for (int i = 0; i < prc.size(); i++) {
                    schema.addProcedure(prc.get(i));
                }
            }

            ArrayList<Function> fnc = da.fetchFunction("connection", idx);
            if (fnc != null) {
                for (int i = 0; i < fnc.size(); i++) {
                    schema.addFunction(fnc.get(i));
                }
            }

            ArrayList<Table> tbl = da.fetchTable("connection", idx);
            if (tbl != null) {
                for (Table table : tbl) {
                    schema.addTable(table);
                }
            }

            ArrayList<View> nvw = da.fetchViews("connection", idx);
            if (nvw != null) {
                for (View view : nvw) {
                    schema.addView(view);
                }
            }

            ArrayList<Package> pkgs = da.fetchPackages("connection", idx);
            if (pkgs != null) {
                for (Package pkg : pkgs) {
                    schema.addPackage(pkg);
                }
            }
            //schema.createSnapshot();
            schema.classifiedFile();
            System.out.println("Database [" + schema.getName().toUpperCase() + "] stored!");
            File file = new File(Util.path);
            System.out.println("Default Path: " + file.getAbsolutePath() + "/" + schema.getName().toUpperCase());
            System.out.println("===========================================");
        }
        System.out.println("Press Enter to exit...");
        System.in.read();
    }
}