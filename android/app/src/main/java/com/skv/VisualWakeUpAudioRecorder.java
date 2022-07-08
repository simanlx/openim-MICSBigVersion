package com.skv;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Rect;
import android.media.AudioFormat;
import android.media.MediaPlayer;
import android.media.MediaRecorder;
import android.util.AttributeSet;
import android.util.Log;
import android.view.SurfaceHolder;
import android.view.SurfaceView;

import java.io.IOException;

public class VisualWakeUpAudioRecorder extends SurfaceView implements SurfaceHolder.Callback, BasicAudioRecorder.OnAudioFrameCapturedListener, SKVWakeUp.OnWakeUpListener {
    private static final String TAG = "AudioRecorder";

    /* Parameters for AudioRecorder */
    private BasicAudioRecorder mAudioRecorder = null;
    private boolean isInitRecorder = false;

    private int mNumChannel = 1;
    private int mSampleRate = 16000;
    private int mBitsPerSample = 16;

    private int frame_samples = 256;
    private int frame_sizes = 256;
    private int frame_times = 16;

    private String mRecordFileName = null;

    /* Parameters for SKVWakeUp */
    private SKVWakeUp mSKVWakeUp = null;
    private boolean isInitWakeUp = true;
    private float mWakeUpThresh = 0.2f;
    private boolean WakeUpState = false;
    private MediaPlayer mp = new MediaPlayer();

    /* Parameters for Painting */
    private SKVFloatCircleBuffer mPlotData = null;
    private SKVBooleanCircleBuffer mPlotDataColorTag = null;

    private int mPaintFlushTime = 64;
    //private int mPaintFlushTime = 128;
    private int haveRecordedTime = 0;
    private Paint mPaint = null;
    private SurfaceHolder mHolder = null;
    private Rect mSurfaceFrame = null;
    private int mWidth = 0;
    private int mHeight = 0;
    private int mCenterY = 0;
    private boolean isInitPainting = false;
    private int num_wakeup = 0;
    @Override
    public void onIsWakeUp(boolean state) {
        mPlotDataColorTag.add(state);
        if (WakeUpState == false  && state == true)
        {
            if (!mp.isPlaying())
            {
                num_wakeup = num_wakeup + 1;
                mp.start();//播放音频
            }

        }
        WakeUpState = state;
    }

    @Override
    public void onWakeUpScore(float score) {
//        mPlotData.add(score * mHeight);
    }

    @Override
    public void onAudioFrameCaptured(byte[] audioData, int bufferSize) {
        haveRecordedTime = haveRecordedTime + frame_times;
        mSKVWakeUp.yyWriteAudioData(audioData, bufferSize);
        if (haveRecordedTime > mPaintFlushTime) {
            haveRecordedTime = 0;
            drawFrame();
        }
    }

    @Override
    public void onAudioFrameCaptured(short[] audioData, int bufferSize) {
        /*for(int i = 0; i < bufferSize; i = i + 10)
        {
            mPlotData.add(audioData[i]);
        }*/
        haveRecordedTime = haveRecordedTime + frame_times;
        mSKVWakeUp.yyWriteAudioData(audioData, bufferSize);
        if (haveRecordedTime > mPaintFlushTime) {
            haveRecordedTime = 0;
            drawFrame();
        }
    }


    public VisualWakeUpAudioRecorder(Context context) {
        super(context);

        /* Build AudioRecorder */
        mAudioRecorder = new BasicAudioRecorder();
        isInitRecorder = mAudioRecorder.initRecorder(MediaRecorder.AudioSource.MIC, 16000,
                AudioFormat.CHANNEL_CONFIGURATION_MONO, AudioFormat.ENCODING_PCM_16BIT, 16);
        if (isInitRecorder) {
            Log.i(TAG, "Build AudioRecorder Sucess!");
            mAudioRecorder.setOnAudioFrameCapturedListener(this);
        } else {
            Log.i(TAG, "Build AudioRecorder Failted!");
        }

        frame_samples = mAudioRecorder.getSamplesPerBuffer();        // 获取一个buffer的样本数
        frame_sizes = mAudioRecorder.getSizesPerBuffer();
        frame_times = mAudioRecorder.getTimesPerBuffer();           // 获取一个buffer的持续的时间
        mNumChannel = mAudioRecorder.getChannels();
        mBitsPerSample = mAudioRecorder.getBitPerSample();
        mSampleRate = mAudioRecorder.getSampleRate();

        /* Build SKVWakeUp */
//        mSKVWakeUp = new SKVWakeUp(context);
//        isInitWakeUp = mSKVWakeUp.yyInitSKVWakeUp(mSampleRate, mBitsPerSample, mNumChannel);
//        if (isInitWakeUp) {
//            Log.i(TAG, "initialize SKVWakeUp Sucessed!");
//            mSKVWakeUp.yySetmWakeUpListener(this);
//            mSKVWakeUp.yySetMaxInBuffer(100 * 1000);
//            mSKVWakeUp.yySetMaxOutBuffer(100 * 1000);
//        } else {
//            Log.i(TAG, "initialize SKVWakeUp Failed!");
//        }
        initMP(context);//初始化mp对象
        isInitPainting = false;
    }

    public VisualWakeUpAudioRecorder(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);

        /* Build AudioRecorder */
        mAudioRecorder = new BasicAudioRecorder();
        isInitRecorder = mAudioRecorder.initRecorder(MediaRecorder.AudioSource.MIC, 16000,
                AudioFormat.CHANNEL_CONFIGURATION_MONO, AudioFormat.ENCODING_PCM_16BIT, 16);
        if (isInitRecorder) {
            Log.i(TAG, "Build AudioRecorder Sucess!");
            mAudioRecorder.setOnAudioFrameCapturedListener(this);
        } else {
            Log.i(TAG, "Build AudioRecorder Failted!");
        }

        frame_samples = mAudioRecorder.getSamplesPerBuffer();        // 获取一个buffer的样本数
        frame_sizes = mAudioRecorder.getSizesPerBuffer();
        frame_times = mAudioRecorder.getTimesPerBuffer();           // 获取一个buffer的持续的时间
        mNumChannel = mAudioRecorder.getChannels();
        mBitsPerSample = mAudioRecorder.getBitPerSample();
        mSampleRate = mAudioRecorder.getSampleRate();

        /* Build SKVWakeUp */
//        mSKVWakeUp = new SKVWakeUp(context);
//        isInitWakeUp = mSKVWakeUp.yyInitSKVWakeUp(mSampleRate, mBitsPerSample, mNumChannel);
//        if (isInitWakeUp) {
//            Log.i(TAG, "initialize SKVWakeUp Sucessed!");
//            mSKVWakeUp.yySetmWakeUpListener(this);
//            mSKVWakeUp.yySetMaxInBuffer(100 * 1000);
//            mSKVWakeUp.yySetMaxOutBuffer(100 * 1000);
//        } else {
//            Log.i(TAG, "initialize SKVWakeUp Failed!");
//        }
        initMP(context);//初始化mp对象
        isInitPainting = false;
    }

    public void setSKVWakeUp(SKVWakeUp mSKVWakeUp){
        this.mSKVWakeUp=mSKVWakeUp;
    }

    public void setAudioFrameCapturedListener(BasicAudioRecorder.OnAudioFrameCapturedListener listener){
        if(mAudioRecorder!=null){
            mAudioRecorder.setOnAudioFrameCapturedListener(listener);
        }
    }

    public boolean start(String WaveName) {
         /* Build painter */
        if (isInitPainting == false) {
            mPaint = new Paint();
            mHolder = getHolder();
            mSurfaceFrame = mHolder.getSurfaceFrame();

            mPaint.setColor(0xffffffff);
            mPaint.setAntiAlias(true);
            mPaint.setStrokeWidth(2);
            mPaint.setStrokeCap(Paint.Cap.ROUND);
            mPaint.setStyle(Paint.Style.STROKE);
            mWidth = mSurfaceFrame.width();
            mHeight = mSurfaceFrame.height();
            mCenterY = mHeight / 2;

            mPlotData = new SKVFloatCircleBuffer(mWidth);
            mPlotDataColorTag = new SKVBooleanCircleBuffer(mWidth);
            for (int i = 0; i < mWidth; i++) {
                mPlotData.add(0);
                mPlotDataColorTag.add(false);
            }
            isInitPainting = true;
        }

        haveRecordedTime = 0;
        if (null == mAudioRecorder) {
            mAudioRecorder = new BasicAudioRecorder();
            isInitRecorder = mAudioRecorder.initRecorder(MediaRecorder.AudioSource.MIC, 16000,
                    AudioFormat.CHANNEL_CONFIGURATION_MONO, AudioFormat.ENCODING_PCM_16BIT, 16);
//            if (isInitRecorder) {
//                mAudioRecorder.setOnAudioFrameCapturedListener(this);
//            } else {
//                Log.i(TAG, "Build AudioRecorder Failted!");
//            }
            frame_samples = mAudioRecorder.getSamplesPerBuffer();        // 获取一个buffer的样本数
            frame_sizes = mAudioRecorder.getSizesPerBuffer();
            frame_times = mAudioRecorder.getTimesPerBuffer();           // 获取一个buffer的持续的时间
            mNumChannel = mAudioRecorder.getChannels();
            mBitsPerSample = mAudioRecorder.getBitPerSample();
            mSampleRate = mAudioRecorder.getSampleRate();
        }
        if (isInitRecorder) {
            if (mAudioRecorder.Start()) {
                Log.i(TAG, "AudioRecorder Start Success!");
                if (WaveName == null || WaveName.length() <= 0) {
                    mRecordFileName = null;
                } else {
                    mAudioRecorder.StartRecordFile(WaveName);
                    mRecordFileName = mAudioRecorder.getmRecordFileName();
                }
            } else {
                Log.i(TAG, "AudioRecorder Start Failed!");
                return false;
            }
        } else {
            Log.i(TAG, "AudioRecorder cannot be initialized!");
            return false;
        }
//        if (isInitWakeUp == false) {
//            isInitWakeUp = mSKVWakeUp.yyInitSKVWakeUp(mSampleRate, mBitsPerSample, mNumChannel);
//            if (isInitWakeUp) {
//                Log.i(TAG, "initialize SKVWakeUp Sucessed!");
//                mSKVWakeUp.yySetmWakeUpListener(this);
//                mSKVWakeUp.yySetMaxInBuffer(100 * 1000);
//                mSKVWakeUp.yySetMaxOutBuffer(100 * 1000);
//            } else {
//                Log.i(TAG, "initialize SKVWakeUp Failed!");
//            }
//        }
        if (isInitWakeUp) {
            if (mSKVWakeUp.Start()) {
                Log.i(TAG, "mSKVWakeUp Start Success!");
            } else {
                Log.i(TAG, "mSKVWakeUp Start Failed!");
            }
        }
        num_wakeup = 0;
        return true;
    }

    public void pause() {
        // 暂停录音
        if (isInitRecorder) {
            mAudioRecorder.Pause();
        }
    }

    public int get_num_wakeup() {
        return num_wakeup;
    }

    public void stop() {
        // 停止录音
        if (isInitRecorder) {
            mAudioRecorder.Stop();
        }
        if (isInitWakeUp) {
            mSKVWakeUp.Stop();
        }
    }

    public String getRecordFileName() {
        return mRecordFileName;
    }

    public void release() {
        mAudioRecorder.release();
        mAudioRecorder = null;
        isInitRecorder = false;

        mSKVWakeUp.yyRelease();
        mSKVWakeUp = null;
        isInitWakeUp = false;
    }

    void drawFrame() {
        Canvas c = null;
        try {
            c = mHolder.lockCanvas();
            if (c != null) {
                drawCube(c);
            }
        } finally {
            if (c != null) mHolder.unlockCanvasAndPost(c);
        }
    }

    void drawCube(Canvas c) {
        c.save();
        c.drawColor(0xff000000);

        int i = 0;
        if (mPlotDataColorTag.get(i)) {
            mPaint.setColor(0xffff0000);
            mPaint.setStrokeWidth(6);
        } else {
            mPaint.setColor(0xffffffff);
            mPaint.setStrokeWidth(2);
        }
        float pre_y = mHeight - mPlotData.get(i);
        c.drawPoint(i, pre_y, mPaint);
        for (i = 1; i < mPlotData.size(); i++) {
            if (mPlotDataColorTag.get(i)) {
                mPaint.setColor(0xffff0000);
                mPaint.setStrokeWidth(6);
            } else {
                mPaint.setColor(0xffffffff);
                mPaint.setStrokeWidth(2);
            }
            c.drawLine(i - 1, pre_y, i, mHeight - mPlotData.get(i), mPaint);
            pre_y = mHeight - mPlotData.get(i);
        }
        c.restore();
    }

    void initMP(Context context)
    {
        try
        {
            AssetFileDescriptor fileDescriptor = context.getAssets().openFd("hello.wav");
            mp.setDataSource(fileDescriptor.getFileDescriptor(),fileDescriptor.getStartOffset(), fileDescriptor.getLength());
            mp.prepare();//mp就绪
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
    }


    @Override
    protected void finalize() throws Throwable
    {
        super.finalize();
    }
    public void onClose()
    {
        release();
    }
    public void surfaceChanged(SurfaceHolder holder, int format, int width, int height)
    {
        mHolder = holder;
        mSurfaceFrame = mHolder.getSurfaceFrame();
        mHeight = height;
        mWidth = width;
        mCenterY = mHeight / 2;
        drawFrame();
    }
    public void surfaceCreated(SurfaceHolder holder)
    {
        mHolder = holder;
        mSurfaceFrame = mHolder.getSurfaceFrame();
        for(int i = 0; i < mWidth; i++)
        {
            mPlotData.add(0);
            mPlotDataColorTag.add(false);
        }
        drawFrame();
    }
    public void surfaceDestroyed(SurfaceHolder holder)
    {
    }
}

