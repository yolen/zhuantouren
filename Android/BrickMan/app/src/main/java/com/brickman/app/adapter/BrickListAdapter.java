package com.brickman.app.adapter;

import android.content.Context;

import com.brickman.app.model.BrickModel;
import com.joanzapata.android.BaseAdapterHelper;
import com.joanzapata.android.QuickAdapter;

import java.util.List;

/**
 * Created by mayu on 16/7/20,下午2:36.
 */
public class BrickListAdapter extends QuickAdapter<BrickModel> {
    public BrickListAdapter(Context context, int layoutResId, List<BrickModel> data) {
        super(context, layoutResId, data);
    }

    @Override
    protected void convert(BaseAdapterHelper helper, BrickModel item) {

    }
}
