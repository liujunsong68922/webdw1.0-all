package com.webdw;

//Rem WebDW���ַ������ɹ���
//Rem ����local_webdw,��������ṹ����һ�����Ϲ淶Ҫ����ַ���
//Rem ��������ֻ�ṩһ����������getsyntaxstring����һ���ַ������local_webdw
//Rem ���룺local_webdw
//Rem ������ַ���,errString,iret
//Rem iret����ִ�е�״̬��־��0���� -1ʧ��
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @��Ȩ���� ������ 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------

public class CWebDW_GetSyntaxString extends Golbal {
	public void ReadMe(){
		System.out.println("WebDW���ַ������ɹ���");
		System.out.println(JWebDWInfo);
	}	
	public String errString = "";// As String 'ִ�в����Ĵ�����Ϣ

	private WebDWSyntax local_webdw;// As WebDWSyntax

	// 'local_webdw������һ���ֲ������ˣ�������ȫ�ֱ�����

	// '��������������local_webdw��ֵ
	// '���룺glocal_webdw
	// '�����local_webdw
	public void SetLocalWebDW() {
		local_webdw = Golbal.GG_webdw.Clone();
	}

	// '������������ȡlocal_webdw��ֵ
	// '����:local_webdw
	// '���:glocal_webdw
	public void GetLocalWebDW() {
		Golbal.GG_webdw = local_webdw.Clone();
	}

	// '�õ�DataWindow���ֱ�ʾ���ַ���
	private String getDW01_DataWindow(MyInt iret) {
		String sret = "";// As String
		iret.intvalue = 0;
		sret = "datawindow(" + "units=" + local_webdw.datawindow.unit + " "
				+ "timer interval=" + local_webdw.datawindow.timer_interval
				+ " " + "color=" + local_webdw.datawindow.color + " "
				+ "processing=" + local_webdw.datawindow.processiong + " "
				+ "HTMLDW=" + local_webdw.datawindow.HTMLDW + " "
				+ "print.documentname=" + "\""
				+ local_webdw.datawindow.print_documentname + "\"" + " "
				+ "print.orientation="
				+ local_webdw.datawindow.print_orientation + " "
				+ "print.margin.left="
				+ local_webdw.datawindow.print_margin_left + " "
				+ "print.margin.right="
				+ local_webdw.datawindow.print_margin_right + " "
				+ "print.margin.top=" + local_webdw.datawindow.print_margin_top
				+ " " + "print.margin.bottom="
				+ local_webdw.datawindow.print_margin_bottom + " "
				+ "print.paper.source="
				+ local_webdw.datawindow.print_paper_source + " "
				+ "print.print.paper.size="
				+ local_webdw.datawindow.print_paper_size + " "
				+ "print.prompt=" + local_webdw.datawindow.print_prompt + " "
				+ "print.buttons=" + local_webdw.datawindow.print_buttons + " "
				+ "print.preview.buttons="
				+ local_webdw.datawindow.print_preview_buttons + " "
				+ "grid.lines=" + " " + " )" + Chr(13) + Chr(10);
		return sret;
	}

	// '�õ�Header���ֵı�ʾ���ַ���
	private String getDW02_Header(MyInt iret) {
		String sret = "";// As String

		iret.intvalue = 0;
		sret = "header(" + "height=" + local_webdw.header.height + " "
				+ "color=" + "\"" + local_webdw.header.color + "\"" + " ) "
				+ Chr(13) + Chr(10);
		return sret;
	}

	// '�õ�Summary���ֵ��ַ�����ʾ
	private String getDW03_Summary(MyInt iret) {
		String sret = "";// As String

		iret.intvalue = 0;
		sret = "summary(" + "height=" + local_webdw.summary.height + " "
				+ "color=" + "\"" + local_webdw.summary.color + "\"" + " ) "
				+ Chr(13) + Chr(10);
		return sret;
	}
//	'�õ�footer
	private String getDW04_Footer(MyInt iret){
	    String sret="";// As String
	        
	    iret.intvalue = 0;
	    sret = "footer(" 
	            + "height=" + local_webdw.footer.height + " " 
	            + "color=" + "\"" + local_webdw.footer.color + "\"" + " ) " + Chr(13) + Chr(10);
	     return sret;
	}
//	'�õ�detail
	private String getDW05_Detail(MyInt iret ){
	    String sret="";// As String
	    iret.intvalue = 0;
	    sret = "detail(" 
	            + "height=" + local_webdw.detail.height + " " 
	            + "color=" + "\"" + local_webdw.detail.color + "\"" + " ) " + Chr(13) + Chr(10);
	     return sret;
	}

	
//	'������������local_webdwת����һ��ָ����ʽ���ַ���
//	'�Ժ�Ҫ�޸����ɵ��ַ�����ֻ��Ҫ�޸�local_webdw�����ݾͿ�����
	public String GetSyntaxString(MyInt iret ){
		//��ʱ������ʵ��,�������ݴ��ڵĹ�����ʱ��Ǩ�Ƶ�Java��
		return "";
	}

	
}
