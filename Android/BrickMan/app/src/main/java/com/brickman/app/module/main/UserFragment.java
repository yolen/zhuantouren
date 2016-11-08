package com.brickman.app.module.main;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.base.Api;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.base.BaseFragment;
import com.brickman.app.common.umeng.UMSdkManager;
import com.brickman.app.common.umeng.auth.LogoutListener;
import com.brickman.app.common.utils.LogUtil;
import com.brickman.app.module.brick.PublishListActivity;
import com.brickman.app.module.mine.BricksListActivity;
import com.brickman.app.module.mine.FlowerListActivity;
import com.brickman.app.module.mine.UserInfoActivity;
import com.brickman.app.module.widget.view.CircleImageView;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.controller.UMServiceFactory;
import com.yolanda.nohttp.OnUploadListener;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/18,下午5:11.
 */
public class UserFragment extends BaseFragment {
    @BindView(R.id.avator)
    CircleImageView avator;
    @BindView(R.id.name)
    TextView name;
    @BindView(R.id.desc)
    TextView desc;
    @BindView(R.id.logout)
    Button logout;

    UMSdkManager mUMSdkManager;
    MReceiver mReceiver;

    /**
     * 文件上传监听。
     */
    private OnUploadListener mOnUploadListener = new OnUploadListener() {

        @Override
        public void onStart(int what) {// 这个文件开始上传。
//        uploadFiles.get(what).setTitle(R.string.upload_start);
//        mUploadFileAdapter.notifyItemChanged(what);
            LogUtil.debug("onStart", what + "");
        }

        @Override
        public void onCancel(int what) {// 这个文件的上传被取消时。
            LogUtil.debug("onCancel", what + "");
        }

        @Override
        public void onProgress(int what, int progress) {// 这个文件的上传进度发生边耍
            LogUtil.debug("onProgress", "第" + what + "张:" + progress + "");
        }

        @Override
        public void onFinish(int what) {// 文件上传完成
            LogUtil.debug("onFinish", what + "");
        }

        @Override
        public void onError(int what, Exception exception) {// 文件上传发生错误。
            LogUtil.error("onError", exception);
        }
    };

    @Override
    protected void initView(View view, Bundle savedInstanceState) {
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        initData();
    }

    private void initData() {
        if (MApplication.mAppContext.mUser != null) {
            Glide.with(mActivity).load(MApplication.mAppContext.mUser.userHead)
                    .diskCacheStrategy(DiskCacheStrategy.ALL).into(avator);
            name.setText(TextUtils.isEmpty(MApplication.mAppContext.mUser.userName) ? MApplication.mAppContext.mUser.userAlias : MApplication.mAppContext.mUser.userName);
            desc.setText(TextUtils.isEmpty(MApplication.mAppContext.mUser.motto) ? "他的格言就是没有格言!!!" : MApplication.mAppContext.mUser.motto);
        } else {
            Glide.with(mActivity).load(R.mipmap.ic_launcher).into(avator);
            name.setText("未登录");
            desc.setText("路见不平,拔刀相助");
        }
        logout.setText(MApplication.mAppContext.mUser != null ? "退出登录" : "点击登录");
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
        mUMSdkManager = UMSdkManager.init(mActivity, UMServiceFactory.getUMSocialService(UMSdkManager.LOGIN));
        IntentFilter filter = new IntentFilter();
        filter.addAction(Api.ACTION_LOGIN);
        filter.addAction(Api.ACTION_USERINFO);
        mReceiver = new MReceiver();
        mActivity.registerReceiver(mReceiver, filter);
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
        mActivity.unregisterReceiver(mReceiver);
    }

    @OnClick({R.id.userInfo, R.id.mybricks, R.id.mybrick, R.id.myflower, R.id.feedback,R.id.about, R.id.logout})
    public void onClick(View view) {
        Intent intent;
        switch (view.getId()) {
            case R.id.userInfo:
                if (MApplication.mAppContext.mUser != null) {
                    intent = new Intent(mActivity, UserInfoActivity.class);
                    mActivity.startActivityWithAnim(intent);
                } else {
                    intent = new Intent(mActivity, LoginActivity.class);
                    mActivity.startActivityWithAnim(intent);
                }
                break;
            case R.id.mybricks:
                if (MApplication.mAppContext.mUser != null) {
                    intent = new Intent(mActivity, PublishListActivity.class);
                    intent.putExtra("title", getResources().getString(R.string.my_bricks));
                    intent.putExtra("userId", MApplication.mAppContext.mUser.userId);
                    intent.putExtra("userName", !TextUtils.isEmpty(MApplication.mAppContext.mUser.userName) ?
                            MApplication.mAppContext.mUser.userName :
                            MApplication.mAppContext.mUser.userAlias);
                    intent.putExtra("userHeader", MApplication.mAppContext.mUser.userHead);
                    mActivity.startActivityWithAnim(intent);
                } else {
                    intent = new Intent(mActivity, LoginActivity.class);
                    mActivity.startActivityWithAnim(intent);
                }
                break;
            case R.id.mybrick:
                if (MApplication.mAppContext.mUser != null) {
                    intent = new Intent(mActivity, BricksListActivity.class);
                    mActivity.startActivityWithAnim(intent);
                } else {
                    intent = new Intent(mActivity, LoginActivity.class);
                    mActivity.startActivityWithAnim(intent);
                }
                break;
            case R.id.myflower:
                if (MApplication.mAppContext.mUser != null) {
                    intent = new Intent(mActivity, FlowerListActivity.class);
                    mActivity.startActivityWithAnim(intent);
                } else {
                    intent = new Intent(mActivity, LoginActivity.class);
                    mActivity.startActivityWithAnim(intent);
                }
                break;
            case R.id.about:
                intent = new Intent(mActivity, WebActivity.class);
                intent.putExtra("title", "关于我们");
                intent.putExtra("url", Api.ABOUT_US);
                mActivity.startActivityWithAnim(intent);
                break;
            case R.id.logout:
                if (MApplication.mAppContext.mUser != null) {
                    mUMSdkManager.logout(mActivity, SHARE_MEDIA.QQ, new LogoutListener() {
                        @Override
                        public void success() {
                            MApplication.mDataKeeper.put("user_info", null);
                            MApplication.mAppContext.mUser = null;
                            initData();
                        }
                    });
                } else {
                    intent = new Intent(mActivity, LoginActivity.class);
                    mActivity.startActivityWithAnim(intent);
                }
                break;
            case R.id.feedback:
                intent = new Intent(mActivity, WebActivity.class);
                intent.putExtra("title", "反馈我们");
                intent.putExtra("url", Api.FEEDBACK_US);
                mActivity.startActivityWithAnim(intent);
                break;
        }
    }

    class MReceiver extends BroadcastReceiver {
        @Override
        public void onReceive(Context context, Intent intent) {
            String action = intent.getAction();
            if (action.equals(Api.ACTION_LOGIN) || action.equals(Api.ACTION_USERINFO)) {
                initData();
            }
        }
    }
}
