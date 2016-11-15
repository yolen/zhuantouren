package com.brickman.app.common.base;

/**
 * Created by mayu on 16/7/18,下午3:20.
 */
public interface Api {

    String FIRST_OPEN = "first_open";

    String KEY = "53b4be63fac688e0";
    // 测试
//    String BASE_URL = "http://123.57.63.161";
    String BASE_URL="http://dev.brickman.cn";
    /**
     * 生产
     */
//    String BASE_URL = "http://115.28.16.51";
    String IMG_URL = "http://dev.img.brickman.cn/" ;//+ ":2080/";
    String IMG_COMPRESS_URL = IMG_URL + "compress/";

    // ------------GET--------------
    // 首页轮播接口【1启动页广告 || 2首页banner广告 || 3 中间上部相机广告 || 4 中间下部公益广告】
    String GET_BANNER = BASE_URL + "/advertisement/advertisement_list_by_type.json";

    // 登录接口
    String POST_LOGIN = BASE_URL + "/user/auth_login.json";
    // 列表接口
    String GET_BRICKLIST = BASE_URL + "/content/list_content.json";
    //刷新消息
    String FLUSH_MESSAGE=BASE_URL+"/notify/pull_remind.do";
    //获取消息列表
    String GET_MESSSAGELIST=BASE_URL+"/notify/user_notify_list.do";
    // 列表接口【内容列表按评论数量排序】
    String GET_BRICKLIST_BY_COMMENT = BASE_URL + "/content/content_list_by_comments_count.json";
    // 用户发布列表
    String GET_USER_BRICKLIST = BASE_URL + "/user/user_content_list.json";
    // 列表详情接口
    String GET_CONTENT_DETAIL = BASE_URL + "/content/detail_content.json";
    // 鲜花列表
    String GET_FLOWERLIST = BASE_URL + "/user/top_users.json";
    // 砖头列表
    String GET_BRICKSLIST = BASE_URL + "/user/top_users.json";
    // 评论列表接口
    String GET_DETAIL_LIST = BASE_URL + "/comment/list_comments.json";

    // ------------POST--------------

    //用户名密码登录
    String LOGIN=BASE_URL+"/user/login.json";
    // 发布接口
    String POST_PUBLISH = BASE_URL + "/content/add_content.do";
    // 评论接口
    String POST_DETAIL_COMMENT = BASE_URL + "/comment/add_comment.do";
    // 鲜花，拍砖，举报【1\2\3】
    String POST_DETAIL_DO = BASE_URL + "/content/oper_content.do";
    // 上传图片接口
    String UPLOAD_FILES = BASE_URL + "/upload/upload_file.do";
    // 上传头像接口
    String UPLOAD_AVATOR = BASE_URL + "/upload/upload_user_head.do";
    // 更改用户信息
    String UPDATE_USERINFO = BASE_URL + "/user/update_user_info.do";
    // 分享回调
    String SHARE_UPDATE_COUNT = BASE_URL + "/content/add_share_count.json";
    // 分享页面
    String SHARE_BRICKMAN_PAGE = BASE_URL + "/index.html?contentId=";

    // 头条
    String TOP_URL = "http://v.juhe.cn/toutiao/index";


    // -------------H5----------------
    //关于我们
    String ABOUT_US = IMG_URL + "html/brickman.html";
    //反馈我们 http://dev.img.brickman.cn/html/brickmanback.html
    String  FEEDBACK_US=IMG_URL+"html/brickmanback.html";
    // 登录成功
    String ACTION_LOGIN = "com.brickman.app.action.login";
    // 用户信息变更
    String ACTION_USERINFO = "com.brickman.app.action.userinfo";
    // 检查更新
    String APP_UPDATE_SERVER_URL = BASE_URL + "/checkVersion.json";
}