package com.webdw;

public class CMultiLang extends Golbal {
	public void ReadMe(){
		System.out.println("多语言支持类.");
		System.out.println(JWebDWInfo);
	}
	private String GetSpecLang(String allstr, String lang, String def) {
		String langs[] = new String[1];
		int i = 0;// As Integer
		String svalue = "";// As String
		String sret = "";// As String

		// '如果输入为空，返回默认值
		if (allstr.equals("")) {// = "" Then
			return Replace(def, "\\r\\n", "" + Chr(13) + Chr(10));
		}

		langs = Split(allstr, "" + Chr(13) + Chr(10));
		for (i = 0; i <= UBound(langs); i++) {
			svalue = langs[i];
			if (InStr(1, svalue, lang) == 1) {
				sret = Mid(svalue, Len(lang) + 2);// '语言名称后面是等号，再后面是显示内容
				sret = Replace(sret, "\\r\\n", "" + Chr(13) + Chr(10));
				return sret;
			}
		}

		// '没有找到，返回默认值
		return Replace(def, "\\r\\n", "" + Chr(13) + Chr(10));
	}

	// '得到按照全局语言定义来检索到的显示字符串，少了一个语言定义参数

	public String GetCurrent(String allstr, String def) {
		return GetSpecLang(allstr, Golbal.G_Lang, def);
	}

	public String GetCurrent(String allstr) {
		return GetCurrent(allstr, "");
	}

	// '将输入的字符串按照指定规则进行组合，得到合适的字符串
	// 'spinfo 简体中文信息
	// 'eninfo 英文信息
	public String SumAllLang(String spinfo, String eninfo) {
		String sp = "";// As String

		String en = "";// As String
		sp = "simplechinese=";
		en = "english=";

		return sp + spinfo + Chr(13) + Chr(10) + en + eninfo;
	}

}
