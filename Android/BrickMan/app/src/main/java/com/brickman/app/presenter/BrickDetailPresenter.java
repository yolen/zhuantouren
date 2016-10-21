package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.BrickDetailContract;
import com.brickman.app.model.Bean.BrickDetailBean;
import com.brickman.app.model.Bean.CommentBean;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONObject;

import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:35.
 */
public class BrickDetailPresenter extends BrickDetailContract.Presenter {
    @Override
    public void loadDetail(int contentId) {
        mModel.loadDetail(contentId, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(HttpUtil.isSuccess(response) && response.optJSONObject("body") != null){
                    BrickDetailBean bean = new Gson().fromJson(response.optJSONObject("body").toString(), new TypeToken<BrickDetailBean>(){}.getType());
                    mView.loadDetailSuccess(bean);
                } else {
                    mView.showMsg(response.optString("body"));
                    mView.loadDetailFailed();
                }
            }

            @Override
            public void onFailed(int what, Response response) {

            }
        });
    }

    @Override
    public void loadCommentList(int pageNO, int contentId) {
        mModel.loadCommentsList(pageNO, contentId, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if (HttpUtil.isSuccess(response)) {
                    if (response.optJSONObject("body") != null) {
                        List<CommentBean> commentList = new Gson().fromJson(response.optJSONObject("body").optJSONArray("data").toString(), new TypeToken<List<CommentBean>>() {
                        }.getType());
                        int pageNo = response.optJSONObject("body").optJSONObject("page").optInt("pageNo");
                        int totalRecords = response.optJSONObject("body").optJSONObject("page").optInt("totalRecords");
                        boolean hasMore = totalRecords > pageNo * 10;
                        mView.loadSuccess(commentList, (int) Math.ceil((double) totalRecords / 10.0), hasMore);
                    }
                } else {
                    mView.showMsg(response.optString("body"));
                }
                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, Response<JSONObject> response) {
                mView.showMsg(HttpUtil.makeErrorMessage(response.getException()));
                mView.dismissLoading();
            }
        });
    }

    @Override
    public void flower(String id) {
        mModel.flower(id, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if (HttpUtil.isSuccess(response)) {
                    mView.flowerSuccess();
                } else if (response.optInt("code") == 104) {
                    mView.showMsg("您已经送过鲜花或拍砖");
                } else {
                    mView.updateState();
                    mView.showMsg(response.optString("body"));
                }
            }

            @Override
            public void onFailed(int what, Response<JSONObject> response) {
                mView.showMsg(HttpUtil.makeErrorMessage(response.getException()));
            }
        });
    }

    @Override
    public void brick(String id) {
        mModel.brick(id, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if (HttpUtil.isSuccess(response)) {
                    mView.brickSuccess();
                } else if (response.optInt("code") == 104) {
                    mView.showMsg("您已经送过鲜花或拍砖");
                } else {
                    mView.updateState();
                    mView.showMsg(response.optString("body"));
                }
            }

            @Override
            public void onFailed(int what, Response<JSONObject> response) {
                mView.showMsg(HttpUtil.makeErrorMessage(response.getException()));
            }
        });
    }

    @Override
    public void report(String id) {
        mView.showLoading();
        mModel.report(id, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if (HttpUtil.isSuccess(response)) {
                    mView.reportSuccess();
                } else if (response.optInt("code") == 104) {
                    mView.showMsg("已举报");
                } else {
                    mView.showMsg(response.optString("body"));
                }
                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, Response<JSONObject> response) {
                mView.showMsg(HttpUtil.makeErrorMessage(response.getException()));
                mView.dismissLoading();
            }
        });
    }

    @Override
    public void comment(String id, String text, String date) {
        mView.showLoading();
        mModel.comment(id, text, date, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if (HttpUtil.isSuccess(response)) {
                    mView.commentSuccess();
                } else {
                    mView.showMsg(response.optString("body"));
                }
                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, Response<JSONObject> response) {
                mView.showMsg(HttpUtil.makeErrorMessage(response.getException()));
            }
        });
    }

    @Override
    public void updateShareCount(String contentId) {
        mView.showLoading();
        mModel.updateShareCount(contentId, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(HttpUtil.isSuccess(response)){
                    mView.updateShareCountSuccess();
                }
                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, Response response) {
                mView.dismissLoading();
            }
        });
    }

    @Override
    public void onStart() {
        super.onStart();
        mView.showLoading();
    }
}
