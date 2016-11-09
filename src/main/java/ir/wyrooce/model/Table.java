package ir.wyrooce.model;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;



/**
 * Created by mym on 11/7/16.
 */

public class Table {
    private String DDL;
    private String name;
    private Column[] columns;


    public String getDDL() {
        return DDL;
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

    public void setDDL(String DDL) {
        this.DDL = DDL;
    }
}
