package com.brickman.app.model;

import com.brickman.app.common.base.Api;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.contract.MainContract;

import org.json.JSONObject;

/**
 * Created by mayu on 16/7/21,下午1:21.
 */
public class MainModel implements MainContract.Model {

    @Override
    public void loadBanner(HttpListener<JSONObject> httpListener) {
        RequestHelper.sendGETRequest(true, Api.REQUEST_BANNER, null, httpListener);
    }

    @Override
    public void loadBrickList(int type, int pageNO, HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("pageSize", "10").append("pageNo", pageNO+"").append("orderType", type + "");
        RequestHelper.sendGETRequest(true, Api.REQUEST_BRICKLIST, param, httpListener);
    }
}
