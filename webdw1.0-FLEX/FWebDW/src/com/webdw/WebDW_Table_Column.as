package com.webdw
{
// 'table内嵌的column属性定义
public class WebDW_Table_Column {
	public var type :String = ""; // '数据类型

	public var  update :String = ""; // '是否可以更新yes/no

	public var  updatewhereclause :String = ""; // '是否是更新时的where条件yes/no

	public var  key :String = ""; // '是否是主键

	public var  Name :String = ""; // '字段名

	public var  dbname :String = ""; // '数据库字段名

	public var  values :String = ""; // '附加值，用来存储编辑风格时的信息

	public var  validations :String = ""; // '编辑的校验字符串

	public function Clone():WebDW_Table_Column {

		 var newOne:WebDW_Table_Column = new WebDW_Table_Column();

		newOne.type = type; // '数据类型

		newOne.update = update; // '是否可以更新yes/no

		newOne.updatewhereclause = updatewhereclause; // '是否是更新时的where条件yes/no

		newOne.key = key; // '是否是主键

		newOne.Name = Name; // '字段名

		newOne.dbname = dbname; // '数据库字段名

		newOne.values = values; // '附加值，用来存储编辑风格时的信息

		newOne.validations = validations; // '编辑的校验字符串

		return newOne;
	}
}
}