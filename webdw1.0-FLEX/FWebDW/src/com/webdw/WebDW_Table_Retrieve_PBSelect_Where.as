package com.webdw
{
// '表检索的where条件定义
public class WebDW_Table_Retrieve_PBSelect_Where {
	public var exp1 :String = "";

	public var op :String = "";

	public var exp2 :String = "";

	public var logic :String = "";

	public function WebDW_Table_Retrieve_PBSelect_Where() {

	}

	public  function Clone(): WebDW_Table_Retrieve_PBSelect_Where{

		var newOne :WebDW_Table_Retrieve_PBSelect_Where = new WebDW_Table_Retrieve_PBSelect_Where();

		newOne.exp1 = exp1;

		newOne.op = op;

		newOne.exp2 = exp2;

		newOne.logic = logic;

		return newOne;
	}
}

}