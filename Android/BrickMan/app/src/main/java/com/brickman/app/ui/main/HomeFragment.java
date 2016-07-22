package com.brickman.app.ui.main;

import android.app.Activity;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentPagerAdapter;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.base.BaseFragment;
import com.brickman.app.common.utils.AssetUtil;
import com.brickman.app.model.Bean.Banner;
import com.brickman.app.ui.widget.banner.BannerEntity;
import com.brickman.app.ui.widget.banner.BannerView;
import com.brickman.app.ui.widget.banner.OnBannerClickListener;
import com.flyco.tablayout.SlidingTabLayout;
import com.flyco.tablayout.listener.OnTabSelectListener;
import com.google.gson.Gson;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by mayu on 16/7/18,下午5:11.
 */
public class HomeFragment extends BaseFragment implements OnTabSelectListener {

    View mRootView;
    BannerView mBanner;
    SlidingTabLayout mSlidingTab;
    ViewPager mVp;
    MyPagerAdapter mAdapter;

    private final String[] titles = {"最近发布", "砖头最多", "鲜花最多"};
    private ArrayList<Fragment> fragments = new ArrayList<>();

    @Override
    protected void initView(View view, Bundle savedInstanceState) {
        mRootView = view;
        mBanner = (BannerView) view.findViewById(R.id.banner);
        mSlidingTab = (SlidingTabLayout) view.findViewById(R.id.slidingTab);
        mVp = (ViewPager) view.findViewById(R.id.vp);
        for (String title : titles) {
            fragments.add(BrickListFragment.getInstance(title));
        }
        mAdapter = new MyPagerAdapter(getActivity().getSupportFragmentManager());
        mVp.setAdapter(mAdapter);
        mVp.setOffscreenPageLimit(3);
        mSlidingTab.setViewPager(mVp, titles);
        mSlidingTab.setOnTabSelectListener(this);

        Banner banner = new Gson().fromJson(AssetUtil.readAssets("banner.json"), Banner.class);

        final List<BannerEntity> entities = new ArrayList<>();
        for (int i = 0; i < banner.getRecommends().size(); i++) {
            BannerEntity entity = new BannerEntity();
            entity.imageUrl = banner.getRecommends().get(i).getThumb();
            entity.title = banner.getRecommends().get(i).getTitle();
            entities.add(entity);
        }

        mBanner.setEntities(entities);
        mBanner.setOnBannerClickListener(new OnBannerClickListener() {
            @Override
            public void onClick(int position) {
                Toast.makeText(getHoldingActivity(), position + "=> " + entities.get(position).title, Toast.LENGTH_SHORT).show();
            }
        });
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
