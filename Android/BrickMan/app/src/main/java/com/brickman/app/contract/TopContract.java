package com.brickman.app.contract;

import com.brickman.app.common.base.BaseModel;
import com.brickman.app.common.base.BasePresenter;
import com.brickman.app.common.base.BaseView;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.model.Bean.TopBean;

import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:29.
 */
public interface TopContract {
    interface Model extends BaseModel {
        void loadTopList(String type, HttpListener httpListener);
    }

    interface View extends BaseView {
        void showMsg(String msg);
        void loadTopListSuccess(String type, List<TopBean> topList);
    }

    abstract class Presenter extends BasePresenter<Model, View> {
        public abstract void loadTopList(String type);
        @Override
        public void onStart() {}
    }
}
