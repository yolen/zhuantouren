package com.brickman.app.model.Bean;

import java.io.Serializable;
import java.util.List;

/**
 * Created by mayu on 16/9/9,下午5:13.
 */
public class BrickDetailBean implements Serializable{


    /**
     * id : 55
     * userId : 79feed78831c4e0bb2c4b0c2d04cf8ec
     * contentTitle : 年空军建军节
     * contentPlace : 北京市东城区大阮府胡同靠近北京农村产权交易所
     * contentStatus : CONTENT_STS00
     * contentBricks : 1
     * contentFlowors : 1
     * contentShares : 0
     * createdTime : 1473408816000
     * contentReports : 1
     * brickContentAttachmentList : [{"id":0,"contentId":0,"type":"","attachmentPath":"event/20160909/9144ec061d4a41b8af0e550ea144b543.jpg"}]
     * users : {"userId":"","userAlias":"orton","userHead":"http://115.28.211.119:2080/head/311fb322e29141d58b42225a14a12b86.jpg","userName":"","userPhone":"","userStatus":"","userSex":"","userSexStr":"","motto":"","plat":"","platId":"","token":""}
     * commentCount : 1
     * brickContentCommentList : [{"id":"133","userId":"79feed78831c4e0bb2c4b0c2d04cf8ec","contentId":55,"commentContent":"你好","createdTime":1473409130000,"user":{"userId":"","userAlias":"orton","userHead":"http://115.28.211.119:2080/head/311fb322e29141d58b42225a14a12b86.jpg","userName":"","userPhone":"","userStatus":"","userSex":"","userSexStr":"","motto":"","plat":"","platId":"","token":""}}]
     */

    public int id;
    public String userId;
    public String contentTitle;
    public String contentPlace;
    public String contentStatus;
    public int contentBricks;
    public int contentFlowors;
    public int contentShares;
    public long createdTime;
    public int contentReports;
    /**
     * userId :
     * userAlias : orton
     * userHead : http://115.28.211.119:2080/head/311fb322e29141d58b42225a14a12b86.jpg
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

    public UsersBean users;
    public int commentCount;
    /**
     * id : 0
     * contentId : 0
     * type :
     * attachmentPath : event/20160909/9144ec061d4a41b8af0e550ea144b543.jpg
     */

    public List<BrickContentAttachmentListBean> brickContentAttachmentList;
    /**
     * id : 133
     * userId : 79feed78831c4e0bb2c4b0c2d04cf8ec
     * contentId : 55
     * commentContent : 你好
     * createdTime : 1473409130000
     * user : {"userId":"","userAlias":"orton","userHead":"http://115.28.211.119:2080/head/311fb322e29141d58b42225a14a12b86.jpg","userName":"","userPhone":"","userStatus":"","userSex":"","userSexStr":"","motto":"","plat":"","platId":"","token":""}
     */

    public List<BrickContentCommentListBean> brickContentCommentList;

    public static class UsersBean {
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

    public static class BrickContentAttachmentListBean {
        public int id;
        public int contentId;
        public String type;
        public String attachmentPath;
    }

    public static class BrickContentCommentListBean {
        public String id;
        public String userId;
        public int contentId;
        public String commentContent;
        public long createdTime;
        /**
         * userId :
         * userAlias : orton
         * userHead : http://115.28.211.119:2080/head/311fb322e29141d58b42225a14a12b86.jpg
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
}
