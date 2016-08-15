package com.brickman.app.common.base;

/**
 * Created by mayu on 16/7/18,下午3:20.
 */
public interface Api {
    String KEY = "53b4be63fac688e0";
    String BASE_URL = "http://115.28.211.119:1080";
    String REQUEST_BANNER = BASE_URL + "/DEMO_BANNER.json";
    String REQUEST_BRICKLIST = BASE_URL + "/content/content_list.json";
    String REQUEST_FLOWERLIST = BASE_URL + "/DEMO_FlOWER_LIST.json";
    String REQUEST_BRICKSLIST = BASE_URL + "/DEMO_BRICKS_LIST.json";
    String REQUEST_DETAIL_SLIST = BASE_URL + "/DEMO_COMMENT_LIST.json";
    String UPLOAD_FILES = BASE_URL + "/upload.json";
    String PUBLISH_BRICK = BASE_URL + "/upload.json";
}


//Luban.get(this)
//        .load(File)                     //传人要压缩的图片
//        .putGear(Luban.THIRD_GEAR)      //设定压缩档次，默认三挡
//        .setCompressListener(new OnCompressListener() { //设置回调
//
//@Override
//public void onStart() {
//        //TODO 压缩开始前调用，可以在方法内启动 loading UI
//        }
//@Override
//public void onSuccess(File file) {
//        //TODO 压缩成功后调用，返回压缩后的图片文件
//        }
//
//@Override
//public void onError(Throwable e) {
//        //TODO 当压缩过去出现问题时调用
//        }
//        }).launch();    //启动压缩