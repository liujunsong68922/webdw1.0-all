package com.webdw
{
// '数据表检索的OrderBy条件定义
public class WebDW_Table_Retrieve_PBSelect_Order {
	public var Name :String= "";// As String '排序的列名称

	public var Asc :String = "";// As String '是否是升序yes/no

	public function Clone():WebDW_Table_Retrieve_PBSelect_Order {

		var newOne:WebDW_Table_Retrieve_PBSelect_Order = new WebDW_Table_Retrieve_PBSelect_Order();

		newOne.Name = Name;

		newOne.Asc = Asc;

		return newOne;
	}
}
}