package com.brickman.app.common.http.listener;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.utils.LogUtil;
import com.yolanda.nohttp.rest.OnResponseListener;
import com.yolanda.nohttp.rest.Response;

/**
 * http响应
 *
 * @param <T>
 */
public class HttpResponseListener<T> implements OnResponseListener<T> {

    /**
     * 结果回调.
     */
    private HttpListener<T> callback;

    /**
     * @param httpCallback 回调对象.
     * @param canCancel    是否允许用户取消请求.
     */
    public HttpResponseListener(HttpListener<T> httpCallback, boolean canCancel) {
        this.callback = httpCallback;
    }

    /**
     * 开始请求, 这里显示一个dialog.
     */
    @Override
    public void onStart(int what) {
    }

    /**
     * 结束请求, 这里关闭dialog.
     */
    @Override
    public void onFinish(int what) {
    }

    /**
     * 成功回调.
     */
    @Override
    public void onSucceed(int what, Response<T> response) {
        String string = response.isFromCache() ? MApplication.mAppContext.getString(R.string.request_from_cache) : MApplication.mAppContext.getString(R.string.request_from_network);
        LogUtil.info("-------" + string + "-------");
        int responseCode = response.getHeaders().getResponseCode();
        LogUtil.info("【" + responseCode + "】" + "---" + response.get());
        if (responseCode > 400) {
            if (responseCode == 405) {// 405表示服务器不支持这种请求方法，比如GET、POST、TRACE中的TRACE就很少有服务器支持。
                LogUtil.debug("请求失败:", "请求的方法被不服务器允许。");
            } else {// 但是其它400+的响应码服务器一般会有流输出。
                LogUtil.debug("请求失败:", response.toString());
            }
        }
        if (callback != null) {
            callback.onSucceed(response.get());
        }
    }

    /**
     * 失败回调.
     */
    @Override
    public void onFailed(int what, Response<T> response) {
        String string = response.isFromCache() ? MApplication.mAppContext.getString(R.string.request_from_cache) : MApplication.mAppContext.getString(R.string.request_from_network);
        LogUtil.info("-------" + string + "-------" + "\n" + response.get());
        if (callback != null)
            callback.onFailed(what, response);
    }
}