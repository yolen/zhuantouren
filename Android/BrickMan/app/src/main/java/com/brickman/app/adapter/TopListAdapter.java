package com.brickman.app.adapter;

import android.content.Context;
import android.widget.ImageView;

import com.brickman.app.R;
import com.brickman.app.model.Bean.TopBean;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;

import java.util.List;

/**
 * Created by mayu on 16/7/20,下午2:36.
 */
public class TopListAdapter extends BaseQuickAdapter<TopBean> {
    private Context mCtx;
    private String mType;

    public TopListAdapter(Context ctx, String type, int layoutResId, List<TopBean> data) {
        super(layoutResId, data);
        this.mCtx = ctx;
        this.mType = type;
    }

    @Override
    protected void convert(BaseViewHolder helper, TopBean item) {
        Glide.with(mCtx).load(item.thumbnail_pic_s)
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .centerCrop().into((ImageView) helper.getView(R.id.img));
        helper.setText(R.id.title, item.title);
        helper.setText(R.id.author, item.author_name);
        helper.setText(R.id.date, item.date);
        if(mType.equals("top")){
            helper.setText(R.id.type, "•" + item.realtype + "•");
        } else {
            helper.setText(R.id.type, "");
        }
    }
}
