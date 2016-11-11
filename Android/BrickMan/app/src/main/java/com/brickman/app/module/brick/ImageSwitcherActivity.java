package com.brickman.app.module.brick;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout.LayoutParams;

import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.http.HttpUtil;
import com.brickman.app.common.http.RequestHelper;
import com.brickman.app.module.dialog.ConfirmDialog;
import com.brickman.app.module.widget.view.TouchImageView;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;
import com.yolanda.nohttp.Headers;
import com.yolanda.nohttp.download.DownloadListener;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

public class ImageSwitcherActivity extends BaseActivity {

    // 图片来源类型
    public static final String INTENT_KEY_IMAGE_SOURCE_TYPE = "source_type";
    // 图片路径
    public final static String INTENT_KEY_IMAGE_LIST = "image_path_list";
    // 点击图片的位置
    public final static String INTENT_KEY_POSITION = "position";
    // 图片来源类型 -- 本地文件
    public static final String SOURCE_TYPE_LOCAL_FILE = "local_file";
    // 图片来源类型 -- 网络图片
    public static final String SOURCE_TYPE_NETWORK = "network";

    private ArrayList<String> mImageList;
    private String mSourceType;
    private int mInitPosition;

    private ViewPager mViewPager;
    private ViewPagerAdapter mAdapter;
    private LinearLayout mLayoutIndicator;
    private List<ImageView> mIndicators;

    @Override
    protected int getLayoutId() {
        isInitMVP = false;
        return R.layout.activity_image_switcher;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mSourceType = getIntent().getStringExtra(INTENT_KEY_IMAGE_SOURCE_TYPE);
        mImageList = getIntent().getStringArrayListExtra(INTENT_KEY_IMAGE_LIST);
        mInitPosition = getIntent().getIntExtra(INTENT_KEY_POSITION, 0);

        mLayoutIndicator = (LinearLayout) findViewById(R.id.layout_indicator);
        mIndicators = new ArrayList<ImageView>();
        mViewPager = (ViewPager) findViewById(R.id.viewpager);
        mAdapter = new ViewPagerAdapter();
        mViewPager.setAdapter(mAdapter);
        mViewPager.setCurrentItem(mInitPosition);
        initIndicator();
        setIndicator();
        findViewById(R.id.btn_back).setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        mViewPager.setOnPageChangeListener(new OnPageChangeListener() {

            @Override
            public void onPageSelected(int index) {
                setIndicator();
            }

            @Override
            public void onPageScrolled(int arg0, float arg1, int arg2) {

            }

            @Override
            public void onPageScrollStateChanged(int arg0) {

            }
        });

        findViewById(R.id.save).setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                new ConfirmDialog(ImageSwitcherActivity.this, "保存图片", new ConfirmDialog.OnConfirmListener() {
                    @Override
                    public void confirm() {
                        RequestHelper.downloadFile(mImageList.get(mViewPager.getCurrentItem()), new DownloadListener() {
                            @Override
                            public void onDownloadError(int what, Exception exception) {
                                showToast(HttpUtil.makeErrorMessage(exception));
                            }

                            @Override
                            public void onStart(int what, boolean isResume, long rangeSize, Headers responseHeaders, long allCount) {
                                showToast("正在保存图片...");
                                showLoading();
                            }

                            @Override
                            public void onProgress(int what, int progress, long fileCount) {

                            }

                            @Override
                            public void onFinish(int what, String filePath) {
                                showToast("保存成功!");
                                dismissLoading();
                                Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
                                Uri uri = Uri.fromFile(new File(filePath));
                                intent.setData(uri);
                                sendBroadcast(intent);//这个广播的目的就是更新图库，发了这个广播进入相册就可以找到你保存的图片了！，记得要传你更新的file哦
                            }

                            @Override
                            public void onCancel(int what) {
                                showToast("取消下载");
                            }
                        });
                    }
                }).show();
            }
        });
    }

    private void initIndicator() {
        for (int i = 0; i < mImageList.size(); i++) {
            ImageView image = new ImageView(this);
            LinearLayout.LayoutParams layoutParams = new LinearLayout.LayoutParams(new ViewGroup.LayoutParams(LayoutParams.WRAP_CONTENT,
                    LayoutParams.WRAP_CONTENT));
            layoutParams.rightMargin = 5;
            layoutParams.leftMargin = 5;
            image.setBackgroundResource(R.mipmap.pub_pagerindicator_point0);
            mLayoutIndicator.addView(image, layoutParams);
            mIndicators.add(image);
        }
    }

    /**
     * 设置选中的tip的背景
     */
    private void setIndicator() {
        for (int i = 0; i < mIndicators.size(); i++) {
            if (i == mViewPager.getCurrentItem()) {
                mIndicators.get(i).setBackgroundResource(R.mipmap.pub_pagerindicator_point1);
            } else {
                mIndicators.get(i).setBackgroundResource(R.mipmap.pub_pagerindicator_point0);
            }
        }
    }

    class ViewPagerAdapter extends PagerAdapter {

        private LayoutInflater inflater;

        public ViewPagerAdapter() {
            inflater = LayoutInflater.from(getApplicationContext());
        }

        @Override
        public void destroyItem(ViewGroup container, int position, Object object) {
            container.removeView((View) object);
        }

        @Override
        public int getCount() {
            return mImageList.size();
        }

        @Override
        public boolean isViewFromObject(View view, Object object) {
            return view.equals(object);
        }

        @Override
        public Object instantiateItem(ViewGroup view, int position) {
            final String resource = mImageList.get(position);
            View layout = inflater.inflate(R.layout.image_switcher_item, view, false);
            ImageView imgThumb = (ImageView) layout.findViewById(R.id.imgThumb);
            final TouchImageView imgFull = (TouchImageView) layout.findViewById(R.id.imgFull);
            final View loading = layout.findViewById(R.id.loading);
            // 本地文件
            if (mSourceType.equals(SOURCE_TYPE_LOCAL_FILE)) {
                String imagePath = "file://" + resource;
                Glide.with(ImageSwitcherActivity.this).load(imagePath).asGif().diskCacheStrategy(DiskCacheStrategy.ALL).into(imgFull);
            } else { // 网络文件
                // 显示缩略图
                // 读取大图
                Glide.with(ImageSwitcherActivity.this).load(resource).asGif().diskCacheStrategy(DiskCacheStrategy.ALL).into(imgFull);
            }
            imgFull.setOnClickListener(new OnClickListener() {
                @Override
                public void onClick(View view) {
                    finish();
                }
            });
            view.addView(layout, 0);
            return layout;
        }
    }
}
