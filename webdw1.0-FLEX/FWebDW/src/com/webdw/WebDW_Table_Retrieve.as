package com.webdw
{
// 'table.retrieve元素定义，其中只有一个pbselect元素
public class WebDW_Table_Retrieve {
	public var pbselect:WebDW_Table_Retrive_PBSelect = new WebDW_Table_Retrive_PBSelect();

	public function  Clone():WebDW_Table_Retrieve {

		var newOne:WebDW_Table_Retrieve = new WebDW_Table_Retrieve();

		newOne.pbselect = pbselect.Clone();

		return newOne;
	}
}
}