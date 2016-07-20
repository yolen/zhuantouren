package com.brickman.app.common.utils;

import android.content.Context;

import java.io.IOException;
import java.io.InputStream;

/**
 * Created by mayu on 16/7/20,下午4:23.
 */
public class AssetUtil {
    public static String readAssets(Context context) {
        String json = "";
        try {
            InputStream inputStream = context.getAssets().open("banner.json");
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
}
