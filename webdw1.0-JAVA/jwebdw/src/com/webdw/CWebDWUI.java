package com.webdw;

import com.webdw.ui.*;
import java.util.*;
import javax.swing.*;

//Rem -------------------------------------------------
//Rem WebDW用户界面解析器，VB功能类
//Rem 主要功能：将一个字符串描述转换成相应的图形界面
//Rem 图形界面和字符串的描述，两者在逻辑上是完全等价的
//Rem 这个功能类似于浏览器的图形解释器,把HTML语言翻译成一个图形化界面
//Rem 其中包括文本,图形等多种元素(一开始可能只有文本)
//Rem 通过一定的技术把界面和数据库可以关联起来
//Rem 第一版本的界面解析器，格式严格按照PB7的数据窗口字符串格式来获取
//Rem 所有以DW_开头的方法，提供和PB Datawindow控件类似的功能和调用接口
//Rem @CopyRight Mr.Liu Junsong 2008-2009
//Rem @版权所有 刘峻松 2008-2009
//Rem E_mail : liujunsong@yahoo.com.cn
//Rem -------------------------------------------------

public class CWebDWUI extends Golbal {
	public void ReadMe() {
		System.out.println("WebDW用户界面解析器接口");
		System.out.println(JWebDWInfo);
	}

	public String errString = "";// As String '返回的错误信息字符串

	public CWebDWTransaction sqlca = null;// '事务支持？SQL访问支持对象

	// '其次是私有变量的定义
	CWebDWUI_ParentDW parentClassDW = null;// '定义一个超类

	private MyInt iret = new MyInt(0);// '通用的返回值定义

	private int iret2 = 0;

	/**
	 * 构造函数
	 * 
	 */
	public CWebDWUI() {
		parentClassDW = new CWebDWUI_ParentDW();// '设置父类窗口，绝大部分功能由父类完成

		parentClassDW.childDW = new CWebDWUI_ChildDW();// '在父类数据窗口上，创建一个子数据窗口
		parentClassDW.childDW.SetParentDW(this);// '告诉父类的子数据窗口，谁是他爸爸

		sqlca = parentClassDW.sqlca;

	}

	// '功能描述：设置g_webdw的值
	// '输入：gg_webdw
	// '输出：g_webdw
	public void SetWebDW() {
		parentClassDW.SetLocalWebDW();
	}

	// '得到父类的错误
	private void getParentErr(int iret) {
		if (iret == -1) {
			errString = parentClassDW.errString;
		}
	}

	// '功能描述：读取g_webdw的值
	// '输入:g_webdw
	// '输出:gg_webdw
	public void GetWebDW() {
		parentClassDW.GetLocalWebDW();
	}

	// 'update()或者commit()成功以后调用的方法，更新界面数据，避免retrieve
	public int After_Update() {
		return parentClassDW.AfterUpdate();
	}

	// '调用子数据窗口的刷新方法
	public int DrawChildDW() {
		int i = parentClassDW.DrawChildDW();
		getParentErr(i);
		return i;
	}

	// '绘制DW的方法,begId代表开始绘制的一行.begId>0
	// 'targetControls: 目标控件的集合 输入
	// 'targetPict: 要绘制的目标图片框 输入
	public int DrawDW() {
		iret2 = parentClassDW.DrawDW();
		getParentErr(iret2);
		return iret2;
	}

	// '添加命令
	public String DW_AddCommand(MyInt iret) {
		String sret = parentClassDW.DW_AddCommand(iret);
		errString = parentClassDW.errString;
		return sret;
	}

	public String DW_BeginTransaction(MyInt iret) {
		String sret = parentClassDW.DW_BeginTransaction(iret);
		errString = parentClassDW.errString;
		return sret;
	}

	// '提交事务
	public String DW_Commit(MyInt iret) {
		String sret = parentClassDW.DW_Commit(iret);
		errString = parentClassDW.errString;
		return sret;
	}

	// '根据给定dw语法进行转换，看看能否测试功能
	// '此方法属于语法层次，不影响界面的显示
	// '如果转换失败，返回-1
	public int DW_Create(String dwSyntax) {

		iret2 = parentClassDW.DW_Create(dwSyntax);
		if (iret2 == -1) {
			errString = parentClassDW.errString;
		}

		return iret2;
	}

	// '功能描述：删除当前行
	// '返回0 成功
	// '返回-1 发生错误
	public int DW_DeleteRow(int rowid) {
		iret2 = parentClassDW.DW_DeleteRow(rowid);
		getParentErr(iret2);
		return iret2;
	}

	public int DW_GetAutoCommit() {
		return parentClassDW.DW_GetAutoCommit();
	}

	// '检索数据窗口中的当前数据
	// 'rowid 行号
	// 'colid 列号
	// '返回值：当前值
	public String DW_GetItemString(int rowid, int colid) {
		return parentClassDW.DW_GetItemString(rowid, colid);
	}

	// '功能描述：得到当前行
	// '要得到当前行，需要传入当前所在对象的ID号
	public int DW_GetRow() {
		iret2 = parentClassDW.DW_GetRow();
		getParentErr(iret2);
		return iret2;
	}

	// '得到最近要提交到后台的更新数据库的命令集合
	// '多条命令之间用chr(13)chr(10)来分隔
	// '目前仅支持单表的更新操作所需要的SQL命令
	public String DW_GetSQLPreview(MyInt iret1) {
		String strsql = parentClassDW.DW_GetSQLPreview(iret1);
		getParentErr(iret1.intvalue);
		return strsql;
	}

	// '得到检索用的select语句，和数据库相关
	public String DW_GetSQLSelect() {
		return parentClassDW.DW_GetSQLSelect();
	}

	// '得到数据窗口的语法表示
	// '返回iret 0 代表成功 -1 代表失败
	public String DW_GetSyntax(MyInt iret) {
		return parentClassDW.DW_GetSyntax(iret);
	}

	// '在数据窗口中插入一条记录，返回这条记录的当前行号，如果出错，返回-1
	// 'rowid代表要插入的行号，如果为0代表在最后插入
	public int DW_InsertRow(int rowid) {
		iret2 = parentClassDW.DW_InsertRow(rowid);
		getParentErr(iret2);
		return iret2;
	}

	public int DW_Retrieve() {
		iret2 = parentClassDW.DW_Retrieve();
		getParentErr(iret2);
		return iret2;
	}

	// '数据窗口的检索功能，等价功能dw.Retrieve()
	// '前提条件是已经设置了datawindow对象
	// 'args是检索调用的参数，各个参数之间用TAB键分割
	// '20090116对参数进行修改，targetControls和targetPict不再需要外部传入
	public int DW_Retrieve(String args) {
		iret2 = parentClassDW.DW_Retrieve(args);
		getParentErr(iret2);
		return iret2;
	}

	// '回滚事务'iret是返回参数0 正常 -1 失败
	public String DW_Rollback(MyInt iret) {
		String sret = parentClassDW.DW_Rollback(iret);
		errString = parentClassDW.errString;
		return sret;
	}

	// '得到当前DataWindow内的记录总数
	// '返回-1代表失败
	// '正常情况返回值>=0
	public int DW_RowCount() {
		iret2 = parentClassDW.DW_RowCount();
		getParentErr(iret2);
		return iret2;
	}

	public int DW_SetAutoCommit(int flag) {
		return parentClassDW.DW_SetAutoCommit(flag);
	}

	// '设置dataobject对象，dataobject对象用一个字符串来描述
	// '这是一个新实现的方法，这个方法中不再传递vscroll,hscroll这些对象
	// '而是通过其名称来进行访问
	public int DW_SetDataObject(List targetControlsArg, MyJPanel targetPictArg,
			MyJPanel parentPict, String sUIDesc, boolean childflag,
			boolean createflag) {
		iret2 = parentClassDW.DW_SetDataObject(targetControlsArg,
				targetPictArg, parentPict, sUIDesc, childflag, createflag);
		getParentErr(iret2);
		return iret2;
	}

	// '设置dataobject对象，dataobject对象用一个字符串来描述
	// '这是一个新实现的方法，这个方法中不再传递vscroll,hscroll这些对象
	// '而是通过其名称来进行访问
	public int DW_SetDataObjectByName(List targetControlsArg,
			MyJPanel targetPictArg, MyJPanel parentPict, String sdwName,
			boolean childflag, boolean createflag) {
		iret2 = parentClassDW.DW_SetDataObjectByName(targetControlsArg,
				targetPictArg, parentPict, sdwName, childflag, createflag);
		getParentErr(iret2);
		return iret2;
	}

	// '设置网格线的颜色0-15有效
	public int DW_SetGridLineColor(int color) {
		iret2 = parentClassDW.DW_SetGridLineColor(color);
		errString = parentClassDW.errString;
		return iret2;
	}

	// '设置数据,只能设置PrimaryBuffer的数据
	public int DW_SetItem(int rowid, int colid, String sdata) {
		iret2 = parentClassDW.DW_SetItem(rowid, colid, sdata);
		getParentErr(iret2);
		return iret2;
	}

	// '设置当前行
	public int DW_SetRow(int rowid) {
		iret2 = parentClassDW.DW_SetRow(rowid);
		getParentErr(iret2);
		return iret2;
	}

	// '设置检索用的Select语句
	public int DW_SetSQLSelect(String strsql) {
		return parentClassDW.DW_SetSQLSelect(strsql);
	}

	// '根据给定的SQL语句，以及对应的数据窗口类型
	// '设置到g_webdw中去
	// '从而再转换，得到一个对应的数据窗口对象出来。
	// 'iret返回值，0 正常 -1 失败
	// '错误信息存放在errstring中
	// '这个方法是一个Select语句的小型解析器
	public String DW_SyntaxFromSQL(String strsql, String stype, MyInt iret) {
		String sret = parentClassDW.DW_SyntaxFromSQL(strsql, stype, iret);
		if (iret.intvalue == -1) {
			errString = parentClassDW.errString;
		}
		return sret;
	}

	// '执行Dw的Update方法,更新数据
	// '返回0代表调用成功
	// '返回-1代表调用发生错误
	// '将targetControls,targetPict都从参数中去掉
	public int DW_Update() {
		iret2 = parentClassDW.DW_Update();
		getParentErr(iret2);
		return iret2;
	}

	// '20090217日提供的Eval方法
	// '如果某方法实际上是由下属的类来实际执行的，那么直接转发到这个类来执行
	// '实际的转发代码在parentclassdw里面运行
	// '此处仅仅是直接调用一下就可以了
	public String Eval(String command, MyInt iret) {
		String sret = parentClassDW.Eval(command, iret);
		if (iret.intvalue == -1) {
			errString = parentClassDW.errString;
		}
		return sret;
	}

	// '功能描述：得到当前界面的网格线竖线描述
	// '数据来源:local_webdw
	// '数据输出：将所有竖线的X值组合起来，用逗号分割，返回
	// '仅用于Grid风格和Tabular风格的数据窗口，其他风格的返回""
	public String GetGridLineInfo() {
		return parentClassDW.GetGridLineInfo();
	}

	// '根据给定的当前控件的名字，判断当前所在列的序号
	// '返回-1代表失败，>=0代表序号
	public int GetRowIdColumnId(String currentControlName, MyInt rowid,
			MyInt colid) {
		iret2 = parentClassDW
				.GetRowIdColumnId(currentControlName, rowid, colid);
		getParentErr(iret2);
		return iret2;
	}

	// '设置列定义字符串
	public int SetColumnDefString(String sColDefString) {
		return parentClassDW.SetColumnDefString(sColDefString);
	}

	// '利用给定的数据，来初始化数据存储
	// 'targetControls 控件的集合
	// 'pictTarget 要绘图的控件
	// 'indata 重新设置的数据
	// 'datastate 可选项,数据的状态,默认为"normal"
	public int SetData(String indata) {
		iret2 = parentClassDW.SetData(indata);
		getParentErr(iret2);
		return iret2;
	}

	// '利用给定的数据，来初始化数据存储
	// 'targetControls 控件的集合
	// 'pictTarget 要绘图的控件
	// 'indata 重新设置的数据
	// 'datastate 可选项,数据的状态,默认为"normal"
	public int SetData(String indata, String datastate) {
		iret2 = parentClassDW.SetData(indata, datastate);
		getParentErr(iret2);
		return iret2;
	}

	// '重新设置修改网格表示的字段列宽度
	// 'newX 新的字段X值
	// 'oldX 旧的字段X值
	// '修改local_webdw的数值
	public int SetGridWidth(int newx, int oldx) {
		// TODO:在后台增加设置网格宽度的功能
		// return parentClassDW.SetGridWidth(newx, oldx);
		return 0;
	}

	public String GetOutputData(){
		String s1= parentClassDW.webdwData.GetColumnString();
		s1=s1+"\r\n"+parentClassDW.webdwData.GetAllData();
		return s1;
	}
}
