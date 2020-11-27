package com.webdw
{
public class CMultiLang extends Golbal {
//	public void ReadMe(){
//		System.out.println("多语言支持类.");
//		System.out.println(JWebDWInfo);
//	}
	private function GetSpecLang(allstr:String, lang:String, def:String):String {
		var langs:Array  = new Array(1);
		var i:int = 0;// As Integer
		var svalue:String = "";// As String
		var sret:String = "";// As String

		// '如果输入为空，返回默认值
		if (allstr==("")) {// = "" Then
			return Replace(def, "\\r\\n", "" + Chr(13) + Chr(10));
		}

		langs = Split(allstr, "" + Chr(13) + Chr(10));
		for (i = 0; i <= UBound(langs); i++) {
			svalue = langs[i];
			if (InStr3(1, svalue, lang) == 1) {
				sret = Mid2(svalue, Len(lang) + 2);// '语言名称后面是等号，再后面是显示内容
				sret = Replace(sret, "\\r\\n", "" + Chr(13) + Chr(10));
				return sret;
			}
		}

		// '没有找到，返回默认值
		return Replace(def, "\\r\\n", "" + Chr(13) + Chr(10));
	}

	// '得到按照全局语言定义来检索到的显示字符串，少了一个语言定义参数

	public function  GetCurrent2( allstr:String,  def:String):String {
		return GetSpecLang(allstr, Golbal.G_Lang, def);
	}

	public function GetCurrent( allstr:String):String {
		return GetCurrent2(allstr, "");
	}

	// '将输入的字符串按照指定规则进行组合，得到合适的字符串
	// 'spinfo 简体中文信息
	// 'eninfo 英文信息
	public function SumAllLang( spinfo:String,  eninfo:String):String {
		var sp :String= "";// As String

		var en:String = "";// As String
		sp = "simplechinese=";
		en = "english=";

		return sp + spinfo + Chr(13) + Chr(10) + en + eninfo;
	}

}
}