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
 * Created by zhangshiyu on 2016/11/10.
 */

public interface MessageContract {
    interface Model extends BaseModel {

        void loadMessageList( int pageNO, HttpListener httpListener);
    }

    interface View extends BaseView {
        void loadMessageSuccess(List<String> dataist, boolean hasMor);

        void loadFailed();
        void showMsg(String msg);
    }

    abstract class Presenter extends BasePresenter<MessageContract.Model, MessageContract.View> {
        public abstract void loadMessagekList( int pageNO);
        @Override
        public void onStart() {}
    }
}
