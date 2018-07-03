package ir.wyrooce.model;

import org.json.simple.JSONObject;

import java.security.NoSuchAlgorithmException;

/**
 * Created by mym on 11/7/16.
 */

public class Function {

    private String name;
    private String sourceCode;
    private String digestSourceCode;

    public Function(String name, String sourceCode) throws NoSuchAlgorithmException {
        this.name = name;
        this.sourceCode = Util.formatter(sourceCode);
        this.digestSourceCode = Util.sha1(sourceCode);
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
        JSONObject fncJSON = new JSONObject();
        fncJSON.put("digestSourceCode", sourceCode);
        fncJSON.put("sourceCode", sourceCode);
        fncJSON.put("name", name);

        return fncJSON;
    }

    public String getDigestSourceCode() {
        return digestSourceCode;
    }
}
