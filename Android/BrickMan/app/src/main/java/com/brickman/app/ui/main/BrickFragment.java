package com.brickman.app.ui.main;

import android.app.Activity;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.base.BaseFragment;
import com.brickman.app.common.utils.LogUtil;

import java.util.List;

import butterknife.ButterKnife;
import butterknife.OnClick;
import cn.finalteam.galleryfinal.FunctionConfig;
import cn.finalteam.galleryfinal.GalleryFinal;
import cn.finalteam.galleryfinal.model.PhotoInfo;

/**
 * Created by mayu on 16/7/18,下午5:11.
 */
public class BrickFragment extends BaseFragment {
    private static final int REQUEST_CODE_CAMERA = 1001;
    private static final int REQUEST_CODE_GALLERY = 1002;

    @Override
    protected void initView(View view, Bundle savedInstanceState) {

    }

    @Override
    protected int getLayoutId() {
        return R.layout.fragment_brick;
    }

    @Override
    protected BaseActivity getHoldingActivity() {
        return super.getHoldingActivity();
    }

    @Override
    public void onAttach(Activity activity) {
        super.onAttach(activity);
    }

    @Override
    protected void addFragment(int fragmentContentId, BaseFragment fragment) {
        super.addFragment(fragmentContentId, fragment);
    }

    @Override
    protected void removeFragment() {
        super.removeFragment();
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        ButterKnife.bind(this, super.onCreateView(inflater, container, savedInstanceState));
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
    }

    @OnClick({R.id.take_photo, R.id.open_galley})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.take_photo:// 拍照
                FunctionConfig functionConfig = new FunctionConfig.Builder()
                        .setEnableEdit(true)
                        .setEnableCrop(true)
                        .setEnablePreview(true)
                        .setEnableRotate(true)
                        .setCropHeight(180)
                        .setCropWidth(240)
                        .setEnableRotate(true)
                        .build();
                GalleryFinal.openCamera(REQUEST_CODE_CAMERA, functionConfig, new GalleryFinal.OnHanlderResultCallback() {
                    @Override
                    public void onHanlderSuccess(int reqeustCode, List<PhotoInfo> resultList) {
                        if (reqeustCode == REQUEST_CODE_CAMERA) {
                            LogUtil.info(resultList.get(0).getPhotoPath());
                        }
                    }

                    @Override
                    public void onHanlderFailure(int requestCode, String errorMsg) {
                        mActivity.showToast(errorMsg);
                    }
                });
                break;
            case R.id.open_galley:// 选择相册
                FunctionConfig functionConfig2 = new FunctionConfig.Builder()
                        .setEnableCamera(false)
                        .setEnableEdit(true)
                        .setEnableCrop(true)
                        .setEnableRotate(true)
                        .setCropHeight(180)
                        .setCropWidth(240)
                        .setEnablePreview(true)
                        .build();
                GalleryFinal.openGallerySingle(REQUEST_CODE_GALLERY, functionConfig2, new GalleryFinal.OnHanlderResultCallback() {
                    @Override
                    public void onHanlderSuccess(int reqeustCode, List<PhotoInfo> resultList) {
                        if (reqeustCode == REQUEST_CODE_GALLERY && resultList != null && resultList.size() > 0) {
                            LogUtil.info(resultList.get(0).getPhotoPath());
                        }
                    }

                    @Override
                    public void onHanlderFailure(int requestCode, String errorMsg) {

                    }
                });
                break;
        }
    }
}
