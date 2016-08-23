package com.brickman.app;

import android.app.ActivityManager;
import android.app.Application;
import android.content.ComponentName;
import android.content.Context;

import com.brickman.app.common.data.DataKeeper;
import com.brickman.app.common.glide.GlideImageLoader;
import com.brickman.app.common.glide.GlidePauseOnScrollListener;
import com.brickman.app.model.Bean.UserBean;
import com.orhanobut.logger.Logger;
import com.yolanda.nohttp.NoHttp;

import java.util.List;

import cn.finalteam.galleryfinal.CoreConfig;
import cn.finalteam.galleryfinal.FunctionConfig;
import cn.finalteam.galleryfinal.GalleryFinal;
import cn.finalteam.galleryfinal.ThemeConfig;

/**
 * Created by mayu on 16/7/14,上午9:56.
 */
public class MApplication extends Application {
    public static MApplication mAppContext;
    public static DataKeeper mDataKeeper;
    public UserBean mUser;
    public boolean isNight = false;
    @Override
    public void onCreate() {
        super.onCreate();
        mAppContext = this;
        //配置程序异常退出处理
//        Thread.setDefaultUncaughtExceptionHandler(new LocalFileHandler(this));
        Logger.init("BRICK_MAN");
        mDataKeeper = new DataKeeper(this, "BRICK_MAN");
        mUser = (UserBean) mDataKeeper.get("user_info");
        NoHttp.initialize(this);

        //设置主题
        ThemeConfig theme = new ThemeConfig.Builder()
                .setCheckNornalColor(getResources().getColor(R.color.light_gray))
                .setCheckSelectedColor(getResources().getColor(R.color.dark_green))
                .setCropControlColor(getResources().getColor(R.color.white))
                .setTitleBarBgColor(getResources().getColor(R.color.colorAccent))
                .setTitleBarTextColor(getResources().getColor(R.color.white))
                .setTitleBarIconColor(getResources().getColor(R.color.white))
                .setFabNornalColor(getResources().getColor(R.color.colorAccent))
                .setFabPressedColor(getResources().getColor(R.color.colorPrimaryDark))
                .build();
        //配置功能
        FunctionConfig functionConfig = new FunctionConfig.Builder()
                .setEnableCamera(true)
                .setEnableEdit(true)
                .setEnableCrop(true)
                .setEnableRotate(true)
                .setCropSquare(true)
                .setEnablePreview(true)
                .build();
        CoreConfig coreConfig = new CoreConfig.Builder(this, new GlideImageLoader(), theme)
                .setFunctionConfig(functionConfig)
                .setPauseOnScrollListener(new GlidePauseOnScrollListener(false, true))
                .build();
        GalleryFinal.init(coreConfig);
    }

    public static MApplication getInstance(){
        return mAppContext;
    }

    /**
     * 获取服务是否开启
     * @param className 完整包名的服务类名
     */
    public static boolean isRunningService(String className, Context context) {
        // 进程的管理者,活动的管理者
        ActivityManager activityManager = (ActivityManager)
                context.getSystemService(Context.ACTIVITY_SERVICE);
        // 获取正在运行的服务，最多获取1000个
        List<ActivityManager.RunningServiceInfo> runningServices = activityManager.getRunningServices(1000);
        // 遍历集合
        for (ActivityManager.RunningServiceInfo runningServiceInfo : runningServices) {
            ComponentName service = runningServiceInfo.service;
            if (className.equals(service.getClassName())) {
                return true;
            }
        }
        return false;
    }
}
