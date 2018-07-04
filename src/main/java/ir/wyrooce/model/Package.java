package ir.wyrooce.model;


import java.security.NoSuchAlgorithmException;

/**
 * Created by mym on 11/12/16.
 */

public class Package {
    private String name;
    private String body;
    private String specification;

    public Package(String name, String body, String spec) {
        this.name = name;
        this.body = body;
        this.specification = spec;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public String getSpecification() {
        return specification;
    }

    public void setSpecification(String specification) {
        this.specification = specification;
    }

    public String getDigestSpecification() throws NoSuchAlgorithmException {
        if (specification == null)return null;
        String result = Util.sha1(getSpecification());
        return result;
    }

}