package com.brickman.app.model;

import com.brickman.app.common.base.Api;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.contract.LoginContract;

/**
 * Created by mayu on 16/7/18,下午1:31.
 */
public class LoginModel implements LoginContract.Model {
    @Override
    public void login(String name, String pass, HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("userName", name).append("userPwd", pass);
        RequestHelper.sendPOSTRequest(false, Api.LOGIN, param, httpListener);
    }

    @Override
    public void register(String name, String pass, String verifypass, HttpListener listener) {
        RequestParam param = ParamBuilder.buildParam("userName", name).append("userPwd", pass).append("checkPassWord",verifypass);
        RequestHelper.sendPOSTRequest(false, Api.REGISTER, param, listener);
    }

    @Override
    public void sign(String name, String pass) {

    }
}
