package ir.wyrooce.model;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Created by mym on 11/8/16.
 */

public class TstMain {
    public static void main(String[] args) throws NoSuchAlgorithmException, SQLException, IOException {

        DatabaseAccess da = new DatabaseAccess();
        Schema schema = new Schema(da.getDBName().toUpperCase());

        ArrayList<Procedure> prc = da.fetchProcedures("connection");
        if (prc != null) {
            for (int i = 0; i < prc.size(); i++) {
                schema.addProcedure(prc.get(i));
            }
        }

        ArrayList<Function> fnc = da.fetchFunction("connection");
        if (fnc != null) {
            for (int i = 0; i < fnc.size(); i++) {
                schema.addFunction(fnc.get(i));
            }
        }

        ArrayList<Table> tbl = da.fetchTable("connection");
        if (tbl != null){
            for (Table table : tbl) {
                schema.addTable(table);
            }
        }

        ArrayList<View> nvw = da.fetchViews("connection");
        if (nvw != null){
            for (View view : nvw) {
                schema.addView(view);
            }
        }

        ArrayList<Package> pkgs = da.fetchPackages("connection");
        if (pkgs != null){
            for (Package pkg : pkgs) {
                schema.addPackage(pkg);
            }
        }
        //schema.createSnapshot();
        schema.classifiedFile();
        System.out.println("Database ["+schema.getName().toUpperCase()+"] stored!");
        System.out.println("Default Path: "+Util.path + "/"+schema.getName().toUpperCase());
        System.out.println("Press Enter to exit...");
        System.in.read();

//        System.out.println(Util.formatter2(schema.getView(0).getSql()));

    }


}





