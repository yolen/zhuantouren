package com.brickman.app.adapter;

import android.content.Context;
import android.text.TextUtils;
import android.widget.LinearLayout;

import com.brickman.app.R;
import com.brickman.app.common.utils.DateUtil;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.module.widget.view.CircleImageView;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
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
        Glide.with(mCtx).load(item.users.userHead)
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .centerCrop().into((CircleImageView)helper.getView(R.id.avator));
        helper.setText(R.id.name, TextUtils.isEmpty(item.users.userName) ? item.users.userAlias : item.users.userName);
        helper.setText(R.id.dateAddress, DateUtil.getMillon(item.createdTime) + " " + item.contentPlace);
        helper.setImageResource(R.id.report, item.contentReports != 0 ? R.mipmap.bm_reporting_sel : R.mipmap.bm_reporting_nor);
        helper.setText(R.id.content, item.contentTitle);
        helper.setImageResource(R.id.iconComment, item.commentCount > 0 ? R.mipmap.bm_comment_sel : R.mipmap.bm_comment_nor);
        helper.setText(R.id.commentNum, item.commentCount + "");

        helper.setImageResource(R.id.iconFlower, item.contentFlowors > 0 ? R.mipmap.bm_flower_sel : R.mipmap.bm_flower_nor);
        helper.setText(R.id.flowerNum, item.contentFlowors + "");

        helper.setImageResource(R.id.iconBrick, item.contentBricks > 0 ? R.mipmap.bm_brick2 : R.mipmap.bm_brick4);
        helper.setText(R.id.brickNum, item.contentBricks + "");

        helper.setImageResource(R.id.iconShare, item.contentShares > 0 ? R.mipmap.bm_share_sel : R.mipmap.bm_share_nor);
        helper.setText(R.id.shareNum, item.contentShares + "");
        LinearLayout linearLayout = (LinearLayout) helper.getView(R.id.imageList);
        linearLayout.setTag(helper.getLayoutPosition());
        mImagesAdapter = new ImagesAdapter(mCtx, linearLayout, false, item.brickContentAttachmentList);
        mImagesAdapter.init();
    }
}
