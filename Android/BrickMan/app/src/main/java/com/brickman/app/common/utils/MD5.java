package com.brickman.app.common.utils;

import java.security.MessageDigest;

public class MD5 {

	public static String encrypt(String plainText) {
		String str = "";
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");// 实例化一个算法对象
			md.update(plainText.getBytes());// 加密文本
			byte b[] = md.digest();

			int i;

			StringBuffer buf = new StringBuffer("");
			for (int offset = 0; offset < b.length; offset++) {
				i = b[offset];
				if (i < 0)
					i += 256;
				if (i < 16)
					buf.append("0");
				buf.append(Integer.toHexString(i));
			}
			str = buf.toString();
		} catch (Exception e) {
		}
		return str.toLowerCase();
	}

	public static void main(String[] args) {
	}
}
