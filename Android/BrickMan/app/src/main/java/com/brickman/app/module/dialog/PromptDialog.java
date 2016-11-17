package com.brickman.app.module.dialog;

import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.TextView;

import com.brickman.app.R;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.Unbinder;

/**
 * Created by zhangshiyu on 2016/11/17.
 */

public class PromptDialog extends AlertDialog {

    private Context mCtx;
    private String mMessage;
    private Unbinder mUnBinder;
    @BindView(R.id.text)
    TextView textView;

    public PromptDialog(Context context, String message) {
        super(context, R.style.CommonDialog);
        this.mCtx = context;
        this.mMessage = message;

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().getAttributes().gravity = Gravity.CENTER;
        setCanceledOnTouchOutside(true);
        setCancelable(true);
        setContentView(R.layout.dialog_prompt);
        mUnBinder = ButterKnife.bind(this);
        textView.setText(mMessage);

    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        mUnBinder.unbind();
    }

    @OnClick({R.id.confirm})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.confirm:
                dismiss();
                cancel();
                break;
        }
    }

}
