package com.brickman.app.model;

import com.brickman.app.common.base.Api;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.contract.BricksListContract;

/**
 * Created by mayu on 16/7/21,下午1:21.
 */
public class BricksListModel implements BricksListContract.Model {
    @Override
    public void loadBricksList(HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("type", "1").append("limit", "10");
        RequestHelper.sendGETRequest(true, Api.GET_BRICKSLIST, param, httpListener);
    }
}
