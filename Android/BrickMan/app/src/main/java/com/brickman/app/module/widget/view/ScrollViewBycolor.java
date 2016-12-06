package com.brickman.app.module.widget.view;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ScrollView;

/**
 * Created by zhangshiyu on 2016/12/6.
 */

public class ScrollViewBycolor extends ScrollView {
    public interface ScrollViewListener {

        void onScrollChanged(ScrollViewBycolor scrollView, int x, int y,
                             int oldx, int oldy);

    }

    private ScrollViewListener scrollViewListener = null;

    public ScrollViewBycolor(Context context) {
        super(context);
    }

    public ScrollViewBycolor(Context context, AttributeSet attrs,
                                int defStyle) {
        super(context, attrs, defStyle);
    }

    public ScrollViewBycolor(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public void setScrollViewListener(ScrollViewListener scrollViewListener) {
        this.scrollViewListener = scrollViewListener;
    }

    @Override
    protected void onScrollChanged(int x, int y, int oldx, int oldy) {
        super.onScrollChanged(x, y, oldx, oldy);
        if (scrollViewListener != null) {
            scrollViewListener.onScrollChanged(this, x, y, oldx, oldy);
        }
    }
}
