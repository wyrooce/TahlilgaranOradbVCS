package ir.wyrooce.model;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

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
    private ArrayList<Function> functions = new ArrayList<Function>();
    private ArrayList<Procedure> procedures = new ArrayList<Procedure>();

    public Schema(String name) {
        this.name = name;
    }

    public Table getTable(int idx){
        return tables.get(idx);
    }

    public Function getFunction(String name){
        for (Function function : functions) {
            if (function.getName().equals(name))
                return function;
        }
        return null;
    }

    public Procedure getProcedure(String name){
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

    public void printFnc(){
        for (Function function : functions) {
            System.out.println(function.getName());
        }
    }

    public void printPrc() {
        for (Procedure procedure : procedures) {
            System.out.println(procedure.getName());
        }
    }

    public JSONObject getJSON(){
        JSONObject schema = new JSONObject();
        schema.put("name", name);

        JSONArray procedureJSONArray = new JSONArray();
        for (Procedure procedure : procedures) {
            procedureJSONArray.add(procedure.getJSON());
        }
        schema.put("procedure", null);

        JSONArray functionJSONArray = new JSONArray();
        for (Function function : functions) {
            functionJSONArray.add(function);
        }
        schema.put("function", functions.get(2).getJSON());
        return schema;
    }

    public void createSnapshot() throws FileNotFoundException {
        PrintStream out = new PrintStream(new FileOutputStream(name+".snapshot"));
        out.println(getJSON().toJSONString());
    }
}
