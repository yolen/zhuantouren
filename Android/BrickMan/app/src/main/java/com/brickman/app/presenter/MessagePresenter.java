package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.contract.MessageContract;
import com.brickman.app.model.Bean.BannerBean;
import com.brickman.app.model.Bean.MessageBean;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by zhangshiyu on 2016/11/10.
 */

public class MessagePresenter extends MessageContract.Presenter {



    @Override
    public void loadMessagekList( final int pageNO,String token) {
          mModel.loadMessageList(pageNO,  token,new HttpListener<JSONObject>() {
              @Override
              public void onSucceed(JSONObject response) {
                  if (HttpUtil.isSuccess(response)) {
                      List<MessageBean> messageBeanList=new ArrayList<MessageBean>();
                      if (response.optJSONArray("body")!=null) {
                          messageBeanList = new Gson().fromJson(response.optJSONArray("body").toString(), new TypeToken<List<MessageBean>>() {
                          }.getType());
                          mView.loadMessageSuccess(messageBeanList, false);
                      }else {
                          mView.loadMessageSuccess(messageBeanList,false);
                      }
                  } else {
                      mView.showMsg(response.optString("body"));
                      mView.loadFailed();
                  }
              }

              @Override
              public void onFailed(int what, Response response) {
                mView.loadFailed();
              }
          });
    }
}
