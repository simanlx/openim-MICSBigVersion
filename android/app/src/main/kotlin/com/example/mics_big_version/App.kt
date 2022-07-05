package com.example.mics_big_version

import android.app.Application
import android.text.TextUtils
import android.util.Log
import com.jeremyliao.liveeventbus.LiveEventBus
import com.raisound.speech.SpeechConfig
import com.raisound.speech.SpeechRecognizerManager
import com.raisound.speech.http.callback.RequestCallback

class App :Application(){

    override fun onCreate() {
        super.onCreate()
        initSpeech()
    }

    fun initSpeech(){
        val speechConfig = SpeechConfig("", "3yo6ijgW", "zT2jXm7wCYWyrdkQjxdGGArMostbXThh")
        val auth = "http://ting.raisound.com:88"
        val grpc = "ting.raisound.com:20060"
        val split = auth.split(":").toTypedArray()
        if (split.size == 3) {
            speechConfig.setApiServer(split[0] + ":" + split[1], split[2].toInt())
        } else if (split.size == 2) {
            if (split[0].startsWith("http")) {
                speechConfig.setApiServer(split[0] + ":" + split[1], if (split[0].contains("https")) 443 else 80)
            } else {
                speechConfig.setApiServer(if (split[1].endsWith("43")) "https://" + split[0] else "http://" + split[0], split[1].toInt())
            }
        } else {
            speechConfig.setApiServer("http://" + split[0], 80)
        }
        if (TextUtils.isEmpty(grpc)) speechConfig.setAsrServer("https://people-voip.raisound.com/vserver", 0) else {
            speechConfig.setAsrServer(grpc.split(":").toTypedArray()[0], grpc.split(":").toTypedArray()[1].toInt())
        }
        //设置平台id
//        speechConfig.setPlatform("1");
//        是否一体化管理服务，设置为true后，只需要设置apiServer即可，转写服务器设置将失效
//        speechConfig.setAutomation(true);
        //是否打开SDK日志输出
        //设置平台id
//        speechConfig.setPlatform("1");
//        是否一体化管理服务，设置为true后，只需要设置apiServer即可，转写服务器设置将失效
//        speechConfig.setAutomation(true);
        //是否打开SDK日志输出
        SpeechRecognizerManager.debug(true)
        //初始化SDK
        //初始化SDK
        SpeechRecognizerManager.initialize(speechConfig, object : RequestCallback<Boolean?> {
            override fun onSuccess(i: Int, aBoolean: Boolean?) {
                Log.d("方方 native,", "方方 native, app instance成功")
                SpeechRecognizerManager.with(this@App).build()
                LiveEventBus.get<Boolean>("initSpeechSuccess").post(true)
            }

            override fun onFailure(i: Int, s: String?) {
                Log.d("fang", "SpeechRecognizerManager initialize  onFailure....")
            }
        })


    }
}