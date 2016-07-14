package com.brickman.app.common.http.param;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Iterator;

/**
 * 参数实体
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
	 *
	 * @return 参数的json格式
	 */
	public JSONObject toJson(){
        jsonObject = new JSONObject(map);
		return jsonObject;
	}

	/**
	 * 将json数组转换成&链接的表单
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
	 * 将json数组转换成&链接的表单
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
}
