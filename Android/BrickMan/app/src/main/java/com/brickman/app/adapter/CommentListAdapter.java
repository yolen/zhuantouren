package com.brickman.app.adapter;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.text.TextUtils;
import android.view.View;

import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.utils.DateUtil;
import com.brickman.app.model.Bean.CommentBean;
import com.brickman.app.module.brick.PublishListActivity;
import com.brickman.app.module.widget.view.CircleImageView;
import com.bumptech.glide.Glide;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;

import java.util.List;

/**
 * Created by mayu on 16/7/20,下午2:36.
 */
public class CommentListAdapter extends BaseQuickAdapter<CommentBean> {
    private BaseActivity mCtx;
    public CommentListAdapter(BaseActivity ctx, int layoutResId, List<CommentBean> data) {
        super(layoutResId, data);
        this.mCtx = ctx;
    }

    @Override
    protected void convert(BaseViewHolder helper, final CommentBean item) {
        Glide.with(mCtx).load(item.user.userHead).placeholder(R.mipmap.ic_launcher).centerCrop().crossFade().into((CircleImageView)helper.getView(R.id.avator));
         helper.setOnClickListener(R.id.avator, new View.OnClickListener() {
             @Override
             public void onClick(View v) {
                 Intent intent=new Intent(mCtx, PublishListActivity.class);
                 intent.putExtra("title",item.user.userName+"的砖集");
                 intent.putExtra("userId",item.user.userId);
                 intent.putExtra("userName",item.user.userName);
                 intent.putExtra("userHeader",item.user.userHead);
                 intent.putExtra("desc",item.user.motto);

                 mCtx.startActivityWithAnim(intent);
             }
         });
        helper.setText(R.id.date, DateUtil.getMillon(item.createdTime));
        helper.setText(R.id.nickName, TextUtils.isEmpty(item.user.userName) ? item.user.userAlias : item.user.userName);
        helper.setText(R.id.content, item.commentContent);
    }
}
