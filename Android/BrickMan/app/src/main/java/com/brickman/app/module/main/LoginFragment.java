package com.brickman.app.module.main;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.TextView;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.base.Api;
import com.brickman.app.common.base.BaseFragment;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.common.http.param.ParamBuilder;
import com.brickman.app.common.http.param.RequestParam;
import com.brickman.app.common.umeng.auth.LoginListener;
import com.brickman.app.model.Bean.UserBean;
import com.brickman.app.module.dialog.PromptDialog;
import com.google.gson.Gson;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.yolanda.nohttp.rest.Response;
import org.json.JSONObject;
import java.util.Map;
import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by zhangshiyu on 2016/11/16.
 */

public class LoginFragment extends BaseFragment {

    @BindView(R.id.username)
    EditText username;
    @BindView(R.id.password)
    EditText password;
    @BindView(R.id.forgetpwd)
    TextView forgetPwd;

    public static LoginFragment getInstance(String title) {
        LoginFragment sf = new LoginFragment();
        Bundle bundle = new Bundle();
        bundle.putString("type", title);
        sf.setArguments(bundle);
        return sf;
    }

    @Override
    protected void initView(View view, Bundle savedInstanceState) {

    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        ButterKnife.bind(this, super.onCreateView(inflater, container, savedInstanceState));
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    protected int getLayoutId() {
        return R.layout.fragment_login;
    }
    @OnClick({R.id.loginWX, R.id.loginQQ,R.id.btn_login,R.id.forgetpwd})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.close:
                ((LoginActivity)mActivity).finishWithAnim();
                break;
            case R.id.forgetpwd:
                new PromptDialog(getContext(),getResources().getString(R.string.findpwdprompt)).show();
                break;
            case R.id.loginWX:
//                mUMSdkManager.login(this, SHARE_MEDIA.WEIXIN, new LoginListener() {
//                    @Override
//                    public void success(String access_token, String openid, Map<String, Object> info) {
                //TODO ...
//                    }
//                });
                ((LoginActivity)mActivity).showToast("暂不支持微信登录!!!");
                break;
            case R.id.loginQQ:
                ((LoginActivity)mActivity).mUMSdkManager.login(((LoginActivity)mActivity), SHARE_MEDIA.QQ, new LoginListener() {
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
                                    ((LoginActivity)mActivity).sendBroadcast(new Intent(Api.ACTION_LOGIN));
                                    ((LoginActivity)mActivity).finishWithAnim();
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
            case R.id.btn_login:
                ((LoginActivity)mActivity).mPresenter.login(username.getText().toString(),password.getText().toString());
                break;
        }
    }

}
