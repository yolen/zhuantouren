package com.brickman.app.module.main;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.widget.ImageView;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.base.Api;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.model.Bean.BannerBean;
import com.bumptech.glide.Glide;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONObject;

import java.util.List;

import butterknife.BindView;

/**
 * 启动页
 */
public class SpalishActivity extends BaseActivity {
    @BindView(R.id.iv)
    ImageView iv;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        MApplication.mAppContext.inite();
        // 判断是否是第一次开启应用
        boolean isFirstOpen = MApplication.mDataKeeper.get(Api.FIRST_OPEN, false);
        // 如果是第一次启动，则先进入功能引导页
        if (!isFirstOpen) {
            Intent intent = new Intent(this, WelcomeGuideActivity.class);
            startActivity(intent);
            finish();
        } else {
            RequestParam params = ParamBuilder.buildParam("advertisementType", "1");
            RequestHelper.sendGETRequest(true, Api.GET_BANNER, params, new HttpListener<JSONObject>() {
                @Override
                public void onSucceed(JSONObject response) {
                    if (HttpUtil.isSuccess(response)) {
                        List<BannerBean> bannerList = new Gson().fromJson(response.optJSONArray("body").toString(), new TypeToken<List<BannerBean>>() {
                        }.getType());
                        BannerBean bannerBean = bannerList.get(0);
                        String picUrl = bannerBean.advertisementUrl;
                        Glide.with(SpalishActivity.this).load(picUrl).placeholder(R.mipmap.bm_launcher).into(iv);
                    } else {
                        showToast(response.optString("body"));
                    }
                    next();
                }

                @Override
                public void onFailed(int what, Response<JSONObject> response) {
                    showToast(HttpUtil.makeErrorMessage(response.getException()));
                    next();
                }
            });
        }


    }

    private void next(){
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {

                startActivityWithAnim(new Intent(SpalishActivity.this, MainActivity.class));
                finishWithAnim();
            }
        }, 1000);
    }

    @Override
    protected int getLayoutId() {
        isInitMVP = false;
        return R.layout.activity_spalish;
    }
}
