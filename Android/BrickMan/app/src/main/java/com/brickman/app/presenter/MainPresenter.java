package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.MainContract;
import com.brickman.app.model.Bean.BannerBean;
import com.brickman.app.model.Bean.BrickBean;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:35.
 */
public class MainPresenter extends MainContract.Presenter {

    @Override
    public void loadAD(final int type, int pageNo) {
        mModel.loadAD(type, pageNo, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if (HttpUtil.isSuccess(response)) {
                    List<BannerBean> bannerList = new Gson().fromJson(response.optJSONArray("body").toString(), new TypeToken<List<BannerBean>>(){}.getType());
                    mView.loadADSuccess(type, bannerList, false);
                } else {
                    mView.showMsg(response.optString("body"));
                    mView.loadFailed(-1);
                }
            }

            @Override
            public void onFailed(int what, Response<JSONObject> response) {
                mView.showMsg(HttpUtil.makeErrorMessage(response.getException()));
                mView.loadFailed(-1);
            }
        });
    }

    @Override
    public void loadBrickList(final int fragmentId, int pageNO) {
        mModel.loadBrickList(fragmentId, pageNO, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if (HttpUtil.isSuccess(response)) {
                    List<BrickBean> brickList = new ArrayList<BrickBean>();
                    if(response.optJSONObject("body").has("data")){
                        brickList = new Gson().fromJson(response.optJSONObject("body").optJSONArray("data").toString(), new TypeToken<List<BrickBean>>() {
                        }.getType());
                        int pageNo = response.optJSONObject("body").optJSONObject("page").optInt("pageNo");
                        int totalRecords = response.optJSONObject("body").optJSONObject("page").optInt("totalRecords");
                        boolean hasMore = totalRecords > pageNo * 10;
                        mView.loadSuccess(fragmentId, brickList, (int) Math.ceil((double) totalRecords / 10.0), hasMore);
                    } else {
                        mView.loadSuccess(fragmentId, brickList, 0, false);
                    }

                } else {
                    mView.loadFailed(fragmentId);
                    mView.showMsg(response.optString("body"));
                }
                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, Response<JSONObject> response) {
                mView.showMsg(HttpUtil.makeErrorMessage(response.getException()));
                mView.dismissLoading();
                mView.loadFailed(fragmentId);
            }
        });
    }

    @Override
    public void loadMessageRemind(String token) {
        mModel.loadMessageRemind(token, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response)  {
                try {
                    int no=response.getInt("body");
                    mView.loadMRSuccess(no);
                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }

            @Override
            public void onFailed(int what, Response<JSONObject> response) {
                   mView.showMsg("消息获取失败");
            }
        });
    }

    @Override
    public void onStart() {
        super.onStart();
    }

}
