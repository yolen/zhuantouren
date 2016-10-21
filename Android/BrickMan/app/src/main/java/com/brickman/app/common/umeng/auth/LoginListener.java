package com.brickman.app.common.umeng.auth;

import java.util.Map;

/**
 * Created by mayu on 15/8/11,上午10:59.
 */
public interface LoginListener {
    void success(String access_token, String openid, Map<String, Object> info);
}
