package com.brickman.app.adapter;

import android.content.Context;

import com.brickman.app.R;
import com.brickman.app.model.Bean.BricksBean;
import com.brickman.app.module.widget.view.CircleImageView;
import com.bumptech.glide.Glide;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;

import java.util.List;

/**
 * Created by mayu on 16/7/20,下午2:36.
 */
public class BricksListAdapter extends BaseQuickAdapter<BricksBean> {
    private Context mCtx;
    public BricksListAdapter(Context ctx, int layoutResId, List<BricksBean> data) {
        super(layoutResId, data);
        this.mCtx = ctx;
    }

    @Override
    protected void convert(BaseViewHolder helper, BricksBean item) {
        Glide.with(mCtx).load(item.userHead).centerCrop().crossFade().into((CircleImageView)helper.getView(R.id.avator));
        helper.setText(R.id.place, helper.getAdapterPosition()+"");
        helper.setText(R.id.nickName, item.userAlias);
        helper.setText(R.id.level, "金砖");
        helper.setText(R.id.bricksNum, item.count+"");
    }
}
