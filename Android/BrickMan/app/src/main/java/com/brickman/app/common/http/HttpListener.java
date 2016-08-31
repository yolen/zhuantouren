package com.brickman.app.common.http;

import com.yolanda.nohttp.rest.Response;

/**
 * 接受回调结果.
 * @param <T>
 */
public interface HttpListener<T> {

    void onSucceed(T response);

//    void onSucceed(int what, T response, String responseStr);

//    void onFailed(int what, String url, Object tag, Exception exception, int responseCode, long networkMillis);
    void onFailed(int what, Response<T> response);
}