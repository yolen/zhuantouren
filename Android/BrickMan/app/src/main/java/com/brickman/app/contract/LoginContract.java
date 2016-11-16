package com.brickman.app.contract;

import com.brickman.app.common.base.BaseModel;
import com.brickman.app.common.base.BasePresenter;
import com.brickman.app.common.base.BaseView;
import com.brickman.app.common.http.HttpListener;
import  com.brickman.app.model.Bean.UserBean;


/**
 * Created by mayu on 16/7/18,下午1:29.
 */
public interface LoginContract {
    interface Model extends BaseModel {
        void login(String name, String pass, HttpListener listener);
        void register(String name, String pass,String verifypass, HttpListener listener);

        void sign(String name, String pass);
    }

    interface View extends BaseView {
        void loginSuccess(UserBean usersBean);
        void registerSuccess(String msg);
        void signSuccess();
        void showMsg(String  msg);
    }

    abstract class Presenter extends BasePresenter<Model, View> {
        public abstract void login(String name, String pass);
        public abstract void sign(String name, String pass);
        public abstract void register(String name, String pass,String verifypass);
        @Override
        public void onStart() {}
    }
}
