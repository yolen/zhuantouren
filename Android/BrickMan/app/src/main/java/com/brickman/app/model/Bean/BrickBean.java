package com.brickman.app.model.Bean;

import java.io.Serializable;
import java.util.List;

/**
 * Created by mayu on 16/7/20,下午2:38.
 */
public class BrickBean implements Serializable {

    /**
     * id : a-------------
     * userId : abc
     * avator : http://img.zcool.cn/community/031d424578e22910000018c1ba8bdb6.jpg@500w_376h_1c_1e_1l_2o
     * name : 砖头人0
     * date : 2016-07-22 09:23
     * address : 苏州观前街
     * content : 人生应该如蜡烛一样，从顶燃到底，一直都是光明的。身边总有那么些好人好事，让生活更美好！
     * commentNum : 34
     * flowerNum : 47
     * shareNum : 23
     * isReport : false
     * images : ["http://img.zcool.cn/community/031d424578e22910000018c1ba8bdb6.jpg@500w_376h_1c_1e_1l_2o","http://img.zcool.cn/community/0318ddd578e0c4c0000012e7ed38ba2.jpg@500w_376h_1c_1e_1l_2o","http://img.zcool.cn/community/031f900578c3b9e0000012e7e19e524.jpg@500w_376h_1c_1e_1l_2o"]
     */

    public String id;
    public String userId;
    public String avator;
    public String name;
    public String date;
    public String address;
    public String content;
    public String commentNum;
    public String flowerNum;
    public String shareNum;
    public boolean isReport;
    public List<String> images;
}
