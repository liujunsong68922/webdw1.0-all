class CMultiLang {
	// constructor function
	constructor(){
		
		this.ReadMe="多语言支持类";
		this.Golbal=golbal;
	}

	GetSpecLang( allstr,  lang,  def) {
		var langs = new Array(1);// String[1];
		var i = 0;// As Integer
		var svalue = "";// As String
		var sret = "";// As String

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

	GetCurrent(allstr, def) {
		return GetSpecLang(allstr, this.Golbal.G_Lang, def);
	}

	GetCurrent(allstr) {
		return GetCurrent(allstr, "");
	}

	// '将输入的字符串按照指定规则进行组合，得到合适的字符串
	// 'spinfo 简体中文信息
	// 'eninfo 英文信息
	SumAllLang( spinfo,  eninfo) {
		var sp = "";// As String

		var en = "";// As String
		sp = "simplechinese=";
		en = "english=";

		return sp + spinfo + Chr(13) + Chr(10) + en + eninfo;
	}

}
