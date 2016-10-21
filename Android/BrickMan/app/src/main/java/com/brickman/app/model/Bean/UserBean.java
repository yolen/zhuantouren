package com.brickman.app.model.Bean;

import java.io.Serializable;

/**
 * Created by mayu on 16/8/18,下午3:07.
 */

public class UserBean implements Serializable {

    /**
     * userId : bc09f503b0c943cf9de777edbc7db577
     * userAlias : 26摄氏度
     * userHead : http://qzapp.qlogo.cn/qzapp/1105593438/C1A39E141323F11A746B57313129D6B9/100
     * userName : null
     * userPhone : null
     * userStatus : null
     * userSex : USER_SEX01
     * motto : null
     * plat : PLAT_TYPE01
     * platId : C1A39E141323F11A746B57313129D6B9
     * token : de224d65688e4b5fa811772608ba9387
     */

    public String userId;
    public String userAlias;
    public String userHead;
    public String userName;
    public String userPhone;
    public String userStatus;
    public String userSex;
    public String motto;
    public String plat;
    public String platId;
    public String token;

    @Override
    public String toString() {
        return "UserBean{" +
                "userId='" + userId + '\'' +
                ", userAlias='" + userAlias + '\'' +
                ", userHead='" + userHead + '\'' +
                ", userName=" + userName +
                ", userPhone=" + userPhone +
                ", userStatus=" + userStatus +
                ", userSex='" + userSex + '\'' +
                ", motto=" + motto +
                ", plat='" + plat + '\'' +
                ", platId='" + platId + '\'' +
                ", token='" + token + '\'' +
                '}';
    }

    public String getUserSex(){
        return userSex.equals("USER_SEX01") ? "男" : "女";
    }

    public void setUserSex(String sexy){
        userSex = sexy;
    }
}
