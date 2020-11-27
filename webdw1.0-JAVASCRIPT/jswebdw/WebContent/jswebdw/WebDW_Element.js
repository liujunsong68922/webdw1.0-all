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