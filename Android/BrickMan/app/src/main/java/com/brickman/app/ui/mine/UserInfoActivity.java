package com.brickman.app.ui.mine;

import android.os.Bundle;
import android.support.annotation.LayoutRes;
import android.support.v7.widget.Toolbar;
import android.view.View;
import android.widget.TextView;

import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;
import com.brickman.app.contract.UserInfoContract;
import com.brickman.app.model.UserInfoModel;
import com.brickman.app.presenter.UserInfoPresenter;
import com.brickman.app.ui.dialog.ImageDialog;
import com.brickman.app.ui.dialog.NickNameDialog;
import com.brickman.app.ui.dialog.PasswordDialog;
import com.brickman.app.ui.dialog.SexyDialog;
import com.brickman.app.ui.widget.view.CircleImageView;

import butterknife.BindView;
import butterknife.OnClick;

import static com.brickman.app.R.id.toolbar;

/**
 * Created by mayu on 16/7/26,上午9:53.
 */
public class UserInfoActivity extends BaseActivity<UserInfoPresenter, UserInfoModel> implements UserInfoContract.View {
    @BindView(R.id.avator)
    CircleImageView mAvator;
    @BindView(R.id.nickName)
    TextView mNickName;
    @BindView(R.id.sex)
    TextView mSex;
    @BindView(R.id.motto)
    TextView mMotto;
    @BindView(toolbar)
    Toolbar mToolbar;

    ImageDialog mImageDialog;
    SexyDialog mSexyDialog;
    NickNameDialog mNickNameDialog;
    PasswordDialog mPasswordDialog;

    @Override
    protected int getLayoutId() {
        return R.layout.activity_user_info;
    }

    @Override
    public void setContentView(@LayoutRes int layoutResID) {
        super.setContentView(layoutResID);
        mToolbar = (Toolbar) findViewById(toolbar);
        mToolbar.setTitle("");
        setSupportActionBar(mToolbar);

    }

    @Override
    public void updateAvatorSuccess(String avatorUrl) {

    }

    @Override
    public void updateNickNameSuccess(String nickName) {

    }

    @Override
    public void updateSexySuccess(String sexy) {

    }

    @Override
    public void updatePasswordSuccess(String password) {

    }

    @Override
    public void updateMottoSuccess(String motto) {

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
//                mPresenter.updateAvator("");
                break;
            case R.id.updateNickName:
                mNickNameDialog = NickNameDialog.getInstance(this);
                mNickNameDialog.show();
//                mPresenter.updateNickName("");
                break;
            case R.id.updateSexy:
                mSexyDialog = SexyDialog.getInstance(this);
                mSexyDialog.show();
//                mPresenter.updateSexy("");
                break;
            case R.id.updatePassword:
                mPasswordDialog = PasswordDialog.getInstance(this);
                mPasswordDialog.show();
//                mPresenter.updatePassword("");
                break;
            case R.id.updateMotto:
//                mPresenter.updateMotto("");
                break;
        }
    }
}

