package com.brickman.app.module.main;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;

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

public class RegisterFragment extends BaseFragment {

    @BindView(R.id.username)
    EditText username;
    @BindView(R.id.password)
    EditText password;
    @BindView(R.id.verifypassword)
    EditText verifypassword;

    public static RegisterFragment getInstance(String title) {
        RegisterFragment sf = new RegisterFragment();
        Bundle bundle = new Bundle();
        bundle.putString("type", title);
        sf.setArguments(bundle);
        return sf;
    }
    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        ButterKnife.bind(this, super.onCreateView(inflater, container, savedInstanceState));
        return super.onCreateView(inflater, container, savedInstanceState);
    }
    @Override
    protected void initView(View view, Bundle savedInstanceState) {

    }

    @Override
    protected int getLayoutId() {
        return R.layout.fragment_register;
    }

    @OnClick({R.id.btn_register})
    public void onClick(View view) {
        if (username.getText().length()<=0){
            ((LoginActivity)mActivity).showMsg("用户名不能为空");
        }else if (password.getText().length()<=0){
            ((LoginActivity)mActivity).showMsg("密码不能为空");
        }else if (verifypassword.getText().length()<=0){
            ((LoginActivity)mActivity).showMsg("确认密码不能为空");
        }else {
            ((LoginActivity) mActivity).mPresenter.register(username.getText().toString(), password.getText().toString(), verifypassword.getText().toString());
        }
    }
}
