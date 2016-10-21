package com.brickman.app.model;

import com.brickman.app.MApplication;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.contract.PublishContract;
import com.yolanda.nohttp.OnUploadListener;

import org.json.JSONObject;

import java.util.List;

import static com.brickman.app.common.base.Api.POST_PUBLISH;
import static com.brickman.app.common.base.Api.UPLOAD_FILES;

/**
 * Created by mayu on 16/8/2,下午1:08.
 */

public class PublishModel implements PublishContract.Model {
    @Override
    public void uploadImages(List<String> imageList, OnUploadListener onUploadListener, HttpListener<JSONObject> httpListener) {
        RequestParam param = ParamBuilder.buildParam("userId", MApplication.getInstance().mUser.userId);
        RequestHelper.uploadFile(UPLOAD_FILES, param, imageList, onUploadListener, httpListener);
    }

    @Override
    public void publish(String content, String date, String address, boolean isGoodThing, String imageList, HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("userId", MApplication.getInstance().mUser.userId)
                .append("imgPaths", imageList)
                .append("contentTitle", content)
                .append("contentPlace", address);
        RequestHelper.sendPOSTRequest(false, POST_PUBLISH, param, httpListener);
    }
}
