package com.brickman.app.module.mine;

import android.content.Intent;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.support.v7.widget.Toolbar;
import android.text.TextUtils;
import android.view.View;
import android.widget.TextView;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.base.Api;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.common.utils.StringUtil;
import com.brickman.app.contract.UserInfoContract;
import com.brickman.app.model.UserInfoModel;
import com.brickman.app.module.dialog.ImageDialog;
import com.brickman.app.module.dialog.MottoDialog;
import com.brickman.app.module.dialog.NickNameDialog;
import com.brickman.app.module.dialog.PasswordDialog;
import com.brickman.app.module.dialog.SexyDialog;
import com.brickman.app.module.dialog.UploadProgressDialog;
import com.brickman.app.module.widget.view.CircleImageView;
import com.brickman.app.presenter.UserInfoPresenter;
import com.bumptech.glide.Glide;
import com.bumptech.glide.load.engine.DiskCacheStrategy;

import java.util.List;

import butterknife.BindView;
import butterknife.OnClick;
import io.github.rockerhieu.emojicon.EmojiconTextView;
import rx.internal.util.unsafe.MpmcArrayQueue;

import static com.brickman.app.R.id.nickName;
import static com.brickman.app.R.id.toolbar;

/**
 * Created by mayu on 16/7/26,上午9:53.
 */
public class UserInfoActivity extends BaseActivity<UserInfoPresenter, UserInfoModel> implements UserInfoContract.View {
    @BindView(R.id.avator)
    CircleImageView mAvator;
    @BindView(nickName)
    TextView mNickName;
    @BindView(R.id.sex)
    TextView mSex;
    @BindView(R.id.motto)
    EmojiconTextView mMotto;
    @BindView(toolbar)
    Toolbar mToolbar;

    ImageDialog mImageDialog;
    SexyDialog mSexyDialog;
    NickNameDialog mNickNameDialog;
    PasswordDialog mPasswordDialog;
    MottoDialog mMottoDialog;

    private UploadProgressDialog mUploadProgressDialog;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_user_info;
    }

    @Override
    public void onCreate(Bundle savedInstanceState, PersistableBundle persistentState) {
        super.onCreate(savedInstanceState, persistentState);
        mToolbar = (Toolbar) findViewById(toolbar);
        mToolbar.setTitle("");
        setSupportActionBar(mToolbar);
    }

    @Override
    protected void onResume() {
        super.onResume();
        Glide.with(UserInfoActivity.this).load(MApplication.mAppContext.mUser.userHead)
                .asBitmap()
                .diskCacheStrategy(DiskCacheStrategy.ALL)
                .into(mAvator);
        mNickName.setText(TextUtils.isEmpty(MApplication.mAppContext.mUser.userName) ?
                MApplication.mAppContext.mUser.userAlias : MApplication.mAppContext.mUser.userAlias);
        mSex.setText(MApplication.mAppContext.mUser.getUserSex());
        mMotto.setText(TextUtils.isEmpty(MApplication.mAppContext.mUser.motto) ? "漂泊者分享交流社区!" : MApplication.mAppContext.mUser.motto);
    }

    @Override
    public void updateAvatorSuccess(String avatorUrl) {
        MApplication.mAppContext.mUser.userHead = avatorUrl;
        MApplication.mDataKeeper.put("user_info", MApplication.mAppContext.mUser);
        Glide.with(this).load(avatorUrl).into(mAvator);
        sendBroadcast(new Intent(Api.ACTION_USERINFO));
    }

    @Override
    public void updateNickNameSuccess(String nickName) {
        MApplication.mAppContext.mUser.userAlias = nickName;
        MApplication.mDataKeeper.put("user_info", MApplication.mAppContext.mUser);
        sendBroadcast(new Intent(Api.ACTION_USERINFO));
        mNickName.setText(nickName);
    }

    @Override
    public void updateSexySuccess(String sexy) {
        MApplication.mAppContext.mUser.userSex = sexy;
        MApplication.mDataKeeper.put("user_info", MApplication.mAppContext.mUser);
        sendBroadcast(new Intent(Api.ACTION_USERINFO));
        mSex.setText(MApplication.mAppContext.mUser.getUserSex());
    }

    public void uploadImageList(List<String> imgList){
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
    public void updatePasswordSuccess(String password) {

    }

    @Override
    public void updateMottoSuccess(String motto) {
        MApplication.mAppContext.mUser.motto = motto;
        MApplication.mDataKeeper.put("user_info", MApplication.mAppContext.mUser);
        sendBroadcast(new Intent(Api.ACTION_USERINFO));
        mMotto.setText(StringUtil.getEmojiByString(motto));
    }

    @Override
    public void uploadImagesSuccess(String imageList) {
        mPresenter.updateAvator(imageList);
        mImageDialog.dismiss();
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
    public void showMsg(String msg) {
        showToast(msg);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @OnClick({R.id.back, R.id.commit, R.id.updateAvator, R.id.updateNickName, R.id.updateSexy, R.id.updatePassword, R.id.updateMotto})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.back:
                finishWithAnim();
                break;
            case R.id.commit:

                break;
            case R.id.updateAvator:
                mImageDialog = ImageDialog.getInstance(this);
                mImageDialog.show();
                break;
            case R.id.updateNickName:
                mNickNameDialog = NickNameDialog.getInstance(this);
                mNickNameDialog.show();
                break;
            case R.id.updateSexy:
                mSexyDialog = SexyDialog.getInstance(this);
                mSexyDialog.show();
                break;
            case R.id.updatePassword:
                mPasswordDialog = PasswordDialog.getInstance(this);
                mPasswordDialog.show();
                break;
            case R.id.updateMotto:
                mMottoDialog = MottoDialog.getInstance(this);
                mMottoDialog.show();
                break;
        }
    }
}

