package com.brickman.app.model;

import com.brickman.app.common.base.Api;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.contract.PublishListContract;

/**
 * Created by mayu on 16/7/21,下午1:21.
 */
public class PublishListModel implements PublishListContract.Model {
    @Override
    public void loadBrickList(String userId, int pageNo, HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("userId", userId).append("pageNo", pageNo+"");
        RequestHelper.sendGETRequest(true, Api.GET_USER_BRICKLIST, param, httpListener);
    }
}
