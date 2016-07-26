package com.brickman.app.ui.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.v7.widget.AppCompatEditText;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;

import com.brickman.app.R;
import com.brickman.app.common.utils.DensityUtils;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/14,上午10:07.
 */
public class PasswordDialog extends Dialog {
    static PasswordDialog imageDialog;
    Context mCtx;
    @BindView(R.id.mobile)
    AppCompatEditText mobile;
    @BindView(R.id.vCode)
    AppCompatEditText vCode;
    @BindView(R.id.password)
    AppCompatEditText password;

    public static PasswordDialog getInstance(Context ctx) {
        imageDialog = new PasswordDialog(ctx);
        return imageDialog;
    }

    public PasswordDialog(Context context) {
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
        View view = li.inflate(R.layout.dialog_password, null);
        setContentView(view, params);
        ButterKnife.bind(this);
    }


    @OnClick({R.id.getVCode, R.id.cancel, R.id.confirm})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.getVCode:
                break;
            case R.id.cancel:
                break;
            case R.id.confirm:
                break;
        }
    }
}
