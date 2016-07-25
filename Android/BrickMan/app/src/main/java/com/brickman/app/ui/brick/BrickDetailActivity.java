package com.brickman.app.ui.brick;

import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.brickman.app.R;
import com.brickman.app.adapter.CommentListAdapter;
import com.brickman.app.adapter.ImagesAdapter;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.contract.CommentsListContract;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.model.Bean.CommentBean;
import com.brickman.app.model.CommentsListModel;
import com.brickman.app.presenter.CommentsListPresenter;
import com.brickman.app.ui.widget.view.CircleImageView;
import com.bumptech.glide.Glide;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.yqritc.recyclerviewflexibledivider.HorizontalDividerItemDecoration;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;

/**
 * Created by mayu on 16/7/23,下午9:33.
 */
public class BrickDetailActivity extends BaseActivity<CommentsListPresenter, CommentsListModel> implements CommentsListContract.View {
    @BindView(R.id.toolbar)
    Toolbar toolbar;
    CircleImageView avator;
    TextView name;
    TextView dateAddress;
    ImageView report;
    TextView content;
    LinearLayout imageList;
    LinearLayout linearLayout;
    @BindView(R.id.rv)
    RecyclerView mRecyclerView;

    View headerView;
    CommentListAdapter mAdapter;
    ImagesAdapter mImagesAdapter;
    @BindView(R.id.ptr)
    PtrClassicFrameLayout ptr;
    @BindView(R.id.iconComment)
    ImageView iconComment;
    @BindView(R.id.commentNum)
    TextView commentNum;
    @BindView(R.id.iconFlower)
    ImageView iconFlower;
    @BindView(R.id.flowerNum)
    TextView flowerNum;
    @BindView(R.id.iconShare)
    ImageView iconShare;
    @BindView(R.id.shareNum)
    TextView shareNum;
    private List<CommentBean> mData;

    private int mType;
    private int mPageNo = 0;
    private int mPageSize = 4;

    private BrickBean brickBean;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_brick_detail;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setTitle("");
        setSupportActionBar(toolbar);
        brickBean = (BrickBean) getIntent().getSerializableExtra("item");
        mAdapter = new CommentListAdapter(this, R.layout.item_comment, mData);
        View loadingView = this.getLayoutInflater().inflate(R.layout.loading_more_view, (ViewGroup) mRecyclerView.getParent(), false);
        mAdapter.setLoadingView(loadingView);
        headerView = this.getLayoutInflater().inflate(R.layout.header_detail, (ViewGroup) mRecyclerView.getParent(), false);
        initView();
        mAdapter.addHeaderView(headerView);
        mAdapter.openLoadAnimation(BaseQuickAdapter.SLIDEIN_BOTTOM);
        mAdapter.setOnLoadMoreListener(new BaseQuickAdapter.RequestLoadMoreListener() {
            @Override
            public void onLoadMoreRequested() {
                mRecyclerView.post(new Runnable() {
                    @Override
                    public void run() {
                        mPageNo++;
                        if (mPageNo >= mPageSize) {
                            mAdapter.notifyDataChangedAfterLoadMore(false);
                            View not_loadingview = BrickDetailActivity.this.getLayoutInflater().inflate(R.layout.loading_no_more_view, (ViewGroup) mRecyclerView.getParent(), false);
                            mAdapter.addFooterView(not_loadingview);
                            BrickDetailActivity.this.showToast("没有更多内容了");
                        } else {
                            mPresenter.loadCommentList(mPageNo);
                        }
                    }
                });
            }
        });
        mAdapter.openLoadMore(0, false);
        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        mRecyclerView.setLayoutManager(layoutManager);
        mRecyclerView.addItemDecoration(new HorizontalDividerItemDecoration.Builder(this)
                .color(getResources().getColor(R.color.light_gray))
                .sizeResId(R.dimen.dp_01)
                .marginResId(R.dimen.dp_70, R.dimen.dp_00)
                .build());
        mRecyclerView.setAdapter(mAdapter);
        mPresenter.loadCommentList(mPageNo);

        ptr.setPtrHandler(new PtrHandler() {
            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                mPageNo = 0;
                mPresenter.loadCommentList(mPageNo);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, mRecyclerView, header);
            }
        });
        ptr.setLastUpdateTimeRelateObject(this);
    }

    private void initView() {
        avator = ButterKnife.findById(headerView, R.id.avator);
        name = ButterKnife.findById(headerView, R.id.name);
        dateAddress = ButterKnife.findById(headerView, R.id.dateAddress);
        report = ButterKnife.findById(headerView, R.id.report);
        content = ButterKnife.findById(headerView, R.id.content);
        imageList = ButterKnife.findById(headerView, R.id.imageList);

        linearLayout = (LinearLayout) ButterKnife.findById(headerView, R.id.imageList);
        Glide.with(this).load(brickBean.avator).centerCrop().crossFade().into(avator);
        name.setText(brickBean.name);
        dateAddress.setText(brickBean.date + " " + brickBean.address);
        report.setImageResource(brickBean.isReport ? R.mipmap.bm_reporting_sel : R.mipmap.bm_reporting_nor);
        content.setText(brickBean.content);
        iconComment.setImageResource(Integer.valueOf(brickBean.commentNum) > 0 ? R.mipmap.bm_comment_sel : R.mipmap.bm_comment_nor);
        commentNum.setText(brickBean.commentNum);
        iconFlower.setImageResource(Integer.valueOf(brickBean.flowerNum) > 0 ? R.mipmap.bm_flower_sel : R.mipmap.bm_flower_nor);
        flowerNum.setText(brickBean.flowerNum);
        iconShare.setImageResource(Integer.valueOf(brickBean.shareNum) > 0 ? R.mipmap.bm_share_sel : R.mipmap.bm_share_nor);
        shareNum.setText(brickBean.shareNum);

        mImagesAdapter = new ImagesAdapter(this, linearLayout, brickBean.images);
        mImagesAdapter.init();
    }

    @Override
    public void loadSuccess(List<CommentBean> brickList, int pageSize, boolean hasMore) {
        mPageSize = pageSize;
        if (mPageNo == 0) {
            ptr.refreshComplete();
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

    @OnClick(R.id.back)
    public void onClick() {
        finishWithAnim();
    }
}
