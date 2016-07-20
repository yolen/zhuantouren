package com.brickman.app.ui.widget.view;

import android.content.Context;
import android.util.AttributeSet;
import android.widget.ListView;

/**
 * 适应ScrollView的ListView
 * 
 * @author mayu
 *
 */
public class MyListView extends ListView {

	public MyListView(Context context) {
		super(context);
	}

	public MyListView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public MyListView(Context context, AttributeSet attrs, int defStyleAttr) {
		super(context, attrs, defStyleAttr);
	}

	/**
	 * 重写该方法，达到使ListView适应ScrollView的效果
	 * 
	 * @author mayu
	 */
	@Override
	protected void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2,
				MeasureSpec.AT_MOST);
		super.onMeasure(widthMeasureSpec, expandSpec);
	}
}
