package com.webdw
{
	import mx.controls.Alert;
	import mx.controls.TextInput;
	import mx.core.UIComponent;
	
	public class Golbal extends VBFunction
	{
	public function Golbal() {
		//super();
		//alert("enter golbal");
		// 实例化时对全局变量来赋值
		//InitGlobalVariable();
	}

	public static  function JWebDWInfo():String 
	{ 
	var sret:String = "    Author: Liujunsong  \r\n"
			+ "    E_Mail: liujunsong@yahoo.com.cn  \r\n"
			+ "    http://webdw.vicp.net  \r\n"
			+ "    Info:If You Can See SourceCode and find bug in it  \r\n"
			+ "    Please contract me.  \r\n";
		return sret;
	}

	public override function  ReadMe():void {
		//System.out.println("全局变量定义");
		//System.out.println(JWebDWInfo);
		trace(JWebDWInfo());
	}
	try{
	//Alert.show("GG_webdw");
	public static var GG_webdw:WebDWSyntax = new WebDWSyntax();
	//Alert.show("GG_webdw1");
	public static var GG_empty_webdw:WebDWSyntax = new WebDWSyntax();
	//Alert.show("GG_webdw2");
	public static var G_ServerURL:String = "http://webdw.vicp.net/myproj/Table";
	//Alert.show("GG_webdw3");
	public static var G_Lang:String = "";
	//Alert.show("GG_webdw4");
	public static var G_LangDef:LangDef =  new LangDef();
	//Alert.show("GG_webdw5");
	public static var G_Transaction_Const:Transaction_Const = new Transaction_Const();
	//Alert.show("GG_webdw6");
	private static var WebDWSite1:String = "http://webdw.vicp.net/myproj/Table";
	//Alert.show("GG_webdw7");
	private static var WebDWSite2:String = "http://localhost/myproj/Table";
	//Alert.show("GG_webdw8");

	public static var True :Boolean= true;
	public static var False:Boolean = false;
	}catch(e:Error){
		super.alert(e);
		super.alert(e.message);
		throw e;
	}

	/**
	 * 初始化全局变量
	 * 
	 */
	public static function InitGlobalVariable():void {
		// G_ServerURL = WebDWSite;// '设置默认连接,连接到webdw.vicp.net
		try{
		// '对全局语言常量赋值
		G_LangDef.Lang_English = "english";
		G_LangDef.Lang_French = "french";
		G_LangDef.Lang_Japanese = "japanese";
		G_LangDef.Lang_SimpleChinese = "simplechinese";

		G_Lang = G_LangDef.Lang_SimpleChinese; // '默认为简体中文显示

		// '对全局数据掩码所用的数据类型来赋值
		// '数据掩码暂时不予支持
		// 'G_EditMaskDataType.EditMask_Date = 1
		// 'G_EditMaskDataType.EditMask_Time = 2
		// 'G_EditMaskDataType.EditMask_DateTime = 3
		// 'G_EditMaskDataType.EditMask_Decimal = 4
		// 'G_EditMaskDataType.EditMask_Numeric = 5
		// 'G_EditMaskDataType.EditMask_String = 6

		// '初始化全局性常量定义的数值
		G_Transaction_Const.Trans_Oper_Query = "1";
		G_Transaction_Const.Trans_Oper_Exec = "2";
		G_Transaction_Const.Trans_Oper_TableList = "3";
		G_Transaction_Const.Trans_Oper_ColumnList = "4";

		G_Transaction_Const.Trans_BeginTrans = "begintrans";
		G_Transaction_Const.Trans_AddCommand = "addcommand";
		G_Transaction_Const.Trans_Commit = "commit";
		G_Transaction_Const.Trans_Rollback = "rollback";

		G_Transaction_Const.Trans_GetDWDefine = "getdwdefine";// '得到数据窗口的定义

		InitGServerURL();
		}catch(e:Error){
			Alert.show("Golabl Init Error:"+e.message);
		}
	}

	public static function InitGServerURL():int {
//		G_ServerURL = "http://localhost/myproj/Table";// '设置默认连接连接到webdw.vicp.net
		G_ServerURL = "/myproj/Table";// '设置默认连接连接到webdw.vicp.net

//		File f1 = new File("C://Iamliujunsong.txt");
//		if (f1.exists()) {
//			G_ServerURL = "http://localhost/myproj/Table";
//		}

		return 0;
	}



	public override function UCase(inStr1:String ): String{
		return inStr1.toUpperCase();
	}
	// '从一个targetControls容器中，根据给定控件名称来检索控件
	// '如果控件不存在，则返回Nothing
	public static function GF_GetObjectByName(targetControls:Array,
			 objName:String ):UIComponent {
		try{
		//Alert.show("enter GF_GetObjectByName");
		var vobj:UIComponent ;//= new UIComponent();
		//Alert.show("define vobj finished:isnull? "+(targetControls==null));
		//Alert.show("size:"+targetControls.length);
		//Alert.show("To find:"+objName);
		for (var i:int = 0; i < targetControls.length; i++) {
			vobj =  targetControls[i];
			if (vobj == (UIComponent)(undefined)) {
				continue;
			}
			if (vobj.name == null || vobj.name =="") {
				continue;
			}
			var s1:String = vobj.name.toUpperCase();
			var s2:String = objName.toUpperCase();
			if (s1==s2) {
				return vobj;
			}
			
		}
		return (UIComponent)(undefined);
		}catch(e:Error){
			Alert.show("Error at GF_GetObjectByName:"+e.getStackTrace());
			return (UIComponent)(undefined);
		}
		return (UIComponent)(undefined);
	}

	public function GF_GetVBColor( pbColor:int, defColor:int):int {
		var iret:int = 0;
		var SYSCOLOR:int = 16777215;// '最大颜色值,256 * 256 * 256 - 1

		if (pbColor <= SYSCOLOR) {
			return pbColor;
		}

		iret = defColor;// '设置默认颜色
		if (pbColor == 1090519039)
			iret = RGB(255, 255, 255); // '如果是windows默认背景色
		if (pbColor == 276856960)
			iret = RGB(125, 125, 125);// ' 如果是应用工作区默认背景色
		if (pbColor == 81324524)
			iret = RGB(125, 125, 125); // ' 如果是按钮表色
		if (pbColor == 33554592)
			iret = RGB(0, 0, 0); // 'window文本默认颜色

		// '下面是几种固定定义的颜色转换
		if (pbColor == 536870912)
			iret = RGB(255, 255, 255); // '白色

		return iret;

	}

	public function GF_GetConvertRate(targetControls:Array):Number {
		var convertRate:Number;
		var TextConvertRate:TextInput;
		try{
			//Alert.show("Enter GF_GetConvertRate");
		TextConvertRate = (TextInput)(GF_GetObjectByName(targetControls, "TextConvertRate"));
			//Alert.show("Find result: isNull? "+ (TextConvertRate==null));
		if (TextConvertRate == null) {
			return 0.3;
		}

		convertRate = parseFloat(TextConvertRate.text); // '获取设置值
		if (convertRate <= 0.1 || convertRate >= 10) {
			convertRate = 0.3;
		}

		return convertRate;
		}catch(e:Error){
			Alert.show("Error in GF_GetConvertRate"+e.message);
			throw e;
		}
		return 0.3;
	}

	public function GF_RetrieveBySyntax( dwSyntax:String):String  {
		var iret:MyInt = new MyInt(0);
		var temp_webdw:CWebDW = new CWebDW();
		var temp_sqlca:CWebDWTransaction = new CWebDWTransaction();
		var str_retrieve:String = "";
		var sdata:String = "";

		if (temp_webdw.Create(dwSyntax) == -1) {// Then '解析失败，返回空字符串
			return "";
		}
		log(dwSyntax);
		log("" + GG_webdw.getColumnNumber());
		str_retrieve = temp_webdw.GetRetrieveSQL();// '得到检索用的SQL语句
		log(str_retrieve);
		if (Len(str_retrieve) == 0) {
			return "";
		}

		//    
		// 'temp_sqlca.opertype = 1
		// 'temp_sqlca.beginPos = 0
		// 'temp_sqlca.readNum = 1000
		temp_sqlca.Eval("Setcommand(" + str_retrieve + ")", iret);

		sdata = temp_sqlca.ExecuteSelect(iret);// '执行sql,得到数据结果

		if (iret.intvalue == -1) {// Then
			return "";
		}

		return sdata;// '返回数据
	}

	public function GF_GetDBlength(sdata:String):int {
		var i:int = 0;
		var ilen:int = 0;
		var stemp:String = "";
		ilen = 0;
		for (i = 1; i <= Len(sdata); i++) {
			stemp = Mid(sdata, i, 1);
			if (Asc(stemp) < 128 && Asc(stemp) > 0) {
				ilen = ilen + 1;
			} else {
				ilen = ilen + 2;
			}

		}
		return ilen;
	}

	public function GF_IF( ifClause:Boolean, YesValue:String, NoValue:String):String {
		if (ifClause) {
			return YesValue;
		} else {
			return NoValue;
		}
	}

	public function GF_IF_Long( ifClause:Boolean,  YesValue:int,  NoValue:int): int {
		if (ifClause) {
			return YesValue;
		} else {
			return NoValue;
		}
	}

	public function GF_GetAlignType(intype:int): int {
		if (intype == 0) {
			return 0;//JTextField.LEFT;
		}
		if (intype == 1) {
			return 1;//JTextField.RIGHT;
		}
		if (intype == 2) {
			return 2;//JTextField.CENTER;
		}
		return 0;//JTextField.CENTER;
	}

	/**
	 * 将VB的颜色转换成Java的颜色
	 * 
	 * @param vbcolor
	 * @return
	 */
	public function GF_GetJavaColor(vbcolor:int ):int {
//		if (vbcolor == 255) {
//			return Color.RED;
//		}
//		return new Color(0, 0, 0);
		return 0;
	}

	public function log( s:String):void {
		trace(s);
	}
	
	
}

}
