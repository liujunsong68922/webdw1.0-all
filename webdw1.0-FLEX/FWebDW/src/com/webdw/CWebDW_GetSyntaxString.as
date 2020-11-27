package com.webdw
{
//Rem WebDW的字符串生成功能
//Rem 输入local_webdw,利用这个结构生成一个符合规范要求的字符串
//Rem 这个类对外只提供一个公共方法getsyntaxstring，用一个字符串填充local_webdw
//Rem 输入：local_webdw
//Rem 输出：字符串,errString,iret
//Rem iret代表执行的状态标志，0正常 -1失败
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @版权所有 刘峻松 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------

public class CWebDW_GetSyntaxString extends Golbal {
//	public void ReadMe(){
//		System.out.println("WebDW的字符串生成功能");
//		System.out.println(JWebDWInfo);
//	}	
	public var errString:String = "";// As String '执行产生的错误信息

	private var local_webdw:WebDWSyntax;// As WebDWSyntax

	// 'local_webdw现在是一个局部变量了，而不是全局变量了

	// '功能描述：设置local_webdw的值
	// '输入：glocal_webdw
	// '输出：local_webdw
	public function SetLocalWebDW():void {
		local_webdw = Golbal.GG_webdw.Clone();
	}

	// '功能描述：读取local_webdw的值
	// '输入:local_webdw
	// '输出:glocal_webdw
	public function GetLocalWebDW():void {
		Golbal.GG_webdw = local_webdw.Clone();
	}

	// '得到DataWindow部分表示的字符串
	private function getDW01_DataWindow( iret:MyInt):String {
		var sret:String = "";// As String
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

	// '得到Header部分的表示的字符串
	private function getDW02_Header( iret:MyInt):String {
		var sret:String = "";// As String

		iret.intvalue = 0;
		sret = "header(" + "height=" + local_webdw.header.height + " "
				+ "color=" + "\"" + local_webdw.header.color + "\"" + " ) "
				+ Chr(13) + Chr(10);
		return sret;
	}

	// '得到Summary部分的字符串表示
	private function getDW03_Summary( iret:MyInt) :String{
		var sret:String = "";// As String

		iret.intvalue = 0;
		sret = "summary(" + "height=" + local_webdw.summary.height + " "
				+ "color=" + "\"" + local_webdw.summary.color + "\"" + " ) "
				+ Chr(13) + Chr(10);
		return sret;
	}
//	'得到footer
	private function getDW04_Footer( iret:MyInt):String{
	    var sret:String="";// As String
	        
	    iret.intvalue = 0;
	    sret = "footer(" 
	            + "height=" + local_webdw.footer.height + " " 
	            + "color=" + "\"" + local_webdw.footer.color + "\"" + " ) " + Chr(13) + Chr(10);
	     return sret;
	}
//	'得到detail
	private function getDW05_Detail(iret:MyInt ):String{
	    var sret:String="";// As String
	    iret.intvalue = 0;
	    sret = "detail(" 
	            + "height=" + local_webdw.detail.height + " " 
	            + "color=" + "\"" + local_webdw.detail.color + "\"" + " ) " + Chr(13) + Chr(10);
	     return sret;
	}

	
//	'功能描述：将local_webdw转换成一个指定格式的字符串
//	'以后要修改生成的字符串，只需要修改local_webdw的数据就可以了
	public function GetSyntaxString( iret:MyInt ):String{
		//暂时不进行实现,定义数据窗口的功能暂时不迁移到Java上
		return "";
	}
}
}