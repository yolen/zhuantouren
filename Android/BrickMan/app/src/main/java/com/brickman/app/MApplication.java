package com.brickman.app;

import android.app.ActivityManager;
import android.app.Application;
import android.content.ComponentName;
import android.content.Context;
import android.os.Environment;
import android.util.Log;

import com.brickman.app.common.data.DataKeeper;
import com.brickman.app.common.data.cipher.Base64Cipher;
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

    /** 首先默认个文件保存路径 */
    public static final String SAVE_PATH= Environment.getExternalStorageState().equalsIgnoreCase(Environment.MEDIA_MOUNTED) ? Environment.getExternalStorageDirectory().getAbsolutePath() : "/mnt/sdcard";//保存到SD卡
    public static final String SAVE_PIC_PATH = SAVE_PATH+ "/brickman/savePic";//保存的确切位置

    public static MApplication mAppContext;
    public static DataKeeper mDataKeeper;
    public UserBean mUser;
    public boolean isNight = false;
    private long start,end;
    @Override
    protected void attachBaseContext(Context base) {
        super.attachBaseContext(base);
        start=System.currentTimeMillis();
        Log.e("stime","startime"+start);
    }


    @Override
    public void onCreate() {
        super.onCreate();
        mAppContext = this;
        new Thread(new Runnable() {
            @Override
            public void run() {
                Log.e("stime","starttime"+System.currentTimeMillis());
                //配置程序异常退出处理
//        Thread.setDefaultUncaughtExceptionHandler(new LocalFileHandler(this));
                Logger.init("BRICK_MAN");
                com.yolanda.nohttp.Logger.setTag("NoHttpSample");
                com.yolanda.nohttp.Logger.setDebug(true);// 开始NoHttp的调试模式, 这样就能看到请求过程和日志
                mDataKeeper = new DataKeeper(mAppContext, "BRICK_MAN");
                mUser = (UserBean) mDataKeeper.get("user_info");
                NoHttp.initialize(mAppContext);
                NoHttp.setEnableCache(true);
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
                CoreConfig coreConfig = new CoreConfig.Builder(mAppContext, new GlideImageLoader(), theme)
                        .setFunctionConfig(functionConfig)
                        .setPauseOnScrollListener(new GlidePauseOnScrollListener(false, true))
                        .build();
                GalleryFinal.init(coreConfig);
                end=System.currentTimeMillis();
                Log.e("stime","endtime"+end+"耗时"+(end-start));

            }
        }).start();
        Log.e("stime","endtime"+System.currentTimeMillis());

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

    public static void setLocation(String city, String address){
        mDataKeeper.put("city", city);
        mDataKeeper.put("address", address);
    }

    public static String getCity(){
        return mDataKeeper.get("city", "北京");
    }

    public static String getAddress(){
        return mDataKeeper.get("address", "北京");
    }
}
