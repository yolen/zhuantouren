package com.brickman.app.module.main;

import android.Manifest;
import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v7.widget.Toolbar;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TabHost;
import android.widget.TabWidget;
import android.widget.TextView;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.base.Api;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.base.PermissionsChecker;
import com.brickman.app.common.lbs.LocationManager;
import com.brickman.app.contract.MainContract;
import com.brickman.app.model.Bean.BannerBean;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.model.MainModel;
import com.brickman.app.module.brick.TopActivity;
import com.brickman.app.module.mine.MessageActivity;
import com.brickman.app.module.mine.PublishActivity;
import com.brickman.app.module.update.UpdateChecker;
import com.brickman.app.module.widget.view.ToastManager;
import com.brickman.app.presenter.MainPresenter;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/14,上午10:00.
 */
public class MainActivity extends BaseActivity<MainPresenter, MainModel> implements MainContract.View {

    @BindView(R.id.title)
    TextView title;
    @BindView(R.id.toolbar)
    Toolbar toolbar;
    @BindView(android.R.id.tabcontent)
    FrameLayout tabcontent;
    @BindView(android.R.id.tabs)
    TabWidget tabs;
    @BindView(R.id.realtabcontent)
    FrameLayout realtabcontent;
    @BindView(android.R.id.tabhost)
    TabHost tabhost;
    @BindView(R.id.publish)
    RelativeLayout publish;
    @BindView(R.id.top)
    RelativeLayout top;
    @BindView(R.id.message)
    ImageView messageIcon;

    private LayoutInflater mInflator;
    public TabHost mTabHost;
    public TabManager mTabManager;

    private String[] tabNames;
    private Class[] clzzs = new Class[]{HomeFragment.class, MainFragment.class, UserFragment.class};
    private int[] tabImgs = new int[]{R.drawable.tab_home, R.drawable.tab_brick, R.drawable.tab_user};

    private static final int REQUEST_CODE = 0; // 请求码
    private PermissionsChecker mPermissionsChecker; // 权限检测器
    // 所需的全部权限
    static final String[] PERMISSIONS = new String[]{
            Manifest.permission.READ_EXTERNAL_STORAGE,
            Manifest.permission.WRITE_EXTERNAL_STORAGE,
            Manifest.permission.CAMERA,
            Manifest.permission.ACCESS_COARSE_LOCATION,
            Manifest.permission.ACCESS_FINE_LOCATION,
            Manifest.permission.READ_PHONE_STATE
    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        tabNames = getResources().getStringArray(R.array.tabNames);
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setTitle("");
        setSupportActionBar(toolbar);
        mPermissionsChecker = new PermissionsChecker(this);
        title.setText(tabNames[0]);
        mInflator = LayoutInflater.from(this);
        mTabHost = (TabHost) findViewById(android.R.id.tabhost);
        mTabHost.setup();
        mTabManager = new TabManager(this, mTabHost, R.id.realtabcontent);
        for (int i = 0; i < 3; i++) {
            mTabManager.addTab(mTabHost.newTabSpec(tabNames[i]).setIndicator(getIndicatorView(tabNames[i], tabImgs[i])), clzzs[i], null);
        }
        title.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (mTabManager.getCurrentTab().equals(mTabManager.getTab(tabNames[0]))) {
                    // TODO ...
                    reload();
                }
            }
        });
        // 缺少权限时, 进入权限配置页面
        if (mPermissionsChecker.lacksPermissions(PERMISSIONS)) {
            startPermissionsActivity();
        } else {
            LocationManager.init(this, new LocationManager.OnResultListener() {
                @Override
                public void getAddress(String city, String address) {
                    MApplication.setLocation(city, address);
                }
            }).startLocation();
        }

        // 自动检查更新
        UpdateChecker.checkForDialog(this, Api.APP_UPDATE_SERVER_URL, false);
    }

    @Override
    protected void onResume() {
        super.onResume();
        // 缺少权限时, 进入权限配置页面
        if (mPermissionsChecker.lacksPermissions(PERMISSIONS)) {
            startPermissionsActivity();
        }
    }

    private void startPermissionsActivity() {
        PermissionsActivity.startActivityForResult(this, REQUEST_CODE, PERMISSIONS);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        // 拒绝时, 关闭页面, 缺少主要权限, 无法运行
        if (requestCode == REQUEST_CODE) {
            if(resultCode == PermissionsActivity.PERMISSIONS_DENIED){
                finish();
            } else if(resultCode == PermissionsActivity.PERMISSIONS_GRANTED){
                LocationManager.init(this, new LocationManager.OnResultListener() {
                    @Override
                    public void getAddress(String city, String address) {
                        MApplication.setLocation(city, address);
                    }
                }).startLocation();
            }
        } else if (resultCode == RESULT_OK && requestCode == 1001) {
            // 详情返回、注释不刷新
//            ArrayList<Fragment> list = (ArrayList<Fragment>) ((HomeFragment) mTabManager.getTab(tabNames[0]).getFragment()).fragments;
//            for (Fragment fg : list) {
//                ((BrickListFragment) fg).reload();
//            }
        } else if (resultCode == RESULT_OK && requestCode == 1002) {
            // 发布返回刷新
            ArrayList<Fragment> list = (ArrayList<Fragment>) ((HomeFragment) mTabManager.getTab(tabNames[0]).getFragment()).fragments;
            ((BrickListFragment)list.get(0)).reload();
        }else if (requestCode==REQUEST_CODE&&requestCode==1003){
            // 消息返回刷新
            messageIcon.setImageResource(R.mipmap.bm_nonemessage);
        }
    }

    @Override
    public void showMsg(String msg) {
        showToast(msg);
    }

    @Override
    public void loadSuccess(int fragmentId, List<BrickBean> brickList, int pageSize, boolean hasMore) {
        ((BrickListFragment) ((HomeFragment) mTabManager
                .getTab(tabNames[0]).getFragment())
                .mAdapter.getItem(fragmentId))
                .loadSuccess(brickList, pageSize, hasMore);
    }

    @Override
    public void loadFailed(int fragmentId) {
        if (fragmentId == -1) {
            AdFragment adFragment =(AdFragment) mTabManager.getTab(tabNames[1]).getFragment();
            if(adFragment != null)
                adFragment.loadFailed();
        } else {
            ((BrickListFragment) ((HomeFragment) mTabManager
                    .getTab(tabNames[0]).getFragment())
                    .mAdapter.getItem(fragmentId))
                    .loadFailed();
        }
    }

    @Override
    public void loadADSuccess(int type, List<BannerBean> dataList, boolean hasMore) {
        if (type == 2) {
            ((HomeFragment) mTabManager
                    .getTab(tabNames[0]).getFragment())
                    .loadBanner(dataList);
        } else if (type == 3) {
            ((AdFragment) mTabManager.getTab(tabNames[1]).getFragment()).loadBanner(dataList);
        } else if (type == 4) {
            ((AdFragment) mTabManager.getTab(tabNames[1]).getFragment()).loadList(dataList, hasMore);
        }
    }

    // 设置TabBar、TabItem及样式
    private View getIndicatorView(String t, int res) {
        View v;
        if (!t.equals(tabNames[1])) {
            v = mInflator.inflate(R.layout.tab_view, null);
            ImageView tabIcon = (ImageView) v.findViewById(R.id.icon);
            TextView title = ((TextView) v.findViewById(R.id.title));
            tabIcon.setImageResource(res);
            title.setText(t);
        } else {
            v = mInflator.inflate(R.layout.tab_view2, null);
            ImageView tabIcon = (ImageView) v.findViewById(R.id.icon);
            tabIcon.setImageResource(res);
        }
        return v;
    }

    // <<<<<<<<<------------------->>>>>>>>>


    @Override
    protected int getLayoutId() {
        return R.layout.activity_main;
    }

    private long exitTime = 0;

    //重写 onKeyDown方法
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && event.getAction() == KeyEvent.ACTION_DOWN) {
            //两秒之内按返回键就会退出
            if ((System.currentTimeMillis() - exitTime) > 2000) {
                ToastManager.showWithTxt(this, "再按一次退出程序");
                exitTime = System.currentTimeMillis();
            } else {
                finish();
                System.exit(0);
            }
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }


    @OnClick({R.id.top, R.id.publish})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.top:
                startActivityWithAnim(new Intent(this, TopActivity.class));
                break;
            case R.id.publish:
                if (MApplication.mAppContext.mUser != null) {
                    startActivityForResultWithAnim(new Intent(this, MessageActivity.class),1003);
//                    startActivityForResultWithAnim();
                } else {
                    startActivityWithAnim(new Intent(this, LoginActivity.class));
                }
                break;
        }
    }
}
