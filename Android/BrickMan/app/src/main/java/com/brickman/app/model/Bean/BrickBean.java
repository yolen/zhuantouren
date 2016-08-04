package com.brickman.app.model.Bean;

import java.io.Serializable;
import java.util.List;

/**
 * Created by mayu on 16/7/20,下午2:38.
 */
public class BrickBean implements Serializable {
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

    public int id;
    public String userId;
    public String contentTitle;
    public String contentPlace;
    public String contentStatus;
    public String contentType;
    public int contentBricks;
    public int contentFlowors;
    public int contentShares;
    public long createdTime;
    public int contentReports;
    public List<String> brickContentAttachmentList;
}
