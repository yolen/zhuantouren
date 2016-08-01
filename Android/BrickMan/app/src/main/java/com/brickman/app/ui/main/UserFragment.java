package com.brickman.app.ui.main;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.base.BaseFragment;
import com.brickman.app.common.utils.LogUtil;
import com.brickman.app.ui.brick.BrickListActivity;
import com.brickman.app.ui.mine.BricksListActivity;
import com.brickman.app.ui.mine.FlowerListActivity;
import com.brickman.app.ui.mine.UserInfoActivity;
import com.yolanda.nohttp.OnUploadListener;

import java.util.ArrayList;

import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/18,下午5:11.
 */
public class UserFragment extends BaseFragment {
    private static final int REQUEST_CODE_GALLERY = 001;
    /**
     * 文件上传监听。
     */
    private OnUploadListener mOnUploadListener = new OnUploadListener() {

        @Override
        public void onStart(int what) {// 这个文件开始上传。
//        uploadFiles.get(what).setTitle(R.string.upload_start);
//        mUploadFileAdapter.notifyItemChanged(what);
            LogUtil.debug("onStart", what + "");
        }

        @Override
        public void onCancel(int what) {// 这个文件的上传被取消时。
            LogUtil.debug("onCancel", what + "");
        }

        @Override
        public void onProgress(int what, int progress) {// 这个文件的上传进度发生边耍
            LogUtil.debug("onProgress", "第" + what + "张:" + progress + "");
        }

        @Override
        public void onFinish(int what) {// 文件上传完成
            LogUtil.debug("onFinish", what + "");
        }

        @Override
        public void onError(int what, Exception exception) {// 文件上传发生错误。
            LogUtil.error("onError", exception);
        }
    };

    @Override
    protected void initView(View view, Bundle savedInstanceState) {
    }

    @Override
    protected int getLayoutId() {
        return R.layout.fragment_user;
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

    @OnClick({R.id.userInfo, R.id.mybricks, R.id.mybrick, R.id.myflower, R.id.about, R.id.logout})
    public void onClick(View view) {
        Intent intent;
        switch (view.getId()) {
            case R.id.userInfo:
                intent = new Intent(mActivity, UserInfoActivity.class);
                mActivity.startActivityWithAnim(intent);
                break;
            case R.id.mybricks:
                intent = new Intent(mActivity, BrickListActivity.class);
                intent.putExtra("title", getResources().getString(R.string.my_bricks));
                mActivity.startActivityWithAnim(intent);
                break;
            case R.id.mybrick:
                intent = new Intent(mActivity, BricksListActivity.class);
                mActivity.startActivityWithAnim(intent);
                break;
            case R.id.myflower:
                intent = new Intent(mActivity, FlowerListActivity.class);
                mActivity.startActivityWithAnim(intent);
                break;
            case R.id.about:
                ArrayList<String> fileList = new ArrayList<String>();
//                fileList.add(Environment.getExternalStorageDirectory().getAbsolutePath()+"/NoHttpSample/image1.jpg");
//                fileList.add(Environment.getExternalStorageDirectory().getAbsolutePath()+"/NoHttpSample/image2.jpg");
//                fileList.add(Environment.getExternalStorageDirectory().getAbsolutePath()+"/NoHttpSample/image2.jpg");
//                RequestParam param = ParamBuilder.buildParam("userId", "test1");
//                RequestHelper.uploadFile(Api.UPLOAD_FILES, param, fileList, mOnUploadListener);
//                FunctionConfig config = new FunctionConfig.Builder()
//                        .setMutiSelectMaxSize(9)
//                        .build();
//                GalleryFinal.openGalleryMuti(REQUEST_CODE_GALLERY, config, new GalleryFinal.OnHanlderResultCallback() {
//                    @Override
//                    public void onHanlderSuccess(int reqeustCode, List<PhotoInfo> resultList) {
//                        if(reqeustCode == REQUEST_CODE_GALLERY){
//                            for (int i = 0; i < resultList.size(); i++) {
//                                LogUtil.info(resultList.get(i).getPhotoId() + "\n"
//                                +resultList.get(i).getWidth()+"/"+resultList.get(i).getHeight()+"\n"
//                                +resultList.get(i).getPhotoPath());
//                            }
//                        }
//                    }
//
//                    @Override
//                    public void onHanlderFailure(int requestCode, String errorMsg) {
//
//                    }
//                });
                break;
            case R.id.logout:
                break;
        }
    }
}
