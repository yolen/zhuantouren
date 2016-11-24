package com.brickman.app.module.main;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.base.BaseFragment;
import com.brickman.app.common.glide.GlideLoader;
import com.brickman.app.common.utils.LogUtil;
import com.brickman.app.model.Bean.BannerBean;
import com.brickman.app.module.widget.view.ViewPagerFixed;
import com.flyco.tablayout.SlidingTabLayout;
import com.flyco.tablayout.listener.OnTabSelectListener;
import com.youth.banner.Banner;
import com.youth.banner.BannerConfig;
import com.youth.banner.listener.OnBannerClickListener;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mayu on 16/7/18,下午5:11.
 */
public class HomeFragment extends BaseFragment implements OnTabSelectListener {

    View mRootView;
    Banner mBanner;
    SlidingTabLayout mSlidingTab;
    ViewPagerFixed mVp;
    MyPagerAdapter mAdapter;

    private final String[] titles = {"最新发布", "砖头最多", "鲜花最多", "评论最多"};
    public ArrayList<Fragment> fragments = new ArrayList<>();

    @Override
    protected void initView(View view, Bundle savedInstanceState) {
        mRootView = view;
        mBanner = (Banner) view.findViewById(R.id.banner);
        ////设置banner样式 设置指示器居中（CIRCLE_INDICATOR或者CIRCLE_INDICATOR_TITLE模式下）
        mBanner.setBannerStyle(BannerConfig.CIRCLE_INDICATOR);
        mBanner.setIndicatorGravity(BannerConfig.CENTER);
        mBanner.setImageLoader(new GlideLoader());
        //设置自动轮播，默认为true
        mBanner.isAutoPlay(true);
        //设置轮播时间
        mBanner.setDelayTime(2500);
        //设置指示器位置（当banner模式中有指示器时）
        mBanner.setIndicatorGravity(BannerConfig.CENTER);

        mSlidingTab = (SlidingTabLayout) view.findViewById(R.id.slidingTab);
        mVp = (ViewPagerFixed) view.findViewById(R.id.vp);
        for (String title : titles) {
            fragments.add(BrickListFragment.getInstance(title));
        }
        mAdapter = new MyPagerAdapter(getActivity().getSupportFragmentManager());
        mVp.setAdapter(mAdapter);
        mVp.setOffscreenPageLimit(4);
        mSlidingTab.setViewPager(mVp, titles);
        mSlidingTab.setOnTabSelectListener(this);
        ((MainActivity) mActivity).mPresenter.loadAD(2, 1);
        mVp.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                ((BrickListFragment) mAdapter.getItem(position)).load();
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
    }

    public void loadBanner(final List<BannerBean> bannerList) {
        List<String> images = new ArrayList<String>();
        for (int i = 0; i < bannerList.size(); i++) {
            images.add(bannerList.get(i).advertisementUrl);
        }
        LogUtil.info(images.size() + "--" + images.toString());
        mBanner.setImages(images);
        mBanner.setOnBannerClickListener(new OnBannerClickListener() {
            @Override
            public void OnBannerClick(int position) {
                String title = bannerList.get(position - 1).advertisementTitle;
                LogUtil.info(title);
            }
        });
        mBanner.start();
    }

    @Override
    public void onTabSelect(int position) {
//        ((BaseActivity) getActivity()).showToast(position + "");
    }

    @Override
    public void onTabReselect(int position) {
//        ((BaseActivity) getActivity()).showToast(position + "");
    }

    @Override
    protected int getLayoutId() {
        return R.layout.fragment_home;
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
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
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
