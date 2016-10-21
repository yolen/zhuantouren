package com.brickman.app.model;

import com.brickman.app.common.base.Api;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.contract.TopContract;

/**
 * Created by mayu on 16/9/5,下午3:09.
 */
public class TopListModel implements TopContract.Model {
    @Override
    public void loadTopList(String type, HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("type", type)
                .append("key", "21ae61f8b3e252c58a07bb5f314c9c01");
        RequestHelper.sendGETRequest(true, Api.TOP_URL, param, httpListener);
    }
}
