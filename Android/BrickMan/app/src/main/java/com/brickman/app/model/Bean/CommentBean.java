package com.brickman.app.model.Bean;

/**
 * Created by mayu on 16/7/23,下午10:24.
 */
public class CommentBean {


    /**
     * id : 1
     * userId : bc09f503b0c943cf9de777edbc7db577
     * contentId : 1
     * commentContent : 给博尔特点赞
     * createdTime : 1472115077000
     * user : {"userId":"","userAlias":"马老板","userHead":"http://115.28.211.119:2080/head/b2b77e1c7cdb4b5bad79096fa417855d.jpg","userName":"","userPhone":"","userStatus":"","userSex":"","userSexStr":"","motto":"","plat":"","platId":"","token":""}
     */

    public String id;
    public String userId;
    public int contentId;
    public String commentContent;
    public long createdTime;
    /**
     * userId :
     * userAlias : 马老板
     * userHead : http://115.28.211.119:2080/head/b2b77e1c7cdb4b5bad79096fa417855d.jpg
     * userName :
     * userPhone :
     * userStatus :
     * userSex :
     * userSexStr :
     * motto :
     * plat :
     * platId :
     * token :
     */

    public UserBean user;

    public static class UserBean {
        public String userId;
        public String userAlias;
        public String userHead;
        public String userName;
        public String userPhone;
        public String userStatus;
        public String userSex;
        public String userSexStr;
        public String motto;
        public String plat;
        public String platId;
        public String token;
    }
}
