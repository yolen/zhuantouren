package com.brickman.app.common.utils;

import com.brickman.app.MApplication;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;

/**
 * Created by mayu on 16/7/20,下午4:23.
 */
public class AssetUtil {
    public static String readAssets(String fileName) {
        String json = "";
        try {
            InputStream inputStream = MApplication.getInstance().getAssets().open(fileName);
            int size = inputStream.available();
            byte[] buffer = new byte[size];
            inputStream.read(buffer);
            inputStream.close();
            json = new String(buffer, "utf-8");
        } catch (IOException e) {
            e.printStackTrace();
        }
        return json;
    }

    public static JSONObject readJSONAssets(String fileName) {
        String jsonStr = "";
        try {
            InputStream inputStream = MApplication.getInstance().getAssets().open(fileName);
            int size = inputStream.available();
            byte[] buffer = new byte[size];
            inputStream.read(buffer);
            inputStream.close();
            jsonStr = new String(buffer, "utf-8");
        } catch (IOException e) {
            e.printStackTrace();
        }
        JSONObject json = null;
        try {
            json = new JSONObject(jsonStr);
        } catch (JSONException e){
            LogUtil.error(e);
        }
        return json;
    }
}
