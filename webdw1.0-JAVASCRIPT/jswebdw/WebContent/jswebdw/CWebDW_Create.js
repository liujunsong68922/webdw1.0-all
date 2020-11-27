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
