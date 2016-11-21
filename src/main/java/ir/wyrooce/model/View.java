package ir.wyrooce.model;

import java.security.NoSuchAlgorithmException;

/**
 * Created by mym on 11/12/16.
 */
public class View {
    private String name;
    private String sql;
    private String digestSQL;

    public String getName() {
        return name;
    }

    public String getDigestSQL() {
        return digestSQL;
    }

    public void setName(String name) {
        this.name = name;

    }

    public String getSql() {
        return sql;
    }

    public void setSql(String sql) throws NoSuchAlgorithmException {
        this.sql = sql;
        this.digestSQL = Util.sha1(sql);
    }

    @Override
    public String toString() {
        return "View{" +
                "name='" + name + '\'' +
                ", sql='" + sql + '\'' +
                ", digestSQL='" + digestSQL + '\'' +
                '}';
    }
}
