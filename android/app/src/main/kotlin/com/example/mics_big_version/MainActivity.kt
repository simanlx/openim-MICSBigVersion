package com.example.mics_big_version

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioTrack
import android.media.MediaPlayer
import android.os.Build
import android.text.TextUtils
import android.util.Log
import com.jeremyliao.liveeventbus.LiveEventBus
import com.raisound.speech.AsrResult
import com.raisound.speech.SpeechError
import com.raisound.speech.SpeechRecognizerManager
import com.raisound.speech.http.response.NlpResult
import com.raisound.speech.interfaces.ISpeechRecognizer
import com.raisound.speech.listener.RecognizerListener
import com.raisound.speech.voiceprint.interfaces.IVoiceprintDCManager
import com.raisound.tts.listeners.TtsListener
import com.skv.BasicAudioRecorder
import com.skv.SKVWakeUp
import com.skv.VisualWakeUpAudioRecorder
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.*

class MainActivity: FlutterActivity(), RecognizerListener, TtsListener, SKVWakeUp.OnWakeUpListener, BasicAudioRecorder.OnAudioFrameCapturedListener {

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
                    "init_speech" -> {
                        initListener()
                        initSkv()
                    }
                    "start_speech_record" -> startSpeechRecord()
                    "stop_speech_record" -> stopSpeechRecord()
                }
            }

        })
    }

    private fun stopSpeechRecord() {
        SpeechRecognizerManager.stop()
    }

    private fun startSpeechRecord() {
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
            val finalStr = asrResult!!.results.replace("，".toRegex(), "")
                    .replace(" ".toRegex(), "")
                    .replace("。".toRegex(), "")
            if (TextUtils.isEmpty(finalStr)) {
                return
            }
            runOnUiThread { speechEventSink?.success(finalStr) }
            stopSpeechRecord()
        }
    }

    override fun onCommandResult(p0: NlpResult?) {

    }

    override fun onError(p0: SpeechError?) {

    }

    //===============================================tts相关============================
            override fun onSynthesisStarted() {
                //开始合成
                Log.i("TTS", "onSynthesisStarted")
                release()
            }

            override fun onPrepared() {
                //准备就绪，收到第一帧数据
                Log.i("TTS", "onPrepared")
                isTTSing = true
                val mUnitSize = AudioTrack.getMinBufferSize(22050, AudioFormat.CHANNEL_OUT_MONO, AudioFormat.ENCODING_PCM_16BIT)
                mAudioTrack = AudioTrack(AudioManager.STREAM_MUSIC,
                        22050,
                        AudioFormat.CHANNEL_OUT_MONO,
                        AudioFormat.ENCODING_PCM_16BIT,
                        mUnitSize,
                        AudioTrack.MODE_STREAM)
                mAudioTrack!!.play()
            }

            override fun onBinaryReceived(bytes: ByteArray, audioType: String, s1: String?, endFlag: Boolean) {
                //返回合成的PCM流
                Log.i("TTS", "onBinaryReceived:" + bytes.size + ",s:" + audioType + ",b:" + endFlag)
                mAudioTrack!!.write(bytes, 0, bytes.size)
            }

            override fun onSynthesisCompleted() {
                //合成完成，最后一条消息返回后，会回调此方法。
                isTTSing = false
                Log.i("TTS", "onSynthesisCompleted")
            }

            override fun onTaskFailed(i: Int, s: String, s1: String) {
                //合成失败
                Log.i("TTS", "onTaskFailed code:$i,message:$s,$s1")
                release()
            }


            private var mAudioTrack: AudioTrack? = null

            /**
             * 释放AudioTrack资源
             */
            private fun release() {
                isTTSing = false
                if (mAudioTrack != null) {
                    if (mAudioTrack!!.state != AudioTrack.STATE_UNINITIALIZED && mAudioTrack!!.playState == AudioTrack.PLAYSTATE_PLAYING) mAudioTrack!!.stop()
                    mAudioTrack!!.release()
                    mAudioTrack = null
                }
            }


    //===============================================tts相关============================

    override fun onAudioFrameCaptured(audioData: ByteArray?, bufferSize: Int) {
        mSKVWakeUp?.yyWriteAudioData(audioData, bufferSize)
    }

    override fun onAudioFrameCaptured(buffer: ShortArray?, bufferSize: Int) {
        mSKVWakeUp?.yyWriteAudioData(buffer, bufferSize)
        if (reader != null && !isTTSing) reader.readShorts(buffer)
        if (unitLength == 0) {
            unitLength = BasicAudioRecorder.mSampleSizePerBuffer
            byteLength = unitLength * size
            fileByte = ShortArray(byteLength)
            tempFileByte = ShortArray(byteLength)
        }
        tempFileByte = fileByte.clone()
        System.arraycopy(tempFileByte, unitLength, fileByte, 0, tempFileByte.size - unitLength)
        System.arraycopy(buffer, 0, fileByte, byteLength - unitLength, buffer!!.size)
    }

    var size = 150

    //每帧的长度
    var unitLength = BasicAudioRecorder.mSampleSizePerBuffer

    //每次传输的长度
    var byteLength = unitLength * size

    //每次取新数据的长度
    var byteLengthNew = unitLength * 5

    //ASR每帧的数据，长度6400
    var readBytes = ByteArray(unitLength)

    //当前返回的长度，累计到6400发送到ASR
    var length = 0

    //声音事件每次发送的数据
    @Volatile
    var fileByte = ShortArray(byteLength)

    //fileByte已写有效数据长度
    @Volatile
    var fileLength = 0

    //上次发送的数据
    @Volatile
    var tempFileByte = ShortArray(byteLength)

    //已写新数据的长度
    @Volatile
    var newFileLength = 0

    //缓存的长度，用于ASR校验
    var cacheLength = unitLength * 25

    //缓存的数据，用于ASR校验
    @Volatile
    var cacheByte = ByteArray(cacheLength)

    //缓存的数据，用于ASR校验
    @Volatile
    var tempCacheByte = ByteArray(cacheLength)

    //cache已写有效数据长度
    @Volatile
    var cachedLength = 0

    @Volatile
    var isWarn = false

    @Volatile
    var delay = 0


    private var mSKVWakeUp: SKVWakeUp? = null
    private var isInitWakeUp = false
    private var mVisualWakeUpAudioRecorder: VisualWakeUpAudioRecorder? = null
    private val reader: ISpeechRecognizer? = null
    private val iVoiceprintDCManager: IVoiceprintDCManager? = null
    var isTTSing = false

    //============================================================================语音唤醒相关内容===============================================

    //初始化语音唤醒
    private fun initSkv() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val i = checkSelfPermission(Manifest.permission.RECORD_AUDIO)
            if (i == PackageManager.PERMISSION_GRANTED) {
                try {
                    mVisualWakeUpAudioRecorder = VisualWakeUpAudioRecorder(this)
                    init()
                } catch (e: java.lang.Exception) {
                }
            }
        }
    }


    private fun init() {
        try {
            mSKVWakeUp = SKVWakeUp(this)
            isInitWakeUp = mSKVWakeUp!!.yyInitSKVWakeUp(16000, 16, 1)
            if (isInitWakeUp) {
                Log.i("方方", "initialize SKVWakeUp Sucessed!")
                mSKVWakeUp!!.yySetmWakeUpListener(this)
                mSKVWakeUp!!.yySetMaxInBuffer(100 * 1000)
                mSKVWakeUp!!.yySetMaxOutBuffer(100 * 1000)
                mVisualWakeUpAudioRecorder!!.setSKVWakeUp(mSKVWakeUp)
                mVisualWakeUpAudioRecorder!!.setAudioFrameCapturedListener(this)
            } else {
                Log.i("方方", "initialize SKVWakeUp Failed!")
            }
            mVisualWakeUpAudioRecorder!!.start("")
        } catch (e: java.lang.Exception) {
        }
    }


    override fun onIsWakeUp(state: Boolean) {
        if (state) {
            Log.d("方方", "语音唤醒成功$state")
            try {
                val mediaPlayer: MediaPlayer = MediaPlayer.create(this@MainActivity, R.raw.active)
                //                                                mediaPlayer.prepare();
                mediaPlayer.start()
                mediaPlayer.setOnCompletionListener { mediaPlayer -> mediaPlayer.release() }
            } catch (e: Exception) {
                e.printStackTrace()
            }
            SpeechRecognizerManager.sendEnd()
            //            TtsManager.getInstance().toSpeech("我在");
            //开启语音唤醒
            startSpeechRecord()

            //定时器(30s后自动关闭)
            hxTimer?.cancel()
            hxTimer = null
            hxTimerTask?.cancel()
            hxTimerTask = null

            hxTimer = Timer()
            hxTimerTask = object : TimerTask() {
                override fun run() {
                    stopSpeechRecord()
                }
            }
            hxTimer?.schedule(hxTimerTask, 30000)
        }
    }

    var hxTimer: Timer? = null
    var hxTimerTask: TimerTask? = null

    override fun onWakeUpScore(score: Float) {

    }


    override fun onDestroy() {
        release()
        if (hxTimer != null) {
            hxTimer!!.cancel()
            hxTimer = null
        }
        if (hxTimerTask != null) {
            hxTimerTask!!.cancel()
            hxTimerTask = null
        }
        super.onDestroy()
    }
}
