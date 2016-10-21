package com.brickman.app.module.brick;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v7.widget.Toolbar;

import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.contract.TopContract;
import com.brickman.app.model.Bean.TopBean;
import com.brickman.app.model.TopListModel;
import com.brickman.app.presenter.TopListPresenter;
import com.flyco.tablayout.SlidingTabLayout;
import com.flyco.tablayout.listener.OnTabSelectListener;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by mayu on 16/9/5,下午2:03.
 * <p/>
 * 类型:top(头条，默认),shehui(社会),guonei(国内),guoji(国际),yule(娱乐),
 * tiyu(体育)junshi(军事),keji(科技),caijing(财经),shishang(时尚)
 */
public class TopActivity extends BaseActivity<TopListPresenter, TopListModel> implements TopContract.View, OnTabSelectListener {
    private final String[] titles = {"头条", "社会", "国内", "国际", "娱乐", "体育", "军事", "科技", "财经", "时尚"};
    private final String[] types = {"top", "shehui", "guonei", "guoji", "yule", "tiyu", "junshi", "keji", "caijing", "shishang"};

    public ArrayList<Fragment> fragments = new ArrayList<>();
    @BindView(R.id.toolbar)
    Toolbar toolbar;
    @BindView(R.id.slidingTab)
    SlidingTabLayout slidingTab;
    @BindView(R.id.vp)
    ViewPager vp;

    MyPagerAdapter mAdapter;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_top;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setTitle("");
        setSupportActionBar(toolbar);

        for (String type : types) {
            fragments.add(TopListFragment.getInstance(type));
        }
        mAdapter = new MyPagerAdapter(getSupportFragmentManager());
        vp.setAdapter(mAdapter);
        vp.setOffscreenPageLimit(10);
        slidingTab.setViewPager(vp, titles);
        slidingTab.setOnTabSelectListener(this);
    }

    @Override
    public void showMsg(String msg) {
        showToast(msg);
    }

    @Override
    public void loadTopListSuccess(String type, List<TopBean> topList) {
        for (int i = 0; i < types.length; i++) {
            if (types[i].equals(type)) {
                ((TopListFragment) mAdapter.getItem(i)).loadSuccess(topList);
            }
        }
    }

    @Override
    public void onTabSelect(int position) {

    }

    @Override
    public void onTabReselect(int position) {

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

    @OnClick(R.id.back)
    public void onClick() {
        finishWithAnim();
    }
}
