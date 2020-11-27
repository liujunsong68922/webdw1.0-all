//<script src="jswebdw/CWebDW_Create.js"></script>
//<script src="jswebdw/CWebDW_GetRetrieveSQL.js"></script>
//<script src="jswebdw/CWebDW_GetSyntaxString.js"></script>
//<script src="jswebdw/CWebDW_SyntaxFromSQL.js"></script>
//<script src="jswebdw/CWebDW.js"></script>
//<script src="jswebdw/CWebDWData_DataBuffer.js"></script>
//<script src="jswebdw/CWebDWData.js"></script>

/**
 * 将一个字符串转换成一个WebDWSyntax对象的方法
 * 
 * @author admin
 * 
 */
// Rem -------------------------------------------------
// Rem WebDW的字符串解析功能
// Rem 输入一个字符串,将这个字符串解析成一个WebDW结构
// Rem 以后就可以直接访问WebDW结构,而不必再去访问字符串进行解析
// Rem 这样字符串的解析只需要发生一次就可以了
// Rem 这个类对外只提供一个公共方法convertDW，用一个字符串填充local_webdw
// Rem 输出：local_webdw,errString
// Rem @CopyRight Mr.Liu Junsong 2008-2009
// Rem @版权所有 刘峻松 2008-2009
// Rem E_mail : liujunsong@yahoo.com.cn
// Rem -------------------------------------------------
class CWebDW_Create{
	// construtor function
	constructor(){
		this.ReadMe="WebDW的字符串解析功能";
		this.email = "liujunsong@aliyun.com";

		this.dwString = ""; // '这个变量存储要解析的字符串,未来可用来比较,只读
		this.errString = ""; // '解析失败以后的错误信息存储在这里
		this.local_webdw = new WebDWSyntax();// 'g_webdw现在是一个局部变量了，而不是全局变量了
		
		this.Golbal = golbal;
	
	}

	// '功能描述：设置g_webdw的值
	// '输入：gg_webdw
	// '输出：g_webdw
	SetLocalWebDW() {
		this.local_webdw = this.Golbal.GG_webdw.Clone();
	}

	// '功能描述：读取g_webdw的值
	// '输入:g_webdw
	// '输出:gg_webdw
	GetLocalWebDW() {
		this.Golbal.GG_webdw = this.local_webdw.Clone();
	}

	// '这个是一个主要的对外公开的解析方法
	// '输入一个字符串,把它解析成一个webdw结构的数据
	// '并存储在g_webdw中
	// '字符串存储在dwString中备用
	// '返回0代表成功
	// '如果解析失败,返回-1代表有错误(一般不会)
	// '不存储字符串,也不存储webdw
	// '错误信息存储在errString中
	Create( inString) {
		var iflag = 0;
		// 'step1 初始化g_webdw

		this.local_webdw = this.Golbal.GG_empty_webdw.Clone();
		this.dwString = inString;
		this.errString = "";

		// 'step2 读入datawindow部分,如果出错,退出程序
		if (this.readWebDW01_Datawindow() == -1) {
			return -1;
		}

		// 'step3 读入header部分
		if (this.readWebDW02_Header() == -1) {
			return -1;
		}

		// 'step4 读入summary部分
		if (this.readWebDW03_Summary() == -1) {
			return -1;
		}

		// 'step5 读入footer部分
		if (this.readWebDW04_Footer() == -1) {
			return -1;
		}

		// 'step6 读入detail部分
		if (this.readWebDW05_Detail() == -1) {
			return -1;
		}

		// 'step7 读入table部分
		if (this.readWebDW06_Table() == -1) {
			return -1;
		}

		// 'step8 读入text部分
		if (this.readWebDW07_Text() == -1) {
			return -1;
		}

		// 'step9 读入column部分
		if (this.readWebDW08_Column() == -1) {
			return -1;
		}

		// 'step10 读入line部分
		if (this.readWebDW09_Line() == -1) {
			return -1;
		}
		// 'return
		return 0;
	}

	// '从inString字符串中，根据元素的名称，得到这个元素的整体描述字符串
	// '查找的算法是：
	// '从原始字符串中开始查找，找到eleName，它的后面应该跟随一个(，标志这个元素的开始
	// '元素中可能嵌套定义内部元素，因此需要对找到的()进行计数
	// '返回的字符串，不再包括()
	// '查找的算法受限于webdw的具体表示，目前采用和PB7一致的表示方法
	// '按照初步设计，webdw应该可以支持PB7导出的DW的正常显示功能
	// '或者说，webdw和PB7是兼容的。
	// 'inString 总的字符串
	// 'eleName 元素名称
	// 'beginPos 开始检索位置
	// 'findPos 输出参数,表示找到的位置,没找到返回-1,要返回参数,所以用Integer类型
	getElementDesc( inString, eleName, beginPos, findPos) {
		var iBeg;
		var leftPos;
		var iflag;

		var i;
		var s;

		findPos.intvalue = -1; // '初始化findPos的值，如果不改变，返回的就是-1

		iBeg = InStr(beginPos, inString, eleName);
		if (iBeg <= 0) {
			return ""; // '返回空字符串代表没有找到这个元素
		}

		leftPos = InStr(iBeg, inString, "("); // '得到左面括号的位置
		if (leftPos <= 0) {
			return ""; // '返回空字符串代表没有找到这个元素
		}

		iflag = 0; // '每找到一个(，iflag++,找到一个) iflag --
		for (i = leftPos + 1; i <= Len(inString); i++) {
			s = Mid(inString, i, 1); // '取当前字符串

			if ((s==("(") || s==(")"))
					&& Mid(inString, i - 1, 1)==("~")) { // '如果是()，需要判断上个字符是否是~,如果是不操作
				continue;
			}

			if (s==("(")) {
				iflag = iflag + 1;
				continue; // '继续进行循环
			}

			if (s==(")")) { // '当前值为)时需要判断iflag的值
				if (iflag == 0) { // 'iflag=0，可以结束循环
					var s1 = Mid(inString, leftPos, i - leftPos + 1);
					findPos.intvalue = leftPos; // '找到的位置是leftPos
					return s1;
				} else {
					iflag = iflag - 1; // '否则将iflag减去1
				}
			}
		}

		return "";
	}

	// '对输入的字符串进行检查
	// '如果以"开头，以"结束,那么就删除掉前后的两个引号
	removeQuote( strIn) {
		var ilen;
		ilen = Len(strIn);

		if (strIn == ("")) {
			return "";
		}
		if (Left(strIn, 1)==("\"") && Right(strIn, 1)==("\"")) {
			return Mid(strIn, 2, ilen - 2);
		}
		return strIn;
	}

	// '从元素表示的字符串里面，用括号包括起来的
	// '取出指定的属性的实际属性值
	// '如果找不到，则返回一个空字符串
	// 'retFlag是一个标志字符串，返回0代表找到了，返回-1代表没有这个指定名称的参数
	// 'eleString 只读
	// 'paraName 只读（大小写敏感）
	// 'begPos 开始查找点
	// 'defValue 找不到时候的默认值
	// 'retFlag 输出参数0代表成功结束-1代表失败
	// 'sep 结束的分割符号，遇到此符号代表结束

	getElementProp2( eleString, paraName, begPos, defValue, retFlag, sep) {
		var iBeg;
		var iEnd;
		var ipos;
		var i;
		var iflag;
		var s;
		var svalue;

		retFlag.intvalue = -1;
		ipos = InStr(begPos, eleString, paraName + "="); // '找到属性名称的开始点
		if (ipos <= 0) { // '找不到，退出
			return defValue; // '返回默认值
		}

		iBeg = ipos + Len(paraName + "="); // 'iBeg代表值的开始点
		iflag = 0;
		for (i = iBeg; i <= Len(eleString); i++) {
			s = Mid(eleString, i, 1);

			if (s==("\"")) { // '如果当前字符串是引号，那么设置标志
				if (iflag == 0) {
					iflag = 1;
				} else {
					iflag = 0;
				}
				continue;
			}

			if (s==(sep)) { // '如果s是结束符号，需要根据iFlag来判断
				if (iflag == 0) { // '如果不在字符串内，那么就退出
					svalue = Mid(eleString, iBeg, i - iBeg);
					svalue = this.removeQuote(svalue); // '去掉开头和结尾的引号
					// getElementProp2 = svalue
					retFlag.intvalue = 0; // '标志成功结束
					return svalue; // '退出此功能
				}
			}

		}

		return defValue; // '返回默认值
	}

	// '从元素表示的字符串里面，用括号包括起来的
	// '取出指定的属性的实际属性值
	// '如果找不到，则返回一个空字符串
	// 'retFlag是一个标志字符串，返回0代表找到了，返回-1代表没有这个指定名称的参数
	// 'eleString 只读
	// 'paraName 只读（大小写敏感）
	// 'begPos 开始查找点
	// 'defValue 找不到时候的默认值
	// 'retFlag 输出参数0代表成功结束-1代表失败
	getElementProp( eleString, paraName, begPos, defValue, retFlag) {
		var svalue;
		svalue = this.getElementProp2(eleString, paraName, begPos, defValue,
				retFlag, " ");
		return svalue;
	}

	// '功能描述：将输入的字符串切分成包含多个实际元素的array对象
	// '只获取其中的指定类型对象
	getAllElement( inString, eletype) {
		var myarray = new Array();
		var stext = "";
		var ipos = new MyInt(0);

		// '分解dwString，将其中的元素取出，描述放入myarray中去

		stext =this.getElementDesc(inString, eletype + "(", 1, ipos);
		while (ipos.intvalue > 0) {
			//myarray.add(stext); // '容器内加入sText
			myarray.push(stext);
			stext =this.getElementDesc(inString, eletype + "(", ipos.intvalue + 1,
					ipos);
		}

		return myarray;
	}

	// '读入datawindow部分的属性
	// '返回0代表成功
	// '返回-1代表失败
	readWebDW01_Datawindow() {
		var sDataWindow;
		var ipos = new MyInt(0);
		var iflag = new MyInt(0);

		// '得到datawindow的表示
		sDataWindow =this.getElementDesc(this.dwString, "datawindow", 1, ipos);

		console.log("sDataWindow:"+sDataWindow);
		// '如果不存在datawindow定义,视为错误数据,停止执行
		if (ipos.intvalue < 0) {
			this.errString = "ERROR:readWebDW01_Datawindow:数据格式不合法:找不到datawindow定义(必须)";
			return -1;
		}

		// '如果存在datawindow定义,那么就设置它的属性
		// '即使没有,也直接跳过去,不报错误,直接设置一个默认值
		this.local_webdw.datawindow.unit = this.getElementProp(sDataWindow, "unit", 1,
				"0", iflag);
		this.local_webdw.datawindow.timer_interval = this.getElementProp(sDataWindow,
				"time_interval", 1, "0", iflag);
		this.local_webdw.datawindow.color = toInt(this.getElementProp(sDataWindow,
				"color", 1, "0", iflag));
		this.local_webdw.datawindow.processiong = this.getElementProp(sDataWindow,
				"processiong", 1, "", iflag);
		this.local_webdw.datawindow.HTMLDW = this.getElementProp(sDataWindow, "HTMLDW",
				1, "no", iflag);
		this.local_webdw.datawindow.print_documentname = this.getElementProp(sDataWindow,
				"print.documentname", 1, "", iflag);
		this.local_webdw.datawindow.print_orientation = toInt(this.getElementProp(
				sDataWindow, "print.orientation", 1, "0", iflag));
		this.local_webdw.datawindow.print_margin_left = toInt(this.getElementProp(
				sDataWindow, "print.margin.left", 1, "110", iflag));
		this.local_webdw.datawindow.print_margin_right = toInt(this.getElementProp(
				sDataWindow, "print.margin.right", 1, "110", iflag));
		this.local_webdw.datawindow.print_margin_top = toInt(this.getElementProp(
				sDataWindow, "print.margin.top", 1, "96", iflag));
		this.local_webdw.datawindow.print_margin_bottom = toInt(this.getElementProp(
				sDataWindow, "print.margin.bottom", 1, "96", iflag));
		this.local_webdw.datawindow.print_paper_source = toInt(this.getElementProp(
				sDataWindow, "print.paper.source", 1, "0", iflag));
		this.local_webdw.datawindow.print_paper_size = toInt(this.getElementProp(
				sDataWindow, "print.paper.size", 1, "0", iflag));
		this.local_webdw.datawindow.print_prompt = this.getElementProp(sDataWindow,
				"print.prompt", 1, "no", iflag);
		this.local_webdw.datawindow.print_buttons = this.getElementProp(sDataWindow,
				"print.buttons", 1, "no", iflag);
		this.local_webdw.datawindow.print_preview_buttons = this.getElementProp(
				sDataWindow, "print.preview.buttons", 1, "no", iflag);
		this.local_webdw.datawindow.grid_lines = this.getElementProp(sDataWindow,
				"grid.lines", 1, "-1", iflag);
		return 0;
	}

	// '读入header部分的属性
	// '返回0代表成功
	// '返回-1代表失败
	readWebDW02_Header() {
		var sHeader = "";
		var ipos = new MyInt(0);
		var iflag = new MyInt(0);

		// '得到datawindow的表示
		sHeader =this.getElementDesc(this.dwString, "header", 1, ipos);

		// '如果找不到header定义，就退出
		if (ipos.intvalue < 0) {
			return 0;
		}

		this.local_webdw.header.height = toInt(this.getElementProp(sHeader, "height", 1,
				"0", iflag));
		this.local_webdw.header.color = toInt(this.getElementProp(sHeader, "color", 1,
				"0", iflag));
		return 0;

	}

	// '读入summary部分的属性
	// '返回0代表成功
	// '返回-1代表失败
	readWebDW03_Summary() {
		var sSummary = "";
		var ipos = new MyInt(0);
		var iflag = new MyInt(0);

		// '得到summary的表示
		sSummary =this.getElementDesc(this.dwString, "summary", 1, ipos);

		// '如果找不到summary定义，就退出
		if (ipos.intvalue < 0) {
			errString = "ERROR:readWebDW03_Summary:数据格式不合法:找不到summary定义(必须)";
			return -1;
		}

		this.local_webdw.summary.height = toInt(this.getElementProp(sSummary, "height",
				1, "0", iflag));
		this.local_webdw.summary.color = toInt(this.getElementProp(sSummary, "color", 1,
				"0", iflag));
		return 0;
	}

	// '读入footer部分的属性
	// '返回0代表成功
	// '返回-1代表失败
	readWebDW04_Footer() {
		var sFooter = "";
		var ipos = new MyInt(0);
		var iflag = new MyInt(0);

		// '得到footer的表示
		sFooter =this.getElementDesc(this.dwString, "footer", 1, ipos);

		// '如果找不到footer定义，就退出
		if (ipos.intvalue < 0) {
			errString = "ERROR:readWebDW04_Footer:数据格式不合法:找不到footer定义(必须)";
			return -1;
		}

		this.local_webdw.footer.height = toInt(this.getElementProp(sFooter, "height", 1,
				"0", iflag));
		this.local_webdw.footer.color = toInt(this.getElementProp(sFooter, "color", 1,
				"0", iflag));
		return 0;
	}

	// '读入detail部分的属性
	// '返回0代表成功
	// '返回-1代表失败
	readWebDW05_Detail() {
		var sDetail = "";
		var ipos = new MyInt(0);
		var iflag = new MyInt(0);

		// '得到footer的表示
		sDetail =this.getElementDesc(this.dwString, "detail", 1, ipos);

		// '如果找不到footer定义，就退出
		if (ipos.intvalue < 0) {
			errString = "ERROR:readWebDW05_Detail:数据格式不合法:找不到detail定义(必须)";
			return -1;
		}
		this.local_webdw.detail.height = toInt(this.getElementProp(sDetail, "height", 1,
				"0", iflag));
		this.local_webdw.detail.color = toInt(this.getElementProp(sDetail, "color", 1,
				"0", iflag));
		return 0;
	}

	// '读入detail部分的属性
	// '返回0代表成功
	// '返回-1代表失败
	readWebDW06_Table() {
		var stable = "";
		var ipos = new MyInt(0);
		var iflag = new MyInt(0);
		var columnArray = new Array();
		var obj;
		var stemp;
		var id = 0;

		// '得到footer的表示
		stable =this.getElementDesc(this.dwString, "table", 1, ipos);

		// '如果找不到footer定义，就退出
		if (ipos.intvalue < 0) {
			errString = "ERROR:readWebDW06_Table:数据格式不合法:找不到table定义(必须)";
			return -1;

		}

		// '先读取column属性
		columnArray = this.getAllElement(stable, "column=");
		id = 0;
		for (var i = 0; i < columnArray.length; i++) {
			stemp =  columnArray[i];

			id = id + 1;
			if (id > 100) {
				errString = "ERROR:readWebDW06_Table:SELECT的列超过100行!";
				return -1;
			}

			this.local_webdw.table.Columns[id].type = this.getElementProp(stemp, "type",
					1, "", iflag);
			this.local_webdw.table.Columns[id].update = this.getElementProp(stemp,
					"update", 1, "yes", iflag);
			this.local_webdw.table.Columns[id].updatewhereclause = this.getElementProp(
					stemp, "updatewhereclause", 1, "yes", iflag);
			this.local_webdw.table.Columns[id].key = this.getElementProp(stemp, "key", 1,
					"", iflag);
			this.local_webdw.table.Columns[id].Name = this.getElementProp(stemp, "name",
					1, "", iflag);
			this.local_webdw.table.Columns[id].dbname = this.getElementProp(stemp,
					"dbname", 1, "", iflag);
			this.local_webdw.table.Columns[id].values = this.getElementProp(stemp,
					"values", 1, "", iflag);

		}

		// '读取retrieve属性值
		// 'g_webdw.table.retrieve = this.getElementProp(stable, "retrieve", 1,
		// "",
		// iflag)

		// 'update,updatewhere,updatekeyinplace
		this.local_webdw.table.update = this.getElementProp(stable, "update", 1, "",
				iflag);
		this.local_webdw.table.updatewhere = this.getElementProp(stable, "updatewhere",
				1, "", iflag);
		this.local_webdw.table.updatekeyinplace = this.getElementProp(stable,
				"updatekeyinplace", 1, "", iflag);

		// '将retrieve字符串的属性读取到对应的变量中去
		// 'retrieve现在不是一个变量，而是一个结构体了。
		var strPBSelect = "";
		var Columns = new Array(101);// String[101]; //
										// '定义要读取的column的名称，这个column是数据库的名称
		var tables = new Array(11);String[11]; // '定义要读取的table名称，最多10个
		var temparray = new Array();
		var tempobj = "";
		var iret = new MyInt(0);

		var select_tablelist = ""; // 'tabel 子句
		var select_columnlist = ""; // 'column 子句
		var select_join = ""; // 'join 条件子句
		var select_where = ""; // 'where子句

		var stablename = "";
		var table_id = 0;
		var scolumnname = "";
		var column_id = 0;

		var join_id = 0;
		var join_left = "";
		var join_op = "";
		var join_right = "";

		var where_id = 0;
		var exp1 = "";
		var where_op = "";
		var exp2 = "";
		var logic = "";

		var order_id = 0;// As Long
		var order_name = "";// As String
		var order_asc = "";// As String

		strPBSelect = this.getElementProp(stable, "retrieve", 1, "", iflag); // '先读取retrieve属性出来

		// '读取table属性
		temparray = this.getAllElement(strPBSelect, "TABLE"); // '得到TABLE元素的定义
		table_id = 0;
		for (var i = 0; i < temparray.length; i++) {
			stemp =  temparray[i];
			stablename = this.getElementProp2(stemp, "NAME", 1, "", iret, ")"); // '采用)作为结束分割符号

			if (iret.intvalue == -1) {
				continue;
			}

			table_id = table_id + 1;
			if (table_id > 10) {
				break;
			}
			this.local_webdw.table.retrieve.pbselect.table[table_id] = stablename; // '存储tableName的值

		}

		// '读取column属性
		temparray = this.getAllElement(strPBSelect, "COLUMN"); // '得到column元素定义
		column_id = 0;
		for (var i = 0; i < temparray.length; i++) {
			stemp = temparray[i];
			scolumnname = this.getElementProp2(stemp, "NAME", 1, "", iret, ")");

			if (iret.intvalue == -1) {
				continue;
			}

			column_id = column_id + 1;
			if (column_id > 100) {
				break;
			}
			this.local_webdw.table.retrieve.pbselect.column[column_id] = scolumnname; // '存储column的NAME
		}

		// '读取join属性
		temparray = this.getAllElement(strPBSelect, "JOIN "); // '得到JOIN元素定义，后面有一个空格
		join_id = 0;
		for (var i = 0; i < temparray.length; i++) {
			stemp = temparray[i];
			join_left = this.getElementProp2(stemp, "LEFT", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			join_op = this.getElementProp2(stemp, "OP", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			join_right = this.getElementProp2(stemp, "RIGHT", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			join_id = join_id + 1;
			if (join_id > 10) {
				break;
			}
			this.local_webdw.table.retrieve.pbselect.join[join_id].join_left = join_left;
			this.local_webdw.table.retrieve.pbselect.join[join_id].join_op = join_op;
			this.local_webdw.table.retrieve.pbselect.join[join_id].join_right = join_right;
		}

		// '读取where属性
		temparray = this.getAllElement(strPBSelect, "WHERE"); // '得到Where元素定义
		where_id = 0;
		for (var i = 0; i < temparray.length; i++) {
			stemp = temparray[i];
			exp1 = this.getElementProp2(stemp, "EXP1", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			where_op = this.getElementProp2(stemp, "OP", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			exp2 = this.getElementProp2(stemp, "EXP2", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			logic = this.getElementProp2(stemp, "LOGIC", 1, "", iret, " ");

			where_id = where_id + 1;
			if (where_id > 10) {
				break;
			}
			this.local_webdw.table.retrieve.pbselect.where[where_id].exp1 = exp1;
			this.local_webdw.table.retrieve.pbselect.where[where_id].op = where_op;
			this.local_webdw.table.retrieve.pbselect.where[where_id].exp2 = exp2;
			this.local_webdw.table.retrieve.pbselect.where[where_id].logic = logic;

		}

		// '读取order属性
		// Set temparray = this.getAllElement(strPBSelect, "ORDER") '得到order元素定义
		// order_id = 0
		// For Each tempobj In temparray
		// stemp = tempobj
		// order_name = this.getElementProp2(stemp, "NAME", 1, "", iret, " ")
		// If iret = -1 Then GoTo continue5
		//	        
		// order_asc = this.getElementProp2(stemp, "ASC", 1, "yes", iret, " ")
		// '默认为升序
		// If iret = -1 Then GoTo continue5
		//	        
		// order_id = order_id + 1
		//	        
		// If order_id > 10 Then
		// Exit For
		// End If
		//	        
		// this.local_webdw.table.retrieve.pbselect.order(order_id).Name =
		// order_name
		// this.local_webdw.table.retrieve.pbselect.order(order_id).Asc =
		// order_asc
		// continue5:
		// Next

		// '读取order属性
		temparray = this.getAllElement(strPBSelect, "ORDER");// '得到order元素定义
		order_id = 0;
		for (var i = 0; i < temparray.length; i++) {
			stemp = temparray[i];
			order_name = this.getElementProp2(stemp, "NAME", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			order_asc = this.getElementProp2(stemp, "ASC", 1, "yes", iret, " ");// '默认为升序
			if (iret.intvalue == -1) {
				continue;
			}

			order_id = order_id + 1;

			if (order_id > 10) {
				break;
			}

			this.local_webdw.table.retrieve.pbselect.order[order_id].Name = order_name;
			this.local_webdw.table.retrieve.pbselect.order[order_id].Asc = order_asc;
		}

		return 0;
	}

	// '读入所有的text的属性
	// '返回0代表成功
	// '返回-1代表失败

	readWebDW07_Text() {
		var textArray = new Array();
		var obj;
		var stemp = "";
		var id = 0;
		var iret = new MyInt(0);

		textArray = this.getAllElement(this.dwString, "text");
		id = 0;
		// '循环处理
		for (var i = 0; i < textArray.length; i++) {
			stemp =  textArray[i];
			if (Len(stemp) < 10) {
				continue;
			}

			id = id + 1;

			if (id > 100) {
				errString = "ERROR:readWebDW07_Text:最多可读取100个标签!";
				return -1;
			}

			this.local_webdw.text[id].band = this.getElementProp(stemp, "band", 1,
					"detail", iret);
			this.local_webdw.text[id].alignment = toInt(this.getElementProp(stemp,
					"alignment", 1, "1", iret));
			this.local_webdw.text[id].text = this.getElementProp(stemp, "text", 1, "",
					iret);
			this.local_webdw.text[id].border = toInt(this.getElementProp(stemp, "border",
					1, "0", iret));
			this.local_webdw.text[id].color = toInt(this.getElementProp(stemp, "color",
					1, "0", iret));
			this.local_webdw.text[id].x = toInt(this.getElementProp(stemp, "x", 1, "0",
					iret));
			this.local_webdw.text[id].y = toInt(this.getElementProp(stemp, "y", 1, "0",
					iret));
			this.local_webdw.text[id].height = toInt(this.getElementProp(stemp, "height",
					1, "0", iret));
			this.local_webdw.text[id].width = toInt(this.getElementProp(stemp, "width",
					1, "0", iret));
			this.local_webdw.text[id].Name = this.getElementProp(stemp, "name", 1, "",
					iret);

			// '下面是字体属性
			this.local_webdw.text[id].font.face = this.getElementProp(stemp, "font.face",
					1, "", iret);
			this.local_webdw.text[id].font.height = toInt(this.getElementProp(stemp,
					"font.height", 1, "", iret));
			this.local_webdw.text[id].font.weight = toInt(this.getElementProp(stemp,
					"font.weight", 1, "", iret));
			this.local_webdw.text[id].font.family = toInt(this.getElementProp(stemp,
					"font.family", 1, "", iret));
			this.local_webdw.text[id].font.pitch = toInt(this.getElementProp(stemp,
					"font.pitch", 1, "", iret));
			this.local_webdw.text[id].font.charset = toInt(this.getElementProp(stemp,
					"font.charset", 1, "", iret));
			this.local_webdw.text[id].font.italic = toInt(this.getElementProp(stemp,
					"font.italic", 1, "0", iret));
			this.local_webdw.text[id].font.underline = toInt(this.getElementProp(stemp,
					"font.underline", 1, "0", iret));
			this.local_webdw.text[id].font.strikethrough = toInt(this.getElementProp(
					stemp, "font.strikethrough", 1, "0", iret));

			// '下面是颜色属性
			this.local_webdw.text[id].background_mode = toInt(this.getElementProp(stemp,
					"background.mode", 1, "", iret));
			this.local_webdw.text[id].background_color = toInt(this.getElementProp(stemp,
					"background.color", 1, "", iret));
		}
		return 0;
	}

	// '读入所有的column的属性
	// '返回0代表成功
	// '返回-1代表失败
	readWebDW08_Column() {
		var columnArray = new Array();
		var obj;
		var sColumn;
		var id;
		var iret = new MyInt(0);
		var temp_webdw_column = new WebDW_Column();

		columnArray = this.getAllElement(this.dwString, "column");
		id = 0;
		// '循环处理
		for (var i = 0; i < columnArray.length; i++) {
			sColumn = columnArray[i];
			id = id + 1;

			if (id > 100) {
				errString = "ERROR:readWebDW08_Column:最多可读取100个列!";
				return -1;
			}

			temp_webdw_column = new WebDW_Column();
			temp_webdw_column.band = this.getElementProp(sColumn, "band", 1, "1",
					iret);
			temp_webdw_column.id = toInt(this.getElementProp(sColumn, "id", 1, "0",
					iret));
			temp_webdw_column.alignment = toInt(this.getElementProp(sColumn,
					"alignment", 1, "1", iret));
			temp_webdw_column.tabsequence = toInt(this.getElementProp(sColumn,
					"tabsequence", 1, "0", iret));
			temp_webdw_column.border = toInt(this.getElementProp(sColumn, "border",
					1, "1", iret));
			temp_webdw_column.color = toInt(this.getElementProp(sColumn, "color", 1,
					"0", iret));

			temp_webdw_column.x = toInt(this.getElementProp(sColumn, "x", 1, "0",
					iret));
			temp_webdw_column.y = toInt(this.getElementProp(sColumn, "y", 1, "0",
					iret));
			temp_webdw_column.height = toInt(this.getElementProp(sColumn, "height",
					1, "0", iret));
			temp_webdw_column.width = toInt(this.getElementProp(sColumn, "width", 1,
					"0", iret));
			temp_webdw_column.format = this.getElementProp(sColumn, "format", 1, "",
					iret);
			temp_webdw_column.Name = this.getElementProp(sColumn, "name", 1, "",
					iret);
			temp_webdw_column.tag = this.getElementProp(sColumn, "tag", 1, "", iret);

			// '下面是编辑风格支持
			temp_webdw_column.edit_limit = toInt(this.getElementProp(sColumn,
					"edit.limit", 1, "0", iret));
			temp_webdw_column.edit_case = this.getElementProp(sColumn, "edit.case",
					1, "any", iret);
			temp_webdw_column.edit_focusrectangle = this.getElementProp(sColumn,
					"edit.focusrectangle", 1, "no", iret);
			temp_webdw_column.edit_autoselect = this.getElementProp(sColumn,
					"edit.autoselect", 1, "no", iret);
			temp_webdw_column.edit_autohscroll = this.getElementProp(sColumn,
					"edit.autohscroll", 1, "yes", iret);

			// '下面是字体支持
			temp_webdw_column.font.face = this.getElementProp(sColumn, "font.face",
					1, "", iret);
			temp_webdw_column.font.height = toInt(this.getElementProp(sColumn,
					"font.height", 1, "", iret));
			temp_webdw_column.font.weight = toInt(this.getElementProp(sColumn,
					"font.weight", 1, "", iret));
			temp_webdw_column.font.family = toInt(this.getElementProp(sColumn,
					"font.family", 1, "", iret));
			temp_webdw_column.font.pitch = toInt(this.getElementProp(sColumn,
					"font.pitch", 1, "", iret));
			temp_webdw_column.font.charset = toInt(this.getElementProp(sColumn,
					"font.charset", 1, "", iret));
			temp_webdw_column.font.italic = toInt(this.getElementProp(sColumn,
					"font.italic", 1, "0", iret));
			temp_webdw_column.font.underline = toInt(this.getElementProp(sColumn,
					"font.underline", 1, "0", iret));
			temp_webdw_column.font.strikethrough = toInt(this.getElementProp(
					sColumn, "font.strikethrough", 1, "0", iret));

			// '下面是background支持
			temp_webdw_column.background_mode = toInt(this.getElementProp(sColumn,
					"background.mode", 1, "", iret));
			temp_webdw_column.background_color = toInt(this.getElementProp(sColumn,
					"background.color", 1, "", iret));

			// '下面是单选按钮的支持定义20090124
			temp_webdw_column.radiobuttons.Columns = toInt(this.getElementProp(
					sColumn, "radiobuttons.columns", 1, "0", iret));

			// '下面是选择框按钮的支持定义20090124
			temp_webdw_column.checkbox.text = this.getElementProp(sColumn,
					"checkbox.text", 1, "", iret);
			temp_webdw_column.checkbox.on = this.getElementProp(sColumn,
					"checkbox.on", 1, "", iret);
			temp_webdw_column.checkbox.off = this.getElementProp(sColumn,
					"checkbox.off", 1, "", iret);
			temp_webdw_column.checkbox.scale1 = this.getElementProp(sColumn,
					"checkbox.scale", 1, "", iret);
			temp_webdw_column.checkbox.threed = this.getElementProp(sColumn,
					"checkbox.threed", 1, "", iret);

			// '下面是下拉列表编辑风格的支持定义20090124
			temp_webdw_column.combobox.allowedit = this.getElementProp(sColumn,
					"ddlb.allowedit", 1, "", iret);
			temp_webdw_column.combobox.limit = toInt(this.getElementProp(sColumn,
					"ddlb.limit", 1, "0", iret));
			temp_webdw_column.combobox.case1 = this.getElementProp(sColumn,
					"ddlb.case", 1, "", iret);
			temp_webdw_column.combobox.useasborder = this.getElementProp(sColumn,
					"ddlb.useasborder", 1, "", iret);

			// '下面是下拉式数据窗口的支持定义20090125(牛年除夕之夜)
			temp_webdw_column.dddw.allowedit = this.getElementProp(sColumn,
					"dddw.allowedit", 1, "", iret);
			temp_webdw_column.dddw.case1 = this.getElementProp(sColumn, "dddw.case",
					1, "", iret);
			temp_webdw_column.dddw.DataColumn = this.getElementProp(sColumn,
					"dddw.datacolumn", 1, "", iret);
			temp_webdw_column.dddw.DisplayColumn = this.getElementProp(sColumn,
					"dddw.displaycolumn", 1, "", iret);
			temp_webdw_column.dddw.limit = toInt(this.getElementProp(sColumn,
					"dddw.limit", 1, "0", iret));
			temp_webdw_column.dddw.Lines = toInt(this.getElementProp(sColumn,
					"dddw.lines", 1, "0", iret));
			temp_webdw_column.dddw.Name = this.getElementProp(sColumn, "dddw.name",
					1, "", iret);
			temp_webdw_column.dddw.PercentWidth = toInt(this.getElementProp(sColumn,
					"dddw.percentwidth", 1, "100", iret));
			temp_webdw_column.dddw.useasborder = this.getElementProp(sColumn,
					"dddw.useasborder", 1, "", iret);
			temp_webdw_column.dddw.vscrollbar = this.getElementProp(sColumn,
					"dddw.vscrollbar", 1, "", iret);

			this.local_webdw.column[temp_webdw_column.id] = temp_webdw_column;
		}
		return 0;
	}

	// '读取所画线条的属性
	readWebDW09_Line() {
		var lineArray = new Array();
		var obj;
		var sline = "";
		var id = 0;
		var iret = new MyInt(0);

		lineArray = this.getAllElement(this.dwString, "line");
		id = 0;
		// '循环处理
		for (var i = 0; i < lineArray.length; i++) {
			sline =  lineArray[i];

			id = id + 1;

			if (id > 100) {

				errString = "ERROR:readWebDW09_Line:最多可读取100个线条!";
				return -1;
			}

			this.local_webdw.lineinfo[id].band = this.getElementProp(sline, "band", 1,
					"detail", iret);
			this.local_webdw.lineinfo[id].x1 = toInt(this.getElementProp(sline, "x1", 1,
					"0", iret));
			this.local_webdw.lineinfo[id].y1 = toInt(this.getElementProp(sline, "y1", 1,
					"0", iret));
			this.local_webdw.lineinfo[id].x2 = toInt(this.getElementProp(sline, "x2", 1,
					"0", iret));
			this.local_webdw.lineinfo[id].y2 = toInt(this.getElementProp(sline, "y2", 1,
					"0", iret));
			this.local_webdw.lineinfo[id].Name = this.getElementProp(sline, "name", 1,
					"", iret);
			this.local_webdw.lineinfo[id].pen_style = this.getElementProp(sline,
					"pen.style", 1, "", iret);
			this.local_webdw.lineinfo[id].pen_width = this.getElementProp(sline,
					"pen.width", 1, "", iret);
			this.local_webdw.lineinfo[id].pen_color = this.getElementProp(sline,
					"pen.color", 1, "", iret);
			this.local_webdw.lineinfo[id].background_mode = this.getElementProp(sline,
					"background.mode", 1, "", iret);
			this.local_webdw.lineinfo[id].background_color = this.getElementProp(sline,
					"background.color", 1, "", iret);
		}
		return 0;
	}

}

//Rem -------------------------------------------------
//Rem WebDW的的数据访问功能类
//Rem 输入：g_webdw
//Rem g_webdw是由CWebDW构建生成的
//Rem 生成以后，对于g_webdw的所有数据读取请求，全部集中在CWebDWReader中实现
//Rem 这样可以明确代码的功能划分，避免代码混乱
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @版权所有 刘峻松 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------

class CWebDW_GetRetrieveSQL{
	//constructor function
	constructor(){
		this.ReadMe = "WebDW的的数据访问功能类";
		this.local_webdw = null;// 'local_webdw现在是一个局部变量了，而不是全局变量了
		this.Golbal = golbal;
	}
	
	// '功能描述：设置g_webdw的值
	// '输入：gg_webdw
	// '输出：g_webdw
	SetLocalWebDW() {
		this.local_webdw = this.Golbal.GG_webdw.Clone();
	}

	// '功能描述：读取g_webdw的值
	// '输入:g_webdw
	// '输出:gg_webdw
	GetLocalWebDW() {
		this.Golbal.GG_webdw = this.local_webdw.Clone();
	}

	// '对输入的字符串进行检查
	// '如果以"开头，以"结束,那么就删除掉前后的两个引号
	removeQuote( strIn) {
		var ilen;
		ilen = Len(strIn);

		if (strIn==("")) {
			return "";
		}
		if (Left(strIn, 1)==("\"") && Right(strIn, 1)==("\"")) {
			return Mid(strIn, 2, ilen - 2);
		}
		return strIn;
	}

	// '得到label的总数
	getLableNum() {
		var id = 0;
		for (id = 1; id <= 100; id++) {
			if (this.local_webdw.text[id].Name==("")) {
				return id - 1;
			}
		}
		return id - 1;
	}

	// '从inString字符串中，根据元素的名称，得到这个元素的整体描述字符串
	// '查找的算法是：
	// '从原始字符串中开始查找，找到eleName，它的后面应该跟随一个(，标志这个元素的开始
	// '元素中可能嵌套定义内部元素，因此需要对找到的()进行计数
	// '返回的字符串，不再包括()
	// '查找的算法受限于webdw的具体表示，目前采用和PB7一致的表示方法
	// '按照初步设计，webdw应该可以支持PB7导出的DW的正常显示功能
	// '或者说，webdw和PB7是兼容的。
	// 'inString 总的字符串
	// 'eleName 元素名称
	// 'beginPos 开始检索位置
	// 'findPos 输出参数,表示找到的位置,没找到返回-1,要返回参数,所以用Integer类型
	getElementDesc( inString, eleName,beginPos, findPos) {
		var iBeg;
		var leftPos;
		var iflag;

		var i;
		var s;

		findPos.intvalue = -1; // '初始化findPos的值，如果不改变，返回的就是-1

		iBeg = InStr(beginPos, inString, eleName);
		if (iBeg <= 0) {
			return ""; // '返回空字符串代表没有找到这个元素
		}

		leftPos = InStr(iBeg, inString, "("); // '得到左面括号的位置
		if (leftPos <= 0) {
			return ""; // '返回空字符串代表没有找到这个元素
		}

		iflag = 0; // '每找到一个(，iflag++,找到一个) iflag --
		for (i = leftPos + 1; i <= VBFunction.Len(inString); i++) {
			s = Mid(inString, i, 1); // '取当前字符串

			if (s==("(") || s==("")
					&& Mid(inString, i - 1, 1)==("~")) { // '如果是()，需要判断上个字符是否是~,如果是不操作
				continue;
			}

			if (s==("(")) {
				iflag = iflag + 1;
				continue; // '继续进行循环
			}

			if (s==(")")) { // '当前值为)时需要判断iflag的值
				if (iflag == 0) { // 'iflag=0，可以结束循环
					var s1 = Mid(inString, leftPos, i - leftPos + 1);
					findPos.intvalue = leftPos; // '找到的位置是leftPos
					return s1;
				} else {
					iflag = iflag - 1; // '否则将iflag减去1
				}
			}
		}

		return "";
	}

	// '从元素表示的字符串里面，用括号包括起来的
	// '取出指定的属性的实际属性值
	// '如果找不到，则返回一个空字符串
	// 'retFlag是一个标志字符串，返回0代表找到了，返回-1代表没有这个指定名称的参数
	// 'eleString 只读
	// 'paraName 只读（大小写敏感）
	// 'begPos 开始查找点
	// 'defValue 找不到时候的默认值
	// 'retFlag 输出参数0代表成功结束-1代表失败
	// 'sep 结束的分割符号，遇到此符号代表结束

	getElementProp( eleString, paraName, begPos, defValue, retFlag, sep) {
		var iBeg = 0;
		var iEnd = 0;
		var ipos = 0;
		var i = 0;
		var iflag = 0;
		var s = "";
		var svalue = "";

		retFlag.intvalue = -1;
		ipos = InStr(begPos, eleString, paraName + "=");// '找到属性名称的开始点
		if (ipos <= 0) {// '找不到，退出
			return defValue;// '返回默认值
		}

		iBeg = ipos + Len(paraName + "=");// 'iBeg代表值的开始点
		iflag = 0;
		for (i = iBeg; i <= Len(eleString); i++) {
			s = Mid(eleString, i, 1);

			if (s==("\"")) {// '如果当前字符串是引号，那么设置标志
				if (iflag == 0) {
					iflag = 1;
				} else {
					iflag = 0;
				}
				continue;
			}

			if (s==(sep)) {// '如果s是结束符号，需要根据iFlag来判断
				if (iflag == 0) {// '如果不在字符串内，那么就退出
					svalue = Mid(eleString, iBeg, i - iBeg);
					svalue = removeQuote(svalue);// '去掉开头和结尾的引号
					retFlag.intvalue = 0;// '标志成功结束
					return svalue;// '退出此功能
				}
			}

		}

		return defValue;// '返回默认值
	}

	// '功能描述：将输入的字符串切分成包含多个实际元素的array对象
	// '只获取其中的指定类型对象
	getAllElement( inString, eletype) {
		var myarray = new Array();
		var stext = "";
		var ipos = new MyInt(0);

		// '分解dwString，将其中的元素取出，描述放入myarray中去

		stext = getElementDesc(inString, eletype + "(", 1, ipos);
		while (ipos.intvalue > 0) {
			myarray.add(stext); // '容器内加入sText
			stext = getElementDesc(inString, eletype + "(", ipos.intvalue + 1,
					ipos);
		}

		return myarray;
	}

	// '功能描述：从DW定义中，分解得到数据库检索用的Select语句
	// '为下一步执行SQL操作打下基础
	// '这个SQL语句可能会带有参数
	GetRetrieveSQL() {
		var local_webdw = this.local_webdw;
		
		var id = 0;
		var select_tablelist = "";// 'tabel 子句
		var select_columnlist = "";// 'column 子句
		var select_join = "";// 'join 条件子句
		var select_where = "";// 'where子句
		var select_orderby = "";// As String 'order by子句

		select_tablelist = "";
		for (id = 1; id <= 10; id++) {
			if (this.local_webdw.table.retrieve.pbselect.table[id]==("")) {
				break;
			}

			if (select_tablelist==("")) {
				select_tablelist = this.local_webdw.table.retrieve.pbselect.table[id];

			} else {
				select_tablelist = select_tablelist + ","
						+ this.local_webdw.table.retrieve.pbselect.table[id];// '拼装Table子句
			}

		}

		select_columnlist = "";
		for (id = 1; id <= 100; id++) {
			if (this.local_webdw.table.retrieve.pbselect.column[id]==("")) {
				break;
			}

			if (select_columnlist==("")) {
				select_columnlist = local_webdw.table.retrieve.pbselect.column[id];
			} else {
				select_columnlist = select_columnlist + ","
						+ local_webdw.table.retrieve.pbselect.column[id];
			}
		}

		select_join = "";
		for (id = 1; id <= 10; id++) {
			if (this.local_webdw.table.retrieve.pbselect.join[id].join_left
					==("")) {
				break;
			}

			if (select_join==("")) {
				select_join = "("
						+ local_webdw.table.retrieve.pbselect.join[id].join_left
						+ " "
						+ local_webdw.table.retrieve.pbselect.join[id].join_op
						+ " "
						+ local_webdw.table.retrieve.pbselect.join[id].join_right
						+ ")";
			} else {
				select_join = select_join
						+ " AND "
						+ "("
						+ local_webdw.table.retrieve.pbselect.join[id].join_left
						+ " "
						+ local_webdw.table.retrieve.pbselect.join[id].join_op
						+ " "
						+ local_webdw.table.retrieve.pbselect.join[id].join_right
						+ ")";
			}
		}

		select_where = select_join;
		for (id = 1; id <= 10; id++) {
			if (this.local_webdw.table.retrieve.pbselect.where[id].exp1==("")) {
				break;
			}

			if (select_where==("")) {
				select_where = "("
						+ local_webdw.table.retrieve.pbselect.where[id].exp1
						+ " "
						+ local_webdw.table.retrieve.pbselect.where[id].op
						+ " "
						+ local_webdw.table.retrieve.pbselect.where[id].exp2
						+ ") "
						+ local_webdw.table.retrieve.pbselect.where[id].logic;
			} else {
				select_where = select_where + " And " + "("
						+ local_webdw.table.retrieve.pbselect.where[id].exp1
						+ " "
						+ local_webdw.table.retrieve.pbselect.where[id].op
						+ " "
						+ local_webdw.table.retrieve.pbselect.where[id].exp2
						+ ") "
						+ local_webdw.table.retrieve.pbselect.where[id].logic;
			}
		}

		if (!select_where==("")) {
			select_where = " Where " + select_where;
		}
//	    '增加对order by 子句的支持，20090204
//	    select_orderby = ""
//	    For id = 1 To 10
//	        If local_webdw.table.retrieve.pbselect.order(id).Name = "" Then
//	            Exit For
//	        End If
//	        
//	        If select_orderby = "" Then
//	            If UCase(this.local_webdw.table.retrieve.pbselect.order(id).Asc) = "YES" Then
//	                select_orderby = local_webdw.table.retrieve.pbselect.order(id).Name & " ASC "
//	            Else
//	                select_orderby = local_webdw.table.retrieve.pbselect.order(id).Name & " DESC "
//	            End If
//	        Else
//	            If UCase(this.local_webdw.table.retrieve.pbselect.order(id).Asc) = "YES" Then
//	                select_orderby = select_orderby & " , " _
//	                            & local_webdw.table.retrieve.pbselect.order(id).Name & " ASC "
//	            Else
//	                select_orderby = select_orderby & " , " _
//	                            & local_webdw.table.retrieve.pbselect.order(id).Name & " DESC "
//	            End If
//	        End If
//	    Next

	    //'增加对order by 子句的支持，20090204
	    select_orderby = "";
	    for( id = 1;id<=10;id++){
	        if( local_webdw.table.retrieve.pbselect.order[id].Name==("")) {
	            break;
	        }
	        
	        if( select_orderby==("")){
	            if( UCase(this.local_webdw.table.retrieve.pbselect.order[id].Asc)==("YES")) {
	                select_orderby = local_webdw.table.retrieve.pbselect.order[id].Name + " ASC ";
	            }else{
	                select_orderby = local_webdw.table.retrieve.pbselect.order[id].Name + " DESC ";
	            }
	        }else{
	            if( UCase(this.local_webdw.table.retrieve.pbselect.order[id].Asc)==("YES")){
	                select_orderby = select_orderby + " , " 
	                            + local_webdw.table.retrieve.pbselect.order[id].Name + " ASC ";
	            }else{
	                select_orderby = select_orderby + " , " 
	                            + local_webdw.table.retrieve.pbselect.order[id].Name + " DESC ";
	            }
	        }
	    }
//	    If select_orderby > "" Then
//      select_orderby = " Order By " & select_orderby
//  End If

	    if( select_orderby.length>0){
	    	select_orderby = " Order By " + select_orderby;
	    }
	    
		var SQL = "Select " + select_columnlist + " from "
				+ select_tablelist + select_where+ select_orderby;
		console.log("SQL-351:"+SQL);
		SQL = Replace(SQL, "~\"", "");
		console.log("SQL-353:"+SQL);
		return SQL;
	}

}

//Rem WebDW的字符串生成功能
//Rem 输入local_webdw,利用这个结构生成一个符合规范要求的字符串
//Rem 这个类对外只提供一个公共方法getsyntaxstring，用一个字符串填充local_webdw
//Rem 输入：local_webdw
//Rem 输出：字符串,errString,iret
//Rem iret代表执行的状态标志，0正常 -1失败
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @版权所有 刘峻松 2008-2009
//Rem E_mail : liujunsong@aliyun.com
//Rem -------------------------------------------------

class CWebDW_GetSyntaxString{
	//constructor function
	constructor(){
		this.ReadMe="WebDW的字符串生成功能";
		this.errString = "";// As String '执行产生的错误信息
		this.local_webdw=new WebDWSyntax();// As WebDWSyntax
		this.Golbal = golbal; //设置全局变量
	}


	// 'local_webdw现在是一个局部变量了，而不是全局变量了

	// '功能描述：设置local_webdw的值
	// '输入：glocal_webdw
	// '输出：local_webdw
	SetLocalWebDW() {
		local_webdw = Golbal.GG_webdw.Clone();
	}

	// '功能描述：读取local_webdw的值
	// '输入:local_webdw
	// '输出:glocal_webdw
	GetLocalWebDW() {
		Golbal.GG_webdw = local_webdw.Clone();
	}

	// '得到DataWindow部分表示的字符串
	getDW01_DataWindow( iret) {
		var sret = "";// As String
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
	getDW02_Header( iret) {
		var sret = "";// As String

		iret.intvalue = 0;
		sret = "header(" + "height=" + local_webdw.header.height + " "
				+ "color=" + "\"" + local_webdw.header.color + "\"" + " ) "
				+ Chr(13) + Chr(10);
		return sret;
	}

	// '得到Summary部分的字符串表示
	getDW03_Summary( iret) {
		var sret = "";// As String

		iret.intvalue = 0;
		sret = "summary(" + "height=" + local_webdw.summary.height + " "
				+ "color=" + "\"" + local_webdw.summary.color + "\"" + " ) "
				+ Chr(13) + Chr(10);
		return sret;
	}
//	'得到footer
	getDW04_Footer( iret){
	    var sret="";// As String
	        
	    iret.intvalue = 0;
	    sret = "footer(" 
	            + "height=" + local_webdw.footer.height + " " 
	            + "color=" + "\"" + local_webdw.footer.color + "\"" + " ) " + Chr(13) + Chr(10);
	     return sret;
	}
//	'得到detail
	getDW05_Detail( iret ){
	    var sret="";// As String
	    iret.intvalue = 0;
	    sret = "detail(" 
	            + "height=" + local_webdw.detail.height + " " 
	            + "color=" + "\"" + local_webdw.detail.color + "\"" + " ) " + Chr(13) + Chr(10);
	     return sret;
	}

	
//	'功能描述：将local_webdw转换成一个指定格式的字符串
//	'以后要修改生成的字符串，只需要修改local_webdw的数据就可以了
	GetSyntaxString( iret ){
		//暂时不进行实现,定义数据窗口的功能暂时不迁移到Java上
		return "";
	}

	
}

//Rem -------------------------------------------------
//Rem WebDW的数据窗口自动生成器
//Rem 这个类的设计目的是给出一个Select语句，自动填充local_webdw的数值
//Rem 这里面没有和后台数据库的交互，所需要的数据事先先提供过来
//Rem 根据生成的数据窗口的类型不同，分为多个不同的方法来实现
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @版权所有 刘峻松 2008-2009
//Rem E_mail : liujunsong@aliyun.com
//Rem -------------------------------------------------

class CWebDW_SyntaxFromSQL {
	// constructor function
	constructor(){
		this.ReadMe = "WebDW的数据窗口自动生成器";
		
		// '公用变量定义
		this.errString="";// As String '错误信息存储字符串，输出字符串

		// 'colDefString字符串的数据从外部直接传入
		this.colDefString="";// As String '数据列存储字符串，格式为：第一行列列表，其他行：列的定义信息

		this.columnlist=""; // As String 'select语句的列列表
		this.tablelist=""; // As String 'select语句的table列表
		this.joinlist=""; // As String 'select语句的连接语句
		this.wherelist=""; // As String 'select语句的where条件字句

		this.color_white = 16777215;

		this.local_webdw =null;// 'local_webdw现在是一个局部变量了，而不是全局变量了
		
	}


//'功能描述：设置local_webdw的值
//'输入：glocal_webdw
//'输出：local_webdw
	SetLocalWebDW(){
	    local_webdw = Golbal.GG_webdw.Clone();
	}

//'功能描述：读取local_webdw的值
//'输入:local_webdw
//'输出:glocal_webdw
	GetLocalWebDW(){
	   Golbal.GG_webdw = local_webdw.Clone();
	}

//'根据给定的SQL语句，以及对应的数据窗口类型
//'设置到local_webdw中去
//'从而再转换，得到一个对应的数据窗口对象出来。
//'iret返回值，0 正常 -1 失败
//'错误信息存放在errstring中
//'这个方法是一个Select语句的小型解析器
	SyntaxFromSQL( strsql , stype , iret){
		iret.intvalue = -1;
		errString ="SyntaxFromSQL方法尚未移植完成!";
		return "";
	}
}

//Rem CWebDW是一个没有具体实现过程的中转类
//Rem 它的设计目的是屏蔽对于CWebDWUI_FromString和CWebDWUI_ToString的访问
//Rem 所有的访问针对CWebDW来进行就可以
//Rem CWebDW对应的数据结构是WebDWSyntax
//Rem CWebDW操作的数据源是GG_WebDW

class CWebDW{
	//constructor function
	constructor(){
		this.ReadMe = "CWebDW是一个没有具体实现过程的中转类";
		
		this.dwString = "";// As String '这个变量存储要解析的字符串,未来可用来比较,只读

		this.errString = "";// As String '解析失败以后的错误信息存储在这里

		// '----------本地对象类封装开始---------
		this.reader = new CWebDW_Create();// '定义一个读取功能类

		this.writer = new CWebDW_GetSyntaxString();// '定义一个输出字符串类

		this.sqlGener = new CWebDW_GetRetrieveSQL();// '定义一个得到数据窗口输出Select的类

		this.synGener = new CWebDW_SyntaxFromSQL();// '定义一个从select变成语法的类

		// '----------本地对象类封装结束---------

		this.local_webdw = new WebDWSyntax();// 'local_webdw现在是一个局部变量了，而不是全局变量了
	
		this.Golbal = golbal;
	}


	// '功能描述：设置g_webdw的值
	// '输入：gg_webdw
	// '输出：local_webdw
	SetLocalWebDW() {
		this.local_webdw = this.Golbal.GG_webdw.Clone();
	}

	// '功能描述：读取local_webdw的值
	// '输入:local_webdw
	// '输出:gg_webdw
	GetLocalWebDW() {
		this.Golbal.GG_webdw =this.local_webdw.Clone();
	}

	// '这个是一个主要的对外公开的解析方法
	// '输入一个字符串,把它解析成一个webdw结构的数据
	// '并存储在g_webdw中
	// '字符串存储在dwString中备用
	// '返回0代表成功
	// '如果解析失败,返回-1代表有错误(一般不会)
	// '不存储字符串,也不存储webdw
	// '错误信息存储在errString中
	Create( inString) {
		var iret = 0;// As Long
		iret =this.reader.Create(inString);

		this.dwString = inString;

		// '更新本地的local_webdw数据,从reader中读取
		this.reader.GetLocalWebDW();
		this.SetLocalWebDW();

		if (iret == -1) {
			this.errString =this.reader.errString;
		}
		return iret;
	}

	// '在读入g_webdw以后，得到表示所有列名称的字符串表示
	// '各列之间用chr(9)分割，顺序按照column定义的顺序
	// '这个数据用来初始化webdwdata的数据集合
	// '操作前提是local_webdw已经有数据了
	GetColumnDefineString() {
		var strcol = "";// As String
		var colid = 0;// As Long
		strcol = "";
		for (colid = 1; colid <= 100; colid++) {// 'g_webdw定义中最多100个列，此处不可读取column，必须读取table.column
			if (this.local_webdw.table.Columns[colid].Name==("")) {
				break;
			}

			if (strcol==("")) {
				strcol = strcol +this.local_webdw.table.Columns[colid].Name;
			} else {
				strcol = strcol + Chr(9)
						+this.local_webdw.table.Columns[colid].Name;
			}
		}

		return strcol; // '返回字符串
	}

	// '功能描述：将local_webdw转换成一个指定格式的字符串
	// '以后要修改生成的字符串，只需要修改g_webdw的数据就可以了
	// '这一方法对应于PB的describe("dw_1.syntax")
	GetSyntaxString(iret) {
		GetLocalWebDW();
		writer.SetLocalWebDW();
		var s1 = "";
		s1 = writer.GetSyntaxString(iret);
		if (iret.intvalue == -1) {
			errString = writer.errString;
		}
		return s1;
	}

	// '功能描述：从DW定义中，分解得到数据库检索用的Select语句
	// '为下一步执行SQL操作打下基础
	// '这个SQL语句可能会带有参数
	GetRetrieveSQL() {
		this.GetLocalWebDW();
		this.sqlGener.SetLocalWebDW();
		return this.sqlGener.GetRetrieveSQL();
	}

	// '根据给定的SQL语句，以及对应的数据窗口类型
	// '设置到g_webdw中去
	// '从而再转换，得到一个对应的数据窗口对象出来。
	// 'iret返回值，0 正常 -1 失败
	// '错误信息存放在errstring中
	// '这个方法是一个Select语句的小型解析器
	SyntaxFromSQL( strsql, stype, iret) {

		var s1 = "";
		s1 = synGener.SyntaxFromSQL(strsql, stype, iret);
		if (iret.intvalue == -1) {
			errString = synGener.errString;
		}
		synGener.GetLocalWebDW();
		SetLocalWebDW();
		return s1;
	}

//	'设置ColumnDefineString
	SetColumnDefineString( colDefString ){
	    synGener.colDefString = colDefString;
	    return 0;
	}
	
//	'根据给定的columnname，计算返回的列编号(1 based)
//	'访问local_webdw来计算得到
	GetColumnIdByColumnName( colname){
	    var colid =0;
	    for(colid = 1;colid<=100;colid++){
	        if( UCase(colname)==(UCase(this.local_webdw.table.Columns[colid].Name))){
	            return colid;
	        }
	    }
	    return -1;
	}

//	'得到界面的最大宽度，用这个宽度来设置横向滚动条的位置等信息
	getMaxWidth() {
	    var i = 0;//As Long
	    var imax = 0;// As Long
	    imax = 0;
	    //'循环读取label的最大宽度
	    for( i = 1 ;i<= 100;i++){
	        if(this.local_webdw.text[i].Name==("")){
	            break;
	        }
	        
	        if(this.local_webdw.text[i].x +this.local_webdw.text[i].width > imax){
	            imax =this.local_webdw.text[i].x +this.local_webdw.text[i].width;
	        }
	    }
	    
	    //'循环读取text的最大宽度
	    for( i = 1 ;i<= 100;i++){
	        if(this.local_webdw.column[i].Name==("")){
	            break;
	        }
	        
	        if(this.local_webdw.column[i].x +this.local_webdw.column[i].width > imax){
	            imax =this.local_webdw.column[i].x +this.local_webdw.column[i].width;
	        }
	    }
	    
	    //'循环读取line的最大右坐标
	    for( i = 1 ;i<= 100;i++){
	        if(this.local_webdw.lineinfo[i].Name==("")){
	            break;
	        }
	        
	        if(this.local_webdw.lineinfo[i].x1 > imax){
	        	imax =this.local_webdw.lineinfo[i].x1;
	        }
	        if(this.local_webdw.lineinfo[i].x2 > imax){
	        	imax =this.local_webdw.lineinfo[i].x2;
	        }
	    }
	    
	    return imax;
	}




}

/*
Rem -------------------------------------------------
Rem WebDW控件对应的数据存储及访问类所使用的数据存储缓存类
Rem 这个类是专门用来定义不同的数据缓存区
Rem 一个DataWindow有如下缓存区:
Rem Primary! = 1 主缓存区，这个缓存区是界面显示用的缓存区
Rem Filter! = 2  过滤缓存区，这个缓存区存放过滤出去的数据
Rem Delete! = 3  删除数据缓存区，所有删除的数据先放到这个缓存区里面
Rem 这样可以明确代码的功能划分，避免代码混乱
Rem @CopyRight Mr.Liu Junsong 2008-2009
Rem @版权所有 刘峻松 2008-2009
Rem E_mail : liujunsong@yahoo.com.cn
Rem -------------------------------------------------
*/
class CWebDWData_DataBuffer{
	//constructor function
	constructor(){
		this.ReadMe="WebDW控件对应的数据存储及访问类所使用的数据存储缓存类";
		this.BufferType; // '缓存区的类型，1. Primary 2. Filter 3.Delete

		this.Columns = new Array(); // '列名的集合，来自返回数据，而不是DW定义

		this.DataArray=new Array();; // '所有数据用字符串类型来存储

		this.errString=""; // '如果调用失败，输出的错误信息。

		this.RowNumber=0; // '数据的总行数

		this.ColNumber=0; // '列的总数

		this.ColLength=0; // '每一行的存储长度	
		this.Init();
	}
	// '功能描述：从当前的数据集合中删除一行记录
	// '后续记录向前移动一条记录
	// '返回0 删除成功
	// '返回-1 删除失败
	DeleteRow(delRowId) {
		// '判断delrowid的合法性
		if (delRowId <= 0 || delRowId > RowNumber) {
			errString = "invalid delete row:" + delRowId;
			return -1;
		}

		var colid = 0; // '行号
		var rowid = 0; // '列号

		for (rowid = delRowId; rowid <= RowNumber - 1; rowid++) {
			for (colid = 1; colid <= ColLength; colid++)
				// '等于下一行的数据,包括移动状态
				DataArray[(rowid - 1) * ColLength + colid] = DataArray[rowid
						* ColLength + colid];
		}

		rowid = RowNumber;
		for (colid = 1; colid <= ColLength; colid++) {// '最后一行的数据清空,包括其状态
			DataArray[(rowid - 1) * ColLength + colid] = "";
		}

		RowNumber = RowNumber - 1; // '总行数减1
		return 0;
	}

	// '生成Insert命令的方法
	// '暂时只考虑单表的维护问题
	// '多表的操作方式待定
	GenerateInsertSQL( stablename,  rowid,  iret) {
		if (BufferType != 1) {
			iret.intvalue = -1;
			errString = "Wrong Buffer Type for Insert:" + BufferType;
			return "";
		}

		if (stablename==("")) {
			iret.intvalue = -1;
			errString = "Empty tableName";
			return "";

		}

		var state;
		state = GetRowState(rowid, iret);

		var scollist = "";
		var strsql = "";
		var colid = 0;

		if (iret.intvalue == -1) { // '获取行状态发生错误
			return "";
		}

		if (! state==("new")) { // '不是新建状态
			iret.intvalue = -1;
			errString = "Wrong Row State for Insert:" + state;
			return "";
		} else { // '是新建状态
			scollist = GetColumnList();
			if (scollist==("")) {
				iret.intvalue = -1;
				errString = "Empty Column List";
				return "";
			}
			strsql = "Insert Into " + stablename + "(" + scollist + ") Values(";

			for (colid = 1; colid <= this.ColNumber; colid++) {
				if (colid < this.ColNumber) {
					strsql = strsql + "'" + GetItemString(rowid, colid, iret)
							+ "',";
				} else {
					strsql = strsql + "'" + GetItemString(rowid, colid, iret)
							+ "')";
				}

				if (iret.intvalue == -1) { // '错误判断
					return "";
				}
			}
		}
		return strsql;

	}

	// '得到指定行的状态数据
	// '从DataArray中读取，对应行的colnumber + 1的变量就代表其状态
	GetRowState( row, iret) {
		// '判断行的准确性
		if (row < 1 || row > this.RowNumber) {
			iret.intvalue = -1;
			this.errString = "Invalid row:" + row;
			return "";
		}

		iret.intvalue = 0;
		return this.DataArray[row * this.ColLength];// '如果每行5列，第11个数据就代表其状态
	}

	// '得到列的列表,按照id排列,各字段之间用逗号分割
	GetColumnList() {
		var colid = 0;
		var slist = "";
		slist = "";
		for (colid = 0; colid <= this.ColNumber - 1; colid++) {
			if (colid < this.ColNumber - 1) {
				slist = slist + this.Columns[colid] + " , ";
			} else {
				slist = slist + this.Columns[colid];
			}
		}

		return slist;
	}

	// '得到指定行列的数据
	// 'row 行号
	// 'col 列号
	// 'iret 返回值
	GetItemString( row, col, iret) {
		// '判断行的准确性
		if (row < 1 || row > this.RowNumber) {
			iret.intvalue = -1;
			errString = "Invalid row:" + row;
			return "";
		}
		// '判断列的准确性
		if (col < 1 || col > this.ColNumber) {
			iret.intvalue = -1;
			errString = "Invalid col:" + col;
			return "";
		}

		// '返回结果数据,GetItemString只能返回当前值，要得到原始值需要调用其它方法
		iret.intvalue = 0;
		return this.DataArray[(row - 1) * this.ColLength + col];

	}

	// '将某一行表示成一个标准的字符串，各列之间用chr(9)分割
	// '如果行号非法，返回空字符串
	GetRowString(rowid) {
		if (rowid <= 0 || rowid > RowNumber) {
			errString = "Invalid row:" + rowid;
			return "";
		}

		var colid = 0;// '列号
		var sret;// '返回字符串
		sret = "";
		for (colid = 1; colid <= this.ColNumber; colid++) {
			if (colid < this.ColNumber) {
				sret = sret + DataArray[(rowid - 1) * ColLength + colid]
						+ Chr(9);
			} else {
				sret = sret + DataArray[(rowid - 1) * ColLength + colid];
			}
		}

		// '返回字符串
		return sret;
	}

	// '将所有的数据都组合成一个字符串返回
	 GetAllData() {
		var sret = "";
		var rowid = 0;

		sret = "";
		for (rowid = 1; rowid <= RowNumber; rowid++) {
			if (sret==("")) {
				sret = GetRowString(rowid);
			} else {
				sret = sret + Chr(13) + Chr(10) + GetRowString(rowid);
			}
		}
		return sret;

	}

	// '得到所有行的更新SQL语句组合
	 GetAllUpdateSQL(stablename, iret) {
		var rowid = 0;
		var strsql = "";
		var sql1 = "";

		strsql = "";
		for (rowid = 1; rowid <= RowNumber; rowid++) {
			sql1 = GetUpdateSql(stablename, rowid, iret);
			if (iret.intvalue == -1) {
				return "";
			}

			if (!sql1==("")) {
				if (strsql==("")) {
					strsql = sql1;
				} else {
					strsql = strsql + Chr(13) + Chr(10) + sql1;
				}
			}
		}

		return strsql;
	}

	// '根据名字来检索列名，返回-1代表没找到
	// '返回的列序号从1开始，关于行序号和列序号的问题，需要重新规划，统一定义
	// '现在代码有点混乱
	GetColIdByName(colname) {
		var colid = 0;
		for (colid = 0; colid <= this.ColNumber - 1; colid++) {
			if (UCase(Columns[colid])==(UCase(colname))) {
				return colid + 1;
			}
		}
		return -1;
	}

	// '根据列的序号，得到列的名称
	 GetColumnName(colid) {
		if (colid <= this.ColNumber && colid >= 0) {
			return this.Columns[colid - 1];
		} else {
			return "";
		}
	}

	// '得到column()的字符串表示,这一功能用来输出并初始化其它dw
	 GetColumnString() {
		var sret = "";
		var colid = 0;
		for (colid = 1; colid <= this.ColNumber; colid++) {
			if (colid < this.ColNumber) {
				sret = sret + this.Columns[colid - 1] + Chr(9);
			} else {
				sret = sret + this.Columns[colid - 1];
			}
		}
		return sret;

	}

	// '得到最初的指定行列的数据
	// 'row 行号
	// 'col 列号
	// 'iret 返回值
	 GetOriginalItemString( row, col, iret) {
		// '判断行的准确性
		if (row < 1 || row > RowNumber) {
			iret.intvalue = -1;
			errString = "Invalid row:" + row;
			return "";
		}

		// '判断列的准确性
		if (col < 1 || col > this.ColNumber) {
			iret.intvalue = -1;
			errString = "Invalid col:" + col;
			return "";
		}

		// '返回结果数据,GetOriginalItemString只能返回原始值
		iret.intvalue = 0;
		return DataArray[(row - 1) * ColLength + this.ColNumber + col];

	}

	// '将某一行的原始数据表示成一个标准的字符串，各列之间用chr(9)分割
	// '如果行号非法，返回空字符串
	 GetOriginalRowString(rowid) {
		if (rowid < 1 || rowid > RowNumber) {
			errString = "Invalid row:" + rowid;
			return "";
		}

		var colid = 0;// '列号
		var sret = "";// '返回字符串
		sret = "";
		for (colid = 1; colid <= this.ColNumber; colid++) {
			if (colid < this.ColNumber) {
				sret = sret
						+ DataArray[(rowid - 1) * ColLength + this.ColNumber + colid]
						+ Chr(9);
			} else {
				sret = sret
						+ DataArray[(rowid - 1) * ColLength + this.ColNumber + colid];
			}
		}

		// '返回字符串
		return sret;
	}

	// '根据rowid,生成更新和删除时所需要的Where字句
	 GetSetClause(rowid, iret) {
		var strSet = "";
		var colid = 0;
		var sData = "";

		strSet = " Set ";
		for (colid = 0; colid <= this.ColNumber - 1; colid++) {
			sData = GetItemString(rowid, colid + 1, iret);
			if (iret.intvalue == -1) {
				return "";
			}

			if (colid == 0) {
				strSet = strSet + this.Columns[colid] + " = " + "'" + sData + "' ";
			} else {
				strSet = strSet + " , " + this.Columns[colid] + " = " + "'" + sData
						+ "' ";
			}
		}

		return strSet;
	}

	// '得到指定一行的Update SQL语句
	// '如果是 new,返回一个Insert语句(仅在primarybuffer中)
	// '如果是 modify,返回一个Update语句(仅在primarybuffer中)
	// '如果是 modify,normal ,返回一个Delete语句(仅在deleteBuffer中)
	// 'sTableName 要更新的数据表名称
	// 'rowid 要更新的行号
	// 'iret 返回标志位 0 正常 -1 发生错误
	 GetUpdateSql(stablename,rowid, iret) {
		var state = "";
		var strSet = "";
		var strWhere = "";

		// 'part1 primarybuffer的处理,根据状态生成Update和Insert
		if (BufferType == 1) {
			state = GetRowState(rowid, iret);
			if (iret.intvalue == -1) {
				return "";
			}

			// '插入语句的生成
			if (state==("new")) {
				var Sql = GenerateInsertSQL(stablename, rowid, iret);
				if (iret.intvalue == -1) {
					return "";
				}
				return Sql;
			}

			// '更新语句的生成
			if (state==("modify")) {
				strSet = GetSetClause(rowid, iret);
				if (iret.intvalue == -1) {
					return "";
				}

				strWhere = GetWhereClause(rowid, iret);
				if (iret.intvalue == -1) {
					return "";
				}

				return "Update " + stablename + strSet + strWhere;
			}

			return ""; // '其他状态下不生成SQL语句,直接返回

		}

		// 'part2 filterBuffer的处理 //'目前暂不处理
		if (BufferType == 2) {
			iret.intvalue = 0;
			return ""; // '目前暂不处理
		}

		// 'part3 deleteBuffer的处理
		if (BufferType == 3) {
			state = GetRowState(rowid, iret);// '如果当前状态是new,不处理
			if (!state==("new")) {

				strWhere = GetWhereClause(rowid, iret);
				if (iret.intvalue == -1) {
					return "";
				}

				return " Delete " + stablename + strWhere;
			}
		}

		return "";

	}

	// '根据rowid,生成更新和删除时所需要的Where字句
	 GetWhereClause(rowid, iret) {
		var strWhere = "";
		var colid = 0;
		var sData = "";
		var colwhere = "";

		strWhere = "";
		for (colid = 0; colid <= this.ColNumber - 1; colid++) {
			sData = GetOriginalItemString(rowid, colid + 1, iret);
			if (iret.intvalue == -1) {
				return "";
			}

			if (sData==("")) {// '空字符串做空值处理
				colwhere = this.Columns[colid] + " is null ";
			} else {
				colwhere = this.Columns[colid] + " = '" + sData + "'";
			}

			if (strWhere==("")) {
				strWhere = colwhere;
			} else {
				strWhere = strWhere + " AND " + colwhere;
			}

		}
		if (!strWhere==("")) {
			return "Where " + strWhere;
		} else {
			return "";
		}
	}

	// '类成员初始化
	Init() {
		this.Columns = new Array(1);//String[1];
		this.DataArray = new Array(1001);//String[1001];
		this.errString = "";
		this.RowNumber = 0;
		this.ColNumber = 0;
		this.ColLength = 0;
		return 0;
	}

	InitData(sindata) {
		return InitData(sindata, "normal");
	}

	// '功能描述：从输入的字符串中读取数据，填充columnArray和lineArray
	// '第一行是列的名称描述，其余行是对应的数据
	// '这里不处理Null值，数据库上的null值被转换为空字符串
	//
	// '返回0 成功
	// '返回-1 失败，错误信息保存在errString中
	// 'sindata 输入数据，字符串表示
	// 'state 数据状态，默认为"normal"
	InitData(sindata,state) {
		this.Init(); // '调用类初始化的方法
		
		var sDataArray=new Array(); // '原始数据按行分解得到的数组
		var vline; // '原始数据每一行
		var sline = ""; // '转换成字符串的原始数据每一行

		var sdarray=new Array();// '中间变量，每一行分解成数据列的数组

		var lineId;// '原始数据的行号，0代表标题，其余代表数据
		var colid; // '列的序号

		this.DataArray = new Array(1); // '先清空原始数据

		sDataArray = Split(sindata, "" + Chr(13) + Chr(10));// '利用回车符号进行分解
		
		lineId = 0; // '原始数据的行号
		for (var i = 0; i < sDataArray.length; i++) {
			sline = sDataArray[i];// '读出一行,转成字符串
			console.log("sline = "+sline);
			if (sline==("") || sline=="OK") {// '遇到空行，退出
				break;
			}

			if (lineId == 0) {
				this.Columns = Split(sline, Chr(9)); // '按chr(9)来分解成列,存到columns里面
				this.ColNumber = UBound(this.Columns) + 1; // '列的数量,split返回的数组是zero-based.
				this.ColLength = this.ColNumber * 2 + 1; // '每一行的长度，等于colnumber*2加1
			} else {
				if (Trim(sline)==("")) { // '遇到空行，退出循环
					break;
				}

				sdarray = Split(sline, Chr(9)); // '按chr(9)来分解列,分解成多个数据列
				console.log("a1"+UBound(sdarray));
				console.log("a2"+UBound(this.Columns));
				
				if (UBound(sdarray) != UBound(this.Columns)) { // '检查数据列是否足够，数据不足则报错误
					if (UBound(sdarray)==0){
						continue;
					}
					this.errString = "CWebDWData.ReadDataq数据格式错误:数据列数量不足!行:"
							+ lineId;
					console.log(this.errString);
					return -1;
				}

				this.RowNumber = lineId; // '存储当前行数

				if (UBound(this.DataArray) < this.RowNumber * this.ColLength) {
					// ReDim Preserve DataArray(UBound(DataArray) + 1000) //
					// '一次分配1000个空间，避免多次分配
					var temp = new Array(this.DataArray.length + 1000);
					var j=1;
					for ( j = 1; j < this.DataArray.length; j++) {
						temp[j] = this.DataArray[j];
					}
					for ( j = this.DataArray.length; j < this.DataArray.length + 1000; j++) {
						temp[j] = "";
					}
					this.DataArray = temp;
				}

				for (colid = 1; colid <= this.ColNumber; colid++) {
					// '对null值的特殊处理:将后台返回的NULL变成一个空字符串
					if (UCase(sdarray[colid - 1])==("NULL")) {
						sdarray[colid - 1] = "";
					}
					this.DataArray[(lineId - 1) * this.ColLength + colid] = sdarray[colid - 1]; // '列的数据存储
					this.DataArray[(lineId - 1) * this.ColLength + this.ColNumber + colid] = sdarray[colid - 1]; // '再存储一份作为备份
				}
				this.DataArray[lineId * this.ColLength] = state; // 'initData的数据是正常状态
			}
			lineId = lineId + 1;
		}
		return 0;
	}

	// '功能描述：在DataArray中插入一行记录，这行记录用字符串来表示
	// 'rowid:要插入的当前行号，插入以后，这一行数据将代表当前行，如果rowid=0，在最后追加
	// 'sline:用字符串表示的一行记录
	// '返回值：>0 代表插入以后的行号，-1代表失败，错误信息在errString中
	InsertRow( insertid,sline) {
		var data=new Array();
		var colid = 0;
		var rowid = 0;

		if (insertid < 0 || insertid > RowNumber) {
			errString = "Invalid rowid:" + insertid;
			return -1;
		}

		data = Split(sline, Chr(9));

		if (UBound(data) != this.ColNumber - 1) {
			errString = "插入列数据列和要求不符合:" + sline;
			return -1;
		}

		// '判断是否需要扩展存储区域
		if (UBound(DataArray) < (RowNumber + 1) * ColLength) {
			// ReDim Preserve DataArray(UBound(DataArray) + 1000) //
			// '一次分配1000个空间，避免多次分配
			var temp = new Array(DataArray.length + 1000);
			for ( j = 1; j < DataArray.length; j++) {
				temp[j] = DataArray[j];
			}
			for ( j = DataArray.length; j < DataArray.length + 1000; j++) {
				temp[j] = "";
			}
			DataArray = temp;
		}

		RowNumber = RowNumber + 1;

		if (insertid > 0) {
			// '先移动现有数据,向后移动一行,包括其状态
			for (rowid = RowNumber - 1; rowid >= insertid + 1; rowid = rowid - 1) {
				for (colid = 1; colid <= ColLength; colid++) {
					DataArray[rowid * ColLength + colid] = DataArray[(rowid - 1)
							* ColLength + colid];
				}
			}
			rowid = insertid;
		} else {
			rowid = RowNumber;
		}

		for (colid = 1; colid <= this.ColNumber; colid++) {
			DataArray[(rowid - 1) * ColLength + colid] = "";// '初始化
		}

		// '复制插入这一行的数据
		for (colid = 1; colid <= this.ColNumber; colid++) {
			DataArray[(rowid - 1) * ColLength + colid] = data[colid - 1];
		}
		DataArray[rowid * ColLength] = "new";// '默认情况下，设置为new,在外面可能会修改这个值
		return rowid;

	}

	// '功能描述：清空所有的数据，保留列信息
	ResetData() {
		DataArray = new String[1000];
		RowNumber = 0;
		return 0;
	}

	// '设置指定行列的数据,返回值无用
	 SetItemString( row, col,sData, iret) {
		// '判断行的准确性
		if (row < 1 || row > RowNumber) {
			iret.intvalue = -1;
			errString = "Invalid row:" + row;
			return "";
		}

		// '判断列的准确性
		if (col < 1 || col > this.ColNumber) {
			iret.intvalue = -1;
			errString = "Invalid col:" + col;
			return "";
		}

		iret.intvalue = 0;
		DataArray[(row - 1) * ColLength + col] = sData;// '只能设置当前值，历史数据无法设置

		if (DataArray[row * ColLength]==("normal")) {// '只有当当前状态为normal时，修改为更新
			DataArray[row * ColLength] = "modify";// '这一行状态为更新
		}

		return "";
	}

	// '设置指定行列的原始数据,返回值无用
	 SetOriginalItemString( row, col,sData, iret) {
		// '判断行的准确性
		if (row < 1 || row > RowNumber) {
			iret.intvalue = -1;
			errString = "Invalid row:" + row;
			return "";
		}

		// '判断列的准确性
		if (col < 1 || col > this.ColNumber) {
			iret.intvalue = -1;
			errString = "Invalid col:" + col;
			return "";
		}

		iret.intvalue = 0;
		DataArray[(row - 1) * ColLength + this.ColNumber + col] = sData;// '设置历史数据

		iret.intvalue = 0;
		return "";
	}

	// '设置指定行的状态数据
	 SetRowState( row,state, iret) {
		// '判断行的准确性
		// '判断行的准确性
		if (row < 1 || row > RowNumber) {
			iret.intvalue = -1;
			errString = "Invalid row:" + row;
			return "";
		}

		iret.intvalue = 0;
		DataArray[row * ColLength] = state;
		return "";

	}

	// '行交换的功能
	// '主要用于排序功能
	// '将两行的数据进行交换
	Sort_SwapLine( row1, row2) {
		// '首先判断输入参数的正确性
		// '如果输入参数错误，那么就不进行操作了
		if (!(row1 > 0 && row1 <= RowNumber && row2 > 0 && row2 <= RowNumber)) {
			return -1;
		}

		var colid = 0;// As Long
		var stemp = "";// As String
		for (colid = 1; colid <= ColLength; colid++) {
			var id = ((row1 - 1) * ColLength) + colid;
			stemp = DataArray[id];
			DataArray[((row1 - 1) * ColLength) + colid] = DataArray[(row2 - 1)* ColLength + colid];
			DataArray[((row2 - 1) * ColLength) + colid] = stemp;
		}
		return 0;
	}

	// '根据给定的排序条件定义，比较rowid1,rowid2的内容，
	// '返回rowid1,rowid2中数据较小的那个行数
	// '这一方法假设rowid1,rowid2都是合法的行数
	// '返回-1代表比较失败，发生错误
	Sort_Compare(sorter, row1, row2) {
		if (sorter==("")) {
			errString = "Compare argument is empty";
			return -1;
		}

		var sorts = new Array(1);//String[1];
		var sortid = 0; // As Long
		var sortcolid = 0;// As Long '排序字段序号
		var sortcoltype = "";// As String '排序字段类型A 升序 D 降序,其他字符一律按升序处理
		var coldatatype = "";// As String '列的数据类型定义
		var pos1 = 0;// As Long '#的位置
		var pos2 = 0;// As Long '空格的位置
		var sdata1 = "";// As String
		var sdata2 = "";// As String

		sorts = Split(sorter, ",");// '一个排序条件切分成多个排序条件
		for (sortid = 0; sortid <= UBound(sorts); sortid++) {
			pos1 = InStr(sorts[sortid], "#");
			if (pos1 <= 0) {
				// Sort_Compare = -1
				errString = "Compare argument error";
				return -1;
			}

			pos2 = InStr(pos1, sorts[sortid], " ");// '找到下一个空格的位置
			if (pos2 <= 0) {
				// Sort_Compare = -1
				errString = "Compare argument error";
				return -1;
			}

			if (pos2 == pos1 + 1) {
				// Sort_Compare = -1
				errString = "Compare argument error";
			}

			sortcolid = toInt(Mid(sorts[sortid], pos1 + 1, pos2 - (pos1 + 1)));
			sortcoltype = UCase(Trim(Mid(sorts[sortid], pos2 + 1)));

			if (sortcolid < 1 || sortcolid > this.ColNumber) {
				// Sort_Compare = -1
				errString = "Compare argument error";
				return -1;
			}

			if (sortcoltype==("")) {
				sortcoltype = "A";
			} else if ((!(sortcoltype==("A")) && (!(sortcoltype
					==("D"))))) {
				// Sort_Compare = -1
				errString = "Comapre argument error";
				return -1;
			}

			// '判断sortcolid的数据类型，如果是字符串，直接比较
			// '如果是数值型，转换成数值进行比较
			// '如果不同，那么就可以直接返回退出，否则进行下一轮循环，比较下一个列的大小
			sdata1 = DataArray[(row1 - 1) * ColLength + sortcolid];
			sdata2 = DataArray[(row2 - 1) * ColLength + sortcolid];

			var v1;// As Double
			var v2;// As Double
			if (IsNumeric(sdata1) && IsNumeric(sdata2)) {// Then
				// '如果两个都是数值型的数据，则比较
				v1 = toDouble(sdata1);
				v2 = toDouble(sdata2);
				if (v1 > v2) {
					if (sortcoltype==("A")) {// Then
						// Sort_Compare = row2
						// Exit Function
						return row2;
					} else {
						// Sort_Compare = row1
						// Exit Function
						return row1;
					}
				} else if (v1 < v2) {// Then
					if (sortcoltype==("A")) {// = "A" Then
						// Sort_Compare = row1
						// Exit Function
						return row1;
					} else {
						// Sort_Compare = row2
						// Exit Function
						return row2;
					}// End If
				}
				// '两数相等，继续循环
			} else
			// '不是数值，直接比较
			if (IsGreat(sdata1, sdata2)) {// Then
				if (sortcoltype==("A")) {// = "A" Then
					// Sort_Compare = row2
					// Exit Function
					return row2;
				} else {
					// Sort_Compare = row1
					// Exit Function
					return row1;
				}
			} else if (IsGreat(sdata2, sdata1)) {// Then
				if (sortcoltype==("A")) {// = "A" Then
					// Sort_Compare = row1
					// Exit Function
					return row1;
				} else {
					// Sort_Compare = row2
					// Exit Function
					return row2;
				}// End If
			}// End If
			// '两数相等，继续循环
		}// End If

		return row1;// '两者相等，返回第一行
	}

	// '根据给定的排序条件定义，从beginrow到endrow进行查找，找到最小的一条记录号出来
	// '返回0代表数据错误,属于调用问题
	Sort_GetMinLine(sorter, beginrow, endrow) {
		if (!(beginrow > 0 && beginrow <= RowNumber && endrow > 0
				&& endrow <= RowNumber && beginrow <= endrow)) {
			// Sort_GetMinLine = -1
			// Exit Function
			return -1;
		}// End If

		var rowid = 0;// As Long
		var irow = 0;// As Long

		irow = beginrow;
		for (rowid = beginrow + 1; rowid <= endrow; rowid++) {
			irow =  Sort_Compare(sorter, irow, rowid);
			if (irow == -1) {// Then
				// Sort_GetMinLine = -1
				// Exit Function
				return -1;
			}// End If
		}

		return irow;
	}

	// '根据给定的排序条件进行数据排序
	// 'sorter是输入的排序条件
	// 'sorter的格式为 #1 A , #2 D(暂时不处理按照列名排序的要求)
	// '如果不符合这一格式，则退出
	// '各条件之间按照逗号进行分割，如果没有AD，则默认为A(升序)
	// '数据列如果是数值型，按照数值进行判断比较
	// '数据列如果不是数值型，按照字符串进行判断比较
	// '暂时不支持日期，时间型的排序比较
	Sort(sorter) {
		if (sorter==("")) {
			// Sort = 0
			// Exit Function
			return 0;
		}// End If

		var rowid = 0;// As Long
		var minrowid = 0;// As Long
		for (rowid = 1; rowid <= RowNumber; rowid++) {
			minrowid = Sort_GetMinLine(sorter, rowid, RowNumber);// '得到从当前行开始最小的行号

			if (minrowid == -1) {// Then '查找最小行失败
				// Sort = -1 '排序失败
				// Exit Function
				return -1;
			}// End If

			if (minrowid > rowid) {// Then '非当前行
				Sort_SwapLine(rowid, minrowid);// '交换数据
			}// End If
		}// Next

		return 0;
	}

}

//Rem -------------------------------------------------
//Rem WebDW控件对应的数据存储及访问类
//Rem 这个类是专门用来操作实际数据的
//Rem 数据通过一个固定格式的字符串来进行初始化
//Rem 数据存储在CWebDWData中
//Rem 这样可以明确代码的功能划分，避免代码混乱
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @版权所有 刘峻松 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------
class CWebDWData{
	//constructor function
	constructor(){
		this.ReadMe="WebDW控件对应的数据存储及访问类";
		this.PrimaryBuffer = new CWebDWData_DataBuffer();// '主Buffer定义
		this.FilterBuffer = new CWebDWData_DataBuffer();// '过滤Buffer定义
		this.DeleteBuffer = new CWebDWData_DataBuffer();// '删除Buffer定义

		// '类初始化时，设置三个不同buffer的类型变量
		this.PrimaryBuffer.BufferType = 1; // '1代表主缓存区
		this.FilterBuffer.BufferType = 2; // '2代表过滤缓存区
		this.DeleteBuffer.BufferType = 3; // '3代表删除缓存区
		
		this.errString = "";
		this.data_filter = "";// As String '数据的过滤条件定义
		this.data_sorter = "";// As String '数据的排序条件定义		
	}


	// '在成功调用Update以后进行处理
	// '清空this.DeleteBuffer
	// '将primaryBuffer中的modify的状态改为normal
	AfterUpdate() {

		// '清空this.DeleteBuffer
		this.DeleteBuffer.Init();

		var rowid = 0;
		var iret = new MyInt(0);
		for (rowid = 1; rowid <= this.PrimaryBuffer.RowNumber; rowid++) {
			this.PrimaryBuffer.SetRowState(rowid, "normal", iret);
		}
		return 0;
	}

	// '功能描述：删除一行
	// '具体处理方式是：在primarybuffer中删除一行，后续数据前移
	// '把这一行插入到deletebuffer中去，在最后一行

	DeleteRow(rowid) {
		var sData = "";
		var newrowid;
		var colid;
		var iret = new MyInt(0);

		sData = "";

		if (rowid > 0 && rowid <= this.PrimaryBuffer.RowNumber) {

			// '复制当前数据
			sData = this.PrimaryBuffer.GetRowString(rowid);
			newrowid = this.DeleteBuffer.InsertRow(0, sData);

			// '复制这条数据的原始数据
			for (colid = 1; colid <= this.PrimaryBuffer.ColNumber; colid++) {
				sData = this.PrimaryBuffer.GetOriginalItemString(rowid, colid, iret);
				if (iret.intvalue == -1) {
					return -1;
				}

				this.DeleteBuffer
						.SetOriginalItemString(newrowid, colid, sData, iret);

				if (iret.intvalue == -1) {
					return -1;
				}

				sData = this.PrimaryBuffer.GetRowState(rowid, iret);
				this.DeleteBuffer.SetRowState(newrowid, sData, iret);
			}

			// '删除原buffer的数据
			this.PrimaryBuffer.DeleteRow(rowid);
		}
		return 0;
	}

	// '功能描述：Webdwdata对外提供一个Eval方法，
	// '通过这个方法来简化webdwui_parentdw的转发功能
	// '支持的功能包括GetDataSorter,SetDataSorter,Sort
	Eval( command, iret) {

		var arg1 = "";// As String

		if (command.equals("")) {// Then
			iret.intvalue = 0;
			return "0";// = 0
		}

		// '第一部分，对Sort相关功能的支持,包括GetSort,SetSort,Sort
		if (UCase(Left(command, Len("GetSort"))).equals(UCase("GetSort"))) {// Then
			iret.intvalue = 0;
			return data_sorter;
		}

		if (UCase(Left(command, Len("SetSort"))).equals(UCase("SetSort"))) {// Then
			arg1 = getOneInputArg(command, iret);
			if (iret.intvalue == -1) {
				return "";
			}
			data_sorter = arg1;
			return "";
		}
		if (UCase(Left(command, Len("Sort"))).equals(UCase("Sort"))) {// Then
			var i = 0;
			i = this.PrimaryBuffer.Sort(data_sorter);
			if (i == -1) {// Then
				errString = this.PrimaryBuffer.errString;
			}
			return "";
		}

		// '对于不能支持的命令类型，直接返回失败失败信息
		// UnknownCommand:
		iret.intvalue = -1;
		errString = "Unknown Command: " + command;
		return "";
	}

	// '得到所有的字符串
	GetAllData() {
		return this.PrimaryBuffer.GetAllData();
	}

	// '得到列的序号
	GetColIdByName( colname) {
		return this.PrimaryBuffer.GetColIdByName(colname);
	}

	GetColumnNumber() {
		return GetColumnNumber(1);
	}

	// '得到列的数量
	GetColumnNumber(BufferType) {
		switch (BufferType) {
		case 1:
			return this.PrimaryBuffer.ColNumber;
		case 2:
			return this.FilterBuffer.ColNumber;
		case 3:
			return this.DeleteBuffer.ColNumber;
		default:
			return 0;
		}

	}

	// '得到当前定义的数据过滤条件
	GetDataFilter() {// As String
		return data_filter;
	}// End Function

	GetItemString(row, col) {
		return this.GetItemString2(row, col, 1);
	}

	// '功能描述:得到指定行列的数据
	// 'row:行号
	// 'col:列号
	// 'buffertype: 可选，buffer类型，默认为主缓存区
	GetItemString2(row, col, BufferType) {
		var iret = new MyInt(0);
		var sret = "";

		// '根据不同的buffertype来进行不同对象的调用
		switch (BufferType) {
		case 1:
			return this.PrimaryBuffer.GetItemString(row, col, iret);
		case 2:
			return this.FilterBuffer.GetItemString(row, col, iret);
		case 3:
			return this.DeleteBuffer.GetItemString(row, col, iret);
		}
		return "";
	}

	// '从输入的字符串中，解析最外边的一个括号，得到里面唯一的一个参数
	// '如果这个参数用引号来包含，去掉两边的引号
	// 'iret = 0 解析成功
	// 'iret = -1 解析失败
	getOneInputArg( cmd, iret) {
		var pos1 = 0;// As Long '左括号
		var pos2 = 0;// As Long '右括号
		var stemp = "";// As String '临时变量

		pos1 = InStr(cmd, "(");

		// 'pos2指向最右面的一个右括号
		for (pos2 = Len(cmd); pos2 >= 1; pos2--) {// Step -1
			if (Mid(cmd, pos2, 1).equals(")")) {// Then
				break;
			}
		}

		if (pos1 <= 0 || pos2 <= 0 || pos1 > pos2) {// Then
			iret.intvalue = -1;
			errString = "输入参数解析失败:" + cmd;
			return "";
		}// End If

		stemp = Mid(cmd, pos1 + 1, pos2 - (pos1 + 1));
		stemp = Trim(stemp);

		// '去掉前后的引号
		if (Left(stemp, 1).equals("\"") && Right(stemp, 1).equals("\"")
				&& Len(stemp) > 1) {// Then
			stemp = Mid(stemp, 2, Len(stemp) - 2);
		}// End If

		// getOneInputArg = stemp
		iret.intvalue = 0;
		return stemp;

	}

	// '得到行的数量
	GetRowCount() {
		return this.GetRowCount2(1);

	}

	// '得到行的数量
	GetRowCount2(BufferType) {
		switch (BufferType) {
		case 1:
			return this.PrimaryBuffer.RowNumber;
		case 2:
			return this.FilterBuffer.RowNumber;
		case 3:
			return this.DeleteBuffer.RowNumber;
		default:
			return 0;
		}
	}

	// '得到指定行的状态数据
	// '从DataArray中读取，对应行的colnumber + 1的变量就代表其状态
	GetRowState(row, iret) {
		return this.PrimaryBuffer.GetRowState(row, iret);
	}

	// '根据DataBuffer的当前状态，得到要更新的SQL语句，
	// '此处返回的是多条SQL语句，组合在一个String中
	// '多个SQL语句之间用chr(13)chr(10)来进行分割
	// '最后一行不包括回车符号
	// '从this.PrimaryBuffer和this.DeleteBuffer中检索数据，this.FilterBuffer不涉及
	// 'sTableName 数据表名称
	// 'iret 返回标志位0 正常 -1 失败
	GetUpdateSql( stablename, iret) {

		var sql1 = "";
		var sql2 = "";

		sql1 = this.PrimaryBuffer.GetAllUpdateSQL(stablename, iret);
		if (iret.intvalue == -1) {
			return "";
		}

		sql2 = this.DeleteBuffer.GetAllUpdateSQL(stablename, iret);
		if (iret.intvalue == -1) {
			return "";
		}

		if (!sql1.equals("")) {
			return sql1 + Chr(13) + Chr(10) + sql2;
		} else {
			return sql2;
		}
	}

	InitData( sindata) {
		return this.InitData2(sindata, "normal");
	}

	// '功能描述：从输入的字符串中读取数据，填充columnArray和lineArray
	// '返回0 成功
	// '返回-1 失败，错误信息保存在errString中
	// 'sindata 输入数据
	// 'state 数据状态,可选项，默认为normal
	InitData2( sindata, state) {
		this.PrimaryBuffer.InitData(sindata, state);

		var sColumn; // 'sColumn取sindata第一行,代表列定义
		sColumn = this.PrimaryBuffer.GetColumnString();

		this.FilterBuffer.InitData(sColumn);
		this.DeleteBuffer.InitData(sColumn);
		return 0;

	}

	// '在primarybuffer中插入一行,这一行的标记为new
	InsertRow(rowid, sData) {
		var i = 0;
		i = this.PrimaryBuffer.InsertRow(rowid, sData);
		if (i == -1) {
			errString = this.PrimaryBuffer.errString;
		}
		return i;
	}

	// '功能描述：清空所有的数据，只保留基本的结构
	ResetData() {

		this.PrimaryBuffer.ResetData();
		this.FilterBuffer.ResetData();
		this.DeleteBuffer.ResetData();
		return 0;

	}

	// '设置当前的数据过滤条件
	// '返回0代表设置成功
	SetDataFilter( Filter) {// As Long
		data_filter = Filter;
		return 0;
	}

	SetItemString(row, col, sData) {
		return SetItemString(row, col, sData, 1);
	}

	// '功能描述：设置指定行列的数据
	// 'row: 行号
	// 'col: 列号
	// 'buffertype 可选项，默认为1
	SetItemString(row, col, sData, BufferType) {

		var sret = "";
		var iret = new MyInt(0);

		if (BufferType == 1) {
			sret = this.PrimaryBuffer.SetItemString(row, col, sData, iret);
		}
		if (BufferType == 2) {
			sret = this.FilterBuffer.SetItemString(row, col, sData, iret);
		}

		if (BufferType == 3) {
			sret = this.DeleteBuffer.SetItemString(row, col, sData, iret);
		}
		return sret;

	}
	//'得到column()的字符串表示,这一功能用来输出并初始化其它dw
	GetColumnString() {//As String
	    return this.PrimaryBuffer.GetColumnString();
	    
	}

}
