package com.brickman.app.contract;

import com.brickman.app.common.base.BaseModel;
import com.brickman.app.common.base.BasePresenter;
import com.brickman.app.common.base.BaseView;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.model.Bean.BannerBean;
import com.brickman.app.model.Bean.BrickBean;

import org.json.JSONObject;

import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:29.
 */
public interface MainContract {
    interface Model extends BaseModel {
        void loadBanner(HttpListener<JSONObject> httpListener);
        void loadBrickList(int type, int pageNO, HttpListener httpListener);
    }

    interface View extends BaseView {
        void loadBannerSuccess(BannerBean bannerBean);
        void loadSuccess(int fragmentId, List<BrickBean> brickList, int pageSize, boolean hasMore);
        void loadFailed(int fragmentId);
        void showMsg(String msg);
    }

    abstract class Presenter extends BasePresenter<Model, View> {
        public abstract void loadBanner();
        public abstract void loadBrickList(int fragmentId, int pageNO);
        @Override
        public void onStart() {}
    }
}
