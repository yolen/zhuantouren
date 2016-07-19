package com.brickman.app.common.http;

import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.common.utils.LogUtil;
import com.yolanda.nohttp.NoHttp;
import com.yolanda.nohttp.RequestMethod;
import com.yolanda.nohttp.rest.CacheMode;
import com.yolanda.nohttp.rest.Request;

import org.json.JSONObject;

/**
 * Created by mayu on 16/6/21,上午11:27.
 */
public class RequestHelper {
    static HttpUtil mHttpUtil;

    static {
        mHttpUtil = HttpUtil.getRequestInstance();
    }

    public static void sendGETRequest(boolean isCache, String url, JSONObject params, boolean isLoading, HttpListener listener) {
        LogUtil.info(url);
        Request<JSONObject> request = NoHttp.createJsonObjectRequest(url, RequestMethod.GET);
        request.setHeader("platform", "Android");
        request.setCacheMode(isCache ? CacheMode.REQUEST_NETWORK_FAILED_READ_CACHE : CacheMode.ONLY_REQUEST_NETWORK);
        if(params != null){
            String param = RequestParam.JsonToParams(params);
            LogUtil.info("请求参数="+param);
            request.setDefineRequestBody(param, NoHttp.CHARSET_UTF8);
        }
        mHttpUtil.add(0, request, listener, true);
    }

    public static void sendPOSTRequest(boolean isCache, String url, Object params, HttpListener listener) {
        LogUtil.info(url);
        Request<JSONObject> request = NoHttp.createJsonObjectRequest(url, RequestMethod.POST);
        request.setHeader("platform", "Android");
        request.setCacheMode(isCache ? CacheMode.REQUEST_NETWORK_FAILED_READ_CACHE : CacheMode.ONLY_REQUEST_NETWORK);
        if(params != null){
            String param = "";
            if(params instanceof JSONObject){
                param = RequestParam.JsonToParams((JSONObject) params);
            } else if(params instanceof String){
                param = (String) params;
            }
            LogUtil.info(param);
            // 注意contentType
            request.setDefineRequestBody(param, NoHttp.CHARSET_UTF8);
        }
        mHttpUtil.add(0, request, listener, true);
    }
}
