package com.brickman.app.module.brick;

import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.adapter.BrickListAdapter;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.utils.PhoneUtils;
import com.brickman.app.contract.PublishListContract;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.model.Bean.UserBean;
import com.brickman.app.model.PublishListModel;
import com.brickman.app.module.widget.view.CircleImageView;
import com.brickman.app.presenter.PublishListPresenter;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
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
 * 发布历史
 * Created by mayu on 16/7/22,下午1:14.
 */
public class PublishListActivity extends BaseActivity<PublishListPresenter, PublishListModel> implements PublishListContract.View {
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
    @BindView(R.id.paddingheight)
    View padingtop;

    @BindView(R.id.avator)
    CircleImageView avator;
    @BindView(R.id.name)
    TextView name;
    @BindView(R.id.desc)
    TextView desc;
    @BindView(R.id.sex)
     ImageView sex;

    private BrickListAdapter mAdapter;
    private List<BrickBean> mData = new ArrayList<BrickBean>();
    private int mPageNo = 1;
    private boolean hasMore = true;
    private String userId;
    public String userName;
    public String userAliar;
    public String userHead;
    public String userSex;
    public String motto1=null;
    public boolean isfromdetail=false;
    @Override
    protected int getLayoutId() {
        return R.layout.activity_publish_list;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mToolBar = (Toolbar) findViewById(R.id.toolbar);
        mToolBar.setTitle("");
        setSupportActionBar(mToolBar);
        mTitle.setText(getIntent().getStringExtra("title"));
        userId = getIntent().getStringExtra("userId");
        userName = getIntent().getStringExtra("userName");
        userHead = getIntent().getStringExtra("userHeader");

//        isfromdetail=getIntent().getBooleanExtra("isfromdetail",false);
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
                        if (!hasMore) {
                            mAdapter.notifyDataChangedAfterLoadMore(false);
                            View not_loadingview = getLayoutInflater().inflate(R.layout.loading_no_more_view, (ViewGroup) mRecyclerView.getParent(), false);
                            mAdapter.addFooterView(not_loadingview);
                            showToast("没有更多内容了");
                        } else {
                            mPresenter.loadBrickList(userId, mPageNo);
                        }
                    }
                });
            }
        });
        mAdapter.openLoadMore(0, false);
        if (!isfromdetail) {
            mAdapter.setOnRecyclerViewItemClickListener(new BaseQuickAdapter.OnRecyclerViewItemClickListener() {
                @Override
                public void onItemClick(View view, int position) {
                    Intent intent = new Intent(PublishListActivity.this, BrickDetailActivity.class);
                    UserBean usersBean = new UserBean();
                    usersBean.userId = userId;
                    usersBean.userName = userName;
                    usersBean.userHead = userHead;
                    BrickBean item = mData.get(position);
                    item.users = usersBean;
                    intent.putExtra("item", item);
                    intent.putExtra("isFromPublish",true);
                    startActivityWithAnim(intent);
                }
            });
        }
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
                mPageNo = 1;
                mPresenter.loadBrickList(userId, mPageNo);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, mRecyclerView, header);
            }
        });
        mPtr.setLastUpdateTimeRelateObject(this);
        mPresenter.loadBrickList(userId, mPageNo);
        setPaddingheight();

    }

    @Override
    public void loadSuccess(List<BrickBean> brickList, UserBean userBean, int pageSize, boolean hasMore) {
        this.hasMore = hasMore;
        if (mPageNo == 1) {
            userHead=userBean.userHead;
            userName=userBean.userName;
            userSex=userBean.getUserSex();
            motto1=userBean.motto;
            userAliar=userBean.userAlias;
            mTitle.setText(userAliar+"的砖集");
            initData();
            mPtr.refreshComplete();
            mData = brickList;
            mAdapter.setNewData(mData);
        } else {
            mAdapter.notifyDataChangedAfterLoadMore(brickList, true);
        }
    }

    @Override
    public void loadFailed() {
        mPtr.refreshComplete();
    }

    @Override
    public void showMsg(String msg) {
        showToast(msg);
    }

    @Override
    protected void onResume() {
        super.onResume();

    }

    /*
        设置填充状态栏高度
         */
    private void setPaddingheight(){
//        padingtop.setMinimumHeight(PhoneUtils.getStatusbarHeight(this));
        ViewGroup.LayoutParams layoutParams = padingtop.getLayoutParams();
        layoutParams.height=PhoneUtils.getStatusbarHeight(this);
        padingtop.setLayoutParams(layoutParams);

    }
    private void initData() {

            Glide.with(this).load(userHead).diskCacheStrategy(DiskCacheStrategy.ALL).into(avator);
            name.setText(TextUtils.isEmpty(userAliar)?userName:userAliar);
            if (userSex.equals("男")){
                sex.setImageResource(R.mipmap.man);
            }else {
                sex.setImageResource(R.mipmap.woman);
            }

//            name.setText(TextUtils.isEmpty(userName) ? MApplication.mAppContext.mUser.userAlias : MApplication.mAppContext.mUser.userName);
            if (motto1!=null){
                desc.setText(motto1);
            }else {
            desc.setText(TextUtils.isEmpty(MApplication.mAppContext.mUser.motto) ? "他的格言就是没有格言!!!" : MApplication.mAppContext.mUser.motto);
            }
//        logout.setText(MApplication.mAppContext.mUser != null ? "退出登录" : "点击登录");
    }
}
