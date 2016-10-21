package com.brickman.app.module.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.RadioButton;
import android.widget.RadioGroup;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.utils.DensityUtils;
import com.brickman.app.common.utils.LogUtil;
import com.brickman.app.module.mine.UserInfoActivity;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;

/**
 * Created by mayu on 16/7/14,上午10:07.
 */
public class SexyDialog extends Dialog {
    static SexyDialog imageDialog;
    Context mCtx;
    @BindView(R.id.rg)
    RadioGroup rg;
    @BindView(R.id.man)
    RadioButton man;
    @BindView(R.id.woman)
    RadioButton woman;

    private String sexy;

    public static SexyDialog getInstance(Context ctx) {
        imageDialog = new SexyDialog(ctx);
        return imageDialog;
    }

    public SexyDialog(Context context) {
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
        View view = li.inflate(R.layout.dialog_sexy, null);
        setContentView(view, params);
        ButterKnife.bind(this);
        rg.setOnCheckedChangeListener(new RadioGroup.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(RadioGroup radioGroup, int checkedId) {
                if(checkedId == man.getId()){
                    sexy = man.getTag().toString();
                } else if(checkedId == woman.getId()){
                    sexy = woman.getTag().toString();
                }
            }
        });
        sexy = MApplication.mAppContext.mUser.userSex;
        if(sexy.equals("USER_SEX01")){
            man.setChecked(true);
            woman.setChecked(false);
        } else if(sexy.equals("USER_SEX02")){
            man.setChecked(false);
            woman.setChecked(true);
        } else {
            man.setChecked(true);
            woman.setChecked(false);
        }
    }


    @OnClick({R.id.man, R.id.woman, R.id.cancel, R.id.confirm})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.man:
                break;
            case R.id.woman:
                break;
            case R.id.cancel:
                dismiss();
                break;
            case R.id.confirm:
                LogUtil.info(sexy+"------");
                dismiss();
                ((UserInfoActivity) mCtx).mPresenter.updateSexy(sexy);
                break;
        }
    }
}
