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
