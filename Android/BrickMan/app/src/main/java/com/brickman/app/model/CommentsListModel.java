package com.brickman.app.model;

import com.brickman.app.MApplication;
import com.brickman.app.common.base.Api;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.contract.CommentsListContract;

/**
 * Created by mayu on 16/7/21,下午1:21.
 */
public class CommentsListModel implements CommentsListContract.Model {
    @Override
    public void loadCommentsList(int pageNo, int contentId, HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("pageSize", "10")
                .append("pageNo", pageNo + "")
                .append("orderType", "0")
                .append("contentId", contentId + "");
        RequestHelper.sendGETRequest(true, Api.GET_DETAIL_LIST, param, httpListener);
    }

    @Override
    public void comment(String id, String text, String date, HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("userId", MApplication.getInstance().mUser.userId)
                .append("contentId", id)
                .append("commentContent", text);
        RequestHelper.sendPOSTRequest(false, Api.POST_DETAIL_COMMENT, param, httpListener);
    }

    @Override
    public void flower(String id, HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("contentId", id)
                .append("userId", MApplication.getInstance().mUser.userId)
                .append("operType", "2");
        RequestHelper.sendPOSTRequest(false, Api.POST_DETAIL_DO, param, httpListener);
    }

    @Override
    public void brick(String id, HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("contentId", id)
                .append("userId", MApplication.getInstance().mUser.userId)
                .append("operType", "1");
        RequestHelper.sendPOSTRequest(false, Api.POST_DETAIL_DO, param, httpListener);
    }

    @Override
    public void report(String id, HttpListener httpListener) {
        RequestParam param = ParamBuilder.buildParam("contentId", id)
                .append("userId", MApplication.getInstance().mUser.userId)
                .append("operType", "3");
        RequestHelper.sendPOSTRequest(false, Api.POST_DETAIL_DO, param, httpListener);
    }
}
