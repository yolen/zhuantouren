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
        RequestParam param = ParamBuilder.buildParam("name", name).append("pwd", pass);
        RequestHelper.sendPOSTRequest(false, Api.BASE_URL, param, httpListener);
    }

    @Override
    public void sign(String name, String pass) {

    }
}
