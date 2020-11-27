package com.webdw;

/**
 * WebDW语法定义的Java描述 从VB代码移植而来
 * 
 * @author admin
 * 
 */

class WebDW_DataWindow {
	String unit = "";

	String timer_interval = "";

	int color = 0;

	String processiong = "";

	String HTMLDW = "";

	String print_documentname = "";

	int print_orientation = 0;

	int print_margin_left = 0;

	int print_margin_right = 0;

	int print_margin_top = 0;

	int print_margin_bottom = 0;

	int print_paper_source = 0;

	int print_paper_size = 0;

	String print_prompt = "";

	String print_buttons = "";

	String print_preview_buttons = "";

	String grid_lines = "";

	public WebDW_DataWindow Clone() {
		WebDW_DataWindow newOne = new WebDW_DataWindow();
		newOne.unit = this.unit;
		newOne.timer_interval = this.timer_interval;
		newOne.color = this.color;
		newOne.processiong = processiong;
		newOne.HTMLDW = HTMLDW;
		newOne.print_documentname = print_documentname;
		newOne.print_orientation = print_orientation;
		newOne.print_margin_left = print_margin_left;
		newOne.print_margin_right = print_margin_right;
		newOne.print_margin_top = print_margin_top;
		newOne.print_margin_bottom = print_margin_bottom;
		newOne.print_paper_source = print_paper_source;
		newOne.print_paper_size = print_paper_size;
		newOne.print_prompt = print_prompt;
		newOne.print_buttons = print_buttons;
		newOne.print_preview_buttons = print_preview_buttons;
		newOne.grid_lines = grid_lines;

		return newOne;
	}
}

// 'header属性定义
class WebDW_Header {
	int height = 0;

	int color = 0;

	public WebDW_Header Clone() {
		WebDW_Header newOne = new WebDW_Header();

		newOne.height = height;

		newOne.color = color;

		return newOne;
	}
}

// 'summary属性定义
class WebDW_Summary {
	int height = 0;

	int color = 0;

	public WebDW_Summary Clone() {

		WebDW_Summary newOne = new WebDW_Summary();

		newOne.height = height;

		newOne.color = color;

		return newOne;
	}
}

// 'footer属性定义
class WebDW_Footer {
	int height = 0;

	int color = 0;

	public WebDW_Footer Clone() {
		WebDW_Footer newOne = new WebDW_Footer();

		newOne.height = height;

		newOne.color = color;

		return newOne;
	}
}

// 'detail属性定义
class WebDW_Detail {
	int height = 0;

	int color = 0;

	public WebDW_Detail Clone() {
		WebDW_Detail newOne = new WebDW_Detail();

		newOne.height = height;

		newOne.color = color;

		return newOne;
	}
}

// 'table内嵌的column属性定义
class WebDW_Table_Column {
	String type = ""; // '数据类型

	String update = ""; // '是否可以更新yes/no

	String updatewhereclause = ""; // '是否是更新时的where条件yes/no

	String key = ""; // '是否是主键

	String Name = ""; // '字段名

	String dbname = ""; // '数据库字段名

	String values = ""; // '附加值，用来存储编辑风格时的信息

	String validations = ""; // '编辑的校验字符串

	public WebDW_Table_Column Clone() {

		WebDW_Table_Column newOne = new WebDW_Table_Column();

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

// '表的连接定义
class WebDW_Table_Retrieve_PBSelect_Join {
	String join_left = "";

	String join_op = "";

	String join_right = "";

	public WebDW_Table_Retrieve_PBSelect_Join() {

	}

	public WebDW_Table_Retrieve_PBSelect_Join Clone() {

		WebDW_Table_Retrieve_PBSelect_Join newOne = new WebDW_Table_Retrieve_PBSelect_Join();

		newOne.join_left = join_left;

		newOne.join_op = join_op;

		newOne.join_right = join_right;

		return newOne;
	}
}

// '表检索的where条件定义
class WebDW_Table_Retrieve_PBSelect_Where {
	String exp1 = "";

	String op = "";

	String exp2 = "";

	String logic = "";

	public WebDW_Table_Retrieve_PBSelect_Where() {

	}

	public WebDW_Table_Retrieve_PBSelect_Where Clone() {

		WebDW_Table_Retrieve_PBSelect_Where newOne = new WebDW_Table_Retrieve_PBSelect_Where();

		newOne.exp1 = exp1;

		newOne.op = op;

		newOne.exp2 = exp2;

		newOne.logic = logic;

		return newOne;
	}
}

// '数据表检索的OrderBy条件定义
class WebDW_Table_Retrieve_PBSelect_Order {
	String Name = "";// As String '排序的列名称

	String Asc = "";// As String '是否是升序yes/no

	public WebDW_Table_Retrieve_PBSelect_Order Clone() {

		WebDW_Table_Retrieve_PBSelect_Order newOne = new WebDW_Table_Retrieve_PBSelect_Order();

		newOne.Name = Name;

		newOne.Asc = Asc;

		return newOne;
	}
}

// 'table的retrieve的pbselect元素属性定义
// '这一部分可能会根据需要来进行后续增加
// '会随着对于DW文件格式的理解深入而扩展
class WebDW_Table_Retrive_PBSelect {
	String version = "";

	String table[] = new String[11]; // '表名，最多容许10个表

	String column[] = new String[101]; // '列名，最多容许100个列

	WebDW_Table_Retrieve_PBSelect_Join join[] = new WebDW_Table_Retrieve_PBSelect_Join[11];// '表连接定义，最多10个连接

	WebDW_Table_Retrieve_PBSelect_Where where[] = new WebDW_Table_Retrieve_PBSelect_Where[11]; // 'where条件定义，最多10个where条件

	WebDW_Table_Retrieve_PBSelect_Order order[] = new WebDW_Table_Retrieve_PBSelect_Order[11]; // 'order

	// 条件设定,最多10个

	/*
	 * 构造函数，初始化
	 */
	public WebDW_Table_Retrive_PBSelect() {
		int i;
		for (i = 0; i < 11; i++) {
			table[i] = "";
		}
		for (i = 0; i < 101; i++) {
			column[i] = "";
		}
		for (i = 0; i < 11; i++) {
			join[i] = new WebDW_Table_Retrieve_PBSelect_Join();
		}
		for (i = 0; i < 11; i++) {
			where[i] = new WebDW_Table_Retrieve_PBSelect_Where();
		}
		for (i = 0; i < 11; i++) {
			order[i] = new WebDW_Table_Retrieve_PBSelect_Order();
		}

	}

	public WebDW_Table_Retrive_PBSelect Clone() {
		WebDW_Table_Retrive_PBSelect newOne = new WebDW_Table_Retrive_PBSelect();
		int i;
		for (i = 0; i < 11; i++) {
			newOne.table[i] = table[i];
		}
		for (i = 0; i < 101; i++) {
			newOne.column[i] = column[i];
		}
		for (i = 0; i < 11; i++) {
			newOne.join[i] = join[i].Clone();
		}
		for (i = 0; i < 11; i++) {
			newOne.where[i] = where[i].Clone();
		}
		for (i = 0; i < 11; i++) {
			newOne.order[i] = order[i].Clone();
		}

		return newOne;
	}
}

// 'table.retrieve元素定义，其中只有一个pbselect元素
class WebDW_Table_Retrieve {
	WebDW_Table_Retrive_PBSelect pbselect = new WebDW_Table_Retrive_PBSelect();

	public WebDW_Table_Retrieve Clone() {

		WebDW_Table_Retrieve newOne = new WebDW_Table_Retrieve();

		newOne.pbselect = pbselect.Clone();

		return newOne;
	}
}

// 'table属性定义
class WebDW_Table {
	WebDW_Table_Column Columns[] = new WebDW_Table_Column[101]; // '最多100列

	WebDW_Table_Retrieve retrieve = new WebDW_Table_Retrieve(); // '重新定义retrieve参数，定义成一个结构

	String update = "";

	String updatewhere = "";

	String updatekeyinplace = "";

	/**
	 * 构造函数,初始化数据
	 * 
	 */
	public WebDW_Table() {
		for (int i = 0; i < 101; i++) {
			Columns[i] = new WebDW_Table_Column();
		}
	}

	public WebDW_Table Clone() {

		WebDW_Table newOne = new WebDW_Table();

		for (int i = 0; i < 101; i++) {
			newOne.Columns[i] = Columns[i].Clone();
		}

		newOne.retrieve = retrieve.Clone();

		newOne.update = update;

		newOne.updatewhere = updatewhere;

		newOne.updatekeyinplace = updatekeyinplace;

		return newOne;
	}
}

// 'WebDW用到的内部Font定义，
// '这个Font属性对text和column有效
// '20081225日增加

class WebDW_Font {
	String face = "";

	int height = 0;

	int weight = 0;

	int family = 0;

	int pitch = 0;

	int charset = 0;

	int italic = 0;

	int underline = 0;

	int strikethrough = 0;

	public WebDW_Font Clone() {

		WebDW_Font newOne = new WebDW_Font();

		newOne.face = face;

		newOne.height = height;

		newOne.weight = weight;

		newOne.family = family;

		newOne.pitch = pitch;

		newOne.charset = charset;

		newOne.italic = italic;

		newOne.underline = underline;

		newOne.strikethrough = strikethrough;

		return newOne;
	}
}

// '数据列对单选按钮组的支持定义，这是Column的一个属性
class WebDW_Column_RadioButtons {
	int Columns = 0; // '单选纽显示列的数量

	public WebDW_Column_RadioButtons Clone() {

		WebDW_Column_RadioButtons newOne = new WebDW_Column_RadioButtons();

		newOne.Columns = Columns;

		return newOne;
	}
}

// '数据列对选择框的支持定义，这是Column的一个属性
class WebDW_Column_CheckBox {
	String text = ""; // '显示在界面上的字符串

	String on = ""; // '选中时的数据值

	String off = ""; // '未选中时的数据值

	String scale1 = ""; // '含义不明,scale是vb保留字，改名

	String threed = ""; // '3D显示风格

	public WebDW_Column_CheckBox Clone() {

		WebDW_Column_CheckBox newOne = new WebDW_Column_CheckBox();

		newOne.text = text; // '显示在界面上的字符串

		newOne.on = on; // '选中时的数据值

		newOne.off = off; // '未选中时的数据值

		newOne.scale1 = scale1; // '含义不明,scale是vb保留字，改名

		newOne.threed = threed; // '3D显示风格
		return newOne;
	}
}

// '数据列对下拉选择框的支持定义，这是Column的一个属性
class WebDW_Column_ComboBox {
	int limit = 0; // '限制，含义不明

	String allowedit = ""; // '是否可以编辑 yes /no

	String case1 = ""; // '大小写,改名为case1

	String useasborder = ""; // '是否显示箭头 yes/no

	public WebDW_Column_ComboBox Clone() {

		WebDW_Column_ComboBox newOne = new WebDW_Column_ComboBox();

		newOne.limit = limit; // '限制，含义不明

		newOne.allowedit = allowedit; // '是否可以编辑 yes /no

		newOne.case1 = case1; // '大小写,改名为case1

		newOne.useasborder = useasborder; // '是否显示箭头 yes/no
		return newOne;
	}
}

// '数据列对下拉数据窗口的支持，这是Column的一个属性
// '20090125日大年三十日添加
class WebDW_Column_DDDW {
	String Name = ""; // '数据窗口的名字，未来用这个字符串来检索此数据窗口

	String DisplayColumn = ""; // '显示列的名字，这一列在子数据窗口中

	String DataColumn = ""; // '数据列的名字，用这一列来设置原数据窗口

	int PercentWidth = 0; // '百分比表示的显示宽度

	int Lines = 0;

	int limit = 0;

	String allowedit = "";

	String useasborder = "";

	String case1 = "";

	String vscrollbar = ""; // '是否显示竖滚动条

	public WebDW_Column_DDDW Clone() {

		WebDW_Column_DDDW newOne = new WebDW_Column_DDDW();

		newOne.Name = Name; // '数据窗口的名字，未来用这个字符串来检索此数据窗口

		newOne.DisplayColumn = DisplayColumn; // '显示列的名字，这一列在子数据窗口中

		newOne.DataColumn = DataColumn; // '数据列的名字，用这一列来设置原数据窗口

		newOne.PercentWidth = PercentWidth; // '百分比表示的显示宽度

		newOne.Lines = Lines;

		newOne.limit = limit;

		newOne.allowedit = allowedit;

		newOne.useasborder = useasborder;

		newOne.case1 = case1;

		newOne.vscrollbar = vscrollbar; // '是否显示竖滚动条

		return newOne;
	}
}

// '
// 'column的支持属性定义，
// '从配置文件中读入到这个结构中
// '再用这个结构来绘图显示
// '属性名称与属性文件中定义的相同,不与控件本身一致
// '属性名全用小写
class WebDW_Column {
	String band = "";

	int id = 0;

	int alignment = 0;

	int tabsequence = 0;

	int border = 0;

	int color = 0;

	int x = 0;

	int y = 0;

	int height = 0;

	int width = 0;

	String format = "";

	String Name = "";

	String tag = "";

	int edit_limit = 0;

	String edit_case = "";

	String edit_focusrectangle = "";

	String edit_autoselect = "";

	String edit_autohscroll = "";

	WebDW_Font font = new WebDW_Font(); // '重新定义Font结构并使用这个结构来使用

	int background_mode = 0;

	int background_color = 0;

	WebDW_Column_RadioButtons radiobuttons = new WebDW_Column_RadioButtons(); // '单选按钮的支持定义20090124

	WebDW_Column_CheckBox checkbox = new WebDW_Column_CheckBox(); // '选择按钮的支持定义20090124

	WebDW_Column_ComboBox combobox = new WebDW_Column_ComboBox(); // '下拉列表框的支持定义20090124

	WebDW_Column_DDDW dddw = new WebDW_Column_DDDW(); // '下拉数据窗口的支持定义20090125

	public WebDW_Column Clone() {

		WebDW_Column newOne = new WebDW_Column();
		newOne.band = band;

		newOne.id = id;

		newOne.alignment = alignment;

		newOne.tabsequence = tabsequence;

		newOne.border = border;

		newOne.color = color;

		newOne.x = x;

		newOne.y = y;

		newOne.height = height;

		newOne.width = width;

		newOne.format = format;

		newOne.Name = Name;

		newOne.tag = tag;

		newOne.edit_limit = edit_limit;

		newOne.edit_case = edit_case;

		newOne.edit_focusrectangle = edit_focusrectangle;

		newOne.edit_autoselect = edit_autoselect;

		newOne.edit_autohscroll = edit_autohscroll;

		newOne.font = font.Clone(); // '重新定义Font结构并使用这个结构来使用

		newOne.background_mode = background_mode;

		newOne.background_color = background_color;

		newOne.radiobuttons = radiobuttons.Clone(); // '单选按钮的支持定义20090124

		newOne.checkbox = checkbox.Clone(); // '选择按钮的支持定义20090124

		newOne.combobox = combobox.Clone(); // '下拉列表框的支持定义20090124

		newOne.dddw = dddw.Clone(); // '下拉数据窗口的支持定义20090125

		return newOne;
	}
}

// 'text的支持属性定义
// '从配置文件中读入到这个结构中
// '再用这个结构来绘图显示
// '属性名称与属性文件中定义的相同，不与控件本身一致
// '属性名全用小写
class WebDW_Text {
	String band = "";

	int alignment = 0;

	String text = "";

	int border = 0;

	int color = 0;

	int x = 0;

	int y = 0;

	int height = 0;

	int width = 0;

	String Name = "";

	WebDW_Font font = new WebDW_Font(); // '新定义的font属性

	int background_mode = 0;

	int background_color = 0;

	public WebDW_Text Clone() {

		WebDW_Text newOne = new WebDW_Text();

		newOne.band = band;

		newOne.alignment = alignment;

		newOne.text = text;

		newOne.border = border;

		newOne.color = color;

		newOne.x = x;

		newOne.y = y;

		newOne.height = height;

		newOne.width = width;

		newOne.Name = Name;

		newOne.font = font.Clone(); // '新定义的font属性

		newOne.background_mode = background_mode;

		newOne.background_color = background_color;

		return newOne;
	}
}

// '线条的数据定义类型
class WebDW_Line {
	String band = "";

	int x1 = 0;

	int y1 = 0;

	int x2 = 0;

	int y2 = 0;

	String Name = "";

	String pen_style = "";

	String pen_width = "";

	String pen_color = "";

	String background_mode = "";

	String background_color = "";

	public WebDW_Line Clone() {
		WebDW_Line newOne = new WebDW_Line();

		newOne.band = band;

		newOne.x1 = x1;

		newOne.y1 = y1;

		newOne.x2 = x2;

		newOne.y2 = y2;

		newOne.Name = Name;

		newOne.pen_style = pen_style;

		newOne.pen_width = pen_width;

		newOne.pen_color = pen_color;

		newOne.background_mode = background_mode;

		newOne.background_color = background_color;

		return newOne;
	}
}

public class WebDWSyntax {
	public void ReadMe() {
		System.out.println("WebDW的用户界面文件表示，采用和PB7.0兼容的界面格式定义");
		System.out.println(Golbal.JWebDWInfo);
	}

	WebDW_DataWindow datawindow = new WebDW_DataWindow();

	WebDW_Header header = new WebDW_Header();

	WebDW_Summary summary = new WebDW_Summary();

	WebDW_Footer footer = new WebDW_Footer();

	WebDW_Detail detail = new WebDW_Detail();

	WebDW_Table table = new WebDW_Table();

	WebDW_Text text[] = new WebDW_Text[101];

	WebDW_Column column[] = new WebDW_Column[101];

	WebDW_Line lineinfo[] = new WebDW_Line[101];

	String column_dddw_syntax[] = new String[101];

	String column_dddw_data[] = new String[101];

	String SelectSQL = "";

	/**
	 * 初始化的构造函数
	 * 
	 */
	public WebDWSyntax() {
		int i = 0;
		for (i = 0; i < 101; i++) {
			text[i] = new WebDW_Text();
		}
		for (i = 0; i < 101; i++) {
			column[i] = new WebDW_Column();
		}
		for (i = 0; i < 101; i++) {
			lineinfo[i] = new WebDW_Line();
		}
		for (i = 0; i < 101; i++) {
			column_dddw_syntax[i] = "";
		}
		for (i = 0; i < 101; i++) {
			column_dddw_data[i] = "";
		}
	}

	public WebDWSyntax Clone() {
		WebDWSyntax newOne = new WebDWSyntax();

		newOne.datawindow = datawindow.Clone();

		newOne.header = header.Clone();

		newOne.summary = summary.Clone();

		newOne.footer = footer.Clone();

		newOne.detail = detail.Clone();

		newOne.table = table.Clone();

		int i = 0;
		for (i = 0; i < 101; i++) {
			newOne.text[i] = text[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.column[i] = column[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.lineinfo[i] = lineinfo[i].Clone();
		}
		for (i = 0; i < 101; i++) {
			newOne.column_dddw_syntax[i] = column_dddw_syntax[i];
		}
		for (i = 0; i < 101; i++) {
			newOne.column_dddw_data[i] = column_dddw_data[i];
		}
		return newOne;
	}
	
	/**
	 * Warning:Test only,Donot Use This Function in Program!!!
	 * @return
	 */
	public int getColumnNumber(){
		for(int i=1;i<=100;i++){
			if (column[i].Name.length()==0){
				return i-1;
			}
		}
		return 100;
	}
}
