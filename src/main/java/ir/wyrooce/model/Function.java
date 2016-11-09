package ir.wyrooce.model;

import org.json.simple.JSONObject;

/**
 * Created by mym on 11/7/16.
 */

public class Function {

    private String name;
    private String sourceCode;

    public Function(String name, String sourceCode) {
        this.name = name;
        this.sourceCode = sourceCode;
    }

    public String getSourceCode() {
        return sourceCode;
    }

    public void setSourceCode(String sourceCode) {
        this.sourceCode = sourceCode;
    }

    public String getName() {
        return name;
    }

    public JSONObject toJSON() {
        JSONObject procedureJSON = new JSONObject();
        procedureJSON.put("sourceCode", sourceCode);
        procedureJSON.put("name", name);
        return procedureJSON;    }
}
