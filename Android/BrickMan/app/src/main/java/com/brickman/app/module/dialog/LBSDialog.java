package com.brickman.app.module.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.support.v7.widget.AppCompatEditText;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;

import com.brickman.app.R;
import com.brickman.app.module.widget.view.ToastManager;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import butterknife.Unbinder;

/**
 * Created by mayu on 16/7/14,上午10:07.
 */
public class LBSDialog extends Dialog {
    @BindView(R.id.address)
    AppCompatEditText address;
    private Context mCtx;
    private String mAddress;
    private Unbinder mUnBinder;
    private OnAddressListener mOnAddressListener;

    public LBSDialog(Context context, String address, OnAddressListener onAddressListener) {
        super(context, R.style.CommonDialog);
        this.mCtx = context;
        this.mAddress = address;
        this.mOnAddressListener = onAddressListener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().getAttributes().gravity = Gravity.CENTER;
        setCanceledOnTouchOutside(false);
        setCancelable(true);
        setContentView(R.layout.dialog_lbs);
        mUnBinder = ButterKnife.bind(this);
        address.setText(mAddress);
        address.requestFocus();
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
                String addressStr = address.getText().toString().trim();
                if (!TextUtils.isEmpty(addressStr)) {
                    mOnAddressListener.getAddress(addressStr);
                    dismiss();
                } else {
                    ToastManager.showWithTxt(mCtx, "地址不能为空！");
                }
                break;
        }
    }

    public interface OnAddressListener {
        public void getAddress(String address);
    }
}
