package com.brickman.app.ui.main;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.TabHost;
import android.widget.TabWidget;
import android.widget.TextView;
import android.widget.Toast;

import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.contract.MainContract;
import com.brickman.app.model.Bean.BannerBean;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.model.MainModel;
import com.brickman.app.presenter.MainPresenter;

import java.util.List;

import butterknife.BindView;

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

    private LayoutInflater mInflator;
    public TabHost mTabHost;
    public TabManager mTabManager;

    private String[] tabNames;
    private Class[] clzzs = new Class[]{HomeFragment.class, BrickFragment.class, UserFragment.class};
    private int[] tabImgs = new int[]{R.drawable.tab_home, R.drawable.tab_brick, R.drawable.tab_user};


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        tabNames = getResources().getStringArray(R.array.tabNames);
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setTitle("");
        setSupportActionBar(toolbar);
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
                }
            }
        });
        startActivityWithAnim(new Intent(this, LoginActivity.class));
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
    public void loadBannerSuccess(BannerBean bannerBean) {
        ((HomeFragment) mTabManager
                .getTab(tabNames[0]).getFragment())
                .loadBanner(bannerBean);
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
                Toast.makeText(getApplicationContext(), "再按一次退出程序", Toast.LENGTH_SHORT).show();
                exitTime = System.currentTimeMillis();
            } else {
                finish();
                System.exit(0);
            }
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }
}
