
package com.webdw
{
//	import java.math.*;
//	import java.util.*;
//	import java.awt.Container;
//
//	import javax.swing.JDialog;
//	import javax.swing.JFrame;
//	import java.util.ArrayList;
//	import java.awt.event.*;
//
//	import javax.swing.*;
	import mx.controls.Alert;
	public class VBFunction
	{
		public function VBFunction()
		{
			//alert("enter VBFunction");
		}
	    public function ReadMe():void {
		trace("这个类定义了许多VB方法的Java实现，避免重复书写代码");
		//trace(Golbal.JWebDWInfo);
		}
	public function InStr( beginPos:int,string1:String ,findString:String):int {
		return InStr3(beginPos,string1,findString);
	}
	/**
	 * 提供与VB函数InStr相同的功能,VB的字符串返回,是从1开始的,所以将返回值加1返回
	 * 返回0代表找不到
	 * @param beginPos,有效位置从1开始
	 * @param string1
	 * @param findString
	 * @return
	 */
	public function InStr3( beginPos:int,string1:String ,findString:String):int {
		var ipos :int  = 0;
		if (string1 == null || string1==("")) {
			return -1;
		}
		if (beginPos<1){
			beginPos=1;
		}
		ipos = string1.indexOf(findString, beginPos - 1);
		return ipos + 1;
	}

	public function InStr2( string1:String ,findString:String):int {
		return InStr3(0, string1, findString);
	}

	/**
	 * 提供与VB函数Len相同的功能
	 * 
	 * @param inStr
	 * @return
	 */
	public function Len( inStr:String):int {
		if (inStr == null) {
			return 0;
		}
		return inStr.length;
	}

	/**
	 * 提供与VB函数Mid相同的功能,VB的字符串计算,下标从1开始.
	 * 
	 * @param str1
	 * @param pos
	 * @param length
	 * @return
	 */
	public function Mid3( str1:String ,  pos:int,  length:int) :String{
		if (length <= 0) {
			return "";
		}
		return str1.substring(pos - 1, pos + length - 1);
	}

	public function Mid( str1:String ,  pos:int,  length:int) :String{
		return Mid3(str1,pos,length);
	}
	public function Mid2( str1 :String ,  pos:int) :String {
		return str1.substring(pos - 1);
	}

	/**
	 * 提供与VB函数Left相同的功能,获得左面几个字符的数据
	 * 
	 * @param instr
	 * @param i
	 * @return
	 */
	public function Left( instr:String ,i:int):String {
		if (instr.length >= i) {
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
	public function Right( instr:String ,  i:int):String {
		return instr.substring(instr.length - i);
	}

	// 得到指定Asc码对应的字符串
	public function Chr(i:int):String {
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
	public function toInt(s:String ):int  {
		try {
			return parseInt(s);
		} catch (e:Error) {
			// e.printStackTrace();
			// System.out.println("ERROR Data ToInt:*"+s+"*");
			trace(e);
			return 0;
		}
		return 0;
	}

	/**
	 * 将字符串转换成数值
	 * 
	 * @param s
	 * @return
	 */
	public function toDouble( s:String):Number {
		try {
			return parseFloat(s);
		} catch ( e:Error) {
			// e.printStackTrace();
			// System.out.println("ERROR Data ToInt:*"+s+"*");
			return 0;
		}
		return 0;
	}

	public function UCase(inStr:String ) : String{
		
		return inStr.toUpperCase();
	}

	public function Split( inStr1:String,  sepStr:String):Array {
		// return inStr.split(sepStr);
		var arraynum :int = 0;
		var data:Array = new Array(1000);
		var i:int  = 0;
		var tempi:int  = 0;
		tempi = InStr3(i, inStr1, sepStr);
		while (tempi > 0) {
			if (i == 0) {
				// 第一个元素,从1开始计算
				data[arraynum] = Mid3(inStr1, 1, tempi - i - 1);
			} else {
				data[arraynum] = Mid3(inStr1, i + sepStr.length, tempi - i- sepStr.length);
			}
			arraynum++;
			i = tempi;
			tempi = InStr3(i+1, inStr1, sepStr);
		}
		if (i == 0) {
			data[arraynum] = inStr1;
		} else {
			data[arraynum] = Mid2(inStr1, i + sepStr.length);
		}
		arraynum++;
		var newdata:Array = new Array(arraynum);
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
	public function UBound(instr:Array):int {
		return instr.length - 1;
	}

	/**
	 * 去掉字符串两面的空格
	 * 
	 * @param inStr
	 * @return
	 */
	public function Trim( inStr:String):String {
		//return inStr.trim();
		return inStr.replace(/(^\s*)|(\s*$)/g, ""); 
	}

	/**
	 * 替换字符串中的内容
	 * 
	 * @param instr
	 * @param str1
	 * @param str2
	 * @return
	 */
	public function Replace( instr:String ,  str1:String,  str2:String):String {
			//这个replace方法的实现有bug
			//如果传入的数据中以分割符号结尾与开头，会发生类型转换错误。	
            //return instr.split(str1).join(str2); 
            //Alert.show("enter Replace");
            try{
     			var dataarray:Array = Split(instr,str1); //调用自己定义的split方法
     			var id:int =0;
     			var sret:String="";
     			for(id=0;id<dataarray.length;id++){
     				if (sret==""){
     					sret = dataarray[id];
     				}else{
     					sret = sret + str2 + dataarray[id];
     				}
     			}
     			//Alert.show("Replace result:"+sret);
     			return sret;
            }catch(e:Error){
            	Alert.show("Replace Error:"+e.message);
            }
            return instr.split(str1).join(str2); 

		//return instr.replace(str1+"/g", str2);
	}

	/**
	 * 得到当前时间的表示
	 * 
	 * @return
	 */
	public function Now():String {
		return new Date().toString();
	}

	public function RGB( r :int ,  g:int ,  b:int):int  {
		return r * 256 * 256 + g * 256 + b;
	}

	public function Asc( s:String):int  {
		if (s == null) {
			s = " ";
		}
		if (s.length == 0) {
			s = " ";
		}
		
		return s.charCodeAt(0);
	}

	/**
	 * 判断S1 > S2
	 * 
	 * @param s1
	 * @param s2
	 * @return
	 */
	public function IsGreat( s1:String,  s2:String):Boolean {
		if (s1.length > 0 && s2.length > 0) {
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

		if (s1.length > 0 && s2.length == 0) {
			return true;
		}

		if (s1.length == 0 && s2.length > 0) {
			return false;
		}
		return true;
	}

	public function IsNumeric( s1:String):Boolean {
		try {
			var d:Number = parseFloat(s1);
			return true;
		} catch ( e:Error) {
			return false;
		}
		return false;
	}

	public function Rnd( d :int ):Number {
		//var r = new Random();
		return Math.random()*d;
	}
	
	//弹出一个类似VB的Windows标准对话框
//	static JFrame f1 = new JFrame();
//	static MessageJDialog d1 = null;
	public function MessageBox2(title:String,info:String):void{
		Alert.show(info,title);
//		f1 = new JFrame();
//		d1 = new MessageJDialog(title,info,f1);
	}
	
	public function MessageBox( sinfo:String):void{
		MessageBox2("JWebDW0.3",sinfo);
	}

	public function MsgBox3( stext:String, iButton:int, title:String):void{
		MessageBox2(title,stext);
	}	
	public function MsgBox( stext:String, iButton:int, title:String):void{
		MessageBox2(title,stext);
	}
	
	public function alert(stext:String):void{
		Alert.show(stext);
	}
	
	}
	
}