package com.example.mics_big_version

import android.content.Intent
import android.util.Log
import com.jeremyliao.liveeventbus.LiveEventBus
import com.raisound.speech.AsrResult
import com.raisound.speech.SpeechError
import com.raisound.speech.SpeechRecognizerManager
import com.raisound.speech.http.response.NlpResult
import com.raisound.speech.listener.RecognizerListener
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(), RecognizerListener {

    var methodChannel:MethodChannel? = null
    var eventChannel:EventChannel? = null

    var speechEventSink:EventChannel.EventSink? = null;

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        methodChannel = MethodChannel(getFlutterEngine()!!.dartExecutor, "channel_big_version")
        eventChannel = EventChannel(getFlutterEngine()!!.dartExecutor, "speech_event_channel")
        setupMethodChannel()
        super.configureFlutterEngine(flutterEngine)

    }

    private fun initListener() {
        if (SpeechRecognizerManager.getInstance() != null) {
            //主页面
            SpeechRecognizerManager.setListener(this@MainActivity)
        } else {
//            Log.d("方方 native,","方方 native, 主页面设置监听失败 SpeechRecognizerManager.getInstance()为空222222222");
        }
    }

    private fun setupMethodChannel() {
        LiveEventBus.get("webMethodCall", String::class.java).observe(this){
            methodChannel?.invokeMethod("webMethodCall",it)
        }
        LiveEventBus.get("initSpeechSuccess", Boolean::class.java).observe(this) { initListener() }
        eventChannel?.setStreamHandler(object :EventChannel.StreamHandler{
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                speechEventSink = events
            }

            override fun onCancel(arguments: Any?) {

            }

        });
        methodChannel?.setMethodCallHandler(object : MethodChannel.MethodCallHandler {
            override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
                when(call.method){
                    "to_zhp_activity" -> toZhpActivity(call.arguments)
                    "init_speech" -> initListener()
                    "start_speech_record" -> startSpeechRecord(result)
                    "stop_speech_record" -> stopSpeechRecord(result)
                }
            }

        })
    }

    private fun stopSpeechRecord(result: MethodChannel.Result) {
        SpeechRecognizerManager.stop()
        result.success("成功")
    }

    private fun startSpeechRecord(result: MethodChannel.Result) {
        SpeechRecognizerManager.start()
    }

    private fun toZhpActivity(arguments: Any) {
        val intent = Intent(this,ZhpActivity::class.java)
        Log.d("参数","跳转携带的参数" + arguments.toString())
//        if (arguments is String) {
            intent.putExtra("url",arguments.toString())
//        }
        startActivity(intent)
    }

    override fun onRecordData(p0: ByteArray?) {

    }

    override fun onVolumeChanged(p0: Int) {

    }

    override fun onBeginOfSpeech() {

    }

    override fun onEndOfSpeech() {

    }

    override fun onResult(asrResult: AsrResult?, p1: Boolean) {
        if (asrResult?.isFinal != false) {
            runOnUiThread { speechEventSink?.success(asrResult?.results) }
        }
    }

    override fun onCommandResult(p0: NlpResult?) {

    }

    override fun onError(p0: SpeechError?) {

    }
}
