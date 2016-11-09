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


    public Procedure(String name, String digestSourceCode) throws NoSuchAlgorithmException {
        this.name = name;
        this.digestSourceCode = digestSourceCode;
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
        procedureJSON.put("name", name);
        return procedureJSON;
    }

    public double similarity(Procedure procedure){
        NormalizedLevenshtein nl = new NormalizedLevenshtein();
        double similarity = nl.similarity(digestSourceCode, procedure.getDigestSourceCode());
        return similarity*100;
    }

    public boolean equalCode(Procedure procedure){
        return digestSourceCode.equals(procedure.digestSourceCode);
    }
}
