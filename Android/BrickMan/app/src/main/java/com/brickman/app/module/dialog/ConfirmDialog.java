package com.brickman.app.module.dialog;

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
 * Created by mayu on 16/7/14,上午10:07.
 */
public class ConfirmDialog extends Dialog {
    @BindView(R.id.text)
    TextView text;
    private Context mCtx;
    private String mMessage;
    private Unbinder mUnBinder;
    private OnConfirmListener mOnConfirmListener;

    public ConfirmDialog(Context context, String message, OnConfirmListener onConfirmListener) {
        super(context, R.style.CommonDialog);
        this.mCtx = context;
        this.mMessage = message;
        this.mOnConfirmListener = onConfirmListener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().getAttributes().gravity = Gravity.CENTER;
        setCanceledOnTouchOutside(false);
        setCancelable(true);
        setContentView(R.layout.dialog_confirm);
        mUnBinder = ButterKnife.bind(this);
        text.setText(mMessage);
    }

    @Override
    public void onDetachedFromWindow() {
        super.onDetachedFromWindow();
        mUnBinder.unbind();
    }

    @OnClick({R.id.cancel, R.id.confirm})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.cancel:
                dismiss();
                break;
            case R.id.confirm:
                mOnConfirmListener.confirm();
                dismiss();
                break;
        }
    }

    public interface OnConfirmListener {
        void confirm();
    }
}
