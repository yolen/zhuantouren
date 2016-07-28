package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.CommentsListContract;
import com.brickman.app.model.Bean.CommentBean;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONObject;

import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:35.
 */
public class CommentsListPresenter extends CommentsListContract.Presenter {
    @Override
    public void loadCommentList(int pageNO) {
        mModel.loadCommentsList(pageNO, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(response.optBoolean("success")){
                    List<CommentBean> commentList = new Gson().fromJson(response.optJSONArray("data").toString(), new TypeToken<List<CommentBean>>(){}.getType());
                    mView.loadSuccess(commentList, response.optInt("pageSize"), response.optBoolean("hasMore"));
                } else {
                    mView.showMsg(response.optString("message"));
                }
                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, String url, Object tag, Exception exception, int responseCode, long networkMillis) {
                mView.showMsg(HttpUtil.makeErrorMessage(exception));
                mView.dismissLoading();
            }
        });
    }

    @Override
    public void flower(String id) {
        mModel.flower(id, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(response.optBoolean("success")){
                    mView.flowerSuccess();
                } else {
                    mView.showMsg(response.optString("message"));
                }
            }

            @Override
            public void onFailed(int what, String url, Object tag, Exception exception, int responseCode, long networkMillis) {
                mView.showMsg(HttpUtil.makeErrorMessage(exception));
            }
        });
    }

    @Override
    public void share(String title, String content, String url, String imgUrl) {
        mModel.share(title, content, url, imgUrl, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(response.optBoolean("success")){
                    mView.flowerSuccess();
                } else {
                    mView.showMsg(response.optString("message"));
                }
            }

            @Override
            public void onFailed(int what, String url, Object tag, Exception exception, int responseCode, long networkMillis) {
                mView.showMsg(HttpUtil.makeErrorMessage(exception));
            }
        });
    }

    @Override
    public void comment(String id, String text, String date) {
        mModel.comment(id, text, date, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(response.optBoolean("success")){
                    mView.flowerSuccess();
                } else {
                    mView.showMsg(response.optString("message"));
                }
            }

            @Override
            public void onFailed(int what, String url, Object tag, Exception exception, int responseCode, long networkMillis) {
                mView.showMsg(HttpUtil.makeErrorMessage(exception));
            }
        });
    }

    @Override
    public void onStart() {
        super.onStart();
        mView.showLoading();
    }

}