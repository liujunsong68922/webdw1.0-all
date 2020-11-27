package com.webdw
{
/**
 * WebDW语法定义的Java描述 从VB代码移植而来
 * 
 * @author admin
 * 
 */

	import mx.controls.Alert;

public class WebDWSyntax {
//	public function ReadMe():void {
//		//System.out.println("WebDW的用户界面文件表示，采用和PB7.0兼容的界面格式定义");
//		//System.out.println(Golbal.JWebDWInfo);
//		trace("WebDW的用户界面文件表示，采用和PB7.0兼容的界面格式定义");
//		trace(Golbal.JWebDWInfo());
//	}
	
	try{
	//Alert.show("enter WebDWSyntax");
	//Alert.show("enter WebDWSyntax1");
	public var datawindow:WebDW_DataWindow = new WebDW_DataWindow();
	//Alert.show("enter WebDWSyntax2");
	public var header:WebDW_Header = new WebDW_Header();
	//Alert.show("enter WebDWSyntax3");
	public var summary:WebDW_Summary = new WebDW_Summary();
	//Alert.show("enter WebDWSyntax4");
	public var footer:WebDW_Footer = new WebDW_Footer();
	//Alert.show("enter WebDWSyntax5");
	public var detail:WebDW_Detail = new WebDW_Detail();
	//Alert.show("enter WebDWSyntax6");
	public var table :WebDW_Table =new WebDW_Table();
	//Alert.show("enter WebDWSyntax7");
	public var text:Array = new Array(101);
	//Alert.show("enter WebDWSyntax8");
	public var column:Array = new Array(101);
	//Alert.show("enter WebDWSyntax9");
	public var lineinfo:Array = new Array(101);
	//Alert.show("enter WebDWSyntax10");
	public var column_dddw_syntax:Array = new Array(101);
	//Alert.show("enter WebDWSyntax11");
	public var column_dddw_data:Array = new Array(101);
	//Alert.show("enter WebDWSyntax12");
	public var SelectSQL:String = "";
	//Alert.show("enter WebDWSyntax13");	
	}catch(e:Error){
		Alert.show(e.message);
		throw e;
	}
	/**
	 * 初始化的构造函数
	 * 
	 */
	public function WebDWSyntax() {
		var i:int  = 0;
		try{
		for (i = 0; i < 101; i++) {
			text[i] = new WebDW_Text();
		}
		for (i = 0; i < 101; i++) {
			column[i] = new WebDW_Column();
		}
		for (i = 0; i < 101; i++) {
			lineinfo[i] = new WebDW_Line();
		}
		for (i = 0; i < 101; i++) {
			column_dddw_syntax[i] = "";
		}
		for (i = 0; i < 101; i++) {
			column_dddw_data[i] = "";
		}
		}catch(e1 :Error){
			Alert.show(e1.message);
			throw e1;
		}
	}

	public function Clone() :WebDWSyntax{
		var newOne:WebDWSyntax = new WebDWSyntax();

		newOne.datawindow = datawindow.Clone();

		newOne.header = header.Clone();

		newOne.summary = summary.Clone();

		newOne.footer = footer.Clone();

		newOne.detail = detail.Clone();

		newOne.table = table.Clone();

		var i:int = 0;
		for (i = 0; i < 101; i++) {
			newOne.text[i] = text[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.column[i] = column[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.lineinfo[i] = lineinfo[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.column_dddw_syntax[i] = column_dddw_syntax[i];
		}
		for (i = 0; i < 101; i++) {
			newOne.column_dddw_data[i] = column_dddw_data[i];
		}
		return newOne;
	}
	
	/**
	 * Warning:Test only,Donot Use This Function in Program!!!
	 * @return
	 */
	public function getColumnNumber():int{
		var i:int =0;
		for(i=1;i<=100;i++){
			if (column[i].Name.length()==0){
				return i-1;
			}
		}
		return 100;
	}
}	
}