package com.brickman.app.module.brick;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.brickman.app.R;
import com.brickman.app.adapter.TopListAdapter;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.base.BaseFragment;
import com.brickman.app.model.Bean.TopBean;
import com.brickman.app.module.main.WebActivity;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.yqritc.recyclerviewflexibledivider.HorizontalDividerItemDecoration;

import java.util.ArrayList;
import java.util.List;

import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;

/**
 * Created by mayu on 16/7/18,下午5:11.
 */
public class TopListFragment extends BaseFragment {
    private TopListAdapter mAdapter;
    private List<TopBean> mData = new ArrayList<TopBean>();

    PtrClassicFrameLayout mPtr;
    private RecyclerView mRecyclerView;
    private String mType;

    public static TopListFragment getInstance(String type) {
        TopListFragment sf = new TopListFragment();
        Bundle bundle = new Bundle();
        bundle.putString("type", type);
        sf.setArguments(bundle);
        return sf;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        ((TopActivity) mActivity).mPresenter.loadTopList(mType);
    }

    @Override
    protected void initView(View view, Bundle savedInstanceState) {
        mType = getArguments().getString("type");
        mPtr = (PtrClassicFrameLayout) view.findViewById(R.id.ptr);

        mRecyclerView = (RecyclerView) view.findViewById(R.id.list);
        mAdapter = new TopListAdapter(mActivity, mType, R.layout.item_top_list, mData);
        View loadingView = mActivity.getLayoutInflater().inflate(R.layout.loading_more_view, (ViewGroup) mRecyclerView.getParent(), false);
        mAdapter.setLoadingView(loadingView);
        mAdapter.openLoadAnimation(BaseQuickAdapter.ALPHAIN);
        mAdapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
            @Override
            public void onLoadMoreRequested() {
                mRecyclerView.post(new Runnable() {
                    @Override
                    public void run() {
                        mAdapter.notifyDataChangedAfterLoadMore(false);
                        View not_loadingview = mActivity.getLayoutInflater().inflate(R.layout.loading_no_more_view, (ViewGroup) mRecyclerView.getParent(), false);
                        mAdapter.addFooterView(not_loadingview);
                        mActivity.showToast("没有更多内容了");

                    }
                });
            }
        });
        mAdapter.openLoadMore(0, false);
        mAdapter.setOnRecyclerViewItemClickListener(new BaseQuickAdapter.OnRecyclerViewItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                Intent intent = new Intent(mActivity, WebActivity.class);
                intent.putExtra("title", "头条详情");
                intent.putExtra("url", mData.get(position).url);
                mActivity.startActivityForResultWithAnim(intent, 1001);
            }
        });
        LinearLayoutManager layoutManager = new LinearLayoutManager(mActivity);
        mRecyclerView.setLayoutManager(layoutManager);
        mRecyclerView.setAdapter(mAdapter);
        mRecyclerView.addItemDecoration(new HorizontalDividerItemDecoration.Builder(mActivity)
                .color(Color.TRANSPARENT)
                .sizeResId(R.dimen.dp_01)
                .marginResId(R.dimen.dp_00, R.dimen.dp_00)
                .build());
        mPtr.setPtrHandler(new PtrHandler() {
            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                ((TopActivity) mActivity).mPresenter.loadTopList(mType);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, mRecyclerView, header);
            }
        });
        mPtr.setLastUpdateTimeRelateObject(this);
    }

    public void loadSuccess(List<TopBean> brickList) {
        mPtr.refreshComplete();
        mData = brickList;
        mAdapter.setNewData(mData);
    }

    public void loadFailed() {
        mPtr.refreshComplete();
    }

    @Override
    protected int getLayoutId() {
        return R.layout.fragment_top_list;
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

    public void reload() {
        mPtr.autoRefresh();
    }
}
