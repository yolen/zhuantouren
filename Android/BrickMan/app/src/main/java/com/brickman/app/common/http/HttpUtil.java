package com.brickman.app.common.http;

import com.brickman.app.common.http.listener.HttpResponseListener;
import com.yolanda.nohttp.NoHttp;
import com.yolanda.nohttp.download.DownloadQueue;
import com.yolanda.nohttp.error.NetworkError;
import com.yolanda.nohttp.error.NotFoundCacheError;
import com.yolanda.nohttp.error.TimeoutError;
import com.yolanda.nohttp.error.URLError;
import com.yolanda.nohttp.error.UnKnownHostError;
import com.yolanda.nohttp.rest.Request;
import com.yolanda.nohttp.rest.RequestQueue;

import org.json.JSONObject;

import java.net.ProtocolException;

/**
 * Created by mayu on 16/6/21,上午10:37.
 */
public class HttpUtil {
    private static HttpUtil httpUtil;

    /**
     * 请求队列.
     */
    private RequestQueue requestQueue;

    /**
     * 下载队列.
     */
    private static DownloadQueue downloadQueue;

    private HttpUtil() {
        requestQueue = NoHttp.newRequestQueue();
    }

    /**
     * 请求队列.
     */
    public synchronized static HttpUtil getRequestInstance() {
        if (httpUtil == null)
            httpUtil = new HttpUtil();
        return httpUtil;
    }

    /**
     * 下载队列.
     */
    public static DownloadQueue getDownloadInstance() {
        if (downloadQueue == null)
            downloadQueue = NoHttp.newDownloadQueue();
        return downloadQueue;
    }

    /**
     * 添加一个请求到请求队列.
     *
     * @param what      用来标志请求, 当多个请求使用同一个{@link HttpListener}时, 在回调方法中会返回这个what.
     * @param request   请求对象.
     * @param callback  结果回调对象.
     * @param canCancel 是否允许用户取消请求.
     */
    public <T> void add(int what, Request<T> request, HttpListener<T> callback, boolean canCancel) {
        requestQueue.add(what, request, new HttpResponseListener<T>(callback, canCancel));
    }

    /**
     * 取消这个sign标记的所有请求.
     */
    public void cancelBySign(Object sign) {
        requestQueue.cancelBySign(sign);
    }

    /**
     * 取消队列中所有请求.
     */
    public void cancelAll() {
        requestQueue.cancelAll();
    }

    /**
     * 退出app时停止所有请求.
     */
    public void stopAll() {
        requestQueue.stop();
    }

    /**
     * http访问异常信息
     * @param exception
     * @return
     */
    public static String makeErrorMessage(Exception exception){
        if (exception instanceof NetworkError) {// 网络不好
            return "请检查网络。";
        } else if (exception instanceof TimeoutError) {// 请求超时
            return"请求超时，网络不好或者服务器不稳定。";
        } else if (exception instanceof UnKnownHostError) {// 找不到服务器
            return"未发现指定服务器。";
        } else if (exception instanceof URLError) {// URL是错的
            return"URL错误。";
        } else if (exception instanceof NotFoundCacheError) {
            // 这个异常只会在仅仅查找缓存时没有找到缓存时返回
            return"没有发现缓存。";
        } else if (exception instanceof ProtocolException) {
            return"系统不支持的请求方式。";
        } else {
            return"未知错误。";
        }
    }

    public static boolean isSuccess(JSONObject jsonObject){
        if(jsonObject.optInt("code") == 101){
            return true;
        } else if(jsonObject.optInt("code") == 103){
            return false;
        } else
            return false;
    }
}
