package com.webdw
{
// 'table的retrieve的pbselect元素属性定义
// '这一部分可能会根据需要来进行后续增加
// '会随着对于DW文件格式的理解深入而扩展
public class WebDW_Table_Retrive_PBSelect {
	public var version:String = "";

	public var table:Array = new Array(11); // '表名，最多容许10个表

	public var column:Array = new Array(101); // '列名，最多容许100个列

	public var join:Array = new Array(11);// '表连接定义，最多10个连接

	public var where:Array = new Array(11); // 'where条件定义，最多10个where条件

	public var order:Array = new Array(11); // 'order

	// 条件设定,最多10个

	/*
	 * 构造函数，初始化
	 */
	public function WebDW_Table_Retrive_PBSelect() {
		var i:int =0;
		for (i = 0; i < 11; i++) {
			table[i] = "";
		}
		for (i = 0; i < 101; i++) {
			column[i] = "";
		}
		for (i = 0; i < 11; i++) {
			join[i] = new WebDW_Table_Retrieve_PBSelect_Join();
		}
		for (i = 0; i < 11; i++) {
			where[i] = new WebDW_Table_Retrieve_PBSelect_Where();
		}
		for (i = 0; i < 11; i++) {
			order[i] = new WebDW_Table_Retrieve_PBSelect_Order();
		}

	}

	public function Clone():WebDW_Table_Retrive_PBSelect {
		var newOne:WebDW_Table_Retrive_PBSelect = new WebDW_Table_Retrive_PBSelect();
		var i:int =0;
		for (i = 0; i < 11; i++) {
			newOne.table[i] = table[i];
		}
		for (i = 0; i < 101; i++) {
			newOne.column[i] = column[i];
		}
		for (i = 0; i < 11; i++) {
			newOne.join[i] = join[i].Clone();
		}
		for (i = 0; i < 11; i++) {
			newOne.where[i] = where[i].Clone();
		}
		for (i = 0; i < 11; i++) {
			newOne.order[i] = order[i].Clone();
		}

		return newOne;
	}
}

}