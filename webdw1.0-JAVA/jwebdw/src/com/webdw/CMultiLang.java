package com.webdw;

public class CMultiLang extends Golbal {
	public void ReadMe(){
		System.out.println("������֧����.");
		System.out.println(JWebDWInfo);
	}
	private String GetSpecLang(String allstr, String lang, String def) {
		String langs[] = new String[1];
		int i = 0;// As Integer
		String svalue = "";// As String
		String sret = "";// As String

		// '�������Ϊ�գ�����Ĭ��ֵ
		if (allstr.equals("")) {// = "" Then
			return Replace(def, "\\r\\n", "" + Chr(13) + Chr(10));
		}

		langs = Split(allstr, "" + Chr(13) + Chr(10));
		for (i = 0; i <= UBound(langs); i++) {
			svalue = langs[i];
			if (InStr(1, svalue, lang) == 1) {
				sret = Mid(svalue, Len(lang) + 2);// '�������ƺ����ǵȺţ��ٺ�������ʾ����
				sret = Replace(sret, "\\r\\n", "" + Chr(13) + Chr(10));
				return sret;
			}
		}

		// 'û���ҵ�������Ĭ��ֵ
		return Replace(def, "\\r\\n", "" + Chr(13) + Chr(10));
	}

	// '�õ�����ȫ�����Զ���������������ʾ�ַ���������һ�����Զ������

	public String GetCurrent(String allstr, String def) {
		return GetSpecLang(allstr, Golbal.G_Lang, def);
	}

	public String GetCurrent(String allstr) {
		return GetCurrent(allstr, "");
	}

	// '��������ַ�������ָ�����������ϣ��õ����ʵ��ַ���
	// 'spinfo ����������Ϣ
	// 'eninfo Ӣ����Ϣ
	public String SumAllLang(String spinfo, String eninfo) {
		String sp = "";// As String

		String en = "";// As String
		sp = "simplechinese=";
		en = "english=";

		return sp + spinfo + Chr(13) + Chr(10) + en + eninfo;
	}

}
