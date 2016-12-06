package com.brickman.app.module.brick;

import android.content.Intent;
import android.graphics.Color;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.RequiresApi;
import android.support.design.widget.AppBarLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.adapter.BrickListAdapter;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.utils.LogUtil;
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
import com.google.android.gms.appindexing.Action;
import com.google.android.gms.appindexing.AppIndex;
import com.google.android.gms.appindexing.Thing;
import com.google.android.gms.common.api.GoogleApiClient;
import com.yqritc.recyclerviewflexibledivider.HorizontalDividerItemDecoration;

import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;
import cn.finalteam.galleryfinal.PhotoSelectActivity;
import in.srain.cube.views.ptr.PtrClassicFrameLayout;
import in.srain.cube.views.ptr.PtrDefaultHandler;
import in.srain.cube.views.ptr.PtrFrameLayout;
import in.srain.cube.views.ptr.PtrHandler;

/**
 * 发布历史
 * Created by mayu on 16/7/22,下午1:14.
 */
public class PublishListActivity extends BaseActivity<PublishListPresenter, PublishListModel> implements PublishListContract.View {

    //    @BindView(R.id.app_bar_layout)
//    AppBarLayout mAppBarLayout;
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
    @BindView(R.id.layout)
    LinearLayout layout;


    CircleImageView avator;

    TextView name;

    TextView desc;

    ImageView sex;

//     RelativeLayout headlayout;

    private BrickListAdapter mAdapter;
    private List<BrickBean> mData = new ArrayList<BrickBean>();
    private int mPageNo = 1;
    private boolean hasMore = true;
    private String userId;
    public String userName;
    public String userAliar;
    public String userHead;
    public String userSex;
    public String motto1 = null;
    public boolean isfromdetail = false;
    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */
    private GoogleApiClient client;
    private View headview;
    @Override
    protected int getLayoutId() {
        return R.layout.activity_publish_list;
    }

    @RequiresApi(api = Build.VERSION_CODES.M)
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
        headview = this.getLayoutInflater().inflate(R.layout.header_pushlishlist, (ViewGroup) mRecyclerView.getParent(), false);
        avator = ButterKnife.findById(headview, R.id.avator);
        name = ButterKnife.findById(headview, R.id.name);
        desc = ButterKnife.findById(headview, R.id.desc);
        sex = ButterKnife.findById(headview, R.id.sex);
        mAdapter.addHeaderView(headview);
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
                    intent.putExtra("isFromPublish", true);
                    startActivityWithAnim(intent);
                }
            });
        }
        final LinearLayoutManager layoutManager = new LinearLayoutManager(this);
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
        mRecyclerView.setOnScrollListener(new RecyclerView.OnScrollListener() {
            @Override
            public void onScrolled(RecyclerView recyclerView, int dx, int dy) {
                super.onScrolled(recyclerView, dx, dy);
                int firstVisibleItemPosition = layoutManager.findFirstVisibleItemPosition();
                int[] location = new int[2];
                headview.getLocationOnScreen(location);
//                #ff6633   ffffff
                int percent=Math.abs(100*(location[1])/(headview.getHeight()-layout.getHeight()));
                String value="";
                String  alphe=Integer.toHexString(0x00+(0xff*percent)/100);String y=Integer.toHexString(0xff-((0xff-0x66)*percent/100));String z=Integer.toHexString(0xff-((0xff-0x33)*percent/100));
                if (alphe.length()==1){
                    alphe="0"+alphe;
                }
                value=alphe+"ff"+y+z;
                if (firstVisibleItemPosition==0&&value.length()==8) {
                    if (percent<100) {
                        layout.setBackgroundColor(Color.parseColor("#" + value));
                    }else {
                        layout.setBackgroundColor(Color.parseColor("#ff6633"));
                    }
                }else {
                    layout.setBackgroundColor(Color.parseColor("#ff6633"));
                }

//                if (percent<=1){
//                    if (percent==0){
//                        if (firstVisibleItemPosition==0) {
//                            layout.setBackgroundColor(Color.parseColor("#" + value));
//                        }else {
//                            layout.setBackgroundColor(Color.parseColor("#ff6633"));
//                        }
//                    }else {
//
//                    }
//
//                }else {
//                    layout.setBackgroundColor(Color.parseColor("#ff6633"));
//                }
            }
        });
        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        client = new GoogleApiClient.Builder(this).addApi(AppIndex.API).build();
    }

    @Override
    public void loadSuccess(List<BrickBean> brickList, UserBean userBean, int pageSize, boolean hasMore) {
        this.hasMore = hasMore;
        if (mPageNo == 1) {
            userHead = userBean.userHead;
            userName = userBean.userName;
            userSex = userBean.getUserSex();
            motto1 = userBean.motto;
            userAliar = userBean.userAlias;
            mTitle.setText(userAliar + "的砖集");
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
    private void setPaddingheight() {
//        padingtop.setMinimumHeight(PhoneUtils.getStatusbarHeight(this));
        ViewGroup.LayoutParams layoutParams = padingtop.getLayoutParams();
        layoutParams.height = PhoneUtils.getStatusbarHeight(this);
        padingtop.setLayoutParams(layoutParams);

    }

    private void initData() {

        Glide.with(this).load(userHead).diskCacheStrategy(DiskCacheStrategy.ALL).into(avator);
        name.setText(TextUtils.isEmpty(userAliar) ? userName : userAliar);
        if (userSex.equals("男")) {
            sex.setImageResource(R.mipmap.man);
        } else {
            sex.setImageResource(R.mipmap.woman);
        }

//            name.setText(TextUtils.isEmpty(userName) ? MApplication.mAppContext.mUser.userAlias : MApplication.mAppContext.mUser.userName);
        if (motto1 != null) {
            desc.setText(motto1);
        } else {
            desc.setText(TextUtils.isEmpty(MApplication.mAppContext.mUser.motto) ? "他的格言就是没有格言!!!" : MApplication.mAppContext.mUser.motto);
        }
//        logout.setText(MApplication.mAppContext.mUser != null ? "退出登录" : "点击登录");
    }

    /**
     * ATTENTION: This was auto-generated to implement the App Indexing API.
     * See https://g.co/AppIndexing/AndroidStudio for more information.
     */
    public Action getIndexApiAction() {
        Thing object = new Thing.Builder()
                .setName("PublishList Page") // TODO: Define a title for the content shown.
                // TODO: Make sure this auto-generated URL is correct.
                .setUrl(Uri.parse("http://[ENTER-YOUR-URL-HERE]"))
                .build();
        return new Action.Builder(Action.TYPE_VIEW)
                .setObject(object)
                .setActionStatus(Action.STATUS_TYPE_COMPLETED)
                .build();
    }

    @Override
    public void onStart() {
        super.onStart();

        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        client.connect();
        AppIndex.AppIndexApi.start(client, getIndexApiAction());
    }

    @Override
    public void onStop() {
        super.onStop();

        // ATTENTION: This was auto-generated to implement the App Indexing API.
        // See https://g.co/AppIndexing/AndroidStudio for more information.
        AppIndex.AppIndexApi.end(client, getIndexApiAction());
        client.disconnect();
    }
}
