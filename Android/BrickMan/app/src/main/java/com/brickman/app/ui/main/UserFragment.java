package com.brickman.app.ui.main;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.base.BaseFragment;
import com.brickman.app.ui.brick.BrickListActivity;

import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/18,下午5:11.
 */
public class UserFragment extends BaseFragment {
    @Override
    protected void initView(View view, Bundle savedInstanceState) {
    }

    @Override
    protected int getLayoutId() {
        return R.layout.fragment_user;
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

    @OnClick({R.id.mybricks, R.id.mybrick, R.id.about, R.id.logout})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.mybricks:
                Intent intent = new Intent(mActivity, BrickListActivity.class);
                intent.putExtra("title", "我的砖集");
                mActivity.startActivityWithAnim(intent);
                break;
            case R.id.mybrick:
                break;
            case R.id.myflower:
                break;
            case R.id.about:
                break;
            case R.id.logout:
                break;
        }
    }
}
