package com.brickman.app.common.http.param;

import android.text.TextUtils;

import com.brickman.app.common.base.Api;
import com.brickman.app.common.utils.LogUtil;
import com.brickman.app.common.utils.MD5;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Random;

/**
 * 参数实体
 *
 * @author mayu
 */
public class RequestParam {

    private HashMap<String, String> map = new HashMap<String, String>();

    private JSONObject jsonObject = new JSONObject();

    public HashMap<String, String> toHashMap() {
        return map;
    }

    public RequestParam append(String key, String value) {
        map.put(key, value);
        return this;
    }

    /**
     * @return 参数的json格式
     */
    public JSONObject toJson() {
        jsonObject = new JSONObject(map);
        return jsonObject;
    }

    /**
     * 将json数组转换成&链接的表单
     *
     * @param params
     * @return
     */
    public String toString(JSONObject params) {
        String param = "";
        try {
            Iterator<String> keys = params.keys();
            for (int i = 0; i < params.length(); i++) {
                String key = keys.next();
                if (i == 0) {
                    param += (key + "=" + params.getString(key));
                } else {
                    param += ("&" + key + "=" + params.getString(key));
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return param;
    }

    /**
     * 将map转换成&链接的表单
     *
     * @return
     */
    public String toString() {
        String param = "";
        int i = 0;
        for (String key : map.keySet()) {
            if (i == 0) {
                param += (key + "=" + map.get(key));
            } else {
                param += ("&" + key + "=" + map.get(key));
            }
            i++;
        }
        return param;
    }

    /**
     * 将json数组转换成&链接的表单
     *
     * @param params
     * @return
     */
    public static String JsonToParams(JSONObject params) {
        String param = "";
        try {
            Iterator<String> keys = params.keys();
            for (int i = 0; i < params.length(); i++) {
                String key = keys.next();
                if (i == 0) {
                    param += (key + "=" + params.getString(key));

                } else {
                    param += ("&" + key + "=" + params.getString(key));
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return param;
    }

    public String encrypt() {
        String ts = new Random().nextInt(10000000) + "";
        String rn = System.currentTimeMillis() + "";
        map.put("ts", ts);
        map.put("rn", rn);
        List<String> strings = new ArrayList<String>();
        for (String key : map.keySet()) {
            strings.add(map.get(key));
        }

        Collections.sort(strings);

        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < strings.size(); i++) {
            if (!TextUtils.isEmpty(strings.get(i))) {
                sb.append(strings.get(i));
            }
        }

        StringBuffer sb1 = new StringBuffer();
        sb1.append(MD5.encrypt(sb.toString()));
        sb1.append(".");
        sb1.append(Api.KEY);
        String cVal = MD5.encrypt(sb1.toString());
        return cVal;
    }
}
