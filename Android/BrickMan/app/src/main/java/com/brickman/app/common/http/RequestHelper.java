package com.brickman.app.common.http;

import android.os.Handler;

import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.common.utils.AssetUtil;
import com.brickman.app.common.utils.LogUtil;
import com.yolanda.nohttp.BasicBinary;
import com.yolanda.nohttp.Binary;
import com.yolanda.nohttp.Headers;
import com.yolanda.nohttp.InputStreamBinary;
import com.yolanda.nohttp.NoHttp;
import com.yolanda.nohttp.OnUploadListener;
import com.yolanda.nohttp.RequestMethod;
import com.yolanda.nohttp.rest.CacheMode;
import com.yolanda.nohttp.rest.Request;

import org.json.JSONObject;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.List;

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
        if (params != null) {
            String param = RequestParam.JsonToParams(params);
            LogUtil.info("请求参数=" + param);
            request.setDefineRequestBody(param, NoHttp.CHARSET_UTF8);
        }
        mHttpUtil.add(0, request, listener, true);
    }

    public static void sendPOSTRequest(boolean isCache, final String url, RequestParam params, final HttpListener listener) {
        LogUtil.info(url);
        if (url.contains("DEMO")) {
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    JSONObject json = AssetUtil.readJSONAssets(url.split("/")[3]);
                    listener.onSucceed(json);
                }
            }, 800);
        } else {
            Request<JSONObject> request = NoHttp.createJsonObjectRequest(url, RequestMethod.POST);
            request.setHeader("platform", "Android");
            request.setCacheMode(isCache ? CacheMode.REQUEST_NETWORK_FAILED_READ_CACHE : CacheMode.ONLY_REQUEST_NETWORK);
            String paramStr = "";
            if (params != null) {
                paramStr = params.append("cVal", params.encrypt()).toString();
            }
            LogUtil.info("参数:" + paramStr);
            request.setDefineRequestBody(paramStr, Headers.HEAD_VALUE_ACCEPT_APPLICATION_X_WWW_FORM_URLENCODED);
            mHttpUtil.add(0, request, listener, true);
        }
    }

    public static void uploadFile(String url, RequestParam params, List<String> fileList, OnUploadListener onUploadListener) {
//        +"?ts=9371859&userId=test1&cVal=6d51d0721e7c2a7e9c975b49d4844d86&rn=1469607952195"
        LogUtil.info(url);
        String paramStr = "";
        if (params != null) {
            paramStr = params.append("cVal", params.encrypt()).toString();
        }
        LogUtil.info("参数:" + paramStr);
        Request<JSONObject> request = NoHttp.createJsonObjectRequest(url+"?"+paramStr, RequestMethod.POST);
        request.setHeader("platform", "Android");
        List<Binary> binaries = new ArrayList<>();
        for (int i = 0; i < fileList.size(); i++) {
            File dir = new File(fileList.get(i));
            if (!dir.exists()) {
                dir.mkdir();
            }
            File file = new File(fileList.get(i));
            BasicBinary binary = null;
            try {
                binary = new InputStreamBinary(new FileInputStream(file), file.getName());
            } catch (FileNotFoundException e) {
                e.printStackTrace();
            }
            binary.setUploadListener(i, onUploadListener);
            binaries.add(binary);
        }
        // 添加FileList到请求
        request.add("files", binaries);
        mHttpUtil.add(0, request, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {

            }

            @Override
            public void onFailed(int what, String url, Object tag, Exception exception, int responseCode, long networkMillis) {

            }
        }, true);
    }
}
