package com.brickman.app.common.utils;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;

/**
 * Created by zhangshiyu on 2016/12/8.
 */

public class StringUtil {

    public static String getStringByEmoji(String unicode){

        try {
            return  URLEncoder.encode(unicode,"UTF-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }return null;
    }
    public static  String getEmojiByString(String contnet){
        try {
            return URLDecoder.decode(contnet,"utf-8");
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }return null;
    }
}
