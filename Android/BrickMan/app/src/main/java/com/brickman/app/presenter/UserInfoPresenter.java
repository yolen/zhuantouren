package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.UserInfoContract;
import com.yolanda.nohttp.OnUploadListener;

import org.json.JSONObject;

import java.util.List;

import static com.brickman.app.common.base.Api.UPLOAD_FILES;

/**
 * Created by mayu on 16/7/26,上午10:08.
 */

public class UserInfoPresenter extends UserInfoContract.Presenter {
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
            public void onFailed(int what, String url, Object tag, Exception exception, int responseCode, long networkMillis) {
                mView.cancelProgressDialog();
            }
        });
    }

    @Override
    public void cancelUpload() {
        HttpUtil.getRequestInstance().cancelBySign(UPLOAD_FILES);
    }

    @Override
    public void updateAvator(final String avatorUri) {
        mView.showLoading();
        mModel.updateAvator(avatorUri, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(HttpUtil.isSuccess(response)){
                    mView.updateAvatorSuccess(avatorUri);
                    mView.showMsg("更新成功!");
                } else {
                    mView.showMsg(response.optString("body"));
                }
                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, String url, Object tag, Exception exception, int responseCode, long networkMillis) {
                mView.dismissLoading();
            }
        });
    }

    @Override
    public void updateNickName(final String nickName) {
        mView.showLoading();
        mModel.updateNickName(nickName, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(HttpUtil.isSuccess(response)){
                    mView.updateNickNameSuccess(nickName);
                    mView.showMsg("更新成功!");
                } else {
                    mView.showMsg(response.optString("body"));
                }
                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, String url, Object tag, Exception exception, int responseCode, long networkMillis) {
                mView.dismissLoading();
            }
        });
    }

    @Override
    public void updateSexy(final String sexy) {
        mView.showLoading();
        mModel.updateSexy(sexy, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(HttpUtil.isSuccess(response)){
                    mView.updateSexySuccess(sexy);
                    mView.showMsg("更新成功!");
                } else {
                    mView.showMsg(response.optString("body"));
                }
                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, String url, Object tag, Exception exception, int responseCode, long networkMillis) {
                mView.dismissLoading();
            }
        });
    }

    @Override
    public void updateMotto(final String motto) {
        mView.showLoading();
        mModel.updateMotto(motto, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(HttpUtil.isSuccess(response)){
                    mView.updateMottoSuccess(motto);
                    mView.showMsg("更新成功!");
                } else {
                    mView.showMsg(response.optString("body"));
                }
                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, String url, Object tag, Exception exception, int responseCode, long networkMillis) {
                mView.dismissLoading();
            }
        });
    }

    @Override
    public void onStart() {
        super.onStart();
    }
}
