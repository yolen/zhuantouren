package com.brickman.app.common.umeng;

import com.brickman.app.MApplication;
import com.brickman.app.R;
import com.umeng.socialize.media.UMImage;

/**
 * 分享实体类（用于存储一条分享信息）
 *
 * @author mayu
 */
public class ShareContent {

	// 分享主题
	private String shareTitle;

	// 分享内容
	private String shareContent;

	// 分享图片
	private UMImage shareImage;

	// 分享地址链接
	private String targetUrl;

	/* 无参构造函数 */

	public ShareContent() {
	}

	/* 有参构造(包含所有属性) */

	/**
	 *
	 * @param shareTitle
	 * @param shareContent
	 * @param shareImage
	 * @param targetUrl
     */
	public ShareContent(String shareTitle, String shareContent,
                        UMImage shareImage, String targetUrl) {
		super();
		this.shareTitle = shareTitle;
		this.shareContent = shareContent;
		if(shareImage == null){
			this.shareImage = new UMImage(MApplication.mAppContext, R.mipmap.ic_launcher);
		} else {
			this.shareImage = shareImage;
		}
		this.targetUrl = targetUrl;
	}

	/**
	 * getter/setter 方法
	 */

	public String getShareTitle() {
		return shareTitle;
	}

	public void setShareTitle(String shareTitle) {
		this.shareTitle = shareTitle;
	}

	public String getShareContent() {
		return shareContent;
	}

	public void setShareContent(String shareContent) {
		this.shareContent = shareContent;
	}

	public UMImage getShareImage() {
		return shareImage;
	}

	public void setShareImage(UMImage shareImage) {
		this.shareImage = shareImage;
	}

	public String getTargetUrl() {
		return targetUrl;
	}

	public void setTargetUrl(String targetUrl) {
		this.targetUrl = targetUrl;
	}

	@Override
	public String toString() {
		return "ShareContent{" + "shareTitle='" + shareTitle + '\''
				+ ", shareContent='" + shareContent + '\'' + ", shareImage="
				+ shareImage + ", targetUrl='" + targetUrl + '\'' + '}';
	}
}
