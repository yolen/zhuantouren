package com.brickman.app.contract;

import com.brickman.app.common.base.BaseModel;
import com.brickman.app.common.base.BasePresenter;
import com.brickman.app.common.base.BaseView;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.model.Bean.BricksBean;

import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:29.
 */
public interface BricksListContract {
    interface Model extends BaseModel {
        void loadBricksList(int pageNO, HttpListener httpListener);
    }

    interface View extends BaseView {
        void loadSuccess(List<BricksBean> brickList, int pageSize, boolean hasMore);
        void showMsg(String msg);
    }

    abstract class Presenter extends BasePresenter<Model, View> {
        public abstract void loadBricksList(int pageNO);
        @Override
        public void onStart() {}
    }
}
