package com.skv;
import android.util.Log;

/**
 * Created by nss on 2017/10/31.
 */

public class SKVProcess
{
    String INFO_TAG = "SKVProcess: ";
    private boolean isInit = false;
    private int sampling_rate = 16000;
    private int bits_persample = 16;
    private int num_src_channel = 0;
    private int num_ref_channel = 2;
    private int num_channel = 0;
    private int frame_size = 256;
    public short [] histbuff = null;
    private int hlen = 0;

    // Used to load the 'SKVPreprocess' library on application startup.
    static {
        System.loadLibrary("SKVPreprocess");
    }
    public native int initialize(int sampling_rate, int bits_persample, int num_src_channel, int num_ref_channel);
    public native void destroy();
    public native short [] write_short(short [] in, int in_size);
    public native byte [] write_byte(byte [] in, int in_size);

    public SKVProcess()
    {
        this.frame_size = 256;
        this.hlen = 0;
        this.sampling_rate = 16000;
        this.bits_persample = 16;
        this.num_src_channel = 4;
        this.num_ref_channel = 2;
        this.num_channel = this.num_src_channel + this.num_ref_channel;
        this.isInit = false;
    }

    public boolean yyInitSKVProcessSdk(int sampling_rate, int bits_persample, int num_src_channel, int num_ref_channel)
    {
        if (sampling_rate != 16000 || bits_persample != 16 || num_src_channel < 1 || num_ref_channel < 1)
        {
            Log.e(this.INFO_TAG, "Cann't support your parameter, now only support sampling_rate = 16000, bits_persample = 16, num_src_channel > 0 and num_ref_channel > 0");
            return false;
        }

        this.frame_size = 256;
        this.histbuff = new short[ 2 * this.frame_size * this.num_channel];
        this.hlen = 0;
        int i = 0;
        for (i = 0; i < 2 * this.frame_size * this.num_channel; i++)
        {
            this.histbuff[i] = 0;
        }
        this.sampling_rate = sampling_rate;
        this.bits_persample = bits_persample;
        this.num_src_channel = num_src_channel;
        this.num_ref_channel = num_ref_channel;
        this.num_channel = this.num_src_channel + this.num_ref_channel;
        int state = initialize(sampling_rate, bits_persample, num_src_channel, num_ref_channel);
        switch (state)
        {
            case 1:
                this.isInit = true;
                Log.e(this.INFO_TAG, "Succeed to initialize SKVProcessSdk!");
                break;
            case 2:
                this.isInit = false;
                Log.e(this.INFO_TAG, "Error: Cann't support your parameter, now only support sampling_rate = 16000, bits_persample = 16, num_src_channel > 0 and num_ref_channel > 0");
                break;
            case 3:
                this.isInit = false;
                Log.e(this.INFO_TAG, "Error: Your so package has been exceed the limited date! Please contact with the writer by calling 15600616328");
                break;
            default:
                this.isInit = false;
                Log.e(this.INFO_TAG, "Error: Unknow errors!");
                break;
        }
        return this.isInit;
    }

    private short [] WriteBuffer(short [] data, int nlen, int left_ref_channel, int right_ref_channel)
    {
        int len = nlen + this.hlen * this.num_channel;
        int nSamples = len / this.num_channel;
        int in_samples = this.frame_size * (int)(nSamples / this.frame_size);
        int in_size = in_samples * this.num_channel;

        short [] in = null;
        if (in_size > 0)
        {
            in = new short[in_size];
        }

        int i = 0, c = 0, write_c = 0;
        for (i = 0; i < in_samples; i++)
        {
            if (i  < this.hlen)
            {
                for (c = 0; c < this.num_channel; c++)
                {
                    in[i * this.num_channel + c] = this.histbuff[i * this.num_channel + c];
                }
            }
            else
            {
                write_c = 0;
                for (c = 0; c < this.num_channel; c++)
                {
                    if (c == left_ref_channel)
                    {
                        in[i * this.num_channel + this.num_channel - 2] = data[(i - this.hlen) * this.num_channel + c];
                    }
                    else if (c == right_ref_channel)
                    {
                        in[i * this.num_channel + this.num_channel - 1] = data[(i - this.hlen) * this.num_channel + c];
                    }
                    else
                    {
                        in[i * this.num_channel + write_c] = data[(i - this.hlen) * this.num_channel + c];
                        write_c = write_c + 1;
                    }
                }
            }
        }

        int hhlen = nSamples - in_samples;
        if( hhlen > 0 )
        {
            for(i = in_samples; i < nSamples; i++)
            {
                if(i < this.hlen)
                {
                    for (c = 0; c < this.num_channel; c++)
                    {
                        histbuff[(i - in_samples) * this.num_channel + c] = histbuff[i * this.num_channel + c];
                    }
                }
                else
                {
                    write_c = 0;
                    for (c = 0; c < this.num_channel; c++)
                    {
                        if (c == left_ref_channel)
                        {
                            histbuff[(i - in_samples) * this.num_channel + this.num_channel - 2] = data[(i - this.hlen) * this.num_channel + c];
                        }
                        else if (c == right_ref_channel)
                        {
                            histbuff[(i - in_samples)  * this.num_channel + this.num_channel - 1] = data[(i - this.hlen) * this.num_channel + c];
                        }
                        else
                        {
                            histbuff[(i - in_samples) * this.num_channel + write_c] = data[ (i - this.hlen) * this.num_channel + c ];
                            write_c = write_c + 1;
                        }
                    }
                }
            }
        }
        else
        {
            hhlen = 0;
        }
        this.hlen = hhlen;

        return in;
    }

    public short [] yyWriteAudioData(short[] in, int in_size, int left_ref_channel, int right_ref_channel)
    {
        if (this.isInit == false)
        {
            Log.e(this.INFO_TAG, "Error: SKVProcessSdk didn't initialied!");
            return null;
        }
        if ( in == null || in_size < 0 )
        {
            Log.e(this.INFO_TAG, "Error: input audio data is null!");
            return null;
        }
        if(left_ref_channel < 0 || left_ref_channel >= this.num_channel || right_ref_channel < 0 || right_ref_channel >= this.num_channel)
        {
            Log.e(this.INFO_TAG, "Error: left_ref_channel or left_ref_channel must be in [0, 1, 2,..., " + this.num_channel + "]!");
            return null;
        }
        short [] out = null;
        int nSamples = in_size / this.num_channel;
        if( nSamples % this.frame_size == 0 && left_ref_channel >= this.num_channel - 2 && right_ref_channel >= this.num_channel - 2 )
        {
            out = write_short(in, in_size);
            return out;
        }
        short [] in_audio = WriteBuffer( in, in_size, left_ref_channel, right_ref_channel );
        if (in_audio != null)
        {
            out = write_short(in_audio, in_audio.length);
        }
        return out;
    }

    public void yyRelease()
    {
        this.histbuff = null;
        this.hlen = 0;
        this.isInit = false;
        destroy();
    }
}
