package com.brickman.app.module.main;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.View;
import android.view.ViewGroup;
import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.base.Api;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.umeng.UMSdkManager;
import com.brickman.app.common.utils.PhoneUtils;
import com.brickman.app.contract.LoginContract;
import com.brickman.app.model.Bean.UserBean;
import com.brickman.app.model.LoginModel;
import com.brickman.app.module.widget.view.ViewPagerFixed;
import com.brickman.app.presenter.LoginPresenter;
import com.flyco.tablayout.SlidingTabLayout;
import com.flyco.tablayout.listener.OnTabSelectListener;
import com.umeng.socialize.controller.UMServiceFactory;
import java.util.ArrayList;


import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/27,上午11:18.
 */
public class LoginActivity extends BaseActivity<LoginPresenter,LoginModel> implements LoginContract.View {
    UMSdkManager mUMSdkManager;
    @BindView(R.id.padingtop)
    View padingtop;
    @BindView(R.id.slidingTab)
    SlidingTabLayout mSlidingTab;
    @BindView(R.id.vp)
    ViewPagerFixed mVp;
    MyPagerAdapter mAdapter;
    private final String[] titles = {"登录", "注册"};
    public ArrayList<Fragment> fragments = new ArrayList<>();
    private RegisterFragment registerFragment=null;
    @Override
    protected int getLayoutId() {
        return R.layout.activity_login;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mUMSdkManager = new UMSdkManager(this, UMServiceFactory.getUMSocialService(UMSdkManager.LOGIN));
        setPaddingheight();
        mAdapter = new MyPagerAdapter(getSupportFragmentManager());

        fragments.add(LoginFragment.getInstance(""));
        registerFragment=RegisterFragment.getInstance("");
        fragments.add(registerFragment);
        mVp.setAdapter(mAdapter);
        mVp.setOffscreenPageLimit(2);
        mSlidingTab.setViewPager(mVp, titles);
        mSlidingTab.setOnTabSelectListener(new OnTabSelectListener() {
            @Override
            public void onTabSelect(int position) {

            }

            @Override
            public void onTabReselect(int position) {

            }
        });
        mVp.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {

            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
    }

    @OnClick({R.id.close})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.close:
                finishWithAnim();
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
    public void registerSuccess(String msg) {
        showToast(msg);
        new Handler().postDelayed(new Runnable() {
            @Override
            public void run() {
                registerFragment.password.setText("");
                registerFragment.verifypassword.setText("");
                mVp.setCurrentItem(0);
                mSlidingTab.setCurrentTab(0);
            }
        }, 2000);

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
    public class MyPagerAdapter extends FragmentPagerAdapter {
        public MyPagerAdapter(FragmentManager fm) {
            super(fm);
        }

        @Override
        public int getCount() {
            return fragments.size();
        }

        @Override
        public CharSequence getPageTitle(int position) {
            return titles[position];
        }

        @Override
        public Fragment getItem(int position) {
            return fragments.get(position);
        }
    }
}
