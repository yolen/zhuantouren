package com.brickman.app.contract;

import com.brickman.app.common.base.BaseModel;
import com.brickman.app.common.base.BasePresenter;
import com.brickman.app.common.base.BaseView;
import com.brickman.app.common.http.HttpListener;
import com.yolanda.nohttp.OnUploadListener;

import org.json.JSONObject;

import java.util.List;

/**
 * Created by mayu on 16/7/26,上午9:53.
 */

public interface UserInfoContract {
    interface Model extends BaseModel {
        void uploadImages(List<String> imageList, OnUploadListener onUploadListener, HttpListener<JSONObject> httpListener);
        void updateAvator(String avatorUri, HttpListener<JSONObject> httpListener);
        void updateNickName(String nickName, HttpListener<JSONObject> httpListener);
        void updateSexy(String sexy, HttpListener<JSONObject> httpListener);
        void updateMotto(String motto, HttpListener<JSONObject> httpListener);
    }

    interface View extends BaseView {
        void uploadImagesSuccess(String imageList);
        void updateAvatorSuccess(String avatorUrl);
        void updateNickNameSuccess(String nickName);
        void updateSexySuccess(String sexy);
        void updatePasswordSuccess(String password);
        void updateMottoSuccess(String motto);
        void showMsg(String msg);

        void updateProgress(int total, int currIndex, int prog);
        void cancelProgressDialog();
    }

    abstract class Presenter extends BasePresenter<Model, View> {
        public abstract void uploadImages(List<String> imageList);
        public abstract void cancelUpload();
        public abstract void updateAvator(String avatorUri);
        public abstract void updateNickName(String nickName);
        public abstract void updateSexy(String sexy);
        public abstract void updateMotto(String motto);
        @Override
        public void onStart() {}
    }
}
