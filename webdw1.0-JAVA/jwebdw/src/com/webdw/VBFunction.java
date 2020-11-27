package com.webdw;

import java.math.*;
import java.util.*;
import java.awt.Container;

import javax.swing.JDialog;
import javax.swing.JFrame;
import java.util.ArrayList;
import java.awt.event.*;

import javax.swing.*;

/**
 * 这个类定义了许多VB方法的Java实现，避免重复书写代码
 * 
 * @author admin
 * 
 */
public class VBFunction {
	public void ReadMe() {
		System.out.println("这个类定义了许多VB方法的Java实现，避免重复书写代码");
		System.out.println(Golbal.JWebDWInfo);
	}

	/**
	 * 提供与VB函数InStr相同的功能,VB的字符串返回,是从1开始的,所以将返回值加1返回
	 * 返回0代表找不到
	 * @param beginPos,有效位置从1开始
	 * @param string1
	 * @param findString
	 * @return
	 */
	public static int InStr(int beginPos, String string1, String findString) {
		int ipos;
		if (string1 == null || string1.equals("")) {
			return -1;
		}
		if (beginPos<1){
			beginPos=1;
		}
		ipos = string1.indexOf(findString, beginPos - 1);
		return ipos + 1;
	}

	public static int InStr(String string1, String findString) {
		return InStr(0, string1, findString);
	}

	/**
	 * 提供与VB函数Len相同的功能
	 * 
	 * @param inStr
	 * @return
	 */
	public static int Len(String inStr) {
		if (inStr == null) {
			return 0;
		}
		return inStr.length();
	}

	/**
	 * 提供与VB函数Mid相同的功能,VB的字符串计算,下标从1开始.
	 * 
	 * @param str1
	 * @param pos
	 * @param length
	 * @return
	 */
	public static String Mid(String str1, int pos, int length) {
		if (length <= 0) {
			return "";
		}
		return str1.substring(pos - 1, pos + length - 1);
	}

	public static String Mid(String str1, int pos) {
		return str1.substring(pos - 1);
	}

	/**
	 * 提供与VB函数Left相同的功能,获得左面几个字符的数据
	 * 
	 * @param instr
	 * @param i
	 * @return
	 */
	public String Left(String instr, int i) {
		if (instr.length() >= i) {
			return instr.substring(0, i);
		} else {
			return instr;
		}
	}

	/**
	 * 提供与VB函数Right相同的功能,获得右面几个字符的数据
	 * 
	 * @param instr
	 * @param i
	 * @return
	 */
	public String Right(String instr, int i) {
		return instr.substring(instr.length() - i);
	}

	// 得到指定Asc码对应的字符串
	public String Chr(int i) {
		if (i == 9)
			return "\t";
		if (i == 13)
			return "\r";
		if (i == 10)
			return "\n";
		return "";
	}

	/**
	 * 将字符串转换成整数
	 * 
	 * @param s
	 * @return
	 */
	public int toInt(String s) {
		try {
			return Integer.parseInt(s);
		} catch (Exception e) {
			// e.printStackTrace();
			// System.out.println("ERROR Data ToInt:*"+s+"*");
			return 0;
		}
	}

	/**
	 * 将字符串转换成数值
	 * 
	 * @param s
	 * @return
	 */
	public double toDouble(String s) {
		try {
			return Double.parseDouble(s);
		} catch (Exception e) {
			// e.printStackTrace();
			// System.out.println("ERROR Data ToInt:*"+s+"*");
			return 0;
		}
	}

	public static String UCase(String inStr) {
		return inStr.toUpperCase();
	}

	public String[] Split(String inStr1, String sepStr) {
		// return inStr.split(sepStr);
		int arraynum = 0;
		String data[] = new String[1000];
		int i = 0;
		int tempi = 0;
		tempi = InStr(i, inStr1, sepStr);
		while (tempi > 0) {
			if (i == 0) {
				// 第一个元素,从1开始计算
				data[arraynum] = Mid(inStr1, 1, tempi - i - 1);
			} else {
				data[arraynum] = Mid(inStr1, i + sepStr.length(), tempi - i
						- sepStr.length());
			}
			arraynum++;
			i = tempi;
			tempi = InStr(i+1, inStr1, sepStr);
		}
		if (i == 0) {
			data[arraynum] = inStr1;
		} else {
			data[arraynum] = Mid(inStr1, i + sepStr.length());
		}
		arraynum++;
		String newdata[] = new String[arraynum];
		for (i = 0; i < arraynum; i++) {
			newdata[i] = data[i];
		}
		return newdata;
	}

	/**
	 * 得到数组的最大下标
	 * 
	 * @param instr
	 * @return
	 */
	public int UBound(String[] instr) {
		return instr.length - 1;
	}

	/**
	 * 去掉字符串两面的空格
	 * 
	 * @param inStr
	 * @return
	 */
	public String Trim(String inStr) {
		return inStr.trim();
	}

	/**
	 * 替换字符串中的内容
	 * 
	 * @param instr
	 * @param str1
	 * @param str2
	 * @return
	 */
	public String Replace(String instr, String str1, String str2) {
		return instr.replaceAll(str1, str2);
	}

	/**
	 * 得到当前时间的表示
	 * 
	 * @return
	 */
	public String Now() {
		return new java.util.Date().toString();
	}

	public long RGB(int r, int g, int b) {
		return r * 256 * 256 + g * 256 + b;
	}

	public int Asc(String s) {
		if (s == null) {
			s = " ";
		}
		if (s.length() == 0) {
			s = " ";
		}
		return s.charAt(0);
	}

	/**
	 * 判断S1 > S2
	 * 
	 * @param s1
	 * @param s2
	 * @return
	 */
	public boolean IsGreat(String s1, String s2) {
		if (s1.length() > 0 && s2.length() > 0) {
			if (s1.charAt(0) > s2.charAt(0)) {
				return true;
			}
			if (s1.charAt(0) < s2.charAt(0)) {
				return false;
			}
			s1 = s1.substring(1);
			s2 = s2.substring(1);
			return IsGreat(s1, s2);
		}

		if (s1.length() > 0 && s2.length() == 0) {
			return true;
		}

		if (s1.length() == 0 && s2.length() > 0) {
			return false;
		}
		return true;
	}

	public boolean IsNumeric(String s1) {
		try {
			double d = Double.parseDouble(s1);
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	public double Rnd(double d) {
		Random r = new Random();
		return r.nextDouble();
	}
	
	//弹出一个类似VB的Windows标准对话框
	static JFrame f1 = new JFrame();
	static MessageJDialog d1 = null;
	public static void MessageBox(String title,String info){
		f1 = new JFrame();
		d1 = new MessageJDialog(title,info,f1);
	}
	
	public static void MessageBox(String sinfo){
		MessageBox("JWebDW0.3",sinfo);
	}

	public static void MsgBox(String stext,int iButton,String title){
		MessageBox(title,stext);
	}
}
