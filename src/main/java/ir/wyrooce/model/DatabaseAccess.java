package ir.wyrooce.model;

import java.io.IOException;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;

/**
 * Created by mym on 11/7/16.
 */

public class DatabaseAccess {

    final static String DB_DRIVER = "oracle.jdbc.driver.OracleDriver";
    Info info = new Info();

    public DatabaseAccess() throws IOException {
        info = Util.loadSetting();
    }

    public String getDBName(int i){
        return (String) info.getUser(i).get("username");
    }

    private Connection getDBConnection(int idx) {
        //loadSetting();

        Connection dbConnection = null;
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        try {
            dbConnection = DriverManager.getConnection("jdbc:oracle:thin:@" + info.host + ":" + info.sid
                    , (String) info.getUser(idx).get("username"), (String) info.getUser(idx).get("password"));
            dbConnection.setAutoCommit(true);
            return dbConnection;
        } catch (SQLException e) {
//            JOptionPane.showMessageDialog(null, "اتصال با پایگاه داده برقرار نشد");
            System.out.println("[ERR] Connection refused: "+info.getUser(idx).get("username"));
            System.out.println(e.getMessage());
            System.exit(1);
        }
        return dbConnection;
    }

    public ArrayList<View> getViewsByConnection(int idx) throws SQLException, NoSuchAlgorithmException {
        Connection con = getDBConnection(idx);
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

    public ArrayList<View> fetchViews(String mode, int idx) throws SQLException, NoSuchAlgorithmException {
        if (mode.equals("connection")) return getViewsByConnection(idx);
        return fetchViewsBySnapshot();
    }

    public ArrayList<Procedure> getProceduresByConnection(int idx) throws SQLException, NoSuchAlgorithmException {
        Connection con = getDBConnection(idx);
        PreparedStatement stm = con.prepareStatement(Util.procedureSourceCodeSQL);
        ResultSet set = stm.executeQuery();
        ArrayList<Procedure> resultArray = new ArrayList<Procedure>();

        while (set.next()) {
            resultArray.add(new Procedure(set.getString(1), set.getString(2)));
        }

        return resultArray;
    }

    public ArrayList<Procedure> fetchProcedures(String mode, int idx) throws SQLException, NoSuchAlgorithmException {
        if (mode.equals("connection")) return getProceduresByConnection(idx);
        else return getProceduresBySnapshot();
    }

    public ArrayList<Function> fetchFunction(String mode, int idx) throws SQLException, NoSuchAlgorithmException {
        if (mode.equals("connection")) return getFunctionByConnection(idx);
        else return fetchFunctionBySnapshot();
    }

    public ArrayList<Function> getFunctionByConnection(int idx) throws SQLException, NoSuchAlgorithmException {
        Connection con = getDBConnection(idx);
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

    public ArrayList<Table> fetchTable(String mode, int idx) throws SQLException {
        if (mode.equals("connection")) {
            return fetchTableByConnection(idx);
        } else return fetchTableBySnapshot();
    }

    public ArrayList<Table> fetchTableBySnapshot() {
        return null;
    }

    public ArrayList<Table> fetchTableByConnection(int idx) throws SQLException {
        Connection con = getDBConnection(idx);
        PreparedStatement stm = con.prepareStatement(Util.tableProperty);
        ResultSet set = stm.executeQuery();
        ArrayList<Table> resultArray = new ArrayList<Table>();
        String tblName = null;
        boolean flag = false;

        while (set.next()) {
            tblName = set.getString(1);
            for (Table tbl : resultArray) {
                if (tbl.getName().equals(tblName)) {
                    tbl.addColumn(new Column(set.getString(2), set.getString(3), set.getInt(4), set.getString(6), set.getString(5), set.getInt(7)));
                    flag = true;
                    break;
                }
            }
            if (!flag) {
                Table tbl = new Table(tblName);
                tbl.addColumn(new Column(set.getString(2), set.getString(3), set.getInt(4), set.getString(6), set.getString(5), set.getInt(7)));
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

    public ArrayList<Package> fetchPackages(String mode, int idx) throws SQLException {
        if (mode.equals("connection")) {
            return fetchPackagesByConnection(idx);
        } else return fetchPackagesBySnapshot();
    }

    private ArrayList<Package> fetchPackagesBySnapshot() {
        return null;
    }

    private ArrayList<Package> fetchPackagesByConnection(int idx) throws SQLException {
        Connection con = getDBConnection(idx);
        PreparedStatement stm = con.prepareStatement(Util.packageSQL);
        ResultSet set = stm.executeQuery();
        ArrayList<Package> resultArray = new ArrayList<Package>();

        while (set.next()) {
            resultArray.add(new Package(set.getString(1), set.getString(2), set.getString(3)));
        }
        return resultArray;
    }
}
