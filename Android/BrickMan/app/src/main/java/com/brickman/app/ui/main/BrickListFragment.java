package com.brickman.app.ui.main;

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
import com.brickman.app.adapter.BrickListAdapter;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.base.BaseFragment;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.ui.brick.BrickDetailActivity;
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
public class BrickListFragment extends BaseFragment {
    private BrickListAdapter mAdapter;
    private List<BrickBean> mData = new ArrayList<BrickBean>();

    PtrClassicFrameLayout mPtr;
    private RecyclerView mRecyclerView;
    private int mType;
    private int mPageNo = 0;
    private int mPageSize = 4;


    public static BrickListFragment getInstance(String title) {
        BrickListFragment sf = new BrickListFragment();
        Bundle bundle = new Bundle();
        bundle.putString("type", title);
        sf.setArguments(bundle);
        return sf;
    }

    @Override
    public void onViewCreated(View view, @Nullable Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);
        ((MainActivity)mActivity).mPresenter.loadBrickList(mType, mPageNo);
    }

    @Override
    protected void initView(View view, Bundle savedInstanceState) {
        String type = getArguments().getString("type");
        mType = type.equals("最近发布") ? 0 : type.equals("砖头最多") ? 1 : type.equals("鲜花最多") ? 2 : 0;
        mPtr = (PtrClassicFrameLayout) view.findViewById(R.id.ptr);

        mRecyclerView = (RecyclerView) view.findViewById(R.id.list);
        mAdapter = new BrickListAdapter(mActivity, R.layout.item_brick_list, mData);
        View loadingView = mActivity.getLayoutInflater().inflate(R.layout.loading_more_view, (ViewGroup) mRecyclerView.getParent(), false);
        mAdapter.setLoadingView(loadingView);
        mAdapter.openLoadAnimation(BaseQuickAdapter.SCALEIN);
        mAdapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
            @Override
            public void onLoadMoreRequested() {
                mRecyclerView.post(new Runnable() {
                    @Override
                    public void run() {
                        mPageNo++;
                        if (mPageNo >= mPageSize) {
                            mAdapter.notifyDataChangedAfterLoadMore(false);
                            View not_loadingview = mActivity.getLayoutInflater().inflate(R.layout.loading_no_more_view, (ViewGroup) mRecyclerView.getParent(), false);
                            mAdapter.addFooterView(not_loadingview);
                            mActivity.showToast("没有更多内容了");
                        } else {
                            ((MainActivity)mActivity).mPresenter.loadBrickList(mType, mPageNo);
                        }
                    }
                });
            }
        });
        mAdapter.openLoadMore(0, false);
        mAdapter.setOnRecyclerViewItemClickListener(new BaseQuickAdapter.OnRecyclerViewItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                Intent intent = new Intent(mActivity, BrickDetailActivity.class);
                intent.putExtra("item", mData.get(position));
                mActivity.startActivityWithAnim(intent);
            }
        });
        LinearLayoutManager layoutManager = new LinearLayoutManager(mActivity) ;
        mRecyclerView.setLayoutManager(layoutManager);
        mRecyclerView.setAdapter(mAdapter);
        mRecyclerView.addItemDecoration(new HorizontalDividerItemDecoration.Builder(mActivity)
                .color(Color.TRANSPARENT)
                .sizeResId(R.dimen.dp_06)
                .marginResId(R.dimen.dp_00, R.dimen.dp_00)
                .build());
        mPtr.setPtrHandler(new PtrHandler() {
            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                mPageNo = 0;
                ((MainActivity)mActivity).mPresenter.loadBrickList(mType, mPageNo);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, mRecyclerView, header);
            }
        });
        mPtr.setLastUpdateTimeRelateObject(this);
    }

    public void loadSuccess(List<BrickBean> brickList, int pageSize, boolean hasMore){
        mPageSize = pageSize;
        if(mPageNo == 0){
            mPtr.refreshComplete();
            mData = brickList;
            mAdapter.setNewData(mData);
        } else {
            mAdapter.notifyDataChangedAfterLoadMore(brickList, true);
        }
    }

    @Override
    protected int getLayoutId() {
        return R.layout.fragment_brick_list;
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
}
