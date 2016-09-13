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
-dontnote
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

# -libraryjars libs/SocialSDK_QQZone_3.jar-------------------------------

  -dontshrink
  -dontoptimize
  -dontwarn android.webkit.WebView
  -dontwarn com.umeng.**
  -dontwarn com.tencent.**
  -dontwarn com.yolanda.nohttp.**
  -dontwarn butterknife.internal.**
  -dontwarn com.wang.avi.**
  -dontwarn com.google.gson.**
  -dontwarn in.srain.cube.**
  -dontwarn com.nineoldandroids.**
  -dontwarn com.amap.api.**
  -dontwarn com.orhanobut.logger.**
  -dontwarn com.bumptech.glide.**
  -dontwarn cn.finalteam.galleryfinal.**
  -dontwarn com.squareup.picasso.**
  -dontwarn sun.misc.Unsafe
  -dontwarn top.zibin.luban.**



  -keep public class javax.**
  -keep public class android.webkit.**
  -dontwarn android.support.v4.**
  -keepattributes Exceptions,InnerClasses,Signature
  -keepattributes *Annotation*
  -keepattributes SourceFile,LineNumberTable

  -keep public interface com.tencent.**
  -keep public interface com.umeng.socialize.**
  -keep public interface com.umeng.socialize.sensor.**
  -keep public interface com.umeng.scrshot.**

  -keep public class com.umeng.socialize.* {*;}


#  -keep class com.facebook.**
#  -keep class com.facebook.** { *; }
  -keep class com.umeng.scrshot.**
  -keep public class com.tencent.** {*;}
  -keep class com.umeng.socialize.sensor.**
  -keep class com.umeng.socialize.handler.**
  -keep class com.umeng.socialize.handler.*
  -keep class com.tencent.mm.sdk.modelmsg.WXMediaMessage {*;}
  -keep class com.tencent.mm.sdk.modelmsg.** implements com.tencent.mm.sdk.modelmsg.WXMediaMessage$IMediaObject {*;}

#  -keep class im.yixin.sdk.api.YXMessage {*;}
#  -keep class im.yixin.sdk.api.** implements im.yixin.sdk.api.YXMessage$YXMessageData{*;}

#  -dontwarn twitter4j.**
#  -keep class twitter4j.** { *; }

  -keep class com.tencent.** {*;}
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

#  -keep class com.sina.** {*;}
#  -dontwarn com.sina.**
#  -keep class  com.alipay.share.sdk.** {
#     *;
#  }
  -keepnames class * implements android.os.Parcelable {
      public static final ** CREATOR;
  }

#  -keep class com.linkedin.** { *; }
#  -keepattributes Signature

# com.yolanda.nohttp:nohttp:1.0.5-------------------------------
-keep class com.yolanda.nohttp.**{*;}

# com.youth.banner:banner:+-------------------------------
#-dontwarn com.youth.banner.**
#-keep class com.youth.banner.**{*;}

# com.jakewharton:butterknife:8.4.0-------------------------------
-keep class butterknife.** { *; }
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
# removes such information by default, so configure it to keep all of it.
-keepattributes Signature
# Gson specific classes
-keep class sun.misc.Unsafe { *; }
-keep class com.google.gson.stream.** { *; }
# Application classes that will be serialized/deserialized over Gson
-keep class com.google.gson.examples.android.model.** { *; }
-keep class com.google.gson.** { *;}
#这句非常重要，主要是滤掉 com.bgb.scan.model包下的所有.class文件不进行混淆编译
-keep class com.brickman.app.model.** {*;}


# com.nineoldandroids:library:2.4.0----------------------------
-keep class com.nineoldandroids.** { *; }
-keep interface com.nineoldandroids.** { *; }

# com.orhanobut:logger:1.15----------------------------
-keep class com.orhanobut.logger.**{ *;}

# top.zibin.luban:1.0.8----------------------------
-keep class top.zibin.luban.**{ *;}
-keep interface top.zibin.luban.** { *; }

# com.github.bumptech.glide:glide:3.7.0----------------------------
-keep public class * implements com.bumptech.glide.module.GlideModule
-keep public enum com.bumptech.glide.load.resource.bitmap.ImageHeaderParser$** {
  **[] $VALUES;
  public *;
}

# in.srain.cube:ultra-ptr:1.0.11----------------------------
-keep class in.srain.cube.** { *; }
-keep interface in.srain.cube.** { *; }

# io.reactivex:rxjava:1.1.6----------------------------
-dontwarn sun.misc.**

-keepclassmembers class rx.internal.util.unsafe.*ArrayQueue*Field* {
   long producerIndex;
   long consumerIndex;
}

-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueProducerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode producerNode;
}

-keepclassmembers class rx.internal.util.unsafe.BaseLinkedQueueConsumerNodeRef {
    rx.internal.util.atomic.LinkedQueueNode consumerNode;
}

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










