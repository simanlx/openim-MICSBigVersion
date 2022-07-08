package com.skv;

import android.content.Context;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by nss on 2018/1/1.
 */
public class SKVWakeUp implements Runnable
{
    private String INFO         = "SKVWakeUp_Info";
    private Thread thread 		= null;
    public boolean isThreading 	= false;

    private String PATH 		= "";
    private String model 		= "";

    private boolean isInit 		    = false;
    private boolean ifHavemodel 	= false;

    private int sampleRate 		= 16000;
    private int bSamples 		= 16;
    private int numMic 			= 1;

    /* InBufferList 输入语音数据缓冲区 */
    private List<short[]> InBufferList 	= null;
    /* OutBufferList 输出识别结果Score缓冲区 */
    private List<Float> OutBufferList 	= null;

    private int MaxInBufferList 	= 100 * 62; // 100s
    private int MaxOutBufferList 	= 3600;	    // 3600s

    private int frame_samples 	        = 256;
    private int frame_samples_size 	    = 256;
    private int hlen 	                = 0;
    private short [] histbuff           = null;

    private Context mContext;

    // 传送唤醒结果的监听
    public interface OnWakeUpListener
    {
        public void onIsWakeUp(boolean state);
        public void onWakeUpScore(float score);
    }
    public OnWakeUpListener mWakeUpListener = null;

    //public native int initialize(int sampling_rate, int bits_persample, int num_channel, String model_name);
    public native int initialize(int sampling_rate, int bits_persample, int num_channel);
    public native void destroy();
    public native float write_short(short [] in, int in_size, int use_channel);
    public native float write_byte(byte [] in, int in_size, int use_channel);
    public native int wakeup_state();
    static
    {
        System.loadLibrary("SKVWakeUp");
    }

    public void yySetmWakeUpListener(OnWakeUpListener mWakeUpListener)
    {
        this.mWakeUpListener = mWakeUpListener;
    }

    public void yySetMaxInBuffer(int millisecond)
    {
        this.MaxInBufferList = millisecond * this.sampleRate / 1000 / this.frame_samples;
    }
    public void yySetMaxOutBuffer(int millisecond)
    {
        this.MaxOutBufferList = millisecond * this.sampleRate / 1000 / this.frame_samples;
    }

    public boolean EmptyInBuffer()
    {
        return InBufferList.isEmpty();
    }
    public int SizeInBuffer()
    {
        return InBufferList.size();
    }
    public boolean EmptyOutBuffer()
    {
        return OutBufferList.isEmpty();
    }
    public int SizeOutBuffer()
    {
        return OutBufferList.size();
    }

    private byte[] shortToByteArray(short s)
    {
        byte[] shortBuf = new byte[2];
        for(int i = 0; i < 2; i++)
        {
            int offset = (shortBuf.length - 1 -i)*8;
            shortBuf[i] = (byte)((s>>>offset)&0xff);
        }
        return shortBuf;
    }
    private byte [] Short2Byte(short [] finalenData, int sLen)
    {
        byte [] data_byt = null;
        int nlen = 0;
        if (bSamples == 16)
        {
            nlen = sLen * 2;
            data_byt = new byte[nlen];
            short a;
            byte [] b = null;

            for(int j = 0; j < sLen; j = j+1)
            {
                a = (short) (finalenData[j]);
                b = shortToByteArray(a);
                data_byt[2*j] = b[0];
                data_byt[2*j+1] = b[1];
            }
        }
        else
        {
            nlen = sLen;
            data_byt = new byte[nlen];
            byte b;
            for (int i = 0; i < sLen; ++i)
            {
                b = (byte)(finalenData[i]);
                data_byt[i] = b;
            }

        }
        return data_byt;
    }
    private short [] Bytes2Shorts(byte [] audioData, int dataLength)
    {
        int mBytePerSample  = bSamples / 8;
        int mOffSet         = mBytePerSample;
        int buffer_size     = dataLength / mOffSet;
        short [] data     	= new short[buffer_size];
        byte  [] mByteArrayPerSample = new byte[mBytePerSample];
        for (int i = 0; i < buffer_size; i++)
        {
            for (int j = 0; j < mBytePerSample; j++)
            {
                mByteArrayPerSample[j] = audioData[ i * mOffSet + j];
            }
            data[i] = Utility.byteArrayToShort(mByteArrayPerSample);
        }
        return data;
    }

    private void inputOneFrame(short[] in_frame, int in_frame_size)
    {
        if(InBufferList == null)
        {
            InBufferList = new ArrayList<short[]>();
        }
        InBufferList.add(in_frame);
        if(InBufferList.size() > MaxInBufferList)
        {
            InBufferList.remove(0);
        }
    }

    private void WriteBuffer(short [] data, int nlen)
    {
        int len = nlen + this.hlen;

        int s = 0;
        int e = s + this.frame_samples_size;
        while( e <= len )
        {
            short [] mSig = new short[this.frame_samples_size];
            for(int i = s; i < e; i++)
            {
                if(i < this.hlen)
                {
                    mSig[i - s] = histbuff[i];
                }
                else
                {
                    mSig[i - s] = data[i - this.hlen];
                }
            }
            inputOneFrame(mSig, mSig.length);

            s = e;
            e = s + this.frame_samples_size;
        }

        int hhlen = len - s;
        if( hhlen > 0 )
        {
            for(int i = s; i < len; i++)
            {
                if(i < this.hlen)
                {
                    histbuff[i - s] = histbuff[i];
                }
                else
                {
                    histbuff[i - s] = data[i - this.hlen];
                }
            }
        }
        else
        {
            hhlen = 0;
        }
        hlen = hhlen;
    }

    public void yyWriteAudioData(float[] in, int in_size)
    {
        short []in_short = new short[in_size];
        for (int i = 0; i < in_size; i++)
        {
            in_short[i] = (short)(in[i]);
        }
        WriteBuffer( in_short, in_size );
    }

    public void yyWriteAudioData(short[] in, int in_size)
    {
        WriteBuffer(in, in_size);
    }

    public void yyWriteAudioData(byte[] in, int in_size)
    {
        short [] in_short = Bytes2Shorts(in, in_size);
        WriteBuffer(in_short, in_short.length);
    }

    public void reset()
    {
        Stop();
        this.hlen = 0;
        if(InBufferList != null)
        {
            InBufferList.clear();
        }
        if(OutBufferList != null)
        {
            OutBufferList.clear();
        }
    }

    public void yyRelease()
    {
        Stop();
        this.histbuff = null;
        this.hlen = 0;
        this.isInit = false;
        if(InBufferList != null)
        {
            InBufferList.clear();
            InBufferList = null;
        }
        if(OutBufferList != null)
        {
            OutBufferList.clear();
            OutBufferList = null;
        }
    }
    public boolean Start()
    {
        if (isInit)
        {
            if (thread != null && thread.isAlive())
            {
                thread.interrupt();
                thread = null;
            }
            thread = new Thread(this);
            isThreading = true;
            if (null != thread && Thread.State.NEW == thread .getState())
            {
                thread.start();
            }
            if( null != thread && thread.isAlive() == false)
            {
                isThreading = false;
            }
        }
        return isThreading;
    }

    public void Stop()
    {
        isThreading = false;
        if (thread != null && thread.isAlive())
        {
            thread.interrupt();
            thread = null;
        }
    }

    void decision(float score, int tstate)
    {
        OutBufferList.add(score);
        while(OutBufferList.size() > MaxOutBufferList)
        {
            OutBufferList.remove(0);
        }
        if(mWakeUpListener != null)
        {
            mWakeUpListener.onWakeUpScore(score);
            if ( tstate > 0)
            {
                mWakeUpListener.onIsWakeUp(true);
            }
            else
            {
                mWakeUpListener.onIsWakeUp(false);
            }
        }
    }

    public void run()
    {
        while (isThreading)
        {
            if (InBufferList != null && !InBufferList.isEmpty())
            {
                float score = 0;
                short [] oneFrame = InBufferList.remove(0);
                if (isInit && null != oneFrame)
                {
                    score = write_short(oneFrame, oneFrame.length, 0);
                    int tstate = wakeup_state();
                    decision(score, tstate);
                }
            }
            else
            {
                synchronized(this)
                {
                    try
                    {
                        wait(100);
                    }
                    catch (InterruptedException e)
                    {
                        e.printStackTrace();
                    }
                }
            }
        }
    }

    public SKVWakeUp(Context context)
    {
        this.mContext = context;
        /*PATH = Environment.getExternalStorageDirectory().getPath() + "/WakeUp/";
        if( !fileIsExists(PATH) )
        {
            makeFile(PATH);
        }
        this.model = PATH + "kaldi.model";
        if( fileIsExists(this.model) )
        {
            this.ifHavemodel = true;
        }
        else
        {
            this.ifHavemodel = assetsCopyData("kaldi.model", this.model);
        }*/

        this.InBufferList  = new ArrayList<short[]>();
        this.OutBufferList = new ArrayList<Float>();

        this.isInit 			= false;

        this.hlen 		= 0;
        this.histbuff 	= null;

        this.isThreading 			= false;
        this.thread 				= null;
        this.mWakeUpListener = null;
    }

    public boolean yyInitSKVWakeUp(int sampling_rate, int bits_persample, int num_channel)
    {
        this.sampleRate = sampling_rate;
        this.bSamples 	= bits_persample;
        this.numMic 	= num_channel;
        this.frame_samples = 256;
        this.frame_samples_size = this.frame_samples * this.numMic;

        this.yySetMaxInBuffer(100000); 	// 100s
        this.yySetMaxOutBuffer(3600000); // 3600s

        this.histbuff = null;
        this.histbuff = new short[this.frame_samples_size];
        this.hlen = 0;

        this.isInit = false;
        this.mWakeUpListener = null;
        this.isThreading = false;

        if(InBufferList == null)
        {
            InBufferList = new ArrayList<short[]>();
        }
        if(OutBufferList == null)
        {
            OutBufferList = new ArrayList<Float>();
        }
        if(thread == null)
        {
            thread = new Thread(this);
        }
        //if(ifHavemodel)
        //{
            //int init_state = initialize(this.sampleRate, this.bSamples, this.numMic, this.model);
        int init_state = initialize(this.sampleRate, this.bSamples, this.numMic);
        switch (init_state)
        {
            case 1:
                Log.i(INFO, "SKVWakeUp Initialize Sucessed !");
                this.isInit = true;
                break;
            case 2:
                Log.i(INFO, "SKVWakeUp Initialize failed, because of the unsupported the parameter of audio !");
                this.isInit = false;
                break;
            case 3:
                Log.i(INFO, "SKVWakeUp Initialize failed, because of Exceeding the limited date !");
                this.isInit = false;
                break;
            case 4:
                Log.i(INFO, "SKVWakeUp Initialize failed, because of Unknown error !");
                this.isInit = false;
                break;
            default:
                Log.i(INFO, "SKVWakeUp Initialize failed, because of Unknown error !");
                this.isInit = false;
                break;
        }
        //}
        return this.isInit;
    }

    private boolean fileIsExists(String strFile)
    {
        try
        {
            File f = new File(strFile);
            if( !f.exists() )
            {
                return false;
            }
        }
        catch (Exception e)
        {
            return false;
        }
        return true;
    }

    private boolean makeFile(String strFile)
    {
        try
        {
            File f = new File(strFile);
            f.mkdir();
        }
        catch (Exception e)
        {
            return false;
        }
        return true;
    }

    private boolean assetsCopyData(String strAssetsFilePath, String strDesFilePath)
    {
        boolean bIsSuc = true;
        InputStream inputStream = null;
        OutputStream outputStream = null;

        File file = new File(strDesFilePath);
        if ( !file.exists() )
        {
            try
            {
                file.createNewFile();
                Runtime.getRuntime().exec("chmod 766 " + file);
            }
            catch (IOException e)
            {
                bIsSuc = false;
            }
        }
        else
        {
            return true;
        }

        try
        {
            inputStream = mContext.getAssets().open(strAssetsFilePath);
            outputStream = new FileOutputStream(file);

            int nLen = 0 ;

            byte[] buff = new byte[1024*1];
            while((nLen = inputStream.read(buff)) > 0)
            {
                outputStream.write(buff, 0, nLen);
            }
        }
        catch (IOException e)
        {
            bIsSuc = false;
        }
        finally
        {
            try
            {
                if (outputStream != null)
                {
                    outputStream.close();
                }

                if (inputStream != null)
                {
                    inputStream.close();
                }
            }
            catch (IOException e)
            {
                bIsSuc = false;
            }
        }
        return bIsSuc;
    }
}

