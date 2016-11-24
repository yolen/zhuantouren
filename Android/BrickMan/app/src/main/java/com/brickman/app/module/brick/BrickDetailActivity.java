package com.brickman.app.module.brick;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.adapter.CommentListAdapter;
import com.brickman.app.adapter.ImagesAdapter;
import com.brickman.app.common.base.Api;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.umeng.ShareContent;
import com.brickman.app.common.utils.DateUtil;
import com.brickman.app.contract.BrickDetailContract;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.model.Bean.BrickDetailBean;
import com.brickman.app.model.Bean.CommentBean;
import com.brickman.app.model.BrickDetailModel;
import com.brickman.app.module.dialog.CommentDialog;
import com.brickman.app.module.dialog.ConfirmDialog;
import com.brickman.app.module.dialog.ShareDialog;
import com.brickman.app.module.main.LoginActivity;
import com.brickman.app.module.widget.view.CircleImageView;
import com.brickman.app.module.widget.view.ToastManager;
import com.brickman.app.presenter.BrickDetailPresenter;
import com.bumptech.glide.Glide;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.umeng.socialize.media.UMImage;
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
public class BrickDetailActivity extends BaseActivity<BrickDetailPresenter, BrickDetailModel> implements BrickDetailContract.View {
    @BindView(R.id.toolbar)
    Toolbar toolbar;
    CircleImageView avator;
    TextView name;
    TextView date;
    TextView address;
    ImageView report;
    TextView content;
    ImageView sexImg;
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
    @BindView(R.id.back)
    RelativeLayout back;
    @BindView(R.id.comment)
    LinearLayout comment;
    @BindView(R.id.flower)
    LinearLayout flower;
    @BindView(R.id.share)
    LinearLayout share;
    @BindView(R.id.iconBrick)
    ImageView iconBrick;
    @BindView(R.id.brickNum)
    TextView brickNum;
    private List<CommentBean> mData;

    private int mType;
    private int mPageNo = 1;
    private int mPageSize = 4;
    private boolean hasMore;

    private BrickBean brickBean;
    private BrickDetailBean brickDetailBean;

    private CommentDialog mCommentDialog;

    private boolean isOperation;

    private boolean isAllow = true;
    private boolean isFromPublish=false;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_brick_detail;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setTitle("");
        isFromPublish=getIntent().getBooleanExtra("isFromPublish",false);
        setSupportActionBar(toolbar);
        brickBean = (BrickBean) getIntent().getSerializableExtra("item");
        mAdapter = new CommentListAdapter(this,isFromPublish, R.layout.item_comment, mData);
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
                        if (!hasMore) {
                            mAdapter.notifyDataChangedAfterLoadMore(false);
                            View not_loadingview = BrickDetailActivity.this.getLayoutInflater().inflate(R.layout.loading_no_more_view, (ViewGroup) mRecyclerView.getParent(), false);
                            mAdapter.addFooterView(not_loadingview);
                            if(mPageNo > 1){
                                BrickDetailActivity.this.showToast("没有更多内容了");
                            }
                        } else {
                            mPageNo++;
                            mPresenter.loadCommentList(mPageNo, brickBean.id);
                        }
                    }
                });
            }
        });
        mAdapter.openLoadMore(0, false);
        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        mRecyclerView.setLayoutManager(layoutManager);
        mRecyclerView.addItemDecoration(new HorizontalDividerItemDecoration.Builder(this)
                .color(getResources().getColor(R.color.white))
                .sizeResId(R.dimen.dp_01)
                .marginResId(R.dimen.dp_70, R.dimen.dp_00)
                .build(), 0);
        mRecyclerView.setAdapter(mAdapter);

        ptr.setPtrHandler(new PtrHandler() {
            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                mPageNo = 1;
                mPresenter.loadDetail(brickBean.id);
                mPresenter.loadCommentList(mPageNo, brickBean.id);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, mRecyclerView, header);
            }
        });
        ptr.setLastUpdateTimeRelateObject(this);
        mPresenter.loadDetail(brickBean.id);
        mPresenter.loadCommentList(mPageNo, brickBean.id);
    }

    private void initView() {
        avator = ButterKnife.findById(headerView, R.id.avator);
        name = ButterKnife.findById(headerView, R.id.name);
        date = ButterKnife.findById(headerView, R.id.date);
        address = ButterKnife.findById(headerView, R.id.address);
        report = ButterKnife.findById(headerView, R.id.report);
        content = ButterKnife.findById(headerView, R.id.content);
        imageList = ButterKnife.findById(headerView, R.id.imageList);
        sexImg=ButterKnife.findById(headerView,R.id.sex);
        report.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (MApplication.mAppContext.mUser != null) {
                    new ConfirmDialog(BrickDetailActivity.this, "您确定要举报这位漂泊者发布的砖集吗？", new ConfirmDialog.OnConfirmListener() {
                        @Override
                        public void confirm() {
                            mPresenter.report(brickBean.id + "");
                        }
                    }).show();
                } else {
                    startActivityWithAnim(new Intent(BrickDetailActivity.this, LoginActivity.class));
                }
            }
        });
        if (!isFromPublish) {
            avator.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Intent intent = new Intent(BrickDetailActivity.this, PublishListActivity.class);
                    if (MApplication.mAppContext.mUser != null &&
                            MApplication.mAppContext.mUser.userId.equals(brickBean.users.userId)) {
                        intent.putExtra("title", getResources().getString(R.string.my_bricks));
                    } else {
                        intent.putExtra("title", !TextUtils.isEmpty(brickBean.users.userName) ? brickBean.users.userName :
                                brickBean.users.userAlias);
                    }
                    intent.putExtra("userName", !TextUtils.isEmpty(brickBean.users.userName) ? brickBean.users.userName :
                            brickBean.users.userAlias);
                    intent.putExtra("userHeader", brickBean.users.userHead);
                    intent.putExtra("userId", brickBean.userId);
                    intent.putExtra("isfromdetail", true);
                    startActivityWithAnim(intent);
                }
            });
        }
    }

    private void initData(){
        linearLayout = (LinearLayout) ButterKnife.findById(headerView, R.id.imageList);
        Glide.with(this).load(brickDetailBean.users.userHead).centerCrop().crossFade().into(avator);
        name.setText(TextUtils.isEmpty(brickDetailBean.users.userName) ? brickDetailBean.users.userAlias : brickDetailBean.users.userName);
        date.setText(DateUtil.getMillon(brickDetailBean.createdTime));
        address.setText(brickDetailBean.contentPlace);
        report.setImageResource(brickDetailBean.contentReports > 0 ? R.mipmap.bm_reporting_sel : R.mipmap.bm_reporting_nor);
        content.setText(brickDetailBean.contentTitle);
        iconComment.setImageResource(brickDetailBean.commentCount > 0 ? R.mipmap.bm_comment_sel : R.mipmap.bm_comment_nor);
        commentNum.setText(brickDetailBean.commentCount + "");
        iconFlower.setImageResource(brickDetailBean.contentFlowors > 0 ? R.mipmap.bm_flower_sel : R.mipmap.bm_flower_nor);
        flowerNum.setText(brickDetailBean.contentFlowors + "");
        iconBrick.setImageResource(brickDetailBean.contentBricks > 0 ? R.mipmap.bm_brick2 : R.mipmap.bm_brick4);
        brickNum.setText(brickDetailBean.contentBricks + "");
        iconShare.setImageResource(brickDetailBean.contentShares > 0 ? R.mipmap.bm_share_sel : R.mipmap.bm_share_nor);
        shareNum.setText(brickDetailBean.contentShares + "");

        sexImg.setImageResource( brickDetailBean.users.getUserSex().equals("男") ? R.mipmap.man : R.mipmap.woman);
        mImagesAdapter = new ImagesAdapter(this, linearLayout, true, brickDetailBean.brickContentAttachmentList);
        mImagesAdapter.init();
    }

    @Override
    public void loadDetailSuccess(BrickDetailBean brickDetailBean) {
        if(brickDetailBean != null){
            this.brickDetailBean = brickDetailBean;
//            brickDetailBean.
            if (brickBean.brickContentAttachmentList==null){

            }
            initData();
        }
    }

    @Override
    public void loadDetailFailed() {
        showMsg("砖头人，当前事件已被平台屏蔽");
    }

    @Override
    public void loadSuccess(List<CommentBean> brickList, int pageSize, boolean hasMore) {
        this.hasMore = hasMore;
        mPageSize = pageSize;
        if (mPageNo == 1) {
            ptr.refreshComplete();
            mData = brickList;
            mAdapter.setNewData(mData);
        } else {
            mAdapter.notifyDataChangedAfterLoadMore(brickList, true);
        }
    }

    @Override
    public void commentSuccess() {
        ToastManager.showWithTxt(this, "评论成功！");
        iconComment.setImageResource(R.mipmap.bm_comment_sel);
        commentNum.setText(Integer.valueOf(commentNum.getText().toString()) + 1 + "");
        mCommentDialog.clear();
        mCommentDialog.dismiss();
        ptr.autoRefresh();
        isOperation = true;
    }

    @Override
    public void brickSuccess() {
        isAllow = false;
        ToastManager.showWithImg(this, R.mipmap.bm_brick2);
        iconBrick.setImageResource(R.mipmap.bm_brick2);
        brickNum.setText(Integer.valueOf(brickNum.getText().toString()) + 1 + "");
        isOperation = true;
    }

    @Override
    public void reportSuccess() {
        ToastManager.showWithImg(this, R.mipmap.bm_reporting_sel);
        report.setImageResource(R.mipmap.bm_reporting_sel);
        isOperation = true;
    }

    @Override
    public void flowerSuccess() {
        isAllow = false;
        ToastManager.showWithImg(this, R.mipmap.bm_flower5);
        iconFlower.setImageResource(R.mipmap.bm_flower_sel);
        flowerNum.setText(Integer.valueOf(flowerNum.getText().toString()) + 1 + "");
        isOperation = true;
    }

    @Override
    public void updateState() {
        isAllow = false;
    }

    @Override
    public void updateShareCountSuccess() {
        iconShare.setImageResource(R.mipmap.bm_share_sel);
        shareNum.setText(Integer.valueOf(shareNum.getText().toString()) + 1 + "");
        isOperation = true;
    }

    @Override
    public void showMsg(String msg) {
        showToast(msg);
    }

    @OnClick({R.id.back, R.id.comment, R.id.flower, R.id.brick, R.id.share})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.back:
                finishWithAnim();
                break;
            case R.id.comment:
                if (mCommentDialog == null) {
                    mCommentDialog = new CommentDialog(this, new CommentDialog.OnSendListener() {
                        @Override
                        public void send(String comment) {
                            if (MApplication.mAppContext.mUser != null) {
                                mPresenter.comment(String.valueOf(brickBean.id), comment, System.currentTimeMillis() + "");
                            } else {
                                startActivityWithAnim(new Intent(BrickDetailActivity.this, LoginActivity.class));
                            }
                        }
                    });
                }
                mCommentDialog.show();
                break;
            case R.id.flower:
                if(isAllow){
                    if (MApplication.mAppContext.mUser != null) {
                        mPresenter.flower(brickBean.id + "");
                    } else {
                        startActivityWithAnim(new Intent(BrickDetailActivity.this, LoginActivity.class));
                    }
                } else {
                    showMsg("您已经为这条砖集表过态度了!");
                }
                break;
            case R.id.brick:
                if(isAllow){
                    if (MApplication.mAppContext.mUser != null) {
                        mPresenter.brick(brickBean.id + "");
                    } else {
                        startActivityWithAnim(new Intent(BrickDetailActivity.this, LoginActivity.class));
                    }
                } else {
                    showMsg("您已经为这条砖集表过态度了!");
                }
                break;
            case R.id.share:
                new ShareDialog(this, new ShareContent("砖头人app",
                        brickBean.contentTitle,
                        new UMImage(this, Api.IMG_COMPRESS_URL + brickBean.brickContentAttachmentList.get(0).attachmentPath),
                        Api.SHARE_BRICKMAN_PAGE + brickBean.id), new ShareDialog.OnShareListener() {
                    @Override
                    public void result(boolean result) {
                        if (result) {
                            showMsg("分享成功");
                            mPresenter.updateShareCount(brickBean.id + "");
                        }
                    }
                }).show();
                break;
        }
    }

    @OnClick(R.id.brick)
    public void onClick() {
    }

    @Override
    public void finishWithAnim() {
        setResult(isOperation ? RESULT_OK : RESULT_CANCELED);
        super.finishWithAnim();
    }

    @Override
    public void finish() {
        setResult(isOperation ? RESULT_OK : RESULT_CANCELED);
        super.finish();
    }
}
