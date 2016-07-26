package com.brickman.app.ui.dialog;

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

import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/14,上午10:07.
 */
public class ImageDialog extends Dialog {
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
                dismiss();
                break;
            case R.id.photo:
                dismiss();
                break;
            case R.id.cancel:
                dismiss();
                break;
        }
    }
}
