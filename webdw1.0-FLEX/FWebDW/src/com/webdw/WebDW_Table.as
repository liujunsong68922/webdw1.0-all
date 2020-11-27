package com.webdw
{
// 'table属性定义
public class WebDW_Table {
	public var Columns:Array = new Array(101); // '最多100列

	public var retrieve:WebDW_Table_Retrieve = new WebDW_Table_Retrieve(); // '重新定义retrieve参数，定义成一个结构

	public var update:String = "";

	public var updatewhere:String = "";

	public var updatekeyinplace:String = "";

	/**
	 * 构造函数,初始化数据
	 * 
	 */
	public function WebDW_Table() {
		var i:int =0;
		for ( i = 0; i < 101; i++) {
			Columns[i] = new WebDW_Table_Column();
		}
	}

	public function Clone():WebDW_Table {

		var newOne:WebDW_Table = new WebDW_Table();
		var i:int  =0;
		for (i = 0; i < 101; i++) {
			newOne.Columns[i] = Columns[i].Clone();
		}

		newOne.retrieve = retrieve.Clone();

		newOne.update = update;

		newOne.updatewhere = updatewhere;

		newOne.updatekeyinplace = updatekeyinplace;

		return newOne;
	}
}
}