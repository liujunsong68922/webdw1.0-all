package com.webdw;
//Rem -------------------------------------------------
//Rem WebDW的数据窗口自动生成器
//Rem 这个类的设计目的是给出一个Select语句，自动填充local_webdw的数值
//Rem 这里面没有和后台数据库的交互，所需要的数据事先先提供过来
//Rem 根据生成的数据窗口的类型不同，分为多个不同的方法来实现
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @版权所有 刘峻松 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------
public class CWebDW_SyntaxFromSQL extends Golbal {
	public void ReadMe(){
		System.out.println("WebDW的数据窗口自动生成器");
		System.out.println(JWebDWInfo);
	}
	//'公用变量定义
	public String errString="";// As String      '错误信息存储字符串，输出字符串

	//'colDefString字符串的数据从外部直接传入
	public String colDefString="";// As String   '数据列存储字符串，格式为：第一行列列表，其他行：列的定义信息

	private String columnlist=""; //As String    'select语句的列列表
	private String  tablelist=""; // As String     'select语句的table列表
	private String  joinlist=""; // As String      'select语句的连接语句
	private String  wherelist=""; // As String     'select语句的where条件字句

	private int color_white = 16777215;

	private WebDWSyntax local_webdw =null;// 'local_webdw现在是一个局部变量了，而不是全局变量了

//	'功能描述：设置local_webdw的值
//	'输入：glocal_webdw
//	'输出：local_webdw
	public void SetLocalWebDW(){
	    local_webdw = Golbal.GG_webdw.Clone();
	}

//	'功能描述：读取local_webdw的值
//	'输入:local_webdw
//	'输出:glocal_webdw
	public void GetLocalWebDW(){
	   Golbal.GG_webdw = local_webdw.Clone();
	}

//	'根据给定的SQL语句，以及对应的数据窗口类型
//	'设置到local_webdw中去
//	'从而再转换，得到一个对应的数据窗口对象出来。
//	'iret返回值，0 正常 -1 失败
//	'错误信息存放在errstring中
//	'这个方法是一个Select语句的小型解析器
	public String SyntaxFromSQL(String strsql ,String stype ,MyInt iret){
		iret.intvalue = -1;
		errString ="SyntaxFromSQL方法尚未移植完成!";
		return "";
	}



}
