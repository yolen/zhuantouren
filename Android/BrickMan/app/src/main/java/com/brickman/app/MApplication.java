package com.brickman.app;

import android.app.Application;

import com.brickman.app.common.exception.LocalFileHandler;
import com.orhanobut.logger.Logger;

/**
 * Created by mayu on 16/7/14,上午9:56.
 */
public class MApplication extends Application {
    @Override
    public void onCreate() {
        super.onCreate();
        //配置程序异常退出处理
        Thread.setDefaultUncaughtExceptionHandler(new LocalFileHandler(this));
        Logger.init("BRICK_MAN");
    }
}
