package com.brickman.app.module.mine;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.adapter.CityAdapter;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.lbs.LocationManager;
import com.brickman.app.model.Bean.CityBean;
import com.brickman.app.module.widget.view.WaveSideBarView;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import com.yqritc.recyclerviewflexibledivider.HorizontalDividerItemDecoration;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/25,下午2:08.
 */

public class CityActivity extends BaseActivity {
    @BindView(R.id.toolbar)
    Toolbar mToolBar;
    @BindView(R.id.list)
    RecyclerView mRecyclerView;
    @BindView(R.id.side_view)
    WaveSideBarView mSideBarView;

    CityAdapter mAdapter;
    List<CityBean> list;
    @BindView(R.id.city_name)
    TextView cityName;
    @BindView(R.id.imageButton)
    ImageView imageButton;

    private LocationManager mLocationManager;

    @Override
    protected int getLayoutId() {
        isInitMVP = false;
        return R.layout.activity_city;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mToolBar = (Toolbar) findViewById(R.id.toolbar);
        mToolBar.setTitle("");
        setSupportActionBar(mToolBar);

        final PinnedHeaderDecoration decoration = new PinnedHeaderDecoration();
        decoration.registerTypePinnedHeader(1, new PinnedHeaderDecoration.PinnedHeaderCreator() {
            @Override
            public boolean create(RecyclerView parent, int adapterPosition) {
                return true;
            }
        });
        mRecyclerView.addItemDecoration(decoration);
        mRecyclerView.setLayoutManager(new LinearLayoutManager(this));
        mRecyclerView.addItemDecoration(new HorizontalDividerItemDecoration.Builder(this)
                .color(getResources().getColor(R.color.light_gray))
                .sizeResId(R.dimen.dp_005)
                .marginResId(R.dimen.dp_15, R.dimen.dp_15)
                .build());
//        headView = this.getLayoutInflater().inflate(R.layout.header_city, (ViewGroup) mRecyclerView.getParent(), false);
        new Thread(new Runnable() {
            @Override
            public void run() {
                list = new Gson().fromJson(CityBean.DATA, new TypeToken<ArrayList<CityBean>>() {
                }.getType());
                Collections.sort(list, new LetterComparator());
                for (int i = 0; i < list.size(); i++) {
                    list.get(i).setItemType(list.get(i).type);
                }
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mAdapter = new CityAdapter(list);
//                        mAdapter.addHeaderView(headView);
                        mRecyclerView.setAdapter(mAdapter);
                        mAdapter.setOnRecyclerViewItemClickListener(new BaseQuickAdapter.OnRecyclerViewItemClickListener() {
                            @Override
                            public void onItemClick(View view, int i) {
                                setResult(RESULT_OK, new Intent().putExtra("address", list.get(i).name));
                                finishWithAnim();
                            }
                        });
                    }
                });
            }
        }).start();
        cityName.setText("当前定位：" + MApplication.getAddress());
        mSideBarView.setOnTouchLetterChangeListener(new WaveSideBarView.OnTouchLetterChangeListener() {
            @Override
            public void onLetterChange(String letter) {
                int pos = mAdapter.getLetterPosition(letter);
                if (pos != -1) {
                    mRecyclerView.scrollToPosition(pos);
                }
            }
        });

        mLocationManager = LocationManager.init(this, new LocationManager.OnResultListener() {
            @Override
            public void getAddress(String city, String address) {
                MApplication.setLocation(city, address);
                cityName.setText("当前定位:" + address);
                showToast(address);
                dismissLoading();
            }
        });
        mLocationManager.startLocation();
    }


    @OnClick({R.id.back, R.id.imageButton})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.back:
                finishWithAnim();
                break;
            case R.id.imageButton:
                showLoading();
                showToast("正在定位...");
                mLocationManager.startLocation();
                break;
        }
    }
}
