// '数据列对选择框的支持定义，这是Column的一个属性
class WebDW_Column_CheckBox {
	constructor(){

	this.text = ""; // '显示在界面上的字符串

	this.on = ""; // '选中时的数据值

	this.off = ""; // '未选中时的数据值

	this.scale1 = ""; // '含义不明,scale是vb保留字，改名

	this.threed = ""; // '3D显示风格
	}
	Clone() {

		var newOne = new WebDW_Column_CheckBox();

		newOne.text = this.text; // '显示在界面上的字符串

		newOne.on = this.on; // '选中时的数据值

		newOne.off = this.off; // '未选中时的数据值

		newOne.scale1 = this.scale1; // '含义不明,scale是vb保留字，改名

		newOne.threed = this.threed; // '3D显示风格
		return newOne;
	}
}

// '数据列对下拉选择框的支持定义，这是Column的一个属性
class WebDW_Column_ComboBox {
	constructor(){
		
	this.limit = 0; // '限制，含义不明

	this.allowedit = ""; // '是否可以编辑 yes /no

	this.case1 = ""; // '大小写,改名为case1

	this.useasborder = ""; // '是否显示箭头 yes/no
	}
	Clone() {

		var newOne = new WebDW_Column_ComboBox();

		newOne.limit = this.limit; // '限制，含义不明

		newOne.allowedit = this.allowedit; // '是否可以编辑 yes /no

		newOne.case1 = this.case1; // '大小写,改名为case1

		newOne.useasborder = this.useasborder; // '是否显示箭头 yes/no
		return newOne;
	}
}

// '数据列对下拉数据窗口的支持，这是Column的一个属性
// '20090125日大年三十日添加
class WebDW_Column_DDDW {
	constructor(){
	
	
	this.Name = ""; // '数据窗口的名字，未来用这个字符串来检索此数据窗口

	this.DisplayColumn = ""; // '显示列的名字，这一列在子数据窗口中

	this.DataColumn = ""; // '数据列的名字，用这一列来设置原数据窗口

	this.PercentWidth = 0; // '百分比表示的显示宽度

	this.Lines = 0;

	this.limit = 0;

	this.allowedit = "";

	this.useasborder = "";

	this.case1 = "";

	this.vscrollbar = ""; // '是否显示竖滚动条
	}
	Clone() {

		var newOne = new WebDW_Column_DDDW();

		newOne.Name =this.Name; // '数据窗口的名字，未来用这个字符串来检索此数据窗口

		newOne.DisplayColumn = this.DisplayColumn; // '显示列的名字，这一列在子数据窗口中

		newOne.DataColumn = this.DataColumn; // '数据列的名字，用这一列来设置原数据窗口

		newOne.PercentWidth = this.PercentWidth; // '百分比表示的显示宽度

		newOne.Lines = this.Lines;

		newOne.limit = this.limit;

		newOne.allowedit = this.allowedit;

		newOne.useasborder = this.useasborder;

		newOne.case1 = this.case1;

		newOne.vscrollbar = this.vscrollbar; // '是否显示竖滚动条

		return newOne;
	}
}

// '数据列对单选按钮组的支持定义，这是Column的一个属性
class WebDW_Column_RadioButtons {
	constructor(){
		
	this.Columns = 0; // '单选纽显示列的数量
	}
	Clone() {

		var newOne = new WebDW_Column_RadioButtons();

		newOne.Columns = this.Columns;

		return newOne;
	}
}