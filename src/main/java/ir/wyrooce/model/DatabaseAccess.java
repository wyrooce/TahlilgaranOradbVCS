package ir.wyrooce.model;

import javax.swing.*;
import java.io.*;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Properties;

/**
 * Created by mym on 11/7/16.
 */


public class DatabaseAccess {

    final static String DB_DRIVER = "oracle.jdbc.driver.OracleDriver";
    private String sid;
    private String password;
    private String username;
    private String host;


//    final static String DB_CONNECTION = "jdbc:oracle:thin:@185.23.129.101:1521:orcl";
//    final static String DB_USER = "akin";
//    final static String DB_PASSWORD = "akin";


    public DatabaseAccess() {
        loadSetting();
    }

    public String getDBName(){
        return username;
    }

    private void loadSetting() {
        Properties prop = new Properties();
        InputStream input = null;

        try {

            input = new FileInputStream(Util.path+"/Config/setting-vcs.txt");

            // load a properties file
            prop.load(input);

            // get the property value and print it out
            username = prop.getProperty("username");
            password = prop.getProperty("password");
            sid = prop.getProperty("sid");
            host = prop.getProperty("host");
        } catch (IOException ex) {
            ex.printStackTrace();
        } finally {
            if (input != null) {
                try {
                    input.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private Connection getDBConnection() {
        //loadSetting();

        Connection dbConnection = null;
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        try {
            dbConnection = DriverManager.getConnection("jdbc:oracle:thin:@" + host + ":" + sid
                    , username, password);
            dbConnection.setAutoCommit(true);
            return dbConnection;
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "اتصال با پایگاه داده برقرار نشد");
            System.out.println(e.getMessage());
            System.exit(1);
        }

        return dbConnection;
    }

    public ArrayList<View> getViewsByConnection() throws SQLException, NoSuchAlgorithmException {
        Connection con = getDBConnection();
        PreparedStatement stm = con.prepareStatement(Util.viewSQL);
        ResultSet set = stm.executeQuery();
        ArrayList<View> resultArray = new ArrayList<View>();

        while (set.next()) {
            View tmp = new View();
            tmp.setName(set.getString(1));
            String sql = set.getString(2);
            sql = Util.formatter(sql.replace("\n", " ").trim());
            tmp.setSql(sql);
            resultArray.add(tmp);
        }
        return resultArray;
    }

    public ArrayList<View> fetchViews(String mode) throws SQLException, NoSuchAlgorithmException {
        if (mode.equals("connection")) return getViewsByConnection();
        return fetchViewsBySnapshot();
    }

    public ArrayList<Procedure> getProceduresByConnection() throws SQLException, NoSuchAlgorithmException {
        Connection con = getDBConnection();
        PreparedStatement stm = con.prepareStatement(Util.procedureSourceCodeSQL);
        ResultSet set = stm.executeQuery();
        ArrayList<Procedure> resultArray = new ArrayList<Procedure>();

        while (set.next()) {
            resultArray.add(new Procedure(set.getString(1), set.getString(2)));
        }

        return resultArray;
    }

    public ArrayList<Procedure> fetchProcedures(String mode) throws SQLException, NoSuchAlgorithmException {
        if (mode.equals("connection")) return getProceduresByConnection();
        else return getProceduresBySnapshot();
    }

    public ArrayList<Function> fetchFunction(String mode) throws SQLException, NoSuchAlgorithmException {
        if (mode.equals("connection")) return getFunctionByConnection();
        else return fetchFunctionBySnapshot();
    }

    public ArrayList<Function> getFunctionByConnection() throws SQLException, NoSuchAlgorithmException {
        Connection con = getDBConnection();
        PreparedStatement stm = con.prepareStatement(Util.functionSourceCodeSQL);
        ResultSet set = stm.executeQuery();
        ArrayList<Function> resultArray = new ArrayList<Function>();

        while (set.next()) {
            resultArray.add(new Function(set.getString(1), set.getString(2)));
        }

        return resultArray;
    }

    public ArrayList<Procedure> getProceduresBySnapshot() {
        return null;
    }

    public ArrayList<Table> fetchTable(String mode) throws SQLException {
        if (mode.equals("connection")) {
            return fetchTableByConnection();
        } else return fetchTableBySnapshot();
    }

    public ArrayList<Table> fetchTableBySnapshot() {
        return null;
    }

    public ArrayList<Table> fetchTableByConnection() throws SQLException {
        Connection con = getDBConnection();
        PreparedStatement stm = con.prepareStatement(Util.tableProperty);
        ResultSet set = stm.executeQuery();
        ArrayList<Table> resultArray = new ArrayList<Table>();
        String tblName = null;
        boolean flag = false;

        while (set.next()) {
            tblName = set.getString(1);
            for (Table tbl : resultArray) {
                if (tbl.getName().equals(tblName)) {
                    tbl.addColumn(new Column(set.getString(2), set.getString(3), set.getInt(4), set.getString(6), set.getString(5)));
                    flag = true;
                    break;
                }
            }
            if (!flag) {
                Table tbl = new Table(tblName);
                tbl.addColumn(new Column(set.getString(2), set.getString(3), set.getInt(4), set.getString(6), set.getString(5)));
                resultArray.add(tbl);
                flag = !flag;
            }
            flag = !flag;
        }
        return resultArray;
    }

    public ArrayList<Function> fetchFunctionBySnapshot() {
        return null;
    }

    public ArrayList<View> fetchViewsBySnapshot() {
        return null;
    }

    public ArrayList<Package> fetchPackages(String mode) throws SQLException {
        if (mode.equals("connection")) {
            return fetchPackagesByConnection();
        } else return fetchPackagesBySnapshot();
    }

    private ArrayList<Package> fetchPackagesBySnapshot() {
        return null;
    }

    private ArrayList<Package> fetchPackagesByConnection() throws SQLException {
        Connection con = getDBConnection();
        PreparedStatement stm = con.prepareStatement(Util.packageSQL);
        ResultSet set = stm.executeQuery();
        ArrayList<Package> resultArray = new ArrayList<Package>();

        while (set.next()) {
            resultArray.add(new Package(set.getString(1), set.getString(2), set.getString(3)));
        }
        return resultArray;
    }
}
