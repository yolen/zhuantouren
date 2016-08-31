package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.LoginContract;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONObject;

/**
 * Created by mayu on 16/7/18,下午1:35.
 */
public class LoginPresenter extends LoginContract.Presenter {
    @Override
    public void login(String name, String pass) {
        mView.showLoading();
        mModel.login(name, pass, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(response.optBoolean("success")){
                    mView.loginSuccess();
                } else {
                    mView.showMsg(response.optString("Message"));
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
    public void sign(String name, String pass) {
//        mView.showMsg(HttpUtil.makeErrorMessage(e));
    }

    @Override
    public void onStart() {
        super.onStart();
    }
}
