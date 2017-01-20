package com.brickman.app.module.mine;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.Toolbar;
import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.widget.CheckBox;
import android.widget.ImageButton;
import android.widget.TextView;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.lbs.LocationManager;
import com.brickman.app.common.utils.DensityUtils;
import com.brickman.app.common.utils.LogUtil;
import com.brickman.app.common.utils.StringUtil;
import com.brickman.app.contract.PublishContract;
import com.brickman.app.model.PublishModel;
import com.brickman.app.module.dialog.LBSDialog;
import com.brickman.app.module.dialog.UploadProgressDialog;
import com.brickman.app.presenter.PublishPresenter;
import com.bumptech.glide.Glide;
import com.chad.library.adapter.base.BaseQuickAdapter;
import com.chad.library.adapter.base.BaseViewHolder;
import com.makeramen.roundedimageview.RoundedImageView;
import com.yqritc.recyclerviewflexibledivider.HorizontalDividerItemDecoration;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;
import cn.finalteam.galleryfinal.FunctionConfig;
import cn.finalteam.galleryfinal.GalleryFinal;
import cn.finalteam.galleryfinal.model.PhotoInfo;
import io.github.rockerhieu.emojicon.EmojiconEditText;
import me.shaohui.advancedluban.Luban;
import me.shaohui.advancedluban.OnMultiCompressListener;

/**
 * Created by mayu on 16/8/1,上午9:49.
 */

public class PublishActivity extends BaseActivity<PublishPresenter, PublishModel> implements PublishContract.View {
    private static final int REQUEST_CODE_GALLERY = 001;
    @BindView(R.id.toolbar)
    Toolbar mToolBar;
    @BindView(R.id.text)
    EmojiconEditText text;
    @BindView(R.id.textSize)
    TextView textSize;
    @BindView(R.id.imageSize)
    TextView imageSize;
    @BindView(R.id.location)
    TextView location;
    @BindView(R.id.checkbox)
    CheckBox checkbox;
    @BindView(R.id.images)
    RecyclerView mRlv;

    private UploadProgressDialog mUploadProgressDialog;
    private LocationManager mLocationManager;

    private ArrayList<String> images = new ArrayList<>();
    private ImageAdapter mImageAdapter;
    private int w;
    private String mAddress;

    private List<String> mLubanList;
//    private String mImagePath;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_publish;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        mToolBar = (Toolbar) findViewById(R.id.toolbar);
        mToolBar.setTitle("");
        setSupportActionBar(mToolBar);
        text.addTextChangedListener(new TextWatcher() {
            @Override
            public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {
            }

            @Override
            public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
            }

            @Override
            public void afterTextChanged(Editable editable) {
                textSize.setText(editable.length() + "/" + "100字");
            }
        });
        images.add("add");
        GridLayoutManager gridLayoutManager = new GridLayoutManager(this, 4);
        gridLayoutManager.setOrientation(LinearLayoutManager.VERTICAL);
        mRlv.setLayoutManager(gridLayoutManager);
        mImageAdapter = new ImageAdapter(R.layout.item_image, images);
        mRlv.setAdapter(mImageAdapter);
        mRlv.addItemDecoration(new HorizontalDividerItemDecoration.Builder(this)
                .color(getResources().getColor(R.color.white))
                .sizeResId(R.dimen.dp_15)
                .marginResId(R.dimen.dp_00, R.dimen.dp_00)
                .build());
        mAddress = MApplication.mAppContext.getAddress();
        location.setText(TextUtils.isEmpty(mAddress) ? "选择位置" : mAddress);
        mLocationManager = new LocationManager(this.getApplicationContext(), new LocationManager.OnResultListener() {
            @Override
            public void getAddress(String city, String address) {
                if (isFinishing()) {
                    new LBSDialog(PublishActivity.this, address, new LBSDialog.OnAddressListener() {
                        @Override
                        public void getAddress(String address) {
                            mAddress = address;
                            location.setText(mAddress);
                        }
                    }).show();
                    dismissLoading();
                }
            }
        });
    }

    @OnClick({R.id.back, R.id.publish, R.id.gps})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.back:
                finishWithAnim();
                break;
            case R.id.publish:

                if (TextUtils.isEmpty(text.getText().toString().trim())) {
                    showMsg("请输入文字描述!");
                } else if (TextUtils.isEmpty(mAddress)) {
                    showMsg("请选择城市!");
                } else {
                    showLoading();
                    if (images.size() > 1) {
                        mLubanList = new ArrayList<String>();
//                        for (int i = 0; i < images.size() - 1; i++) {
//                            mImagePath = images.get(i);
//                            compressImage(mImagePath);
//                        }
                        compressImageList(images);
                    } else {
                        dismissLoading();
                        uploadImagesSuccess(null);
                    }
                }
                break;
            case R.id.gps:
                showMsg("正在获取您当前位置...");
                showLoading();
                mLocationManager.startLocation();
                break;
        }
    }

    /**
     * 批量压缩图片
     *
     * @param imagePathList
     */
    private void compressImageList(final List<String> imagePathList) {
        if (imagePathList == null || imagePathList.size() == 0) {
            return;
        }
        List<File> fileList = new ArrayList<File>();
        for (String path : imagePathList) {
            fileList.add(new File(path));
        }
        Luban.compress(this, fileList)
                .putGear(Luban.THIRD_GEAR)      // set the compress mode, default is : THIRD_GEAR
                .launch(new OnMultiCompressListener() {
                    @Override
                    public void onStart() {
                        // 压缩开始前调用，可以在方法内启动 loading UI
                        LogUtil.info("开始压缩图片:--");
                    }

                    @Override
                    public void onSuccess(List<File> fileList) {
                        // 压缩成功后调用，返回压缩后的图片文件
                        for (File file: fileList) {
                            LogUtil.info("压缩图片成功:--" + (file.length() / 1024) + "KB" + file.getPath());
                            mLubanList.add(file.getPath());
                        }
                        if (mLubanList.size() == images.size() - 1) {
                            dismissLoading();
                            if (!isFinishing()) {
                                uploadImageList(mLubanList);
                            }
                        }
                    }

                    @Override
                    public void onError(Throwable e) {
                        // 当压缩过去出现问题时调用
                        LogUtil.info("压缩图片失败:--!");
                    }
                });
    }

    /**
     * 压缩图片
     * <p>
     * //     * @param imagePath
     */
//    private void compressImage(final String imagePath) {
//        Luban.get(this.getApplicationContext())
//                .load(new File(imagePath))                     //传人要压缩的图片
//                .putGear(Luban.THIRD_GEAR)//设定压缩档次，默认三挡
//                .setCompressListener(new OnCompressListener() { //设置回调
//                    @Override
//                    public void onStart() {
//                        // 压缩开始前调用，可以在方法内启动 loading UI
//                        LogUtil.info("开始压缩图片:--");
//                    }
//
//                    @Override
//                    public void onSuccess(File file) {
//                        // 压缩成功后调用，返回压缩后的图片文件
//                        LogUtil.info("压缩图片成功:--" + (file.length() / 1024) + "KB" + file.getPath());
//                        mLubanList.add(file.getPath());
//                        if (mLubanList.size() == images.size() - 1) {
//                            dismissLoading();
//                            if (!isFinishing()) {
//                                uploadImageList(mLubanList);
//                            }
//                        }
//                    }
//
//                    @Override
//                    public void onError(Throwable e) {
//                        // 当压缩过去出现问题时调用
//                        LogUtil.info("压缩图片失败:--!");
//                        mLubanList.add(imagePath);
//                        if (mLubanList.size() == images.size() - 1) {
//                            dismissLoading();
//                            if (!isFinishing()) {
//                                uploadImageList(mLubanList);
//                            }
//                        }
//                    }
//                }).launch();    //启动压缩
//    }
    private void uploadImageList(List<String> imgList) {
        mUploadProgressDialog = new UploadProgressDialog(this, new UploadProgressDialog.OnCancelListener() {
            @Override
            public void cancelUpload() {
                mPresenter.cancelUpload();
            }
        });
        mUploadProgressDialog.show();
        mPresenter.uploadImages(imgList);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 100) {
            if (resultCode == RESULT_OK) {
                mAddress = data.getStringExtra("address");
                location.setText(mAddress);
            }
        }
    }

    class ImageAdapter extends BaseQuickAdapter<String> {
        public ImageAdapter(int layoutResId, List<String> data) {
            super(layoutResId, data);
            w = (DensityUtils.getWidth(PublishActivity.this)
                    - DensityUtils.dip2px(PublishActivity.this,
                    (int) getResources().getDimension(R.dimen.dp_30))) / 4;
        }

        @Override
        protected void convert(BaseViewHolder helper, final String s) {
            final RoundedImageView image = helper.getView(R.id.image);
            ImageButton del = helper.getView(R.id.del);
            if (s.equals("add")) {
                Glide.with(PublishActivity.this).load(R.mipmap.bm_add).override(w, w).centerCrop().crossFade().into(image);
                del.setVisibility(View.INVISIBLE);
            } else {
                Glide.with(PublishActivity.this).load(s).override(w, w).centerCrop().crossFade().into(image);
                del.setVisibility(View.VISIBLE);
            }
            image.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (s.equals("add")) {
                        FunctionConfig config = new FunctionConfig.Builder()
                                .setMutiSelectMaxSize(9)
                                .setSelected(images)
                                .setEnableCamera(true)
                                .build();
                        GalleryFinal.openGalleryMuti(REQUEST_CODE_GALLERY, config, new GalleryFinal.OnHanlderResultCallback() {
                            @Override
                            public void onHanlderSuccess(int reqeustCode, List<PhotoInfo> resultList) {
                                if (reqeustCode == REQUEST_CODE_GALLERY) {
                                    images.clear();
                                    images.add("add");
                                    for (int i = 0; i < resultList.size(); i++) {
                                        images.add(images.size() - 1, resultList.get(i).getPhotoPath());
                                    }
                                    mImageAdapter.notifyDataSetChanged();
                                    imageSize.setText(resultList.size() + "/9");
                                }
                            }

                            @Override
                            public void onHanlderFailure(int requestCode, String errorMsg) {

                            }
                        });
                    }
                }
            });
            del.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    if (!s.equals("add")) {
                        images.remove(s);
                        mImageAdapter.notifyDataSetChanged();
                        imageSize.setText((images.size() - 1) + "/9");
                    }
                }
            });
        }
    }

    @Override
    public void uploadImagesSuccess(String imageList) {
        String content = text.getText().toString().trim();
        boolean isGoodThings = checkbox.isChecked();
        if (!isEmpty(content, mAddress, imageList)) {
            mPresenter.publish(StringUtil.getStringByEmoji(content), System.currentTimeMillis() + "", mAddress, isGoodThings, imageList);
        }
    }

    private boolean isEmpty(String content, String address, String imageList) {
        if (TextUtils.isEmpty(content)) {
            showMsg("请输入文字描述!");
            return true;
        } else if (TextUtils.isEmpty(mAddress)) {
            showMsg("请选择城市!");
            return true;
        } else if (TextUtils.isEmpty(imageList)) {
            showMsg("请选择图片!");
            return true;
        } else {
            return false;
        }
    }

    @Override
    public void updateProgress(int total, int currIndex, int prog) {
        mUploadProgressDialog.updateProgress(total, currIndex, prog);
    }

    @Override
    public void cancelProgressDialog() {
        mUploadProgressDialog.dismiss();
    }

    @Override
    public void publishSuccess() {
        showMsg("发布成功");
        setResult(RESULT_OK);
        finishWithAnim();
    }

    @Override
    public void showMsg(String msg) {
        showToast(msg);
    }


}
