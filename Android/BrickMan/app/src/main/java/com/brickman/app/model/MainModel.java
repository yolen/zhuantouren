package com.brickman.app.model;

import com.brickman.app.common.base.Api;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.contract.MainContract;

/**
 * Created by mayu on 16/7/21,下午1:21.
 */
public class MainModel implements MainContract.Model {
    @Override
    public void loadBrickList(int pageNO, HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("pageSize", "10").append("pageNO", pageNO+"");
        RequestHelper.sendPOSTRequest(false, Api.REQUEST_BRICKLIST, param, httpListener);
    }
}
