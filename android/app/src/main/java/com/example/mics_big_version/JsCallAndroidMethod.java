package com.example.mics_big_version;

import android.util.Log;
import android.webkit.JavascriptInterface;

import com.google.gson.Gson;
import com.jeremyliao.liveeventbus.LiveEventBus;

public class JsCallAndroidMethod {
    @JavascriptInterface
    public String test(String args){
        return "hello word " + args;
    };

    @JavascriptInterface
    public String call(String args){
        Log.d("方方","请求通话携带的参数" +args);
        LiveEventBus.get("webMethodCall").post(args);
//        Gson gson = new Gson();
//        WebGiveCallBean webGiveCallBean = gson.fromJson(args, WebGiveCallBean.class);
        return "hello word " + args;
    };
}
