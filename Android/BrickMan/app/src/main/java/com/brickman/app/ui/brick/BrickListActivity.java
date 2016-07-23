package com.brickman.app.ui.brick;

import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.brickman.app.R;
import com.brickman.app.adapter.BrickListAdapter;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.contract.BrickListContract;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.model.BrickListModel;
import com.brickman.app.presenter.BrickListPresenter;
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
 * Created by mayu on 16/7/22,下午1:14.
 */
public class BrickListActivity extends BaseActivity<BrickListPresenter, BrickListModel> implements BrickListContract.View {
    @BindView(R.id.toolbar)
    Toolbar mToolBar;
    @BindView(R.id.back)
    RelativeLayout mBack;
    @BindView(R.id.title)
    TextView mTitle;
    @BindView(R.id.list)
    RecyclerView mRecyclerView;
    @BindView(R.id.ptr)
    PtrClassicFrameLayout mPtr;

    private BrickListAdapter mAdapter;
    private List<BrickBean> mData = new ArrayList<BrickBean>();
    private int mPageNo = 0;
    private int mPageSize = 4;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_brick_list;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mToolBar = (Toolbar) findViewById(R.id.toolbar);
        mToolBar.setTitle("");
        setSupportActionBar(mToolBar);
        mTitle.setText(getIntent().getStringExtra("title"));
        mBack.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                finishWithAnim();
            }
        });
        mAdapter = new BrickListAdapter(this, R.layout.item_brick_list, mData);
        View loadingView = this.getLayoutInflater().inflate(R.layout.loading_more_view, (ViewGroup) mRecyclerView.getParent(), false);
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
                            mPresenter.loadBrickList(mPageNo);
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
                .sizeResId(R.dimen.dp_06)
                .marginResId(R.dimen.dp_00, R.dimen.dp_00)
                .build());
        mPtr.setPtrHandler(new PtrHandler() {
            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                mPageNo = 0;
                mPresenter.loadBrickList(mPageNo);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, mRecyclerView, header);
            }
        });
        mPtr.setLastUpdateTimeRelateObject(this);
        mPresenter.loadBrickList(mPageNo);
    }

    @Override
    public void loadSuccess(List<BrickBean> brickList, int pageSize, boolean hasMore) {
        mPageSize = pageSize;
        if (mPageNo == 0) {
            mPtr.refreshComplete();
            mData = brickList;
            mAdapter.setNewData(mData);
        } else {
            mAdapter.notifyDataChangedAfterLoadMore(brickList, true);
        }
    }

    @Override
    public void showMsg(String msg) {
        showToast(msg);
    }
}
