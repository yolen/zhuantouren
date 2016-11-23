package com.brickman.app.module.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;

import com.brickman.app.R;
import com.brickman.app.common.utils.DensityUtils;
import com.brickman.app.common.utils.LogUtil;
import com.brickman.app.module.mine.UserInfoActivity;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import butterknife.ButterKnife;
import butterknife.OnClick;
import cn.finalteam.galleryfinal.FunctionConfig;
import cn.finalteam.galleryfinal.GalleryFinal;
import cn.finalteam.galleryfinal.model.PhotoInfo;
import top.zibin.luban.Luban;
import top.zibin.luban.OnCompressListener;

/**
 * Created by mayu on 16/7/14,上午10:07.
 */
public class ImageDialog extends Dialog {
    private static final int REQUEST_CODE_CAMERA = 1001;
    private static final int REQUEST_CODE_GALLERY = 1002;
    static ImageDialog imageDialog;
    Context mCtx;

    public static ImageDialog getInstance(Context ctx) {
        imageDialog = new ImageDialog(ctx);
        return imageDialog;
    }

    public ImageDialog(Context context) {
        super(context, R.style.CommonDialog);
        this.mCtx = context;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setCancelable(true);
        Window window = this.getWindow();
        window.setGravity(Gravity.BOTTOM);
        window.setWindowAnimations(R.style.dialogstyle);
        int width = DensityUtils.getWidth(mCtx);
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(width, android.view.ViewGroup.LayoutParams.WRAP_CONTENT);
        setCancelable(true);
        setCanceledOnTouchOutside(true);
        LayoutInflater li = (LayoutInflater) mCtx.getSystemService(Activity.LAYOUT_INFLATER_SERVICE);
        View view = li.inflate(R.layout.dialog_image, null);
        setContentView(view, params);
        ButterKnife.bind(this);
    }

    @OnClick({R.id.camera, R.id.photo, R.id.cancel})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.camera:
                FunctionConfig functionConfig = new FunctionConfig.Builder()
                        .setEnableEdit(true)
                        .setEnableCrop(true)
                        .setEnablePreview(false)
                        .setCropHeight(480)
                        .setCropWidth(480)
                        .setCropSquare(true)
                        .setForceCrop(true)
                        .build();
                GalleryFinal.openCamera(REQUEST_CODE_CAMERA, functionConfig, new GalleryFinal.OnHanlderResultCallback() {
                    @Override
                    public void onHanlderSuccess(int reqeustCode, List<PhotoInfo> resultList) {
                        if (reqeustCode == REQUEST_CODE_CAMERA) {
                            LogUtil.info(resultList.get(0).getPhotoPath());
                            String imagePath = resultList.get(0).getPhotoPath();
                            compress(imagePath);
                        }
                    }

                    @Override
                    public void onHanlderFailure(int requestCode, String errorMsg) {
                        ((UserInfoActivity) mCtx).showToast(errorMsg);
                    }
                });
                break;
            case R.id.photo:
                FunctionConfig functionConfig2 = new FunctionConfig.Builder()
                        .setEnableCamera(false)
                        .setEnableEdit(true)
                        .setEnableCrop(true)
                        .setCropSquare(true)
                        .setForceCrop(true)
                        .setEnablePreview(false)
                        .build();
                GalleryFinal.openGallerySingle(REQUEST_CODE_GALLERY, functionConfig2, new GalleryFinal.OnHanlderResultCallback() {
                    @Override
                    public void onHanlderSuccess(int reqeustCode, List<PhotoInfo> resultList) {
                        if (reqeustCode == REQUEST_CODE_GALLERY && resultList != null && resultList.size() > 0) {
                            LogUtil.info(resultList.get(0).getPhotoPath());
                            String imagePath = resultList.get(0).getPhotoPath();
                            compress(imagePath);
                        }
                    }

                    @Override
                    public void onHanlderFailure(int requestCode, String errorMsg) {
                        ((UserInfoActivity) mCtx).showToast(errorMsg);
                    }
                });
                break;
            case R.id.cancel:
                dismiss();
                break;
        }
    }

    private void compress(final String imagePath) {
        Luban.get(mCtx)
                .load(new File(imagePath))                     //传人要压缩的图片
//                .putGear(Luban.FIRST_GEAR)//设定压缩档次，默认三挡
                .setCompressListener(new OnCompressListener() { //设置回调
                    @Override
                    public void onStart() {
                        // 压缩开始前调用，可以在方法内启动 loading UI
                        LogUtil.info("开始压缩图片:--");
                    }

                    @Override
                    public void onSuccess(File file) {
                        // 压缩成功后调用，返回压缩后的图片文件
                        LogUtil.info("压缩图片成功:--" + (file.length() / 1024) + "KB" + file.getPath());
                        ArrayList<String> list = new ArrayList<String>();
                        list.add(file.getPath());
                        ((UserInfoActivity) mCtx).uploadImageList(list);
                    }

                    @Override
                    public void onError(Throwable e) {
                        // 当压缩过去出现问题时调用
                        LogUtil.info("压缩图片失败:--!");
                        ArrayList<String> list = new ArrayList<String>();
                        list.add(imagePath);
                        ((UserInfoActivity) mCtx).uploadImageList(list);
                    }
                }).launch();    //启动压缩
    }
}
