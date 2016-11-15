package com.brickman.app.model;

import android.support.annotation.NonNull;

import com.brickman.app.common.base.Api;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.contract.MessageContract;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

/**
 * Created by zhangshiyu on 2016/11/10.
 */

public class MessageListModel implements MessageContract.Model{


    @Override
    public void loadMessageList( int pageNO, String token,HttpListener httpListener) {
        RequestParam params = ParamBuilder.buildParam("token", token );
        RequestHelper.sendGETRequest(true, Api.GET_MESSSAGELIST, params, httpListener);

    }

}
