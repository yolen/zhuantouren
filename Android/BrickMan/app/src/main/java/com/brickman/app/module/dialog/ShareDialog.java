package com.brickman.app.module.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.widget.LinearLayout.LayoutParams;

import com.brickman.app.R;
import com.brickman.app.common.umeng.ShareContent;
import com.brickman.app.common.umeng.UMSdkManager;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.bean.SocializeEntity;
import com.umeng.socialize.controller.UMServiceFactory;
import com.umeng.socialize.controller.listener.SocializeListeners;

/**
 * 分享对话框
 * @author mayu
 *
 */
public class ShareDialog extends Dialog implements
		View.OnClickListener {
    private UMSdkManager mUMSdkManager;
	private Context mContext;
	private OnShareListener mListener;

    private ShareContent mShareContent;

	public ShareDialog(Context context, ShareContent shareContent, OnShareListener listener) {
		super(context, R.style.CommonDialog);
		this.mContext = context;
		this.mListener = listener;
        this.mShareContent = shareContent;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		Window window = this.getWindow();
		window.setGravity(Gravity.BOTTOM); 
		window.setWindowAnimations(R.style.dialogstyle); 
		DisplayMetrics dm = new DisplayMetrics();
		((Activity) mContext).getWindowManager().getDefaultDisplay().getMetrics(dm);
		int width = dm.widthPixels;
		LayoutParams params = new LayoutParams(width, android.view.ViewGroup.LayoutParams.WRAP_CONTENT);
		setCancelable(true);
		setCanceledOnTouchOutside(true);
		
		LayoutInflater li = (LayoutInflater)mContext.getSystemService(Activity.LAYOUT_INFLATER_SERVICE);
	    View view = li.inflate(R.layout.dialog_share, null);
		setContentView(view, params);

        mUMSdkManager = UMSdkManager.init((Activity) mContext, UMServiceFactory.getUMSocialService(UMSdkManager.SHARE));
        mUMSdkManager.setShareContent((Activity) mContext, mShareContent);

		findViewById(R.id.btnWX).setOnClickListener(this);
		findViewById(R.id.btnFriend).setOnClickListener(this);
		findViewById(R.id.btnQQ).setOnClickListener(this);
		findViewById(R.id.btnQZone).setOnClickListener(this);

		findViewById(R.id.cancel).setOnClickListener(this);
	}
	
	@Override
	public void onClick(View v) {
		switch (v.getId()) {
			case R.id.btnWX:
                share(SHARE_MEDIA.WEIXIN);
				break;
			case R.id.btnFriend:
                share(SHARE_MEDIA.WEIXIN_CIRCLE);
				break;
			case R.id.btnQZone:
                share(SHARE_MEDIA.QZONE);
				break;
			case R.id.btnQQ:
				share(SHARE_MEDIA.QQ);
				break;
			case R.id.cancel:
//				mListener.result(false);
				dismiss();
				break;
			default:
				break;
		}
	}

    private void share(SHARE_MEDIA media){
        mUMSdkManager.share((Activity) mContext, media, new SocializeListeners.SnsPostListener() {
            @Override
            public void onStart() {

            }

            @Override
            public void onComplete(SHARE_MEDIA share_media, int stCode, SocializeEntity socializeEntity) {
                if (stCode == 200) {
					if(share_media == SHARE_MEDIA.QQ){
					} else if(share_media == SHARE_MEDIA.QZONE){
					} else if(share_media == SHARE_MEDIA.WEIXIN){
					} else if(share_media == SHARE_MEDIA.WEIXIN_CIRCLE){
					} else if(share_media == SHARE_MEDIA.SINA){
					}
                    mListener.result(true);
                } else {
                    mListener.result(false);
                }
            }
        });
		dismiss();
    }

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if(keyCode == KeyEvent.KEYCODE_BACK){
			dismiss();
			return false;
		} else {
			return super.onKeyDown(keyCode, event);
		}
	}

	public interface OnShareListener{
        void result(boolean result);
	}
}
