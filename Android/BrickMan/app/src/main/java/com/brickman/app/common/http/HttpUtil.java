package com.brickman.app.common.http;

import com.brickman.app.common.http.listener.HttpResponseListener;
import com.brickman.app.ui.BaseActivity;
import com.yolanda.nohttp.NoHttp;
import com.yolanda.nohttp.download.DownloadQueue;
import com.yolanda.nohttp.rest.Request;
import com.yolanda.nohttp.rest.RequestQueue;

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
     * @param context   context用来实例化dialog.
     * @param what      用来标志请求, 当多个请求使用同一个{@link HttpListener}时, 在回调方法中会返回这个what.
     * @param request   请求对象.
     * @param callback  结果回调对象.
     * @param canCancel 是否允许用户取消请求.
     * @param isLoading 是否显示dialog.
     */
    public <T> void add(BaseActivity context, int what, Request<T> request, HttpListener<T> callback, boolean canCancel, boolean isLoading) {
        requestQueue.add(what, request, new HttpResponseListener<T>(context, callback, canCancel, isLoading));
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
}
