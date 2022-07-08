package com.skv;
/**
 * Created by nss on 2018/1/2.
 */
public class SKVFloatCircleBuffer
{
    public float [] data;
    public int len;
    int write_ptr;

    public SKVFloatCircleBuffer(int size)
    {
        write_ptr = 0;
        len = size;
        data = new float[size];
        for (int i = 0; i < size; i++)
        {
            data[i] = 0.0f;
        }
    }
    public void clear_buffer()
    {
        write_ptr = 0;
        int i = 0;
        for (i = 0; i < len; i++)
        {
            data[i] = 0;
        }
    }
    public void add(float aData)
    {
        data[write_ptr] = aData;
        write_ptr = (write_ptr + 1) % len;
    }
    public float get(int i)
    {
        return data[(write_ptr + i) % len];
    }
    public int size()
    {
        return len;
    }
}
