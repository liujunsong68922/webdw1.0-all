package com.webdw
{
// '表的连接定义
public class WebDW_Table_Retrieve_PBSelect_Join {
	public var join_left :String = "";

	public var join_op :String = "";

	public var join_right :String = "";

	public function WebDW_Table_Retrieve_PBSelect_Join() {

	}

	public function Clone():WebDW_Table_Retrieve_PBSelect_Join {

		var newOne:WebDW_Table_Retrieve_PBSelect_Join = new WebDW_Table_Retrieve_PBSelect_Join();

		newOne.join_left = join_left;

		newOne.join_op = join_op;

		newOne.join_right = join_right;

		return newOne;
	}
}

}