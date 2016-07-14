package com.brickman.app.common.http.param;


/**
 * 请求参数构造器
 * @author alaowan
 *
 */
public class ParamBuilder {
	
	public static RequestParam buildParam(){
		return new RequestParam();
	}
	
	public static RequestParam buildParam(String key, String value){
		return new RequestParam().append(key, value);
	}
}
