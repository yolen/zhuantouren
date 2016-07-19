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
import com.brickman.app.common.utils.TUtil;
import com.brickman.app.ui.dialog.LoadingDialog;
import com.readystatesoftware.systembartint.SystemBarTintManager;

import butterknife.ButterKnife;

/**
 * @author mayu
 */
public abstract class BaseActivity<T extends BasePresenter, E extends BaseModel>  extends AppCompatActivity {
    public MApplication mApp;
    public T mPresenter;
    public E mModel;
    public LoadingDialog mLoadingDialog;
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setTheme(R.style.AppThemeDay);
        // 设置状态栏颜色
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT && Build.VERSION.SDK_INT <= Build.VERSION_CODES.LOLLIPOP) {
            setTranslucentStatus(true);
            SystemBarTintManager tintManager = new SystemBarTintManager(this);
            tintManager.setStatusBarTintEnabled(true);
            tintManager.setStatusBarTintResource(R.color.colorPrimaryDark);//通知栏所需颜色
        }
        this.setContentView(this.getLayoutId());
        ButterKnife.bind(this);
        mApp = MApplication.getInstance();
        mLoadingDialog = new LoadingDialog(this);
        mPresenter = TUtil.getT(this, 0);
        mModel = TUtil.getT(this, 1);
        if (this instanceof BaseView) mPresenter.setVM(this, mModel);
    }

    protected abstract int getLayoutId();

    @Override
    protected void onDestroy() {
        super.onDestroy();
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
