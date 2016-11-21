package ir.wyrooce.model;

import java.io.FileNotFoundException;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 * Created by mym on 11/8/16.
 */

public class TstMain {
    public static void main(String[] args) throws NoSuchAlgorithmException, SQLException, FileNotFoundException {

        Schema schema = new Schema("HAMI");
        DatabaseAccess da = new DatabaseAccess();

        ArrayList<Procedure> prc = da.getProcedures("connection");
        if (prc != null) {
            for (int i = 0; i < prc.size(); i++) {
                schema.addProcedure(prc.get(i));
            }
        }

        ArrayList<Function> fnc = da.getFunction("connection");
        if (fnc != null) {
            for (int i = 0; i < fnc.size(); i++) {
                schema.addFunction(fnc.get(i));
            }
        }

        ArrayList<Table> tbl = da.getTable("connection");
        if (tbl != null){
            for (Table table : tbl) {
                schema.addTable(table);
            }
        }

        ArrayList<View> nvw = da.getViews("connection");
        if (nvw != null){
            for (View view : nvw) {
                schema.addView(view);
            }
        }
        schema.printView();


    }


}





