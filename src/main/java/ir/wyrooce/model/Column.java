package ir.wyrooce.model;

import org.json.simple.JSONObject;

/**
 * Created by mym on 11/8/16.
 */
public class Column {

    private String name;
    private String dataType;
    private String dataDefault;
    private String nullable;

    public JSONObject getJSON(){
        JSONObject obj = new JSONObject();

        obj.put("name", name);
        obj.put("dataType", dataType);
        obj.put("dataDefault", dataDefault);
        obj.put("nullable", nullable);

        return obj;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDataType() {
        return dataType;
    }

    public void setDataType(String dataType) {
        this.dataType = dataType;
    }

    public String getDataDefault() {
        return dataDefault;
    }

    public void setDataDefault(String dataDefault) {
        this.dataDefault = dataDefault;
    }

    public String getNullable() {
        return nullable;
    }

    public void setNullable(String nullable) {
        this.nullable = nullable;
    }
}
