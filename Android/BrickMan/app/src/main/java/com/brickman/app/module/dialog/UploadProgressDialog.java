package com.brickman.app.module.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.brickman.app.R;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/14,上午10:07.
 */
public class UploadProgressDialog extends Dialog {
    @BindView(R.id.progress_bar)
    ProgressBar progressBar;
    @BindView(R.id.fileNum)
    TextView fileNum;
    @BindView(R.id.progress)
    TextView progress;

    private OnCancelListener mOnCancelListener;

    public UploadProgressDialog(Context context, OnCancelListener cancelListener) {
        super(context, R.style.ProgressDialog);
        this.mOnCancelListener = cancelListener;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getWindow().getAttributes().gravity = Gravity.CENTER;
        setCanceledOnTouchOutside(false);
        setCancelable(false);
        setContentView(R.layout.dialog_progress);
        ButterKnife.bind(this);
    }

    public void updateProgress(int total, int currIndex, int prog) {
        fileNum.setText(currIndex + "/" + total);
        progress.setText(prog + "%");
        progressBar.setProgress(prog);
    }

    @OnClick(R.id.cancel)
    public void onClick() {
        mOnCancelListener.cancelUpload();
        dismiss();
    }

    public interface OnCancelListener {
        void cancelUpload();
    }
}
