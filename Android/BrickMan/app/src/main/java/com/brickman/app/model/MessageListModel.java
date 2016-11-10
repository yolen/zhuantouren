package com.brickman.app.model;

import android.support.annotation.NonNull;

import com.brickman.app.common.http.HttpListener;
import com.brickman.app.contract.MessageContract;

import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

/**
 * Created by zhangshiyu on 2016/11/10.
 */

public class MessageListModel implements MessageContract.Model{
    private List<String> list=new ArrayList<>();
    public MessageListModel(){

        for (int i=0;i<50;i++){
            list.add("我是第"+i+"条数据");
        }
    }
    @Override
    public void loadMessageList( int pageNO, HttpListener httpListener) {
        List<String> data=null;
        switch (pageNO){
            case 1:
              data=list.subList(0,10);
                break;
            case 2:
                data=list.subList(10,20);
                break;
            case 3:
                data=list.subList(20,30);
                break;
            case 4:
                data=list.subList(30,40);
                break;
            case 5:
                data=list.subList(40,50);
                break;
        }
        httpListener.onSucceed(data);
    }

}
