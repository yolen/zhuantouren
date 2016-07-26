package com.brickman.app.ui.mine;

import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;

import com.brickman.app.R;
import com.brickman.app.adapter.FlowerListAdapter;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.contract.FlowerListContract;
import com.brickman.app.model.Bean.FlowerBean;
import com.brickman.app.model.FlowerListModel;
import com.brickman.app.presenter.FlowerListPresenter;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.yqritc.recyclerviewflexibledivider.HorizontalDividerItemDecoration;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;

/**
 * Created by mayu on 16/7/22,下午3:40.
 */
public class FlowerListActivity extends BaseActivity<FlowerListPresenter, FlowerListModel> implements FlowerListContract.View {
    @BindView(R.id.back)
    RelativeLayout back;
    @BindView(R.id.toolbar)
    Toolbar mToolBar;
    @BindView(R.id.list)
    RecyclerView mRecyclerView;
    @BindView(R.id.ptr)
    PtrClassicFrameLayout mPtr;
    View headView;

    private FlowerListAdapter mAdapter;
    private List<FlowerBean> mData = new ArrayList<FlowerBean>();
    private int mPageNo = 0;
    private int mPageSize = 3;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_flower_list;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mToolBar = (Toolbar) findViewById(R.id.toolbar);
        mToolBar.setTitle("");
        back.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finishWithAnim();
            }
        });
        mAdapter = new FlowerListAdapter(this, R.layout.item_flower_list, mData);
        View loadingView = this.getLayoutInflater().inflate(R.layout.loading_more_view, (ViewGroup) mRecyclerView.getParent(), false);
        headView = this.getLayoutInflater().inflate(R.layout.header_my_flower, (ViewGroup) mRecyclerView.getParent(), false);
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
                        if (mPageNo >= mPageSize) {
                            mAdapter.notifyDataChangedAfterLoadMore(false);
                            View not_loadingview = getLayoutInflater().inflate(R.layout.loading_no_more_view, (ViewGroup) mRecyclerView.getParent(), false);
                            mAdapter.addFooterView(not_loadingview);
                            showToast("没有更多内容了");
                        } else {
                            mPresenter.loadFlowerList(mPageNo);
                        }
                    }
                });
            }
        });
        mAdapter.openLoadMore(0, false);
        mAdapter.setOnRecyclerViewItemClickListener(new BaseQuickAdapter.OnRecyclerViewItemClickListener() {
            @Override
            public void onItemClick(View view, int position) {
                showToast(Integer.toString(position));
            }
        });
        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        mRecyclerView.setLayoutManager(layoutManager);
        mRecyclerView.setAdapter(mAdapter);
        mRecyclerView.addItemDecoration(new HorizontalDividerItemDecoration.Builder(this)
                .color(Color.TRANSPARENT)
                .sizeResId(R.dimen.dp_02)
                .marginResId(R.dimen.dp_00, R.dimen.dp_00)
                .build());
        mPtr.setPtrHandler(new PtrHandler() {
            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                mPageNo = 0;
                mPresenter.loadFlowerList(mPageNo);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, mRecyclerView, header);
            }
        });
        mPtr.setLastUpdateTimeRelateObject(this);
        mPresenter.loadFlowerList(mPageNo);
    }

    @Override
    public void loadSuccess(List<FlowerBean> flowerList, int pageSize, boolean hasMore) {
        mPageSize = pageSize;
        if (mPageNo == 0) {
            mPtr.refreshComplete();
            mData = flowerList;
            mAdapter.setNewData(mData);
        } else {
            mAdapter.notifyDataChangedAfterLoadMore(flowerList, true);
        }
    }

    @Override
    public void showMsg(String msg) {
        showToast(msg);
    }
}
