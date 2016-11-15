package com.brickman.app.module.main;

import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.base.Api;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.common.umeng.UMSdkManager;
import com.brickman.app.common.umeng.auth.LoginListener;
import com.brickman.app.common.utils.PhoneUtils;
import com.brickman.app.contract.LoginContract;
import com.brickman.app.model.Bean.UserBean;
import com.brickman.app.model.LoginModel;
import com.brickman.app.presenter.LoginPresenter;
import com.google.gson.Gson;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.controller.UMServiceFactory;
import com.yolanda.nohttp.rest.Response;

import org.json.JSONObject;

import java.util.Map;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/27,上午11:18.
 */
public class LoginActivity extends BaseActivity<LoginPresenter,LoginModel> implements LoginContract.View {
    UMSdkManager mUMSdkManager;
    @BindView(R.id.username)
     EditText username;
    @BindView(R.id.password)
     EditText password;
    @BindView(R.id.padingtop)
    View padingtop;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_login;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mUMSdkManager = UMSdkManager.init(this, UMServiceFactory.getUMSocialService(UMSdkManager.LOGIN));
        setPaddingheight();
    }

    @OnClick({R.id.loginWX, R.id.loginQQ, R.id.skip,R.id.close,R.id.btn_login})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.close:
                finishWithAnim();
                break;
            case R.id.loginWX:
//                mUMSdkManager.login(this, SHARE_MEDIA.WEIXIN, new LoginListener() {
//                    @Override
//                    public void success(String access_token, String openid, Map<String, Object> info) {
                        //TODO ...
//                    }
//                });
                showToast("暂不支持微信登录!!!");
                break;
            case R.id.loginQQ:
                mUMSdkManager.login(this, SHARE_MEDIA.QQ, new LoginListener() {
                    @Override
                    public void success(String access_token, String openid, Map<String, Object> info) {
                        RequestParam params = ParamBuilder.buildParam("thirdAuth", "qq")
                                .append("accessToken", access_token).append("openId", openid);
                        RequestHelper.sendPOSTRequest(false, Api.POST_LOGIN, params, new HttpListener<JSONObject>() {
                            @Override
                            public void onSucceed(JSONObject response) {
                                if(HttpUtil.isSuccess(response)){
                                    UserBean user = new Gson().fromJson(response.optJSONObject("body").toString(), UserBean.class);
                                    MApplication.mDataKeeper.put("user_info", user);
                                    MApplication.mAppContext.mUser = user;
                                    sendBroadcast(new Intent(Api.ACTION_LOGIN));
                                    finishWithAnim();
                                }
                            }

                            @Override
                            public void onFailed(int what, Response<JSONObject> response) {

                            }
                        });
                        //TODO ...
//                        loginWithPlatfprm("wechat", info.get("openid").toString(), info.get("nickname").toString(), info.get("headimgurl").toString(), Integer.valueOf(info.get("sex").toString()) == 1 ? "male" : "female");
                    }
                });
                break;
            case R.id.skip:
                finishWithAnim();
                break;
            case R.id.btn_login:
               mPresenter.login(username.getText().toString(),password.getText().toString());
                break;
        }
    }

    @Override
    public void loginSuccess(UserBean usersBean) {


            MApplication.mDataKeeper.put("user_info", usersBean);
            MApplication.mAppContext.mUser = usersBean;
            sendBroadcast(new Intent(Api.ACTION_LOGIN));
            finishWithAnim();

    }

    @Override
    public void signSuccess() {

    }

    @Override
    public void showMsg(String msg) {
         showToast(msg);
    }
    /*
    设置填充状态栏高度
     */
    private void setPaddingheight(){
//        padingtop.setMinimumHeight(PhoneUtils.getStatusbarHeight(this));
        ViewGroup.LayoutParams layoutParams = padingtop.getLayoutParams();
        layoutParams.height= PhoneUtils.getStatusbarHeight(this);
        padingtop.setLayoutParams(layoutParams);

    }
}
