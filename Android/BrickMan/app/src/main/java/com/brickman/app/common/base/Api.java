package com.brickman.app.common.base;

/**
 * Created by mayu on 16/7/18,下午3:20.
 */
public interface Api {
    String KEY = "53b4be63fac688e0";
    String BASE_URL = "http://115.28.211.119:1080";
    String IMG_URL = "http://115.28.211.119:2080/";
    String REQUEST_BANNER = BASE_URL + "/DEMO_BANNER.json";
    // 登录接口
    String REQUEST_LOGIN = BASE_URL + "/user/auth_login.json";
    // 列表接口
    String REQUEST_BRICKLIST = BASE_URL + "/content/list_content.json";
    // 列表详情接口
    String REQUEST_CONTENT_DETAIL = BASE_URL + "/content/detail_content.json";
    // 发布接口
    String REQUEST_PUBLISH = BASE_URL + "/content/add_content.do";

    String REQUEST_FLOWERLIST = BASE_URL + "/DEMO_FlOWER_LIST.json";
    String REQUEST_BRICKSLIST = BASE_URL + "/DEMO_BRICKS_LIST.json";
    // 评论列表接口
    String REQUEST_DETAIL_LIST = BASE_URL + "/comment/list_comments.json";
    // 评论接口
    String REQUEST_DETAIL_COMMENT = BASE_URL + "/comment/add_comment.json";
    // 上传图片接口
    String UPLOAD_FILES = BASE_URL + "/upload/upload_file.do";
    // 上传头像接口
    String UPLOAD_AVATOR = BASE_URL + "/upload/upload_user_head.do";
    // 更改用户信息
    String UPDATE_USERINFO = BASE_URL + "/user/update_user_info.do";


    // 登录成功
    String ACTION_LOGIN = "com.brickman.app.action.login";
    // 用户信息变更
    String ACTION_USERINFO = "com.brickman.app.action.userinfo";
}