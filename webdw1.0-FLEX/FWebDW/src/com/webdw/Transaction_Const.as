package com.webdw
{


public class Transaction_Const {
	public var Trans_Oper_Query :String = ""; // '查询操作 //1

	public var Trans_Oper_Exec :String = ""; // '执行操作 //2

	public var Trans_Oper_TableList :String = ""; // '数据表列表操作 //3

	public var Trans_Oper_ColumnList :String = ""; // '数据列列表操作 //4

	// '下面是事务相关方法
	public var Trans_BeginTrans :String = ""; // '启动一个事务

	public var Trans_AddCommand :String = ""; // '增加命令

	public var Trans_Commit :String = ""; // '提交事务

	public var Trans_Rollback :String = ""; // '回滚（取消）事务

	// '下面是获得数据窗口定义的方法
	public var Trans_GetDWDefine :String = ""; // '从后台检索数据窗口定义文件

	}
}