package com.brickman.app.model;


import com.brickman.app.MApplication;
import com.brickman.app.common.base.Api;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.contract.UserInfoContract;
import com.yolanda.nohttp.OnUploadListener;

import org.json.JSONObject;

import java.util.List;

import static com.brickman.app.common.base.Api.UPLOAD_FILES;

/**
 * Created by mayu on 16/7/26,上午10:05.
 */
public class UserInfoModel implements UserInfoContract.Model {
    @Override
    public void uploadImages(List<String> imageList, OnUploadListener onUploadListener, HttpListener<JSONObject> httpListener) {
        RequestParam param = ParamBuilder.buildParam("userId", MApplication.getInstance().mUser.userId);
        RequestHelper.uploadFile(UPLOAD_FILES, param, imageList, onUploadListener, httpListener);
    }

    @Override
    public void updateAvator(String avatorUri, HttpListener<JSONObject> httpListener) {
        RequestParam params = ParamBuilder.buildParam("userId", MApplication.getInstance().mUser.userId)
                .append("userHead", avatorUri);
        RequestHelper.sendPOSTRequest(false, Api.UPDATE_USERINFO, params, httpListener);
    }

    @Override
    public void updateNickName(String nickName, HttpListener<JSONObject> httpListener) {
        RequestParam params = ParamBuilder.buildParam("userId", MApplication.getInstance().mUser.userId)
                .append("userAlias", nickName);
        RequestHelper.sendPOSTRequest(false, Api.UPDATE_USERINFO, params, httpListener);
    }

    @Override
    public void updateSexy(String sexy, HttpListener<JSONObject> httpListener) {
        RequestParam params = ParamBuilder.buildParam("userId", MApplication.getInstance().mUser.userId)
                .append("userSex", sexy);
        RequestHelper.sendPOSTRequest(false, Api.UPDATE_USERINFO, params, httpListener);
    }

    @Override
    public void updateMotto(String motto, HttpListener<JSONObject> httpListener) {
        RequestParam params = ParamBuilder.buildParam("userId", MApplication.getInstance().mUser.userId)
                .append("motto", motto);
        RequestHelper.sendPOSTRequest(false, Api.UPDATE_USERINFO, params, httpListener);
    }
}

