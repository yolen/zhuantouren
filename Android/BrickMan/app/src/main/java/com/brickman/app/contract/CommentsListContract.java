package com.brickman.app.contract;

import com.brickman.app.common.base.BaseModel;
import com.brickman.app.common.base.BasePresenter;
import com.brickman.app.common.base.BaseView;
import com.brickman.app.common.http.HttpListener;
import com.brickman.app.model.Bean.CommentBean;

import java.util.List;

/**
 * Created by mayu on 16/7/18,下午1:29.
 */
public interface CommentsListContract {
    interface Model extends BaseModel {
        void loadCommentsList(int pageNO, int contentId, HttpListener httpListener);
        void comment(String id, String text, String date, HttpListener httpListener);
        void flower(String id, HttpListener httpListener);
        void brick(String id, HttpListener httpListener);
        void report(String id, HttpListener httpListener);
    }

    interface View extends BaseView {
        void loadSuccess(List<CommentBean> commentList, int pageSize, boolean hasMore);
        void commentSuccess();
        void flowerSuccess();
        void brickSuccess();
        void reportSuccess();
        void shareSuccess();
        void showMsg(String msg);
    }

    abstract class Presenter extends BasePresenter<Model, View> {
        public abstract void loadCommentList(int pageNO, int contentId);
        public abstract void comment(String id, String text, String date);
        public abstract void flower(String id);
        public abstract void brick(String id);
        public abstract void report(String id);
        @Override
        public void onStart() {}
    }
}
