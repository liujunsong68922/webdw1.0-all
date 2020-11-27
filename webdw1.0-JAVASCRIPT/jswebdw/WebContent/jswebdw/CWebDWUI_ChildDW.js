class CWebDWUI_ChildDW extends Golbal {
	// constructor function
	constructor() {
		super();
		
		this.ReadMe = "子数据窗口类";
		this.parentClassDW = new CWebDWUI_ParentDW();
		this.webdw = this.parentClassDW.webdw;
		this.webdwData = this.parentClassDW.webdwData;
		
		this.errString = "";// '返回的错误信息字符串
	}
	


	// '------------下面的定义是界面上的动态元素对应的事件处理器定义
	// Private WithEvents myTextBox As TextBox 'myTextBox是一个虚拟的文本框，用来定义文本框事件响应
	// '------------界面动态元素定义完毕

	// parentControlName = "";// '父数据窗口的控件名称

	// dataColumnName = "";// '数据列名称

	parentControlName( sname){
		parentClassDW.parentControlName=sname;
	}
	dataColumnName( sname){
		parentClassDW.dataColumnName =sname;
	}
	// private CWebDWUI parentDW = null;// '设置父数据窗口的句柄



	// '功能描述：设置g_webdw的值
	// '输入：gg_webdw
	// '输出：g_webdw
	SetWebDW() {
		parentClassDW.SetLocalWebDW();
	}

	// '功能描述：读取g_webdw的值
	// '输入:g_webdw
	// '输出:gg_webdw
	GetWebDW() {
		parentClassDW.GetLocalWebDW();
	}

	// '画文本框的方法
	// 'targetControls 目标控件集合
	// 'pictTarget 要绘制的图片框
	// 'lineNum 行号，从1开始，文本框只在detail区域绘制，不考虑其他区域
	// 'leftpos 左偏移量，对象向左偏移leftpos<0
// private int DrawColumn(List targetControls, JPanel targetPict,
// double convertRate, int lineNum, int leftPos) {
// return parentClassDW.DrawColumn(lineNum, leftPos);
// }

	// '画文本框的方法
	// 'targetControls 目标控件集合
	// 'pictTarget 要绘制的图片框
	// 'lineNum 行号，从1开始，文本框只在detail区域绘制，不考虑其他区域
	// 'leftpos 左偏移量，对象向左偏移leftpos<0
// private int DrawColumn(List targetControls, JPanel targetPict,
// double convertRate, int lineNum) {
// return parentClassDW.DrawColumn(lineNum, 0);
// }

	// '绘制DW的方法,begId代表开始绘制的一行.begId>0
	// 'targetControls: 目标控件的集合 输入
	// 'targetPict: 要绘制的目标图片框 输入
	DrawDW() {
		return parentClassDW.DrawDW();
	}

// private int drawImageOnly() {
// return parentClassDW.DrawDW_ImageOnly();
// }

	// '画标签的方法
	// 'targetControls 目标窗体或者用户控件的控件集合
	// 'pictTarget 目标图片框
	// 'lineNum 行号0代表绘制表头，其他代表具体的行号
	// 'leftpos 所有元素的左偏移量 leftpos <=0
	// '图形数据来源: g_webdw
// private int DrawLabel(List targetControls, JPanel targetPict,
// double convertRate, int lineNum, int leftPos) {
// return parentClassDW.DrawLabel(lineNum, leftPos);
// }

	// '画标签的方法
	// 'targetControls 目标窗体或者用户控件的控件集合
	// 'pictTarget 目标图片框
	// 'lineNum 行号0代表绘制表头，其他代表具体的行号
	// 'leftpos 所有元素的左偏移量 leftpos <=0
	// '图形数据来源: g_webdw
// private int DrawLabel(List targetControls, JPanel targetPict,
// double convertRate, int lineNum) {
// return parentClassDW.DrawLabel(lineNum, 0);
// }

	// '在界面上画线的方法
	// '通过这个方法支持在界面上进行画线
	// 'leftpos 左偏移量 leftpos<=0
// DrawLine(List targetControls, JPanel targetPict,
// double convertRate, int lineNum, int leftPos) {
// return parentClassDW.DrawLine(lineNum, leftPos);
// }

	// '在界面上画线的方法
	// '通过这个方法支持在界面上进行画线
	// 'leftpos 左偏移量 leftpos<=0
// DrawLine(List targetControls, JPanel targetPict,
// double convertRate, int lineNum) {
// return parentClassDW.DrawLine(lineNum, 0);
// }

	// '功能描述：得到当前行
	// '要得到当前行，需要传入当前所在对象的ID号
// DW_GetRow() {
// return parentClassDW.DW_GetRow();
// }

	// '得到最近要提交到后台的更新数据库的命令集合
	// '多条命令之间用chr(13)chr(10)来分隔
	// '目前仅支持单表的更新操作所需要的SQL命令
	DW_GetSQLPreview( iret) {

		return parentClassDW.DW_GetSQLPreview(iret);
	}

	// '在数据窗口中插入一条记录，返回这条记录的当前行号，如果出错，返回-1
	// 'rowid代表要插入的行号，如果为0代表在最后插入
	DW_InsertRow( rowid) {
		return parentClassDW.DW_InsertRow(rowid);
	}

	// '数据窗口的检索功能，等价功能dw.Retrieve()
	// '前提条件是已经设置了datawindow对象
	// 'args是检索调用的参数，各个参数之间用TAB键分割
	// '20090116对参数进行修改，targetControls和targetPict不再需要外部传入
	DW_Retrieve( args) {
		return parentClassDW.DW_Retrieve(args);
	}

	// '数据窗口的检索功能，等价功能dw.Retrieve()
	// '前提条件是已经设置了datawindow对象
	// 'args是检索调用的参数，各个参数之间用TAB键分割
	// '20090116对参数进行修改，targetControls和targetPict不再需要外部传入
	DW_Retrieve() {
		return parentClassDW.DW_Retrieve();
	}

	// '得到当前DataWindow内的记录总数
	// '返回-1代表失败
	// '正常情况返回值>=0
	DW_RowCount() {

		return parentClassDW.DW_RowCount();
	}

	// '设置dataobject对象，dataobject对象用一个字符串来描述
	// '这是一个新实现的方法，这个方法中不再传递vscroll,hscroll这些对象
	// '而是通过其名称来进行访问
	DW_SetDataObject( targetControlsArg,  targetPictArg, parentPict,
			 sUIDesc,  childFlag, createflag) {

		return parentClassDW.DW_SetDataObject(targetControlsArg, targetPictArg,
				parentPict,sUIDesc, childFlag,createflag);
	}

	// '设置dataobject对象，dataobject对象用一个字符串来描述
	// '这是一个新实现的方法，这个方法中不再传递vscroll,hscroll这些对象
	// '而是通过其名称来进行访问
	DW_SetDataObjectByName( targetControlsArg,
			 targetPictArg,  parentPict, sdwName,
			 childFlag, createflag) {
		var iret = 0;
		iret = parentClassDW.DW_SetDataObjectByName(targetControlsArg,
				targetPictArg,parentPict, sdwName,childFlag,createflag);
		errString = parentClassDW.errString;
		return iret;
	}

	// '设置当前行
	DW_SetRow( rowid) {
		return parentClassDW.DW_SetRow(rowid);
	}

	// '执行Dw的Update方法,更新数据
	// '返回0代表调用成功
	// '返回-1代表调用发生错误
	// '将targetControls,targetPict都从参数中去掉
	DW_Update() {

		return parentClassDW.DW_Update();
	}

	GetItemString( rowid, colid) {
		return webdwData.GetItemString(rowid, colid);
	}

	// '得到父类的错误
	getParentErr( iret) {
		if (iret == -1) {
			errString = parentClassDW.errString;
		}
		return 0;
	}

	// '根据给定的当前控件的名字，判断当前所在列的序号
	// '返回-1代表失败，>=0代表序号
	GetRowIdColumnId( currentControlName, rowid, colid) {
		return parentClassDW.GetRowIdColumnId(currentControlName, rowid, colid);
	}

	// '利用给定的数据，来初始化数据存储
	// 'targetControls 控件的集合
	// 'pictTarget 要绘图的控件
	// 'indata 重新设置的数据
	// 'datastate 可选项,数据的状态,默认为"normal"
	SetData( indata,  datastate) {
		return parentClassDW.SetData(indata, datastate);
	}

	// '利用给定的数据，来初始化数据存储
	// 'targetControls 控件的集合
	// 'pictTarget 要绘图的控件
	// 'indata 重新设置的数据
	// 'datastate 可选项,数据的状态,默认为"normal"
	SetData( indata) {
		return parentClassDW.SetData(indata);
	}

	// '根据给定的columnname，计算返回的列编号(1 based)
	// 'Public Function GetColumnIdByColumnName(colname As String) As Long
	// ' GetColumnIdByColumnName =
	// parentClassDW.GetColumnIdByColumnName(colname)
	// 'End Function
	//
	// '设置数据,只能设置PrimaryBuffer的数据
	SetItemString( rowid,  colid,  sdata) {
		return webdwData.SetItemString(rowid, colid, sdata);
	}

	// '设置父数据窗口的句柄
	SetParentDW( pui) {
		return this.parentClassDW.SetParentDW(pui);
	}
	
	CloseDW(){
		return parentClassDW.CloseDW();
	}
}
