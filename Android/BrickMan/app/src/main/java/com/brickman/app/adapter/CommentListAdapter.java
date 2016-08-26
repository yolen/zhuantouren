package com.brickman.app.adapter;

import android.content.Context;
import android.text.TextUtils;

import com.brickman.app.R;
import com.brickman.app.common.utils.DateUtil;
import com.brickman.app.model.Bean.CommentBean;
import com.brickman.app.module.widget.view.CircleImageView;
import com.bumptech.glide.Glide;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;

import java.util.List;

/**
 * Created by mayu on 16/7/20,下午2:36.
 */
public class CommentListAdapter extends BaseQuickAdapter<CommentBean> {
    private Context mCtx;
    public CommentListAdapter(Context ctx, int layoutResId, List<CommentBean> data) {
        super(layoutResId, data);
        this.mCtx = ctx;
    }

    @Override
    protected void convert(BaseViewHolder helper, CommentBean item) {
        Glide.with(mCtx).load(item.user.userHead).placeholder(R.mipmap.ic_launcher).centerCrop().crossFade().into((CircleImageView)helper.getView(R.id.avator));
        helper.setText(R.id.date, DateUtil.getMillon(item.createdTime));
        helper.setText(R.id.nickName, TextUtils.isEmpty(item.user.userName) ? item.user.userAlias : item.user.userName);
        helper.setText(R.id.content, item.commentContent);
    }
}
