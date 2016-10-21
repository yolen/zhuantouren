package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.PublishContract;
import com.yolanda.nohttp.OnUploadListener;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONObject;

import java.util.List;

import static com.brickman.app.common.base.Api.UPLOAD_FILES;

/**
 * Created by mayu on 16/8/2,下午1:09.
 */

public class PublishPresenter extends PublishContract.Presenter {
    @Override
    public void uploadImages(final List<String> imageList) {
        mModel.uploadImages(imageList, new OnUploadListener() {
            @Override
            public void onStart(int what) {
                mView.updateProgress(imageList.size(), what, 0);
            }

            @Override
            public void onCancel(int what) {
                mView.cancelProgressDialog();
            }

            @Override
            public void onProgress(int what, int progress) {
                mView.updateProgress(imageList.size(), what, progress);
            }

            @Override
            public void onFinish(int what) {
            }

            @Override
            public void onError(int what, Exception exception) {
                mView.cancelProgressDialog();
            }
        }, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(HttpUtil.isSuccess(response)){
                    mView.uploadImagesSuccess(response.optString("body"));
                } else {
                    mView.showMsg(response.optString("body"));
                }
                mView.cancelProgressDialog();
            }

            @Override
            public void onFailed(int what, Response<JSONObject> response) {
                mView.showMsg(HttpUtil.makeErrorMessage(response.getException()));
                mView.cancelProgressDialog();
            }
        });
    }

    @Override
    public void cancelUpload() {
        HttpUtil.getRequestInstance().cancelBySign(UPLOAD_FILES);
    }

    @Override
    public void publish(String content, String date, String address, boolean isGoodThing, String imageList) {
        mView.showLoading();
        mModel.publish(content, date,address, isGoodThing, imageList, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
               if(HttpUtil.isSuccess(response)){
                    mView.publishSuccess();
                } else {
                   mView.showMsg("发布失败");
               }
                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, Response<JSONObject> response) {
                mView.showMsg(HttpUtil.makeErrorMessage(response.getException()));
                mView.dismissLoading();
            }
        });
    }

    @Override
    public void onStart() {
        super.onStart();
    }
}
