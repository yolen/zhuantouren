package com.brickman.app.presenter;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.contract.MessageContract;
import com.yolanda.nohttp.rest.Response;

import java.util.List;

/**
 * Created by zhangshiyu on 2016/11/10.
 */

public class MessagePresenter extends MessageContract.Presenter {


    @Override
    public void loadMessagekList( final int pageNO) {
          mModel.loadMessageList(pageNO, new HttpListener<List<String>>() {
              @Override
              public void onSucceed(List<String> response) {
                  if (response==null) {
                      mView.loadMessageSuccess(response,false);
                  }else {
                      mView.loadMessageSuccess(response,true);
                  }
              }

              @Override
              public void onFailed(int what, Response response) {
                mView.loadFailed();
              }
          });
    }
}
