package com.brickman.app.module.main;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.base.BaseFragment;
import com.brickman.app.module.mine.PublishActivity;

import butterknife.BindView;
import butterknife.ButterKnife;

/**
 * Created by zhangshiyu on 2016/11/10.
 */

public class MainFragment extends BaseFragment {

    @BindView(R.id.publish)
    Button publish;
    @Override
    protected void initView(View view, Bundle savedInstanceState) {
        publish.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (MApplication.mAppContext.mUser != null) {
                   mActivity.startActivityForResultWithAnim(new Intent(mActivity, PublishActivity.class), 1002);
                } else {
                    mActivity.startActivityWithAnim(new Intent(mActivity, LoginActivity.class));
                }
            }
        });
    }

    @Override
    protected int getLayoutId() {
        return R.layout.fragment_main;
    }
    @Override
    protected BaseActivity getHoldingActivity() {
        return super.getHoldingActivity();
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
    }

    @Override
    protected void addFragment(int fragmentContentId, BaseFragment fragment) {
        super.addFragment(fragmentContentId, fragment);
    }

    @Override
    protected void removeFragment() {
        super.removeFragment();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        ButterKnife.bind(this, super.onCreateView(inflater, container, savedInstanceState));
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
    }
}
