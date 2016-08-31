package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.FlowerListContract;
import com.brickman.app.model.Bean.FlowerBean;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONObject;

import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:35.
 */
public class FlowerListPresenter extends FlowerListContract.Presenter {
    @Override
    public void loadFlowerList() {
        mModel.loadFlowerList(new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(HttpUtil.isSuccess(response)){
                    List<FlowerBean> brickList = new Gson().fromJson(response.optJSONArray("body").toString(), new TypeToken<List<FlowerBean>>(){}.getType());
                    mView.loadSuccess(brickList);
                } else {
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
