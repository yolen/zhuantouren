package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.BricksListContract;
import com.brickman.app.model.Bean.BricksBean;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:35.
 */
public class BricksListPresenter extends BricksListContract.Presenter {
    @Override
    public void loadBricksList() {
        mModel.loadBricksList(new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(HttpUtil.isSuccess(response)){
                    List<BricksBean> brickList =new ArrayList<BricksBean>();
                    if (response.optJSONArray("body")!=null) {
                            brickList = new Gson().fromJson(response.optJSONArray("body").toString(), new TypeToken<List<BricksBean>>() {
                        }.getType());
                        mView.loadSuccess(brickList);
                    }else {
                        mView.loadSuccess(brickList);
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
