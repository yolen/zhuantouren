package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.LoginContract;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.model.Bean.FlowerBean;
import com.brickman.app.model.Bean.UserBean;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:35.
 */
public class LoginPresenter extends LoginContract.Presenter {
    @Override
    public void login(String name, String pass) {
        if (name.length()<=0){
            mView.showMsg("用户名不能为空");
        }else if (pass.length()<=0){
            mView.showMsg("密码不能为空");
        }else {
            mView.showLoading();
            mModel.login(name, pass, new HttpListener<JSONObject>() {
                @Override
                public void onSucceed(JSONObject response) {
                    try {
                        if (response.getString("code").equals("101")) {
                            UserBean usersBean = new Gson().fromJson(response.optJSONObject("body").toString(), UserBean.class);
                            mView.loginSuccess(usersBean);
                        } else  if (response.getString("code").equals("104")){
                            mView.showMsg(response.getString("body"));
                        }else {
                            mView.showMsg(response.getString("body"));
                        }
                    } catch (JSONException e) {
                        e.printStackTrace();
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
    }

    @Override
    public void sign(String name, String pass) {
//        mView.showMsg(HttpUtil.makeErrorMessage(e));
    }

    @Override
    public void register(String name, String pass, String verifypass) {
        mView.showLoading();
        mModel.register(name, pass, verifypass, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                try {
                    if (response.getString("code").equals("101")) {
                        mView.registerSuccess(response.getString("body"));
                    } else  if (response.getString("code").equals("104")){
                        mView.showMsg(response.getString("body"));
                    }else {
                        mView.showMsg(response.getString("body"));
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, Response response) {
                mView.showMsg(HttpUtil.makeErrorMessage(response.getException()));
                mView.dismissLoading();
            }
        });
    }

    @Override
    public void onStart() {
        super.onStart();
    }
}
