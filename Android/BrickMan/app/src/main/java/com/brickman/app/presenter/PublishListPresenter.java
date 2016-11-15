package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.PublishListContract;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.model.Bean.UserBean;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:35.
 */
public class PublishListPresenter extends PublishListContract.Presenter {
    @Override
    public void loadBrickList(String userId, int pageNO) {
        mModel.loadBrickList(userId, pageNO, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if (HttpUtil.isSuccess(response)) {
                    List<BrickBean> brickList = new ArrayList<BrickBean>();
                    UserBean userBean=null;
                    if (response.optJSONObject("body").has("user")) {
                         userBean = new Gson().fromJson(response.optJSONObject("body").optJSONObject("user").toString(), UserBean.class);
                    }
                    if(response.optJSONObject("body").has("data")){
                        brickList = new Gson().fromJson(response.optJSONObject("body").optJSONArray("data").toString(), new TypeToken<List<BrickBean>>() {
                        }.getType());
                        int pageNo = response.optJSONObject("body").optJSONObject("page").optInt("pageNo");
                        int totalRecords = response.optJSONObject("body").optJSONObject("page").optInt("totalRecords");

                        boolean hasMore = totalRecords > pageNo * 10;
                        mView.loadSuccess(brickList,userBean, (int) Math.ceil((double) totalRecords / 10.0), hasMore);
                    } else {
                        mView.loadSuccess(brickList, userBean,0, false);
                    }

                } else {
                    mView.loadFailed();
                    mView.showMsg(response.optString("body"));
                }
                mView.dismissLoading();
            }

            @Override
            public void onFailed(int what, Response<JSONObject> response) {
                mView.showMsg(HttpUtil.makeErrorMessage(response.getException()));
                mView.dismissLoading();
                mView.loadFailed();
            }
        });
    }

    @Override
    public void onStart() {
        super.onStart();
        mView.showLoading();
    }

}
