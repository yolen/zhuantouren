package com.brickman.app.common.umeng;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;

import com.brickman.app.R;
import com.brickman.app.common.utils.LogUtil;
import com.umeng.socialize.bean.SHARE_MEDIA;
import com.umeng.socialize.controller.UMSocialService;
import com.umeng.socialize.controller.listener.SocializeListeners;
import com.umeng.socialize.media.QQShareContent;
import com.umeng.socialize.media.QZoneShareContent;
import com.umeng.socialize.media.SinaShareContent;
import com.umeng.socialize.media.UMImage;
import com.umeng.socialize.sso.QZoneSsoHandler;
import com.umeng.socialize.sso.UMQQSsoHandler;
import com.umeng.socialize.sso.UMSsoHandler;
import com.umeng.socialize.weixin.controller.UMWXHandler;
import com.umeng.socialize.weixin.media.CircleShareContent;
import com.umeng.socialize.weixin.media.WeiXinShareContent;


/**
 * Umeng分享、第三方登录、自动更新 Created by mayu on 15/8/11,上午10:07.
 */
public class UMSdkManager {
	private static Activity mAct;
	private static UMSdkManager umSdkManager;
	public static final String SHARE = "com.umeng.share";
	public static UMSocialService mController;

	public UMSdkManager(Activity act, UMSocialService controller) {
		UMSdkManager.mAct = act;
		UMSdkManager.mController = controller;
	}

	public static UMSdkManager init(Activity act, UMSocialService controller) {
		if (umSdkManager == null) {
			umSdkManager = new UMSdkManager(act, controller);
			umSdkManager.configPlatforms(controller);
		}
		return umSdkManager;
	}

	/**
	 * isWXAppInstalledAndSupported(mAct)
	 * 
	 * @param context
	 * @return
	 */
	public static boolean isWXAppInstalledAndSupported(Context context) {
		try {
			boolean isWxInstalled = context.getPackageManager().getPackageInfo("com.tencent.mm", PackageManager.GET_ACTIVITIES) != null;
			if (!isWxInstalled)
				LogUtil.info("~~~~~~~~~~~~~~微信客户端未安装，请确认");
			return isWxInstalled;
		} catch (NameNotFoundException e) {
			LogUtil.error("UMSdkManager", e);
			return false;
		}
	}

	/**
	 * 配置分享平台参数
	 */
	public void configPlatforms(UMSocialService controller) {
		// 添加新浪sso授权
//		mController.getConfig().setSsoHandler(new SinaSsoHandler());
		// 添加QQ、QZone平台
		addQQQZonePlatform(mAct);
		// 添加微信、微信朋友圈平台
		addWXPlatform(mAct);
	}

	/**
	 * 如果有使用任一平台的SSO授权, 则必须在对应的activity中实现onActivityResult方法, 并添加如下代码
	 * 
	 * @param requestCode
	 * @param resultCode
	 * @param data
	 */
	public static void onActivityResult(int requestCode, int resultCode, Intent data) {
		// 根据requestCode获取对应的SsoHandler
		/**使用SSO授权必须添加如下代码 */
		if(mController != null){
			UMSsoHandler ssoHandler = mController.getConfig().getSsoHandler(requestCode);
			if(ssoHandler != null){
				ssoHandler.authorizeCallBack(requestCode, resultCode, data);
			}
		}
	}

	/**
	 * 分享
	 * 
	 * @param act
	 * @param media
	 *            【SHARE_MEDIA.WEIXIN | SHARE_MEDIA.WEIXIN_CIRCLE |
	 *            SHARE_MEDIA.QZONE | SHARE_MEDIA.SINA】
	 * @param mShareListener
	 */
	public void share(Activity act, SHARE_MEDIA media, SocializeListeners.SnsPostListener mShareListener) {
		mController.directShare(act, media, mShareListener);
	}

	/**
	 * 根据不同的平台设置不同的分享内容</br>
	 */
	public void setShareContent(Activity act, ShareContent share) {
		UMImage urlImage = null;
		if (share.getShareImage() != null) {
			urlImage = share.getShareImage();
		} else {
			urlImage = new UMImage(act, R.mipmap.ic_launcher);
		}

		/** 1.设置微信好友分享的内容 */
		WeiXinShareContent weixinContent = new WeiXinShareContent();
		weixinContent.setShareContent(share.getShareContent());
		weixinContent.setTitle(share.getShareTitle());
		weixinContent.setTargetUrl(share.getTargetUrl());
		weixinContent.setShareMedia(urlImage);
		mController.setShareMedia(weixinContent);

		/** 2.设置朋友圈分享的内容 */
		CircleShareContent circleMedia = new CircleShareContent();
		circleMedia.setShareContent(share.getShareContent());
		circleMedia.setTitle(share.getShareTitle());
		circleMedia.setShareImage(urlImage);
		circleMedia.setTargetUrl(share.getTargetUrl());
		mController.setShareMedia(circleMedia);

		/** 3.设置QQ空间分享内容 */
		QZoneShareContent qzone = new QZoneShareContent();
		qzone.setShareContent(share.getShareContent());
		qzone.setTargetUrl(share.getTargetUrl());
		qzone.setTitle(share.getShareTitle());
		qzone.setShareImage(urlImage);
		mController.setShareMedia(qzone);

		/** 4.QQ分享内容 */
		QQShareContent qqShareContent = new QQShareContent();
		qqShareContent.setShareContent(share.getShareContent());
		qqShareContent.setTitle(share.getShareTitle());
		qqShareContent.setShareImage(urlImage);
		qqShareContent.setTargetUrl(share.getTargetUrl());
		mController.setShareMedia(qqShareContent);

		/** 5.新浪微博分享内容 */
		SinaShareContent sinaContent = new SinaShareContent(urlImage);
		sinaContent.setShareContent(share.getShareContent()+share.getTargetUrl());
		sinaContent.setTitle(share.getShareTitle());
		sinaContent.setShareImage(urlImage);
		sinaContent.setTargetUrl(share.getTargetUrl());
		mController.setShareMedia(sinaContent);
	}

	/**
	 * @return
	 * @功能描述 : 添加QQ平台支持 QQ分享的内容， 包含四种类型， 即单纯的文字、图片、音乐、视频. 参数说明 : title, summary,
	 *       image url中必须至少设置一个, targetUrl必须设置,网页地址必须以"http://"开头 . title :
	 *       要分享标题 summary : 要分享的文字概述 image url : 图片地址 [以上三个参数至少填写一个] targetUrl
	 *       : 用户点击该分享时跳转到的目标地址 [必填] ( 若不填写则默认设置为友盟主页 )
	 */
	public void addQQQZonePlatform(Activity act) {
		String appId = "1105290573";
		String appKey = "Q9B9H4TFWaAbgFOS";
		// 添加QQ支持, 并且设置QQ分享内容的target url
		UMQQSsoHandler qqSsoHandler = new UMQQSsoHandler(act, appId, appKey);
		qqSsoHandler.addToSocialSDK();

		// 添加QZone平台
		QZoneSsoHandler qZoneSsoHandler = new QZoneSsoHandler(act, appId, appKey);
		qZoneSsoHandler.addToSocialSDK();
	}

	/**
	 * @return
	 * @功能描述 : 添加微信平台分享
	 */
	public void addWXPlatform(Activity act) {
		// 注意：在微信授权的时候，必须传递appSecret
		String appId = "wxa5b550cd9a1817d6";
		String appSecret = "daec9fff6ab7c9c2043035f53aeb8301";
		// 添加微信平台
		UMWXHandler wxHandler = new UMWXHandler(act, appId, appSecret);
		wxHandler.addToSocialSDK();

		// 支持微信朋友圈
		UMWXHandler wxCircleHandler = new UMWXHandler(act, appId, appSecret);
		wxCircleHandler.setToCircle(true);
		wxCircleHandler.addToSocialSDK();
	}
}
