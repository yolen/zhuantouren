package com.brickman.app.common.base;

import android.annotation.TargetApi;
import android.os.Build;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Toast;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.ui.dialog.LoadingDialog;
import com.readystatesoftware.systembartint.SystemBarTintManager;

/**
 * @author mayu
 */
public abstract class BaseActivity extends AppCompatActivity {
    public MApplication mApp;
    public LoadingDialog mLoadingDialog;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        // 设置状态栏颜色
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            setTranslucentStatus(true);
        }
        SystemBarTintManager tintManager = new SystemBarTintManager(this);
        tintManager.setStatusBarTintEnabled(true);
        tintManager.setStatusBarTintResource(R.color.colorPrimaryDark);//通知栏所需颜色

        mApp = (MApplication) getApplication();
        mLoadingDialog = new LoadingDialog(this);
    }

    //添加fragment
    protected void addFragment(int fragmentContentId, BaseFragment fragment) {
        if (fragment != null) {
            getSupportFragmentManager().beginTransaction()
                    .replace(fragmentContentId, fragment, fragment.getClass().getSimpleName())
                    .addToBackStack(fragment.getClass().getSimpleName())
                    .commitAllowingStateLoss();
        }
    }

    //移除fragment
    protected void removeFragment() {
        if (getSupportFragmentManager().getBackStackEntryCount() > 1) {
            getSupportFragmentManager().popBackStack();
        } else {
            finish();
        }
    }

    /**
     * 显示Toast消息
     * @param message
     */
    public void showToast(String message){
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
    }

    /**
     * 显示Toast消息
     * @param message
     */
    public void showToast(int message){
        Toast.makeText(this, message, Toast.LENGTH_SHORT).show();
    }

    /**
     * 显示loading
     */
    public void showLoading(){
        if(!mLoadingDialog.isShowing()){
            mLoadingDialog.show();
        }
    }

    /**
     * 隐藏loading
     */
    public void dismissLoading(){
        if(mLoadingDialog.isShowing()){
            mLoadingDialog.dismiss();
        }
    }

    @TargetApi(19)
    private void setTranslucentStatus(boolean on) {
        Window win = getWindow();
        WindowManager.LayoutParams winParams = win.getAttributes();
        final int bits = WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS;
        if (on) {
            winParams.flags |= bits;
        } else {
            winParams.flags &= ~bits;
        }
        win.setAttributes(winParams);
    }
}
