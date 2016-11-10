package com.brickman.app.adapter;

import android.content.Context;
import android.widget.ImageView;

import com.brickman.app.R;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;

import java.util.List;

/**
 * Created by zhangshiyu on 2016/11/10.
 */

public class MessageListAdapter extends BaseQuickAdapter<String> {
    private Context mCtx;
    public MessageListAdapter(Context ctx,int layoutResId, List<String> data) {
        super(layoutResId, data);
        this.mCtx=mContext;

    }

    @Override
    protected void convert(BaseViewHolder baseViewHolder, String s) {
        baseViewHolder.setText(R.id.title,s);
        baseViewHolder.setText(R.id.content,s+"内容");

    }
}
