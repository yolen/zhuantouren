package com.brickman.app;

import android.app.Application;

import com.orhanobut.logger.Logger;

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
    }

    public static MApplication getInstance(){
        return  mAppContext;
    }
}
