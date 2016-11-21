package ir.wyrooce.model;

import javax.swing.*;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.util.ArrayList;
import java.util.Scanner;

/**
 * Created by mym on 11/7/16.
 */
public class DatabaseAccess {
    private Schema schema;

    final static String DB_DRIVER = "oracle.jdbc.driver.OracleDriver";
    final static String DB_CONNECTION = "jdbc:oracle:thin:@185.23.129.101:1521:orcl";
    final static String DB_USER = "hami";
    final static String DB_PASSWORD = "tiAgp3N8F5";


    private String[] loadSetting(){
        String[] result = new String[4];
        Scanner input = null;
        try {
            input = new Scanner(new FileReader("setting-vcs.txt"));
        } catch (FileNotFoundException e) {
            JOptionPane.showMessageDialog(null, "فایل تنظیمات پیدا نشد");
            System.exit(1);
            e.printStackTrace();
        }
        while (input.hasNext()) {
            String tmp = input.nextLine().trim();
            if (tmp.substring(0, tmp.indexOf("=")).equals("username")) {
                result[0] = tmp.substring(tmp.indexOf("=")+1).trim();

            } else if (tmp.substring(0, tmp.indexOf("=")).equals("password")) {
                result[1] = tmp.substring(tmp.indexOf("=")+1).trim();

            } else if (tmp.substring(0, tmp.indexOf("=")).equals("host")) {
                result[2] = tmp.substring(tmp.indexOf("=")+1).trim();

            } else if (tmp.substring(0, tmp.indexOf("=")).equals("sid")) {
                result[3] = tmp.substring(tmp.indexOf("=")+1).trim();
            }
        }
        return result;
    }

    private Connection getDBConnection() {
        String[] connectionDescription = loadSetting();
        for (String con : connectionDescription) {
            if (con == null){
                JOptionPane.showMessageDialog(null, "فایل تنظیمات مشکل دارد");
                System.exit(1);
            }
        }

        Connection dbConnection = null;
        try {
            Class.forName(DB_DRIVER);
        } catch (ClassNotFoundException e) {
            System.out.println(e.getMessage());
        }
        try {
            dbConnection = DriverManager.getConnection("jdbc:oracle:thin:@"+connectionDescription[2]+":"+connectionDescription[3]
                    , connectionDescription[0], connectionDescription[1]);
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

        while (set.next()){
            View tmp = new View();
            tmp.setName(set.getString(1));
            String sql = set.getString(2);
            sql = Util.formatter(sql.replace("\n", " ").trim());
            tmp.setSql(sql);
            resultArray.add(tmp);
        }
        return resultArray;
    }

    public ArrayList<View> getViews(String mode) throws SQLException, NoSuchAlgorithmException {
        if (mode.equals("connection"))return getViewsByConnection();
        return getViewsBySnapshot();
    }

    public ArrayList<Procedure> getProceduresByConnection() throws SQLException, NoSuchAlgorithmException {
        Connection con = getDBConnection();
        PreparedStatement stm = con.prepareStatement(Util.procedureSourceCodeSQL);
        ResultSet set = stm.executeQuery();
        ArrayList<Procedure> resultArray = new ArrayList<Procedure>();

        while (set.next()){
            resultArray.add(new Procedure(set.getString(1), set.getString(2)));
        }

        return resultArray;
    }

    public ArrayList<Procedure> getProcedures(String mode) throws SQLException, NoSuchAlgorithmException {
        if (mode.equals("connection")) return getProceduresByConnection();
        else return getProceduresBySnapshot();
    }

    public ArrayList<Function> getFunction(String mode) throws SQLException, NoSuchAlgorithmException {
        if (mode.equals("connection")) return getFunctionByConnection();
        else return getFunctionBySnapshot();
    }

    public ArrayList<Function> getFunctionByConnection() throws SQLException, NoSuchAlgorithmException {
        Connection con = getDBConnection();
        PreparedStatement stm = con.prepareStatement(Util.functionSerouceCodeSQL);
        ResultSet set = stm.executeQuery();
        ArrayList<Function> resultArray = new ArrayList<Function>();

        while (set.next()){
            resultArray.add(new Function(set.getString(1), set.getString(2)));
        }

        return resultArray;
    }

    public ArrayList<Procedure> getProceduresBySnapshot() {
        return null;
    }

    public ArrayList<Table> getTable(String mode) throws SQLException {
        if (mode.equals("connection")){
            return getTableByConnection();
        }else return getTableBySnapshot();
    }

    public ArrayList<Table> getTableBySnapshot(){
        return null;
    }

    public ArrayList<Table> getTableByConnection() throws SQLException {
        Connection con = getDBConnection();
        PreparedStatement stm = con.prepareStatement(Util.tableProperty);
        ResultSet set = stm.executeQuery();
        ArrayList<Table> resultArray = new ArrayList<Table>();
        String tblName = null;
        boolean flag = false;

        while (set.next()){
            tblName = set.getString(1);
            for (Table tbl : resultArray){
                if (tbl.getName().equals(tblName)){
                    tbl.addColumn(new Column(set.getString(2), set.getString(3), set.getInt(4), set.getString(6), set.getString(5)));
                    flag = true;
                    break;
                }
            }
            if (!flag){
                Table tbl = new Table(tblName);
                tbl.addColumn(new Column(set.getString(2), set.getString(3), set.getInt(4), set.getString(6), set.getString(5)));
                resultArray.add(tbl);
                flag = !flag;
            }
            flag = !flag;
        }
        return resultArray;
    }

    public ArrayList<Function> getFunctionBySnapshot() {
        return null;
    }

    public ArrayList<View> getViewsBySnapshot() {
        return null;
    }
}
