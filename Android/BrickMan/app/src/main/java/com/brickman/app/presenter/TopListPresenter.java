package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.contract.TopContract;
import com.brickman.app.model.Bean.TopBean;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONObject;

import java.util.List;

/**
 * Created by mayu on 16/9/5,下午3:12.
 */
public class TopListPresenter extends TopContract.Presenter {
    @Override
    public void onStart() {
        super.onStart();
    }

    @Override
    public void loadTopList(final String type) {
        mModel.loadTopList(type, new HttpListener<JSONObject>() {
            @Override
            public void onSucceed(JSONObject response) {
                if(response.optInt("error_code") == 0){
                    String jStr = response.optJSONObject("result").optJSONArray("data").toString();
                    List<TopBean> list = new Gson().fromJson(jStr, new TypeToken<List<TopBean>>(){}.getType());
                    if(list != null && list.size() > 0){
                        mView.loadTopListSuccess(type, list);
                    }
                } else {
                    mView.showMsg(response.optString("reason"));
                }
            }

            @Override
            public void onFailed(int what, Response response) {

            }
        });
    }
}
