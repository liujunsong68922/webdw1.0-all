//<script src="jswebdw/WebDWSyntax_Cloneable.js"></script>
//<script src="jswebdw/WebDW_Column_Element.js"></script>
//<script src="jswebdw/WebDW_Column.js"></script>
//<script src="jswebdw/WebDW_Element.js"></script>
//<script src="jswebdw/WebDW_Table.js"></script>
//<script src="jswebdw/WebDWSyntax.js"></script>

/**
 * This class is designed to support field clone function. It is designed only
 * used in WebDWSyntax class and its subclass.
 * Author: Mr.Liu Junsong
 * E_main:liujunsong@aliyun.com
 * Date:2018/12/1
 */
class WebDWSyntax_Cloneable{
	/**
	 * empty constructor
	 */
	constructor(){
		this._testonlyvariable ="THIS IS THE TEST VALUE ONLY.";
	}
	
	/**
	 * give the field name ,return field value (maybe undefined) through call
	 * the eval function. This is truly a dangerous command.
	 */
	getFieldValue(field){
		var retValue = eval("this."+field);

		return retValue;
	}
	/**
	 * set the value to the field,if the field donot exist,then js will create
	 * it automatically.
	 */
	setFieldValue(field,value){
		var valuetype = typeof(value);
		
		switch (valuetype)
		{
			case "number": eval("this."+field+" = "+value );break;
			case "boolean": eval("this."+field+" = "+value);break;
			// Warning: the string value cannot contains "'" at some time, or it
			// will fail.There are some problem in this method
			// so this function only can be used in limit condition.
			// NEVER USE IT in large scale.
			case "string": eval("this."+field+" = '"+value+"'" );break;
			case "object": break;
			case "function": break;
			case "undefined": break;
		}
	}
	

	/**
	 * clone field's value ,according the fields array,which contains all field
	 * name srcObj: the source object tarObj: the target object fields: the
	 * field name array
	 */
	F_Clone(srcObj,tarObj,fields){
		for(var i=0;i<fields.length;i++){
			// get the field value from source object
			var fieldValue = srcObj.getFieldValue(fields[i]);
			// clone this value to target object
			tarObj.setFieldValue(fields[i],fieldValue);
			
		}
		
	}
}

//'数据列对选择框的支持定义，这是Column的一个属性
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

/**
 * This is the new ES6 type's WebDWSyntax using Class keyword ,instant of
 * function keyword. Author: Mr.Liu Junsong E_main:liujunsong@aliyun.com
 */

class WebDW_Column extends WebDWSyntax_Cloneable {
	constructor(){
		// call super's constructor
		super();
		
		this.band = "";
	
		this.id = 0;
	
		this.alignment = 0;
	
		this.tabsequence = 0;
	
		this.border = 0;
	
		this.color = 0;
	
		this.x = 0;
	
		this.y = 0;
	
		this.height = 0;
	
		this.width = 0;
	
		this.format = "";
	
		this.Name = "";
	
		this.tag = "";
	
		this.edit_limit = 0;
	
		this.edit_case = "";
	
		this.edit_focusrectangle = "";
	
		this.edit_autoselect = "";
	
		this.edit_autohscroll = "";
	
		this.font = new WebDW_Font(); // '重新定义Font结构并使用这个结构来使用
	
		this.background_mode = 0;
	
		this.background_color = 0;
	
		this. radiobuttons = new WebDW_Column_RadioButtons(); // '单选按钮的支持定义20090124
	
		this. checkbox = new WebDW_Column_CheckBox(); // '选择按钮的支持定义20090124
	
		this. combobox = new WebDW_Column_ComboBox(); // '下拉列表框的支持定义20090124
	
		this. dddw = new WebDW_Column_DDDW(); // '下拉数据窗口的支持定义20090125

}
	Clone() {

		var newOne = new WebDW_Column();
		var fields = new Array("band","id","alignment","tabsequence","border",
				"color","x","y","height","width",
				"format","Name","tag",
				"edit_limit","edit_case","edit_focusrectangle","edit_autoselect","edit_autohscroll",
				"background_mode","background_color");
		
		// call super function to clone field value.
		super.F_Clone(this,newOne,fields);

		// the following is object,not only value.
		// call the object's deep clone function.
		newOne.font = this.font.Clone(); // '重新定义Font结构并使用这个结构来使用

		newOne.radiobuttons = this.radiobuttons.Clone(); // '单选按钮的支持定义20090124

		newOne.checkbox = this.checkbox.Clone(); // '选择按钮的支持定义20090124

		newOne.combobox = this.combobox.Clone(); // '下拉列表框的支持定义20090124

		newOne.dddw = this.dddw.Clone(); // '下拉数据窗口的支持定义20090125

		return newOne;
	}
}

/**
 * WebDW语法定义的Java描述 从VB代码移植而来
 * 
 * @author admin
 * 
 */

class WebDW_DataWindow extends WebDWSyntax_Cloneable {
	constructor(){
		// call super.
		super();
	
	this.unit = "";
	this.timer_interval = "";
	this.color = 0;
	this.processiong = "";
	this.HTMLDW = "";
	this.print_documentname = "";
	this.print_orientation = 0;
	this.print_margin_left = 0;
	this.print_margin_right = 0;
	this.print_margin_top = 0;
	this.print_margin_bottom = 0;
	this.print_paper_source = 0;
	this.print_paper_size = 0;
	this.print_prompt = "";
	this.print_buttons = "";
	this.print_preview_buttons = "";
	this.grid_lines = "";
	}
	// Clone function
	Clone() {
		var newOne = new WebDW_DataWindow();
		var fields = new Array(	"unit",	"timer_interval","color","processiong","HTMLDW",
				"print_documentname","print_orientation","print_margin_left","print_margin_right",
				"print_margin_top",	"print_margin_bottom","print_paper_source","print_paper_size",
				"print_prompt","print_buttons","print_preview_buttons","grid_lines");
		
		// call super function to clone field value.
		super.F_Clone(this,newOne,fields);
		
		return newOne;
	}
}

// 'detail属性定义
class WebDW_Detail {
	// constructor
	constructor(){
		this. height = 0;
		this. color = 0;
	}
	
	// Clone function
	Clone() {
		var newOne = new WebDW_Detail();
		newOne.height = this.height;
		newOne.color = this.color;

		return newOne;
	}
}


class WebDW_Font extends WebDWSyntax_Cloneable {
	// Constructor
	constructor(){
		// call super.
		super();
		
	this.face = "";
	this.height = 0;
	this.weight = 0;
	this.family = 0;
	this.pitch = 0;
	this.charset = 0;
	this.italic = 0;
	this.underline = 0;
	this.strikethrough = 0;
	}
	
	// Clone function
	Clone() {
		var newOne = new WebDW_Font();
		var fields = new Array("face","height","weight","family","pitch",
		"charset","italic","underline","strikethrough");
		
		// call super function to clone field value.
		super.F_Clone(this,newOne,fields);

		return newOne;
	}
}

// 'footer属性定义
class WebDW_Footer {
	constructor(){
	this. height = 0;
	this. color = 0;
}
	Clone() {
		var newOne = new WebDW_Footer();

		newOne.height = this.height;
		newOne.color = this.color;

		return newOne;
	}
}

// 'header属性定义
class WebDW_Header {
	constructor(){

		this. height = 0;
		this. color = 0;
	}
	
	Clone() {
		var newOne = new WebDW_Header();

		newOne.height = this.height;
		newOne.color = this.color;

		return newOne;
	}
}

// '线条的数据定义类型
class WebDW_Line extends WebDWSyntax_Cloneable{
	constructor(){
		super();
		
		this.band = "";
		this.x1 = 0;
		this.y1 = 0;
		this.x2 = 0;
		this.y2 = 0;
		this.Name = "";
		this.pen_style = "";
		this.pen_width = "";
		this.pen_color = "";
		this.background_mode = "";
		this.background_color = "";
	}
	
	Clone() {
		var newOne = new WebDW_Line();
		var fields = new Array("band","x1","y1","x2","y2",
				"Name","pen_style","pen_width","pen_color","background_mode",
				"background_color");
				
		// call super function to clone field value.
		super.F_Clone(this,newOne,fields);

		return newOne;
	}
}

class WebDW_Summary {
	constructor(){
		
	this.height = 0;
	this.color = 0;

	}
	
	Clone() {
		var newOne = new WebDW_Summary();

		newOne.height = this.height;
		newOne.color = this.color;

		return newOne;
	}
}

// 'text的支持属性定义
// '从配置文件中读入到这个结构中
// '再用这个结构来绘图显示
// '属性名称与属性文件中定义的相同，不与控件本身一致
// '属性名全用小写
class WebDW_Text extends WebDWSyntax_Cloneable{
	constructor(){
		super();
		this.band = "";
		this.alignment = 0;
		this.text = "";
		this.border = 0;
		this.color = 0;
		this.x = 0;
		this.y = 0;
		this.height = 0;
		this.width = 0;
		this.Name = "";
		this.font = new WebDW_Font(); // '新定义的font属性
		this.background_mode = 0;
		this.background_color = 0;

	}
	// Clone function
	Clone() {

		var newOne = new WebDW_Text();
		var fields = new Array("band","alignment","text","border","color",
				"x","y","height","width","Name",
				"background_mode","background_color");

		// call super function to clone field value.
		super.F_Clone(this,newOne,fields);
		
		newOne.font = this.font.Clone(); // '新定义的font属性

		return newOne;
	}
}

//'table属性定义
class WebDW_Table {
	
	constructor(){
		
		this.Columns = new Array(101);// WebDW_Table_Column[101]; // '最多100列
	
		this.retrieve = new WebDW_Table_Retrieve(); // '重新定义retrieve参数，定义成一个结构
	
		this.update = "";
		this.updatewhere = "";
		this.updatekeyinplace = "";

		for (var i = 0; i < 101; i++) {
			this.Columns[i] = new WebDW_Table_Column();
		}
	}


	 Clone() {

		var newOne = new WebDW_Table();

		for (var i = 0; i < 101; i++) {
			newOne.Columns[i] = this.Columns[i].Clone();
		}

		newOne.retrieve = this.retrieve.Clone();
		newOne.update = this.update;
		newOne.updatewhere = this.thupdatewhere;
		newOne.updatekeyinplace = this.updatekeyinplace;

		return newOne;
	}
}

// 'table内嵌的column属性定义
class WebDW_Table_Column {
	// Constructor
	constructor(){
		this.type = ""; // '数据类型
		this.update = ""; // '是否可以更新yes/no
		this.updatewhereclause = ""; // '是否是更新时的where条件yes/no
		this.key = ""; // '是否是主键
		this.Name = ""; // '字段名
		this.dbname = ""; // '数据库字段名
		this.values = ""; // '附加值，用来存储编辑风格时的信息
		this.validations = ""; // '编辑的校验字符串
}
	// clone function
	Clone() {

		var newOne = new WebDW_Table_Column();
		newOne.type = this.type; // '数据类型
		newOne.update = this.update; // '是否可以更新yes/no
		newOne.updatewhereclause = this.updatewhereclause; // '是否是更新时的where条件yes/no
		newOne.key = this.key; // '是否是主键
		newOne.Name = this.Name; // '字段名
		newOne.dbname = this.dbname; // '数据库字段名
		newOne.values = this.values; // '附加值，用来存储编辑风格时的信息
		newOne.validations = this.validations; // '编辑的校验字符串

		return newOne;
	}
}

class WebDW_Table_Retrieve {
	// Constructor
	constructor(){
		this. pbselect = new WebDW_Table_Retrive_PBSelect();
	}
	// Clone function
	Clone() {

		var newOne = new WebDW_Table_Retrieve();

		newOne.pbselect = this.pbselect.Clone();

		return newOne;
	}
}

// '表的连接定义
class WebDW_Table_Retrieve_PBSelect_Join {
	// Constructor
	constructor(){
		this. join_left = "";
		this. join_op = "";
		this. join_right = "";
	}

	// Clone function
	  Clone() {

		var newOne = new WebDW_Table_Retrieve_PBSelect_Join();

		newOne.join_left = this.join_left;
		newOne.join_op = this.join_op;
		newOne.join_right = this.join_right;

		return newOne;
	}
}

// '数据表检索的OrderBy条件定义
class WebDW_Table_Retrieve_PBSelect_Order {
	// Constructor
	constructor(){
		this. Name = "";// As this.'排序的列名称
		this. Asc = "";// As this.'是否是升序yes/no
	}
	
	// Clone function
	Clone() {

		var newOne = new WebDW_Table_Retrieve_PBSelect_Order();

		newOne.Name = this.Name;
		newOne.Asc = this.Asc;

		return newOne;
	}
}

// '表检索的where条件定义
class WebDW_Table_Retrieve_PBSelect_Where {
	// Constructor
	constructor(){
		this.exp1 = "";
		this.op = "";
		this.exp2 = "";
		this.logic = "";
	}
	
	// Clone function
	Clone() {

		var newOne = new WebDW_Table_Retrieve_PBSelect_Where();

		newOne.exp1 = this.exp1;
		newOne.op = this.op;
		newOne.exp2 = this.texp2;
		newOne.logic = this.logic;

		return newOne;
	}
}

// 'table的retrieve的pbselect元素属性定义
// '这一部分可能会根据需要来进行后续增加
// '会随着对于DW文件格式的理解深入而扩展
class WebDW_Table_Retrive_PBSelect {
	// Constructor
	constructor(){
	this.version = "";

	this.table = new Array(11);// String[11]; // '表名，最多容许10个表

	this.column = new Array(11);// String[101]; // '列名，最多容许100个列

	this. join = new Array(11);// WebDW_Table_Retrieve_PBSelect_Join[11];//
								// '表连接定义，最多10个连接

	this. where = new Array(11);// WebDW_Table_Retrieve_PBSelect_Where[11]; //
								// 'where条件定义，最多10个where条件

	this. order = new Array(11);// WebDW_Table_Retrieve_PBSelect_Order[11]; //
								// 'order
	// 条件设定,最多10个
		var i;
		for (i = 0; i < 11; i++) {
			this.table[i] = "";
		}
		for (i = 0; i < 101; i++) {
			this.column[i] = "";
		}
		for (i = 0; i < 11; i++) {
			this.join[i] = new WebDW_Table_Retrieve_PBSelect_Join();
		}
		for (i = 0; i < 11; i++) {
			this.where[i] = new WebDW_Table_Retrieve_PBSelect_Where();
		}
		for (i = 0; i < 11; i++) {
			this.order[i] = new WebDW_Table_Retrieve_PBSelect_Order();
		}


	}

	// Clone function
	 Clone() {
		var newOne = new WebDW_Table_Retrive_PBSelect();
		var i;
		for (i = 0; i < 11; i++) {
			newOne.table[i] = this.table[i];
		}
		for (i = 0; i < 101; i++) {
			newOne.column[i] = this.column[i];
		}
		for (i = 0; i < 11; i++) {
			newOne.join[i] = this.join[i].Clone();
		}
		for (i = 0; i < 11; i++) {
			newOne.where[i] = this.where[i].Clone();
		}
		for (i = 0; i < 11; i++) {
			newOne.order[i] = this.order[i].Clone();
		}

		return newOne;
	}
}

class WebDWSyntax {
	
	constructor(){
		this.ReadMe="WebDW的用户界面文件表示，采用和PB7.0兼容的界面格式定义";
		
		this. datawindow = new WebDW_DataWindow();
	
		this. header = new WebDW_Header();
	
		this. summary = new WebDW_Summary();
	
		this. footer = new WebDW_Footer();
	
		this. detail = new WebDW_Detail();
	
		this. table = new WebDW_Table();
	
		this. text = new Array(101);// WebDW_Text[101];
	
		this. column = new Array(101);// WebDW_Column[101];
	
		this. lineinfo = new Array(101);// WebDW_Line[101];
	
		this. column_dddw_syntax = new Array(101);// new String[101];
	
		this. column_dddw_data = new Array(101);// new String[101];
	
		this. SelectSQL = "";

	/**
	 * 初始化的构造函数
	 * 
	 */

		var i = 0;
		for (i = 0; i < 101; i++) {
			this.text[i] = new WebDW_Text();
		}
		for (i = 0; i < 101; i++) {
			this.column[i] = new WebDW_Column();
		}
		for (i = 0; i < 101; i++) {
			this.lineinfo[i] = new WebDW_Line();
		}
		for (i = 0; i < 101; i++) {
			this.column_dddw_syntax[i] = "";
		}
		for (i = 0; i < 101; i++) {
			this.column_dddw_data[i] = "";
		}
	}
	
	// Clone function
	Clone() {
		var newOne = new WebDWSyntax();

		newOne.datawindow = this.datawindow.Clone();

		newOne.header = this.header.Clone();

		newOne.summary = this.summary.Clone();

		newOne.footer = this.footer.Clone();

		newOne.detail = this.detail.Clone();

		newOne.table = this.table.Clone();
		
		newOne.SelectSQL = this.SelectSQL;
		
		var i = 0;
		for (i = 0; i < 101; i++) {
			newOne.text[i] = this.text[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.column[i] = this.column[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.lineinfo[i] = this.lineinfo[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.column_dddw_syntax[i] = this.column_dddw_syntax[i];
		}
		for (i = 0; i < 101; i++) {
			newOne.column_dddw_data[i] = this.column_dddw_data[i];
		}
		return newOne;
	}
	
	/**
	 * Warning:Test only,Donot Use This Function in Program!!!
	 * 
	 * @return
	 */
	getColumnNumber(){
		for(var i=1;i<=100;i++){
			if (this.column[i].Name.length()==0){
				return i-1;
			}
		}
		return 100;
	}
}
