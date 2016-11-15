package com.brickman.app.adapter;

import android.content.Context;
import android.widget.ImageView;

import com.brickman.app.R;
import com.brickman.app.model.Bean.MessageBean;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;

import java.util.List;

/**
 * Created by zhangshiyu on 2016/11/10.
 */

public class MessageListAdapter extends BaseQuickAdapter<MessageBean> {
    private Context mCtx;
    public MessageListAdapter(Context ctx,int layoutResId, List<MessageBean> data) {
        super(layoutResId, data);
        this.mCtx=mContext;

    }

    @Override
    protected void convert(BaseViewHolder baseViewHolder, MessageBean s) {
        baseViewHolder.setText(R.id.title,s.text);
        baseViewHolder.setText(R.id.content,s.text);

    }


}
