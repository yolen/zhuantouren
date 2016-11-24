package com.brickman.app.module.main;

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
import com.brickman.app.module.brick.BrickDetailActivity;
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
    private int mPageNo = 1;
    private boolean hasMore = true;
    private boolean isFirst = true;


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
        if (mType == 0) {
            ((MainActivity) mActivity).mPresenter.loadBrickList(mType, mPageNo);
            isFirst = false;
        }
    }

    public void load() {
        if (isFirst && mType != 0) {
            ((MainActivity) mActivity).mPresenter.loadBrickList(mType, mPageNo);
            isFirst = false;
        }
    }


    @Override
    protected void initView(View view, Bundle savedInstanceState) {
        String type = getArguments().getString("type");
        switch (type) {
            case "最新发布":
                mType = 0;
                break;
            case "砖头最多":
                mType = 1;
                break;
            case "鲜花最多":
                mType = 2;
                break;
            case "评论最多":
                mType = 3;
                break;
        }
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
                        if (!hasMore) {
                            mAdapter.notifyDataChangedAfterLoadMore(false);
                            View not_loadingview = mActivity.getLayoutInflater().inflate(R.layout.loading_no_more_view, (ViewGroup) mRecyclerView.getParent(), false);
                            mAdapter.addFooterView(not_loadingview);
                            if (mPageNo > 1) {
                                mActivity.showToast("没有更多内容了");
                            }
                        } else {
                            mPageNo++;
                            ((MainActivity) mActivity).mPresenter.loadBrickList(mType, mPageNo);
                        }
                    }
                });
            }
        });
        mAdapter.openLoadMore(0, false);
//        mAdapter.setOnRecyclerViewItemClickListener(new BaseQuickAdapter.OnRecyclerViewItemClickListener() {
//            @Override
//            public void onItemClick(View view, int position) {
//                Intent intent = new Intent(mActivity, BrickDetailActivity.class);
//                intent.putExtra("item", mData.get(position));
//                mActivity.startActivityForResultWithAnim(intent, 1001);
//            }
//        });
        LinearLayoutManager layoutManager = new LinearLayoutManager(mActivity);
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
                mPageNo = 1;
                ((MainActivity) mActivity).mPresenter.loadBrickList(mType, mPageNo);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, mRecyclerView, header);
            }
        });
        mPtr.setLastUpdateTimeRelateObject(this);
    }

    public void loadSuccess(List<BrickBean> brickList, int pageSize, boolean hasMore) {
        this.hasMore = hasMore;
        if (mPtr!=null) {
            if (mPageNo == 1) {
                mPtr.refreshComplete();
                mData = brickList;
                mAdapter.setNewData(mData);
            } else {
                mAdapter.notifyDataChangedAfterLoadMore(brickList, true);
            }
        }
    }

    public void loadFailed() {
        mPtr.refreshComplete();
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

    public void reload() {
        if (!isFirst) {
            mPtr.autoRefresh();
        }
    }
}
