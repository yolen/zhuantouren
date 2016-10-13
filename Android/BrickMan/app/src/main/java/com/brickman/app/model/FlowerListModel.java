package com.brickman.app.model;

import com.brickman.app.common.base.Api;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.contract.FlowerListContract;

/**
 * Created by mayu on 16/7/21,下午1:21.
 */
public class FlowerListModel implements FlowerListContract.Model {
    @Override
    public void loadFlowerList(HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("type", "2").append("limit", "10");
        RequestHelper.sendPOSTRequest(true, Api.GET_FLOWERLIST, param, httpListener);
    }
}
