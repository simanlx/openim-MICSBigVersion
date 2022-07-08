package com.skv;
/**
 * Created by nss on 2018/1/2.
 */
public class SKVBooleanCircleBuffer
{
    public boolean [] data;
    public int len;
    int write_ptr;

    public SKVBooleanCircleBuffer(int size)
    {
        write_ptr = 0;
        len = size;
        data = new boolean[size];
        for (int i = 0; i < size; i++)
        {
            data[i] = false;
        }
    }
    public void clear_buffer()
    {
        write_ptr = 0;
        int i = 0;
        for (i = 0; i < len; i++)
        {
            data[i] = false;
        }
    }
    public void add(boolean aData)
    {
        data[write_ptr] = aData;
        write_ptr = (write_ptr + 1) % len;
    }
    public boolean get(int i)
    {
        return data[(write_ptr + i) % len];
    }
    public int size()
    {
        return len;
    }
}
