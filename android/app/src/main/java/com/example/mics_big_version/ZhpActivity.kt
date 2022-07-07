package com.example.mics_big_version

import android.annotation.SuppressLint
import android.graphics.Bitmap
import android.net.http.SslError
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.webkit.*
import io.flutter.embedding.android.FlutterActivity

class ZhpActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_zhp)
        AndroidBug5497Workaround.assistActivity(this)
        initView()
    }

    @SuppressLint("SetJavaScriptEnabled")
    private fun initView() {

        val webView = findViewById<WebView>(R.id.webView)
        webView.webViewClient =object :WebViewClient(){
            override fun shouldOverrideUrlLoading(view: WebView?, request: WebResourceRequest?): Boolean {
                return super.shouldOverrideUrlLoading(view, request)
            }

            override fun onPageStarted(view: WebView?, url: String?, favicon: Bitmap?) {
                super.onPageStarted(view, url, favicon)
                Log.d("webView","webView url" + "onPageStarted" )
            }

            override fun onReceivedSslError(view: WebView?, handler: SslErrorHandler?, error: SslError?) {
                Log.d("webView","webView url onReceivedSslError")
                handler?.proceed()
//                super.onReceivedSslError(view, handler, error)
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                Log.d("webView","webView url onPageFinished" + url)

            }
            override fun onReceivedError(view: WebView?, request: WebResourceRequest?, error: WebResourceError?) {
                super.onReceivedError(view, request, error)
                Log.d("webView","webView url  error" + error.toString())
            }
        }

        webView.settings.useWideViewPort = true
        webView.settings.loadWithOverviewMode = true
        webView.settings.defaultTextEncodingName = "utf-8"
        webView.settings.loadsImagesAutomatically = true
        webView.settings.javaScriptEnabled = true
        webView.settings.domStorageEnabled = true
        webView.settings.supportZoom()
        webView.settings.loadWithOverviewMode = true



        webView.webChromeClient = object :WebChromeClient(){
            override fun onPermissionRequest(request: PermissionRequest?) {
//                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP){
                Log.d("webView权限申请","webView权限申请" + request?.resources)
                    request?.grant(request.resources)
//                }
            }
        }

        val url = intent.getStringExtra("url")
        Log.d("webView","webView url" + url)
        webView.loadUrl(url?:"")

        webView.addJavascriptInterface(JsCallAndroidMethod(),"android")
    }

}