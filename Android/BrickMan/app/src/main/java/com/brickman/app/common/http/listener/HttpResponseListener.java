package com.brickman.app.common.http.listener;

import com.brickman.app.R;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.utils.LogUtil;
import com.brickman.app.common.base.BaseActivity;
import com.yolanda.nohttp.error.NetworkError;
import com.yolanda.nohttp.error.NotFoundCacheError;
import com.yolanda.nohttp.error.TimeoutError;
import com.yolanda.nohttp.error.URLError;
import com.yolanda.nohttp.error.UnKnownHostError;
import com.yolanda.nohttp.rest.OnResponseListener;
import com.yolanda.nohttp.rest.Response;

import java.net.ProtocolException;

/**
 * http响应
 * @param <T>
 */
public class HttpResponseListener<T> implements OnResponseListener<T> {

    private BaseActivity context;

    /**
     * 结果回调.
     */
    private HttpListener<T> callback;

    /**
     * 是否显示dialog.
     */
    private boolean isLoading;

    /**
     * @param context      context用来实例化dialog.
     * @param httpCallback 回调对象.
     * @param canCancel    是否允许用户取消请求.
     * @param isLoading    是否显示dialog.
     */
    public HttpResponseListener(BaseActivity context, HttpListener<T> httpCallback, boolean canCancel, boolean isLoading) {
        this.context = (BaseActivity) context;
        this.callback = httpCallback;
        this.isLoading = isLoading;
    }

    /**
     * 开始请求, 这里显示一个dialog.
     */
    @Override
    public void onStart(int what) {
        if (context != null && isLoading) {
            context.showLoading();
        }
    }

    /**
     * 结束请求, 这里关闭dialog.
     */
    @Override
    public void onFinish(int what) {
        if (context != null && isLoading) {
            context.dismissLoading();
        }
    }

    /**
     * 成功回调.
     */
    @Override
    public void onSucceed(int what, Response<T> response) {
        int responseCode = response.getHeaders().getResponseCode();
        if (responseCode > 400 && context != null) {
            if (responseCode == 405) {// 405表示服务器不支持这种请求方法，比如GET、POST、TRACE中的TRACE就很少有服务器支持。
                context.showToast(context.getResources().getString(R.string.request_failed) + ":" + context.getResources().getString(R.string.request_method_not_allow));
            } else {// 但是其它400+的响应码服务器一般会有流输出。
                context.showToast(response.toString());
            }
        }
        if (callback != null) {
            LogUtil.info(responseCode + ">>>" + response.get());
            callback.onSucceed(what, response.get());
        }
    }

    /**
     * 失败回调.
     */
    @Override
    public void onFailed(int what, String url, Object tag, Exception exception,
                         int responseCode, long networkMillis) {
        if (exception instanceof NetworkError) {// 网络不好
            context.showToast("请检查网络。");
        } else if (exception instanceof TimeoutError) {// 请求超时
            context.showToast("请求超时，网络不好或者服务器不稳定。");
        } else if (exception instanceof UnKnownHostError) {// 找不到服务器
            context.showToast("未发现指定服务器。");
        } else if (exception instanceof URLError) {// URL是错的
            context.showToast("URL错误。");
        } else if (exception instanceof NotFoundCacheError) {
            // 这个异常只会在仅仅查找缓存时没有找到缓存时返回
            context.showToast("没有发现缓存。");
        } else if (exception instanceof ProtocolException) {
            context.showToast("系统不支持的请求方式。");
        } else {
            context.showToast("未知错误。");
        }
        LogUtil.error(exception);
        if (callback != null)
            callback.onFailed(what, url, tag, exception, responseCode, networkMillis);
    }
}