package com.webdw
{
//Rem CWebDW是一个没有具体实现过程的中转类
//Rem 它的设计目的是屏蔽对于CWebDWUI_FromString和CWebDWUI_ToString的访问
//Rem 所有的访问针对CWebDW来进行就可以
//Rem CWebDW对应的数据结构是WebDWSyntax
//Rem CWebDW操作的数据源是GG_WebDW
	import mx.controls.Alert;
public class CWebDW extends Golbal {
	public function CWebDW(){
		
	}
	
	public override function ReadMe():void{
		trace("CWebDW是一个没有具体实现过程的中转类");
		trace(JWebDWInfo);
	}
	public var dwString:String = "";// As String '这个变量存储要解析的字符串,未来可用来比较,只读

	public var errString:String = "";// As String '解析失败以后的错误信息存储在这里

	// '----------本地对象类封装开始---------
	private var reader: CWebDW_Create= new CWebDW_Create();// '定义一个读取功能类

	private var writer: CWebDW_GetSyntaxString= new CWebDW_GetSyntaxString();// '定义一个输出字符串类

	private var sqlGener:CWebDW_GetRetrieveSQL = new CWebDW_GetRetrieveSQL();// '定义一个得到数据窗口输出Select的类

	private var synGener : CWebDW_SyntaxFromSQL= new CWebDW_SyntaxFromSQL();// '定义一个从select变成语法的类

	// '----------本地对象类封装结束---------

	private var local_webdw:WebDWSyntax = new WebDWSyntax();// 'local_webdw现在是一个局部变量了，而不是全局变量了

	// '功能描述：设置g_webdw的值
	// '输入：gg_webdw
	// '输出：local_webdw
	public function SetLocalWebDW():void {
		local_webdw = Golbal.GG_webdw.Clone();
	}

	// '功能描述：读取local_webdw的值
	// '输入:local_webdw
	// '输出:gg_webdw
	public function GetLocalWebDW():void {
		Golbal.GG_webdw = local_webdw.Clone();
	}

	// '这个是一个主要的对外公开的解析方法
	// '输入一个字符串,把它解析成一个webdw结构的数据
	// '并存储在g_webdw中
	// '字符串存储在dwString中备用
	// '返回0代表成功
	// '如果解析失败,返回-1代表有错误(一般不会)
	// '不存储字符串,也不存储webdw
	// '错误信息存储在errString中
	public function Create( inString:String):int {
		try{
			//Alert.show("enter Create");
		var iret:int = 0;// As Long
		iret = reader.Create(inString);

		dwString = inString;

		// '更新本地的local_webdw数据,从reader中读取
		//Alert.show("Update webdw");
		reader.GetLocalWebDW();
		SetLocalWebDW();

		if (iret == -1) {
			errString = reader.errString;
		}
		return iret;
		}catch(e:Error){
			Alert.show("Create Error:"+e.message);
			throw e;
			return -1;
		}
		return -1;
	}

	// '在读入g_webdw以后，得到表示所有列名称的字符串表示
	// '各列之间用chr(9)分割，顺序按照column定义的顺序
	// '这个数据用来初始化webdwdata的数据集合
	// '操作前提是local_webdw已经有数据了
	public function GetColumnDefineString():String {
		var strcol:String = "";// As String
		var colid:int = 0;// As Long
		strcol = "";
		for (colid = 1; colid <= 100; colid++) {// 'g_webdw定义中最多100个列，此处不可读取column，必须读取table.column
			if (local_webdw.table.Columns[colid].Name==("")) {
				break;
			}

			if (strcol==("")) {
				strcol = strcol + local_webdw.table.Columns[colid].Name;
			} else {
				strcol = strcol + Chr(9)
						+ local_webdw.table.Columns[colid].Name;
			}
		}

		return strcol; // '返回字符串
	}

	// '功能描述：将local_webdw转换成一个指定格式的字符串
	// '以后要修改生成的字符串，只需要修改g_webdw的数据就可以了
	// '这一方法对应于PB的describe("dw_1.syntax")
	public function GetSyntaxString(iret:MyInt):String {
		GetLocalWebDW();
		writer.SetLocalWebDW();
		var s1:String = "";
		s1 = writer.GetSyntaxString(iret);
		if (iret.intvalue == -1) {
			errString = writer.errString;
		}
		return s1;
	}

	// '功能描述：从DW定义中，分解得到数据库检索用的Select语句
	// '为下一步执行SQL操作打下基础
	// '这个SQL语句可能会带有参数
	public function GetRetrieveSQL():String {
		GetLocalWebDW();
		sqlGener.SetLocalWebDW();
		return sqlGener.GetRetrieveSQL();
	}

	// '根据给定的SQL语句，以及对应的数据窗口类型
	// '设置到g_webdw中去
	// '从而再转换，得到一个对应的数据窗口对象出来。
	// 'iret返回值，0 正常 -1 失败
	// '错误信息存放在errstring中
	// '这个方法是一个Select语句的小型解析器
	public function SyntaxFromSQL(strsql:String ,  stype:String,  iret:MyInt):String {

		var s1 :String= "";
		s1 = synGener.SyntaxFromSQL(strsql, stype, iret);
		if (iret.intvalue == -1) {
			errString = synGener.errString;
		}
		synGener.GetLocalWebDW();
		SetLocalWebDW();
		return s1;
	}

//	'设置ColumnDefineString
	public function SetColumnDefineString( colDefString:String ):int{
	    synGener.colDefString = colDefString;
	    return 0;
	}
	
//	'根据给定的columnname，计算返回的列编号(1 based)
//	'访问local_webdw来计算得到
	public function GetColumnIdByColumnName( colname:String ):int{
	    var colid :int=0;
	    for(colid = 1;colid<=100;colid++){
	        if( UCase(colname)==(UCase(local_webdw.table.Columns[colid].Name))){
	            return colid;
	        }
	    }
	    return -1;
	}

//	'得到界面的最大宽度，用这个宽度来设置横向滚动条的位置等信息
	public function getMaxWidth():int  {
	    var i:int = 0;//As Long
	    var imax:int = 0;// As Long
	    imax = 0;
	    //'循环读取label的最大宽度
	    for( i = 1 ;i<= 100;i++){
	        if( local_webdw.text[i].Name==("")){
	            break;
	        }
	        
	        if( local_webdw.text[i].x + local_webdw.text[i].width > imax){
	            imax = local_webdw.text[i].x + local_webdw.text[i].width;
	        }
	    }
	    
	    //'循环读取text的最大宽度
	    for( i = 1 ;i<= 100;i++){
	        if(local_webdw.column[i].Name==("")){
	            break;
	        }
	        
	        if( local_webdw.column[i].x + local_webdw.column[i].width > imax){
	            imax = local_webdw.column[i].x + local_webdw.column[i].width;
	        }
	    }
	    
	    //'循环读取line的最大右坐标
	    for( i = 1 ;i<= 100;i++){
	        if( local_webdw.lineinfo[i].Name==("")){
	            break;
	        }
	        
	        if( local_webdw.lineinfo[i].x1 > imax){
	        	imax = local_webdw.lineinfo[i].x1;
	        }
	        if( local_webdw.lineinfo[i].x2 > imax){
	        	imax = local_webdw.lineinfo[i].x2;
	        }
	    }
	    
	    return imax;
	}

}
}