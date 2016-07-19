package com.brickman.app.common.base;


/**
 * Created by baixiaokang on 16/4/22.
 */
public abstract class BasePresenter<E, T> {
    public E mModel;
    public T mView;

    public void setVM(T v, E m) {
        this.mView = v;
        this.mModel = m;
        this.onStart();
    }

    public abstract void onStart();

}
