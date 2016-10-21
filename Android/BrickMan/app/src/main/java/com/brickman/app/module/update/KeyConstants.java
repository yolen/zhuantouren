package com.brickman.app.module.update;

/**
 * Created by mayu on 16/5/26,上午10:19.
 */
public class KeyConstants {
    // json {"url":"http://192.168.205.33:8080/Hello/medtime_v3.0.1_Other_20150116.apk","versionCode":2,"updateMessage":"版本更新信息"}
    //我这里服务器返回的json数据是这样的，可以根据实际情况修改下面参数的名称
    public static final String APK_DOWNLOAD_URL = "downLink";
    public static final String APK_UPDATE_CONTENT = "updateDesc";
    public static final String APK_VERSION_CODE = "versionCode";
    public static final String APK_VERSION_NAME = "versionName";
}
