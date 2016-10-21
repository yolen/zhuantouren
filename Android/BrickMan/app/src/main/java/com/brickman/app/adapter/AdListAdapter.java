package com.brickman.app.adapter;

import android.content.Context;
import android.widget.ImageView;

import com.brickman.app.R;
import com.brickman.app.model.Bean.BannerBean;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;

import java.util.List;

/**
 * Created by mayu on 16/9/2,上午9:50.
 */
public class AdListAdapter extends BaseQuickAdapter<BannerBean> {
    private Context mCtx;
    public AdListAdapter(Context ctx, int layoutResId, List<BannerBean> data) {
        super(layoutResId, data);
        this.mCtx = ctx;
    }

    @Override
    protected void convert(BaseViewHolder holder, BannerBean bannerBean) {
        if(holder.getAdapterPosition() == 1){
            holder.setVisible(R.id.title, true);
        } else {
            holder.setVisible(R.id.title, false);
        }
        Glide.with(mCtx).load(bannerBean.advertisementUrl)
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .into((ImageView) holder.getView(R.id.img));
    }
}
