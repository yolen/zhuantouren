package com.brickman.app.module.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.EditText;

import com.brickman.app.R;
import com.brickman.app.common.utils.DensityUtils;
import com.brickman.app.common.utils.KeyboardUtils;
import com.brickman.app.module.widget.view.ToastManager;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/14,上午10:07.
 */
public class CommentDialog extends Dialog {
    static CommentDialog imageDialog;
    Context mCtx;
    @BindView(R.id.comment)
    EditText comment;

    private OnSendListener mOnSendListener;

    public CommentDialog(Context context, OnSendListener onSendListener) {
        super(context, R.style.LoadingDialog);
        this.mCtx = context;
        this.mOnSendListener = onSendListener;
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
        View view = li.inflate(R.layout.dialog_comment, null);
        setContentView(view, params);
        ButterKnife.bind(this);
    }

    @Override
    public void show() {
        super.show();
        KeyboardUtils.toggleSoftInput(mCtx, comment);
    }

    @Override
    public void dismiss() {
        super.dismiss();
        KeyboardUtils.hideSoftInput((Activity) mCtx);
    }

    @OnClick({R.id.comment, R.id.send})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.comment:
                break;
            case R.id.send:
                String text = comment.getText().toString().trim();
                if(!TextUtils.isEmpty(text)){
                    mOnSendListener.send(text);
                } else {
                    ToastManager.showWithTxt(mCtx, "评论不能为空!");
                }
                break;
        }
    }

    public void clear(){
        comment.setText("");
    }

    public interface OnSendListener{
        void send(String comment);
    }
}
