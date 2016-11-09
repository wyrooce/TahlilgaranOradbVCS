package ir.wyrooce.model;

/**
 * Created by mym on 11/8/16.
 */
public class Query {
    final public static String tableProperty =
            "SELECT COLUMN_NAME, DATA_TYPE, DATA_LENGTH, NULLABLE, DATA_DEFAULT  " +
            "FROM DBA_TAB_COLUMNS\nWHERE OWNER = \'HAMI\' AND TABLE_NAME = \'TBL_HAMI\' ";
    final public static String procedureSourceCodeSQL =
            "WITH TMP AS  (SELECT lower(SUBSTR(type, 1,1)) type, NAME, LINE, SUBSTR(TEXT, 0, CASE WHEN INSTR(TEXT, '--') = 0 THEN LENGTH(TEXT)  ELSE INSTR(TEXT, '--')-1  END) TEXT FROM USER_SOURCE WHERE INSTR(TRIM(TEXT), '--') <> 1  AND TRIM(TEXT)  <> CHR(10)  AND TYPE = 'PROCEDURE'  ORDER BY NAME,  LINE  ) SELECT NAME,  regexp_replace( REPLACE( RTRIM(XMLAGG(XMLELEMENT(E, trim(TEXT), '').EXTRACT('//text()') ORDER BY LINE).GetClobVal(),','), chr(10), ' '), ' +', ' ') AS CODe FROM TMP GROUP BY NAME";
    final public static String functionSerouceCode =
            "WITH TMP AS\n" +
                    "  (SELECT lower(SUBSTR(type, 1,1)) type,\n" +
                    "    NAME,\n" +
                    "    LINE,\n" +
                    "    SUBSTR(TEXT, 0,\n" +
                    "    CASE\n" +
                    "      WHEN INSTR(TEXT, '--') = 0\n" +
                    "      THEN LENGTH(TEXT)\n" +
                    "      ELSE INSTR(TEXT, '--')-1\n" +
                    "    END) TEXT\n" +
                    "  FROM USER_SOURCE\n" +
                    "  WHERE INSTR(TRIM(TEXT), '--') <> 1\n" +
                    "  AND TRIM(TEXT)                <> CHR(10)\n" +
                    "  AND TYPE = 'FUNCTION'\n" +
                    "  ORDER BY NAME,\n" +
                    "    LINE\n" +
                    "  )\n" +
                    "SELECT\n" +
                    "  NAME,\n" +
                    "  regexp_replace( REPLACE( RTRIM(XMLAGG(XMLELEMENT(E, trim(TEXT), '').EXTRACT('//text()')\n" +
                    "ORDER BY LINE).GetClobVal(),','), chr(10), ' '), ' +', ' ') AS CODe\n" +
                    "FROM TMP\n" +
                    "GROUP BY NAME\n";


}
