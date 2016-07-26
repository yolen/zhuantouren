package com.brickman.app.contract;

import com.brickman.app.common.base.BaseModel;
import com.brickman.app.common.base.BasePresenter;
import com.brickman.app.common.base.BaseView;

/**
 * Created by mayu on 16/7/26,上午9:53.
 */

public interface UserInfoContract {
    interface Model extends BaseModel {
        void updateAvator(String avatorUri);
        void updateNickName(String nickName);
        void updateSexy(String sexy);
        void updatePassword(String password);
        void updateMotto(String motto);
    }

    interface View extends BaseView {
        void updateAvatorSuccess(String avatorUrl);
        void updateNickNameSuccess(String nickName);
        void updateSexySuccess(String sexy);
        void updatePasswordSuccess(String password);
        void updateMottoSuccess(String motto);
        void showMsg(String msg);
    }

    abstract class Presenter extends BasePresenter<Model, View> {
        public abstract void updateAvator(String avatorUri);
        public abstract void updateNickName(String nickName);
        public abstract void updateSexy(String sexy);
        public abstract void updatePassword(String password);
        public abstract void updateMotto(String motto);
        @Override
        public void onStart() {}
    }
}
