package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.LoginContract;

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
            public void onFailed(int what, String url, Object tag, Exception exception, int responseCode, long networkMillis) {
                mView.dismissLoading();
                mView.showMsg(HttpUtil.makeErrorMessage(exception));
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
