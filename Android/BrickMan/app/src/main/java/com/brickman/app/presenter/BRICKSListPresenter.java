package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.BricksListContract;
import com.brickman.app.model.Bean.BricksBean;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import org.json.JSONObject;

import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:35.
 */
public class BricksListPresenter extends BricksListContract.Presenter {
    @Override
    public void loadBricksList(int pageNO) {
        mModel.loadBricksList(pageNO, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(response.optBoolean("success")){
                    List<BricksBean> brickList = new Gson().fromJson(response.optJSONArray("data").toString(), new TypeToken<List<BricksBean>>(){}.getType());
                    mView.loadSuccess(brickList, response.optInt("pageSize"), response.optBoolean("hasMore"));
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
    public void onStart() {
        super.onStart();
        mView.showLoading();
    }

}
