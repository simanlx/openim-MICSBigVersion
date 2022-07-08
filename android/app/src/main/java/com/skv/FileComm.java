package com.skv;

import android.annotation.SuppressLint;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.List;

@SuppressLint("SimpleDateFormat")
public class FileComm 
{
	static public void writedata(float xdata, String filename)
	{
		FileWriter fileWriter = null;
		try 
		{
			fileWriter=new FileWriter(filename,true);
			fileWriter.write(String.valueOf(xdata)+" ");
			fileWriter.flush();
			fileWriter.close();
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		}
	}

	static public void writestring(String xdata, String filename, boolean append)
	{
		FileWriter fileWriter = null;
		try 
		{
			fileWriter=new FileWriter(filename,append);
			fileWriter.write(xdata+ "\n");
			fileWriter.flush();
			fileWriter.close();
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		}
	}	
	
	static public void writeIntlist(List<Integer> data, String filename, boolean append)
	{		
		int nlen = data.size();
		FileWriter fileWriter = null;
		try 
		{
			fileWriter=new FileWriter(filename, append);
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日    HH:mm:ss");
			Date curDate = new Date(System.currentTimeMillis());//获取当前时间
			String str = formatter.format(curDate);
			fileWriter.write(str);
			
			for(int i = 0; i < nlen; i++)
			{
				fileWriter.write(String.valueOf(data.get(i))+" ");
			}
			fileWriter.write("\n");
			fileWriter.flush();
			fileWriter.close();
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		}
	}
	static public void writelist(List<Float> data, String filename, boolean append)
	{
		int nlen = data.size();
		FileWriter fileWriter = null;
		try 
		{
			fileWriter=new FileWriter(filename, append);
			
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy年MM月dd日    HH:mm:ss");
			Date curDate = new Date(System.currentTimeMillis());//获取当前时间
			String str = formatter.format(curDate);
			fileWriter.write(str);
			
			for(int i = 0; i < nlen; i++)
			{
				fileWriter.write(String.valueOf(data.get(i))+" ");
			}
			fileWriter.write("\n");
			fileWriter.flush();
			fileWriter.close();
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		}
	}
	static public void write1Ddata(float [] xdata, String filename)
	{
		FileWriter fileWriter = null;
		try 
		{
			fileWriter=new FileWriter(filename);
			for(int i = 0; i < xdata.length; i++)
			{
				fileWriter.write(String.valueOf(xdata[i])+" ");
			}
			fileWriter.write("\n");
			fileWriter.flush();
			fileWriter.close();
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		}
	}
	static public void write1Ddata(int [] xdata, String filename)
	{
		FileWriter fileWriter = null;
		try 
		{
			fileWriter=new FileWriter(filename);
			for(int i = 0; i < xdata.length; i++)
			{
				fileWriter.write(xdata[i] + " ");
			}
			fileWriter.write("\n");
			fileWriter.flush();
			fileWriter.close();
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		}
	}	
	
	
	static public void write2Ddata(float [][] xdata, String filename)
	{
		FileWriter fileWriter = null;
		try 
		{
			fileWriter=new FileWriter(filename);
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		}
		
		for(int i = 0; i < xdata.length; i++)
		{
			for(int j = 0; j < xdata[i].length; j++)
			{
				try
				{
					fileWriter.write(String.valueOf(xdata[i][j])+" ");
				}
				catch (IOException e)
				{
					e.printStackTrace();
				}
			}
			try 
			{
				fileWriter.write("\n");
			} 
			catch (IOException e)
			{
				e.printStackTrace();
			}
		}
		try 
		{
			fileWriter.flush();
			fileWriter.close();
		} 
		catch (IOException e)
		{
			e.printStackTrace();
		}
	}
	static public boolean fileIsExists(String strFile)
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
	
	static public boolean makeFile(String strFile)
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
}
