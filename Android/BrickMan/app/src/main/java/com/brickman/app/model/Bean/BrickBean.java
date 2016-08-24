package com.brickman.app.model.Bean;

import java.io.Serializable;
import java.util.List;

/**
 * Created by mayu on 16/7/20,下午2:38.
 */
public class BrickBean implements Serializable {
    /**
     * id : 3
     * userId : bc09f503b0c943cf9de777edbc7db577
     * contentTitle : test1
     * contentPlace : 北京
     * contentStatus : CONTENT_STS00
     * contentType : CONTENT_TYPE01
     * contentBricks : 2
     * contentFlowors : 2
     * contentShares : 0
     * createdTime : 1469588115000
     * contentReports : 0
     * brickContentAttachmentList : [{"id":1,"contentId":3,"type":"RESOURCE_TYPE01","attachmentPath":"123"},{"id":6,"contentId":3,"type":"sad","attachmentPath":"asdsadsadsd"}]
     * users : {"userId":null,"userAlias":"26摄氏度","userHead":"http://qzapp.qlogo.cn/qzapp/1105593438/C1A39E141323F11A746B57313129D6B9/100","userName":null,"userPhone":null,"userStatus":null,"userSex":null,"motto":null,"plat":null,"platId":null,"token":null}
     */

    public int id;
    public String userId;
    public String contentTitle;
    public String contentPlace;
    public String contentStatus;
    public String contentType;
    public int contentBricks;
    public int contentFlowors;
    public int contentShares;
    public int commmentCount;
    public long createdTime;
    public int contentReports;
    /**
     * userId : null
     * userAlias : 26摄氏度
     * userHead : http://qzapp.qlogo.cn/qzapp/1105593438/C1A39E141323F11A746B57313129D6B9/100
     * userName : null
     * userPhone : null
     * userStatus : null
     * userSex : null
     * motto : null
     * plat : null
     * platId : null
     * token : null
     */

    public UsersBean users;
    /**
     * id : 1
     * contentId : 3
     * type : RESOURCE_TYPE01
     * attachmentPath : 123
     */

    public List<BrickContentAttachmentListBean> brickContentAttachmentList;

    public static class UsersBean implements Serializable {
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
    }

    public static class BrickContentAttachmentListBean implements Serializable {
        public int id;
        public int contentId;
        public String type;
        public String attachmentPath;
    }
    /**
     * id : 4
     * userId : test1
     * contentTitle : test1
     * contentPlace : 北京
     * contentStatus : CONTENT_STS00
     * contentType : CONTENT_TYPE01
     * contentBricks : 1
     * contentFlowors : 0
     * contentShares : 0
     * createdTime : 1469588122000
     * contentReports : 0
     * brickContentAttachmentList : ["123","1234545"]
     */


}
