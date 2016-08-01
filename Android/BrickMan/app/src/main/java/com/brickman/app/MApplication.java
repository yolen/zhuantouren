package com.brickman.app;

import android.app.Application;

import com.brickman.app.common.glide.GlideImageLoader;
import com.brickman.app.common.glide.GlidePauseOnScrollListener;
import com.orhanobut.logger.Logger;
import com.yolanda.nohttp.NoHttp;

import cn.finalteam.galleryfinal.CoreConfig;
import cn.finalteam.galleryfinal.FunctionConfig;
import cn.finalteam.galleryfinal.GalleryFinal;
import cn.finalteam.galleryfinal.ThemeConfig;

/**
 * Created by mayu on 16/7/14,上午9:56.
 */
public class MApplication extends Application {
    public static MApplication mAppContext;

    @Override
    public void onCreate() {
        super.onCreate();
        mAppContext = this;
        //配置程序异常退出处理
//        Thread.setDefaultUncaughtExceptionHandler(new LocalFileHandler(this));
        Logger.init("BRICK_MAN");
        NoHttp.initialize(this);

        //设置主题
        ThemeConfig theme = new ThemeConfig.Builder()
                .setCheckNornalColor(getResources().getColor(R.color.light_gray))
                .setCheckSelectedColor(getResources().getColor(R.color.colorAccent))
                .setCropControlColor(getResources().getColor(R.color.colorAccent))
                .setTitleBarBgColor(getResources().getColor(R.color.colorAccent))
                .setTitleBarTextColor(getResources().getColor(R.color.white))
                .setTitleBarIconColor(getResources().getColor(R.color.white))
                .setFabNornalColor(getResources().getColor(R.color.colorAccent))
                .setFabPressedColor(getResources().getColor(R.color.colorPrimaryDark))
                .build();
//        //配置功能
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

    public static MApplication getInstance() {
        return mAppContext;
    }
}
