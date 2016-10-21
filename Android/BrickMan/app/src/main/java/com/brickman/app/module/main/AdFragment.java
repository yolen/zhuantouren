package com.brickman.app.module.main;

import android.app.Activity;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.brickman.app.R;
import com.brickman.app.adapter.AdListAdapter;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.base.BaseFragment;
import com.brickman.app.common.glide.GlideLoader;
import com.brickman.app.common.utils.LogUtil;
import com.brickman.app.model.Bean.BannerBean;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.youth.banner.Banner;
import com.youth.banner.BannerConfig;
import com.youth.banner.listener.OnBannerClickListener;
import com.yqritc.recyclerviewflexibledivider.HorizontalDividerItemDecoration;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;

/**
 * Created by mayu on 16/7/18,下午5:11.
 */
public class AdFragment extends BaseFragment {
    @BindView(R.id.list)
    RecyclerView mRecyclerView;
    @BindView(R.id.ptr)
    PtrClassicFrameLayout mPtr;
    Banner mBanner;

    View headView;
    private AdListAdapter mAdapter;
    private List<BannerBean> mData = new ArrayList<BannerBean>();
    private boolean hasMore = false;
    private int mPageNo = 1;

    @Override
    protected void initView(View view, Bundle savedInstanceState) {
        mAdapter = new AdListAdapter(mActivity, R.layout.item_ad, mData);
        View loadingView = mActivity.getLayoutInflater().inflate(R.layout.loading_more_view, (ViewGroup) mRecyclerView.getParent(), false);
        headView = mActivity.getLayoutInflater().inflate(R.layout.header_ad, (ViewGroup) mRecyclerView.getParent(), false);
        mBanner = (Banner) headView.findViewById(R.id.banner);
        //设置指示器居中（CIRCLE_INDICATOR或者CIRCLE_INDICATOR_TITLE模式下）
        mBanner.setBannerStyle(BannerConfig.CIRCLE_INDICATOR);
        mBanner.setIndicatorGravity(BannerConfig.CENTER);
        mBanner.setVisibility(View.GONE);
        mBanner.setImageLoader(new GlideLoader());
        mAdapter.addHeaderView(headView);
        mAdapter.setLoadingView(loadingView);
        mAdapter.openLoadAnimation(BaseQuickAdapter.SCALEIN);
        mAdapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
            @Override
            public void onLoadMoreRequested() {
                mRecyclerView.post(new Runnable() {
                    @Override
                    public void run() {
                        mPageNo++;
                        if (!hasMore) {
                            mAdapter.notifyDataChangedAfterLoadMore(false);
                            View not_loadingview = mActivity.getLayoutInflater().inflate(R.layout.loading_no_more_view, (ViewGroup) mRecyclerView.getParent(), false);
                            mAdapter.addFooterView(not_loadingview);
                            mActivity.showToast("没有更多内容了");
                        } else {
                            ((MainActivity) mActivity).mPresenter.loadAD(4, mPageNo);
                        }
                    }
                });
            }
        });
        mAdapter.openLoadMore(0, false);
        mAdapter.setOnRecyclerViewItemClickListener(new BaseQuickAdapter.OnRecyclerViewItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
//                mActivity.showToast(Integer.toString(position));
            }
        });
        LinearLayoutManager layoutManager = new LinearLayoutManager(mActivity);
        mRecyclerView.setLayoutManager(layoutManager);
        mRecyclerView.setAdapter(mAdapter);
        mRecyclerView.addItemDecoration(new HorizontalDividerItemDecoration.Builder(mActivity)
                .color(Color.TRANSPARENT)
                .sizeResId(R.dimen.dp_10)
                .marginResId(R.dimen.dp_00, R.dimen.dp_00)
                .build());

        mPtr.setPtrHandler(new PtrHandler() {
            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                mPageNo = 1;
                ((MainActivity)mActivity).mPresenter.loadAD(4, mPageNo);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, mRecyclerView, header);
            }
        });
        mPtr.setLastUpdateTimeRelateObject(this);
        // 中间上部广告
        ((MainActivity)mActivity).mPresenter.loadAD(3, 1);
        // 中间下部广告
        ((MainActivity)mActivity).mPresenter.loadAD(4, mPageNo);
    }

    public void loadBanner(final List<BannerBean> bannerList){
        ArrayList<String> images = new ArrayList<String>();
        for (int i = 0; i < bannerList.size(); i++) {
            images.add(bannerList.get(i).advertisementUrl);
        }
        mBanner.setImages(images);
        mBanner.setOnBannerClickListener(new OnBannerClickListener() {
            @Override
            public void OnBannerClick(int position) {
                String title = bannerList.get(position - 1).advertisementTitle;
                LogUtil.info(title);
            }
        });
        mBanner.startAutoPlay();
    }

    public void loadList(List<BannerBean> bannerList, boolean hasMore){
        this.hasMore = hasMore;
        if (mPageNo == 1) {
            mPtr.refreshComplete();
            mData = bannerList;
            mAdapter.setNewData(mData);
        } else {
            mAdapter.notifyDataChangedAfterLoadMore(bannerList, true);
        }
    }

    public void loadFailed(){
        if(mPtr != null)
            mPtr.refreshComplete();
    }

    @Override
    protected int getLayoutId() {
        return R.layout.fragment_brick;
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
