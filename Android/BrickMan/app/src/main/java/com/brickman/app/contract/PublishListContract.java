package com.brickman.app.contract;

import com.brickman.app.common.base.BaseModel;
import com.brickman.app.common.base.BasePresenter;
import com.brickman.app.common.base.BaseView;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.model.Bean.UserBean;

import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:29.
 */
public interface PublishListContract {
    interface Model extends BaseModel {
        void loadBrickList(String userId, int pageNO, HttpListener httpListener);
    }

    interface View extends BaseView {
        void loadSuccess(List<BrickBean> brickList, UserBean userBean, int pageSize, boolean hasMore);
        void loadFailed();
        void showMsg(String msg);
    }

    abstract class Presenter extends BasePresenter<Model, View> {
        public abstract void loadBrickList(String userId, int pageNO);
        @Override
        public void onStart() {}
    }
}
