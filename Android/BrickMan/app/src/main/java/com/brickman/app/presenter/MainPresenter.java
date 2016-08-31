package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.MainContract;
import com.brickman.app.model.Bean.BannerBean;
import com.brickman.app.model.Bean.BrickBean;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:35.
 */
public class MainPresenter extends MainContract.Presenter {

    @Override
    public void loadBanner() {
        mModel.loadBanner(new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if (response.optBoolean("success")) {
                    BannerBean bannerBean = new Gson().fromJson(response.toString(), BannerBean.class);
                    mView.loadBannerSuccess(bannerBean);
                } else {
                    mView.showMsg(response.optString("message"));
                }
            }

            @Override
            public void onFailed(int what, Response<JSONObject> response) {
                mView.showMsg(HttpUtil.makeErrorMessage(response.getException()));
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
    public void onStart() {
        super.onStart();
    }

}
