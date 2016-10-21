package com.brickman.app.module.main;

import android.os.Bundle;
import android.support.v7.widget.Toolbar;
import android.view.KeyEvent;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.widget.TextView;

import com.brickman.app.R;
import com.brickman.app.common.base.BaseActivity;

import butterknife.BindView;
import butterknife.OnClick;

/**
 * Created by mayu on 16/8/25,下午3:25.
 */
public class WebActivity extends BaseActivity {
    @BindView(R.id.title)
    TextView title;
    @BindView(R.id.toolbar)
    Toolbar toolbar;
    @BindView(R.id.webView)
    WebView webView;

    @Override
    protected int getLayoutId() {
        isInitMVP = false;
        return R.layout.activity_web;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        toolbar = (Toolbar) findViewById(R.id.toolbar);
        toolbar.setTitle("");
        setSupportActionBar(toolbar);
        WebSettings webSettings = webView.getSettings();
        webSettings.setCacheMode(WebSettings.LOAD_CACHE_ELSE_NETWORK);
        webSettings.setJavaScriptEnabled(true);
        webSettings.setDisplayZoomControls(false);
        webSettings.setSupportZoom(false);
        webView.loadUrl(getIntent().getStringExtra("url"));
        title.setText(getIntent().getStringExtra("title"));
    }

    @OnClick(R.id.back)
    public void onClick() {
        finishWithAnim();
    }

    //改写物理按键——返回的逻辑
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            if (webView.canGoBack()) {
                webView.goBack();//返回上一页面
                return true;
            } else {
                finishWithAnim();
            }
        }
        return super.onKeyDown(keyCode, event);
    }
}
