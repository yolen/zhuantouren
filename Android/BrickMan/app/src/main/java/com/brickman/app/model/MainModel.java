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
    public void loadAD(int type, int pageNo, HttpListener<JSONObject> httpListener) {
        RequestParam params = ParamBuilder.buildParam("advertisementType", type + "")
                .append("pageNo", pageNo + "");
        RequestHelper.sendGETRequest(true, Api.GET_BANNER, params, httpListener);
    }

    @Override
    public void loadBrickList(int type, int pageNO, HttpListener httpListener) {
        RequestParam param;
        if(type == 3){
            param = ParamBuilder.buildParam("pageNo", pageNO+"");
            RequestHelper.sendGETRequest(true, Api.GET_BRICKLIST_BY_COMMENT, param, httpListener);
        } else {
            param = ParamBuilder.buildParam("pageSize", "10").append("pageNo", pageNO+"").append("orderType", type + "");
            RequestHelper.sendGETRequest(true, Api.GET_BRICKLIST, param, httpListener);
        }
    }

    @Override
    public void loadMessageRemind(String token,HttpListener httpListener) {
        RequestParam params = ParamBuilder.buildParam("token", token );
        RequestHelper.sendGETRequest(true, Api.FLUSH_MESSAGE, params, httpListener);
    }
}
