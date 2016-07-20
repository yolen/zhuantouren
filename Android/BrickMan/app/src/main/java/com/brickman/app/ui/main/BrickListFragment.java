package com.brickman.app.ui.main;

import android.app.Activity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ListView;

import com.brickman.app.R;
import com.brickman.app.adapter.BrickListAdapter;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.base.BaseFragment;
import com.brickman.app.model.BrickModel;

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
    private List<BrickModel> mData;

    PtrClassicFrameLayout mPtr;
    private ListView myListView;
    private String mType;


    public static BrickListFragment getInstance(String title) {
        BrickListFragment sf = new BrickListFragment();
        Bundle bundle = new Bundle();
        bundle.putString("type", title);
        sf.setArguments(bundle);
        return sf;
    }

    @Override
    protected void initView(View view, Bundle savedInstanceState) {
        mType = getArguments().getString("type", "最近发布");
        mPtr = (PtrClassicFrameLayout) view.findViewById(R.id.ptr);
        myListView = (ListView) view.findViewById(R.id.list);
        mData = new ArrayList<BrickModel>();
        int size = 10;
        if(mType.equals("最近发布")){
            size = 10;
        } else if(mType.equals("砖头最多")){
            size = 7;
        } else {
            size = 13;
        }
        for (int i = 0; i < size; i++) {
            mData.add(new BrickModel());
        }
        mAdapter = new BrickListAdapter(mActivity, R.layout.item_brick_list, mData);
        myListView.setAdapter(mAdapter);
        mPtr.setPtrHandler(new PtrHandler() {
            @Override
            public void onRefreshBegin(PtrFrameLayout frame) {
                frame.postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        mPtr.refreshComplete();
                    }
                }, 1800);
            }

            @Override
            public boolean checkCanDoRefresh(PtrFrameLayout frame, View content, View header) {
                return PtrDefaultHandler.checkContentCanBePulledDown(frame, myListView, header);
            }
        });
        mPtr.setLastUpdateTimeRelateObject(this);
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
