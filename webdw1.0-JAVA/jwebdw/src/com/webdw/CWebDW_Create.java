package com.webdw;

import java.util.ArrayList;

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
public class CWebDW_Create extends Golbal {
	public void ReadMe(){
		System.out.println("WebDW的字符串解析功能");
		System.out.println(JWebDWInfo);
	}
	public String email = "liujunsong@yahoo.com.cn";

	public String dwString = ""; // '这个变量存储要解析的字符串,未来可用来比较,只读

	public String errString = ""; // '解析失败以后的错误信息存储在这里

	private WebDWSyntax local_webdw = new WebDWSyntax();// 'g_webdw现在是一个局部变量了，而不是全局变量了

	// '功能描述：设置g_webdw的值
	// '输入：gg_webdw
	// '输出：g_webdw
	public void SetLocalWebDW() {
		local_webdw = Golbal.GG_webdw.Clone();
	}

	// '功能描述：读取g_webdw的值
	// '输入:g_webdw
	// '输出:gg_webdw
	public void GetLocalWebDW() {
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
	public int Create(String inString) {
		int iflag = 0;
		// 'step1 初始化g_webdw

		local_webdw = Golbal.GG_empty_webdw.Clone();
		dwString = inString;
		errString = "";

		// 'step2 读入datawindow部分,如果出错,退出程序
		if (readWebDW01_Datawindow() == -1) {
			return -1;
		}

		// 'step3 读入header部分
		if (readWebDW02_Header() == -1) {
			return -1;
		}

		// 'step4 读入summary部分
		if (readWebDW03_Summary() == -1) {
			return -1;
		}

		// 'step5 读入footer部分
		if (readWebDW04_Footer() == -1) {
			return -1;
		}

		// 'step6 读入detail部分
		if (readWebDW05_Detail() == -1) {
			return -1;
		}

		// 'step7 读入table部分
		if (readWebDW06_Table() == -1) {
			return -1;
		}

		// 'step8 读入text部分
		if (readWebDW07_Text() == -1) {
			return -1;
		}

		// 'step9 读入column部分
		if (readWebDW08_Column() == -1) {
			return -1;
		}

		// 'step10 读入line部分
		if (readWebDW09_Line() == -1) {
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
	private String getElementDesc(String inString, String eleName,
			int beginPos, MyInt findPos) {
		int iBeg;
		int leftPos;
		int iflag;

		int i;
		String s;

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

			if ((s.equals("(") || s.equals(")"))
					&& Mid(inString, i - 1, 1).equals("~")) { // '如果是()，需要判断上个字符是否是~,如果是不操作
				continue;
			}

			if (s.equals("(")) {
				iflag = iflag + 1;
				continue; // '继续进行循环
			}

			if (s.equals(")")) { // '当前值为)时需要判断iflag的值
				if (iflag == 0) { // 'iflag=0，可以结束循环
					String s1 = Mid(inString, leftPos, i - leftPos + 1);
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
	private String removeQuote(String strIn) {
		int ilen;
		ilen = Len(strIn);

		if (strIn.equals("")) {
			return "";
		}
		if (Left(strIn, 1).equals("\"") && Right(strIn, 1).equals("\"")) {
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

	private String getElementProp2(String eleString, String paraName,
			int begPos, String defValue, MyInt retFlag, String sep) {
		int iBeg;
		int iEnd;
		int ipos;
		int i;
		int iflag;
		String s;
		String svalue;

		retFlag.intvalue = -1;
		ipos = InStr(begPos, eleString, paraName + "="); // '找到属性名称的开始点
		if (ipos <= 0) { // '找不到，退出
			return defValue; // '返回默认值
		}

		iBeg = ipos + Len(paraName + "="); // 'iBeg代表值的开始点
		iflag = 0;
		for (i = iBeg; i <= Len(eleString); i++) {
			s = Mid(eleString, i, 1);

			if (s.equals("\"")) { // '如果当前字符串是引号，那么设置标志
				if (iflag == 0) {
					iflag = 1;
				} else {
					iflag = 0;
				}
				continue;
			}

			if (s.equals(sep)) { // '如果s是结束符号，需要根据iFlag来判断
				if (iflag == 0) { // '如果不在字符串内，那么就退出
					svalue = Mid(eleString, iBeg, i - iBeg);
					svalue = removeQuote(svalue); // '去掉开头和结尾的引号
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
	private String getElementProp(String eleString, String paraName,
			int begPos, String defValue, MyInt retFlag) {
		String svalue;
		svalue = getElementProp2(eleString, paraName, begPos, defValue,
				retFlag, " ");
		return svalue;
	}

	// '功能描述：将输入的字符串切分成包含多个实际元素的array对象
	// '只获取其中的指定类型对象
	private ArrayList getAllElement(String inString, String eletype) {
		ArrayList myarray = new ArrayList();
		String stext = "";
		MyInt ipos = new MyInt(0);

		// '分解dwString，将其中的元素取出，描述放入myarray中去

		stext = getElementDesc(inString, eletype + "(", 1, ipos);
		while (ipos.intvalue > 0) {
			myarray.add(stext); // '容器内加入sText
			stext = getElementDesc(inString, eletype + "(", ipos.intvalue + 1,
					ipos);
		}

		return myarray;
	}

	// '读入datawindow部分的属性
	// '返回0代表成功
	// '返回-1代表失败
	private int readWebDW01_Datawindow() {
		String sDataWindow;
		MyInt ipos = new MyInt(0);
		MyInt iflag = new MyInt(0);

		// '得到datawindow的表示
		sDataWindow = getElementDesc(dwString, "datawindow", 1, ipos);

		// '如果不存在datawindow定义,视为错误数据,停止执行
		if (ipos.intvalue < 0) {
			errString = "ERROR:readWebDW01_Datawindow:数据格式不合法:找不到datawindow定义(必须)";
			return -1;
		}

		// '如果存在datawindow定义,那么就设置它的属性
		// '即使没有,也直接跳过去,不报错误,直接设置一个默认值
		local_webdw.datawindow.unit = getElementProp(sDataWindow, "unit", 1,
				"0", iflag);
		local_webdw.datawindow.timer_interval = getElementProp(sDataWindow,
				"time_interval", 1, "0", iflag);
		local_webdw.datawindow.color = toInt(getElementProp(sDataWindow,
				"color", 1, "0", iflag));
		local_webdw.datawindow.processiong = getElementProp(sDataWindow,
				"processiong", 1, "", iflag);
		local_webdw.datawindow.HTMLDW = getElementProp(sDataWindow, "HTMLDW",
				1, "no", iflag);
		local_webdw.datawindow.print_documentname = getElementProp(sDataWindow,
				"print.documentname", 1, "", iflag);
		local_webdw.datawindow.print_orientation = toInt(getElementProp(
				sDataWindow, "print.orientation", 1, "0", iflag));
		local_webdw.datawindow.print_margin_left = toInt(getElementProp(
				sDataWindow, "print.margin.left", 1, "110", iflag));
		local_webdw.datawindow.print_margin_right = toInt(getElementProp(
				sDataWindow, "print.margin.right", 1, "110", iflag));
		local_webdw.datawindow.print_margin_top = toInt(getElementProp(
				sDataWindow, "print.margin.top", 1, "96", iflag));
		local_webdw.datawindow.print_margin_bottom = toInt(getElementProp(
				sDataWindow, "print.margin.bottom", 1, "96", iflag));
		local_webdw.datawindow.print_paper_source = toInt(getElementProp(
				sDataWindow, "print.paper.source", 1, "0", iflag));
		local_webdw.datawindow.print_paper_size = toInt(getElementProp(
				sDataWindow, "print.paper.size", 1, "0", iflag));
		local_webdw.datawindow.print_prompt = getElementProp(sDataWindow,
				"print.prompt", 1, "no", iflag);
		local_webdw.datawindow.print_buttons = getElementProp(sDataWindow,
				"print.buttons", 1, "no", iflag);
		local_webdw.datawindow.print_preview_buttons = getElementProp(
				sDataWindow, "print.preview.buttons", 1, "no", iflag);
		local_webdw.datawindow.grid_lines = getElementProp(sDataWindow,
				"grid.lines", 1, "-1", iflag);
		return 0;
	}

	// '读入header部分的属性
	// '返回0代表成功
	// '返回-1代表失败
	private int readWebDW02_Header() {
		String sHeader = "";
		MyInt ipos = new MyInt(0);
		MyInt iflag = new MyInt(0);

		// '得到datawindow的表示
		sHeader = getElementDesc(dwString, "header", 1, ipos);

		// '如果找不到header定义，就退出
		if (ipos.intvalue < 0) {
			return 0;
		}

		local_webdw.header.height = toInt(getElementProp(sHeader, "height", 1,
				"0", iflag));
		local_webdw.header.color = toInt(getElementProp(sHeader, "color", 1,
				"0", iflag));
		return 0;

	}

	// '读入summary部分的属性
	// '返回0代表成功
	// '返回-1代表失败
	private int readWebDW03_Summary() {
		String sSummary = "";
		MyInt ipos = new MyInt(0);
		MyInt iflag = new MyInt(0);

		// '得到summary的表示
		sSummary = getElementDesc(dwString, "summary", 1, ipos);

		// '如果找不到summary定义，就退出
		if (ipos.intvalue < 0) {
			errString = "ERROR:readWebDW03_Summary:数据格式不合法:找不到summary定义(必须)";
			return -1;
		}

		local_webdw.summary.height = toInt(getElementProp(sSummary, "height",
				1, "0", iflag));
		local_webdw.summary.color = toInt(getElementProp(sSummary, "color", 1,
				"0", iflag));
		return 0;
	}

	// '读入footer部分的属性
	// '返回0代表成功
	// '返回-1代表失败
	private int readWebDW04_Footer() {
		String sFooter = "";
		MyInt ipos = new MyInt(0);
		MyInt iflag = new MyInt(0);

		// '得到footer的表示
		sFooter = getElementDesc(dwString, "footer", 1, ipos);

		// '如果找不到footer定义，就退出
		if (ipos.intvalue < 0) {
			errString = "ERROR:readWebDW04_Footer:数据格式不合法:找不到footer定义(必须)";
			return -1;
		}

		local_webdw.footer.height = toInt(getElementProp(sFooter, "height", 1,
				"0", iflag));
		local_webdw.footer.color = toInt(getElementProp(sFooter, "color", 1,
				"0", iflag));
		return 0;
	}

	// '读入detail部分的属性
	// '返回0代表成功
	// '返回-1代表失败
	private int readWebDW05_Detail() {
		String sDetail = "";
		MyInt ipos = new MyInt(0);
		MyInt iflag = new MyInt(0);

		// '得到footer的表示
		sDetail = getElementDesc(dwString, "detail", 1, ipos);

		// '如果找不到footer定义，就退出
		if (ipos.intvalue < 0) {
			errString = "ERROR:readWebDW05_Detail:数据格式不合法:找不到detail定义(必须)";
			return -1;
		}
		local_webdw.detail.height = toInt(getElementProp(sDetail, "height", 1,
				"0", iflag));
		local_webdw.detail.color = toInt(getElementProp(sDetail, "color", 1,
				"0", iflag));
		return 0;
	}

	// '读入detail部分的属性
	// '返回0代表成功
	// '返回-1代表失败
	private int readWebDW06_Table() {
		String stable = "";
		MyInt ipos = new MyInt(0);
		MyInt iflag = new MyInt(0);
		ArrayList columnArray = new ArrayList();
		Object obj;
		String stemp;
		int id = 0;

		// '得到footer的表示
		stable = getElementDesc(dwString, "table", 1, ipos);

		// '如果找不到footer定义，就退出
		if (ipos.intvalue < 0) {
			errString = "ERROR:readWebDW06_Table:数据格式不合法:找不到table定义(必须)";
			return -1;

		}

		// '先读取column属性
		columnArray = getAllElement(stable, "column=");
		id = 0;
		for (int i = 0; i < columnArray.size(); i++) {
			stemp = (String) columnArray.get(i);

			id = id + 1;
			if (id > 100) {
				errString = "ERROR:readWebDW06_Table:SELECT的列超过100行!";
				return -1;
			}

			local_webdw.table.Columns[id].type = getElementProp(stemp, "type",
					1, "", iflag);
			local_webdw.table.Columns[id].update = getElementProp(stemp,
					"update", 1, "yes", iflag);
			local_webdw.table.Columns[id].updatewhereclause = getElementProp(
					stemp, "updatewhereclause", 1, "yes", iflag);
			local_webdw.table.Columns[id].key = getElementProp(stemp, "key", 1,
					"", iflag);
			local_webdw.table.Columns[id].Name = getElementProp(stemp, "name",
					1, "", iflag);
			local_webdw.table.Columns[id].dbname = getElementProp(stemp,
					"dbname", 1, "", iflag);
			local_webdw.table.Columns[id].values = getElementProp(stemp,
					"values", 1, "", iflag);

		}

		// '读取retrieve属性值
		// 'g_webdw.table.retrieve = getElementProp(stable, "retrieve", 1, "",
		// iflag)

		// 'update,updatewhere,updatekeyinplace
		local_webdw.table.update = getElementProp(stable, "update", 1, "",
				iflag);
		local_webdw.table.updatewhere = getElementProp(stable, "updatewhere",
				1, "", iflag);
		local_webdw.table.updatekeyinplace = getElementProp(stable,
				"updatekeyinplace", 1, "", iflag);

		// '将retrieve字符串的属性读取到对应的变量中去
		// 'retrieve现在不是一个变量，而是一个结构体了。
		String strPBSelect = "";
		String Columns[] = new String[101]; // '定义要读取的column的名称，这个column是数据库的名称
		String tables[] = new String[11]; // '定义要读取的table名称，最多10个
		ArrayList temparray = new ArrayList();
		String tempobj = "";
		MyInt iret = new MyInt(0);

		String select_tablelist = ""; // 'tabel 子句
		String select_columnlist = ""; // 'column 子句
		String select_join = ""; // 'join 条件子句
		String select_where = ""; // 'where子句

		String stablename = "";
		int table_id = 0;
		String scolumnname = "";
		int column_id = 0;

		int join_id = 0;
		String join_left = "";
		String join_op = "";
		String join_right = "";

		int where_id = 0;
		String exp1 = "";
		String where_op = "";
		String exp2 = "";
		String logic = "";

		int order_id = 0;// As Long
		String order_name = "";// As String
		String order_asc = "";// As String

		strPBSelect = getElementProp(stable, "retrieve", 1, "", iflag); // '先读取retrieve属性出来

		// '读取table属性
		temparray = getAllElement(strPBSelect, "TABLE"); // '得到TABLE元素的定义
		table_id = 0;
		for (int i = 0; i < temparray.size(); i++) {
			stemp = (String) temparray.get(i);
			stablename = getElementProp2(stemp, "NAME", 1, "", iret, ")"); // '采用)作为结束分割符号

			if (iret.intvalue == -1) {
				continue;
			}

			table_id = table_id + 1;
			if (table_id > 10) {
				break;
			}
			local_webdw.table.retrieve.pbselect.table[table_id] = stablename; // '存储tableName的值

		}

		// '读取column属性
		temparray = getAllElement(strPBSelect, "COLUMN"); // '得到column元素定义
		column_id = 0;
		for (int i = 0; i < temparray.size(); i++) {
			stemp = (String) temparray.get(i);
			scolumnname = getElementProp2(stemp, "NAME", 1, "", iret, ")");

			if (iret.intvalue == -1) {
				continue;
			}

			column_id = column_id + 1;
			if (column_id > 100) {
				break;
			}
			local_webdw.table.retrieve.pbselect.column[column_id] = scolumnname; // '存储column的NAME
		}

		// '读取join属性
		temparray = getAllElement(strPBSelect, "JOIN "); // '得到JOIN元素定义，后面有一个空格
		join_id = 0;
		for (int i = 0; i < temparray.size(); i++) {
			stemp = (String) temparray.get(i);
			join_left = getElementProp2(stemp, "LEFT", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			join_op = getElementProp2(stemp, "OP", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			join_right = getElementProp2(stemp, "RIGHT", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			join_id = join_id + 1;
			if (join_id > 10) {
				break;
			}
			local_webdw.table.retrieve.pbselect.join[join_id].join_left = join_left;
			local_webdw.table.retrieve.pbselect.join[join_id].join_op = join_op;
			local_webdw.table.retrieve.pbselect.join[join_id].join_right = join_right;
		}

		// '读取where属性
		temparray = getAllElement(strPBSelect, "WHERE"); // '得到Where元素定义
		where_id = 0;
		for (int i = 0; i < temparray.size(); i++) {
			stemp = (String) temparray.get(i);
			exp1 = getElementProp2(stemp, "EXP1", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			where_op = getElementProp2(stemp, "OP", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			exp2 = getElementProp2(stemp, "EXP2", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			logic = getElementProp2(stemp, "LOGIC", 1, "", iret, " ");

			where_id = where_id + 1;
			if (where_id > 10) {
				break;
			}
			local_webdw.table.retrieve.pbselect.where[where_id].exp1 = exp1;
			local_webdw.table.retrieve.pbselect.where[where_id].op = where_op;
			local_webdw.table.retrieve.pbselect.where[where_id].exp2 = exp2;
			local_webdw.table.retrieve.pbselect.where[where_id].logic = logic;

		}

		// '读取order属性
		// Set temparray = getAllElement(strPBSelect, "ORDER") '得到order元素定义
		// order_id = 0
		// For Each tempobj In temparray
		// stemp = tempobj
		// order_name = getElementProp2(stemp, "NAME", 1, "", iret, " ")
		// If iret = -1 Then GoTo continue5
		//	        
		// order_asc = getElementProp2(stemp, "ASC", 1, "yes", iret, " ") '默认为升序
		// If iret = -1 Then GoTo continue5
		//	        
		// order_id = order_id + 1
		//	        
		// If order_id > 10 Then
		// Exit For
		// End If
		//	        
		// local_webdw.table.retrieve.pbselect.order(order_id).Name = order_name
		// local_webdw.table.retrieve.pbselect.order(order_id).Asc = order_asc
		// continue5:
		// Next

		// '读取order属性
		temparray = getAllElement(strPBSelect, "ORDER");// '得到order元素定义
		order_id = 0;
		for (int i = 0; i < temparray.size(); i++) {
			stemp = (String) temparray.get(i);
			order_name = getElementProp2(stemp, "NAME", 1, "", iret, " ");
			if (iret.intvalue == -1) {
				continue;
			}

			order_asc = getElementProp2(stemp, "ASC", 1, "yes", iret, " ");// '默认为升序
			if (iret.intvalue == -1) {
				continue;
			}

			order_id = order_id + 1;

			if (order_id > 10) {
				break;
			}

			local_webdw.table.retrieve.pbselect.order[order_id].Name = order_name;
			local_webdw.table.retrieve.pbselect.order[order_id].Asc = order_asc;
		}

		return 0;
	}

	// '读入所有的text的属性
	// '返回0代表成功
	// '返回-1代表失败

	private int readWebDW07_Text() {
		ArrayList textArray = new ArrayList();
		Object obj;
		String stemp = "";
		int id = 0;
		MyInt iret = new MyInt(0);

		textArray = getAllElement(dwString, "text");
		id = 0;
		// '循环处理
		for (int i = 0; i < textArray.size(); i++) {
			stemp = (String) textArray.get(i);
			if (Len(stemp) < 10) {
				continue;
			}

			id = id + 1;

			if (id > 100) {
				errString = "ERROR:readWebDW07_Text:最多可读取100个标签!";
				return -1;
			}

			local_webdw.text[id].band = getElementProp(stemp, "band", 1,
					"detail", iret);
			local_webdw.text[id].alignment = toInt(getElementProp(stemp,
					"alignment", 1, "1", iret));
			local_webdw.text[id].text = getElementProp(stemp, "text", 1, "",
					iret);
			local_webdw.text[id].border = toInt(getElementProp(stemp, "border",
					1, "0", iret));
			local_webdw.text[id].color = toInt(getElementProp(stemp, "color",
					1, "0", iret));
			local_webdw.text[id].x = toInt(getElementProp(stemp, "x", 1, "0",
					iret));
			local_webdw.text[id].y = toInt(getElementProp(stemp, "y", 1, "0",
					iret));
			local_webdw.text[id].height = toInt(getElementProp(stemp, "height",
					1, "0", iret));
			local_webdw.text[id].width = toInt(getElementProp(stemp, "width",
					1, "0", iret));
			local_webdw.text[id].Name = getElementProp(stemp, "name", 1, "",
					iret);

			// '下面是字体属性
			local_webdw.text[id].font.face = getElementProp(stemp, "font.face",
					1, "", iret);
			local_webdw.text[id].font.height = toInt(getElementProp(stemp,
					"font.height", 1, "", iret));
			local_webdw.text[id].font.weight = toInt(getElementProp(stemp,
					"font.weight", 1, "", iret));
			local_webdw.text[id].font.family = toInt(getElementProp(stemp,
					"font.family", 1, "", iret));
			local_webdw.text[id].font.pitch = toInt(getElementProp(stemp,
					"font.pitch", 1, "", iret));
			local_webdw.text[id].font.charset = toInt(getElementProp(stemp,
					"font.charset", 1, "", iret));
			local_webdw.text[id].font.italic = toInt(getElementProp(stemp,
					"font.italic", 1, "0", iret));
			local_webdw.text[id].font.underline = toInt(getElementProp(stemp,
					"font.underline", 1, "0", iret));
			local_webdw.text[id].font.strikethrough = toInt(getElementProp(
					stemp, "font.strikethrough", 1, "0", iret));

			// '下面是颜色属性
			local_webdw.text[id].background_mode = toInt(getElementProp(stemp,
					"background.mode", 1, "", iret));
			local_webdw.text[id].background_color = toInt(getElementProp(stemp,
					"background.color", 1, "", iret));
		}
		return 0;
	}

	// '读入所有的column的属性
	// '返回0代表成功
	// '返回-1代表失败
	private int readWebDW08_Column() {
		ArrayList columnArray = new ArrayList();
		Object obj;
		String sColumn;
		int id;
		MyInt iret = new MyInt(0);
		WebDW_Column temp_webdw_column = new WebDW_Column();

		columnArray = getAllElement(dwString, "column");
		id = 0;
		// '循环处理
		for (int i = 0; i < columnArray.size(); i++) {
			sColumn = (String) columnArray.get(i);
			id = id + 1;

			if (id > 100) {
				errString = "ERROR:readWebDW08_Column:最多可读取100个列!";
				return -1;
			}

			temp_webdw_column = new WebDW_Column();
			temp_webdw_column.band = getElementProp(sColumn, "band", 1, "1",
					iret);
			temp_webdw_column.id = toInt(getElementProp(sColumn, "id", 1, "0",
					iret));
			temp_webdw_column.alignment = toInt(getElementProp(sColumn,
					"alignment", 1, "1", iret));
			temp_webdw_column.tabsequence = toInt(getElementProp(sColumn,
					"tabsequence", 1, "0", iret));
			temp_webdw_column.border = toInt(getElementProp(sColumn, "border",
					1, "1", iret));
			temp_webdw_column.color = toInt(getElementProp(sColumn, "color", 1,
					"0", iret));

			temp_webdw_column.x = toInt(getElementProp(sColumn, "x", 1, "0",
					iret));
			temp_webdw_column.y = toInt(getElementProp(sColumn, "y", 1, "0",
					iret));
			temp_webdw_column.height = toInt(getElementProp(sColumn, "height",
					1, "0", iret));
			temp_webdw_column.width = toInt(getElementProp(sColumn, "width", 1,
					"0", iret));
			temp_webdw_column.format = getElementProp(sColumn, "format", 1, "",
					iret);
			temp_webdw_column.Name = getElementProp(sColumn, "name", 1, "",
					iret);
			temp_webdw_column.tag = getElementProp(sColumn, "tag", 1, "", iret);

			// '下面是编辑风格支持
			temp_webdw_column.edit_limit = toInt(getElementProp(sColumn,
					"edit.limit", 1, "0", iret));
			temp_webdw_column.edit_case = getElementProp(sColumn, "edit.case",
					1, "any", iret);
			temp_webdw_column.edit_focusrectangle = getElementProp(sColumn,
					"edit.focusrectangle", 1, "no", iret);
			temp_webdw_column.edit_autoselect = getElementProp(sColumn,
					"edit.autoselect", 1, "no", iret);
			temp_webdw_column.edit_autohscroll = getElementProp(sColumn,
					"edit.autohscroll", 1, "yes", iret);

			// '下面是字体支持
			temp_webdw_column.font.face = getElementProp(sColumn, "font.face",
					1, "", iret);
			temp_webdw_column.font.height = toInt(getElementProp(sColumn,
					"font.height", 1, "", iret));
			temp_webdw_column.font.weight = toInt(getElementProp(sColumn,
					"font.weight", 1, "", iret));
			temp_webdw_column.font.family = toInt(getElementProp(sColumn,
					"font.family", 1, "", iret));
			temp_webdw_column.font.pitch = toInt(getElementProp(sColumn,
					"font.pitch", 1, "", iret));
			temp_webdw_column.font.charset = toInt(getElementProp(sColumn,
					"font.charset", 1, "", iret));
			temp_webdw_column.font.italic = toInt(getElementProp(sColumn,
					"font.italic", 1, "0", iret));
			temp_webdw_column.font.underline = toInt(getElementProp(sColumn,
					"font.underline", 1, "0", iret));
			temp_webdw_column.font.strikethrough = toInt(getElementProp(
					sColumn, "font.strikethrough", 1, "0", iret));

			// '下面是background支持
			temp_webdw_column.background_mode = toInt(getElementProp(sColumn,
					"background.mode", 1, "", iret));
			temp_webdw_column.background_color = toInt(getElementProp(sColumn,
					"background.color", 1, "", iret));

			// '下面是单选按钮的支持定义20090124
			temp_webdw_column.radiobuttons.Columns = toInt(getElementProp(
					sColumn, "radiobuttons.columns", 1, "0", iret));

			// '下面是选择框按钮的支持定义20090124
			temp_webdw_column.checkbox.text = getElementProp(sColumn,
					"checkbox.text", 1, "", iret);
			temp_webdw_column.checkbox.on = getElementProp(sColumn,
					"checkbox.on", 1, "", iret);
			temp_webdw_column.checkbox.off = getElementProp(sColumn,
					"checkbox.off", 1, "", iret);
			temp_webdw_column.checkbox.scale1 = getElementProp(sColumn,
					"checkbox.scale", 1, "", iret);
			temp_webdw_column.checkbox.threed = getElementProp(sColumn,
					"checkbox.threed", 1, "", iret);

			// '下面是下拉列表编辑风格的支持定义20090124
			temp_webdw_column.combobox.allowedit = getElementProp(sColumn,
					"ddlb.allowedit", 1, "", iret);
			temp_webdw_column.combobox.limit = toInt(getElementProp(sColumn,
					"ddlb.limit", 1, "0", iret));
			temp_webdw_column.combobox.case1 = getElementProp(sColumn,
					"ddlb.case", 1, "", iret);
			temp_webdw_column.combobox.useasborder = getElementProp(sColumn,
					"ddlb.useasborder", 1, "", iret);

			// '下面是下拉式数据窗口的支持定义20090125(牛年除夕之夜)
			temp_webdw_column.dddw.allowedit = getElementProp(sColumn,
					"dddw.allowedit", 1, "", iret);
			temp_webdw_column.dddw.case1 = getElementProp(sColumn, "dddw.case",
					1, "", iret);
			temp_webdw_column.dddw.DataColumn = getElementProp(sColumn,
					"dddw.datacolumn", 1, "", iret);
			temp_webdw_column.dddw.DisplayColumn = getElementProp(sColumn,
					"dddw.displaycolumn", 1, "", iret);
			temp_webdw_column.dddw.limit = toInt(getElementProp(sColumn,
					"dddw.limit", 1, "0", iret));
			temp_webdw_column.dddw.Lines = toInt(getElementProp(sColumn,
					"dddw.lines", 1, "0", iret));
			temp_webdw_column.dddw.Name = getElementProp(sColumn, "dddw.name",
					1, "", iret);
			temp_webdw_column.dddw.PercentWidth = toInt(getElementProp(sColumn,
					"dddw.percentwidth", 1, "100", iret));
			temp_webdw_column.dddw.useasborder = getElementProp(sColumn,
					"dddw.useasborder", 1, "", iret);
			temp_webdw_column.dddw.vscrollbar = getElementProp(sColumn,
					"dddw.vscrollbar", 1, "", iret);

			local_webdw.column[temp_webdw_column.id] = temp_webdw_column;
		}
		return 0;
	}

	// '读取所画线条的属性
	private int readWebDW09_Line() {
		ArrayList lineArray = new ArrayList();
		Object obj;
		String sline = "";
		int id = 0;
		MyInt iret = new MyInt(0);

		lineArray = getAllElement(dwString, "line");
		id = 0;
		// '循环处理
		for (int i = 0; i < lineArray.size(); i++) {
			sline = (String) lineArray.get(i);

			id = id + 1;

			if (id > 100) {

				errString = "ERROR:readWebDW09_Line:最多可读取100个线条!";
				return -1;
			}

			local_webdw.lineinfo[id].band = getElementProp(sline, "band", 1,
					"detail", iret);
			local_webdw.lineinfo[id].x1 = toInt(getElementProp(sline, "x1", 1,
					"0", iret));
			local_webdw.lineinfo[id].y1 = toInt(getElementProp(sline, "y1", 1,
					"0", iret));
			local_webdw.lineinfo[id].x2 = toInt(getElementProp(sline, "x2", 1,
					"0", iret));
			local_webdw.lineinfo[id].y2 = toInt(getElementProp(sline, "y2", 1,
					"0", iret));
			local_webdw.lineinfo[id].Name = getElementProp(sline, "name", 1,
					"", iret);
			local_webdw.lineinfo[id].pen_style = getElementProp(sline,
					"pen.style", 1, "", iret);
			local_webdw.lineinfo[id].pen_width = getElementProp(sline,
					"pen.width", 1, "", iret);
			local_webdw.lineinfo[id].pen_color = getElementProp(sline,
					"pen.color", 1, "", iret);
			local_webdw.lineinfo[id].background_mode = getElementProp(sline,
					"background.mode", 1, "", iret);
			local_webdw.lineinfo[id].background_color = getElementProp(sline,
					"background.color", 1, "", iret);
		}
		return 0;
	}

}
