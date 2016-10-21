package com.brickman.app.contract;

import com.brickman.app.common.base.BaseModel;
import com.brickman.app.common.base.BasePresenter;
import com.brickman.app.common.base.BaseView;
import com.brickman.app.common.http.HttpListener;
import com.yolanda.nohttp.OnUploadListener;

import org.json.JSONObject;

import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:29.
 */
public interface PublishContract {
    interface Model extends BaseModel {
        void uploadImages(List<String> imageList, OnUploadListener onUploadListener, HttpListener<JSONObject> httpListener);

        void publish(String content, String date, String address, boolean isGoodThing, String imageList, HttpListener httpListener);
    }

    interface View extends BaseView {
        void uploadImagesSuccess(String imageList);

        void publishSuccess();

        void updateProgress(int total, int currIndex, int prog);

        void cancelProgressDialog();

        void showMsg(String msg);
    }

    abstract class Presenter extends BasePresenter<Model, View> {
        public abstract void uploadImages(List<String> imageList);

        public abstract void cancelUpload();

        public abstract void publish(String content, String date, String address, boolean isGoodThing, String imageList);

        @Override
        public void onStart() {
        }
    }
}
