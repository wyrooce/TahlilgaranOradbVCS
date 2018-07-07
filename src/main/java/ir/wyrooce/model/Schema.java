package ir.wyrooce.model;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.PrintStream;
import java.util.ArrayList;

/**
 * Created by mym on 11/7/16.
 */

public class Schema {
    private String name;
    private ArrayList<Table> tables = new ArrayList<Table>();
    private ArrayList<View> views = new ArrayList<View>();
    private ArrayList<Function> functions = new ArrayList<Function>();
    private ArrayList<Procedure> procedures = new ArrayList<Procedure>();
    private ArrayList<Package> packages = new ArrayList<Package>();

    public Schema(String name) {
        this.name = name;
    }

    public String getName(){
        return name;
    }

    public Schema(JSONObject schemaJSON) {
        name = (String) schemaJSON.get("name");
        JSONArray functionSJONArray = (JSONArray) schemaJSON.get("function");

    }

    public Table getTable(int idx) {
        return tables.get(idx);
    }

    public Function getFunction(String name) {
        for (Function function : functions) {
            if (function.getName().equals(name))
                return function;
        }
        return null;
    }

    public Table getTable(String name) {
        for (Table table : tables) {
            if (table.getName().equals(name))
                return table;
        }
        return null;
    }

    public Procedure getProcedure(String name) {
        for (Procedure procedure : procedures) {
            if (procedure.getName().equals(name))
                return procedure;
        }
        return null;
    }

    public void addProcedure(Procedure procedure) {
        if (procedure != null)
            procedures.add(procedure);
    }

    public void addFunction(Function function) {
        if (function != null)
            functions.add(function);
    }

    public void addPackage(Package pkg){
        if (pkg != null)
            packages.add(pkg);
    }

    public void printFnc() {
        for (Function function : functions) {
            System.out.println(function.getName());
        }
    }

    public void printPrc() {
        for (Procedure procedure : procedures) {
            System.out.println(procedure.getName());
        }
    }

    public JSONObject toJSON() {
        JSONObject schema = new JSONObject();
        schema.put("name", name);

        JSONArray procedureJSONArray = new JSONArray();
        for (Procedure procedure : procedures) {
            procedureJSONArray.add(procedure.toJSON());
        }
        schema.put("procedure", procedureJSONArray);

        JSONArray functionJSONArray = new JSONArray();
        for (Function function : functions) {
            functionJSONArray.add(function.toJSON());
        }
        schema.put("function", functionJSONArray);
        return schema;
    }

    public void classifiedFile() throws FileNotFoundException {
        String path = Util.path + "/"+ name +"/";
        File dir = new File(path);
        if (!dir.exists() || !dir.isDirectory()){
            dir.mkdir();
            System.out.println("Directory "+dir.getAbsolutePath()+" is created.");
        }
        PrintStream outspec, out = new PrintStream(new FileOutputStream(path + name + "-PRC.sql"));
        for (int i=0;i<procedures.size();i++){
            String prc = procedures.get(i).getSourceCode();
            out.println("--------------------------------------------------------\n"
                      + "--  DDL for Procedure " + procedures.get(i).getName() + "\n"
                      + "--------------------------------------------------------");
            out.println(prc);
        }
        out.close();

        out = new PrintStream(new FileOutputStream(path + name + "-FNC.sql"));
        for (int i=0;i<functions.size();i++){
            String fnc = functions.get(i).getSourceCode();
            out.println("--------------------------------------------------------\n"
                    + "--  DDL for Function " + functions.get(i).getName() + "\n"
                    + "--------------------------------------------------------");
            out.println(fnc);
        }
        out.close();

        out = new PrintStream(new FileOutputStream(path + name + "-NVW.sql"));
        for (int i=0;i<views.size();i++){
            String nvw = views.get(i).getSql();
            out.println("--------------------------------------------------------\n"
                    + "--  DDL for View " + views.get(i).getName() + "\n"
                    + "--------------------------------------------------------");
            out.println(nvw);
        }
        out.close();

        out = new PrintStream(new FileOutputStream(path + name + "-TBL.sql"));
        for (int i=0;i<tables.size();i++){
            String tbl = tables.get(i).getNiceJSON();
            out.println("--------------------------------------------------------\n"
                    + "--  DDL for Table " + tables.get(i).getName() + "\n"
                    + "--------------------------------------------------------");
            out.println(tbl);
        }
        out.close();

        out = new PrintStream(new FileOutputStream(path + name + "-PKG.sql"));
        outspec = new PrintStream(new FileOutputStream(path + name + "-PKG-SPEC.sql"));
        for (int i=0;i<packages.size();i++){
            String body = packages.get(i).getBody();
            String spec = packages.get(i).getSpecification();
            String title = "--------------------------------------------------------\n"
                    + "--  DDL for Table " + packages.get(i).getName() + "\n"
                    + "--------------------------------------------------------";
            out.println(title);
            out.println(body);

            outspec.println(title);
            outspec.println(spec);
        }
        out.close();
        outspec.close();
    }

    public void createSnapshot() throws FileNotFoundException {
        PrintStream out = new PrintStream(new FileOutputStream(name + ".snapshot"));
        out.println(toJSON().toJSONString());
    }

    public void printTbl() {
        for (Table table : tables) {
            System.out.println(table);
        }
    }

    public void printView() {
        for (View view : views) {
            System.out.println(view);
        }
    }

    public void addTable(Table table) {
        if (table != null)
            tables.add(table);
    }

    public void addView(View view) {
        if (view != null)
            views.add(view);
    }

    public Package getPackage(int idx) {
        return packages.get(idx);
    }

    public View getView(int idx) {
        return views.get(idx);
    }
}
