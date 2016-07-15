package com.brickman.app.common.utils;

import com.orhanobut.logger.Logger;

import org.json.JSONObject;

/**
 * Logcat工具类
 * 
 * @author alaowan
 *
 */
public class LogUtil {
	private static final boolean isDebug = true;
	public static void error(String tag, Throwable e) {
		if(LogUtil.isDebug){
			Logger.e(e, tag);
		}
	}
	
	public static void error(Exception e) {
		if (e == null)
			return;
		if(LogUtil.isDebug){
            Logger.e(e, "Exception");
		}
	}

	public static void info(String message) {
		if (message == null)
			return;
		if(LogUtil.isDebug){
            Logger.i(message);
		}
	}

	public static void debug(String tag, String message) {
		if (message == null)
			return;
		if(LogUtil.isDebug){
			Logger.d(message);
		}
	}

    public static void json(JSONObject jsonObject){
        if(jsonObject == null)
            return;
        if(LogUtil.isDebug)
            Logger.json(jsonObject.toString());
    }

}
