package com.skv;

import android.media.AudioFormat;
import android.media.AudioRecord;
import android.media.MediaRecorder;
import android.os.Environment;
import android.util.Log;

import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;

public class BasicAudioRecorder implements Runnable
{
	private static final String TAG 					  = "AudioRecorder";
	private static final int DEFAULT_SOURCE 		  = MediaRecorder.AudioSource.MIC;
	private static final int DEFAULT_SAMPLE_RATE 	  = 16000;
	private static final int DEFAULT_CHANNEL_CONFIG  = AudioFormat.CHANNEL_CONFIGURATION_MONO; // AudioFormat.CHANNEL_CONFIGURATION_MONO
	private static final int DEFAULT_DATA_FORMAT 	  = AudioFormat.ENCODING_PCM_16BIT;
	//private static final String FILE_PATH 			  = Environment.getExternalStorageDirectory().getAbsolutePath()+"/cache/";
	private String FILE_PATH 			  				  = null;

    // 传送录音buffer的监听，一旦录制一个buffer的数据，就将数据传送出去进行处理
	public interface OnAudioFrameCapturedListener
	{
		void onAudioFrameCaptured(byte[] audioData, int bufferSize);
		void onAudioFrameCaptured(short[] buffer, int bufferSize);
	}
	private OnAudioFrameCapturedListener mAudioFrameCapturedListener = null;

	private WavFileWriter mWavFileWirter = null;      // 录音文件保存对象
	private AudioRecord mAudioRecord   = null;        // 录音对象
    private Thread mCaptureThread 		 = null;

    private int mBitPerSample 			= 16;        // 录音量化率，默认16bit
    private int nChannels 				= 1;         // 录音麦克风个数，默认单麦克
    private int mSampleRate 				= 16000;    // 录音采样率，默认16000
	private String mRecordFileName  		= "";    	// 录音文件保存的文件名

    private int mSamplesPerBuffer 		= 256;    	// 每个buffer录制的声音样本数
    private int mTimesPerBuffer   		= 16;       // buffer间隔时间,单位ms,即，每BufferTimes录制一个buffer
    private int mSizesPerBuffer    		= 0;        // 每个buffer的字节数（大小)
	public static int mSampleSizePerBuffer		= 0;

    private boolean mIsWritingRecordWav = false;
    private boolean mIsInitial 		 	= false;
    public boolean mIsCaptureStarted 	= false;

    public BasicAudioRecorder()
    {
		mIsInitial 		 		= false;
		mIsCaptureStarted 		= false;
		mIsWritingRecordWav 	= false;

		mAudioFrameCapturedListener 	= null;
        mAudioRecord 					= null;
		mWavFileWirter 					= null;
		mCaptureThread 					= null;

		if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED))
		{
			FILE_PATH = Environment.getExternalStorageDirectory().getAbsolutePath()+"/cache/";
			File fpath = new File(FILE_PATH);
			if ( !fpath.exists() )
			{
				fpath.mkdirs();
			}
		}
		else
		{
			FILE_PATH = null;
		}


		mSampleRate 		= DEFAULT_SAMPLE_RATE;     		// 录音采样率，默认16000
		mTimesPerBuffer		= 16;
		if ( DEFAULT_DATA_FORMAT == AudioFormat.ENCODING_PCM_16BIT)
		{
			mBitPerSample = 16;
		}
		else
		{
			mBitPerSample = 8;
		}
		if (DEFAULT_CHANNEL_CONFIG == AudioFormat.CHANNEL_CONFIGURATION_MONO)
		{
			nChannels = 1;
		}
		else
		{
			nChannels = 2;
		}
		mIsInitial = initRecorder(DEFAULT_SOURCE, DEFAULT_SAMPLE_RATE, DEFAULT_CHANNEL_CONFIG, DEFAULT_DATA_FORMAT, mTimesPerBuffer);
    }
    
    /**
     * 初始化录音类
     * @param
     * audioSource  	 :  麦克风           AudioSource.MIC
     * sampleRate    	 :  采样率           16000
     * channelConfig 	 :  麦克风个数        1
     * audioFormat   	 :  量化率           16
     * milesecond    	 :  录制每个buffer的时间间隔，单位ms，即：一个buffer读取samples个的声音样本
     * @example
     * initRecorder(AudioSource.MIC, 16000, AudioFormat.CHANNEL_CONFIGURATION_MONO, AudioFormat.ENCODING_PCM_16BIT, 32);
     */
    public boolean initRecorder(int audioSource, int sampleRate, int channelConfig, int audioFormat, int milesecond)
    {
		mIsInitial		 		= false;
		mIsCaptureStarted 		= false;
		mIsWritingRecordWav 	= false;

		mAudioFrameCapturedListener = null;
		mAudioRecord 		= null;
		mWavFileWirter 		= null;
		mCaptureThread		= null;

    	mSampleRate 	= sampleRate;
		if ( audioFormat == AudioFormat.ENCODING_PCM_16BIT)
		{
			mBitPerSample = 16;
		}
		else
		{
			mBitPerSample = 8;
		}
		if ( channelConfig == AudioFormat.CHANNEL_CONFIGURATION_MONO )
		{
			nChannels = 1;
		}
		else
		{
			nChannels = 2;
		}

		int minBufferSize = AudioRecord.getMinBufferSize(sampleRate, channelConfig, audioFormat);
		if (minBufferSize == AudioRecord.ERROR_BAD_VALUE)
		{
			Log.e(TAG, "Invalid parameter !");
			return false;
		}

		mSamplesPerBuffer 	= milesecond * mSampleRate / 1000;
		mSizesPerBuffer 	= mSamplesPerBuffer * nChannels * mBitPerSample / 8;
		if ( mSizesPerBuffer < minBufferSize )
		{
			mSizesPerBuffer 		= minBufferSize;
			mSamplesPerBuffer 		= mSizesPerBuffer / (nChannels * mBitPerSample / 8);
		}
        mTimesPerBuffer = (1000 * mSamplesPerBuffer) / mSampleRate;
		mSampleSizePerBuffer = mSamplesPerBuffer * nChannels;

		mAudioRecord = new AudioRecord(audioSource, sampleRate, channelConfig, audioFormat, mSizesPerBuffer);
		if (mAudioRecord.getState() == AudioRecord.STATE_UNINITIALIZED)
		{
			Log.e(TAG, "AudioRecord initialize fail !");
			mIsInitial = false;
		}
		else
		{
			Log.e(TAG, "AudioRecord initialize success !");
			mIsInitial = true;
		}
		return mIsInitial;
    }

	// 开启获取录音数据的线程
	public boolean Start()
	{
		if( startRecord() )
		{
			if ( mCaptureThread != null && mCaptureThread.isAlive())
			{
				mCaptureThread.interrupt();
				mCaptureThread = null;
			}
			mCaptureThread = new Thread(this);
			mIsCaptureStarted = true;
			if (null != mCaptureThread && Thread.State.NEW == mCaptureThread.getState())
			{
				mCaptureThread.start();
			}
			if(false == mCaptureThread.isAlive())
			{
				mIsCaptureStarted = false;
				Log.d(TAG, "Start audio capture failed !");
				return false;
			}
			Log.d(TAG, "Start audio capture success !");
			return true;
		}
		else
		{
			mIsCaptureStarted = false;
			Log.d(TAG, "Start audio capture failed !");
			return false;
		}
	}
	// 停止获取录音数据的线程
	public void Stop()
	{
		mIsCaptureStarted = false;
		if (mCaptureThread != null && mCaptureThread.isAlive())
		{
			try
			{
				mCaptureThread.interrupt();
				mCaptureThread.join(1000);
				mCaptureThread = null;
			}
			catch (InterruptedException e)
			{
				e.printStackTrace();
			}
		}
		stopRecord();
		StopRecordFile();
	}

	public void Pause()
	{
		mIsCaptureStarted = false;
		if (mCaptureThread != null && mCaptureThread.isAlive())
		{
			try
			{
				mCaptureThread.interrupt();
				mCaptureThread.join(1000);
				mCaptureThread = null;
			}
			catch (InterruptedException e)
			{
				e.printStackTrace();
			}
		}
		stopRecord();
	}

    // 开始录音
	public boolean startRecord()
    {
		if(null != mAudioRecord && AudioRecord.STATE_INITIALIZED == mAudioRecord.getState())
		{
			if(AudioRecord.RECORDSTATE_RECORDING == mAudioRecord.getRecordingState())
			{
				stopRecord();
			}
			mAudioRecord.startRecording();
			return true;
		}
		return false;
    }
    // 结束录音
    @SuppressWarnings("deprecation")
	public void stopRecord()
    {
		if (null != mAudioRecord && AudioRecord.RECORDSTATE_RECORDING == mAudioRecord.getRecordingState())
		{
			mAudioRecord.stop();
		}
    }

    // 获取录音数据的线程
    public void run()  
    {
    	int ret = 0;
    	while ( mIsCaptureStarted )
        {
        	short [] buffer = new short[mSampleSizePerBuffer];
			ret = mAudioRecord.read(buffer, 0, buffer.length);
			if (ret == AudioRecord.ERROR_INVALID_OPERATION)
			{
				Log.e(TAG, "Error ERROR_INVALID_OPERATION");
			}
			else if (ret == AudioRecord.ERROR_BAD_VALUE)
			{
				Log.e(TAG, "Error ERROR_BAD_VALUE");
			}
			else
        	{
				if (mAudioFrameCapturedListener != null)
				{
					mAudioFrameCapturedListener.onAudioFrameCaptured(buffer, ret);
				}
				if ( null != mWavFileWirter && mIsWritingRecordWav)
				{
					mWavFileWirter.writeData(buffer, 0, ret);
				}
        	}
        }
    }

	// 开始将录音数据保存成wav文件
	public void StartRecordFile(String FileNamePrefix)
	{
		if(mIsInitial && FILE_PATH != null)
		{
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd-HH-mm-ss");
			Date curDate = new Date(System.currentTimeMillis());
			String str = formatter.format(curDate);

			mRecordFileName = FILE_PATH + FileNamePrefix + "_" + str + ".wav";

			if(mWavFileWirter != null && mIsWritingRecordWav)
			{
				StopRecordFile();
			}
			mWavFileWirter = null;

			mWavFileWirter = new WavFileWriter();
			try
			{
				mWavFileWirter.openFile(mRecordFileName, mSampleRate, mBitPerSample, nChannels);
				mIsWritingRecordWav = true;
			}
			catch (IOException e)
			{
				mIsWritingRecordWav = false;
				e.printStackTrace();
			}
		}
		else
		{
			mIsWritingRecordWav = false;
		}
	}

	// 结束将录音数据保存成wav文件
	public void StopRecordFile()
	{
		if(mWavFileWirter != null && mIsWritingRecordWav)
		{
			try
			{
				mWavFileWirter.closeFile();
			}
			catch (IOException e)
			{
				e.printStackTrace();
			}
		}
		mIsWritingRecordWav = false;
	}

	@SuppressWarnings("deprecation")
	public void release()
    {
        Stop();
    	if( mAudioRecord != null )
    	{
			mAudioRecord.release();
    	}
		mAudioRecord = null;
		mCaptureThread = null;
		mWavFileWirter = null;
    }
    
    @Override
    protected void finalize() throws Throwable
    {
		release();
        super.finalize();
    }

	public void setOnAudioFrameCapturedListener(OnAudioFrameCapturedListener listener)
	{
		mAudioFrameCapturedListener = listener;
	}
	public int getSamplesPerBuffer()
	{
		return mSamplesPerBuffer;
	}
	public int getSizesPerBuffer()
	{
		return mSizesPerBuffer;
	}
	public int getTimesPerBuffer()
	{
		return mTimesPerBuffer;
	}
	public String getmRecordFileName() { return mRecordFileName; }
	public int getBitPerSample() { return mBitPerSample; }
	public int getChannels() { return nChannels; }
	public int getSampleRate() { return mSampleRate; }
	public boolean isRecording() {
		return mIsCaptureStarted;
	}
	public boolean isWritingRecordWav() { return mIsWritingRecordWav; }
}