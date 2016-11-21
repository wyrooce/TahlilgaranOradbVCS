package ir.wyrooce.model;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import java.util.ArrayList;


/**
 * Created by mym on 11/7/16.
 */

public class Table {
    private String DDL;
    private String name;
    private ArrayList<Column> columns = new ArrayList<Column>();


    public String getDDL() {
        return DDL;
    }

    public Table(String name) {
        this.name = name;
    }

    public JSONObject getJSON(){
        JSONObject tableJSON = new JSONObject();
        JSONArray columnsJSON = new JSONArray();

        tableJSON.put("name", name);

        for (Column column : columns) {
            columnsJSON.add(column.toJSON());
        }

        tableJSON.put("column", columnsJSON);
        return tableJSON;
    }

    public String getName() {
        return name;
    }

    public void addColumn(Column column){
        if (column != null)
            columns.add(column);
    }

    public void setName(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return "Table{" +
                "name='" + name + '\'' +
                ", columns=" + columns +
                '}';
    }

    public void setDDL(String DDL) {
        this.DDL = DDL;
    }
}
