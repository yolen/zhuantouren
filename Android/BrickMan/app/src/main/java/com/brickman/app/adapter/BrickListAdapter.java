package com.brickman.app.adapter;

import com.brickman.app.model.BrickBean;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;

import java.util.List;

/**
 * Created by mayu on 16/7/20,下午2:36.
 */
public class BrickListAdapter extends BaseQuickAdapter<BrickBean> {
    public BrickListAdapter(int layoutResId, List<BrickBean> data) {
        super(layoutResId, data);
    }

    @Override
    protected void convert(BaseViewHolder helper, BrickBean item) {

    }
}
