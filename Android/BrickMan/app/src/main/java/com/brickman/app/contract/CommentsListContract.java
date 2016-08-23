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
        void share(String title, String content, String url, String imgUrl, HttpListener httpListener);
    }

    interface View extends BaseView {
        void loadSuccess(List<CommentBean> commentList, int pageSize, boolean hasMore);
        void commentSuccess();
        void flowerSuccess();
        void shareSuccess();
        void showMsg(String msg);
    }

    abstract class Presenter extends BasePresenter<Model, View> {
        public abstract void loadCommentList(int pageNO, int contentId);
        public abstract void comment(String id, String text, String date);
        public abstract void flower(String id);
        public abstract void share(String title, String content, String url, String imgUrl);
        @Override
        public void onStart() {}
    }
}
