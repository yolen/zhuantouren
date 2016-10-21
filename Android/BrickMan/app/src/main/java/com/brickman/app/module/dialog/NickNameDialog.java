package com.brickman.app.module.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.v7.widget.AppCompatEditText;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;

import com.brickman.app.R;
import com.brickman.app.common.utils.DensityUtils;
import com.brickman.app.module.mine.UserInfoActivity;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/14,上午10:07.
 */
public class NickNameDialog extends Dialog {
    static NickNameDialog imageDialog;
    Context mCtx;
    @BindView(R.id.nickName)
    AppCompatEditText nickName;

    public static NickNameDialog getInstance(Context ctx) {
        imageDialog = new NickNameDialog(ctx);
        return imageDialog;
    }

    public NickNameDialog(Context context) {
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
        ViewGroup.LayoutParams params = new ViewGroup.LayoutParams(width, ViewGroup.LayoutParams.WRAP_CONTENT);
        setCancelable(true);
        setCanceledOnTouchOutside(true);
        LayoutInflater li = (LayoutInflater) mCtx.getSystemService(Activity.LAYOUT_INFLATER_SERVICE);
        View view = li.inflate(R.layout.dialog_nickname, null);
        setContentView(view, params);
        ButterKnife.bind(this);
    }


    @OnClick({R.id.cancel, R.id.confirm})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.cancel:
                dismiss();
                break;
            case R.id.confirm:
                String name = nickName.getText().toString().trim();
                if(!TextUtils.isEmpty(name)){
                    dismiss();
                    ((UserInfoActivity)mCtx).mPresenter.updateNickName(name);
                } else {
                    ((UserInfoActivity)mCtx).showMsg("昵称不能为空");
                }
                break;
        }
    }
}
