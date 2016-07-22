package com.brickman.app.adapter;

import android.content.Context;
import android.widget.LinearLayout;

import com.brickman.app.R;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.ui.widget.view.CircleImageView;
import com.bumptech.glide.Glide;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;

import java.util.List;

/**
 * Created by mayu on 16/7/20,下午2:36.
 */
public class BrickListAdapter extends BaseQuickAdapter<BrickBean> {
    private Context mCtx;
    private ImagesAdapter mImagesAdapter;
    public BrickListAdapter(Context ctx, int layoutResId, List<BrickBean> data) {
        super(layoutResId, data);
        this.mCtx = ctx;
    }

    @Override
    protected void convert(BaseViewHolder helper, BrickBean item) {
        Glide.with(mCtx).load(item.avator).centerCrop().crossFade().into((CircleImageView)helper.getView(R.id.avator));
        helper.setText(R.id.name, item.name);
        helper.setText(R.id.dateAddress, item.date + " " + item.address);
        helper.setImageResource(R.id.report, item.isReport ? R.mipmap.bm_reporting_sel : R.mipmap.bm_reporting_nor);
        helper.setText(R.id.content, item.content);
        helper.setImageResource(R.id.iconComment, Integer.valueOf(item.commentNum) > 0 ? R.mipmap.bm_comment_sel : R.mipmap.bm_comment_nor);
        helper.setText(R.id.commentNum, item.commentNum);
        helper.setImageResource(R.id.iconFlower, Integer.valueOf(item.flowerNum) > 0 ? R.mipmap.bm_flower_sel : R.mipmap.bm_flower_nor);
        helper.setText(R.id.flowerNum, item.flowerNum);
        helper.setImageResource(R.id.iconShare, Integer.valueOf(item.shareNum) > 0 ? R.mipmap.bm_share_sel : R.mipmap.bm_share_nor);
        helper.setText(R.id.shareNum, item.shareNum);
        LinearLayout linearLayout = (LinearLayout) helper.getView(R.id.imageList);
        linearLayout.setTag(helper.getLayoutPosition());
        mImagesAdapter = new ImagesAdapter(mCtx, linearLayout, item.images);
        mImagesAdapter.init();
    }
}
