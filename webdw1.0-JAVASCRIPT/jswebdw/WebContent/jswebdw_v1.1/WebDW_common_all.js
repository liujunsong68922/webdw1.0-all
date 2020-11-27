//<script src="jswebdw/VBFunction.js"></script>
//<script src="jswebdw/Golbal.js"></script>
//<script src="jswebdw/MyInt.js"></script>

//将VB的函数定义成公用函数，供其他程序调用，暂时不考虑可能存在的命名冲突问题

/**
 * 这个类定义了许多VB方法的Java实现，避免重复书写代码
 * 
 * @author admin
 * 
 */
class VBFunction {
	// Constructor function
	constructor(){
		this.ReadMe="这个类定义了许多VB方法的Java/JavaScript实现，避免重复书写代码";
	}
}

	/**
	 * 提供与VB函数InStr相同的功能,VB的字符串返回,是从1开始的,所以将返回值加1返回 返回0代表找不到
	 * 
	 * @param beginPos,有效位置从1开始
	 * @param string1
	 * @param findString
	 * @return
	 */
function InStr3(beginPos, string1, findString) {
		var ipos;
		if (string1 == null || string1=="") {
			return -1;
		}
		if (beginPos<1){
			beginPos=1;
		}
		ipos = string1.indexOf(findString, beginPos - 1);
		return ipos + 1;
	}

function 	InStr2(string1, findString) {
		return InStr3(0, string1, findString);
	}
	
function 	InStr(beginPos, string1, findString) {
		return InStr3(beginPos, string1, findString);
	}

	/**
	 * 提供与VB函数Len相同的功能
	 * 
	 * @param inStr
	 * @return
	 */
function 	Len(inStr) {
		if (inStr == null) {
			return 0;
		}
		return inStr.length;
	}

	/**
	 * 提供与VB函数Mid相同的功能,VB的字符串计算,下标从1开始.
	 * 
	 * @param str1
	 * @param pos
	 * @param length
	 * @return
	 */
function 	Mid3(str1,  pos,  length) {
		if (length <= 0) {
			return "";
		}
		return str1.substring(pos - 1, pos + length - 1);
	}

function 	Mid2( str1,  pos) {
		return str1.substring(pos - 1);
	}

function 	Mid(str1,  pos,  length) {
		return this.Mid3(str1,  pos,  length);
	}
	/**
	 * 提供与VB函数Left相同的功能,获得左面几个字符的数据
	 * 
	 * @param instr
	 * @param i
	 * @return
	 */
function 	Left(instr, i) {
		if (instr.length >= i) {
			return instr.substring(0, i);
		} else {
			return instr;
		}
	}

	/**
	 * 提供与VB函数Right相同的功能,获得右面几个字符的数据
	 * 
	 * @param instr
	 * @param i
	 * @return
	 */
function 	Right( instr,  i) {
		return instr.substring(instr.length - i);
	}

	// 得到指定Asc码对应的字符串
function 	Chr(i) {
		if (i == 9)
			return "\t";
		if (i == 13)
			return "\r";
		if (i == 10)
			return "\n";
		return "";
	}

	/**
	 * 将字符串转换成整数
	 * 
	 * @param s
	 * @return
	 */
	function 	toInt(s) {
		try {
			return parseInt(s);
		} catch ( e) {
			// e.printStackTrace();
			// System.out.println("ERROR Data ToInt:*"+s+"*");
			return 0;
		}
	}

	/**
	 * 将字符串转换成数值
	 * 
	 * @param s
	 * @return
	 */
	function 	toDouble( s) {
		try {
			return parseFloat(s);
		} catch ( e) {
			// e.printStackTrace();
			// System.out.println("ERROR Data ToInt:*"+s+"*");
			return 0;
		}
	}

	function 	UCase(inStr) {
		return inStr.toUpperCase();
	}

	function 	Split( inStr1,  sepStr) {
		// return inStr.split(sepStr);
		var arraynum = 0;
		var data = new Array(1000);
		var i = 0;
		var tempi = 0;
		tempi = InStr3(i, inStr1, sepStr);
		while (tempi > 0) {
			if (i == 0) {
				// 第一个元素,从1开始计算
				data[arraynum] = Mid(inStr1, 1, tempi - i - 1);
			} else {
				data[arraynum] = Mid(inStr1, i + sepStr.length, tempi - i
						- sepStr.length);
			}
			arraynum++;
			i = tempi;
			tempi = InStr(i+1, inStr1, sepStr);
		}
		if (i == 0) {
			data[arraynum] = inStr1;
		} else {
			data[arraynum] = Mid2(inStr1, i + sepStr.length);
		}
		arraynum++;
		var newdata = new Array(arraynum);
		for (i = 0; i < arraynum; i++) {
			newdata[i] = data[i];
		}
		return newdata;
	}

	/**
	 * 得到数组的最大下标
	 * 
	 * @param instr
	 * @return
	 */
	function 	UBound(instr) {
		return instr.length - 1;
	}

	/**
	 * 去掉字符串两面的空格
	 * 
	 * @param inStr
	 * @return
	 */
	function 	Trim(inStr) {
		return inStr.replace(/(^\s*)|(\s*$)/g,"");
	}



	/**
	 * 得到当前时间的表示
	 * 
	 * @return
	 */
	function 	Now() {
		return new Date().toString();
	}

	function 	RGB( r,  g,  b) {
		return r * 256 * 256 + g * 256 + b;
	}

	function 	Asc( s) {
		if (s == null) {
			s = " ";
		}
		if (s.length == 0) {
			s = " ";
		}
		return s.charAt(0);
	}

	/**
	 * 判断S1 > S2
	 * 
	 * @param s1
	 * @param s2
	 * @return
	 */
	function 	IsGreat( s1,  s2) {
		if (s1.length > 0 && s2.length > 0) {
			if (s1.charAt(0) > s2.charAt(0)) {
				return true;
			}
			if (s1.charAt(0) < s2.charAt(0)) {
				return false;
			}
			s1 = s1.substring(1);
			s2 = s2.substring(1);
			return IsGreat(s1, s2);
		}

		if (s1.length > 0 && s2.length == 0) {
			return true;
		}

		if (s1.length == 0 && s2.length > 0) {
			return false;
		}
		return true;
	}

	function 	IsNumeric(s1) {
		try {
			var d = parseFloat(s1);
			return true;
		} catch ( e) {
			return false;
		}
	}

	function 	Rnd(d) {
		return Math.random() * d;
	}
	
	// 弹出一个类似VB的Windows标准对话框
// static JFrame f1 = new JFrame();
// static MessageJDialog d1 = null;
	function 	MessageBox2( title, info){
	
	}
	
	function 	MessageBox(sinfo){
		MessageBox("JWebDW0.3",sinfo);
	}

	function 	MsgBox3(stext, iButton, title){
		MessageBox2(title,stext);
	}
	
	/**
	 * 替换字符串中的内容
	 * 
	 * @param instr
	 * @param str1
	 * @param str2
	 * @return
	 */
	function 	Replace(instr, str1, str2) {
			var dataarray = Split(instr,str1);// 调用自己定义的Split方法
			console.log(dataarray.length);
			var id = 0;
			var sret ="";
			for(id=0;id<dataarray.length;id++){
				if(sret==""){
					sret = dataarray[id];
				}else{
					sret = sret + str2 + dataarray[id];
					console.log("id "+ id+" :"+ sret);
				}
			}
			return sret;

		// return instr.split(str1).join(str2);
	}

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
			// if (vbcolor == 255) {
			// return Color.RED;
			// }
			return 0;
		}

		function log(s) {
			console.log(s);
		}
		
		function Log(s) {
			console.log(s);
		}

		class MyInt {
			// Constructor function
			constructor(i){
				this.ReadMe ="自己提供的对于int数据类型的封装,用来实现VB的ByRef调用";
				this.intvalue = i;
			}
		}

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

		//Rem -------------------------------------------------
		//Rem CWebDWEditMask类是一个掩码类，
		//Rem 主要功能是在数据录入时格式化数据输入
		//Rem 在数据输出时也同样进行格式化
		//Rem @CopyRight Mr.Liu Junsong 2008-2009
		//Rem @版权所有 刘峻松 2008-2009
		//Rem E_mail : liujunsong@yahoo.com.cn
		//Rem -------------------------------------------------

		class CWebDWDisplayFormat{
			// constructor function
			constructor(){
				this.ReadMe="CWebDWEditMask类是一个掩码类";
			}
			// '给定一个输入字符串，加上一个编辑风格的字符串
			// '输出一个已经格式化以后的字符串
			GetFormatString( inString,  sformat, iDataType) {
				return "";
			}

			// '将输入的代表数值的字符串，按照指定格式进行格式化
			// '这一方法用来获得数值型数据的掩码支持
			// '按照PB的规则，
			// '#代表1位数字
			// '0代表1位数字，无对应位时用0补足
			// '.小数点
			// '，带分割符号
			// '算法如下：
			// '以小数点为界，从头开始计算原数值与对应的掩码标志。
			// '如果：原始数据位数 > 掩码位数 那么 取原始位数
			// '如果: 原始数据位数 = 掩码位数，而且掩码为#
			// '如果：原始数据位数 < 掩码位数，而且掩码=0 ，那么返回0
			// '如果：掩码中定义了分割符号（除#,0)以外，那么返回分割符号
			GetFormateDecimal(inString,sformate) {
				return inString;
				// TODO:需要进行必要的代码迁移，暂时忽略这部分功能
			}

		}
		
