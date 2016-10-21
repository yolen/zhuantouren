package com.brickman.app.common.http.listener;

import com.brickman.app.common.utils.LogUtil;
import com.yolanda.nohttp.OnUploadListener;

/**
 * Created by mayu on 16/7/27,下午3:21.
 */
public class OnUploadCallback implements OnUploadListener {

    @Override
    public void onStart(int what) {// 这个文件开始上传。
//        uploadFiles.get(what).setTitle(R.string.upload_start);
//        mUploadFileAdapter.notifyItemChanged(what);
    }

    @Override
    public void onCancel(int what) {// 这个文件的上传被取消时。
        LogUtil.debug("onCancel", what + "");
    }

    @Override
    public void onProgress(int what, int progress) {// 这个文件的上传进度发生边耍
        LogUtil.debug("onProgress", progress + "");
    }

    @Override
    public void onFinish(int what) {// 文件上传完成
        LogUtil.debug("onFinish", what + "");
    }

    @Override
    public void onError(int what, Exception exception) {// 文件上传发生错误。
        LogUtil.error("onError", exception);
    }
}
