/**
 * 事务对象相关的常数定义，被事务对象用来和后台服务器进行通讯使用
 */
class Transaction_Const {
	constructor(){
		this.Trans_Oper_Query = "1"; // '查询操作 //1
	
		this.Trans_Oper_Exec = "2"; // '执行操作 //2
	
		this.Trans_Oper_TableList = "3"; // '数据表列表操作 //3
	
		this.Trans_Oper_ColumnList = "4"; // '数据列列表操作 //4
	
		// '下面是事务相关方法
		this.Trans_BeginTrans = "begintrans"; // '启动一个事务
	
		this.Trans_AddCommand = "addcommand"; // '增加命令
	
		this.Trans_Commit = "commit"; // '提交事务
	
		this.Trans_Rollback = "rollback"; // '回滚（取消）事务
	
		// '下面是获得数据窗口定义的方法
		this. Trans_GetDWDefine = "getdwdefine"; // '从后台检索数据窗口定义文件

	}
}

/**
 * 语言类型定义,用于进行多语言支持
 * 
 * @author liujunsong
 * 
 */
class LangDef {
	constructor(){
		this.Lang_SimpleChinese = "SimpleChinese";// '简体中文定义
		this.Lang_English = "English"; // '英文定义
		this.Lang_French = "French"; // '法文定义
		this.Lang_Japanese = "Japanese"; // '日文定义
	}
}

/**
 * 全局变量定义
 * 
 * @author admin
 * 
 */
class Golbal extends VBFunction {
	constructor(){
		super();
		
		this.ReadMe="全局变量和全局方法定义";

		this.GG_webdw = new WebDWSyntax();
		this.GG_empty_webdw = new WebDWSyntax();
		this.G_ServerURL = "/myproj/Table";
		//this.G_ServerURL = "http://webdw.vicp.net/myproj/Table";
		this.G_Lang = "SimpleChinese";
		this.G_LangDef = new LangDef();
		this.G_Transaction_Const = new Transaction_Const();
		this.True = true;
		this.False = false;

	}
}

var golbal = new Golbal();

	// '从一个targetControls容器中，根据给定控件名称来检索控件
	// '如果控件不存在，则返回Nothing
	function GF_GetObjectByName(targetControls, objName) {
		var vobj = null;
		for (var i = 0; i < targetControls.length; i++) {
			vobj = targetControls[i];
			
			if (vobj == null) {
				continue;
			}
			if (vobj.name == null) {
				continue;
			}
			var s1 = vobj.name.toUpperCase();
			var s2 = objName.toUppderCase();
			if (s1 == s2) {
				return vobj;
			}
		}
		return null;
	}
	

	function GF_GetVBColor( pbColor,  defColor) {
		var iret = 0;
		var SYSCOLOR = 16777215;// '最大颜色值,256 * 256 * 256 - 1

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

	function GF_GetConvertRate(targetControls) {
		var convertRate;
		var TextConvertRate;

		TextConvertRate = GF_GetObjectByName(targetControls, "TextConvertRate");

		if (TextConvertRate == null) {
			return 0.3;
		}
		
		convertRate = parseFloat(TextConvertRate.Text()); // '获取设置值
		if (convertRate <= 0.1 || convertRate >= 10) {
			convertRate = 0.2;
		}

		return convertRate;
	}

	function GF_RetrieveBySyntax( dwSyntax) {
		var iret = new MyInt(0);
		var temp_webdw = new CWebDW();
		var temp_sqlca = new CWebDWTransaction();
		var str_retrieve = "";
		var sdata = "";

		if (temp_webdw.Create(dwSyntax) == -1) {// Then '解析失败，返回空字符串
			return "";
		}
		log(dwSyntax);
		log("" + GG_webdw.getColumnNumber());
		str_retrieve = temp_webdw.GetRetrieveSQL();// '得到检索用的SQL语句
		log(str_retrieve);
		if (str_retrieve.length() == 0) {
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

	function GF_GetDBlength( sdata) {
		var i = 0;
		var ilen = 0;
		var stemp = "";
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

	function GF_IF( ifClause,  YesValue,  NoValue) {
		if (ifClause) {
			return YesValue;
		} else {
			return NoValue;
		}
	}

	function GF_IF_Long( ifClause,  YesValue,  NoValue) {
		if (ifClause) {
			return YesValue;
		} else {
			return NoValue;
		}
	}

	function GF_GetAlignType(intype) {
		if (intype == 0) {
			return 0;
		}
		if (intype == 1) {
			return 1;
		}
		if (intype == 2) {
			return 2;
		}
		return 0;
	}

	/**
	 * 将VB的颜色转换成Java的颜色
	 * 
	 * @param vbcolor
	 * @return
	 */
	function GF_GetJavaColor( vbcolor) {
		//if (vbcolor == 255) {
		//	return Color.RED;
		//}
		return 0;
	}

	function log(s) {
		console.log(s);
	}
	
	function Log(s) {
		console.log(s);
	}
