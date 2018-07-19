package ir.wyrooce.model;

import org.json.simple.JSONObject;

import java.util.ArrayList;
import java.util.Hashtable;

/**
 * Created by mym on 11/8/16.
 */
public class Column {

    private String name;
    private String dataType;
    private String dataDefault;
    private int dataLength;
    private String nullable;
    private int id;

    public Column(String name, String dataType, int dataLength, String dataDefault, String nullable, int id) {
        this.name = name;
        this.dataType = dataType;
        this.dataDefault = dataDefault;
        this.dataLength = dataLength;
        this.nullable = nullable;
        this.id = id;
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
        return dataDefault==null?"":dataDefault;
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

    public ArrayList<String> compare(Column otherColumn){//return compare json
        ArrayList<String> changesList = new ArrayList<String>();
        System.out.println(otherColumn.getName() + "(" + id + ") : " + getName() + "(" + id + ")");

        if (!otherColumn.getName().equals(getName()) && otherColumn.id != id) {//incompatible columns
            return null;
        }
        if (!otherColumn.getName().equals(getName()) && otherColumn.id == id){//rename
            changesList.add("RENAME COLUMN "+ getName() +" TO "+otherColumn.getName());

            //other spec?
        }
        if (!otherColumn.getDataType().equals(getDataType())){
            changesList.add("MODIFY ("+otherColumn.getName()+" "+otherColumn.getDataType()+")");
        }
        if (!otherColumn.getDataDefault().equals(getDataDefault())){
            changesList.add("MODIFY ("+otherColumn.getName()+" DEFAULT "+otherColumn.getDataDefault()+")");
        }
        if (!otherColumn.getNullable().equals(otherColumn.getNullable())){
            changesList.add("MODIFY ("+otherColumn.getName()+ (otherColumn.getNullable().equalsIgnoreCase("Null")? " NULL":" NOT NULL" +")"));
        }
        if (otherColumn.getDataLength() != otherColumn.getDataLength()){
            changesList.add("MODIFY ("+otherColumn.getName()+" "+otherColumn.getDataType()+")");
        }
        return changesList;
    }

    public int getDataLength() {
        return dataLength;
    }
}
