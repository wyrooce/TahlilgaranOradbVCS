package ir.wyrooce.model;

import org.json.simple.JSONObject;

/**
 * Created by mym on 11/8/16.
 */
public class Column {

    private String name;
    private String dataType;
    private String dataDefault;
    private int dataLength;
    private String nullable;

    public Column(String name, String dataType, int dataLength, String dataDefault, String nullable) {
        this.name = name;
        this.dataType = dataType;
        this.dataDefault = dataDefault;
        this.dataLength = dataLength;
        this.nullable = nullable;
    }

    public JSONObject toJSON(){
        JSONObject obj = new JSONObject();

        obj.put("name", name);
        obj.put("dataType", dataType);
        obj.put("dataDefault", dataDefault);
        obj.put("nullable", nullable);
        obj.put("dataLength", dataLength);

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

    @Override
    public String toString() {
        return "Column{" +
                "name='" + name + '\'' +
                '}';
    }
}
