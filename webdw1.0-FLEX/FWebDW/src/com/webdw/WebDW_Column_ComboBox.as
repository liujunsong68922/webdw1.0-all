package com.webdw
{
// '数据列对下拉选择框的支持定义，这是Column的一个属性
public class WebDW_Column_ComboBox {
	public var limit:int = 0; // '限制，含义不明

	public var allowedit:String = ""; // '是否可以编辑 yes /no

	public var case1:String = ""; // '大小写,改名为case1

	public var useasborder:String = ""; // '是否显示箭头 yes/no

	public function  Clone() :WebDW_Column_ComboBox{

		var newOne:WebDW_Column_ComboBox = new WebDW_Column_ComboBox();

		newOne.limit = limit; // '限制，含义不明

		newOne.allowedit = allowedit; // '是否可以编辑 yes /no

		newOne.case1 = case1; // '大小写,改名为case1

		newOne.useasborder = useasborder; // '是否显示箭头 yes/no
		return newOne;
	}
}
}