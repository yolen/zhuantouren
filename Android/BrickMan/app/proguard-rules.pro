# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /Users/mayu/Applications/android-sdk-mac_x86/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}


-dontwarn
-optimizationpasses 5          # 指定代码的压缩级别
-dontusemixedcaseclassnames   # 是否使用大小写混合
-dontpreverify           # 混淆时是否做预校验
-verbose                # 混淆时是否记录日志

-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*  # 混淆时所采用的算法

-keep public class * extends android.app.Activity      # 保持哪些类不被混淆
-keep public class * extends android.app.Application   # 保持哪些类不被混淆
-keep public class * extends android.app.Service       # 保持哪些类不被混淆
-keep public class * extends android.content.BroadcastReceiver  # 保持哪些类不被混淆
-keep public class * extends android.content.ContentProvider    # 保持哪些类不被混淆
-keep public class * extends android.app.backup.BackupAgentHelper # 保持哪些类不被混淆
-keep public class * extends android.preference.Preference        # 保持哪些类不被混淆
-keep public class com.android.vending.licensing.ILicensingService    # 保持哪些类不被混淆

-keepclasseswithmembernames class * {  # 保持 native 方法不被混淆
    native <methods>;
}
-keepclasseswithmembers class * {   # 保持自定义控件类不被混淆
    public <init>(android.content.Context, android.util.AttributeSet);
}
-keepclasseswithmembers class * {# 保持自定义控件类不被混淆
    public <init>(android.content.Context, android.util.AttributeSet, int);
}
-keepclassmembers class * extends android.app.Activity { # 保持自定义控件类不被混淆
    public void *(android.view.View);
}
-keepclassmembers enum * {     # 保持枚举 enum 类不被混淆
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-keep class * implements android.os.Parcelable { # 保持 Parcelable 不被混淆
    public static final android.os.Parcelable$Creator *;
}
-keepclassmembers class fqcn.of.javascript.interface.for.webview {
   public *;
}

-keepclassmembers class * extends android.webkit.WebChromeClient{
   		public void openFileChooser(...);
}

#移除Log类打印各个等级日志的代码，打正式包的时候可以做为禁log使用，这里可以作为禁止log打印的功能使用，另外的一种实现方案是通过BuildConfig.DEBUG的变量来控制
-assumenosideeffects class android.util.Log {
    public static *** v(...);
    public static *** i(...);
    public static *** d(...);
    public static *** w(...);
    public static *** e(...);
}

######################################################################

 -dontshrink
 -dontoptimize
 -dontwarn com.google.android.maps.**
 -dontwarn android.webkit.WebView
 -dontwarn com.umeng.**
 -dontwarn com.tencent.weibo.sdk.**
 -dontwarn com.facebook.**

# -libraryjars libs/SocialSDK_QQZone_3.jar-------------------------------

  -dontshrink
  -dontoptimize
  -dontwarn com.google.android.maps.**
  -dontwarn android.webkit.WebView
  -dontwarn com.umeng.**
  -dontwarn com.tencent.weibo.sdk.**
  -dontwarn com.facebook.**
  -keep public class javax.**
  -keep public class android.webkit.**
  -dontwarn android.support.v4.**
  -keep enum com.facebook.**
  -keepattributes Exceptions,InnerClasses,Signature
  -keepattributes *Annotation*
  -keepattributes SourceFile,LineNumberTable

  -keep public interface com.facebook.**
  -keep public interface com.tencent.**
  -keep public interface com.umeng.socialize.**
  -keep public interface com.umeng.socialize.sensor.**
  -keep public interface com.umeng.scrshot.**

  -keep public class com.umeng.socialize.* {*;}


  -keep class com.facebook.**
  -keep class com.facebook.** { *; }
  -keep class com.umeng.scrshot.**
  -keep public class com.tencent.** {*;}
  -keep class com.umeng.socialize.sensor.**
  -keep class com.umeng.socialize.handler.**
  -keep class com.umeng.socialize.handler.*
  -keep class com.tencent.mm.sdk.modelmsg.WXMediaMessage {*;}
  -keep class com.tencent.mm.sdk.modelmsg.** implements com.tencent.mm.sdk.modelmsg.WXMediaMessage$IMediaObject {*;}

  -keep class im.yixin.sdk.api.YXMessage {*;}
  -keep class im.yixin.sdk.api.** implements im.yixin.sdk.api.YXMessage$YXMessageData{*;}

  -dontwarn twitter4j.**
  -keep class twitter4j.** { *; }

  -keep class com.tencent.** {*;}
  -dontwarn com.tencent.**
  -keep public class com.umeng.soexample.R$*{
      public static final int *;
  }
  -keep public class com.umeng.soexample.R$*{
      public static final int *;
  }
  -keep class com.tencent.open.TDialog$*
  -keep class com.tencent.open.TDialog$* {*;}
  -keep class com.tencent.open.PKDialog
  -keep class com.tencent.open.PKDialog {*;}
  -keep class com.tencent.open.PKDialog$*
  -keep class com.tencent.open.PKDialog$* {*;}

  -keep class com.sina.** {*;}
  -dontwarn com.sina.**
  -keep class  com.alipay.share.sdk.** {
     *;
  }
  -keepnames class * implements android.os.Parcelable {
      public static final ** CREATOR;
  }

  -keep class com.linkedin.** { *; }
  -keepattributes Signature

# com.yolanda.nohttp:nohttp:1.0.5-------------------------------
-dontwarn com.yolanda.nohttp.**
-keep class com.yolanda.nohttp.**{*;}

# com.jakewharton:butterknife:8.4.0-------------------------------
-keep class butterknife.** { *; }
-dontwarn butterknife.internal.**
-keep class **$$ViewBinder { *; }

-keepclasseswithmembernames class * {
    @butterknife.* <fields>;
}

-keepclasseswithmembernames class * {
    @butterknife.* <methods>;
}

# com.wang.avi:library:1.0.5-------------------------------
-keep class com.wang.avi.** { *; }
-keep class com.wang.avi.indicators.** { *; }

# com.google.code.gson:gson:2.2.4----------------------------
-dontwarn com.google.gson.**
-keep class com.google.gson.http.**{ *;}
#gson
#如果用用到Gson解析包的，直接添加下面这几行就能成功混淆，不然会报错。
-keepattributes Signature
# Gson specific classes
-keep class sun.misc.Unsafe { *; }
# Application classes that will be serialized/deserialized over Gson
-keep class com.google.gson.stream.** { *; }
# 如果使用了Gson之类的工具要使被它解析的JavaBean类即实体类不被混淆。
-keep class com.matrix.app.entity.json.** { *; }
-keep class com.matrix.appsdk.network.model.** { *; }

# com.nineoldandroids:library:2.4.0----------------------------
-dontwarn com.nineoldandroids.**
-keep class com.nineoldandroids.** { *; }
-keep interface com.nineoldandroids.** { *; }

# com.orhanobut:logger:1.15----------------------------
-dontwarn com.orhanobut.logger.**
-keep class com.orhanobut.logger.**{ *;}

# com.github.bumptech.glide:glide:3.7.0----------------------------
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}

# in.srain.cube:ultra-ptr:1.0.11----------------------------
-keep class in.srain.cube.** { *; }
-keep interface in.srain.cube.** { *; }
-dontwarn in.srain.cube.**

# cn.finalteam:galleryfinal:1.4.8.7--------------------------
-keep class cn.finalteam.galleryfinal.widget.*{*;}
-keep class cn.finalteam.galleryfinal.widget.crop.*{*;}
-keep class cn.finalteam.galleryfinal.widget.zoonview.*{*;}

#-------------------------高德地图-----------------------
#3D 地图
#-keep   class com.amap.api.mapcore.**{*;}
#-keep   class com.amap.api.maps.**{*;}
#-keep   class com.autonavi.amap.mapcore.*{*;}

#定位
-keep class com.amap.api.location.**{*;}
-keep class com.amap.api.fence.**{*;}
-keep class com.autonavi.aps.amapapi.model.**{*;}

#搜索
#-keep class com.amap.api.services.**{*;}

#2D地图
#-keep class com.amap.api.maps2d.**{*;}
#-keep class com.amap.api.mapcore2d.**{*;}

#导航
#-keep class com.amap.api.navi.**{*;}
#-keep class com.autonavi.**{*;}










