package com.brickman.app.common.base;

import android.annotation.TargetApi;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.support.annotation.LayoutRes;
import android.support.v7.app.AppCompatActivity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.brickman.app.common.utils.TUtil;
import com.brickman.app.module.dialog.LoadingDialog;
import com.brickman.app.module.widget.view.SwipeBackLayout;
import com.readystatesoftware.systembartint.SystemBarTintManager;

import butterknife.ButterKnife;
import butterknife.Unbinder;

/**
 * @author mayu
 */
public abstract class BaseActivity<T extends BasePresenter, E extends BaseModel>  extends AppCompatActivity {
    public MApplication mApp;
    public T mPresenter;
    public E mModel;
    public LoadingDialog mLoadingDialog;
    private SwipeBackLayout swipeBackLayout;
    private ImageView ivShadow;
    protected boolean isInitMVP = true;
    protected int statusBar_color;
    Unbinder unbinder;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        int layoutId = getLayoutId();
        if(layoutId == R.layout.activity_spalish
                || layoutId == R.layout.activity_login
                || layoutId == R.layout.activity_image_switcher
                || layoutId == R.layout.activity_guide){
            setTheme(R.style.Transparent);
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
                Window window = getWindow();
                window.setFlags(WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS,
                        WindowManager.LayoutParams.FLAG_TRANSLUCENT_STATUS);
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT && Build.VERSION.SDK_INT <= Build.VERSION_CODES.LOLLIPOP) {
                setTranslucentStatus(true);
                SystemBarTintManager tintManager = new SystemBarTintManager(this);
                tintManager.setStatusBarTintEnabled(true);
                tintManager.setStatusBarTintResource(R.color.transparent);//通知栏所需颜色
            }
        } else {
            setTheme(((MApplication)getApplication()).isNight ? R.style.AppThemeNight : R.style.AppThemeDay);
            // 设置状态栏颜色
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT && Build.VERSION.SDK_INT <= Build.VERSION_CODES.LOLLIPOP) {
                setTranslucentStatus(true);
                SystemBarTintManager tintManager = new SystemBarTintManager(this);
                tintManager.setStatusBarTintEnabled(true);
                tintManager.setStatusBarTintResource(R.color.colorPrimary);//通知栏所需颜色
            }
        }
        setContentView(layoutId);
        unbinder = ButterKnife.bind(this);

        mApp = MApplication.getInstance();
        mLoadingDialog = new LoadingDialog(this);
        if(isInitMVP){
            mPresenter = TUtil.getT(this, 0);
            mModel = TUtil.getT(this, 1);
        }
        if (this instanceof BaseView) mPresenter.setVM(this, mModel);
    }

    @Override
    public void setContentView(@LayoutRes int layoutResID) {
        if (layoutResID == R.layout.activity_main
                || layoutResID == R.layout.activity_login
                || layoutResID == R.layout.activity_spalish
                || layoutResID == R.layout.activity_image_switcher
                || layoutResID == R.layout.activity_guide) {
            super.setContentView(layoutResID);
        } else {
            super.setContentView(getContainer());
            View view = LayoutInflater.from(this).inflate(layoutResID, null);
            view.setBackgroundColor(getResources().getColor(R.color.window_background));
            swipeBackLayout.addView(view);
        }
    }

    protected abstract int getLayoutId();

    private View getContainer() {
        RelativeLayout container = new RelativeLayout(this);
        swipeBackLayout = new SwipeBackLayout(this);
        swipeBackLayout.setDragEdge(SwipeBackLayout.DragEdge.LEFT);
        ivShadow = new ImageView(this);
        ivShadow.setBackgroundColor(getResources().getColor(R.color.theme_black_7f));
        RelativeLayout.LayoutParams params = new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.MATCH_PARENT);
        container.addView(ivShadow, params);
        container.addView(swipeBackLayout);
        swipeBackLayout.setOnSwipeBackListener(new SwipeBackLayout.SwipeBackListener() {
            @Override
            public void onViewPositionChanged(float fractionAnchor, float fractionScreen) {
                ivShadow.setAlpha(1 - fractionScreen);
            }
        });
        return container;
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        unbinder.unbind();
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

    public void reload() {
        ((MApplication)getApplication()).isNight = !((MApplication)getApplication()).isNight;
        Intent intent = getIntent();
        overridePendingTransition(0, 0);
        intent.addFlags(Intent.FLAG_ACTIVITY_NO_ANIMATION);
        finish();
        overridePendingTransition(0, 0);
        startActivity(intent);
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

    public void startActivityWithAnim(Intent intent) {
        startActivity(intent);
        overridePendingTransition(R.anim.activity_animation_in_from_right, R.anim.activity_animation_out_to_left);
    }

    public void startActivityForResultWithAnim(Intent intent, int requestCode) {
        startActivityForResult(intent, requestCode);
        overridePendingTransition(R.anim.activity_animation_in_from_right, R.anim.activity_animation_out_to_left);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
    }

    public void finishWithAnim() {
        finish();
        overridePendingTransition(R.anim.activity_animation_in_from_left, R.anim.activity_animation_out_to_right);
    }

    //重写 onKeyDown方法
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK && event.getAction() == KeyEvent.ACTION_DOWN) {
            finishWithAnim();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }
}
