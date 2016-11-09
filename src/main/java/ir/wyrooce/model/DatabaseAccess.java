package ir.wyrooce.model;

import javax.swing.*;
import java.io.FileNotFoundException;
import java.io.FileReader;
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

    public ArrayList<Procedure> getProcedures() throws SQLException {
        Connection con = getDBConnection();
        PreparedStatement stm = con.prepareStatement(Query.procedureSourceCodeSQL);
        ResultSet set = stm.executeQuery();
        ArrayList<Procedure> resultArray = new ArrayList<Procedure>();

        while (set.next()){
            resultArray.add(new Procedure(set.getString(1), set.getString(2)));
        }

        return resultArray;
    }

    public ArrayList<Function> getFunction() throws SQLException {
        Connection con = getDBConnection();
        PreparedStatement stm = con.prepareStatement(Query.functionSerouceCode);
        ResultSet set = stm.executeQuery();
        ArrayList<Function> resultArray = new ArrayList<Function>();

        while (set.next()){
            resultArray.add(new Function(set.getString(1), set.getString(2)));
        }

        return resultArray;
    }
}
