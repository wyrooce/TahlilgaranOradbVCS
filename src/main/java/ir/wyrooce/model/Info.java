package ir.wyrooce.model;

import org.json.simple.JSONObject;

import java.util.ArrayList;

public class Info {
    public String sid;
    public String host;
    private ArrayList<JSONObject> users = new ArrayList<JSONObject>();

    public JSONObject getUser(int idx){
        return users.get(idx);
    }

    public int userCount(){
        return users.size();
    }

    public void addUser(String username, String password){
        JSONObject newUser = new JSONObject();
        newUser.put("username", username);
        newUser.put("password", password);
        users.add(newUser);
    }
}