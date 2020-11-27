package com.webdw
{
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
 import mx.controls.Alert;
public class CWebDWData_DataBuffer extends Golbal {
//	public void ReadMe(){
//		System.out.println("WebDW控件对应的数据存储及访问类所使用的数据存储缓存类");
//		System.out.println(JWebDWInfo);
//	}
	public function CWebDWData_DataBuffer():void {
		Init();
	}

	public var BufferType:int; // '缓存区的类型，1. Primary 2. Filter 3.Delete

	public var Columns:Array; // '列名的集合，来自返回数据，而不是DW定义

	private var DataArray:Array=new Array(100001); // '所有数据用字符串类型来存储

	public var errString:String=""; // '如果调用失败，输出的错误信息。

	public var RowNumber:int=0; // '数据的总行数

	public var ColNumber:int=0; // '列的总数

	public var ColLength:int=0; // '每一行的存储长度

	// '功能描述：从当前的数据集合中删除一行记录
	// '后续记录向前移动一条记录
	// '返回0 删除成功
	// '返回-1 删除失败
	public function DeleteRow( delRowId:int):int {
		// '判断delrowid的合法性
		if (delRowId <= 0 || delRowId > RowNumber) {
			errString = "invalid delete row:" + delRowId;
			return -1;
		}

		var colid:int = 0; // '行号
		var rowid:int = 0; // '列号

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
	private function GenerateInsertSQL(stablename:String,  rowid:int, iret:MyInt):String {
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

		var state:String;
		state = GetRowState(rowid, iret);

		var scollist:String = "";
		var strsql:String = "";
		var colid:int = 0;

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

			for (colid = 1; colid <= ColNumber; colid++) {
				if (colid < ColNumber) {
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
	public function GetRowState( row:int,  iret:MyInt):String {
		// '判断行的准确性
		if (row < 1 || row > RowNumber) {
			iret.intvalue = -1;
			errString = "Invalid row:" + row;
			return "";
		}

		iret.intvalue = 0;
		return DataArray[row * ColLength];// '如果每行5列，第11个数据就代表其状态
	}

	// '得到列的列表,按照id排列,各字段之间用逗号分割
	private function GetColumnList():String {
		var colid:int = 0;
		var slist:String = "";
		slist = "";
		for (colid = 0; colid <= ColNumber - 1; colid++) {
			if (colid < ColNumber - 1) {
				slist = slist + Columns[colid] + " , ";
			} else {
				slist = slist + Columns[colid];
			}
		}

		return slist;
	}

	// '得到指定行列的数据
	// 'row 行号
	// 'col 列号
	// 'iret 返回值
	public function GetItemString( row:int,  col:int,  iret:MyInt):String {
		// '判断行的准确性
		if (row < 1 || row > RowNumber) {
			iret.intvalue = -1;
			errString = "Invalid row:" + row;
			return "";
		}
		// '判断列的准确性
		if (col < 1 || col > ColNumber) {
			iret.intvalue = -1;
			errString = "Invalid col:" + col;
			return "";
		}

		// '返回结果数据,GetItemString只能返回当前值，要得到原始值需要调用其它方法
		iret.intvalue = 0;
		return DataArray[(row - 1) * ColLength + col];

	}

	// '将某一行表示成一个标准的字符串，各列之间用chr(9)分割
	// '如果行号非法，返回空字符串
	public function GetRowString( rowid:int):String {
		if (rowid <= 0 || rowid > RowNumber) {
			errString = "Invalid row:" + rowid;
			return "";
		}

		var colid:int = 0;// '列号
		var sret:String;// '返回字符串
		sret = "";
		for (colid = 1; colid <= ColNumber; colid++) {
			if (colid < ColNumber) {
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
	public function GetAllData():String {
		var sret:String = "";
		var rowid:int = 0;

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
	public function GetAllUpdateSQL( stablename:String,  iret:MyInt):String {
		var rowid:int = 0;
		var strsql:String = "";
		var sql1:String = "";

		strsql = "";
		//Alert.show("enter GetAllUpdateSQL"+RowNumber+stablename);
		for (rowid = 1; rowid <= RowNumber; rowid++) {
			sql1 = GetUpdateSql(stablename, rowid, iret);
			if (iret.intvalue == -1) {
				return "";
			}

			if (!(sql1==(""))) {
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
	public function GetColIdByName(colname:String):int {
		var colid:int = 0;
		for (colid = 0; colid <= ColNumber - 1; colid++) {
			if (UCase(Columns[colid])==(UCase(colname))) {
				return colid + 1;
			}
		}
		return -1;
	}

	// '根据列的序号，得到列的名称
	public function GetColumnName(colid:int):String {
		if (colid <= ColNumber && colid >= 0) {
			return Columns[colid - 1];
		} else {
			return "";
		}
	}

	// '得到column()的字符串表示,这一功能用来输出并初始化其它dw
	public function GetColumnString():String {
		var sret:String = "";
		var colid:int = 0;
		for (colid = 1; colid <= ColNumber; colid++) {
			if (colid < ColNumber) {
				sret = sret + Columns[colid - 1] + Chr(9);
			} else {
				sret = sret + Columns[colid - 1];
			}
		}
		return sret;

	}

	// '得到最初的指定行列的数据
	// 'row 行号
	// 'col 列号
	// 'iret 返回值
	public function GetOriginalItemString(row :int,  col:int,  iret:MyInt):String {
		// '判断行的准确性
		if (row < 1 || row > RowNumber) {
			iret.intvalue = -1;
			errString = "Invalid row:" + row;
			return "";
		}

		// '判断列的准确性
		if (col < 1 || col > ColNumber) {
			iret.intvalue = -1;
			errString = "Invalid col:" + col;
			return "";
		}

		// '返回结果数据,GetOriginalItemString只能返回原始值
		iret.intvalue = 0;
		return DataArray[(row - 1) * ColLength + ColNumber + col];

	}

	// '将某一行的原始数据表示成一个标准的字符串，各列之间用chr(9)分割
	// '如果行号非法，返回空字符串
	public function GetOriginalRowString( rowid:int):String {
		if (rowid < 1 || rowid > RowNumber) {
			errString = "Invalid row:" + rowid;
			return "";
		}

		var colid:int = 0;// '列号
		var sret:String = "";// '返回字符串
		sret = "";
		for (colid = 1; colid <= ColNumber; colid++) {
			if (colid < ColNumber) {
				sret = sret
						+ DataArray[(rowid - 1) * ColLength + ColNumber + colid]
						+ Chr(9);
			} else {
				sret = sret
						+ DataArray[(rowid - 1) * ColLength + ColNumber + colid];
			}
		}

		// '返回字符串
		return sret;
	}

	// '根据rowid,生成更新和删除时所需要的Where字句
	private function GetSetClause( rowid:int, iret:MyInt):String {
		var strSet:String = "";
		var colid:int = 0;
		var sData:String = "";

		strSet = " Set ";
		for (colid = 0; colid <= ColNumber - 1; colid++) {
			sData = GetItemString(rowid, colid + 1, iret);
			if (iret.intvalue == -1) {
				return "";
			}

			if (colid == 0) {
				strSet = strSet + Columns[colid] + " = " + "'" + sData + "' ";
			} else {
				strSet = strSet + " , " + Columns[colid] + " = " + "'" + sData
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
	public function GetUpdateSql( stablename:String,  rowid:int, iret:MyInt):String  {
		var state:String = "";
		var strSet:String = "";
		var strWhere:String = "";

		// 'part1 primarybuffer的处理,根据状态生成Update和Insert
		if (BufferType == 1) {
			state = GetRowState(rowid, iret);
			if (iret.intvalue == -1) {
				return "";
			}

			// '插入语句的生成
			if (state==("new")) {
				var Sql:String = GenerateInsertSQL(stablename, rowid, iret);
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
			if (!(state==("new"))) {

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
	private function GetWhereClause( rowid:int,  iret:MyInt):String  {
		var strWhere:String = "";
		var colid:int = 0;
		var sData:String = "";
		var colwhere:String = "";

		strWhere = "";
		for (colid = 0; colid <= ColNumber - 1; colid++) {
			sData = GetOriginalItemString(rowid, colid + 1, iret);
			if (iret.intvalue == -1) {
				return "";
			}

			if (sData==("")) {// '空字符串做空值处理
				colwhere = Columns[colid] + " is null ";
			} else {
				colwhere = Columns[colid] + " = '" + sData + "'";
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
	public function Init():int  {
		Columns = new Array(1);
		DataArray = new Array(1001);
		errString = "";
		RowNumber = 0;
		ColNumber = 0;
		ColLength = 0;
		return 0;
	}

	public function InitData(sindata:String ):int {
		return InitData2(sindata, "normal");
	}

	// '功能描述：从输入的字符串中读取数据，填充columnArray和lineArray
	// '第一行是列的名称描述，其余行是对应的数据
	// '这里不处理Null值，数据库上的null值被转换为空字符串
	//
	// '返回0 成功
	// '返回-1 失败，错误信息保存在errString中
	// 'sindata 输入数据，字符串表示
	// 'state 数据状态，默认为"normal"
	public function InitData2( sindata:String ,  state:String):int  {
		//Alert.show("buffer Init");
		Init(); // '调用类初始化的方法

		var sDataArray:Array; // '原始数据按行分解得到的数组
		var vline:String; // '原始数据每一行
		var sline:String = ""; // '转换成字符串的原始数据每一行

		var sdarray:Array;// '中间变量，每一行分解成数据列的数组

		var lineId:int;// '原始数据的行号，0代表标题，其余代表数据
		var colid:int; // '列的序号
		DataArray = new Array(1); // '先清空原始数据
		//Alert.show("buffer 2");

		sDataArray = Split(sindata, "" + Chr(13) + Chr(10));// '利用回车符号进行分解
		//Alert.show("buffer 3");

		lineId = 0; // '原始数据的行号
		var i:int=0;
		var j:int=0;
		//Alert.show("buffer 4");
		
		for ( i = 0; i < sDataArray.length; i++) {
			sline = (String)(sDataArray[i]);// '读出一行,转成字符串
			if (sline==("")) {// '遇到空行，退出
				break;
			}

			if (lineId == 0) {
				Columns = Split(sline, Chr(9)); // '按chr(9)来分解成列,存到columns里面
				ColNumber = UBound(Columns) + 1; // '列的数量,split返回的数组是zero-based.
				ColLength = ColNumber * 2 + 1; // '每一行的长度，等于colnumber*2加1
			} else {
				if (Trim(sline)==("")) { // '遇到空行，退出循环
					break;
				}

				sdarray = Split(sline, Chr(9)); // '按chr(9)来分解列,分解成多个数据列

				if (UBound(sdarray) != UBound(Columns)) { // '检查数据列是否足够，数据不足则报错误
					errString = "CWebDWData.ReadDataq数据格式错误:数据列数量不足!行:"
							+ lineId;
					return -1;
				}

				RowNumber = lineId; // '存储当前行数

				if (UBound(DataArray) < RowNumber * ColLength) {
					// ReDim Preserve DataArray(UBound(DataArray) + 1000) //
					// '一次分配1000个空间，避免多次分配
					var temp:Array = new Array(DataArray.length + 1000);
					
					for (j = 1; j < DataArray.length; j++) {
						temp[j] = DataArray[j];
					}
					for (j = DataArray.length; j < DataArray.length + 1000; j++) {
						temp[j] = "";
					}
					DataArray = temp;
				}

				for (colid = 1; colid <= ColNumber; colid++) {
					// '对null值的特殊处理:将后台返回的NULL变成一个空字符串
					if (UCase(sdarray[colid - 1])==("NULL")) {
						sdarray[colid - 1] = "";
					}
					DataArray[(lineId - 1) * ColLength + colid] = sdarray[colid - 1]; // '列的数据存储
					DataArray[(lineId - 1) * ColLength + ColNumber + colid] = sdarray[colid - 1]; // '再存储一份作为备份
				}
				DataArray[lineId * ColLength] = state; // 'initData的数据是正常状态
			}
			lineId = lineId + 1;
		}
		return 0;
	}

	// '功能描述：在DataArray中插入一行记录，这行记录用字符串来表示
	// 'rowid:要插入的当前行号，插入以后，这一行数据将代表当前行，如果rowid=0，在最后追加
	// 'sline:用字符串表示的一行记录
	// '返回值：>0 代表插入以后的行号，-1代表失败，错误信息在errString中
	public function InsertRow( insertid:int,  sline:String):int  {
		var data:Array;
		var colid:int = 0;
		var rowid:int = 0;

		if (insertid < 0 || insertid > RowNumber) {
			errString = "Invalid rowid:" + insertid;
			return -1;
		}

		data = Split(sline, Chr(9));

		if (UBound(data) != ColNumber - 1) {
			errString = "插入列数据列和要求不符合:" + sline;
			return -1;
		}

		// '判断是否需要扩展存储区域
		if (UBound(DataArray) < (RowNumber + 1) * ColLength) {
			// ReDim Preserve DataArray(UBound(DataArray) + 1000) //
			// '一次分配1000个空间，避免多次分配
			var temp:Array = new Array(DataArray.length + 1000);
			var j:int=0;
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

		for (colid = 1; colid <= ColNumber; colid++) {
			DataArray[(rowid - 1) * ColLength + colid] = "";// '初始化
		}

		// '复制插入这一行的数据
		for (colid = 1; colid <= ColNumber; colid++) {
			DataArray[(rowid - 1) * ColLength + colid] = data[colid - 1];
		}
		DataArray[rowid * ColLength] = "new";// '默认情况下，设置为new,在外面可能会修改这个值
		return rowid;

	}

	// '功能描述：清空所有的数据，保留列信息
	public function ResetData():int {
		DataArray = new Array(1000);
		RowNumber = 0;
		return 0;
	}

	// '设置指定行列的数据,返回值无用
	public function SetItemString( row:int,col:int,sData:String, iret:MyInt):String {
		// '判断行的准确性
		if (row < 1 || row > RowNumber) {
			iret.intvalue = -1;
			errString = "Invalid row:" + row;
			return "";
		}

		// '判断列的准确性
		if (col < 1 || col > ColNumber) {
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
	public function SetOriginalItemString(row:int ,  col:int,  sData:String ,  iret:MyInt):String {
		// '判断行的准确性
		if (row < 1 || row > RowNumber) {
			iret.intvalue = -1;
			errString = "Invalid row:" + row;
			return "";
		}

		// '判断列的准确性
		if (col < 1 || col > ColNumber) {
			iret.intvalue = -1;
			errString = "Invalid col:" + col;
			return "";
		}

		iret.intvalue = 0;
		DataArray[(row - 1) * ColLength + ColNumber + col] = sData;// '设置历史数据

		iret.intvalue = 0;
		return "";
	}

	// '设置指定行的状态数据
	public function SetRowState( row:int,  state:String,  iret:MyInt):String {
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
	private function Sort_SwapLine( row1:int,  row2:int):int {
		// '首先判断输入参数的正确性
		// '如果输入参数错误，那么就不进行操作了
		if (!(row1 > 0 && row1 <= RowNumber && row2 > 0 && row2 <= RowNumber)) {
			return -1;
		}

		var colid:int = 0;// As Long
		var stemp:String = "";// As String
		var id:int;
		for (colid = 1; colid <= ColLength; colid++) {
			 id = (int) ((row1 - 1) * ColLength) + colid;
			stemp = DataArray[id];
			DataArray[(int) ((row1 - 1) * ColLength) + colid] = DataArray[(row2 - 1)
					* ColLength + colid];
			DataArray[(int) ((row2 - 1) * ColLength) + colid] = stemp;
		}
		return 0;
	}

	// '根据给定的排序条件定义，比较rowid1,rowid2的内容，
	// '返回rowid1,rowid2中数据较小的那个行数
	// '这一方法假设rowid1,rowid2都是合法的行数
	// '返回-1代表比较失败，发生错误
	private function Sort_Compare( sorter:String,  row1:int,  row2:int):int  {
		if (sorter==("")) {
			errString = "Compare argument is empty";
			return -1;
		}

		var sorts:Array = new Array(1);
		var sortid :int= 0; // As Long
		var sortcolid:int = 0;// As Long '排序字段序号
		var sortcoltype:String = "";// As String '排序字段类型A 升序 D 降序,其他字符一律按升序处理
		var coldatatype:String = "";// As String '列的数据类型定义
		var pos1:int = 0;// As Long '#的位置
		var pos2:int= 0;// As Long '空格的位置
		var sdata1:String = "";// As String
		var sdata2:String = "";// As String

		sorts = Split(sorter, ",");// '一个排序条件切分成多个排序条件
		for (sortid = 0; sortid <= UBound(sorts); sortid++) {
			pos1 = InStr2(sorts[sortid], "#");
			if (pos1 <= 0) {
				// Sort_Compare = -1
				errString = "Compare argument error";
				return -1;
			}

			pos2 = InStr3(pos1, sorts[sortid], " ");// '找到下一个空格的位置
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
			sortcoltype = UCase(Trim(Mid2(sorts[sortid], pos2 + 1)));

			if (sortcolid < 1 || sortcolid > ColNumber) {
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

			var v1:Number;// As Double
			var v2:Number;// As Double
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
	private function Sort_GetMinLine( sorter:String,  beginrow:int,  endrow:int):int {
		if (!(beginrow > 0 && beginrow <= RowNumber && endrow > 0
				&& endrow <= RowNumber && beginrow <= endrow)) {
			// Sort_GetMinLine = -1
			// Exit Function
			return -1;
		}// End If

		var rowid:int = 0;// As Long
		var irow :int= 0;// As Long

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
	public function Sort( sorter:String): int {
		if (sorter==("")) {
			// Sort = 0
			// Exit Function
			return 0;
		}// End If

		var rowid:int = 0;// As Long
		var minrowid:int = 0;// As Long
		for (rowid = 1; rowid <= RowNumber; rowid++) {
			minrowid =  Sort_GetMinLine(sorter, rowid, RowNumber);// '得到从当前行开始最小的行号

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
}