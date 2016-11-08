package com.brickman.app.adapter;

import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.brickman.app.R;
import com.brickman.app.common.base.Api;
import com.brickman.app.common.utils.DensityUtils;
import com.brickman.app.model.Bean.BrickBean;
import com.brickman.app.module.brick.ImageSwitcherActivity;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;

import java.util.ArrayList;
import java.util.List;

/**
 * @author mayu
 */
public class ImagesAdapter {
    private Context mCtx;
    private LinearLayout mRootView;
    private boolean mClickble;
    private List<BrickBean.BrickContentAttachmentListBean> mImgList;
    int pos = 0;

    public ImagesAdapter(Context ctx, LinearLayout rootView, boolean clickable, List<BrickBean.BrickContentAttachmentListBean> imgList) {
        this.mCtx = ctx;
        this.mRootView = rootView;
        this.mClickble = clickable;
        this.mImgList = imgList;
    }

    public void init() {
        if (mImgList != null) {
            mRootView.removeAllViews();
            if (mImgList.size() > 0) {
                mRootView.setVisibility(View.VISIBLE);
                if (mImgList.size() % 3 == 0) {
                    int n = mImgList.size() / 3;
                    for (int i = 0; i < n; i++) {
                        LinearLayout layout = getLinearLyout(mCtx);
                        for (int j = 0; j < 3; j++) {
                            pos = (3 * i + j);
                            setimageItem(pos, layout, 3);
                        }
                        mRootView.addView(layout);
                    }
                } else if (mImgList.size() % 3 == 1) {
                    int n = mImgList.size() / 3;
                    for (int i = 0; i < n + 1; i++) {
                        LinearLayout layout = getLinearLyout(mCtx);
                        if (i == 0) {
                            pos = 0;
                            setimageItem(pos, layout, 1);
                        } else {
                            for (int j = 0; j < 3; j++) {
                                pos = (3 * i + j - 2);
                                setimageItem(pos, layout, 3);
                            }
                        }
                        mRootView.addView(layout);
                    }
                } else if (mImgList.size() % 3 == 2) {
                    int n = mImgList.size() / 3;
                    for (int i = 0; i < n + 1; i++) {
                        LinearLayout layout = getLinearLyout(mCtx);
                        if (i == 0) {
                            for (int j = 0; j < 2; j++) {
                                pos = (2 * i + j);
                                setimageItem(pos, layout, 2);
                            }
                        } else {
                            for (int j = 0; j < 3; j++) {
                                pos = (3 * i + j - 1);
                                setimageItem(pos, layout, 3);
                            }
                        }
                        mRootView.addView(layout);
                    }
                }
            } else {
                mRootView.setVisibility(View.GONE);
            }
        } else {
            mRootView.setVisibility(View.GONE);
        }
    }

    private LinearLayout getLinearLyout(Context ctx) {
        LinearLayout layout = new LinearLayout(ctx);
        layout.setOrientation(LinearLayout.HORIZONTAL);
        layout.setLayoutParams(new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT));
        return layout;
    }

    private void setimageItem(final int pos, LinearLayout parent, int n) {
        int margin = DensityUtils.dip2px(mCtx, 2);
        int w = DensityUtils.getWidth(mCtx) - DensityUtils.dip2px(mCtx, 0);
        final ImageView imageView = new ImageView(mCtx);
        imageView.setScaleType(ImageView.ScaleType.CENTER_CROP);
        imageView.setBackgroundColor(mCtx.getResources().getColor(R.color.light_gray));
        LinearLayout.LayoutParams lp = null;
        if (n == 1) {
//            if(mImgList.size() == 1){
//                imageView.setScaleType(ImageView.ScaleType.FIT_CENTER);
//                w = w - margin * 2;
//                lp = new LinearLayout.LayoutParams(w * 2 / 5, LinearLayout.LayoutParams.WRAP_CONTENT);
//            } else {
            w = w - margin * 2;
            lp = new LinearLayout.LayoutParams(w, w / 2);
//            }
        } else if (n == 2) {
            w = w - margin * 4;
            lp = new LinearLayout.LayoutParams(w / 2, w * 2 / 5);
        } else if (n == 3) {
            w = w - margin * 6;
            lp = new LinearLayout.LayoutParams(w / 3, w / 3);
        }
        lp.setMargins(margin, margin, margin, margin);
        imageView.setLayoutParams(lp);
        Glide.with(mCtx).load(Api.IMG_COMPRESS_URL + mImgList.get(pos).attachmentPath)
                .diskCacheStrategy(DiskCacheStrategy.ALL).crossFade().into(imageView);

        if (mClickble) {
            imageView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(mCtx, ImageSwitcherActivity.class);
                    intent.putExtra(ImageSwitcherActivity.INTENT_KEY_IMAGE_SOURCE_TYPE, ImageSwitcherActivity.SOURCE_TYPE_NETWORK);
                    ArrayList<String> imageList = new ArrayList<String>();
                    for (BrickBean.BrickContentAttachmentListBean item : mImgList) {
                        imageList.add(Api.IMG_URL + item.attachmentPath);
                    }
                    intent.putStringArrayListExtra(ImageSwitcherActivity.INTENT_KEY_IMAGE_LIST, imageList);
                    intent.putExtra(ImageSwitcherActivity.INTENT_KEY_POSITION, pos);
                    mCtx.startActivity(intent);
                }
            });
        }
        parent.addView(imageView);
    }
}

