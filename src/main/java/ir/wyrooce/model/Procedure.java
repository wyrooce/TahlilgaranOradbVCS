package ir.wyrooce.model;

import org.json.simple.JSONObject;
import info.debatty.java.stringsimilarity.*;

import java.security.NoSuchAlgorithmException;

/**
 * Created by mym on 11/7/16.
 */

public class Procedure {

    private String name;
    private String digestSourceCode;
    private String sourceCode;


    public Procedure(String name, String sourceCode) throws NoSuchAlgorithmException {
        this.name = name;
        this.sourceCode = Util.formatter(sourceCode);
        this.digestSourceCode = Util.sha1(sourceCode);
    }

    public String getDigestSourceCode() {
        return digestSourceCode;
    }

    public void setDigestSourceCode(String digestSourceCode) {
        this.digestSourceCode = digestSourceCode;
    }

    public String getName() {
        return name;
    }

    public JSONObject toJSON(){
        JSONObject procedureJSON = new JSONObject();
        procedureJSON.put("digestSourceCode", digestSourceCode);
        procedureJSON.put("sourceCode", sourceCode);
        procedureJSON.put("name", name);

        return procedureJSON;
    }

    public double similarity(Procedure procedure) {
        NormalizedLevenshtein nl = new NormalizedLevenshtein();
        double similarity = nl.similarity(sourceCode, procedure.getSourceCode());
        return similarity * 100;
    }

    public boolean equalCode(Procedure procedure){
        return digestSourceCode.equals(procedure.digestSourceCode);
    }

    public String getSourceCode() {
        return sourceCode;
    }
}
